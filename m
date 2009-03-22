Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56094 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082AbZCVNDe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Mar 2009 09:03:34 -0400
Subject: Re: [PATCH] Marvell CF8381
From: Johannes Berg <johannes@sipsolutions.net>
To: Marek Vasut <marek.vasut@gmail.com>
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org,
	hs4233@mail.mn-solutions.de
In-Reply-To: <200903221401.58743.marek.vasut@gmail.com> (sfid-20090322_140150_033503_6DD30533)
References: <200903220127.21836.marek.vasut@gmail.com>
	 <200903220511.50229.marek.vasut@gmail.com>
	 <1237709048.5100.682.camel@johannes.local>
	 <200903221401.58743.marek.vasut@gmail.com>
	 (sfid-20090322_140150_033503_6DD30533)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-HB2j2+vXGJGGihtGsd2K"
Date: Sun, 22 Mar 2009 14:03:30 +0100
Message-Id: <1237727010.19647.3.camel@johannes.local> (sfid-20090322_140335_866015_990CA212)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-HB2j2+vXGJGGihtGsd2K
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-03-22 at 14:01 +0100, Marek Vasut wrote:

> > > diff --git a/drivers/net/wireless/libertas/cmd.c
> > > b/drivers/net/wireless/libertas/cmd.c
> > > index 639dd02..ce32bc9 100644
> > > --- a/drivers/net/wireless/libertas/cmd.c
> > > +++ b/drivers/net/wireless/libertas/cmd.c
> > > @@ -123,7 +123,7 @@ int lbs_update_hw_spec(struct lbs_private *priv)
> > >          * only ever be 8-bit, even though the field size is 16-bit.=20
> > > Some firmware
> > >          * returns non-zero high 8 bits here.
> > >          */
> > > -       priv->regioncode =3D le16_to_cpu(cmd.regioncode) & 0xFF;
> > > +       priv->regioncode =3D (le16_to_cpu(cmd.regioncode) & 0xFF00) >=
> 8;
> >
> > I'd be more inclined to think that this was an endian bug? Does your
> > machine happen to be big endian?
>=20
> intel pxa270 (little endian). Btw. that macro le16_to_cpu should handle t=
he=20
> endianness, shouldn't it ?

Yes, but maybe that part is _not_ a le16 but two u8s. :) But if you're
on LE too then I guess that's not it.

johannes

--=-HB2j2+vXGJGGihtGsd2K
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJxjcfAAoJEKVg1VMiehFYOzwQAKV4RBuJ9/RZw4VSgP1CNNmv
Zh8KtiTjpKlIL28J0BrHgwZCxNEM7NsLhcKrPzoIt7KSSs1NHqaoo/QQlyW03syB
6DncVbLN6qMoXTFTtXcLHcwCi/giQjsxk2ntiicLkEbfWRpr29xX3xhbXUGR6KOb
zRzzkDq1YrPtD39wFNb6Wg0JzhXVXpCSUhemFQgCTNwo9aJJa+GmoR4hoMvWV476
/BvhOSQElP9cJIRVExe0Z6fZ7e06UxnZnjx7tiEaEuh8jxSViWBuw2iomjSJNTSV
WRbyyobpeIy6kcntT/+eiz4gF03Uawk2UDXo9RPqorVJBIRj3UXgeXieDTY8i2PD
3wWXgyvXWbpxWfY/jbotWuNrmdqVnadfJDLq8kj/v4y0Y9gz49uEmnoOuOszO+v8
7Z90D9XxXij3KN0UP/sFeQHVGUwW55ckwkXQCgf7w3vdpDNUeRGBzWXoCeuhifpa
Q/a4sjxpA15Df1JTSc/6yLxFztzYLFrPNuJsPEvDlnbIcplISSzdEycHbkVey0T4
ukIZfNnxk6qsuCEvHK9W0yK/suyHEgnmi666I1/cR3g8hYH3F+IbDX+oaa6g+Q8v
rlr54sy6o44n+kficrekMA6ovtpOAPu8Vj4hZwAxIrAH86D8Pi/DUTJZ6qto632E
c7vtKOiJ0gif9SRqgxOM
=LCxE
-----END PGP SIGNATURE-----

--=-HB2j2+vXGJGGihtGsd2K--

