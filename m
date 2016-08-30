Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:41194 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1758167AbcH3Ljf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Aug 2016 07:39:35 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Oren Givon <oren.givon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 30 Aug 2016 14:38:56 +0300
Message-Id: <1472557142-14782-10-git-send-email-luca@coelho.fi> (sfid-20160830_133939_691621_4FFE8509)
In-Reply-To: <1472557142-14782-1-git-send-email-luca@coelho.fi>
References: <1472556999.27868.86.camel@coelho.fi>
 <1472557142-14782-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 10/16] iwlwifi: add a new series 9460 with new PCI ID
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Oren Givon <oren.givon@intel.com>

Add a new series to the 9000 series called 9460.
In addition, add a new PCI ID that is the 9460 new series.

Signed-off-by: Oren Givon <oren.givon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-9000.c   |  4 ++--
 drivers/net/wireless/intel/iwlwifi/iwl-config.h |  2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c   | 27 +++++++++++++------------
 3 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-9000.c b/drivers/net/wireless/intel/iwlwifi/iwl-9000.c
index b8356a8..5621cf2 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-9000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-9000.c
@@ -156,8 +156,8 @@ const struct iwl_cfg iwl9260_2ac_cfg = {
 	.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
 };
 
-const struct iwl_cfg iwl9000_2ac_cfg = {
-	.name = "Intel(R) Dual Band Wireless AC 9000",
+const struct iwl_cfg iwl9460_2ac_cfg = {
+	.name = "Intel(R) Dual Band Wireless AC 9460",
 	.fw_name_pre = IWL9000_FW_PRE,
 	IWL_DEVICE_9000,
 	.ht_params = &iwl9000_ht_params,
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index 04260fc..a18b57f 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -449,9 +449,9 @@ extern const struct iwl_cfg iwl4165_2ac_cfg;
 extern const struct iwl_cfg iwl8260_2ac_sdio_cfg;
 extern const struct iwl_cfg iwl8265_2ac_sdio_cfg;
 extern const struct iwl_cfg iwl4165_2ac_sdio_cfg;
-extern const struct iwl_cfg iwl9000_2ac_cfg;
 extern const struct iwl_cfg iwl9000lc_2ac_cfg;
 extern const struct iwl_cfg iwl9260_2ac_cfg;
+extern const struct iwl_cfg iwl9460_2ac_cfg;
 extern const struct iwl_cfg iwla000_2ac_cfg;
 #endif /* CONFIG_IWLMVM */
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index bf523f5..d053183 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -504,18 +504,19 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 /* 9000 Series */
 	{IWL_PCI_DEVICE(0x2526, 0x0000, iwl9260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x2526, 0x0010, iwl9260_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x9DF0, 0x0A10, iwl9000_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x9DF0, 0x0010, iwl9000_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x9DF0, 0x0210, iwl9000_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x9DF0, 0x0410, iwl9000_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x9DF0, 0x0610, iwl9000_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x9DF0, 0x0310, iwl9000_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x9DF0, 0x0000, iwl9000_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x9DF0, 0x0510, iwl9000_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x9DF0, 0x2010, iwl9000_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x2526, 0x1420, iwl9000_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x9DF0, 0x0710, iwl9000_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x9DF0, 0x2A10, iwl9000_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x0A10, iwl9460_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x0010, iwl9460_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x0210, iwl9460_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x0410, iwl9460_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x0610, iwl9460_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x0310, iwl9460_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x0000, iwl9460_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x0510, iwl9460_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x2010, iwl9460_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x2526, 0x1420, iwl9460_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x0710, iwl9460_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x2A10, iwl9460_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x30DC, 0x0060, iwl9460_2ac_cfg)},
 
 /* a000 Series */
 	{IWL_PCI_DEVICE(0x2720, 0x0A10, iwla000_2ac_cfg)},
@@ -636,7 +637,7 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	if (iwl_trans->cfg->rf_id) {
-		if (cfg == &iwl9000_2ac_cfg &&
+		if (cfg == &iwl9460_2ac_cfg &&
 		    iwl_trans->hw_rf_id == CSR_HW_RF_ID_TYPE_LC) {
 			cfg = &iwl9000lc_2ac_cfg;
 			iwl_trans->cfg = cfg;
-- 
2.8.1
