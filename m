Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:42260 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867AbZFFR6m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Jun 2009 13:58:42 -0400
Message-ID: <4A2AAE4A.6060100@web.de>
Date: Sat, 06 Jun 2009 19:58:34 +0200
From: Jan Kiszka <jan.kiszka@web.de>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	otus-devel@lists.madwifi-project.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/2] ar9170-fw: Roll-your-own toolchain
References: <4A2AA395.3060406@web.de>	 <1244308808.15640.4.camel@johannes.local>  <4A2AA6BC.5040004@web.de>	 <1244309333.17485.0.camel@johannes.local>  <4A2AA94E.3050700@web.de> <1244310329.17485.15.camel@johannes.local>
In-Reply-To: <1244310329.17485.15.camel@johannes.local>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig5D6026CDA63B0EC57E27F302"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig5D6026CDA63B0EC57E27F302
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Johannes Berg wrote:
> On Sat, 2009-06-06 at 19:37 +0200, Jan Kiszka wrote:
>=20
>>> Yes. With the AP firmware, that is. I don't care about that firmware =
at
>>> all.
>> I do as it shall upgrade my soft-AP from an oldish rt2500 to this
>> dwa-160 stick.
>=20
> No, you don't actually need AP software for that. The STA software
> supports most of AP already.

The last statement I read was: "haven't found a way to properly transmit
multicast frames after DTIM". Does this still apply on the new STA
firmware? What is the state of AP mode in the driver source? Just
disabled, some bits missing - or even ready to work?

>=20
>> Are you at least interested in porting the missing AP bits into the ST=
A
>> version (likely the best long-term approach anyway)? And do you have a=

>> rough idea which bits are missing / where to look at?
>=20
> Yes, that would be the plan. No, I have no idea what's missing. There
> are tools like diff though :)

Yeah:
# diff -up nice-code-1.c nice-code-2.c | manual-filter
=2E..
-rxBBReg =3D reg_read_PHY(0x1c5960); //*(volatile u32_t*)(0x1c5960); /* 0=
x1c8960 write only */
+rxBBReg =3D *(volatile u32_t*)(0x1c5960); /* 0x1c8960 write only */
=2E..

That will be a "nice" job... :)


Another silly question: You wrote that 802.11n works with the firmware,
and I blindly assumed that this of course includes a/b/g. I was right?
My current AP works in g-mode when association with the ar9170 fails...

Thanks so far,
Jan


--------------enig5D6026CDA63B0EC57E27F302
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkoqrlIACgkQniDOoMHTA+nE/gCeLCI9xHUaeyQVBgG2ol9FeXhC
i3sAn3YgenE3npQPMCJhczy7RB/jpXgg
=obmz
-----END PGP SIGNATURE-----

--------------enig5D6026CDA63B0EC57E27F302--
