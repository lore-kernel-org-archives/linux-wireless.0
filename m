Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:20491 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754672Ab0BVGlV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Feb 2010 01:41:21 -0500
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 17/22] wl1271: Implement looped IRQ handling
Date: Mon, 22 Feb 2010 08:38:37 +0200
Message-Id: <1266820722-20202-18-git-send-email-juuso.oikarinen@nokia.com>
In-Reply-To: <1266820722-20202-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1266820722-20202-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch implements looped IRQ handling. In essence, if a new interrupt is
asserted by the FW while the host is processing the previous one, the host
will directly proceed processing the new IRQ without leaving the handling
function.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271.h      |    2 +
 drivers/net/wireless/wl12xx/wl1271_main.c |   76 ++++++++++++++++++-----------
 drivers/net/wireless/wl12xx/wl1271_sdio.c |    4 +-
 drivers/net/wireless/wl12xx/wl1271_spi.c  |    4 +-
 4 files changed, 55 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
index 7f03f89..457ce72 100644
--- a/drivers/net/wireless/wl12xx/wl1271.h
+++ b/drivers/net/wireless/wl12xx/wl1271.h
@@ -371,6 +371,8 @@ struct wl1271 {
 #define WL1271_FLAG_IN_ELP             (6)
 #define WL1271_FLAG_PSM                (7)
 #define WL1271_FLAG_PSM_REQUESTED      (8)
+#define WL1271_FLAG_IRQ_PENDING        (9)
+#define WL1271_FLAG_IRQ_RUNNING       (10)
 	unsigned long flags;
 
 	struct wl1271_partition_set part;
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index a46d323..9f74168 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -406,10 +406,14 @@ static void wl1271_fw_status(struct wl1271 *wl,
 		le32_to_cpu(status->fw_localtime);
 }
 
+#define WL1271_IRQ_MAX_LOOPS 10
+
 static void wl1271_irq_work(struct work_struct *work)
 {
 	int ret;
 	u32 intr;
+	int loopcount = WL1271_IRQ_MAX_LOOPS;
+	unsigned long flags;
 	struct wl1271 *wl =
 		container_of(work, struct wl1271, irq_work);
 
@@ -417,51 +421,65 @@ static void wl1271_irq_work(struct work_struct *work)
 
 	wl1271_debug(DEBUG_IRQ, "IRQ work");
 
-	if (wl->state == WL1271_STATE_OFF)
+	if (unlikely(wl->state == WL1271_STATE_OFF))
 		goto out;
 
 	ret = wl1271_ps_elp_wakeup(wl, true);
 	if (ret < 0)
 		goto out;
 
-	wl1271_fw_status(wl, wl->fw_status);
-	intr = le32_to_cpu(wl->fw_status->intr);
-	if (!intr) {
-		wl1271_debug(DEBUG_IRQ, "Zero interrupt received.");
-		goto out_sleep;
-	}
+	spin_lock_irqsave(&wl->wl_lock, flags);
+	while (test_bit(WL1271_FLAG_IRQ_PENDING, &wl->flags) && loopcount) {
+		clear_bit(WL1271_FLAG_IRQ_PENDING, &wl->flags);
+		spin_unlock_irqrestore(&wl->wl_lock, flags);
+		loopcount--;
 
-	intr &= WL1271_INTR_MASK;
+		wl1271_fw_status(wl, wl->fw_status);
+		intr = le32_to_cpu(wl->fw_status->intr);
+		if (!intr) {
+			wl1271_debug(DEBUG_IRQ, "Zero interrupt received.");
+			continue;
+		}
 
-	if (intr & WL1271_ACX_INTR_EVENT_A) {
-		wl1271_debug(DEBUG_IRQ, "WL1271_ACX_INTR_EVENT_A");
-		wl1271_event_handle(wl, 0);
-	}
+		intr &= WL1271_INTR_MASK;
 
-	if (intr & WL1271_ACX_INTR_EVENT_B) {
-		wl1271_debug(DEBUG_IRQ, "WL1271_ACX_INTR_EVENT_B");
-		wl1271_event_handle(wl, 1);
-	}
+		if (intr & WL1271_ACX_INTR_DATA) {
+			wl1271_debug(DEBUG_IRQ, "WL1271_ACX_INTR_DATA");
 
-	if (intr & WL1271_ACX_INTR_INIT_COMPLETE)
-		wl1271_debug(DEBUG_IRQ,
-			     "WL1271_ACX_INTR_INIT_COMPLETE");
+			/* check for tx results */
+			if (wl->fw_status->tx_results_counter !=
+			    (wl->tx_results_count & 0xff))
+				wl1271_tx_complete(wl);
 
-	if (intr & WL1271_ACX_INTR_HW_AVAILABLE)
-		wl1271_debug(DEBUG_IRQ, "WL1271_ACX_INTR_HW_AVAILABLE");
+			wl1271_rx(wl, wl->fw_status);
+		}
+
+		if (intr & WL1271_ACX_INTR_EVENT_A) {
+			wl1271_debug(DEBUG_IRQ, "WL1271_ACX_INTR_EVENT_A");
+			wl1271_event_handle(wl, 0);
+		}
+
+		if (intr & WL1271_ACX_INTR_EVENT_B) {
+			wl1271_debug(DEBUG_IRQ, "WL1271_ACX_INTR_EVENT_B");
+			wl1271_event_handle(wl, 1);
+		}
 
-	if (intr & WL1271_ACX_INTR_DATA) {
-		wl1271_debug(DEBUG_IRQ, "WL1271_ACX_INTR_DATA");
+		if (intr & WL1271_ACX_INTR_INIT_COMPLETE)
+			wl1271_debug(DEBUG_IRQ,
+				     "WL1271_ACX_INTR_INIT_COMPLETE");
 
-		/* check for tx results */
-		if (wl->fw_status->tx_results_counter !=
-		    (wl->tx_results_count & 0xff))
-			wl1271_tx_complete(wl);
+		if (intr & WL1271_ACX_INTR_HW_AVAILABLE)
+			wl1271_debug(DEBUG_IRQ, "WL1271_ACX_INTR_HW_AVAILABLE");
 
-		wl1271_rx(wl, wl->fw_status);
+		spin_lock_irqsave(&wl->wl_lock, flags);
 	}
 
-out_sleep:
+	if (test_bit(WL1271_FLAG_IRQ_PENDING, &wl->flags))
+		ieee80211_queue_work(wl->hw, &wl->irq_work);
+	else
+		clear_bit(WL1271_FLAG_IRQ_RUNNING, &wl->flags);
+	spin_unlock_irqrestore(&wl->wl_lock, flags);
+
 	wl1271_ps_elp_sleep(wl);
 
 out:
diff --git a/drivers/net/wireless/wl12xx/wl1271_sdio.c b/drivers/net/wireless/wl12xx/wl1271_sdio.c
index 7d7c850..1f204db 100644
--- a/drivers/net/wireless/wl12xx/wl1271_sdio.c
+++ b/drivers/net/wireless/wl12xx/wl1271_sdio.c
@@ -75,7 +75,9 @@ static irqreturn_t wl1271_irq(int irq, void *cookie)
 		wl->elp_compl = NULL;
 	}
 
-	ieee80211_queue_work(wl->hw, &wl->irq_work);
+	if (!test_and_set_bit(WL1271_FLAG_IRQ_RUNNING, &wl->flags))
+		ieee80211_queue_work(wl->hw, &wl->irq_work);
+	set_bit(WL1271_FLAG_IRQ_PENDING, &wl->flags);
 	spin_unlock_irqrestore(&wl->wl_lock, flags);
 
 	return IRQ_HANDLED;
diff --git a/drivers/net/wireless/wl12xx/wl1271_spi.c b/drivers/net/wireless/wl12xx/wl1271_spi.c
index 51171d7..ed285fe 100644
--- a/drivers/net/wireless/wl12xx/wl1271_spi.c
+++ b/drivers/net/wireless/wl12xx/wl1271_spi.c
@@ -324,7 +324,9 @@ static irqreturn_t wl1271_irq(int irq, void *cookie)
 		wl->elp_compl = NULL;
 	}
 
-	ieee80211_queue_work(wl->hw, &wl->irq_work);
+	if (!test_and_set_bit(WL1271_FLAG_IRQ_RUNNING, &wl->flags))
+		ieee80211_queue_work(wl->hw, &wl->irq_work);
+	set_bit(WL1271_FLAG_IRQ_PENDING, &wl->flags);
 	spin_unlock_irqrestore(&wl->wl_lock, flags);
 
 	return IRQ_HANDLED;
-- 
1.6.3.3

