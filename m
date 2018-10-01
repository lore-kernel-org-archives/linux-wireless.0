Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60AF2C00449
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 12:10:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 313162084C
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 12:10:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 313162084C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729162AbeJASrw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 14:47:52 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:54310 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728999AbeJASrv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 14:47:51 -0400
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1g6x1o-0006wq-FP; Mon, 01 Oct 2018 15:10:21 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Mon,  1 Oct 2018 15:09:56 +0300
Message-Id: <20181001121010.29684-3-luca@coelho.fi>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <20181001121010.29684-1-luca@coelho.fi>
References: <20181001121010.29684-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 02/16] iwlwifi: add dump collection in case alive flow fails
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

Trigger dump collection if the alive flow fails, regardless of the
reason.

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c   | 27 ++++++++++++++++++-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h   |  1 +
 .../wireless/intel/iwlwifi/fw/error-dump.h    |  2 ++
 .../net/wireless/intel/iwlwifi/fw/runtime.h   |  1 +
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c   |  2 ++
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c  |  2 ++
 6 files changed, 34 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 146ec5065825..a049367ac08a 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -973,6 +973,30 @@ const struct iwl_fw_dump_desc iwl_dump_desc_assert = {
 };
 IWL_EXPORT_SYMBOL(iwl_dump_desc_assert);
 
+void iwl_fw_alive_error_dump(struct iwl_fw_runtime *fwrt)
+{
+	struct iwl_fw_dump_desc *iwl_dump_desc_no_alive =
+		kmalloc(sizeof(*iwl_dump_desc_no_alive), GFP_KERNEL);
+
+	if (!iwl_dump_desc_no_alive)
+		return;
+
+	iwl_dump_desc_no_alive->trig_desc.type =
+		cpu_to_le32(FW_DBG_TRIGGER_NO_ALIVE);
+	iwl_dump_desc_no_alive->len = 0;
+
+	if (WARN_ON(fwrt->dump.desc))
+		iwl_fw_free_dump_desc(fwrt);
+
+	IWL_WARN(fwrt, "Collecting data: trigger %d fired.\n",
+		 FW_DBG_TRIGGER_NO_ALIVE);
+
+	fwrt->dump.desc = iwl_dump_desc_no_alive;
+	iwl_fw_error_dump(fwrt);
+	clear_bit(IWL_FWRT_STATUS_WAIT_ALIVE, &fwrt->status);
+}
+IWL_EXPORT_SYMBOL(iwl_fw_alive_error_dump);
+
 int iwl_fw_dbg_collect_desc(struct iwl_fw_runtime *fwrt,
 			    const struct iwl_fw_dump_desc *desc,
 			    const struct iwl_fw_dbg_trigger_tlv *trigger)
@@ -998,7 +1022,8 @@ int iwl_fw_dbg_collect_desc(struct iwl_fw_runtime *fwrt,
 	    fwrt->smem_cfg.num_lmacs)
 		return -EIO;
 
-	if (test_and_set_bit(IWL_FWRT_STATUS_DUMPING, &fwrt->status))
+	if (test_and_set_bit(IWL_FWRT_STATUS_DUMPING, &fwrt->status) ||
+	    test_bit(IWL_FWRT_STATUS_WAIT_ALIVE, &fwrt->status))
 		return -EBUSY;
 
 	if (WARN_ON(fwrt->dump.desc))
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
index 5b087fc4f380..0f09a2128ad2 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
@@ -368,4 +368,5 @@ static inline void iwl_fw_resume_timestamp(struct iwl_fw_runtime *fwrt) {}
 
 #endif /* CONFIG_IWLWIFI_DEBUGFS */
 
+void iwl_fw_alive_error_dump(struct iwl_fw_runtime *fwrt);
 #endif  /* __iwl_fw_dbg_h__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h b/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h
index 6d3ef331b7d5..6fede174c664 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h
@@ -328,6 +328,7 @@ iwl_fw_error_next_data(struct iwl_fw_error_dump_data *data)
  * @FW_DBG_TDLS: trigger log collection upon TDLS related events.
  * @FW_DBG_TRIGGER_TX_STATUS: trigger log collection upon tx status when
  *  the firmware sends a tx reply.
+ * @FW_DBG_TRIGGER_NO_ALIVE: trigger log collection if alive flow fails
  */
 enum iwl_fw_dbg_trigger {
 	FW_DBG_TRIGGER_INVALID = 0,
@@ -345,6 +346,7 @@ enum iwl_fw_dbg_trigger {
 	FW_DBG_TRIGGER_TX_LATENCY,
 	FW_DBG_TRIGGER_TDLS,
 	FW_DBG_TRIGGER_TX_STATUS,
+	FW_DBG_TRIGGER_NO_ALIVE,
 
 	/* must be last */
 	FW_DBG_TRIGGER_MAX,
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/runtime.h b/drivers/net/wireless/intel/iwlwifi/fw/runtime.h
index 9ed5819defaf..ac6db5e2b3d0 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/runtime.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/runtime.h
@@ -88,6 +88,7 @@ struct iwl_fwrt_shared_mem_cfg {
 
 enum iwl_fw_runtime_status {
 	IWL_FWRT_STATUS_DUMPING = 0,
+	IWL_FWRT_STATUS_WAIT_ALIVE,
 };
 
 /**
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 3fee304cddbb..c5df73231ba3 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -299,6 +299,7 @@ static int iwl_mvm_load_ucode_wait_alive(struct iwl_mvm *mvm,
 	enum iwl_ucode_type old_type = mvm->fwrt.cur_fw_img;
 	static const u16 alive_cmd[] = { MVM_ALIVE };
 
+	set_bit(IWL_FWRT_STATUS_WAIT_ALIVE, &mvm->fwrt.status);
 	if (ucode_type == IWL_UCODE_REGULAR &&
 	    iwl_fw_dbg_conf_usniffer(mvm->fw, FW_DBG_START_FROM_ALIVE) &&
 	    !(fw_has_capa(&mvm->fw->ucode_capa,
@@ -369,6 +370,7 @@ static int iwl_mvm_load_ucode_wait_alive(struct iwl_mvm *mvm,
 		atomic_set(&mvm->mac80211_queue_stop_count[i], 0);
 
 	set_bit(IWL_MVM_STATUS_FIRMWARE_RUNNING, &mvm->status);
+	clear_bit(IWL_FWRT_STATUS_WAIT_ALIVE, &mvm->fwrt.status);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index b058b7de88be..c388e0e758e7 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -788,6 +788,8 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	mutex_lock(&mvm->mutex);
 	iwl_mvm_ref(mvm, IWL_MVM_REF_INIT_UCODE);
 	err = iwl_run_init_mvm_ucode(mvm, true);
+	if (test_bit(IWL_FWRT_STATUS_WAIT_ALIVE, &mvm->fwrt.status))
+		iwl_fw_alive_error_dump(&mvm->fwrt);
 	if (!iwlmvm_mod_params.init_dbg || !err)
 		iwl_mvm_stop_device(mvm);
 	iwl_mvm_unref(mvm, IWL_MVM_REF_INIT_UCODE);
-- 
2.19.0

