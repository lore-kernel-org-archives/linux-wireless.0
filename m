Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34079 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753646AbZARRMO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Jan 2009 12:12:14 -0500
Subject: Re: [PATCH 08/13] cfg80211: save original values on regulatory
	hints
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20090118152844.GR29609@tesla>
References: <1232064746-17134-5-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-6-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-7-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-8-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-9-git-send-email-lrodriguez@atheros.com>
	 <1232097921.3854.28.camel@johannes> <20090116163100.GE29609@tesla>
	 <1232138062.3745.6.camel@johannes> <20090116210655.GK29609@tesla>
	 <1232268449.3877.8.camel@johannes>  <20090118152844.GR29609@tesla>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-W0NbQG2Ji8CZt8mmeEXz"
Date: Sun, 18 Jan 2009 18:12:05 +0100
Message-Id: <1232298725.3819.4.camel@johannes> (sfid-20090118_181220_480421_8569E034)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-W0NbQG2Ji8CZt8mmeEXz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-01-18 at 07:28 -0800, Luis R. Rodriguez wrote:

> Just so you know the approach I started taking for v3 of this series
> was to apply save the orig_* parameters if REGDOM_SET_BY_DRIVER and
> the request->wiphy =3D=3D wiphy. This works OK except if you have "US"
> as your regulatory domain and you have OLD_REG set cfg80211 will have
> already have called for a new regulatory domain update for "US" so
> this is -EALREADY. Some changes are then required to inform drivers
> through the reg_notifier() of this. This is where I was at now.

Yeah, I know.

> > I think you're hampered by not being able to simply request a
> > regdomain from crda outside the normal "apply regdomain" flow,=20
>=20
> Well I have a few approaches already which have worked but I like to=20
> think we're looking for the most simple solution so its easier to
> support this for other drivers as well.

Right.

> > maybe we
> > should think about that instead? Then ath9k could just request a
> > regdomain from crda before it even registers its wiphy?
>=20
> Are you suggesting we consider new API for drivers which want the
> behaviour we want? That works for me too, but then again I'd be applying
> the save orig_* stuff perhaps at the end of this new, say,
> regulatory_hint_strict().

Well, I was more thinking to have a=20
struct regdomain *cfg80211_ask_crda(const char *alpha2);

but I realise that is very hard to implement with the call to userspace
etc. So yeah, doing something like the _strict you propose seems more
appropriate. Maybe call it something else, not _hint,and have it call
out to userspace regardless (i.e. don't ever ignore that hint, as we
might ignore other hints), say regulatory_apply(wiphy, alpha2)? Not
sure, apply seems not quite right either.

johannes

--=-W0NbQG2Ji8CZt8mmeEXz
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJc2LiAAoJEKVg1VMiehFY+P8QAL8+uAAl5lESqJqLoQeGB/D6
nJqyykmMreC7Cvz8Oofc5ZGEfx7jFO1xUyYNQAK3EMAQsTydP5DgEg22ZtiYbfTA
XAgYB/qfYSGociZJVSG6WJ5Tv7Zz8yNbWP5pgUECUAPXdupkZE6oqcn1KQ5UNPUf
CEowWDBhFK1nONpSKdrKisclK4KjBFpe1OjYu5TfuUXj7YdSMvmrVIe9zHymN1DP
xoaRmFqF59VR9hfszPwYOLSbPp//7HqpnceMdvIFlzLaUHDS0iDP9/st5fpFE6dg
zKZNWw+YsLEMUCBEx/1A7XhwuHjcnzwisag47Q7EWq25B/MKQcxcI2eQ0ojISAJ9
pbc79aVWQ5NYkcDpSjpMsEDo3ETgI45tc9r7T4bISmd4OXKAXZUThIc3k1DV9Zca
ipNyBdehvIVCWKPq5OVIXNUYerx/AwduFuuZGSzo1NfmPjS6KyWDAOuanJSczcMz
fDQM/WYb+2mTm0z8jpCDpk86Jr08ZMDUR1Jv8Pbtyn9x/rCJ4UZ/DXA66rfkXRdR
JXZJFYiSweRczAY4Jm7RZeJqRb7B3z0vsjxwkr10zT/3oU2UiefDZ7Bh9616eJ4O
G0yyr5hVTXU7ZCdaUnkHNO8by8/k0BvejfFENHdx9bIYRbq9D1AF6VAPonRZN4qE
BCpFRoTMkqqXYc/b9G8S
=fBDs
-----END PGP SIGNATURE-----

--=-W0NbQG2Ji8CZt8mmeEXz--

