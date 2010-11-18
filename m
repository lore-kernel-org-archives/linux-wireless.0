Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wp020.webpack.hosteurope.de ([80.237.132.27]:42988 "EHLO
	wp020.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935047Ab0KQWeT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Nov 2010 17:34:19 -0500
From: Michael Gerdau <mgd@qata.de>
To: =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: Re: [PATCH] ssb: drop BCM4328 hack for SPROM revision
Date: Thu, 18 Nov 2010 01:12:06 +0100
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
References: <1290019933-9924-1-git-send-email-zajec5@gmail.com>
In-Reply-To: <1290019933-9924-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4392141.GMKsCa1SWM";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <201011180112.18813.mgd@qata.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart4392141.GMKsCa1SWM
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

> This hacks leads to incorrect SPROM parsing for me and reading for
> example MAC as: 00:00:00:54:00:00. Michael G. who introduced this
> confirmed it is not needed anymore.
>=20
> Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com>
> ---
> Michael: I guess I could add your Tested-by. Is that right?

That ist right. I suppose the correct entry would be
Tested-by: Michael Gerdau <mgd@qata.de>

> John: it's 2.6.38 ofc. It should apply cleanly no matter if you applied
> my previous patch for guessing unknown SPROM revision. There is not
> dependence between that 2 patches.
> ---
>  drivers/ssb/pci.c |    4 ----
>  1 files changed, 0 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/ssb/pci.c b/drivers/ssb/pci.c
> index b5343ac..f529663 100644
> --- a/drivers/ssb/pci.c
> +++ b/drivers/ssb/pci.c
> @@ -580,10 +580,6 @@ static int sprom_extract(struct ssb_bus *bus, struct
> ssb_sprom *out, * Always extract r1. */
>  		out->revision =3D 1;
>  		ssb_dprintk(KERN_DEBUG PFX "SPROM treated as revision %d\n",
> out->revision); -	} else if (bus->chip_id =3D=3D 0x4321) {
> -		/* the BCM4328 has a chipid =3D=3D 0x4321 and a rev 4 SPROM */
> -		out->revision =3D 4;
> -		ssb_dprintk(KERN_DEBUG PFX "SPROM treated as revision %d\n",
> out->revision); }
>=20
>  	switch (out->revision) {


=2D-=20
 Michael Gerdau       email: mgd@qata.de
 GPG-keys available on request or at public keyserver

--nextPart4392141.GMKsCa1SWM
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAkzkb2IACgkQFas8bfo4d/ckAQCbBVCoLn1yDKBtH3umBnJCz0Ji
t0oAn2yH/fFG+wSl82ws2X+GJTdsYlza
=mrgz
-----END PGP SIGNATURE-----

--nextPart4392141.GMKsCa1SWM--
