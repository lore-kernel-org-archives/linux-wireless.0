Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52895 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596AbZFPSff (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2009 14:35:35 -0400
Subject: Re: [PATCH] cfg80211: allow adding/deleting stations on mesh
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrey Yurovsky <andrey@cozybit.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <1245177064-31861-1-git-send-email-andrey@cozybit.com>
References: <1245177064-31861-1-git-send-email-andrey@cozybit.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-0y/gxLZ/w35qJOavAFmu"
Date: Tue, 16 Jun 2009 20:35:07 +0200
Message-Id: <1245177307.21287.34.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-0y/gxLZ/w35qJOavAFmu
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-06-16 at 11:31 -0700, Andrey Yurovsky wrote:
> Commit b2a151a288 added a check that prevents adding or deleting
> stations on non-AP interfaces.  Adding and deleting stations is
> supported for Mesh Point interfaces, so add Mesh Point to that check as
> well.

Why? Aren't those automatically discovered like IBSS peers?

johannes

> Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>
> ---
>  net/wireless/nl80211.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
>=20
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index e18856c..b28c641 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -1763,7 +1763,8 @@ static int nl80211_new_station(struct sk_buff *skb,=
 struct genl_info *info)
>  		goto out_rtnl;
> =20
>  	if (dev->ieee80211_ptr->iftype !=3D NL80211_IFTYPE_AP &&
> -	    dev->ieee80211_ptr->iftype !=3D NL80211_IFTYPE_AP_VLAN) {
> +	    dev->ieee80211_ptr->iftype !=3D NL80211_IFTYPE_AP_VLAN &&
> +	    dev->ieee80211_ptr->iftype !=3D NL80211_IFTYPE_MESH_POINT) {
>  		err =3D -EINVAL;
>  		goto out;
>  	}
> @@ -1812,7 +1813,8 @@ static int nl80211_del_station(struct sk_buff *skb,=
 struct genl_info *info)
>  		goto out_rtnl;
> =20
>  	if (dev->ieee80211_ptr->iftype !=3D NL80211_IFTYPE_AP &&
> -	    dev->ieee80211_ptr->iftype !=3D NL80211_IFTYPE_AP_VLAN) {
> +	    dev->ieee80211_ptr->iftype !=3D NL80211_IFTYPE_AP_VLAN &&
> +	    dev->ieee80211_ptr->iftype !=3D NL80211_IFTYPE_MESH_POINT) {
>  		err =3D -EINVAL;
>  		goto out;
>  	}

--=-0y/gxLZ/w35qJOavAFmu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKN+XYAAoJEODzc/N7+QmalBoQAMTf6bIvKcLf0+eoYFmMkfgF
tAY5kx3n8/TmLffN9VaZAr7Q3QR2LYh541dEyWTHZZx2gHcMa1O9tBMUT3ImCz8V
h4KEE9t7kjDf9lnVamk7jurjSI+/RGMEx71bs5YIZSQ+ORQL63Lby9bExeVN+Xp8
UsO0Ypgw+JrfewPmHOLvzEy9iIU5GduOEc6BNWPSh9ArFfb0YVH1GfL9Chv+bW1o
LAseZcPyTCOguNTS2EamD3Ci3kAhtQJDUNA5eS6h76SFE9KhRQocyEAJmzVjCnUr
tnDjHG/qPLsyIX9M+SZb8NwYpMXPWA6xcU4tjKeMwhpWoBUyb6qM36yB/Yu3RR1f
8j1+tcWeK3aBdg919geDfr8sWwoUPuqYhmJw3LOFMHasO1rUliu7eC3F6KHj9xvb
0Bv7JGOf81EASZlvSrIy9kxF/i7yO8L2O4/yFi6DtIIyXikJAtwYdh3+Ks20Lc9z
HDbr134hq1YzyTLshmEHSw+PEJv0Ug7b+RPoPPezhyQRme+UNgYLZOsrNKJmRKoI
ViJzcqYOoQlqlLtG+GciqSJ6wK851WC2iBZ61FhUeWx3IBc7zqn8fccDwsKV+TOu
DdNhFqs/d3VHZm2wOE7urKWWK0LnsKdE+iMtitsebXPEOydbC896AswlQy2FAOL5
nfjGIJrviPA23EWDSALu
=46oO
-----END PGP SIGNATURE-----

--=-0y/gxLZ/w35qJOavAFmu--

