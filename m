Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:52772 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbYI2TTe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Sep 2008 15:19:34 -0400
Date: Mon, 29 Sep 2008 14:19:29 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [PATCH] b43: Increase loop tries in do_dummy_tx
Message-ID: <48e12a41.fSr2FmkheZiPQYjZ%Larry.Finger@lwfinger.net> (sfid-20080929_211937_509837_5B320AAC)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

One of the spin-on-condition loops in routine do_dummy_tx always exits before
the condition is satisfied. The hardware might be left in an inconsistent
state that might be the cause of the PHY transmission errors seen by some
users.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This is 2.6.28 material.

Larry
---

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
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

