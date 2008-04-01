Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:58841 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759295AbYDAL7U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Apr 2008 07:59:20 -0400
Subject: Re: [PATCH 1/2] mac80211: check for mesh_config length on incoming
	management frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <47f189ce.0a528c0a.4608.0322@mx.google.com> (sfid-20080401_020316_451825_4D6102CB)
References: <47f189ce.0a528c0a.4608.0322@mx.google.com>
	 (sfid-20080401_020316_451825_4D6102CB)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-HeZnH0Rp8UqzQQ6yLV/l"
Date: Tue, 01 Apr 2008 13:59:16 +0200
Message-Id: <1207051156.5143.50.camel@johannes.berg> (sfid-20080401_125944_422291_556DD7BF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-HeZnH0Rp8UqzQQ6yLV/l
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


Indeed :)
Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  net/mac80211/ieee80211_sta.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
>=20
> diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
> index cfe6fcc..feec201 100644
> --- a/net/mac80211/ieee80211_sta.c
> +++ b/net/mac80211/ieee80211_sta.c
> @@ -2153,11 +2153,14 @@ ieee80211_rx_mesh_bss_get(struct net_device *dev,=
 u8 *mesh_id, int mesh_id_len,
> =20
>  static struct ieee80211_sta_bss *
>  ieee80211_rx_mesh_bss_add(struct net_device *dev, u8 *mesh_id, int mesh_=
id_len,
> -			  u8 *mesh_cfg, int freq)
> +			  u8 *mesh_cfg, int mesh_config_len, int freq)
>  {
>  	struct ieee80211_local *local =3D wdev_priv(dev->ieee80211_ptr);
>  	struct ieee80211_sta_bss *bss;
> =20
> +	if (mesh_config_len !=3D MESH_CFG_LEN)
> +		return NULL;
> +
>  	bss =3D kzalloc(sizeof(*bss), GFP_ATOMIC);
>  	if (!bss)
>  		return NULL;
> @@ -2530,7 +2533,8 @@ static void ieee80211_rx_bss_info(struct net_device=
 *dev,
>  #ifdef CONFIG_MAC80211_MESH
>  		if (elems.mesh_config)
>  			bss =3D ieee80211_rx_mesh_bss_add(dev, elems.mesh_id,
> -				elems.mesh_id_len, elems.mesh_config, freq);
> +				elems.mesh_id_len, elems.mesh_config,
> +				elems.mesh_config_len, freq);
>  		else
>  #endif
>  			bss =3D ieee80211_rx_bss_add(dev, mgmt->bssid, freq,

--=-HeZnH0Rp8UqzQQ6yLV/l
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR/Ijk6Vg1VMiehFYAQJbthAAozvbjz8SdiQwkNbkGWhoE0N5Th+OpHCR
9JKI6gYsWq5rYRs/hj7rH3RaB8E8XWXMKsjr0TDoN2vzk58hZOu/epQHybawYXDE
ZqTjqoPTxAgyUSwOMp6oqhOUOWCRYyyz6do7bq8mT9oKw63cYNdCF/MUFMXD8axA
hdS9kHUqSB8myAYes0IM8NUImRNLpJq0NZmFhsHn6YYgZj6VKeXtqclQLllbdNqL
vKCZftMMk3N1lOwKB/UviEesZG9ndR86CennmPfq0/vgODTCj17pYEWcbKOcDooF
fx6IalbZR1f30zK1rM4H7z1UrZOsiHRMGGi+7pazKfOiFpDxhz7ZfJhC93ynBvKG
kS7g+suxB58WpfjjW7M1MsxMpI50T3UyYlzH3M3iLxidsPsA/Q3gHk5R6b6jYLTj
F8EmICO/Aslz0xuQCEOOOoVLd8zSpqSb6i56kLoGDbTd/ZrZ8+OjOMpmFOTewtHw
GmuTbkDQMRFBHlsEQUiQcwtpiQwaB2AOYM2Pqrr9aYY5Drce6LFvBK7kZB/FvoDC
cjr4iJXGt12kniobwC5HuZq4fEX2maiIJ+tuZnquqDoV2pvRkW4oX7V5BhdcUlwU
+GE/Wtqh2GbBBkb1urO0I51NK8SfB/a8LUNqjg1q1aDdWTZjMXy+sjJrOuUqW4h6
fPnEVUQESec=
=vPC1
-----END PGP SIGNATURE-----

--=-HeZnH0Rp8UqzQQ6yLV/l--

