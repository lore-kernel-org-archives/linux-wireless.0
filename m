Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:36468 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755434AbYBVQL6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2008 11:11:58 -0500
Subject: Re: [PATCH 06/13 v2] o11s: support for mesh interfaces in mac80211
	data path
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <47be773a.29578c0a.41e9.ffffa95d@mx.google.com> (sfid-20080222_071823_283753_CB1EE72E)
References: <47be773a.29578c0a.41e9.ffffa95d@mx.google.com>
	 (sfid-20080222_071823_283753_CB1EE72E)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ozfxFUmwGcMkpMrW3Jv/"
Date: Fri, 22 Feb 2008 17:11:32 +0100
Message-Id: <1203696692.7082.58.camel@johannes.berg> (sfid-20080222_161207_816974_68B4C7A9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ozfxFUmwGcMkpMrW3Jv/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> +#ifdef CONFIG_MAC80211_MESH
> +#include "mesh.h"
> +#endif

same here.

> @@ -1474,8 +1512,8 @@ int ieee80211_subif_start_xmit(struct sk_buff *skb,
>          * EAPOL frames from the local station.
>          */
>         if (unlikely(!is_multicast_ether_addr(hdr.addr1) &&
> -                    !(sta_flags & WLAN_STA_AUTHORIZED) &&
> -                    !(ethertype =3D=3D ETH_P_PAE &&
> +                     !(sta_flags & WLAN_STA_AUTHORIZED) &&
> +                     !(ethertype =3D=3D ETH_P_PAE &&
>                        compare_ether_addr(dev->dev_addr,
>                                           skb->data + ETH_ALEN) =3D=3D 0)=
)) {
>  #ifdef CONFIG_MAC80211_VERBOSE_DEBUG=20

?

> +#ifdef CONFIG_MAC80211_MESH
> +static struct sk_buff *ieee80211_mesh_beacon_get(struct net_device *dev)
> +{
> +	struct ieee80211_local *local =3D wdev_priv(dev->ieee80211_ptr);
> +	struct sk_buff *skb =3D dev_alloc_skb(local->hw.extra_tx_headroom + 400=
);

What's 400? No way to know how large it'll get?

johannes

--=-ozfxFUmwGcMkpMrW3Jv/
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR770M6Vg1VMiehFYAQIISA//fI0dEzS9j9/IADF8unpSOqJ6z3/jqI+i
UPD+eL+FLYaF71VWykqr3wRS37kuEeHzj8K3hOh2RhmlEfqSDkHXSSUC52mQwwhi
LcGcUQq4q663m9H6OXmlm+oZZ+x5xX4nvqzIlpKTF3BVw7fkAVlg5OAVsJY1SGiq
AxBafDQB5oR6/4KMYryG8EiBzTTl8k5YTFPg6rmcyXKQ5y9214iSWt4fGrDeQ+/H
jyszPUiGCTf7F+l2jkhQHXTDxUvKaK81nETOLgz11E+zaqTVEMo3yUq7LfagY8G1
HJMyF+SjI9sPmpNPBJbWQah6JTFKzkbJwH1LfHp4d+V5tINnwFu+zZDC0EBfXDRx
dwTlTCDKtuM07a33aPUo44VTFXFpnIHuRHwkpBXJoE3Mlxtp7NRnlTwYFohB2VTe
PZP47AUhkuM9T1DQ9RC+MxLwAN1kUCkjfChwN4wDfVOeO+YUubX/8lVDqKZ4b3NN
orm+IDWGMDeApAiLdvEO5Op/FIEo2N5g1WrumPePHCBeF6btJ4DvYHhKd3j691wy
xwE+LnIvkGkwdH6ihr73Refkk0/S/UXnoFOUvEPWpoDC8wt++/Idnz+umrIPavp3
iFlZ3dpXwSr6R7nn77XChJUUiRsC7NBOxFvXebbfomhFm7qeKjEDujp7+BAJyGDz
Bwjvtaeemh0=
=T+mB
-----END PGP SIGNATURE-----

--=-ozfxFUmwGcMkpMrW3Jv/--

