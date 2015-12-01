Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:53385 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755920AbbLAJ75 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2015 04:59:57 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Oren Givon <oren.givon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 32/41] iwlwifi: Add PCI IDs for the new 3168 series
Date: Tue,  1 Dec 2015 11:58:58 +0200
Message-Id: <1448963947-24302-32-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151201_110002_908238_1EEA3EAB)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E905B07@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E905B07@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Oren Givon <oren.givon@intel.com>

Add a new struct for the 3168 series and a few new
PCI ID entries.

Signed-off-by: Oren Givon <oren.givon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-7000.c   | 13 +++++++++++++
 drivers/net/wireless/intel/iwlwifi/iwl-config.h |  1 +
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c   |  4 ++++
 3 files changed, 18 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-7000.c b/drivers/net/wireless/intel/iwlwifi/iwl-7000.c
index bf88ec3..51fec20 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-7000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-7000.c
@@ -7,6 +7,7 @@
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
+ * Copyright(c) 2015 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -33,6 +34,7 @@
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
+ * Copyright(c) 2015 Intel Deutschland GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -274,6 +276,17 @@ const struct iwl_cfg iwl3165_2ac_cfg = {
 	.dccm_len = IWL7265_DCCM_LEN,
 };
 
+const struct iwl_cfg iwl3168_2ac_cfg = {
+	.name = "Intel(R) Dual Band Wireless AC 3168",
+	.fw_name_pre = IWL7265D_FW_PRE,
+	IWL_DEVICE_7000,
+	.ht_params = &iwl7000_ht_params,
+	.nvm_ver = IWL3165_NVM_VERSION,
+	.nvm_calib_ver = IWL3165_TX_POWER_VERSION,
+	.pwr_tx_backoffs = iwl7265_pwr_tx_backoffs,
+	.dccm_len = IWL7265_DCCM_LEN,
+};
+
 const struct iwl_cfg iwl7265_2ac_cfg = {
 	.name = "Intel(R) Dual Band Wireless AC 7265",
 	.fw_name_pre = IWL7265_FW_PRE,
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index c9bf9ac..a1452a1 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -420,6 +420,7 @@ extern const struct iwl_cfg iwl3160_2ac_cfg;
 extern const struct iwl_cfg iwl3160_2n_cfg;
 extern const struct iwl_cfg iwl3160_n_cfg;
 extern const struct iwl_cfg iwl3165_2ac_cfg;
+extern const struct iwl_cfg iwl3168_2ac_cfg;
 extern const struct iwl_cfg iwl7265_2ac_cfg;
 extern const struct iwl_cfg iwl7265_2n_cfg;
 extern const struct iwl_cfg iwl7265_n_cfg;
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 37cf81b..fe30c78 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -377,6 +377,10 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x3165, 0x8010, iwl3165_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x3165, 0x8110, iwl3165_2ac_cfg)},
 
+/* 3168 Series */
+	{IWL_PCI_DEVICE(0x24FB, 0x2110, iwl3168_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x24FB, 0x0000, iwl3168_2ac_cfg)},
+
 /* 7265 Series */
 	{IWL_PCI_DEVICE(0x095A, 0x5010, iwl7265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x095A, 0x5110, iwl7265_2ac_cfg)},
-- 
2.5.0

