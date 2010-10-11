Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34116 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753621Ab0JKItm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Oct 2010 04:49:42 -0400
Received: by mail-ww0-f44.google.com with SMTP id 40so3490097wwj.1
        for <linux-wireless@vger.kernel.org>; Mon, 11 Oct 2010 01:49:41 -0700 (PDT)
From: Ido Yariv <ido@wizery.com>
To: Luciano Coelho <luciano.coelho@nokia.com>,
	linux-wireless@vger.kernel.org
Cc: Ido Yariv <ido@wizery.com>
Subject: [PATCH 4/4] wl1271: Fix TX queue low watermark handling
Date: Mon, 11 Oct 2010 10:48:56 +0200
Message-Id: <1286786936-20544-5-git-send-email-ido@wizery.com>
In-Reply-To: <1286786936-20544-1-git-send-email-ido@wizery.com>
References: <1286786936-20544-1-git-send-email-ido@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The number of entries in the TX queue is compared to the low watermark
value each time TX completion interrupts are handled.
However, the fact that a TX completion arrived does not necessarily mean
there are any less skbs in the TX queue.

In addition, a TX completion interrupt does not necessarily mean that there
are any new available TX blocks. Thus, queuing TX work when the low
watermark is reached might not be needed.

Fix this by moving the low watermark handling to the TX work function,
and avoid queuing TX work in this case.

Signed-off-by: Ido Yariv <ido@wizery.com>
---
 drivers/net/wireless/wl12xx/wl1271_tx.c |   36 +++++++++++++++++++-----------
 1 files changed, 23 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_tx.c b/drivers/net/wireless/wl12xx/wl1271_tx.c
index e2ba5a7..a22ebb2 100644
--- a/drivers/net/wireless/wl12xx/wl1271_tx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_tx.c
@@ -212,6 +212,20 @@ u32 wl1271_tx_enabled_rates_get(struct wl1271 *wl, u32 rate_set)
 	return enabled_rates;
 }
 
+static void handle_tx_low_watermark(struct wl1271 *wl)
+{
+	unsigned long flags;
+
+	if (test_bit(WL1271_FLAG_TX_QUEUE_STOPPED, &wl->flags) &&
+	    skb_queue_len(&wl->tx_queue) <= WL1271_TX_QUEUE_LOW_WATERMARK) {
+		/* firmware buffer has space, restart queues */
+		spin_lock_irqsave(&wl->wl_lock, flags);
+		ieee80211_wake_queues(wl->hw);
+		clear_bit(WL1271_FLAG_TX_QUEUE_STOPPED, &wl->flags);
+		spin_unlock_irqrestore(&wl->wl_lock, flags);
+	}
+}
+
 void wl1271_tx_work_locked(struct wl1271 *wl)
 {
 	struct sk_buff *skb;
@@ -225,6 +239,7 @@ void wl1271_tx_work_locked(struct wl1271 *wl)
 	if (unlikely(test_and_clear_bit(WL1271_FLAG_STA_RATES_CHANGED,
 					&wl->flags))) {
 		unsigned long flags;
+
 		spin_lock_irqsave(&wl->wl_lock, flags);
 		sta_rates = wl->sta_rate_set;
 		spin_unlock_irqrestore(&wl->wl_lock, flags);
@@ -289,6 +304,8 @@ out_ack:
 	}
 
 out:
+	handle_tx_low_watermark(wl);
+
 	if (woken_up)
 		wl1271_ps_elp_sleep(wl);
 }
@@ -400,19 +417,6 @@ void wl1271_tx_complete(struct wl1271 *wl)
 
 		wl->tx_results_count++;
 	}
-
-	if (test_bit(WL1271_FLAG_TX_QUEUE_STOPPED, &wl->flags) &&
-	    skb_queue_len(&wl->tx_queue) <= WL1271_TX_QUEUE_LOW_WATERMARK) {
-		unsigned long flags;
-
-		/* firmware buffer has space, restart queues */
-		wl1271_debug(DEBUG_TX, "tx_complete: waking queues");
-		spin_lock_irqsave(&wl->wl_lock, flags);
-		ieee80211_wake_queues(wl->hw);
-		clear_bit(WL1271_FLAG_TX_QUEUE_STOPPED, &wl->flags);
-		spin_unlock_irqrestore(&wl->wl_lock, flags);
-		ieee80211_queue_work(wl->hw, &wl->tx_work);
-	}
 }
 
 /* caller must hold wl->mutex */
@@ -427,6 +431,12 @@ void wl1271_tx_reset(struct wl1271 *wl)
 		ieee80211_tx_status(wl->hw, skb);
 	}
 
+	/*
+	 * Make sure the driver is at a consistent state, in case this
+	 * function is called from a context other than interface removal.
+	 */
+	handle_tx_low_watermark(wl);
+
 	for (i = 0; i < ACX_TX_DESCRIPTORS; i++)
 		if (wl->tx_frames[i] != NULL) {
 			skb = wl->tx_frames[i];
-- 
1.7.0.4

