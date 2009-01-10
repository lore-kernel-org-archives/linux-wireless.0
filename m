Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42775 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932AbZAJJNX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Jan 2009 04:13:23 -0500
Subject: Re: [PATCH] iw: Fix regression in mesh_param input parsing
From: Johannes Berg <johannes@sipsolutions.net>
To: Colin McCabe <colin@cozybit.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1231549996-15919-1-git-send-email-colin@cozybit.com> (sfid-20090110_021745_599151_06D1AB57)
References: <1231549996-15919-1-git-send-email-colin@cozybit.com>
	 (sfid-20090110_021745_599151_06D1AB57)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-/uHoo7OklSNUs38Df41g"
Date: Sat, 10 Jan 2009 10:14:26 +0100
Message-Id: <1231578866.3685.5.camel@johannes> (sfid-20090110_101330_059284_7EA978B6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/uHoo7OklSNUs38Df41g
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-01-09 at 17:13 -0800, Colin McCabe wrote:
> In the iw tool, don't crash on bad arguments to "iw dev mesh set mesh_par=
am"
>=20
> ---
>  mesh.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>=20
> diff --git a/mesh.c b/mesh.c
> index d6edf3f..f663363 100644
> --- a/mesh.c
> +++ b/mesh.c
> @@ -192,9 +192,10 @@ static const struct mesh_param_descr* find_mesh_para=
m(int argc, char **argv,
> =20
>  	/* Find out what mesh parameter we want to change. */
>  	mdescr =3D NULL;
> -	for (i =3D 0; ARRAY_SIZE(_mesh_param_descrs); i++)
> +	for (i =3D 0; i < ARRAY_SIZE(_mesh_param_descrs); i++) {
>  		if (!strcmp(_mesh_param_descrs[i].name, argv[0]))
>  			return _mesh_param_descrs + i;
> +	}

Ouch, sorry about that! Merged the patch, thanks.

johannes

--=-/uHoo7OklSNUs38Df41g
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJaGbsAAoJEKVg1VMiehFYFLMP/1QauTlALZ6gl63wGvP9JklN
ogZjSBtN2edri1TaKEv33TW4QkzKBgoQFaIgH1dWiYFll+CJkJ7up7jlFRCAw7pN
RFuzVGpisUXpJPSjrmvnDrgYYl/0+PKOblx3d31qYItPVqHaGVqA9pcx18JRYiPW
vqxVZNMHGUmOTjEs8SxAelzvBe1Wbm+x0YqsAq3uUsxZYKd12Elus0cXgsqF8NXw
MdqcKiDG8P21DQfeLYzp0NsD9PNbfXrJPGeGmUGbuoxvhOoHtwUw/NCGHiCgZDEO
mtTl52oyHzg1TfCzrHhl775fR9FVNwi2EP2NMy4pUPYSuHCWXuZbADyB73zAnUjs
R32mqzH++fl2pq3Nyyz3b9QfIFOogVBP+QCOrWgDAw3hIh/M4D0ESmV2/oedRshm
yFYFEma3tQBND5yCdkiNZEgGHdJ99EHIqn63dOokkYIRWmny7a9AopUJBssJz4nw
zBlME+7qm1/ChfqLZNfabV86a52dbpHEY1a8oPPovp8tF2uyaFHqu++8CMaJogP0
7pdfTJGt+1hHjegHWNfLqeDUgt/jzwOUU9PxFBiICKkti5p2F3ycOwM8GVbdBQoW
nD4COysZ+dxFnXTAlXIhsSizXMC0rnSu6fm5wrorgDkuUEzJwVkd0h/IelhaIcQs
efaL9RqDxZWkJo52DwvD
=8WEf
-----END PGP SIGNATURE-----

--=-/uHoo7OklSNUs38Df41g--

