Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60498 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758127AbZASMAT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2009 07:00:19 -0500
Subject: Re: [PATCH 4/4] mac80211: use IEEE80211_IFSTA_MESH_CTR_INC macro
	to increment ttl.
From: Johannes Berg <johannes@sipsolutions.net>
To: Rami Rosen <ramirose@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	luisca@cozybit.com
In-Reply-To: <eb3ff54b0901190350w5ca5c3d0ocadbaa3c6cbac747@mail.gmail.com> (sfid-20090119_125114_759642_CD8FF056)
References: <eb3ff54b0901190350w5ca5c3d0ocadbaa3c6cbac747@mail.gmail.com>
	 (sfid-20090119_125114_759642_CD8FF056)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-VItTvg0j1+juZBqDr/dE"
Date: Mon, 19 Jan 2009 12:59:43 +0100
Message-Id: <1232366383.3864.0.camel@johannes.local> (sfid-20090119_130023_343421_C9DC52B0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-VItTvg0j1+juZBqDr/dE
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-01-19 at 13:50 +0200, Rami Rosen wrote:
> This patch replaces decrementing ttl explicitly with the
> IEEE80211_IFSTA_MESH_CTR_INC macro in mesh_hwmp.c
>=20
>=20
> Signed-off-by: Rami Rosen <ramirose@gmail.com>
>=20
> --
> (wireless-testing)
>=20
> diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
> index 4f862b2..1828d80 100644
> --- a/net/mac80211/mesh_hwmp.c
> +++ b/net/mac80211/mesh_hwmp.c
> @@ -507,7 +507,7 @@ static void hwmp_prep_frame_process(struct
> ieee80211_sub_if_data *sdata,
>=20
>  	ttl =3D PREP_IE_TTL(prep_elem);
>  	if (ttl <=3D 1) {
> -		sdata->u.mesh.mshstats.dropped_frames_ttl++;
> +	IEEE80211_IFSTA_MESH_CTR_INC(&sdata->u.mesh,dropped_frames_ttl);

For one, this is whitespace damaged, secondly, it's not necessary to use
the macro in a mesh-only file.

johannes

--=-VItTvg0j1+juZBqDr/dE
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJdGssAAoJEKVg1VMiehFYWbwP/0A8KHQnrUml53SffJce1+qJ
8cPXzdo9IEPh+++Zjrm6ygos4FuMDhZoqszQOVyQOEZt2ySHa/zFzBnj3dUW4u4j
asE9K6ZGii9YP19xwhw1zBylUhSZzmvDn+8eKcpo7aVrnJeS8n46Phsau5I8NG2Z
7iqmWLOhhyRjH+FQnrs0o9++u5G/MLD4xRoHclMd2/3EU9Bkrfgg9lgxunR/XDOu
CQJZy7dt4EXFIbe7bzv3q18ZWd2BhNmyXG97xjYVGql7pILLOGfaFmZF4o37Vn2j
4nU2BuNjHvO7fci8aer4jqjPybBiZh2Oi572ynpyIfFRyzI0VV/6axf1EAAM45TB
mDGrR3r78lZm4+7Oav1hbu1LmQwfayipxtwtkT7oVdKaGCRYGOZSvyzNlOHUbXVG
dA+qmZX5OGNMQRGmNO5HBBiRtSo9gC8SWFkS3oIsHZd5LHLnBlnqv9M3PgMiW2tr
GubxinGab9T39zDIT11ACpLk57Wg5kHXagAH086si+46KWOqH7Z+UWEgsrBsa1qo
Dq77ik0ox7d0ZuHSS3RhBPem/xvgT1uM0aWVBE8KQaejHiPw5Jr+fYRUVMHJN8SH
bh0jW00uOc8CFIBVJ4jJMUrrQGU8DWAZMGr8BdFyqHPyrN7aNs6CcK4A983Qs/q9
R/9L2IzoMCT2auc3b1fF
=hDWm
-----END PGP SIGNATURE-----

--=-VItTvg0j1+juZBqDr/dE--

