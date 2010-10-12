Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42471 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932304Ab0JLMts (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Oct 2010 08:49:48 -0400
Received: by wwj40 with SMTP id 40so4973564wwj.1
        for <linux-wireless@vger.kernel.org>; Tue, 12 Oct 2010 05:49:46 -0700 (PDT)
From: Ido Yariv <ido@wizery.com>
To: Luciano Coelho <luciano.coelho@nokia.com>,
	linux-wireless@vger.kernel.org
Cc: Ido Yariv <ido@wizery.com>
Subject: [PATCH v3 2/4] wl1271: Fix TX starvation
Date: Tue, 12 Oct 2010 14:49:10 +0200
Message-Id: <1286887752-19321-3-git-send-email-ido@wizery.com>
In-Reply-To: <1286887752-19321-1-git-send-email-ido@wizery.com>
References: <1286887752-19321-1-git-send-email-ido@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While wl1271_irq_work handles RX directly (by calling wl1271_rx), a different
work is scheduled for transmitting packets. The IRQ work might handle more than
one interrupt during a single call, including multiple TX completion
interrupts. This might starve TX, since no packets are transmitted until all
interrupts are handled.

Fix this by calling the TX work function directly, instead of deferring
it.

Signed-off-by: Ido Yariv <ido@wizery.com>
---
 drivers/net/wireless/wl12xx/wl1271.h      |    1 +
 drivers/net/wireless/wl12xx/wl1271_main.c |   19 +++++++++++++++----
 drivers/net/wireless/wl12xx/wl1271_tx.c   |   14 ++++++++++----
 drivers/net/wireless/wl12xx/wl1271_tx.h   |    1 +
 4 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
index 8a4cd76..4a034a3 100644
--- a/drivers/net/wireless/wl12xx/wl1271.h
+++ b/drivers/net/wireless/wl12xx/wl1271.h
@@ -351,6 +351,7 @@ struct wl1271 {
 #define WL1271_FLAG_IDLE_REQUESTED    (11)
 #define WL1271_FLAG_PSPOLL_FAILURE    (12)
 #define WL1271_FLAG_STA_STATE_SENT    (13)
+#define WL1271_FLAG_FW_TX_BUSY        (14)
 	unsigned long flags;
 
 	struct wl1271_partition_set part;
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 48a4b99..18aff22 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -481,9 +481,9 @@ static void wl1271_fw_status(struct wl1271 *wl,
 		total += cnt;
 	}
 
-	/* if more blocks are available now, schedule some tx work */
-	if (total && !skb_queue_empty(&wl->tx_queue))
-		ieee80211_queue_work(wl->hw, &wl->tx_work);
+	/* if more blocks are available now, tx work can be scheduled */
+	if (total)
+		clear_bit(WL1271_FLAG_FW_TX_BUSY, &wl->flags);
 
 	/* update the host-chipset time offset */
 	getnstimeofday(&ts);
@@ -537,6 +537,16 @@ static void wl1271_irq_work(struct work_struct *work)
 			    (wl->tx_results_count & 0xff))
 				wl1271_tx_complete(wl);
 
+			/* Check if any tx blocks were freed */
+			if (!test_bit(WL1271_FLAG_FW_TX_BUSY, &wl->flags) &&
+					!skb_queue_empty(&wl->tx_queue)) {
+				/*
+				 * In order to avoid starvation of the TX path,
+				 * call the work function directly.
+				 */
+				wl1271_tx_work_locked(wl);
+			}
+
 			wl1271_rx(wl, wl->fw_status);
 		}
 
@@ -867,7 +877,8 @@ static int wl1271_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	 * before that, the tx_work will not be initialized!
 	 */
 
-	ieee80211_queue_work(wl->hw, &wl->tx_work);
+	if (!test_bit(WL1271_FLAG_FW_TX_BUSY, &wl->flags))
+		ieee80211_queue_work(wl->hw, &wl->tx_work);
 
 	/*
 	 * The workqueue is slow to process the tx_queue and we need stop
diff --git a/drivers/net/wireless/wl12xx/wl1271_tx.c b/drivers/net/wireless/wl12xx/wl1271_tx.c
index b13b373..cf32a77 100644
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
 
@@ -260,6 +257,8 @@ void wl1271_tx_work(struct work_struct *work)
 			 * Queue back last skb, and stop aggregating.
 			 */
 			skb_queue_head(&wl->tx_queue, skb);
+			/* No work left, avoid scheduling redundant tx work */
+			set_bit(WL1271_FLAG_FW_TX_BUSY, &wl->flags);
 			goto out_ack;
 		} else if (ret < 0) {
 			dev_kfree_skb(skb);
@@ -283,7 +282,14 @@ out_ack:
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

