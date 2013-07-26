Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58157 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756248Ab3GZIaI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jul 2013 04:30:08 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Eytan Lifshitz <eytan.lifshitz@intel.com>
Subject: [PATCH 30/30] iwlwifi: mvm: add high temperature SKU thermal throttling parameters
Date: Fri, 26 Jul 2013 10:28:47 +0200
Message-Id: <1374827327-3464-31-git-send-email-johannes@sipsolutions.net> (sfid-20130726_103018_805782_A1951DE7)
In-Reply-To: <1374827327-3464-1-git-send-email-johannes@sipsolutions.net>
References: <1374827327-3464-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eytan Lifshitz <eytan.lifshitz@intel.com>

When the NIC is expected to operate in high temperature,
it is advisable to put more aggresive thermal throttling
parameters, in order to prevent CT-kill.

Signed-off-by: eytan lifshitz <eytan.lifshitz@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-7000.c   | 10 ++++++++++
 drivers/net/wireless/iwlwifi/iwl-config.h |  3 +++
 drivers/net/wireless/iwlwifi/mvm/tt.c     | 29 ++++++++++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/pcie/drv.c   |  6 +++---
 4 files changed, 44 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-7000.c b/drivers/net/wireless/iwlwifi/iwl-7000.c
index 7f61674..76e14c0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-7000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-7000.c
@@ -127,6 +127,16 @@ const struct iwl_cfg iwl7260_2ac_cfg = {
 	.nvm_calib_ver = IWL7260_TX_POWER_VERSION,
 };
 
+const struct iwl_cfg iwl7260_2ac_cfg_high_temp = {
+	.name = "Intel(R) Dual Band Wireless AC 7260",
+	.fw_name_pre = IWL7260_FW_PRE,
+	IWL_DEVICE_7000,
+	.ht_params = &iwl7000_ht_params,
+	.nvm_ver = IWL7260_NVM_VERSION,
+	.nvm_calib_ver = IWL7260_TX_POWER_VERSION,
+	.high_temp = true,
+};
+
 const struct iwl_cfg iwl7260_2n_cfg = {
 	.name = "Intel(R) Dual Band Wireless N 7260",
 	.fw_name_pre = IWL7260_FW_PRE,
diff --git a/drivers/net/wireless/iwlwifi/iwl-config.h b/drivers/net/wireless/iwlwifi/iwl-config.h
index 87fe955..e4d370b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/iwlwifi/iwl-config.h
@@ -206,6 +206,7 @@ struct iwl_eeprom_params {
  * @led_mode: 0=blinking, 1=On(RF On)/Off(RF Off)
  * @rx_with_siso_diversity: 1x1 device with rx antenna diversity
  * @internal_wimax_coex: internal wifi/wimax combo device
+ * @high_temp: Is this NIC is designated to be in high temperature.
  *
  * We enable the driver to be backward compatible wrt. hardware features.
  * API differences in uCode shouldn't be handled here but through TLVs
@@ -234,6 +235,7 @@ struct iwl_cfg {
 	enum iwl_led_mode led_mode;
 	const bool rx_with_siso_diversity;
 	const bool internal_wimax_coex;
+	bool high_temp;
 };
 
 /*
@@ -284,6 +286,7 @@ extern const struct iwl_cfg iwl135_bgn_cfg;
 #endif /* CONFIG_IWLDVM */
 #if IS_ENABLED(CONFIG_IWLMVM)
 extern const struct iwl_cfg iwl7260_2ac_cfg;
+extern const struct iwl_cfg iwl7260_2ac_cfg_high_temp;
 extern const struct iwl_cfg iwl7260_2n_cfg;
 extern const struct iwl_cfg iwl7260_n_cfg;
 extern const struct iwl_cfg iwl3160_2ac_cfg;
diff --git a/drivers/net/wireless/iwlwifi/mvm/tt.c b/drivers/net/wireless/iwlwifi/mvm/tt.c
index f5ba185f..1f3282d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tt.c
@@ -512,12 +512,39 @@ static const struct iwl_tt_params iwl7000_tt_params = {
 	.support_tx_backoff = true,
 };
 
+static const struct iwl_tt_params iwl7000_high_temp_tt_params = {
+	.ct_kill_entry = 118,
+	.ct_kill_exit = 96,
+	.ct_kill_duration = 5,
+	.dynamic_smps_entry = 114,
+	.dynamic_smps_exit = 110,
+	.tx_protection_entry = 114,
+	.tx_protection_exit = 108,
+	.tx_backoff = {
+		{.temperature = 112, .backoff = 300},
+		{.temperature = 113, .backoff = 800},
+		{.temperature = 114, .backoff = 1500},
+		{.temperature = 115, .backoff = 3000},
+		{.temperature = 116, .backoff = 5000},
+		{.temperature = 117, .backoff = 10000},
+	},
+	.support_ct_kill = true,
+	.support_dynamic_smps = true,
+	.support_tx_protection = true,
+	.support_tx_backoff = true,
+};
+
 void iwl_mvm_tt_initialize(struct iwl_mvm *mvm)
 {
 	struct iwl_mvm_tt_mgmt *tt = &mvm->thermal_throttle;
 
 	IWL_DEBUG_TEMP(mvm, "Initialize Thermal Throttling\n");
-	tt->params = &iwl7000_tt_params;
+
+	if (mvm->cfg->high_temp)
+		tt->params = &iwl7000_high_temp_tt_params;
+	else
+		tt->params = &iwl7000_tt_params;
+
 	tt->throttle = false;
 	INIT_DELAYED_WORK(&tt->ct_kill_exit, check_exit_ctkill);
 }
diff --git a/drivers/net/wireless/iwlwifi/pcie/drv.c b/drivers/net/wireless/iwlwifi/pcie/drv.c
index 81f3ea5..db6be24 100644
--- a/drivers/net/wireless/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/iwlwifi/pcie/drv.c
@@ -272,9 +272,9 @@ static DEFINE_PCI_DEVICE_TABLE(iwl_hw_card_ids) = {
 	{IWL_PCI_DEVICE(0x08B1, 0x4462, iwl7260_n_cfg)},
 	{IWL_PCI_DEVICE(0x08B1, 0x4870, iwl7260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x08B1, 0x486E, iwl7260_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x08B1, 0x4A70, iwl7260_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x08B1, 0x4A6E, iwl7260_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x08B1, 0x4A6C, iwl7260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x08B1, 0x4A70, iwl7260_2ac_cfg_high_temp)},
+	{IWL_PCI_DEVICE(0x08B1, 0x4A6E, iwl7260_2ac_cfg_high_temp)},
+	{IWL_PCI_DEVICE(0x08B1, 0x4A6C, iwl7260_2ac_cfg_high_temp)},
 	{IWL_PCI_DEVICE(0x08B1, 0x4020, iwl7260_2n_cfg)},
 	{IWL_PCI_DEVICE(0x08B2, 0x4220, iwl7260_2n_cfg)},
 	{IWL_PCI_DEVICE(0x08B1, 0x4420, iwl7260_2n_cfg)},
-- 
1.8.0

