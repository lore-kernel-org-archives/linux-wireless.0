Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx30.mail.ru ([194.67.23.238]:32594 "EHLO mx30.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757750AbYJ3Sjn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 14:39:43 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Dave <kilroyd@googlemail.com>
Subject: Re: [Orinoco-devel] 2.6.28-rc2: new PCMCIA device instance after resume - orinoco can't download firmware
Date: Thu, 30 Oct 2008 21:39:36 +0300
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
	linux-pcmcia@lists.infradead.org,
	orinoco-devel@lists.sourceforge.net,
	linux-wireless@vger.kernel.org,
	Dominik Brodowski <linux@dominikbrodowski.net>
References: <200810282219.51492.arvidjaar@mail.ru> <20081029215142.GA29780@flint.arm.linux.org.uk> <4909F9BC.3050306@gmail.com>
In-Reply-To: <4909F9BC.3050306@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart5817223.MoGt4UGyqb";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200810302139.37864.arvidjaar@mail.ru> (sfid-20081030_193948_461085_11D6A025)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart5817223.MoGt4UGyqb
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 30 October 2008, Dave wrote:
> After much faffing about, I managed to bisect this. In retrospect the
> above hint (thanks Russell) and a code inspection ought to have made the
> bug obvious. The offending commit is:
>=20
> commit 1168386aa7d850ead2ae135d5a7949a592c6e9a0
> pcmcia: deprecate CS_OUT_OF_RESOURCE
>=20
> in which the following change is made (among others):
>=20
> @@ -352,7 +352,9 @@ int verify_cis_cache(struct pcmcia_socket *s)
>=20
>         buf =3D kmalloc(256, GFP_KERNEL);
>         if (buf =3D=3D NULL)
> -               return -1;
> +               dev_printk(KERN_WARNING, &s->dev,
> +                          "no memory for verifying CIS\n");
> +               return -ENOMEM;
>         list_for_each_entry(cis, &s->cis_cache, node) {
>                 int len =3D cis->len;
>=20

Oh, my ... I have been looking over this dozens of times ... it just
proves how addictive to bisecting in place of proper debugging we became :(
Dave, thank you!

Rafael, this falls in obvious "regression with patches" case I think.

Tested-by: Andrey Borzenkov <arvidjaar@mail.ru>


>=20
> The attached patch should fix things.
>=20
> Regards,
>=20
> Dave.
> ---
> pcmcia: Actually verify against the cached CIS
>=20
> Commit 1168386aa7d850ead2ae135d5a7949a592c6e9a0 introduced a printk into
> a single line if without adding braces, resulting in PCMCIA devices
> being added as new on resume.
>=20
> Add the necessary braces.
>=20
> Reported by: Andrey Borzenkov <arvidjaar@mail.ru>
> Signed-off by: David Kilroy <kilroyd@gmail.com>
> ---
> diff --git a/drivers/pcmcia/cistpl.c b/drivers/pcmcia/cistpl.c
> index 8d37768..91a00ec 100644
> --- a/drivers/pcmcia/cistpl.c
> +++ b/drivers/pcmcia/cistpl.c
> @@ -351,10 +351,12 @@ int verify_cis_cache(struct pcmcia_socket *s)
>         char *buf;
>=20
>         buf =3D kmalloc(256, GFP_KERNEL);
> -       if (buf =3D=3D NULL)
> +       if (buf =3D=3D NULL) {
>                 dev_printk(KERN_WARNING, &s->dev,
>                            "no memory for verifying CIS\n");
>                 return -ENOMEM;
> +       }
> +
>         list_for_each_entry(cis, &s->cis_cache, node) {
>                 int len =3D cis->len;
>=20
>=20
>=20
>=20



--nextPart5817223.MoGt4UGyqb
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkJ/2kACgkQR6LMutpd94z2lQCfa7I3R7G61sfCAwPqT2mK0XRg
p2cAn2woGB5KlR4kf3RojfZEEHd/1jDT
=ShCQ
-----END PGP SIGNATURE-----

--nextPart5817223.MoGt4UGyqb--
