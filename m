Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:55663 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754748Ab0J0MJw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Oct 2010 08:09:52 -0400
Received: by eye27 with SMTP id 27so436678eye.19
        for <linux-wireless@vger.kernel.org>; Wed, 27 Oct 2010 05:09:51 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <luciano.coelho@nokia.com>
Subject: [PATCH 1/2] wl1271: handle HW watchdog interrupt
Date: Wed, 27 Oct 2010 14:09:57 +0200
Message-Id: <1288181398-2358-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

unmask the WL1271_ACX_INTR_WATCHDOG interrupt.
when getting it - enqueue a recovery work and bail out.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/wl1271_acx.h  |    3 ++-
 drivers/net/wireless/wl12xx/wl1271_main.c |    8 ++++++++
 2 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.h b/drivers/net/wireless/wl12xx/wl1271_acx.h
index 7589167..b7c4908 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.h
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.h
@@ -61,7 +61,8 @@
 					    WL1271_ACX_INTR_HW_AVAILABLE  | \
 					    WL1271_ACX_INTR_DATA)
 
-#define WL1271_INTR_MASK                   (WL1271_ACX_INTR_EVENT_A      | \
+#define WL1271_INTR_MASK                   (WL1271_ACX_INTR_WATCHDOG     | \
+					    WL1271_ACX_INTR_EVENT_A      | \
 					    WL1271_ACX_INTR_EVENT_B      | \
 					    WL1271_ACX_INTR_HW_AVAILABLE | \
 					    WL1271_ACX_INTR_DATA)
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index c54887c..c9b51f4 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -529,6 +529,14 @@ static void wl1271_irq_work(struct work_struct *work)
 
 		intr &= WL1271_INTR_MASK;
 
+		if (unlikely(intr & WL1271_ACX_INTR_WATCHDOG)) {
+			wl1271_error("watchdog interrupt received! starting recovery.");
+			ieee80211_queue_work(wl->hw, &wl->recovery_work);
+
+			/* we are going to restart the chip. ignore any other interrupt. */
+			goto out;
+		}
+
 		if (intr & WL1271_ACX_INTR_DATA) {
 			wl1271_debug(DEBUG_IRQ, "WL1271_ACX_INTR_DATA");
 
-- 
1.7.0.4

