Return-Path: <SRS0=jXAT=QH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A03CAC282D9
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 20:23:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 707FB218AF
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 20:23:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728088AbfAaUXF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 31 Jan 2019 15:23:05 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:53702 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727435AbfAaUXF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Jan 2019 15:23:05 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gpIr0-0004pL-5q; Thu, 31 Jan 2019 22:22:30 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Thu, 31 Jan 2019 22:22:04 +0200
Message-Id: <20190131202206.15903-20-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190131202206.15903-1-luca@coelho.fi>
References: <20190131202206.15903-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 19/21] iwlwifi: refactor NIC init sequence
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

The typical sequence of setting INIT_DONE and then waiting
for clock stabilisation is going to need a new workarounds,
so first of all refactor it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../wireless/intel/iwlwifi/iwl-eeprom-read.c  | 47 ++++++-------
 drivers/net/wireless/intel/iwlwifi/iwl-io.c   | 30 +++++++++
 drivers/net/wireless/intel/iwlwifi/iwl-io.h   |  5 ++
 .../net/wireless/intel/iwlwifi/mvm/utils.c    | 18 +----
 .../wireless/intel/iwlwifi/pcie/trans-gen2.c  | 21 +-----
 .../net/wireless/intel/iwlwifi/pcie/trans.c   | 67 +++----------------
 6 files changed, 66 insertions(+), 122 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-read.c b/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-read.c
index a6db6a814257..82e87192119e 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-read.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-read.c
@@ -193,34 +193,25 @@ static int iwl_init_otp_access(struct iwl_trans *trans)
 {
 	int ret;
 
-	/* Enable 40MHz radio clock */
-	iwl_write32(trans, CSR_GP_CNTRL,
-		    iwl_read32(trans, CSR_GP_CNTRL) |
-		    BIT(trans->cfg->csr->flag_init_done));
-
-	/* wait for clock to be ready */
-	ret = iwl_poll_bit(trans, CSR_GP_CNTRL,
-			   BIT(trans->cfg->csr->flag_mac_clock_ready),
-			   BIT(trans->cfg->csr->flag_mac_clock_ready),
-			   25000);
-	if (ret < 0) {
-		IWL_ERR(trans, "Time out access OTP\n");
-	} else {
-		iwl_set_bits_prph(trans, APMG_PS_CTRL_REG,
-				  APMG_PS_CTRL_VAL_RESET_REQ);
-		udelay(5);
-		iwl_clear_bits_prph(trans, APMG_PS_CTRL_REG,
-				    APMG_PS_CTRL_VAL_RESET_REQ);
-
-		/*
-		 * CSR auto clock gate disable bit -
-		 * this is only applicable for HW with OTP shadow RAM
-		 */
-		if (trans->cfg->base_params->shadow_ram_support)
-			iwl_set_bit(trans, CSR_DBG_LINK_PWR_MGMT_REG,
-				    CSR_RESET_LINK_PWR_MGMT_DISABLED);
-	}
-	return ret;
+	ret = iwl_finish_nic_init(trans);
+	if (ret)
+		return ret;
+
+	iwl_set_bits_prph(trans, APMG_PS_CTRL_REG,
+			  APMG_PS_CTRL_VAL_RESET_REQ);
+	udelay(5);
+	iwl_clear_bits_prph(trans, APMG_PS_CTRL_REG,
+			    APMG_PS_CTRL_VAL_RESET_REQ);
+
+	/*
+	 * CSR auto clock gate disable bit -
+	 * this is only applicable for HW with OTP shadow RAM
+	 */
+	if (trans->cfg->base_params->shadow_ram_support)
+		iwl_set_bit(trans, CSR_DBG_LINK_PWR_MGMT_REG,
+			    CSR_RESET_LINK_PWR_MGMT_DISABLED);
+
+	return 0;
 }
 
 static int iwl_read_otp_word(struct iwl_trans *trans, u16 addr,
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-io.c b/drivers/net/wireless/intel/iwlwifi/iwl-io.c
index d62eb2d9389a..4ea5883f9175 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-io.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-io.c
@@ -488,3 +488,33 @@ int iwl_dump_fh(struct iwl_trans *trans, char **buf)
 
 	return 0;
 }
+
+int iwl_finish_nic_init(struct iwl_trans *trans)
+{
+	int err;
+
+	/*
+	 * Set "initialization complete" bit to move adapter from
+	 * D0U* --> D0A* (powered-up active) state.
+	 */
+	iwl_set_bit(trans, CSR_GP_CNTRL,
+		    BIT(trans->cfg->csr->flag_init_done));
+
+	if (trans->cfg->device_family == IWL_DEVICE_FAMILY_8000)
+		udelay(2);
+
+	/*
+	 * Wait for clock stabilization; once stabilized, access to
+	 * device-internal resources is supported, e.g. iwl_write_prph()
+	 * and accesses to uCode SRAM.
+	 */
+	err = iwl_poll_bit(trans, CSR_GP_CNTRL,
+			   BIT(trans->cfg->csr->flag_mac_clock_ready),
+			   BIT(trans->cfg->csr->flag_mac_clock_ready),
+			   25000);
+	if (err < 0)
+		IWL_DEBUG_INFO(trans, "Failed to wake NIC\n");
+
+	return err < 0 ? err : 0;
+}
+IWL_EXPORT_SYMBOL(iwl_finish_nic_init);
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-io.h b/drivers/net/wireless/intel/iwlwifi/iwl-io.h
index 61477e58352d..bf1100837d72 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-io.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-io.h
@@ -5,6 +5,8 @@
  *
  * GPL LICENSE SUMMARY
  *
+ * Copyright (C) 2018 Intel Corporation
+ *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
  * published by the Free Software Foundation.
@@ -23,6 +25,7 @@
  *
  * BSD LICENSE
  *
+ * Copyright (C) 2018 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -96,6 +99,8 @@ void iwl_set_bits_mask_prph(struct iwl_trans *trans, u32 ofs,
 void iwl_clear_bits_prph(struct iwl_trans *trans, u32 ofs, u32 mask);
 void iwl_force_nmi(struct iwl_trans *trans);
 
+int iwl_finish_nic_init(struct iwl_trans *trans);
+
 /* Error handling */
 int iwl_dump_fh(struct iwl_trans *trans, char **buf);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index 92f61e8a6284..4a18997fb48a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -523,23 +523,9 @@ static void iwl_mvm_dump_lmac_error_log(struct iwl_mvm *mvm, u8 lmac_num)
 		/* reset the device */
 		iwl_trans_sw_reset(trans);
 
-		/* set INIT_DONE flag */
-		iwl_set_bit(trans, CSR_GP_CNTRL,
-			    BIT(trans->cfg->csr->flag_init_done));
-
-		/* and wait for clock stabilization */
-		if (trans->cfg->device_family == IWL_DEVICE_FAMILY_8000)
-			udelay(2);
-
-		err = iwl_poll_bit(trans, CSR_GP_CNTRL,
-				   BIT(trans->cfg->csr->flag_mac_clock_ready),
-				   BIT(trans->cfg->csr->flag_mac_clock_ready),
-				   25000);
-		if (err < 0) {
-			IWL_DEBUG_INFO(trans,
-				       "Failed to reset the card for the dump\n");
+		err = iwl_finish_nic_init(trans);
+		if (err)
 			return;
-		}
 	}
 
 	iwl_trans_read_mem_bytes(trans, base, &table, sizeof(table));
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
index 77f3610e5ca9..e2d64378c932 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
@@ -92,26 +92,9 @@ int iwl_pcie_gen2_apm_init(struct iwl_trans *trans)
 
 	iwl_pcie_apm_config(trans);
 
-	/*
-	 * Set "initialization complete" bit to move adapter from
-	 * D0U* --> D0A* (powered-up active) state.
-	 */
-	iwl_set_bit(trans, CSR_GP_CNTRL,
-		    BIT(trans->cfg->csr->flag_init_done));
-
-	/*
-	 * Wait for clock stabilization; once stabilized, access to
-	 * device-internal resources is supported, e.g. iwl_write_prph()
-	 * and accesses to uCode SRAM.
-	 */
-	ret = iwl_poll_bit(trans, CSR_GP_CNTRL,
-			   BIT(trans->cfg->csr->flag_mac_clock_ready),
-			   BIT(trans->cfg->csr->flag_mac_clock_ready),
-			   25000);
-	if (ret < 0) {
-		IWL_DEBUG_INFO(trans, "Failed to init the card\n");
+	ret = iwl_finish_nic_init(trans);
+	if (ret)
 		return ret;
-	}
 
 	set_bit(STATUS_DEVICE_ENABLED, &trans->status);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 0b29b2ebb23d..375d8f25b886 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -364,26 +364,9 @@ static int iwl_pcie_apm_init(struct iwl_trans *trans)
 	if (trans->cfg->base_params->pll_cfg)
 		iwl_set_bit(trans, CSR_ANA_PLL_CFG, CSR50_ANA_PLL_CFG_VAL);
 
-	/*
-	 * Set "initialization complete" bit to move adapter from
-	 * D0U* --> D0A* (powered-up active) state.
-	 */
-	iwl_set_bit(trans, CSR_GP_CNTRL,
-		    BIT(trans->cfg->csr->flag_init_done));
-
-	/*
-	 * Wait for clock stabilization; once stabilized, access to
-	 * device-internal resources is supported, e.g. iwl_write_prph()
-	 * and accesses to uCode SRAM.
-	 */
-	ret = iwl_poll_bit(trans, CSR_GP_CNTRL,
-			   BIT(trans->cfg->csr->flag_mac_clock_ready),
-			   BIT(trans->cfg->csr->flag_mac_clock_ready),
-			   25000);
-	if (ret < 0) {
-		IWL_ERR(trans, "Failed to init the card\n");
+	ret = iwl_finish_nic_init(trans);
+	if (ret)
 		return ret;
-	}
 
 	if (trans->cfg->host_interrupt_operation_mode) {
 		/*
@@ -453,23 +436,8 @@ static void iwl_pcie_apm_lp_xtal_enable(struct iwl_trans *trans)
 
 	iwl_trans_pcie_sw_reset(trans);
 
-	/*
-	 * Set "initialization complete" bit to move adapter from
-	 * D0U* --> D0A* (powered-up active) state.
-	 */
-	iwl_set_bit(trans, CSR_GP_CNTRL,
-		    BIT(trans->cfg->csr->flag_init_done));
-
-	/*
-	 * Wait for clock stabilization; once stabilized, access to
-	 * device-internal resources is possible.
-	 */
-	ret = iwl_poll_bit(trans, CSR_GP_CNTRL,
-			   BIT(trans->cfg->csr->flag_mac_clock_ready),
-			   BIT(trans->cfg->csr->flag_mac_clock_ready),
-			   25000);
-	if (WARN_ON(ret < 0)) {
-		IWL_ERR(trans, "Access time out - failed to enable LP XTAL\n");
+	ret = iwl_finish_nic_init(trans);
+	if (WARN_ON(ret)) {
 		/* Release XTAL ON request */
 		__iwl_trans_pcie_clear_bit(trans, CSR_GP_CNTRL,
 					   CSR_GP_CNTRL_REG_FLAG_XTAL_ON);
@@ -1558,20 +1526,10 @@ static int iwl_trans_pcie_d3_resume(struct iwl_trans *trans,
 
 	iwl_set_bit(trans, CSR_GP_CNTRL,
 		    BIT(trans->cfg->csr->flag_mac_access_req));
-	iwl_set_bit(trans, CSR_GP_CNTRL,
-		    BIT(trans->cfg->csr->flag_init_done));
 
-	if (trans->cfg->device_family >= IWL_DEVICE_FAMILY_8000)
-		udelay(2);
-
-	ret = iwl_poll_bit(trans, CSR_GP_CNTRL,
-			   BIT(trans->cfg->csr->flag_mac_clock_ready),
-			   BIT(trans->cfg->csr->flag_mac_clock_ready),
-			   25000);
-	if (ret < 0) {
-		IWL_ERR(trans, "Failed to resume the device (mac ready)\n");
+	ret = iwl_finish_nic_init(trans);
+	if (ret)
 		return ret;
-	}
 
 	/*
 	 * Reconfigure IVAR table in case of MSIX or reset ict table in
@@ -3521,18 +3479,9 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 		 * in-order to recognize C step driver should read chip version
 		 * id located at the AUX bus MISC address space.
 		 */
-		iwl_set_bit(trans, CSR_GP_CNTRL,
-			    BIT(trans->cfg->csr->flag_init_done));
-		udelay(2);
-
-		ret = iwl_poll_bit(trans, CSR_GP_CNTRL,
-				   BIT(trans->cfg->csr->flag_mac_clock_ready),
-				   BIT(trans->cfg->csr->flag_mac_clock_ready),
-				   25000);
-		if (ret < 0) {
-			IWL_DEBUG_INFO(trans, "Failed to wake up the nic\n");
+		ret = iwl_finish_nic_init(trans);
+		if (ret)
 			goto out_no_pci;
-		}
 
 		if (iwl_trans_grab_nic_access(trans, &flags)) {
 			u32 hw_step;
-- 
2.20.1

