Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60117 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932204AbXK3Lkp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Nov 2007 06:40:45 -0500
Subject: Re: [PATCH] mac80211: rate limit wep decrypt failed messages
From: Johannes Berg <johannes@sipsolutions.net>
To: Adel Gadllah <adel.gadllah@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <6cf6b73e0711290809q7c8a2050x6daf97b5eb954cbe@mail.gmail.com> (sfid-20071129_160947_895228_70E521FB)
References: <6cf6b73e0711290809q7c8a2050x6daf97b5eb954cbe@mail.gmail.com>
	 (sfid-20071129_160947_895228_70E521FB)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-mPvJUjDmwD75QL9uQyik"
Date: Fri, 30 Nov 2007 12:38:08 +0100
Message-Id: <1196422688.6058.183.camel@johannes.berg> (sfid-20071130_114048_359951_E0C5FDFD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-mPvJUjDmwD75QL9uQyik
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Thu, 2007-11-29 at 17:09 +0100, Adel Gadllah wrote:
> The attached patch rate limits "WEP decrypt failed (ICV)" to avoid
> flooding the logfiles.
>=20
> Signed-off-by: Adel Gadllah <adel.gadllah@gmx.net>

Acked-by: Johannes Berg <johannes@sipsolutions.net>
>=20
> diff --git a/net/mac80211/wep.c b/net/mac80211/wep.c
> index 9bf0e1c..b5f3413 100644
> --- a/net/mac80211/wep.c
> +++ b/net/mac80211/wep.c
> @@ -265,7 +265,8 @@ int ieee80211_wep_decrypt(struct ieee80211_local
> *local, struct sk_buff *skb,
>  	if (ieee80211_wep_decrypt_data(local->wep_rx_tfm, rc4key, klen,
>  				       skb->data + hdrlen + WEP_IV_LEN,
>  				       len)) {
> -		printk(KERN_DEBUG "WEP decrypt failed (ICV)\n");
> +		if (net_ratelimit())
> +			printk(KERN_DEBUG "WEP decrypt failed (ICV)\n");
>  		ret =3D -1;
>  	}
> -
>=20

--=-mPvJUjDmwD75QL9uQyik
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR0/2H6Vg1VMiehFYAQLNYg/8DsF3UiLWHrOFlbgytwZEYLkHCqfzmERk
uBMO2qUDxdNTlRRPDs1pzPMZ2gzQwibKRU4WkINafJVbYSPdVHaGdhMnVNke+5dZ
uFymaO0427XHTLOQHG8Slmhq4TA5F7i8fiet5LPQEuqogTI3UMdrzCEGkRxeuAIG
H0S/zeLQGQCCkj2SDNsk5FfCdzuTGxscoRbxiEzjvm+gPvD+RzJyHRSoB9WCaXDt
etf1xFYtK7Z9AtpCutQ5289QutsyaUITjfcTOGlHEAZNyioXOX6ngSR2CT/cdueC
aKvoP0Z7CMLXoklPkPcKFRw6qj2v8ZC35urXXhUnTcZmYIq+pd4N/sAcHaCs2722
zT6zDD/IiBfmcfajNnNJhI+FfvulSFqpzACSXYKpVDVb8+JpPi+qByDn0Wx3YNgy
B10gsw4OBh0e7p5WQRXPd5jyNQ1Pp7WAGLaHdCKim5iYkGYof9p14M+lX3Zz4Pdo
/vZl0kLNIXH9upQj+BHQhZKCA3GH7fOhTvPcfoMjCAojU8+J8v0U/Fh7J7Gkt0Oi
v3SaiQhwkrIhvrkl65zMxR0wD1TKqZI3xuPLKoSLtj8GV4EHbuzifh+wizORgNoH
C/HRhKKe7FHzS+WVrKfyfXCRdfJhPsdYeHGsuIpCAKVVKvyFgkqRXA5I54FXmEPL
r1bLAcHxkhs=
=q8nb
-----END PGP SIGNATURE-----

--=-mPvJUjDmwD75QL9uQyik--

