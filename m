Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:47719 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755449AbYBULER (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Feb 2008 06:04:17 -0500
Subject: Re: hardware/firmware powersave help, Broadcom scheme
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: Michael Buesch <mb@bu3sch.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Tomas Winkler <tomasw@gmail.com>,
	bruno randolf <br1@einfach.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>, Jouni Malinen <j@w1.fi>
In-Reply-To: <1203591498.17534.179.camel@johannes.berg> (sfid-20080221_105915_696487_565AB67A)
References: <1203520709.17534.68.camel@johannes.berg>
	 <1203574345.3099.64.camel@debian.sh.intel.com>
	 <1203591498.17534.179.camel@johannes.berg>
	 (sfid-20080221_105915_696487_565AB67A)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-w1V2JNveaItzEqeEp7c5"
Date: Thu, 21 Feb 2008 12:04:08 +0100
Message-Id: <1203591848.17534.185.camel@johannes.berg> (sfid-20080221_110423_900971_CC1CF765)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-w1V2JNveaItzEqeEp7c5
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> As for implementing the "barrier" scheme, the following could work:
>=20
> When a STA goes to sleep, mac80211 calls a new
> 	ops->insert_queue_barrier(hw, u8 *sta, u32 cookie)
>=20
> callback in the driver. This callback takes note of all current queue
> status and inserts the status information into a list. mac80211 has
> created a cookie (probably just based on an increasing per-sta counter)
> and saves that cookie in the sta_info for that particular sta (this
> barrier cookie is to allow having two barriers for the same STA in
> flight at the same time).
>=20
> As part of TX status processing, the driver now checks whether any of
> the barriers completed by comparing the TX queue status to the list of
> barriers. It then calls a new
>=20
> 	void ieee80211_barrier_completed(u8 *sta, u32 cookie)
>=20
> mac80211 function. mac80211 looks up the sta and clears the cookie if it
> matches, and if so also schedules all outstanding frames for
> transmission.
>=20
> Additionally, mac80211 is changed to not transmit if the sta has a
> barrier cookie assigned.

Now, let me explain how I'd implement this:

The driver is first changed to always keep track of the frame cookie/ID
for the last frame inserted into each queue. This needs a single u32 per
hardware queue.

Then, when insert_queue_barrier() is called, the driver saves the
following information in a list:
 * sta mac addr
 * cookie
 * last frame cookie for all possible queues

On TX status/completion notification, the driver checks for the first
barrier in the list whether all frame cookies have been completed. This
can either be implemented by making the cookies be increasing numbers or
walking the barrier list for each completed cookie and clearing those
that have been processed. When a barrier has been processed completely,
it calls the ieee80211_barrier_completed() function and removes it from
the list.

johannes

--=-w1V2JNveaItzEqeEp7c5
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR71apqVg1VMiehFYAQKX6A/9FvubF8CzNGqB54uY5gG2PHz2sdwIOD6L
kWlR4RBZ/+ibCob1G3aYKbvuN9NnABIivLraMrBX66p0+P/UQJkyFwEJN1oixiVU
v0RaZSsyoRk59PKyOkdtT/qVEjJGvX4jTDPKLO+NoY9ToOOt2ipKx89boESDD8M0
CQN/exCSJ5vazqDVacr3KaPkm9lpl+vsnSm4i455tpIDDoiOb1n3mI8U5w+a/nlH
aTO42CTe3nDIAgXdOgDt3bNfrFnzNjcwHIZ3DZ+UTZ9ci6NB6jrrx/wid9//fMGN
KHB3yDpz4jZElxp5NANkyD2XpvnEBN5xm5WGA9noKK/sTMc27j6SJnDDyswUWinP
WRu/M/6WiVAT3RXKk1QD7iT/gsqT2K2Sm7o47eE1Pvy5ndPvMjL6/bir8KHC97xO
MuA+lJWR/iOTc3cMvyFXPyX8TkCG4EHd2Y5PMRgziMCWdN87ADMRoIlPACiC3gyB
x5+CVwYrt/bY0Ud707/TMQa+TsXqaaBab4tqR6tXBwAk8pRziQAnb3Lw+6SRNSKk
8HtBP1Fh59hP/DUAwN5dhk+KSaeyoa2cpkjMtp9w1wtDFL5nloTHg1mt515zJetz
3/Qkamx0jmEGlATHiKGY187LuUtPxNGmRmSJlVP8c8w2rUqIVUKbEmyYPIjZ+tRk
4tKebwy2nNQ=
=4NGw
-----END PGP SIGNATURE-----

--=-w1V2JNveaItzEqeEp7c5--

