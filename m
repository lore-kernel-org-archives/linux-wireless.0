Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36634 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbYJTMWf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2008 08:22:35 -0400
Subject: Re: [RFC] mac80211: Re-enable aggregation
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"tomasw@gmail.com" <tomasw@gmail.com>
In-Reply-To: <18684.24323.743610.871307@gargle.gargle.HOWL>
References: <18684.16351.638713.791015@gargle.gargle.HOWL>
	 <1224491480.18024.32.camel@johannes.berg>
	 <18684.18492.94865.480736@gargle.gargle.HOWL>
	 <1224493957.18024.47.camel@johannes.berg>
	 <18684.20459.335157.171344@gargle.gargle.HOWL>
	 <1224495531.18024.55.camel@johannes.berg>
	 <18684.24323.743610.871307@gargle.gargle.HOWL>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-foTao0lb0KlmU7j1+qTz"
Date: Mon, 20 Oct 2008 14:22:29 +0200
Message-Id: <1224505349.27899.17.camel@johannes.berg> (sfid-20081020_142239_310995_040D4043)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-foTao0lb0KlmU7j1+qTz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-10-20 at 16:05 +0530, Sujith wrote:

> > But couldn't non-HT frames be buffered similarly? Maybe I'm missing one
> > of the finer points of the 11n draft?
>=20
> Probably because 11n aggregation have more rigorous timing requirements
> between frames.

What kind? I can only find the ampdu spacing/length exponent stuff.

> > I guess there's no clear answer here. How about "whichever you want"?
> > Though I think I prefer pushing them down as that makes the model easie=
r
> > to understand. It probably also makes the Intel case easier to
> > implement.
>=20
> A way to pull down buffered frames for each TID (like ieee80211_get_buffe=
red_bc() )
> would be really useful for ath9k.

I'm not sure, that seems like a useful thing initially, but leaves a lot
of stuff for the driver. We should probably think about moving more
things *up* into mac80211 rather than giving the driver more access to
low-level details. This would also allow us possibly even send A-MPDU
mcast when acting as an HT AP, something the driver cannot easily do.

Can you explain the way it currently works in ath9k?

Also, I'm trying to understand the relation between a block-ack
agreement and A-MDPU, I understand that without a block-ack-agreement
aggregation isn't very useful, but could we not, for example, implement
(regular) delayed block-ack with much the same infrastructure?

What I could also imagine is that mac80211 simply does pretty much
everything and hands a number of skbs to the driver at once with some
additional information about how to aggregate them, what sort of spacing
to use, etc. It should be able to calculate all the required stuff since
it knows from the rate control algorithm what's happening there. That
might leave Intel out a bit, but I'm starting to think that we want to
special-case them a bit anyway.

johannes

--=-foTao0lb0KlmU7j1+qTz
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI/HgBAAoJEKVg1VMiehFYMd4P/0p6rL1P1IcyXDhB4s9c6fbL
uJDnRLtXc07sc/e3gM7rlfAibuwLEb6oodZXSHbGU8NlO+nI04BbuqXEXrOJNRQB
ujWQcCvce4Nn4W5PWdPqIWFkNJKEyI6da2si/EBwWk725/a4qs4Yq3mZsy/MfuO/
DFDysidx8cUpXB298PybGKA0EvCPoqCuGlG8QpuAe0sWHSNU/zPk3xSZ/FTUltaM
qynQv9CLoBcezNJpbiBTYp0e5DPZAf5ZzYc3cPFgo7IxRlmq2ksIB4RO2AKoxX+f
8otlN3NDAeWaqCVgZo8GKjard9xY+9Pu8h/7dVNGs2seFVYNHUdlmDr6kbLwmy0s
o3zcIijsdxwDCT8FtdQ1xTQ7WKDFqi7JhMLlU5xpzMm/Xq6SsTcuZ1Bu/+qwKfIa
BjEkUmySi32d1k6s1kmY2EZFiYT/14U5fihsmMWXwcr/EivqXQEh+zx03CIBTis0
RBhtK80coZWpF0gWzqUznNE7qRpF2oLTWlkIU+n4ras1+ri+BBRMH5o+15BErH/7
HCfFEjfir/SGHzQ5naLl7X8PqoKUo/nzIzDkD8nCuftd0vW9WMJYO/uZX3TuZawG
1KDW01ocY/dz+jFxs5fpaS0dxqpicUhHuYpKr3zjgwCNke7jAr2hwZ45VCT73aqt
Z8em4x9K8m8vjcPED7Sl
=N604
-----END PGP SIGNATURE-----

--=-foTao0lb0KlmU7j1+qTz--

