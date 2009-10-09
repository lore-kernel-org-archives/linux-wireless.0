Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:33021 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758148AbZJIJRq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Oct 2009 05:17:46 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH V3] iwlwifi: use paged Rx
Date: Fri,  9 Oct 2009 17:19:45 +0800
Message-Id: <1255079985-17282-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This switches the iwlwifi driver to use paged skb from linear skb for Rx
buffer. So that it relieves some Rx buffer allocation pressure for the
memory subsystem. Currently iwlwifi (4K for 3945) requests 8K bytes for
Rx buffer. Due to the trailing skb_shared_info in the skb->data,
alloc_skb() will do the next order allocation, which is 16K bytes. This
is suboptimal and more likely to fail when the system is under memory
usage pressure. Switching to paged Rx skb lets us allocate the RXB
directly by alloc_pages(), so that only order 1 allocation is required.

It also adjusts the area spin_lock (with IRQ disabled) protected in the
tasklet because tasklet guarentees to run only on one CPU and the new
unprotected code can be preempted by the IRQ handler. This saves us from
spawning another workqueue to make skb_linearize/__pskb_pull_tail happy
(which cannot be called in hard irq context).

Finally, mac80211 doesn't support paged Rx yet. So we linearize the skb
for all the management frames and software decryption or defragmentation
required data frames before handed to mac80211. For all the other frames,
we __pskb_pull_tail 64 bytes in the linear area of the skb for mac80211
to handle them properly.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
V2: fix 3945 problem and linearize skb for fragemented frames
V3: fix a 3945 pci_unmap_page bug

 drivers/net/wireless/iwlwifi/iwl-3945.c     |   67 ++++++++++-----
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c     |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   42 ++++-----
 drivers/net/wireless/iwlwifi/iwl-commands.h |   10 ++
 drivers/net/wireless/iwlwifi/iwl-core.c     |   13 ++--
 drivers/net/wireless/iwlwifi/iwl-core.h     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h      |   27 ++++--
 drivers/net/wireless/iwlwifi/iwl-hcmd.c     |   21 ++----
 drivers/net/wireless/iwlwifi/iwl-rx.c       |  122 +++++++++++++++++----------
 drivers/net/wireless/iwlwifi/iwl-scan.c     |   20 ++--
 drivers/net/wireless/iwlwifi/iwl-spectrum.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-sta.c      |   62 +++++--------
 drivers/net/wireless/iwlwifi/iwl-tx.c       |   10 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |  120 +++++++++++++-------------
 15 files changed, 284 insertions(+), 240 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 8012381..b188a02 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -293,7 +293,7 @@ static void iwl3945_tx_queue_reclaim(struct iwl_priv *priv,
 static void iwl3945_rx_reply_tx(struct iwl_priv *priv,
 			    struct iwl_rx_mem_buffer *rxb)
 {
-	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	u16 sequence = le16_to_cpu(pkt->hdr.sequence);
 	int txq_id = SEQ_TO_QUEUE(sequence);
 	int index = SEQ_TO_INDEX(sequence);
@@ -353,7 +353,7 @@ static void iwl3945_rx_reply_tx(struct iwl_priv *priv,
 void iwl3945_hw_rx_statistics(struct iwl_priv *priv,
 		struct iwl_rx_mem_buffer *rxb)
 {
-	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	IWL_DEBUG_RX(priv, "Statistics notification received (%d vs %d).\n",
 		     (int)sizeof(struct iwl3945_notif_statistics),
 		     le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK);
@@ -543,14 +543,17 @@ static void iwl3945_pass_packet_to_mac80211(struct iwl_priv *priv,
 				   struct iwl_rx_mem_buffer *rxb,
 				   struct ieee80211_rx_status *stats)
 {
-	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)IWL_RX_DATA(pkt);
 	struct iwl3945_rx_frame_hdr *rx_hdr = IWL_RX_HDR(pkt);
 	struct iwl3945_rx_frame_end *rx_end = IWL_RX_END(pkt);
-	short len = le16_to_cpu(rx_hdr->len);
+	u16 len = le16_to_cpu(rx_hdr->len);
+	struct sk_buff *skb;
+	int ret;
 
 	/* We received data from the HW, so stop the watchdog */
-	if (unlikely((len + IWL39_RX_FRAME_SIZE) > skb_tailroom(rxb->skb))) {
+	if (unlikely(len + IWL39_RX_FRAME_SIZE >
+		     PAGE_SIZE << priv->hw_params.rx_page_order)) {
 		IWL_DEBUG_DROP(priv, "Corruption detected!\n");
 		return;
 	}
@@ -562,20 +565,45 @@ static void iwl3945_pass_packet_to_mac80211(struct iwl_priv *priv,
 		return;
 	}
 
-	skb_reserve(rxb->skb, (void *)rx_hdr->payload - (void *)pkt);
-	/* Set the size of the skb to the size of the frame */
-	skb_put(rxb->skb, le16_to_cpu(rx_hdr->len));
+	skb = alloc_skb(IWL_LINK_HDR_MAX, GFP_ATOMIC);
+	if (!skb) {
+		IWL_ERR(priv, "alloc_skb failed\n");
+		return;
+	}
 
 	if (!iwl3945_mod_params.sw_crypto)
 		iwl_set_decrypted_flag(priv,
-				       (struct ieee80211_hdr *)rxb->skb->data,
+				       (struct ieee80211_hdr *)rxb_addr(rxb),
 				       le32_to_cpu(rx_end->status), stats);
 
+	skb_add_rx_frag(skb, 0, rxb->page,
+			(void *)rx_hdr->payload - (void *)pkt, len);
+
+	/* mac80211 currently doesn't support paged SKB. Convert it to
+	 * linear SKB for management frame and data frame requires
+	 * software decryption or software defragementation. */
+	if (ieee80211_is_mgmt(hdr->frame_control) ||
+	    ieee80211_has_protected(hdr->frame_control) ||
+	    ieee80211_has_morefrags(hdr->frame_control) ||
+	    le16_to_cpu(hdr->seq_ctrl) & IEEE80211_SCTL_FRAG)
+		ret = skb_linearize(skb);
+	else
+		ret = __pskb_pull_tail(skb, min_t(u16, IWL_LINK_HDR_MAX, len)) ?
+			0 : -ENOMEM;
+
+	if (ret) {
+		kfree_skb(skb);
+		goto out;
+	}
+
 	iwl_update_stats(priv, false, hdr->frame_control, len);
 
-	memcpy(IEEE80211_SKB_RXCB(rxb->skb), stats, sizeof(*stats));
-	ieee80211_rx_irqsafe(priv->hw, rxb->skb);
-	rxb->skb = NULL;
+	memcpy(IEEE80211_SKB_RXCB(skb), stats, sizeof(*stats));
+	ieee80211_rx(priv->hw, skb);
+
+ out:
+	priv->alloc_rxb_page--;
+	rxb->page = NULL;
 }
 
 #define IWL_DELAY_NEXT_SCAN_AFTER_ASSOC (HZ*6)
@@ -585,7 +613,7 @@ static void iwl3945_rx_reply_rx(struct iwl_priv *priv,
 {
 	struct ieee80211_hdr *header;
 	struct ieee80211_rx_status rx_status;
-	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl3945_rx_frame_stats *rx_stats = IWL_RX_STATS(pkt);
 	struct iwl3945_rx_frame_hdr *rx_hdr = IWL_RX_HDR(pkt);
 	struct iwl3945_rx_frame_end *rx_end = IWL_RX_END(pkt);
@@ -1811,7 +1839,7 @@ int iwl3945_hw_reg_set_txpower(struct iwl_priv *priv, s8 power)
 static int iwl3945_send_rxon_assoc(struct iwl_priv *priv)
 {
 	int rc = 0;
-	struct iwl_rx_packet *res = NULL;
+	struct iwl_rx_packet *pkt;
 	struct iwl3945_rxon_assoc_cmd rxon_assoc;
 	struct iwl_host_cmd cmd = {
 		.id = REPLY_RXON_ASSOC,
@@ -1840,14 +1868,14 @@ static int iwl3945_send_rxon_assoc(struct iwl_priv *priv)
 	if (rc)
 		return rc;
 
-	res = (struct iwl_rx_packet *)cmd.reply_skb->data;
-	if (res->hdr.flags & IWL_CMD_FAILED_MSK) {
+	pkt = (struct iwl_rx_packet *)cmd.reply_page;
+	if (pkt->hdr.flags & IWL_CMD_FAILED_MSK) {
 		IWL_ERR(priv, "Bad return from REPLY_RXON_ASSOC command\n");
 		rc = -EIO;
 	}
 
-	priv->alloc_rxb_skb--;
-	dev_kfree_skb_any(cmd.reply_skb);
+	priv->alloc_rxb_page--;
+	free_pages(cmd.reply_page, priv->hw_params.rx_page_order);
 
 	return rc;
 }
@@ -2513,8 +2541,7 @@ int iwl3945_hw_set_hw_params(struct iwl_priv *priv)
 	priv->hw_params.max_txq_num = priv->cfg->num_of_queues;
 
 	priv->hw_params.tfd_size = sizeof(struct iwl3945_tfd);
-	priv->hw_params.rx_buf_size = IWL_RX_BUF_SIZE_3K;
-	priv->hw_params.max_pkt_size = 2342;
+	priv->hw_params.rx_page_order = get_order(IWL_RX_BUF_SIZE_3K);
 	priv->hw_params.max_rxq_size = RX_QUEUE_SIZE;
 	priv->hw_params.max_rxq_log = RX_QUEUE_SIZE_LOG;
 	priv->hw_params.max_stations = IWL3945_STATION_COUNT;
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 6d77039..1a622aa 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -1999,7 +1999,7 @@ static int iwl4965_tx_status_reply_tx(struct iwl_priv *priv,
 static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
 				struct iwl_rx_mem_buffer *rxb)
 {
-	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	u16 sequence = le16_to_cpu(pkt->hdr.sequence);
 	int txq_id = SEQ_TO_QUEUE(sequence);
 	int index = SEQ_TO_INDEX(sequence);
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index ab5b9d8..17555c7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -423,7 +423,7 @@ static int iwl5000_send_calib_cfg(struct iwl_priv *priv)
 static void iwl5000_rx_calib_result(struct iwl_priv *priv,
 			     struct iwl_rx_mem_buffer *rxb)
 {
-	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_calib_hdr *hdr = (struct iwl_calib_hdr *)pkt->u.raw;
 	int len = le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK;
 	int index;
@@ -1143,7 +1143,7 @@ static int iwl5000_tx_status_reply_tx(struct iwl_priv *priv,
 static void iwl5000_rx_reply_tx(struct iwl_priv *priv,
 				struct iwl_rx_mem_buffer *rxb)
 {
-	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	u16 sequence = le16_to_cpu(pkt->hdr.sequence);
 	int txq_id = SEQ_TO_QUEUE(sequence);
 	int index = SEQ_TO_INDEX(sequence);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 0878b34..fc7a511 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -524,7 +524,7 @@ int iwl_hw_tx_queue_init(struct iwl_priv *priv,
 static void iwl_rx_reply_alive(struct iwl_priv *priv,
 				struct iwl_rx_mem_buffer *rxb)
 {
-	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_alive_resp *palive;
 	struct delayed_work *pwork;
 
@@ -610,7 +610,7 @@ static void iwl_rx_beacon_notif(struct iwl_priv *priv,
 				struct iwl_rx_mem_buffer *rxb)
 {
 #ifdef CONFIG_IWLWIFI_DEBUG
-	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl4965_beacon_notif *beacon =
 		(struct iwl4965_beacon_notif *)pkt->u.raw;
 	u8 rate = iwl_hw_get_rate(beacon->beacon_notify_hdr.rate_n_flags);
@@ -634,7 +634,7 @@ static void iwl_rx_beacon_notif(struct iwl_priv *priv,
 static void iwl_rx_card_state_notif(struct iwl_priv *priv,
 				    struct iwl_rx_mem_buffer *rxb)
 {
-	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	u32 flags = le32_to_cpu(pkt->u.card_state_notif.flags);
 	unsigned long status = priv->status;
 
@@ -786,10 +786,10 @@ void iwl_rx_handle(struct iwl_priv *priv)
 
 		rxq->queue[i] = NULL;
 
-		pci_unmap_single(priv->pci_dev, rxb->real_dma_addr,
-				 priv->hw_params.rx_buf_size + 256,
-				 PCI_DMA_FROMDEVICE);
-		pkt = (struct iwl_rx_packet *)rxb->skb->data;
+		pci_unmap_page(priv->pci_dev, rxb->page_dma,
+			       PAGE_SIZE << priv->hw_params.rx_page_order,
+			       PCI_DMA_FROMDEVICE);
+		pkt = rxb_addr(rxb);
 
 		trace_iwlwifi_dev_rx(priv, pkt,
 			le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK);
@@ -825,10 +825,10 @@ void iwl_rx_handle(struct iwl_priv *priv)
 		}
 
 		if (reclaim) {
-			/* Invoke any callbacks, transfer the skb to caller, and
-			 * fire off the (possibly) blocking iwl_send_cmd()
+			/* Invoke any callbacks, transfer the buffer to caller,
+			 * and fire off the (possibly) blocking iwl_send_cmd()
 			 * as we reclaim the driver command queue */
-			if (rxb && rxb->skb)
+			if (rxb && rxb->page)
 				iwl_tx_cmd_complete(priv, rxb);
 			else
 				IWL_WARN(priv, "Claim null rxb?\n");
@@ -837,10 +837,10 @@ void iwl_rx_handle(struct iwl_priv *priv)
 		/* For now we just don't re-use anything.  We can tweak this
 		 * later to try and re-use notification packets and SKBs that
 		 * fail to Rx correctly */
-		if (rxb->skb != NULL) {
-			priv->alloc_rxb_skb--;
-			dev_kfree_skb_any(rxb->skb);
-			rxb->skb = NULL;
+		if (rxb->page != NULL) {
+			priv->alloc_rxb_page--;
+			__free_pages(rxb->page, priv->hw_params.rx_page_order);
+			rxb->page = NULL;
 		}
 
 		spin_lock_irqsave(&rxq->lock, flags);
@@ -907,6 +907,8 @@ static void iwl_irq_tasklet_legacy(struct iwl_priv *priv)
 	}
 #endif
 
+	spin_unlock_irqrestore(&priv->lock, flags);
+
 	/* Since CSR_INT and CSR_FH_INT_STATUS reads and clears are not
 	 * atomic, make sure that inta covers all the interrupts that
 	 * we've discovered, even if FH interrupt came in just after
@@ -928,8 +930,6 @@ static void iwl_irq_tasklet_legacy(struct iwl_priv *priv)
 
 		handled |= CSR_INT_BIT_HW_ERR;
 
-		spin_unlock_irqrestore(&priv->lock, flags);
-
 		return;
 	}
 
@@ -1056,7 +1056,6 @@ static void iwl_irq_tasklet_legacy(struct iwl_priv *priv)
 			"flags 0x%08lx\n", inta, inta_mask, inta_fh, flags);
 	}
 #endif
-	spin_unlock_irqrestore(&priv->lock, flags);
 }
 
 /* tasklet for iwlagn interrupt */
@@ -1086,6 +1085,9 @@ static void iwl_irq_tasklet(struct iwl_priv *priv)
 				inta, inta_mask);
 	}
 #endif
+
+	spin_unlock_irqrestore(&priv->lock, flags);
+
 	/* saved interrupt in inta variable now we can reset priv->inta */
 	priv->inta = 0;
 
@@ -1101,8 +1103,6 @@ static void iwl_irq_tasklet(struct iwl_priv *priv)
 
 		handled |= CSR_INT_BIT_HW_ERR;
 
-		spin_unlock_irqrestore(&priv->lock, flags);
-
 		return;
 	}
 
@@ -1242,14 +1242,10 @@ static void iwl_irq_tasklet(struct iwl_priv *priv)
 			 inta & ~priv->inta_mask);
 	}
 
-
 	/* Re-enable all interrupts */
 	/* only Re-enable if diabled by irq */
 	if (test_bit(STATUS_INT_ENABLED, &priv->status))
 		iwl_enable_interrupts(priv);
-
-	spin_unlock_irqrestore(&priv->lock, flags);
-
 }
 
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index cc4e912..7d4f131 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -3544,6 +3544,16 @@ struct iwl_wimax_coex_cmd {
  *****************************************************************************/
 
 struct iwl_rx_packet {
+	/*
+	 * The first 4 bytes of the RX frame header contain both the RX frame
+	 * size and some flags.
+	 * Bit fields:
+	 * 31:    flag flush RB request
+	 * 30:    flag ignore TC (terminal counter) request
+	 * 29:    flag fast IRQ request
+	 * 28-14: Reserved
+	 * 13-00: RX frame size
+	 */
 	__le32 len_n_flags;
 	struct iwl_cmd_header hdr;
 	union {
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 2ae168a..3e6ce5c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1281,7 +1281,7 @@ static void iwl_set_rate(struct iwl_priv *priv)
 
 void iwl_rx_csa(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 {
-	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_rxon_cmd *rxon = (void *)&priv->active_rxon;
 	struct iwl_csa_notification *csa = &(pkt->u.csa_notif);
 	IWL_DEBUG_11H(priv, "CSA notif: channel %d, status %d\n",
@@ -1492,10 +1492,9 @@ int iwl_set_hw_params(struct iwl_priv *priv)
 	priv->hw_params.max_rxq_size = RX_QUEUE_SIZE;
 	priv->hw_params.max_rxq_log = RX_QUEUE_SIZE_LOG;
 	if (priv->cfg->mod_params->amsdu_size_8K)
-		priv->hw_params.rx_buf_size = IWL_RX_BUF_SIZE_8K;
+		priv->hw_params.rx_page_order = get_order(IWL_RX_BUF_SIZE_8K);
 	else
-		priv->hw_params.rx_buf_size = IWL_RX_BUF_SIZE_4K;
-	priv->hw_params.max_pkt_size = priv->hw_params.rx_buf_size - 256;
+		priv->hw_params.rx_page_order = get_order(IWL_RX_BUF_SIZE_4K);
 
 	priv->hw_params.max_beacon_itrvl = IWL_MAX_UCODE_BEACON_INTERVAL;
 
@@ -2176,7 +2175,7 @@ void iwl_rx_pm_sleep_notif(struct iwl_priv *priv,
 			   struct iwl_rx_mem_buffer *rxb)
 {
 #ifdef CONFIG_IWLWIFI_DEBUG
-	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_sleep_notification *sleep = &(pkt->u.sleep_notif);
 	IWL_DEBUG_RX(priv, "sleep mode: %d, src: %d\n",
 		     sleep->pm_sleep_mode, sleep->pm_wakeup_src);
@@ -2187,7 +2186,7 @@ EXPORT_SYMBOL(iwl_rx_pm_sleep_notif);
 void iwl_rx_pm_debug_statistics_notif(struct iwl_priv *priv,
 				      struct iwl_rx_mem_buffer *rxb)
 {
-	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	u32 len = le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK;
 	IWL_DEBUG_RADIO(priv, "Dumping %d bytes of unhandled "
 			"notification for %s:\n", len,
@@ -2199,7 +2198,7 @@ EXPORT_SYMBOL(iwl_rx_pm_debug_statistics_notif);
 void iwl_rx_reply_error(struct iwl_priv *priv,
 			struct iwl_rx_mem_buffer *rxb)
 {
-	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 
 	IWL_ERR(priv, "Error Reply type 0x%08X cmd %s (0x%02X) "
 		"seq 0x%04X ser 0x%08X\n",
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index cec673b..b877f88 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -531,7 +531,7 @@ int iwl_send_cmd_pdu_async(struct iwl_priv *priv, u8 id, u16 len,
 			   const void *data,
 			   void (*callback)(struct iwl_priv *priv,
 					    struct iwl_device_cmd *cmd,
-					    struct sk_buff *skb));
+					    struct iwl_rx_packet *pkt));
 
 int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 451aa65..35d5794 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -146,12 +146,13 @@ extern void iwl5000_temperature(struct iwl_priv *priv);
 #define	DEFAULT_LONG_RETRY_LIMIT  4U
 
 struct iwl_rx_mem_buffer {
-	dma_addr_t real_dma_addr;
-	dma_addr_t aligned_dma_addr;
-	struct sk_buff *skb;
+	dma_addr_t page_dma;
+	struct page *page;
 	struct list_head list;
 };
 
+#define rxb_addr(r) page_address(r->page)
+
 /* defined below */
 struct iwl_device_cmd;
 
@@ -167,7 +168,7 @@ struct iwl_cmd_meta {
 	 */
 	void (*callback)(struct iwl_priv *priv,
 			 struct iwl_device_cmd *cmd,
-			 struct sk_buff *skb);
+			 struct iwl_rx_packet *pkt);
 
 	/* The CMD_SIZE_HUGE flag bit indicates that the command
 	 * structure is stored at the end of the shared queue memory. */
@@ -366,6 +367,13 @@ enum {
 
 #define IWL_CMD_MAX_PAYLOAD 320
 
+/*
+ * IWL_LINK_HDR_MAX should include ieee80211_hdr, radiotap header,
+ * SNAP header and alignment. It should also be big enough for 802.11
+ * control frames.
+ */
+#define IWL_LINK_HDR_MAX 64
+
 /**
  * struct iwl_device_cmd
  *
@@ -390,10 +398,10 @@ struct iwl_device_cmd {
 
 struct iwl_host_cmd {
 	const void *data;
-	struct sk_buff *reply_skb;
+	unsigned long reply_page;
 	void (*callback)(struct iwl_priv *priv,
 			 struct iwl_device_cmd *cmd,
-			 struct sk_buff *skb);
+			 struct iwl_rx_packet *pkt);
 	u32 flags;
 	u16 len;
 	u8 id;
@@ -650,7 +658,7 @@ struct iwl_sensitivity_ranges {
  * @valid_tx/rx_ant: usable antennas
  * @max_rxq_size: Max # Rx frames in Rx queue (must be power-of-2)
  * @max_rxq_log: Log-base-2 of max_rxq_size
- * @rx_buf_size: Rx buffer size
+ * @rx_page_order: Rx buffer page order
  * @rx_wrt_ptr_reg: FH{39}_RSCSR_CHNL0_WPTR
  * @max_stations:
  * @bcast_sta_id:
@@ -673,9 +681,8 @@ struct iwl_hw_params {
 	u8  valid_rx_ant;
 	u16 max_rxq_size;
 	u16 max_rxq_log;
-	u32 rx_buf_size;
+	u32 rx_page_order;
 	u32 rx_wrt_ptr_reg;
-	u32 max_pkt_size;
 	u8  max_stations;
 	u8  bcast_sta_id;
 	u8  ht40_channel;
@@ -987,7 +994,7 @@ struct iwl_priv {
 	int frames_count;
 
 	enum ieee80211_band band;
-	int alloc_rxb_skb;
+	int alloc_rxb_page;
 
 	void (*rx_handlers[REPLY_MAX])(struct iwl_priv *priv,
 				       struct iwl_rx_mem_buffer *rxb);
diff --git a/drivers/net/wireless/iwlwifi/iwl-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
index 532c8d6..22a21a1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
@@ -103,17 +103,8 @@ EXPORT_SYMBOL(get_cmd_string);
 
 static void iwl_generic_cmd_callback(struct iwl_priv *priv,
 				     struct iwl_device_cmd *cmd,
-				     struct sk_buff *skb)
+				     struct iwl_rx_packet *pkt)
 {
-	struct iwl_rx_packet *pkt = NULL;
-
-	if (!skb) {
-		IWL_ERR(priv, "Error: Response NULL in %s.\n",
-				get_cmd_string(cmd->hdr.cmd));
-		return;
-	}
-
-	pkt = (struct iwl_rx_packet *)skb->data;
 	if (pkt->hdr.flags & IWL_CMD_FAILED_MSK) {
 		IWL_ERR(priv, "Bad return from %s (0x%08X)\n",
 			get_cmd_string(cmd->hdr.cmd), pkt->hdr.flags);
@@ -215,7 +206,7 @@ int iwl_send_cmd_sync(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 		ret = -EIO;
 		goto fail;
 	}
-	if ((cmd->flags & CMD_WANT_SKB) && !cmd->reply_skb) {
+	if ((cmd->flags & CMD_WANT_SKB) && !cmd->reply_page) {
 		IWL_ERR(priv, "Error: Response NULL in '%s'\n",
 			  get_cmd_string(cmd->id));
 		ret = -EIO;
@@ -237,9 +228,9 @@ cancel:
 							~CMD_WANT_SKB;
 	}
 fail:
-	if (cmd->reply_skb) {
-		dev_kfree_skb_any(cmd->reply_skb);
-		cmd->reply_skb = NULL;
+	if (cmd->reply_page) {
+		free_pages(cmd->reply_page, priv->hw_params.rx_page_order);
+		cmd->reply_page = 0;
 	}
 out:
 	clear_bit(STATUS_HCMD_SYNC_ACTIVE, &priv->status);
@@ -272,7 +263,7 @@ int iwl_send_cmd_pdu_async(struct iwl_priv *priv,
 			   u8 id, u16 len, const void *data,
 			   void (*callback)(struct iwl_priv *priv,
 					    struct iwl_device_cmd *cmd,
-					    struct sk_buff *skb))
+					    struct iwl_rx_packet *pkt))
 {
 	struct iwl_host_cmd cmd = {
 		.id = id,
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 7ad327e..0a407f7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -200,7 +200,7 @@ int iwl_rx_queue_restock(struct iwl_priv *priv)
 		list_del(element);
 
 		/* Point to Rx buffer via next RBD in circular buffer */
-		rxq->bd[rxq->write] = iwl_dma_addr2rbd_ptr(priv, rxb->aligned_dma_addr);
+		rxq->bd[rxq->write] = iwl_dma_addr2rbd_ptr(priv, rxb->page_dma);
 		rxq->queue[rxq->write] = rxb;
 		rxq->write = (rxq->write + 1) & RX_QUEUE_MASK;
 		rxq->free_count--;
@@ -239,7 +239,7 @@ void iwl_rx_allocate(struct iwl_priv *priv, gfp_t priority)
 	struct iwl_rx_queue *rxq = &priv->rxq;
 	struct list_head *element;
 	struct iwl_rx_mem_buffer *rxb;
-	struct sk_buff *skb;
+	struct page *page;
 	unsigned long flags;
 
 	while (1) {
@@ -252,29 +252,34 @@ void iwl_rx_allocate(struct iwl_priv *priv, gfp_t priority)
 
 		if (rxq->free_count > RX_LOW_WATERMARK)
 			priority |= __GFP_NOWARN;
-		/* Alloc a new receive buffer */
-		skb = alloc_skb(priv->hw_params.rx_buf_size + 256,
-						priority);
 
-		if (!skb) {
+		if (priv->hw_params.rx_page_order > 0)
+			priority |= __GFP_COMP;
+
+		/* Alloc a new receive buffer */
+		page = alloc_pages(priority, priv->hw_params.rx_page_order);
+		if (!page) {
 			if (net_ratelimit())
-				IWL_DEBUG_INFO(priv, "Failed to allocate SKB buffer.\n");
+				IWL_DEBUG_INFO(priv, "alloc_pages failed, "
+					       "order: %d\n",
+					       priv->hw_params.rx_page_order);
+
 			if ((rxq->free_count <= RX_LOW_WATERMARK) &&
 			    net_ratelimit())
-				IWL_CRIT(priv, "Failed to allocate SKB buffer with %s. Only %u free buffers remaining.\n",
+				IWL_CRIT(priv, "Failed to alloc_pages with %s. Only %u free buffers remaining.\n",
 					 priority == GFP_ATOMIC ?  "GFP_ATOMIC" : "GFP_KERNEL",
 					 rxq->free_count);
 			/* We don't reschedule replenish work here -- we will
 			 * call the restock method and if it still needs
 			 * more buffers it will schedule replenish */
-			break;
+			return;
 		}
 
 		spin_lock_irqsave(&rxq->lock, flags);
 
 		if (list_empty(&rxq->rx_used)) {
 			spin_unlock_irqrestore(&rxq->lock, flags);
-			dev_kfree_skb_any(skb);
+			__free_pages(page, priv->hw_params.rx_page_order);
 			return;
 		}
 		element = rxq->rx_used.next;
@@ -283,24 +288,21 @@ void iwl_rx_allocate(struct iwl_priv *priv, gfp_t priority)
 
 		spin_unlock_irqrestore(&rxq->lock, flags);
 
-		rxb->skb = skb;
-		/* Get physical address of RB/SKB */
-		rxb->real_dma_addr = pci_map_single(
-					priv->pci_dev,
-					rxb->skb->data,
-					priv->hw_params.rx_buf_size + 256,
-					PCI_DMA_FROMDEVICE);
+		rxb->page = page;
+		/* Get physical address of the RB */
+		rxb->page_dma = pci_map_page(priv->pci_dev, page, 0,
+				PAGE_SIZE << priv->hw_params.rx_page_order,
+				PCI_DMA_FROMDEVICE);
 		/* dma address must be no more than 36 bits */
-		BUG_ON(rxb->real_dma_addr & ~DMA_BIT_MASK(36));
+		BUG_ON(rxb->page_dma & ~DMA_BIT_MASK(36));
 		/* and also 256 byte aligned! */
-		rxb->aligned_dma_addr = ALIGN(rxb->real_dma_addr, 256);
-		skb_reserve(rxb->skb, rxb->aligned_dma_addr - rxb->real_dma_addr);
+		BUG_ON(rxb->page_dma & DMA_BIT_MASK(8));
 
 		spin_lock_irqsave(&rxq->lock, flags);
 
 		list_add_tail(&rxb->list, &rxq->rx_free);
 		rxq->free_count++;
-		priv->alloc_rxb_skb++;
+		priv->alloc_rxb_page++;
 
 		spin_unlock_irqrestore(&rxq->lock, flags);
 	}
@@ -336,12 +338,14 @@ void iwl_rx_queue_free(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
 {
 	int i;
 	for (i = 0; i < RX_QUEUE_SIZE + RX_FREE_BUFFERS; i++) {
-		if (rxq->pool[i].skb != NULL) {
-			pci_unmap_single(priv->pci_dev,
-					 rxq->pool[i].real_dma_addr,
-					 priv->hw_params.rx_buf_size + 256,
-					 PCI_DMA_FROMDEVICE);
-			dev_kfree_skb(rxq->pool[i].skb);
+		if (rxq->pool[i].page != NULL) {
+			pci_unmap_page(priv->pci_dev, rxq->pool[i].page_dma,
+				PAGE_SIZE << priv->hw_params.rx_page_order,
+				PCI_DMA_FROMDEVICE);
+			__free_pages(rxq->pool[i].page,
+				     priv->hw_params.rx_page_order);
+			rxq->pool[i].page = NULL;
+			priv->alloc_rxb_page--;
 		}
 	}
 
@@ -405,14 +409,14 @@ void iwl_rx_queue_reset(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
 	for (i = 0; i < RX_FREE_BUFFERS + RX_QUEUE_SIZE; i++) {
 		/* In the reset function, these buffers may have been allocated
 		 * to an SKB, so we need to unmap and free potential storage */
-		if (rxq->pool[i].skb != NULL) {
-			pci_unmap_single(priv->pci_dev,
-					 rxq->pool[i].real_dma_addr,
-					 priv->hw_params.rx_buf_size + 256,
-					 PCI_DMA_FROMDEVICE);
-			priv->alloc_rxb_skb--;
-			dev_kfree_skb(rxq->pool[i].skb);
-			rxq->pool[i].skb = NULL;
+		if (rxq->pool[i].page != NULL) {
+			pci_unmap_page(priv->pci_dev, rxq->pool[i].page_dma,
+				PAGE_SIZE << priv->hw_params.rx_page_order,
+				PCI_DMA_FROMDEVICE);
+			priv->alloc_rxb_page--;
+			__free_pages(rxq->pool[i].page,
+				     priv->hw_params.rx_page_order);
+			rxq->pool[i].page = NULL;
 		}
 		list_add_tail(&rxq->pool[i].list, &rxq->rx_used);
 	}
@@ -491,7 +495,7 @@ void iwl_rx_missed_beacon_notif(struct iwl_priv *priv,
 				struct iwl_rx_mem_buffer *rxb)
 
 {
-	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_missed_beacon_notif *missed_beacon;
 
 	missed_beacon = &pkt->u.missed_beacon;
@@ -592,7 +596,7 @@ void iwl_rx_statistics(struct iwl_priv *priv,
 			      struct iwl_rx_mem_buffer *rxb)
 {
 	int change;
-	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 
 	IWL_DEBUG_RX(priv, "Statistics notification received (%d vs %d).\n",
 		     (int)sizeof(priv->statistics),
@@ -919,6 +923,9 @@ static void iwl_pass_packet_to_mac80211(struct iwl_priv *priv,
 					struct iwl_rx_mem_buffer *rxb,
 					struct ieee80211_rx_status *stats)
 {
+	struct sk_buff *skb;
+	int ret = 0;
+
 	/* We only process data packets if the interface is open */
 	if (unlikely(!priv->is_open)) {
 		IWL_DEBUG_DROP_LIMIT(priv,
@@ -931,15 +938,38 @@ static void iwl_pass_packet_to_mac80211(struct iwl_priv *priv,
 	    iwl_set_decrypted_flag(priv, hdr, ampdu_status, stats))
 		return;
 
-	/* Resize SKB from mac header to end of packet */
-	skb_reserve(rxb->skb, (void *)hdr - (void *)rxb->skb->data);
-	skb_put(rxb->skb, len);
+	skb = alloc_skb(IWL_LINK_HDR_MAX, GFP_ATOMIC);
+	if (!skb) {
+		IWL_ERR(priv, "alloc_skb failed\n");
+		return;
+	}
+
+	skb_add_rx_frag(skb, 0, rxb->page, (void *)hdr - rxb_addr(rxb), len);
+
+	/* mac80211 currently doesn't support paged SKB. Convert it to
+	 * linear SKB for management frame and data frame requires
+	 * software decryption or software defragementation. */
+	if (ieee80211_is_mgmt(hdr->frame_control) ||
+	    ieee80211_has_protected(hdr->frame_control) ||
+	    ieee80211_has_morefrags(hdr->frame_control) ||
+	    le16_to_cpu(hdr->seq_ctrl) & IEEE80211_SCTL_FRAG)
+		ret = skb_linearize(skb);
+	else
+		ret = __pskb_pull_tail(skb, min_t(u16, IWL_LINK_HDR_MAX, len)) ?
+			 0 : -ENOMEM;
+
+	if (ret) {
+		kfree_skb(skb);
+		goto out;
+	}
 
 	iwl_update_stats(priv, false, hdr->frame_control, len);
-	memcpy(IEEE80211_SKB_RXCB(rxb->skb), stats, sizeof(*stats));
-	ieee80211_rx_irqsafe(priv->hw, rxb->skb);
-	priv->alloc_rxb_skb--;
-	rxb->skb = NULL;
+	memcpy(IEEE80211_SKB_RXCB(skb), stats, sizeof(*stats));
+
+	ieee80211_rx(priv->hw, skb);
+ out:
+	priv->alloc_rxb_page--;
+	rxb->page = NULL;
 }
 
 /* This is necessary only for a number of statistics, see the caller. */
@@ -967,7 +997,7 @@ void iwl_rx_reply_rx(struct iwl_priv *priv,
 {
 	struct ieee80211_hdr *header;
 	struct ieee80211_rx_status rx_status;
-	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_rx_phy_res *phy_res;
 	__le32 rx_pkt_status;
 	struct iwl4965_rx_mpdu_res_start *amsdu;
@@ -1128,7 +1158,7 @@ EXPORT_SYMBOL(iwl_rx_reply_rx);
 void iwl_rx_reply_rx_phy(struct iwl_priv *priv,
 				    struct iwl_rx_mem_buffer *rxb)
 {
-	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	priv->last_phy_res[0] = 1;
 	memcpy(&priv->last_phy_res[1], &(pkt->u.raw[0]),
 	       sizeof(struct iwl_rx_phy_res));
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 41f9a06..4fca65a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -111,7 +111,7 @@ EXPORT_SYMBOL(iwl_scan_cancel_timeout);
 static int iwl_send_scan_abort(struct iwl_priv *priv)
 {
 	int ret = 0;
-	struct iwl_rx_packet *res;
+	struct iwl_rx_packet *pkt;
 	struct iwl_host_cmd cmd = {
 		.id = REPLY_SCAN_ABORT_CMD,
 		.flags = CMD_WANT_SKB,
@@ -131,21 +131,21 @@ static int iwl_send_scan_abort(struct iwl_priv *priv)
 		return ret;
 	}
 
-	res = (struct iwl_rx_packet *)cmd.reply_skb->data;
-	if (res->u.status != CAN_ABORT_STATUS) {
+	pkt = (struct iwl_rx_packet *)cmd.reply_page;
+	if (pkt->u.status != CAN_ABORT_STATUS) {
 		/* The scan abort will return 1 for success or
 		 * 2 for "failure".  A failure condition can be
 		 * due to simply not being in an active scan which
 		 * can occur if we send the scan abort before we
 		 * the microcode has notified us that a scan is
 		 * completed. */
-		IWL_DEBUG_INFO(priv, "SCAN_ABORT returned %d.\n", res->u.status);
+		IWL_DEBUG_INFO(priv, "SCAN_ABORT returned %d.\n", pkt->u.status);
 		clear_bit(STATUS_SCAN_ABORTING, &priv->status);
 		clear_bit(STATUS_SCAN_HW, &priv->status);
 	}
 
-	priv->alloc_rxb_skb--;
-	dev_kfree_skb_any(cmd.reply_skb);
+	priv->alloc_rxb_page--;
+	free_pages(cmd.reply_page, priv->hw_params.rx_page_order);
 
 	return ret;
 }
@@ -155,7 +155,7 @@ static void iwl_rx_reply_scan(struct iwl_priv *priv,
 			      struct iwl_rx_mem_buffer *rxb)
 {
 #ifdef CONFIG_IWLWIFI_DEBUG
-	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_scanreq_notification *notif =
 	    (struct iwl_scanreq_notification *)pkt->u.raw;
 
@@ -167,7 +167,7 @@ static void iwl_rx_reply_scan(struct iwl_priv *priv,
 static void iwl_rx_scan_start_notif(struct iwl_priv *priv,
 				    struct iwl_rx_mem_buffer *rxb)
 {
-	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_scanstart_notification *notif =
 	    (struct iwl_scanstart_notification *)pkt->u.raw;
 	priv->scan_start_tsf = le32_to_cpu(notif->tsf_low);
@@ -186,7 +186,7 @@ static void iwl_rx_scan_results_notif(struct iwl_priv *priv,
 				      struct iwl_rx_mem_buffer *rxb)
 {
 #ifdef CONFIG_IWLWIFI_DEBUG
-	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_scanresults_notification *notif =
 	    (struct iwl_scanresults_notification *)pkt->u.raw;
 
@@ -213,7 +213,7 @@ static void iwl_rx_scan_complete_notif(struct iwl_priv *priv,
 				       struct iwl_rx_mem_buffer *rxb)
 {
 #ifdef CONFIG_IWLWIFI_DEBUG
-	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_scancomplete_notification *scan_notif = (void *)pkt->u.raw;
 
 	IWL_DEBUG_SCAN(priv, "Scan complete: %d channels (TSF 0x%08X:%08X) - %d\n",
diff --git a/drivers/net/wireless/iwlwifi/iwl-spectrum.c b/drivers/net/wireless/iwlwifi/iwl-spectrum.c
index 022bcf1..1ea5cd3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-spectrum.c
+++ b/drivers/net/wireless/iwlwifi/iwl-spectrum.c
@@ -177,7 +177,7 @@ static int iwl_get_measurement(struct iwl_priv *priv,
 static void iwl_rx_spectrum_measure_notif(struct iwl_priv *priv,
 					  struct iwl_rx_mem_buffer *rxb)
 {
-	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_spectrum_notification *report = &(pkt->u.spectrum_notif);
 
 	if (!report->state) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index c6633fe..dc74c16 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -99,32 +99,25 @@ static void iwl_sta_ucode_activate(struct iwl_priv *priv, u8 sta_id)
 
 static void iwl_add_sta_callback(struct iwl_priv *priv,
 				 struct iwl_device_cmd *cmd,
-				 struct sk_buff *skb)
+				 struct iwl_rx_packet *pkt)
 {
-	struct iwl_rx_packet *res = NULL;
 	struct iwl_addsta_cmd *addsta =
 		(struct iwl_addsta_cmd *)cmd->cmd.payload;
 	u8 sta_id = addsta->sta.sta_id;
 
-	if (!skb) {
-		IWL_ERR(priv, "Error: Response NULL in REPLY_ADD_STA.\n");
-		return;
-	}
-
-	res = (struct iwl_rx_packet *)skb->data;
-	if (res->hdr.flags & IWL_CMD_FAILED_MSK) {
+	if (pkt->hdr.flags & IWL_CMD_FAILED_MSK) {
 		IWL_ERR(priv, "Bad return from REPLY_ADD_STA (0x%08X)\n",
-			  res->hdr.flags);
+			  pkt->hdr.flags);
 		return;
 	}
 
-	switch (res->u.add_sta.status) {
+	switch (pkt->u.add_sta.status) {
 	case ADD_STA_SUCCESS_MSK:
 		iwl_sta_ucode_activate(priv, sta_id);
 		 /* fall through */
 	default:
 		IWL_DEBUG_HC(priv, "Received REPLY_ADD_STA:(0x%08X)\n",
-			     res->u.add_sta.status);
+			     pkt->u.add_sta.status);
 		break;
 	}
 }
@@ -132,7 +125,7 @@ static void iwl_add_sta_callback(struct iwl_priv *priv,
 int iwl_send_add_sta(struct iwl_priv *priv,
 		     struct iwl_addsta_cmd *sta, u8 flags)
 {
-	struct iwl_rx_packet *res = NULL;
+	struct iwl_rx_packet *pkt = NULL;
 	int ret = 0;
 	u8 data[sizeof(*sta)];
 	struct iwl_host_cmd cmd = {
@@ -152,15 +145,15 @@ int iwl_send_add_sta(struct iwl_priv *priv,
 	if (ret || (flags & CMD_ASYNC))
 		return ret;
 
-	res = (struct iwl_rx_packet *)cmd.reply_skb->data;
-	if (res->hdr.flags & IWL_CMD_FAILED_MSK) {
+	pkt = (struct iwl_rx_packet *)cmd.reply_page;
+	if (pkt->hdr.flags & IWL_CMD_FAILED_MSK) {
 		IWL_ERR(priv, "Bad return from REPLY_ADD_STA (0x%08X)\n",
-			  res->hdr.flags);
+			  pkt->hdr.flags);
 		ret = -EIO;
 	}
 
 	if (ret == 0) {
-		switch (res->u.add_sta.status) {
+		switch (pkt->u.add_sta.status) {
 		case ADD_STA_SUCCESS_MSK:
 			iwl_sta_ucode_activate(priv, sta->sta.sta_id);
 			IWL_DEBUG_INFO(priv, "REPLY_ADD_STA PASSED\n");
@@ -172,8 +165,8 @@ int iwl_send_add_sta(struct iwl_priv *priv,
 		}
 	}
 
-	priv->alloc_rxb_skb--;
-	dev_kfree_skb_any(cmd.reply_skb);
+	priv->alloc_rxb_page--;
+	free_pages(cmd.reply_page, priv->hw_params.rx_page_order);
 
 	return ret;
 }
@@ -324,26 +317,19 @@ static void iwl_sta_ucode_deactivate(struct iwl_priv *priv, const char *addr)
 
 static void iwl_remove_sta_callback(struct iwl_priv *priv,
 				    struct iwl_device_cmd *cmd,
-				    struct sk_buff *skb)
+				    struct iwl_rx_packet *pkt)
 {
-	struct iwl_rx_packet *res = NULL;
 	struct iwl_rem_sta_cmd *rm_sta =
-		 (struct iwl_rem_sta_cmd *)cmd->cmd.payload;
+			(struct iwl_rem_sta_cmd *)cmd->cmd.payload;
 	const char *addr = rm_sta->addr;
 
-	if (!skb) {
-		IWL_ERR(priv, "Error: Response NULL in REPLY_REMOVE_STA.\n");
-		return;
-	}
-
-	res = (struct iwl_rx_packet *)skb->data;
-	if (res->hdr.flags & IWL_CMD_FAILED_MSK) {
+	if (pkt->hdr.flags & IWL_CMD_FAILED_MSK) {
 		IWL_ERR(priv, "Bad return from REPLY_REMOVE_STA (0x%08X)\n",
-		res->hdr.flags);
+		pkt->hdr.flags);
 		return;
 	}
 
-	switch (res->u.rem_sta.status) {
+	switch (pkt->u.rem_sta.status) {
 	case REM_STA_SUCCESS_MSK:
 		iwl_sta_ucode_deactivate(priv, addr);
 		break;
@@ -356,7 +342,7 @@ static void iwl_remove_sta_callback(struct iwl_priv *priv,
 static int iwl_send_remove_station(struct iwl_priv *priv, const u8 *addr,
 				   u8 flags)
 {
-	struct iwl_rx_packet *res = NULL;
+	struct iwl_rx_packet *pkt;
 	int ret;
 
 	struct iwl_rem_sta_cmd rm_sta_cmd;
@@ -381,15 +367,15 @@ static int iwl_send_remove_station(struct iwl_priv *priv, const u8 *addr,
 	if (ret || (flags & CMD_ASYNC))
 		return ret;
 
-	res = (struct iwl_rx_packet *)cmd.reply_skb->data;
-	if (res->hdr.flags & IWL_CMD_FAILED_MSK) {
+	pkt = (struct iwl_rx_packet *)cmd.reply_page;
+	if (pkt->hdr.flags & IWL_CMD_FAILED_MSK) {
 		IWL_ERR(priv, "Bad return from REPLY_REMOVE_STA (0x%08X)\n",
-			  res->hdr.flags);
+			  pkt->hdr.flags);
 		ret = -EIO;
 	}
 
 	if (!ret) {
-		switch (res->u.rem_sta.status) {
+		switch (pkt->u.rem_sta.status) {
 		case REM_STA_SUCCESS_MSK:
 			iwl_sta_ucode_deactivate(priv, addr);
 			IWL_DEBUG_ASSOC(priv, "REPLY_REMOVE_STA PASSED\n");
@@ -401,8 +387,8 @@ static int iwl_send_remove_station(struct iwl_priv *priv, const u8 *addr,
 		}
 	}
 
-	priv->alloc_rxb_skb--;
-	dev_kfree_skb_any(cmd.reply_skb);
+	priv->alloc_rxb_page--;
+	free_pages(cmd.reply_page, priv->hw_params.rx_page_order);
 
 	return ret;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index d0bd7cd..5c43d7c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -1153,7 +1153,7 @@ static void iwl_hcmd_queue_reclaim(struct iwl_priv *priv, int txq_id,
  */
 void iwl_tx_cmd_complete(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 {
-	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	u16 sequence = le16_to_cpu(pkt->hdr.sequence);
 	int txq_id = SEQ_TO_QUEUE(sequence);
 	int index = SEQ_TO_INDEX(sequence);
@@ -1180,10 +1180,10 @@ void iwl_tx_cmd_complete(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 
 	/* Input error checking is done when commands are added to queue. */
 	if (meta->flags & CMD_WANT_SKB) {
-		meta->source->reply_skb = rxb->skb;
-		rxb->skb = NULL;
+		meta->source->reply_page = (unsigned long)rxb_addr(rxb);
+		rxb->page = NULL;
 	} else if (meta->callback)
-		meta->callback(priv, cmd, rxb->skb);
+		meta->callback(priv, cmd, pkt);
 
 	iwl_hcmd_queue_reclaim(priv, txq_id, index, cmd_index);
 
@@ -1442,7 +1442,7 @@ static int iwl_tx_status_reply_compressed_ba(struct iwl_priv *priv,
 void iwl_rx_reply_compressed_ba(struct iwl_priv *priv,
 					   struct iwl_rx_mem_buffer *rxb)
 {
-	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_compressed_ba_resp *ba_resp = &pkt->u.compressed_ba;
 	struct iwl_tx_queue *txq = NULL;
 	struct iwl_ht_agg *agg;
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 515f29b..5977a57 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -745,7 +745,7 @@ static int iwl3945_get_measurement(struct iwl_priv *priv,
 			       u8 type)
 {
 	struct iwl_spectrum_cmd spectrum;
-	struct iwl_rx_packet *res;
+	struct iwl_rx_packet *pkt;
 	struct iwl_host_cmd cmd = {
 		.id = REPLY_SPECTRUM_MEASUREMENT_CMD,
 		.data = (void *)&spectrum,
@@ -790,18 +790,18 @@ static int iwl3945_get_measurement(struct iwl_priv *priv,
 	if (rc)
 		return rc;
 
-	res = (struct iwl_rx_packet *)cmd.reply_skb->data;
-	if (res->hdr.flags & IWL_CMD_FAILED_MSK) {
+	pkt = (struct iwl_rx_packet *)cmd.reply_page;
+	if (pkt->hdr.flags & IWL_CMD_FAILED_MSK) {
 		IWL_ERR(priv, "Bad return from REPLY_RX_ON_ASSOC command\n");
 		rc = -EIO;
 	}
 
-	spectrum_resp_status = le16_to_cpu(res->u.spectrum.status);
+	spectrum_resp_status = le16_to_cpu(pkt->u.spectrum.status);
 	switch (spectrum_resp_status) {
 	case 0:		/* Command will be handled */
-		if (res->u.spectrum.id != 0xff) {
+		if (pkt->u.spectrum.id != 0xff) {
 			IWL_DEBUG_INFO(priv, "Replaced existing measurement: %d\n",
-						res->u.spectrum.id);
+						pkt->u.spectrum.id);
 			priv->measurement_status &= ~MEASUREMENT_READY;
 		}
 		priv->measurement_status |= MEASUREMENT_ACTIVE;
@@ -813,7 +813,7 @@ static int iwl3945_get_measurement(struct iwl_priv *priv,
 		break;
 	}
 
-	dev_kfree_skb_any(cmd.reply_skb);
+	free_pages(cmd.reply_page, priv->hw_params.rx_page_order);
 
 	return rc;
 }
@@ -822,7 +822,7 @@ static int iwl3945_get_measurement(struct iwl_priv *priv,
 static void iwl3945_rx_reply_alive(struct iwl_priv *priv,
 			       struct iwl_rx_mem_buffer *rxb)
 {
-	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_alive_resp *palive;
 	struct delayed_work *pwork;
 
@@ -859,7 +859,7 @@ static void iwl3945_rx_reply_add_sta(struct iwl_priv *priv,
 				 struct iwl_rx_mem_buffer *rxb)
 {
 #ifdef CONFIG_IWLWIFI_DEBUG
-	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 #endif
 
 	IWL_DEBUG_RX(priv, "Received REPLY_ADD_STA: 0x%02X\n", pkt->u.status);
@@ -895,7 +895,7 @@ static void iwl3945_rx_beacon_notif(struct iwl_priv *priv,
 				struct iwl_rx_mem_buffer *rxb)
 {
 #ifdef CONFIG_IWLWIFI_DEBUG
-	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl3945_beacon_notif *beacon = &(pkt->u.beacon_status);
 	u8 rate = beacon->beacon_notify_hdr.rate;
 
@@ -918,7 +918,7 @@ static void iwl3945_rx_beacon_notif(struct iwl_priv *priv,
 static void iwl3945_rx_card_state_notif(struct iwl_priv *priv,
 				    struct iwl_rx_mem_buffer *rxb)
 {
-	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	u32 flags = le32_to_cpu(pkt->u.card_state_notif.flags);
 	unsigned long status = priv->status;
 
@@ -1082,7 +1082,7 @@ static int iwl3945_rx_queue_restock(struct iwl_priv *priv)
 		list_del(element);
 
 		/* Point to Rx buffer via next RBD in circular buffer */
-		rxq->bd[rxq->write] = iwl3945_dma_addr2rbd_ptr(priv, rxb->real_dma_addr);
+		rxq->bd[rxq->write] = iwl3945_dma_addr2rbd_ptr(priv, rxb->page_dma);
 		rxq->queue[rxq->write] = rxb;
 		rxq->write = (rxq->write + 1) & RX_QUEUE_MASK;
 		rxq->free_count--;
@@ -1122,7 +1122,7 @@ static void iwl3945_rx_allocate(struct iwl_priv *priv, gfp_t priority)
 	struct iwl_rx_queue *rxq = &priv->rxq;
 	struct list_head *element;
 	struct iwl_rx_mem_buffer *rxb;
-	struct sk_buff *skb;
+	struct page *page;
 	unsigned long flags;
 
 	while (1) {
@@ -1136,9 +1136,13 @@ static void iwl3945_rx_allocate(struct iwl_priv *priv, gfp_t priority)
 
 		if (rxq->free_count > RX_LOW_WATERMARK)
 			priority |= __GFP_NOWARN;
+
+		if (priv->hw_params.rx_page_order > 0)
+			priority |= __GFP_COMP;
+
 		/* Alloc a new receive buffer */
-		skb = alloc_skb(priv->hw_params.rx_buf_size, priority);
-		if (!skb) {
+		page = alloc_pages(priority, priv->hw_params.rx_page_order);
+		if (!page) {
 			if (net_ratelimit())
 				IWL_DEBUG_INFO(priv, "Failed to allocate SKB buffer.\n");
 			if ((rxq->free_count <= RX_LOW_WATERMARK) &&
@@ -1155,7 +1159,7 @@ static void iwl3945_rx_allocate(struct iwl_priv *priv, gfp_t priority)
 		spin_lock_irqsave(&rxq->lock, flags);
 		if (list_empty(&rxq->rx_used)) {
 			spin_unlock_irqrestore(&rxq->lock, flags);
-			dev_kfree_skb_any(skb);
+			__free_pages(page, priv->hw_params.rx_page_order);
 			return;
 		}
 		element = rxq->rx_used.next;
@@ -1163,26 +1167,18 @@ static void iwl3945_rx_allocate(struct iwl_priv *priv, gfp_t priority)
 		list_del(element);
 		spin_unlock_irqrestore(&rxq->lock, flags);
 
-		rxb->skb = skb;
-
-		/* If radiotap head is required, reserve some headroom here.
-		 * The physical head count is a variable rx_stats->phy_count.
-		 * We reserve 4 bytes here. Plus these extra bytes, the
-		 * headroom of the physical head should be enough for the
-		 * radiotap head that iwl3945 supported. See iwl3945_rt.
-		 */
-		skb_reserve(rxb->skb, 4);
-
+		rxb->page = page;
 		/* Get physical address of RB/SKB */
-		rxb->real_dma_addr = pci_map_single(priv->pci_dev,
-						rxb->skb->data,
-						priv->hw_params.rx_buf_size,
-						PCI_DMA_FROMDEVICE);
+		rxb->page_dma = pci_map_page(priv->pci_dev, page, 0,
+				PAGE_SIZE << priv->hw_params.rx_page_order,
+				PCI_DMA_FROMDEVICE);
 
 		spin_lock_irqsave(&rxq->lock, flags);
+
 		list_add_tail(&rxb->list, &rxq->rx_free);
-		priv->alloc_rxb_skb++;
 		rxq->free_count++;
+		priv->alloc_rxb_page++;
+
 		spin_unlock_irqrestore(&rxq->lock, flags);
 	}
 }
@@ -1198,14 +1194,14 @@ void iwl3945_rx_queue_reset(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
 	for (i = 0; i < RX_FREE_BUFFERS + RX_QUEUE_SIZE; i++) {
 		/* In the reset function, these buffers may have been allocated
 		 * to an SKB, so we need to unmap and free potential storage */
-		if (rxq->pool[i].skb != NULL) {
-			pci_unmap_single(priv->pci_dev,
-					 rxq->pool[i].real_dma_addr,
-					 priv->hw_params.rx_buf_size,
-					 PCI_DMA_FROMDEVICE);
-			priv->alloc_rxb_skb--;
-			dev_kfree_skb(rxq->pool[i].skb);
-			rxq->pool[i].skb = NULL;
+		if (rxq->pool[i].page != NULL) {
+			pci_unmap_page(priv->pci_dev, rxq->pool[i].page_dma,
+				PAGE_SIZE << priv->hw_params.rx_page_order,
+				PCI_DMA_FROMDEVICE);
+			priv->alloc_rxb_page--;
+			__free_pages(rxq->pool[i].page,
+				     priv->hw_params.rx_page_order);
+			rxq->pool[i].page = NULL;
 		}
 		list_add_tail(&rxq->pool[i].list, &rxq->rx_used);
 	}
@@ -1213,8 +1209,8 @@ void iwl3945_rx_queue_reset(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
 	/* Set us so that we have processed and used all buffers, but have
 	 * not restocked the Rx queue with fresh buffers */
 	rxq->read = rxq->write = 0;
-	rxq->free_count = 0;
 	rxq->write_actual = 0;
+	rxq->free_count = 0;
 	spin_unlock_irqrestore(&rxq->lock, flags);
 }
 
@@ -1247,12 +1243,14 @@ static void iwl3945_rx_queue_free(struct iwl_priv *priv, struct iwl_rx_queue *rx
 {
 	int i;
 	for (i = 0; i < RX_QUEUE_SIZE + RX_FREE_BUFFERS; i++) {
-		if (rxq->pool[i].skb != NULL) {
-			pci_unmap_single(priv->pci_dev,
-					 rxq->pool[i].real_dma_addr,
-					 priv->hw_params.rx_buf_size,
-					 PCI_DMA_FROMDEVICE);
-			dev_kfree_skb(rxq->pool[i].skb);
+		if (rxq->pool[i].page != NULL) {
+			pci_unmap_page(priv->pci_dev, rxq->pool[i].page_dma,
+				PAGE_SIZE << priv->hw_params.rx_page_order,
+				PCI_DMA_FROMDEVICE);
+			__free_pages(rxq->pool[i].page,
+				     priv->hw_params.rx_page_order);
+			rxq->pool[i].page = NULL;
+			priv->alloc_rxb_page--;
 		}
 	}
 
@@ -1388,10 +1386,10 @@ static void iwl3945_rx_handle(struct iwl_priv *priv)
 
 		rxq->queue[i] = NULL;
 
-		pci_unmap_single(priv->pci_dev, rxb->real_dma_addr,
-				priv->hw_params.rx_buf_size,
-				PCI_DMA_FROMDEVICE);
-		pkt = (struct iwl_rx_packet *)rxb->skb->data;
+		pci_unmap_page(priv->pci_dev, rxb->page_dma,
+			       PAGE_SIZE << priv->hw_params.rx_page_order,
+			       PCI_DMA_FROMDEVICE);
+		pkt = rxb_addr(rxb);
 
 		trace_iwlwifi_dev_rx(priv, pkt,
 			le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK);
@@ -1416,16 +1414,17 @@ static void iwl3945_rx_handle(struct iwl_priv *priv)
 			priv->isr_stats.rx_handlers[pkt->hdr.cmd]++;
 		} else {
 			/* No handling needed */
-			IWL_DEBUG_RX(priv, "r %d i %d No handler needed for %s, 0x%02x\n",
+			IWL_DEBUG_RX(priv,
+				"r %d i %d No handler needed for %s, 0x%02x\n",
 				r, i, get_cmd_string(pkt->hdr.cmd),
 				pkt->hdr.cmd);
 		}
 
 		if (reclaim) {
-			/* Invoke any callbacks, transfer the skb to caller, and
-			 * fire off the (possibly) blocking iwl_send_cmd()
+			/* Invoke any callbacks, transfer the buffer to caller,
+			 * and fire off the (possibly) blocking iwl_send_cmd()
 			 * as we reclaim the driver command queue */
-			if (rxb && rxb->skb)
+			if (rxb && rxb->page)
 				iwl_tx_cmd_complete(priv, rxb);
 			else
 				IWL_WARN(priv, "Claim null rxb?\n");
@@ -1434,10 +1433,10 @@ static void iwl3945_rx_handle(struct iwl_priv *priv)
 		/* For now we just don't re-use anything.  We can tweak this
 		 * later to try and re-use notification packets and SKBs that
 		 * fail to Rx correctly */
-		if (rxb->skb != NULL) {
-			priv->alloc_rxb_skb--;
-			dev_kfree_skb_any(rxb->skb);
-			rxb->skb = NULL;
+		if (rxb->page != NULL) {
+			priv->alloc_rxb_page--;
+			__free_pages(rxb->page, priv->hw_params.rx_page_order);
+			rxb->page = NULL;
 		}
 
 		spin_lock_irqsave(&rxq->lock, flags);
@@ -1678,6 +1677,8 @@ static void iwl3945_irq_tasklet(struct iwl_priv *priv)
 	}
 #endif
 
+	spin_unlock_irqrestore(&priv->lock, flags);
+
 	/* Since CSR_INT and CSR_FH_INT_STATUS reads and clears are not
 	 * atomic, make sure that inta covers all the interrupts that
 	 * we've discovered, even if FH interrupt came in just after
@@ -1699,8 +1700,6 @@ static void iwl3945_irq_tasklet(struct iwl_priv *priv)
 
 		handled |= CSR_INT_BIT_HW_ERR;
 
-		spin_unlock_irqrestore(&priv->lock, flags);
-
 		return;
 	}
 
@@ -1792,7 +1791,6 @@ static void iwl3945_irq_tasklet(struct iwl_priv *priv)
 			"flags 0x%08lx\n", inta, inta_mask, inta_fh, flags);
 	}
 #endif
-	spin_unlock_irqrestore(&priv->lock, flags);
 }
 
 static int iwl3945_get_channels_for_scan(struct iwl_priv *priv,
-- 
1.6.0.4

