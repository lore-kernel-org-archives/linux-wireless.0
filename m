Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:57753 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190AbXHOL7r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Aug 2007 07:59:47 -0400
Subject: Re: warnings in iwlwifi
From: Johannes Berg <johannes@sipsolutions.net>
To: ian <ischram@telenet.be>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Tomas Winkler <tomasw@gmail.com>, Zhu Yi <yi.zhu@intel.com>
In-Reply-To: <46C2E992.5070805@telenet.be>
References: <1187133051.31200.26.camel@johannes.berg>
	 <46C2E992.5070805@telenet.be>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-umrk8nlDyFNQwTtm1rod"
Date: Wed, 15 Aug 2007 14:02:23 +0200
Message-Id: <1187179344.3998.38.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-umrk8nlDyFNQwTtm1rod
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-08-15 at 13:54 +0200, ian wrote:

> > 	le16_to_cpu(phy_flags_hw & RX_RES_PHY_FLAGS_ANTENNA_MSK) >> 4;
> >=20
> > looks totally bogus unless you somehow do macro magic to define the
> > RX_RES_PHY...MASK in little endian...
>=20
> iwl-hw.h:#define        RX_RES_PHY_FLAGS_ANTENNA_MSK            __constan=
t_cpu_to_le16(0xf0)

> I don't understand how this would generate the warning though

Ah, so there is macro magic. Why that, and not just convert the value to
CPU first and then mask? i.e.
#define        RX_RES_PHY_FLAGS_ANTENNA_MSK            0xF0
and use
	(le16_to_cpu(phy_flags_hw) & RX_RES...MSK) >> 4
or something?

> > Maybe it's time for you to get a cross compiler or better yet buy a
> > big-endian machine and actually test things on that? :)
> >=20
>=20
> No need for these drastic comments, for two warnings imho ;-)

:)

I'm spammed by warnings right now in my kernel build for some reason.
I'm guessing gcc got a bit more trigger-happy or something.

> I'm predicting that patch will arrive on linux-wireless soon too.
> (took me quite some time to figure this out, because I was looking at the=
 iwlwifi git)

Alright :)

johannes

--=-umrk8nlDyFNQwTtm1rod
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGwutP/ETPhpq3jKURAr3CAKCKmS4OjBRWeKyt3yX9601zR2nWCACeOhae
Ppt9mg+pEkHwgft7dG0NXyI=
=6dJ7
-----END PGP SIGNATURE-----

--=-umrk8nlDyFNQwTtm1rod--

