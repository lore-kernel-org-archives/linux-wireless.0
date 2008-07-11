Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:23678 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751777AbYGKD4t (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2008 23:56:49 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Esti Kummer <stkumer@localhost.localdomain>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 02/14] iwlwifi: adding pci device ids to iwl_hw_card_ids
Date: Fri, 11 Jul 2008 11:53:30 +0800
Message-Id: <1215748422-12672-3-git-send-email-yi.zhu@intel.com> (sfid-20080711_055653_928615_9A332D37)
In-Reply-To: <1215748422-12672-2-git-send-email-yi.zhu@intel.com>
References: <1215748422-12672-1-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-2-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Esti Kummer <stkumer@localhost.localdomain>

The patch adds PCI device IDs to iwl_hw_card_ids.

Signed-off-by: Esti Kummer <stkumer@localhost.localdomain>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-5000.c     |   18 ++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    2 ++
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   10 +++++++++-
 3 files changed, 29 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 717db0d..3697d03 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -1506,6 +1506,24 @@ struct iwl_cfg iwl5300_agn_cfg = {
 	.mod_params = &iwl50_mod_params,
 };
 
+struct iwl_cfg iwl5100_bg_cfg = {
+	.name = "5100BG",
+	.fw_name = "iwlwifi-5000" IWL5000_UCODE_API ".ucode",
+	.sku = IWL_SKU_G,
+	.ops = &iwl5000_ops,
+	.eeprom_size = IWL_5000_EEPROM_IMG_SIZE,
+	.mod_params = &iwl50_mod_params,
+};
+
+struct iwl_cfg iwl5100_abg_cfg = {
+	.name = "5100ABG",
+	.fw_name = "iwlwifi-5000" IWL5000_UCODE_API ".ucode",
+	.sku = IWL_SKU_A|IWL_SKU_G,
+	.ops = &iwl5000_ops,
+	.eeprom_size = IWL_5000_EEPROM_IMG_SIZE,
+	.mod_params = &iwl50_mod_params,
+};
+
 struct iwl_cfg iwl5100_agn_cfg = {
 	.name = "5100AGN",
 	.fw_name = "iwlwifi-5000" IWL5000_UCODE_API ".ucode",
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 163502d..0177a1d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -51,6 +51,8 @@ extern struct iwl_cfg iwl4965_agn_cfg;
 extern struct iwl_cfg iwl5300_agn_cfg;
 extern struct iwl_cfg iwl5100_agn_cfg;
 extern struct iwl_cfg iwl5350_agn_cfg;
+extern struct iwl_cfg iwl5100_bg_cfg;
+extern struct iwl_cfg iwl5100_abg_cfg;
 
 /* Change firmware file name, using "-" and incrementing number,
  *   *only* when uCode interface or architecture changes so that it
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 7f65d91..47071f2 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -4409,8 +4409,16 @@ static struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x4229, PCI_ANY_ID, iwl4965_agn_cfg)},
 	{IWL_PCI_DEVICE(0x4230, PCI_ANY_ID, iwl4965_agn_cfg)},
 #ifdef CONFIG_IWL5000
-	{IWL_PCI_DEVICE(0x4235, PCI_ANY_ID, iwl5300_agn_cfg)},
+	{IWL_PCI_DEVICE(0x4232, 0x1205, iwl5100_bg_cfg)},
+	{IWL_PCI_DEVICE(0x4232, 0x1305, iwl5100_bg_cfg)},
+	{IWL_PCI_DEVICE(0x4232, 0x1206, iwl5100_abg_cfg)},
+	{IWL_PCI_DEVICE(0x4232, 0x1306, iwl5100_abg_cfg)},
+	{IWL_PCI_DEVICE(0x4232, 0x1326, iwl5100_abg_cfg)},
+	{IWL_PCI_DEVICE(0x4237, 0x1216, iwl5100_abg_cfg)},
 	{IWL_PCI_DEVICE(0x4232, PCI_ANY_ID, iwl5100_agn_cfg)},
+	{IWL_PCI_DEVICE(0x4235, PCI_ANY_ID, iwl5300_agn_cfg)},
+	{IWL_PCI_DEVICE(0x4236, PCI_ANY_ID, iwl5300_agn_cfg)},
+	{IWL_PCI_DEVICE(0x4237, PCI_ANY_ID, iwl5100_agn_cfg)},
 	{IWL_PCI_DEVICE(0x423A, PCI_ANY_ID, iwl5350_agn_cfg)},
 #endif /* CONFIG_IWL5000 */
 	{0}
-- 
1.5.3.6

