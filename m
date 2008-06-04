Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39988 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbYFDGLY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2008 02:11:24 -0400
Subject: Re: [PATCH v2] mac80211: send association event on IBSS create
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, stable@kernel.org
In-Reply-To: <1212550795.11852.1.camel@localhost.localdomain> (sfid-20080604_054030_524076_8E1E3D1C)
References: <1212543981.4237.19.camel@localhost.localdomain>
	 <1212550795.11852.1.camel@localhost.localdomain>
	 (sfid-20080604_054030_524076_8E1E3D1C)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-gBwtGGH5zXNhlQWzAhRq"
Date: Wed, 04 Jun 2008 08:10:27 +0200
Message-Id: <1212559827.14371.9.camel@johannes.berg> (sfid-20080604_081128_403747_96C04887)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-gBwtGGH5zXNhlQWzAhRq
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-06-03 at 23:39 -0400, Dan Williams wrote:
> =EF=BB=BFOtherwise userspace has no idea the IBSS creation succeeded.
>=20
> Signed-off-by: Dan Williams <dcbw@redhat.com>

Looks ok to me, you're the wext expert :)

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> -------------
>=20
> John, please apply to 2.6.26 and later.
>=20
> Stable: applicable to 2.6.24 and 2.6.25 as well.  File used to be called
> net/mac80211/ieee80211_sta.c and diff should still apply with minor
> fixup to the second hunk.
>=20
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index c220bed..73c66e0 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -2348,6 +2348,7 @@ static int ieee80211_sta_join_ibss(struct net_devic=
e *dev,
>  	u8 *pos;
>  	struct ieee80211_sub_if_data *sdata;
>  	struct ieee80211_supported_band *sband;
> +	union iwreq_data wrqu;
> =20
>  	sband =3D local->hw.wiphy->bands[local->hw.conf.channel->band];
> =20
> @@ -2491,6 +2492,10 @@ static int ieee80211_sta_join_ibss(struct net_devi=
ce *dev,
>  	ifsta->state =3D IEEE80211_IBSS_JOINED;
>  	mod_timer(&ifsta->timer, jiffies + IEEE80211_IBSS_MERGE_INTERVAL);
> =20
> +	memset(&wrqu, 0, sizeof(wrqu));
> +	memcpy(wrqu.ap_addr.sa_data, bss->bssid, ETH_ALEN);
> +	wireless_send_event(dev, SIOCGIWAP, &wrqu, NULL);
> +
>  	return res;
>  }
> =20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--=-gBwtGGH5zXNhlQWzAhRq
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASEYx0qVg1VMiehFYAQJ4FRAAs3yvyMR31fD0xbNK30PIJXP9oZpraq1m
GFEq5NB4zwwIzxf//dKrRiHD00DZzeWhrnLeMNkOhYSJ6wS28bP/+M817uUjUWSC
tLjghcjo1W2iFnjjpdxgZUSAHQ0+yWSHirMvp9JZuJGm8jZqk0zDEzK3XGrMlOKI
2B/v5Dx7dKUzzflYAvnQQt3nSUJPrE5UivgNdbFMjcfJxv5ZkYSn+pMQ2kvNjJC0
pjvywIXwELxkY7QJ2BqYQKxK1o4n+5dhd+EnW/sWmrFJPC2ZMURIT7/I04T2ddZN
3dHeLt/sKBWN9OUa6pxmQqDUS3X+uTM+tp/zVzT/xN77/dftHEBMMAQ/WNLqLKAp
gBZKA0F3rqxmvwZHuQh+MQlxZ+EEozfzFL3ssJ4njy3U2Ej3kSVpxpMvvh5gQQND
uDAxMFV7JMZlCx82cpPSehEuTIJuDIGD3ysNh42QBamc2knZsJolIgpW3ms475fp
qQWv2iU23Kr2DfJWOlXbB2/mqayN/wdFlxHFUXrkB1BpQF5FSOoM4jXLkpXiUWoM
s3FghdO0rMm+2p2epDHOsskZxgkDDW1RoctSDBQIAaq0oRfIvT0zqLVMffLEX9G5
c/eIr5+jPv4LbDjP/lUjrF5ePS3IDStmjUBo+idUrmz/sRP2C8YYPTikpdSBUaX8
5M9Dk5bWt9Q=
=srZP
-----END PGP SIGNATURE-----

--=-gBwtGGH5zXNhlQWzAhRq--

