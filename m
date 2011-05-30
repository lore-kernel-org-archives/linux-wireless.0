Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:50981 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752711Ab1E3RAo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 May 2011 13:00:44 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>, stable@kernel.org
Subject: [PATCH wireless-2.6] iwlagn: fix incorrect PCI subsystem id for 6150 devices
Date: Mon, 30 May 2011 09:32:52 -0700
Message-Id: <1306773172-21745-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110530_190047_299787_6CDCA84A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

For 6150 devices, modify the supported PCI subsystem ID.

Cc: stable@kernel.org
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
these patches are also available from wireless-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

 drivers/net/wireless/iwlwifi/iwl-6000.c |   29 ++++++++++++++++++-----------
 drivers/net/wireless/iwlwifi/iwl-agn.c  |    6 +++---
 drivers/net/wireless/iwlwifi/iwl-agn.h  |    1 +
 3 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index a745b01..45d16a9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -696,20 +696,27 @@ struct iwl_cfg iwl6050_2abg_cfg = {
 	IWL_DEVICE_6050,
 };
 
+#define IWL_DEVICE_6150						\
+	.fw_name_pre = IWL6050_FW_PRE,				\
+	.ucode_api_max = IWL6050_UCODE_API_MAX,			\
+	.ucode_api_min = IWL6050_UCODE_API_MIN,			\
+	.ops = &iwl6150_ops,					\
+	.eeprom_ver = EEPROM_6150_EEPROM_VERSION,		\
+	.eeprom_calib_ver = EEPROM_6150_TX_POWER_VERSION,	\
+	.base_params = &iwl6050_base_params,			\
+	.need_dc_calib = true,					\
+	.led_mode = IWL_LED_BLINK,				\
+	.internal_wimax_coex = true
+
 struct iwl_cfg iwl6150_bgn_cfg = {
 	.name = "Intel(R) Centrino(R) Wireless-N + WiMAX 6150 BGN",
-	.fw_name_pre = IWL6050_FW_PRE,
-	.ucode_api_max = IWL6050_UCODE_API_MAX,
-	.ucode_api_min = IWL6050_UCODE_API_MIN,
-	.eeprom_ver = EEPROM_6150_EEPROM_VERSION,
-	.eeprom_calib_ver = EEPROM_6150_TX_POWER_VERSION,
-	.ops = &iwl6150_ops,
-	.mod_params = &iwlagn_mod_params,
-	.base_params = &iwl6050_base_params,
+	IWL_DEVICE_6150,
 	.ht_params = &iwl6000_ht_params,
-	.need_dc_calib = true,
-	.led_mode = IWL_LED_RF_STATE,
-	.internal_wimax_coex = true,
+};
+
+struct iwl_cfg iwl6150_bg_cfg = {
+	.name = "Intel(R) Centrino(R) Wireless-N + WiMAX 6150 BG",
+	IWL_DEVICE_6150,
 };
 
 struct iwl_cfg iwl6000_3agn_cfg = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 321b18b..8960052 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -4458,11 +4458,11 @@ static DEFINE_PCI_DEVICE_TABLE(iwl_hw_card_ids) = {
 
 /* 6150 WiFi/WiMax Series */
 	{IWL_PCI_DEVICE(0x0885, 0x1305, iwl6150_bgn_cfg)},
-	{IWL_PCI_DEVICE(0x0885, 0x1306, iwl6150_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x0885, 0x1307, iwl6150_bg_cfg)},
 	{IWL_PCI_DEVICE(0x0885, 0x1325, iwl6150_bgn_cfg)},
-	{IWL_PCI_DEVICE(0x0885, 0x1326, iwl6150_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x0885, 0x1327, iwl6150_bg_cfg)},
 	{IWL_PCI_DEVICE(0x0886, 0x1315, iwl6150_bgn_cfg)},
-	{IWL_PCI_DEVICE(0x0886, 0x1316, iwl6150_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x0886, 0x1317, iwl6150_bg_cfg)},
 
 /* 1000 Series WiFi */
 	{IWL_PCI_DEVICE(0x0083, 0x1205, iwl1000_bgn_cfg)},
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 20f8e41..89050b9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -90,6 +90,7 @@ extern struct iwl_cfg iwl6000_3agn_cfg;
 extern struct iwl_cfg iwl6050_2agn_cfg;
 extern struct iwl_cfg iwl6050_2abg_cfg;
 extern struct iwl_cfg iwl6150_bgn_cfg;
+extern struct iwl_cfg iwl6150_bg_cfg;
 extern struct iwl_cfg iwl1000_bgn_cfg;
 extern struct iwl_cfg iwl1000_bg_cfg;
 extern struct iwl_cfg iwl100_bgn_cfg;
-- 
1.7.0.4

