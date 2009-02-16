Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40944 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846AbZBPJWb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Feb 2009 04:22:31 -0500
Subject: Re: [PATCH 05/10] cfg80211: add regulatory_hint_core() to separate
	 the core reg hint
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890902160117yd3a3b09o45ada7bc0aa0fbd7@mail.gmail.com> (sfid-20090216_101803_498555_14F95098)
References: <1234589627-16977-1-git-send-email-lrodriguez@atheros.com>
	 <1234589627-16977-6-git-send-email-lrodriguez@atheros.com>
	 <1234695593.4219.47.camel@johannes.local>
	 <43e72e890902160014k11ba609lbe1340750771b6c0@mail.gmail.com>
	 <1234774211.4219.102.camel@johannes.local>
	 <43e72e890902160117yd3a3b09o45ada7bc0aa0fbd7@mail.gmail.com>
	 (sfid-20090216_101803_498555_14F95098)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Y2lJNXE8H0anIS5giS0t"
Date: Mon, 16 Feb 2009 10:22:25 +0100
Message-Id: <1234776145.4219.113.camel@johannes.local> (sfid-20090216_102235_286610_0CE76992)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Y2lJNXE8H0anIS5giS0t
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-02-16 at 01:17 -0800, Luis R. Rodriguez wrote:

> >> > So before you documented that cfg80211_mutex is used to protect this
> >> > variable, but it's not used here.
> >>
> >> This is only used during initialization, have any better ideas?
> >
> > If regulatory is initialised before netlink that is probably fine, is
> > it?
>=20
> Yeah I was hoping that would be the case but then I realized that we
> also end up creating a udev event to call crda and we need nl80211
> initialized in order to process these hints so technically we have a
> race between regulatory_init() finishing and nl80211_init() get done
> before we can let nl80211 process the first CORE call to crda so it
> may be dropped -- unless we are sure udev will do some sort of
> retries.
>=20
> An alternative is to add the regulatory_request() for core to the
> queue and then call a reg_post_init() on core.c  that would just
> schedule the reg workqueue after nl80211_init().
>=20
> Thoughts?

Can't you just do the proper locking and initialise regulatory after
nl80211?

johannes

--=-Y2lJNXE8H0anIS5giS0t
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJmTBPAAoJEKVg1VMiehFYqU8QAKc52ZQBq3S4t1NLGP3DR3Uv
JUOji4uoIz8iAOALEyyis+6LNjWGqnghXVgxk+5t2NW6WSQFjyVPfrrefkeobF+b
jio2hwMrAAnfNT3XF2rF8L4ZSNqEXl/muxAJd1YV1qr+WA8tYC5NSmDHCkJ1EBMx
+zZNbBgItE9xzb4sxWfGrkDMFJulZIxxT0OK3R1+BN7lA9OREwW3PQa46TF+l4+z
d+O7/wF0WerfClyK2hE97+ni33TF/OktlBwRCaGJz7A/RIiKS5r03ckU0LUIz4Jp
2Vt6EkK9WNJOYdQ2FofF5WDV6ndYTgde3+w5w0OzSQhPNI9ztg+Os7LJl4Q6+/Fc
foX3Aq/8EVQWCWA8X7fQSPk3xL+Fa/YHiHWyjLKZeGRndI8S0u4OBBNnuFum0hp4
6LIfJkXug+jJcLoi6UFNBkgJLmddRCHv3GDGSMo+6zgokgJ4GQ8JrglKUb7lp4wv
Pj0a2uHFfzbtspYADIcNUuKdDeZT5W51qkza1aUez8Eh+CCJWUUt4bqoyg5QA9j2
QK0q/kYLPEjRRIb9Lzu5ofG810Sqx8R+dkmmyyeRqSq0Gw5VwV3EyjAMSGDcmoRi
Mhy5vpVJYI0imyErq2AQMjvXatv5DRxF1BgR6iHdiuCGlYvf2Nh3Lhm/HvbLarIO
YAgbSdcleGR+hofYk0qC
=oRXq
-----END PGP SIGNATURE-----

--=-Y2lJNXE8H0anIS5giS0t--

