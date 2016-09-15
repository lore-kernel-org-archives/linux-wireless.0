Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:54770 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751469AbcIOSLu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Sep 2016 14:11:50 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Thu, 15 Sep 2016 21:11:15 +0300
Message-Id: <20160915181131.32213-9-luca@coelho.fi> (sfid-20160915_201200_789616_721505D2)
In-Reply-To: <1473962425.5664.41.camel@coelho.fi>
References: <1473962425.5664.41.camel@coelho.fi>
Subject: [PATCH 09/25] iwlwifi: change byte count table for a000 devices
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Since TFD was enlarged to 256 bytes, the fetch of the TFD
itself is very expensive.
To make DRAM to SRAM more efficient, bits 12-13 will indicate
the number of 64 byte chunks that should be transferred to
SRAM.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-fh.h  |  7 +++++-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c | 36 ++++++++++++++++++++++------
 2 files changed, 35 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-fh.h b/drivers/net/wireless/intel/iwlwifi/iwl-fh.h
index 98d2ff2..33ef537 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-fh.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-fh.h
@@ -734,8 +734,13 @@ struct iwl_tfh_tfd {
 /**
  * struct iwlagn_schedq_bc_tbl scheduler byte count table
  *	base physical address provided by SCD_DRAM_BASE_ADDR
+ * For devices up to a000:
  * @tfd_offset  0-12 - tx command byte count
- *	       12-16 - station index
+ *		12-16 - station index
+ * For a000 and on:
+ * @tfd_offset  0-12 - tx command byte count
+ *		12-13 - number of 64 byte chunks
+ *		14-16 - reserved
  */
 struct iwlagn_scd_bc_tbl {
 	__le16 tfd_offset[TFD_QUEUE_BC_SIZE];
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index f893ee1..b4b925e 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -176,14 +176,14 @@ static void iwl_pcie_txq_stuck_timer(unsigned long data)
  * iwl_pcie_txq_update_byte_cnt_tbl - Set up entry in Tx byte-count array
  */
 static void iwl_pcie_txq_update_byte_cnt_tbl(struct iwl_trans *trans,
-					     struct iwl_txq *txq, u16 byte_cnt)
+					     struct iwl_txq *txq, u16 byte_cnt,
+					     int num_tbs)
 {
 	struct iwlagn_scd_bc_tbl *scd_bc_tbl;
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	int write_ptr = txq->q.write_ptr;
 	int txq_id = txq->q.id;
 	u8 sec_ctl = 0;
-	u8 sta_id = 0;
 	u16 len = byte_cnt + IWL_TX_CRC_SIZE + IWL_TX_DELIMITER_SIZE;
 	__le16 bc_ent;
 	struct iwl_tx_cmd *tx_cmd =
@@ -191,7 +191,6 @@ static void iwl_pcie_txq_update_byte_cnt_tbl(struct iwl_trans *trans,
 
 	scd_bc_tbl = trans_pcie->scd_bc_tbls.addr;
 
-	sta_id = tx_cmd->sta_id;
 	sec_ctl = tx_cmd->sec_ctl;
 
 	switch (sec_ctl & TX_CMD_SEC_MSK) {
@@ -205,14 +204,32 @@ static void iwl_pcie_txq_update_byte_cnt_tbl(struct iwl_trans *trans,
 		len += IEEE80211_WEP_IV_LEN + IEEE80211_WEP_ICV_LEN;
 		break;
 	}
-
 	if (trans_pcie->bc_table_dword)
 		len = DIV_ROUND_UP(len, 4);
 
 	if (WARN_ON(len > 0xFFF || write_ptr >= TFD_QUEUE_SIZE_MAX))
 		return;
 
-	bc_ent = cpu_to_le16(len | (sta_id << 12));
+	if (trans->cfg->use_tfh) {
+		u8 filled_tfd_size = offsetof(struct iwl_tfh_tfd, tbs) +
+				     num_tbs * sizeof(struct iwl_tfh_tb);
+		/*
+		 * filled_tfd_size contains the number of filled bytes in the
+		 * TFD.
+		 * Dividing it by 64 will give the number of chunks to fetch
+		 * to SRAM- 0 for one chunk, 1 for 2 and so on.
+		 * If, for example, TFD contains only 3 TBs then 32 bytes
+		 * of the TFD are used, and only one chunk of 64 bytes should
+		 * be fetched
+		 */
+		u8 num_fetch_chunks = DIV_ROUND_UP(filled_tfd_size, 64) - 1;
+
+		bc_ent = cpu_to_le16(len | (num_fetch_chunks << 12));
+	} else {
+		u8 sta_id = tx_cmd->sta_id;
+
+		bc_ent = cpu_to_le16(len | (sta_id << 12));
+	}
 
 	scd_bc_tbl[txq_id].tfd_offset[write_ptr] = bc_ent;
 
@@ -240,6 +257,7 @@ static void iwl_pcie_txq_inval_byte_cnt_tbl(struct iwl_trans *trans,
 		sta_id = tx_cmd->sta_id;
 
 	bc_ent = cpu_to_le16(1 | (sta_id << 12));
+
 	scd_bc_tbl[txq_id].tfd_offset[read_ptr] = bc_ent;
 
 	if (read_ptr < TFD_QUEUE_SIZE_BC_DUP)
@@ -1126,7 +1144,8 @@ void iwl_trans_pcie_reclaim(struct iwl_trans *trans, int txq_id, int ssn,
 
 		txq->entries[txq->q.read_ptr].skb = NULL;
 
-		iwl_pcie_txq_inval_byte_cnt_tbl(trans, txq);
+		if (!trans->cfg->use_tfh)
+			iwl_pcie_txq_inval_byte_cnt_tbl(trans, txq);
 
 		iwl_pcie_txq_free_tfd(trans, txq);
 	}
@@ -2272,6 +2291,7 @@ int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 	struct iwl_queue *q;
 	dma_addr_t tb0_phys, tb1_phys, scratch_phys;
 	void *tb1_addr;
+	void *tfd;
 	u16 len, tb1_len;
 	bool wait_write_ptr;
 	__le16 fc;
@@ -2410,8 +2430,10 @@ int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 		goto out_err;
 	}
 
+	tfd = iwl_pcie_get_tfd(trans_pcie, txq, q->write_ptr);
 	/* Set up entry for this TFD in Tx byte-count array */
-	iwl_pcie_txq_update_byte_cnt_tbl(trans, txq, le16_to_cpu(tx_cmd->len));
+	iwl_pcie_txq_update_byte_cnt_tbl(trans, txq, le16_to_cpu(tx_cmd->len),
+					 iwl_pcie_tfd_get_num_tbs(trans, tfd));
 
 	wait_write_ptr = ieee80211_has_morefrags(fc);
 
-- 
2.9.3
