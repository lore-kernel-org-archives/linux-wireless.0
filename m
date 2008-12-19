Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:33262 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752632AbYLSCpW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 21:45:22 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 24/43] iwl3945: use iwl_rx_mem_buffer
Date: Fri, 19 Dec 2008 10:37:24 +0800
Message-Id: <1229654263-21454-25-git-send-email-yi.zhu@intel.com> (sfid-20081219_034609_712590_4A665338)
In-Reply-To: <1229654263-21454-24-git-send-email-yi.zhu@intel.com>
References: <1229654263-21454-1-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-2-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-3-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-4-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-5-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-6-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-7-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-8-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-9-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-10-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-11-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-12-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-13-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-14-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-15-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-16-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-17-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-18-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-19-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-20-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-21-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-22-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-23-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-24-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

The patch replaces iwl3945_rx_mem_buffer with iwl_rx_mem_buffer.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    8 ++--
 drivers/net/wireless/iwlwifi/iwl-3945.h     |   16 +++------
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   52 +++++++++++++-------------
 3 files changed, 35 insertions(+), 41 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 528c094..bbba509 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -330,7 +330,7 @@ static void iwl3945_tx_queue_reclaim(struct iwl3945_priv *priv,
  * iwl3945_rx_reply_tx - Handle Tx response
  */
 static void iwl3945_rx_reply_tx(struct iwl3945_priv *priv,
-			    struct iwl3945_rx_mem_buffer *rxb)
+			    struct iwl_rx_mem_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
 	u16 sequence = le16_to_cpu(pkt->hdr.sequence);
@@ -389,7 +389,7 @@ static void iwl3945_rx_reply_tx(struct iwl3945_priv *priv,
  *
  *****************************************************************************/
 
-void iwl3945_hw_rx_statistics(struct iwl3945_priv *priv, struct iwl3945_rx_mem_buffer *rxb)
+void iwl3945_hw_rx_statistics(struct iwl3945_priv *priv, struct iwl_rx_mem_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
 	IWL_DEBUG_RX("Statistics notification received (%d vs %d).\n",
@@ -571,7 +571,7 @@ static int iwl3945_is_network_packet(struct iwl3945_priv *priv,
 }
 
 static void iwl3945_pass_packet_to_mac80211(struct iwl3945_priv *priv,
-				   struct iwl3945_rx_mem_buffer *rxb,
+				   struct iwl_rx_mem_buffer *rxb,
 				   struct ieee80211_rx_status *stats)
 {
 	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
@@ -614,7 +614,7 @@ static void iwl3945_pass_packet_to_mac80211(struct iwl3945_priv *priv,
 #define IWL_DELAY_NEXT_SCAN_AFTER_ASSOC (HZ*6)
 
 static void iwl3945_rx_reply_rx(struct iwl3945_priv *priv,
-				struct iwl3945_rx_mem_buffer *rxb)
+				struct iwl_rx_mem_buffer *rxb)
 {
 	struct ieee80211_hdr *header;
 	struct ieee80211_rx_status rx_status;
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index e794cd5..410a8bd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -106,12 +106,6 @@ enum iwl3945_antenna {
 #define	DEFAULT_SHORT_RETRY_LIMIT 7U
 #define	DEFAULT_LONG_RETRY_LIMIT  4U
 
-struct iwl3945_rx_mem_buffer {
-	dma_addr_t dma_addr;
-	struct sk_buff *skb;
-	struct list_head list;
-};
-
 int iwl3945_x2_queue_used(const struct iwl_queue *q, int i);
 
 #define MAX_NUM_OF_TBS          (20)
@@ -229,13 +223,13 @@ struct iwl3945_host_cmd {
  * @rx_used: List of Rx buffers with no SKB
  * @need_update: flag to indicate we need to update read/write index
  *
- * NOTE:  rx_free and rx_used are used as a FIFO for iwl3945_rx_mem_buffers
+ * NOTE:  rx_free and rx_used are used as a FIFO for iwl_rx_mem_buffers
  */
 struct iwl3945_rx_queue {
 	__le32 *bd;
 	dma_addr_t dma_addr;
-	struct iwl3945_rx_mem_buffer pool[RX_QUEUE_SIZE + RX_FREE_BUFFERS];
-	struct iwl3945_rx_mem_buffer *queue[RX_QUEUE_SIZE];
+	struct iwl_rx_mem_buffer pool[RX_QUEUE_SIZE + RX_FREE_BUFFERS];
+	struct iwl_rx_mem_buffer *queue[RX_QUEUE_SIZE];
 	u32 processed;
 	u32 read;
 	u32 write;
@@ -409,7 +403,7 @@ extern void iwl3945_hw_build_tx_cmd_rate(struct iwl3945_priv *priv,
 extern int iwl3945_hw_reg_send_txpower(struct iwl3945_priv *priv);
 extern int iwl3945_hw_reg_set_txpower(struct iwl3945_priv *priv, s8 power);
 extern void iwl3945_hw_rx_statistics(struct iwl3945_priv *priv,
-				 struct iwl3945_rx_mem_buffer *rxb);
+				 struct iwl_rx_mem_buffer *rxb);
 extern void iwl3945_disable_events(struct iwl3945_priv *priv);
 extern int iwl4965_get_temperature(const struct iwl3945_priv *priv);
 
@@ -464,7 +458,7 @@ struct iwl3945_priv {
 	int alloc_rxb_skb;
 
 	void (*rx_handlers[REPLY_MAX])(struct iwl3945_priv *priv,
-				       struct iwl3945_rx_mem_buffer *rxb);
+				       struct iwl_rx_mem_buffer *rxb);
 
 	struct ieee80211_supported_band bands[IEEE80211_NUM_BANDS];
 
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 44777fa..73587fe 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2869,7 +2869,7 @@ static int iwl3945_get_measurement(struct iwl3945_priv *priv,
 #endif
 
 static void iwl3945_rx_reply_alive(struct iwl3945_priv *priv,
-			       struct iwl3945_rx_mem_buffer *rxb)
+			       struct iwl_rx_mem_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
 	struct iwl_alive_resp *palive;
@@ -2905,7 +2905,7 @@ static void iwl3945_rx_reply_alive(struct iwl3945_priv *priv,
 }
 
 static void iwl3945_rx_reply_add_sta(struct iwl3945_priv *priv,
-				 struct iwl3945_rx_mem_buffer *rxb)
+				 struct iwl_rx_mem_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
 
@@ -2914,7 +2914,7 @@ static void iwl3945_rx_reply_add_sta(struct iwl3945_priv *priv,
 }
 
 static void iwl3945_rx_reply_error(struct iwl3945_priv *priv,
-			       struct iwl3945_rx_mem_buffer *rxb)
+			       struct iwl_rx_mem_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
 
@@ -2929,7 +2929,7 @@ static void iwl3945_rx_reply_error(struct iwl3945_priv *priv,
 
 #define TX_STATUS_ENTRY(x) case TX_STATUS_FAIL_ ## x: return #x
 
-static void iwl3945_rx_csa(struct iwl3945_priv *priv, struct iwl3945_rx_mem_buffer *rxb)
+static void iwl3945_rx_csa(struct iwl3945_priv *priv, struct iwl_rx_mem_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
 	struct iwl3945_rxon_cmd *rxon = (void *)&priv->active_rxon;
@@ -2941,7 +2941,7 @@ static void iwl3945_rx_csa(struct iwl3945_priv *priv, struct iwl3945_rx_mem_buff
 }
 
 static void iwl3945_rx_spectrum_measure_notif(struct iwl3945_priv *priv,
-					  struct iwl3945_rx_mem_buffer *rxb)
+					  struct iwl_rx_mem_buffer *rxb)
 {
 #ifdef CONFIG_IWL3945_SPECTRUM_MEASUREMENT
 	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
@@ -2959,7 +2959,7 @@ static void iwl3945_rx_spectrum_measure_notif(struct iwl3945_priv *priv,
 }
 
 static void iwl3945_rx_pm_sleep_notif(struct iwl3945_priv *priv,
-				  struct iwl3945_rx_mem_buffer *rxb)
+				  struct iwl_rx_mem_buffer *rxb)
 {
 #ifdef CONFIG_IWL3945_DEBUG
 	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
@@ -2970,7 +2970,7 @@ static void iwl3945_rx_pm_sleep_notif(struct iwl3945_priv *priv,
 }
 
 static void iwl3945_rx_pm_debug_statistics_notif(struct iwl3945_priv *priv,
-					     struct iwl3945_rx_mem_buffer *rxb)
+					     struct iwl_rx_mem_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
 	IWL_DEBUG_RADIO("Dumping %d bytes of unhandled "
@@ -3006,7 +3006,7 @@ static void iwl3945_bg_beacon_update(struct work_struct *work)
 }
 
 static void iwl3945_rx_beacon_notif(struct iwl3945_priv *priv,
-				struct iwl3945_rx_mem_buffer *rxb)
+				struct iwl_rx_mem_buffer *rxb)
 {
 #ifdef CONFIG_IWL3945_DEBUG
 	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
@@ -3029,7 +3029,7 @@ static void iwl3945_rx_beacon_notif(struct iwl3945_priv *priv,
 
 /* Service response to REPLY_SCAN_CMD (0x80) */
 static void iwl3945_rx_reply_scan(struct iwl3945_priv *priv,
-			      struct iwl3945_rx_mem_buffer *rxb)
+			      struct iwl_rx_mem_buffer *rxb)
 {
 #ifdef CONFIG_IWL3945_DEBUG
 	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
@@ -3042,7 +3042,7 @@ static void iwl3945_rx_reply_scan(struct iwl3945_priv *priv,
 
 /* Service SCAN_START_NOTIFICATION (0x82) */
 static void iwl3945_rx_scan_start_notif(struct iwl3945_priv *priv,
-				    struct iwl3945_rx_mem_buffer *rxb)
+				    struct iwl_rx_mem_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
 	struct iwl_scanstart_notification *notif =
@@ -3059,7 +3059,7 @@ static void iwl3945_rx_scan_start_notif(struct iwl3945_priv *priv,
 
 /* Service SCAN_RESULTS_NOTIFICATION (0x83) */
 static void iwl3945_rx_scan_results_notif(struct iwl3945_priv *priv,
-				      struct iwl3945_rx_mem_buffer *rxb)
+				      struct iwl_rx_mem_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
 	struct iwl_scanresults_notification *notif =
@@ -3084,7 +3084,7 @@ static void iwl3945_rx_scan_results_notif(struct iwl3945_priv *priv,
 
 /* Service SCAN_COMPLETE_NOTIFICATION (0x84) */
 static void iwl3945_rx_scan_complete_notif(struct iwl3945_priv *priv,
-				       struct iwl3945_rx_mem_buffer *rxb)
+				       struct iwl_rx_mem_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
 	struct iwl_scancomplete_notification *scan_notif = (void *)pkt->u.raw;
@@ -3147,7 +3147,7 @@ reschedule:
 /* Handle notification from uCode that card's power state is changing
  * due to software, hardware, or critical temperature RFKILL */
 static void iwl3945_rx_card_state_notif(struct iwl3945_priv *priv,
-				    struct iwl3945_rx_mem_buffer *rxb)
+				    struct iwl_rx_mem_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
 	u32 flags = le32_to_cpu(pkt->u.card_state_notif.flags);
@@ -3265,7 +3265,7 @@ static void iwl3945_cmd_queue_reclaim(struct iwl3945_priv *priv,
  * if the callback returns 1
  */
 static void iwl3945_tx_cmd_complete(struct iwl3945_priv *priv,
-				struct iwl3945_rx_mem_buffer *rxb)
+				struct iwl_rx_mem_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
 	u16 sequence = le16_to_cpu(pkt->hdr.sequence);
@@ -3352,7 +3352,7 @@ static void iwl3945_tx_cmd_complete(struct iwl3945_priv *priv,
  *                            are available, schedules iwl3945_rx_replenish
  *
  * -- enable interrupts --
- * ISR - iwl3945_rx()         Detach iwl3945_rx_mem_buffers from pool up to the
+ * ISR - iwl3945_rx()         Detach iwl_rx_mem_buffers from pool up to the
  *                            READ INDEX, detaching the SKB from the pool.
  *                            Moves the packet buffer from queue to rx_used.
  *                            Calls iwl3945_rx_queue_restock to refill any empty
@@ -3446,7 +3446,7 @@ static int iwl3945_rx_queue_restock(struct iwl3945_priv *priv)
 {
 	struct iwl3945_rx_queue *rxq = &priv->rxq;
 	struct list_head *element;
-	struct iwl3945_rx_mem_buffer *rxb;
+	struct iwl_rx_mem_buffer *rxb;
 	unsigned long flags;
 	int write, rc;
 
@@ -3455,11 +3455,11 @@ static int iwl3945_rx_queue_restock(struct iwl3945_priv *priv)
 	while ((iwl3945_rx_queue_space(rxq) > 0) && (rxq->free_count)) {
 		/* Get next free Rx buffer, remove from free list */
 		element = rxq->rx_free.next;
-		rxb = list_entry(element, struct iwl3945_rx_mem_buffer, list);
+		rxb = list_entry(element, struct iwl_rx_mem_buffer, list);
 		list_del(element);
 
 		/* Point to Rx buffer via next RBD in circular buffer */
-		rxq->bd[rxq->write] = iwl3945_dma_addr2rbd_ptr(priv, rxb->dma_addr);
+		rxq->bd[rxq->write] = iwl3945_dma_addr2rbd_ptr(priv, rxb->real_dma_addr);
 		rxq->queue[rxq->write] = rxb;
 		rxq->write = (rxq->write + 1) & RX_QUEUE_MASK;
 		rxq->free_count--;
@@ -3498,12 +3498,12 @@ static void iwl3945_rx_allocate(struct iwl3945_priv *priv)
 {
 	struct iwl3945_rx_queue *rxq = &priv->rxq;
 	struct list_head *element;
-	struct iwl3945_rx_mem_buffer *rxb;
+	struct iwl_rx_mem_buffer *rxb;
 	unsigned long flags;
 	spin_lock_irqsave(&rxq->lock, flags);
 	while (!list_empty(&rxq->rx_used)) {
 		element = rxq->rx_used.next;
-		rxb = list_entry(element, struct iwl3945_rx_mem_buffer, list);
+		rxb = list_entry(element, struct iwl_rx_mem_buffer, list);
 
 		/* Alloc a new receive buffer */
 		rxb->skb =
@@ -3530,7 +3530,7 @@ static void iwl3945_rx_allocate(struct iwl3945_priv *priv)
 		list_del(element);
 
 		/* Get physical address of RB/SKB */
-		rxb->dma_addr =
+		rxb->real_dma_addr =
 		    pci_map_single(priv->pci_dev, rxb->skb->data,
 				   IWL_RX_BUF_SIZE, PCI_DMA_FROMDEVICE);
 		list_add_tail(&rxb->list, &rxq->rx_free);
@@ -3574,7 +3574,7 @@ static void iwl3945_rx_queue_free(struct iwl3945_priv *priv, struct iwl3945_rx_q
 	for (i = 0; i < RX_QUEUE_SIZE + RX_FREE_BUFFERS; i++) {
 		if (rxq->pool[i].skb != NULL) {
 			pci_unmap_single(priv->pci_dev,
-					 rxq->pool[i].dma_addr,
+					 rxq->pool[i].real_dma_addr,
 					 IWL_RX_BUF_SIZE, PCI_DMA_FROMDEVICE);
 			dev_kfree_skb(rxq->pool[i].skb);
 		}
@@ -3625,7 +3625,7 @@ void iwl3945_rx_queue_reset(struct iwl3945_priv *priv, struct iwl3945_rx_queue *
 		 * to an SKB, so we need to unmap and free potential storage */
 		if (rxq->pool[i].skb != NULL) {
 			pci_unmap_single(priv->pci_dev,
-					 rxq->pool[i].dma_addr,
+					 rxq->pool[i].real_dma_addr,
 					 IWL_RX_BUF_SIZE, PCI_DMA_FROMDEVICE);
 			priv->alloc_rxb_skb--;
 			dev_kfree_skb(rxq->pool[i].skb);
@@ -3728,7 +3728,7 @@ int iwl3945_calc_sig_qual(int rssi_dbm, int noise_dbm)
  */
 static void iwl3945_rx_handle(struct iwl3945_priv *priv)
 {
-	struct iwl3945_rx_mem_buffer *rxb;
+	struct iwl_rx_mem_buffer *rxb;
 	struct iwl_rx_packet *pkt;
 	struct iwl3945_rx_queue *rxq = &priv->rxq;
 	u32 r, i;
@@ -3758,7 +3758,7 @@ static void iwl3945_rx_handle(struct iwl3945_priv *priv)
 
 		rxq->queue[i] = NULL;
 
-		pci_dma_sync_single_for_cpu(priv->pci_dev, rxb->dma_addr,
+		pci_dma_sync_single_for_cpu(priv->pci_dev, rxb->real_dma_addr,
 					    IWL_RX_BUF_SIZE,
 					    PCI_DMA_FROMDEVICE);
 		pkt = (struct iwl_rx_packet *)rxb->skb->data;
@@ -3808,7 +3808,7 @@ static void iwl3945_rx_handle(struct iwl3945_priv *priv)
 			rxb->skb = NULL;
 		}
 
-		pci_unmap_single(priv->pci_dev, rxb->dma_addr,
+		pci_unmap_single(priv->pci_dev, rxb->real_dma_addr,
 				 IWL_RX_BUF_SIZE, PCI_DMA_FROMDEVICE);
 		spin_lock_irqsave(&rxq->lock, flags);
 		list_add_tail(&rxb->list, &priv->rxq.rx_used);
-- 
1.5.3.6

