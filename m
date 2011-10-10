Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:61902 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751284Ab1JJPQ3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 11:16:29 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 15/34] iwlagn: add "_d" sku to 6005 series of devices
Date: Mon, 10 Oct 2011 07:27:00 -0700
Message-Id: <1318256839-31837-16-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111010_171737_315099_BFE42C0B)
In-Reply-To: <1318256839-31837-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1318256839-31837-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add additional sku to 6005 series of devices

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-6000.c |    6 ++++++
 drivers/net/wireless/iwlwifi/iwl-cfg.h  |    1 +
 drivers/net/wireless/iwlwifi/iwl-pci.c  |    1 +
 3 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index d81c87d..8e3cdd9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -393,6 +393,12 @@ struct iwl_cfg iwl6005_2agn_sff_cfg = {
 	.ht_params = &iwl6000_ht_params,
 };
 
+struct iwl_cfg iwl6005_2agn_d_cfg = {
+	.name = "Intel(R) Centrino(R) Advanced-N 6205D AGN",
+	IWL_DEVICE_6005,
+	.ht_params = &iwl6000_ht_params,
+};
+
 #define IWL_DEVICE_6030						\
 	.fw_name_pre = IWL6030_FW_PRE,				\
 	.ucode_api_max = IWL6000G2_UCODE_API_MAX,		\
diff --git a/drivers/net/wireless/iwlwifi/iwl-cfg.h b/drivers/net/wireless/iwlwifi/iwl-cfg.h
index d4f317c..df2ff32 100644
--- a/drivers/net/wireless/iwlwifi/iwl-cfg.h
+++ b/drivers/net/wireless/iwlwifi/iwl-cfg.h
@@ -79,6 +79,7 @@ extern struct iwl_cfg iwl6005_2agn_cfg;
 extern struct iwl_cfg iwl6005_2abg_cfg;
 extern struct iwl_cfg iwl6005_2bg_cfg;
 extern struct iwl_cfg iwl6005_2agn_sff_cfg;
+extern struct iwl_cfg iwl6005_2agn_d_cfg;
 extern struct iwl_cfg iwl1030_bgn_cfg;
 extern struct iwl_cfg iwl1030_bg_cfg;
 extern struct iwl_cfg iwl6030_2agn_cfg;
diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c b/drivers/net/wireless/iwlwifi/iwl-pci.c
index 1d7bb74..11c09e5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -254,6 +254,7 @@ static DEFINE_PCI_DEVICE_TABLE(iwl_hw_card_ids) = {
 	{IWL_PCI_DEVICE(0x0085, 0x1316, iwl6005_2abg_cfg)},
 	{IWL_PCI_DEVICE(0x0082, 0xC020, iwl6005_2agn_sff_cfg)},
 	{IWL_PCI_DEVICE(0x0085, 0xC220, iwl6005_2agn_sff_cfg)},
+	{IWL_PCI_DEVICE(0x0082, 0x1341, iwl6005_2agn_d_cfg)},
 
 /* 6x30 Series */
 	{IWL_PCI_DEVICE(0x008A, 0x5305, iwl1030_bgn_cfg)},
-- 
1.7.0.4

