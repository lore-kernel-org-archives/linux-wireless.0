Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:35115 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1162968Ab3DEXtI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Apr 2013 19:49:08 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Daniel Drake <dsd@laptop.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	John Rhodes <jrhodes@marvell.com>
Date: Fri, 5 Apr 2013 16:48:32 -0700
Subject: RE: mwifiex frequent "not allowed while suspended" crash on resume
Message-ID: <477F20668A386D41ADCC57781B1F70430D9DDAB9CC@SC-VEXCH1.marvell.com> (sfid-20130406_014913_476021_11095CC8)
References: <CAMLZHHRpPghm0tWTksFiD-zxUUM1dSbgPbj6doMck1jqv-yokw@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F70430D9DAD431B@SC-VEXCH1.marvell.com>
 <CAMLZHHRcTgQ66fucR09SEyjCCRiZixigM=cDwnfKB5yWYk4PQw@mail.gmail.com>
In-Reply-To: <CAMLZHHRcTgQ66fucR09SEyjCCRiZixigM=cDwnfKB5yWYk4PQw@mail.gmail.com>
Content-Type: multipart/mixed;
	boundary="_002_477F20668A386D41ADCC57781B1F70430D9DDAB9CCSCVEXCH1marve_"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--_002_477F20668A386D41ADCC57781B1F70430D9DDAB9CCSCVEXCH1marve_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi Daniel,

> As we haven't heard back from you in a while, and this is blocking
> several things on our end, I had a quick look myself.
>=20
> The problem seems to be TX soon after resume, and there does seem to
> be a bit of a lack of synchronization here (i.e. mwifiex_main_process
> should maybe avoid doing TX while the interface is suspended).

Normally TX is blocked until resume handler is called and host sleep handsh=
ake between driver and firmware is done. Does the TX happen before "hs_deac=
tivated" event?

>=20
> As a quick hack I added netdev_device_detach() early in suspend, and
> netdev_device_attach() late in resume, and that seems to serialize
> things. But I don't think its a good fix. Hopefully you can find a
> solution that flows better with the mwifiex design.

I'm thinking of releasing IRQ in driver suspend handler and re-claim the IR=
Q in resume. Of course it needs some changes in sdio_release_irq to skip SD=
IO_CCCR_IENx disabling, otherwise host may not be woken up by SDIO DAT1.

Attached is the sample code, not tested.

Thanks,
Bing


--_002_477F20668A386D41ADCC57781B1F70430D9DDAB9CCSCVEXCH1marve_
Content-Type: application/octet-stream; name="release_irq_in_suspend.diff"
Content-Description: release_irq_in_suspend.diff
Content-Disposition: attachment; filename="release_irq_in_suspend.diff";
	size=2244; creation-date="Fri, 05 Apr 2013 23:10:36 GMT";
	modification-date="Fri, 05 Apr 2013 23:10:36 GMT"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbW1jL2NvcmUvc2Rpb19pcnEuYyBiL2RyaXZlcnMvbW1jL2Nv
cmUvc2Rpb19pcnEuYwppbmRleCAzZDhjZWI0Li5iYTcyZTdiIDEwMDY0NAotLS0gYS9kcml2ZXJz
L21tYy9jb3JlL3NkaW9faXJxLmMKKysrIGIvZHJpdmVycy9tbWMvY29yZS9zZGlvX2lycS5jCkBA
IC0yODYsMTQgKzI4NiwyMCBAQCBpbnQgc2Rpb19yZWxlYXNlX2lycShzdHJ1Y3Qgc2Rpb19mdW5j
ICpmdW5jKQogCUJVR19PTighZnVuYyk7CiAJQlVHX09OKCFmdW5jLT5jYXJkKTsKIAotCXByX2Rl
YnVnKCJTRElPOiBEaXNhYmxpbmcgSVJRIGZvciAlcy4uLlxuIiwgc2Rpb19mdW5jX2lkKGZ1bmMp
KTsKLQogCWlmIChmdW5jLT5pcnFfaGFuZGxlcikgewogCQlmdW5jLT5pcnFfaGFuZGxlciA9IE5V
TEw7CiAJCXNkaW9fY2FyZF9pcnFfcHV0KGZ1bmMtPmNhcmQpOwogCQlzZGlvX3NpbmdsZV9pcnFf
c2V0KGZ1bmMtPmNhcmQpOwogCX0KIAorCWlmKGZ1bmMtPmNhcmQtPmhvc3QgJiYKKwkgICBmdW5j
LT5jYXJkLT5ob3N0LT5wbV9mbGFncyAmIE1NQ19QTV9XQUtFX1NESU9fSVJRKSB7CisJCXByX2lu
Zm8oIlNESU86IEtFRVAgSVJRIE9OIGZvciAlcy4uLlxuIiwgc2Rpb19mdW5jX2lkKGZ1bmMpKTsK
KwkJcmV0dXJuIDA7CisJfQorCisJcHJfZGVidWcoIlNESU86IERpc2FibGluZyBJUlEgZm9yICVz
Li4uXG4iLCBzZGlvX2Z1bmNfaWQoZnVuYykpOworCiAJcmV0ID0gbW1jX2lvX3J3X2RpcmVjdChm
dW5jLT5jYXJkLCAwLCAwLCBTRElPX0NDQ1JfSUVOeCwgMCwgJnJlZyk7CiAJaWYgKHJldCkKIAkJ
cmV0dXJuIHJldDsKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL213aWZpZXgvc2Rp
by5jIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvbXdpZmlleC9zZGlvLmMKaW5kZXggMzYzYmEzMS4u
YjllZjkzZSAxMDA2NDQKLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvbXdpZmlleC9zZGlvLmMK
KysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvbXdpZmlleC9zZGlvLmMKQEAgLTUxLDYgKzUxLDcg
QEAgc3RhdGljIHN0cnVjdCBtd2lmaWV4X2lmX29wcyBzZGlvX29wczsKIHN0YXRpYyBzdHJ1Y3Qg
c2VtYXBob3JlIGFkZF9yZW1vdmVfY2FyZF9zZW07CiAKIHN0YXRpYyBpbnQgbXdpZmlleF9zZGlv
X3Jlc3VtZShzdHJ1Y3QgZGV2aWNlICpkZXYpOworc3RhdGljIHZvaWQgbXdpZmlleF9zZGlvX2lu
dGVycnVwdChzdHJ1Y3Qgc2Rpb19mdW5jICpmdW5jKTsKIAogLyoKICAqIFNESU8gcHJvYmUuCkBA
IC0xOTEsNiArMTkyLDEwIEBAIHN0YXRpYyBpbnQgbXdpZmlleF9zZGlvX3N1c3BlbmQoc3RydWN0
IGRldmljZSAqZGV2KQogCQlyZXR1cm4gLUVGQVVMVDsKIAl9CiAKKwlzZGlvX2NsYWltX2hvc3Qo
Y2FyZC0+ZnVuYyk7CisJc2Rpb19yZWxlYXNlX2lycShmdW5jKTsKKwlzZGlvX3JlbGVhc2VfaG9z
dChjYXJkLT5mdW5jKTsKKwogCWRldl9kYmcoYWRhcHRlci0+ZGV2LCAiY21kOiBzdXNwZW5kIHdp
dGggTU1DX1BNX0tFRVBfUE9XRVJcbiIpOwogCXJldCA9IHNkaW9fc2V0X2hvc3RfcG1fZmxhZ3Mo
ZnVuYywgTU1DX1BNX0tFRVBfUE9XRVIpOwogCkBAIC0yMTYsNiArMjIxLDcgQEAgc3RhdGljIGlu
dCBtd2lmaWV4X3NkaW9fcmVzdW1lKHN0cnVjdCBkZXZpY2UgKmRldikKIAlzdHJ1Y3Qgc2Rpb19t
bWNfY2FyZCAqY2FyZDsKIAlzdHJ1Y3QgbXdpZmlleF9hZGFwdGVyICphZGFwdGVyOwogCW1tY19w
bV9mbGFnX3QgcG1fZmxhZyA9IDA7CisJaW50IHJldDsKIAogCWlmIChmdW5jKSB7CiAJCXBtX2Zs
YWcgPSBzZGlvX2dldF9ob3N0X3BtX2NhcHMoZnVuYyk7CkBAIC0yMzgsNiArMjQ0LDE0IEBAIHN0
YXRpYyBpbnQgbXdpZmlleF9zZGlvX3Jlc3VtZShzdHJ1Y3QgZGV2aWNlICpkZXYpCiAKIAlhZGFw
dGVyLT5pc19zdXNwZW5kZWQgPSBmYWxzZTsKIAorCXNkaW9fY2xhaW1faG9zdChjYXJkLT5mdW5j
KTsKKwlyZXQgPSBzZGlvX2NsYWltX2lycShmdW5jLCBtd2lmaWV4X3NkaW9faW50ZXJydXB0KTsK
KwlzZGlvX3JlbGVhc2VfaG9zdChjYXJkLT5mdW5jKTsKKwlpZiAocmV0KSB7CisJCXByX2Vycigi
JXM6IGNsYWltIGlycSBmYWlsZWQ6IHJldD0lZFxuIiwgX19mdW5jX18sIHJldCk7CisJCXJldHVy
biByZXQ7CisJfQorCiAJLyogRGlzYWJsZSBIb3N0IFNsZWVwICovCiAJbXdpZmlleF9jYW5jZWxf
aHMobXdpZmlleF9nZXRfcHJpdihhZGFwdGVyLCBNV0lGSUVYX0JTU19ST0xFX1NUQSksCiAJCQkg
IE1XSUZJRVhfQVNZTkNfQ01EKTsK

--_002_477F20668A386D41ADCC57781B1F70430D9DDAB9CCSCVEXCH1marve_--
