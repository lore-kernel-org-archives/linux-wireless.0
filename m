Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35365 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbYKCRuQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Nov 2008 12:50:16 -0500
Subject: Re: No ProbeResp - assume out of range
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Tomas Winkler <tomasw@gmail.com>,
	Michael Buesch <mb@bu3sch.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Kalle Valo <kalle.valo@nokia.com>
In-Reply-To: <490F2B6C.9090002@openwrt.org> (sfid-20081103_174852_988997_5757C55B)
References: <43e72e890811021305k19e9a314i6400cd1a759b3d00@mail.gmail.com>
	 <200811022303.54476.mb@bu3sch.de>
	 <1ba2fa240811021442o178c98a1pa920b863b60d9293@mail.gmail.com>
	 <43e72e890811021458h1444d350v33a5e5b984b76495@mail.gmail.com>
	 <20081103002558.GA14153@tesla>  <490F2B6C.9090002@openwrt.org>
	 (sfid-20081103_174852_988997_5757C55B)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-kTaZ9hFraIQ/7Hh3XiOR"
Date: Mon, 03 Nov 2008 18:50:05 +0100
Message-Id: <1225734605.3619.39.camel@johannes.berg> (sfid-20081103_185022_297275_376F55BF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-kTaZ9hFraIQ/7Hh3XiOR
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-11-03 at 17:48 +0100, Felix Fietkau wrote:
> Luis R. Rodriguez wrote:
> > OK I found the issue with ath5k, no beacons were being passed at all, I=
'll post
> > a patch.
> Why not configure the beacon miss interrupt instead of passing beacons to
> mac80211 in STA mode? That should save some battery on Laptops because it=
=20
> won't cause 10 extra wakeups every second.

We have no way to indicate to mac80211 that the hw is watching beacons,
so that'd be equivalent to just dropping them. We've discussed such API,
and I hope somebody will implement it :)

johannes

--=-kTaZ9hFraIQ/7Hh3XiOR
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJDznJAAoJEKVg1VMiehFY6xwP/2yNGu1DCDkr34n774n2cFNV
RcI8B7hJQ2k1ST/L4hi7XOHB72Cj6X8vdY3p1IyrA41y5LCmbALaAzYtVWBwm7wf
i7DPZNla2VDpVCpfpbFdywo3kAQx0DO1aCePzG4MZxcqAoDhiQKXKPPi2O/RsoV4
458QKxZYQkxGIYwGTM9dRz5XpbnYAvOGxPe8gMZDKszOek4wd4JITgM9rwTcizOB
wrBzz9p29K1j7G+km1UmiKkOwhzJZXEjQRStdjq9Bo8qZsC/UV5W5dQrGb6vICC8
3R33HhA6FRJc354CrKJwySWEDutgNJ3Sht2FrSYTbRAaQf0hnk4fIjT3jXx94k4r
PQ5MTnm1w8r/YTjf8UzorP7B0UCNP4lghm6Pp0HK3zLagzVPHaFZ6USu49O/5AQM
lqc2/qeTgTNuWYx/yPqqJe5LW4zTbFb36CvBEx6exq6gWBAYd22cm5nVk6hwhCHd
XaiJ1ZboFqJkroLolrNszqYOBjGLzpq5cAQrjwmIgX4DhgAHGXzP0ud6omBSU3aV
NxS6JVpeTT41HA7J8N9LwP2LN1OTUizltD+uORTPxJbdv4pB6GoUYKO5diRBWy4G
zgPRHI8Dm+N/6ry5BNTDJ7OvwOYzfcvr2NCz4T1/yh6nTLfT6A+TvhLqpewJl/rS
8JwF/a43ZZLT7rqPd7oS
=3BYJ
-----END PGP SIGNATURE-----

--=-kTaZ9hFraIQ/7Hh3XiOR--

