Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:43509 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625Ab3CZWN3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Mar 2013 18:13:29 -0400
Received: by mail-ob0-f172.google.com with SMTP id tb18so7677301obb.31
        for <linux-wireless@vger.kernel.org>; Tue, 26 Mar 2013 15:13:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACna6rxpiPp_FR8jF=jKHbd6XrYndfFZC5O4g6=fvioK=e8vEg@mail.gmail.com>
References: <CACna6rwdAAsCX76=nwHpj-grVvQznbNCPVnpXL9kP2TkvhR-yw@mail.gmail.com>
	<1364323118.8319.13.camel@jlt4.sipsolutions.net>
	<CACna6rxpiPp_FR8jF=jKHbd6XrYndfFZC5O4g6=fvioK=e8vEg@mail.gmail.com>
Date: Tue, 26 Mar 2013 23:13:28 +0100
Message-ID: <CACna6ry+km7_epXz5NQ84D_jKQ9e6iFjtrmzHKb1Gxc1ywjtmw@mail.gmail.com> (sfid-20130326_231333_300089_F39C607C)
Subject: Re: Scanning regression since "cfg80211: use DS or HT operation IEs
 to determine BSS channel"
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	b43-dev <b43-dev@lists.infradead.org>
Content-Type: multipart/mixed; boundary=e89a8fb205482cd39104d8db3baa
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--e89a8fb205482cd39104d8db3baa
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

2013/3/26 Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com>:
> 2013/3/26 Johannes Berg <johannes@sipsolutions.net>:
>> Can you check your channel list? (iw list or iw phy0 info)
>
> Sure, attaching iw.list.log.

Hm, after some recompilations, rmmod, modprobe... now I can see
> * 2472 MHz [13] (20.0 dBm) (passive scanning, no IBSS)
(I didn't have "passive" for channel 13 earlier). Not sure what could
change that. I've to do more experiments with different channels.


>> Does reverting just the mac80211 change fix it?
>
> Yes. Reverting just a change in net/mac80211/scan.c fixes the problem
> for me. I've tested this with the latest wireless-testing.

Just to make it clear: I've modified scan.c as you can see in attached
0001-mac80211-fix.patch (application/octet-stream) 2 KB

--=20
Rafa=C5=82

--e89a8fb205482cd39104d8db3baa
Content-Type: application/octet-stream; name="0001-mac80211-fix.patch"
Content-Disposition: attachment; filename="0001-mac80211-fix.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hermeuex1

RnJvbSAxMDgwM2U4MWI1MGI3YmMyNTdmOWNlZTQ0YTc3NWE5YTc5YTlhYmU3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiA9P1VURi04P3E/UmFmYT1DNT04Mj0yME1pPUM1PTgyZWNraT89
IDxybWlsZWNraUBhbnRtaWNyby5jb20+CkRhdGU6IFR1ZSwgMjYgTWFyIDIwMTMgMjI6MzA6MTMg
KzAxMDAKU3ViamVjdDogW1BBVENIXSBtYWM4MDIxMSBmaXgKCi0tLQogbmV0L21hYzgwMjExL3Nj
YW4uYyB8ICAgIDkgKysrKysrKystCiAxIGZpbGUgY2hhbmdlZCwgOCBpbnNlcnRpb25zKCspLCAx
IGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvbmV0L21hYzgwMjExL3NjYW4uYyBiL25ldC9tYWM4
MDIxMS9zY2FuLmMKaW5kZXggY2IzNGNiYi4uZDIzZTQ2YyAxMDA2NDQKLS0tIGEvbmV0L21hYzgw
MjExL3NjYW4uYworKysgYi9uZXQvbWFjODAyMTEvc2Nhbi5jCkBAIC0xNTMsNiArMTUzLDcgQEAg
dm9pZCBpZWVlODAyMTFfc2Nhbl9yeChzdHJ1Y3QgaWVlZTgwMjExX2xvY2FsICpsb2NhbCwgc3Ry
dWN0IHNrX2J1ZmYgKnNrYikKIAl1OCAqZWxlbWVudHM7CiAJc3RydWN0IGllZWU4MDIxMV9jaGFu
bmVsICpjaGFubmVsOwogCXNpemVfdCBiYXNlbGVuOworCWludCBmcmVxOwogCXN0cnVjdCBpZWVl
ODAyXzExX2VsZW1zIGVsZW1zOwogCiAJaWYgKHNrYi0+bGVuIDwgMjQgfHwKQEAgLTE4NCw3ICsx
ODUsMTMgQEAgdm9pZCBpZWVlODAyMTFfc2Nhbl9yeChzdHJ1Y3QgaWVlZTgwMjExX2xvY2FsICps
b2NhbCwgc3RydWN0IHNrX2J1ZmYgKnNrYikKIAogCWllZWU4MDJfMTFfcGFyc2VfZWxlbXMoZWxl
bWVudHMsIHNrYi0+bGVuIC0gYmFzZWxlbiwgJmVsZW1zKTsKIAotCWNoYW5uZWwgPSBpZWVlODAy
MTFfZ2V0X2NoYW5uZWwobG9jYWwtPmh3LndpcGh5LCByeF9zdGF0dXMtPmZyZXEpOworCWlmIChl
bGVtcy5kc19wYXJhbXMgJiYgZWxlbXMuZHNfcGFyYW1zX2xlbiA9PSAxKQorCQlmcmVxID0gaWVl
ZTgwMjExX2NoYW5uZWxfdG9fZnJlcXVlbmN5KGVsZW1zLmRzX3BhcmFtc1swXSwKKwkJCQkJCSAg
ICAgIHJ4X3N0YXR1cy0+YmFuZCk7CisJZWxzZQorCQlmcmVxID0gcnhfc3RhdHVzLT5mcmVxOwor
CisJY2hhbm5lbCA9IGllZWU4MDIxMV9nZXRfY2hhbm5lbChsb2NhbC0+aHcud2lwaHksIGZyZXEp
OwogCiAJaWYgKCFjaGFubmVsIHx8IGNoYW5uZWwtPmZsYWdzICYgSUVFRTgwMjExX0NIQU5fRElT
QUJMRUQpCiAJCXJldHVybjsKLS0gCjEuNy4xMC40Cgo=
--e89a8fb205482cd39104d8db3baa--
