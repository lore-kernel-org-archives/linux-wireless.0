Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48502 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495AbZCUIGy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Mar 2009 04:06:54 -0400
Subject: Re: [PATCH 4/4] nl80211: Check iftype in cfg80211 code
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni.malinen@atheros.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20090320192402.149900539@atheros.com>
References: <20090320192115.448175935@atheros.com>
	 <20090320192402.149900539@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-oIwDAKy281gek7pYWZ2w"
Date: Sat, 21 Mar 2009 09:06:48 +0100
Message-Id: <1237622808.5100.167.camel@johannes.local> (sfid-20090321_090659_752768_1312C169)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-oIwDAKy281gek7pYWZ2w
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-03-20 at 21:21 +0200, Jouni Malinen wrote:
> plain text document attachment (nl80211-check-iftype.patch)
> We do not want to require all the drivers using cfg80211 to need to do
> this. In addition, make the error values consistent by using
> EOPNOTSUPP instead of semi-random assortment of errno values.
>=20
> Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

Great, thanks.

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  net/mac80211/cfg.c     |   40 ----------------------------
>  net/wireless/nl80211.c |   68 ++++++++++++++++++++++++++++++++++++++++++=
+++++--
>  2 files changed, 66 insertions(+), 42 deletions(-)
>=20
> --- uml.orig/net/mac80211/cfg.c	2009-03-20 18:03:59.000000000 +0200
> +++ uml/net/mac80211/cfg.c	2009-03-20 18:04:01.000000000 +0200
> @@ -540,9 +540,6 @@ static int ieee80211_add_beacon(struct w
> =20
>  	sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
> =20
> -	if (sdata->vif.type !=3D NL80211_IFTYPE_AP)
> -		return -EINVAL;
> -
>  	old =3D sdata->u.ap.beacon;
> =20
>  	if (old)
> @@ -559,9 +556,6 @@ static int ieee80211_set_beacon(struct w
> =20
>  	sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
> =20
> -	if (sdata->vif.type !=3D NL80211_IFTYPE_AP)
> -		return -EINVAL;
> -
>  	old =3D sdata->u.ap.beacon;
> =20
>  	if (!old)
> @@ -577,9 +571,6 @@ static int ieee80211_del_beacon(struct w
> =20
>  	sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
> =20
> -	if (sdata->vif.type !=3D NL80211_IFTYPE_AP)
> -		return -EINVAL;
> -
>  	old =3D sdata->u.ap.beacon;
> =20
>  	if (!old)
> @@ -858,9 +849,6 @@ static int ieee80211_add_mpath(struct wi
> =20
>  	sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
> =20
> -	if (sdata->vif.type !=3D NL80211_IFTYPE_MESH_POINT)
> -		return -ENOTSUPP;
> -
>  	rcu_read_lock();
>  	sta =3D sta_info_get(local, next_hop);
>  	if (!sta) {
> @@ -908,9 +896,6 @@ static int ieee80211_change_mpath(struct
> =20
>  	sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
> =20
> -	if (sdata->vif.type !=3D NL80211_IFTYPE_MESH_POINT)
> -		return -ENOTSUPP;
> -
>  	rcu_read_lock();
> =20
>  	sta =3D sta_info_get(local, next_hop);
> @@ -979,9 +964,6 @@ static int ieee80211_get_mpath(struct wi
> =20
>  	sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
> =20
> -	if (sdata->vif.type !=3D NL80211_IFTYPE_MESH_POINT)
> -		return -ENOTSUPP;
> -
>  	rcu_read_lock();
>  	mpath =3D mesh_path_lookup(dst, sdata);
>  	if (!mpath) {
> @@ -1003,9 +985,6 @@ static int ieee80211_dump_mpath(struct w
> =20
>  	sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
> =20
> -	if (sdata->vif.type !=3D NL80211_IFTYPE_MESH_POINT)
> -		return -ENOTSUPP;
> -
>  	rcu_read_lock();
>  	mpath =3D mesh_path_lookup_by_idx(idx, sdata);
>  	if (!mpath) {
> @@ -1025,8 +1004,6 @@ static int ieee80211_get_mesh_params(str
>  	struct ieee80211_sub_if_data *sdata;
>  	sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
> =20
> -	if (sdata->vif.type !=3D NL80211_IFTYPE_MESH_POINT)
> -		return -ENOTSUPP;
>  	memcpy(conf, &(sdata->u.mesh.mshcfg), sizeof(struct mesh_config));
>  	return 0;
>  }
> @@ -1044,9 +1021,6 @@ static int ieee80211_set_mesh_params(str
>  	struct ieee80211_sub_if_data *sdata;
>  	sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
> =20
> -	if (sdata->vif.type !=3D NL80211_IFTYPE_MESH_POINT)
> -		return -ENOTSUPP;
> -
>  	/* Set the config options which we are interested in setting */
>  	conf =3D &(sdata->u.mesh.mshcfg);
>  	if (_chg_mesh_attr(NL80211_MESHCONF_RETRY_TIMEOUT, mask))
> @@ -1094,9 +1068,6 @@ static int ieee80211_change_bss(struct w
> =20
>  	sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
> =20
> -	if (sdata->vif.type !=3D NL80211_IFTYPE_AP)
> -		return -EINVAL;
> -
>  	if (params->use_cts_prot >=3D 0) {
>  		sdata->vif.bss_conf.use_cts_prot =3D params->use_cts_prot;
>  		changed |=3D BSS_CHANGED_ERP_CTS_PROT;
> @@ -1209,9 +1180,6 @@ static int ieee80211_auth(struct wiphy *
> =20
>  	sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
> =20
> -	if (sdata->vif.type !=3D NL80211_IFTYPE_STATION)
> -		return -EOPNOTSUPP;
> -
>  	switch (req->auth_type) {
>  	case NL80211_AUTHTYPE_OPEN_SYSTEM:
>  		sdata->u.mgd.auth_algs =3D IEEE80211_AUTH_ALG_OPEN;
> @@ -1268,9 +1236,6 @@ static int ieee80211_assoc(struct wiphy=20
> =20
>  	sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
> =20
> -	if (sdata->vif.type !=3D NL80211_IFTYPE_STATION)
> -		return -EOPNOTSUPP;
> -
>  	if (memcmp(sdata->u.mgd.bssid, req->peer_addr, ETH_ALEN) !=3D 0 ||
>  	    !(sdata->u.mgd.flags & IEEE80211_STA_AUTHENTICATED))
>  		return -ENOLINK; /* not authenticated */
> @@ -1305,8 +1270,6 @@ static int ieee80211_deauth(struct wiphy
>  	struct ieee80211_sub_if_data *sdata;
> =20
>  	sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
> -	if (sdata->vif.type !=3D NL80211_IFTYPE_STATION)
> -		return -EOPNOTSUPP;
> =20
>  	/* TODO: req->ie */
>  	return ieee80211_sta_deauthenticate(sdata, req->reason_code);
> @@ -1319,9 +1282,6 @@ static int ieee80211_disassoc(struct wip
> =20
>  	sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
> =20
> -	if (sdata->vif.type !=3D NL80211_IFTYPE_STATION)
> -		return -EOPNOTSUPP;
> -
>  	/* TODO: req->ie */
>  	return ieee80211_sta_disassociate(sdata, req->reason_code);
>  }
> --- uml.orig/net/wireless/nl80211.c	2009-03-20 18:03:59.000000000 +0200
> +++ uml/net/wireless/nl80211.c	2009-03-20 21:16:18.000000000 +0200
> @@ -1049,6 +1049,11 @@ static int nl80211_addset_beacon(struct=20
>  	if (err)
>  		goto unlock_rtnl;
> =20
> +	if (dev->ieee80211_ptr->iftype !=3D NL80211_IFTYPE_AP) {
> +		err =3D -EOPNOTSUPP;
> +		goto out;
> +	}
> +
>  	switch (info->genlhdr->cmd) {
>  	case NL80211_CMD_NEW_BEACON:
>  		/* these are required for NEW_BEACON */
> @@ -1136,6 +1141,10 @@ static int nl80211_del_beacon(struct sk_
>  		goto out;
>  	}
> =20
> +	if (dev->ieee80211_ptr->iftype !=3D NL80211_IFTYPE_AP) {
> +		err =3D -EOPNOTSUPP;
> +		goto out;
> +	}
>  	err =3D drv->ops->del_beacon(&drv->wiphy, dev);
> =20
>   out:
> @@ -1324,7 +1333,7 @@ static int nl80211_dump_station(struct s
>  	}
> =20
>  	if (!dev->ops->dump_station) {
> -		err =3D -ENOSYS;
> +		err =3D -EOPNOTSUPP;
>  		goto out_err;
>  	}
> =20
> @@ -1698,10 +1707,15 @@ static int nl80211_dump_mpath(struct sk_
>  	}
> =20
>  	if (!dev->ops->dump_mpath) {
> -		err =3D -ENOSYS;
> +		err =3D -EOPNOTSUPP;
>  		goto out_err;
>  	}
> =20
> +	if (netdev->ieee80211_ptr->iftype !=3D NL80211_IFTYPE_MESH_POINT) {
> +		err =3D -EOPNOTSUPP;
> +		goto out;
> +	}
> +
>  	while (1) {
>  		err =3D dev->ops->dump_mpath(&dev->wiphy, netdev, path_idx,
>  					   dst, next_hop, &pinfo);
> @@ -1759,6 +1773,11 @@ static int nl80211_get_mpath(struct sk_b
>  		goto out;
>  	}
> =20
> +	if (dev->ieee80211_ptr->iftype !=3D NL80211_IFTYPE_MESH_POINT) {
> +		err =3D -EOPNOTSUPP;
> +		goto out;
> +	}
> +
>  	err =3D drv->ops->get_mpath(&drv->wiphy, dev, dst, next_hop, &pinfo);
>  	if (err)
>  		goto out;
> @@ -1813,6 +1832,11 @@ static int nl80211_set_mpath(struct sk_b
>  		goto out;
>  	}
> =20
> +	if (dev->ieee80211_ptr->iftype !=3D NL80211_IFTYPE_MESH_POINT) {
> +		err =3D -EOPNOTSUPP;
> +		goto out;
> +	}
> +
>  	if (!netif_running(dev)) {
>  		err =3D -ENETDOWN;
>  		goto out;
> @@ -1856,6 +1880,11 @@ static int nl80211_new_mpath(struct sk_b
>  		goto out;
>  	}
> =20
> +	if (dev->ieee80211_ptr->iftype !=3D NL80211_IFTYPE_MESH_POINT) {
> +		err =3D -EOPNOTSUPP;
> +		goto out;
> +	}
> +
>  	if (!netif_running(dev)) {
>  		err =3D -ENETDOWN;
>  		goto out;
> @@ -1944,6 +1973,11 @@ static int nl80211_set_bss(struct sk_buf
>  		goto out;
>  	}
> =20
> +	if (dev->ieee80211_ptr->iftype !=3D NL80211_IFTYPE_AP) {
> +		err =3D -EOPNOTSUPP;
> +		goto out;
> +	}
> +
>  	err =3D drv->ops->change_bss(&drv->wiphy, dev, &params);
> =20
>   out:
> @@ -2058,6 +2092,11 @@ static int nl80211_get_mesh_params(struc
>  		goto out;
>  	}
> =20
> +	if (dev->ieee80211_ptr->iftype !=3D NL80211_IFTYPE_MESH_POINT) {
> +		err =3D -EOPNOTSUPP;
> +		goto out;
> +	}
> +
>  	/* Get the mesh params */
>  	err =3D drv->ops->get_mesh_params(&drv->wiphy, dev, &cur_params);
>  	if (err)
> @@ -2175,6 +2214,11 @@ static int nl80211_set_mesh_params(struc
>  		goto out;
>  	}
> =20
> +	if (dev->ieee80211_ptr->iftype !=3D NL80211_IFTYPE_MESH_POINT) {
> +		err =3D -EOPNOTSUPP;
> +		goto out;
> +	}
> +
>  	/* This makes sure that there aren't more than 32 mesh config
>  	 * parameters (otherwise our bitfield scheme would not work.) */
>  	BUILD_BUG_ON(NL80211_MESHCONF_ATTR_MAX > 32);
> @@ -2661,6 +2705,11 @@ static int nl80211_authenticate(struct s
>  		goto out;
>  	}
> =20
> +	if (dev->ieee80211_ptr->iftype !=3D NL80211_IFTYPE_STATION) {
> +		err =3D -EOPNOTSUPP;
> +		goto out;
> +	}
> +
>  	if (!netif_running(dev)) {
>  		err =3D -ENETDOWN;
>  		goto out;
> @@ -2734,6 +2783,11 @@ static int nl80211_associate(struct sk_b
>  		goto out;
>  	}
> =20
> +	if (dev->ieee80211_ptr->iftype !=3D NL80211_IFTYPE_STATION) {
> +		err =3D -EOPNOTSUPP;
> +		goto out;
> +	}
> +
>  	if (!netif_running(dev)) {
>  		err =3D -ENETDOWN;
>  		goto out;
> @@ -2797,6 +2851,11 @@ static int nl80211_deauthenticate(struct
>  		goto out;
>  	}
> =20
> +	if (dev->ieee80211_ptr->iftype !=3D NL80211_IFTYPE_STATION) {
> +		err =3D -EOPNOTSUPP;
> +		goto out;
> +	}
> +
>  	if (!netif_running(dev)) {
>  		err =3D -ENETDOWN;
>  		goto out;
> @@ -2856,6 +2915,11 @@ static int nl80211_disassociate(struct s
>  		goto out;
>  	}
> =20
> +	if (dev->ieee80211_ptr->iftype !=3D NL80211_IFTYPE_STATION) {
> +		err =3D -EOPNOTSUPP;
> +		goto out;
> +	}
> +
>  	if (!netif_running(dev)) {
>  		err =3D -ENETDOWN;
>  		goto out;
>=20
> --=20
>=20

--=-oIwDAKy281gek7pYWZ2w
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJxKAVAAoJEKVg1VMiehFY424P/RB/gF1mVANJMM+TYvU5t6Bp
deJlozj8zUXBayosZzwzf+SyXpwykp1+pA0dh+vx0YF77T9ITTsQETSo9O2BKWZJ
5qpvBCiXPkr867VpnuUnVPU3TK2WaAEXnf3pW6jFHJLRwNoXqofVvMIDF6yfDr3p
gDxZjcWGOGSINCPgsK5koPp55ZSgnLFELL1nWgQvnzSAa/UEAaD2ajWFIVAT/nps
kY9P/8lCBULCOq4DjAXIsKA+/Y5AnPGsj+4CDXM7kzXVIXR+frZUvwzdoMjn3LaW
YSl1cIOCsPlNFLP5T1tzN8X42Oz54gCx507Js8oITpgH8+29n9adK+hssEo7zwRr
B1Sj+F31LHB4+acRRBaRpX+Mkw/8EJ3BYgDpS4ovwBZUwPA/kz92RwMUtpBxh4Uf
PHV8menftFpUw9kJrfEJcC/GazLTmuxonHEc6Bxr8bx6E4hTyEyQpYuUKshkRP7Q
lii74X0wA7O7mtr/txUm6019C7AUUQH82i5IKLlS5jnt8nR4kQRkqiP7zFmO3RT9
Iw78ULY0jgMsSYlF5PHJoCNvI5ve7CR5lO1tHAPFG9OVxLLGWOYs/eZI3ZSFTZCX
QXc6ht+fhMpKwLH/R9Dn4pQD4DrupS178sRdsVkuVyjdkk0sY5AUJLYCkH4tyIu1
KyvwxRUoyuApVeKPJGwZ
=E8K0
-----END PGP SIGNATURE-----

--=-oIwDAKy281gek7pYWZ2w--

