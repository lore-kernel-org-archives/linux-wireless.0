Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:40007 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752381AbbDBGmW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Apr 2015 02:42:22 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Eran Harary <eran.harary@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 17/31] iwlwifi: 8000: change PNVM in case it doesn't match to the HW step
Date: Thu,  2 Apr 2015 09:41:05 +0300
Message-Id: <1427956879-11725-17-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150402_090420_610683_E7A34044)
In-Reply-To: <1427956656.8122.2.camel@egrumbacBox>
References: <1427956656.8122.2.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eran Harary <eran.harary@intel.com>

There is a strong relationship between the NVM version and
the hardware step. Enforce that in the driver in case the
default NVM on the platform is the wrong one.

Signed-off-by: Eran Harary <eran.harary@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-8000.c   |  9 +++++---
 drivers/net/wireless/iwlwifi/iwl-config.h |  3 ++-
 drivers/net/wireless/iwlwifi/mvm/nvm.c    | 34 ++++++++++++++++++++++++++++---
 drivers/net/wireless/iwlwifi/mvm/ops.c    | 10 ++++++---
 4 files changed, 46 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-8000.c b/drivers/net/wireless/iwlwifi/iwl-8000.c
index 4ef50cf..ce6321b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-8000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-8000.c
@@ -94,7 +94,8 @@
 	IWL8000_FW_PRE "-" __stringify(api) ".ucode"
 
 #define NVM_HW_SECTION_NUM_FAMILY_8000		10
-#define DEFAULT_NVM_FILE_FAMILY_8000		"iwl_nvm_8000B.bin"
+#define DEFAULT_NVM_FILE_FAMILY_8000B		"nvmData-8000B"
+#define DEFAULT_NVM_FILE_FAMILY_8000C		"nvmData-8000C"
 
 /* Max SDIO RX aggregation size of the ADDBA request/response */
 #define MAX_RX_AGG_SIZE_8260_SDIO	28
@@ -176,7 +177,8 @@ const struct iwl_cfg iwl8260_2ac_sdio_cfg = {
 	.ht_params = &iwl8000_ht_params,
 	.nvm_ver = IWL8000_NVM_VERSION,
 	.nvm_calib_ver = IWL8000_TX_POWER_VERSION,
-	.default_nvm_file = DEFAULT_NVM_FILE_FAMILY_8000,
+	.default_nvm_file_B_step = DEFAULT_NVM_FILE_FAMILY_8000B,
+	.default_nvm_file_C_step = DEFAULT_NVM_FILE_FAMILY_8000C,
 	.max_rx_agg_size = MAX_RX_AGG_SIZE_8260_SDIO,
 	.disable_dummy_notification = true,
 	.max_ht_ampdu_exponent  = MAX_HT_AMPDU_EXPONENT_8260_SDIO,
@@ -190,7 +192,8 @@ const struct iwl_cfg iwl4165_2ac_sdio_cfg = {
 	.ht_params = &iwl8000_ht_params,
 	.nvm_ver = IWL8000_NVM_VERSION,
 	.nvm_calib_ver = IWL8000_TX_POWER_VERSION,
-	.default_nvm_file = DEFAULT_NVM_FILE_FAMILY_8000,
+	.default_nvm_file_B_step = DEFAULT_NVM_FILE_FAMILY_8000B,
+	.default_nvm_file_C_step = DEFAULT_NVM_FILE_FAMILY_8000C,
 	.max_rx_agg_size = MAX_RX_AGG_SIZE_8260_SDIO,
 	.bt_shared_single_ant = true,
 	.disable_dummy_notification = true,
diff --git a/drivers/net/wireless/iwlwifi/iwl-config.h b/drivers/net/wireless/iwlwifi/iwl-config.h
index aa41c77..bbed8fc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/iwlwifi/iwl-config.h
@@ -303,7 +303,8 @@ struct iwl_cfg {
 	bool lp_xtal_workaround;
 	const struct iwl_pwr_tx_backoff *pwr_tx_backoffs;
 	bool no_power_up_nic_in_init;
-	const char *default_nvm_file;
+	const char *default_nvm_file_B_step;
+	const char *default_nvm_file_C_step;
 	unsigned int max_rx_agg_size;
 	bool disable_dummy_notification;
 	unsigned int max_tx_agg_size;
diff --git a/drivers/net/wireless/iwlwifi/mvm/nvm.c b/drivers/net/wireless/iwlwifi/mvm/nvm.c
index 675197d..524ade2 100644
--- a/drivers/net/wireless/iwlwifi/mvm/nvm.c
+++ b/drivers/net/wireless/iwlwifi/mvm/nvm.c
@@ -418,6 +418,15 @@ static int iwl_mvm_read_external_nvm(struct iwl_mvm *mvm)
 		IWL_INFO(mvm, "NVM Version %08X\n", le32_to_cpu(dword_buff[2]));
 		IWL_INFO(mvm, "NVM Manufacturing date %08X\n",
 			 le32_to_cpu(dword_buff[3]));
+
+		/* nvm file validation, dword_buff[2] holds the file version */
+		if ((CSR_HW_REV_STEP(mvm->trans->hw_rev) == SILICON_C_STEP &&
+		     le32_to_cpu(dword_buff[2]) < 0xE4A) ||
+		    (CSR_HW_REV_STEP(mvm->trans->hw_rev) == SILICON_B_STEP &&
+		     le32_to_cpu(dword_buff[2]) >= 0xE4A)) {
+			ret = -EFAULT;
+			goto out;
+		}
 	} else {
 		file_sec = (void *)fw_entry->data;
 	}
@@ -516,6 +525,8 @@ int iwl_nvm_init(struct iwl_mvm *mvm, bool read_nvm_from_nic)
 	int ret, section;
 	u32 size_read = 0;
 	u8 *nvm_buffer, *temp;
+	const char *nvm_file_B = mvm->cfg->default_nvm_file_B_step;
+	const char *nvm_file_C = mvm->cfg->default_nvm_file_C_step;
 
 	if (WARN_ON_ONCE(mvm->cfg->nvm_hw_section_num >= NVM_MAX_NUM_SECTIONS))
 		return -EINVAL;
@@ -574,10 +585,27 @@ int iwl_nvm_init(struct iwl_mvm *mvm, bool read_nvm_from_nic)
 
 	/* load external NVM if configured */
 	if (mvm->nvm_file_name) {
-		/* move to External NVM flow */
+		/* read External NVM file - take the default */
 		ret = iwl_mvm_read_external_nvm(mvm);
-		if (ret)
-			return ret;
+		if (ret) {
+			/* choose the nvm_file name according to the
+			 * HW step
+			 */
+			if (CSR_HW_REV_STEP(mvm->trans->hw_rev) ==
+			    SILICON_B_STEP)
+				mvm->nvm_file_name = nvm_file_B;
+			else
+				mvm->nvm_file_name = nvm_file_C;
+
+			if (ret == -EFAULT && mvm->nvm_file_name) {
+				/* in case nvm file was failed try again */
+				ret = iwl_mvm_read_external_nvm(mvm);
+				if (ret)
+					return ret;
+			} else {
+				return ret;
+			}
+		}
 	}
 
 	/* parse the relevant nvm sections */
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 388886c..67ed57e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -521,10 +521,14 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	min_backoff = calc_min_backoff(trans, cfg);
 	iwl_mvm_tt_initialize(mvm, min_backoff);
 	/* set the nvm_file_name according to priority */
-	if (iwlwifi_mod_params.nvm_file)
+	if (iwlwifi_mod_params.nvm_file) {
 		mvm->nvm_file_name = iwlwifi_mod_params.nvm_file;
-	else
-		mvm->nvm_file_name = mvm->cfg->default_nvm_file;
+	} else if (trans->cfg->device_family == IWL_DEVICE_FAMILY_8000) {
+		if (CSR_HW_REV_STEP(trans->hw_rev) == SILICON_B_STEP)
+			mvm->nvm_file_name = mvm->cfg->default_nvm_file_B_step;
+		else
+			mvm->nvm_file_name = mvm->cfg->default_nvm_file_C_step;
+	}
 
 	if (WARN(cfg->no_power_up_nic_in_init && !mvm->nvm_file_name,
 		 "not allowing power-up and not having nvm_file\n"))
-- 
1.9.1

