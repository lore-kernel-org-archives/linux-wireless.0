Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:48703 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763732AbYBUK6y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Feb 2008 05:58:54 -0500
Subject: Re: hardware/firmware powersave help, Broadcom scheme
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: Michael Buesch <mb@bu3sch.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Tomas Winkler <tomasw@gmail.com>,
	bruno randolf <br1@einfach.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>, Jouni Malinen <j@w1.fi>
In-Reply-To: <1203574345.3099.64.camel@debian.sh.intel.com>
References: <1203520709.17534.68.camel@johannes.berg>
	 <1203574345.3099.64.camel@debian.sh.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-hjk43xs4JLaj/S7EuuCu"
Date: Thu, 21 Feb 2008 11:58:18 +0100
Message-Id: <1203591498.17534.179.camel@johannes.berg> (sfid-20080221_105915_696487_565AB67A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-hjk43xs4JLaj/S7EuuCu
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Hey, and there is also ipw firmware!

Yeah but I know nothing about it and you haven't published anything
yet :)

> As broadcom, the iwl4965AGN firmware is also aware of the powersave
> state for the station/stations (consider about the master mode). In
> stead of having a special "power management queue",=20

"Power management queue" is a bit misleading, it's not a frame queue,
it's a queue/fifo of power management status notifications.

> the 4965 firmware
> still use the normal 4 QoS queues for frames destined to powersaved
> STAs.=20

Yes, same for Broadcom.

> But these frames will be dropped by firmware eventually.=20

Yeah, they're suppressed by firmware if the STA has gone to sleep
between the frame being queued by the driver and processed by the
firmware.

> In this
> case, mac80211 ieee80211_tx_status() will get these SKBs with a tx error
> state DST_STA_IN_POWERSAVE so that it can requeue them (to send them
> later when STA wakes up).=20

You should indicate that to mac80211 by using the TX_FILTERED TX status
flag.

> Note, this scheme is to resolve the race
> condition you mentioned that in the small window the STA powersave state
> mismatches between mac80211 and firmware. After mac80211 receives the PS
> frame, it stops to Tx more frames to hardware.

Right. This completely solves the race, there's a possible scheme where
the host notifies the firmware of powersave status changes which will
still help because this can be made faster than the TX queues, but still
leaves a small window. That was hypothetical though, I guess nobody
implements such a scheme.

> This scheme works well but we have one requirement for mac80211. That
> is, in the master mode, when the destined STA wakes up from powersave
> mode, mac80211 should not begin to Tx frames to hardware until the
> current h/w Tx queues are drained. Otherwise we can expect frames out of
> order issue happens (for example, some frames in h/w queues are requeued
> but others are left when mac80211 begins to Tx).

Good point. Completely draining isn't really possible when we're
communicating with another station nor is it necessary, inserting a sort
of "barrier" into the queue (any frame would be sufficient) would be
good enough so that you know when all frames inserted before the
powersave status change are drained.

On the other hand, even that is not necessary. Because we stop TX to a
STA right away once we see a STA going to sleep it would be sufficient
to insert a barrier into all queues when the STA goes to sleep and later
wait for those barriers to complete, which in most cases they will
already have.

[continuing below]

> It's good that you look into mac80211 powersave now. We also have code
> that enables master mode PS poll and uAPSD based on an early version of
> mac80211. We will merge it to the latest mac80211 and submit but it
> takes some time. I can point you the patch if you are interested.

I'm somewhat interested, I was trying to get my N810 to perform well
with a Broadcom/mac80211 based AP. I'd be much more interested in having
an iwl4965 ucode image and driver patches to get master mode working
there though :)

As for implementing the "barrier" scheme, the following could work:

When a STA goes to sleep, mac80211 calls a new
	ops->insert_queue_barrier(hw, u8 *sta, u32 cookie)

callback in the driver. This callback takes note of all current queue
status and inserts the status information into a list. mac80211 has
created a cookie (probably just based on an increasing per-sta counter)
and saves that cookie in the sta_info for that particular sta (this
barrier cookie is to allow having two barriers for the same STA in
flight at the same time).

As part of TX status processing, the driver now checks whether any of
the barriers completed by comparing the TX queue status to the list of
barriers. It then calls a new

	void ieee80211_barrier_completed(u8 *sta, u32 cookie)

mac80211 function. mac80211 looks up the sta and clears the cookie if it
matches, and if so also schedules all outstanding frames for
transmission.

Additionally, mac80211 is changed to not transmit if the sta has a
barrier cookie assigned.

What do you think?

johannes

--=-hjk43xs4JLaj/S7EuuCu
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR71ZSaVg1VMiehFYAQKzrw/+JthOrsYOnGg7sab3Bp4+ufPcn1PevDFu
Gfwl1fzUff+/WYea0SaGInfR+kSukgAejklJAC4VlXveARgP5jh0LyPkeGH013k0
uzmpdMLpgpdUPDBLzA6uDCV507Ym1W89SHDdbOkebvyp7p/ezc9KTYywY3BE2n2g
n5dt0cwI9Rlz4er6n4sIL6Nkkvz2l72NXz3+mcEAX1qvh5SdWDrEgSPBpjnTsQHk
RPNi7Lzq7N59tcyeMCc9s7EwmsZV8u1fboU5dcYVulMkzckOgmJrLCVBjL7tXfpe
/8Y2wusW01YlqHpxWaa5oECBIG1HdUqq3m2zyjAiMlapvwTUsdqr/3mp/kq37p/J
9M4bIclf1nu0ejMKcQmq6GnwGJY588ANVZVzY76lxFFwH8KDu6uImXar1EJ8HU6g
psQpXfW+wtFxR+P8Oy4uQobfiXKEoExSvrmH6B1OCqwPfbqe43Dft0+hgELE6x9T
gPzu9JJXV6evH24SQw/k5iEc0zZkx3L82qK1Iy8uagUd/I3yE93TOys0G/u1vOQr
nvzhWDE7teexMphfAb7Nj478BOD7zeVvxIVbXvJg9D9hXq05SotnWLzKE4xwy0Dw
pTQWPSNcVRg5jyCRu658+TSuKT/DLoQS79Goe2S+riQs1B0yHR8RvphTED/W8aM3
OsK9e4J/ZKo=
=YqS/
-----END PGP SIGNATURE-----

--=-hjk43xs4JLaj/S7EuuCu--

