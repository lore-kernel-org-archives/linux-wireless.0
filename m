Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51727 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909Ab0BRMHW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Feb 2010 07:07:22 -0500
Subject: Re: [PATCH v3] mac80211: deprecate RX status noise
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Roskin <proski@gnu.org>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Benoit PAPILLAULT <benoit.papillault@free.fr>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1266447118.12365.21.camel@mj>
References: <1266437114.23447.0.camel@jlt3.sipsolutions.net>
	 <1266438137.23447.1.camel@jlt3.sipsolutions.net>
	 <1266438446.23447.2.camel@jlt3.sipsolutions.net>  <4B7C561C.70702@free.fr>
	 <43e72e891002171429j7f47c86bqd4374bf07b8979de@mail.gmail.com>
	 <1266447118.12365.21.camel@mj>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-fRrLBZSU9MshlJCCvopa"
Date: Thu, 18 Feb 2010 13:07:11 +0100
Message-ID: <1266494831.6261.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-fRrLBZSU9MshlJCCvopa
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2010-02-17 at 17:51 -0500, Pavel Roskin wrote:
> On Wed, 2010-02-17 at 14:29 -0800, Luis R. Rodriguez wrote:
>=20
> > > Being per packet or global, I'm not an RF engineer to say what's
> best, but
> > > even if it is global, "last_noise" would still be useful as
> "global noise
> > > when the last packets was received from this node".
> >=20
> > If anything it should be per center freq.

Actually, per channel.

> The noise value will be missed.  It's useful to see the signal to
> noise
> ratio.  I have little trust to the absolute noise values, but I know
> that the connection is bad if signal is just 3 dBm above the noise
> measured by the same card with the same antenna on the same channel.=20
>=20
> Maybe it would be better to remove per-packet noise only when the
> "next
> generation noise" is implemented?  It could be a batch of patches.

Hear hear!

Face it, the way we report it right now is utterly broken. Various
hardware reports various bogus values, like iwlwifi for example
reporting the same noise value that it collected after a beacon over and
over again, or just reporting 127 when it had no value.

We've been saying that we need something new for years. But those people
who want it don't seem to want to lift a finger for getting it.

johannes


--=-fRrLBZSU9MshlJCCvopa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLfS1sAAoJEODzc/N7+Qma3OMP/ipALqCqSF+eJ5HGoCO71vlL
Pvji2hZIDq6RlFfoq7hxFaKr6tIpEtzXB2Xf9GCOAQtVI4sy/jd21o4ghFoy1xbL
ZD7C9v7NwTC3kwntgqKq3f+dSgPJRwqKqR+TtE4f4L7MoSvgxvvj+LN2hXq+mv9c
BJtvyOgyFSGtEVfA+03zUcS0BZp2jImZwFjEe/ng3pGvNhnS16skZ2XLhpgu4lfC
TBWvRGzzzn3DlFNObdiUyFxDHJXZrc+c0f4BxpE8hmQpdtjt1NQqdq8i9yCqMCf0
miWlTFNBlBDrFK3Ecb5dwmOf00ZE9xvG3AAomLF4T+ziH54qF3b6KuONxaq+C3+n
d7ox9/pfBs2I852szpiIYPgeIE8FhP3wx9waefD27r/3ThAL1xg475Zvm19RVeHo
0C+FrulO4nDwajlboEQqL6lOHWkU9VCSdKw24Gu8gSpEQ0AhsaJ4FaeozGEM+Dnl
op+RM+9tW707rxQn74HO+EanY3cg4JPaYd5ynZoLa3ABJPCMZ5CzgNYs3h8BiK/j
D+A5SiiXXYfasrrH35TJVl79QrnJ4SiayKbWjZSjT+fgUWUl6idXLUM2XLOr2MkO
f988dh3LfgL8OgO02jCTrZKUsKQonHxZGaBbzntyZFFvUjyo6FI6hZJ6iG3DuPXe
3Cfrv/pgNADbZiVmdUk6
=Cf/R
-----END PGP SIGNATURE-----

--=-fRrLBZSU9MshlJCCvopa--

