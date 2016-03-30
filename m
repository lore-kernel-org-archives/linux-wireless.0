Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:24696 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754142AbcC3OF6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2016 10:05:58 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Haim Dreyfuss <haim.dreyfuss@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 17/43] iwlwifi: 9000: update device id and FW serial number
Date: Wed, 30 Mar 2016 17:04:49 +0300
Message-Id: <1459346715-7954-17-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160330_160612_610082_C087F2FB)
In-Reply-To: <1459346667.4731.9.camel@intel.com>
References: <1459346667.4731.9.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Haim Dreyfuss <haim.dreyfuss@intel.com>

Update device id and FW serial number for 2X2 antenna devices
in 9000 generation product. These will not be available on
the market in the coming year.

Signed-off-by: Haim Dreyfuss <haim.dreyfuss@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-9000.c   |  8 ++++----
 drivers/net/wireless/intel/iwlwifi/iwl-config.h |  2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c   | 10 +++++-----
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-9000.c b/drivers/net/wireless/intel/iwlwifi/iwl-9000.c
index 318b1dc..642fc92 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-9000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-9000.c
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2015 Intel Deutschland GmbH
+ * Copyright(c) 2015-2016 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -18,7 +18,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2015 Intel Deutschland GmbH
+ * Copyright(c) 2015-2016 Intel Deutschland GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -143,8 +143,8 @@ static const struct iwl_tt_params iwl9000_tt_params = {
 	.vht_mu_mimo_supported = true,					\
 	.mac_addr_from_csr = true
 
-const struct iwl_cfg iwl9260_2ac_cfg = {
-		.name = "Intel(R) Dual Band Wireless AC 9260",
+const struct iwl_cfg iwl9560_2ac_cfg = {
+		.name = "Intel(R) Dual Band Wireless AC 9560",
 		.fw_name_pre = IWL9000_FW_PRE,
 		IWL_DEVICE_9000,
 		.ht_params = &iwl9000_ht_params,
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index 3e4d346..8cbd248 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -439,7 +439,7 @@ extern const struct iwl_cfg iwl8265_2ac_cfg;
 extern const struct iwl_cfg iwl4165_2ac_cfg;
 extern const struct iwl_cfg iwl8260_2ac_sdio_cfg;
 extern const struct iwl_cfg iwl4165_2ac_sdio_cfg;
-extern const struct iwl_cfg iwl9260_2ac_cfg;
+extern const struct iwl_cfg iwl9560_2ac_cfg;
 extern const struct iwl_cfg iwl5165_2ac_cfg;
 #endif /* CONFIG_IWLMVM */
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 3456669..fb8b5ec 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -485,15 +485,15 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 /* 9000 Series */
 	{IWL_PCI_DEVICE(0x9DF0, 0x2A10, iwl5165_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x9DF0, 0x2010, iwl5165_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x9DF0, 0x0A10, iwl9260_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x9DF0, 0x0010, iwl9260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x2526, 0x0A10, iwl9560_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x2526, 0x0010, iwl9560_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x9DF0, 0x0000, iwl5165_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x9DF0, 0x0310, iwl5165_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x9DF0, 0x0510, iwl5165_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x9DF0, 0x0710, iwl5165_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x9DF0, 0x0210, iwl9260_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x9DF0, 0x0410, iwl9260_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x9DF0, 0x0610, iwl9260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x2526, 0x0210, iwl9560_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x2526, 0x0410, iwl9560_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x2526, 0x0610, iwl9560_2ac_cfg)},
 #endif /* CONFIG_IWLMVM */
 
 	{0}
-- 
2.5.0

