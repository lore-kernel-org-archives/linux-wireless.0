Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61639 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766Ab1H1MKb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Aug 2011 08:10:31 -0400
Received: by wyg24 with SMTP id 24so3448441wyg.19
        for <linux-wireless@vger.kernel.org>; Sun, 28 Aug 2011 05:10:30 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 1/5] wl12xx: don't disconnect on recovery
Date: Sun, 28 Aug 2011 15:11:53 +0300
Message-Id: <1314533517-24639-1-git-send-email-eliad@wizery.com> (sfid-20110828_141043_028085_DFDD4B0B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

allow full connection recovery by dropping the
beacon_loss notification.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 8324d90..8aff8d4 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1225,9 +1225,6 @@ static void wl1271_recovery_work(struct work_struct *work)
 	    test_bit(WL1271_FLAG_AP_STARTED, &wl->flags))
 		wl->tx_security_seq += WL1271_TX_SQN_POST_RECOVERY_PADDING;
 
-	if (test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags))
-		ieee80211_connection_loss(wl->vif);
-
 	/* Prevent spurious TX during FW restart */
 	ieee80211_stop_queues(wl->hw);
 
-- 
1.7.6.401.g6a319

