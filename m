Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44800 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756352AbZJKKbt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Oct 2009 06:31:49 -0400
Subject: Re: [PATCH] b43: fix ieee80211_rx() context
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: John Linville <linville@tuxdriver.com>,
	David Miller <davem@davemloft.net>,
	Kalle Valo <kalle.valo@iki.fi>,
	Dave Young <hidave.darkstar@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200910111226.44778.mb@bu3sch.de>
References: <1255256361.4095.56.camel@johannes.local>
	 <200910111226.44778.mb@bu3sch.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-/2b0jILa48i0ImmSBVM0"
Date: Sun, 11 Oct 2009 12:31:06 +0200
Message-Id: <1255257066.4095.66.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/2b0jILa48i0ImmSBVM0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-10-11 at 12:26 +0200, Michael Buesch wrote:
> On Sunday 11 October 2009 12:19:21 Johannes Berg wrote:
> > Due to the way it interacts with the networking
> > stack and other parts of mac80211, ieee80211_rx()
> > must be called with disabled softirqs.
>=20
> Is this stated in the documentation somewhere?

No. However, there are many things that aren't in the documentation, I'm
working on a patch to add a note.

> > Michael, the former maintainer of this driver,
> > has refused to fix the problem this way instead
> > proposing a much more invasive patch that could
> > not even be proved correct wrt. locking inside
> > mac80211. Regardless of that, he believes this
> > to be a bug in mac80211, and has also publicly
> > stated [1] that he does not care about this even
> > though it is a regression introduced by his own
> > patches.
>=20
> What if we leave slander out of the commit messages?

As far as I know, it is an accurate account of what happened in the
other thread, and as such is not slander. I just wanted to provide a
rationale for me fixing this bug instead of you. If you disagree that
this is an accurate representation, I invite you to summarise the thread
that caused this miserable situation of a known bug not being fixed for
a very long time despite appropriate fixes being known in your own words
for the commit message.

johannes

--=-/2b0jILa48i0ImmSBVM0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK0bPnAAoJEODzc/N7+QmaWt0P/1Zd4yAAhzlL1HhzuiksUzbc
CBd6FEcMDN5pbibExrBLEk93bigdWTikgiIsn/io9vXAB+X7XH9FBqZA/LcPr9h6
0/3xIwGYGqEbHb4AuG/1mY/QYDWKsEsU3BCO6PpwsN53g5+fYxImoGDXPjhj/im5
i4EiE+DefHtZ0QswtL7BaA5wguXtAT02rOCVZXcXCTBFX5hZJmnS8wWBxkDZCdzd
NPgEwSwrikf0fee3uOXbuK6WCTfJdMFY6onLWWXkF6HO3ycZ4QlB9x2ZOQiJ7Cj1
wQOzMjzl178iI/hgGi566a2SYgGKHSVWvjQK6njub651MZZZpLpX1z74wRptlcW/
i/JjXkr5El120P83hGjHMfGE64URR7MA+UzaFzG5ynawVnrWo4wQVJ4XAOnrLU52
0irZCrD7mcqfczkikUTqBm8fY/o5Aq2szBU3DLmstzYTLWW4CdeZoaqeL1LvIw28
SsVAJoOlyaIzCww349Bjql0UmK5RFLJISCaxDm+ukMvpe1Ex+PZae9QG3PzsKI6K
jOe7T4COcZs7t2L/KZ+KotBAL1vg8DX5iaVM9A/OwempIuzLOoOV7gFmNg2j2LmH
yayRqnz7lBi2ainI75wRXoiRrVzqpED4QGhnet9DCDSuRYSOYDUZUL0YiER5aV4Y
ClTc+872fOcAsfJnQyXq
=0v3d
-----END PGP SIGNATURE-----

--=-/2b0jILa48i0ImmSBVM0--

