Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:49685 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757366Ab0JWQSO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Oct 2010 12:18:14 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 8/8] iwlagn: use 6000g2b uCode for 130 series devices
Date: Sat, 23 Oct 2010 09:15:46 -0700
Message-Id: <1287850546-23500-9-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1287850546-23500-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1287850546-23500-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For 130 series device, 6000g2b uCode will be used, no need to
have additional defines for 130 devices, so remove those.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-6000.c |   15 ++++-----------
 1 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index eacbce0..b181690 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -53,13 +53,11 @@
 #define IWL6000_UCODE_API_MAX 4
 #define IWL6050_UCODE_API_MAX 5
 #define IWL6000G2_UCODE_API_MAX 5
-#define IWL130_UCODE_API_MAX 5
 
 /* Lowest firmware API version supported */
 #define IWL6000_UCODE_API_MIN 4
 #define IWL6050_UCODE_API_MIN 4
 #define IWL6000G2_UCODE_API_MIN 4
-#define IWL130_UCODE_API_MIN 5
 
 #define IWL6000_FW_PRE "iwlwifi-6000-"
 #define _IWL6000_MODULE_FIRMWARE(api) IWL6000_FW_PRE #api ".ucode"
@@ -77,10 +75,6 @@
 #define _IWL6000G2B_MODULE_FIRMWARE(api) IWL6000G2B_FW_PRE #api ".ucode"
 #define IWL6000G2B_MODULE_FIRMWARE(api) _IWL6000G2B_MODULE_FIRMWARE(api)
 
-#define IWL130_FW_PRE "iwlwifi-130-"
-#define _IWL130_MODULE_FIRMWARE(api) IWL130_FW_PRE #api ".ucode"
-#define IWL130_MODULE_FIRMWARE(api) _IWL130_MODULE_FIRMWARE(api)
-
 static void iwl6000_set_ct_threshold(struct iwl_priv *priv)
 {
 	/* want Celsius */
@@ -838,8 +832,8 @@ struct iwl_cfg iwl6000_3agn_cfg = {
 struct iwl_cfg iwl130_bgn_cfg = {
 	.name = "Intel(R) 130 Series 1x1 BGN",
 	.fw_name_pre = IWL6000G2B_FW_PRE,
-	.ucode_api_max = IWL130_UCODE_API_MAX,
-	.ucode_api_min = IWL130_UCODE_API_MIN,
+	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
+	.ucode_api_min = IWL6000G2_UCODE_API_MIN,
 	.sku = IWL_SKU_G|IWL_SKU_N,
 	.valid_tx_ant = ANT_A,
 	.valid_rx_ant = ANT_A,
@@ -858,8 +852,8 @@ struct iwl_cfg iwl130_bgn_cfg = {
 struct iwl_cfg iwl130_bg_cfg = {
 	.name = "Intel(R) 130 Series 1x2 BG",
 	.fw_name_pre = IWL6000G2B_FW_PRE,
-	.ucode_api_max = IWL130_UCODE_API_MAX,
-	.ucode_api_min = IWL130_UCODE_API_MIN,
+	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
+	.ucode_api_min = IWL6000G2_UCODE_API_MIN,
 	.sku = IWL_SKU_G,
 	.valid_tx_ant = ANT_A,
 	.valid_rx_ant = ANT_A,
@@ -878,4 +872,3 @@ MODULE_FIRMWARE(IWL6000_MODULE_FIRMWARE(IWL6000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL6050_MODULE_FIRMWARE(IWL6050_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL6000G2A_MODULE_FIRMWARE(IWL6000G2_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL6000G2B_MODULE_FIRMWARE(IWL6000G2_UCODE_API_MAX));
-MODULE_FIRMWARE(IWL130_MODULE_FIRMWARE(IWL130_UCODE_API_MAX));
-- 
1.7.0.4

