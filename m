Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:35904 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751815AbdF1UOY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Jun 2017 16:14:24 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Tzipi Peres <tzipi.peres@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 28 Jun 2017 23:13:13 +0300
Message-Id: <20170628201330.9432-15-luca@coelho.fi> (sfid-20170628_221453_603730_C3411B26)
In-Reply-To: <20170628201330.9432-1-luca@coelho.fi>
References: <20170628201330.9432-1-luca@coelho.fi>
Subject: [PATCH 14/31] iwlwifi: add the new a000_2ax series
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tzipi Peres <tzipi.peres@intel.com>

Add a new config struct for the new a000 2ax series and add
the five PCI ID for it.

Signed-off-by: Tzipi Peres <tzipi.peres@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-a000.c   | 10 ++++++++++
 drivers/net/wireless/intel/iwlwifi/iwl-config.h |  1 +
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c   |  5 +++++
 3 files changed, 16 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-a000.c b/drivers/net/wireless/intel/iwlwifi/iwl-a000.c
index 4634c46d1eb4..2940c0a6c3d6 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-a000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-a000.c
@@ -158,5 +158,15 @@ const struct iwl_cfg iwla000_2ac_cfg_jf = {
 		.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
 };
 
+const struct iwl_cfg iwla000_2ax_cfg_hr = {
+		.name = "Intel(R) Dual Band Wireless AX a000",
+		.fw_name_pre = IWL_A000_HR_FW_PRE,
+		IWL_DEVICE_A000,
+		.ht_params = &iwl_a000_ht_params,
+		.nvm_ver = IWL_A000_NVM_VERSION,
+		.nvm_calib_ver = IWL_A000_TX_POWER_VERSION,
+		.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
+};
+
 MODULE_FIRMWARE(IWL_A000_HR_MODULE_FIRMWARE(IWL_A000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_A000_JF_MODULE_FIRMWARE(IWL_A000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index 127017efdd87..c52623cb7c2a 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -462,6 +462,7 @@ extern const struct iwl_cfg iwl9560_2ac_cfg;
 extern const struct iwl_cfg iwla000_2ac_cfg_hr;
 extern const struct iwl_cfg iwla000_2ac_cfg_hr_cdb;
 extern const struct iwl_cfg iwla000_2ac_cfg_jf;
+extern const struct iwl_cfg iwla000_2ax_cfg_hr;
 #endif /* CONFIG_IWLMVM */
 
 #endif /* __IWL_CONFIG_H__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index a8fb77483313..e995b055be4e 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -539,6 +539,11 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 /* a000 Series */
 	{IWL_PCI_DEVICE(0x2720, 0x0A10, iwla000_2ac_cfg_hr_cdb)},
 	{IWL_PCI_DEVICE(0x34F0, 0x0310, iwla000_2ac_cfg_jf)},
+	{IWL_PCI_DEVICE(0x2720, 0x0000, iwla000_2ax_cfg_hr)},
+	{IWL_PCI_DEVICE(0x34F0, 0x0070, iwla000_2ax_cfg_hr)},
+	{IWL_PCI_DEVICE(0x2720, 0x0078, iwla000_2ax_cfg_hr)},
+	{IWL_PCI_DEVICE(0x2720, 0x0070, iwla000_2ax_cfg_hr)},
+	{IWL_PCI_DEVICE(0x2720, 0x1080, iwla000_2ax_cfg_hr)},
 #endif /* CONFIG_IWLMVM */
 
 	{0}
-- 
2.11.0
