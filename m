Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:54832 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753047AbcIOSMX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Sep 2016 14:12:23 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Oren Givon <oren.givon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Thu, 15 Sep 2016 21:11:22 +0300
Message-Id: <20160915181131.32213-16-luca@coelho.fi> (sfid-20160915_203149_533245_4C58D726)
In-Reply-To: <1473962425.5664.41.camel@coelho.fi>
References: <1473962425.5664.41.camel@coelho.fi>
Subject: [PATCH 16/25] iwlwifi: add the new 9560 series
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Oren Givon <oren.givon@intel.com>

Add a new config struct for the new 9560 series and add
the 4 new PCI IDs for it.

Signed-off-by: Oren Givon <oren.givon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-9000.c   | 11 +++++++++++
 drivers/net/wireless/intel/iwlwifi/iwl-config.h |  1 +
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c   |  4 ++++
 3 files changed, 16 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-9000.c b/drivers/net/wireless/intel/iwlwifi/iwl-9000.c
index 1fec6af..4d68985 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-9000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-9000.c
@@ -187,6 +187,17 @@ const struct iwl_cfg iwl9460_2ac_cfg = {
 	.integrated = true,
 };
 
+const struct iwl_cfg iwl9560_2ac_cfg = {
+	.name = "Intel(R) Dual Band Wireless AC 9560",
+	.fw_name_pre = IWL9000_FW_PRE,
+	IWL_DEVICE_9000,
+	.ht_params = &iwl9000_ht_params,
+	.nvm_ver = IWL9000_NVM_VERSION,
+	.nvm_calib_ver = IWL9000_TX_POWER_VERSION,
+	.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
+	.integrated = true,
+};
+
 /*
  * TODO the struct below is for internal testing only this should be
  * removed by EO 2016~
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index 7008319..63d3f9b 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -454,6 +454,7 @@ extern const struct iwl_cfg iwl9160_2ac_cfg;
 extern const struct iwl_cfg iwl9260_2ac_cfg;
 extern const struct iwl_cfg iwl9270_2ac_cfg;
 extern const struct iwl_cfg iwl9460_2ac_cfg;
+extern const struct iwl_cfg iwl9560_2ac_cfg;
 extern const struct iwl_cfg iwla000_2ac_cfg;
 #endif /* CONFIG_IWLMVM */
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index c6e24fb..74aa416 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -523,6 +523,10 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x9DF0, 0x0060, iwl9460_2ac_cfg)},
 	{IWL_PCI_DEVICE(0xA370, 0x0060, iwl9460_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x31DC, 0x0060, iwl9460_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x2526, 0x0030, iwl9560_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x0030, iwl9560_2ac_cfg)},
+	{IWL_PCI_DEVICE(0xA370, 0x0030, iwl9560_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x31DC, 0x0030, iwl9560_2ac_cfg)},
 
 /* a000 Series */
 	{IWL_PCI_DEVICE(0x2720, 0x0A10, iwla000_2ac_cfg)},
-- 
2.9.3
