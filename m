Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34116 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753621Ab0JKItk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Oct 2010 04:49:40 -0400
Received: by wwj40 with SMTP id 40so3490097wwj.1
        for <linux-wireless@vger.kernel.org>; Mon, 11 Oct 2010 01:49:39 -0700 (PDT)
From: Ido Yariv <ido@wizery.com>
To: Luciano Coelho <luciano.coelho@nokia.com>,
	linux-wireless@vger.kernel.org
Cc: Ido Yariv <ido@wizery.com>
Subject: [PATCH 2/4] wl1271: Fix TX starvation
Date: Mon, 11 Oct 2010 10:48:54 +0200
Message-Id: <1286786936-20544-3-git-send-email-ido@wizery.com>
In-Reply-To: <1286786936-20544-1-git-send-email-ido@wizery.com>
References: <1286786936-20544-1-git-send-email-ido@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While wl1271_irq_work handles RX directly (by calling wl1271_rx), a different
work is queued for transmitting packets. The IRQ work might handle more than
one interrupt during a single call, including multiple TX completion
interrupts. This might starve TX, since no packets are transmitted until all
interrupts are handled.

Fix this by calling the TX work function directly, instead of deferring
it.

Signed-off-by: Ido Yariv <ido@wizery.com>
---
 drivers/net/wireless/wl12xx/wl1271_main.c |   19 +++++++++++++------
 drivers/net/wireless/wl12xx/wl1271_tx.c   |   12 ++++++++----
 drivers/net/wireless/wl12xx/wl1271_tx.h   |    1 +
 3 files changed, 22 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 48a4b99..5643834 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -458,7 +458,6 @@ static void wl1271_fw_status(struct wl1271 *wl,
 			     struct wl1271_fw_status *status)
 {
 	struct timespec ts;
-	u32 total = 0;
 	int i;
 
 	wl1271_raw_read(wl, FW_STATUS_ADDR, status, sizeof(*status), false);
@@ -478,13 +477,8 @@ static void wl1271_fw_status(struct wl1271 *wl,
 		wl->tx_blocks_freed[i] =
 			le32_to_cpu(status->tx_released_blks[i]);
 		wl->tx_blocks_available += cnt;
-		total += cnt;
 	}
 
-	/* if more blocks are available now, schedule some tx work */
-	if (total && !skb_queue_empty(&wl->tx_queue))
-		ieee80211_queue_work(wl->hw, &wl->tx_work);
-
 	/* update the host-chipset time offset */
 	getnstimeofday(&ts);
 	wl->time_offset = (timespec_to_ns(&ts) >> 10) -
@@ -499,6 +493,7 @@ static void wl1271_irq_work(struct work_struct *work)
 	u32 intr;
 	int loopcount = WL1271_IRQ_MAX_LOOPS;
 	unsigned long flags;
+	u32 prev_tx_blocks;
 	struct wl1271 *wl =
 		container_of(work, struct wl1271, irq_work);
 
@@ -519,6 +514,7 @@ static void wl1271_irq_work(struct work_struct *work)
 		spin_unlock_irqrestore(&wl->wl_lock, flags);
 		loopcount--;
 
+		prev_tx_blocks = wl->tx_blocks_available;
 		wl1271_fw_status(wl, wl->fw_status);
 		intr = le32_to_cpu(wl->fw_status->intr);
 		if (!intr) {
@@ -537,6 +533,17 @@ static void wl1271_irq_work(struct work_struct *work)
 			    (wl->tx_results_count & 0xff))
 				wl1271_tx_complete(wl);
 
+			/* Check if any tx blocks were freed */
+			if ((wl->tx_blocks_available > prev_tx_blocks) &&
+					!skb_queue_empty(&wl->tx_queue)) {
+				/*
+				 * In order to avoid starvation of the TX path,
+				 * call the work function directly.
+				 */
+				cancel_work_sync(&wl->tx_work);
+				wl1271_tx_work_locked(wl);
+			}
+
 			wl1271_rx(wl, wl->fw_status);
 		}
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_tx.c b/drivers/net/wireless/wl12xx/wl1271_tx.c
index 63bc52c..90a8909 100644
--- a/drivers/net/wireless/wl12xx/wl1271_tx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_tx.c
@@ -204,9 +204,8 @@ u32 wl1271_tx_enabled_rates_get(struct wl1271 *wl, u32 rate_set)
 	return enabled_rates;
 }
 
-void wl1271_tx_work(struct work_struct *work)
+void wl1271_tx_work_locked(struct wl1271 *wl)
 {
-	struct wl1271 *wl = container_of(work, struct wl1271, tx_work);
 	struct sk_buff *skb;
 	bool woken_up = false;
 	u32 sta_rates = 0;
@@ -223,8 +222,6 @@ void wl1271_tx_work(struct work_struct *work)
 		spin_unlock_irqrestore(&wl->wl_lock, flags);
 	}
 
-	mutex_lock(&wl->mutex);
-
 	if (unlikely(wl->state == WL1271_STATE_OFF))
 		goto out;
 
@@ -286,7 +283,14 @@ out_ack:
 out:
 	if (woken_up)
 		wl1271_ps_elp_sleep(wl);
+}
 
+void wl1271_tx_work(struct work_struct *work)
+{
+	struct wl1271 *wl = container_of(work, struct wl1271, tx_work);
+
+	mutex_lock(&wl->mutex);
+	wl1271_tx_work_locked(wl);
 	mutex_unlock(&wl->mutex);
 }
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_tx.h b/drivers/net/wireless/wl12xx/wl1271_tx.h
index d12a129..f1c9065 100644
--- a/drivers/net/wireless/wl12xx/wl1271_tx.h
+++ b/drivers/net/wireless/wl12xx/wl1271_tx.h
@@ -140,6 +140,7 @@ static inline int wl1271_tx_get_queue(int queue)
 }
 
 void wl1271_tx_work(struct work_struct *work);
+void wl1271_tx_work_locked(struct wl1271 *wl);
 void wl1271_tx_complete(struct wl1271 *wl);
 void wl1271_tx_reset(struct wl1271 *wl);
 void wl1271_tx_flush(struct wl1271 *wl);
-- 
1.7.0.4

