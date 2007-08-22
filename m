Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60813 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565AbXHVJZv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Aug 2007 05:25:51 -0400
Subject: b43 vs. the TIM (was: mac80211 AP mode powersaving problems?)
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <Kalle.Valo@nokia.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jiri Benc <jbenc@suse.cz>,
	Michael Wu <flamingice@sourmilk.net>,
	Michael Buesch <mb@bu3sch.de>
In-Reply-To: <87lkccf30m.fsf@tikku.osso.net>
References: <1186990509.27916.38.camel@johannes.berg>
	 <87lkccf30m.fsf@tikku.osso.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-f21s/rueM5lU/d0neY6n"
Date: Wed, 22 Aug 2007 09:49:05 +0200
Message-Id: <1187768945.9267.12.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-f21s/rueM5lU/d0neY6n
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-08-16 at 08:43 +0300, Kalle Valo wrote:

> One thing which came to my mind is that when Nokia 770 is in PSM it
> uses PS-Poll to fetch the frames from AP. Few devices do that, so I
> wonder if mac80211 supports that properly?

I had to return the N770 I tested with to its owner, but I think I found
the problem anyway. b43 doesn't have a set_tim() handler so the TIM bits
are never set.

Michael, the firmware automatically sets the DTIM count field in the
beacon according to the the B43_SHM_SH_DTIMPER value, B43_SHM_SH_TIMBPOS
must point to the correct offset into the beacon (to the TIM information
element.) Bit 0 of the TIM (broadcast/multicast) is set according to
whether FIFO 4 has contents or not so we'll have to do some more reverse
engineering to get that bit properly set. The microcode doesn't seem to
do any other things with the TIM, but I haven't fully understood the PMQ
thing yet, but it appears to be just some firmware-assisted PS mode
tracking (it adds entries when a STA enters or leaves PS mode or
disassociates/deauthenticates etc.

johannes

--=-f21s/rueM5lU/d0neY6n
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGy+px/ETPhpq3jKURArT5AJ48eN2yuI2vUo0D3+VzAukgrggoEgCgsUX9
xy0F9MqMhdpzrQ8qS+xopaY=
=UNWo
-----END PGP SIGNATURE-----

--=-f21s/rueM5lU/d0neY6n--

