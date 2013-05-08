Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog133.obsmtp.com ([74.125.149.82]:54704 "EHLO
	na3sys009aog133.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757596Ab3EHR7Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 May 2013 13:59:16 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Daniel Drake <dsd@laptop.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>
Date: Wed, 8 May 2013 10:58:38 -0700
Subject: RE: Memory leak in mwifiex_cfg80211_scan
Message-ID: <477F20668A386D41ADCC57781B1F70430DD2CA03F7@SC-VEXCH1.marvell.com> (sfid-20130508_195920_297150_33847CE3)
References: <CAMLZHHSVd6GpmqTQyJmbsheH1utZh8mNW8d4zLtjwoONaGwbNA@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F70430D9E0579DB@SC-VEXCH1.marvell.com>
	<CAMLZHHQ=BNuD0UmcV8pv=6phW=W-C5C7Af6n8tLWTrzyuzPQow@mail.gmail.com>
	<CAMLZHHQXY3OuWKr_K1B9-NmZFwCcQFPNTBoOkpvT9kxWJ=ixqQ@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F70430D9E14FF4C@SC-VEXCH1.marvell.com>
	<CAMLZHHSHG2ySmW0ac6+M-7fOgNFrqXBf7=SXFFkWDrhwGwYKXQ@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F70430D9E150221@SC-VEXCH1.marvell.com>
	<CAMLZHHThUxB_Vj4eOjq+61osUQ3CQ5UGgvrgZXE33oDD1N=YtA@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F70430D9E150A22@SC-VEXCH1.marvell.com>
	<CAMLZHHTNPBh3LDD0F2+zqSvUPmT6bhA8HLZvc1dTJmHGR8eVJg@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F70430D9E232E33@SC-VEXCH1.marvell.com>
	<CAMLZHHS7DOfRfpd-W2hVeJSvxVHNjm7SrxGXH=qLqaFt2sB+BA@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F70430DD2C9FC92@SC-VEXCH1.marvell.com>
 <CAMLZHHQdBuy=7bBsifA4i5ZKQcjnEhKZqVumRE=qu+Jkn3dZug@mail.gmail.com>
In-Reply-To: <CAMLZHHQdBuy=7bBsifA4i5ZKQcjnEhKZqVumRE=qu+Jkn3dZug@mail.gmail.com>
Content-Type: multipart/mixed;
	boundary="_002_477F20668A386D41ADCC57781B1F70430DD2CA03F7SCVEXCH1marve_"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--_002_477F20668A386D41ADCC57781B1F70430DD2CA03F7SCVEXCH1marve_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi Daniel,

> I think you should use del_timer_sync() though, for the SMP case where
> the timer may be running on a different processor.

Thanks for the comment. Please find attached updated patch.

Regards,
Bing

>=20
> Daniel

--_002_477F20668A386D41ADCC57781B1F70430DD2CA03F7SCVEXCH1marve_
Content-Type: application/octet-stream;
	name="v2_0001-mwifiex-scan-delay-timer-cleanup-in-unload-path.patch"
Content-Description: v2_0001-mwifiex-scan-delay-timer-cleanup-in-unload-path.patch
Content-Disposition: attachment;
	filename="v2_0001-mwifiex-scan-delay-timer-cleanup-in-unload-path.patch";
	size=1769; creation-date="Wed, 08 May 2013 17:56:10 GMT";
	modification-date="Wed, 08 May 2013 17:56:10 GMT"
Content-Transfer-Encoding: base64

RnJvbSA0ZmM4MGRkYTUwZDYyOTYwZjI4MjM4OTEzNTVhNWY1MzgyZjRjZTY3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBbWl0a3VtYXIgS2Fyd2FyIDxha2Fyd2FyQG1hcnZlbGwuY29t
PgpEYXRlOiBNb24sIDYgTWF5IDIwMTMgMTc6Mjg6NDQgLTA3MDAKU3ViamVjdDogW1BBVENIXSBt
d2lmaWV4OiBzY2FuIGRlbGF5IHRpbWVyIGNsZWFudXAgaW4gdW5sb2FkIHBhdGgKClJldHVybiBm
cm9tIHNjYW4gZGVsYXkgdGltZXIgcm91dGluZSBpZiBzdXJwcmlzZV9yZW1vdmVkIGZsYWcKaXMg
dHJ1ZS4gQWxzbywgY2FuY2VsIHRoZSB0aW1lciBpbiB1bmxvYWQgcGF0aC4KClRoaXMgZml4ZXMg
YSBjcmFzaCB3aGVuIHNjYW4gZGVsYXkgdGltZXIgYWNjZXNzZXMgc3RydWN0dXJlcwp0aGF0IGhh
dmUgYmVlbiBmcmVlZCBhbHJlYWR5LgoKVGVzdGVkIHdpdGggIml3bGlzdCBtbGFuMCBzY2FuICYg
c2xlZXAgMTsgcm1tb2QgbXdpZmlleF9zZGlvIgoKUmVwb3J0ZWQtYnk6IERhbmllbCBEcmFrZSA8
ZHNkQGxhcHRvcC5vcmc+ClRlc3RlZC1ieTogRGFuaWVsIERyYWtlIDxkc2RAbGFwdG9wLm9yZz4K
U2lnbmVkLW9mZi1ieTogQW1pdGt1bWFyIEthcndhciA8YWthcndhckBtYXJ2ZWxsLmNvbT4KU2ln
bmVkLW9mZi1ieTogQmluZyBaaGFvIDxiemhhb0BtYXJ2ZWxsLmNvbT4KLS0tCiBkcml2ZXJzL25l
dC93aXJlbGVzcy9td2lmaWV4L2luaXQuYyB8ICAgMTAgKysrKysrKysrKwogMSBmaWxlcyBjaGFu
Z2VkLCAxMCBpbnNlcnRpb25zKCspLCAwIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZl
cnMvbmV0L3dpcmVsZXNzL213aWZpZXgvaW5pdC5jIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvbXdp
ZmlleC9pbml0LmMKaW5kZXggYmNhNTAwYS4uMTM0MzcyNWYgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMv
bmV0L3dpcmVsZXNzL213aWZpZXgvaW5pdC5jCisrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL213
aWZpZXgvaW5pdC5jCkBAIC01OSw2ICs1OSw5IEBAIHN0YXRpYyB2b2lkIHNjYW5fZGVsYXlfdGlt
ZXJfZm4odW5zaWduZWQgbG9uZyBkYXRhKQogCXN0cnVjdCBjbWRfY3RybF9ub2RlICpjbWRfbm9k
ZSwgKnRtcF9ub2RlOwogCXVuc2lnbmVkIGxvbmcgZmxhZ3M7CiAKKwlpZiAoYWRhcHRlci0+c3Vy
cHJpc2VfcmVtb3ZlZCkKKwkJcmV0dXJuOworCiAJaWYgKGFkYXB0ZXItPnNjYW5fZGVsYXlfY250
ID09IE1XSUZJRVhfTUFYX1NDQU5fREVMQVlfQ05UKSB7CiAJCS8qCiAJCSAqIEFib3J0IHNjYW4g
b3BlcmF0aW9uIGJ5IGNhbmNlbGxpbmcgYWxsIHBlbmRpbmcgc2NhbgpAQCAtNDUyLDExICs0NTUs
MTggQEAgc3RhdGljIHZvaWQgbXdpZmlleF9mcmVlX2xvY2tfbGlzdChzdHJ1Y3QgbXdpZmlleF9h
ZGFwdGVyICphZGFwdGVyKQogc3RhdGljIHZvaWQKIG13aWZpZXhfYWRhcHRlcl9jbGVhbnVwKHN0
cnVjdCBtd2lmaWV4X2FkYXB0ZXIgKmFkYXB0ZXIpCiB7CisJaW50IGk7CisKIAlpZiAoIWFkYXB0
ZXIpIHsKIAkJcHJfZXJyKCIlczogYWRhcHRlciBpcyBOVUxMXG4iLCBfX2Z1bmNfXyk7CiAJCXJl
dHVybjsKIAl9CiAKKwlmb3IgKGkgPSAwOyBpIDwgYWRhcHRlci0+cHJpdl9udW07IGkrKykgewor
CQlpZiAoYWRhcHRlci0+cHJpdltpXSkKKwkJCWRlbF90aW1lcl9zeW5jKCZhZGFwdGVyLT5wcml2
W2ldLT5zY2FuX2RlbGF5X3RpbWVyKTsKKwl9CisKIAltd2lmaWV4X2NhbmNlbF9hbGxfcGVuZGlu
Z19jbWQoYWRhcHRlcik7CiAKIAkvKiBGcmVlIGxvY2sgdmFyaWFibGVzICovCi0tIAoxLjcuMy40
Cgo=

--_002_477F20668A386D41ADCC57781B1F70430DD2CA03F7SCVEXCH1marve_--
