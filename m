Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42656 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887AbXJaMPF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Oct 2007 08:15:05 -0400
Subject: Re: [PATCH 4/7] o80211s: (mac80211s) basic mesh interface support
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4727de06.0e578c0a.2568.ffffb079@mx.google.com> (sfid-20071031_014443_042392_A26640AB)
References: <4727de06.0e578c0a.2568.ffffb079@mx.google.com>
	 (sfid-20071031_014443_042392_A26640AB)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-f3eNi+94mAHKG2McA8lL"
Date: Wed, 31 Oct 2007 13:16:25 +0100
Message-Id: <1193832985.12078.14.camel@johannes.berg> (sfid-20071031_121511_670486_A567EC19)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-f3eNi+94mAHKG2McA8lL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> @@ -521,6 +522,8 @@ struct ieee80211_if_init_conf {
>   *	config_interface() call, so copy the value somewhere if you need
>   *	it.
>   * @ssid_len: length of the @ssid field.
> + * @mesh_id: mesh ID of the mesh network we will be part of.
> + * @mesh_id_len: length of the @mesh_id field.

Why would the driver need this?

> +ieee80211s-objs =3D ieee80211s.o ieee80211s_stats.o ieee80211s_pathtable=
.o

I think I'd prefer shorter filenames. Maybe mesh networking should also
be made configurable in Kconfig?

> +static int ieee80211_if_set_mesh_cfg(struct wiphy *wiphy,
> +		struct net_device *dev, struct mesh_params *params)
> +{
> +	struct ieee80211_local *local =3D wiphy_priv(wiphy);
> +	struct ieee80211_if_sta *ifsta;
> +	struct ieee80211_sub_if_data *sdata =3D NULL;
> +	if (unlikely(local->reg_state !=3D IEEE80211_DEV_REGISTERED))
> +		return -ENODEV;
> +
> +	if (!dev)
> +		return 0;
> +=09
> +	if (!(dev->ieee80211_ptr && dev->ieee80211_ptr->wiphy->privid=20
> +				=3D=3D mac80211_wiphy_privid))
> +		return -EINVAL;

This cannot happen if you wrote the nl80211 counterpart correctly.
=20
>  	switch (sdata->type) {
>  	case IEEE80211_IF_TYPE_STA:
> +	case IEEE80211_IF_TYPE_MESH:
>  	case IEEE80211_IF_TYPE_IBSS:
>  		add_sta_files(sdata);

There are mesh APs too, that is not supported yet I take it? How do you
plan to support this when you're essentially hard-coding MESH =3D=3D STA
here and in many other places?

> +static void ieee80211_mesh(struct net_device *dev,
> +			   struct ieee80211_if_sta *ifsta)
> +{
> +	mod_timer(&ifsta->timer, jiffies + IEEE80211_MONITORING_INTERVAL);
> +}

?? That needs a better name, whatever it does.

> +++ b/net/mac80211/ieee80211s.c
> @@ -0,0 +1,56 @@
> +/*
> + * Copyright (c) 2007 open80211s Ltd.
> + * Authors :   Luis Carlos Cobo <luisca@cozybit.com>
> + * 	       Javier Cardona <javier@cozybit.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include "ieee80211s.h"
> +
> +int ieee80211s_start(void)
> +{
> +	o80211s_pathtable_init();
> +	return o80211s_create_procmesh();
> +}

procmesh?

The whole ieee80211s.c file is useless. _start() and _stop() can well be
split into the two calls at the callsites, and the header functions can
be part of util.c or so.

> + * Print one entry (line) of /proc/net/mesh

Why do we need /proc/net/mesh? Whatever interface it provides should be
in nl80211 and if you need it for testing, debugfs.

> +	if (rx->sdata->type =3D=3D IEEE80211_IF_TYPE_MESH) {
> +		if (((rx->fc & IEEE80211_FCTL_FTYPE) =3D=3D IEEE80211_FTYPE_DATA) &&
> +		     !((rx->fc & IEEE80211_FCTL_FROMDS) &&
> +		      (rx->fc & IEEE80211_FCTL_TODS)))

I'd rewrite that as ((rx->fc & (FROMDS|TODS)) =3D=3D TODS) or whatever it i=
s.
=20
> +	if (sdata->type =3D=3D IEEE80211_IF_TYPE_MESH) {
> +		int meshhdrlen =3D get_mesh_header_len(
> +				(struct ieee80211s_hdr*) skb->data);
> +		/* copy mesh header on cb to be use if forwarded */
> +		memcpy(skb->cb, skb->data + hdrlen, meshhdrlen);
> +		hdrlen +=3D meshhdrlen;
> +	}

A note to which code uses it from cb please.
=20
> +	if (tx->sdata->type =3D=3D IEEE80211_IF_TYPE_MESH) {
> +		return TXRX_CONTINUE;}
> +

That looks crappy. Whats with the braces?

johannes

--=-f3eNi+94mAHKG2McA8lL
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARyhyGKVg1VMiehFYAQLdBA//T6A70RkTakkGrazhG18NpsV+F/g+kBs+
IW2J8Ropi2QVvCX+VMsWw8oLZZs9CVylcfWFK6gxVL0KKVfddaT1qKnTOR5vMjhZ
Rz/0FFb+B5BRwVkhH3GZcfflHWMVwxivTZ6WQSpS75Kgn71wDt/FGzts52IGa+me
BDeoYzqfCiucp13DNS2Uut1pBw45m71nV+oSNYRQL/oYU+Te6Kac9i1ZHuNTK9p1
WwNehiT434xuCx46Lz5yylUP8hjIjsJV7cSQ6KhLkv0aFci+JmaL68nLz/CdFLfp
S/fdz2NJ8jrP2kbdyVNgCF8XbrQhojUOZADZaqsT+nwbhLesIA+Mq4kbJPMUH9Ax
uXM8IQw1/Ed/Mub2m/FfFoLug2QbJsO6DQ98lr8QgYOSycCJ1GbMrmj9uASutkZF
hnQP+GR3J+xGKu4vd5lEDYI3DbX9uF4UqjB4vWDBvPatyUSxcKI9dy8j+E25tqIH
gjjxHeECVQ5dOHtoL0VGMqUkuUYO+78oMy0qhHm3GRINDEbeiS0U7OPp2eCO7vxR
s5coe5BXTPX30ZBhbtUHTMiX3CMUmG+hv6kLNt8Bt+Z66UhwkKm/30aui0cb2TJ/
DexVQxu4Gm6hlg7Ep79WU1cxHfTvLxON+bgj9CzUEh/f7GDNRcUd1e67n/obkc3M
W0mrFXH0M1g=
=k+7U
-----END PGP SIGNATURE-----

--=-f3eNi+94mAHKG2McA8lL--

