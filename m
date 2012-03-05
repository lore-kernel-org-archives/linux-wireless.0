Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:41676 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756199Ab2CESK3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Mar 2012 13:10:29 -0500
Date: Mon, 5 Mar 2012 21:10:07 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] airo: fix test for FLAG_RADIO_DOWN
Message-ID: <20120305181007.GC26880@elgon.mountain> (sfid-20120305_191034_447861_020B4150)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We should be doing a shift (1 << FLAG_RADIO_DOWN) here before testing
the flag.  As luck would have it, this test works almost correctly.
The current code tests for FLAG_RADIO_OFF instead of FLAG_RADIO_DOWN.

#define FLAG_RADIO_OFF  0       /* User disabling of MAC */
#define FLAG_RADIO_DOWN 1       /* ifup/ifdown disabling of MAC */

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
I don't have this hardware.  Please review carefully.

diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index 1c008c6..ddc061d 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -1869,7 +1869,7 @@ static int readStatsRid(struct airo_info*ai, StatsRid *sr, int rid, int lock)
 
 static void try_auto_wep(struct airo_info *ai)
 {
-	if (auto_wep && !(ai->flags & FLAG_RADIO_DOWN)) {
+	if (auto_wep && !test_bit(FLAG_RADIO_DOWN, &ai->flags)) {
 		ai->expires = RUN_AT(3*HZ);
 		wake_up_interruptible(&ai->thr_wait);
 	}
