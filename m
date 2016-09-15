Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:54916 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753910AbcIOSNJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Sep 2016 14:13:09 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Oren Givon <oren.givon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Thu, 15 Sep 2016 21:11:23 +0300
Message-Id: <20160915181131.32213-17-luca@coelho.fi> (sfid-20160915_201320_685870_BEF948A8)
In-Reply-To: <1473962425.5664.41.camel@coelho.fi>
References: <1473962425.5664.41.camel@coelho.fi>
Subject: [PATCH 17/25] iwlwifi: add the new 8275 series
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Oren Givon <oren.givon@intel.com>

Add a new config struct for the new 8275 series and add
the first PCI ID for it.

Signed-off-by: Oren Givon <oren.givon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-8000.c   | 11 +++++++++++
 drivers/net/wireless/intel/iwlwifi/iwl-config.h |  1 +
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c   |  1 +
 3 files changed, 13 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-8000.c b/drivers/net/wireless/intel/iwlwifi/iwl-8000.c
index 6c6725e..cde4f26 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-8000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-8000.c
@@ -212,6 +212,17 @@ const struct iwl_cfg iwl8265_2ac_cfg = {
 	.vht_mu_mimo_supported = true,
 };
 
+const struct iwl_cfg iwl8275_2ac_cfg = {
+	.name = "Intel(R) Dual Band Wireless AC 8275",
+	.fw_name_pre = IWL8265_FW_PRE,
+	IWL_DEVICE_8265,
+	.ht_params = &iwl8000_ht_params,
+	.nvm_ver = IWL8000_NVM_VERSION,
+	.nvm_calib_ver = IWL8000_TX_POWER_VERSION,
+	.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
+	.vht_mu_mimo_supported = true,
+};
+
 const struct iwl_cfg iwl4165_2ac_cfg = {
 	.name = "Intel(R) Dual Band Wireless AC 4165",
 	.fw_name_pre = IWL8000_FW_PRE,
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index 63d3f9b..6cecb1a 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -445,6 +445,7 @@ extern const struct iwl_cfg iwl7265d_n_cfg;
 extern const struct iwl_cfg iwl8260_2n_cfg;
 extern const struct iwl_cfg iwl8260_2ac_cfg;
 extern const struct iwl_cfg iwl8265_2ac_cfg;
+extern const struct iwl_cfg iwl8275_2ac_cfg;
 extern const struct iwl_cfg iwl4165_2ac_cfg;
 extern const struct iwl_cfg iwl8260_2ac_sdio_cfg;
 extern const struct iwl_cfg iwl8265_2ac_sdio_cfg;
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 74aa416..14c6e94 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -500,6 +500,7 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x24FD, 0x0930, iwl8265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24FD, 0x0950, iwl8265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24FD, 0x0850, iwl8265_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x24FD, 0x0012, iwl8275_2ac_cfg)},
 
 /* 9000 Series */
 	{IWL_PCI_DEVICE(0x271B, 0x0010, iwl9160_2ac_cfg)},
-- 
2.9.3
