Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:41020 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755475AbcH2V2N (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 29 Aug 2016 17:28:13 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Oren Givon <oren.givon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 30 Aug 2016 00:26:13 +0300
Message-Id: <1472505976-21108-13-git-send-email-luca@coelho.fi> (sfid-20160829_232817_800700_AAAA9BBC)
In-Reply-To: <1472505976-21108-1-git-send-email-luca@coelho.fi>
References: <1472505827.27868.41.camel@coelho.fi>
 <1472505976-21108-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 13/16] iwlwifi: add the new 9170 series
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Oren Givon <oren.givon@intel.com>

Add a new config struct for the new 9170 series and add
the first PCI ID for it.

Signed-off-by: Oren Givon <oren.givon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-9000.c   | 10 ++++++++++
 drivers/net/wireless/intel/iwlwifi/iwl-config.h |  1 +
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c   |  1 +
 3 files changed, 12 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-9000.c b/drivers/net/wireless/intel/iwlwifi/iwl-9000.c
index e442650..1fec6af 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-9000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-9000.c
@@ -146,6 +146,16 @@ static const struct iwl_tt_params iwl9000_tt_params = {
 	.mac_addr_from_csr = true,					\
 	.rf_id = true
 
+const struct iwl_cfg iwl9160_2ac_cfg = {
+	.name = "Intel(R) Dual Band Wireless AC 9160",
+	.fw_name_pre = IWL9260_FW_PRE,
+	IWL_DEVICE_9000,
+	.ht_params = &iwl9000_ht_params,
+	.nvm_ver = IWL9000_NVM_VERSION,
+	.nvm_calib_ver = IWL9000_TX_POWER_VERSION,
+	.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
+};
+
 const struct iwl_cfg iwl9260_2ac_cfg = {
 	.name = "Intel(R) Dual Band Wireless AC 9260",
 	.fw_name_pre = IWL9260_FW_PRE,
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index 0ab415c..7008319 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -450,6 +450,7 @@ extern const struct iwl_cfg iwl8260_2ac_sdio_cfg;
 extern const struct iwl_cfg iwl8265_2ac_sdio_cfg;
 extern const struct iwl_cfg iwl4165_2ac_sdio_cfg;
 extern const struct iwl_cfg iwl9000lc_2ac_cfg;
+extern const struct iwl_cfg iwl9160_2ac_cfg;
 extern const struct iwl_cfg iwl9260_2ac_cfg;
 extern const struct iwl_cfg iwl9270_2ac_cfg;
 extern const struct iwl_cfg iwl9460_2ac_cfg;
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 1be0ac2..c6e24fb 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -502,6 +502,7 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x24FD, 0x0850, iwl8265_2ac_cfg)},
 
 /* 9000 Series */
+	{IWL_PCI_DEVICE(0x271B, 0x0010, iwl9160_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x2526, 0x0000, iwl9260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x2526, 0x0010, iwl9260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x2526, 0x1410, iwl9270_2ac_cfg)},
-- 
2.8.1
