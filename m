Return-Path: <SRS0=80NG=P2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B0B4C5AC81
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Jan 2019 19:00:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 081AA20883
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Jan 2019 19:00:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729211AbfARTAY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 18 Jan 2019 14:00:24 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:48366 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728989AbfARTAV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Jan 2019 14:00:21 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gkZNL-0004cj-3n; Fri, 18 Jan 2019 21:00:19 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Ihab Zhaika <ihab.zhaika@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 18 Jan 2019 20:59:56 +0200
Message-Id: <20190118190004.22270-9-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190118190004.22270-1-luca@coelho.fi>
References: <20190118190004.22270-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 08/16] iwlwifi: correct one of the PCI struct names
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ihab Zhaika <ihab.zhaika@intel.com>

One of the cfg struct names is mistakenly "iwl22000", when it should
be "iwl22560".

Signed-off-by: Ihab Zhaika <ihab.zhaika@intel.com>
Fixes: 2f7a3863191a ("iwlwifi: rename the temporary name of A000 to the official 22000")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/cfg/22000.c    |  4 +--
 .../net/wireless/intel/iwlwifi/iwl-config.h   |  1 +
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 34 +++++++++----------
 .../net/wireless/intel/iwlwifi/pcie/trans.c   |  4 +--
 4 files changed, 22 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
index 588433da5ab1..310bef797a43 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
@@ -198,8 +198,8 @@ const struct iwl_cfg iwl22000_2ac_cfg_jf = {
 	IWL_DEVICE_22500,
 };
 
-const struct iwl_cfg iwl22000_2ax_cfg_hr = {
-	.name = "Intel(R) Dual Band Wireless AX 22000",
+const struct iwl_cfg iwl22560_2ax_cfg_hr = {
+	.name = "Intel(R) Wireless-AX 22560",
 	.fw_name_pre = IWL_22000_QU_B_HR_B_FW_PRE,
 	IWL_DEVICE_22500,
 	/*
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index 1261a29f3b40..6695aa8fbfba 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -570,6 +570,7 @@ extern const struct iwl_cfg iwl9560_killer_s_2ac_cfg_shared_clk;
 extern const struct iwl_cfg iwl22000_2ac_cfg_hr;
 extern const struct iwl_cfg iwl22000_2ac_cfg_hr_cdb;
 extern const struct iwl_cfg iwl22000_2ac_cfg_jf;
+extern const struct iwl_cfg iwl22560_2ax_cfg_hr;
 extern const struct iwl_cfg iwl22000_2ax_cfg_hr;
 extern const struct iwl_cfg iwl22260_2ax_cfg;
 extern const struct iwl_cfg killer1650x_2ax_cfg;
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 4462133c12ba..6694efc6a431 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -871,32 +871,32 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0xA370, 0x42A4, iwl9462_2ac_cfg_soc)},
 
 /* 22000 Series */
-	{IWL_PCI_DEVICE(0x2720, 0x0000, iwl22000_2ax_cfg_hr)},
-	{IWL_PCI_DEVICE(0x2720, 0x0040, iwl22000_2ax_cfg_hr)},
-	{IWL_PCI_DEVICE(0x2720, 0x0078, iwl22000_2ax_cfg_hr)},
+	{IWL_PCI_DEVICE(0x2720, 0x0000, iwl22560_2ax_cfg_hr)},
+	{IWL_PCI_DEVICE(0x2720, 0x0040, iwl22560_2ax_cfg_hr)},
+	{IWL_PCI_DEVICE(0x2720, 0x0078, iwl22560_2ax_cfg_hr)},
 	{IWL_PCI_DEVICE(0x2720, 0x0070, iwl22000_2ac_cfg_hr_cdb)},
 	{IWL_PCI_DEVICE(0x2720, 0x0030, iwl22000_2ac_cfg_hr_cdb)},
-	{IWL_PCI_DEVICE(0x2720, 0x1080, iwl22000_2ax_cfg_hr)},
+	{IWL_PCI_DEVICE(0x2720, 0x1080, iwl22560_2ax_cfg_hr)},
 	{IWL_PCI_DEVICE(0x2720, 0x0090, iwl22000_2ac_cfg_hr_cdb)},
 	{IWL_PCI_DEVICE(0x2720, 0x0310, iwl22000_2ac_cfg_hr_cdb)},
-	{IWL_PCI_DEVICE(0x34F0, 0x0040, iwl22000_2ax_cfg_hr)},
-	{IWL_PCI_DEVICE(0x34F0, 0x0070, iwl22000_2ax_cfg_hr)},
-	{IWL_PCI_DEVICE(0x34F0, 0x0078, iwl22000_2ax_cfg_hr)},
-	{IWL_PCI_DEVICE(0x34F0, 0x0310, iwl22000_2ax_cfg_hr)},
+	{IWL_PCI_DEVICE(0x34F0, 0x0040, iwl22560_2ax_cfg_hr)},
+	{IWL_PCI_DEVICE(0x34F0, 0x0070, iwl22560_2ax_cfg_hr)},
+	{IWL_PCI_DEVICE(0x34F0, 0x0078, iwl22560_2ax_cfg_hr)},
+	{IWL_PCI_DEVICE(0x34F0, 0x0310, iwl22560_2ax_cfg_hr)},
 	{IWL_PCI_DEVICE(0x40C0, 0x0000, iwl22560_2ax_cfg_su_cdb)},
 	{IWL_PCI_DEVICE(0x40C0, 0x0010, iwl22560_2ax_cfg_su_cdb)},
 	{IWL_PCI_DEVICE(0x40c0, 0x0090, iwl22560_2ax_cfg_su_cdb)},
 	{IWL_PCI_DEVICE(0x40C0, 0x0310, iwl22560_2ax_cfg_su_cdb)},
 	{IWL_PCI_DEVICE(0x40C0, 0x0A10, iwl22560_2ax_cfg_su_cdb)},
-	{IWL_PCI_DEVICE(0x43F0, 0x0040, iwl22000_2ax_cfg_hr)},
-	{IWL_PCI_DEVICE(0x43F0, 0x0070, iwl22000_2ax_cfg_hr)},
-	{IWL_PCI_DEVICE(0x43F0, 0x0078, iwl22000_2ax_cfg_hr)},
-	{IWL_PCI_DEVICE(0xA0F0, 0x0000, iwl22000_2ax_cfg_hr)},
-	{IWL_PCI_DEVICE(0xA0F0, 0x0040, iwl22000_2ax_cfg_hr)},
-	{IWL_PCI_DEVICE(0xA0F0, 0x0070, iwl22000_2ax_cfg_hr)},
-	{IWL_PCI_DEVICE(0xA0F0, 0x0078, iwl22000_2ax_cfg_hr)},
-	{IWL_PCI_DEVICE(0xA0F0, 0x00B0, iwl22000_2ax_cfg_hr)},
-	{IWL_PCI_DEVICE(0xA0F0, 0x0A10, iwl22000_2ax_cfg_hr)},
+	{IWL_PCI_DEVICE(0x43F0, 0x0040, iwl22560_2ax_cfg_hr)},
+	{IWL_PCI_DEVICE(0x43F0, 0x0070, iwl22560_2ax_cfg_hr)},
+	{IWL_PCI_DEVICE(0x43F0, 0x0078, iwl22560_2ax_cfg_hr)},
+	{IWL_PCI_DEVICE(0xA0F0, 0x0000, iwl22560_2ax_cfg_hr)},
+	{IWL_PCI_DEVICE(0xA0F0, 0x0040, iwl22560_2ax_cfg_hr)},
+	{IWL_PCI_DEVICE(0xA0F0, 0x0070, iwl22560_2ax_cfg_hr)},
+	{IWL_PCI_DEVICE(0xA0F0, 0x0078, iwl22560_2ax_cfg_hr)},
+	{IWL_PCI_DEVICE(0xA0F0, 0x00B0, iwl22560_2ax_cfg_hr)},
+	{IWL_PCI_DEVICE(0xA0F0, 0x0A10, iwl22560_2ax_cfg_hr)},
 
 	{IWL_PCI_DEVICE(0x2723, 0x0080, iwl22260_2ax_cfg)},
 	{IWL_PCI_DEVICE(0x2723, 0x0084, iwl22260_2ax_cfg)},
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 633444d2f930..55ccfa22b3c0 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -3585,10 +3585,10 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 #if IS_ENABLED(CONFIG_IWLMVM)
 	trans->hw_rf_id = iwl_read32(trans, CSR_HW_RF_ID);
 
-	if (cfg == &iwl22000_2ax_cfg_hr) {
+	if (cfg == &iwl22560_2ax_cfg_hr) {
 		if (CSR_HW_RF_ID_TYPE_CHIP_ID(trans->hw_rf_id) ==
 		    CSR_HW_RF_ID_TYPE_CHIP_ID(CSR_HW_RF_ID_TYPE_HR)) {
-			trans->cfg = &iwl22000_2ax_cfg_hr;
+			trans->cfg = &iwl22560_2ax_cfg_hr;
 		} else if (CSR_HW_RF_ID_TYPE_CHIP_ID(trans->hw_rf_id) ==
 			   CSR_HW_RF_ID_TYPE_CHIP_ID(CSR_HW_RF_ID_TYPE_JF)) {
 			trans->cfg = &iwl22000_2ax_cfg_jf;
-- 
2.20.1

