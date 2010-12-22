Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37342 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751717Ab0LVEMQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Dec 2010 23:12:16 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Julien Cristau <jcristau@debian.org>, 599345@bugs.debian.org,
	ilw@linux.intel.com, linux-wireless@vger.kernel.org
In-Reply-To: <1286983826.3640.57.camel@jlt3.sipsolutions.net>
References: <20101006191947.GA3036@radis.liafa.jussieu.fr>
	 <1286402043.2955.81.camel@localhost>
	 <1286437870.3657.16.camel@jlt3.sipsolutions.net>
	 <1286737393.2955.225.camel@localhost>
	 <20101013151716.GA3167@radis.liafa.jussieu.fr>
	 <1286983826.3640.57.camel@jlt3.sipsolutions.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-fujP5BzIk9flY/gqENTu"
Date: Wed, 22 Dec 2010 04:11:44 +0000
Message-ID: <1292991104.2874.26.camel@localhost>
Mime-Version: 1.0
Subject: Re: Bug#599345: linux-image-2.6.32-5-amd64: iwlagn allocation
 failure
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-fujP5BzIk9flY/gqENTu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2010-10-13 at 17:30 +0200, Johannes Berg wrote:
> On Wed, 2010-10-13 at 17:17 +0200, Julien Cristau wrote:
>=20
> > Getting lots of those in dmesg:
> > iwlagn 0000:0c:00.0: Too many chunks: 2
> >=20
> > Doesn't seem to prevent the network from working though.
>=20
> It'll at least leak lots of memory though. But I think the check there
> is just wrong -- there are TFDs, and there are SKBs, and we need two
> TFDs, but just one SKB.

Right.  The old condition:
	if (num_tbs >=3D IWL_NUM_OF_TBS) {
should have been:
	if (num_tbs > IWL_NUM_OF_TBS) {
though in practice neither condition was possible.

In the minimal patch, the condition should be changed to:
	if (num_tbs > 2) {

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-fujP5BzIk9flY/gqENTu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUATRF6c+e/yOyVhhEJAQLk2w//ZYPu/gzXqxBBEafbpNi1kkrF+p8c4Ifv
L+aXUsTg95Gi3PGcT5xX+2VDcdg1F3W0fMs6AnNZ2NwaW0gqXhuc3a6CgBnhH/Af
th4fMoGBvLSTl6iQt0tC6oz46FVwyLMddrj5vbFnSDD6Yxuhrjwt5mzuc+dQcwcx
hh5mTwO4zPdB7NFe4Sv0tcSLMd/AUfuv1IUCW7hGAGRMfL3/Eq1D2rqnmUui+fQU
C/AK0venpUww0D4i3avTj56H8QKavkIzRwaAuPkz3H90j7xaGso7gulsRdslynpn
6Ac9SnMc3O/8qxgvDbk91L8ajG7CjTiom1pU0plwbYHBIw6wU4ugMg9zz4aeFqmL
L0wzeFLvNnv1joS91QG+Wk4rd7f8UXPREdbCjxalUE4/pa2IyE8s8tw3S0gNyx4O
VBRvbohxtFJSOuQX1VuKw3aXF15wwSRvF8mDjLKwME5FlRIIuLojsE07hzYCdXwV
xWMdsE5CDWpAXAhWgCPqpU6X2kUdit8YC4hSN7W7eHLCQTiDN6ZH9J/eYNUJVkSv
pxlO72ztSpLFFpfHjktj8+k7PgLNbHkJoVgfKkq1+ukIzk+CwcGRH4RG41lnjREJ
S5FpQ6h62+8XnF0PbJulM2MvXF/sISdKfGifhfU76VtR4Cugogz3G3hIEW5GkUnY
wWMM3se4ZKE=
=c0lj
-----END PGP SIGNATURE-----

--=-fujP5BzIk9flY/gqENTu--
