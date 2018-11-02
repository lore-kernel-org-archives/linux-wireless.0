Return-Path: <SRS0=E2P1=NN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A69DC65C22
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Nov 2018 11:08:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 21FB920657
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Nov 2018 11:08:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 21FB920657
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727312AbeKBUPC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 2 Nov 2018 16:15:02 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:34042 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726821AbeKBUPB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Nov 2018 16:15:01 -0400
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gIXJF-0007MW-Hb; Fri, 02 Nov 2018 13:08:14 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri,  2 Nov 2018 13:07:54 +0200
Message-Id: <20181102110800.29817-10-luca@coelho.fi>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181102110800.29817-1-luca@coelho.fi>
References: <20181102110800.29817-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 09/15] iwlwifi: dbg: avoid passing trigger around
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

The trigger structure is being passed around, when
all we care about is whether to dump only monitor
or not. Pass a bool instead.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c   | 20 +++++++++----------
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h   |  3 +--
 .../net/wireless/intel/iwlwifi/fw/runtime.h   |  2 +-
 .../net/wireless/intel/iwlwifi/iwl-trans.h    |  8 +++-----
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c   |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c  |  2 +-
 .../net/wireless/intel/iwlwifi/pcie/trans.c   |  4 ++--
 7 files changed, 18 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index c16757051f16..310af0d60101 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -655,13 +655,8 @@ _iwl_fw_error_dump(struct iwl_fw_runtime *fwrt,
 	u32 smem_len = fwrt->fw->dbg.n_mem_tlv ? 0 : fwrt->trans->cfg->smem_len;
 	u32 sram2_len = fwrt->fw->dbg.n_mem_tlv ?
 				0 : fwrt->trans->cfg->dccm2_len;
-	bool monitor_dump_only = false;
 	int i;
 
-	if (fwrt->dump.trig &&
-	    fwrt->dump.trig->mode & IWL_FW_DBG_TRIGGER_MONITOR_ONLY)
-		monitor_dump_only = true;
-
 	/* SRAM - include stack CCM if driver knows the values for it */
 	if (!fwrt->trans->cfg->dccm_offset || !fwrt->trans->cfg->dccm_len) {
 		const struct fw_img *img;
@@ -727,7 +722,7 @@ _iwl_fw_error_dump(struct iwl_fw_runtime *fwrt,
 	}
 
 	/* If we only want a monitor dump, reset the file length */
-	if (monitor_dump_only) {
+	if (fwrt->dump.monitor_only) {
 		file_len = sizeof(*dump_file) + sizeof(*dump_data) * 2 +
 			   sizeof(*dump_info) + sizeof(*dump_smem_cfg);
 	}
@@ -817,7 +812,7 @@ _iwl_fw_error_dump(struct iwl_fw_runtime *fwrt,
 	}
 
 	/* In case we only want monitor dump, skip to dump trasport data */
-	if (monitor_dump_only)
+	if (fwrt->dump.monitor_only)
 		goto out;
 
 	if (fwrt->fw->dbg.dump_mask & BIT(IWL_FW_ERROR_DUMP_MEM)) {
@@ -932,7 +927,7 @@ void iwl_fw_error_dump(struct iwl_fw_runtime *fwrt)
 	}
 
 	fw_error_dump->trans_ptr = iwl_trans_dump_data(fwrt->trans,
-						       fwrt->dump.trig);
+						       fwrt->dump.monitor_only);
 	file_len = le32_to_cpu(dump_file->file_len);
 	fw_error_dump->fwrt_len = file_len;
 	if (fw_error_dump->trans_ptr) {
@@ -998,7 +993,8 @@ void iwl_fw_alive_error_dump(struct iwl_fw_runtime *fwrt)
 IWL_EXPORT_SYMBOL(iwl_fw_alive_error_dump);
 
 int iwl_fw_dbg_collect_desc(struct iwl_fw_runtime *fwrt,
-			    const struct iwl_fw_dump_desc *desc, void *trigger,
+			    const struct iwl_fw_dump_desc *desc,
+			    bool monitor_only,
 			    unsigned int delay)
 {
 	/*
@@ -1028,7 +1024,7 @@ int iwl_fw_dbg_collect_desc(struct iwl_fw_runtime *fwrt,
 		 le32_to_cpu(desc->trig_desc.type));
 
 	fwrt->dump.desc = desc;
-	fwrt->dump.trig = trigger;
+	fwrt->dump.monitor_only = monitor_only;
 
 	schedule_delayed_work(&fwrt->dump.wk, delay);
 
@@ -1043,6 +1039,7 @@ int iwl_fw_dbg_collect(struct iwl_fw_runtime *fwrt,
 {
 	struct iwl_fw_dump_desc *desc;
 	unsigned int delay = 0;
+	bool monitor_only = false;
 
 	if (trigger) {
 		u16 occurrences = le16_to_cpu(trigger->occurrences) - 1;
@@ -1059,6 +1056,7 @@ int iwl_fw_dbg_collect(struct iwl_fw_runtime *fwrt,
 
 		trigger->occurrences = cpu_to_le16(occurrences);
 		delay = le16_to_cpu(trigger->trig_dis_ms);
+		monitor_only = trigger->mode & IWL_FW_DBG_TRIGGER_MONITOR_ONLY;
 	}
 
 	desc = kzalloc(sizeof(*desc) + len, GFP_ATOMIC);
@@ -1070,7 +1068,7 @@ int iwl_fw_dbg_collect(struct iwl_fw_runtime *fwrt,
 	desc->trig_desc.type = cpu_to_le32(trig);
 	memcpy(desc->trig_desc.data, str, len);
 
-	return iwl_fw_dbg_collect_desc(fwrt, desc, trigger, delay);
+	return iwl_fw_dbg_collect_desc(fwrt, desc, monitor_only, delay);
 }
 IWL_EXPORT_SYMBOL(iwl_fw_dbg_collect);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
index 6f8d3256f7b0..b56d787ffc1e 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
@@ -101,13 +101,12 @@ static inline void iwl_fw_free_dump_desc(struct iwl_fw_runtime *fwrt)
 	if (fwrt->dump.desc != &iwl_dump_desc_assert)
 		kfree(fwrt->dump.desc);
 	fwrt->dump.desc = NULL;
-	fwrt->dump.trig = NULL;
 }
 
 void iwl_fw_error_dump(struct iwl_fw_runtime *fwrt);
 int iwl_fw_dbg_collect_desc(struct iwl_fw_runtime *fwrt,
 			    const struct iwl_fw_dump_desc *desc,
-			    void *trigger, unsigned int delay);
+			    bool monitor_only, unsigned int delay);
 int iwl_fw_dbg_collect(struct iwl_fw_runtime *fwrt,
 		       enum iwl_fw_dbg_trigger trig,
 		       const char *str, size_t len,
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/runtime.h b/drivers/net/wireless/intel/iwlwifi/fw/runtime.h
index 6b95d0e75889..8a139431e7be 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/runtime.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/runtime.h
@@ -131,7 +131,7 @@ struct iwl_fw_runtime {
 	/* debug */
 	struct {
 		const struct iwl_fw_dump_desc *desc;
-		const struct iwl_fw_dbg_trigger_tlv *trig;
+		bool monitor_only;
 		struct delayed_work wk;
 
 		u8 conf;
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index 26b3c73051ca..f384a98a021c 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -602,8 +602,7 @@ struct iwl_trans_ops {
 	void (*resume)(struct iwl_trans *trans);
 
 	struct iwl_trans_dump_data *(*dump_data)(struct iwl_trans *trans,
-						 const struct iwl_fw_dbg_trigger_tlv
-						 *trigger);
+						 bool monitor_only);
 };
 
 /**
@@ -897,12 +896,11 @@ static inline void iwl_trans_resume(struct iwl_trans *trans)
 }
 
 static inline struct iwl_trans_dump_data *
-iwl_trans_dump_data(struct iwl_trans *trans,
-		    const struct iwl_fw_dbg_trigger_tlv *trigger)
+iwl_trans_dump_data(struct iwl_trans *trans, bool monitor_only)
 {
 	if (!trans->ops->dump_data)
 		return NULL;
-	return trans->ops->dump_data(trans, trigger);
+	return trans->ops->dump_data(trans, monitor_only);
 }
 
 static inline struct iwl_device_cmd *
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index 843f3b41b72e..9b018d00f78f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -1956,7 +1956,7 @@ static int __iwl_mvm_resume(struct iwl_mvm *mvm, bool test)
 		set_bit(STATUS_FW_ERROR, &mvm->trans->status);
 		iwl_mvm_dump_nic_error_log(mvm);
 		iwl_fw_dbg_collect_desc(&mvm->fwrt, &iwl_dump_desc_assert,
-					NULL, 0);
+					false, 0);
 		ret = 1;
 		goto err;
 	}
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 0d5b55ed8dda..2291661dd72d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -1233,7 +1233,7 @@ void iwl_mvm_nic_restart(struct iwl_mvm *mvm, bool fw_error)
 	 */
 	if (!mvm->fw_restart && fw_error) {
 		iwl_fw_dbg_collect_desc(&mvm->fwrt, &iwl_dump_desc_assert,
-					NULL, 0);
+					false, 0);
 	} else if (test_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status)) {
 		struct iwl_mvm_reprobe *reprobe;
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 890b51b223a1..551ce439647b 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -2990,7 +2990,7 @@ static int iwl_trans_get_fw_monitor_len(struct iwl_trans *trans, int *len)
 
 static struct iwl_trans_dump_data
 *iwl_trans_pcie_dump_data(struct iwl_trans *trans,
-			  const struct iwl_fw_dbg_trigger_tlv *trigger)
+			  bool monitor_only)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_fw_error_dump_data *data;
@@ -3014,7 +3014,7 @@ static struct iwl_trans_dump_data
 	/* FW monitor */
 	monitor_len = iwl_trans_get_fw_monitor_len(trans, &len);
 
-	if (trigger && (trigger->mode & IWL_FW_DBG_TRIGGER_MONITOR_ONLY)) {
+	if (monitor_only) {
 		if (!(trans->dbg_dump_mask &
 		      BIT(IWL_FW_ERROR_DUMP_FW_MONITOR)))
 			return NULL;
-- 
2.19.1

