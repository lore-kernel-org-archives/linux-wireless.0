Return-Path: <SRS0=pdv6=UY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2A24C48BD4
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Jun 2019 09:45:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 95D43214DA
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Jun 2019 09:45:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727952AbfFYJpB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 25 Jun 2019 05:45:01 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:54594 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726551AbfFYJpB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Jun 2019 05:45:01 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <luca@coelho.fi>)
        id 1hfi0Y-0007Nv-LF; Tue, 25 Jun 2019 12:44:58 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: [PATCH 02/12] iwlwifi: dbg: allow dump collection in case of an early error
Date:   Tue, 25 Jun 2019 12:44:42 +0300
Message-Id: <20190625094452.19034-3-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190625094452.19034-1-luca@coelho.fi>
References: <20190625094452.19034-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

Improve the robustness of the dump collection flow in case of an early
error:
1. in iwl_trans_pcie_sync_nmi, disable and enable interrupts only if
   they were already enabled
2. attempt to initiate dump collection in iwl_fw_dbg_error_collect only
   if the device is enabled
3. check Tx command queue was already allocated before trying to collect it

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c   |  7 +++++--
 .../net/wireless/intel/iwlwifi/pcie/trans.c   | 21 +++++++++++++++----
 2 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 5f52e40a2903..5650b57a64e9 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -2057,9 +2057,12 @@ int iwl_fw_dbg_error_collect(struct iwl_fw_runtime *fwrt,
 			     enum iwl_fw_dbg_trigger trig_type)
 {
 	int ret;
-	struct iwl_fw_dump_desc *iwl_dump_error_desc =
-		kmalloc(sizeof(*iwl_dump_error_desc), GFP_KERNEL);
+	struct iwl_fw_dump_desc *iwl_dump_error_desc;
 
+	if (!test_bit(STATUS_DEVICE_ENABLED, &fwrt->trans->status))
+		return -EIO;
+
+	iwl_dump_error_desc = kmalloc(sizeof(*iwl_dump_error_desc), GFP_KERNEL);
 	if (!iwl_dump_error_desc)
 		return -ENOMEM;
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 803fcbac4152..ca486a7af602 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -3172,7 +3172,7 @@ static struct iwl_trans_dump_data
 	len = sizeof(*dump_data);
 
 	/* host commands */
-	if (dump_mask & BIT(IWL_FW_ERROR_DUMP_TXCMD))
+	if (dump_mask & BIT(IWL_FW_ERROR_DUMP_TXCMD) && cmdq)
 		len += sizeof(*data) +
 			cmdq->n_window * (sizeof(*txcmd) +
 					  TFD_MAX_PAYLOAD_SIZE);
@@ -3224,7 +3224,7 @@ static struct iwl_trans_dump_data
 	len = 0;
 	data = (void *)dump_data->data;
 
-	if (dump_mask & BIT(IWL_FW_ERROR_DUMP_TXCMD)) {
+	if (dump_mask & BIT(IWL_FW_ERROR_DUMP_TXCMD) && cmdq) {
 		u16 tfd_size = trans_pcie->tfd_size;
 
 		data->type = cpu_to_le32(IWL_FW_ERROR_DUMP_TXCMD);
@@ -3658,6 +3658,7 @@ void iwl_trans_pcie_sync_nmi(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	unsigned long timeout = jiffies + IWL_TRANS_NMI_TIMEOUT;
+	bool interrupts_enabled = test_bit(STATUS_INT_ENABLED, &trans->status);
 	u32 inta_addr, sw_err_bit;
 
 	if (trans_pcie->msix_enabled) {
@@ -3668,7 +3669,12 @@ void iwl_trans_pcie_sync_nmi(struct iwl_trans *trans)
 		sw_err_bit = CSR_INT_BIT_SW_ERR;
 	}
 
-	iwl_disable_interrupts(trans);
+	/* if the interrupts were already disabled, there is no point in
+	 * calling iwl_disable_interrupts
+	 */
+	if (interrupts_enabled)
+		iwl_disable_interrupts(trans);
+
 	iwl_force_nmi(trans);
 	while (time_after(timeout, jiffies)) {
 		u32 inta_hw = iwl_read32(trans, inta_addr);
@@ -3682,6 +3688,13 @@ void iwl_trans_pcie_sync_nmi(struct iwl_trans *trans)
 
 		mdelay(1);
 	}
-	iwl_enable_interrupts(trans);
+
+	/* enable interrupts only if there were already enabled before this
+	 * function to avoid a case were the driver enable interrupts before
+	 * proper configurations were made
+	 */
+	if (interrupts_enabled)
+		iwl_enable_interrupts(trans);
+
 	iwl_trans_fw_error(trans);
 }
-- 
2.20.1

