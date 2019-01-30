Return-Path: <SRS0=OIIa=QG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08969C282D7
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 11:56:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE51D20855
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 11:56:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730843AbfA3L4f (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 30 Jan 2019 06:56:35 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:52878 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730308AbfA3L4e (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Jan 2019 06:56:34 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gooTD-0003x8-2E; Wed, 30 Jan 2019 13:55:55 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Wed, 30 Jan 2019 13:55:24 +0200
Message-Id: <20190130115528.19922-14-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190130115528.19922-1-luca@coelho.fi>
References: <20190130115528.19922-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 13/17] iwlwifi: Fix pre operational dumping flows
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

There are several dumping flows in the driver in case of a fail
prior to operational.

In some cases we get 2 dumps while in others we get none.

Fix this by uniting the different flows.
Add a different dump type to driver triggered dumps in case we want
a dump but did not got assert, and make all dumping go through
iwl_fw_dbg_collect_desc to avoid multiple dumps.

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c   | 89 +++++++++++--------
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h   |  5 +-
 .../wireless/intel/iwlwifi/fw/error-dump.h    |  3 +
 drivers/net/wireless/intel/iwlwifi/fw/init.c  |  3 +
 .../net/wireless/intel/iwlwifi/iwl-trans.h    | 13 +++
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c   |  6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |  9 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c  |  2 +
 8 files changed, 81 insertions(+), 49 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 0edc5bcdfb82..f8cf12804aee 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -1365,44 +1365,6 @@ const struct iwl_fw_dump_desc iwl_dump_desc_assert = {
 };
 IWL_EXPORT_SYMBOL(iwl_dump_desc_assert);
 
-void iwl_fw_assert_error_dump(struct iwl_fw_runtime *fwrt)
-{
-	IWL_INFO(fwrt, "error dump due to fw assert\n");
-	fwrt->dump.desc = &iwl_dump_desc_assert;
-	iwl_fw_error_dump(fwrt);
-}
-IWL_EXPORT_SYMBOL(iwl_fw_assert_error_dump);
-
-void iwl_fw_alive_timeout_dump(struct iwl_fw_runtime *fwrt)
-{
-	struct iwl_fw_dump_desc *iwl_dump_desc_alive_timeout;
-
-	if (test_and_set_bit(IWL_FWRT_STATUS_DUMPING, &fwrt->status))
-		return;
-
-	iwl_dump_desc_alive_timeout =
-		kmalloc(sizeof(*iwl_dump_desc_alive_timeout), GFP_KERNEL);
-	if (!iwl_dump_desc_alive_timeout)
-		return;
-
-	iwl_dump_desc_alive_timeout->trig_desc.type =
-		cpu_to_le32(FW_DBG_TRIGGER_ALIVE_TIMEOUT);
-	iwl_dump_desc_alive_timeout->len = 0;
-
-	if (WARN_ON(fwrt->dump.desc))
-		iwl_fw_free_dump_desc(fwrt);
-
-	IWL_WARN(fwrt, "Collecting data: trigger %d fired.\n",
-		 FW_DBG_TRIGGER_ALIVE_TIMEOUT);
-
-	/* set STATUS_FW_ERROR to collect all memory regions. */
-	set_bit(STATUS_FW_ERROR, &fwrt->trans->status);
-
-	fwrt->dump.desc = iwl_dump_desc_alive_timeout;
-	iwl_fw_error_dump(fwrt);
-}
-IWL_EXPORT_SYMBOL(iwl_fw_alive_timeout_dump);
-
 int iwl_fw_dbg_collect_desc(struct iwl_fw_runtime *fwrt,
 			    const struct iwl_fw_dump_desc *desc,
 			    bool monitor_only,
@@ -1442,6 +1404,33 @@ int iwl_fw_dbg_collect_desc(struct iwl_fw_runtime *fwrt,
 }
 IWL_EXPORT_SYMBOL(iwl_fw_dbg_collect_desc);
 
+int iwl_fw_dbg_error_collect(struct iwl_fw_runtime *fwrt,
+			     enum iwl_fw_dbg_trigger trig_type)
+{
+	int ret;
+	struct iwl_fw_dump_desc *iwl_dump_error_desc =
+		kmalloc(sizeof(*iwl_dump_error_desc), GFP_KERNEL);
+
+	if (!iwl_dump_error_desc)
+		return -ENOMEM;
+
+	iwl_dump_error_desc->trig_desc.type = cpu_to_le32(trig_type);
+	iwl_dump_error_desc->len = 0;
+
+	ret = iwl_fw_dbg_collect_desc(fwrt, iwl_dump_error_desc, false, 0);
+	if (ret) {
+		kfree(iwl_dump_error_desc);
+	} else {
+		set_bit(STATUS_FW_WAIT_DUMP, &fwrt->trans->status);
+
+		/* trigger nmi to halt the fw */
+		iwl_force_nmi(fwrt->trans);
+	}
+
+	return ret;
+}
+IWL_EXPORT_SYMBOL(iwl_fw_dbg_error_collect);
+
 int _iwl_fw_dbg_collect(struct iwl_fw_runtime *fwrt,
 			enum iwl_fw_dbg_trigger trig,
 			const char *str, size_t len,
@@ -1893,3 +1882,27 @@ void iwl_fw_dbg_apply_point(struct iwl_fw_runtime *fwrt,
 	_iwl_fw_dbg_apply_point(fwrt, data, apply_point, true);
 }
 IWL_EXPORT_SYMBOL(iwl_fw_dbg_apply_point);
+
+void iwl_fwrt_stop_device(struct iwl_fw_runtime *fwrt)
+{
+	/* if the wait event timeout elapses instead of wake up then
+	 * the driver did not receive NMI interrupt and can not assume the FW
+	 * is halted
+	 */
+	int ret = wait_event_timeout(fwrt->trans->fw_halt_waitq,
+				     !test_bit(STATUS_FW_WAIT_DUMP,
+					       &fwrt->trans->status),
+				     msecs_to_jiffies(2000));
+	if (!ret) {
+		/* failed to receive NMI interrupt, assuming the FW is stuck */
+		set_bit(STATUS_FW_ERROR, &fwrt->trans->status);
+
+		clear_bit(STATUS_FW_WAIT_DUMP, &fwrt->trans->status);
+	}
+
+	/* Assuming the op mode mutex is held at this point */
+	iwl_fw_dbg_collect_sync(fwrt);
+
+	iwl_trans_stop_device(fwrt->trans);
+}
+IWL_EXPORT_SYMBOL(iwl_fwrt_stop_device);
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
index 36e0f40dab3b..2fa7a19e02b6 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
@@ -112,6 +112,8 @@ void iwl_fw_error_dump(struct iwl_fw_runtime *fwrt);
 int iwl_fw_dbg_collect_desc(struct iwl_fw_runtime *fwrt,
 			    const struct iwl_fw_dump_desc *desc,
 			    bool monitor_only, unsigned int delay);
+int iwl_fw_dbg_error_collect(struct iwl_fw_runtime *fwrt,
+			     enum iwl_fw_dbg_trigger trig_type);
 int _iwl_fw_dbg_collect(struct iwl_fw_runtime *fwrt,
 			enum iwl_fw_dbg_trigger trig,
 			const char *str, size_t len,
@@ -434,10 +436,9 @@ static inline void iwl_fw_resume_timestamp(struct iwl_fw_runtime *fwrt) {}
 
 #endif /* CONFIG_IWLWIFI_DEBUGFS */
 
-void iwl_fw_assert_error_dump(struct iwl_fw_runtime *fwrt);
-void iwl_fw_alive_timeout_dump(struct iwl_fw_runtime *fwrt);
 void iwl_fw_dbg_collect_sync(struct iwl_fw_runtime *fwrt);
 void iwl_fw_dbg_apply_point(struct iwl_fw_runtime *fwrt,
 			    enum iwl_fw_ini_apply_point apply_point);
 
+void iwl_fwrt_stop_device(struct iwl_fw_runtime *fwrt);
 #endif  /* __iwl_fw_dbg_h__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h b/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h
index d06707f3a2a4..e1c6aa61ab90 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h
@@ -356,6 +356,8 @@ iwl_fw_error_next_data(struct iwl_fw_error_dump_data *data)
  * @FW_DBG_TRIGGER_TX_STATUS: trigger log collection upon tx status when
  *  the firmware sends a tx reply.
  * @FW_DBG_TRIGGER_ALIVE_TIMEOUT: trigger log collection if alive flow timeouts
+ * @FW_DBG_TRIGGER_DRIVER: trigger log collection upon a flow failure
+ *	in the driver.
  */
 enum iwl_fw_dbg_trigger {
 	FW_DBG_TRIGGER_INVALID = 0,
@@ -374,6 +376,7 @@ enum iwl_fw_dbg_trigger {
 	FW_DBG_TRIGGER_TDLS,
 	FW_DBG_TRIGGER_TX_STATUS,
 	FW_DBG_TRIGGER_ALIVE_TIMEOUT,
+	FW_DBG_TRIGGER_DRIVER,
 
 	/* must be last */
 	FW_DBG_TRIGGER_MAX,
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/init.c b/drivers/net/wireless/intel/iwlwifi/fw/init.c
index 2efac307909e..7adf4e4e841a 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/init.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/init.c
@@ -6,6 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2017 Intel Deutschland GmbH
+ * Copyright(c) 2019 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -26,6 +27,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2017 Intel Deutschland GmbH
+ * Copyright(c) 2019 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -74,6 +76,7 @@ void iwl_fw_runtime_init(struct iwl_fw_runtime *fwrt, struct iwl_trans *trans,
 	fwrt->ops_ctx = ops_ctx;
 	INIT_DELAYED_WORK(&fwrt->dump.wk, iwl_fw_error_dump_wk);
 	iwl_fwrt_dbgfs_register(fwrt, dbgfs_dir);
+	init_waitqueue_head(&fwrt->trans->fw_halt_waitq);
 }
 IWL_EXPORT_SYMBOL(iwl_fw_runtime_init);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index a7009cd4232d..d79025d663df 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -8,6 +8,7 @@
  * Copyright(c) 2007 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
+ * Copyright(c) 2018 - 2019 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,6 +31,7 @@
  * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
+ * Copyright(c) 2018 - 2019 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -330,6 +332,7 @@ enum iwl_d3_status {
  *	are sent
  * @STATUS_TRANS_IDLE: the trans is idle - general commands are not to be sent
  * @STATUS_TRANS_DEAD: trans is dead - avoid any read/write operation
+ * @STATUS_FW_WAIT_DUMP: if set, wait until cleared before collecting dump
  */
 enum iwl_trans_status {
 	STATUS_SYNC_HCMD_ACTIVE,
@@ -342,6 +345,7 @@ enum iwl_trans_status {
 	STATUS_TRANS_GOING_IDLE,
 	STATUS_TRANS_IDLE,
 	STATUS_TRANS_DEAD,
+	STATUS_FW_WAIT_DUMP,
 };
 
 static inline int
@@ -796,6 +800,11 @@ struct iwl_trans {
 	bool suspending;
 	bool dbg_rec_on;
 
+	u32 lmac_error_event_table[2];
+	u32 umac_error_event_table;
+	unsigned int error_event_table_tlv_status;
+	wait_queue_head_t fw_halt_waitq;
+
 	/* pointer to trans specific struct */
 	/*Ensure that this pointer will always be aligned to sizeof pointer */
 	char trans_specific[0] __aligned(sizeof(void *));
@@ -1202,6 +1211,10 @@ static inline void iwl_trans_fw_error(struct iwl_trans *trans)
 	/* prevent double restarts due to the same erroneous FW */
 	if (!test_and_set_bit(STATUS_FW_ERROR, &trans->status))
 		iwl_op_mode_nic_error(trans->op_mode);
+
+	if (test_and_clear_bit(STATUS_FW_WAIT_DUMP, &trans->status))
+		wake_up(&trans->fw_halt_waitq);
+
 }
 
 /*****************************************************
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 25c8cea1180e..d8ae9561a9b0 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -332,7 +332,8 @@ static int iwl_mvm_load_ucode_wait_alive(struct iwl_mvm *mvm,
 		struct iwl_trans *trans = mvm->trans;
 
 		if (ret == -ETIMEDOUT)
-			iwl_fw_alive_timeout_dump(&mvm->fwrt);
+			iwl_fw_dbg_error_collect(&mvm->fwrt,
+						 FW_DBG_TRIGGER_ALIVE_TIMEOUT);
 
 		if (trans->cfg->device_family >= IWL_DEVICE_FAMILY_22000)
 			IWL_ERR(mvm,
@@ -408,7 +409,6 @@ static int iwl_run_unified_mvm_ucode(struct iwl_mvm *mvm, bool read_nvm)
 	ret = iwl_mvm_load_ucode_wait_alive(mvm, IWL_UCODE_REGULAR);
 	if (ret) {
 		IWL_ERR(mvm, "Failed to start RT ucode: %d\n", ret);
-		iwl_fw_assert_error_dump(&mvm->fwrt);
 		goto error;
 	}
 
@@ -1053,7 +1053,7 @@ int iwl_mvm_up(struct iwl_mvm *mvm)
 	ret = iwl_mvm_load_rt_fw(mvm);
 	if (ret) {
 		IWL_ERR(mvm, "Failed to start RT ucode: %d\n", ret);
-		iwl_fw_assert_error_dump(&mvm->fwrt);
+		iwl_fw_dbg_error_collect(&mvm->fwrt, FW_DBG_TRIGGER_DRIVER);
 		goto error;
 	}
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index f7176020139d..ee61f4a00c5e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -2013,15 +2013,12 @@ static inline void iwl_mvm_stop_device(struct iwl_mvm *mvm)
 			       &mvm->status))
 		iwl_fw_dbg_collect_desc(&mvm->fwrt, &iwl_dump_desc_assert,
 					false, 0);
-	/* calling this function without using dump_start/end since at this
-	 * point we already hold the op mode mutex
-	 */
-	iwl_fw_dbg_collect_sync(&mvm->fwrt);
+
 	iwl_fw_cancel_timestamp(&mvm->fwrt);
-	iwl_free_fw_paging(&mvm->fwrt);
 	clear_bit(IWL_MVM_STATUS_FIRMWARE_RUNNING, &mvm->status);
+	iwl_fwrt_stop_device(&mvm->fwrt);
+	iwl_free_fw_paging(&mvm->fwrt);
 	iwl_fw_dump_conf_clear(&mvm->fwrt);
-	iwl_trans_stop_device(mvm->trans);
 }
 
 /* Re-configure the SCD for a queue that has already been configured */
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index de288962773e..ad816007e546 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -817,6 +817,8 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	mutex_lock(&mvm->mutex);
 	iwl_mvm_ref(mvm, IWL_MVM_REF_INIT_UCODE);
 	err = iwl_run_init_mvm_ucode(mvm, true);
+	if (err)
+		iwl_fw_dbg_error_collect(&mvm->fwrt, FW_DBG_TRIGGER_DRIVER);
 	if (!iwlmvm_mod_params.init_dbg || !err)
 		iwl_mvm_stop_device(mvm);
 	iwl_mvm_unref(mvm, IWL_MVM_REF_INIT_UCODE);
-- 
2.20.1

