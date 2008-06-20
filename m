Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51281 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbYFTHMA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jun 2008 03:12:00 -0400
Subject: Re: [PATCH] libertas: make mesh code configurable
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	libertas-dev@lists.infradead.org
In-Reply-To: <200806200906.59479.hs4233@mail.mn-solutions.de>
References: <200806191704.10297.hs4233@mail.mn-solutions.de>
	 <1213889556.8967.29.camel@johannes.berg>
	 <200806200906.59479.hs4233@mail.mn-solutions.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-5eqc29bAttUjQh71Zhs/"
Date: Fri, 20 Jun 2008 09:11:11 +0200
Message-Id: <1213945871.8967.131.camel@johannes.berg> (sfid-20080620_091204_220838_243A8E5A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-5eqc29bAttUjQh71Zhs/
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-06-20 at 09:06 +0200, Holger Schurig wrote:
> > Especially for the mesh_dev thing, you should probably have a
> > static inline that returns priv->mesh_dev (mesh case) and NULL
> > (non-mesh case) and rely on the compiler to elide as much code
> > as possible.
> >
> > E.g. this:
> > > +#ifdef CONFIG_LIBERTAS_MESH
> > >  	if (priv->mesh_dev && (priv->mesh_connect_status =3D=3D
> > > LBS_CONNECTED)) netif_wake_queue(priv->mesh_dev);
> > > +#endif
> >
> > wouldn't then need an ifdef.
>=20
> Ah, I thought that the compiler would barf about the
> priv->mesh_connect_status, because this is no longer in
> struct lbs_private.
>=20
> So I tried your suggestion and, yes, the compiler barfs:

Yeah, of course, but that's actually the benefit of that method, the
stuff in there is compiled. You already have a static inline for that
(=EF=BB=BFmesh_is_connected or something) though.

As it stands, your patch really makes the driver hard to maintain, one
will have to pretty much compile with and without mesh configured to
test changes. IMHO. YMMV, and I don't really think my opinion for that
driver should matter much :)

johannes

--=-5eqc29bAttUjQh71Zhs/
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIW1gLAAoJEKVg1VMiehFYxzMP/jwmdqdmY27QcxD0XoUvQBNd
IWPq5fPD/NRGGMN4WQZFLbdrMiMcDEYjEyEa3SETXfwUL0b8QEUJjees2/Uu7t2g
Bybh6vBjFLOJzTsHPAwb/CJQbcRFYzVwygW53rdQ/Gx6HiWGb9VhaSSqZOLYvlr6
usQVIZMzvF7ne9xJel157b7YYmwz3IxAag5M7gH1wWyryFaQWCMnHJyfVmaCMXyX
4yVOXHDb+Gju3DSPqTC9tmZjuGA3QzbQhdKz1lPOOtqC0KR2FVtc8XgupaoQbLjp
wYD0+PMIeXO/THrpIaLepM1bXz/E2gueBJyuT4nn7gbkq/oHCbh5YQYSH7asIj6n
ok5ew6IgxeVyxShP+vT0Xh+ncdnCioY80XFNwgXDR0zHSH5qiAtftmqnHRYeasOY
BZiyxoyyZFFw0BrTPKnzdONK6joWvSC/c5fRvC3bIbAkNCNzViQ9BBEc0f5Xrf4U
rvb4mXbD+o208Ax14sU2K3/klUydm3KR90UZYWnOKn5XMJ48rkgri6rd1BCsqEM4
1XIEyGcn9Wo1HOckSnKqSfgKsOBbCgKKLoPTVsdUfyXOE7L2fKmfs6W3LntoYyxZ
hd8YxFD/dON559IDVbUfikhfbX71NStJVkAWwYE/sQzH3Y5JWzri0Io9D1CZpjm1
gMVRSzAUsuqyoLw0geAe
=SrCD
-----END PGP SIGNATURE-----

--=-5eqc29bAttUjQh71Zhs/--

