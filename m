Return-Path: <SRS0=wltO=RL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8C5AC43381
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Mar 2019 10:09:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B58AC20854
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Mar 2019 10:09:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726388AbfCHKJI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Mar 2019 05:09:08 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:41434 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726364AbfCHKJG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Mar 2019 05:09:06 -0500
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1h2CR5-0006tZ-UX; Fri, 08 Mar 2019 12:09:04 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Ihab Zhaika <ihab.zhaika@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri,  8 Mar 2019 12:08:47 +0200
Message-Id: <20190308100848.13188-7-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190308100848.13188-1-luca@coelho.fi>
References: <20190308100848.13188-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 6/7] iwlwifi: rename structs to fit the new names
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ihab Zhaika <ihab.zhaika@intel.com>

rename few structs to fit the new marketing names

Signed-off-by: Ihab Zhaika <ihab.zhaika@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c  | 12 ++++++------
 drivers/net/wireless/intel/iwlwifi/iwl-config.h |  2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c   | 12 ++++++------
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c |  2 +-
 4 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
index fdc56f821b5a..d5c29298ae3e 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
@@ -235,8 +235,8 @@ const struct iwl_cfg iwl_ax101_cfg_qu_hr = {
 	.max_tx_agg_size = IEEE80211_MAX_AMPDU_BUF_HT,
 };
 
-const struct iwl_cfg iwl22260_2ax_cfg = {
-	.name = "Intel(R) Wireless-AX 22260",
+const struct iwl_cfg iwl_ax200_cfg_cc = {
+	.name = "Intel(R) Wi-Fi 6 AX200 160MHz",
 	.fw_name_pre = IWL_CC_A_FW_PRE,
 	IWL_DEVICE_22500,
 	/*
@@ -249,7 +249,7 @@ const struct iwl_cfg iwl22260_2ax_cfg = {
 };
 
 const struct iwl_cfg killer1650x_2ax_cfg = {
-	.name = "Killer(R) Wireless-AX 1650x Wireless Network Adapter (200NGW)",
+	.name = "Killer(R) Wi-Fi 6 AX1650x 160MHz Wireless Network Adapter (200NGW)",
 	.fw_name_pre = IWL_CC_A_FW_PRE,
 	IWL_DEVICE_22500,
 	/*
@@ -262,7 +262,7 @@ const struct iwl_cfg killer1650x_2ax_cfg = {
 };
 
 const struct iwl_cfg killer1650w_2ax_cfg = {
-	.name = "Killer(R) Wireless-AX 1650w Wireless Network Adapter (200D2W)",
+	.name = "Killer(R) Wi-Fi 6 AX1650w 160MHz Wireless Network Adapter (200D2W)",
 	.fw_name_pre = IWL_CC_A_FW_PRE,
 	IWL_DEVICE_22500,
 	/*
@@ -328,7 +328,7 @@ const struct iwl_cfg killer1550s_2ac_cfg_qu_b0_jf_b0 = {
 };
 
 const struct iwl_cfg killer1650s_2ax_cfg_qu_b0_hr_b0 = {
-	.name = "Killer(R) Wireless-AX 1650i Wireless Network Adapter (22560NGW)",
+	.name = "Killer(R) Wi-Fi 6 AX1650i 160MHz Wireless Network Adapter (201NGW)",
 	.fw_name_pre = IWL_22000_QU_B_HR_B_FW_PRE,
 	IWL_DEVICE_22500,
 	/*
@@ -340,7 +340,7 @@ const struct iwl_cfg killer1650s_2ax_cfg_qu_b0_hr_b0 = {
 };
 
 const struct iwl_cfg killer1650i_2ax_cfg_qu_b0_hr_b0 = {
-	.name = "Killer(R) Wireless-AX 1650s Wireless Network Adapter (22560D2W)",
+	.name = "Killer(R) Wi-Fi 6 AX1650s 160MHz Wireless Network Adapter (201D2W)",
 	.fw_name_pre = IWL_22000_QU_B_HR_B_FW_PRE,
 	IWL_DEVICE_22500,
 	/*
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index f5f87773667b..c91b537fa7ff 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -550,7 +550,7 @@ extern const struct iwl_cfg iwl22000_2ac_cfg_hr_cdb;
 extern const struct iwl_cfg iwl22000_2ac_cfg_jf;
 extern const struct iwl_cfg iwl_ax101_cfg_qu_hr;
 extern const struct iwl_cfg iwl22000_2ax_cfg_hr;
-extern const struct iwl_cfg iwl22260_2ax_cfg;
+extern const struct iwl_cfg iwl_ax200_cfg_cc;
 extern const struct iwl_cfg killer1650s_2ax_cfg_qu_b0_hr_b0;
 extern const struct iwl_cfg killer1650i_2ax_cfg_qu_b0_hr_b0;
 extern const struct iwl_cfg killer1650x_2ax_cfg;
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 2b94e4cef56c..c35e50359d2c 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -953,14 +953,14 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0xA0F0, 0x1652, killer1650i_2ax_cfg_qu_b0_hr_b0)},
 	{IWL_PCI_DEVICE(0xA0F0, 0x4070, iwl_ax101_cfg_qu_hr)},
 
-	{IWL_PCI_DEVICE(0x2723, 0x0080, iwl22260_2ax_cfg)},
-	{IWL_PCI_DEVICE(0x2723, 0x0084, iwl22260_2ax_cfg)},
-	{IWL_PCI_DEVICE(0x2723, 0x0088, iwl22260_2ax_cfg)},
-	{IWL_PCI_DEVICE(0x2723, 0x008C, iwl22260_2ax_cfg)},
+	{IWL_PCI_DEVICE(0x2723, 0x0080, iwl_ax200_cfg_cc)},
+	{IWL_PCI_DEVICE(0x2723, 0x0084, iwl_ax200_cfg_cc)},
+	{IWL_PCI_DEVICE(0x2723, 0x0088, iwl_ax200_cfg_cc)},
+	{IWL_PCI_DEVICE(0x2723, 0x008C, iwl_ax200_cfg_cc)},
 	{IWL_PCI_DEVICE(0x2723, 0x1653, killer1650w_2ax_cfg)},
 	{IWL_PCI_DEVICE(0x2723, 0x1654, killer1650x_2ax_cfg)},
-	{IWL_PCI_DEVICE(0x2723, 0x4080, iwl22260_2ax_cfg)},
-	{IWL_PCI_DEVICE(0x2723, 0x4088, iwl22260_2ax_cfg)},
+	{IWL_PCI_DEVICE(0x2723, 0x4080, iwl_ax200_cfg_cc)},
+	{IWL_PCI_DEVICE(0x2723, 0x4088, iwl_ax200_cfg_cc)},
 
 	{IWL_PCI_DEVICE(0x1a56, 0x1653, killer1650w_2ax_cfg)},
 	{IWL_PCI_DEVICE(0x1a56, 0x1654, killer1650x_2ax_cfg)},
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 28d6ae8c9336..1d6f3053f233 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -3561,7 +3561,7 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 		}
 	} else if (CSR_HW_RF_ID_TYPE_CHIP_ID(trans->hw_rf_id) ==
 		   CSR_HW_RF_ID_TYPE_CHIP_ID(CSR_HW_RF_ID_TYPE_HR) &&
-		   (trans->cfg != &iwl22260_2ax_cfg ||
+		   (trans->cfg != &iwl_ax200_cfg_cc ||
 		    trans->hw_rev == CSR_HW_REV_TYPE_QNJ_B0)) {
 		u32 hw_status;
 
-- 
2.20.1

