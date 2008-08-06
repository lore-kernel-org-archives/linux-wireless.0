Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50437 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761713AbYHFM04 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Aug 2008 08:26:56 -0400
Subject: Re: [PATCH] mac80211: keep mesh ifaces in allmulti mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <4899975a.2135440a.05a6.3c34@mx.google.com> (sfid-20080806_142148_316320_D8214475)
References: <4899975a.2135440a.05a6.3c34@mx.google.com>
	 (sfid-20080806_142148_316320_D8214475)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-hbQX4F5Rloq8tSskVnan"
Date: Wed, 06 Aug 2008 14:26:20 +0200
Message-Id: <1218025580.23048.2.camel@johannes.berg> (sfid-20080806_142659_674306_11012168)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-hbQX4F5Rloq8tSskVnan
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-08-06 at 13:17 +0200, Luis Carlos Cobo wrote:
> Currently a mesh node will not forward a multicast frame if it is not sub=
scribed
> to the specific multicast address. This patch addresses the issue and fix=
es mesh
> multicast forwarding.
>=20
> Signed-off-by: Luis Carlos Cobo <luisca@cozybit.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  net/mac80211/main.c |    8 +++++++-
>  1 files changed, 7 insertions(+), 1 deletions(-)
>=20
> diff --git a/net/mac80211/main.c b/net/mac80211/main.c
> index 0c02c47..aa5a191 100644
> --- a/net/mac80211/main.c
> +++ b/net/mac80211/main.c
> @@ -245,10 +245,13 @@ static int ieee80211_open(struct net_device *dev)
>  	case IEEE80211_IF_TYPE_AP:
>  		sdata->bss =3D &sdata->u.ap;
>  		break;
> +	case IEEE80211_IF_TYPE_MESH_POINT:
> +		/* mesh ifaces must set allmulti to forward mcast traffic */
> +		atomic_inc(&local->iff_allmultis);
> +		break;
>  	case IEEE80211_IF_TYPE_STA:
>  	case IEEE80211_IF_TYPE_MNTR:
>  	case IEEE80211_IF_TYPE_IBSS:
> -	case IEEE80211_IF_TYPE_MESH_POINT:
>  		/* no special treatment */
>  		break;
>  	case IEEE80211_IF_TYPE_INVALID:
> @@ -495,6 +498,9 @@ static int ieee80211_stop(struct net_device *dev)
>  		netif_addr_unlock_bh(local->mdev);
>  		break;
>  	case IEEE80211_IF_TYPE_MESH_POINT:
> +		/* allmulti is always set on mesh ifaces */
> +		atomic_dec(&local->iff_allmultis);
> +		/* fall through */
>  	case IEEE80211_IF_TYPE_STA:
>  	case IEEE80211_IF_TYPE_IBSS:
>  		sdata->u.sta.state =3D IEEE80211_DISABLED;

--=-hbQX4F5Rloq8tSskVnan
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJImZhpAAoJEKVg1VMiehFYk5UP/0EunoqDTTSjtKedOsz0/Zzj
CfHaul8vFHLNCmZKVc13zHKJR7qZ00J/TZv7Vzugs+yrNDrQ6bJUE7tuNyHcrtXv
3ypCmhTXyc04VI1NRgkAmvoD3zKEXW6Jzxm44VdNJR7YZRtrIADIJyQdx0UDYulv
hUPeFSPnQ82F1fKBAnXl3zUZsiXhCu9ZDMUemEQNnz91Eq28N8KlTmF9uPQoob/x
edprOdGN4r4qBgrn9Ujfwzk1ZC0R0eQ/WPtEDalF+3L2b6ThtzhDyz+6UKCLT42j
lOG4IfpQ+hLFIzbtrSwZftUnj0OXlFkfvYOGYBMq6uba9czoej4CRmwtE8Hsb9N6
2syVTO5vctpIgxrFwZohsFivJShRLYjtRLqomBXyfoiwEMMqmkfp/WLPfSqnH9C4
W1Ek9OhlwsIuJcu/evbxLfOrrMibiloDYzA8V+hltPhZf1iAQkmc1JYPYog0N4lf
lP1IXzLnXUy3q79mSDYdFvVJPb2eoaIBIUTqIkfn4n5pJVt0jXpgszlEqW9vDDJb
qGd/KJPZ08bwEZjYWTKwLbx+kG2efmp9qASODANerqoJyTbgd3w39T43LwWq78XA
w16tXNTFU80TBjBfu4V+dUqtwceRgEruNloqIyaOe93pXhDVEzDVS+3+lJy1e/UF
jwo5e0ecetG9SrDfkgFF
=OADl
-----END PGP SIGNATURE-----

--=-hbQX4F5Rloq8tSskVnan--

