Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:11459 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030187Ab2CEUiJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Mar 2012 15:38:09 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH RESEND 22/33] iwlwifi: refactor PCI-E RX path
Date: Mon,  5 Mar 2012 11:24:40 -0800
Message-Id: <1330975491-19680-23-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120305_213900_120016_A8E80BD2)
In-Reply-To: <1330975491-19680-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330975491-19680-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Just make the code easier to read with less indentation.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c |  216 +++++++++++-----------
 1 files changed, 110 insertions(+), 106 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
index 68e89be..bf560e9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
@@ -358,6 +358,113 @@ void iwl_bg_rx_replenish(struct work_struct *data)
 	iwlagn_rx_replenish(trans_pcie->trans);
 }
 
+static void iwl_rx_handle_rxbuf(struct iwl_trans *trans,
+				struct iwl_rx_mem_buffer *rxb)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct iwl_rx_queue *rxq = &trans_pcie->rxq;
+	struct iwl_tx_queue *txq = &trans_pcie->txq[trans->shrd->cmd_queue];
+	struct iwl_device_cmd *cmd;
+	unsigned long flags;
+	int len, err;
+	u16 sequence;
+	struct iwl_rx_cmd_buffer rxcb;
+	struct iwl_rx_packet *pkt;
+	bool reclaim;
+	int index, cmd_index;
+
+	if (WARN_ON(!rxb))
+		return;
+
+	dma_unmap_page(trans->dev, rxb->page_dma,
+		       PAGE_SIZE << hw_params(trans).rx_page_order,
+		       DMA_FROM_DEVICE);
+
+	rxcb._page = rxb->page;
+	pkt = rxb_addr(&rxcb);
+
+	IWL_DEBUG_RX(trans, "%s, 0x%02x\n",
+		     get_cmd_string(pkt->hdr.cmd), pkt->hdr.cmd);
+
+
+	len = le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK;
+	len += sizeof(u32); /* account for status word */
+	trace_iwlwifi_dev_rx(priv(trans), pkt, len);
+
+	/* Reclaim a command buffer only if this packet is a response
+	 *   to a (driver-originated) command.
+	 * If the packet (e.g. Rx frame) originated from uCode,
+	 *   there is no command buffer to reclaim.
+	 * Ucode should set SEQ_RX_FRAME bit if ucode-originated,
+	 *   but apparently a few don't get set; catch them here. */
+	reclaim = !(pkt->hdr.sequence & SEQ_RX_FRAME) &&
+		  (pkt->hdr.cmd != REPLY_RX_PHY_CMD) &&
+		  (pkt->hdr.cmd != REPLY_RX) &&
+		  (pkt->hdr.cmd != REPLY_RX_MPDU_CMD) &&
+		  (pkt->hdr.cmd != REPLY_COMPRESSED_BA) &&
+		  (pkt->hdr.cmd != STATISTICS_NOTIFICATION) &&
+		  (pkt->hdr.cmd != REPLY_TX);
+
+	sequence = le16_to_cpu(pkt->hdr.sequence);
+	index = SEQ_TO_INDEX(sequence);
+	cmd_index = get_cmd_index(&txq->q, index);
+
+	if (reclaim)
+		cmd = txq->cmd[cmd_index];
+	else
+		cmd = NULL;
+
+	/* warn if this is cmd response / notification and the uCode
+	 * didn't set the SEQ_RX_FRAME for a frame that is
+	 * uCode-originated
+	 * If you saw this code after the second half of 2012, then
+	 * please remove it
+	 */
+	WARN(pkt->hdr.cmd != REPLY_TX && reclaim == false &&
+	     (!(pkt->hdr.sequence & SEQ_RX_FRAME)),
+	     "reclaim is false, SEQ_RX_FRAME unset: %s\n",
+	     get_cmd_string(pkt->hdr.cmd));
+
+	err = iwl_op_mode_rx(trans->op_mode, &rxcb, cmd);
+
+	/*
+	 * XXX: After here, we should always check rxcb._page
+	 * against NULL before touching it or its virtual
+	 * memory (pkt). Because some rx_handler might have
+	 * already taken or freed the pages.
+	 */
+
+	if (reclaim) {
+		/* Invoke any callbacks, transfer the buffer to caller,
+		 * and fire off the (possibly) blocking
+		 * iwl_trans_send_cmd()
+		 * as we reclaim the driver command queue */
+		if (rxcb._page)
+			iwl_tx_cmd_complete(trans, &rxcb, err);
+		else
+			IWL_WARN(trans, "Claim null rxb?\n");
+	}
+
+	/* page was stolen from us */
+	if (rxcb._page == NULL)
+		rxb->page = NULL;
+
+	/* Reuse the page if possible. For notification packets and
+	 * SKBs that fail to Rx correctly, add them back into the
+	 * rx_free list for reuse later. */
+	spin_lock_irqsave(&rxq->lock, flags);
+	if (rxb->page != NULL) {
+		rxb->page_dma =
+			dma_map_page(trans->dev, rxb->page, 0,
+				PAGE_SIZE << hw_params(trans).rx_page_order,
+				DMA_FROM_DEVICE);
+		list_add_tail(&rxb->list, &rxq->rx_free);
+		rxq->free_count++;
+	} else
+		list_add_tail(&rxb->list, &rxq->rx_used);
+	spin_unlock_irqrestore(&rxq->lock, flags);
+}
+
 /**
  * iwl_rx_handle - Main entry function for receiving responses from uCode
  *
@@ -367,18 +474,12 @@ void iwl_bg_rx_replenish(struct work_struct *data)
  */
 static void iwl_rx_handle(struct iwl_trans *trans)
 {
-	struct iwl_trans_pcie *trans_pcie =
-		IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_rx_queue *rxq = &trans_pcie->rxq;
-	struct iwl_tx_queue *txq = &trans_pcie->txq[trans->shrd->cmd_queue];
-	struct iwl_device_cmd *cmd;
 	u32 r, i;
-	int reclaim;
-	unsigned long flags;
 	u8 fill_rx = 0;
 	u32 count = 8;
 	int total_empty;
-	int index, cmd_index;
 
 	/* uCode's read index (stored in shared DRAM) indicates the last Rx
 	 * buffer that the driver may process (last buffer filled by ucode). */
@@ -398,111 +499,14 @@ static void iwl_rx_handle(struct iwl_trans *trans)
 		fill_rx = 1;
 
 	while (i != r) {
-		int len, err;
-		u16 sequence;
 		struct iwl_rx_mem_buffer *rxb;
-		struct iwl_rx_cmd_buffer rxcb;
-		struct iwl_rx_packet *pkt;
 
 		rxb = rxq->queue[i];
-
-		/* If an RXB doesn't have a Rx queue slot associated with it,
-		 * then a bug has been introduced in the queue refilling
-		 * routines -- catch it here */
-		if (WARN_ON(rxb == NULL)) {
-			i = (i + 1) & RX_QUEUE_MASK;
-			continue;
-		}
-
 		rxq->queue[i] = NULL;
 
-		dma_unmap_page(trans->dev, rxb->page_dma,
-			       PAGE_SIZE << hw_params(trans).rx_page_order,
-			       DMA_FROM_DEVICE);
-
-		rxcb._page = rxb->page;
-		pkt = rxb_addr(&rxcb);
-
-		IWL_DEBUG_RX(trans, "r = %d, i = %d, %s, 0x%02x\n", r,
-			i, get_cmd_string(pkt->hdr.cmd), pkt->hdr.cmd);
-
-		len = le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK;
-		len += sizeof(u32); /* account for status word */
-		trace_iwlwifi_dev_rx(priv(trans), pkt, len);
-
-		/* Reclaim a command buffer only if this packet is a response
-		 *   to a (driver-originated) command.
-		 * If the packet (e.g. Rx frame) originated from uCode,
-		 *   there is no command buffer to reclaim.
-		 * Ucode should set SEQ_RX_FRAME bit if ucode-originated,
-		 *   but apparently a few don't get set; catch them here. */
-		reclaim = !(pkt->hdr.sequence & SEQ_RX_FRAME) &&
-			(pkt->hdr.cmd != REPLY_RX_PHY_CMD) &&
-			(pkt->hdr.cmd != REPLY_RX) &&
-			(pkt->hdr.cmd != REPLY_RX_MPDU_CMD) &&
-			(pkt->hdr.cmd != REPLY_COMPRESSED_BA) &&
-			(pkt->hdr.cmd != STATISTICS_NOTIFICATION) &&
-			(pkt->hdr.cmd != REPLY_TX);
-
-		sequence = le16_to_cpu(pkt->hdr.sequence);
-		index = SEQ_TO_INDEX(sequence);
-		cmd_index = get_cmd_index(&txq->q, index);
-
-		if (reclaim)
-			cmd = txq->cmd[cmd_index];
-		else
-			cmd = NULL;
-
-		/* warn if this is cmd response / notification and the uCode
-		 * didn't set the SEQ_RX_FRAME for a frame that is
-		 * uCode-originated
-		 * If you saw this code after the second half of 2012, then
-		 * please remove it
-		 */
-		WARN(pkt->hdr.cmd != REPLY_TX && reclaim == false &&
-		     (!(pkt->hdr.sequence & SEQ_RX_FRAME)),
-		     "reclaim is false, SEQ_RX_FRAME unset: %s\n",
-		     get_cmd_string(pkt->hdr.cmd));
-
-		err = iwl_op_mode_rx(trans->op_mode, &rxcb, cmd);
-
-		/*
-		 * XXX: After here, we should always check rxcb._page
-		 * against NULL before touching it or its virtual
-		 * memory (pkt). Because some rx_handler might have
-		 * already taken or freed the pages.
-		 */
-
-		if (reclaim) {
-			/* Invoke any callbacks, transfer the buffer to caller,
-			 * and fire off the (possibly) blocking
-			 * iwl_trans_send_cmd()
-			 * as we reclaim the driver command queue */
-			if (rxcb._page)
-				iwl_tx_cmd_complete(trans, &rxcb, err);
-			else
-				IWL_WARN(trans, "Claim null rxb?\n");
-		}
-
-		/* page was stolen from us */
-		if (rxcb._page == NULL)
-			rxb->page = NULL;
+		IWL_DEBUG_RX(trans, "rxbuf: r = %d, i = %d (%p)\n", rxb);
 
-		/* Reuse the page if possible. For notification packets and
-		 * SKBs that fail to Rx correctly, add them back into the
-		 * rx_free list for reuse later. */
-		spin_lock_irqsave(&rxq->lock, flags);
-		if (rxb->page != NULL) {
-			rxb->page_dma = dma_map_page(trans->dev, rxb->page,
-				0, PAGE_SIZE <<
-				    hw_params(trans).rx_page_order,
-				DMA_FROM_DEVICE);
-			list_add_tail(&rxb->list, &rxq->rx_free);
-			rxq->free_count++;
-		} else
-			list_add_tail(&rxb->list, &rxq->rx_used);
-
-		spin_unlock_irqrestore(&rxq->lock, flags);
+		iwl_rx_handle_rxbuf(trans, rxb);
 
 		i = (i + 1) & RX_QUEUE_MASK;
 		/* If there are a lot of unused frames,
-- 
1.7.0.4

