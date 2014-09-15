Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:62027 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387AbaIOFLX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2014 01:11:23 -0400
Received: by mail-we0-f176.google.com with SMTP id q58so3334300wes.7
        for <linux-wireless@vger.kernel.org>; Sun, 14 Sep 2014 22:11:22 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Oren Givon <oren.givon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 11/12] iwlwifi: add PCI IDs and add then new 3165 series
Date: Mon, 15 Sep 2014 08:10:47 +0300
Message-Id: <1410757848-1827-11-git-send-email-egrumbach@gmail.com> (sfid-20140915_071134_805388_E07443CA)
In-Reply-To: <5416742C.3070804@gmail.com>
References: <5416742C.3070804@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Oren Givon <oren.givon@intel.com>

This change does the following:
1) Add a new 7265 series PCI ID
2) Add two new 3160 series PCI IDs
3) Add the new 3165 series PCI IDs and configurations

Signed-off-by: Oren Givon <oren.givon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-7000.c   | 16 ++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-config.h |  1 +
 drivers/net/wireless/iwlwifi/pcie/drv.c   |  7 +++++++
 3 files changed, 24 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-7000.c b/drivers/net/wireless/iwlwifi/iwl-7000.c
index d67a37a..d53adc2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-7000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-7000.c
@@ -83,6 +83,8 @@
 #define IWL7260_TX_POWER_VERSION	0xffff /* meaningless */
 #define IWL3160_NVM_VERSION		0x709
 #define IWL3160_TX_POWER_VERSION	0xffff /* meaningless */
+#define IWL3165_NVM_VERSION		0x709
+#define IWL3165_TX_POWER_VERSION	0xffff /* meaningless */
 #define IWL7265_NVM_VERSION		0x0a1d
 #define IWL7265_TX_POWER_VERSION	0xffff /* meaningless */
 
@@ -92,6 +94,9 @@
 #define IWL3160_FW_PRE "iwlwifi-3160-"
 #define IWL3160_MODULE_FIRMWARE(api) IWL3160_FW_PRE __stringify(api) ".ucode"
 
+#define IWL3165_FW_PRE "iwlwifi-3165-"
+#define IWL3165_MODULE_FIRMWARE(api) IWL3165_FW_PRE __stringify(api) ".ucode"
+
 #define IWL7265_FW_PRE "iwlwifi-7265-"
 #define IWL7265_MODULE_FIRMWARE(api) IWL7265_FW_PRE __stringify(api) ".ucode"
 
@@ -213,6 +218,16 @@ static const struct iwl_pwr_tx_backoff iwl7265_pwr_tx_backoffs[] = {
 	{0},
 };
 
+const struct iwl_cfg iwl3165_2ac_cfg = {
+	.name = "Intel(R) Dual Band Wireless AC 3165",
+	.fw_name_pre = IWL3165_FW_PRE,
+	IWL_DEVICE_7000,
+	.ht_params = &iwl7000_ht_params,
+	.nvm_ver = IWL3165_NVM_VERSION,
+	.nvm_calib_ver = IWL3165_TX_POWER_VERSION,
+	.pwr_tx_backoffs = iwl7265_pwr_tx_backoffs,
+};
+
 const struct iwl_cfg iwl7265_2ac_cfg = {
 	.name = "Intel(R) Dual Band Wireless AC 7265",
 	.fw_name_pre = IWL7265_FW_PRE,
@@ -245,4 +260,5 @@ const struct iwl_cfg iwl7265_n_cfg = {
 
 MODULE_FIRMWARE(IWL7260_MODULE_FIRMWARE(IWL7260_UCODE_API_OK));
 MODULE_FIRMWARE(IWL3160_MODULE_FIRMWARE(IWL3160_UCODE_API_OK));
+MODULE_FIRMWARE(IWL3165_MODULE_FIRMWARE(IWL3160_UCODE_API_OK));
 MODULE_FIRMWARE(IWL7265_MODULE_FIRMWARE(IWL7260_UCODE_API_OK));
diff --git a/drivers/net/wireless/iwlwifi/iwl-config.h b/drivers/net/wireless/iwlwifi/iwl-config.h
index 942c99b..3d7cc37 100644
--- a/drivers/net/wireless/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/iwlwifi/iwl-config.h
@@ -337,6 +337,7 @@ extern const struct iwl_cfg iwl7260_n_cfg;
 extern const struct iwl_cfg iwl3160_2ac_cfg;
 extern const struct iwl_cfg iwl3160_2n_cfg;
 extern const struct iwl_cfg iwl3160_n_cfg;
+extern const struct iwl_cfg iwl3165_2ac_cfg;
 extern const struct iwl_cfg iwl7265_2ac_cfg;
 extern const struct iwl_cfg iwl7265_2n_cfg;
 extern const struct iwl_cfg iwl7265_n_cfg;
diff --git a/drivers/net/wireless/iwlwifi/pcie/drv.c b/drivers/net/wireless/iwlwifi/pcie/drv.c
index 98950e4..8bb8305 100644
--- a/drivers/net/wireless/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/iwlwifi/pcie/drv.c
@@ -352,11 +352,17 @@ static DEFINE_PCI_DEVICE_TABLE(iwl_hw_card_ids) = {
 	{IWL_PCI_DEVICE(0x08B3, 0x8060, iwl3160_2n_cfg)},
 	{IWL_PCI_DEVICE(0x08B3, 0x8062, iwl3160_n_cfg)},
 	{IWL_PCI_DEVICE(0x08B4, 0x8270, iwl3160_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x08B4, 0x8370, iwl3160_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x08B4, 0x8272, iwl3160_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x08B3, 0x8470, iwl3160_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x08B3, 0x8570, iwl3160_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x08B3, 0x1070, iwl3160_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x08B3, 0x1170, iwl3160_2ac_cfg)},
 
+/* 3165 Series */
+	{IWL_PCI_DEVICE(0x3165, 0x4010, iwl3165_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x3165, 0x4210, iwl3165_2ac_cfg)},
+
 /* 7265 Series */
 	{IWL_PCI_DEVICE(0x095A, 0x5010, iwl7265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x095A, 0x5110, iwl7265_2ac_cfg)},
@@ -378,6 +384,7 @@ static DEFINE_PCI_DEVICE_TABLE(iwl_hw_card_ids) = {
 	{IWL_PCI_DEVICE(0x095B, 0x5202, iwl7265_n_cfg)},
 	{IWL_PCI_DEVICE(0x095A, 0x9010, iwl7265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x095A, 0x9012, iwl7265_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x095A, 0x900A, iwl7265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x095A, 0x9110, iwl7265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x095A, 0x9112, iwl7265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x095A, 0x9210, iwl7265_2ac_cfg)},
-- 
1.9.1

