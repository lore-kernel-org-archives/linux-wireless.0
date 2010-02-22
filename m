Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:20505 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754689Ab0BVGl0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Feb 2010 01:41:26 -0500
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 11/22] wl1271: Improvements to the TX path
Date: Mon, 22 Feb 2010 08:38:31 +0200
Message-Id: <1266820722-20202-12-git-send-email-juuso.oikarinen@nokia.com>
In-Reply-To: <1266820722-20202-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1266820722-20202-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

- Fix a TX result overflow problem that was present in the TX path and visible
  with at least linksys AP's (probably any AP with high throughput capability.)
- Optimize TX by writing FW trigger for a group of TX frames instead of
  each and every frame.
- Slightly optimize the TX path code.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Kalle Valo <kalle.valo@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271.h      |    4 +-
 drivers/net/wireless/wl12xx/wl1271_main.c |    8 ++----
 drivers/net/wireless/wl12xx/wl1271_tx.c   |   38 +++++++++++++++++-----------
 drivers/net/wireless/wl12xx/wl1271_tx.h   |    2 +-
 4 files changed, 29 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
index 10135c9..cc974ea 100644
--- a/drivers/net/wireless/wl12xx/wl1271.h
+++ b/drivers/net/wireless/wl12xx/wl1271.h
@@ -396,10 +396,10 @@ struct wl1271 {
 	/* Accounting for allocated / available TX blocks on HW */
 	u32 tx_blocks_freed[NUM_TX_QUEUES];
 	u32 tx_blocks_available;
-	u8 tx_results_count;
+	u32 tx_results_count;
 
 	/* Transmitted TX packets counter for chipset interface */
-	int tx_packets_count;
+	u32 tx_packets_count;
 
 	/* Time-offset between host and chipset clocks */
 	int time_offset;
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 310f58c..5cc778f 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -453,14 +453,12 @@ static void wl1271_irq_work(struct work_struct *work)
 		wl1271_debug(DEBUG_IRQ, "WL1271_ACX_INTR_HW_AVAILABLE");
 
 	if (intr & WL1271_ACX_INTR_DATA) {
-		u8 tx_res_cnt = wl->fw_status->tx_results_counter -
-			wl->tx_results_count;
-
 		wl1271_debug(DEBUG_IRQ, "WL1271_ACX_INTR_DATA");
 
 		/* check for tx results */
-		if (tx_res_cnt)
-			wl1271_tx_complete(wl, tx_res_cnt);
+		if (wl->fw_status->tx_results_counter !=
+		    (wl->tx_results_count & 0xff))
+			wl1271_tx_complete(wl);
 
 		wl1271_rx(wl, wl->fw_status);
 	}
diff --git a/drivers/net/wireless/wl12xx/wl1271_tx.c b/drivers/net/wireless/wl12xx/wl1271_tx.c
index 2b7dd9b..2e057b0 100644
--- a/drivers/net/wireless/wl12xx/wl1271_tx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_tx.c
@@ -169,7 +169,6 @@ static int wl1271_tx_send_packet(struct wl1271 *wl, struct sk_buff *skb,
 
 	/* write packet new counter into the write access register */
 	wl->tx_packets_count++;
-	wl1271_write32(wl, WL1271_HOST_WR_ACCESS, wl->tx_packets_count);
 
 	desc = (struct wl1271_tx_hw_descr *) skb->data;
 	wl1271_debug(DEBUG_TX, "tx id %u skb 0x%p payload %u (%u words)",
@@ -244,6 +243,7 @@ void wl1271_tx_work(struct work_struct *work)
 	struct sk_buff *skb;
 	bool woken_up = false;
 	u32 sta_rates = 0;
+	u32 prev_tx_packets_count;
 	int ret;
 
 	/* check if the rates supported by the AP have changed */
@@ -260,6 +260,8 @@ void wl1271_tx_work(struct work_struct *work)
 	if (unlikely(wl->state == WL1271_STATE_OFF))
 		goto out;
 
+	prev_tx_packets_count = wl->tx_packets_count;
+
 	/* if rates have changed, re-configure the rate policy */
 	if (unlikely(sta_rates)) {
 		wl->rate_set = wl1271_tx_enabled_rates_get(wl, sta_rates);
@@ -270,7 +272,7 @@ void wl1271_tx_work(struct work_struct *work)
 		if (!woken_up) {
 			ret = wl1271_ps_elp_wakeup(wl, false);
 			if (ret < 0)
-				goto out;
+				goto out_ack;
 			woken_up = true;
 		}
 
@@ -282,10 +284,10 @@ void wl1271_tx_work(struct work_struct *work)
 			ieee80211_stop_queues(wl->hw);
 			set_bit(WL1271_FLAG_TX_QUEUE_STOPPED, &wl->flags);
 			skb_queue_head(&wl->tx_queue, skb);
-			goto out;
+			goto out_ack;
 		} else if (ret < 0) {
 			dev_kfree_skb(skb);
-			goto out;
+			goto out_ack;
 		} else if (test_and_clear_bit(WL1271_FLAG_TX_QUEUE_STOPPED,
 					      &wl->flags)) {
 			/* firmware buffer has space, restart queues */
@@ -295,6 +297,11 @@ void wl1271_tx_work(struct work_struct *work)
 		}
 	}
 
+out_ack:
+	/* interrupt the firmware with the new packets */
+	if (prev_tx_packets_count != wl->tx_packets_count)
+		wl1271_write32(wl, WL1271_HOST_WR_ACCESS, wl->tx_packets_count);
+
 out:
 	if (woken_up)
 		wl1271_ps_elp_sleep(wl);
@@ -311,7 +318,7 @@ static void wl1271_tx_complete_packet(struct wl1271 *wl,
 	int id = result->id;
 
 	/* check for id legality */
-	if (id >= ACX_TX_DESCRIPTORS || wl->tx_frames[id] == NULL) {
+	if (unlikely(id >= ACX_TX_DESCRIPTORS || wl->tx_frames[id] == NULL)) {
 		wl1271_warning("TX result illegal id: %d", id);
 		return;
 	}
@@ -366,10 +373,11 @@ static void wl1271_tx_complete_packet(struct wl1271 *wl,
 }
 
 /* Called upon reception of a TX complete interrupt */
-void wl1271_tx_complete(struct wl1271 *wl, u32 count)
+void wl1271_tx_complete(struct wl1271 *wl)
 {
 	struct wl1271_acx_mem_map *memmap =
 		(struct wl1271_acx_mem_map *)wl->target_mem_map;
+	u32 count, fw_counter;
 	u32 i;
 
 	wl1271_debug(DEBUG_TX, "tx_complete received, packets: %d", count);
@@ -377,12 +385,18 @@ void wl1271_tx_complete(struct wl1271 *wl, u32 count)
 	/* read the tx results from the chipset */
 	wl1271_read(wl, le32_to_cpu(memmap->tx_result),
 		    wl->tx_res_if, sizeof(*wl->tx_res_if), false);
+	fw_counter = le32_to_cpu(wl->tx_res_if->tx_result_fw_counter);
+
+	/* write host counter to chipset (to ack) */
+	wl1271_write32(wl, le32_to_cpu(memmap->tx_result) +
+		       offsetof(struct wl1271_tx_hw_res_if,
+				tx_result_host_counter), fw_counter);
+
+	count = fw_counter - wl->tx_results_count;
 
 	/* verify that the result buffer is not getting overrun */
-	if (count > TX_HW_RESULT_QUEUE_LEN) {
+	if (unlikely(count > TX_HW_RESULT_QUEUE_LEN))
 		wl1271_warning("TX result overflow from chipset: %d", count);
-		count = TX_HW_RESULT_QUEUE_LEN;
-	}
 
 	/* process the results */
 	for (i = 0; i < count; i++) {
@@ -395,12 +409,6 @@ void wl1271_tx_complete(struct wl1271 *wl, u32 count)
 
 		wl->tx_results_count++;
 	}
-
-	/* write host counter to chipset (to ack) */
-	wl1271_write32(wl, le32_to_cpu(memmap->tx_result) +
-		       offsetof(struct wl1271_tx_hw_res_if,
-		       tx_result_host_counter),
-		       le32_to_cpu(wl->tx_res_if->tx_result_fw_counter));
 }
 
 /* caller must hold wl->mutex */
diff --git a/drivers/net/wireless/wl12xx/wl1271_tx.h b/drivers/net/wireless/wl12xx/wl1271_tx.h
index 17e405a..ca92bd8 100644
--- a/drivers/net/wireless/wl12xx/wl1271_tx.h
+++ b/drivers/net/wireless/wl12xx/wl1271_tx.h
@@ -160,7 +160,7 @@ static inline int wl1271_tx_ac_to_tid(int ac)
 }
 
 void wl1271_tx_work(struct work_struct *work);
-void wl1271_tx_complete(struct wl1271 *wl, u32 count);
+void wl1271_tx_complete(struct wl1271 *wl);
 void wl1271_tx_flush(struct wl1271 *wl);
 
 #endif
-- 
1.6.3.3

