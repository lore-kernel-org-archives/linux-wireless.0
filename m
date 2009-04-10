Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:5558 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755443AbZDJBlJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Apr 2009 21:41:09 -0400
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH] orinoco: correct timeout logic in __orinoco_hw_set_tkip_key()
To: John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Thu, 09 Apr 2009 21:41:05 -0400
Message-ID: <20090410014105.4183.54402.stgit@mj.roinet.com> (sfid-20090410_034120_769936_E2EB7D98)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If the value read from HERMES_RID_TXQUEUEEMPTY becomes 0 after exactly
100 readings, we wrongly consider it a timeout.  Rewrite the clever
while loop as a for loop that does the right thing and looks simpler.

Reported by Juha Leppanen <juha_motorsportcom@luukku.com>

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/orinoco/hw.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/orinoco/hw.c b/drivers/net/wireless/orinoco/hw.c
index 081428d..632fac8 100644
--- a/drivers/net/wireless/orinoco/hw.c
+++ b/drivers/net/wireless/orinoco/hw.c
@@ -372,15 +372,13 @@ int __orinoco_hw_set_tkip_key(hermes_t *hw, int key_idx, int set_tx,
 	}
 
 	/* Wait upto 100ms for tx queue to empty */
-	k = 100;
-	do {
-		k--;
+	for (k = 100; k > 0; k--) {
 		udelay(1000);
 		ret = hermes_read_wordrec(hw, USER_BAP, HERMES_RID_TXQUEUEEMPTY,
 					  &xmitting);
-		if (ret)
+		if (ret || !xmitting)
 			break;
-	} while ((k > 0) && xmitting);
+	}
 
 	if (k == 0)
 		ret = -ETIMEDOUT;
