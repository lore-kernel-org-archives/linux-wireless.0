Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58426 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753306AbYJ3Lpk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 07:45:40 -0400
Subject: Re: [PATCH 08/10] ath9k: add block braces to match indentation
From: Johannes Berg <johannes@sipsolutions.net>
To: Ilpo =?ISO-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
Cc: linville@tuxdriver.com, lrodriguez@atheros.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0810301339550.7072@wrl-59.cs.helsinki.fi> (sfid-20081030_124200_919823_8E5E3369)
References: <Pine.LNX.4.64.0810301307160.7072@wrl-59.cs.helsinki.fi>
	 <Pine.LNX.4.64.0810301339550.7072@wrl-59.cs.helsinki.fi>
	 (sfid-20081030_124200_919823_8E5E3369)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-rKMt9PhQhkcVWnqTD5j/"
Date: Thu, 30 Oct 2008 12:45:29 +0100
Message-Id: <1225367129.3690.40.camel@johannes.berg> (sfid-20081030_124542_456042_D73A3D40)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-rKMt9PhQhkcVWnqTD5j/
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-10-30 at 13:41 +0200, Ilpo J=C3=A4rvinen wrote:
> This isn't a behavior problem as is, and fixing indentation
> inconsistency either way would be fine (reindent or braces).
>=20
> Signed-off-by: Ilpo J=C3=A4rvinen <ilpo.jarvinen@helsinki.fi>
> ---
>  drivers/net/wireless/ath9k/main.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath=
9k/main.c
> index f05f584..0f67b1b 100644
> --- a/drivers/net/wireless/ath9k/main.c
> +++ b/drivers/net/wireless/ath9k/main.c
> @@ -467,9 +467,10 @@ void ath_tx_complete(struct ath_softc *sc, struct sk=
_buff *skb,
>  	if (tx_info->flags & IEEE80211_TX_CTL_NO_ACK ||
>  		tx_info->flags & IEEE80211_TX_STAT_TX_FILTERED) {
>  		/* free driver's private data area of tx_info */
> -		if (tx_info->driver_data[0] !=3D NULL)
> +		if (tx_info->driver_data[0] !=3D NULL) {
>  			kfree(tx_info->driver_data[0]);
>  			tx_info->driver_data[0] =3D NULL;
> +		}

Since kfree(NULL) is fine, how about just removing the if? Also, this
code has been removed in a recent change in the wireless tree, I think
(the rate control revamp)

johannes

--=-rKMt9PhQhkcVWnqTD5j/
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJCZ5VAAoJEKVg1VMiehFY/RcP/0W6APCTcoX6agnitGuRrcPT
oNwqRsgyEdfghluckisF9Zf40YQDJ0wKAzoufdyqkZY6ydJxh8u7IxEy7UlKeJdJ
3bWVcYMAexVWQLmUCZM3t5wKDSu+SFLLIFMIMlhQZb495SQy5IAUpVQhjHHpadxi
tXORCG/p5BZKJDS5nwSBPojM04IvFbLq5Hvphw2c+QMxf7+iUBYgAIJbU2PPqRre
cmnXIpR25Xji5i26ftFC4/gT0ljOeqqruySltcXX+sDdjWGwuROh/tVk5/EHAkWC
SwKVwaVnzx5VNp2tcSMzF01H2Ilj3lIG4gXPeDb4Piq8aUEvFyIoVLKGlJ/9Fo+b
ByY/2ssjNdDGr/b592m6RYwkygEZt9egYg5zKUCutNpfqeCI0aIWoThsFMNgCzle
hCTSaFq5Kh7ifu8fAS9PgkZGSLusWMWWhyWqybVcW6/BKLdNKxCqt/tcABZhu4bi
8VjvLGP6oNLJB+cbh/6oi4ZuQVXAZX1AxQJDXCt6WVABZVTgszcL+3kmvkg6Stn+
/WuzzRYxyVSWr3iuFVJsaFxdlxxJHtbEHYS6pw1T4CrnyqUlZFhT3lSVj/QVS9Vg
Q5JllKdIExXiFWvAgN16VWSnLAUMtyTcQBHj5FYSnlb5rxm3Eh3PZ9EFuRXbYDn0
cn/4POqMMOzHihKZsxOj
=xZsA
-----END PGP SIGNATURE-----

--=-rKMt9PhQhkcVWnqTD5j/--

