Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51287 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700Ab0BHNqQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Feb 2010 08:46:16 -0500
Subject: Re: [PATCH 2/2] mac80211: give warning if building w/out rate ctrl
 algorithm
From: Johannes Berg <johannes@sipsolutions.net>
To: Andres Salomon <dilinger@collabora.co.uk>
Cc: linux-wireless@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <20100207214837.027dfd3d@mycelium.queued.net>
References: <20100207214837.027dfd3d@mycelium.queued.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-+yzTYpsfe5M/C4084IuV"
Date: Mon, 08 Feb 2010 10:06:33 +0100
Message-ID: <1265619993.3783.0.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+yzTYpsfe5M/C4084IuV
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2010-02-07 at 21:48 -0500, Andres Salomon wrote:
> I discovered that if EMBEDDED=3Dy, one can accidentally build a mac80211 =
stack
> w/ no rate control algorithm.  When RC_MINISTREL and RC_PID are both disa=
bled,
> the RC_DEFAULT string (which rate.c uses as the fallback algorithm) will =
be
> "".  That'll cause the rate_control_alloc to fail, which will in turn cau=
se
> ieee80211_register_hw to fail.  IOW, no driver will load.
>=20
> This will tell kconfig to provide a warning if no rate control algorithms
> have been selected.  That'll at least warn the user that they're about to
> build a broken wireless stack.


> +comment "mac80211 will not work properly w/out rate control algorithm"
> +	depends on MAC80211_HAS_RC=3Dn

Except that isn't true for hardware that doesn't require an algorithm,
or drivers that provide it themselves, like iwlagn or ath9k. I would
prefer it to be worded accordingly.

johannes

--=-+yzTYpsfe5M/C4084IuV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLb9QUAAoJEODzc/N7+QmauKwQAMnqTVrTJp5xRrDOgq+duHVo
OHZfWZUgvbEP3k9wxHqOwnO9Sx+vt8mOopWVh+Rw6MebEx5AIKbX8CE4hhH0/1c7
LnbS+lTy/E75fFO6ZgFsuVJJIMcrmVLuSIgTVTefrK6rU+LKNpwvrygEA8+aX2sp
av0qfgy6r4/oLdLZ+mQFDYL7gZ7BHS8F/upmoWOyR7L8/vPz4c+ylFAJ7O4vk/+a
WsG/yzttVyRY4zc76/BGOASDucLBo0JpkkrfmAuC9H62UqaZ+1NL5gRZq70O4jEn
0IA8NKGZznOlT/SohCwdFZg3cy1hylZ2medynFH+JP+bN3KNxg0DdsMVz9//AhpQ
7dSD48ZsOUqQk8M+400QSOoty75oIQShlbyNubsqrpruH+8SK0CNxN+bV5CxjtW4
TkHOhYBC4FbIAUQuIPzGEPpCcGfuKGcY+0Dw5iz2vvnhlyIm70SU+cXhGOmqN3HV
HZW0IFnjkMWf4XlW/vAa+OlrD2glTD/EexbxIMUqwlGHo0kmxhVBpquDWm2Q9AY4
laDLuVPF2MYyTWZ8hi7GxN6Skgcpk/MP2LRlKPxLQssSuGkD8dv3Lf0ce3O7Ygrj
3Tz9yTfE4Qj+Cg3NFLE5+gzEr8R4loMlD/J/sUoWrgKk45ZYMDciPbSALhj+BntN
24xxxXQ7KmYMkVU8Acx9
=OgS2
-----END PGP SIGNATURE-----

--=-+yzTYpsfe5M/C4084IuV--

