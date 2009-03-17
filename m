Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41174 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975AbZCQXEz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2009 19:04:55 -0400
Subject: Re: rt2x00 mesh support
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Antonio Marques <froz@icix.org>,
	Andrey Yurovsky <andrey@cozybit.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200903180001.07723.IvDoorn@gmail.com> (sfid-20090318_000140_630826_AF91C22B)
References: <E8FC0565-5438-4AB5-A004-CD31DD9C1AA3@icix.org>
	 <200903172304.12595.IvDoorn@gmail.com>
	 <1237329348.5100.8.camel@johannes.local>
	 <200903180001.07723.IvDoorn@gmail.com>
	 (sfid-20090318_000140_630826_AF91C22B)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-dlMl5EUlPFTQTWn7KOw+"
Date: Wed, 18 Mar 2009 00:04:22 +0100
Message-Id: <1237331062.5100.9.camel@johannes.local> (sfid-20090318_000458_108174_4817A25E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-dlMl5EUlPFTQTWn7KOw+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-03-18 at 00:01 +0100, Ivo van Doorn wrote:

> > > This command means that mac80211 uses the start() callback function. =
This triggers rt2x00 to initialize
> > > the registers which resets the beacon generation.
> >=20
> > Strange, that doesn't seem right. If you look at net/mac80211/iface.c,
> > you'll see it call ->start(), then ->add_interface(), and later
> > ieee80211_start_mesh(), which calls _if_config() and sets
> > beacon/beacon_enabled.
>=20
> ok, I gone through the rt2x00 code a couple of times now to see how this =
bug can be triggered by rt2x00,
> But the only other scenario I could find, is when the open() callback for=
 the netdevice structure doesn't end
> with a call to the config() callback function. But as far as I see it tha=
t is happening correctly.

Maybe log (+dump_stack()) all the relevant calls from mac80211 to the
driver? That might give us a better idea of what's going on. Also,
Antonio, make sure you're using the very latest code. I for one need
sleep now :)

johannes

--=-dlMl5EUlPFTQTWn7KOw+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJwCxzAAoJEKVg1VMiehFY+fMQALj/BUHuIM8X7qtD/AYU2JSf
Ek2Lit1U/FLpmqTTt2nzrieecSleZCrqDUWfmNVRb/aUTGw679/7Xek2hSL4VV+E
7BWbh7DbSf7DJbN5lfDB5rNyrM/aW/5SHiGk0GWikIEKxngQNl/bd/WBaaFkY7yH
prbqrKCQNGhf9BaUrZ5eyXpaRQmiHpRMeDjx4/YgHKVKewhQ5vHJzKnlo9HRXK3h
HAHTT2lAbaqQr8KoLVVLvapCKc7pK+fnFmOsUXkh7Ce3c2EvOjsmQeLybEIBozDb
/tIGUrxGbTPIUmb5z6VJ9zdSm9OlJYf4v+L0xVdPN/KTCGKdd6pq51RBdXuuppbH
kETM4vLtS0L0JBA5N7a1dLLjjb+AwsDwXtzJswRaUlaGRYqm0qTWy2oodO9ZyIB+
1tsMQh1+J5Kacs5pzdunl7X23tYvEZfVfGL/LPcrQvgmTrqtnGcAk975A/BaTnIy
96091BTIrgJ09qCXtVuZU6TPWwAppNGxAKrTNSXZKVCBsJ9zcHBTuxC0LHsTsZpW
FOlMtkKNdMWjum2W63vYhM0Kc0Lyd+hxlYQ+4xJ/lmtaz+QyyJdZgtchNQUcPud8
jhHvVF0u/STqDwtMUfGwC67FGLzecrGp5qWLIEslmpHLN69R+mLBQnoHzWItHpMM
DBdHZrI5DObnCm+RpI/1
=HNvB
-----END PGP SIGNATURE-----

--=-dlMl5EUlPFTQTWn7KOw+--

