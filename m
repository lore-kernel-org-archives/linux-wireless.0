Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:37935 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754779Ab2FWGmV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jun 2012 02:42:21 -0400
Received: by lbon10 with SMTP id n10so7625646lbo.27
        for <linux-wireless@vger.kernel.org>; Fri, 22 Jun 2012 23:42:18 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, arik@wizery.com, ido@wizery.com
Subject: [PATCH 18/18] wlcore: prevent recovery in the middle of resume
Date: Sat, 23 Jun 2012 09:41:29 +0300
Message-Id: <1340433689-24320-19-git-send-email-coelho@ti.com> (sfid-20120623_085130_946627_21D99F10)
In-Reply-To: <1340433689-24320-1-git-send-email-coelho@ti.com>
References: <1340433689-24320-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Take the mutex early in the resume handler and use the locked version of
the IRQ routine. This ensures any recoveries queued will only take place
after resume has fully completed.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wlcore/main.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 0c1e075..372ccf2 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -1723,6 +1723,7 @@ static int wl1271_op_resume(struct ieee80211_hw *hw)
 	struct wl12xx_vif *wlvif;
 	unsigned long flags;
 	bool run_irq_work = false, pending_recovery;
+	int ret;
 
 	wl1271_debug(DEBUG_MAC80211, "mac80211 resume wow=%d",
 		     wl->wow_enabled);
@@ -1738,6 +1739,8 @@ static int wl1271_op_resume(struct ieee80211_hw *hw)
 		run_irq_work = true;
 	spin_unlock_irqrestore(&wl->wl_lock, flags);
 
+	mutex_lock(&wl->mutex);
+
 	/* test the recovery flag before calling any SDIO functions */
 	pending_recovery = test_bit(WL1271_FLAG_RECOVERY_IN_PROGRESS,
 				    &wl->flags);
@@ -1747,13 +1750,15 @@ static int wl1271_op_resume(struct ieee80211_hw *hw)
 			     "run postponed irq_work directly");
 
 		/* don't talk to the HW if recovery is pending */
-		if (!pending_recovery)
-			wlcore_irq(0, wl);
+		if (!pending_recovery) {
+			ret = wlcore_irq_locked(wl);
+			if (ret)
+				wl12xx_queue_recovery_work(wl);
+		}
 
 		wlcore_enable_interrupts(wl);
 	}
 
-	mutex_lock(&wl->mutex);
 	if (pending_recovery) {
 		wl1271_warning("queuing forgotten recovery on resume");
 		ieee80211_queue_work(wl->hw, &wl->recovery_work);
-- 
1.7.10

