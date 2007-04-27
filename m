Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:55826 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755975AbXD0PMt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Apr 2007 11:12:49 -0400
Subject: Re: [PATCH] mac80211: add sta item when changing WDS address
From: Johannes Berg <johannes@sipsolutions.net>
To: Jiri Benc <jbenc@suse.cz>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1175011277.9282.8.camel@johannes.berg>
References: <1175011277.9282.8.camel@johannes.berg>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-oRtQejTjNA+B9d8/ETI9"
Date: Fri, 27 Apr 2007 17:12:52 +0200
Message-Id: <1177686772.3565.32.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-oRtQejTjNA+B9d8/ETI9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-03-27 at 18:01 +0200, Johannes Berg wrote:
> This patch adds a sta item for the new address when you change a WDS
> link's address. If the sta item cannot be created return an error.

Anything wrong with this patch? :)

> --- wireless-dev.orig/net/mac80211/ieee80211.c	2007-03-27 16:33:29.523155=
480 +0200
> +++ wireless-dev/net/mac80211/ieee80211.c	2007-03-27 16:33:47.163155480 +=
0200
> @@ -4418,6 +4418,15 @@ int ieee80211_if_update_wds(struct net_d
>  	struct ieee80211_sub_if_data *sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
>  	struct sta_info *sta;
> =20
> +	if (compare_ether_addr(remote_addr, sdata->u.wds.remote_addr) =3D=3D 0)
> +		return 0;
> +
> +	/* Create STA entry for the new peer */
> +	sta =3D sta_info_add(local, dev, remote_addr, GFP_KERNEL);
> +	if (!sta)
> +		return -ENOMEM;
> +	sta_info_put(sta);
> +
>  	/* Remove STA entry for the old peer */
>  	sta =3D sta_info_get(local, sdata->u.wds.remote_addr);
>  	if (sta) {


--=-oRtQejTjNA+B9d8/ETI9
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGMhL0/ETPhpq3jKURAvoEAJ0asQStJRZfRVPdcWgarnzHerxH1gCfSn3y
vwzp9J+6vxO0zq0YKNhbN+Y=
=wMjo
-----END PGP SIGNATURE-----

--=-oRtQejTjNA+B9d8/ETI9--

