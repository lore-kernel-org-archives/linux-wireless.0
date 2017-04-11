Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:50540 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753729AbdDKMiA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Apr 2017 08:38:00 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 11 Apr 2017 15:37:21 +0300
Message-Id: <20170411123742.12214-5-luca@coelho.fi> (sfid-20170411_143807_029945_40E6B1F1)
In-Reply-To: <20170411123742.12214-1-luca@coelho.fi>
References: <20170411123742.12214-1-luca@coelho.fi>
Subject: [PATCH 04/25] iwlwifi: remove support for deprecated RF
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

One of the RF modules we support has been deprecated and never
released publicly.  Remove support for this module.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-9000.c   | 19 -------------------
 drivers/net/wireless/intel/iwlwifi/iwl-config.h |  1 -
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h    |  1 -
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c   | 17 +++++------------
 4 files changed, 5 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-9000.c b/drivers/net/wireless/intel/iwlwifi/iwl-9000.c
index a5f0c0bf85ec..ca119bd8a32b 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-9000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-9000.c
@@ -74,13 +74,10 @@
 
 #define  IWL9000_FW_PRE "iwlwifi-9000-pu-a0-jf-a0-"
 #define  IWL9260_FW_PRE "iwlwifi-9260-th-a0-jf-a0-"
-#define  IWL9000LC_FW_PRE "iwlwifi-9000-pu-a0-lc-a0-"
 #define IWL9000_MODULE_FIRMWARE(api) \
 	IWL9000_FW_PRE "-" __stringify(api) ".ucode"
 #define IWL9260_MODULE_FIRMWARE(api) \
 	IWL9260_FW_PRE "-" __stringify(api) ".ucode"
-#define IWL9000LC_MODULE_FIRMWARE(api) \
-	IWL9000LC_FW_PRE "-" __stringify(api) ".ucode"
 
 #define NVM_HW_SECTION_NUM_FAMILY_9000		10
 
@@ -198,21 +195,5 @@ const struct iwl_cfg iwl9560_2ac_cfg = {
 	.integrated = true,
 };
 
-/*
- * TODO the struct below is for internal testing only this should be
- * removed by EO 2016~
- */
-const struct iwl_cfg iwl9000lc_2ac_cfg = {
-	.name = "Intel(R) Dual Band Wireless AC 9000",
-	.fw_name_pre = IWL9000LC_FW_PRE,
-	IWL_DEVICE_9000,
-	.ht_params = &iwl9000_ht_params,
-	.nvm_ver = IWL9000_NVM_VERSION,
-	.nvm_calib_ver = IWL9000_TX_POWER_VERSION,
-	.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
-	.integrated = true,
-};
-
 MODULE_FIRMWARE(IWL9000_MODULE_FIRMWARE(IWL9000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL9260_MODULE_FIRMWARE(IWL9000_UCODE_API_MAX));
-MODULE_FIRMWARE(IWL9000LC_MODULE_FIRMWARE(IWL9000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index 94f8a51b633e..96a2ec32f707 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -449,7 +449,6 @@ extern const struct iwl_cfg iwl4165_2ac_cfg;
 extern const struct iwl_cfg iwl8260_2ac_sdio_cfg;
 extern const struct iwl_cfg iwl8265_2ac_sdio_cfg;
 extern const struct iwl_cfg iwl4165_2ac_sdio_cfg;
-extern const struct iwl_cfg iwl9000lc_2ac_cfg;
 extern const struct iwl_cfg iwl9160_2ac_cfg;
 extern const struct iwl_cfg iwl9260_2ac_cfg;
 extern const struct iwl_cfg iwl9270_2ac_cfg;
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-csr.h b/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
index 4ee3b621ec27..fa120fb55373 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
@@ -348,7 +348,6 @@ enum {
 
 /* RF_ID value */
 #define CSR_HW_RF_ID_TYPE_JF		(0x00105000)
-#define CSR_HW_RF_ID_TYPE_LC		(0x00101000)
 #define CSR_HW_RF_ID_TYPE_HR		(0x00109000)
 
 /* EEPROM REG */
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index ba8a81cb0e2b..d38fcc1a4768 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -667,18 +667,11 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		iwl_trans->cfg = cfg_7265d;
 	}
 
-	if (iwl_trans->cfg->rf_id) {
-		if (cfg == &iwl9460_2ac_cfg &&
-		    iwl_trans->hw_rf_id == CSR_HW_RF_ID_TYPE_LC) {
-			cfg = &iwl9000lc_2ac_cfg;
-			iwl_trans->cfg = cfg;
-		}
-
-		if (cfg == &iwla000_2ac_cfg_hr &&
-		    iwl_trans->hw_rf_id == CSR_HW_RF_ID_TYPE_JF) {
-			cfg = &iwla000_2ac_cfg_jf;
-			iwl_trans->cfg = cfg;
-		}
+	if (iwl_trans->cfg->rf_id &&
+	    (cfg == &iwla000_2ac_cfg_hr &&
+	     iwl_trans->hw_rf_id == CSR_HW_RF_ID_TYPE_JF)) {
+		cfg = &iwla000_2ac_cfg_jf;
+		iwl_trans->cfg = cfg;
 	}
 #endif
 
-- 
2.11.0
