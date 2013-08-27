Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gw90.de ([188.40.100.199]:33666 "EHLO mail.gw90.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752924Ab3H0I0S (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Aug 2013 04:26:18 -0400
Message-ID: <1377591967.5019.25.camel@mattotaupa> (sfid-20130827_102623_500236_EBF53DE7)
Subject: Re: [rt2x00-users] [PATCH 3.11 v2] rt2800: fix wrong TX power
 compensation
From: Paul Menzel <paulepanter@users.sourceforge.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Fabien ADAM <id2ndr@crocobox.org>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Date: Tue, 27 Aug 2013 10:26:07 +0200
In-Reply-To: <20130827081340.GB2609@redhat.com>
References: <20130826131851.GB10525@redhat.com>
	 <1377548398.4408.4.camel@mattotaupa> <20130827080001.GA2609@redhat.com>
	 <20130827081340.GB2609@redhat.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-UxVXq/LPRpA0O78bpFpZ"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-UxVXq/LPRpA0O78bpFpZ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dear Stanislaw,


thank you for the updated patch. One last suggestion inline.


Am Dienstag, den 27.08.2013, 10:13 +0200 schrieb Stanislaw Gruszka:
> We should not do temperature compensation on devices without
> EXTERNAL_TX_ALC bit set (called DynamicTxAgcControl on vendor driver).
> Such devices can have totally bogus TSSI parameters on the EEPROM,
> but are still treated by us as valid and results in wrong TX power
> calculations.
>=20
> This fixes inability to connect to AP on slightly longer distance on
> some Ralink chips/devices without EXTERNAL_TX_ALC configured.
>=20
> Reference:
> http://thread.gmane.org/gmane.linux.drivers.rt2x00.user/2263
>=20
> Reported-and-tested-by: Fabien ADAM <id2ndr@crocobox.org>
> Cc: stable@vger.kernel.org
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
> Acked-by: Paul Menzel <paulepanter@users.sourceforge.net>
> ---
>  drivers/net/wireless/rt2x00/rt2800lib.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>=20
> v1 -> v2: fix changelog
>=20
> John,
>=20
> If possible this should go to 3.11, -next & cc -stable is also fine as
> usual.
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

Could a (debug) message be printed that temperature compensations is not
supported? Not sure if that should be done in the library or the code
calling this function.

> +
> +	/*
>  	 * Read TSSI boundaries for temperature compensation from
>  	 * the EEPROM.
>  	 *

Thanks,

Paul

--=-UxVXq/LPRpA0O78bpFpZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iEYEABECAAYFAlIcYp8ACgkQPX1aK2wOHViE/wCfYAZd+DaJ+qJJMZSbGv+MQKpV
DkgAn08pNwA++DvZeUUZmlYj6GmqKmaX
=eKpq
-----END PGP SIGNATURE-----

--=-UxVXq/LPRpA0O78bpFpZ--

