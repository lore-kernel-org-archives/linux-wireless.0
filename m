Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36703 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757817AbZAPUe1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2009 15:34:27 -0500
Subject: Re: [PATCH 08/13] cfg80211: save original values on regulatory
	hints
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20090116163100.GE29609@tesla>
References: <1232064746-17134-1-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-2-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-3-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-4-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-5-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-6-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-7-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-8-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-9-git-send-email-lrodriguez@atheros.com>
	 <1232097921.3854.28.camel@johannes>  <20090116163100.GE29609@tesla>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-vXXoLlU9w8QmGmvVvH6o"
Date: Fri, 16 Jan 2009 21:34:22 +0100
Message-Id: <1232138062.3745.6.camel@johannes> (sfid-20090116_213430_680616_BF185ECE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-vXXoLlU9w8QmGmvVvH6o
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-01-16 at 08:31 -0800, Luis R. Rodriguez wrote:
> On Fri, Jan 16, 2009 at 01:25:21AM -0800, Johannes Berg wrote:
> > On Thu, 2009-01-15 at 16:12 -0800, Luis R. Rodriguez wrote:
> > > When a driver issues a regulatory_hint() lets save the received
> > > values as original channel settings. This allows users to change
> > > regulatory domains multiple times while always respecting the driver'=
s
> > > own regulatory setings.
> >=20
> > This definitely isn't the right way to do things here. This means that
> > my card that's programmed to US can never do channel 13 here, something
> > which on b43 we definitely want to allow.
>=20
> Ah -- are you sure you want to allow for that?=20

Yes.

> It seems I was misunderstanding a bit
> how things would be done for 11d in ath9k and the fact is that we *don't*=
 allow
> for channels beyond what the programmed regulatory domain allows. This is=
 because
> calibration stuff has only been tested/ensured/certified/call-it-what you=
 want
> for the channels in that regulatory domain SKU.=20

Yes, I know why you want this, but I think you should do it slightly
differently.

> Are you certain that b43 can operate
> well on channels not in their regulatory domain SKU? If so then how about=
 a wiphy flag
> to let drivers pick this.

I don't see a need for a flag. We just need to have the driver set
orig_flags rather than cfg80211, no?

johannes

--=-vXXoLlU9w8QmGmvVvH6o
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJcO9LAAoJEKVg1VMiehFYVAoP/japGFarL1dBTNZF+I3+IOTe
aIB8Jv27XrnQRoMSFEaNorZ9o4w7i5IGw1t5SiBXeS+kF3UZroJIGvCgBY/LwAz5
KcAoelE5B9j8/hj834R1GGPZYMC9Xm5nhYSpDy5SEA1x7uZUFhG0X01eJ2/w/lw5
3ZUpdEy8l46oucaGiVjsjm8MzeUX39K12Uu6BdEVfV5vKt/Bh6fz8x43t7Tli03g
o1pZDbL8Eo1OgGjfKyuzPoePc0kWcL7lcehmHw5CmyCe/C667h9S77aKWYdaREyT
oH+L0cVZaMpeftRNyL1HXTOQa8wCWTuAOOdX+C7+bs6AhpJqveO8aXuBCUGdoYgo
1U9pcfZr6Xcl2K9rG559Ri1IjMKAkn4E/tvqE3J01Jp4kKsAzoXMhH3/woMegS5m
bieB7LCfo3PvixpzQ6SaxgcNOEk41lsLK4i+5Eh7Cb97uq4UVdazIRHXWJyhJr4Y
ge2vQE8aVXbaFA7t+c6lU+nxiq+3dWiBAwMvO93pBlhjnUXEdXi7/1rNvfnfb5Vx
GuuCISaW15XL3if+akfWBjVeF2QUBcgGSHWA79BoWYpAK679k2iEnPc/VxYxYNMM
6LemK/jsbNnw8TzT8Kv79GHWhqkl2e6U9GjtEl4gNw8MWfKlkdyvW3nZkvbXJQG4
kR0K1uGlWLOv9wysWfL5
=zjHZ
-----END PGP SIGNATURE-----

--=-vXXoLlU9w8QmGmvVvH6o--

