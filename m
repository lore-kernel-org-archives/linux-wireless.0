Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:38408 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbZFFSdF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Jun 2009 14:33:05 -0400
Message-ID: <4A2AB634.9020904@web.de>
Date: Sat, 06 Jun 2009 20:32:20 +0200
From: Jan Kiszka <jan.kiszka@web.de>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	otus-devel@lists.madwifi-project.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] ar9170-fw: Use self-built toolchain by default
References: <4A2AA3BA.4050200@web.de> <1244311169.17485.16.camel@johannes.local>
In-Reply-To: <1244311169.17485.16.camel@johannes.local>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig37E4E8BF5FA8BDBB89A9D2DD"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig37E4E8BF5FA8BDBB89A9D2DD
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Johannes Berg wrote:
> On Sat, 2009-06-06 at 19:13 +0200, Jan Kiszka wrote:
>> Signed-off-by: Jan Kiszka <jan.kiszka@web.de>
>> ---
>>
>>  Makefile |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/Makefile b/Makefile
>> index e0113d6..5fc0868 100644
>> --- a/Makefile
>> +++ b/Makefile
>> @@ -1,7 +1,7 @@
>>  # Type is AP or STA
>>  TYPE ?=3D STA
>> =20
>> -PFX ?=3D /usr/share/gnush_v0901_elf-1/bin/sh-elf-
>> +PFX ?=3D $(shell pwd)/toolchain/inst/bin/sh-elf-
>=20
> This will fail in strange ways if the user doesn't first manually build=

> the toolchain... It does that if you don't have it installed, but it
> would be nice to tell them to build it?
>=20

What about this? There are probably smarter ways to achieve this, but
I'm not speaking fluently 'make'.

---------->

Switch the default to our own toolchain and provide a hint in case it's
missing or the provided PFX does not point to a gcc.

Signed-off-by: Jan Kiszka <jan.kiszka@web.de>
---

 Makefile |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/Makefile b/Makefile
index e0113d6..6316f62 100644
--- a/Makefile
+++ b/Makefile
@@ -1,11 +1,13 @@
 # Type is AP or STA
 TYPE ?=3D STA
=20
-PFX ?=3D /usr/share/gnush_v0901_elf-1/bin/sh-elf-
-CC =3D $(PFX)gcc
-LD =3D $(PFX)ld
-AS =3D $(PFX)as
-OBJCOPY =3D $(PFX)objcopy
+PFX ?=3D $(shell pwd)/toolchain/inst/bin/sh-elf-
+VALID_PFX =3D $(if $(wildcard $(PFX)gcc), $(PFX), \
+	$(error Error: sh2 gcc not found. To build your own, invoke 'make -C to=
olchain'.))
+CC =3D $(VALID_PFX)gcc
+LD =3D $(VALID_PFX)ld
+AS =3D $(VALID_PFX)as
+OBJCOPY =3D $(VALID_PFX)objcopy
=20
 # CPU is a Little endian sh2a-nofpu-or-sh3-nommu
 CPU =3D -m2


--------------enig37E4E8BF5FA8BDBB89A9D2DD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkoqtjgACgkQniDOoMHTA+nC/QCeJPtpGu1QRUhdAhlc1fI9lnZr
xu4An1v3utD2I/jntlZLyD4qM2A/okKb
=Jq1j
-----END PGP SIGNATURE-----

--------------enig37E4E8BF5FA8BDBB89A9D2DD--
