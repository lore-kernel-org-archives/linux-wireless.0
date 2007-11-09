Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39334 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753550AbXKIMLC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2007 07:11:02 -0500
Subject: Re: [RFC] b43: multiple MAC addresses support
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Ben Greear <greearb@candelatech.com>,
	Michael Wu <flamingice@sourmilk.net>,
	Jiri Benc <jbenc@suse.cz>, Jouni Malinen <j@w1.fi>
In-Reply-To: <1194572631.4793.64.camel@johannes.berg>
References: <1194572631.4793.64.camel@johannes.berg>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-SgXOqozI1iw8ANVAGIXO"
Date: Fri, 09 Nov 2007 11:52:30 +0100
Message-Id: <1194605550.4793.93.camel@johannes.berg> (sfid-20071109_121106_678597_54580D32)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-SgXOqozI1iw8ANVAGIXO
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

So as you can see from the code, I only allowed station interfaces for
now. Which is actually pretty useless since you can't use two of them to
associate to the same AP. It also violates the IEEE 802.11 specification
as far as I can tell because we can only adopt the time of one BSS...

This is a good stepping stone, however. I've shown that the firmware can
easily be modified to support address masks, so we can now think about
how multi-BSS AP operation can work.

Right now, I'm thinking we should do it this way:

As for the firmware, I'd disable support for TIM manipulation and make
it take the beacon from the multicast/broadcast frame queue instead of
from the template RAM. Essentially, at beacon time, the firmware would
send the first frame from the mc/bc queue (the beacon) and then all
other frames from the mc/bc queue (the mc/bc traffic) up to the "last
bc/mc frame ID" where we clear the more data bit. No special-casing of
the DTIM period etc, we let the driver handle all that.

We should limit multi-BSS operation to some sane value, say 16, and
require that the mask is the last four bits or less. This way, we can
use the lowest four bits of the mac address as a beacon ID and have
different "last bc/mc frame ID"s for the different beacons to ease
driver operation and make it race-free.

In the driver, for such modified firmware, we rely on mac80211's
software broadcast/multicast queuing feature along with the get_beacon()
function. Every time the firmware indicates that it has sent a beacon,
the driver will queue the next beacon (round-robin between the
interfaces) and the corresponding multicast traffic.

Something I'm not clear on right now is the timing of it all. If there
are say two BSSes, the driver can simply program the hardware to half
the beacon period and then the beacons will alternate. But if there are
seven BSSes, the beacon period might not be divisible by seven so timing
errors will happen and, worse yet, accumulate. Does hostapd somehow
account for this? Or should the beaconing work completely differently,
for example with all N beacons sent in a burst?

johannes

--=-SgXOqozI1iw8ANVAGIXO
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARzQ77KVg1VMiehFYAQK5Zw/9FtMTEpUwxWOOpXzoE3kl0Msi0eNaR0Wl
f+rWJ62dJCxYnmt+Fw9rFcEXmgEmKRaqqsoyPPqUG+ONuUtnDvn/qZyuR6qnfynJ
X3BuUBElQ1wqAnxbrLDDS9tlifJxidWZXB93fQOj/EbiCEHc6LSMVSMDq5XuNdq7
zd+JArxu96bF1YvCpnWtPP7MY94eNNHLKMaQVBeAkDA1BCFVHHM9vx8joSWAo/YJ
LDdW8V8fDdvqx+6LnZ0iuXq9CyXsju6xcQbkw4au78Hh05U4QOMrAJt3HtoQZU3c
q+q+dTiANxjg7Vh7RHtUKrgXqa9fnN9wPR4yZUNQF0VeklCdYRLl3MeUCH9z/QS3
P4l+ms9scRHTL/F8J80OQa4EdzV8um9nOno1RNMifMm/VZl6C+5EnI9tCaY0ZDKG
aqGnakCWfMhegdAy9ooaVYwfVEbDJX9B5ZiJF0sLor5T9yBceT40ehO3YfbKNX1W
HlQ/IIgK6xRgLiX59eDRqiQnqR2kSZqX94BhG+wGzb8+7Tn1vSKTdrzACCkBA4uO
6shga9rfvrUB3oayt6gupoJ0J6l56nstO9evOR1kmpFsMNmCw0pl8nHfxKtkvVCT
zOgM5TrCgIod90XHk4RyePVJ3DAgVirDOH5h+Wd8YIxxQZdj+SVlZOv1ZhPxcJtf
DTKWz8BbvKI=
=uBBo
-----END PGP SIGNATURE-----

--=-SgXOqozI1iw8ANVAGIXO--

