Return-Path: <SRS0=80NG=P2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B77F0C07EBF
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Jan 2019 19:00:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89CE42086D
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Jan 2019 19:00:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729180AbfARTAS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 18 Jan 2019 14:00:18 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:48312 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729096AbfARTAR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Jan 2019 14:00:17 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gkZNG-0004cj-Pr; Fri, 18 Jan 2019 21:00:15 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 18 Jan 2019 20:59:50 +0200
Message-Id: <20190118190004.22270-3-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190118190004.22270-1-luca@coelho.fi>
References: <20190118190004.22270-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 02/16] iwlwifi: wrt: add to dump number of lmacs, lmac1 and umac error id
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

Add to the dump the number of lmacs, the error id of the umac
and the error id of lmac1, if supported.
In case the reason for the dump trigger is not an assert
the error id is zero.

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        |  8 +++++++-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h        |  5 ++++-
 drivers/net/wireless/intel/iwlwifi/fw/error-dump.h | 11 +++++++++--
 drivers/net/wireless/intel/iwlwifi/fw/runtime.h    |  3 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c     | 13 ++++++++-----
 5 files changed, 30 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 2a19b178c5e8..d4d6544f8833 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -828,7 +828,13 @@ _iwl_fw_error_dump(struct iwl_fw_runtime *fwrt,
 			sizeof(dump_info->dev_human_readable) - 1);
 		strncpy(dump_info->bus_human_readable, fwrt->dev->bus->name,
 			sizeof(dump_info->bus_human_readable) - 1);
-		dump_info->rt_status = cpu_to_le32(fwrt->dump.rt_status);
+		dump_info->num_of_lmacs = fwrt->smem_cfg.num_lmacs;
+		dump_info->lmac_err_id[0] =
+			cpu_to_le32(fwrt->dump.lmac_err_id[0]);
+		if (fwrt->smem_cfg.num_lmacs > 1)
+			dump_info->lmac_err_id[1] =
+				cpu_to_le32(fwrt->dump.lmac_err_id[1]);
+		dump_info->umac_err_id = cpu_to_le32(fwrt->dump.umac_err_id);
 
 		dump_data = iwl_fw_error_next_data(dump_data);
 	}
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
index 6aabbdd72326..40dcc3deb257 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
@@ -102,7 +102,10 @@ static inline void iwl_fw_free_dump_desc(struct iwl_fw_runtime *fwrt)
 	if (fwrt->dump.desc != &iwl_dump_desc_assert)
 		kfree(fwrt->dump.desc);
 	fwrt->dump.desc = NULL;
-	fwrt->dump.rt_status = 0;
+	fwrt->dump.lmac_err_id[0] = 0;
+	if (fwrt->smem_cfg.num_lmacs > 1)
+		fwrt->dump.lmac_err_id[1] = 0;
+	fwrt->dump.umac_err_id = 0;
 }
 
 void iwl_fw_error_dump(struct iwl_fw_runtime *fwrt);
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h b/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h
index 65faecf552cd..c02425a1e64f 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h
@@ -180,6 +180,8 @@ enum iwl_fw_error_dump_family {
 	IWL_FW_ERROR_DUMP_FAMILY_8 = 8,
 };
 
+#define MAX_NUM_LMAC 2
+
 /**
  * struct iwl_fw_error_dump_info - info on the device / firmware
  * @device_family: the family of the device (7 / 8)
@@ -187,7 +189,10 @@ enum iwl_fw_error_dump_family {
  * @fw_human_readable: human readable FW version
  * @dev_human_readable: name of the device
  * @bus_human_readable: name of the bus used
- * @rt_status: the error_id/rt_status that that triggered the latest dump
+ * @num_of_lmacs: the number of lmacs
+ * @lmac_err_id: the lmac 0/1 error_id/rt_status that triggered the latest dump
+ *	if the dump collection was not initiated by an assert, the value is 0
+ * @umac_err_id: the umac error_id/rt_status that triggered the latest dump
  *	if the dump collection was not initiated by an assert, the value is 0
  */
 struct iwl_fw_error_dump_info {
@@ -196,7 +201,9 @@ struct iwl_fw_error_dump_info {
 	u8 fw_human_readable[FW_VER_HUMAN_READABLE_SZ];
 	u8 dev_human_readable[64];
 	u8 bus_human_readable[8];
-	__le32 rt_status;
+	u8 num_of_lmacs;
+	__le32 umac_err_id;
+	__le32 lmac_err_id[MAX_NUM_LMAC];
 } __packed;
 
 /**
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/runtime.h b/drivers/net/wireless/intel/iwlwifi/fw/runtime.h
index 4f7090f88cb0..a0fcbb28114b 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/runtime.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/runtime.h
@@ -142,7 +142,8 @@ struct iwl_fw_runtime {
 		u32 *d3_debug_data;
 		struct iwl_fw_ini_active_regs active_regs[IWL_FW_INI_MAX_REGION_ID];
 		struct iwl_fw_ini_active_triggers active_trigs[IWL_FW_TRIGGER_ID_NUM];
-		u32 rt_status;
+		u32 lmac_err_id[MAX_NUM_LMAC];
+		u32 umac_err_id;
 	} dump;
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 	struct {
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index d116c6ae18ff..e8659bf50890 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -463,6 +463,9 @@ static void iwl_mvm_dump_umac_error_log(struct iwl_mvm *mvm)
 	iwl_trans_read_mem_bytes(trans, mvm->umac_error_event_table, &table,
 				 sizeof(table));
 
+	if (table.valid)
+		mvm->fwrt.dump.umac_err_id = table.error_id;
+
 	if (ERROR_START_OFFSET <= table.valid * ERROR_ELEM_SIZE) {
 		IWL_ERR(trans, "Start IWL Error Log Dump:\n");
 		IWL_ERR(trans, "Status: 0x%08lX, count: %d\n",
@@ -486,11 +489,11 @@ static void iwl_mvm_dump_umac_error_log(struct iwl_mvm *mvm)
 	IWL_ERR(mvm, "0x%08X | isr status reg\n", table.nic_isr_pref);
 }
 
-static void iwl_mvm_dump_lmac_error_log(struct iwl_mvm *mvm, u32 base)
+static void iwl_mvm_dump_lmac_error_log(struct iwl_mvm *mvm, u8 lmac_num)
 {
 	struct iwl_trans *trans = mvm->trans;
 	struct iwl_error_event_table table;
-	u32 val;
+	u32 val, base = mvm->error_event_table[lmac_num];
 
 	if (mvm->fwrt.cur_fw_img == IWL_UCODE_INIT) {
 		if (!base)
@@ -541,7 +544,7 @@ static void iwl_mvm_dump_lmac_error_log(struct iwl_mvm *mvm, u32 base)
 	iwl_trans_read_mem_bytes(trans, base, &table, sizeof(table));
 
 	if (table.valid)
-		mvm->fwrt.dump.rt_status = table.error_id;
+		mvm->fwrt.dump.lmac_err_id[lmac_num] = table.error_id;
 
 	if (ERROR_START_OFFSET <= table.valid * ERROR_ELEM_SIZE) {
 		IWL_ERR(trans, "Start IWL Error Log Dump:\n");
@@ -598,10 +601,10 @@ void iwl_mvm_dump_nic_error_log(struct iwl_mvm *mvm)
 		return;
 	}
 
-	iwl_mvm_dump_lmac_error_log(mvm, mvm->error_event_table[0]);
+	iwl_mvm_dump_lmac_error_log(mvm, 0);
 
 	if (mvm->error_event_table[1])
-		iwl_mvm_dump_lmac_error_log(mvm, mvm->error_event_table[1]);
+		iwl_mvm_dump_lmac_error_log(mvm, 1);
 
 	iwl_mvm_dump_umac_error_log(mvm);
 }
-- 
2.20.1

