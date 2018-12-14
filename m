Return-Path: <SRS0=OWo+=OX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5AF5C43444
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Dec 2018 20:30:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4FE8D2080F
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Dec 2018 20:30:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730932AbeLNUae (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 14 Dec 2018 15:30:34 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:42060 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730713AbeLNUae (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Dec 2018 15:30:34 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=localhost.localdomain)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gXu5v-0002RG-NC; Fri, 14 Dec 2018 22:30:00 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 14 Dec 2018 22:29:39 +0200
Message-Id: <20181214202945.32375-13-luca@coelho.fi>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181214202945.32375-1-luca@coelho.fi>
References: <20181214202945.32375-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 12/18] iwlwifi: wrt: add rt status and num of rx/tx fifos to dump
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

Add the rt status of the last assert or 0 if the dump collection was
not initiated by an assert.  Add the number of rx and tx fifos in use.
These fields are added to dump info lst file.

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        | 1 +
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h        | 1 +
 drivers/net/wireless/intel/iwlwifi/fw/error-dump.h | 3 +++
 drivers/net/wireless/intel/iwlwifi/fw/runtime.h    | 1 +
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c     | 3 +++
 5 files changed, 9 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index b17298ba7dc0..d1e6196a52a2 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -828,6 +828,7 @@ _iwl_fw_error_dump(struct iwl_fw_runtime *fwrt,
 			sizeof(dump_info->dev_human_readable) - 1);
 		strncpy(dump_info->bus_human_readable, fwrt->dev->bus->name,
 			sizeof(dump_info->bus_human_readable) - 1);
+		dump_info->rt_status = cpu_to_le32(fwrt->dump.rt_status);
 
 		dump_data = iwl_fw_error_next_data(dump_data);
 	}
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
index c14e4614a2ea..6aabbdd72326 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
@@ -102,6 +102,7 @@ static inline void iwl_fw_free_dump_desc(struct iwl_fw_runtime *fwrt)
 	if (fwrt->dump.desc != &iwl_dump_desc_assert)
 		kfree(fwrt->dump.desc);
 	fwrt->dump.desc = NULL;
+	fwrt->dump.rt_status = 0;
 }
 
 void iwl_fw_error_dump(struct iwl_fw_runtime *fwrt);
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h b/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h
index cefafc9a082f..65faecf552cd 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h
@@ -187,6 +187,8 @@ enum iwl_fw_error_dump_family {
  * @fw_human_readable: human readable FW version
  * @dev_human_readable: name of the device
  * @bus_human_readable: name of the bus used
+ * @rt_status: the error_id/rt_status that that triggered the latest dump
+ *	if the dump collection was not initiated by an assert, the value is 0
  */
 struct iwl_fw_error_dump_info {
 	__le32 device_family;
@@ -194,6 +196,7 @@ struct iwl_fw_error_dump_info {
 	u8 fw_human_readable[FW_VER_HUMAN_READABLE_SZ];
 	u8 dev_human_readable[64];
 	u8 bus_human_readable[8];
+	__le32 rt_status;
 } __packed;
 
 /**
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/runtime.h b/drivers/net/wireless/intel/iwlwifi/fw/runtime.h
index 77845de30c5c..4f7090f88cb0 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/runtime.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/runtime.h
@@ -142,6 +142,7 @@ struct iwl_fw_runtime {
 		u32 *d3_debug_data;
 		struct iwl_fw_ini_active_regs active_regs[IWL_FW_INI_MAX_REGION_ID];
 		struct iwl_fw_ini_active_triggers active_trigs[IWL_FW_TRIGGER_ID_NUM];
+		u32 rt_status;
 	} dump;
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 	struct {
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index 5ad352ef8e9b..d116c6ae18ff 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -540,6 +540,9 @@ static void iwl_mvm_dump_lmac_error_log(struct iwl_mvm *mvm, u32 base)
 
 	iwl_trans_read_mem_bytes(trans, base, &table, sizeof(table));
 
+	if (table.valid)
+		mvm->fwrt.dump.rt_status = table.error_id;
+
 	if (ERROR_START_OFFSET <= table.valid * ERROR_ELEM_SIZE) {
 		IWL_ERR(trans, "Start IWL Error Log Dump:\n");
 		IWL_ERR(trans, "Status: 0x%08lX, count: %d\n",
-- 
2.19.2

