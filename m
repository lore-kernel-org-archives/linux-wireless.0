Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:46913 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812Ab3KSUwV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Nov 2013 15:52:21 -0500
Received: by mail-wg0-f49.google.com with SMTP id x13so8070318wgg.4
        for <linux-wireless@vger.kernel.org>; Tue, 19 Nov 2013 12:52:20 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Oren Givon <oren.givon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 3/7] iwlwifi: add new HW - 7265 series
Date: Tue, 19 Nov 2013 22:52:02 +0200
Message-Id: <1384894326-24676-3-git-send-email-egrumbach@gmail.com> (sfid-20131119_215226_570713_EA6CBCE8)
In-Reply-To: <528BCEDB.8010703@gmail.com>
References: <528BCEDB.8010703@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Oren Givon <oren.givon@intel.com>

Add new HW IDs and configurations for 7265 series.

Signed-off-by: Oren Givon <oren.givon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-7000.c   |   18 ++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-config.h |    2 ++
 drivers/net/wireless/iwlwifi/pcie/drv.c   |   22 ++++++++++++++++++++++
 3 files changed, 42 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-7000.c b/drivers/net/wireless/iwlwifi/iwl-7000.c
index 2ea4b11..1ed861f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-7000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-7000.c
@@ -203,5 +203,23 @@ const struct iwl_cfg iwl7265_2ac_cfg = {
 	.nvm_calib_ver = IWL7265_TX_POWER_VERSION,
 };
 
+const struct iwl_cfg iwl7265_2n_cfg = {
+	.name = "Intel(R) Dual Band Wireless N 7265",
+	.fw_name_pre = IWL7265_FW_PRE,
+	IWL_DEVICE_7000,
+	.ht_params = &iwl7000_ht_params,
+	.nvm_ver = IWL7265_NVM_VERSION,
+	.nvm_calib_ver = IWL7265_TX_POWER_VERSION,
+};
+
+const struct iwl_cfg iwl7265_n_cfg = {
+	.name = "Intel(R) Wireless N 7265",
+	.fw_name_pre = IWL7265_FW_PRE,
+	IWL_DEVICE_7000,
+	.ht_params = &iwl7000_ht_params,
+	.nvm_ver = IWL7265_NVM_VERSION,
+	.nvm_calib_ver = IWL7265_TX_POWER_VERSION,
+};
+
 MODULE_FIRMWARE(IWL7260_MODULE_FIRMWARE(IWL7260_UCODE_API_OK));
 MODULE_FIRMWARE(IWL3160_MODULE_FIRMWARE(IWL3160_UCODE_API_OK));
diff --git a/drivers/net/wireless/iwlwifi/iwl-config.h b/drivers/net/wireless/iwlwifi/iwl-config.h
index 6801c7a..03fd9aa 100644
--- a/drivers/net/wireless/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/iwlwifi/iwl-config.h
@@ -297,6 +297,8 @@ extern const struct iwl_cfg iwl3160_2ac_cfg;
 extern const struct iwl_cfg iwl3160_2n_cfg;
 extern const struct iwl_cfg iwl3160_n_cfg;
 extern const struct iwl_cfg iwl7265_2ac_cfg;
+extern const struct iwl_cfg iwl7265_2n_cfg;
+extern const struct iwl_cfg iwl7265_n_cfg;
 #endif /* CONFIG_IWLMVM */
 
 #endif /* __IWL_CONFIG_H__ */
diff --git a/drivers/net/wireless/iwlwifi/pcie/drv.c b/drivers/net/wireless/iwlwifi/pcie/drv.c
index 941c0c8..64d6ac5 100644
--- a/drivers/net/wireless/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/iwlwifi/pcie/drv.c
@@ -352,7 +352,29 @@ static DEFINE_PCI_DEVICE_TABLE(iwl_hw_card_ids) = {
 	{IWL_PCI_DEVICE(0x08B3, 0x8570, iwl3160_2ac_cfg)},
 
 /* 7265 Series */
+	{IWL_PCI_DEVICE(0x08B1, 0x0000, iwl7265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x095A, 0x5010, iwl7265_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x095A, 0x5110, iwl7265_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x095B, 0x5310, iwl7265_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x095B, 0x5302, iwl7265_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x095B, 0x5210, iwl7265_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x095B, 0x5012, iwl7265_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x095B, 0x500A, iwl7265_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x095A, 0x5410, iwl7265_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x095A, 0x1010, iwl7265_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x095A, 0x5000, iwl7265_2n_cfg)},
+	{IWL_PCI_DEVICE(0x095B, 0x5200, iwl7265_2n_cfg)},
+	{IWL_PCI_DEVICE(0x095A, 0x5002, iwl7265_n_cfg)},
+	{IWL_PCI_DEVICE(0x095B, 0x5202, iwl7265_n_cfg)},
+	{IWL_PCI_DEVICE(0x095A, 0x9010, iwl7265_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x095A, 0x9210, iwl7265_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x095A, 0x9410, iwl7265_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x095A, 0x5020, iwl7265_2n_cfg)},
+	{IWL_PCI_DEVICE(0x095A, 0x502A, iwl7265_2n_cfg)},
+	{IWL_PCI_DEVICE(0x095A, 0x5420, iwl7265_2n_cfg)},
+	{IWL_PCI_DEVICE(0x095A, 0x5090, iwl7265_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x095B, 0x5290, iwl7265_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x095A, 0x5490, iwl7265_2ac_cfg)},
 #endif /* CONFIG_IWLMVM */
 
 	{0}
-- 
1.7.9.5

