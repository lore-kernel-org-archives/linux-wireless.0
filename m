Return-Path: <SRS0=80NG=P2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9DFAC5AC81
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Jan 2019 19:01:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A9FC82086D
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Jan 2019 19:01:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729272AbfARTBO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 18 Jan 2019 14:01:14 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:48462 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729187AbfARTBN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Jan 2019 14:01:13 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gkZNN-0004cj-OD; Fri, 18 Jan 2019 21:00:22 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 18 Jan 2019 20:59:59 +0200
Message-Id: <20190118190004.22270-12-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190118190004.22270-1-luca@coelho.fi>
References: <20190118190004.22270-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 11/16] iwlwifi: remove support for 9000 A-step devices
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

We don't support 9000 A-step devices anymore, so we can remove support
for loading both the a0/a0 and a0/b0 FWs.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c | 110 ++++++------------
 .../net/wireless/intel/iwlwifi/iwl-config.h   |   6 -
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c  |  27 ++---
 3 files changed, 45 insertions(+), 98 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/9000.c b/drivers/net/wireless/intel/iwlwifi/cfg/9000.c
index f2114137c13f..09618f176f4f 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/9000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/9000.c
@@ -73,21 +73,12 @@
 #define IWL9000_SMEM_OFFSET		0x400000
 #define IWL9000_SMEM_LEN		0x68000
 
-#define  IWL9000A_FW_PRE "iwlwifi-9000-pu-a0-jf-a0-"
-#define  IWL9000B_FW_PRE "iwlwifi-9000-pu-b0-jf-b0-"
-#define  IWL9000RFB_FW_PRE "iwlwifi-9000-pu-a0-jf-b0-"
-#define  IWL9260A_FW_PRE "iwlwifi-9260-th-a0-jf-a0-"
-#define  IWL9260B_FW_PRE "iwlwifi-9260-th-b0-jf-b0-"
-#define IWL9000A_MODULE_FIRMWARE(api) \
-	IWL9000A_FW_PRE __stringify(api) ".ucode"
-#define IWL9000B_MODULE_FIRMWARE(api) \
-	IWL9000B_FW_PRE __stringify(api) ".ucode"
-#define IWL9000RFB_MODULE_FIRMWARE(api) \
-	IWL9000RFB_FW_PRE __stringify(api) ".ucode"
-#define IWL9260A_MODULE_FIRMWARE(api) \
-	IWL9260A_FW_PRE __stringify(api) ".ucode"
-#define IWL9260B_MODULE_FIRMWARE(api) \
-	IWL9260B_FW_PRE __stringify(api) ".ucode"
+#define  IWL9000_FW_PRE "iwlwifi-9000-pu-b0-jf-b0-"
+#define  IWL9260_FW_PRE "iwlwifi-9260-th-b0-jf-b0-"
+#define IWL9000_MODULE_FIRMWARE(api) \
+	IWL9000_FW_PRE __stringify(api) ".ucode"
+#define IWL9260_MODULE_FIRMWARE(api) \
+	IWL9260_FW_PRE __stringify(api) ".ucode"
 
 static const struct iwl_base_params iwl9000_base_params = {
 	.eeprom_size = OTP_LOW_IMAGE_SIZE_32K,
@@ -162,81 +153,67 @@ static const struct iwl_tt_params iwl9000_tt_params = {
 
 const struct iwl_cfg iwl9160_2ac_cfg = {
 	.name = "Intel(R) Dual Band Wireless AC 9160",
-	.fw_name_pre = IWL9260A_FW_PRE,
-	.fw_name_pre_b_or_c_step = IWL9260B_FW_PRE,
+	.fw_name_pre = IWL9260_FW_PRE,
 	IWL_DEVICE_9000,
 };
 
 const struct iwl_cfg iwl9260_2ac_cfg = {
 	.name = "Intel(R) Dual Band Wireless AC 9260",
-	.fw_name_pre = IWL9260A_FW_PRE,
-	.fw_name_pre_b_or_c_step = IWL9260B_FW_PRE,
+	.fw_name_pre = IWL9260_FW_PRE,
 	IWL_DEVICE_9000,
 };
 
 const struct iwl_cfg iwl9260_killer_2ac_cfg = {
 	.name = "Killer (R) Wireless-AC 1550 Wireless Network Adapter (9260NGW)",
-	.fw_name_pre = IWL9260A_FW_PRE,
-	.fw_name_pre_b_or_c_step = IWL9260B_FW_PRE,
+	.fw_name_pre = IWL9260_FW_PRE,
 	IWL_DEVICE_9000,
 };
 
 const struct iwl_cfg iwl9270_2ac_cfg = {
 	.name = "Intel(R) Dual Band Wireless AC 9270",
-	.fw_name_pre = IWL9260A_FW_PRE,
-	.fw_name_pre_b_or_c_step = IWL9260B_FW_PRE,
+	.fw_name_pre = IWL9260_FW_PRE,
 	IWL_DEVICE_9000,
 };
 
 const struct iwl_cfg iwl9460_2ac_cfg = {
 	.name = "Intel(R) Dual Band Wireless AC 9460",
-	.fw_name_pre = IWL9260A_FW_PRE,
-	.fw_name_pre_b_or_c_step = IWL9260B_FW_PRE,
+	.fw_name_pre = IWL9260_FW_PRE,
 	IWL_DEVICE_9000,
 };
 
 const struct iwl_cfg iwl9460_2ac_cfg_soc = {
 	.name = "Intel(R) Dual Band Wireless AC 9460",
-	.fw_name_pre = IWL9000A_FW_PRE,
-	.fw_name_pre_b_or_c_step = IWL9000B_FW_PRE,
-	.fw_name_pre_rf_next_step = IWL9000RFB_FW_PRE,
+	.fw_name_pre = IWL9000_FW_PRE,
 	IWL_DEVICE_9000,
 	.integrated = true,
 	.soc_latency = 5000,
 };
 
 const struct iwl_cfg iwl9461_2ac_cfg_soc = {
-		.name = "Intel(R) Dual Band Wireless AC 9461",
-		.fw_name_pre = IWL9000A_FW_PRE,
-		.fw_name_pre_b_or_c_step = IWL9000B_FW_PRE,
-		.fw_name_pre_rf_next_step = IWL9000RFB_FW_PRE,
-		IWL_DEVICE_9000,
-		.integrated = true,
-		.soc_latency = 5000,
+	.name = "Intel(R) Dual Band Wireless AC 9461",
+	.fw_name_pre = IWL9000_FW_PRE,
+	IWL_DEVICE_9000,
+	.integrated = true,
+	.soc_latency = 5000,
 };
 
 const struct iwl_cfg iwl9462_2ac_cfg_soc = {
-		.name = "Intel(R) Dual Band Wireless AC 9462",
-		.fw_name_pre = IWL9000A_FW_PRE,
-		.fw_name_pre_b_or_c_step = IWL9000B_FW_PRE,
-		.fw_name_pre_rf_next_step = IWL9000RFB_FW_PRE,
-		IWL_DEVICE_9000,
-		.integrated = true,
-		.soc_latency = 5000,
+	.name = "Intel(R) Dual Band Wireless AC 9462",
+	.fw_name_pre = IWL9000_FW_PRE,
+	IWL_DEVICE_9000,
+	.integrated = true,
+	.soc_latency = 5000,
 };
 
 const struct iwl_cfg iwl9560_2ac_cfg = {
 	.name = "Intel(R) Dual Band Wireless AC 9560",
-	.fw_name_pre = IWL9260A_FW_PRE,
-	.fw_name_pre_b_or_c_step = IWL9260B_FW_PRE,
+	.fw_name_pre = IWL9260_FW_PRE,
 	IWL_DEVICE_9000,
 };
 
 const struct iwl_cfg iwl9560_2ac_cfg_soc = {
 	.name = "Intel(R) Dual Band Wireless AC 9560",
-	.fw_name_pre = IWL9000A_FW_PRE,
-	.fw_name_pre_b_or_c_step = IWL9000B_FW_PRE,
-	.fw_name_pre_rf_next_step = IWL9000RFB_FW_PRE,
+	.fw_name_pre = IWL9000_FW_PRE,
 	IWL_DEVICE_9000,
 	.integrated = true,
 	.soc_latency = 5000,
@@ -244,9 +221,7 @@ const struct iwl_cfg iwl9560_2ac_cfg_soc = {
 
 const struct iwl_cfg iwl9560_killer_2ac_cfg_soc = {
 	.name = "Killer (R) Wireless-AC 1550i Wireless Network Adapter (9560NGW)",
-	.fw_name_pre = IWL9000A_FW_PRE,
-	.fw_name_pre_b_or_c_step = IWL9000B_FW_PRE,
-	.fw_name_pre_rf_next_step = IWL9000RFB_FW_PRE,
+	.fw_name_pre = IWL9000_FW_PRE,
 	IWL_DEVICE_9000,
 	.integrated = true,
 	.soc_latency = 5000,
@@ -254,9 +229,7 @@ const struct iwl_cfg iwl9560_killer_2ac_cfg_soc = {
 
 const struct iwl_cfg iwl9560_killer_s_2ac_cfg_soc = {
 	.name = "Killer (R) Wireless-AC 1550s Wireless Network Adapter (9560NGW)",
-	.fw_name_pre = IWL9000A_FW_PRE,
-	.fw_name_pre_b_or_c_step = IWL9000B_FW_PRE,
-	.fw_name_pre_rf_next_step = IWL9000RFB_FW_PRE,
+	.fw_name_pre = IWL9000_FW_PRE,
 	IWL_DEVICE_9000,
 	.integrated = true,
 	.soc_latency = 5000,
@@ -264,9 +237,7 @@ const struct iwl_cfg iwl9560_killer_s_2ac_cfg_soc = {
 
 const struct iwl_cfg iwl9460_2ac_cfg_shared_clk = {
 	.name = "Intel(R) Dual Band Wireless AC 9460",
-	.fw_name_pre = IWL9000A_FW_PRE,
-	.fw_name_pre_b_or_c_step = IWL9000B_FW_PRE,
-	.fw_name_pre_rf_next_step = IWL9000RFB_FW_PRE,
+	.fw_name_pre = IWL9000_FW_PRE,
 	IWL_DEVICE_9000,
 	.integrated = true,
 	.soc_latency = 5000,
@@ -275,9 +246,7 @@ const struct iwl_cfg iwl9460_2ac_cfg_shared_clk = {
 
 const struct iwl_cfg iwl9461_2ac_cfg_shared_clk = {
 	.name = "Intel(R) Dual Band Wireless AC 9461",
-	.fw_name_pre = IWL9000A_FW_PRE,
-	.fw_name_pre_b_or_c_step = IWL9000B_FW_PRE,
-	.fw_name_pre_rf_next_step = IWL9000RFB_FW_PRE,
+	.fw_name_pre = IWL9000_FW_PRE,
 	IWL_DEVICE_9000,
 	.integrated = true,
 	.soc_latency = 5000,
@@ -286,9 +255,7 @@ const struct iwl_cfg iwl9461_2ac_cfg_shared_clk = {
 
 const struct iwl_cfg iwl9462_2ac_cfg_shared_clk = {
 	.name = "Intel(R) Dual Band Wireless AC 9462",
-	.fw_name_pre = IWL9000A_FW_PRE,
-	.fw_name_pre_b_or_c_step = IWL9000B_FW_PRE,
-	.fw_name_pre_rf_next_step = IWL9000RFB_FW_PRE,
+	.fw_name_pre = IWL9000_FW_PRE,
 	IWL_DEVICE_9000,
 	.integrated = true,
 	.soc_latency = 5000,
@@ -297,9 +264,7 @@ const struct iwl_cfg iwl9462_2ac_cfg_shared_clk = {
 
 const struct iwl_cfg iwl9560_2ac_cfg_shared_clk = {
 	.name = "Intel(R) Dual Band Wireless AC 9560",
-	.fw_name_pre = IWL9000A_FW_PRE,
-	.fw_name_pre_b_or_c_step = IWL9000B_FW_PRE,
-	.fw_name_pre_rf_next_step = IWL9000RFB_FW_PRE,
+	.fw_name_pre = IWL9000_FW_PRE,
 	IWL_DEVICE_9000,
 	.integrated = true,
 	.soc_latency = 5000,
@@ -308,9 +273,7 @@ const struct iwl_cfg iwl9560_2ac_cfg_shared_clk = {
 
 const struct iwl_cfg iwl9560_killer_2ac_cfg_shared_clk = {
 	.name = "Killer (R) Wireless-AC 1550i Wireless Network Adapter (9560NGW)",
-	.fw_name_pre = IWL9000A_FW_PRE,
-	.fw_name_pre_b_or_c_step = IWL9000B_FW_PRE,
-	.fw_name_pre_rf_next_step = IWL9000RFB_FW_PRE,
+	.fw_name_pre = IWL9000_FW_PRE,
 	IWL_DEVICE_9000,
 	.integrated = true,
 	.soc_latency = 5000,
@@ -319,17 +282,12 @@ const struct iwl_cfg iwl9560_killer_2ac_cfg_shared_clk = {
 
 const struct iwl_cfg iwl9560_killer_s_2ac_cfg_shared_clk = {
 	.name = "Killer (R) Wireless-AC 1550s Wireless Network Adapter (9560NGW)",
-	.fw_name_pre = IWL9000A_FW_PRE,
-	.fw_name_pre_b_or_c_step = IWL9000B_FW_PRE,
-	.fw_name_pre_rf_next_step = IWL9000RFB_FW_PRE,
+	.fw_name_pre = IWL9000_FW_PRE,
 	IWL_DEVICE_9000,
 	.integrated = true,
 	.soc_latency = 5000,
 	.extra_phy_cfg_flags = FW_PHY_CFG_SHARED_CLK
 };
 
-MODULE_FIRMWARE(IWL9000A_MODULE_FIRMWARE(IWL9000_UCODE_API_MAX));
-MODULE_FIRMWARE(IWL9000B_MODULE_FIRMWARE(IWL9000_UCODE_API_MAX));
-MODULE_FIRMWARE(IWL9000RFB_MODULE_FIRMWARE(IWL9000_UCODE_API_MAX));
-MODULE_FIRMWARE(IWL9260A_MODULE_FIRMWARE(IWL9000_UCODE_API_MAX));
-MODULE_FIRMWARE(IWL9260B_MODULE_FIRMWARE(IWL9000_UCODE_API_MAX));
+MODULE_FIRMWARE(IWL9000_MODULE_FIRMWARE(IWL9000_UCODE_API_MAX));
+MODULE_FIRMWARE(IWL9260_MODULE_FIRMWARE(IWL9000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index e50cf8c88dfd..7698cadd4ff9 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -335,10 +335,6 @@ struct iwl_csr_params {
  * @fw_name_pre: Firmware filename prefix. The api version and extension
  *	(.ucode) will be added to filename before loading from disk. The
  *	filename is constructed as fw_name_pre<api>.ucode.
- * @fw_name_pre_b_or_c_step: same as @fw_name_pre, only for b or c steps
- *	(if supported)
- * @fw_name_pre_rf_next_step: same as @fw_name_pre_b_or_c_step, only for rf
- *	next step. Supported only in integrated solutions.
  * @ucode_api_max: Highest version of uCode API supported by driver.
  * @ucode_api_min: Lowest version of uCode API supported by driver.
  * @max_inst_size: The maximal length of the fw inst section (only DVM)
@@ -392,8 +388,6 @@ struct iwl_cfg {
 	/* params specific to an individual device within a device family */
 	const char *name;
 	const char *fw_name_pre;
-	const char *fw_name_pre_b_or_c_step;
-	const char *fw_name_pre_rf_next_step;
 	/* params not likely to change within a device family */
 	const struct iwl_base_params *base_params;
 	/* params likely to change within a device family */
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index bf1be985f36b..2efa1dfe9b4c 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -210,18 +210,15 @@ static int iwl_request_firmware(struct iwl_drv *drv, bool first)
 {
 	const struct iwl_cfg *cfg = drv->trans->cfg;
 	char tag[8];
-	const char *fw_pre_name;
 
 	if (drv->trans->cfg->device_family == IWL_DEVICE_FAMILY_9000 &&
-	    (CSR_HW_REV_STEP(drv->trans->hw_rev) == SILICON_B_STEP ||
-	     CSR_HW_REV_STEP(drv->trans->hw_rev) == SILICON_C_STEP))
-		fw_pre_name = cfg->fw_name_pre_b_or_c_step;
-	else if (drv->trans->cfg->integrated &&
-		 CSR_HW_RFID_STEP(drv->trans->hw_rf_id) == SILICON_B_STEP &&
-		 cfg->fw_name_pre_rf_next_step)
-		fw_pre_name = cfg->fw_name_pre_rf_next_step;
-	else
-		fw_pre_name = cfg->fw_name_pre;
+	    (CSR_HW_REV_STEP(drv->trans->hw_rev) != SILICON_B_STEP &&
+	     CSR_HW_REV_STEP(drv->trans->hw_rev) != SILICON_C_STEP)) {
+		IWL_ERR(drv,
+			"Only HW steps B and C are currently supported (0x%0x)\n",
+			drv->trans->hw_rev);
+		return -EINVAL;
+	}
 
 	if (first) {
 		drv->fw_index = cfg->ucode_api_max;
@@ -235,15 +232,13 @@ static int iwl_request_firmware(struct iwl_drv *drv, bool first)
 		IWL_ERR(drv, "no suitable firmware found!\n");
 
 		if (cfg->ucode_api_min == cfg->ucode_api_max) {
-			IWL_ERR(drv, "%s%d is required\n", fw_pre_name,
+			IWL_ERR(drv, "%s%d is required\n", cfg->fw_name_pre,
 				cfg->ucode_api_max);
 		} else {
 			IWL_ERR(drv, "minimum version required: %s%d\n",
-				fw_pre_name,
-				cfg->ucode_api_min);
+				cfg->fw_name_pre, cfg->ucode_api_min);
 			IWL_ERR(drv, "maximum version supported: %s%d\n",
-				fw_pre_name,
-				cfg->ucode_api_max);
+				cfg->fw_name_pre, cfg->ucode_api_max);
 		}
 
 		IWL_ERR(drv,
@@ -252,7 +247,7 @@ static int iwl_request_firmware(struct iwl_drv *drv, bool first)
 	}
 
 	snprintf(drv->firmware_name, sizeof(drv->firmware_name), "%s%s.ucode",
-		 fw_pre_name, tag);
+		 cfg->fw_name_pre, tag);
 
 	IWL_DEBUG_INFO(drv, "attempting to load firmware '%s'\n",
 		       drv->firmware_name);
-- 
2.20.1

