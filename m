Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:2924 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751988AbbHRH5w (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2015 03:57:52 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 03/26] iwlwifi: pcie: dump RBs when FW error occurs
Date: Tue, 18 Aug 2015 10:57:13 +0300
Message-Id: <1439884656-18146-3-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150818_095803_124241_BD6B1281)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E8110F8@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E8110F8@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add support for dumping all the RBs in the RX queue
when FW error occurs.
This will assist debugging.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h | 17 +++++++
 drivers/net/wireless/iwlwifi/pcie/trans.c        | 59 +++++++++++++++++++++++-
 2 files changed, 74 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h b/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
index e57dbd0..af5b320 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
@@ -84,6 +84,8 @@
  * @IWL_FW_ERROR_DUMP_MEM: chunk of memory
  * @IWL_FW_ERROR_DUMP_ERROR_INFO: description of what triggered this dump.
  *	Structured as &struct iwl_fw_error_dump_trigger_desc.
+ * @IWL_FW_ERROR_DUMP_RB: the content of an RB structured as
+ *	&struct iwl_fw_error_dump_rb
  */
 enum iwl_fw_error_dump_type {
 	/* 0 is deprecated */
@@ -97,6 +99,7 @@ enum iwl_fw_error_dump_type {
 	IWL_FW_ERROR_DUMP_FH_REGS = 8,
 	IWL_FW_ERROR_DUMP_MEM = 9,
 	IWL_FW_ERROR_DUMP_ERROR_INFO = 10,
+	IWL_FW_ERROR_DUMP_RB = 11,
 
 	IWL_FW_ERROR_DUMP_MAX,
 };
@@ -223,6 +226,20 @@ struct iwl_fw_error_dump_mem {
 };
 
 /**
+ * struct iwl_fw_error_dump_rb - content of an Receive Buffer
+ * @index: the index of the Receive Buffer in the Rx queue
+ * @rxq: the RB's Rx queue
+ * @reserved:
+ * @data: the content of the Receive Buffer
+ */
+struct iwl_fw_error_dump_rb {
+	__le32 index;
+	__le32 rxq;
+	__le32 reserved;
+	u8 data[];
+};
+
+/**
  * iwl_fw_error_next_data - advance fw error dump data pointer
  * @data: previous data block
  * Returns: next data block
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 8cc8f2b..9ebdd80 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -2275,6 +2275,47 @@ static u32 iwl_trans_pcie_dump_prph(struct iwl_trans *trans,
 	return prph_len;
 }
 
+static u32 iwl_trans_pcie_dump_rbs(struct iwl_trans *trans,
+				   struct iwl_fw_error_dump_data **data,
+				   int allocated_rb_nums)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	int max_len = PAGE_SIZE << trans_pcie->rx_page_order;
+	struct iwl_rxq *rxq = &trans_pcie->rxq;
+	u32 i, r, j, rb_len = 0;
+
+	spin_lock(&rxq->lock);
+
+	r = le16_to_cpu(ACCESS_ONCE(rxq->rb_stts->closed_rb_num)) & 0x0FFF;
+
+	for (i = rxq->read, j = 0;
+	     i != r && j < allocated_rb_nums;
+	     i = (i + 1) & RX_QUEUE_MASK, j++) {
+		struct iwl_rx_mem_buffer *rxb = rxq->queue[i];
+		struct iwl_fw_error_dump_rb *rb;
+
+		dma_unmap_page(trans->dev, rxb->page_dma, max_len,
+			       DMA_FROM_DEVICE);
+
+		rb_len += sizeof(**data) + sizeof(*rb) + max_len;
+
+		(*data)->type = cpu_to_le32(IWL_FW_ERROR_DUMP_RB);
+		(*data)->len = cpu_to_le32(sizeof(*rb) + max_len);
+		rb = (void *)(*data)->data;
+		rb->index = cpu_to_le32(i);
+		memcpy(rb->data, page_address(rxb->page), max_len);
+		/* remap the page for the free benefit */
+		rxb->page_dma = dma_map_page(trans->dev, rxb->page, 0,
+						     max_len,
+						     DMA_FROM_DEVICE);
+
+		*data = iwl_fw_error_next_data(*data);
+	}
+
+	spin_unlock(&rxq->lock);
+
+	return rb_len;
+}
 #define IWL_CSR_TO_DUMP (0x250)
 
 static u32 iwl_trans_pcie_dump_csr(struct iwl_trans *trans,
@@ -2352,9 +2393,10 @@ struct iwl_trans_dump_data *iwl_trans_pcie_dump_data(struct iwl_trans *trans)
 	struct iwl_txq *cmdq = &trans_pcie->txq[trans_pcie->cmd_queue];
 	struct iwl_fw_error_dump_txcmd *txcmd;
 	struct iwl_trans_dump_data *dump_data;
-	u32 len;
+	u32 len, num_rbs;
 	u32 monitor_len;
 	int i, ptr;
+	bool dump_rbs = test_bit(STATUS_FW_ERROR, &trans->status);
 
 	/* transport dump header */
 	len = sizeof(*dump_data);
@@ -2379,6 +2421,17 @@ struct iwl_trans_dump_data *iwl_trans_pcie_dump_data(struct iwl_trans *trans)
 	/* FH registers */
 	len += sizeof(*data) + (FH_MEM_UPPER_BOUND - FH_MEM_LOWER_BOUND);
 
+	if (dump_rbs) {
+		/* RBs */
+		num_rbs = le16_to_cpu(ACCESS_ONCE(
+				      trans_pcie->rxq.rb_stts->closed_rb_num))
+				      & 0x0FFF;
+		num_rbs = (num_rbs - trans_pcie->rxq.read) & RX_QUEUE_MASK;
+		len += num_rbs * (sizeof(*data) +
+				  sizeof(struct iwl_fw_error_dump_rb) +
+				  (PAGE_SIZE << trans_pcie->rx_page_order));
+	}
+
 	/* FW monitor */
 	if (trans_pcie->fw_mon_page) {
 		len += sizeof(*data) + sizeof(struct iwl_fw_error_dump_fw_mon) +
@@ -2442,8 +2495,10 @@ struct iwl_trans_dump_data *iwl_trans_pcie_dump_data(struct iwl_trans *trans)
 	len += iwl_trans_pcie_dump_prph(trans, &data);
 	len += iwl_trans_pcie_dump_csr(trans, &data);
 	len += iwl_trans_pcie_fh_regs_dump(trans, &data);
-	/* data is already pointing to the next section */
+	if (dump_rbs)
+		len += iwl_trans_pcie_dump_rbs(trans, &data, num_rbs);
 
+	/* data is already pointing to the next section */
 	if ((trans_pcie->fw_mon_page &&
 	     trans->cfg->device_family == IWL_DEVICE_FAMILY_7000) ||
 	    trans->dbg_dest_tlv) {
-- 
2.1.4

