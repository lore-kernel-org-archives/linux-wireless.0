Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45786 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434AbYFSPdZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jun 2008 11:33:25 -0400
Subject: Re: [PATCH] libertas: make mesh code configurable
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	libertas-dev@lists.infradead.org
In-Reply-To: <200806191704.10297.hs4233@mail.mn-solutions.de> (sfid-20080619_170429_512985_CDD100EA)
References: <200806191704.10297.hs4233@mail.mn-solutions.de>
	 (sfid-20080619_170429_512985_CDD100EA)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-vxzpKNxEr9F62HcjZ/Ax"
Date: Thu, 19 Jun 2008 17:32:36 +0200
Message-Id: <1213889556.8967.29.camel@johannes.berg> (sfid-20080619_173345_071369_CE31A474)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-vxzpKNxEr9F62HcjZ/Ax
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-06-19 at 17:04 +0200, Holger Schurig wrote:
> There are no known firmwares for CF and SDIO based devices that
> support MESH. For those devices, mesh-support in the driver is just
> a bit of bloat. Moreover, they're mostly used in embedded devices,
> where space counts.

Wow. That's more ifdefs than mac80211 needs to do this.

> +#ifdef CONFIG_LIBERTAS_MESH
>  	if (dev =3D=3D priv->mesh_dev) {
>  		priv->mesh_open =3D 1;
>  		priv->mesh_connect_status =3D LBS_CONNECTED;
>  		netif_carrier_on(dev);
> -	} else {
> +	} else
> +#endif
> +	{

and those are particularly ugly.

Especially for the mesh_dev thing, you should probably have a static
inline that returns priv->mesh_dev (mesh case) and NULL (non-mesh case)
and rely on the compiler to elide as much code as possible.

E.g. this:

> +#ifdef CONFIG_LIBERTAS_MESH
>  	if (priv->mesh_dev && (priv->mesh_connect_status =3D=3D LBS_CONNECTED))
>  		netif_wake_queue(priv->mesh_dev);
> +#endif

wouldn't then need an ifdef.

johannes

--=-vxzpKNxEr9F62HcjZ/Ax
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIWnwRAAoJEKVg1VMiehFYu/cP/1abgcluTUw4oA2lyxYbeZUD
5iVvdh1im7pVOc1/9WWkdfs3dHXQNK4/5iJJY1LF2A62GmoiiZsO4hcjghL7r6aX
+QZ4pHAa8JnubCaE0bZGK7wiB9QIKPNrGQ3fO26DZ5MfWtvwbPj7cZdv4yb5pa0C
lMtK4iJnV1YKFJX9jjNk2MAVh3eKaM/uatByj4rOYuEc/TGKrzp9k2cQA7/rmHzn
vmD0Y5Djmm5XK2B+Q+iTBue76HYwz96dlTlOrv1vJj/c3/MLL9I7xg+N1MygFZv+
tdB4iBpF+pvgx9tOzRdeD54deoUyvf3DJtIutUqzmCPalZdIvnMvE3wPcJ0K5Dpm
CAFmrjBp95pbql/NwT+bOhIy+7D/cE3ivC/SlLtvPev0V5dPoqQvZQKf/n0/whr5
Xdw/X8Y+c/4uoQ3CcA0VeBYrC1vfz2jdNn8rKBAl2QT5PeNODZdyYzr/yqDCP17z
FP1RISbQk1Jiy21FTWW6QXTrtf8t/fciAUDTBJeBiO10/TgCoWEgDqcxtcWf0+Xa
T4OGi30MpZomCnb2GybSAE3oEGjzziC1yrDCRlK8mFMMepWWupnUAEjrJewoJpBw
MiCwWC9QCgv8aRZqPu+NwguAsXz7Dsw9qB0inA1W3eZ4+8PSeCy6F7Ef6wCzumDn
ILDE09T5ZX+9ewZVgO2U
=FyFp
-----END PGP SIGNATURE-----

--=-vxzpKNxEr9F62HcjZ/Ax--

