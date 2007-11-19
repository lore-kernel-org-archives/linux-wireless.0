Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59032 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754562AbXKSOrx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2007 09:47:53 -0500
Subject: Re: [RFC] b43: multiple MAC addresses support
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: Michael Buesch <mb@bu3sch.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Ben Greear <greearb@candelatech.com>,
	Michael Wu <flamingice@sourmilk.net>, Jiri Benc <jbenc@suse.cz>
In-Reply-To: <20071118234700.GC8672@jm.kir.nu> (sfid-20071118_234837_503212_D6C4E1FE)
References: <1194572631.4793.64.camel@johannes.berg>
	 <1194605550.4793.93.camel@johannes.berg> <20071111025808.GK4031@jm.kir.nu>
	 <1194868951.5229.36.camel@johannes.berg>  <20071118234700.GC8672@jm.kir.nu>
	 (sfid-20071118_234837_503212_D6C4E1FE)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-VtFWlw+eVt3FkTGVEO34"
Date: Mon, 19 Nov 2007 15:49:09 +0100
Message-Id: <1195483749.8642.12.camel@johannes.berg> (sfid-20071119_144817_216119_E49A82D6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-VtFWlw+eVt3FkTGVEO34
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Well, the multicast/broadcast frames would be sent after DTIM beacon
> using normal frame transmission rules, so this would be possible order.
> Though, this might not be that likely if one were to consider a case
> where these APs are on separate radios (i.e., multiple STAs contenting
> for the medium) should there be large number of buffered frames.

Right.

> While this may end up being the easiest and cleanest way of implementing
> multi-BSS support, this has somewhat unfortunate drawbacks for power
> save stations (e.g., STAs associated with the AP1 would need to remain
> awake for the extra time needed to send beacon2 and beacon3; and STAs
> associated with the AP3 would need to remain awake while mc1..mc2 frames
> are sent).

Yep. Hence my idea of doing DTIM 0 beacons independently.

> TBTT could (and well, should) be separate for each BSS. In other words,
> if there are four virtual BSSes using one radio (BSS1 .. BSS4), TBTT
> should be different for each. If the beacon frames are send out as a
> burst, TBTT2 should be TBTT1 + <time needed to send beacon1> and so on..
> Similarly, there should be independent TSF for each BSS. However,
> implementing this for virtual BSS (single radio) designs is going to be
> quite difficult since the hardware/firmware is unlikely to support
> something like this..

Well, I'm fairly sure Broadcom hardware would allow this because
apparently it allows subtracting/adding (?) an arbitrary (?) value to
the TSF timestamp as it is written. This could be made host-controlled
so the host keeps track of the offsets. The only requirement would be
that the beacon periods are spread out in equal intervals to allow the
microcode to schedule properly.

> > Another thing that I just realised is that I'm not sure whether we
> > update the TSF in probe responses correctly or at all because as far as
> > I can tell it's only done for the probe response microcode offload.
> > We'll have to look into this.
>=20
> This should be done in the same way as for Beacons, i.e., by whatever
> low-level functionality is available in the transmitting path.

Yes. Except as far as I can tell Broadcom hardware/firmware only does it
when the *firmware* responds to probe responses, and we disabled that.

> > Actually, what we can do is adjust the offset for each of the beacons
> > differently. So when we're sending a beacon at TSF "interval * (N+.25)"
> > we can round that up to "interval * (N+1)" by adjusting the TSF write
> > offset. This means that stations will adopt a TSF that is larger than
> > ours by a bit. If we'd do the same for probe responses (which should be
> > fairly easy), would the timing work out? I'm not entirely clear about
> > CFP operation etc.
>=20
> Where would the TSF be adjusted? Some of these tricks could be doable in
> the low-level firmware/microcode (if one is used), but this may be
> difficult to do without access to such low-level location.

There is such access as I described above.

I need do tests but right now I have no second wireless card at all.

johannes

--=-VtFWlw+eVt3FkTGVEO34
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR0GiY6Vg1VMiehFYAQJGoA//f0uiTKr5c/6pLiQZSzMymWN19MVJ/vrR
X8j7cjUGSbErt5qvVQhGD1E07ZjTqRpEh0vloBUSnoy+fMXqemtLfe83SuMQHhZi
GIOQsoSjIVbynWnqKIy+jv+Jt/fi6XkWvNp5gWBAIYR60/erRR8VY2TJkyQeIdTB
mtg9lQJiD13+Nfn6L10HzDxvicMqqUlT+AbCiqgpM0eoHgX9i7yvlxv6hPjeImj+
1f2eM6wAmG5hckV+s2yNqjzPYeCzm9XJp4D2Gc5H+KXU7G9ZpdNdDimQRM3s5ZU3
gHAsjTZ1FoI38gGBJtKQztQHWkVnBjw5Rl8VYAzMl2qql5oDpxRFH/qmGl4kX/6G
pZEiLqCO6z/yS8rBf9CdactU1LcnD9amqBG0KWYKSqSJJoWmVZeXmCgEFhqatjZG
D0opRMrnNKs9Tb0KKerg4fNAdOoBEnz9iMdgE+mcKlGpl/1YS9Pa49l+qchB2UFh
Mnf8Jz4jp6sUQ3J/9cBR2q9KNa59Cr7kAKoACPsIuNEkux4u15/4fTHyeuj8LE06
VMkjbaFLBEgxHPVuVQjUAA1Um6QT/puysX813RvupzmkWZ96PnZdlphHowcjb0lC
hUJ1ak/1Hcn0VGo7eRKXHyb6ZVsrgvPnAED1S3vO6XFG6ECWOILKTcsbXYt4rdH/
07V13DTOZmE=
=PPAP
-----END PGP SIGNATURE-----

--=-VtFWlw+eVt3FkTGVEO34--

