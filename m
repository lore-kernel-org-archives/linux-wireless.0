Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:41938 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754598AbYBVQQk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2008 11:16:40 -0500
Subject: Re: [PATCH 08/13 v2] o11s: other changes in mac80211 for mesh
	interface support
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <47be7741.05d6720a.44c4.ffffd0c9@mx.google.com> (sfid-20080222_071830_924260_34482369)
References: <47be7741.05d6720a.44c4.ffffd0c9@mx.google.com>
	 (sfid-20080222_071830_924260_34482369)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Wg543R31+M1AOk6sUztt"
Date: Fri, 22 Feb 2008 17:16:23 +0100
Message-Id: <1203696983.7082.63.camel@johannes.berg> (sfid-20080222_161647_594990_DB076DBC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Wg543R31+M1AOk6sUztt
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


>  int ieee80211_set_freq(struct ieee80211_local *local, int freq);
>  /* ieee80211_sta.c */
> +#define IEEE80211_FC(type, stype) cpu_to_le16(type | stype)

That seems... misplaced.

>  	if (sdata->vif.type !=3D IEEE80211_IF_TYPE_STA &&
>  	    sdata->vif.type !=3D IEEE80211_IF_TYPE_IBSS &&
> +	    sdata->vif.type !=3D IEEE80211_IF_TYPE_MESH_POINT &&
>  	    sdata->vif.type !=3D IEEE80211_IF_TYPE_AP)
>  		return -EOPNOTSUPP;

Why no scanning on mesh interfaces?

> +struct sta_info *sta_info_get_by_idx(struct ieee80211_local *local, int =
idx,
> +				     struct net_device *dev)
> +{
> +	struct sta_info *sta;
> +	int i =3D 0;
> +
> +	read_lock_bh(&local->sta_lock);
> +	list_for_each_entry(sta, &local->sta_list, list) {
> +		if (i < idx) {
> +			++i;
> +			continue;

I already commented on the raciness of this.

johannes

--=-Wg543R31+M1AOk6sUztt
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR771VaVg1VMiehFYAQJ7cw/+Po5pK2iyUV6YsuhrvKvg5WkjGd/8uUL/
lg8pQgQkaloKqAOtGlkrs+hQkzcyT6j5e+57C3zE7hN8cxR39C5BWCGqr43hCAWb
BzWabh20A4YX1/Xp90vFYmYsj72Acg7Jb3mdHwTPuCnf4RvH9Tm1KdU5scEaxGCn
tqJiYFIZNn3sfXYoZIm0HFoBTrrixZmIxFXSOy0dgg/vGK36WU92ulvcbH1sjdfO
aCgQosF/oDpFU+aGUgjxKD+JVjkfGyOGRbeZlTPk34i1J7ick63ixyHnqPMauKw4
aJDj9ogBsebZysQdNIWHKRDhBQ8x9PkEntpT/k9njwHWh4ue1WlZbwBi7UjxDmxY
Ny7MXyROYcWwNtkiBwEaro5QEwyOYMtCUyBVMJ7tlaNKgIQHz3rE5wew+NlHLyTE
ZOMS7/cpVFcHKFcA8IDTw+BNluFxd+eB4UBlp54X8uAgKpcDlG5q6gUS28aTyYlv
FFEt/nKaI0TYA3kLXCKpZuPcpCIEoc3FyEc+4A1jYoA3FSiM4d594gl5K6Ds6j2a
lM9koi6bOkvHoaWiP+c5GFvnmtp2uIVYF4QXEJUkYyWRPamtljgb2l4N/p7qz932
HYbecwrK73iT8i2G4HsTPI7CLtJYzCf9bPoX1wMqwylYJDpR01a//FoT59+McgbV
zsG/OFmDR+k=
=SpsB
-----END PGP SIGNATURE-----

--=-Wg543R31+M1AOk6sUztt--

