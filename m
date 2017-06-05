Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:59270 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751340AbdFEUmh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Jun 2017 16:42:37 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Mon,  5 Jun 2017 23:41:58 +0300
Message-Id: <20170605204218.30151-6-luca@coelho.fi> (sfid-20170605_224243_078075_79024DCA)
In-Reply-To: <20170605204218.30151-1-luca@coelho.fi>
References: <20170605204218.30151-1-luca@coelho.fi>
Subject: [PATCH 05/25] iwlwifi: remove references to 8000 B-step devices
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

We don't have any 8000 B-step right now, and there is no
firmware loading code for them anyway.
Further more, 9000 B-step devices will hit those code paths.
Remove code that was introduced only for 8000 B-step.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-8000.c   |  2 --
 drivers/net/wireless/intel/iwlwifi/iwl-config.h |  1 -
 drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c | 21 ---------------------
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c    | 14 ++------------
 4 files changed, 2 insertions(+), 36 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-8000.c b/drivers/net/wireless/intel/iwlwifi/iwl-8000.c
index 502956b0ee91..4d6135b5ff92 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-8000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-8000.c
@@ -98,7 +98,6 @@
 	IWL8265_FW_PRE __stringify(api) ".ucode"
 
 #define NVM_HW_SECTION_NUM_FAMILY_8000		10
-#define DEFAULT_NVM_FILE_FAMILY_8000B		"nvmData-8000B"
 #define DEFAULT_NVM_FILE_FAMILY_8000C		"nvmData-8000C"
 
 /* Max SDIO RX/TX aggregation sizes of the ADDBA request/response */
@@ -162,7 +161,6 @@ static const struct iwl_tt_params iwl8000_tt_params = {
 	.dccm2_len = IWL8260_DCCM2_LEN,					\
 	.smem_offset = IWL8260_SMEM_OFFSET,				\
 	.smem_len = IWL8260_SMEM_LEN,					\
-	.default_nvm_file_B_step = DEFAULT_NVM_FILE_FAMILY_8000B,	\
 	.default_nvm_file_C_step = DEFAULT_NVM_FILE_FAMILY_8000C,	\
 	.thermal_params = &iwl8000_tt_params,				\
 	.apmg_not_supported = true,					\
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index f0273ebd29d8..5b0f1d65d199 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -335,7 +335,6 @@ struct iwl_cfg {
 	const struct iwl_ht_params *ht_params;
 	const struct iwl_eeprom_params *eeprom_params;
 	const struct iwl_pwr_tx_backoff *pwr_tx_backoffs;
-	const char *default_nvm_file_B_step;
 	const char *default_nvm_file_C_step;
 	const struct iwl_tt_params *thermal_params;
 	enum iwl_device_family device_family;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
index d8b592aa362c..8aa2992e1427 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
@@ -705,14 +705,6 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 			   sizeof(*dump_info);
 	}
 
-	/*
-	 * In 8000 HW family B-step include the ICCM (which resides separately)
-	 */
-	if (mvm->cfg->device_family == IWL_DEVICE_FAMILY_8000 &&
-	    CSR_HW_REV_STEP(mvm->trans->hw_rev) == SILICON_B_STEP)
-		file_len += sizeof(*dump_data) + sizeof(*dump_mem) +
-			    IWL8260_ICCM_LEN;
-
 	if (mvm->fw_dump_desc)
 		file_len += sizeof(*dump_data) + sizeof(*dump_trig) +
 			    mvm->fw_dump_desc->len;
@@ -837,19 +829,6 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 		dump_data = iwl_fw_error_next_data(dump_data);
 	}
 
-	if (mvm->cfg->device_family == IWL_DEVICE_FAMILY_8000 &&
-	    CSR_HW_REV_STEP(mvm->trans->hw_rev) == SILICON_B_STEP) {
-		dump_data->type = cpu_to_le32(IWL_FW_ERROR_DUMP_MEM);
-		dump_data->len = cpu_to_le32(IWL8260_ICCM_LEN +
-					     sizeof(*dump_mem));
-		dump_mem = (void *)dump_data->data;
-		dump_mem->type = cpu_to_le32(IWL_FW_ERROR_DUMP_MEM_SRAM);
-		dump_mem->offset = cpu_to_le32(IWL8260_ICCM_OFFSET);
-		iwl_trans_read_mem_bytes(mvm->trans, IWL8260_ICCM_OFFSET,
-					 dump_mem->data, IWL8260_ICCM_LEN);
-		dump_data = iwl_fw_error_next_data(dump_data);
-	}
-
 	/* Dump fw's virtual image */
 	if (!mvm->trans->cfg->gen2 &&
 	    mvm->fw->img[mvm->cur_ucode].paging_mem_size &&
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c b/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
index e7631a9620bf..30ecbc14b3d0 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
@@ -448,9 +448,7 @@ int iwl_mvm_read_external_nvm(struct iwl_mvm *mvm)
 
 		/* nvm file validation, dword_buff[2] holds the file version */
 		if ((CSR_HW_REV_STEP(mvm->trans->hw_rev) == SILICON_C_STEP &&
-		     le32_to_cpu(dword_buff[2]) < 0xE4A) ||
-		    (CSR_HW_REV_STEP(mvm->trans->hw_rev) == SILICON_B_STEP &&
-		     le32_to_cpu(dword_buff[2]) >= 0xE4A)) {
+		     le32_to_cpu(dword_buff[2]) < 0xE4A)) {
 			ret = -EFAULT;
 			goto out;
 		}
@@ -644,7 +642,6 @@ int iwl_nvm_init(struct iwl_mvm *mvm, bool read_nvm_from_nic)
 	int ret, section;
 	u32 size_read = 0;
 	u8 *nvm_buffer, *temp;
-	const char *nvm_file_B = mvm->cfg->default_nvm_file_B_step;
 	const char *nvm_file_C = mvm->cfg->default_nvm_file_C_step;
 
 	if (WARN_ON_ONCE(mvm->cfg->nvm_hw_section_num >= NVM_MAX_NUM_SECTIONS))
@@ -714,14 +711,7 @@ int iwl_nvm_init(struct iwl_mvm *mvm, bool read_nvm_from_nic)
 		/* read External NVM file from the mod param */
 		ret = iwl_mvm_read_external_nvm(mvm);
 		if (ret) {
-			/* choose the nvm_file name according to the
-			 * HW step
-			 */
-			if (CSR_HW_REV_STEP(mvm->trans->hw_rev) ==
-			    SILICON_B_STEP)
-				mvm->nvm_file_name = nvm_file_B;
-			else
-				mvm->nvm_file_name = nvm_file_C;
+			mvm->nvm_file_name = nvm_file_C;
 
 			if ((ret == -EFAULT || ret == -ENOENT) &&
 			    mvm->nvm_file_name) {
-- 
2.11.0
