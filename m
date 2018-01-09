Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bluehome.net ([96.66.250.149]:48963 "EHLO bluehome.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752903AbeAIXXy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Jan 2018 18:23:54 -0500
From: "Jason Self" <jason@bluehome.net>
Subject: [PATCH] carl9170: Change from _COMPILER_VERSION to CMAKE_C_COMPILER_VERSION
To: linux-wireless@vger.kernel.org
Message-Id: <1515539646.3509@bluehome.net> (sfid-20180110_002359_002325_9F05F5BA)
Date: Tue, 09 Jan 2018 15:14:06 -0800 (PST)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="bound1515539646"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.

--bound1515539646
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit

Patch is attached.

My problem started off this way:

git clone https://github.com/chunkeey/carl9170fw.git
cd carl9170fw
make -C toolchain
(time passes)
./autogen.sh
(accept all default answers)
./autogen.sh install
Installing firmware...Apply miniboot..../autogen.sh: line 35: 
tools/src/miniboot: No such file or directory

So somewhere in the process miniboot wasn't being built. I confirmed
that tools/src/miniboot really didn't exist, since dynamic linking
problems can confusingly cause the same error.

After some research it was determined that miniboot wasn't being
built because the conditional in tools/CMakeLists.txt for the
compiler version determined that the detected version of GCC was
less than version 44.

This machine is running GCC 7.2. gcc -dumpversion prints '7', which
is lower than 44. It also doesn't match the regular expression for
_COMPILER_VERSION, which expects at least two numbers separated
by a dot. _COMPILER_VERSION seems to be mangled in a way that is not
compatible with recent versions of GCC but there's no reason to
mangle it as far as I can tell because VERSION_GREATER can compare
dots but then that seems to make _COMPILER_VERSION unnecessary,
considering that CMAKE already sets CMAKE_C_COMPILER_VERSION.

So the idea of this patch is to change tools/CMakeLists.txt to use
CMAKE_C_COMPILER_VERSION instead of _COMPILER_VERSION, and compare
with 4.4 instead of 44 so that the conditional can be met and
miniboot can be built.

Signed-off-by: Jason Self <j@jxself.org>
---
 tools/CMakeLists.txt | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/tools/CMakeLists.txt b/tools/CMakeLists.txt
index 4d9862d..1c21fef 100644
--- a/tools/CMakeLists.txt
+++ b/tools/CMakeLists.txt
@@ -11,10 +11,8 @@ set(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/extra)
 include(GCCVersion)
 include("../config.cmake")
 
-_COMPILER_DUMPVERSION(_COMPILER_VERSION)
-
-if (("${_COMPILER_VERSION}" VERSION_GREATER 44) OR
-    ("${_COMPILER_VERSION}" VERSION_EQUAL 44))
+if (("${CMAKE_C_COMPILER_VERSION}" VERSION_GREATER 4.4) OR
+    ("${CMAKE_C_COMPILER_VERSION}" VERSION_EQUAL 4.4))
 
 	include_directories (../include/linux ../include/shared 
../include lib include)
 	add_subdirectory(lib)
-- 
1.9.1

--bound1515539646
Content-type: application/octet-stream; name="0001-carl9170-Change-from-_COMPILER_VERSION-to-CMAKE_C_CO.patch"
Content-Disposition: attachments; filename="0001-carl9170-Change-from-_COMPILER_VERSION-to-CMAKE_C_CO.patch"
Content-Transfer-Encoding: base64

RnJvbSBmZGJmNjk0YWRlMWMwMGM0N2IzYzU4MjNjNzVmYWIwNjA3ZDg1MzFmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBKYXNvbiBTZWxmIDxqQGp4c2VsZi5vcmc+CkRhdGU6IFR1ZSwg
OSBKYW4gMjAxOCAxNDoxMjoxOCAtMDgwMApTdWJqZWN0OiBbUEFUQ0hdIGNhcmw5MTcwOiBDaGFu
Z2UgZnJvbSBfQ09NUElMRVJfVkVSU0lPTiB0bwogQ01BS0VfQ19DT01QSUxFUl9WRVJTSU9OCgpN
eSBwcm9ibGVtIHN0YXJ0ZWQgb2ZmIHRoaXMgd2F5OgoKZ2l0IGNsb25lIGh0dHBzOi8vZ2l0aHVi
LmNvbS9jaHVua2VleS9jYXJsOTE3MGZ3LmdpdApjZCBjYXJsOTE3MGZ3Cm1ha2UgLUMgdG9vbGNo
YWluCih0aW1lIHBhc3NlcykKLi9hdXRvZ2VuLnNoCihhY2NlcHQgYWxsIGRlZmF1bHQgYW5zd2Vy
cykKLi9hdXRvZ2VuLnNoIGluc3RhbGwKSW5zdGFsbGluZyBmaXJtd2FyZS4uLkFwcGx5IG1pbmli
b290Li4uLi9hdXRvZ2VuLnNoOiBsaW5lIDM1OiB0b29scy9zcmMvbWluaWJvb3Q6IE5vIHN1Y2gg
ZmlsZSBvciBkaXJlY3RvcnkKClNvIHNvbWV3aGVyZSBpbiB0aGUgcHJvY2VzcyBtaW5pYm9vdCB3
YXNuJ3QgYmVpbmcgYnVpbHQuIEkgY29uZmlybWVkCnRoYXQgdG9vbHMvc3JjL21pbmlib290IHJl
YWxseSBkaWRuJ3QgZXhpc3QsIHNpbmNlIGR5bmFtaWMgbGlua2luZwpwcm9ibGVtcyBjYW4gY29u
ZnVzaW5nbHkgY2F1c2UgdGhlIHNhbWUgZXJyb3IuCgpBZnRlciBzb21lIHJlc2VhcmNoIGl0IHdh
cyBkZXRlcm1pbmVkIHRoYXQgbWluaWJvb3Qgd2Fzbid0IGJlaW5nCmJ1aWx0IGJlY2F1c2UgdGhl
IGNvbmRpdGlvbmFsIGluIHRvb2xzL0NNYWtlTGlzdHMudHh0IGZvciB0aGUKY29tcGlsZXIgdmVy
c2lvbiBkZXRlcm1pbmVkIHRoYXQgdGhlIGRldGVjdGVkIHZlcnNpb24gb2YgR0NDIHdhcwpsZXNz
IHRoYW4gdmVyc2lvbiA0NC4KClRoaXMgbWFjaGluZSBpcyBydW5uaW5nIEdDQyA3LjIuIGdjYyAt
ZHVtcHZlcnNpb24gcHJpbnRzICc3Jywgd2hpY2gKaXMgbG93ZXIgdGhhbiA0NC4gSXQgYWxzbyBk
b2Vzbid0IG1hdGNoIHRoZSByZWd1bGFyIGV4cHJlc3Npb24gZm9yCl9DT01QSUxFUl9WRVJTSU9O
LCB3aGljaCBleHBlY3RzIGF0IGxlYXN0IHR3byBudW1iZXJzIHNlcGFyYXRlZApieSBhIGRvdC4g
X0NPTVBJTEVSX1ZFUlNJT04gc2VlbXMgdG8gYmUgbWFuZ2xlZCBpbiBhIHdheSB0aGF0IGlzIG5v
dApjb21wYXRpYmxlIHdpdGggcmVjZW50IHZlcnNpb25zIG9mIEdDQyBidXQgdGhlcmUncyBubyBy
ZWFzb24gdG8KbWFuZ2xlIGl0IGFzIGZhciBhcyBJIGNhbiB0ZWxsIGJlY2F1c2UgVkVSU0lPTl9H
UkVBVEVSIGNhbiBjb21wYXJlCmRvdHMgYnV0IHRoZW4gdGhhdCBzZWVtcyB0byBtYWtlIF9DT01Q
SUxFUl9WRVJTSU9OIHVubmVjZXNzYXJ5LApjb25zaWRlcmluZyB0aGF0IENNQUtFIGFscmVhZHkg
c2V0cyBDTUFLRV9DX0NPTVBJTEVSX1ZFUlNJT04uCgpTbyB0aGUgaWRlYSBvZiB0aGlzIHBhdGNo
IGlzIHRvIGNoYW5nZSB0b29scy9DTWFrZUxpc3RzLnR4dCB0byB1c2UKQ01BS0VfQ19DT01QSUxF
Ul9WRVJTSU9OIGluc3RlYWQgb2YgX0NPTVBJTEVSX1ZFUlNJT04sIGFuZCBjb21wYXJlCndpdGgg
NC40IGluc3RlYWQgb2YgNDQgc28gdGhhdCB0aGUgY29uZGl0aW9uYWwgY2FuIGJlIG1ldCBhbmQK
bWluaWJvb3QgY2FuIGJlIGJ1aWx0LgoKU2lnbmVkLW9mZi1ieTogSmFzb24gU2VsZiA8akBqeHNl
bGYub3JnPgotLS0KIHRvb2xzL0NNYWtlTGlzdHMudHh0IHwgNiArKy0tLS0KIDEgZmlsZSBjaGFu
Z2VkLCAyIGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvdG9vbHMv
Q01ha2VMaXN0cy50eHQgYi90b29scy9DTWFrZUxpc3RzLnR4dAppbmRleCA0ZDk4NjJkLi4xYzIx
ZmVmIDEwMDY0NAotLS0gYS90b29scy9DTWFrZUxpc3RzLnR4dAorKysgYi90b29scy9DTWFrZUxp
c3RzLnR4dApAQCAtMTEsMTAgKzExLDggQEAgc2V0KENNQUtFX01PRFVMRV9QQVRIICR7Q01BS0Vf
U09VUkNFX0RJUn0vZXh0cmEpCiBpbmNsdWRlKEdDQ1ZlcnNpb24pCiBpbmNsdWRlKCIuLi9jb25m
aWcuY21ha2UiKQogCi1fQ09NUElMRVJfRFVNUFZFUlNJT04oX0NPTVBJTEVSX1ZFUlNJT04pCi0K
LWlmICgoIiR7X0NPTVBJTEVSX1ZFUlNJT059IiBWRVJTSU9OX0dSRUFURVIgNDQpIE9SCi0gICAg
KCIke19DT01QSUxFUl9WRVJTSU9OfSIgVkVSU0lPTl9FUVVBTCA0NCkpCitpZiAoKCIke0NNQUtF
X0NfQ09NUElMRVJfVkVSU0lPTn0iIFZFUlNJT05fR1JFQVRFUiA0LjQpIE9SCisgICAgKCIke0NN
QUtFX0NfQ09NUElMRVJfVkVSU0lPTn0iIFZFUlNJT05fRVFVQUwgNC40KSkKIAogCWluY2x1ZGVf
ZGlyZWN0b3JpZXMgKC4uL2luY2x1ZGUvbGludXggLi4vaW5jbHVkZS9zaGFyZWQgLi4vaW5jbHVk
ZSBsaWIgaW5jbHVkZSkKIAlhZGRfc3ViZGlyZWN0b3J5KGxpYikKLS0gCjEuOS4xCgo=

--bound1515539646--
