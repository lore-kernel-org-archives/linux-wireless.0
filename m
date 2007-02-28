Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60799 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880AbXB1UCq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Feb 2007 15:02:46 -0500
Subject: Re: [PATCH 2/28] rt2x00: Add debugfs support
From: Johannes Berg <johannes@sipsolutions.net>
To: Robin Cornelius <robin.cornelius@gmail.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	James Ketrenos <jketreno@linux.intel.com>
In-Reply-To: <c4db5c50702280921i6f0689adm197b5fcb19f1852f@mail.gmail.com>
References: <200702281507.13953.IvDoorn@gmail.com>
	 <200702281752.36875.IvDoorn@gmail.com>
	 <1172681674.5015.43.camel@johannes.berg>
	 <200702281809.15486.IvDoorn@gmail.com>
	 <c4db5c50702280921i6f0689adm197b5fcb19f1852f@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-IL2ERNwuHl9h/MA4dHZI"
Date: Wed, 28 Feb 2007 21:02:20 +0100
Message-Id: <1172692940.5015.85.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-IL2ERNwuHl9h/MA4dHZI
Content-Type: multipart/mixed; boundary="=-lgO2yBt9EMgzMucXagIj"


--=-lgO2yBt9EMgzMucXagIj
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-02-28 at 17:21 +0000, Robin Cornelius wrote:

> d80211 and cfg80211 will compile against a 2.6.20 kernel (i believe
> 2.6.18 or better will do).

I just got cfg80211 to compile against 2.6.19 on my brothers laptop.
With James's changes to build mac80211 against older kernels, this
should enable us to actually build the current code against older
kernels.

There will currently be two restrictions:
 * no nl80211
 * no wiphy renaming

The second isn't a problem at all, users just have a bit less
convenience then. The first will become more and more of a problem as
mac80211 will migrate towards cfg80211, but since it hasn't yet this
will allow us some time.

To build, I used this sed script first:

sed 's/\([a-z0-9_]*\)->ieee80211_ptr/((struct wireless_dev*)(\1->ax25_ptr))=
/' -i *.c

to fix the ieee80211_ptr thing (using ax25_ptr as James did), and then
applied the attached patch. Then I built the whole thing with the
attached Makefile and loaded the module. I couldn't really test it since
I don't have mac80211 building against that right now.

johannes

--=-lgO2yBt9EMgzMucXagIj
Content-Description: 
Content-Disposition: attachment; filename=fixes.patch
Content-Type: text/x-patch; charset=UTF-8
Content-Transfer-Encoding: base64

SW5kZXg6IGNmZzgwMjExL2NvcmUuYw0KPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQ0KLS0tIGNmZzgwMjExLm9yaWcvY29y
ZS5jCTIwMDctMDItMjggMjA6NDA6NDAuNjk4OTA4NzkxICswMTAwDQorKysgY2ZnODAyMTEvY29y
ZS5jCTIwMDctMDItMjggMjA6NDI6MDcuNjI0OTA4NzkxICswMTAwDQpAQCAtMTQ2LDYgKzE0Niw4
IEBADQogew0KIAlpbnQgaWR4LCB0YWtlbiA9IC0xLCByZXN1bHQ7DQogDQorCXJldHVybiAtRU9Q
Tk9UU1VQUDsNCisNCiAJLyogcHJvaGliaXQgY2FsbGluZyB0aGUgdGhpbmcgcGh5JWQgd2hlbiAl
ZCBpcyBub3QgaXRzIG51bWJlciAqLw0KIAlzc2NhbmYobmV3bmFtZSwgUEhZX05BTUUgIiVuIiwg
JmlkeCwgJnRha2VuKTsNCiAJaWYgKHRha2VuID09IHN0cmxlbihuZXduYW1lKSAmJiBpZHggIT0g
cmRldi0+aWR4KQ0KQEAgLTI4MSw3ICsyODMsNyBAQA0KIAljYXNlIE5FVERFVl9SRUdJU1RFUjoN
CiAJCW11dGV4X2xvY2soJnJkZXYtPmRldmxpc3RfbXR4KTsNCiAJCWxpc3RfYWRkKCYoKHN0cnVj
dCB3aXJlbGVzc19kZXYqKShkZXYtPmF4MjVfcHRyKSktPmxpc3QsICZyZGV2LT5uZXRkZXZfbGlz
dCk7DQotCQlpZiAoc3lzZnNfY3JlYXRlX2xpbmsoJmRldi0+ZGV2LmtvYmosICZyZGV2LT53aXBo
eS5kZXYua29iaiwNCisJCWlmIChzeXNmc19jcmVhdGVfbGluaygmZGV2LT5jbGFzc19kZXYua29i
aiwgJnJkZXYtPndpcGh5LmRldi5rb2JqLA0KIAkJCQkgICAgICAicGh5ODAyMTEiKSkgew0KIAkJ
CXByaW50ayhLRVJOX0VSUiAid2lyZWxlc3M6IGZhaWxlZCB0byBhZGQgcGh5ODAyMTEgc3ltbGlu
ayB0byBuZXRkZXYhXG4iKTsNCiAJCX0NCkBAIC0yOTAsNyArMjkyLDcgQEANCiAJCWJyZWFrOw0K
IAljYXNlIE5FVERFVl9VTlJFR0lTVEVSOg0KIAkJbXV0ZXhfbG9jaygmcmRldi0+ZGV2bGlzdF9t
dHgpOw0KLQkJc3lzZnNfcmVtb3ZlX2xpbmsoJmRldi0+ZGV2LmtvYmosICJwaHk4MDIxMSIpOw0K
KwkJc3lzZnNfcmVtb3ZlX2xpbmsoJmRldi0+Y2xhc3NfZGV2LmtvYmosICJwaHk4MDIxMSIpOw0K
IAkJbGlzdF9kZWwoJigoc3RydWN0IHdpcmVsZXNzX2RldiopKGRldi0+YXgyNV9wdHIpKS0+bGlz
dCk7DQogCQltdXRleF91bmxvY2soJnJkZXYtPmRldmxpc3RfbXR4KTsNCiAJCWJyZWFrOw0K


--=-lgO2yBt9EMgzMucXagIj
Content-Disposition: attachment; filename=Makefile
Content-Transfer-Encoding: base64
Content-Type: text/x-makefile; name=Makefile; charset=UTF-8

S1ZFUgk6PSAkKHNoZWxsIHVuYW1lIC1yKQ0KS0RJUgk/PSAvbGliL21vZHVsZXMvJChLVkVSKS9i
dWlsZA0KTU9EUEFUSAk6PSAkKERFU1RESVIpL2xpYi9tb2R1bGVzLyQoS1ZFUikva2VybmVsL25l
dC93aXJlbGVzcy8NCg0KaWZuZXEgKCQoS0VSTkVMUkVMRUFTRSksKQ0KDQpDT05GSUdfQ0ZHODAy
MTE9bQ0KQ0ZMQUdTKz0tSSAkKFBXRCkgJy1EaWVlZTgwMjExX3B0cj1heDI1X3B0cicNCg0Kb2Jq
LSQoQ09ORklHX0NGRzgwMjExKSArPSBjZmc4MDIxMS5vDQpjZmc4MDIxMS15ICs9IGNvcmUubyBz
eXNmcy5vDQoNCmVsc2UNClBXRAk6PSAkKHNoZWxsIHB3ZCkNCg0KbW9kdWxlOg0KCSQoTUFLRSkg
LUMgJChLRElSKSBNPSQoUFdEKSBtb2R1bGVzDQplbmRpZg0K


--=-lgO2yBt9EMgzMucXagIj--

--=-IL2ERNwuHl9h/MA4dHZI
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF5d/M/ETPhpq3jKURAu1iAJ4st4oAq09ZyX3yLtAH/KfBmca7rgCguIpY
jRYm6JIsdC/b0VEYz/SMnsI=
=wi+H
-----END PGP SIGNATURE-----

--=-IL2ERNwuHl9h/MA4dHZI--

