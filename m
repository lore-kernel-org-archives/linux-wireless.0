Return-Path: <SRS0=80NG=P2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E003C5ACD3
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Jan 2019 19:00:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 05A6E2086D
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Jan 2019 19:00:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729199AbfARTAU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 18 Jan 2019 14:00:20 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:48338 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729161AbfARTAU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Jan 2019 14:00:20 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gkZNJ-0004cj-0P; Fri, 18 Jan 2019 21:00:17 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 18 Jan 2019 20:59:53 +0200
Message-Id: <20190118190004.22270-6-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190118190004.22270-1-luca@coelho.fi>
References: <20190118190004.22270-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 05/16] iwlwifi: add PCI IDs for the 22260 device series
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

Add new structs and PCI IDs for 22260 devices.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/cfg/22000.c    | 40 +++++++++++++++++++
 .../net/wireless/intel/iwlwifi/iwl-config.h   |  3 ++
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 10 +++++
 .../net/wireless/intel/iwlwifi/pcie/trans.c   |  3 +-
 4 files changed, 55 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
index 7e65073834b7..588433da5ab1 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
@@ -83,6 +83,7 @@
 #define IWL_22000_HR_A0_FW_PRE		"iwlwifi-QuQnj-a0-hr-a0-"
 #define IWL_22000_SU_Z0_FW_PRE		"iwlwifi-su-z0-"
 #define IWL_QU_B_JF_B_FW_PRE		"iwlwifi-Qu-b0-jf-b0-"
+#define IWL_CC_A_FW_PRE			"iwlwifi-cc-a0-"
 
 #define IWL_22000_HR_MODULE_FIRMWARE(api) \
 	IWL_22000_HR_FW_PRE __stringify(api) ".ucode"
@@ -104,6 +105,8 @@
 	IWL_22000_SU_Z0_FW_PRE __stringify(api) ".ucode"
 #define IWL_QU_B_JF_B_MODULE_FIRMWARE(api) \
 	IWL_QU_B_JF_B_FW_PRE __stringify(api) ".ucode"
+#define IWL_CC_A_MODULE_FIRMWARE(api) \
+	IWL_CC_A_FW_PRE __stringify(api) ".ucode"
 
 static const struct iwl_base_params iwl_22000_base_params = {
 	.eeprom_size = OTP_LOW_IMAGE_SIZE_32K,
@@ -207,6 +210,42 @@ const struct iwl_cfg iwl22000_2ax_cfg_hr = {
 	.max_tx_agg_size = IEEE80211_MAX_AMPDU_BUF_HT,
 };
 
+const struct iwl_cfg iwl22260_2ax_cfg = {
+	.name = "Intel(R) Wireless-AX 22260",
+	.fw_name_pre = IWL_CC_A_FW_PRE,
+	IWL_DEVICE_22500,
+	/*
+	 * This device doesn't support receiving BlockAck with a large bitmap
+	 * so we need to restrict the size of transmitted aggregation to the
+	 * HT size; mac80211 would otherwise pick the HE max (256) by default.
+	 */
+	.max_tx_agg_size = IEEE80211_MAX_AMPDU_BUF_HT,
+};
+
+const struct iwl_cfg killer1650x_2ax_cfg = {
+	.name = "Killer(R) Wireless-AX 1650x Wireless Network Adapter (22260NGW)",
+	.fw_name_pre = IWL_CC_A_FW_PRE,
+	IWL_DEVICE_22500,
+	/*
+	 * This device doesn't support receiving BlockAck with a large bitmap
+	 * so we need to restrict the size of transmitted aggregation to the
+	 * HT size; mac80211 would otherwise pick the HE max (256) by default.
+	 */
+	.max_tx_agg_size = IEEE80211_MAX_AMPDU_BUF_HT,
+};
+
+const struct iwl_cfg killer1650w_2ax_cfg = {
+	.name = "Killer(R) Wireless-AX 1650w Wireless Network Adapter (22260D2W)",
+	.fw_name_pre = IWL_CC_A_FW_PRE,
+	IWL_DEVICE_22500,
+	/*
+	 * This device doesn't support receiving BlockAck with a large bitmap
+	 * so we need to restrict the size of transmitted aggregation to the
+	 * HT size; mac80211 would otherwise pick the HE max (256) by default.
+	 */
+	.max_tx_agg_size = IEEE80211_MAX_AMPDU_BUF_HT,
+};
+
 /*
  * All JF radio modules are part of the 9000 series, but the MAC part
  * looks more like 22000.  That's why this device is here, but called
@@ -324,3 +363,4 @@ MODULE_FIRMWARE(IWL_22000_JF_B0_QNJ_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_22000_HR_A0_QNJ_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_22000_SU_Z0_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_QU_B_JF_B_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
+MODULE_FIRMWARE(IWL_CC_A_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index 91861a9cbe57..1261a29f3b40 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -571,6 +571,9 @@ extern const struct iwl_cfg iwl22000_2ac_cfg_hr;
 extern const struct iwl_cfg iwl22000_2ac_cfg_hr_cdb;
 extern const struct iwl_cfg iwl22000_2ac_cfg_jf;
 extern const struct iwl_cfg iwl22000_2ax_cfg_hr;
+extern const struct iwl_cfg iwl22260_2ax_cfg;
+extern const struct iwl_cfg killer1650x_2ax_cfg;
+extern const struct iwl_cfg killer1650w_2ax_cfg;
 extern const struct iwl_cfg iwl9461_2ac_cfg_qu_b0_jf_b0;
 extern const struct iwl_cfg iwl9462_2ac_cfg_qu_b0_jf_b0;
 extern const struct iwl_cfg iwl9560_2ac_cfg_qu_b0_jf_b0;
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 353581ccc01e..4462133c12ba 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -898,6 +898,16 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0xA0F0, 0x00B0, iwl22000_2ax_cfg_hr)},
 	{IWL_PCI_DEVICE(0xA0F0, 0x0A10, iwl22000_2ax_cfg_hr)},
 
+	{IWL_PCI_DEVICE(0x2723, 0x0080, iwl22260_2ax_cfg)},
+	{IWL_PCI_DEVICE(0x2723, 0x0084, iwl22260_2ax_cfg)},
+	{IWL_PCI_DEVICE(0x2723, 0x0088, iwl22260_2ax_cfg)},
+	{IWL_PCI_DEVICE(0x2723, 0x008C, iwl22260_2ax_cfg)},
+	{IWL_PCI_DEVICE(0x2723, 0x4080, iwl22260_2ax_cfg)},
+	{IWL_PCI_DEVICE(0x2723, 0x4088, iwl22260_2ax_cfg)},
+
+	{IWL_PCI_DEVICE(0x1a56, 0x1653, killer1650w_2ax_cfg)},
+	{IWL_PCI_DEVICE(0x1a56, 0x1654, killer1650x_2ax_cfg)},
+
 #endif /* CONFIG_IWLMVM */
 
 	{0}
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index dbe62bc3ece4..fc2f98f2d516 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -3602,7 +3602,8 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 			goto out_no_pci;
 		}
 	} else if (CSR_HW_RF_ID_TYPE_CHIP_ID(trans->hw_rf_id) ==
-		   CSR_HW_RF_ID_TYPE_CHIP_ID(CSR_HW_RF_ID_TYPE_HR)) {
+		   CSR_HW_RF_ID_TYPE_CHIP_ID(CSR_HW_RF_ID_TYPE_HR) &&
+		   trans->cfg != &iwl22260_2ax_cfg) {
 		u32 hw_status;
 
 		hw_status = iwl_read_prph(trans, UMAG_GEN_HW_STATUS);
-- 
2.20.1

