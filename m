Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:42462 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755822Ab2FWGmV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jun 2012 02:42:21 -0400
Received: by lbok6 with SMTP id k6so5974987lbo.18
        for <linux-wireless@vger.kernel.org>; Fri, 22 Jun 2012 23:42:17 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, arik@wizery.com, ido@wizery.com
Subject: [PATCH 17/18] wlcore: refactor threaded IRQ routine
Date: Sat, 23 Jun 2012 09:41:28 +0300
Message-Id: <1340433689-24320-18-git-send-email-coelho@ti.com> (sfid-20120623_084227_326261_CA4EA9BD)
In-Reply-To: <1340433689-24320-1-git-send-email-coelho@ti.com>
References: <1340433689-24320-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Separate the threaded IRQ handling routine into two functions.
The outer function takes the mutex and calls recovery on errors. It also
performs a Tx-path optimization to avoid redundant works.

The inner function is simplified - all calls to recovery are removed and
it assumes the lock is taken. The locked variant will be reused elsewhere.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wlcore/main.c |   62 ++++++++++++++++-----------------
 1 file changed, 31 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index e6e6654..0c1e075 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -494,20 +494,15 @@ static void wl1271_netstack_work(struct work_struct *work)
 
 #define WL1271_IRQ_MAX_LOOPS 256
 
-static irqreturn_t wl1271_irq(int irq, void *cookie)
+static int wlcore_irq_locked(struct wl1271 *wl)
 {
-	int ret;
+	int ret = 0;
 	u32 intr;
 	int loopcount = WL1271_IRQ_MAX_LOOPS;
-	struct wl1271 *wl = (struct wl1271 *)cookie;
 	bool done = false;
 	unsigned int defer_count;
 	unsigned long flags;
 
-	/* TX might be handled here, avoid redundant work */
-	set_bit(WL1271_FLAG_TX_PENDING, &wl->flags);
-	cancel_work_sync(&wl->tx_work);
-
 	/*
 	 * In case edge triggered interrupt must be used, we cannot iterate
 	 * more than once without introducing race conditions with the hardirq.
@@ -515,8 +510,6 @@ static irqreturn_t wl1271_irq(int irq, void *cookie)
 	if (wl->platform_quirks & WL12XX_PLATFORM_QUIRK_EDGE_IRQ)
 		loopcount = 1;
 
-	mutex_lock(&wl->mutex);
-
 	wl1271_debug(DEBUG_IRQ, "IRQ work");
 
 	if (unlikely(wl->state == WL1271_STATE_OFF))
@@ -536,10 +529,8 @@ static irqreturn_t wl1271_irq(int irq, void *cookie)
 		smp_mb__after_clear_bit();
 
 		ret = wlcore_fw_status(wl, wl->fw_status_1, wl->fw_status_2);
-		if (ret < 0) {
-			wl12xx_queue_recovery_work(wl);
+		if (ret < 0)
 			goto out;
-		}
 
 		wlcore_hw_tx_immediate_compl(wl);
 
@@ -553,7 +544,7 @@ static irqreturn_t wl1271_irq(int irq, void *cookie)
 		if (unlikely(intr & WL1271_ACX_INTR_WATCHDOG)) {
 			wl1271_error("HW watchdog interrupt received! starting recovery.");
 			wl->watchdog_recovery = true;
-			wl12xx_queue_recovery_work(wl);
+			ret = -EIO;
 
 			/* restarting the chip. ignore any other interrupt. */
 			goto out;
@@ -563,7 +554,7 @@ static irqreturn_t wl1271_irq(int irq, void *cookie)
 			wl1271_error("SW watchdog interrupt received! "
 				     "starting recovery.");
 			wl->watchdog_recovery = true;
-			wl12xx_queue_recovery_work(wl);
+			ret = -EIO;
 
 			/* restarting the chip. ignore any other interrupt. */
 			goto out;
@@ -573,10 +564,8 @@ static irqreturn_t wl1271_irq(int irq, void *cookie)
 			wl1271_debug(DEBUG_IRQ, "WL1271_ACX_INTR_DATA");
 
 			ret = wlcore_rx(wl, wl->fw_status_1);
-			if (ret < 0) {
-				wl12xx_queue_recovery_work(wl);
+			if (ret < 0)
 				goto out;
-			}
 
 			/* Check if any tx blocks were freed */
 			spin_lock_irqsave(&wl->wl_lock, flags);
@@ -588,20 +577,16 @@ static irqreturn_t wl1271_irq(int irq, void *cookie)
 				 * call the work function directly.
 				 */
 				ret = wlcore_tx_work_locked(wl);
-				if (ret < 0) {
-					wl12xx_queue_recovery_work(wl);
+				if (ret < 0)
 					goto out;
-				}
 			} else {
 				spin_unlock_irqrestore(&wl->wl_lock, flags);
 			}
 
 			/* check for tx results */
 			ret = wlcore_hw_tx_delayed_compl(wl);
-			if (ret < 0) {
-				wl12xx_queue_recovery_work(wl);
+			if (ret < 0)
 				goto out;
-			}
 
 			/* Make sure the deferred queues don't get too long */
 			defer_count = skb_queue_len(&wl->deferred_tx_queue) +
@@ -613,19 +598,15 @@ static irqreturn_t wl1271_irq(int irq, void *cookie)
 		if (intr & WL1271_ACX_INTR_EVENT_A) {
 			wl1271_debug(DEBUG_IRQ, "WL1271_ACX_INTR_EVENT_A");
 			ret = wl1271_event_handle(wl, 0);
-			if (ret < 0) {
-				wl12xx_queue_recovery_work(wl);
+			if (ret < 0)
 				goto out;
-			}
 		}
 
 		if (intr & WL1271_ACX_INTR_EVENT_B) {
 			wl1271_debug(DEBUG_IRQ, "WL1271_ACX_INTR_EVENT_B");
 			ret = wl1271_event_handle(wl, 1);
-			if (ret < 0) {
-				wl12xx_queue_recovery_work(wl);
+			if (ret < 0)
 				goto out;
-			}
 		}
 
 		if (intr & WL1271_ACX_INTR_INIT_COMPLETE)
@@ -639,6 +620,25 @@ static irqreturn_t wl1271_irq(int irq, void *cookie)
 	wl1271_ps_elp_sleep(wl);
 
 out:
+	return ret;
+}
+
+static irqreturn_t wlcore_irq(int irq, void *cookie)
+{
+	int ret;
+	unsigned long flags;
+	struct wl1271 *wl = cookie;
+
+	/* TX might be handled here, avoid redundant work */
+	set_bit(WL1271_FLAG_TX_PENDING, &wl->flags);
+	cancel_work_sync(&wl->tx_work);
+
+	mutex_lock(&wl->mutex);
+
+	ret = wlcore_irq_locked(wl);
+	if (ret)
+		wl12xx_queue_recovery_work(wl);
+
 	spin_lock_irqsave(&wl->wl_lock, flags);
 	/* In case TX was not handled here, queue TX work */
 	clear_bit(WL1271_FLAG_TX_PENDING, &wl->flags);
@@ -1748,7 +1748,7 @@ static int wl1271_op_resume(struct ieee80211_hw *hw)
 
 		/* don't talk to the HW if recovery is pending */
 		if (!pending_recovery)
-			wl1271_irq(0, wl);
+			wlcore_irq(0, wl);
 
 		wlcore_enable_interrupts(wl);
 	}
@@ -5489,7 +5489,7 @@ int __devinit wlcore_probe(struct wl1271 *wl, struct platform_device *pdev)
 	else
 		irqflags = IRQF_TRIGGER_HIGH | IRQF_ONESHOT;
 
-	ret = request_threaded_irq(wl->irq, wl12xx_hardirq, wl1271_irq,
+	ret = request_threaded_irq(wl->irq, wl12xx_hardirq, wlcore_irq,
 				   irqflags,
 				   pdev->name, wl);
 	if (ret < 0) {
-- 
1.7.10

