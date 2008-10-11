Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx39.mail.ru ([194.67.23.35]:49807 "EHLO mx39.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754924AbYJKSfT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Oct 2008 14:35:19 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Dave <kilroyd@googlemail.com>
Subject: Re: [PATCH 1/2] orinoco: reload firmware on resume
Date: Sat, 11 Oct 2008 22:34:22 +0400
Cc: orinoco-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
References: <200810111816.26370.arvidjaar@mail.ru> <48F0E58F.6000900@gmail.com>
In-Reply-To: <48F0E58F.6000900@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart53211554.Vex7JbhyvN";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200810112234.59773.arvidjaar@mail.ru> (sfid-20081011_203525_278974_5ADCF569)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart53211554.Vex7JbhyvN
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Saturday 11 October 2008, Dave wrote:
> Andrey Borzenkov wrote:
> > On resume card state is likely lost so we have to reload firmware
> > again.
> >=20
> > Signed-off-by: Andrey Borzenkov <arvidjaar@mail.ru>
> >=20
> > ---
> >=20
> > This is non-functional without second patch. Currently you simply
> > have no way to load request firmware from user space in ->resume.
>=20
> Does it work when you compile the firmware into the kernel image
> with CONFIG_FIRMWARE_KERNEL, CONFIG_EXTRA_FIRMWARE and
> CONFIG_EXTRA_FIRMWARE_DIR?
> =20

I assume yes - but the resulting binary cannot be redistributed, so it
of little help; it means, orinoco driver in distributions still won't
work out of the box.

[From another mail]
> Spectrum_cs has had firmware download for a while. It achieves the firmwa=
re
> reload on resume by doing schedule_work(&priv->reset_work).
>
> Would the same work for orinoco_cs?

You (currently) have no way to synchronize reset_work with unfreezing
other tasks. It may work most of the time but it may as well fail every
now and then. Also spectrum_cs is obviously broken - it claims hardware
and interface are available *before* they are actiually available. This
again is hard to debug race condition.

It is planned to add pre-freeze notifiers; in this case we could use them
to load firmware before suspend. But right now I do not see how this situat=
ion
is different from compiling firmware in module except that it is more clean
from legal point of view.

Personally I prefer to use it right now (ideally in 2.6.28; do not know who
decides) and return to it later when we have better interfaces.

> > +	int err =3D 0;
>=20
> The explicit initialisation is unneccesary.

OK it is leftover; I tried first to load firmware before hermes_init; it
worked for STR and failed for STD. I'll remove it; thank you.

--nextPart53211554.Vex7JbhyvN
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkjw8bcACgkQR6LMutpd94w6EgCgwwpKjRu3wckAunnDN/tsubAh
/vgAn2Wshofa3gKUZaZ8qORrHXS2buXL
=0/3s
-----END PGP SIGNATURE-----

--nextPart53211554.Vex7JbhyvN--
