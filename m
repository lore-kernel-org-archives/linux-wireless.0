Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:21225 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161254Ab2COU2A (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 16:28:00 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 03/26] iwlwifi: process multiple frames per RXB
Date: Thu, 15 Mar 2012 13:26:43 -0700
Message-Id: <1331843226-29860-4-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120315_212859_156784_48A072B0)
In-Reply-To: <1331843226-29860-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1331843226-29860-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The flow handler (hardware) can put multiple
frames into a single RX buffer. To handle
this, walk the RX buffer and check if there
are multiple valid packets in it.

To let the upper layer handle this correctly
introduce rxb_offset() which is needed when
we pass pages to mac80211 -- we need to know
the offset into the page there.

Also change the page handling scheme to use
refcounting. Anyone who needs a page will
"steal" it, which marks it as having been
used & refcounts it. The RX handler then has
to free its own reference and must not reuse
the page.

Finally, do not set the bit asking the FH to
give us each packet in a single buffer. This
really enables the feature.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rx.c        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c |  143 ++++++++++++----------
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c    |    1 -
 drivers/net/wireless/iwlwifi/iwl-trans.h         |   17 ++-
 4 files changed, 92 insertions(+), 71 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
index 44c6f71..45bfeed 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
@@ -794,7 +794,7 @@ static void iwlagn_pass_packet_to_mac80211(struct iwl_priv *priv,
 		return;
 	}
 
-	offset = (void *)hdr - rxb_addr(rxb);
+	offset = (void *)hdr - rxb_addr(rxb) + rxb_offset(rxb);
 	p = rxb_steal_page(rxb);
 	skb_add_rx_frag(skb, 0, p, offset, len);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
index 8b1a798..b282311 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
@@ -362,83 +362,96 @@ static void iwl_rx_handle_rxbuf(struct iwl_trans *trans,
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_rx_queue *rxq = &trans_pcie->rxq;
 	struct iwl_tx_queue *txq = &trans_pcie->txq[trans_pcie->cmd_queue];
-	struct iwl_device_cmd *cmd;
 	unsigned long flags;
-	int len, err;
-	u16 sequence;
-	struct iwl_rx_cmd_buffer rxcb;
-	struct iwl_rx_packet *pkt;
-	bool reclaim;
-	int index, cmd_index;
+	bool page_stolen = false;
+	int max_len = PAGE_SIZE << hw_params(trans).rx_page_order;
+	u32 offset = 0;
 
 	if (WARN_ON(!rxb))
 		return;
 
-	dma_unmap_page(trans->dev, rxb->page_dma,
-		       PAGE_SIZE << hw_params(trans).rx_page_order,
-		       DMA_FROM_DEVICE);
+	dma_unmap_page(trans->dev, rxb->page_dma, max_len, DMA_FROM_DEVICE);
 
-	rxcb._page = rxb->page;
-	pkt = rxb_addr(&rxcb);
+	while (offset + sizeof(u32) + sizeof(struct iwl_cmd_header) < max_len) {
+		struct iwl_rx_packet *pkt;
+		struct iwl_device_cmd *cmd;
+		u16 sequence;
+		bool reclaim;
+		int index, cmd_index, err, len;
+		struct iwl_rx_cmd_buffer rxcb = {
+			._offset = offset,
+			._page = rxb->page,
+			._page_stolen = false,
+		};
 
-	IWL_DEBUG_RX(trans, "%s, 0x%02x\n",
-		     get_cmd_string(pkt->hdr.cmd), pkt->hdr.cmd);
+		pkt = rxb_addr(&rxcb);
 
+		if (pkt->len_n_flags == cpu_to_le32(FH_RSCSR_FRAME_INVALID))
+			break;
 
-	len = le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK;
-	len += sizeof(u32); /* account for status word */
-	trace_iwlwifi_dev_rx(trans->dev, pkt, len);
-
-	/* Reclaim a command buffer only if this packet is a response
-	 *   to a (driver-originated) command.
-	 * If the packet (e.g. Rx frame) originated from uCode,
-	 *   there is no command buffer to reclaim.
-	 * Ucode should set SEQ_RX_FRAME bit if ucode-originated,
-	 *   but apparently a few don't get set; catch them here. */
-	reclaim = !(pkt->hdr.sequence & SEQ_RX_FRAME);
-	if (reclaim) {
-		int i;
-
-		for (i = 0; i < trans_pcie->n_no_reclaim_cmds; i++) {
-			if (trans_pcie->no_reclaim_cmds[i] == pkt->hdr.cmd) {
-				reclaim = false;
-				break;
+		IWL_DEBUG_RX(trans, "cmd at offset %d: %s (0x%.2x)\n",
+			     rxcb._offset, get_cmd_string(pkt->hdr.cmd),
+			     pkt->hdr.cmd);
+
+		len = le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK;
+		len += sizeof(u32); /* account for status word */
+		trace_iwlwifi_dev_rx(trans->dev, pkt, len);
+
+		/* Reclaim a command buffer only if this packet is a response
+		 *   to a (driver-originated) command.
+		 * If the packet (e.g. Rx frame) originated from uCode,
+		 *   there is no command buffer to reclaim.
+		 * Ucode should set SEQ_RX_FRAME bit if ucode-originated,
+		 *   but apparently a few don't get set; catch them here. */
+		reclaim = !(pkt->hdr.sequence & SEQ_RX_FRAME);
+		if (reclaim) {
+			int i;
+
+			for (i = 0; i < trans_pcie->n_no_reclaim_cmds; i++) {
+				if (trans_pcie->no_reclaim_cmds[i] ==
+							pkt->hdr.cmd) {
+					reclaim = false;
+					break;
+				}
 			}
 		}
-	}
 
-	sequence = le16_to_cpu(pkt->hdr.sequence);
-	index = SEQ_TO_INDEX(sequence);
-	cmd_index = get_cmd_index(&txq->q, index);
+		sequence = le16_to_cpu(pkt->hdr.sequence);
+		index = SEQ_TO_INDEX(sequence);
+		cmd_index = get_cmd_index(&txq->q, index);
 
-	if (reclaim)
-		cmd = txq->cmd[cmd_index];
-	else
-		cmd = NULL;
+		if (reclaim)
+			cmd = txq->cmd[cmd_index];
+		else
+			cmd = NULL;
 
-	err = iwl_op_mode_rx(trans->op_mode, &rxcb, cmd);
+		err = iwl_op_mode_rx(trans->op_mode, &rxcb, cmd);
 
-	/*
-	 * XXX: After here, we should always check rxcb._page
-	 * against NULL before touching it or its virtual
-	 * memory (pkt). Because some rx_handler might have
-	 * already taken or freed the pages.
-	 */
+		/*
+		 * After here, we should always check rxcb._page_stolen,
+		 * if it is true then one of the handlers took the page.
+		 */
 
-	if (reclaim) {
-		/* Invoke any callbacks, transfer the buffer to caller,
-		 * and fire off the (possibly) blocking
-		 * iwl_trans_send_cmd()
-		 * as we reclaim the driver command queue */
-		if (rxcb._page)
-			iwl_tx_cmd_complete(trans, &rxcb, err);
-		else
-			IWL_WARN(trans, "Claim null rxb?\n");
+		if (reclaim) {
+			/* Invoke any callbacks, transfer the buffer to caller,
+			 * and fire off the (possibly) blocking
+			 * iwl_trans_send_cmd()
+			 * as we reclaim the driver command queue */
+			if (!rxcb._page_stolen)
+				iwl_tx_cmd_complete(trans, &rxcb, err);
+			else
+				IWL_WARN(trans, "Claim null rxb?\n");
+		}
+
+		page_stolen |= rxcb._page_stolen;
+		offset += ALIGN(len, FH_RSCSR_FRAME_ALIGN);
 	}
 
-	/* page was stolen from us */
-	if (rxcb._page == NULL)
+	/* page was stolen from us -- free our reference */
+	if (page_stolen) {
+		__free_pages(rxb->page, hw_params(trans).rx_page_order);
 		rxb->page = NULL;
+	}
 
 	/* Reuse the page if possible. For notification packets and
 	 * SKBs that fail to Rx correctly, add them back into the
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index b4f796c..98cd71f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -180,7 +180,6 @@ static void iwl_trans_rx_hw_init(struct iwl_trans *trans,
 			   FH_RCSR_RX_CONFIG_CHNL_EN_ENABLE_VAL |
 			   FH_RCSR_CHNL0_RX_IGNORE_RXF_EMPTY |
 			   FH_RCSR_CHNL0_RX_CONFIG_IRQ_DEST_INT_HOST_VAL |
-			   FH_RCSR_CHNL0_RX_CONFIG_SINGLE_FRAME_MSK |
 			   rb_size|
 			   (rb_timeout << FH_RCSR_RX_CONFIG_REG_IRQ_RBTH_POS)|
 			   (rfdnlog << FH_RCSR_RX_CONFIG_RBDCB_SIZE_POS));
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 0c81cba..57d8ae7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -162,6 +162,8 @@ struct iwl_cmd_header {
 
 
 #define FH_RSCSR_FRAME_SIZE_MSK		0x00003FFF	/* bits 0-13 */
+#define FH_RSCSR_FRAME_INVALID		0x55550000
+#define FH_RSCSR_FRAME_ALIGN		0x40
 
 struct iwl_rx_packet {
 	/*
@@ -260,18 +262,25 @@ static inline void iwl_free_resp(struct iwl_host_cmd *cmd)
 
 struct iwl_rx_cmd_buffer {
 	struct page *_page;
+	int _offset;
+	bool _page_stolen;
 };
 
 static inline void *rxb_addr(struct iwl_rx_cmd_buffer *r)
 {
-	return page_address(r->_page);
+	return (void *)((unsigned long)page_address(r->_page) + r->_offset);
+}
+
+static inline int rxb_offset(struct iwl_rx_cmd_buffer *r)
+{
+	return r->_offset;
 }
 
 static inline struct page *rxb_steal_page(struct iwl_rx_cmd_buffer *r)
 {
-	struct page *p = r->_page;
-	r->_page = NULL;
-	return p;
+	r->_page_stolen = true;
+	get_page(r->_page);
+	return r->_page;
 }
 
 #define MAX_NO_RECLAIM_CMDS	6
-- 
1.7.0.4

