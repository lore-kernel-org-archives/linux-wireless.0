Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wj0-f196.google.com ([209.85.210.196]:34752 "EHLO
        mail-wj0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753067AbcLQNLB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 17 Dec 2016 08:11:01 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Sebastian Reichel <sre@kernel.org>
Subject: MAC address in wl1251 NVS data (Was: Re: wl1251 NVS calibration data format)
Date: Sat, 17 Dec 2016 14:10:57 +0100
Cc: Gery Kahn <gery.kahn@gmail.com>, Shahar Lev <shahar@wizery.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pavel Machek <pavel@ucw.cz>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
References: <201612161201.48356@pali> <201612171214.50820@pali> <20161217120350.phnlfhklwfqqgbjr@earth>
In-Reply-To: <20161217120350.phnlfhklwfqqgbjr@earth>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3979182.UCilIFt6EB";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <201612171410.57556@pali> (sfid-20161217_141127_752454_1596830F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart3979182.UCilIFt6EB
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

> On Sat, Dec 17, 2016 at 12:14:50PM +0100, Pali Roh=C3=A1r wrote:
> > > [1] http://notaz.gp2x.de/misc/pnd/wl1251/nvs_map.txt
> > In that description is something about STA mac address:
> >=20

    019       02           //length

> > 01a       6d           //STA_ADDR_L Register Address.  (STA MAC
> > Address)
> > 01b       54           //
> > 01c       00           //STA_ADDR_L Register
> > 01d       00           //
> > 01e       32           //
> > 01f       28           //
> > 020       00           //STA_ADDR_H Register Data.

    021       08           //
    022       00           //
    023       00           //

So... above data means:

019 - number of words
01a - low bits of offset applied with mask 0xfe
01b - high bits of offset
01c-01f first word
020-023 second word

Interpreted as: at address offset 0x536c are written two words=20
0x28320000 and 0x00000800

wl1271 driver has in linux/drivers/net/wireless/ti/wlcore/boot.c this:

	/* update current MAC address to NVS */
	nvs_ptr[11] =3D wl->addresses[0].addr[0];
	nvs_ptr[10] =3D wl->addresses[0].addr[1];
	nvs_ptr[6] =3D wl->addresses[0].addr[2];
	nvs_ptr[5] =3D wl->addresses[0].addr[3];
	nvs_ptr[4] =3D wl->addresses[0].addr[4];
	nvs_ptr[3] =3D wl->addresses[0].addr[5];

Looking at wl1271-nvs.bin file (which is "modified" in kernel by boot.c)

000: 01
001: 6d
002: 54
003: 00
004: 00
005: ef
006: be

Means: at address offset 0x536c is written one word 0xBEEF0000

007: 01
008: 71
009: 54
00a: ad
00b: de
00c: 00
00d: 00

Means: at address offset 0x5371 is written one word 0x0000DEAD

Above boot.c kernel code updates those data to MAC address, so at=20
address offset 0x536c is written four low bytes of MAC address and to=20
0x5371 are written remaining two bytes. So 00:00:DE:AD:BE:EF

So conclusion: address offset for wl1271 (where is written MAC address)=20
is exactly same as for wl1251 which is marked in that documentation as=20
STA_ADDR_L Register.

Btw, in our wl1251-nvs.bin found in Maemo rootfs, which is exactly same=20
as in linux-firmware.git tree there are those data:

019: 02
01a: 6d
01b: 54
01c: 09
01d: 03
01e: 07
01f: 20
020: 00
021: 00
022: 00
023: 00

So hardcoded MAC address in wl1251-nvs.bin is: 00:00:20:07:03:09. Which=20
is assigned to DIAB. Strange that it is not TI...

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart3979182.UCilIFt6EB
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlhVOWEACgkQi/DJPQPkQ1KYsgCeO0IIYGM6CTR7MVdneCZ3PCU6
CgsAoJIYFoQn1FCYZUKd2Zb8d1HbWdd+
=S5h0
-----END PGP SIGNATURE-----

--nextPart3979182.UCilIFt6EB--
