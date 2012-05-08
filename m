Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:33655 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752530Ab2EHLHa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 May 2012 07:07:30 -0400
Received: by obceq6 with SMTP id eq6so11340315obc.9
        for <linux-wireless@vger.kernel.org>; Tue, 08 May 2012 04:07:29 -0700 (PDT)
From: Yoni Divinsky <yoni.divinsky@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: <arik@wizery.com>, <coelho@ti.com>
Subject: [PATCH 3/4] wlcore: do not send stop fwlog cmd if fw is hanged
Date: Tue,  8 May 2012 14:02:13 +0300
Message-Id: <1336474934-22069-3-git-send-email-yoni.divinsky@ti.com> (sfid-20120508_130734_731881_A4B382AC)
In-Reply-To: <1336474934-22069-1-git-send-email-yoni.divinsky@ti.com>
References: <1336474934-22069-1-git-send-email-yoni.divinsky@ti.com>
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
index 45fe911..b8dcef3 100644
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
@@ -926,6 +929,7 @@ static void wl1271_recovery_work(struct work_struct *work)
 	 * to restart the HW.
 	 */
 	ieee80211_wake_queues(wl->hw);
+	wl->watchdog_recovery = false;
 	return;
 out_unlock:
 	mutex_unlock(&wl->mutex);
@@ -1049,6 +1053,7 @@ int wl1271_plt_start(struct wl1271 *wl)
 
 		wl->plt = true;
 		wl->state = WL1271_STATE_ON;
+		wl->watchdog_recovery = false;
 		wl1271_notice("firmware booted in PLT mode (%s)",
 			      wl->chip.fw_ver_str);
 
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

