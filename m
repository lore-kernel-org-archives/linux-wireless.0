Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:36105 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbaEGTxu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 15:53:50 -0400
Received: by mail-wg0-f47.google.com with SMTP id x12so1480739wgg.6
        for <linux-wireless@vger.kernel.org>; Wed, 07 May 2014 12:53:49 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eran Harary <eran.harary@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 11/23] iwlwifi: mvm: prevent nic to powered up at driver load
Date: Wed,  7 May 2014 22:52:48 +0300
Message-Id: <1399492380-12050-11-git-send-email-egrumbach@gmail.com> (sfid-20140507_215437_262005_1E703B08)
In-Reply-To: <536A8EE3.2050906@gmail.com>
References: <536A8EE3.2050906@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eran Harary <eran.harary@intel.com>

A few devices aren't allowed to be powered up at driver
load time. Add "power_up_nic_in_init" flag to iwl_cfg
structure to customize the load flow according to the
device.

Signed-off-by: Eran Harary <eran.harary@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-config.h |  1 +
 drivers/net/wireless/iwlwifi/mvm/fw.c     |  2 +-
 drivers/net/wireless/iwlwifi/mvm/mvm.h    |  2 +-
 drivers/net/wireless/iwlwifi/mvm/nvm.c    |  6 ++++--
 drivers/net/wireless/iwlwifi/mvm/ops.c    | 16 +++++++++++-----
 5 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-config.h b/drivers/net/wireless/iwlwifi/iwl-config.h
index b73eac9..97f23d6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/iwlwifi/iwl-config.h
@@ -274,6 +274,7 @@ struct iwl_cfg {
 	u8   nvm_hw_section_num;
 	bool lp_xtal_workaround;
 	const struct iwl_pwr_tx_backoff *pwr_tx_backoffs;
+	bool no_power_up_nic_in_init;
 };
 
 /*
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw.c b/drivers/net/wireless/iwlwifi/mvm/fw.c
index 3d99cf5..34ae3f3 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/iwlwifi/mvm/fw.c
@@ -295,7 +295,7 @@ int iwl_run_init_mvm_ucode(struct iwl_mvm *mvm, bool read_nvm)
 	/* Read the NVM only at driver load time, no need to do this twice */
 	if (read_nvm) {
 		/* Read nvm */
-		ret = iwl_nvm_init(mvm);
+		ret = iwl_nvm_init(mvm, true);
 		if (ret) {
 			IWL_ERR(mvm, "Failed to read NVM: %d\n", ret);
 			goto error;
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 17c42da..b52d1c9 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -757,7 +757,7 @@ int iwl_mvm_rx_statistics(struct iwl_mvm *mvm,
 			  struct iwl_device_cmd *cmd);
 
 /* NVM */
-int iwl_nvm_init(struct iwl_mvm *mvm);
+int iwl_nvm_init(struct iwl_mvm *mvm, bool read_nvm_from_nic);
 int iwl_mvm_load_nvm_to_nic(struct iwl_mvm *mvm);
 
 int iwl_mvm_up(struct iwl_mvm *mvm);
diff --git a/drivers/net/wireless/iwlwifi/mvm/nvm.c b/drivers/net/wireless/iwlwifi/mvm/nvm.c
index 4092422..fe4c91e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/nvm.c
+++ b/drivers/net/wireless/iwlwifi/mvm/nvm.c
@@ -427,7 +427,7 @@ int iwl_mvm_load_nvm_to_nic(struct iwl_mvm *mvm)
 	return ret;
 }
 
-int iwl_nvm_init(struct iwl_mvm *mvm)
+int iwl_nvm_init(struct iwl_mvm *mvm, bool read_nvm_from_nic)
 {
 	int ret, i, section;
 	u8 *nvm_buffer, *temp;
@@ -443,7 +443,9 @@ int iwl_nvm_init(struct iwl_mvm *mvm)
 		ret = iwl_mvm_read_external_nvm(mvm);
 		if (ret)
 			return ret;
-	} else {
+	}
+
+	if (read_nvm_from_nic) {
 		/* list of NVM sections we are allowed/need to read */
 		if (mvm->trans->cfg->device_family != IWL_DEVICE_FAMILY_8000) {
 			nvm_to_read[0] = mvm->cfg->nvm_hw_section_num;
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 7a5a8ba..3c14ea1 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -467,12 +467,18 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	min_backoff = calc_min_backoff(trans, cfg);
 	iwl_mvm_tt_initialize(mvm, min_backoff);
 
+	if (WARN(cfg->no_power_up_nic_in_init && !iwlwifi_mod_params.nvm_file,
+		 "not allowing power-up and not having nvm_file\n"))
+		goto out_free;
+
 	/*
-	 * If the NVM exists in an external file,
-	 * there is no need to unnecessarily power up the NIC at driver load
+	 * Even if nvm exists in the nvm_file driver should read agin the nvm
+	 * from the nic because there might be entries that exist in the OTP
+	 * and not in the file.
+	 * for nics with no_power_up_nic_in_init: rely completley on nvm_file
 	 */
-	if (iwlwifi_mod_params.nvm_file) {
-		err = iwl_nvm_init(mvm);
+	if (cfg->no_power_up_nic_in_init && iwlwifi_mod_params.nvm_file) {
+		err = iwl_nvm_init(mvm, false);
 		if (err)
 			goto out_free;
 	} else {
@@ -519,7 +525,7 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
  out_free:
 	iwl_phy_db_free(mvm->phy_db);
 	kfree(mvm->scan_cmd);
-	if (!iwlwifi_mod_params.nvm_file)
+	if (!cfg->no_power_up_nic_in_init || !iwlwifi_mod_params.nvm_file)
 		iwl_trans_op_mode_leave(trans);
 	ieee80211_free_hw(mvm->hw);
 	return NULL;
-- 
1.8.3.2

