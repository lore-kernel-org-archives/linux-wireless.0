Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:44672 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751695AbdHRPxE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Aug 2017 11:53:04 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 18 Aug 2017 18:49:20 +0300
Message-Id: <20170818154922.2904-23-luca@coelho.fi> (sfid-20170818_175307_252294_57BF5A73)
In-Reply-To: <20170818154922.2904-1-luca@coelho.fi>
References: <20170818154922.2904-1-luca@coelho.fi>
Subject: [PATCH 22/24] iwlwifi: mvm: remove useless argument in iwl_nvm_init()
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

We always call iwl_nvm_init() with read_nvm_from_nic == true, so this
argument is useless.  Remove it.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c  |  5 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c | 98 ++++++++++++++--------------
 3 files changed, 51 insertions(+), 54 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 90ae50f7768a..3d65ab49a8a6 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -388,7 +388,7 @@ static int iwl_run_unified_mvm_ucode(struct iwl_mvm *mvm, bool read_nvm)
 	}
 
 	if (IWL_MVM_PARSE_NVM && read_nvm) {
-		ret = iwl_nvm_init(mvm, true);
+		ret = iwl_nvm_init(mvm);
 		if (ret) {
 			IWL_ERR(mvm, "Failed to read NVM: %d\n", ret);
 			goto error;
@@ -486,8 +486,7 @@ int iwl_run_init_mvm_ucode(struct iwl_mvm *mvm, bool read_nvm)
 
 	/* Read the NVM only at driver load time, no need to do this twice */
 	if (read_nvm) {
-		/* Read nvm */
-		ret = iwl_nvm_init(mvm, true);
+		ret = iwl_nvm_init(mvm);
 		if (ret) {
 			IWL_ERR(mvm, "Failed to read NVM: %d\n", ret);
 			goto remove_notif;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 74fdd33fd9fb..83303bac0e4b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1373,7 +1373,7 @@ int iwl_mvm_request_statistics(struct iwl_mvm *mvm, bool clear);
 void iwl_mvm_accu_radio_stats(struct iwl_mvm *mvm);
 
 /* NVM */
-int iwl_nvm_init(struct iwl_mvm *mvm, bool read_nvm_from_nic);
+int iwl_nvm_init(struct iwl_mvm *mvm);
 int iwl_mvm_load_nvm_to_nic(struct iwl_mvm *mvm);
 int iwl_mvm_read_external_nvm(struct iwl_mvm *mvm);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c b/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
index 08020386c3d4..5a6916f0b9ec 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
@@ -546,7 +546,7 @@ int iwl_mvm_load_nvm_to_nic(struct iwl_mvm *mvm)
 	return ret;
 }
 
-int iwl_nvm_init(struct iwl_mvm *mvm, bool read_nvm_from_nic)
+int iwl_nvm_init(struct iwl_mvm *mvm)
 {
 	int ret, section;
 	u32 size_read = 0;
@@ -557,63 +557,61 @@ int iwl_nvm_init(struct iwl_mvm *mvm, bool read_nvm_from_nic)
 		return -EINVAL;
 
 	/* load NVM values from nic */
-	if (read_nvm_from_nic) {
-		/* Read From FW NVM */
-		IWL_DEBUG_EEPROM(mvm->trans->dev, "Read from NVM\n");
-
-		nvm_buffer = kmalloc(mvm->cfg->base_params->eeprom_size,
-				     GFP_KERNEL);
-		if (!nvm_buffer)
-			return -ENOMEM;
-		for (section = 0; section < NVM_MAX_NUM_SECTIONS; section++) {
-			/* we override the constness for initial read */
-			ret = iwl_nvm_read_section(mvm, section, nvm_buffer,
-						   size_read);
-			if (ret < 0)
-				continue;
-			size_read += ret;
-			temp = kmemdup(nvm_buffer, ret, GFP_KERNEL);
-			if (!temp) {
-				ret = -ENOMEM;
-				break;
-			}
+	/* Read From FW NVM */
+	IWL_DEBUG_EEPROM(mvm->trans->dev, "Read from NVM\n");
+
+	nvm_buffer = kmalloc(mvm->cfg->base_params->eeprom_size,
+			     GFP_KERNEL);
+	if (!nvm_buffer)
+		return -ENOMEM;
+	for (section = 0; section < NVM_MAX_NUM_SECTIONS; section++) {
+		/* we override the constness for initial read */
+		ret = iwl_nvm_read_section(mvm, section, nvm_buffer,
+					   size_read);
+		if (ret < 0)
+			continue;
+		size_read += ret;
+		temp = kmemdup(nvm_buffer, ret, GFP_KERNEL);
+		if (!temp) {
+			ret = -ENOMEM;
+			break;
+		}
 
-			iwl_mvm_nvm_fixups(mvm, section, temp, ret);
+		iwl_mvm_nvm_fixups(mvm, section, temp, ret);
 
-			mvm->nvm_sections[section].data = temp;
-			mvm->nvm_sections[section].length = ret;
+		mvm->nvm_sections[section].data = temp;
+		mvm->nvm_sections[section].length = ret;
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
-			switch (section) {
-			case NVM_SECTION_TYPE_SW:
-				mvm->nvm_sw_blob.data = temp;
-				mvm->nvm_sw_blob.size  = ret;
-				break;
-			case NVM_SECTION_TYPE_CALIBRATION:
-				mvm->nvm_calib_blob.data = temp;
-				mvm->nvm_calib_blob.size  = ret;
-				break;
-			case NVM_SECTION_TYPE_PRODUCTION:
-				mvm->nvm_prod_blob.data = temp;
-				mvm->nvm_prod_blob.size  = ret;
-				break;
-			case NVM_SECTION_TYPE_PHY_SKU:
-				mvm->nvm_phy_sku_blob.data = temp;
-				mvm->nvm_phy_sku_blob.size  = ret;
+		switch (section) {
+		case NVM_SECTION_TYPE_SW:
+			mvm->nvm_sw_blob.data = temp;
+			mvm->nvm_sw_blob.size  = ret;
+			break;
+		case NVM_SECTION_TYPE_CALIBRATION:
+			mvm->nvm_calib_blob.data = temp;
+			mvm->nvm_calib_blob.size  = ret;
+			break;
+		case NVM_SECTION_TYPE_PRODUCTION:
+			mvm->nvm_prod_blob.data = temp;
+			mvm->nvm_prod_blob.size  = ret;
+			break;
+		case NVM_SECTION_TYPE_PHY_SKU:
+			mvm->nvm_phy_sku_blob.data = temp;
+			mvm->nvm_phy_sku_blob.size  = ret;
+			break;
+		default:
+			if (section == mvm->cfg->nvm_hw_section_num) {
+				mvm->nvm_hw_blob.data = temp;
+				mvm->nvm_hw_blob.size = ret;
 				break;
-			default:
-				if (section == mvm->cfg->nvm_hw_section_num) {
-					mvm->nvm_hw_blob.data = temp;
-					mvm->nvm_hw_blob.size = ret;
-					break;
-				}
 			}
-#endif
 		}
-		if (!size_read)
-			IWL_ERR(mvm, "OTP is blank\n");
-		kfree(nvm_buffer);
+#endif
 	}
+	if (!size_read)
+		IWL_ERR(mvm, "OTP is blank\n");
+	kfree(nvm_buffer);
 
 	/* Only if PNVM selected in the mod param - load external NVM  */
 	if (mvm->nvm_file_name) {
-- 
2.14.1
