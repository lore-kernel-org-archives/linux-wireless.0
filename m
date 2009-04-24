Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49693 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383AbZDXK1V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Apr 2009 06:27:21 -0400
Subject: Re: on radio_enabled
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <87tz4ed0w7.fsf@litku.valot.fi> (sfid-20090424_082529_965140_23D2B4DF)
References: <1240439975.30082.66.camel@johannes.local>
	 <87tz4ed0w7.fsf@litku.valot.fi> (sfid-20090424_082529_965140_23D2B4DF)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-oG+9zWnbLjFTphJOfHOh"
Date: Fri, 24 Apr 2009 12:26:47 +0200
Message-Id: <1240568807.18031.34.camel@johannes.local> (sfid-20090424_122726_640625_D4CEB9CD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-oG+9zWnbLjFTphJOfHOh
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-04-24 at 09:24 +0300, Kalle Valo wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
>=20
> > Now, if we're going to use radio_enabled more, I wonder whether we
> > should completely deconfigure the hardware when we want to turn off
> > radio_enabled, and then completely reconfigure it once we enable the
> > radio again.
>=20
> I assume that you mean op_stop() and op_start() here.

Yes. And all the associated things, see the suspend/resume code.

> > Pros:
> >  * configures all hardware correctly without the driver needing to do
> >    everything by itself
> >  * works with all hardware for sure
> >
> > Cons:
> >  * higher latency
>=20
> From stlc45xx and wl12xx perspective I would like to have low latency as
> possible for the radio on/off case. This is what I had in mind:
>=20
> interface down:
>=20
> o chip is powered off while down
> o ifup uploads firmware and initialises it
> o ifup might take hundreds of milliseconds, at least with 1271
>=20
> radio off:
>=20
> o chip is powered on
> o firmware possibly sleeping/hibernating
> o radios turned off
> o very low latency (<5 ms) to wakeup
> o small power consuption during radio off
>=20
> This way it would be possible to have a bit faster scans when not
> associated (with radio off), but still have a possibility to completely
> turn of chip from user space for a longer periods of time (with
> interface down).

I wonder where the use case for faster scanning is, but I guess the slow
SPI bus really does make for a long delay in initialising due to
firmware upload. I have no trouble with implementing it this way, and
userspace can still set the interfaces down when it wishes to do that,
while we can save a lot of power when userspace doesn't do it that way.


Now, what happens with "iwconfig wlan0 txpower off"? I can't figure out
that one. Should it be completely equivalent to rfkill, regardless of
what rfkill ends up doing?

Thanks,
johannes

--=-oG+9zWnbLjFTphJOfHOh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ8ZPkAAoJEKVg1VMiehFYXp0QAJUVWoYLyReRNXJ9A7afj1rs
Bd4ExLccggIktwIvTocTvSRq+EjW6JAcIj0voLnoIkIwvrHZWfAG2HCMq3rzaYyJ
5+0X2Kif+UintCcrmw5BGipffi18O4LgDDrJa6+fIIvA+FIMnrozFTWnNbdq6/UO
DeFbNsQ696CsihZ8w2bCFvAKJA9YGKqKViJ6tGXRmyHktoRM3hbnsTRohhvQ8ele
7L+OBBEAzZSIDCsATZGdn4Ql5q9rFFJAPMTfVCu+5JNX6OWapQlzb0AeNICpJ17H
6FGo1rDVrQtjbEt6sJoWoOOMwxHsvcDpoCIaPZoJl2dHS51Gchu5L4vtx+QveW6s
6mhbsiqkYWKTdyNWJVT9hEWLKScAw1JUYogKUpRQSL/QNlSTSpZWiTlzsJo6EBNJ
ScPpoxrt6NLYELMiYWZgbG3l366xIYbV1m8n2qJnuSE6XBC9xgyTxKWCUdD4gBBj
g6ojwlLIWSiqu0pt+OT9e8kdu9yMpNPxYWzuhpU3XPjT0Rix6zz082KTgLf5GX/8
hUuOi9mzk/rAPkPTivc4mRTxZSCSMcvKZX8SJ1YLrQUiMQhC/4OxxN1ld6kpXiFj
nUWmuSnBPtDyUQ5mNhciRXiVJ4MlpOflvZaHeGkLyIHVXRKcKEcCyv0PvibHfryd
xc2WbRPpiQCqPMf221+O
=ncxH
-----END PGP SIGNATURE-----

--=-oG+9zWnbLjFTphJOfHOh--

