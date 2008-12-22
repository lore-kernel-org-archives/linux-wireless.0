Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57316 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756073AbYLVVxB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Dec 2008 16:53:01 -0500
Subject: Re: [PATCH] mac80211: allow mode change if IBSS is not allowed
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>
In-Reply-To: <20081222213935.26129.4212.stgit@dv.roinet.com> (sfid-20081222_223953_952557_F52B06C5)
References: <20081222213935.26129.4212.stgit@dv.roinet.com>
	 (sfid-20081222_223953_952557_F52B06C5)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-d3rlgh8otXzaJK0tMTnv"
Date: Mon, 22 Dec 2008 22:52:58 +0100
Message-Id: <1229982778.3775.0.camel@johannes> (sfid-20081222_225310_922528_8AB17358)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-d3rlgh8otXzaJK0tMTnv
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-12-22 at 16:39 -0500, Pavel Roskin wrote:
> Changing mode on an interface is not allowed if IBSS is disabled for the
> current channel.  That restriction should only apply when switching to
> the ad-hoc mode, as it was prior to db17d8c4.
>=20
> Signed-off-by: Pavel Roskin <proski@gnu.org>

Thanks Pavel.

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  net/mac80211/iface.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>=20
> diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
> index 5abbc3f..b907482 100644
> --- a/net/mac80211/iface.c
> +++ b/net/mac80211/iface.c
> @@ -699,7 +699,8 @@ int ieee80211_if_change_type(struct ieee80211_sub_if_=
data *sdata,
>  		return 0;
> =20
>  	/* Setting ad-hoc mode on non-IBSS channel is not supported. */
> -	if (sdata->local->oper_channel->flags & IEEE80211_CHAN_NO_IBSS)
> +	if (sdata->local->oper_channel->flags & IEEE80211_CHAN_NO_IBSS &&
> +	    type =3D=3D NL80211_IFTYPE_ADHOC)
>  		return -EOPNOTSUPP;
> =20
>  	/*
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--=-d3rlgh8otXzaJK0tMTnv
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJUAw3AAoJEKVg1VMiehFY1wQP/2/Z7dwSUqE2yrLwQT+k01yA
5h6rkjDUQ+HASW4g3A/qHsg1VYJYec0e+MBwormiUcFRCx+1VFKOIx+23Z1qpVvf
q2HPIDU4m4b9PbsSGjm2htkrNEnvkGbFnu04a1dreu3tNANzKGEsuUR0B2zRQJRV
/8yVWbTk7WsfnAwc+09G/TFxiqYCxqoK4UhzW7/kE5GIKlTQG/fK+P1q3khc7DlK
5vqhtGHQXmUmUNmFbl5lFJjAvXZlSawRjXHs3zuELIw7uJYZ4Oskfkal6sfymdX1
UsVYvP1pMyr2ABtsQdGKR3vlRcxoRlVI/tx+8aEoCJ8rvSa0B9UVvSt52d/+oo31
0P5FusFBzEkM6eN7VN+tYyKoEoBsbgiAqhtlOjhyijvRpW4e6B3kMG12vH+QvbIC
5POzr7zVLilH2ET9hNMQoDWZMV9T8MJXabiKQ3I7uAt2tAmkkDVPXeqfltzs2pw0
UUEjOFUmi16NEls6YzR+1Vac2BZE7pVbYqxymDZKx5wcqaaOHWLQqo7G/2r1VfBm
epcf064sGyp56jkl4msDrb3SqZX9FZeG4BO7evbf38kQzdfor71UmM8f0eYIDv+6
8O1q4GK8EvrMLyD1AcJejqw1S5611HB1SKSyGGPlqgWsUS9gMeA3Q+PklxQwlZvV
8JPBJ382aodMOkfmXDH8
=5q2A
-----END PGP SIGNATURE-----

--=-d3rlgh8otXzaJK0tMTnv--

