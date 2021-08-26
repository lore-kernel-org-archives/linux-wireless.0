Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 111D8C4320E
	for <linux-wireless@archiver.kernel.org>; Thu, 26 Aug 2021 19:48:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EAC4B60F11
	for <linux-wireless@archiver.kernel.org>; Thu, 26 Aug 2021 19:48:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243522AbhHZTtY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 26 Aug 2021 15:49:24 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:33478 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S232398AbhHZTtX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 26 Aug 2021 15:49:23 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=kveik.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <luca@coelho.fi>)
        id 1mJLM3-002XB4-3k; Thu, 26 Aug 2021 22:48:04 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     luca@coelho.fi, linux-wireless@vger.kernel.org
Date:   Thu, 26 Aug 2021 22:47:48 +0300
Message-Id: <iwlwifi.20210826224715.609ad58a49f3.I05c351233601ecc51dddfa5df69ace292216eb95@changeid>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210826194748.826360-1-luca@coelho.fi>
References: <20210826194748.826360-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH v2 12/12] iwlwifi: Start scratch debug register for Bz family
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Matti Gottlieb <matti.gottlieb@intel.com>

Start scratch debug register for Bz family.
This register is used for FW debug, and the driver
should start this register with a fixed value, during
init, and upon an error, should read it, and add it to
the dump.

Signed-off-by: Matti Gottlieb <matti.gottlieb@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dump.c         | 7 +++++++
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h         | 7 +++++++
 drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c | 8 +++++---
 3 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dump.c b/drivers/net/wireless/intel/iwlwifi/fw/dump.c
index a1842205e86a..1f9cf4e40547 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dump.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dump.c
@@ -328,6 +328,13 @@ static void iwl_fwrt_dump_tcm_error_log(struct iwl_fw_runtime *fwrt)
 	for (i = 0; i < ARRAY_SIZE(table.sw_status); i++)
 		IWL_ERR(fwrt, "0x%08X | tcm SW status[%d]\n",
 			table.sw_status[i], i);
+
+	if (trans->trans_cfg->device_family >= IWL_DEVICE_FAMILY_BZ) {
+		u32 scratch = iwl_read32(trans, CSR_FUNC_SCRATCH);
+
+		IWL_ERR(fwrt, "Function Scratch status:\n");
+		IWL_ERR(fwrt, "0x%08X | Func Scratch\n", scratch);
+	}
 }
 
 static void iwl_fwrt_dump_iml_error_log(struct iwl_fw_runtime *fwrt)
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-csr.h b/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
index cf796403c45c..2c4d70fb32fa 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
@@ -34,6 +34,7 @@
 #define CSR_GPIO_IN             (CSR_BASE+0x018) /* read external chip pins */
 #define CSR_RESET               (CSR_BASE+0x020) /* busmaster enable, NMI, etc*/
 #define CSR_GP_CNTRL            (CSR_BASE+0x024)
+#define CSR_FUNC_SCRATCH        (CSR_BASE+0x02c) /* Scratch register - used for FW dbg */
 
 /* 2nd byte of CSR_INT_COALESCING, not accessible via iwl_write32()! */
 #define CSR_INT_PERIODIC_REG	(CSR_BASE+0x005)
@@ -135,6 +136,12 @@
 #define CSR_DBG_HPET_MEM_REG		(CSR_BASE+0x240)
 #define CSR_DBG_LINK_PWR_MGMT_REG	(CSR_BASE+0x250)
 
+/*
+ * Scratch register initial configuration - this is set on init, and read
+ * during a error FW error.
+ */
+#define CSR_FUNC_SCRATCH_INIT_VALUE		(0x01010101)
+
 /* Bits for CSR_HW_IF_CONFIG_REG */
 #define CSR_HW_IF_CONFIG_REG_MSK_MAC_DASH	(0x00000003)
 #define CSR_HW_IF_CONFIG_REG_MSK_MAC_STEP	(0x0000000C)
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
index bf0c32a74ca4..53bc5b7d8d5c 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
@@ -466,13 +466,15 @@ int iwl_trans_pcie_gen2_start_fw(struct iwl_trans *trans,
 
 	iwl_pcie_set_ltr(trans);
 
-	if (trans->trans_cfg->device_family >= IWL_DEVICE_FAMILY_BZ)
+	if (trans->trans_cfg->device_family >= IWL_DEVICE_FAMILY_BZ) {
+		iwl_write32(trans, CSR_FUNC_SCRATCH, CSR_FUNC_SCRATCH_INIT_VALUE);
 		iwl_set_bit(trans, CSR_GP_CNTRL,
 			    CSR_GP_CNTRL_REG_FLAG_ROM_START);
-	else if (trans->trans_cfg->device_family >= IWL_DEVICE_FAMILY_AX210)
+	} else if (trans->trans_cfg->device_family >= IWL_DEVICE_FAMILY_AX210) {
 		iwl_write_umac_prph(trans, UREG_CPU_INIT_RUN, 1);
-	else
+	} else {
 		iwl_write_prph(trans, UREG_CPU_INIT_RUN, 1);
+	}
 
 	/* re-check RF-Kill state since we may have missed the interrupt */
 	hw_rfkill = iwl_pcie_check_hw_rf_kill(trans);
-- 
2.33.0

