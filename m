Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49462 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499Ab0AYSdp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2010 13:33:45 -0500
Subject: Re: [PATCH v3 1/1] mac80211: tell driver when dtim change detected
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"j@w1.fi" <j@w1.fi>, Kalle Valo <kalle.valo@nokia.com>
In-Reply-To: <43e72e891001251018h1a62e1ccn4a7d1411fa2c0615@mail.gmail.com>
References: <1264109996-15995-1-git-send-email-wey-yi.w.guy@intel.com>
	 <1264186981.2593.10.camel@johannes.local>
	 <43e72e891001221120i79c6525bo4852cb5a6c7a37@mail.gmail.com>
	 <1264189560.2593.14.camel@johannes.local>
	 <43e72e891001221544j1b1bd67ao8dfcf4d0dd12dd81@mail.gmail.com>
	 <1264205494.7208.7.camel@wwguy-ubuntu>
	 <43e72e891001221623v477b9fady32237c1a3aededda@mail.gmail.com>
	 <1264206170.7208.8.camel@wwguy-ubuntu>
	 <1264250814.2593.25.camel@johannes.local>
	 <43e72e891001251018h1a62e1ccn4a7d1411fa2c0615@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-4ohVme2o+acKfq6WdY5L"
Date: Mon, 25 Jan 2010 19:33:38 +0100
Message-ID: <1264444418.23766.53.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-4ohVme2o+acKfq6WdY5L
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2010-01-25 at 10:18 -0800, Luis R. Rodriguez wrote:

> > Yes, since 0 is nonsensical, we would use 1 instead.
>=20
> OK -- it seems we have a consensus waiting for a beacon would be good,
> but it would be good to have something in for stable. Is the patch Guy
> posted acceptable for that purpose? That is, merge this for now until
> we get beacon wait implemented prior to association.

Not sure we even need it in stable that badly? It seems it only hurts
power consumption somewhat. And I just implemented waiting today too.

Although Bob has a point, we could change the way we pass the DTIM
period to the driver, only pass it in the powersave callbacks, and then
we could associate without it and just enable powersave only after
receiving a beacon. That assumes that drivers don't use it for anything
else though, of course, but I don't see anything else you could use it
for really.

johannes

--=-4ohVme2o+acKfq6WdY5L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLXeP/AAoJEODzc/N7+QmaYVoP/jc6ZGyTfwGREuJKoIhg6X0B
RPH0hAZ+KCqNMTiSbJm+6iCTPH44BQTFKVmHWdc4+iPShP7n4TtkEAa1E1P/RA3t
FFB51uBuv4ducfW5HGktFgGhMf1wtumzAOhZxiH+Zr1oXsH+TIKyHP5uNOA9IaWm
ZbiC1/bvsjVcY9O4vbqhKhL0HYTHftsO2cCpoik1DpAvtqBNY6Ttc7rt2mSAPx4x
hUgVKzVWNPP5VCO/aoAToufXKjqNY+cca2R1Lm9PcNjrlKwvU7RKfuzhSlwd67Mr
iDWITOYYRC4irqLDAd9Xry6/WWemca7wbjTh6+BUJz8tBCwi9OyFvoC4pTXMQuPq
Cz/ZdttQeN22oGEAbJOqRWoWoUYtDYGB+hfR8NOYmih/GlIERZ7YjCaejhKn2DTM
bF+UKh3I32mPdn+q76/WhzxaHVy4Xp+eb3ipgcXLKmzONxkHL4bJP7mNyYMWV4L2
RJRQ4OMPqZ4NYek2Mo3SWTGHjWUJyVT9lOGBlH2NKLEjNEbl6Z0C5HCgc2xc/UZr
zzRCu0rmM7X6bSwGVuvjxCAKmhaTSQag2ax8hFFZTX9ulWUilehWkQ1SjpUTgNWs
r2jUDdXfas9FtVNVJyvt7Wa51JPAl6Qyuf9NK+LHCVbo5Mg3QO8dwyuw76r3EkVI
iQcEtqMLjkRbObrix17H
=+ZTe
-----END PGP SIGNATURE-----

--=-4ohVme2o+acKfq6WdY5L--

