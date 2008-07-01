Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55580 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427AbYGAIst (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2008 04:48:49 -0400
Subject: Re: [PATCH] mac80211: Don't request encryption for proble response
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200807011045.13870.IvDoorn@gmail.com> (sfid-20080701_104125_115903_99BF2B9C)
References: <200807011045.13870.IvDoorn@gmail.com>
	 (sfid-20080701_104125_115903_99BF2B9C)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-0YtHrfnhQqT53KIRiPYG"
Date: Tue, 01 Jul 2008 10:48:06 +0200
Message-Id: <1214902086.7763.13.camel@johannes.berg> (sfid-20080701_104852_871789_4EA6BD89)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-0YtHrfnhQqT53KIRiPYG
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-07-01 at 10:45 +0200, Ivo van Doorn wrote:
> Probe responses shouldn't be encrypted, and mac80211 doesn't
> set the crypto key accordingly. However it didn't set the
> IEEE80211_TX_CTL_DO_NOT_ENCRYPT flag which means drivers
> could make an attempt to encrypt it, and causing a NULL
> pointer dereference when accessing the provided hw_key field.
>=20
> Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index 7b4d4d4..fd28cd8 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -2531,6 +2531,7 @@ static int ieee80211_sta_join_ibss(struct net_devic=
e *dev,
>  			control->flags |=3D IEEE80211_TX_CTL_SHORT_PREAMBLE;
>  		control->antenna_sel_tx =3D local->hw.conf.antenna_sel_tx;
>  		control->flags |=3D IEEE80211_TX_CTL_NO_ACK;
> +		control->flags |=3D IEEE80211_TX_CTL_DO_NOT_ENCRYPT;
>  		control->control.retry_limit =3D 1;
> =20
>  		ifsta->probe_resp =3D skb_copy(skb, GFP_ATOMIC);
>=20

--=-0YtHrfnhQqT53KIRiPYG
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIae9CAAoJEKVg1VMiehFY8JYQAJzPA0n8gFuqTicqOH6YOvzT
x6fJIPPq64TzeZHMi9Wqc8rmDq2weKyoVoHueDcASQ6Yt7qQ/DLsEAV9V+3TdkoR
1dtwoTfCRqntl1G566dGNsYIyixUQAONcIx16oHwVXMbZdd1sHGZM+h5PiTglVxF
k5k7mLyOO5gvAkk4+wl0Frz5kI2GIcEYq25ptKFJ3oezGDGV6ojPsCNi8HJBbAfW
96zjQI0r+QI/vSNczxmrW9pPNJdh/Up0UOZ9/o8Jw80TWbIcKYMBff94iGlsSZqh
Pu1YEsGxINteL9NZyZJJ9SS6O0lTXanAZjZ/kl/IVaon5ulixusePszR/NXsfnoZ
ifyw1fj3C9gr/PHRUQi87Ayu6ExQZErMjOhw3z5LgM1NHctiGuXJkU0UXnbtPNGi
gXijR8INJLTAVoqiJTRVHjlAX7zCgk5SElipO6jpbxkj+Ps1/xsZKflXVnjdpa89
hOVNhnBqzcVb9a2XtWmYqU/p3/z21uQDokmVtsSzt7elnvGOd2W8giFIS8XUW1rr
cYIGInuNBO4vbcsVqx59QpePE8IzcXSvM6uKs7yTd5iULhYpHoHEU/nt+L2QLbQP
hGZ18QRN1hpEAS8CO5OfmXG3enoXE5H/LeCGPJsocx2+kl6DiWDN8qC5ofkt6SiM
OKVEs8nMYzzsbbPCHS7F
=RUyR
-----END PGP SIGNATURE-----

--=-0YtHrfnhQqT53KIRiPYG--

