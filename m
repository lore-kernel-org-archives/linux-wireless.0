Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog134.obsmtp.com ([74.125.149.83]:42400 "EHLO
	na3sys009aog134.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761170Ab3EBSnX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 May 2013 14:43:23 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Daniel Drake <dsd@laptop.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>
Date: Thu, 2 May 2013 11:41:42 -0700
Subject: RE: Memory leak in mwifiex_cfg80211_scan
Message-ID: <477F20668A386D41ADCC57781B1F70430D9E232E33@SC-VEXCH1.marvell.com> (sfid-20130502_204336_165374_6E01B745)
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
In-Reply-To: <CAMLZHHTNPBh3LDD0F2+zqSvUPmT6bhA8HLZvc1dTJmHGR8eVJg@mail.gmail.com>
Content-Type: multipart/mixed;
	boundary="_002_477F20668A386D41ADCC57781B1F70430D9E232E33SCVEXCH1marve_"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--_002_477F20668A386D41ADCC57781B1F70430D9E232E33SCVEXCH1marve_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi Daniel,

>  Kernel panic - not syncing: Fatal exception in interrupt
>=20
> I suspect this crash also existed before your patch, just I was not
> testing scan_delay_fn before. Maybe you prefer to deal with it as a
> separate issue.

You are right, this crash also existed before the patch in "deferred scan" =
path.
Please try attached patch address this issue.

Thanks,
Bing

>=20
> Daniel

--_002_477F20668A386D41ADCC57781B1F70430D9E232E33SCVEXCH1marve_
Content-Type: application/octet-stream;
	name="0001-mwifiex-cancel-scan-delay-timer-when-driver-unload.patch"
Content-Description: 0001-mwifiex-cancel-scan-delay-timer-when-driver-unload.patch
Content-Disposition: attachment;
	filename="0001-mwifiex-cancel-scan-delay-timer-when-driver-unload.patch";
	size=1173; creation-date="Thu, 02 May 2013 18:38:01 GMT";
	modification-date="Thu, 02 May 2013 18:38:01 GMT"
Content-Transfer-Encoding: base64

RnJvbSA1NTYxNDAwYWQ1Y2U4ODZlNjBiNzZhMzliNjlhOWQ2YTBlYzdlMmUxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBbWl0a3VtYXIgS2Fyd2FyIDxha2Fyd2FyQG1hcnZlbGwuY29t
PgpEYXRlOiBGcmksIDMgTWF5IDIwMTMgMjE6MTg6NTggKzA1MzAKU3ViamVjdDogW1BBVENIXSBt
d2lmaWV4OiBjYW5jZWwgc2NhbiBkZWxheSB0aW1lciB3aGVuIGRyaXZlciB1bmxvYWQKCkFsbCBw
ZW5kaW5nIHNjYW4gY29tbWFuZHMgYXJlIGNsZWFyZWQgaW4gdW5sb2FkIHBhdGgsCmJ1dCBzY2Fu
IGRlbGF5IHRpbWVyIGlzIG5vdCBjYW5jZWxsZWQuIFRoaXMgcGF0Y2ggZml4ZXMgdGhlCmlzc3Vl
LgoKU2lnbmVkLW9mZi1ieTogQW1pdGt1bWFyIEthcndhciA8YWthcndhckBtYXJ2ZWxsLmNvbT4K
LS0tCiBkcml2ZXJzL25ldC93aXJlbGVzcy9td2lmaWV4L2luaXQuYyB8ICAgIDcgKysrKysrKwog
MSBmaWxlcyBjaGFuZ2VkLCA3IGluc2VydGlvbnMoKyksIDAgZGVsZXRpb25zKC0pCgpkaWZmIC0t
Z2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvbXdpZmlleC9pbml0LmMgYi9kcml2ZXJzL25ldC93
aXJlbGVzcy9td2lmaWV4L2luaXQuYwppbmRleCBkNzUwMjg2Li5mNmI0Yjk2IDEwMDY0NAotLS0g
YS9kcml2ZXJzL25ldC93aXJlbGVzcy9td2lmaWV4L2luaXQuYworKysgYi9kcml2ZXJzL25ldC93
aXJlbGVzcy9td2lmaWV4L2luaXQuYwpAQCAtNDUzLDExICs0NTMsMTggQEAgc3RhdGljIHZvaWQg
bXdpZmlleF9mcmVlX2xvY2tfbGlzdChzdHJ1Y3QgbXdpZmlleF9hZGFwdGVyICphZGFwdGVyKQog
c3RhdGljIHZvaWQKIG13aWZpZXhfZnJlZV9hZGFwdGVyKHN0cnVjdCBtd2lmaWV4X2FkYXB0ZXIg
KmFkYXB0ZXIpCiB7CisJaW50IGk7CisKIAlpZiAoIWFkYXB0ZXIpIHsKIAkJcHJfZXJyKCIlczog
YWRhcHRlciBpcyBOVUxMXG4iLCBfX2Z1bmNfXyk7CiAJCXJldHVybjsKIAl9CiAKKwlmb3IgKGkg
PSAwOyBpIDwgYWRhcHRlci0+cHJpdl9udW07IGkrKykgeworCQlpZiAoYWRhcHRlci0+cHJpdltp
XSkKKwkJCWRlbF90aW1lcigmYWRhcHRlci0+cHJpdltpXS0+c2Nhbl9kZWxheV90aW1lcik7CisJ
fQorCiAJbXdpZmlleF9jYW5jZWxfYWxsX3BlbmRpbmdfY21kKGFkYXB0ZXIpOwogCiAJLyogRnJl
ZSBsb2NrIHZhcmlhYmxlcyAqLwotLSAKMS43LjMuNAoK

--_002_477F20668A386D41ADCC57781B1F70430D9E232E33SCVEXCH1marve_--
