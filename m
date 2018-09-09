Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:47942 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726689AbeIIO0L (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 9 Sep 2018 10:26:11 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sun,  9 Sep 2018 12:36:43 +0300
Message-Id: <20180909093656.10194-4-luca@coelho.fi> (sfid-20180909_113711_154230_E4991E4C)
In-Reply-To: <20180909093656.10194-1-luca@coelho.fi>
References: <20180909093656.10194-1-luca@coelho.fi>
Subject: [PATCH 03/16] iwlwifi: pcie: tx: pull tracing out of iwl_fill_data_tbs()
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This will allow us to reuse the function later for adding fraglist
SKBs to the TFD.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c | 41 ++++++++++----------
 1 file changed, 21 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index 2742c41c88b3..14b6e726da46 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -1977,26 +1977,24 @@ int iwl_trans_pcie_send_hcmd(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 
 static int iwl_fill_data_tbs(struct iwl_trans *trans, struct sk_buff *skb,
 			     struct iwl_txq *txq, u8 hdr_len,
-			     struct iwl_cmd_meta *out_meta,
-			     struct iwl_device_cmd *dev_cmd, u16 tb1_len)
+			     struct iwl_cmd_meta *out_meta)
 {
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	u16 tb2_len;
+	u16 head_tb_len;
 	int i;
 
 	/*
 	 * Set up TFD's third entry to point directly to remainder
 	 * of skb's head, if any
 	 */
-	tb2_len = skb_headlen(skb) - hdr_len;
+	head_tb_len = skb_headlen(skb) - hdr_len;
 
-	if (tb2_len > 0) {
-		dma_addr_t tb2_phys = dma_map_single(trans->dev,
-						     skb->data + hdr_len,
-						     tb2_len, DMA_TO_DEVICE);
-		if (unlikely(dma_mapping_error(trans->dev, tb2_phys)))
+	if (head_tb_len > 0) {
+		dma_addr_t tb_phys = dma_map_single(trans->dev,
+						    skb->data + hdr_len,
+						    head_tb_len, DMA_TO_DEVICE);
+		if (unlikely(dma_mapping_error(trans->dev, tb_phys)))
 			return -EINVAL;
-		iwl_pcie_txq_build_tfd(trans, txq, tb2_phys, tb2_len, false);
+		iwl_pcie_txq_build_tfd(trans, txq, tb_phys, head_tb_len, false);
 	}
 
 	/* set up the remaining entries to point to the data */
@@ -2019,12 +2017,6 @@ static int iwl_fill_data_tbs(struct iwl_trans *trans, struct sk_buff *skb,
 		out_meta->tbs |= BIT(tb_idx);
 	}
 
-	trace_iwlwifi_dev_tx(trans->dev, skb,
-			     iwl_pcie_get_tfd(trans, txq, txq->write_ptr),
-			     trans_pcie->tfd_size,
-			     &dev_cmd->hdr, IWL_FIRST_TB_SIZE + tb1_len,
-			     hdr_len);
-	trace_iwlwifi_dev_tx_data(trans->dev, skb, hdr_len);
 	return 0;
 }
 
@@ -2415,9 +2407,18 @@ int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 						     out_meta, dev_cmd,
 						     tb1_len)))
 			goto out_err;
-	} else if (unlikely(iwl_fill_data_tbs(trans, skb, txq, hdr_len,
-				       out_meta, dev_cmd, tb1_len))) {
-		goto out_err;
+	} else {
+		if (unlikely(iwl_fill_data_tbs(trans, skb, txq, hdr_len,
+					       out_meta)))
+			goto out_err;
+
+		trace_iwlwifi_dev_tx(trans->dev, skb,
+				     iwl_pcie_get_tfd(trans, txq,
+						      txq->write_ptr),
+				     trans_pcie->tfd_size,
+				     &dev_cmd->hdr, IWL_FIRST_TB_SIZE + tb1_len,
+				     hdr_len);
+		trace_iwlwifi_dev_tx_data(trans->dev, skb, hdr_len);
 	}
 
 	/* building the A-MSDU might have changed this data, so memcpy it now */
-- 
2.18.0
