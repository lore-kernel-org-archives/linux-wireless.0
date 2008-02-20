Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60447 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755037AbYBTScs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2008 13:32:48 -0500
Subject: hardware/firmware powersave help, Broadcom scheme
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Tomas Winkler <tomasw@gmail.com>,
	bruno randolf <br1@einfach.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>, Jouni Malinen <j@w1.fi>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-JPfMn4Y0XItKn7LzbruH"
Date: Wed, 20 Feb 2008 16:18:29 +0100
Message-Id: <1203520709.17534.68.camel@johannes.berg> (sfid-20080220_183252_343571_96D1AD6B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-JPfMn4Y0XItKn7LzbruH
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

After my previous mail about atheros's powersave help I thought about it
a bit more.

The basic problem this solves is the race condition between software
noticing a station went to sleep and stopping to send frames to it. The
software will obviously stop sending frames to that station right away,
but there may be frames already pending in hardware/DMA fifos/queues.

mac80211 contains code that assumes if a packet fails and the station is
in powersave mode then this packet failed because of that, but that is
obviously suboptimal because the packet will be transmitted even though
the station is asleep. Hence the need for hardware/firmware help.

For Atheros hardware, this seems to be implemented by having a hardware
filter which (I guess) is software controlled. When the station goes to
sleep you insert it into the filter and frames that already are in the
(DMA) queue/fifo will be filtered instead of transmitted. This still
leaves a small window for the race condition because of the processing
delay in the stack. Unless of course the filter table is hardware
controlled, but then it can only ever *insert* stations into the table,
not delete them, it appears that the plan is to handle the delete step
by the IEEE80211_TXCTL_CLEAR_DST_MASK tx control flag.

Broadcom hardware, on the other hand, has a slightly more complicated
scheme. All powersave transitions are registered by the firmware (!) in
a hardware FIFO (really a ring buffer I think), the "power management
queue". I'm not entirely sure how entries are deleted again, but IIUC
they can only be deleted once there are no frames "in flight" for any
powersave station any more.

The atheros scheme seems to be implemented in mac80211, but I think we
might also want to implement the Broadcom scheme. This could be done
fully in the driver but that has a chance that the PS flags get out of
sync between the firmware, driver and mac80211. To fix this, we'd have
to export a new function to set/clear the PS flag (i.e. invoke
ap_sta_ps_start/ap_sta_ps_end) on driver request rather than on received
frames.

Thoughts?

johannes

--=-JPfMn4Y0XItKn7LzbruH
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR7xExKVg1VMiehFYAQIeZg/+NMVPPBCbW+NhrOtD4EZ9SHfbZu9NTKVS
BJI7FuIhlsLJyb++896A2/Eas9oFiILG43D5zgMKDymVsKkgp/CEbRdLwK0Z9l3k
CAWlTU39uAsnYd4QwyyENZsxoQ9noQv8dlLvS7/fsMXjTGiXFtrFnCwr4kNNw8E8
kyU1NYonRPVQ5OXo99Xmymu3WLqEfc9+rXifhyI5QEptaHOppDODmd6YoiWM5Svi
87CTaH4M71ptCwzJJcWOInsgKt7x1nx44WUMESPy7whNbl5qLIoPMqWDZe9Z6vOn
/8izHmDCoJxSrHRzpZOvTIQtIx+ROzBLtSEo7wcQwDoK6GSpU0wYE3KJyOddpbAq
4L62FP3PQ9//m65lRRVLMrWOx+8ADfh+qKR9XHTlqw1J89VhWJ/Mo5ce/ObieKmq
z3lyiuxBKZjV4xl69wsrazfF3zGg9UyX3TNPwtvORwRanNr2WBcW72+bt4If66NM
a0vucugKT8p7YidXRMZ89grRznj2MhN8ZNYFSM05/yD51ew5Uk/Vg1fNFoNfqaal
/drdAjGFaIqVvLoGzHIPmCv1dmGuVy8htjWJnn5XEmQm5prMNdImx/mpK/FfNFvt
B5ihowgyUlw1Sobf1cEjUH2DyXppQcWCaaIg7UwExvwnb47uJ2Kbt/7oWouFhPMM
MQu9lTJu6kk=
=qPb2
-----END PGP SIGNATURE-----

--=-JPfMn4Y0XItKn7LzbruH--

