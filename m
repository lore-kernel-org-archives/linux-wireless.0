Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54044 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762221AbYESPGz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2008 11:06:55 -0400
Subject: Re: [PATCHv4] mac80211: fix NULL pointer dereference in
	ieee80211_compatible_rates
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <hschaa@suse.de>
Cc: John Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200805191659.43961.hschaa@suse.de>
References: <200805191659.43961.hschaa@suse.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-YRQDN+aeg3wUyoQ2kp6+"
Date: Mon, 19 May 2008 17:05:18 +0200
Message-Id: <1211209518.6252.49.camel@johannes.berg> (sfid-20080519_170734_672271_74439C88)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-YRQDN+aeg3wUyoQ2kp6+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-05-19 at 16:59 +0200, Helmut Schaa wrote:
> Fix a possible NULL pointer dereference in ieee80211_compatible_rates=20
> introduced in the patch "mac80211: fix association with some APs". If no =
bss
> is available just use all supported rates in the association request.
>=20
> Signed-off-by: Helmut Schaa <hschaa@suse.de>

Thanks.
Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>=20
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index 76ad4ed..7aff784 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -722,6 +722,15 @@ static void ieee80211_send_assoc(struct net_device *=
dev,
>  		if (bss->wmm_ie)
>  			wmm =3D 1;
>  		ieee80211_rx_bss_put(dev, bss);
> +
> +		/* get all rates supported by the device and the AP as
> +		 * some APs don't like getting a superset of their rates
> +		 * in the association request (e.g. D-Link DAP 1353 in
> +		 * b-only mode) */
> +		rates_len =3D ieee80211_compatible_rates(bss, sband, &rates);
> +	} else {
> +		rates =3D ~0;
> +		rates_len =3D sband->n_bitrates;
>  	}
> =20
>  	mgmt =3D (struct ieee80211_mgmt *) skb_put(skb, 24);
> @@ -752,10 +761,7 @@ static void ieee80211_send_assoc(struct net_device *=
dev,
>  	*pos++ =3D ifsta->ssid_len;
>  	memcpy(pos, ifsta->ssid, ifsta->ssid_len);
> =20
> -	/* all supported rates should be added here but some APs
> -	 * (e.g. D-Link DAP 1353 in b-only mode) don't like that
> -	 * Therefore only add rates the AP supports */
> -	rates_len =3D ieee80211_compatible_rates(bss, sband, &rates);
> +	/* add all rates which were marked to be used above */
>  	supp_rates_len =3D rates_len;
>  	if (supp_rates_len > 8)
>  		supp_rates_len =3D 8;
>=20

--=-YRQDN+aeg3wUyoQ2kp6+
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASDGXLaVg1VMiehFYAQKicQ/+OjCD/RH45ZEw59ZHUy65NQ1BUTzvuRIs
g3A/nxg5UdWUeEDDBBZlK5gf1LWbMDmDX5uKQWYOOmtxLolYzM45EUiMlENRbB8P
Zb/otK6laDUPApmERwzTY4W86OERh/Zv3GxCwM4ClMLriYgIZIQTLAWnruABnTP8
rkLYfdn0geFFWcGYca7VSXJuDmAkgJyaz5sMxGPezk2erJcC6fi0q44V2v0srp3z
POrwMNAljEz2JT9NKS6wKSgrNtxE3tNU0qxKz4rzGX5u7zknvMXFhVIeE3AZnogs
n7Y+4CW5Wedg9g2qWZs3IqsRwyY1ONYruP+ExYhu2r16Py43vbI3FfZmZ/HJ3iLa
TBLX74jAqLYh7LnU7GQF26WP+wy2PojM1r2pk7Zw7hlwn5yV0snObpw8MJHNvsPM
Eu8BPuD4JtOHyX2ClWxMwJlT5I91OkqGSIHdlP749Goif/EXHnbw2qnL85vblALS
cWVi/ChpyLnIdVGIZop+nUhRjwBJbmy4RF5Xy+EjC/UipIxQYvS1yPYziZSkZy9p
1GYK4cl88Ba1Flfnv0bZvAonNLejk2k0c46IiUzqJfg8xaINqyj55vr6vBozY0if
Bm1j1QXzybID9+7AIBC9UxmB4fizHAWOXRy2CBSBPwYCrEDAfZtUWyrJr4r2ek7O
8qI4g1U0GnU=
=HKIO
-----END PGP SIGNATURE-----

--=-YRQDN+aeg3wUyoQ2kp6+--

