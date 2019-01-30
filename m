Return-Path: <SRS0=OIIa=QG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9690C282D7
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 11:55:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9510620855
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 11:55:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730716AbfA3Lzz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 30 Jan 2019 06:55:55 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:52778 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727878AbfA3Lzy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Jan 2019 06:55:54 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gooT9-0003x8-9Q; Wed, 30 Jan 2019 13:55:51 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Wed, 30 Jan 2019 13:55:19 +0200
Message-Id: <20190130115528.19922-9-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190130115528.19922-1-luca@coelho.fi>
References: <20190130115528.19922-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 08/17] iwlwifi: differentiate between alive timeout and alive flow failure
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

There are two cases that can cause the alive flow to fail,
an assert or a timeout.
Currently we mask any incoming asserts when we wait for alive.

Solve this by differentiating between the two cases:
1. Let the regular error handling to handle a received assert
2. Do a dump collection in the case of a timeout

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Fixes: f38efdb29389 ("iwlwifi: add dump collection in case alive flow fails")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c   | 31 +++++++++++--------
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h   |  2 +-
 .../wireless/intel/iwlwifi/fw/error-dump.h    |  4 +--
 .../net/wireless/intel/iwlwifi/fw/runtime.h   |  1 -
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c   |  5 +--
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c  |  2 --
 6 files changed, 24 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index d16a8a4f0c3f..0edc5bcdfb82 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -1373,29 +1373,35 @@ void iwl_fw_assert_error_dump(struct iwl_fw_runtime *fwrt)
 }
 IWL_EXPORT_SYMBOL(iwl_fw_assert_error_dump);
 
-void iwl_fw_alive_error_dump(struct iwl_fw_runtime *fwrt)
+void iwl_fw_alive_timeout_dump(struct iwl_fw_runtime *fwrt)
 {
-	struct iwl_fw_dump_desc *iwl_dump_desc_no_alive =
-		kmalloc(sizeof(*iwl_dump_desc_no_alive), GFP_KERNEL);
+	struct iwl_fw_dump_desc *iwl_dump_desc_alive_timeout;
 
-	if (!iwl_dump_desc_no_alive)
+	if (test_and_set_bit(IWL_FWRT_STATUS_DUMPING, &fwrt->status))
 		return;
 
-	iwl_dump_desc_no_alive->trig_desc.type =
-		cpu_to_le32(FW_DBG_TRIGGER_NO_ALIVE);
-	iwl_dump_desc_no_alive->len = 0;
+	iwl_dump_desc_alive_timeout =
+		kmalloc(sizeof(*iwl_dump_desc_alive_timeout), GFP_KERNEL);
+	if (!iwl_dump_desc_alive_timeout)
+		return;
+
+	iwl_dump_desc_alive_timeout->trig_desc.type =
+		cpu_to_le32(FW_DBG_TRIGGER_ALIVE_TIMEOUT);
+	iwl_dump_desc_alive_timeout->len = 0;
 
 	if (WARN_ON(fwrt->dump.desc))
 		iwl_fw_free_dump_desc(fwrt);
 
 	IWL_WARN(fwrt, "Collecting data: trigger %d fired.\n",
-		 FW_DBG_TRIGGER_NO_ALIVE);
+		 FW_DBG_TRIGGER_ALIVE_TIMEOUT);
+
+	/* set STATUS_FW_ERROR to collect all memory regions. */
+	set_bit(STATUS_FW_ERROR, &fwrt->trans->status);
 
-	fwrt->dump.desc = iwl_dump_desc_no_alive;
+	fwrt->dump.desc = iwl_dump_desc_alive_timeout;
 	iwl_fw_error_dump(fwrt);
-	clear_bit(IWL_FWRT_STATUS_WAIT_ALIVE, &fwrt->status);
 }
-IWL_EXPORT_SYMBOL(iwl_fw_alive_error_dump);
+IWL_EXPORT_SYMBOL(iwl_fw_alive_timeout_dump);
 
 int iwl_fw_dbg_collect_desc(struct iwl_fw_runtime *fwrt,
 			    const struct iwl_fw_dump_desc *desc,
@@ -1418,8 +1424,7 @@ int iwl_fw_dbg_collect_desc(struct iwl_fw_runtime *fwrt,
 	    fwrt->smem_cfg.num_lmacs)
 		return -EIO;
 
-	if (test_and_set_bit(IWL_FWRT_STATUS_DUMPING, &fwrt->status) ||
-	    test_bit(IWL_FWRT_STATUS_WAIT_ALIVE, &fwrt->status))
+	if (test_and_set_bit(IWL_FWRT_STATUS_DUMPING, &fwrt->status))
 		return -EBUSY;
 
 	if (WARN_ON(fwrt->dump.desc))
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
index 330229d2a61d..36e0f40dab3b 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
@@ -435,7 +435,7 @@ static inline void iwl_fw_resume_timestamp(struct iwl_fw_runtime *fwrt) {}
 #endif /* CONFIG_IWLWIFI_DEBUGFS */
 
 void iwl_fw_assert_error_dump(struct iwl_fw_runtime *fwrt);
-void iwl_fw_alive_error_dump(struct iwl_fw_runtime *fwrt);
+void iwl_fw_alive_timeout_dump(struct iwl_fw_runtime *fwrt);
 void iwl_fw_dbg_collect_sync(struct iwl_fw_runtime *fwrt);
 void iwl_fw_dbg_apply_point(struct iwl_fw_runtime *fwrt,
 			    enum iwl_fw_ini_apply_point apply_point);
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h b/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h
index c02425a1e64f..d06707f3a2a4 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h
@@ -355,7 +355,7 @@ iwl_fw_error_next_data(struct iwl_fw_error_dump_data *data)
  * @FW_DBG_TDLS: trigger log collection upon TDLS related events.
  * @FW_DBG_TRIGGER_TX_STATUS: trigger log collection upon tx status when
  *  the firmware sends a tx reply.
- * @FW_DBG_TRIGGER_NO_ALIVE: trigger log collection if alive flow fails
+ * @FW_DBG_TRIGGER_ALIVE_TIMEOUT: trigger log collection if alive flow timeouts
  */
 enum iwl_fw_dbg_trigger {
 	FW_DBG_TRIGGER_INVALID = 0,
@@ -373,7 +373,7 @@ enum iwl_fw_dbg_trigger {
 	FW_DBG_TRIGGER_TX_LATENCY,
 	FW_DBG_TRIGGER_TDLS,
 	FW_DBG_TRIGGER_TX_STATUS,
-	FW_DBG_TRIGGER_NO_ALIVE,
+	FW_DBG_TRIGGER_ALIVE_TIMEOUT,
 
 	/* must be last */
 	FW_DBG_TRIGGER_MAX,
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/runtime.h b/drivers/net/wireless/intel/iwlwifi/fw/runtime.h
index a0fcbb28114b..9ff04ffba3fa 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/runtime.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/runtime.h
@@ -90,7 +90,6 @@ struct iwl_fwrt_shared_mem_cfg {
 
 enum iwl_fw_runtime_status {
 	IWL_FWRT_STATUS_DUMPING = 0,
-	IWL_FWRT_STATUS_WAIT_ALIVE,
 };
 
 /**
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index d3dc9d276e0f..25c8cea1180e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -299,7 +299,6 @@ static int iwl_mvm_load_ucode_wait_alive(struct iwl_mvm *mvm,
 	enum iwl_ucode_type old_type = mvm->fwrt.cur_fw_img;
 	static const u16 alive_cmd[] = { MVM_ALIVE };
 
-	set_bit(IWL_FWRT_STATUS_WAIT_ALIVE, &mvm->fwrt.status);
 	if (ucode_type == IWL_UCODE_REGULAR &&
 	    iwl_fw_dbg_conf_usniffer(mvm->fw, FW_DBG_START_FROM_ALIVE) &&
 	    !(fw_has_capa(&mvm->fw->ucode_capa,
@@ -332,6 +331,9 @@ static int iwl_mvm_load_ucode_wait_alive(struct iwl_mvm *mvm,
 	if (ret) {
 		struct iwl_trans *trans = mvm->trans;
 
+		if (ret == -ETIMEDOUT)
+			iwl_fw_alive_timeout_dump(&mvm->fwrt);
+
 		if (trans->cfg->device_family >= IWL_DEVICE_FAMILY_22000)
 			IWL_ERR(mvm,
 				"SecBoot CPU1 Status: 0x%x, CPU2 Status: 0x%x\n",
@@ -377,7 +379,6 @@ static int iwl_mvm_load_ucode_wait_alive(struct iwl_mvm *mvm,
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 	iwl_fw_set_dbg_rec_on(&mvm->fwrt);
 #endif
-	clear_bit(IWL_FWRT_STATUS_WAIT_ALIVE, &mvm->fwrt.status);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index e56b31692a20..a2719a75249a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -818,8 +818,6 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	mutex_lock(&mvm->mutex);
 	iwl_mvm_ref(mvm, IWL_MVM_REF_INIT_UCODE);
 	err = iwl_run_init_mvm_ucode(mvm, true);
-	if (test_bit(IWL_FWRT_STATUS_WAIT_ALIVE, &mvm->fwrt.status))
-		iwl_fw_alive_error_dump(&mvm->fwrt);
 	if (!iwlmvm_mod_params.init_dbg || !err)
 		iwl_mvm_stop_device(mvm);
 	iwl_mvm_unref(mvm, IWL_MVM_REF_INIT_UCODE);
-- 
2.20.1

