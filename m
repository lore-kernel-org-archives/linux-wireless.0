Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3149 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755413Ab1KRIVb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 03:21:31 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pAI8LVXD032243
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Fri, 18 Nov 2011 03:21:31 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 20/77] iwlegacy: s/il_rx_mem_buffer/il_rx_buf/
Date: Fri, 18 Nov 2011 09:21:42 +0100
Message-Id: <1321604559-10707-20-git-send-email-sgruszka@redhat.com> (sfid-20111118_092138_231811_E995A216)
In-Reply-To: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
References: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/iwl-3945.c     |   10 +++++-----
 drivers/net/wireless/iwlegacy/iwl-3945.h     |    4 ++--
 drivers/net/wireless/iwlegacy/iwl-4965-lib.c |   14 +++++++-------
 drivers/net/wireless/iwlegacy/iwl-4965-rx.c  |    6 +++---
 drivers/net/wireless/iwlegacy/iwl-4965-tx.c  |    2 +-
 drivers/net/wireless/iwlegacy/iwl-4965.c     |    4 ++--
 drivers/net/wireless/iwlegacy/iwl-4965.h     |   12 ++++++------
 drivers/net/wireless/iwlegacy/iwl-core.c     |    8 ++++----
 drivers/net/wireless/iwlegacy/iwl-core.h     |   12 ++++++------
 drivers/net/wireless/iwlegacy/iwl-dev.h      |   10 +++++-----
 drivers/net/wireless/iwlegacy/iwl-rx.c       |    4 ++--
 drivers/net/wireless/iwlegacy/iwl-scan.c     |    8 ++++----
 drivers/net/wireless/iwlegacy/iwl-tx.c       |    2 +-
 drivers/net/wireless/iwlegacy/iwl3945-base.c |   20 ++++++++++----------
 drivers/net/wireless/iwlegacy/iwl4965-base.c |    8 ++++----
 15 files changed, 62 insertions(+), 62 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/iwl-3945.c b/drivers/net/wireless/iwlegacy/iwl-3945.c
index ff006e7..ad78d3f 100644
--- a/drivers/net/wireless/iwlegacy/iwl-3945.c
+++ b/drivers/net/wireless/iwlegacy/iwl-3945.c
@@ -302,7 +302,7 @@ static void il3945_tx_queue_reclaim(struct il_priv *il,
  * il3945_rx_reply_tx - Handle Tx response
  */
 static void il3945_rx_reply_tx(struct il_priv *il,
-				struct il_rx_mem_buffer *rxb)
+				struct il_rx_buf *rxb)
 {
 	struct il_rx_pkt *pkt = rxb_addr(rxb);
 	u16 sequence = le16_to_cpu(pkt->hdr.sequence);
@@ -396,7 +396,7 @@ static void il3945_accumulative_statistics(struct il_priv *il,
 #endif
 
 void il3945_hw_rx_statistics(struct il_priv *il,
-		struct il_rx_mem_buffer *rxb)
+		struct il_rx_buf *rxb)
 {
 	struct il_rx_pkt *pkt = rxb_addr(rxb);
 
@@ -411,7 +411,7 @@ void il3945_hw_rx_statistics(struct il_priv *il,
 }
 
 void il3945_reply_statistics(struct il_priv *il,
-			      struct il_rx_mem_buffer *rxb)
+			      struct il_rx_buf *rxb)
 {
 	struct il_rx_pkt *pkt = rxb_addr(rxb);
 	__le32 *flag = (__le32 *)&pkt->u.raw;
@@ -456,7 +456,7 @@ static int il3945_is_network_packet(struct il_priv *il,
 }
 
 static void il3945_pass_packet_to_mac80211(struct il_priv *il,
-				   struct il_rx_mem_buffer *rxb,
+				   struct il_rx_buf *rxb,
 				   struct ieee80211_rx_status *stats)
 {
 	struct il_rx_pkt *pkt = rxb_addr(rxb);
@@ -506,7 +506,7 @@ static void il3945_pass_packet_to_mac80211(struct il_priv *il,
 #define IL_DELAY_NEXT_SCAN_AFTER_ASSOC (HZ*6)
 
 static void il3945_rx_reply_rx(struct il_priv *il,
-				struct il_rx_mem_buffer *rxb)
+				struct il_rx_buf *rxb)
 {
 	struct ieee80211_hdr *header;
 	struct ieee80211_rx_status rx_status;
diff --git a/drivers/net/wireless/iwlegacy/iwl-3945.h b/drivers/net/wireless/iwlegacy/iwl-3945.h
index 6c68f59..8a294ca 100644
--- a/drivers/net/wireless/iwlegacy/iwl-3945.h
+++ b/drivers/net/wireless/iwlegacy/iwl-3945.h
@@ -259,9 +259,9 @@ void il3945_hw_build_tx_cmd_rate(struct il_priv *il,
 extern int il3945_hw_reg_send_txpower(struct il_priv *il);
 extern int il3945_hw_reg_set_txpower(struct il_priv *il, s8 power);
 extern void il3945_hw_rx_statistics(struct il_priv *il,
-				 struct il_rx_mem_buffer *rxb);
+				 struct il_rx_buf *rxb);
 void il3945_reply_statistics(struct il_priv *il,
-			      struct il_rx_mem_buffer *rxb);
+			      struct il_rx_buf *rxb);
 extern void il3945_disable_events(struct il_priv *il);
 extern int il4965_get_temperature(const struct il_priv *il);
 extern void il3945_post_associate(struct il_priv *il);
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-lib.c b/drivers/net/wireless/iwlegacy/iwl-4965-lib.c
index 1182bc0..57fc190 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-lib.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-lib.c
@@ -230,7 +230,7 @@ void il4965_rx_queue_restock(struct il_priv *il)
 {
 	struct il_rx_queue *rxq = &il->rxq;
 	struct list_head *element;
-	struct il_rx_mem_buffer *rxb;
+	struct il_rx_buf *rxb;
 	unsigned long flags;
 
 	spin_lock_irqsave(&rxq->lock, flags);
@@ -241,7 +241,7 @@ void il4965_rx_queue_restock(struct il_priv *il)
 
 		/* Get next free Rx buffer, remove from free list */
 		element = rxq->rx_free.next;
-		rxb = list_entry(element, struct il_rx_mem_buffer, list);
+		rxb = list_entry(element, struct il_rx_buf, list);
 		list_del(element);
 
 		/* Point to Rx buffer via next RBD in circular buffer */
@@ -280,7 +280,7 @@ static void il4965_rx_allocate(struct il_priv *il, gfp_t priority)
 {
 	struct il_rx_queue *rxq = &il->rxq;
 	struct list_head *element;
-	struct il_rx_mem_buffer *rxb;
+	struct il_rx_buf *rxb;
 	struct page *page;
 	unsigned long flags;
 	gfp_t gfp_mask = priority;
@@ -329,7 +329,7 @@ static void il4965_rx_allocate(struct il_priv *il, gfp_t priority)
 			return;
 		}
 		element = rxq->rx_used.next;
-		rxb = list_entry(element, struct il_rx_mem_buffer, list);
+		rxb = list_entry(element, struct il_rx_buf, list);
 		list_del(element);
 
 		spin_unlock_irqrestore(&rxq->lock, flags);
@@ -529,7 +529,7 @@ static void il4965_pass_packet_to_mac80211(struct il_priv *il,
 					struct ieee80211_hdr *hdr,
 					u16 len,
 					u32 ampdu_status,
-					struct il_rx_mem_buffer *rxb,
+					struct il_rx_buf *rxb,
 					struct ieee80211_rx_status *stats)
 {
 	struct sk_buff *skb;
@@ -566,7 +566,7 @@ static void il4965_pass_packet_to_mac80211(struct il_priv *il,
 /* Called for REPLY_RX (legacy ABG frames), or
  * REPLY_RX_MPDU_CMD (HT high-throughput N frames). */
 void il4965_rx_reply_rx(struct il_priv *il,
-				struct il_rx_mem_buffer *rxb)
+				struct il_rx_buf *rxb)
 {
 	struct ieee80211_hdr *header;
 	struct ieee80211_rx_status rx_status;
@@ -686,7 +686,7 @@ void il4965_rx_reply_rx(struct il_priv *il,
 /* Cache phy data (Rx signal strength, etc) for HT frame (REPLY_RX_PHY_CMD).
  * This will be used later in il_rx_reply_rx() for REPLY_RX_MPDU_CMD. */
 void il4965_rx_reply_rx_phy(struct il_priv *il,
-			    struct il_rx_mem_buffer *rxb)
+			    struct il_rx_buf *rxb)
 {
 	struct il_rx_pkt *pkt = rxb_addr(rxb);
 	il->_4965.last_phy_res_valid = true;
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-rx.c b/drivers/net/wireless/iwlegacy/iwl-4965-rx.c
index 95b7b13..9ccec09 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-rx.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-rx.c
@@ -42,7 +42,7 @@
 #include "iwl-4965.h"
 
 void il4965_rx_missed_beacon_notif(struct il_priv *il,
-				struct il_rx_mem_buffer *rxb)
+				struct il_rx_buf *rxb)
 
 {
 	struct il_rx_pkt *pkt = rxb_addr(rxb);
@@ -152,7 +152,7 @@ static void il4965_accumulative_statistics(struct il_priv *il,
 #define REG_RECALIB_PERIOD (60)
 
 void il4965_rx_statistics(struct il_priv *il,
-			      struct il_rx_mem_buffer *rxb)
+			      struct il_rx_buf *rxb)
 {
 	int change;
 	struct il_rx_pkt *pkt = rxb_addr(rxb);
@@ -196,7 +196,7 @@ void il4965_rx_statistics(struct il_priv *il,
 }
 
 void il4965_reply_statistics(struct il_priv *il,
-			      struct il_rx_mem_buffer *rxb)
+			      struct il_rx_buf *rxb)
 {
 	struct il_rx_pkt *pkt = rxb_addr(rxb);
 
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-tx.c b/drivers/net/wireless/iwlegacy/iwl-4965-tx.c
index 94d77e2..dff48e8 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-tx.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-tx.c
@@ -1246,7 +1246,7 @@ void il4965_hwrate_to_tx_control(struct il_priv *il, u32 rate_n_flags,
  * of frames sent via aggregation.
  */
 void il4965_rx_reply_compressed_ba(struct il_priv *il,
-					   struct il_rx_mem_buffer *rxb)
+					   struct il_rx_buf *rxb)
 {
 	struct il_rx_pkt *pkt = rxb_addr(rxb);
 	struct il_compressed_ba_resp *ba_resp = &pkt->u.compressed_ba;
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965.c b/drivers/net/wireless/iwlegacy/iwl-4965.c
index 457aa40..5dd963e 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965.c
@@ -1772,7 +1772,7 @@ static int il4965_get_ra_sta_id(struct il_priv *il, struct ieee80211_hdr *hdr)
  * il4965_rx_reply_tx - Handle standard (non-aggregation) Tx response
  */
 static void il4965_rx_reply_tx(struct il_priv *il,
-				struct il_rx_mem_buffer *rxb)
+				struct il_rx_buf *rxb)
 {
 	struct il_rx_pkt *pkt = rxb_addr(rxb);
 	u16 sequence = le16_to_cpu(pkt->hdr.sequence);
@@ -1875,7 +1875,7 @@ static void il4965_rx_reply_tx(struct il_priv *il,
 }
 
 static void il4965_rx_beacon_notif(struct il_priv *il,
-				    struct il_rx_mem_buffer *rxb)
+				    struct il_rx_buf *rxb)
 {
 	struct il_rx_pkt *pkt = rxb_addr(rxb);
 	struct il4965_beacon_notif *beacon = (void *)pkt->u.raw;
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965.h b/drivers/net/wireless/iwlegacy/iwl-4965.h
index 4427462..b5b27f4 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965.h
+++ b/drivers/net/wireless/iwlegacy/iwl-4965.h
@@ -100,9 +100,9 @@ void il4965_rx_queue_free(struct il_priv *il, struct il_rx_queue *rxq);
 int il4965_rxq_stop(struct il_priv *il);
 int il4965_hwrate_to_mac80211_idx(u32 rate_n_flags, enum ieee80211_band band);
 void il4965_rx_reply_rx(struct il_priv *il,
-		     struct il_rx_mem_buffer *rxb);
+		     struct il_rx_buf *rxb);
 void il4965_rx_reply_rx_phy(struct il_priv *il,
-			 struct il_rx_mem_buffer *rxb);
+			 struct il_rx_buf *rxb);
 void il4965_rx_handle(struct il_priv *il);
 
 /* tx */
@@ -122,7 +122,7 @@ int il4965_tx_agg_stop(struct il_priv *il, struct ieee80211_vif *vif,
 int il4965_txq_check_empty(struct il_priv *il,
 			   int sta_id, u8 tid, int txq_id);
 void il4965_rx_reply_compressed_ba(struct il_priv *il,
-				struct il_rx_mem_buffer *rxb);
+				struct il_rx_buf *rxb);
 int il4965_tx_queue_reclaim(struct il_priv *il, int txq_id, int index);
 void il4965_hw_txq_ctx_free(struct il_priv *il);
 int il4965_txq_ctx_alloc(struct il_priv *il);
@@ -171,13 +171,13 @@ u8 il4965_toggle_tx_ant(struct il_priv *il, u8 ant_idx, u8 valid);
 
 /* rx */
 void il4965_rx_missed_beacon_notif(struct il_priv *il,
-				struct il_rx_mem_buffer *rxb);
+				struct il_rx_buf *rxb);
 bool il4965_good_plcp_health(struct il_priv *il,
 			  struct il_rx_pkt *pkt);
 void il4965_rx_statistics(struct il_priv *il,
-		       struct il_rx_mem_buffer *rxb);
+		       struct il_rx_buf *rxb);
 void il4965_reply_statistics(struct il_priv *il,
-			  struct il_rx_mem_buffer *rxb);
+			  struct il_rx_buf *rxb);
 
 /* scan */
 int il4965_request_scan(struct il_priv *il, struct ieee80211_vif *vif);
diff --git a/drivers/net/wireless/iwlegacy/iwl-core.c b/drivers/net/wireless/iwlegacy/iwl-core.c
index 7afdd80..8feb2dd 100644
--- a/drivers/net/wireless/iwlegacy/iwl-core.c
+++ b/drivers/net/wireless/iwlegacy/iwl-core.c
@@ -863,7 +863,7 @@ void il_chswitch_done(struct il_priv *il, bool is_success)
 }
 EXPORT_SYMBOL(il_chswitch_done);
 
-void il_rx_csa(struct il_priv *il, struct il_rx_mem_buffer *rxb)
+void il_rx_csa(struct il_priv *il, struct il_rx_buf *rxb)
 {
 	struct il_rx_pkt *pkt = rxb_addr(rxb);
 	struct il_csa_notification *csa = &(pkt->u.csa_notif);
@@ -1206,7 +1206,7 @@ int il_send_statistics_request(struct il_priv *il, u8 flags, bool clear)
 EXPORT_SYMBOL(il_send_statistics_request);
 
 void il_rx_pm_sleep_notif(struct il_priv *il,
-			   struct il_rx_mem_buffer *rxb)
+			   struct il_rx_buf *rxb)
 {
 #ifdef CONFIG_IWLEGACY_DEBUG
 	struct il_rx_pkt *pkt = rxb_addr(rxb);
@@ -1218,7 +1218,7 @@ void il_rx_pm_sleep_notif(struct il_priv *il,
 EXPORT_SYMBOL(il_rx_pm_sleep_notif);
 
 void il_rx_pm_debug_statistics_notif(struct il_priv *il,
-				      struct il_rx_mem_buffer *rxb)
+				      struct il_rx_buf *rxb)
 {
 	struct il_rx_pkt *pkt = rxb_addr(rxb);
 	u32 len = le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK;
@@ -1230,7 +1230,7 @@ void il_rx_pm_debug_statistics_notif(struct il_priv *il,
 EXPORT_SYMBOL(il_rx_pm_debug_statistics_notif);
 
 void il_rx_reply_error(struct il_priv *il,
-			struct il_rx_mem_buffer *rxb)
+			struct il_rx_buf *rxb)
 {
 	struct il_rx_pkt *pkt = rxb_addr(rxb);
 
diff --git a/drivers/net/wireless/iwlegacy/iwl-core.h b/drivers/net/wireless/iwlegacy/iwl-core.h
index f805ccf..bc2ae06 100644
--- a/drivers/net/wireless/iwlegacy/iwl-core.h
+++ b/drivers/net/wireless/iwlegacy/iwl-core.h
@@ -370,11 +370,11 @@ static inline void il_update_stats(struct il_priv *il, bool is_tx,
  * RX handlers.
  * **************************************************/
 void il_rx_pm_sleep_notif(struct il_priv *il,
-			   struct il_rx_mem_buffer *rxb);
+			   struct il_rx_buf *rxb);
 void il_rx_pm_debug_statistics_notif(struct il_priv *il,
-				      struct il_rx_mem_buffer *rxb);
+				      struct il_rx_buf *rxb);
 void il_rx_reply_error(struct il_priv *il,
-			struct il_rx_mem_buffer *rxb);
+			struct il_rx_buf *rxb);
 
 /*****************************************************
 * RX
@@ -386,14 +386,14 @@ void il_rx_queue_update_write_ptr(struct il_priv *il,
 				  struct il_rx_queue *q);
 int il_rx_queue_space(const struct il_rx_queue *q);
 void il_tx_cmd_complete(struct il_priv *il,
-				struct il_rx_mem_buffer *rxb);
+				struct il_rx_buf *rxb);
 /* Handlers */
 void il_rx_spectrum_measure_notif(struct il_priv *il,
-					  struct il_rx_mem_buffer *rxb);
+					  struct il_rx_buf *rxb);
 void il_recover_from_statistics(struct il_priv *il,
 				struct il_rx_pkt *pkt);
 void il_chswitch_done(struct il_priv *il, bool is_success);
-void il_rx_csa(struct il_priv *il, struct il_rx_mem_buffer *rxb);
+void il_rx_csa(struct il_priv *il, struct il_rx_buf *rxb);
 
 /* TX helpers */
 
diff --git a/drivers/net/wireless/iwlegacy/iwl-dev.h b/drivers/net/wireless/iwlegacy/iwl-dev.h
index d15dcbd..ad72d39 100644
--- a/drivers/net/wireless/iwlegacy/iwl-dev.h
+++ b/drivers/net/wireless/iwlegacy/iwl-dev.h
@@ -85,7 +85,7 @@ struct il_tx_queue;
 #define	DEFAULT_SHORT_RETRY_LIMIT 7U
 #define	DEFAULT_LONG_RETRY_LIMIT  4U
 
-struct il_rx_mem_buffer {
+struct il_rx_buf {
 	dma_addr_t page_dma;
 	struct page *page;
 	struct list_head list;
@@ -346,13 +346,13 @@ struct il_host_cmd {
  * @rb_stts: driver's pointer to receive buffer status
  * @rb_stts_dma: bus address of receive buffer status
  *
- * NOTE:  rx_free and rx_used are used as a FIFO for il_rx_mem_buffers
+ * NOTE:  rx_free and rx_used are used as a FIFO for il_rx_bufs
  */
 struct il_rx_queue {
 	__le32 *bd;
 	dma_addr_t bd_dma;
-	struct il_rx_mem_buffer pool[RX_QUEUE_SIZE + RX_FREE_BUFFERS];
-	struct il_rx_mem_buffer *queue[RX_QUEUE_SIZE];
+	struct il_rx_buf pool[RX_QUEUE_SIZE + RX_FREE_BUFFERS];
+	struct il_rx_buf *queue[RX_QUEUE_SIZE];
 	u32 read;
 	u32 write;
 	u32 free_count;
@@ -968,7 +968,7 @@ struct il_priv {
 	int alloc_rxb_page;
 
 	void (*rx_handlers[REPLY_MAX])(struct il_priv *il,
-				       struct il_rx_mem_buffer *rxb);
+				       struct il_rx_buf *rxb);
 
 	struct ieee80211_supported_band bands[IEEE80211_NUM_BANDS];
 
diff --git a/drivers/net/wireless/iwlegacy/iwl-rx.c b/drivers/net/wireless/iwlegacy/iwl-rx.c
index 2e7c87f..a6bee84 100644
--- a/drivers/net/wireless/iwlegacy/iwl-rx.c
+++ b/drivers/net/wireless/iwlegacy/iwl-rx.c
@@ -95,7 +95,7 @@
  *                            are available, schedules il_rx_replenish
  *
  * -- enable interrupts --
- * ISR - il_rx()         Detach il_rx_mem_buffers from pool up to the
+ * ISR - il_rx()         Detach il_rx_bufs from pool up to the
  *                            READ INDEX, detaching the SKB from the pool.
  *                            Moves the packet buffer from queue to rx_used.
  *                            Calls il_rx_queue_restock to refill any empty
@@ -211,7 +211,7 @@ EXPORT_SYMBOL(il_rx_queue_alloc);
 
 
 void il_rx_spectrum_measure_notif(struct il_priv *il,
-					  struct il_rx_mem_buffer *rxb)
+					  struct il_rx_buf *rxb)
 {
 	struct il_rx_pkt *pkt = rxb_addr(rxb);
 	struct il_spectrum_notification *report = &(pkt->u.spectrum_notif);
diff --git a/drivers/net/wireless/iwlegacy/iwl-scan.c b/drivers/net/wireless/iwlegacy/iwl-scan.c
index 96c90e7..dfc1431 100644
--- a/drivers/net/wireless/iwlegacy/iwl-scan.c
+++ b/drivers/net/wireless/iwlegacy/iwl-scan.c
@@ -183,7 +183,7 @@ EXPORT_SYMBOL(il_scan_cancel_timeout);
 
 /* Service response to REPLY_SCAN_CMD (0x80) */
 static void il_rx_reply_scan(struct il_priv *il,
-			      struct il_rx_mem_buffer *rxb)
+			      struct il_rx_buf *rxb)
 {
 #ifdef CONFIG_IWLEGACY_DEBUG
 	struct il_rx_pkt *pkt = rxb_addr(rxb);
@@ -196,7 +196,7 @@ static void il_rx_reply_scan(struct il_priv *il,
 
 /* Service SCAN_START_NOTIFICATION (0x82) */
 static void il_rx_scan_start_notif(struct il_priv *il,
-				    struct il_rx_mem_buffer *rxb)
+				    struct il_rx_buf *rxb)
 {
 	struct il_rx_pkt *pkt = rxb_addr(rxb);
 	struct il_scanstart_notification *notif =
@@ -214,7 +214,7 @@ static void il_rx_scan_start_notif(struct il_priv *il,
 
 /* Service SCAN_RESULTS_NOTIFICATION (0x83) */
 static void il_rx_scan_results_notif(struct il_priv *il,
-				      struct il_rx_mem_buffer *rxb)
+				      struct il_rx_buf *rxb)
 {
 #ifdef CONFIG_IWLEGACY_DEBUG
 	struct il_rx_pkt *pkt = rxb_addr(rxb);
@@ -236,7 +236,7 @@ static void il_rx_scan_results_notif(struct il_priv *il,
 
 /* Service SCAN_COMPLETE_NOTIFICATION (0x84) */
 static void il_rx_scan_complete_notif(struct il_priv *il,
-				       struct il_rx_mem_buffer *rxb)
+				       struct il_rx_buf *rxb)
 {
 
 #ifdef CONFIG_IWLEGACY_DEBUG
diff --git a/drivers/net/wireless/iwlegacy/iwl-tx.c b/drivers/net/wireless/iwlegacy/iwl-tx.c
index 0e900a4..2e95b78 100644
--- a/drivers/net/wireless/iwlegacy/iwl-tx.c
+++ b/drivers/net/wireless/iwlegacy/iwl-tx.c
@@ -593,7 +593,7 @@ static void il_hcmd_queue_reclaim(struct il_priv *il, int txq_id,
  * if the callback returns 1
  */
 void
-il_tx_cmd_complete(struct il_priv *il, struct il_rx_mem_buffer *rxb)
+il_tx_cmd_complete(struct il_priv *il, struct il_rx_buf *rxb)
 {
 	struct il_rx_pkt *pkt = rxb_addr(rxb);
 	u16 sequence = le16_to_cpu(pkt->hdr.sequence);
diff --git a/drivers/net/wireless/iwlegacy/iwl3945-base.c b/drivers/net/wireless/iwlegacy/iwl3945-base.c
index dd8ce29..446bdb5 100644
--- a/drivers/net/wireless/iwlegacy/iwl3945-base.c
+++ b/drivers/net/wireless/iwlegacy/iwl3945-base.c
@@ -745,7 +745,7 @@ static int il3945_get_measurement(struct il_priv *il,
 }
 
 static void il3945_rx_reply_alive(struct il_priv *il,
-			       struct il_rx_mem_buffer *rxb)
+			       struct il_rx_buf *rxb)
 {
 	struct il_rx_pkt *pkt = rxb_addr(rxb);
 	struct il_alive_resp *palive;
@@ -781,7 +781,7 @@ static void il3945_rx_reply_alive(struct il_priv *il,
 }
 
 static void il3945_rx_reply_add_sta(struct il_priv *il,
-				 struct il_rx_mem_buffer *rxb)
+				 struct il_rx_buf *rxb)
 {
 #ifdef CONFIG_IWLEGACY_DEBUG
 	struct il_rx_pkt *pkt = rxb_addr(rxb);
@@ -791,7 +791,7 @@ static void il3945_rx_reply_add_sta(struct il_priv *il,
 }
 
 static void il3945_rx_beacon_notif(struct il_priv *il,
-				struct il_rx_mem_buffer *rxb)
+				struct il_rx_buf *rxb)
 {
 	struct il_rx_pkt *pkt = rxb_addr(rxb);
 	struct il3945_beacon_notif *beacon = &(pkt->u.beacon_status);
@@ -814,7 +814,7 @@ static void il3945_rx_beacon_notif(struct il_priv *il,
 /* Handle notification from uCode that card's power state is changing
  * due to software, hardware, or critical temperature RFKILL */
 static void il3945_rx_card_state_notif(struct il_priv *il,
-				    struct il_rx_mem_buffer *rxb)
+				    struct il_rx_buf *rxb)
 {
 	struct il_rx_pkt *pkt = rxb_addr(rxb);
 	u32 flags = le32_to_cpu(pkt->u.card_state_notif.flags);
@@ -935,7 +935,7 @@ static void il3945_setup_rx_handlers(struct il_priv *il)
  *                            are available, schedules il3945_rx_replenish
  *
  * -- enable interrupts --
- * ISR - il3945_rx()         Detach il_rx_mem_buffers from pool up to the
+ * ISR - il3945_rx()         Detach il_rx_bufs from pool up to the
  *                            READ INDEX, detaching the SKB from the pool.
  *                            Moves the packet buffer from queue to rx_used.
  *                            Calls il3945_rx_queue_restock to refill any empty
@@ -968,7 +968,7 @@ static void il3945_rx_queue_restock(struct il_priv *il)
 {
 	struct il_rx_queue *rxq = &il->rxq;
 	struct list_head *element;
-	struct il_rx_mem_buffer *rxb;
+	struct il_rx_buf *rxb;
 	unsigned long flags;
 	int write;
 
@@ -977,7 +977,7 @@ static void il3945_rx_queue_restock(struct il_priv *il)
 	while (il_rx_queue_space(rxq) > 0 && rxq->free_count) {
 		/* Get next free Rx buffer, remove from free list */
 		element = rxq->rx_free.next;
-		rxb = list_entry(element, struct il_rx_mem_buffer, list);
+		rxb = list_entry(element, struct il_rx_buf, list);
 		list_del(element);
 
 		/* Point to Rx buffer via next RBD in circular buffer */
@@ -1016,7 +1016,7 @@ static void il3945_rx_allocate(struct il_priv *il, gfp_t priority)
 {
 	struct il_rx_queue *rxq = &il->rxq;
 	struct list_head *element;
-	struct il_rx_mem_buffer *rxb;
+	struct il_rx_buf *rxb;
 	struct page *page;
 	unsigned long flags;
 	gfp_t gfp_mask = priority;
@@ -1059,7 +1059,7 @@ static void il3945_rx_allocate(struct il_priv *il, gfp_t priority)
 			return;
 		}
 		element = rxq->rx_used.next;
-		rxb = list_entry(element, struct il_rx_mem_buffer, list);
+		rxb = list_entry(element, struct il_rx_buf, list);
 		list_del(element);
 		spin_unlock_irqrestore(&rxq->lock, flags);
 
@@ -1201,7 +1201,7 @@ int il3945_calc_db_from_ratio(int sig_ratio)
  */
 static void il3945_rx_handle(struct il_priv *il)
 {
-	struct il_rx_mem_buffer *rxb;
+	struct il_rx_buf *rxb;
 	struct il_rx_pkt *pkt;
 	struct il_rx_queue *rxq = &il->rxq;
 	u32 r, i;
diff --git a/drivers/net/wireless/iwlegacy/iwl4965-base.c b/drivers/net/wireless/iwlegacy/iwl4965-base.c
index 131d6e9..81613ed 100644
--- a/drivers/net/wireless/iwlegacy/iwl4965-base.c
+++ b/drivers/net/wireless/iwlegacy/iwl4965-base.c
@@ -428,7 +428,7 @@ int il4965_hw_tx_queue_init(struct il_priv *il,
  *
  ******************************************************************************/
 static void il4965_rx_reply_alive(struct il_priv *il,
-				struct il_rx_mem_buffer *rxb)
+				struct il_rx_buf *rxb)
 {
 	struct il_rx_pkt *pkt = rxb_addr(rxb);
 	struct il_alive_resp *palive;
@@ -488,7 +488,7 @@ static void il4965_bg_statistics_periodic(unsigned long data)
 }
 
 static void il4965_rx_beacon_notif(struct il_priv *il,
-				struct il_rx_mem_buffer *rxb)
+				struct il_rx_buf *rxb)
 {
 	struct il_rx_pkt *pkt = rxb_addr(rxb);
 	struct il4965_beacon_notif *beacon =
@@ -530,7 +530,7 @@ static void il4965_perform_ct_kill_task(struct il_priv *il)
 /* Handle notification from uCode that card's power state is changing
  * due to software, hardware, or critical temperature RFKILL */
 static void il4965_rx_card_state_notif(struct il_priv *il,
-				    struct il_rx_mem_buffer *rxb)
+				    struct il_rx_buf *rxb)
 {
 	struct il_rx_pkt *pkt = rxb_addr(rxb);
 	u32 flags = le32_to_cpu(pkt->u.card_state_notif.flags);
@@ -633,7 +633,7 @@ static void il4965_setup_rx_handlers(struct il_priv *il)
  */
 void il4965_rx_handle(struct il_priv *il)
 {
-	struct il_rx_mem_buffer *rxb;
+	struct il_rx_buf *rxb;
 	struct il_rx_pkt *pkt;
 	struct il_rx_queue *rxq = &il->rxq;
 	u32 r, i;
-- 
1.7.1

