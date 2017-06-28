Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:35954 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751518AbdF1UPD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Jun 2017 16:15:03 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 28 Jun 2017 23:13:26 +0300
Message-Id: <20170628201330.9432-28-luca@coelho.fi> (sfid-20170628_221553_965125_5C01F243)
In-Reply-To: <20170628201330.9432-1-luca@coelho.fi>
References: <20170628201330.9432-1-luca@coelho.fi>
Subject: [PATCH 27/31] iwlwifi: mvm: rename iwl_shared_mem_cfg_v1 to the correct _v2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This structure represents V2, V1 has the three last fields missing.
Rename it to be more accurate.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h | 6 +++---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c     | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
index 17475e269ef5..f3ca61ff9f58 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
@@ -724,7 +724,7 @@ enum iwl_system_subcmd_ids {
 	/**
 	 * @SHARED_MEM_CFG_CMD:
 	 * response in &struct iwl_shared_mem_cfg or
-	 * &struct iwl_shared_mem_cfg_v1
+	 * &struct iwl_shared_mem_cfg_v2
 	 */
 	SHARED_MEM_CFG_CMD = 0x0,
 
@@ -2546,7 +2546,7 @@ struct iwl_tdls_config_res {
 #define TX_FIFO_INTERNAL_MAX_NUM	6
 
 /**
- * struct iwl_shared_mem_cfg_v1 - Shared memory configuration information
+ * struct iwl_shared_mem_cfg_v2 - Shared memory configuration information
  *
  * @shared_mem_addr: shared memory addr (pre 8000 HW set to 0x0 as MARBH is not
  *	accessible)
@@ -2568,7 +2568,7 @@ struct iwl_tdls_config_res {
  * NOTE: on firmware that don't have IWL_UCODE_TLV_CAPA_EXTEND_SHARED_MEM_CFG
  *	 set, the last 3 members don't exist.
  */
-struct iwl_shared_mem_cfg_v1 {
+struct iwl_shared_mem_cfg_v2 {
 	__le32 shared_mem_addr;
 	__le32 shared_mem_size;
 	__le32 sample_buff_addr;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 07308912486a..c5445be36701 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -955,7 +955,7 @@ static void iwl_mvm_parse_shared_mem_a000(struct iwl_mvm *mvm,
 static void iwl_mvm_parse_shared_mem(struct iwl_mvm *mvm,
 				     struct iwl_rx_packet *pkt)
 {
-	struct iwl_shared_mem_cfg_v1 *mem_cfg = (void *)pkt->data;
+	struct iwl_shared_mem_cfg_v2 *mem_cfg = (void *)pkt->data;
 	int i;
 
 	mvm->smem_cfg.num_lmacs = 1;
-- 
2.11.0
