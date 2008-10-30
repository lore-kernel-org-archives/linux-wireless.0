Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41543 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588AbYJ3Ko7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 06:44:59 -0400
Subject: Re: [PATCH 3/4] mac80211_hwsim: Debug info for TX queue parameters
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20081029175254.540859084@localhost>
References: <20081029174934.817700763@localhost>
	 <20081029175254.540859084@localhost>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-10r+Kd714G3Ha9cGcCm4"
Date: Thu, 30 Oct 2008 11:44:55 +0100
Message-Id: <1225363495.3690.21.camel@johannes.berg> (sfid-20081030_114506_724716_A205EFC0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-10r+Kd714G3Ha9cGcCm4
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-10-29 at 19:49 +0200, Jouni Malinen wrote:
> plain text document attachment (hwsim_tx_conf.patch)
> Provide detailed information on TX queue parameter changes to make it
> easier to debug mac80211 functionality.
>=20
> Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> Index: wireless-testing/drivers/net/wireless/mac80211_hwsim.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- wireless-testing.orig/drivers/net/wireless/mac80211_hwsim.c	2008-10-2=
9 13:27:50.000000000 +0200
> +++ wireless-testing/drivers/net/wireless/mac80211_hwsim.c	2008-10-29 13:=
36:20.000000000 +0200
> @@ -468,6 +468,17 @@
>  	return 0;
>  }
> =20
> +static int mac80211_hwsim_conf_tx(
> +	struct ieee80211_hw *hw, u16 queue,
> +	const struct ieee80211_tx_queue_params *params)
> +{
> +	printk(KERN_DEBUG "%s:%s (queue=3D%d txop=3D%d cw_min=3D%d cw_max=3D%d =
"
> +	       "aifs=3D%d)\n",
> +	       wiphy_name(hw->wiphy), __func__, queue,
> +	       params->txop, params->cw_min, params->cw_max, params->aifs);
> +	return 0;
> +}
> +
>  static const struct ieee80211_ops mac80211_hwsim_ops =3D
>  {
>  	.tx =3D mac80211_hwsim_tx,
> @@ -481,6 +492,7 @@
>  	.bss_info_changed =3D mac80211_hwsim_bss_info_changed,
>  	.sta_notify =3D mac80211_hwsim_sta_notify,
>  	.set_tim =3D mac80211_hwsim_set_tim,
> +	.conf_tx =3D mac80211_hwsim_conf_tx,
>  };
> =20
>=20
>=20
> --
>=20

--=-10r+Kd714G3Ha9cGcCm4
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJCZAiAAoJEKVg1VMiehFY5GsQAMGOeoaGPB6ByLUVkT3hUW3X
WebHSqCwH+NtDptOjHpcgwGlqSmcllEGPfOAl9xWiT5gP8vwlM+Ik4nqRAEmx1JI
L+YNKtrehPTRN//EZ1Dy1UcUvm6ruEqf5O7lzOgD5T8NlTPM5KZGVVJ6IS3Dg/lb
yF+6SHtmftEk98Iu4vXoI36tWCBOIq1xLcn2oUYaIO/ySAqGGyKA+M+FE7FTlyiw
Erlvfq3g17BL2vdQYc9zJDK9tUQN5asCIQ4UnV4I4Xf+042wmQgWThuVWZQ/zbS5
EApLj32+SrxsvuX3X+TXrD0I3lFx3O1gvMUKC2ZS3gQwVM9Lbsi2x83C59gzXNUb
1xsZNBt0x0EQdIvcm45z9ZQyfugSfHI+USTIlXtstKZ7fhHneNzGIIHbY6DvBDTx
3E9308fYfKXqgkSScdhs7xhMhezVeXHzu/zbr4xb4L3/0hbqxBUGUP1lYbCdlL1F
O9pUhh3iOHZsQu9Fgpp5uS3qfmVLDnEPLUnWGqdonV//BSGpaeoi2hRy49XbJhFe
jWK5Jr7OhS33OHT60Sx3Wy+QOgckgD2R1OltlJDh9g9MePdIbWRIpuldwWNoSxcS
GSPKGH4Ce0eqUNqsUycQ88AFHyJrSWaevK63MF1oEhlUgxO/h22h8ap9cpTALKg1
wGlAvGfKWtW+Dj7HtoU8
=f8CV
-----END PGP SIGNATURE-----

--=-10r+Kd714G3Ha9cGcCm4--

