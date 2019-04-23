Return-Path: <SRS0=odSX=SZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69957C10F14
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Apr 2019 09:11:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 43BA2206BA
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Apr 2019 09:11:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727013AbfDWJLk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Apr 2019 05:11:40 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:59034 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726130AbfDWJLk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Apr 2019 05:11:40 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <luca@coelho.fi>)
        id 1hIrS4-0000FN-Hs; Tue, 23 Apr 2019 12:10:56 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: [PATCH 13/16] iwlwifi: dbg_ini: add periodic trigger support
Date:   Tue, 23 Apr 2019 12:10:40 +0300
Message-Id: <20190423091043.7156-14-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190423091043.7156-1-luca@coelho.fi>
References: <20190423091043.7156-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

Allows to configure a periodic data collection

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c   | 40 +++++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h   |  3 ++
 drivers/net/wireless/intel/iwlwifi/fw/init.c  |  2 +
 .../net/wireless/intel/iwlwifi/fw/runtime.h   |  1 +
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c  |  1 +
 5 files changed, 47 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 035eeeabfc8c..d8c4fdb8d4a1 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -2616,6 +2616,20 @@ static void iwl_fw_dbg_update_triggers(struct iwl_fw_runtime *fwrt,
 			active->trig->occurrences = cpu_to_le32(-1);
 
 		active->active = true;
+
+		if (id == IWL_FW_TRIGGER_ID_PERIODIC_TRIGGER) {
+			u32 collect_interval = le32_to_cpu(trig->trigger_data);
+
+			/* the minimum allowed interval is 50ms */
+			if (collect_interval < 50) {
+				collect_interval = 50;
+				trig->trigger_data =
+					cpu_to_le32(collect_interval);
+			}
+
+			mod_timer(&fwrt->dump.periodic_trig,
+				  jiffies + msecs_to_jiffies(collect_interval));
+		}
 next:
 		iter += sizeof(*trig) + trig_regs_size;
 
@@ -2696,8 +2710,34 @@ IWL_EXPORT_SYMBOL(iwl_fw_dbg_apply_point);
 
 void iwl_fwrt_stop_device(struct iwl_fw_runtime *fwrt)
 {
+	del_timer(&fwrt->dump.periodic_trig);
 	iwl_fw_dbg_collect_sync(fwrt);
 
 	iwl_trans_stop_device(fwrt->trans);
 }
 IWL_EXPORT_SYMBOL(iwl_fwrt_stop_device);
+
+void iwl_fw_dbg_periodic_trig_handler(struct timer_list *t)
+{
+	struct iwl_fw_runtime *fwrt;
+	enum iwl_fw_ini_trigger_id id = IWL_FW_TRIGGER_ID_PERIODIC_TRIGGER;
+	int ret;
+	typeof(fwrt->dump) *dump_ptr = container_of(t, typeof(fwrt->dump),
+						    periodic_trig);
+
+	fwrt = container_of(dump_ptr, typeof(*fwrt), dump);
+
+	ret = _iwl_fw_dbg_ini_collect(fwrt, id);
+	if (!ret || ret == -EBUSY) {
+		struct iwl_fw_ini_trigger *trig =
+			fwrt->dump.active_trigs[id].trig;
+		u32 occur = le32_to_cpu(trig->occurrences);
+		u32 collect_interval = le32_to_cpu(trig->trigger_data);
+
+		if (!occur)
+			return;
+
+		mod_timer(&fwrt->dump.periodic_trig,
+			  jiffies + msecs_to_jiffies(collect_interval));
+	}
+}
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
index cccf91db74c4..2a9e560a906b 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
@@ -385,11 +385,13 @@ void iwl_fw_dbg_read_d3_debug_data(struct iwl_fw_runtime *fwrt);
 
 static inline void iwl_fw_flush_dump(struct iwl_fw_runtime *fwrt)
 {
+	del_timer(&fwrt->dump.periodic_trig);
 	flush_delayed_work(&fwrt->dump.wk);
 }
 
 static inline void iwl_fw_cancel_dump(struct iwl_fw_runtime *fwrt)
 {
+	del_timer(&fwrt->dump.periodic_trig);
 	cancel_delayed_work_sync(&fwrt->dump.wk);
 }
 
@@ -468,4 +470,5 @@ static inline void iwl_fw_error_collect(struct iwl_fw_runtime *fwrt)
 	}
 }
 
+void iwl_fw_dbg_periodic_trig_handler(struct timer_list *t);
 #endif  /* __iwl_fw_dbg_h__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/init.c b/drivers/net/wireless/intel/iwlwifi/fw/init.c
index 12310e3d2fc5..4435c0ce3013 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/init.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/init.c
@@ -76,6 +76,8 @@ void iwl_fw_runtime_init(struct iwl_fw_runtime *fwrt, struct iwl_trans *trans,
 	fwrt->ops_ctx = ops_ctx;
 	INIT_DELAYED_WORK(&fwrt->dump.wk, iwl_fw_error_dump_wk);
 	iwl_fwrt_dbgfs_register(fwrt, dbgfs_dir);
+	timer_setup(&fwrt->dump.periodic_trig,
+		    iwl_fw_dbg_periodic_trig_handler, 0);
 }
 IWL_EXPORT_SYMBOL(iwl_fw_runtime_init);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/runtime.h b/drivers/net/wireless/intel/iwlwifi/fw/runtime.h
index 88a558e082a3..a6402a0b3854 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/runtime.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/runtime.h
@@ -146,6 +146,7 @@ struct iwl_fw_runtime {
 		u32 umac_err_id;
 		void *fifo_iter;
 		enum iwl_fw_ini_trigger_id ini_trig_id;
+		struct timer_list periodic_trig;
 	} dump;
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 	struct {
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 55d399899d1c..602ff50268f2 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -1261,6 +1261,7 @@ static void iwl_mvm_reprobe_wk(struct work_struct *wk)
 void iwl_mvm_nic_restart(struct iwl_mvm *mvm, bool fw_error)
 {
 	iwl_abort_notification_waits(&mvm->notif_wait);
+	del_timer(&mvm->fwrt.dump.periodic_trig);
 
 	/*
 	 * This is a bit racy, but worst case we tell mac80211 about
-- 
2.20.1

