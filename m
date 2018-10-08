Return-Path: <SRS0=RoeA=MU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC976C65BD1
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 08:17:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 910622087C
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 08:17:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 910622087C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727029AbeJHP2S (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Oct 2018 11:28:18 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:56330 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726793AbeJHP2S (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Oct 2018 11:28:18 -0400
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1g9QjZ-0003w6-8w; Mon, 08 Oct 2018 11:17:46 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Mon,  8 Oct 2018 11:17:23 +0300
Message-Id: <20181008081735.3401-7-luca@coelho.fi>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <20181008081735.3401-1-luca@coelho.fi>
References: <20181008081735.3401-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 06/18] iwlwifi: dump debug data before stop device
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

Debug data dump is not working in flows that stop the device is used
in their error handling. During these flows the op mode mutex is
locked until the device stops.  Because of that, any assert generated
from the firmware can be handled only after the device already
stopped.

Since dumping cannot occour after stopping the device, split the the
dump function to two parts, Part that handles locking, and the part
that starts the actual dumping and call the second part in the op mode
stop device function.

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c  | 27 +++++++++++++++-----
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h  |  1 +
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h |  5 ++++
 3 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index f44c716b1130..c16757051f16 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -1154,14 +1154,14 @@ int iwl_fw_start_dbg_conf(struct iwl_fw_runtime *fwrt, u8 conf_id)
 }
 IWL_EXPORT_SYMBOL(iwl_fw_start_dbg_conf);
 
-void iwl_fw_error_dump_wk(struct work_struct *work)
+/* this function assumes dump_start was called beforehand and dump_end will be
+ * called afterwards
+ */
+void iwl_fw_dbg_collect_sync(struct iwl_fw_runtime *fwrt)
 {
-	struct iwl_fw_runtime *fwrt =
-		container_of(work, struct iwl_fw_runtime, dump.wk.work);
 	struct iwl_fw_dbg_params params = {0};
 
-	if (fwrt->ops && fwrt->ops->dump_start &&
-	    fwrt->ops->dump_start(fwrt->ops_ctx))
+	if (!test_bit(IWL_FWRT_STATUS_DUMPING, &fwrt->status))
 		return;
 
 	if (fwrt->ops && fwrt->ops->fw_running &&
@@ -1169,7 +1169,7 @@ void iwl_fw_error_dump_wk(struct work_struct *work)
 		IWL_ERR(fwrt, "Firmware not running - cannot dump error\n");
 		iwl_fw_free_dump_desc(fwrt);
 		clear_bit(IWL_FWRT_STATUS_DUMPING, &fwrt->status);
-		goto out;
+		return;
 	}
 
 	iwl_fw_dbg_stop_recording(fwrt, &params);
@@ -1183,7 +1183,20 @@ void iwl_fw_error_dump_wk(struct work_struct *work)
 		udelay(500);
 		iwl_fw_dbg_restart_recording(fwrt, &params);
 	}
-out:
+}
+IWL_EXPORT_SYMBOL(iwl_fw_dbg_collect_sync);
+
+void iwl_fw_error_dump_wk(struct work_struct *work)
+{
+	struct iwl_fw_runtime *fwrt =
+		container_of(work, struct iwl_fw_runtime, dump.wk.work);
+
+	if (fwrt->ops && fwrt->ops->dump_start &&
+	    fwrt->ops->dump_start(fwrt->ops_ctx))
+		return;
+
+	iwl_fw_dbg_collect_sync(fwrt);
+
 	if (fwrt->ops && fwrt->ops->dump_end)
 		fwrt->ops->dump_end(fwrt->ops_ctx);
 }
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
index d9578dcec24c..6f8d3256f7b0 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
@@ -367,4 +367,5 @@ static inline void iwl_fw_resume_timestamp(struct iwl_fw_runtime *fwrt) {}
 #endif /* CONFIG_IWLWIFI_DEBUGFS */
 
 void iwl_fw_alive_error_dump(struct iwl_fw_runtime *fwrt);
+void iwl_fw_dbg_collect_sync(struct iwl_fw_runtime *fwrt);
 #endif  /* __iwl_fw_dbg_h__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 6f927052aeaf..ff1ba84f3aa6 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1906,6 +1906,11 @@ static inline u32 iwl_mvm_flushable_queues(struct iwl_mvm *mvm)
 
 static inline void iwl_mvm_stop_device(struct iwl_mvm *mvm)
 {
+	lockdep_assert_held(&mvm->mutex);
+	/* calling this function without using dump_start/end since at this
+	 * point we already hold the op mode mutex
+	 */
+	iwl_fw_dbg_collect_sync(&mvm->fwrt);
 	iwl_fw_cancel_timestamp(&mvm->fwrt);
 	iwl_free_fw_paging(&mvm->fwrt);
 	clear_bit(IWL_MVM_STATUS_FIRMWARE_RUNNING, &mvm->status);
-- 
2.19.0

