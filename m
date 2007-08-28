Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54215 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900AbXH1QRa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Aug 2007 12:17:30 -0400
Subject: Re: mac80211 AP mode powersaving problems?
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <Kalle.Valo@nokia.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jiri Benc <jbenc@suse.cz>,
	Michael Wu <flamingice@sourmilk.net>,
	Michael Buesch <mb@bu3sch.de>
In-Reply-To: <87sl63prsg.fsf@nokia.com>
References: <1186990509.27916.38.camel@johannes.berg>
	 <87lkccf30m.fsf@tikku.osso.net> <1187270479.5141.44.camel@johannes.berg>
	 <87643f4kkh.fsf@nokia.com> <1187275344.23489.6.camel@johannes.berg>
	 <871wdphsus.fsf@nokia.com> <1188290911.7837.65.camel@johannes.berg>
	 <87absbsz5f.fsf@nokia.com> <1188299159.7837.96.camel@johannes.berg>
	 <87sl63prsg.fsf@nokia.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-/tdSrZZIUvqwMfXtGyXx"
Date: Tue, 28 Aug 2007 18:18:55 +0200
Message-Id: <1188317935.7837.106.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/tdSrZZIUvqwMfXtGyXx
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-08-28 at 19:06 +0300, Kalle Valo wrote:

> Ok, I finally managed to test it. Hardware was Nokia N800 and Broadcom
> 4318 in an x86 laptop. I used b43 from wireless-dev#everything commit
> 0347a7c86f8406 and hostapd from commit 62897a2a1a0e. I tested running
> ping and arping from the laptop to N800.

Cool, thanks.

> Everything works fine when N800 has WLAN PSM disabled. When WLAN PSM
> is enabled, TIM for AID is not set in beacons, just like you said.

Right.

> But that's not all, also multicast frames (including ARP broadcast)
> are not buffered correctly. They are sent randomly instead of directly
> after a DTIM beacon. Also Multicast bit is not set and DTIM is always
> zero even though DTIM period is two.

Hm, yeah, I almost expected this, b43 hardware has some capabilities for
this but we don't really know how to use it yet. We also need to upload
the DTIM count to the hardware (shm somewhere)=20

> I also some really odd frames sent by b43 when N800 had PSM enabled.
> Never seen it before, no idea what it is. Dump at the of this message.

Could you send me a packet capture in pkt format via private mail?

johannes

--=-/tdSrZZIUvqwMfXtGyXx
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG1Erv/ETPhpq3jKURArLPAKCcend6cWG/x0KTM/lUejnM+kilXgCdHQ9c
VQbl4qZg7IJFDFCkdPSje4o=
=aKe5
-----END PGP SIGNATURE-----

--=-/tdSrZZIUvqwMfXtGyXx--

