using SimpleIterativeSolvers
using Base.Test
include("getDivGrad.jl")

println("=== Testing Upper/Lower Tri solvers ===")
A = sprandn(100,100,.1) + speye(100)
D = sparse(diagm(diag(A)))
L = tril(A,-1)
U = triu(A,1)
omega = .87
rhs = randn(100)

x1 = bwdTriSolveOmega(A,rhs,omega)
xgt = ((1./omega)*D + U)\ rhs
@test norm(x1-xgt)/norm(xgt) < 1e-15

x1 = fwdTriSolveOmega(A,rhs,omega)
xgt = ((1./omega)*D + L)\ rhs
@test norm(x1-xgt)/norm(xgt) < 1e-15

println("=== Testing SOR ===")
# small full system

# CG: test sparse Laplacian
A = getDivGrad(32,32,32)
rhs = randn(size(A,1))
tol = 1e-2

# tests with A being matrix
x1,flag1,relres1,iter1,resvec1       = sor(A,rhs,tol=tol,maxIter=100)
x2,flag2,relres2,iter2,resvec2       = sor(A,rhs,tol=tol,maxIter=100,omega=2/3,out=1)
x3,flag3,relres3,iter3,resvec3       = sor(A,rhs,tol=tol,maxIter=100,omega=1/2,out=1)

# test relative residuals
@test norm(A*x1-rhs)/norm(rhs) <= tol
@test norm(A*x2-rhs)/norm(rhs) <= tol

println("=== SOR : All tests passed. ====")