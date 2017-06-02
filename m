Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:60764 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751149AbdFBL0S (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Jun 2017 07:26:18 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  2 Jun 2017 14:25:37 +0300
Message-Id: <20170602112553.2466-10-luca@coelho.fi> (sfid-20170602_132639_787666_97A04665)
In-Reply-To: <20170602112553.2466-1-luca@coelho.fi>
References: <20170602112553.2466-1-luca@coelho.fi>
Subject: [PATCH 09/25] iwlwifi: mvm: disentangle paging command structs
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Instead of using a union and hard-coding the size difference,
declare both command structs properly, use a union on the
stack to build them and the right sizeof() for the size.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h | 29 +++++++++++++++++++------
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c     | 19 +++++++++-------
 2 files changed, 33 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
index 69f3065ba600..a1cce18460bb 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
@@ -508,7 +508,26 @@ struct iwl_nvm_access_cmd {
 
 #define NUM_OF_FW_PAGING_BLOCKS	33 /* 32 for data and 1 block for CSS */
 
-/*
+/**
+ * struct iwl_fw_paging_cmd_v1 - paging layout
+ *
+ * (FW_PAGING_BLOCK_CMD = 0x4f)
+ *
+ * Send to FW the paging layout in the driver.
+ *
+ * @flags: various flags for the command
+ * @block_size: the block size in powers of 2
+ * @block_num: number of blocks specified in the command.
+ * @device_phy_addr: virtual addresses from device side
+ */
+struct iwl_fw_paging_cmd_v1 {
+	__le32 flags;
+	__le32 block_size;
+	__le32 block_num;
+	__le32 device_phy_addr[NUM_OF_FW_PAGING_BLOCKS];
+} __packed; /* FW_PAGING_BLOCK_CMD_API_S_VER_1 */
+
+/**
  * struct iwl_fw_paging_cmd - paging layout
  *
  * (FW_PAGING_BLOCK_CMD = 0x4f)
@@ -519,16 +538,12 @@ struct iwl_nvm_access_cmd {
  * @block_size: the block size in powers of 2
  * @block_num: number of blocks specified in the command.
  * @device_phy_addr: virtual addresses from device side
- *	32 bit address for API version 1, 64 bit address for API version 2.
-*/
+ */
 struct iwl_fw_paging_cmd {
 	__le32 flags;
 	__le32 block_size;
 	__le32 block_num;
-	union {
-		__le32 addr32[NUM_OF_FW_PAGING_BLOCKS];
-		__le64 addr64[NUM_OF_FW_PAGING_BLOCKS];
-	} device_phy_addr;
+	__le64 device_phy_addr[NUM_OF_FW_PAGING_BLOCKS];
 } __packed; /* FW_PAGING_BLOCK_CMD_API_S_VER_2 */
 
 /*
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index a8804bc979fe..8bdeb7c891e9 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -384,20 +384,23 @@ static int iwl_save_fw_paging(struct iwl_mvm *mvm,
 /* send paging cmd to FW in case CPU2 has paging image */
 static int iwl_send_paging_cmd(struct iwl_mvm *mvm, const struct fw_img *fw)
 {
-	struct iwl_fw_paging_cmd paging_cmd = {
-		.flags =
+	union {
+		struct iwl_fw_paging_cmd v2;
+		struct iwl_fw_paging_cmd_v1 v1;
+	} paging_cmd = {
+		.v2.flags =
 			cpu_to_le32(PAGING_CMD_IS_SECURED |
 				    PAGING_CMD_IS_ENABLED |
 				    (mvm->num_of_pages_in_last_blk <<
 				    PAGING_CMD_NUM_OF_PAGES_IN_LAST_GRP_POS)),
-		.block_size = cpu_to_le32(BLOCK_2_EXP_SIZE),
-		.block_num = cpu_to_le32(mvm->num_of_paging_blk),
+		.v2.block_size = cpu_to_le32(BLOCK_2_EXP_SIZE),
+		.v2.block_num = cpu_to_le32(mvm->num_of_paging_blk),
 	};
-	int blk_idx, size = sizeof(paging_cmd);
+	int blk_idx, size = sizeof(paging_cmd.v2);
 
 	/* A bit hard coded - but this is the old API and will be deprecated */
 	if (!iwl_mvm_has_new_tx_api(mvm))
-		size -= NUM_OF_FW_PAGING_BLOCKS * 4;
+		size = sizeof(paging_cmd.v1);
 
 	/* loop for for all paging blocks + CSS block */
 	for (blk_idx = 0; blk_idx < mvm->num_of_paging_blk + 1; blk_idx++) {
@@ -408,11 +411,11 @@ static int iwl_send_paging_cmd(struct iwl_mvm *mvm, const struct fw_img *fw)
 		if (iwl_mvm_has_new_tx_api(mvm)) {
 			__le64 phy_addr = cpu_to_le64(addr);
 
-			paging_cmd.device_phy_addr.addr64[blk_idx] = phy_addr;
+			paging_cmd.v2.device_phy_addr[blk_idx] = phy_addr;
 		} else {
 			__le32 phy_addr = cpu_to_le32(addr);
 
-			paging_cmd.device_phy_addr.addr32[blk_idx] = phy_addr;
+			paging_cmd.v1.device_phy_addr[blk_idx] = phy_addr;
 		}
 	}
 
-- 
2.11.0
