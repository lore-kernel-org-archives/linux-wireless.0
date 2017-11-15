Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45838 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932460AbdKOQxA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Nov 2017 11:53:00 -0500
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>, stable@vger.kernel.org
Date: Wed, 15 Nov 2017 18:52:41 +0200
Message-Id: <20171115165242.21675-3-luca@coelho.fi> (sfid-20171115_175311_112043_30784A2E)
In-Reply-To: <20171115165242.21675-1-luca@coelho.fi>
References: <20171115165242.21675-1-luca@coelho.fi>
Subject: [PATCH 2/3] iwlwifi: fix PCI IDs and configuration mapping for 9000 series
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

A lot of PCI IDs were missing and there were some problems with the
configuration and firmware selection for devices on the 9000 series.
Fix the firmware selection by adding files for the B-steps; add
configuration for some integrated devices; and add a bunch of PCI IDs
(mostly for integrated devices) that were missing from the driver's
list.

Without this patch, a lot of devices will not be recognized or will
try to load the wrong firmware file.

Cc: stable@vger.kernel.org # 4.13
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c |  73 ++++++++++++--
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 132 ++++++++++++++++++++------
 2 files changed, 168 insertions(+), 37 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/9000.c b/drivers/net/wireless/intel/iwlwifi/cfg/9000.c
index af7c4f36b66f..e7e75b458005 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/9000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/9000.c
@@ -72,18 +72,21 @@
 #define IWL9000_SMEM_OFFSET		0x400000
 #define IWL9000_SMEM_LEN		0x68000
 
-#define  IWL9000_FW_PRE "iwlwifi-9000-pu-a0-jf-a0-"
+#define  IWL9000A_FW_PRE "iwlwifi-9000-pu-a0-jf-a0-"
+#define  IWL9000B_FW_PRE "iwlwifi-9000-pu-b0-jf-b0-"
 #define  IWL9000RFB_FW_PRE "iwlwifi-9000-pu-a0-jf-b0-"
 #define  IWL9260A_FW_PRE "iwlwifi-9260-th-a0-jf-a0-"
 #define  IWL9260B_FW_PRE "iwlwifi-9260-th-b0-jf-b0-"
-#define IWL9000_MODULE_FIRMWARE(api) \
-	IWL9000_FW_PRE "-" __stringify(api) ".ucode"
+#define IWL9000A_MODULE_FIRMWARE(api) \
+	IWL9000A_FW_PRE __stringify(api) ".ucode"
+#define IWL9000B_MODULE_FIRMWARE(api) \
+	IWL9000B_FW_PRE __stringify(api) ".ucode"
 #define IWL9000RFB_MODULE_FIRMWARE(api) \
-	IWL9000RFB_FW_PRE "-" __stringify(api) ".ucode"
+	IWL9000RFB_FW_PRE __stringify(api) ".ucode"
 #define IWL9260A_MODULE_FIRMWARE(api) \
-	IWL9260A_FW_PRE "-" __stringify(api) ".ucode"
+	IWL9260A_FW_PRE __stringify(api) ".ucode"
 #define IWL9260B_MODULE_FIRMWARE(api) \
-	IWL9260B_FW_PRE "-" __stringify(api) ".ucode"
+	IWL9260B_FW_PRE __stringify(api) ".ucode"
 
 #define NVM_HW_SECTION_NUM_FAMILY_9000		10
 
@@ -194,7 +197,48 @@ const struct iwl_cfg iwl9460_2ac_cfg = {
 	.nvm_ver = IWL9000_NVM_VERSION,
 	.nvm_calib_ver = IWL9000_TX_POWER_VERSION,
 	.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
+};
+
+const struct iwl_cfg iwl9460_2ac_cfg_soc = {
+	.name = "Intel(R) Dual Band Wireless AC 9460",
+	.fw_name_pre = IWL9000A_FW_PRE,
+	.fw_name_pre_b_or_c_step = IWL9000B_FW_PRE,
+	.fw_name_pre_rf_next_step = IWL9000RFB_FW_PRE,
+	IWL_DEVICE_9000,
+	.ht_params = &iwl9000_ht_params,
+	.nvm_ver = IWL9000_NVM_VERSION,
+	.nvm_calib_ver = IWL9000_TX_POWER_VERSION,
+	.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
 	.integrated = true,
+	.soc_latency = 5000,
+};
+
+const struct iwl_cfg iwl9461_2ac_cfg_soc = {
+		.name = "Intel(R) Dual Band Wireless AC 9461",
+		.fw_name_pre = IWL9000A_FW_PRE,
+		.fw_name_pre_b_or_c_step = IWL9000B_FW_PRE,
+		.fw_name_pre_rf_next_step = IWL9000RFB_FW_PRE,
+		IWL_DEVICE_9000,
+		.ht_params = &iwl9000_ht_params,
+		.nvm_ver = IWL9000_NVM_VERSION,
+		.nvm_calib_ver = IWL9000_TX_POWER_VERSION,
+		.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
+		.integrated = true,
+		.soc_latency = 5000,
+};
+
+const struct iwl_cfg iwl9462_2ac_cfg_soc = {
+		.name = "Intel(R) Dual Band Wireless AC 9462",
+		.fw_name_pre = IWL9000A_FW_PRE,
+		.fw_name_pre_b_or_c_step = IWL9000B_FW_PRE,
+		.fw_name_pre_rf_next_step = IWL9000RFB_FW_PRE,
+		IWL_DEVICE_9000,
+		.ht_params = &iwl9000_ht_params,
+		.nvm_ver = IWL9000_NVM_VERSION,
+		.nvm_calib_ver = IWL9000_TX_POWER_VERSION,
+		.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
+		.integrated = true,
+		.soc_latency = 5000,
 };
 
 const struct iwl_cfg iwl9560_2ac_cfg = {
@@ -206,10 +250,23 @@ const struct iwl_cfg iwl9560_2ac_cfg = {
 	.nvm_ver = IWL9000_NVM_VERSION,
 	.nvm_calib_ver = IWL9000_TX_POWER_VERSION,
 	.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
-	.integrated = true,
 };
 
-MODULE_FIRMWARE(IWL9000_MODULE_FIRMWARE(IWL9000_UCODE_API_MAX));
+const struct iwl_cfg iwl9560_2ac_cfg_soc = {
+	.name = "Intel(R) Dual Band Wireless AC 9560",
+	.fw_name_pre = IWL9000A_FW_PRE,
+	.fw_name_pre_b_or_c_step = IWL9000B_FW_PRE,
+	.fw_name_pre_rf_next_step = IWL9000RFB_FW_PRE,
+	IWL_DEVICE_9000,
+	.ht_params = &iwl9000_ht_params,
+	.nvm_ver = IWL9000_NVM_VERSION,
+	.nvm_calib_ver = IWL9000_TX_POWER_VERSION,
+	.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
+	.integrated = true,
+	.soc_latency = 5000,
+};
+MODULE_FIRMWARE(IWL9000A_MODULE_FIRMWARE(IWL9000_UCODE_API_MAX));
+MODULE_FIRMWARE(IWL9000B_MODULE_FIRMWARE(IWL9000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL9000RFB_MODULE_FIRMWARE(IWL9000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL9260A_MODULE_FIRMWARE(IWL9000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL9260B_MODULE_FIRMWARE(IWL9000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 4a21c12276d7..f21fe59faccf 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -535,47 +535,121 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x2526, 0x0238, iwl9560_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x2526, 0x023C, iwl9560_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x2526, 0x0260, iwl9460_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x2526, 0x0264, iwl9461_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x2526, 0x02A0, iwl9460_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x2526, 0x02A4, iwl9460_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x2526, 0x1010, iwl9260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x2526, 0x1030, iwl9560_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x2526, 0x1210, iwl9260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x2526, 0x1410, iwl9270_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x2526, 0x1420, iwl9460_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x2526, 0x1420, iwl9460_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x2526, 0x1610, iwl9270_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x2526, 0x4010, iwl9260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x2526, 0x4030, iwl9560_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x2526, 0x40A4, iwl9460_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x2526, 0xA014, iwl9260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x2526, 0x42A4, iwl9462_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x271B, 0x0010, iwl9160_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x271B, 0x0014, iwl9160_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x271B, 0x0210, iwl9160_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x30DC, 0x0060, iwl9460_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x31DC, 0x0030, iwl9560_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x31DC, 0x0034, iwl9560_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x31DC, 0x0038, iwl9560_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x31DC, 0x003C, iwl9560_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x31DC, 0x0060, iwl9460_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x9DF0, 0x0000, iwl9460_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x9DF0, 0x0010, iwl9460_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x9DF0, 0x0030, iwl9560_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x9DF0, 0x0034, iwl9560_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x9DF0, 0x0038, iwl9560_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x9DF0, 0x003C, iwl9560_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x9DF0, 0x0060, iwl9460_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x9DF0, 0x0210, iwl9460_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x9DF0, 0x0310, iwl9460_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x9DF0, 0x0410, iwl9460_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x9DF0, 0x0510, iwl9460_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x9DF0, 0x0610, iwl9460_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x9DF0, 0x0710, iwl9460_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x9DF0, 0x0A10, iwl9460_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x9DF0, 0x2010, iwl9460_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x9DF0, 0x2A10, iwl9460_2ac_cfg)},
-	{IWL_PCI_DEVICE(0xA370, 0x0030, iwl9560_2ac_cfg)},
-	{IWL_PCI_DEVICE(0xA370, 0x0034, iwl9560_2ac_cfg)},
-	{IWL_PCI_DEVICE(0xA370, 0x0038, iwl9560_2ac_cfg)},
-	{IWL_PCI_DEVICE(0xA370, 0x003C, iwl9560_2ac_cfg)},
-	{IWL_PCI_DEVICE(0xA370, 0x0060, iwl9460_2ac_cfg)},
-	{IWL_PCI_DEVICE(0xA370, 0x1030, iwl9560_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x271B, 0x0214, iwl9260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x2720, 0x0034, iwl9560_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x2720, 0x0038, iwl9560_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x2720, 0x003C, iwl9560_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x2720, 0x0060, iwl9461_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x2720, 0x0064, iwl9461_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x2720, 0x00A0, iwl9462_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x2720, 0x00A4, iwl9462_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x2720, 0x0230, iwl9560_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x2720, 0x0234, iwl9560_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x2720, 0x0238, iwl9560_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x2720, 0x023C, iwl9560_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x2720, 0x0260, iwl9461_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x2720, 0x0264, iwl9461_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x2720, 0x02A0, iwl9462_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x2720, 0x02A4, iwl9462_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x2720, 0x4030, iwl9560_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x2720, 0x40A4, iwl9462_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x30DC, 0x0060, iwl9460_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x30DC, 0x0064, iwl9461_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x30DC, 0x00A0, iwl9462_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x30DC, 0x00A4, iwl9462_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x30DC, 0x0260, iwl9461_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x30DC, 0x0264, iwl9461_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x30DC, 0x02A0, iwl9462_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x30DC, 0x02A4, iwl9462_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x31DC, 0x0030, iwl9560_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x31DC, 0x0034, iwl9560_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x31DC, 0x0038, iwl9560_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x31DC, 0x003C, iwl9560_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x31DC, 0x0060, iwl9460_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x31DC, 0x0064, iwl9461_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x31DC, 0x00A0, iwl9462_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x31DC, 0x00A4, iwl9462_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x31DC, 0x0230, iwl9560_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x31DC, 0x0234, iwl9560_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x31DC, 0x0238, iwl9560_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x31DC, 0x023C, iwl9560_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x31DC, 0x0260, iwl9461_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x31DC, 0x0264, iwl9461_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x31DC, 0x02A0, iwl9462_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x31DC, 0x02A4, iwl9462_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x31DC, 0x4030, iwl9560_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x31DC, 0x4034, iwl9560_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x31DC, 0x40A4, iwl9462_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x34F0, 0x0030, iwl9560_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x34F0, 0x0034, iwl9560_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x34F0, 0x02A4, iwl9462_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x0000, iwl9460_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x0010, iwl9460_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x0030, iwl9560_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x0034, iwl9560_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x0038, iwl9560_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x003C, iwl9560_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x0060, iwl9460_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x0064, iwl9461_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x00A0, iwl9462_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x00A4, iwl9462_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x0210, iwl9460_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x0230, iwl9560_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x0234, iwl9560_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x0238, iwl9560_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x023C, iwl9560_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x0260, iwl9461_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x0264, iwl9461_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x02A0, iwl9462_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x02A4, iwl9462_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x0310, iwl9460_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x0410, iwl9460_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x0510, iwl9460_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x0610, iwl9460_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x0710, iwl9460_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x0A10, iwl9460_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x2010, iwl9460_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x2A10, iwl9460_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x4030, iwl9560_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x4034, iwl9560_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x40A4, iwl9462_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0xA370, 0x0030, iwl9560_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0xA370, 0x0034, iwl9560_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0xA370, 0x0038, iwl9560_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0xA370, 0x003C, iwl9560_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0xA370, 0x0060, iwl9460_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0xA370, 0x0064, iwl9461_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0xA370, 0x00A0, iwl9462_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0xA370, 0x00A4, iwl9462_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0xA370, 0x0230, iwl9560_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0xA370, 0x0234, iwl9560_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0xA370, 0x0238, iwl9560_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0xA370, 0x023C, iwl9560_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0xA370, 0x0260, iwl9461_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0xA370, 0x0264, iwl9461_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0xA370, 0x02A0, iwl9462_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0xA370, 0x02A4, iwl9462_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0xA370, 0x1030, iwl9560_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0xA370, 0x4030, iwl9560_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0xA370, 0x4034, iwl9560_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0xA370, 0x40A4, iwl9462_2ac_cfg_soc)},
 
 /* a000 Series */
 	{IWL_PCI_DEVICE(0x2720, 0x0A10, iwla000_2ac_cfg_hr_cdb)},
-- 
2.15.0
