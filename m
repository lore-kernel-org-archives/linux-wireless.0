Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:54457 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754573AbaEORE5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2014 13:04:57 -0400
Received: by mail-we0-f182.google.com with SMTP id t60so1404173wes.27
        for <linux-wireless@vger.kernel.org>; Thu, 15 May 2014 10:04:56 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eran Harary <eran.harary@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 03/24] iwlwifi: 8000: add default NVM file name in family 8000
Date: Thu, 15 May 2014 20:04:20 +0300
Message-Id: <1400173481-9047-3-git-send-email-egrumbach@gmail.com> (sfid-20140515_190503_871659_76105C93)
In-Reply-To: <5374F373.6040902@gmail.com>
References: <5374F373.6040902@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eran Harary <eran.harary@intel.com>

The 8000 family products need a file on the file system
which is used as NVM. This file is a must, if no filename
is supplied as module parameter, use a default filename.

Signed-off-by: Eran Harary <eran.harary@intel.com>
Reviewed-by: Dor Shaish <dor.shaish@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-8000.c   |  3 +++
 drivers/net/wireless/iwlwifi/iwl-config.h |  1 +
 drivers/net/wireless/iwlwifi/mvm/fw.c     |  2 +-
 drivers/net/wireless/iwlwifi/mvm/mvm.h    |  1 +
 drivers/net/wireless/iwlwifi/mvm/nvm.c    |  8 ++++----
 drivers/net/wireless/iwlwifi/mvm/ops.c    | 11 ++++++++---
 6 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-8000.c b/drivers/net/wireless/iwlwifi/iwl-8000.c
index b26b68c..51c4153 100644
--- a/drivers/net/wireless/iwlwifi/iwl-8000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-8000.c
@@ -83,6 +83,7 @@
 #define IWL8000_MODULE_FIRMWARE(api) IWL8000_FW_PRE __stringify(api) ".ucode"
 
 #define NVM_HW_SECTION_NUM_FAMILY_8000		10
+#define DEFAULT_NVM_FILE_FAMILY_8000		"iwl_nvm_8000.bin"
 
 static const struct iwl_base_params iwl8000_base_params = {
 	.eeprom_size = OTP_LOW_IMAGE_SIZE_FAMILY_8000,
@@ -118,6 +119,7 @@ const struct iwl_cfg iwl8260_2ac_cfg = {
 	.ht_params = &iwl8000_ht_params,
 	.nvm_ver = IWL8000_NVM_VERSION,
 	.nvm_calib_ver = IWL8000_TX_POWER_VERSION,
+	.default_nvm_file = DEFAULT_NVM_FILE_FAMILY_8000,
 };
 
 const struct iwl_cfg iwl8260_n_cfg = {
@@ -127,6 +129,7 @@ const struct iwl_cfg iwl8260_n_cfg = {
 	.ht_params = &iwl8000_ht_params,
 	.nvm_ver = IWL8000_NVM_VERSION,
 	.nvm_calib_ver = IWL8000_TX_POWER_VERSION,
+	.default_nvm_file = DEFAULT_NVM_FILE_FAMILY_8000,
 };
 
 MODULE_FIRMWARE(IWL8000_MODULE_FIRMWARE(IWL8000_UCODE_API_OK));
diff --git a/drivers/net/wireless/iwlwifi/iwl-config.h b/drivers/net/wireless/iwlwifi/iwl-config.h
index 97f23d6..8a62068 100644
--- a/drivers/net/wireless/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/iwlwifi/iwl-config.h
@@ -275,6 +275,7 @@ struct iwl_cfg {
 	bool lp_xtal_workaround;
 	const struct iwl_pwr_tx_backoff *pwr_tx_backoffs;
 	bool no_power_up_nic_in_init;
+	const char *default_nvm_file;
 };
 
 /*
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw.c b/drivers/net/wireless/iwlwifi/mvm/fw.c
index 34ae3f3..7ec2dfe 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/iwlwifi/mvm/fw.c
@@ -303,7 +303,7 @@ int iwl_run_init_mvm_ucode(struct iwl_mvm *mvm, bool read_nvm)
 	}
 
 	/* In case we read the NVM from external file, load it to the NIC */
-	if (iwlwifi_mod_params.nvm_file)
+	if (mvm->nvm_file_name)
 		iwl_mvm_load_nvm_to_nic(mvm);
 
 	ret = iwl_nvm_check_version(mvm->nvm_data, mvm->trans);
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 1e468c3..a4909f3 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -501,6 +501,7 @@ struct iwl_mvm {
 	u8 queue_to_mac80211[IWL_MAX_HW_QUEUES];
 	atomic_t queue_stop_count[IWL_MAX_HW_QUEUES];
 
+	const char *nvm_file_name;
 	struct iwl_nvm_data *nvm_data;
 	/* NVM sections */
 	struct iwl_nvm_section nvm_sections[NVM_MAX_NUM_SECTIONS];
diff --git a/drivers/net/wireless/iwlwifi/mvm/nvm.c b/drivers/net/wireless/iwlwifi/mvm/nvm.c
index 6b88c29..8dafca6 100644
--- a/drivers/net/wireless/iwlwifi/mvm/nvm.c
+++ b/drivers/net/wireless/iwlwifi/mvm/nvm.c
@@ -318,16 +318,16 @@ static int iwl_mvm_read_external_nvm(struct iwl_mvm *mvm)
 	 * get here after that we assume the NVM request can be satisfied
 	 * synchronously.
 	 */
-	ret = request_firmware(&fw_entry, iwlwifi_mod_params.nvm_file,
+	ret = request_firmware(&fw_entry, mvm->nvm_file_name,
 			       mvm->trans->dev);
 	if (ret) {
 		IWL_ERR(mvm, "ERROR: %s isn't available %d\n",
-			iwlwifi_mod_params.nvm_file, ret);
+			mvm->nvm_file_name, ret);
 		return ret;
 	}
 
 	IWL_INFO(mvm, "Loaded NVM file %s (%zu bytes)\n",
-		 iwlwifi_mod_params.nvm_file, fw_entry->size);
+		 mvm->nvm_file_name, fw_entry->size);
 
 	if (fw_entry->size < sizeof(*file_sec)) {
 		IWL_ERR(mvm, "NVM file too small\n");
@@ -513,7 +513,7 @@ int iwl_nvm_init(struct iwl_mvm *mvm, bool read_nvm_from_nic)
 	}
 
 	/* load external NVM if configured */
-	if (iwlwifi_mod_params.nvm_file) {
+	if (mvm->nvm_file_name) {
 		/* move to External NVM flow */
 		ret = iwl_mvm_read_external_nvm(mvm);
 		if (ret)
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index f8530b3..e844f0e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -466,8 +466,13 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 
 	min_backoff = calc_min_backoff(trans, cfg);
 	iwl_mvm_tt_initialize(mvm, min_backoff);
+	/* set the nvm_file_name according to priority */
+	if (iwlwifi_mod_params.nvm_file)
+		mvm->nvm_file_name = iwlwifi_mod_params.nvm_file;
+	else
+		mvm->nvm_file_name = mvm->cfg->default_nvm_file;
 
-	if (WARN(cfg->no_power_up_nic_in_init && !iwlwifi_mod_params.nvm_file,
+	if (WARN(cfg->no_power_up_nic_in_init && !mvm->nvm_file_name,
 		 "not allowing power-up and not having nvm_file\n"))
 		goto out_free;
 
@@ -477,7 +482,7 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	 * and not in the file.
 	 * for nics with no_power_up_nic_in_init: rely completley on nvm_file
 	 */
-	if (cfg->no_power_up_nic_in_init && iwlwifi_mod_params.nvm_file) {
+	if (cfg->no_power_up_nic_in_init && mvm->nvm_file_name) {
 		err = iwl_nvm_init(mvm, false);
 		if (err)
 			goto out_free;
@@ -525,7 +530,7 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
  out_free:
 	iwl_phy_db_free(mvm->phy_db);
 	kfree(mvm->scan_cmd);
-	if (!cfg->no_power_up_nic_in_init || !iwlwifi_mod_params.nvm_file)
+	if (!cfg->no_power_up_nic_in_init || !mvm->nvm_file_name)
 		iwl_trans_op_mode_leave(trans);
 	ieee80211_free_hw(mvm->hw);
 	return NULL;
-- 
1.8.3.2

