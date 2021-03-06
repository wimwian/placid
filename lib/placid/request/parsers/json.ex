defmodule Placid.Request.Parsers.JSON do
  @moduledoc false
  alias Plug.Conn

  @type conn    :: map
  @type headers :: map
  @type opts    :: Keyword

  @spec parse(conn, binary, binary, headers, opts) :: {:ok | :error, map | atom, conn}
  def parse(%Conn{} = conn, "application", "json", _headers, opts) do
    case Conn.read_body(conn, opts) do
      { :ok, body, conn } ->
        { :ok, body |> Poison.Parser.parse!, conn }
      { :more, _data, conn } ->
        { :error, :too_large, conn }
    end
  end
  def parse(conn, _type, _subtype, _headers, _opts) do
    { :next, conn }
  end
end