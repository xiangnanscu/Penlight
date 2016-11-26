local input = require 'pl.input'
local seq = require 'pl.seq'
local asserteq = require('pl.test').asserteq
local utils = require 'pl.utils'
local stringio = require 'pl.stringio'
local unpack = utils.unpack

local L = utils.string_lambda
local S = seq.list
local C = seq.copy
local C2 = seq.copy2


asserteq (seq.sum(input.numbers '10 20 30 40 50'),150)
local x,y = unpack(C(input.numbers('10 20')))
assert (x == 10 and y == 20)


local test = {{1,10},{2,20},{3,30}}
asserteq(C2(ipairs{10,20,30}),test)
local res = C2(input.fields({1,2},',','1,10\n2,20\n3,30\n'))
asserteq(res,test)

asserteq(
  seq.copy(seq.filter(seq.list{10,20,5,15},seq.greater_than(10))),
  {20,15}
)

asserteq(
  seq.copy(seq.filter(seq.list{10,20,5,15},seq.less_than(15))),
  {10,5}
)

asserteq(
  #C(seq.filter(seq.list{10,20,5,10,15},seq.equal_to(10))),
  2
)

asserteq(
  #seq{'green','yellow','red','blue','red'}:filter(seq.equal_to'red'):copy(),
  2
)

asserteq(
  seq{'apple','orange','pineapple'}:filter(seq.matching'apple'):copy(),
  {'apple','pineapple'}
)

asserteq(
  C(seq.sort(seq.keys{[11] = true, [17]= true, [23] = true})),
  {11,17,23}
)

asserteq(
  C(seq.range(2,5)),
  {2,3,4,5}
)

asserteq(seq.reduce('-',{1,2,3,4,5}),-13)

asserteq(seq.count(S{10,20,30,40},L'|x| x > 20'), 2)

asserteq(C2(seq.zip({1,2,3},{10,20,30})),test)

asserteq(C(seq.splice({10,20},{30,40})),{10,20,30,40})

asserteq(C(seq.map(L'#_',{'one','tw'})),{3,2})

--for l1,l2 in seq.last{10,20,30} do print(l1,l2) end

asserteq(C2(seq.last{10,20,30}),{{20,10},{30,20}} )

asserteq(
  seq{10,20,30}:map(L'_+1'):copy(),
  {11,21,31}
)

asserteq(
  seq {1,2,3,4,5}:reduce ('*'), 120
)

-- test reduce with an initial value
asserteq(
  seq {1,2,3,4,5}:reduce ('+', 42), 57
)

-- test reduce with a short sequence
asserteq(
  seq {7}:reduce ('+'), 7
)

asserteq(
  seq {5}:reduce ('/', 40), 8
)

asserteq(
  seq {}:reduce ('+', 42), 42
)

asserteq(
  seq {}:reduce ('-'), nil
)

asserteq(
  seq{'one','two'}:upper():copy(),
  {'ONE','TWO'}
)

asserteq(
  seq{'one','two','three'}:skip(1):copy(),
  {'two','three'}
)

-- test skipping pass sequence
asserteq(
  seq{'one','two','three'}:skip(4):copy(),
  {}
)

asserteq(
  seq{7,8,9,10}:take(3):copy(),
  {7,8,9}
)

asserteq(
  seq{7,8,9,10}:take(6):copy(),
  {7,8,9,10}
)

asserteq(
  seq{7,8,9,10}:take(0):copy(),
  {}
)

asserteq(
  seq{7,8,9,10}:take(-1):copy(),
  {}
)

local l, u = 50, 100
local rand_seq = seq(seq.random(7, l, u))
asserteq(
  #rand_seq:filter(seq.less_than(u+1)):filter(seq.greater_than(l-1)):copy(),
  7
)

rand_seq = seq(seq.random(7, u))
asserteq(
  #rand_seq:filter(seq.less_than(u+1)):filter(seq.greater_than(0)):copy(),
  7
)

rand_seq = seq(seq.random(7))
asserteq(
  #rand_seq:filter(seq.less_than(1)):filter(seq.greater_than(0)):copy(),
  7
)

test = {354,215,696,501,786}
asserteq(
  C(seq.sort{seq(test):minmax()}),
  {215,786}
)

asserteq(
  seq(test):enum():copy_tuples(),
  {{1,354},{2,215},{3,696},{4,501},{5,786}}
)

asserteq(
  C(seq.unique(seq.list{1,2,3,2,1})),
  {1,2,3}
)


local f = stringio.open '1 2 3 4'

-- seq.lines may take format specifiers if using Lua 5.2, or a 5.2-compatible
-- file object like that returned by stringio.
asserteq(
    seq.lines(f,'*n'):copy(),
    {1,2,3,4}
)

-- the seq() constructor can now take an iterator which consists of two parts,
-- a function and an object - as returned e.g. by lfs.dir()

local function my_iter(T)
    local idx = 1
    return function(self)
        local res = self[idx]
        idx = idx + 1
        return res
    end,
    T
end

asserteq(
    seq(my_iter{10,20,30}):copy(),
    {10,20,30}
)

