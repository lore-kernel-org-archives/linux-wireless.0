Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48458 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474AbZCUIFg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Mar 2009 04:05:36 -0400
Subject: Re: [PATCH 3/4] nl80211: Check that netif_runnin is true in
 cfg80211 code
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni.malinen@atheros.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20090320192357.566055522@atheros.com>
References: <20090320192115.448175935@atheros.com>
	 <20090320192357.566055522@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-yRea/8vUETy9E0AbryYH"
Date: Sat, 21 Mar 2009 09:05:30 +0100
Message-Id: <1237622730.5100.166.camel@johannes.local> (sfid-20090321_090539_567450_F0FF79E7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-yRea/8vUETy9E0AbryYH
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-03-20 at 21:21 +0200, Jouni Malinen wrote:
> plain text document attachment (nl80211-check-netif-running.patch)
> We do not want to require all the drivers using cfg80211 to need to do
> this or to be prepared to handle these commands when the interface is
> down.
>=20
> Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

Thanks a lot, Jouni.

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  net/mac80211/cfg.c     |   25 -------------------------
>  net/wireless/nl80211.c |   40 ++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 40 insertions(+), 25 deletions(-)
>=20
> --- uml.orig/net/mac80211/cfg.c	2009-03-20 18:03:53.000000000 +0200
> +++ uml/net/mac80211/cfg.c	2009-03-20 18:03:59.000000000 +0200
> @@ -728,10 +728,6 @@ static int ieee80211_add_station(struct=20
>  	int err;
>  	int layer2_update;
> =20
> -	/* Prevent a race with changing the rate control algorithm */
> -	if (!netif_running(dev))
> -		return -ENETDOWN;
> -
>  	if (params->vlan) {
>  		sdata =3D IEEE80211_DEV_TO_SUB_IF(params->vlan);
> =20
> @@ -860,9 +856,6 @@ static int ieee80211_add_mpath(struct wi
>  	struct sta_info *sta;
>  	int err;
> =20
> -	if (!netif_running(dev))
> -		return -ENETDOWN;
> -
>  	sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
> =20
>  	if (sdata->vif.type !=3D NL80211_IFTYPE_MESH_POINT)
> @@ -913,9 +906,6 @@ static int ieee80211_change_mpath(struct
>  	struct mesh_path *mpath;
>  	struct sta_info *sta;
> =20
> -	if (!netif_running(dev))
> -		return -ENETDOWN;
> -
>  	sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
> =20
>  	if (sdata->vif.type !=3D NL80211_IFTYPE_MESH_POINT)
> @@ -1202,9 +1192,6 @@ static int ieee80211_scan(struct wiphy *
>  {
>  	struct ieee80211_sub_if_data *sdata;
> =20
> -	if (!netif_running(dev))
> -		return -ENETDOWN;
> -
>  	sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
> =20
>  	if (sdata->vif.type !=3D NL80211_IFTYPE_STATION &&
> @@ -1220,9 +1207,6 @@ static int ieee80211_auth(struct wiphy *
>  {
>  	struct ieee80211_sub_if_data *sdata;
> =20
> -	if (!netif_running(dev))
> -		return -ENETDOWN;
> -
>  	sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
> =20
>  	if (sdata->vif.type !=3D NL80211_IFTYPE_STATION)
> @@ -1282,9 +1266,6 @@ static int ieee80211_assoc(struct wiphy=20
>  	struct ieee80211_sub_if_data *sdata;
>  	int ret;
> =20
> -	if (!netif_running(dev))
> -		return -ENETDOWN;
> -
>  	sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
> =20
>  	if (sdata->vif.type !=3D NL80211_IFTYPE_STATION)
> @@ -1323,9 +1304,6 @@ static int ieee80211_deauth(struct wiphy
>  {
>  	struct ieee80211_sub_if_data *sdata;
> =20
> -	if (!netif_running(dev))
> -		return -ENETDOWN;
> -
>  	sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
>  	if (sdata->vif.type !=3D NL80211_IFTYPE_STATION)
>  		return -EOPNOTSUPP;
> @@ -1339,9 +1317,6 @@ static int ieee80211_disassoc(struct wip
>  {
>  	struct ieee80211_sub_if_data *sdata;
> =20
> -	if (!netif_running(dev))
> -		return -ENETDOWN;
> -
>  	sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
> =20
>  	if (sdata->vif.type !=3D NL80211_IFTYPE_STATION)
> --- uml.orig/net/wireless/nl80211.c	2009-03-20 18:03:57.000000000 +0200
> +++ uml/net/wireless/nl80211.c	2009-03-20 18:03:59.000000000 +0200
> @@ -1556,6 +1556,11 @@ static int nl80211_new_station(struct sk
>  		goto out;
>  	}
> =20
> +	if (!netif_running(dev)) {
> +		err =3D -ENETDOWN;
> +		goto out;
> +	}
> +
>  	err =3D drv->ops->add_station(&drv->wiphy, dev, mac_addr, &params);
> =20
>   out:
> @@ -1808,6 +1813,11 @@ static int nl80211_set_mpath(struct sk_b
>  		goto out;
>  	}
> =20
> +	if (!netif_running(dev)) {
> +		err =3D -ENETDOWN;
> +		goto out;
> +	}
> +
>  	err =3D drv->ops->change_mpath(&drv->wiphy, dev, dst, next_hop);
> =20
>   out:
> @@ -1846,6 +1856,11 @@ static int nl80211_new_mpath(struct sk_b
>  		goto out;
>  	}
> =20
> +	if (!netif_running(dev)) {
> +		err =3D -ENETDOWN;
> +		goto out;
> +	}
> +
>  	err =3D drv->ops->add_mpath(&drv->wiphy, dev, dst, next_hop);
> =20
>   out:
> @@ -2380,6 +2395,11 @@ static int nl80211_trigger_scan(struct s
>  		goto out;
>  	}
> =20
> +	if (!netif_running(dev)) {
> +		err =3D -ENETDOWN;
> +		goto out;
> +	}
> +
>  	if (drv->scan_req) {
>  		err =3D -EBUSY;
>  		goto out;
> @@ -2641,6 +2661,11 @@ static int nl80211_authenticate(struct s
>  		goto out;
>  	}
> =20
> +	if (!netif_running(dev)) {
> +		err =3D -ENETDOWN;
> +		goto out;
> +	}
> +
>  	if (!info->attrs[NL80211_ATTR_MAC]) {
>  		err =3D -EINVAL;
>  		goto out;
> @@ -2709,6 +2734,11 @@ static int nl80211_associate(struct sk_b
>  		goto out;
>  	}
> =20
> +	if (!netif_running(dev)) {
> +		err =3D -ENETDOWN;
> +		goto out;
> +	}
> +
>  	if (!info->attrs[NL80211_ATTR_MAC] ||
>  	    !info->attrs[NL80211_ATTR_SSID]) {
>  		err =3D -EINVAL;
> @@ -2767,6 +2797,11 @@ static int nl80211_deauthenticate(struct
>  		goto out;
>  	}
> =20
> +	if (!netif_running(dev)) {
> +		err =3D -ENETDOWN;
> +		goto out;
> +	}
> +
>  	if (!info->attrs[NL80211_ATTR_MAC]) {
>  		err =3D -EINVAL;
>  		goto out;
> @@ -2821,6 +2856,11 @@ static int nl80211_disassociate(struct s
>  		goto out;
>  	}
> =20
> +	if (!netif_running(dev)) {
> +		err =3D -ENETDOWN;
> +		goto out;
> +	}
> +
>  	if (!info->attrs[NL80211_ATTR_MAC]) {
>  		err =3D -EINVAL;
>  		goto out;
>=20
> --=20
>=20

--=-yRea/8vUETy9E0AbryYH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJxJ/HAAoJEKVg1VMiehFY2D8P/izex/ZguLMqig5SFI9cU8JB
5AhUiwttENI1RYq6HO+9R03S6I8AMAAX0q5PRaGgJcJREUZ8DNr2OrY3OafXQypG
0Wy5UZorRHM1OTszpgxhzcRMTIXZ7+cQFZ15igARQbiiioywrlhxGu+6juk8cAlL
oiwwqcIzC7XmoFztoyG9XuWLRflRhTiQnXgYVtHcy6RQw2nVqqjsk2WfwJNZc0fN
jYxOpp5m40qZY2A+DFQo4LyJsvWZPPup4+lZ7ThIE0JIakDEk/+MGoYUi1OMBtn/
N43PGlrcJy1YuSj6YNbQFnTzwzZ56p6InKigdVgo2ZOEkcJx2PSJ0nxQgIJLeIX/
yhNe5UfbyadWAxW9NChm5Qpa8lBE8ApGNmXtEyB66J2zjGPUwJG3dNNyCOaTKQxv
fTbQb1IEenG3LoIxb9nhY6T4l4hW60WvcxapOUXrJY8pLnO2t3L7TQ8CWtUSU2nC
wA6ohwp1rz+iBYa1SnwfHb507D8nxKRRFC9XrtdI1aVnJ3rXlLDXKUzVeEJniswd
uxq9fXvOuMfBohlayPzgimTnpsJ+I4FiHWnXfqaRTDzWh/3m90JNb7b/2qvafp2a
ejNm7lGEOeNKnXNCd4TbxeobGlFP2eFmiLsE8CasW2wFDaMd1HeaH7hEv++nfPjV
mB/fVGvE355FSMIA5Wgc
=CZGD
-----END PGP SIGNATURE-----

--=-yRea/8vUETy9E0AbryYH--

