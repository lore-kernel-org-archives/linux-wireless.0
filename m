Return-Path: <SRS0=qAgV=RZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC419C4360F
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 12:47:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 85BFE2070D
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 12:47:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387883AbfCVMrz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Mar 2019 08:47:55 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:46028 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387786AbfCVMrx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Mar 2019 08:47:53 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1h7JaR-0000ZZ-5E; Fri, 22 Mar 2019 14:47:51 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 22 Mar 2019 14:47:44 +0200
Message-Id: <20190322124744.17924-4-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190322124744.17924-1-luca@coelho.fi>
References: <20190322124744.17924-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 3/3] iwlwifi: add support for quz firmwares
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

Add a new configuration with a new firmware name for quz devices.
And, since these devices have the same PCI device and subsystem IDs,
we need to add some code to switch from a normal qu firmware to the
quz firmware.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c | 18 ++++++++++++++++--
 .../net/wireless/intel/iwlwifi/iwl-config.h    |  1 +
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h   |  1 +
 .../net/wireless/intel/iwlwifi/pcie/trans.c    |  4 ++++
 4 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
index d5c29298ae3e..eb6defb6d0cd 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
@@ -82,6 +82,7 @@
 #define IWL_22000_HR_A0_FW_PRE		"iwlwifi-QuQnj-a0-hr-a0-"
 #define IWL_22000_SU_Z0_FW_PRE		"iwlwifi-su-z0-"
 #define IWL_QU_B_JF_B_FW_PRE		"iwlwifi-Qu-b0-jf-b0-"
+#define IWL_QUZ_A_HR_B_FW_PRE		"iwlwifi-QuZ-a0-hr-b0-"
 #define IWL_QNJ_B_JF_B_FW_PRE		"iwlwifi-QuQnj-b0-jf-b0-"
 #define IWL_CC_A_FW_PRE			"iwlwifi-cc-a0-"
 #define IWL_22000_SO_A_JF_B_FW_PRE	"iwlwifi-so-a0-jf-b0-"
@@ -105,8 +106,8 @@
 	IWL_22000_HR_A0_FW_PRE __stringify(api) ".ucode"
 #define IWL_22000_SU_Z0_MODULE_FIRMWARE(api) \
 	IWL_22000_SU_Z0_FW_PRE __stringify(api) ".ucode"
-#define IWL_QU_B_JF_B_MODULE_FIRMWARE(api) \
-	IWL_QU_B_JF_B_FW_PRE __stringify(api) ".ucode"
+#define IWL_QUZ_A_HR_B_MODULE_FIRMWARE(api) \
+	IWL_QUZ_A_HR_B_FW_PRE __stringify(api) ".ucode"
 #define IWL_QU_B_JF_B_MODULE_FIRMWARE(api) \
 	IWL_QU_B_JF_B_FW_PRE __stringify(api) ".ucode"
 #define IWL_QNJ_B_JF_B_MODULE_FIRMWARE(api)		\
@@ -235,6 +236,18 @@ const struct iwl_cfg iwl_ax101_cfg_qu_hr = {
 	.max_tx_agg_size = IEEE80211_MAX_AMPDU_BUF_HT,
 };
 
+const struct iwl_cfg iwl_ax101_cfg_quz_hr = {
+	.name = "Intel(R) Wi-Fi 6 AX101",
+	.fw_name_pre = IWL_QUZ_A_HR_B_FW_PRE,
+	IWL_DEVICE_22500,
+	/*
+	 * This device doesn't support receiving BlockAck with a large bitmap
+	 * so we need to restrict the size of transmitted aggregation to the
+	 * HT size; mac80211 would otherwise pick the HE max (256) by default.
+	 */
+	.max_tx_agg_size = IEEE80211_MAX_AMPDU_BUF_HT,
+};
+
 const struct iwl_cfg iwl_ax200_cfg_cc = {
 	.name = "Intel(R) Wi-Fi 6 AX200 160MHz",
 	.fw_name_pre = IWL_CC_A_FW_PRE,
@@ -444,6 +457,7 @@ MODULE_FIRMWARE(IWL_22000_HR_B_QNJ_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_22000_HR_A0_QNJ_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_22000_SU_Z0_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_QU_B_JF_B_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
+MODULE_FIRMWARE(IWL_QUZ_A_HR_B_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_QNJ_B_JF_B_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_CC_A_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_22000_SO_A_JF_B_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index c91b537fa7ff..93070848280a 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -549,6 +549,7 @@ extern const struct iwl_cfg iwl22000_2ac_cfg_hr;
 extern const struct iwl_cfg iwl22000_2ac_cfg_hr_cdb;
 extern const struct iwl_cfg iwl22000_2ac_cfg_jf;
 extern const struct iwl_cfg iwl_ax101_cfg_qu_hr;
+extern const struct iwl_cfg iwl_ax101_cfg_quz_hr;
 extern const struct iwl_cfg iwl22000_2ax_cfg_hr;
 extern const struct iwl_cfg iwl_ax200_cfg_cc;
 extern const struct iwl_cfg killer1650s_2ax_cfg_qu_b0_hr_b0;
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-csr.h b/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
index aea6d03e545a..e539bc94eff7 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
@@ -327,6 +327,7 @@ enum {
 #define CSR_HW_REV_TYPE_NONE		(0x00001F0)
 #define CSR_HW_REV_TYPE_QNJ		(0x0000360)
 #define CSR_HW_REV_TYPE_QNJ_B0		(0x0000364)
+#define CSR_HW_REV_TYPE_QUZ		(0x0000354)
 #define CSR_HW_REV_TYPE_HR_CDB		(0x0000340)
 #define CSR_HW_REV_TYPE_SO		(0x0000370)
 #define CSR_HW_REV_TYPE_TY		(0x0000420)
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 1d6f3053f233..79c1dc05f948 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -3543,6 +3543,10 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 		}
 	} else if (cfg == &iwl_ax101_cfg_qu_hr) {
 		if (CSR_HW_RF_ID_TYPE_CHIP_ID(trans->hw_rf_id) ==
+		    CSR_HW_RF_ID_TYPE_CHIP_ID(CSR_HW_RF_ID_TYPE_HR) &&
+		    trans->hw_rev == CSR_HW_REV_TYPE_QNJ_B0) {
+			trans->cfg = &iwl22000_2ax_cfg_qnj_hr_b0;
+		} else if (CSR_HW_RF_ID_TYPE_CHIP_ID(trans->hw_rf_id) ==
 		    CSR_HW_RF_ID_TYPE_CHIP_ID(CSR_HW_RF_ID_TYPE_HR)) {
 			trans->cfg = &iwl_ax101_cfg_qu_hr;
 		} else if (CSR_HW_RF_ID_TYPE_CHIP_ID(trans->hw_rf_id) ==
-- 
2.20.1

