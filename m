Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:52872 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755752AbdDRWWS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Apr 2017 18:22:18 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 19 Apr 2017 01:17:18 +0300
Message-Id: <20170418221729.28372-15-luca@coelho.fi> (sfid-20170419_002221_786575_FCF72187)
In-Reply-To: <20170418221729.28372-1-luca@coelho.fi>
References: <20170418221729.28372-1-luca@coelho.fi>
Subject: [PATCH 14/25] iwlwifi: support a000 CDB product
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Identify and load FW for a000 CDB product.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-a000.c   | 20 ++++++++++++++++----
 drivers/net/wireless/intel/iwlwifi/iwl-config.h |  5 ++++-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c   |  7 ++++---
 3 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-a000.c b/drivers/net/wireless/intel/iwlwifi/iwl-a000.c
index df4e8714d627..1c731b88d08c 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-a000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-a000.c
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2015-2016 Intel Deutschland GmbH
+ * Copyright(c) 2015-2017 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -18,7 +18,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2015-2016 Intel Deutschland GmbH
+ * Copyright(c) 2015-2017 Intel Deutschland GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -72,8 +72,9 @@
 #define IWL_A000_SMEM_OFFSET		0x400000
 #define IWL_A000_SMEM_LEN		0x68000
 
-#define IWL_A000_JF_FW_PRE "iwlwifi-Qu-a0-jf-b0-"
-#define IWL_A000_HR_FW_PRE "iwlwifi-Qu-a0-hr-a0-"
+#define IWL_A000_JF_FW_PRE	"iwlwifi-Qu-a0-jf-b0-"
+#define IWL_A000_HR_FW_PRE	"iwlwifi-Qu-a0-hr-a0-"
+#define IWL_A000_HR_CDB_FW_PRE	"iwlwifi-QuIcp-a0-hrcdb-a0-"
 
 #define IWL_A000_HR_MODULE_FIRMWARE(api) \
 	IWL_A000_HR_FW_PRE "-" __stringify(api) ".ucode"
@@ -134,6 +135,17 @@ const struct iwl_cfg iwla000_2ac_cfg_hr = {
 		.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
 };
 
+const struct iwl_cfg iwla000_2ac_cfg_hr_cdb = {
+		.name = "Intel(R) Dual Band Wireless AC a000",
+		.fw_name_pre = IWL_A000_HR_CDB_FW_PRE,
+		IWL_DEVICE_A000,
+		.ht_params = &iwl_a000_ht_params,
+		.nvm_ver = IWL_A000_NVM_VERSION,
+		.nvm_calib_ver = IWL_A000_TX_POWER_VERSION,
+		.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
+		.cdb = true,
+};
+
 const struct iwl_cfg iwla000_2ac_cfg_jf = {
 		.name = "Intel(R) Dual Band Wireless AC a000",
 		.fw_name_pre = IWL_A000_JF_FW_PRE,
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index 06034a71a190..4af1267181a9 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -314,6 +314,7 @@ struct iwl_pwr_tx_backoff {
  * @rf_id: need to read rf_id to determine the firmware image
  * @integrated: discrete or integrated
  * @gen2: a000 and on transport operation
+ * @cdb: CDB support
  *
  * We enable the driver to be backward compatible wrt. hardware features.
  * API differences in uCode shouldn't be handled here but through TLVs
@@ -360,7 +361,8 @@ struct iwl_cfg {
 	    rf_id:1,
 	    integrated:1,
 	    use_tfh:1,
-	    gen2:1;
+	    gen2:1,
+	    cdb:1;
 	u8 valid_tx_ant;
 	u8 valid_rx_ant;
 	u8 non_shared_ant;
@@ -450,6 +452,7 @@ extern const struct iwl_cfg iwl9270_2ac_cfg;
 extern const struct iwl_cfg iwl9460_2ac_cfg;
 extern const struct iwl_cfg iwl9560_2ac_cfg;
 extern const struct iwl_cfg iwla000_2ac_cfg_hr;
+extern const struct iwl_cfg iwla000_2ac_cfg_hr_cdb;
 extern const struct iwl_cfg iwla000_2ac_cfg_jf;
 #endif /* CONFIG_IWLMVM */
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 52e1d0c9428d..e51760e752d4 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -537,7 +537,8 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0xA370, 0x1030, iwl9560_2ac_cfg)},
 
 /* a000 Series */
-	{IWL_PCI_DEVICE(0x2720, 0x0A10, iwla000_2ac_cfg_hr)},
+	{IWL_PCI_DEVICE(0x2720, 0x0A10, iwla000_2ac_cfg_hr_cdb)},
+	{IWL_PCI_DEVICE(0x2722, 0x0A10, iwla000_2ac_cfg_hr)},
 #endif /* CONFIG_IWLMVM */
 
 	{0}
@@ -672,8 +673,8 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	if (iwl_trans->cfg->rf_id &&
-	    (cfg == &iwla000_2ac_cfg_hr &&
-	     iwl_trans->hw_rf_id == CSR_HW_RF_ID_TYPE_JF)) {
+	    (cfg == &iwla000_2ac_cfg_hr || cfg == &iwla000_2ac_cfg_hr_cdb) &&
+	     iwl_trans->hw_rf_id == CSR_HW_RF_ID_TYPE_JF) {
 		cfg = &iwla000_2ac_cfg_jf;
 		iwl_trans->cfg = cfg;
 	}
-- 
2.11.0
