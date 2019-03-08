Return-Path: <SRS0=wltO=RL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79B3AC10F0C
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Mar 2019 10:09:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5631D20854
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Mar 2019 10:09:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbfCHKJG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Mar 2019 05:09:06 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:41424 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725975AbfCHKJF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Mar 2019 05:09:05 -0500
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1h2CR4-0006tZ-T4; Fri, 08 Mar 2019 12:09:03 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri,  8 Mar 2019 12:08:46 +0200
Message-Id: <20190308100848.13188-6-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190308100848.13188-1-luca@coelho.fi>
References: <20190308100848.13188-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 5/7] iwlwifi: use sync nmi in case of init flow failure
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

In case of alive interrupt timeout or any failure in the init flow
the driver generates FW nmi. The driver assumes that the nmi will
generate SW interrupt. This assumption does not hold and leads to faulty
behavior in the recovery flow.

Solve this by using sync nmi, this way, even if the driver does not
receive SW interrupt, it still starts the recovery flow.

Also remove the wait queue from iwl_fwrt_stop_device since the driver is
handling the SW interrupt synchronously.

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c   | 26 +++----------------
 drivers/net/wireless/intel/iwlwifi/fw/init.c  |  1 -
 .../net/wireless/intel/iwlwifi/iwl-trans.h    |  7 -----
 3 files changed, 3 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index b99d38b37014..d7380016f1c0 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -1944,14 +1944,10 @@ int iwl_fw_dbg_error_collect(struct iwl_fw_runtime *fwrt,
 	iwl_dump_error_desc->len = 0;
 
 	ret = iwl_fw_dbg_collect_desc(fwrt, iwl_dump_error_desc, false, 0);
-	if (ret) {
+	if (ret)
 		kfree(iwl_dump_error_desc);
-	} else {
-		set_bit(STATUS_FW_WAIT_DUMP, &fwrt->trans->status);
-
-		/* trigger nmi to halt the fw */
-		iwl_force_nmi(fwrt->trans);
-	}
+	else
+		iwl_trans_sync_nmi(fwrt->trans);
 
 	return ret;
 }
@@ -2491,22 +2487,6 @@ IWL_EXPORT_SYMBOL(iwl_fw_dbg_apply_point);
 
 void iwl_fwrt_stop_device(struct iwl_fw_runtime *fwrt)
 {
-	/* if the wait event timeout elapses instead of wake up then
-	 * the driver did not receive NMI interrupt and can not assume the FW
-	 * is halted
-	 */
-	int ret = wait_event_timeout(fwrt->trans->fw_halt_waitq,
-				     !test_bit(STATUS_FW_WAIT_DUMP,
-					       &fwrt->trans->status),
-				     msecs_to_jiffies(2000));
-	if (!ret) {
-		/* failed to receive NMI interrupt, assuming the FW is stuck */
-		set_bit(STATUS_FW_ERROR, &fwrt->trans->status);
-
-		clear_bit(STATUS_FW_WAIT_DUMP, &fwrt->trans->status);
-	}
-
-	/* Assuming the op mode mutex is held at this point */
 	iwl_fw_dbg_collect_sync(fwrt);
 
 	iwl_trans_stop_device(fwrt->trans);
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/init.c b/drivers/net/wireless/intel/iwlwifi/fw/init.c
index 7adf4e4e841a..12310e3d2fc5 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/init.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/init.c
@@ -76,7 +76,6 @@ void iwl_fw_runtime_init(struct iwl_fw_runtime *fwrt, struct iwl_trans *trans,
 	fwrt->ops_ctx = ops_ctx;
 	INIT_DELAYED_WORK(&fwrt->dump.wk, iwl_fw_error_dump_wk);
 	iwl_fwrt_dbgfs_register(fwrt, dbgfs_dir);
-	init_waitqueue_head(&fwrt->trans->fw_halt_waitq);
 }
 IWL_EXPORT_SYMBOL(iwl_fw_runtime_init);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index fa750711d889..d8690acee40c 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -338,7 +338,6 @@ enum iwl_d3_status {
  *	are sent
  * @STATUS_TRANS_IDLE: the trans is idle - general commands are not to be sent
  * @STATUS_TRANS_DEAD: trans is dead - avoid any read/write operation
- * @STATUS_FW_WAIT_DUMP: if set, wait until cleared before collecting dump
  */
 enum iwl_trans_status {
 	STATUS_SYNC_HCMD_ACTIVE,
@@ -351,7 +350,6 @@ enum iwl_trans_status {
 	STATUS_TRANS_GOING_IDLE,
 	STATUS_TRANS_IDLE,
 	STATUS_TRANS_DEAD,
-	STATUS_FW_WAIT_DUMP,
 };
 
 static inline int
@@ -832,7 +830,6 @@ struct iwl_trans {
 	u32 lmac_error_event_table[2];
 	u32 umac_error_event_table;
 	unsigned int error_event_table_tlv_status;
-	wait_queue_head_t fw_halt_waitq;
 
 	/* pointer to trans specific struct */
 	/*Ensure that this pointer will always be aligned to sizeof pointer */
@@ -1240,10 +1237,6 @@ static inline void iwl_trans_fw_error(struct iwl_trans *trans)
 	/* prevent double restarts due to the same erroneous FW */
 	if (!test_and_set_bit(STATUS_FW_ERROR, &trans->status))
 		iwl_op_mode_nic_error(trans->op_mode);
-
-	if (test_and_clear_bit(STATUS_FW_WAIT_DUMP, &trans->status))
-		wake_up(&trans->fw_halt_waitq);
-
 }
 
 static inline void iwl_trans_sync_nmi(struct iwl_trans *trans)
-- 
2.20.1

