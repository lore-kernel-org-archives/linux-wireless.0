Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:44061 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752848AbYI2ScL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Sep 2008 14:32:11 -0400
Message-ID: <48E11F1E.50705@lwfinger.net> (sfid-20080929_203217_500971_C132105B)
Date: Mon, 29 Sep 2008 13:31:58 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: Broadcom Linux <bcm43xx-dev@lists.berlios.de>,
	wireless <linux-wireless@vger.kernel.org>, fback+bcm@fback.net
Subject: [RFC/T] b43: to few loop tries in do_dummy_tx
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael,

I have started modifying my copy of b43 to see if I can locate any
coding problems that might be causing the PHY transmission errors. To
start with, I am checking all the sections that use udelay. The main
reason is that when a bug in the CPU timer cut all delays in half, I
got these errors in b43legacy. I also noted the report this morning
that compiler and toolchain versions seem to be important.

One of the first places I looked was in do_dummy_tx. When I checked
the spin-on-condition loops in this routine, I found that the 3rd
always used the maximum number of loops and exited before the
condition was met. I increased the number of possible loops from 10 to
20 and found that it always takes 17 or 18 passes for the condition to
be met on my machine.

The existing code matches specs - I even checked the code in
4.150.10.5. It is too early to tell if this has anything to do with
the errors, but I suggest the following change:

diff --git a/drivers/net/wireless/b43/main.c
b/drivers/net/wireless/b43/main.c
index 7205a93..af60122 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -814,7 +814,7 @@ void b43_dummy_transmission(struct b43_wldev *dev)
 			break;
 		udelay(10);
 	}
-	for (i = 0x00; i < 0x0A; i++) {
+	for (i = 0x00; i < 0x19; i++) {
 		value = b43_read16(dev, 0x0690);
 		if (!(value & 0x0100))
 			break;

Using 25 passes gives a little margin for CPUs that are much faster
than mine. Perhaps the margin should even be bigger.

Larry


