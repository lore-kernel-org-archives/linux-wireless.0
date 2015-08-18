Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:63426 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752078AbbHRH6D (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2015 03:58:03 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 07/26] iwlwifi: pcie: support frag SKBs
Date: Tue, 18 Aug 2015 10:57:17 +0300
Message-Id: <1439884656-18146-7-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150818_100110_327547_8C8805BD)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E8110F8@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E8110F8@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Allow frag SKBs in PCIe and advertise the maximum number of frags
to the opmode. As a fallback. linearize the SKB if it exceeds the
maximum number of fragments. This allows using the hardware better
(filling more TBs) and should improve performance when used by the
opmode.

Also adjust tracing to be able to deal with this.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-devtrace-data.h |  7 ++-
 drivers/net/wireless/iwlwifi/iwl-trans.h         |  7 +++
 drivers/net/wireless/iwlwifi/pcie/internal.h     |  6 ++
 drivers/net/wireless/iwlwifi/pcie/trans.c        |  2 +
 drivers/net/wireless/iwlwifi/pcie/tx.c           | 70 ++++++++++++++++++++----
 5 files changed, 77 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-devtrace-data.h b/drivers/net/wireless/iwlwifi/iwl-devtrace-data.h
index 04e6649..71a78ce 100644
--- a/drivers/net/wireless/iwlwifi/iwl-devtrace-data.h
+++ b/drivers/net/wireless/iwlwifi/iwl-devtrace-data.h
@@ -35,8 +35,8 @@
 TRACE_EVENT(iwlwifi_dev_tx_data,
 	TP_PROTO(const struct device *dev,
 		 struct sk_buff *skb,
-		 void *data, size_t data_len),
-	TP_ARGS(dev, skb, data, data_len),
+		 u8 hdr_len, size_t data_len),
+	TP_ARGS(dev, skb, hdr_len, data_len),
 	TP_STRUCT__entry(
 		DEV_ENTRY
 
@@ -45,7 +45,8 @@ TRACE_EVENT(iwlwifi_dev_tx_data,
 	TP_fast_assign(
 		DEV_ASSIGN;
 		if (iwl_trace_data(skb))
-			memcpy(__get_dynamic_array(data), data, data_len);
+			skb_copy_bits(skb, hdr_len,
+				      __get_dynamic_array(data), data_len);
 	),
 	TP_printk("[%s] TX frame data", __get_str(dev))
 );
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 2f79e54..e68497a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -248,6 +248,8 @@ static inline u32 iwl_rx_packet_payload_len(const struct iwl_rx_packet *pkt)
  * @CMD_MAKE_TRANS_IDLE: The command response should mark the trans as idle.
  * @CMD_WAKE_UP_TRANS: The command response should wake up the trans
  *	(i.e. mark it as non-idle).
+ * @CMD_TB_BITMAP_POS: Position of the first bit for the TB bitmap. We need to
+ *	check that we leave enough room for the TBs bitmap which needs 20 bits.
  */
 enum CMD_MODE {
 	CMD_ASYNC		= BIT(0),
@@ -257,6 +259,8 @@ enum CMD_MODE {
 	CMD_SEND_IN_IDLE	= BIT(4),
 	CMD_MAKE_TRANS_IDLE	= BIT(5),
 	CMD_WAKE_UP_TRANS	= BIT(6),
+
+	CMD_TB_BITMAP_POS	= 11,
 };
 
 #define DEF_CMD_PAYLOAD_SIZE 320
@@ -641,6 +645,8 @@ enum iwl_d0i3_mode {
  * @cfg - pointer to the configuration
  * @status: a bit-mask of transport status flags
  * @dev - pointer to struct device * that represents the device
+ * @max_skb_frags: maximum number of fragments an SKB can have when transmitted.
+ *	0 indicates that frag SKBs (NETIF_F_SG) aren't supported.
  * @hw_id: a u32 with the ID of the device / sub-device.
  *	Set during transport allocation.
  * @hw_id_str: a string with info about HW ID. Set during transport allocation.
@@ -669,6 +675,7 @@ struct iwl_trans {
 	unsigned long status;
 
 	struct device *dev;
+	u32 max_skb_frags;
 	u32 hw_rev;
 	u32 hw_id;
 	char hw_id_str[52];
diff --git a/drivers/net/wireless/iwlwifi/pcie/internal.h b/drivers/net/wireless/iwlwifi/pcie/internal.h
index 17f65dc..feb2f7e 100644
--- a/drivers/net/wireless/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/iwlwifi/pcie/internal.h
@@ -44,6 +44,12 @@
 #include "iwl-io.h"
 #include "iwl-op-mode.h"
 
+/* We need 2 entries for the TX command and header, and another one might
+ * be needed for potential data in the SKB's head. The remaining ones can
+ * be used for frags.
+ */
+#define IWL_PCIE_MAX_FRAGS (IWL_NUM_OF_TBS - 3)
+
 /*
  * RX related structures and functions
  */
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 9ebdd80..fb55810 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -2627,6 +2627,8 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 	if (!trans)
 		return ERR_PTR(-ENOMEM);
 
+	trans->max_skb_frags = IWL_PCIE_MAX_FRAGS;
+
 	trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 
 	trans_pcie->trans = trans;
diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index 601eee1..b7d1268 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -388,11 +388,18 @@ static void iwl_pcie_tfd_unmap(struct iwl_trans *trans,
 
 	/* first TB is never freed - it's the scratchbuf data */
 
-	for (i = 1; i < num_tbs; i++)
-		dma_unmap_single(trans->dev, iwl_pcie_tfd_tb_get_addr(tfd, i),
-				 iwl_pcie_tfd_tb_get_len(tfd, i),
-				 DMA_TO_DEVICE);
-
+	for (i = 1; i < num_tbs; i++) {
+		if (meta->flags & BIT(i + CMD_TB_BITMAP_POS))
+			dma_unmap_page(trans->dev,
+				       iwl_pcie_tfd_tb_get_addr(tfd, i),
+				       iwl_pcie_tfd_tb_get_len(tfd, i),
+				       DMA_TO_DEVICE);
+		else
+			dma_unmap_single(trans->dev,
+					 iwl_pcie_tfd_tb_get_addr(tfd, i),
+					 iwl_pcie_tfd_tb_get_len(tfd, i),
+					 DMA_TO_DEVICE);
+	}
 	tfd->num_tbs = 0;
 }
 
@@ -468,7 +475,7 @@ static int iwl_pcie_txq_build_tfd(struct iwl_trans *trans, struct iwl_txq *txq,
 
 	iwl_pcie_tfd_set_tb(tfd, num_tbs, addr, len);
 
-	return 0;
+	return num_tbs;
 }
 
 static int iwl_pcie_txq_alloc(struct iwl_trans *trans,
@@ -1546,6 +1553,8 @@ static int iwl_pcie_enqueue_hcmd(struct iwl_trans *trans,
 		iwl_pcie_txq_build_tfd(trans, txq, phys_addr, cmdlen[i], false);
 	}
 
+	BUILD_BUG_ON(IWL_NUM_OF_TBS + CMD_TB_BITMAP_POS >
+		     sizeof(out_meta->flags) * BITS_PER_BYTE);
 	out_meta->flags = cmd->flags;
 	if (WARN_ON_ONCE(txq->entries[idx].free_buf))
 		kzfree(txq->entries[idx].free_buf);
@@ -1789,7 +1798,7 @@ int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 		      struct iwl_device_cmd *dev_cmd, int txq_id)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	struct ieee80211_hdr *hdr;
 	struct iwl_tx_cmd *tx_cmd = (struct iwl_tx_cmd *)dev_cmd->payload;
 	struct iwl_cmd_meta *out_meta;
 	struct iwl_txq *txq;
@@ -1798,9 +1807,10 @@ int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 	void *tb1_addr;
 	u16 len, tb1_len, tb2_len;
 	bool wait_write_ptr;
-	__le16 fc = hdr->frame_control;
-	u8 hdr_len = ieee80211_hdrlen(fc);
+	__le16 fc;
+	u8 hdr_len;
 	u16 wifi_seq;
+	int i;
 
 	txq = &trans_pcie->txq[txq_id];
 	q = &txq->q;
@@ -1809,6 +1819,18 @@ int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 		      "TX on unused queue %d\n", txq_id))
 		return -EINVAL;
 
+	if (skb_is_nonlinear(skb) &&
+	    skb_shinfo(skb)->nr_frags > IWL_PCIE_MAX_FRAGS &&
+	    __skb_linearize(skb))
+		return -ENOMEM;
+
+	/* mac80211 always puts the full header into the SKB's head,
+	 * so there's no need to check if it's readable there
+	 */
+	hdr = (struct ieee80211_hdr *)skb->data;
+	fc = hdr->frame_control;
+	hdr_len = ieee80211_hdrlen(fc);
+
 	spin_lock(&txq->lock);
 
 	/* In AGG mode, the index in the ring must correspond to the WiFi
@@ -1839,6 +1861,7 @@ int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 
 	/* Set up first empty entry in queue's array of Tx/cmd buffers */
 	out_meta = &txq->entries[q->write_ptr].meta;
+	out_meta->flags = 0;
 
 	/*
 	 * The second TB (tb1) points to the remainder of the TX command
@@ -1872,9 +1895,9 @@ int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 
 	/*
 	 * Set up TFD's third entry to point directly to remainder
-	 * of skb, if any (802.11 null frames have no payload).
+	 * of skb's head, if any
 	 */
-	tb2_len = skb->len - hdr_len;
+	tb2_len = skb_headlen(skb) - hdr_len;
 	if (tb2_len > 0) {
 		dma_addr_t tb2_phys = dma_map_single(trans->dev,
 						     skb->data + hdr_len,
@@ -1887,6 +1910,29 @@ int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 		iwl_pcie_txq_build_tfd(trans, txq, tb2_phys, tb2_len, false);
 	}
 
+	/* set up the remaining entries to point to the data */
+	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+		const skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
+		dma_addr_t tb_phys;
+		int tb_idx;
+
+		if (!skb_frag_size(frag))
+			continue;
+
+		tb_phys = skb_frag_dma_map(trans->dev, frag, 0,
+					   skb_frag_size(frag), DMA_TO_DEVICE);
+
+		if (unlikely(dma_mapping_error(trans->dev, tb_phys))) {
+			iwl_pcie_tfd_unmap(trans, out_meta,
+					   &txq->tfds[q->write_ptr]);
+			goto out_err;
+		}
+		tb_idx = iwl_pcie_txq_build_tfd(trans, txq, tb_phys,
+						skb_frag_size(frag), false);
+
+		out_meta->flags |= BIT(tb_idx + CMD_TB_BITMAP_POS);
+	}
+
 	/* Set up entry for this TFD in Tx byte-count array */
 	iwl_pcie_txq_update_byte_cnt_tbl(trans, txq, le16_to_cpu(tx_cmd->len));
 
@@ -1896,7 +1942,7 @@ int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 			     &dev_cmd->hdr, IWL_HCMD_SCRATCHBUF_SIZE + tb1_len,
 			     skb->data + hdr_len, tb2_len);
 	trace_iwlwifi_dev_tx_data(trans->dev, skb,
-				  skb->data + hdr_len, tb2_len);
+				  hdr_len, skb->len - hdr_len);
 
 	wait_write_ptr = ieee80211_has_morefrags(fc);
 
-- 
2.1.4

