Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46267 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755AbZI1O5h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Sep 2009 10:57:37 -0400
Subject: Re: [RFC] libertas: first stab at cfg80211 support
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <h.schurig@mn-solutions.de>
Cc: libertas-dev@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Dan Williams <dcbw@redhat.com>
In-Reply-To: <200909281654.08859.h.schurig@mn-solutions.de>
References: <200909281321.21600.h.schurig@mn-solutions.de>
	 <1254144714.3151.1.camel@johannes.local>
	 <200909281654.08859.h.schurig@mn-solutions.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-wtlrgKGKcd3iPWnOzIuz"
Date: Mon, 28 Sep 2009 16:57:37 +0200
Message-Id: <1254149857.3151.5.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-wtlrgKGKcd3iPWnOzIuz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-09-28 at 16:54 +0200, Holger Schurig wrote:

> Yes, it has three netdevs, but they aren't all setup at=20
> card-initialization time.
>=20
>=20
> Some details: "struct private" contains:
>=20
>         struct net_device *dev;
>         struct net_device *mesh_dev; /* Virtual device */
>         struct net_device *rtap_net_dev;
>=20
> The old code did have an
>=20
>         dev =3D alloc_etherdev(sizeof(struct lbs_private));"
>=20
> and the other two netdevs got initialized at some other location:
>=20
> * priv->lbs_add_mesh() in lbs_add_mesh()
>   via "alloc_netdev(0, "msh%d", ether_setup)". And lbs_add_mesh()
>   is called only when the hardware supports this.
> * rtap_net_dev is created in lbs_add_rtap() and again I haven't
>   change the creation of this thingy.
>=20
> Please note that when I'm using the card in station mode, both=20
> mesh_dev and rtap_net_dev are NULL. My firmware doesn't have=20
> mesh code, and only when I set the card into monitor mode will=20
> the rtap_net_dev created.
>=20
>=20
> I kept this behavior for now: at initialzation I call:
>=20
>         wdev =3D lbs_wdev_alloc(sizeof(struct lbs_private), dmdev);
> 	wdev->xyz =3D initialization;
>         ...
>         dev =3D alloc_netdev()
>=20
>=20
> For me it's not clear if I should create wdev's for mesh_dev and=20
> rtap_net_dev as well. However, I'm not able to check the mesh=20
> code anyway: my firmware doesn't support this. And for=20
> rtap_net_dev I'm not sure if this shouldn't be handled=20
> differently in a cfg80211 scenario, e.g. via=20
> lbs_cfg80211_change_iface().

Interesting.

> A hint of what I should then would be most welcome :-)

It might make sense to support adding interfaces with nl80211, since
apparently it has mesh and monitor interfaces.

johannes

--=-wtlrgKGKcd3iPWnOzIuz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKwM7dAAoJEODzc/N7+QmaH7cQAK1pXKnV284olhYrSqiAC44v
KudglaZ3UFz7heB8z1nFInbpMnZuYPNlqGof8eRmI4eISnp0BA2UaN8R9BqqTxkK
pk4AvtWwFad6R8Ll7h7AHNX4BD0suyEssVeowV6h/Y7whE+7tTf5WdP1nlZfkEWK
+ym8LLRBOfGzDytSApcR1Cwc79HDK4C5CdE/0U3Izfp2j1D5HJp+EEJjdJ9yCkfS
yUnlQjCrz9ZnpYLPmn0fhutE05PH4M/gz2xC7RiWN4SIVXmTaxfOHWh+76qrDtJ5
ZrwcHsOUYTWB9oiq+8zzdYpjuXv7S84dH+AYE7iVQX7Auy4Q9mN0uRU+zKekDo8R
d98XISqblcm7OOQPtfUsiJmNvvbtGMwWfDO0CNhO6HoD6UGdGhEOXa0Yq0Kp9Uui
5cK2KjTYUJGg0Rv19wPQG3SHRnTezx1iy9JmpqCDArL9b/UxZcyr52NB9TA7G/I/
ISdFMD0hw1/9c7eXqjxLfwoMcGJDR1u7Q5H0uiHDwmfG7li5qEoF9ftQwN9LTNEP
3HowTRbEvvsfh6edPy/vPPR2BVJaey4yG9e+EXVHUtHWxToyeX90rjNwU+RrN5fD
NzrfpKwsaWXJxov6NAVYTkfKWU699blGmh+IZDSJlHNrSqfuGi3Q9YUFitcs49jF
8MzWN8bTn945xdBfRm0o
=Xz6y
-----END PGP SIGNATURE-----

--=-wtlrgKGKcd3iPWnOzIuz--

