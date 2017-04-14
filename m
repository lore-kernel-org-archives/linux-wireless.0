Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:51804 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753945AbdDNJEH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Apr 2017 05:04:07 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 14 Apr 2017 12:02:03 +0300
Message-Id: <20170414090210.31397-20-luca@coelho.fi> (sfid-20170414_110418_531848_EBA29F59)
In-Reply-To: <20170414090210.31397-1-luca@coelho.fi>
References: <20170414090210.31397-1-luca@coelho.fi>
Subject: [PATCH v2 19/26] iwlwifi: pcie: support new TX command
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Move to use the correct structure.
Remove code referring to old command.
Update DMA locations.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |  4 ++--
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c  | 10 +---------
 2 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index bd358895caee..912d475ed292 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -205,11 +205,11 @@ struct iwl_cmd_meta {
  * into the buffer regardless of whether it should be mapped or not.
  * This indicates how big the first TB must be to include the scratch buffer
  * and the assigned PN.
- * Since PN location is 16 bytes at offset 24, it's 40 now.
+ * Since PN location is 8 bytes at offset 12, it's 20 now.
  * If we make it bigger then allocations will be bigger and copy slower, so
  * that's probably not useful.
  */
-#define IWL_FIRST_TB_SIZE	40
+#define IWL_FIRST_TB_SIZE	20
 #define IWL_FIRST_TB_SIZE_ALIGN ALIGN(IWL_FIRST_TB_SIZE, 64)
 
 struct iwl_pcie_txq_entry {
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
index 3a36bda5fd27..67af73ef7d0d 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
@@ -284,14 +284,12 @@ static int iwl_fill_data_tbs(struct iwl_trans *trans, struct sk_buff *skb,
 	return 0;
 }
 
-#define TX_CMD_FLG_MH_PAD_MSK cpu_to_le32(TX_CMD_FLG_MH_PAD)
-
 int iwl_trans_pcie_gen2_tx(struct iwl_trans *trans, struct sk_buff *skb,
 			   struct iwl_device_cmd *dev_cmd, int txq_id)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct ieee80211_hdr *hdr;
-	struct iwl_tx_cmd *tx_cmd = (struct iwl_tx_cmd *)dev_cmd->payload;
+	struct iwl_tx_cmd_gen2 *tx_cmd = (void *)dev_cmd->payload;
 	struct iwl_cmd_meta *out_meta;
 	struct iwl_txq *txq;
 	dma_addr_t tb0_phys, tb1_phys, scratch_phys;
@@ -345,9 +343,6 @@ int iwl_trans_pcie_gen2_tx(struct iwl_trans *trans, struct sk_buff *skb,
 	scratch_phys = tb0_phys + sizeof(struct iwl_cmd_header) +
 		       offsetof(struct iwl_tx_cmd, scratch);
 
-	tx_cmd->dram_lsb_ptr = cpu_to_le32(scratch_phys);
-	tx_cmd->dram_msb_ptr = iwl_get_dma_hi_addr(scratch_phys);
-
 	/* Set up first empty entry in queue's array of Tx/cmd buffers */
 	out_meta = &txq->entries[txq->write_ptr].meta;
 	out_meta->flags = 0;
@@ -361,9 +356,6 @@ int iwl_trans_pcie_gen2_tx(struct iwl_trans *trans, struct sk_buff *skb,
 	len = sizeof(struct iwl_tx_cmd) + sizeof(struct iwl_cmd_header) +
 	      hdr_len - IWL_FIRST_TB_SIZE;
 	tb1_len = ALIGN(len, 4);
-	/* Tell NIC about any 2-byte padding after MAC header */
-	if (tb1_len != len)
-		tx_cmd->tx_flags |= TX_CMD_FLG_MH_PAD_MSK;
 
 	/*
 	 * The first TB points to bi-directional DMA data, we'll
-- 
2.11.0
