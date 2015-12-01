Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:53385 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755920AbbLAJ77 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2015 04:59:59 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Oren Givon <oren.givon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 33/41] iwlwifi: Add PCI IDs for the new series 8165
Date: Tue,  1 Dec 2015 11:58:59 +0200
Message-Id: <1448963947-24302-33-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151201_110007_025671_20A24F08)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E905B07@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E905B07@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Oren Givon <oren.givon@intel.com>

Add a new struct for the 8165 series and a few new
PCI ID entries.

Signed-off-by: Oren Givon <oren.givon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-8000.c   | 10 ++++++++++
 drivers/net/wireless/intel/iwlwifi/iwl-config.h |  1 +
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c   |  2 ++
 3 files changed, 13 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-8000.c b/drivers/net/wireless/intel/iwlwifi/iwl-8000.c
index dd22b78..89a25cf 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-8000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-8000.c
@@ -186,6 +186,16 @@ const struct iwl_cfg iwl8260_2ac_cfg = {
 	.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
 };
 
+const struct iwl_cfg iwl8265_2ac_cfg = {
+	.name = "Intel(R) Dual Band Wireless AC 8265",
+	.fw_name_pre = IWL8000_FW_PRE,
+	IWL_DEVICE_8000,
+	.ht_params = &iwl8000_ht_params,
+	.nvm_ver = IWL8000_NVM_VERSION,
+	.nvm_calib_ver = IWL8000_TX_POWER_VERSION,
+	.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
+};
+
 const struct iwl_cfg iwl4165_2ac_cfg = {
 	.name = "Intel(R) Dual Band Wireless AC 4165",
 	.fw_name_pre = IWL8000_FW_PRE,
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index a1452a1..6a4c0c2 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -429,6 +429,7 @@ extern const struct iwl_cfg iwl7265d_2n_cfg;
 extern const struct iwl_cfg iwl7265d_n_cfg;
 extern const struct iwl_cfg iwl8260_2n_cfg;
 extern const struct iwl_cfg iwl8260_2ac_cfg;
+extern const struct iwl_cfg iwl8265_2ac_cfg;
 extern const struct iwl_cfg iwl4165_2ac_cfg;
 extern const struct iwl_cfg iwl8260_2ac_sdio_cfg;
 extern const struct iwl_cfg iwl4165_2ac_sdio_cfg;
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index fe30c78..9bdce44 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -471,6 +471,8 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x24F3, 0x0850, iwl8260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24F3, 0x0950, iwl8260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24F3, 0x0930, iwl8260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x24FD, 0x0000, iwl8265_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x24FD, 0x0010, iwl8265_2ac_cfg)},
 
 /* 9000 Series */
 	{IWL_PCI_DEVICE(0x9DF0, 0x2A10, iwl5165_2ac_cfg)},
-- 
2.5.0

