Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:50035 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755786Ab2FWGmR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jun 2012 02:42:17 -0400
Received: by lbjn8 with SMTP id n8so5620379lbj.14
        for <linux-wireless@vger.kernel.org>; Fri, 22 Jun 2012 23:42:14 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, arik@wizery.com, ido@wizery.com
Subject: [PATCH 15/18] wlcore: force recovery on resume if suspended without recovering
Date: Sat, 23 Jun 2012 09:41:26 +0300
Message-Id: <1340433689-24320-16-git-send-email-coelho@ti.com> (sfid-20120623_085131_112790_DF500F9E)
In-Reply-To: <1340433689-24320-1-git-send-email-coelho@ti.com>
References: <1340433689-24320-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

If an error is detected after mac80211 is already suspended, the recovery
work will not be queued. This will leave the driver in a bad state on
resume.

Detect this in the resume op and re-queue a recovery.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wlcore/main.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 0df28d5..0b51522 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -1707,7 +1707,7 @@ static int wl1271_op_resume(struct ieee80211_hw *hw)
 	struct wl1271 *wl = hw->priv;
 	struct wl12xx_vif *wlvif;
 	unsigned long flags;
-	bool run_irq_work = false;
+	bool run_irq_work = false, pending_recovery;
 
 	wl1271_debug(DEBUG_MAC80211, "mac80211 resume wow=%d",
 		     wl->wow_enabled);
@@ -1723,17 +1723,33 @@ static int wl1271_op_resume(struct ieee80211_hw *hw)
 		run_irq_work = true;
 	spin_unlock_irqrestore(&wl->wl_lock, flags);
 
+	/* test the recovery flag before calling any SDIO functions */
+	pending_recovery = test_bit(WL1271_FLAG_RECOVERY_IN_PROGRESS,
+				    &wl->flags);
+
 	if (run_irq_work) {
 		wl1271_debug(DEBUG_MAC80211,
 			     "run postponed irq_work directly");
-		wl1271_irq(0, wl);
+
+		/* don't talk to the HW if recovery is pending */
+		if (!pending_recovery)
+			wl1271_irq(0, wl);
+
 		wlcore_enable_interrupts(wl);
 	}
 
 	mutex_lock(&wl->mutex);
+	if (pending_recovery) {
+		wl1271_warning("queuing forgotten recovery on resume");
+		ieee80211_queue_work(wl->hw, &wl->recovery_work);
+		goto out;
+	}
+
 	wl12xx_for_each_wlvif(wl, wlvif) {
 		wl1271_configure_resume(wl, wlvif);
 	}
+
+out:
 	wl->wow_enabled = false;
 	mutex_unlock(&wl->mutex);
 
-- 
1.7.10

