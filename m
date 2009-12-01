Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:32876 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503AbZLAJ3g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2009 04:29:36 -0500
Subject: Re: [PATCH 1/2] cfg80211: add SM PS hooks
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <87pr6z6uud.fsf@purkki.valot.fi>
References: <20091130153857.963079149@sipsolutions.net>
	 <20091130154300.492667106@sipsolutions.net>
	 <87pr6z6uud.fsf@purkki.valot.fi>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-mv8jotYY/6+4Gh5udd5o"
Date: Tue, 01 Dec 2009 10:29:31 +0100
Message-ID: <1259659771.32171.62.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-mv8jotYY/6+4Gh5udd5o
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-12-01 at 09:01 +0200, Kalle Valo wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
>=20
> > Add spatial multiplexing power save configuration
> > hooks to cfg80211/nl80211.
>=20
> Is it really necessary to export this to user space, at least via
> nl80211? If we add this to nl80211, we have to support this almost
> forever.
>=20
> Also how are planning to use this? What components will use the
> interface and how?

Good questions.

> My concern here is that we will end up having, yet again, complicated
> user space interface for power save. The ideal situation would be that
> kernel would configure all this automatically and we would have a
> simple interface just to disable power save in cases where it doesn't
> work (broken APs etc).

I'm not actually sure that there are APs broken wrt. SM PS, it seems
highly unlikely -- even if there are (like mac80211!!) the rate control
algorithm would recover the situation.

As such, I suppose it's somewhat a debugging API. On the other hand,
there are actual traffic throughput consequences of enabling SM PS, even
when in powersave. Powersave will be turned off automatically if there's
enough traffic, but SM PS won't. The default, automatic, means it just
follows powersave (dynamic SM PS if on, no SM PS if off), but I'm not
sure that is typically desirable.

Of course, on the other hand, I don't see many users actually setting
it. An alternative could be to try to estimate traffic, but that gets
messy fairly quickly because the thresholds depend on the environment.

If you prefer to leave it out for now, I can probably move it to debugfs
until we have a more clearly defined use case, although if we decide
that we never want it then obviously the action frame handling can go
away again.

johannes

--=-mv8jotYY/6+4Gh5udd5o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLFOH4AAoJEODzc/N7+QmahT8P/jUr6MgOB9QRB8FP8Xom3HWA
LgP6LaoK21YIVphZxN9MtqW09mTlERvk3uvg/X7LaeVyrKpXgXI5K++OdWxQN3BU
uXIxpXjJkV8fazG8QjPI5HjT6lwn/ws+R3fCMKR5xl+hRukuWqwwKsF/1n7/0j+d
+56ljBUTssq9PiM2CNrSxIC96avSTCpqq9cOf0f8MiEyZFUouL1hwAFfPKZtrqD+
6+/kxwFRAcipDLlqhzqqWvSye+BIfKgyuEncpOFCJ5voDGod6nIYsmjQF8tpIm+1
Ey4UapvcQDVkw7cmbhaXDenpEWi2CvvbahaJBKvjFqs8DgBMM/jAhZdXhhIA4iSx
+AX2SgJACkpM4b7O7aNLUPGlefRYNccfV09OURG0Z5pxY6MZecajOcVclKjuLD9+
uwMrIn5rRecJTg2EOxAiCpEXD0iIw5zJnwTuaI9t5orVISUMsiSyaE8eRbNtIIBZ
J9XNQqvIXBwJiFXfevSkR0WipYNxiYNIyCFWn9u/t9ElcO9PbcEocHAP9jcB1G89
1bTnmZQfOUBdA6CLBMmcJwNildecYMAg0xsmJPzzUM8gi2WqQY3WjE476K/8pNSX
RkpLGaUy1HBN2h5i+k4LKuBJnw3rM8jhgOh2m84BOvAZcowNowueBaY3u+PsAhZR
3sz1A9qJyN3IMxCzOPX4
=LepO
-----END PGP SIGNATURE-----

--=-mv8jotYY/6+4Gh5udd5o--

