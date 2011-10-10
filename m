Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:54032 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293Ab1JJPQ3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 11:16:29 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 16/34] iwlagn: Add "_d" sku to 105 series of devices
Date: Mon, 10 Oct 2011 07:27:01 -0700
Message-Id: <1318256839-31837-17-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111010_171718_647954_E8E25C89)
In-Reply-To: <1318256839-31837-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1318256839-31837-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add additional sku to 105 series

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-2000.c |    6 ++++++
 drivers/net/wireless/iwlwifi/iwl-cfg.h  |    1 +
 drivers/net/wireless/iwlwifi/iwl-pci.c  |    1 +
 3 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index 09a6b8e..c7634b2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -340,6 +340,12 @@ struct iwl_cfg iwl105_bgn_cfg = {
 	.ht_params = &iwl2000_ht_params,
 };
 
+struct iwl_cfg iwl105_bgn_d_cfg = {
+	.name = "105D Series 1x1 BGN",
+	IWL_DEVICE_105,
+	.ht_params = &iwl2000_ht_params,
+};
+
 #define IWL_DEVICE_135						\
 	.fw_name_pre = IWL135_FW_PRE,				\
 	.ucode_api_max = IWL135_UCODE_API_MAX,			\
diff --git a/drivers/net/wireless/iwlwifi/iwl-cfg.h b/drivers/net/wireless/iwlwifi/iwl-cfg.h
index df2ff32..2a2dc45 100644
--- a/drivers/net/wireless/iwlwifi/iwl-cfg.h
+++ b/drivers/net/wireless/iwlwifi/iwl-cfg.h
@@ -110,6 +110,7 @@ extern struct iwl_cfg iwl6035_2abg_cfg;
 extern struct iwl_cfg iwl6035_2bg_cfg;
 extern struct iwl_cfg iwl105_bg_cfg;
 extern struct iwl_cfg iwl105_bgn_cfg;
+extern struct iwl_cfg iwl105_bgn_d_cfg;
 extern struct iwl_cfg iwl135_bg_cfg;
 extern struct iwl_cfg iwl135_bgn_cfg;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c b/drivers/net/wireless/iwlwifi/iwl-pci.c
index 11c09e5..3b6cc66 100644
--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -355,6 +355,7 @@ static DEFINE_PCI_DEVICE_TABLE(iwl_hw_card_ids) = {
 	{IWL_PCI_DEVICE(0x0894, 0x0026, iwl105_bg_cfg)},
 	{IWL_PCI_DEVICE(0x0895, 0x0226, iwl105_bg_cfg)},
 	{IWL_PCI_DEVICE(0x0894, 0x0426, iwl105_bg_cfg)},
+	{IWL_PCI_DEVICE(0x0894, 0x0822, iwl105_bgn_d_cfg)},
 
 /* 135 Series */
 	{IWL_PCI_DEVICE(0x0892, 0x0062, iwl135_bgn_cfg)},
-- 
1.7.0.4

