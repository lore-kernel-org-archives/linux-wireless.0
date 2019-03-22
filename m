Return-Path: <SRS0=qAgV=RZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 895A2C4360F
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 13:59:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 61163218E2
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 13:59:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727836AbfCVN7P (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Mar 2019 09:59:15 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:46056 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727806AbfCVN7P (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Mar 2019 09:59:15 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1h7KhU-0000bK-4m; Fri, 22 Mar 2019 15:59:13 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 22 Mar 2019 15:58:40 +0200
Message-Id: <20190322135903.10631-2-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190322135903.10631-1-luca@coelho.fi>
References: <20190322135903.10631-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 01/24] iwlwifi: dbg_ini: support HW error trigger
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

Differentiate between SW and HW error interrupts and support ini HW
error trigger.

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h    | 10 ++++++++++
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h |  2 ++
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c   |  7 +++----
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c   |  1 +
 4 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
index 13cb164a4fb9..cccf91db74c4 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
@@ -458,4 +458,14 @@ static inline void iwl_fw_umac_set_alive_err_table(struct iwl_trans *trans,
 /* This bit is used to differentiate the legacy dump from the ini dump */
 #define INI_DUMP_BIT BIT(31)
 
+static inline void iwl_fw_error_collect(struct iwl_fw_runtime *fwrt)
+{
+	if (fwrt->trans->ini_valid && fwrt->trans->hw_error) {
+		_iwl_fw_dbg_ini_collect(fwrt, IWL_FW_TRIGGER_ID_FW_HW_ERROR);
+		fwrt->trans->hw_error = false;
+	} else {
+		iwl_fw_dbg_collect_desc(fwrt, &iwl_dump_desc_assert, false, 0);
+	}
+}
+
 #endif  /* __iwl_fw_dbg_h__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index cef045d3f1bf..2235978adf70 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -768,6 +768,7 @@ struct iwl_self_init_dram {
  * @umac_error_event_table: addr of umac error table
  * @error_event_table_tlv_status: bitmap that indicates what error table
  *	pointers was recevied via TLV. use enum &iwl_error_event_table_status
+ * @hw_error: equals true if hw error interrupt was received from the FW
  */
 struct iwl_trans {
 	const struct iwl_trans_ops *ops;
@@ -831,6 +832,7 @@ struct iwl_trans {
 	u32 umac_error_event_table;
 	unsigned int error_event_table_tlv_status;
 	wait_queue_head_t fw_halt_waitq;
+	bool hw_error;
 
 	/* pointer to trans specific struct */
 	/*Ensure that this pointer will always be aligned to sizeof pointer */
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 3cc6048d6a10..8e2e4fa7914e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -1291,8 +1291,7 @@ void iwl_mvm_nic_restart(struct iwl_mvm *mvm, bool fw_error)
 	 * can't recover this since we're already half suspended.
 	 */
 	if (!mvm->fw_restart && fw_error) {
-		iwl_fw_dbg_collect_desc(&mvm->fwrt, &iwl_dump_desc_assert,
-					false, 0);
+		iwl_fw_error_collect(&mvm->fwrt);
 	} else if (test_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status)) {
 		struct iwl_mvm_reprobe *reprobe;
 
@@ -1340,8 +1339,8 @@ void iwl_mvm_nic_restart(struct iwl_mvm *mvm, bool fw_error)
 			}
 		}
 
-		iwl_fw_dbg_collect_desc(&mvm->fwrt, &iwl_dump_desc_assert,
-					false, 0);
+		iwl_fw_error_collect(&mvm->fwrt);
+
 		if (fw_error && mvm->fw_restart > 0)
 			mvm->fw_restart--;
 		set_bit(IWL_MVM_STATUS_HW_RESTART_REQUESTED, &mvm->status);
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index abe40196266b..69fcfa930791 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -2207,6 +2207,7 @@ irqreturn_t iwl_pcie_irq_msix_handler(int irq, void *dev_id)
 			"Hardware error detected. Restarting.\n");
 
 		isr_stats->hw++;
+		trans->hw_error = true;
 		iwl_pcie_irq_handle_error(trans);
 	}
 
-- 
2.20.1

