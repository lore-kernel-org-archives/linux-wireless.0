Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp209.alice.it ([82.57.200.105]:50599 "EHLO smtp209.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755952Ab1DFOHZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2011 10:07:25 -0400
Date: Wed, 6 Apr 2011 16:06:54 +0200
From: Antonio Ospite <ospite@studenti.unina.it>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, openezx-devel@lists.openezx.org,
	"John W . Linville" <linville@tuxdriver.com>,
	Liam Girdwood <lrg@slimlogic.co.uk>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	linux-kernel@vger.kernel.org, Marek Vasut <marek.vasut@gmail.com>,
	Guiming Zhuo <gmzhuo@gmail.com>
Subject: Re: [PATCH] rfkill: Regulator consumer driver for rfkill
Message-Id: <20110406160654.e629dfde.ospite@studenti.unina.it>
In-Reply-To: <1302082178.3811.7.camel@jlt3.sipsolutions.net>
References: <1302081679-812-1-git-send-email-ospite@studenti.unina.it>
	<1302082178.3811.7.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__6_Apr_2011_16_06_54_+0200_BgR7JzPikK0uFaxl"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Signature=_Wed__6_Apr_2011_16_06_54_+0200_BgR7JzPikK0uFaxl
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 06 Apr 2011 11:29:38 +0200
Johannes Berg <johannes@sipsolutions.net> wrote:

> On Wed, 2011-04-06 at 11:21 +0200, Antonio Ospite wrote:
>=20
> > +	if (regulator_is_enabled(vcc)) {
> > +		dev_dbg(&pdev->dev, "Regulator already enabled\n");
> > +		rfkill_data->reg_enabled =3D 1;
> > +	}
> > +	rfkill_init_sw_state(rf_kill, !rfkill_data->reg_enabled);
> > +
> > +	ret =3D rfkill_register(rf_kill);
>=20
> We recently had a thread about how rfkill_init_sw_state() isn't quite
> working the right way. Also, it is indented to be used for devices that
> keep their state over resume. I think you should remove it here and rely
> on rfkill to sync you after registration.
>=20
> Cf. the long thread here:
> http://thread.gmane.org/gmane.linux.acpi.devel/49577
>

Ok, but I still need to replace that call with a rfkill_set_sw_state()
to expose the initial status of the regulator to the rfkill system,
right?

> Other than that, no comments from me from an rfkill POV.
>=20
> johannes
>=20

Thanks I am waiting a couple of days before sending a v2.

Regards,
   Antonio

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?

--Signature=_Wed__6_Apr_2011_16_06_54_+0200_BgR7JzPikK0uFaxl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk2cc34ACgkQ5xr2akVTsAEX/QCgiqleQlOE24P70b6zDpJVQEUP
NyEAn1yDa6vzoDR3LrxB0O/yJ0Yq8ZBk
=x5n3
-----END PGP SIGNATURE-----

--Signature=_Wed__6_Apr_2011_16_06_54_+0200_BgR7JzPikK0uFaxl--
