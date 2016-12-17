Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wj0-f196.google.com ([209.85.210.196]:33699 "EHLO
        mail-wj0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754381AbcLQLOy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 17 Dec 2016 06:14:54 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Sebastian Reichel <sre@kernel.org>
Subject: Re: wl1251 NVS calibration data format
Date: Sat, 17 Dec 2016 12:14:50 +0100
Cc: Gery Kahn <gery.kahn@gmail.com>, Shahar Lev <shahar@wizery.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pavel Machek <pavel@ucw.cz>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
References: <201612161201.48356@pali> <20161217093705.p64yzumqlu3u5aq7@earth>
In-Reply-To: <20161217093705.p64yzumqlu3u5aq7@earth>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1493969.IcPi48psSL";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <201612171214.50820@pali> (sfid-20161217_121517_778341_DE2A302F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1493969.IcPi48psSL
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Saturday 17 December 2016 10:37:05 Sebastian Reichel wrote:
> Hi,
>=20
> On Fri, Dec 16, 2016 at 12:01:48PM +0100, Pali Roh=C3=A1r wrote:
> > Hi! Do you know format of wl1251 NVS calibration data file?
> >=20
> > I found that there is tool for changing NVS file for wl1271 and
> > newer chips (so not for wl1251!) at:
> > https://github.com/gxk/ti-utils
> >=20
> > And wl1271 has in NVS data already place for MAC address. And in
> > wlcore (for wl1271 and newer) there is really kernel code which is
> > doing something with MAC address in NVS, see:
> > https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tre
> > e/drivers/net/wireless/ti/wlcore/boot.c#n352
> >=20
> > So... I would like to know if in wl1251 NVS calibration file is
> > also some place for MAC address or not.
> >=20
> > Default wl1251 NVS calibration file is available in linux-firmware:
> > https://git.kernel.org/cgit/linux/kernel/git/firmware/linux-firmwar
> > e.git/tree/ti-connectivity/wl1251-nvs.bin
>=20
> Pandora people [0] have a description of the format at [1].
>=20
> [0] https://pandorawiki.org/WiFi
> [1] http://notaz.gp2x.de/misc/pnd/wl1251/nvs_map.txt

Thank you very very much!

I tried to search for something, but I have not find anything.

In that description is something about STA mac address:

01a       6d           //STA_ADDR_L Register Address.  (STA MAC Address)
01b       54           //
01c       00           //STA_ADDR_L Register
01d       00           //
01e       32           //
01f       28           //
020       00           //STA_ADDR_H Register Data.

STA would be abbreviation for station and so it should be really set to=20
mac address of that chip?

If yes, that could allow us to set permanent MAC address at time when=20
loading & sending NVS calibration data... Exactly same as wl1271 and new=20
drivers are working.

I will try to play with driver if it is really truth!

I already looked into original TI's multiplatform HAL driver for wl1251=20
chip (big mess) and found there that there is wl1251 command to read mac=20
address from chip. It could be done by this wl1251 function:

wl1251_cmd_interrogate(wl, DOT11_STATION_ID, mac, sizeof(*mac))

(same id as for setting permanent mac address, but opposite to read it)

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1493969.IcPi48psSL
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlhVHioACgkQi/DJPQPkQ1JlbACfc5QhZe47sOItnhCzjxNZiH6I
GAYAoMY+pQO/otAfzqeFcBCOxDiceLSn
=SGuA
-----END PGP SIGNATURE-----

--nextPart1493969.IcPi48psSL--
