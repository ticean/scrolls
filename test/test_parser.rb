require_relative "test_helper"

class TestScrollsParser < Test::Unit::TestCase
  include Scrolls::Parser

  def test_parse_bool
    data = { test: true, exec: false }
    assert_equal "test=true exec=false", unparse(data)
    assert_equal data.inspect, parse(unparse(data)).inspect
  end

  def test_parse_numbers
    data = { elapsed: 12.00000, __time: 0 }
    assert_equal "elapsed=12.000 __time=0", unparse(data)
    assert_equal data.inspect, parse(unparse(data)).inspect
  end

  def test_parse_strings
    # Strings are all double quoted, with " or \ escaped
    data = { s: "echo 'hello' \"world\"" }
    assert_equal 's="echo \'hello\' \\"world\\""', unparse(data)
    assert_equal data.inspect, parse(unparse(data)).inspect

    data = { s: 'echo "hello"' }
    assert_equal "s='echo \"hello\"'", unparse(data)
    assert_equal data.inspect, parse(unparse(data)).inspect

    data = { s: "hello world" }
    assert_equal 's="hello world"', unparse(data)
    assert_equal data.inspect, parse(unparse(data)).inspect

    data = { s: "slasher \\" }
    assert_equal 's="slasher \\\\"', unparse(data)
    assert_equal data.inspect, parse(unparse(data)).inspect

    data = {s: "x=4,y=10" }
    assert_equal 's="x=4,y=10"', unparse(data)
    assert_equal data.inspect, parse(unparse(data)).inspect

    data = {s: "x=4, y=10" }
    assert_equal 's="x=4, y=10"', unparse(data)
    assert_equal data.inspect, parse(unparse(data)).inspect

    # simple value is unquoted
    data = { s: "hi" }
    assert_equal 's=hi', unparse(data)
    assert_equal data.inspect, parse(unparse(data)).inspect
  end

  def test_parse_constants
    data = { s1: :symbol, s2: Scrolls }
    assert_equal "s1=symbol s2=Scrolls", unparse(data)
  end

  def test_parse_epoch_time
    v = 1340118155
    data = { t: Time.at(v) }
    assert_equal "t=#{Time.at(v).strftime("%FT%H:%M:%S%z")}", unparse(data)
  end

  def test_parse_time_object
    now = Time.now
    data = { t: now }
    assert_equal "t=#{now.strftime("%FT%H:%M:%S%z")}", unparse(data)
  end

  def test_parse_nil
    data = { n: nil }
    assert_equal "n=nil", unparse(data)
  end
end
