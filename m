Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33353 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753178AbcLXM54 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 24 Dec 2016 07:57:56 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Sebastian Reichel <sre@kernel.org>
Subject: Re: wl1251 NVS calibration data format
Date: Sat, 24 Dec 2016 13:57:52 +0100
Cc: Gery Kahn <gery.kahn@gmail.com>, Shahar Lev <shahar@wizery.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pavel Machek <pavel@ucw.cz>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
References: <201612161201.48356@pali> <20161217093705.p64yzumqlu3u5aq7@earth> <201612171214.50820@pali>
In-Reply-To: <201612171214.50820@pali>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart5172311.J332cXn8yN";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <201612241357.52086@pali> (sfid-20161224_135818_628061_AA93E801)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart5172311.J332cXn8yN
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Saturday 17 December 2016 12:14:50 Pali Roh=C3=A1r wrote:
> I will try to play with driver if it is really truth!
>=20
> I already looked into original TI's multiplatform HAL driver for
> wl1251 chip (big mess) and found there that there is wl1251 command
> to read mac address from chip. It could be done by this wl1251
> function:
>=20
> wl1251_cmd_interrogate(wl, DOT11_STATION_ID, mac, sizeof(*mac))
>=20
> (same id as for setting permanent mac address, but opposite to read
> it)

Confirmed! Calling that function (before setting real linux mac address)=20
returns MAC address 00:00:20:07:03:09.

Changing NVS data at position 0x1c-0x21 changes also what above function=20
returns.

So really at position 0x1c-0x21 in NVS data is stored MAC address (in=20
reverse order). Just default is some unknown 00:00:20:07:03:09.

So MAC address is really part of NVS data.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart5172311.J332cXn8yN
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlhecNAACgkQi/DJPQPkQ1LjxgCgyZbNDK+5tEZW8PZ4eUrnrovy
PSkAn0/Dv5ELzOyyEK3/VEkLczciIOj0
=4mKK
-----END PGP SIGNATURE-----

--nextPart5172311.J332cXn8yN--
