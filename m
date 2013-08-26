Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gw90.de ([188.40.100.199]:60115 "EHLO mail.gw90.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751489Ab3HZUUZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Aug 2013 16:20:25 -0400
Message-ID: <1377548398.4408.4.camel@mattotaupa> (sfid-20130826_222028_340289_481C1226)
Subject: Re: [rt2x00-users] [PATCH 3.11] rt2800: fix wrong TX power
 compensation
From: Paul Menzel <paulepanter@users.sourceforge.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Fabien ADAM <id2ndr@crocobox.org>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Date: Mon, 26 Aug 2013 22:19:58 +0200
In-Reply-To: <20130826131851.GB10525@redhat.com>
References: <20130826131851.GB10525@redhat.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-bJA247uZy2sld7nEo5Dz"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-bJA247uZy2sld7nEo5Dz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Am Montag, den 26.08.2013, 15:18 +0200 schrieb Stanislaw Gruszka:
> We should not do temperature compensation on devices without
> EXTERNAL_TX_ALC bit set (called DynamicTxAgcControl on vendor driver).
> Such devices can have totally bogus TSSI parameters on the EEPROM,
> but still threaded by us as valid and result doing wrong TX power

=E2=80=A2 s,still threaded,are still treated,
=E2=80=A2 =E2=80=A6 and results in wrong TX power calculations.

> calculations.
>=20
> This fix inability to connect to AP on slightly longer distance on

=E2=80=A2 fixes

> some Ralink chips/devices.

Could you please add which ones you have tested?

Is there a bug report about this?

> Reported-and-tested-by: Fabien ADAM <id2ndr@crocobox.org>
> Cc: stable@vger.kernel.org
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/rt2x00/rt2800lib.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>=20
> John,
>=20
> If possible this should go to 3.11, -next & cc -stable is also fine as
> ususal.
>=20
> Note that in -next version of the patch rt2x00_eeprom_read() should
> be changed to rt2800_eeprom_read() do to commit
> 3e38d3daf881a78ac13e93504a8ac5777040797e
> =20
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wirele=
ss/rt2x00/rt2800lib.c
> index 1f80ea5..a0119d3 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -2790,6 +2790,13 @@ static int rt2800_get_gain_calibration_delta(struc=
t rt2x00_dev *rt2x00dev)
>  	int i;
> =20
>  	/*
> +	 * First check if temperature compensation is supported.
> +	 */
> +	rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC_CONF1, &eeprom);
> +	if (!rt2x00_get_field16(eeprom, EEPROM_NIC_CONF1_EXTERNAL_TX_ALC))
> +		return 0;
> +
> +	/*
>  	 * Read TSSI boundaries for temperature compensation from
>  	 * the EEPROM.
>  	 *

With the improvements to the commit message,

Acked-by: Paul Menzel <paulepanter@users.sourceforge.net>


Thanks,

Paul

--=-bJA247uZy2sld7nEo5Dz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iEYEABECAAYFAlIbuG8ACgkQPX1aK2wOHVjyPwCdGy/J9MkbNKf3Noq3GmGlOilX
F7kAn0PJc7MNhKpYD4m+SF5cbtGTNdaL
=BHRZ
-----END PGP SIGNATURE-----

--=-bJA247uZy2sld7nEo5Dz--

