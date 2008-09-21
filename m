Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46236 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743AbYIUVb3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Sep 2008 17:31:29 -0400
Subject: Re: [PATCH v3] mac80211: mesh portal functionality support
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Luis Carlos Cobo <luisca@cozybit.com>,
	Yanbo Li <dreamfly281@gmail.com>
In-Reply-To: <445f43ac0809211031k310bd226x3b0b19e15846ba38@mail.gmail.com> (sfid-20080921_193219_897330_61ECA379)
References: <1222003802.3023.26.camel@johannes.berg>
	 <445f43ac0809211031k310bd226x3b0b19e15846ba38@mail.gmail.com>
	 (sfid-20080921_193219_897330_61ECA379)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-jJasGcEu9qrxFIVbxkdy"
Date: Sun, 21 Sep 2008 23:31:22 +0200
Message-Id: <1222032682.3023.59.camel@johannes.berg> (sfid-20080921_233144_000425_889CB04B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-jJasGcEu9qrxFIVbxkdy
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > +/* Mesh extent address flags */
> > +#define MESH_DATA_NO_EADDR     0x0
> > +#define MESH_DATA_EADD1_EADD2  0x2
>=20
> Just for consistency with the draft I suggest adding/renaming:
>=20
> #define MESH_AE_ADD4                         0x1
> #define MESH_AE_ADD5_ADD6              0x2
> #define MESH_AE_ADD4_ADD5_ADD6  0x3

Actually, now that I look at it, should we just define

#define MESH_FLAGS_AE_A4     0x1
#define MESH_FLAGS_AE_A5_A6  0x2
#define MESH_FLAGS_PS_DEEP   0x4


> > +                       if (meshdr->flags =3D=3D MESH_DATA_EADD1_EADD2)=
 {

> > +       if (mesh_hdr->flags =3D=3D MESH_DATA_EADD1_EADD2){
>=20
> There are other assigned and reserved bits in the flags field.  It's
> probably better to do...

and then in these two places use

if (..->flags & MESH_FLAGS_AE_A5_A6)

?

It seems to me that these are actually defined bitwise, 0x1 indicates A4
is in the AE and 0x2 indicates A5 and A6 are present.

johannes

--=-jJasGcEu9qrxFIVbxkdy
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI1r0mAAoJEKVg1VMiehFYA0IP/jyPzbh0NG21ZYyv4CjBrUut
sUi/AIFtnm3/jLAPpeXjTuonsfYTgWCNQlgeBGpQfu3rtkmq+g6U7+nzxljnFqYy
lALoK3sSMfJyUelntOGPhcC/h+n0s0XgWJqkgfWabnIiR7tUZGHocJZlhpcG2zA6
vH8fxbSQhuKQnVYT+vDtQj3Iz73wQb+JJ6d4sa8ipvRPO1aS1yhV4JymGRgUuBw0
zGKSISc3/cvBYSbdkKfHNQqiMrUHjerbbYjLjk6N2RHwHzrutiO0/mRwGCwv8zOJ
/Ie3bVq9y3/rGBoGjv0vXxAn+I2+pywGcEzKQGwNC688CiWjb+qvbqOQSfdlD0V/
dva5uy4p8g8I9QvxDqHX4D1F1lSQMtfWOTXqqzQErAlF4Rg2tUEDnNtQLZgKzBFz
81YB0gBxdoE8YNq+97uetumQvT351tRwQwleuLIQ/9coF4joKYxA7oJr1W5SP1W/
PzRqBNSxPydxWOegBXe1Lf8i60acHLAM2zsPpjZ/ktvPZJQiKak/wume1LTIG83B
XUkRWN0KGtNTK6p0nLtMmHUUWlMhl2f4zGv37djYklX2Y8yLCB7v0zjw8mIkPblm
raxLx1MM11MdsJXhE4YZ7kY6ayxzdGyTuFC9cos6prVSwtQyDPvxvpWwvphJ2BYl
d2I0+PwNiwD1tOHQHDEd
=ltfa
-----END PGP SIGNATURE-----

--=-jJasGcEu9qrxFIVbxkdy--

