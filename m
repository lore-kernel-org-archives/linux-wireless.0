Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:35684 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965929Ab2EPIiu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 May 2012 04:38:50 -0400
Received: by obhx4 with SMTP id x4so835399obh.20
        for <linux-wireless@vger.kernel.org>; Wed, 16 May 2012 01:38:49 -0700 (PDT)
From: Yoni Divinsky <yoni.divinsky@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: <arik@wizery.com>, <coelho@ti.com>
Subject: [PATCH v2] wlcore: do not send stop fwlog cmd if fw is hanged
Date: Wed, 16 May 2012 11:34:18 +0300
Message-Id: <1337157258-15163-2-git-send-email-yoni.divinsky@ti.com> (sfid-20120516_103855_985443_923CDDD5)
In-Reply-To: <1337157258-15163-1-git-send-email-yoni.divinsky@ti.com>
References: <1337157258-15163-1-git-send-email-yoni.divinsky@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If the driver received a watchdog interrupt then the
assumption is that the fw is hanged. Avoid sending
the stop fwlog command in case of a watchdog recovey
to avoid waiting for the 2 seconds timeout of the command.

Signed-off-by: Yoni Divinsky <yoni.divinsky@ti.com>
---
 drivers/net/wireless/ti/wlcore/main.c   |    9 +++++++--
 drivers/net/wireless/ti/wlcore/wlcore.h |    1 +
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 45fe911..305a7c1 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -582,6 +582,7 @@ static irqreturn_t wl1271_irq(int irq, void *cookie)
 		if (unlikely(intr & WL1271_ACX_INTR_WATCHDOG)) {
 			wl1271_error("watchdog interrupt received! "
 				     "starting recovery.");
+			wl->watchdog_recovery = true;
 			wl12xx_queue_recovery_work(wl);
 
 			/* restarting the chip. ignore any other interrupt. */
@@ -820,10 +821,12 @@ static void wl12xx_read_fwlog_panic(struct wl1271 *wl)
 
 	/*
 	 * Make sure the chip is awake and the logger isn't active.
-	 * This might fail if the firmware hanged.
+	 * Do not send a stop fwlog command if the fw is hanged.
 	 */
-	if (!wl1271_ps_elp_wakeup(wl))
+	if (!wl1271_ps_elp_wakeup(wl) && !wl->watchdog_recovery)
 		wl12xx_cmd_stop_fwlog(wl);
+	else
+		goto out;
 
 	/* Read the first memory block address */
 	wl12xx_fw_status(wl, wl->fw_status);
@@ -914,6 +917,7 @@ static void wl1271_recovery_work(struct work_struct *work)
 		vif = wl12xx_wlvif_to_vif(wlvif);
 		__wl1271_op_remove_interface(wl, vif, false);
 	}
+        wl->watchdog_recovery = false;
 	mutex_unlock(&wl->mutex);
 	wl1271_op_stop(wl->hw);
 
@@ -928,6 +932,7 @@ static void wl1271_recovery_work(struct work_struct *work)
 	ieee80211_wake_queues(wl->hw);
 	return;
 out_unlock:
+        wl->watchdog_recovery = false;
 	mutex_unlock(&wl->mutex);
 }
 
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 0b3f0b5..d6a8ad4 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -228,6 +228,7 @@ struct wl1271 {
 
 	/* Hardware recovery work */
 	struct work_struct recovery_work;
+	bool watchdog_recovery;
 
 	/* Pointer that holds DMA-friendly block for the mailbox */
 	struct event_mailbox *mbox;
-- 
1.7.0.4

