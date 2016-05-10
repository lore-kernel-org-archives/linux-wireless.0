Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40842 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751496AbcEJUat (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2016 16:30:49 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com
Date: Tue, 10 May 2016 23:06:11 +0300
Message-Id: <1462910797-20303-15-git-send-email-luca@coelho.fi> (sfid-20160510_223053_047217_2D00739C)
In-Reply-To: <1462910797-20303-1-git-send-email-luca@coelho.fi>
References: <1462910585.25219.7.camel@coelho.fi>
 <1462910797-20303-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 15/41] iwlwifi: Rename 9560 to 9260 and add new PCI IDs for it
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Haim Dreyfuss <haim.dreyfuss@intel.com>

Rename 9560 to 9260.
Add new PCI ID for 9260 and change some entries from 5165 to 9260.
Also order the 9000 series.

Signed-off-by: Haim Dreyfuss <haim.dreyfuss@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-9000.c   |  4 ++--
 drivers/net/wireless/intel/iwlwifi/iwl-config.h |  2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c   | 21 +++++++++++----------
 3 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-9000.c b/drivers/net/wireless/intel/iwlwifi/iwl-9000.c
index b9aca37..86a5599 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-9000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-9000.c
@@ -140,8 +140,8 @@ static const struct iwl_tt_params iwl9000_tt_params = {
 	.vht_mu_mimo_supported = true,					\
 	.mac_addr_from_csr = true
 
-const struct iwl_cfg iwl9560_2ac_cfg = {
-		.name = "Intel(R) Dual Band Wireless AC 9560",
+const struct iwl_cfg iwl9260_2ac_cfg = {
+		.name = "Intel(R) Dual Band Wireless AC 9260",
 		.fw_name_pre = IWL9000_FW_PRE,
 		IWL_DEVICE_9000,
 		.ht_params = &iwl9000_ht_params,
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index 95558e3..2e71e88 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -439,7 +439,7 @@ extern const struct iwl_cfg iwl4165_2ac_cfg;
 extern const struct iwl_cfg iwl8260_2ac_sdio_cfg;
 extern const struct iwl_cfg iwl8265_2ac_sdio_cfg;
 extern const struct iwl_cfg iwl4165_2ac_sdio_cfg;
-extern const struct iwl_cfg iwl9560_2ac_cfg;
+extern const struct iwl_cfg iwl9260_2ac_cfg;
 extern const struct iwl_cfg iwl5165_2ac_cfg;
 #endif /* CONFIG_IWLMVM */
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index de42066..8f139d0 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -493,19 +493,20 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x24FD, 0x8130, iwl8265_2ac_cfg)},
 
 /* 9000 Series */
-	{IWL_PCI_DEVICE(0x9DF0, 0x0A10, iwl9560_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x9DF0, 0x0010, iwl9560_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x9DF0, 0x2A10, iwl5165_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x9DF0, 0x2010, iwl5165_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x2526, 0x1420, iwl5165_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x2526, 0x0010, iwl5165_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x9DF0, 0x0000, iwl5165_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x2526, 0x0000, iwl9260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x2526, 0x0010, iwl9260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x0A10, iwl9260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x0010, iwl9260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x0210, iwl9260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x0410, iwl9260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x0610, iwl9260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x9DF0, 0x0310, iwl5165_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x0000, iwl5165_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x9DF0, 0x0510, iwl5165_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x2010, iwl5165_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x2526, 0x1420, iwl5165_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x9DF0, 0x0710, iwl5165_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x9DF0, 0x0210, iwl9560_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x9DF0, 0x0410, iwl9560_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x9DF0, 0x0610, iwl9560_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x2A10, iwl5165_2ac_cfg)},
 #endif /* CONFIG_IWLMVM */
 
 	{0}
-- 
2.8.1

