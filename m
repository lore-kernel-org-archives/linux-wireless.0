Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gw90.de ([188.40.100.199]:49003 "EHLO mail.gw90.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753895Ab3JCJPE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Oct 2013 05:15:04 -0400
Message-ID: <1380789509.8125.6.camel@mattotaupa> (sfid-20131003_111509_402548_B6F144BD)
Subject: Re: [rt2x00-users] [PATCH 1/2] rt2x00: rt2800lib: remove
 TXMIXER_GAIN entries from the extended EEPROM map
From: Paul Menzel <paulepanter@users.sourceforge.net>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Date: Thu, 03 Oct 2013 10:38:29 +0200
In-Reply-To: <1380742914-22486-1-git-send-email-juhosg@openwrt.org>
References: <1380742914-22486-1-git-send-email-juhosg@openwrt.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-3WxOhD5TtncOSd+a5sGt"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-3WxOhD5TtncOSd+a5sGt
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dear Gabor,


thank you for the patch!


Am Mittwoch, den 02.10.2013, 21:41 +0200 schrieb Gabor Juhos:
> The comments are indicating the TXMIXER_GAIN_BG and
> the TXMIXED_GAIN_A entries are overlapping with the

(I think if you use =C2=BBthe=C2=AB twice, it is just singular =C2=BBentry=
=C2=AB.)

> RSSI_BG2 and RSSI_A2 entries in the extended EEPROM
> map. This is not correct, becuase the upper byte of

bec*au*se

> the RSSI_BG2 and RSSI_A2 entries are reserved. There
> are no TX mixer gain values are stored at all in the
> extended EEPROM.
>=20
> Remove the initialization of these entries from the
> extended EEPROM map to reflect this.
>=20
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
> ---
>  drivers/net/wireless/rt2x00/rt2800lib.c |    2 --
>  1 file changed, 2 deletions(-)
>=20
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wirele=
ss/rt2x00/rt2800lib.c
> index c706ddc..c979bb7 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -280,10 +280,8 @@ static const unsigned int rt2800_eeprom_map_ext[EEPR=
OM_WORD_COUNT] =3D {
>  	[EEPROM_RSSI_BG]		=3D 0x0028,
>  	[EEPROM_TXPOWER_DELTA]		=3D 0x0028, /* Overlaps with RSSI_BG */
>  	[EEPROM_RSSI_BG2]		=3D 0x0029,
> -	[EEPROM_TXMIXER_GAIN_BG]	=3D 0x0029, /* Overlaps with RSSI_BG2 */
>  	[EEPROM_RSSI_A]			=3D 0x002a,
>  	[EEPROM_RSSI_A2]		=3D 0x002b,
> -	[EEPROM_TXMIXER_GAIN_A]		=3D 0x002b, /* Overlaps with RSSI_A2 */
>  	[EEPROM_TXPOWER_BG1]		=3D 0x0030,
>  	[EEPROM_TXPOWER_BG2]		=3D 0x0037,
>  	[EEPROM_EXT_TXPOWER_BG3]	=3D 0x003e,

Do you know if this fixes any problems and should be backported to
stable? If any testing can be done on

        idVendor           0x148f Ralink Technology, Corp.
        idProduct          0x2870 RT2870 Wireless Adapter

please tell me.

With the fixes above,

Acked-by: Paul Menzel <paulepanter@users.sourceforge.net>


Thanks,

Paul

--=-3WxOhD5TtncOSd+a5sGt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iEYEABECAAYFAlJNLQYACgkQPX1aK2wOHVjuAACdEU1nB85jdHS3HnPwpxl6SpMu
N5UAniwjUkhe6bHBLTfBVMdChL2w7+IK
=dzQC
-----END PGP SIGNATURE-----

--=-3WxOhD5TtncOSd+a5sGt--

