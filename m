Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:14733 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756883AbXG0Dux (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jul 2007 23:50:53 -0400
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C7D001.537B5191"
Subject: [PATCH 1/1] Add uCode/Driver compatibility version number to firmware file name
Date: Thu, 26 Jul 2007 20:50:51 -0700
Message-ID: <4220499A1B034C4FA93B547BA01E1FF001746253@orsmsx413.amr.corp.intel.com>
From: "Cahill, Ben M" <ben.m.cahill@intel.com>
To: <ipw3945-devel@lists.sourceforge.net>
Cc: <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.

------_=_NextPart_001_01C7D001.537B5191
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi all,

Attached please find patch that looks for (requires) new firmware
filenames for 3945 and 4965.

This is to enhance enforcement of driver/uCode compatibility, and allow
simpler coexistence of older/newer drivers and their associated uCode
files.  It also allows easy upgrades of uCode, without modification of
driver, *if* the uCode is compatible (which is likely).

FYI, here's the formula for our version numbers:

The uCode version numbers consist of the following, which are found in
the uCode tarball name, as well as the 1st dword of the firmware file
itself, with following bit offsets:

INTEL_MAJOR:  << 24, internal uCode version number
INTEL_MINOR:  << 16, internal uCode version number
LINUX_MAJOR:  <<  8, (new) indicates driver compatibility
LINUX_MINOR:  <<  0, incremented each time we (Linux team) change
anything

I'm sending the uCode files to Yi separately, so as not to burden
everybody's mailboxes.

Tip of the hat to Jeremy at Red Hat for his help.

-- Ben --


------_=_NextPart_001_01C7D001.537B5191
Content-Type: application/octet-stream;
	name="0001-Add-uCode-driver-compatibility-version-number-in-fir.patch"
Content-Transfer-Encoding: base64
Content-Description: 0001-Add-uCode-driver-compatibility-version-number-in-fir.patch
Content-Disposition: attachment;
	filename="0001-Add-uCode-driver-compatibility-version-number-in-fir.patch"

RnJvbSBkMGMzYTdhZmJkMTdmOTg0M2I5YTk1YWJhM2NhM2MwNzJhNGZkNGI4IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBCZW4gQ2FoaWxsIDxiZW4ubS5jYWhpbGxAaW50ZWwuY29tPgpE
YXRlOiBUaHUsIDI2IEp1bCAyMDA3IDIzOjE1OjAyIC0wNDAwClN1YmplY3Q6IFtQQVRDSF0gQWRk
IHVDb2RlL2RyaXZlciBjb21wYXRpYmlsaXR5IHZlcnNpb24gbnVtYmVyIGluIGZpcm13YXJlIGZp
bGVuYW1lLAogIHRvIGVuYWJsZSBjb21wYXRpYmlsaXR5IGVuZm9yY2VtZW50IGFuZCBjb2V4aXN0
ZW5jZSBvZiBvbGQvbmV3IGRyaXZlcnMuCgpTaWduZWQtb2ZmLWJ5OiBCZW4gQ2FoaWxsIDxiZW4u
bS5jYWhpbGxAaW50ZWwuY29tPgotLS0KIG9yaWdpbi9pd2wtYmFzZS5jIHwgICAxOSArKysrKysr
KysrKy0tLS0tLS0tCiAxIGZpbGVzIGNoYW5nZWQsIDExIGluc2VydGlvbnMoKyksIDggZGVsZXRp
b25zKC0pCgpkaWZmIC0tZ2l0IGEvb3JpZ2luL2l3bC1iYXNlLmMgYi9vcmlnaW4vaXdsLWJhc2Uu
YwppbmRleCBkMzZlMTMyLi45MmEzMmU4IDEwMDY0NAotLS0gYS9vcmlnaW4vaXdsLWJhc2UuYwor
KysgYi9vcmlnaW4vaXdsLWJhc2UuYwpAQCAtMTEwLDYgKzExMCwxMyBAQCBCVUlMRF9CVUcoKQog
I2RlZmluZSBEUlZfQ09QWVJJR0hUCSJDb3B5cmlnaHQoYykgMjAwMy0yMDA3IEludGVsIENvcnBv
cmF0aW9uIgogI2RlZmluZSBEUlZfVkVSU0lPTiAgICAgSVdMV0lGSV9WRVJTSU9OCiAKKy8qIENo
YW5nZSBmaXJtd2FyZSBmaWxlIG5hbWUsIHVzaW5nICItIiBhbmQgaW5jcmVtZW50aW5nIG51bWJl
ciwKKyAqICAgKm9ubHkqIHdoZW4gdUNvZGUgaW50ZXJmYWNlIG9yIGFyY2hpdGVjdHVyZSBjaGFu
Z2VzIHNvIHRoYXQgaXQKKyAqICAgaXMgbm90IGNvbXBhdGlibGUgd2l0aCBlYXJsaWVyIGRyaXZl
cnMuCisgKiBUaGlzIG51bWJlciB3aWxsIGFsc28gYXBwZWFyIGluIDw8IDggcG9zaXRpb24gb2Yg
MXN0IGR3b3JkIG9mIHVDb2RlIGZpbGUgKi8KKyNkZWZpbmUgSVdMMzk0NV9VQ09ERV9BUEkgIi0x
IgorI2RlZmluZSBJV0w0OTY1X1VDT0RFX0FQSSAiLTEiCisKIE1PRFVMRV9ERVNDUklQVElPTihE
UlZfREVTQ1JJUFRJT04pOwogTU9EVUxFX1ZFUlNJT04oRFJWX1ZFUlNJT04pOwogTU9EVUxFX0FV
VEhPUihEUlZfQ09QWVJJR0hUKTsKQEAgLTYxNzYsMjEgKzYxODMsMTcgQEAgc3RhdGljIGludCBp
d2xfcmVhZF91Y29kZShzdHJ1Y3QgaXdsX3ByaXYgKnByaXYpCiAJaW50IHJjID0gMDsKIAljb25z
dCBzdHJ1Y3QgZmlybXdhcmUgKnVjb2RlX3JhdzsKICNpZiBJV0wgPT0gMzk0NQotCWNvbnN0IGNo
YXIgKm5hbWUgPSAiaXdsd2lmaS0zOTQ1LnVjb2RlIjsJLyogZmlybXdhcmUgZmlsZSBuYW1lICov
CisJLyogZmlybXdhcmUgZmlsZSBuYW1lIGNvbnRhaW5zIHVDb2RlL2RyaXZlciBjb21wYXRpYmls
aXR5IHZlcnNpb24gKi8KKwljb25zdCBjaGFyICpuYW1lID0gIml3bHdpZmktMzk0NSIgSVdMMzk0
NV9VQ09ERV9BUEkgIi51Y29kZSI7CiAjZWxpZiBJV0wgPT0gNDk2NQotCWNvbnN0IGNoYXIgKm5h
bWUgPSAiaXdsd2lmaS00OTY1LnVjb2RlIjsJLyogZmlybXdhcmUgZmlsZSBuYW1lICovCisJY29u
c3QgY2hhciAqbmFtZSA9ICJpd2x3aWZpLTQ5NjUiIElXTDQ5NjVfVUNPREVfQVBJICIudWNvZGUi
OwogI2VuZGlmCiAJdTggKnNyYzsKIAlzaXplX3QgbGVuOwogCXUzMiB2ZXIsIGluc3Rfc2l6ZSwg
ZGF0YV9zaXplLCBpbml0X3NpemUsIGluaXRfZGF0YV9zaXplLCBib290X3NpemU7CiAKIAkvKiBB
c2sga2VybmVsIGZpcm13YXJlX2NsYXNzIG1vZHVsZSB0byBnZXQgdGhlIGJvb3QgZmlybXdhcmUg
b2ZmIGRpc2suCi0JICogcmVxdWVzdF9maXJtd2FyZSgpIGlzIHN5bmNocm9ub3VzIGNhbGwsIGZp
bGUgaXMgaW4gbWVtb3J5IG9uIHJldHVybi4KLQkgKiBUT0RPOiAgV291bGQgaXQgYmUgbW9yZSBw
b2xpdGUgdG8gdXNlIGFzeW5jaHJvbm91cwotCSAqICAgICAgICByZXF1ZXN0X2Zpcm13YXJlX25v
d2FpdCgpPz8gIElmIHNvLCBwdXQgcmVxdWVzdCBiYWNrIGludG8KLQkgKiAgICAgICAgaXdsX3Bj
aV9wcm9iZSgpLCBhbmQgcmVzdCBvZiB0aGlzIGZ1bmN0aW9uIHdvdWxkIHNlcnZlIGFzCi0JICog
ICAgICAgIHRoZSBjYWxsYmFjayBmb3IgcmVxdWVzdF9maXJtd2FyZV9ub3dhaXQoKS4gIEFsc28g
bmVlZCB0bwotCSAqICAgICAgICBtYWtlIHN1cmUgZXZlcnl0aGluZyB3YWl0cyBmb3IgdGhpcyBj
YWxsYmFjayB0byBjb21wbGV0ZSEgKi8KKwkgKiByZXF1ZXN0X2Zpcm13YXJlKCkgaXMgc3luY2hy
b25vdXMsIGZpbGUgaXMgaW4gbWVtb3J5IG9uIHJldHVybi4gKi8KIAlyYyA9IHJlcXVlc3RfZmly
bXdhcmUoJnVjb2RlX3JhdywgbmFtZSwgJnByaXYtPnBjaV9kZXYtPmRldik7CiAJaWYgKHJjIDwg
MCkgewogCQlJV0xfRVJST1IoIiVzIGZpcm13YXJlIGZpbGUgcmVxIGZhaWxlZDogUmVhc29uICVk
XG4iLCBuYW1lLCByYyk7Ci0tIAoxLjUuMgoK

------_=_NextPart_001_01C7D001.537B5191--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
