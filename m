Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42066 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755470AbYBGKgw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Feb 2008 05:36:52 -0500
Subject: Re: [PATCH 07/13] o11s: support for mesh interfaces in mac80211
	data path
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <47a78281.03b48c0a.7362.5d39@mx.google.com> (sfid-20080204_212421_865811_21908028)
References: <47a78281.03b48c0a.7362.5d39@mx.google.com>
	 (sfid-20080204_212421_865811_21908028)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-zayIRV9AEblRD/XG1I5v"
Date: Thu, 07 Feb 2008 01:53:39 +0100
Message-Id: <1202345620.9965.80.camel@johannes.berg> (sfid-20080207_103658_038577_506A8BE6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-zayIRV9AEblRD/XG1I5v
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> +	if (rx->sdata->vif.type =3D=3D IEEE80211_IF_TYPE_MESH_POINT) {
> +		if ((rx->fc & IEEE80211_FCTL_FTYPE) =3D=3D IEEE80211_FTYPE_DATA) {
> +			if (!((rx->fc & IEEE80211_FCTL_FROMDS) &&
> +					(rx->fc & IEEE80211_FCTL_TODS)))

It'd be shorter to write

	if (rx->fc ^ (IEEE80211_FCTL_FROMDS | IEEE80211_FCTL_TODS))

but I'm not sure that's easier to understand ;)

> +		/* If there is not an established peer link and this is
> +		 * not a peer link establisment frame, beacon or probe,
> +		 * drop the frame.
> +		 */
> +		if (!is_estab_plink(hdr->addr2, rx->dev)) {

This would get to be something like

		if (sta->flags & STA_FLAG_MESH_LINK_ESTABLISHED)

right?

> +			if ((rx->fc & IEEE80211_FCTL_FTYPE) !=3D
> +				IEEE80211_FTYPE_MGMT)
> +				return TXRX_DROP;

All this deep indentation is pretty ugly. Can you create a new function

static void rx_result ieee80211_rx_check_mesh(...)

and in ieee80211_rx_h_check() simply do

if (rx->sdata->vif.type =3D=3D IEEE80211_IF_TYPE_MESH_POINT)
	return ieee80211_rx_check_mesh(...);

please?

> @@ -987,7 +1038,8 @@ ieee80211_rx_h_remove_qos_control(struct ieee80211_t=
xrx_data *rx)
>  static int
>  ieee80211_802_1x_port_control(struct ieee80211_txrx_data *rx)
>  {
> -	if (unlikely(!rx->sta || !(rx->sta->flags & WLAN_STA_AUTHORIZED))) {
> +	if (rx->sdata->vif.type !=3D IEEE80211_IF_TYPE_MESH_POINT &&
> +	    (!rx->sta || !(rx->sta->flags & WLAN_STA_AUTHORIZED))) {

I suppose you should be adding sta_info structs for each mesh peer and
set the AUTHORIZED flag on them. Is this what you were referring to in
the patch description?

> @@ -1222,6 +1290,36 @@ ieee80211_deliver_skb(struct ieee80211_txrx_data *=
rx)
>  		}
>  	}
> =20
> +	/* Mesh forwarding */
> +	if (sdata->vif.type =3D=3D IEEE80211_IF_TYPE_MESH_POINT) {

Similarly here, I think this code could benefit from the outdenting
achieved by putting it into an own function, the compiler will inline it
anyway. Also that could simplify #ifdef'ing the mesh code if we want
that.

> @@ -1474,9 +1508,10 @@ int ieee80211_subif_start_xmit(struct sk_buff *skb=
,
>  	 * Drop unicast frames to unauthorised stations unless they are
>  	 * EAPOL frames from the local station.
>  	 */
> -	if (unlikely(!is_multicast_ether_addr(hdr.addr1) &&
> -		     !(sta_flags & WLAN_STA_AUTHORIZED) &&
> -		     !(ethertype =3D=3D ETH_P_PAE &&
> +	if (sdata->vif.type !=3D IEEE80211_IF_TYPE_MESH_POINT &&
> +	    (!is_multicast_ether_addr(hdr.addr1) &&
> +		      !(sta_flags & WLAN_STA_AUTHORIZED) &&
> +		      !(ethertype =3D=3D ETH_P_PAE &&
>  		       compare_ether_addr(dev->dev_addr,
>  					  skb->data + ETH_ALEN) =3D=3D 0))) {

That's also an artifact of not adding sta info structs, right?

johannes

--=-zayIRV9AEblRD/XG1I5v
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR6pWkqVg1VMiehFYAQIHig/9GsQwq3+5BvV4NJc33B/LBBbQEYK6lJrJ
w7KKvQH8DEWTb6/6hq/s7mFajXXwiyj9uJPXJjnW5n2kCWHG7VLm9UhwaOTUTIqg
vWM1YieDRAE4ciGR0vvfTNDoaQ/pGlOFK5xkwKnvoODZ94q6evsFzD2mQIfBXWBm
+bZHE1OU7K4GXgCG0uTEMAjjetN6UzNc1H4e853Ca6ajrhXHmvtZNb4bHewMwG+p
EFEcqAChufqYeqlDJonyd/HaL7h6KGjpKRlhkBJ3UEngrCBVpk34vx1wwL5VBeRp
LB6aXn6vn0C+l/YvafmbxiaPhbVQij9kMsFPAFSbO3KdzQdFSCT9uuhWVYlv34VZ
IZs6SIa0+KCvMD+YZZxL9ieATBpylNjQuT9MNx8d2/6OWX+eQ7LNJFklo+29fNSX
93c7prdSJLsUW2dtJkKvyZFnhN/jkqha4eGocvz+oWtGpySy8e5NLhR59hOFZzPh
l6L1U83rqNNHObKCl181vlvi2p0w7QtPhyJo/268owAPOv3ai/8lLLinnq0T7TMp
YfDh2OwYiFDYFoVI+RNmXv83qFBMFre1EsE7rKVGsZwzq6CDyMDYkoUd9rluw6ry
6qbKWSxyru+2NgTjlvF+MlZZsu/hGkgsQ6dUIi0R7AYTdkhGM9kkDYF4pJAY8Yny
eY95tgjZ04Y=
=RQ9K
-----END PGP SIGNATURE-----

--=-zayIRV9AEblRD/XG1I5v--

