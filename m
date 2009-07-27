Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51823 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056AbZG0QFK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2009 12:05:10 -0400
Subject: Re: Possible BUG where mac80211 fails to stop queues
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4A6DCE0E.3010103@lwfinger.net>
References: <4A6CDE26.3000409@lwfinger.net>
	 <1248684480.19945.45.camel@johannes.local>  <4A6DCE0E.3010103@lwfinger.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-LcF2SaMRsTNUpa9wYGP0"
Date: Mon, 27 Jul 2009 18:04:36 +0200
Message-Id: <1248710676.8500.9.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-LcF2SaMRsTNUpa9wYGP0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-07-27 at 10:55 -0500, Larry Finger wrote:

> > I've also seen it under extreme stress on Intel hardware, cf.
> > http://thread.gmane.org/gmane.linux.kernel.wireless.general/36497
>=20
> Fortunately, the b43 coding was robust enough to prevent queue
> overrun, thus we just end up with a warning.

Right. iwlwifi wasn't so lucky.

> > Are you seeing this multiple times? I don't think you have fragmentatio=
n
> > on, do you? At least I didn't and still saw the problem, which seemed a
> > bit strange, but I really couldn't see any other way for it to happen.
>=20
> When it occurs, I get just a single warning. Fragmentation was not on.

> I will prepare a patch that acknowledges that mac80211 might send one
> extra fragment after the queues are stopped and only issue a warning
> if we get more than one.

Sounds reasonable. You could even change the threshold from 2 to 4 and
enqueue the frame anyway, if still >=3D 2 slots free, I guess.

However, I think I've seen this happen more than once, which really
makes me think there's a bug in mac80211 too, but I haven't been able to
find that bug if any.

johannes

--=-LcF2SaMRsTNUpa9wYGP0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKbdARAAoJEODzc/N7+QmaG1IP/ieUOf+pi+8d+OWzduo7n+5S
z9ndFYQQpXQIz3rbdqs5UGWFjmUSaR9TVrR+ewF6iwCBpsW5z6dTEO0wJxgEprzD
L0p5TfXw2HdK3Q9VXQPcPhOmDGgmRnb94gkg2txrTDVvOFD4B5OhgGqWZRBMQuBB
+/bCnwkGOoupDszn0JoH03i/Q9RNLASdMyoec17qJF0V+UnTo+KE3i1CDIzldate
4Lc1rKThXiSISloo2FcLAgsu+QV5I5wNqIyHy6iEUF8YSpsai9CSywwB35dqdMen
RHUNg0LgW2He7GOorP1NmT1F4daLXyEZ77ZQ3W3dFD6vWUK4E9rb3C5lmnKKeSzS
ERWMAFCnyaqVYxlOM1nm9P5DqTdCTSEMH1ux0f3FlNoK80eGX7Ubo/Zpu5qpALGl
7uMJgfGtdADw6rcsGqgilTBMYg1h/wHhMqn6o0z/zbF2T5Y5lzGxuhVZYMxijk1G
FSvSDHjDvygY2OQUKoG8YNvDP8Q78D1iBeh4cKUKoVgxJA/zpgaSmqePMNMPSjbT
1U+Ijh+DPvmXYOcHpnXUxist9ltbSiuDcgdUvXm6h9x3LghlLY1hM4BM5XHdxujc
27+BvlRMJjgAQdtAJw0FMiY/rltk14eHICnbL8bZxD1XncD3cuepMiINZaRHCO3l
IQN82GlP86tbKQNB+NQz
=gPUG
-----END PGP SIGNATURE-----

--=-LcF2SaMRsTNUpa9wYGP0--

