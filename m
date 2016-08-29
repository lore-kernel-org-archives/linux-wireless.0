Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40944 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755561AbcH2V0e (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 29 Aug 2016 17:26:34 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 30 Aug 2016 00:26:03 +0300
Message-Id: <1472505976-21108-3-git-send-email-luca@coelho.fi> (sfid-20160829_232637_569134_6A03FA57)
In-Reply-To: <1472505976-21108-1-git-send-email-luca@coelho.fi>
References: <1472505827.27868.41.camel@coelho.fi>
 <1472505976-21108-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 03/16] iwlwifi: mvm: support new paging command format
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

For a000 devices there is a support of 64 bit DMA addressing.
The paging command was changed accordingly - support it.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h |  8 +++++--
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c     | 28 ++++++++++++++++++-------
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h    |  6 ++++++
 3 files changed, 32 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
index 71076f0..57b574b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
@@ -482,13 +482,17 @@ struct iwl_nvm_access_cmd {
  * @block_size: the block size in powers of 2
  * @block_num: number of blocks specified in the command.
  * @device_phy_addr: virtual addresses from device side
+ *	32 bit address for API version 1, 64 bit address for API version 2.
 */
 struct iwl_fw_paging_cmd {
 	__le32 flags;
 	__le32 block_size;
 	__le32 block_num;
-	__le32 device_phy_addr[NUM_OF_FW_PAGING_BLOCKS];
-} __packed; /* FW_PAGING_BLOCK_CMD_API_S_VER_1 */
+	union {
+		__le32 addr32[NUM_OF_FW_PAGING_BLOCKS];
+		__le64 addr64[NUM_OF_FW_PAGING_BLOCKS];
+	} device_phy_addr;
+} __packed; /* FW_PAGING_BLOCK_CMD_API_S_VER_2 */
 
 /*
  * Fw items ID's
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 7e0cdbf..47e8e70 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -385,9 +385,7 @@ static int iwl_save_fw_paging(struct iwl_mvm *mvm,
 /* send paging cmd to FW in case CPU2 has paging image */
 static int iwl_send_paging_cmd(struct iwl_mvm *mvm, const struct fw_img *fw)
 {
-	int blk_idx;
-	__le32 dev_phy_addr;
-	struct iwl_fw_paging_cmd fw_paging_cmd = {
+	struct iwl_fw_paging_cmd paging_cmd = {
 		.flags =
 			cpu_to_le32(PAGING_CMD_IS_SECURED |
 				    PAGING_CMD_IS_ENABLED |
@@ -396,18 +394,32 @@ static int iwl_send_paging_cmd(struct iwl_mvm *mvm, const struct fw_img *fw)
 		.block_size = cpu_to_le32(BLOCK_2_EXP_SIZE),
 		.block_num = cpu_to_le32(mvm->num_of_paging_blk),
 	};
+	int blk_idx, size = sizeof(paging_cmd);
+
+	/* A bit hard coded - but this is the old API and will be deprecated */
+	if (!iwl_mvm_has_new_tx_api(mvm))
+		size -= NUM_OF_FW_PAGING_BLOCKS * 4;
 
 	/* loop for for all paging blocks + CSS block */
 	for (blk_idx = 0; blk_idx < mvm->num_of_paging_blk + 1; blk_idx++) {
-		dev_phy_addr =
-			cpu_to_le32(mvm->fw_paging_db[blk_idx].fw_paging_phys >>
-				    PAGE_2_EXP_SIZE);
-		fw_paging_cmd.device_phy_addr[blk_idx] = dev_phy_addr;
+		dma_addr_t addr = mvm->fw_paging_db[blk_idx].fw_paging_phys;
+
+		addr = addr >> PAGE_2_EXP_SIZE;
+
+		if (iwl_mvm_has_new_tx_api(mvm)) {
+			__le64 phy_addr = cpu_to_le64(addr);
+
+			paging_cmd.device_phy_addr.addr64[blk_idx] = phy_addr;
+		} else {
+			__le32 phy_addr = cpu_to_le32(addr);
+
+			paging_cmd.device_phy_addr.addr32[blk_idx] = phy_addr;
+		}
 	}
 
 	return iwl_mvm_send_cmd_pdu(mvm, iwl_cmd_id(FW_PAGING_BLOCK_CMD,
 						    IWL_ALWAYS_LONG_GROUP, 0),
-				    0, sizeof(fw_paging_cmd), &fw_paging_cmd);
+				    0, size, &paging_cmd);
 }
 
 /*
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 0b0855a..28ebc12 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1192,6 +1192,12 @@ static inline bool iwl_mvm_has_new_rx_api(struct iwl_mvm *mvm)
 			   IWL_UCODE_TLV_CAPA_MULTI_QUEUE_RX_SUPPORT);
 }
 
+static inline bool iwl_mvm_has_new_tx_api(struct iwl_mvm *mvm)
+{
+	/* TODO - replace with TLV once defined */
+	return mvm->trans->cfg->use_tfh;
+}
+
 static inline bool iwl_mvm_is_tt_in_fw(struct iwl_mvm *mvm)
 {
 #ifdef CONFIG_THERMAL
-- 
2.8.1
