Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp209.alice.it ([82.57.200.105]:44960 "EHLO smtp209.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755952Ab1DFO3K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2011 10:29:10 -0400
Date: Wed, 6 Apr 2011 16:29:01 +0200
From: Antonio Ospite <ospite@studenti.unina.it>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-wireless@vger.kernel.org, openezx-devel@lists.openezx.org,
	"John W . Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Liam Girdwood <lrg@slimlogic.co.uk>,
	linux-kernel@vger.kernel.org, Marek Vasut <marek.vasut@gmail.com>,
	Guiming Zhuo <gmzhuo@gmail.com>
Subject: Re: [PATCH] rfkill: Regulator consumer driver for rfkill
Message-Id: <20110406162901.0efa11ad.ospite@studenti.unina.it>
In-Reply-To: <20110406141131.GC2810@opensource.wolfsonmicro.com>
References: <1302081679-812-1-git-send-email-ospite@studenti.unina.it>
	<20110406141131.GC2810@opensource.wolfsonmicro.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__6_Apr_2011_16_29_01_+0200_y1Jge.GaRKe2jFhV"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Signature=_Wed__6_Apr_2011_16_29_01_+0200_y1Jge.GaRKe2jFhV
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 6 Apr 2011 23:11:33 +0900
Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> On Wed, Apr 06, 2011 at 11:21:19AM +0200, Antonio Ospite wrote:
>=20
> > +	tristate "Generic rfkill regulator driver"
> > +	depends on RFKILL || !RFKILL
>=20
> That looks *odd*.

Taken from Documentation/rfkill.txt section 3.  Kernel API.
I guess I can drop it if we want to be stricter and just require RFKILL
to be enabled. Johannes?

> Otherwise this looks fine from a regulator API point
> of view.  You use an exclusive get() so you could get away without
> remembering the enable state as nothing else could hold the device open
> but there's no harm in doing so and it's defensive against silly
> constraints that force the regulator on.
>=20

Thanks Mark.

Regards,
   Antonio

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?

--Signature=_Wed__6_Apr_2011_16_29_01_+0200_y1Jge.GaRKe2jFhV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk2ceK0ACgkQ5xr2akVTsAHw8wCeJ1SFlc0FYqYQifw4c35qs3qn
fPUAni64Tm91GrqZMb7LCsOVE+rT2eld
=Pc7K
-----END PGP SIGNATURE-----

--Signature=_Wed__6_Apr_2011_16_29_01_+0200_y1Jge.GaRKe2jFhV--
