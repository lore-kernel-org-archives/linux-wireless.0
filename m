Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:56565 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753356Ab1KJBdc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Nov 2011 20:33:32 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 07/28] iwlwifi: remove un-supported SKUs
Date: Wed,  9 Nov 2011 16:39:10 -0800
Message-Id: <1320885571-19122-8-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111110_023347_151428_9D9E1D80)
In-Reply-To: <1320885571-19122-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1320885571-19122-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

BG only SKUs are no longer supported by 2000 and 1x5 series. Remove it

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-2000.c |   20 --------------------
 drivers/net/wireless/iwlwifi/iwl-6000.c |   10 ----------
 drivers/net/wireless/iwlwifi/iwl-cfg.h  |    6 ------
 drivers/net/wireless/iwlwifi/iwl-pci.c  |   18 ------------------
 4 files changed, 0 insertions(+), 54 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index 7943197..b319357 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -270,11 +270,6 @@ struct iwl_cfg iwl2000_2bgn_cfg = {
 	.ht_params = &iwl2000_ht_params,
 };
 
-struct iwl_cfg iwl2000_2bg_cfg = {
-	.name = "2000 Series 2x2 BG",
-	IWL_DEVICE_2000,
-};
-
 struct iwl_cfg iwl2000_2bgn_d_cfg = {
 	.name = "2000D Series 2x2 BGN",
 	IWL_DEVICE_2000,
@@ -304,11 +299,6 @@ struct iwl_cfg iwl2030_2bgn_cfg = {
 	.ht_params = &iwl2000_ht_params,
 };
 
-struct iwl_cfg iwl2030_2bg_cfg = {
-	.name = "2000 Series 2x2 BG/BT",
-	IWL_DEVICE_2030,
-};
-
 #define IWL_DEVICE_105						\
 	.fw_name_pre = IWL105_FW_PRE,				\
 	.ucode_api_max = IWL105_UCODE_API_MAX,			\
@@ -326,11 +316,6 @@ struct iwl_cfg iwl2030_2bg_cfg = {
 	.rx_with_siso_diversity = true,				\
 	.iq_invert = true					\
 
-struct iwl_cfg iwl105_bg_cfg = {
-	.name = "105 Series 1x1 BG",
-	IWL_DEVICE_105,
-};
-
 struct iwl_cfg iwl105_bgn_cfg = {
 	.name = "105 Series 1x1 BGN",
 	IWL_DEVICE_105,
@@ -361,11 +346,6 @@ struct iwl_cfg iwl105_bgn_d_cfg = {
 	.rx_with_siso_diversity = true,				\
 	.iq_invert = true					\
 
-struct iwl_cfg iwl135_bg_cfg = {
-	.name = "135 Series 1x1 BG/BT",
-	IWL_DEVICE_135,
-};
-
 struct iwl_cfg iwl135_bgn_cfg = {
 	.name = "135 Series 1x1 BGN/BT",
 	IWL_DEVICE_135,
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index c840c78..ee3363f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -439,16 +439,6 @@ struct iwl_cfg iwl6035_2agn_cfg = {
 	.ht_params = &iwl6000_ht_params,
 };
 
-struct iwl_cfg iwl6035_2abg_cfg = {
-	.name = "6035 Series 2x2 ABG/BT",
-	IWL_DEVICE_6030,
-};
-
-struct iwl_cfg iwl6035_2bg_cfg = {
-	.name = "6035 Series 2x2 BG/BT",
-	IWL_DEVICE_6030,
-};
-
 struct iwl_cfg iwl1030_bgn_cfg = {
 	.name = "Intel(R) Centrino(R) Wireless-N 1030 BGN",
 	IWL_DEVICE_6030,
diff --git a/drivers/net/wireless/iwlwifi/iwl-cfg.h b/drivers/net/wireless/iwlwifi/iwl-cfg.h
index 2a2dc45..e1d7825 100644
--- a/drivers/net/wireless/iwlwifi/iwl-cfg.h
+++ b/drivers/net/wireless/iwlwifi/iwl-cfg.h
@@ -101,17 +101,11 @@ extern struct iwl_cfg iwl100_bg_cfg;
 extern struct iwl_cfg iwl130_bgn_cfg;
 extern struct iwl_cfg iwl130_bg_cfg;
 extern struct iwl_cfg iwl2000_2bgn_cfg;
-extern struct iwl_cfg iwl2000_2bg_cfg;
 extern struct iwl_cfg iwl2000_2bgn_d_cfg;
 extern struct iwl_cfg iwl2030_2bgn_cfg;
-extern struct iwl_cfg iwl2030_2bg_cfg;
 extern struct iwl_cfg iwl6035_2agn_cfg;
-extern struct iwl_cfg iwl6035_2abg_cfg;
-extern struct iwl_cfg iwl6035_2bg_cfg;
-extern struct iwl_cfg iwl105_bg_cfg;
 extern struct iwl_cfg iwl105_bgn_cfg;
 extern struct iwl_cfg iwl105_bgn_d_cfg;
-extern struct iwl_cfg iwl135_bg_cfg;
 extern struct iwl_cfg iwl135_bgn_cfg;
 
 #endif /* __iwl_pci_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c b/drivers/net/wireless/iwlwifi/iwl-pci.c
index 9ecfbd7..86d6a23 100644
--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -326,46 +326,28 @@ static DEFINE_PCI_DEVICE_TABLE(iwl_hw_card_ids) = {
 	{IWL_PCI_DEVICE(0x0890, 0x4022, iwl2000_2bgn_cfg)},
 	{IWL_PCI_DEVICE(0x0891, 0x4222, iwl2000_2bgn_cfg)},
 	{IWL_PCI_DEVICE(0x0890, 0x4422, iwl2000_2bgn_cfg)},
-	{IWL_PCI_DEVICE(0x0890, 0x4026, iwl2000_2bg_cfg)},
-	{IWL_PCI_DEVICE(0x0891, 0x4226, iwl2000_2bg_cfg)},
-	{IWL_PCI_DEVICE(0x0890, 0x4426, iwl2000_2bg_cfg)},
 	{IWL_PCI_DEVICE(0x0890, 0x4822, iwl2000_2bgn_d_cfg)},
 
 /* 2x30 Series */
 	{IWL_PCI_DEVICE(0x0887, 0x4062, iwl2030_2bgn_cfg)},
 	{IWL_PCI_DEVICE(0x0888, 0x4262, iwl2030_2bgn_cfg)},
 	{IWL_PCI_DEVICE(0x0887, 0x4462, iwl2030_2bgn_cfg)},
-	{IWL_PCI_DEVICE(0x0887, 0x4066, iwl2030_2bg_cfg)},
-	{IWL_PCI_DEVICE(0x0888, 0x4266, iwl2030_2bg_cfg)},
-	{IWL_PCI_DEVICE(0x0887, 0x4466, iwl2030_2bg_cfg)},
 
 /* 6x35 Series */
 	{IWL_PCI_DEVICE(0x088E, 0x4060, iwl6035_2agn_cfg)},
 	{IWL_PCI_DEVICE(0x088F, 0x4260, iwl6035_2agn_cfg)},
 	{IWL_PCI_DEVICE(0x088E, 0x4460, iwl6035_2agn_cfg)},
-	{IWL_PCI_DEVICE(0x088E, 0x4064, iwl6035_2abg_cfg)},
-	{IWL_PCI_DEVICE(0x088F, 0x4264, iwl6035_2abg_cfg)},
-	{IWL_PCI_DEVICE(0x088E, 0x4464, iwl6035_2abg_cfg)},
-	{IWL_PCI_DEVICE(0x088E, 0x4066, iwl6035_2bg_cfg)},
-	{IWL_PCI_DEVICE(0x088F, 0x4266, iwl6035_2bg_cfg)},
-	{IWL_PCI_DEVICE(0x088E, 0x4466, iwl6035_2bg_cfg)},
 
 /* 105 Series */
 	{IWL_PCI_DEVICE(0x0894, 0x0022, iwl105_bgn_cfg)},
 	{IWL_PCI_DEVICE(0x0895, 0x0222, iwl105_bgn_cfg)},
 	{IWL_PCI_DEVICE(0x0894, 0x0422, iwl105_bgn_cfg)},
-	{IWL_PCI_DEVICE(0x0894, 0x0026, iwl105_bg_cfg)},
-	{IWL_PCI_DEVICE(0x0895, 0x0226, iwl105_bg_cfg)},
-	{IWL_PCI_DEVICE(0x0894, 0x0426, iwl105_bg_cfg)},
 	{IWL_PCI_DEVICE(0x0894, 0x0822, iwl105_bgn_d_cfg)},
 
 /* 135 Series */
 	{IWL_PCI_DEVICE(0x0892, 0x0062, iwl135_bgn_cfg)},
 	{IWL_PCI_DEVICE(0x0893, 0x0262, iwl135_bgn_cfg)},
 	{IWL_PCI_DEVICE(0x0892, 0x0462, iwl135_bgn_cfg)},
-	{IWL_PCI_DEVICE(0x0892, 0x0066, iwl135_bg_cfg)},
-	{IWL_PCI_DEVICE(0x0893, 0x0266, iwl135_bg_cfg)},
-	{IWL_PCI_DEVICE(0x0892, 0x0466, iwl135_bg_cfg)},
 
 	{0}
 };
-- 
1.7.0.4

