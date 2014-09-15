Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:39215 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbaIOFNI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2014 01:13:08 -0400
Received: by mail-wi0-f177.google.com with SMTP id em10so3450964wid.10
        for <linux-wireless@vger.kernel.org>; Sun, 14 Sep 2014 22:13:07 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Oren Givon <oren.givon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 02/28] iwlwifi: add and edit 8000 series PCI IDs
Date: Mon, 15 Sep 2014 08:12:34 +0300
Message-Id: <1410757980-2138-2-git-send-email-egrumbach@gmail.com> (sfid-20140915_071314_523284_F32DF2ED)
In-Reply-To: <5416742C.3070804@gmail.com>
References: <5416742C.3070804@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Oren Givon <oren.givon@intel.com>

Edit some 8000 series PCI IDs and add configuration to
Dual Band Wireless N 8260 devices.

Signed-off-by: Oren Givon <oren.givon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-8000.c   | 9 +++++++++
 drivers/net/wireless/iwlwifi/iwl-config.h | 1 +
 drivers/net/wireless/iwlwifi/pcie/drv.c   | 1 +
 3 files changed, 11 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-8000.c b/drivers/net/wireless/iwlwifi/iwl-8000.c
index 23a67bf..3c576ee 100644
--- a/drivers/net/wireless/iwlwifi/iwl-8000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-8000.c
@@ -117,6 +117,15 @@ static const struct iwl_ht_params iwl8000_ht_params = {
 	.led_mode = IWL_LED_RF_STATE,				\
 	.nvm_hw_section_num = NVM_HW_SECTION_NUM_FAMILY_8000
 
+const struct iwl_cfg iwl8260_2n_cfg = {
+	.name = "Intel(R) Dual Band Wireless N 8260",
+	.fw_name_pre = IWL8000_FW_PRE,
+	IWL_DEVICE_8000,
+	.ht_params = &iwl8000_ht_params,
+	.nvm_ver = IWL8000_NVM_VERSION,
+	.nvm_calib_ver = IWL8000_TX_POWER_VERSION,
+};
+
 const struct iwl_cfg iwl8260_2ac_cfg = {
 	.name = "Intel(R) Dual Band Wireless AC 8260",
 	.fw_name_pre = IWL8000_FW_PRE,
diff --git a/drivers/net/wireless/iwlwifi/iwl-config.h b/drivers/net/wireless/iwlwifi/iwl-config.h
index 07c0f1f..1b9c77d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/iwlwifi/iwl-config.h
@@ -343,6 +343,7 @@ extern const struct iwl_cfg iwl3165_2ac_cfg;
 extern const struct iwl_cfg iwl7265_2ac_cfg;
 extern const struct iwl_cfg iwl7265_2n_cfg;
 extern const struct iwl_cfg iwl7265_n_cfg;
+extern const struct iwl_cfg iwl8260_2n_cfg;
 extern const struct iwl_cfg iwl8260_2ac_cfg;
 extern const struct iwl_cfg iwl8260_2ac_sdio_cfg;
 #endif /* CONFIG_IWLMVM */
diff --git a/drivers/net/wireless/iwlwifi/pcie/drv.c b/drivers/net/wireless/iwlwifi/pcie/drv.c
index b9d5049..ca68c3c 100644
--- a/drivers/net/wireless/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/iwlwifi/pcie/drv.c
@@ -405,6 +405,7 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 
 /* 8000 Series */
 	{IWL_PCI_DEVICE(0x24F3, 0x0010, iwl8260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x24F3, 0x0004, iwl8260_2n_cfg)},
 	{IWL_PCI_DEVICE(0x24F4, 0x0030, iwl8260_2ac_cfg)},
 #endif /* CONFIG_IWLMVM */
 
-- 
1.9.1

