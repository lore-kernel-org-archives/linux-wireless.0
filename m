Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42290 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761997AbXGKJlQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jul 2007 05:41:16 -0400
Subject: Re: [PATCH] cfg80211: Don't allow users to create/remove interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: John Linville <linville@tuxdriver.com>,
	Andy Green <andy@warmcat.com>, linux-wireless@vger.kernel.org
In-Reply-To: <200707110117.26067.mb@bu3sch.de>
References: <200707110117.26067.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Gkv2OFOp0viNZFjTIiUS"
Date: Wed, 11 Jul 2007 11:36:03 +0200
Message-Id: <1184146563.3738.42.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Gkv2OFOp0viNZFjTIiUS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-07-11 at 01:17 +0200, Michael Buesch wrote:
> This adds a capability check to only allow creation
> and removal of interfaces by a network admin.
>=20
> Signed-off-by: Michael Buesch <mb@bu3sch.de>
> Cc: Johannes Berg <johannes@sipsolutions.net>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

Should stable be getting this too, for people who use out-of-tree
mac80211 drivers?

> Cc: Andy Green <andy@warmcat.com>
>=20
> Index: mac80211/net/wireless/sysfs.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- mac80211.orig/net/wireless/sysfs.c	2007-06-01 11:20:32.000000000 +020=
0
> +++ mac80211/net/wireless/sysfs.c	2007-07-11 01:04:53.000000000 +0200
> @@ -46,9 +46,10 @@ static ssize_t _store_add_iface(struct d
>  	struct cfg80211_registered_device *rdev =3D dev_to_rdev(dev);
>  	int res;
> =20
> +	if (!capable(CAP_NET_ADMIN))
> +		return -EPERM;
>  	if (len > IFNAMSIZ)
>  		return -EINVAL;
> -
>  	if (!rdev->ops->add_virtual_intf)
>  		return -ENOSYS;
> =20
> @@ -68,9 +69,10 @@ static ssize_t _store_remove_iface(struc
>  	int res, ifidx;
>  	struct net_device *netdev;
> =20
> +	if (!capable(CAP_NET_ADMIN))
> +		return -EPERM;
>  	if (len > IFNAMSIZ)
>  		return -EINVAL;
> -
>  	if (!rdev->ops->del_virtual_intf)
>  		return -ENOSYS;
> =20
>=20

--=-Gkv2OFOp0viNZFjTIiUS
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGlKSC/ETPhpq3jKURAraMAJ423Ivon4RkrAh8ngQ4wvELwbQXTgCeO3vf
lRrqWpiRx0A2f/5oP3p1Nco=
=2BAj
-----END PGP SIGNATURE-----

--=-Gkv2OFOp0viNZFjTIiUS--

