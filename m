Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:42471 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753977AbbAVUdk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2015 15:33:40 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Oren Givon <oren.givon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 04/38] iwlwifi: add new config and PCI IDs for 4165 series
Date: Thu, 22 Jan 2015 22:32:55 +0200
Message-Id: <1421958809-3371-4-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150122_214447_784489_2B4F6605)
In-Reply-To: <1421958313.6424.2.camel@egrumbacBox>
References: <1421958313.6424.2.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Oren Givon <oren.givon@intel.com>

Add a new config for 4165 series over PCI and insert support
for two new 4165 series PCI IDs.

Signed-off-by: Oren Givon <oren.givon@intel.com>
Reviewed-by: Liad Kaufman <liad.kaufman@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-8000.c   | 10 ++++++++++
 drivers/net/wireless/iwlwifi/iwl-config.h |  1 +
 drivers/net/wireless/iwlwifi/pcie/drv.c   |  2 ++
 3 files changed, 13 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-8000.c b/drivers/net/wireless/iwlwifi/iwl-8000.c
index 46e9c9a..9eca533 100644
--- a/drivers/net/wireless/iwlwifi/iwl-8000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-8000.c
@@ -156,6 +156,16 @@ const struct iwl_cfg iwl8260_2ac_cfg = {
 	.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
 };
 
+const struct iwl_cfg iwl4165_2ac_cfg = {
+	.name = "Intel(R) Dual Band Wireless AC 4165",
+	.fw_name_pre = IWL8000_FW_PRE,
+	IWL_DEVICE_8000,
+	.ht_params = &iwl8000_ht_params,
+	.nvm_ver = IWL8000_NVM_VERSION,
+	.nvm_calib_ver = IWL8000_TX_POWER_VERSION,
+	.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
+};
+
 const struct iwl_cfg iwl8260_2ac_sdio_cfg = {
 	.name = "Intel(R) Dual Band Wireless-AC 8260",
 	.fw_name_pre = IWL8000_FW_PRE,
diff --git a/drivers/net/wireless/iwlwifi/iwl-config.h b/drivers/net/wireless/iwlwifi/iwl-config.h
index fa0bc48..0eaafd8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/iwlwifi/iwl-config.h
@@ -378,6 +378,7 @@ extern const struct iwl_cfg iwl7265d_2n_cfg;
 extern const struct iwl_cfg iwl7265d_n_cfg;
 extern const struct iwl_cfg iwl8260_2n_cfg;
 extern const struct iwl_cfg iwl8260_2ac_cfg;
+extern const struct iwl_cfg iwl4165_2ac_cfg;
 extern const struct iwl_cfg iwl8260_2ac_sdio_cfg;
 extern const struct iwl_cfg iwl4165_2ac_sdio_cfg;
 #endif /* CONFIG_IWLMVM */
diff --git a/drivers/net/wireless/iwlwifi/pcie/drv.c b/drivers/net/wireless/iwlwifi/pcie/drv.c
index 3ee8e38..c7820aa 100644
--- a/drivers/net/wireless/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/iwlwifi/pcie/drv.c
@@ -411,6 +411,8 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x24F3, 0x0010, iwl8260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24F3, 0x0004, iwl8260_2n_cfg)},
 	{IWL_PCI_DEVICE(0x24F4, 0x0030, iwl8260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x24F5, 0x0010, iwl4165_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x24F6, 0x0030, iwl4165_2ac_cfg)},
 #endif /* CONFIG_IWLMVM */
 
 	{0}
-- 
1.9.1

