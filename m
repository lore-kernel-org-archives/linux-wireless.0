Return-Path: <SRS0=Soq1=NW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CB46C43610
	for <linux-wireless@archiver.kernel.org>; Sun, 11 Nov 2018 20:07:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B4792080D
	for <linux-wireless@archiver.kernel.org>; Sun, 11 Nov 2018 20:07:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6B4792080D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731541AbeKLF5L (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 12 Nov 2018 00:57:11 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:35932 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727101AbeKLF5K (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Nov 2018 00:57:10 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gLw1E-0000JG-Mu; Sun, 11 Nov 2018 22:07:41 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Sun, 11 Nov 2018 22:07:20 +0200
Message-Id: <20181111200732.8159-5-luca@coelho.fi>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181111200732.8159-1-luca@coelho.fi>
References: <20181111200732.8159-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 04/16] iwlwifi: fix cfg structs for 22000 with different RF modules
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

We have to choose different configuration and different firmwares
depending on the external RF module that is installed.  Since the
external module is not represented in the PCI IDs, we need to change
the configuration at runtime, after checking the RF ID of the module
installed.  We have a bit of a mess in the code that does this,
because it applies cfg's according to the RF ID only, ignoring the
integrated module that is in use.

Fix that for some devices by adding correct configurations for them
and not ignoring the integrated module's type when making the
decision.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/cfg/22000.c    |  1 -
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c |  2 +-
 .../net/wireless/intel/iwlwifi/pcie/trans.c   | 22 +++++++++++++++++--
 3 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
index da5d5f9b2573..8b2339165bca 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
@@ -323,7 +323,6 @@ MODULE_FIRMWARE(IWL_22000_HR_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_22000_JF_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_22000_HR_A_F0_QNJ_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_22000_HR_B_F0_QNJ_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
-MODULE_FIRMWARE(IWL_22000_QU_B_HR_B_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_22000_HR_B_QNJ_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_22000_JF_B0_QNJ_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_22000_HR_A0_QNJ_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 8d4711590dfc..353581ccc01e 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -882,7 +882,7 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x34F0, 0x0040, iwl22000_2ax_cfg_hr)},
 	{IWL_PCI_DEVICE(0x34F0, 0x0070, iwl22000_2ax_cfg_hr)},
 	{IWL_PCI_DEVICE(0x34F0, 0x0078, iwl22000_2ax_cfg_hr)},
-	{IWL_PCI_DEVICE(0x34F0, 0x0310, iwl22000_2ac_cfg_jf)},
+	{IWL_PCI_DEVICE(0x34F0, 0x0310, iwl22000_2ax_cfg_hr)},
 	{IWL_PCI_DEVICE(0x40C0, 0x0000, iwl22560_2ax_cfg_su_cdb)},
 	{IWL_PCI_DEVICE(0x40C0, 0x0010, iwl22560_2ax_cfg_su_cdb)},
 	{IWL_PCI_DEVICE(0x40c0, 0x0090, iwl22560_2ax_cfg_su_cdb)},
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 16eed9b0f301..231ec8131ee8 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -3401,8 +3401,26 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 #if IS_ENABLED(CONFIG_IWLMVM)
 	trans->hw_rf_id = iwl_read32(trans, CSR_HW_RF_ID);
 
-	if (CSR_HW_RF_ID_TYPE_CHIP_ID(trans->hw_rf_id) ==
-	    CSR_HW_RF_ID_TYPE_CHIP_ID(CSR_HW_RF_ID_TYPE_HR)) {
+	if (cfg == &iwl22000_2ax_cfg_hr) {
+		if (CSR_HW_RF_ID_TYPE_CHIP_ID(trans->hw_rf_id) ==
+		    CSR_HW_RF_ID_TYPE_CHIP_ID(CSR_HW_RF_ID_TYPE_HR)) {
+			trans->cfg = &iwl22000_2ax_cfg_hr;
+		} else if (CSR_HW_RF_ID_TYPE_CHIP_ID(trans->hw_rf_id) ==
+			   CSR_HW_RF_ID_TYPE_CHIP_ID(CSR_HW_RF_ID_TYPE_JF)) {
+			trans->cfg = &iwl22000_2ax_cfg_jf;
+		} else if (CSR_HW_RF_ID_TYPE_CHIP_ID(trans->hw_rf_id) ==
+			   CSR_HW_RF_ID_TYPE_CHIP_ID(CSR_HW_RF_ID_TYPE_HRCDB)) {
+			IWL_ERR(trans, "RF ID HRCDB is not supported\n");
+			ret = -EINVAL;
+			goto out_no_pci;
+		} else {
+			IWL_ERR(trans, "Unrecognized RF ID 0x%08x\n",
+				CSR_HW_RF_ID_TYPE_CHIP_ID(trans->hw_rf_id));
+			ret = -EINVAL;
+			goto out_no_pci;
+		}
+	} else if (CSR_HW_RF_ID_TYPE_CHIP_ID(trans->hw_rf_id) ==
+		   CSR_HW_RF_ID_TYPE_CHIP_ID(CSR_HW_RF_ID_TYPE_HR)) {
 		u32 hw_status;
 
 		hw_status = iwl_read_prph(trans, UMAG_GEN_HW_STATUS);
-- 
2.19.1

