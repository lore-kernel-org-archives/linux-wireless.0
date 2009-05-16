Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45951 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754324AbZEPMtA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 May 2009 08:49:00 -0400
Subject: Re: Scan while TX/RX'ing a lot of data
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>, Aeolus.Yang@atheros.com,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	Gaurav.Jauhar@atheros.com
In-Reply-To: <1242429353.10933.32.camel@localhost.localdomain>
References: <43e72e890905141052o1f072bc5m4bc5922327617f8b@mail.gmail.com>
	 <1242327298.4227.25.camel@localhost.localdomain>
	 <200905151011.50915.hs4233@mail.mn-solutions.de>
	 <1242429353.10933.32.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-4gE8BHHyK0EvDQXQjISm"
Date: Sat, 16 May 2009 14:48:57 +0200
Message-Id: <1242478137.10005.63.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-4gE8BHHyK0EvDQXQjISm
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-05-15 at 19:15 -0400, Dan Williams wrote:

> Well, what does "background scan" mean?  mac80211 will obviously accept
> beacons from APs on the same channel and happily add them to the scan
> list.

Only if powersave/beacon filtering isn't enabled. Actually, mac80211
does beacon filtering itself now, so I don't think this happens any more
(I did that on purpose so people don't really rely on the former
behaviour)

> But a background scan would imply that the card itself is taking
> over the decision about when to jump around and scan, basically the same
> thing NM is doing, right?  When would the card/stack decided to
> background scan, and what channels would it background scan on?  If it
> doesn't do more or less all passive channels, then it wouldn't be that
> useful for figuring out the site survey data.

I would think that mac80211, while asked to scan when associated, could
simply do something like calculating how long it can go off-channel
under the current QoS requirements, and then go off-channel for that,
wait for the next on-channel beacon and some traffic, scan the next
channel(s) again etc.

johannes

--=-4gE8BHHyK0EvDQXQjISm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIbBAABAgAGBQJKDrY0AAoJEODzc/N7+Qma2mYP93OFNvbAVf1h7l9kXUO/rcUu
Z24TmNANtMxBYeHdL1h/KmM+bR/MRfpb9WhDrgVeE8gtbwvSCwen74RaDXpq/Udu
62uCJPQrciPEsXQJxlCNkhQxOEO/TCoOjwtacjwoOWPvM55G8zw6xQ6DkxMuGOOk
EhBFI49vP2lyEc/3sfy5wVvJdoqK4ZfylXy7cCdGn9oBUZxFniVt7oTk5mY0hidQ
jWGbQ59K0X8FcTpVFgfdhZLZ+478qJfSvX+PGtS2yK8DtyJjtLSzOBSn2QjEsJy0
V4cCV+32XfsbR98Q28T+8ZK7bIODs95yicpoJywP3rNQWtT0PwXoXOsNYtbix6sF
okHGstJVv7/UhhAhHi3a6I/AA/MBeph+m8rdRm5Zu+pZDIEgRKDEUKB5Y6ChrJSA
c09nHwL3fTVSTllar+OcL5qwUdXemGI3w58OXC5hBK56YQn2VM631G7jXeZb50Ys
QTejXbxZVMmE89uoDz9KzzoAUt1tGU6UcEhES2d9uVAXr30BhLomyVqI56SJCvw9
IuGmpv+6QRbUZ5F7jPT4Fxrpz3X4BZqpXaxKRajnzbJrj+9PeERUaRgVf5epyxaq
Fos1Y3UZted9ti3xvaD0rJ/1fUFhRL0k6koe0VehSqc7IS4H980Ar5mKjjPCbL3c
bxYp0jkz8A8YZX/Wemc=
=62VE
-----END PGP SIGNATURE-----

--=-4gE8BHHyK0EvDQXQjISm--

