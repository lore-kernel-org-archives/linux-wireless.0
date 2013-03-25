Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:42518 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756079Ab3CYKy4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Mar 2013 06:54:56 -0400
From: Luciano Coelho <coelho@ti.com>
To: <linux-wireless@vger.kernel.org>, <ido@wizery.com>, <balbi@ti.com>
CC: <coelho@ti.com>, <gregoire@alwaysinnovating.com>
Subject: [PATCH] wlcore: move handling from hardirq to the irq thread function
Date: Mon, 25 Mar 2013 12:53:44 +0200
Message-ID: <1364208824-18751-1-git-send-email-coelho@ti.com> (sfid-20130325_115459_652312_1BF9A9D5)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Spin locks and completions are expensive in hard IRQ context and cause
problems with RT kernels.  In RT kernels, both spin locks and
completions can schedule(), so we can't use them in hard irq context.

Move handling code into the irq thread function to avoid that.

Reported-by: Gregoire Gentil <gregoire@alwaysinnovating.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wlcore/main.c |   53 +++++++++++++--------------------
 1 file changed, 21 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 248daa9..c2730a7 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -651,6 +651,25 @@ static irqreturn_t wlcore_irq(int irq, void *cookie)
 	unsigned long flags;
 	struct wl1271 *wl = cookie;
 
+	/* complete the ELP completion */
+	spin_lock_irqsave(&wl->wl_lock, flags);
+	set_bit(WL1271_FLAG_IRQ_RUNNING, &wl->flags);
+	if (wl->elp_compl) {
+		complete(wl->elp_compl);
+		wl->elp_compl = NULL;
+	}
+
+	if (test_bit(WL1271_FLAG_SUSPENDED, &wl->flags)) {
+		/* don't enqueue a work right now. mark it as pending */
+		set_bit(WL1271_FLAG_PENDING_WORK, &wl->flags);
+		wl1271_debug(DEBUG_IRQ, "should not enqueue work");
+		disable_irq_nosync(wl->irq);
+		pm_wakeup_event(wl->dev, 0);
+		spin_unlock_irqrestore(&wl->wl_lock, flags);
+		return IRQ_HANDLED;
+	}
+	spin_unlock_irqrestore(&wl->wl_lock, flags);
+
 	/* TX might be handled here, avoid redundant work */
 	set_bit(WL1271_FLAG_TX_PENDING, &wl->flags);
 	cancel_work_sync(&wl->tx_work);
@@ -5998,35 +6017,6 @@ int wlcore_free_hw(struct wl1271 *wl)
 }
 EXPORT_SYMBOL_GPL(wlcore_free_hw);
 
-static irqreturn_t wl12xx_hardirq(int irq, void *cookie)
-{
-	struct wl1271 *wl = cookie;
-	unsigned long flags;
-
-	wl1271_debug(DEBUG_IRQ, "IRQ");
-
-	/* complete the ELP completion */
-	spin_lock_irqsave(&wl->wl_lock, flags);
-	set_bit(WL1271_FLAG_IRQ_RUNNING, &wl->flags);
-	if (wl->elp_compl) {
-		complete(wl->elp_compl);
-		wl->elp_compl = NULL;
-	}
-
-	if (test_bit(WL1271_FLAG_SUSPENDED, &wl->flags)) {
-		/* don't enqueue a work right now. mark it as pending */
-		set_bit(WL1271_FLAG_PENDING_WORK, &wl->flags);
-		wl1271_debug(DEBUG_IRQ, "should not enqueue work");
-		disable_irq_nosync(wl->irq);
-		pm_wakeup_event(wl->dev, 0);
-		spin_unlock_irqrestore(&wl->wl_lock, flags);
-		return IRQ_HANDLED;
-	}
-	spin_unlock_irqrestore(&wl->wl_lock, flags);
-
-	return IRQ_WAKE_THREAD;
-}
-
 static void wlcore_nvs_cb(const struct firmware *fw, void *context)
 {
 	struct wl1271 *wl = context;
@@ -6068,9 +6058,8 @@ static void wlcore_nvs_cb(const struct firmware *fw, void *context)
 	else
 		irqflags = IRQF_TRIGGER_HIGH | IRQF_ONESHOT;
 
-	ret = request_threaded_irq(wl->irq, wl12xx_hardirq, wlcore_irq,
-				   irqflags,
-				   pdev->name, wl);
+	ret = request_threaded_irq(wl->irq, NULL, wlcore_irq,
+				   irqflags, pdev->name, wl);
 	if (ret < 0) {
 		wl1271_error("request_irq() failed: %d", ret);
 		goto out_free_nvs;
-- 
1.7.10.4

