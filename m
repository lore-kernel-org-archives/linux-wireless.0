Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:45633 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758201AbXKOQkO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Nov 2007 11:40:14 -0500
Subject: multi-BSSID AP support
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Henry Ptasinski <henryp@broadcom.com>,
	Kalle Valo <Kalle.Valo@nokia.com>, Jouni Malinen <j@w1.fi>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Michael Buesch <mb@bu3sch.de>,
	Michael Wu <flamingice@sourmilk.net>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Felix Fietkau <nbd@openwrt.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-0Uz2lvBHXJU5rMfRu85v"
Date: Wed, 14 Nov 2007 20:39:41 +0100
Message-Id: <1195069181.13846.51.camel@johannes.berg> (sfid-20071115_170750_190283_9B00536A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-0Uz2lvBHXJU5rMfRu85v
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Ok, so after that thread started out Broadcom specific and then went off
discussing various related things, I want to summarise a bit.

Because beacons are also subject to media delays, I'm now convinced that
my interpretation of the standard wrt. TBTT always being a multiple of
the beacon interval is correct [1].

What I'm trying to decide now is what beaconing scheme is best. We have
a few possible schemes:
 (a) simply burst beacons at TBTT, all beacons have same DTIM period and
     count, then multicast traffic after the beacons
 (b) burst beacons at TBTT but vary DTIM count so that the DTIM 0 beacon
     can come first in the burst, then multicast traffic after the
     beacons
 (c) spread out beacons across the beacon period with TSF offsets

To my knowledge, the (b) scheme I described isn't used anywhere [guess I
should've patented it...]. I'm told Atheros uses (c), but this isn't
confirmed and I doubt it when I look at their TX descriptors. Some APs
at my university use (a). I haven't checked what other collocated
multi-BSSID implementations do.

If anybody can come up with other schemes, let me know.

Now let me list the upsides/downsides of these schemes.

(a) can be a problem because the TBTT is a multiple of the beacon
interval and thus just bursting the beacons is not good because it
forces STAs to wake up at the first beacon even if they're interested in
the third or so. Also, if the DTIM 0 beacons are all aligned as they are
in the implementations I know, stations will have to receive basically
all multicast traffic of the AP even when they only want one of the
BSSIDs.

(c) is nice because it doesn't suffer from any of these effects.
However, it requires that the hardware be able to timestamp the frames
with arbitrary offsets to support the virtual timers. Offsets are pretty
much required due to the fact that probe responses must be timestamped
as well and they can be sent with various rates etc, but it's not clear
that arbitrary offsets can be specified on a per-packet basis. Broadcom
hardware is capable of doing this, it would require small firmware
changes to allow setting the offset from the driver [2]. However, this
requirement may make it impossible to support this feature well with
other drivers.

(b) has the same good behaviour with power saving stations because the
relevant beacons (those that the stations wake up for) are sent as close
to the TBTT as possible. It also doesn't suffer from the hardware (or
firmware) support problem because only one timer is used rather than one
virtual timer per BSSID. Thus, any current hardware/firmware design
should be able to support this (the non-DTIM beacons can be considered
broadcast traffic and put into the queue for such traffic).

(c) has a slight power save advantage over (b) because if multicast
traffic is present, it'll be sent right away after the beacon and not
after the other beacons. Therefore, powersaving STAs will not need to
receive the other beacons in this case. I think, however, that this is
almost negligible. Opinions?

Now, considering the CFP [3], I first thought that (a) would have
advantages because it can do a CFP for all BSSIDs at the same time, but
because 9.3.2.2 requires that the NAV is updated [4] for *any* received
beacon's CFPDurRemaining value, I don't even see any problem with CFPs
in the other two schemes either.

And here ends my knowledge about what the beacon timing is relevant for.
Is there anything else? I can't think of anything.

In summary, I think (b) is the way to go. After this analysis I'm a bit
confused that (a) is implemented at all by anybody. Did I miss any
benefits of that except having to think less? :)

Since (c) has (albeit very slight) advantages for power saving, I'm
tempted to implement both (b) and (c) to be able to tell the difference.

johannes


[1] otherwise errors would add up and it would very quickly be
impossible for a STA to wake up at the right time

[2] in fact, we need to implement this anyway to timestamp probe
responses!

[3] btw, is Broadcom hardware CF-Pollable? I can't seem to find any
indication that it is in the firmware, but that seems weird to me.
Anybody know?

[4] off topic, but does anybody know why Broadcom hardware updates the
NAV for the duration field of 802.11 frames with version !=3D 0? Seems
wrong to me, it's not even clear that there would be a duration value at
that spot for new versions, is it?

--=-0Uz2lvBHXJU5rMfRu85v
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARztO/KVg1VMiehFYAQKelw//emZPu8RsKIt0MeU/Cc2Yu6Ih9IYhtx+N
7wdJPsGZK5THEiqJygeaomY1ufCviAAOiY4Xcqv70c53B74dd+pS2EyQGw/mTdhT
e5EUN1OoJ+xJ3DB1gsEs63/Kz/iskLpKcqB4fJgK1GhSwVxWq1dPQZGVon7rtoT3
kDhuhYsv0fRipNWVjqQ0d+3535BKaxgneaqbv8ZSYumcOsyHlzWB4XHn+psoHis+
GEnxU30seiTi+JaNamPospOldBjZ5todghI5AxzDZhrH46xGc8d/vsnFc/wdxKEZ
WmYpK5FX+P5feVrF+7i4Bh0R2RllQEvEHseYdGzWaXmyXXZvj1m/CV2CaFtQHL1G
O+X5XfvUhRPzfylvQ4NQ8cHTArYJ/2pDa21XYSKTFBn9SyJtlASQRu3z1aoNPkSw
kuf3VPbUEw0V8IrGPro4DVTqyy3+yL2ak54IOeN+ccF3hJVQD9iGMYCSL8erVyMT
Rqx9RfBtMebPnwcNdDeOwBJ6DbvBiMOpqg5oDKJPvhuHa9tlJ6yE2EcT/1mDA1Y5
fmK/5JzgD8g5e2PA70beHZEY9vBoK2jlEcUVbAWOaip311XriFBHpWtrUelgv4ei
FWp4e8hP/hYJghkL8drOHIBndMc66xV8uat1BFIKOAimUR0hKH71INjVfxp/x+l6
yazhe3Au+JI=
=kJ+v
-----END PGP SIGNATURE-----

--=-0Uz2lvBHXJU5rMfRu85v--

