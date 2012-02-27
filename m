Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:45594 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755458Ab2B0XTK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 18:19:10 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 23/24] iwlwifi: update pci subsystem id
Date: Mon, 27 Feb 2012 14:07:47 -0800
Message-Id: <1330380468-17674-24-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120228_001919_073865_4EF91EDF)
In-Reply-To: <1330380468-17674-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330380468-17674-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update the pci subsystem id and product name for 6005 series devices

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-6000.c |   11 +++++++++++
 drivers/net/wireless/iwlwifi/iwl-cfg.h  |    2 ++
 drivers/net/wireless/iwlwifi/iwl-pci.c  |    6 +++---
 3 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 1e6fbf4..223e60a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -383,6 +383,17 @@ struct iwl_cfg iwl6005_2agn_d_cfg = {
 	.ht_params = &iwl6000_ht_params,
 };
 
+struct iwl_cfg iwl6005_2agn_mow1_cfg = {
+	.name = "Intel(R) Centrino(R) Advanced-N 6206 AGN",
+	IWL_DEVICE_6005,
+	.ht_params = &iwl6000_ht_params,
+};
+struct iwl_cfg iwl6005_2agn_mow2_cfg = {
+	.name = "Intel(R) Centrino(R) Advanced-N 6207 AGN",
+	IWL_DEVICE_6005,
+	.ht_params = &iwl6000_ht_params,
+};
+
 #define IWL_DEVICE_6030						\
 	.fw_name_pre = IWL6030_FW_PRE,				\
 	.ucode_api_max = IWL6000G2_UCODE_API_MAX,		\
diff --git a/drivers/net/wireless/iwlwifi/iwl-cfg.h b/drivers/net/wireless/iwlwifi/iwl-cfg.h
index 957bc00..1ad14bb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-cfg.h
+++ b/drivers/net/wireless/iwlwifi/iwl-cfg.h
@@ -80,6 +80,8 @@ extern struct iwl_cfg iwl6005_2abg_cfg;
 extern struct iwl_cfg iwl6005_2bg_cfg;
 extern struct iwl_cfg iwl6005_2agn_sff_cfg;
 extern struct iwl_cfg iwl6005_2agn_d_cfg;
+extern struct iwl_cfg iwl6005_2agn_mow1_cfg;
+extern struct iwl_cfg iwl6005_2agn_mow2_cfg;
 extern struct iwl_cfg iwl1030_bgn_cfg;
 extern struct iwl_cfg iwl1030_bg_cfg;
 extern struct iwl_cfg iwl6030_2agn_cfg;
diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c b/drivers/net/wireless/iwlwifi/iwl-pci.c
index 93bd9f6..0ce7047 100644
--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -158,9 +158,9 @@ static DEFINE_PCI_DEVICE_TABLE(iwl_hw_card_ids) = {
 	{IWL_PCI_DEVICE(0x0085, 0x1316, iwl6005_2abg_cfg)},
 	{IWL_PCI_DEVICE(0x0082, 0xC020, iwl6005_2agn_sff_cfg)},
 	{IWL_PCI_DEVICE(0x0085, 0xC220, iwl6005_2agn_sff_cfg)},
-	{IWL_PCI_DEVICE(0x0082, 0x1341, iwl6005_2agn_d_cfg)},
-	{IWL_PCI_DEVICE(0x0082, 0x1304, iwl6005_2agn_cfg)},/* low 5GHz active */
-	{IWL_PCI_DEVICE(0x0082, 0x1305, iwl6005_2agn_cfg)},/* high 5GHz active */
+	{IWL_PCI_DEVICE(0x0082, 0x4820, iwl6005_2agn_d_cfg)},
+	{IWL_PCI_DEVICE(0x0082, 0x1304, iwl6005_2agn_mow1_cfg)},/* low 5GHz active */
+	{IWL_PCI_DEVICE(0x0082, 0x1305, iwl6005_2agn_mow2_cfg)},/* high 5GHz active */
 
 /* 6x30 Series */
 	{IWL_PCI_DEVICE(0x008A, 0x5305, iwl1030_bgn_cfg)},
-- 
1.7.0.4

