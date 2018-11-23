Return-Path: <SRS0=iPli=OC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BBB1C43441
	for <linux-wireless@archiver.kernel.org>; Fri, 23 Nov 2018 11:26:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5230F206B2
	for <linux-wireless@archiver.kernel.org>; Fri, 23 Nov 2018 11:26:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5230F206B2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394379AbeKWWKd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 23 Nov 2018 17:10:33 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:38250 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2394366AbeKWWKd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Nov 2018 17:10:33 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gQ9bb-0008GU-0v; Fri, 23 Nov 2018 13:26:39 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 23 Nov 2018 13:26:19 +0200
Message-Id: <20181123112631.29360-4-luca@coelho.fi>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181123112631.29360-1-luca@coelho.fi>
References: <20181123112631.29360-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 03/15] iwlwifi: add support for triggering ini triggers
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

Add support for ini triggers.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c   | 59 +++++++++++++++++--
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h   | 39 +++++++++++-
 .../net/wireless/intel/iwlwifi/fw/runtime.h   |  2 +-
 .../net/wireless/intel/iwlwifi/mvm/debugfs.c  |  2 +-
 4 files changed, 91 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 58771e253396..b17298ba7dc0 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -1329,10 +1329,10 @@ int iwl_fw_dbg_collect_desc(struct iwl_fw_runtime *fwrt,
 }
 IWL_EXPORT_SYMBOL(iwl_fw_dbg_collect_desc);
 
-int iwl_fw_dbg_collect(struct iwl_fw_runtime *fwrt,
-		       enum iwl_fw_dbg_trigger trig,
-		       const char *str, size_t len,
-		       struct iwl_fw_dbg_trigger_tlv *trigger)
+int _iwl_fw_dbg_collect(struct iwl_fw_runtime *fwrt,
+			enum iwl_fw_dbg_trigger trig,
+			const char *str, size_t len,
+			struct iwl_fw_dbg_trigger_tlv *trigger)
 {
 	struct iwl_fw_dump_desc *desc;
 	unsigned int delay = 0;
@@ -1367,6 +1367,47 @@ int iwl_fw_dbg_collect(struct iwl_fw_runtime *fwrt,
 
 	return iwl_fw_dbg_collect_desc(fwrt, desc, monitor_only, delay);
 }
+IWL_EXPORT_SYMBOL(_iwl_fw_dbg_collect);
+
+int iwl_fw_dbg_collect(struct iwl_fw_runtime *fwrt,
+		       u32 id, const char *str, size_t len)
+{
+	struct iwl_fw_dump_desc *desc;
+	u32 occur, delay;
+
+	if (!fwrt->trans->ini_valid)
+		return _iwl_fw_dbg_collect(fwrt, id, str, len, NULL);
+
+	if (id == FW_DBG_TRIGGER_USER)
+		id = IWL_FW_TRIGGER_ID_USER_TRIGGER;
+
+	if (WARN_ON(!fwrt->dump.active_trigs[id].active))
+		return -EINVAL;
+
+	delay = le32_to_cpu(fwrt->dump.active_trigs[id].conf->ignore_consec);
+	occur = le32_to_cpu(fwrt->dump.active_trigs[id].conf->occurrences);
+	if (!occur)
+		return 0;
+
+	if (le32_to_cpu(fwrt->dump.active_trigs[id].conf->force_restart)) {
+		IWL_WARN(fwrt, "Force restart: trigger %d fired.\n", id);
+		iwl_force_nmi(fwrt->trans);
+		return 0;
+	}
+
+	desc = kzalloc(sizeof(*desc) + len, GFP_ATOMIC);
+	if (!desc)
+		return -ENOMEM;
+
+	occur--;
+	fwrt->dump.active_trigs[id].conf->occurrences = cpu_to_le32(occur);
+
+	desc->len = len;
+	desc->trig_desc.type = cpu_to_le32(id);
+	memcpy(desc->trig_desc.data, str, len);
+
+	return iwl_fw_dbg_collect_desc(fwrt, desc, true, delay);
+}
 IWL_EXPORT_SYMBOL(iwl_fw_dbg_collect);
 
 int iwl_fw_dbg_collect_trig(struct iwl_fw_runtime *fwrt,
@@ -1395,8 +1436,8 @@ int iwl_fw_dbg_collect_trig(struct iwl_fw_runtime *fwrt,
 		len = strlen(buf) + 1;
 	}
 
-	ret = iwl_fw_dbg_collect(fwrt, le32_to_cpu(trigger->id), buf, len,
-				 trigger);
+	ret = _iwl_fw_dbg_collect(fwrt, le32_to_cpu(trigger->id), buf, len,
+				  trigger);
 
 	if (ret)
 		return ret;
@@ -1668,6 +1709,12 @@ static void iwl_fw_dbg_update_triggers(struct iwl_fw_runtime *fwrt,
 			active->conf = trig;
 		}
 
+		/* Since zero means infinity - just set to -1 */
+		if (!le32_to_cpu(trig->occurrences))
+			trig->occurrences = cpu_to_le32(-1);
+		if (!le32_to_cpu(trig->ignore_consec))
+			trig->ignore_consec = cpu_to_le32(-1);
+
 		iter += sizeof(*trig) +
 			le32_to_cpu(trig->num_regions) * sizeof(__le32);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
index 324ee063224d..c14e4614a2ea 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
@@ -108,10 +108,12 @@ void iwl_fw_error_dump(struct iwl_fw_runtime *fwrt);
 int iwl_fw_dbg_collect_desc(struct iwl_fw_runtime *fwrt,
 			    const struct iwl_fw_dump_desc *desc,
 			    bool monitor_only, unsigned int delay);
+int _iwl_fw_dbg_collect(struct iwl_fw_runtime *fwrt,
+			enum iwl_fw_dbg_trigger trig,
+			const char *str, size_t len,
+			struct iwl_fw_dbg_trigger_tlv *trigger);
 int iwl_fw_dbg_collect(struct iwl_fw_runtime *fwrt,
-		       enum iwl_fw_dbg_trigger trig,
-		       const char *str, size_t len,
-		       struct iwl_fw_dbg_trigger_tlv *trigger);
+		       u32 id, const char *str, size_t len);
 int iwl_fw_dbg_collect_trig(struct iwl_fw_runtime *fwrt,
 			    struct iwl_fw_dbg_trigger_tlv *trigger,
 			    const char *fmt, ...) __printf(3, 4);
@@ -213,6 +215,37 @@ _iwl_fw_dbg_trigger_on(struct iwl_fw_runtime *fwrt,
 	_iwl_fw_dbg_trigger_on((fwrt), (wdev), (id));		\
 })
 
+static inline bool
+_iwl_fw_ini_trigger_on(struct iwl_fw_runtime *fwrt,
+		       const enum iwl_fw_dbg_trigger id)
+{
+	struct iwl_fw_ini_active_triggers *trig = &fwrt->dump.active_trigs[id];
+	u32 ms;
+
+	if (!fwrt->trans->ini_valid)
+		return false;
+
+	if (!trig || !trig->active)
+		return false;
+
+	ms = le32_to_cpu(trig->conf->ignore_consec);
+	if (ms)
+		ms /= USEC_PER_MSEC;
+
+	if (iwl_fw_dbg_no_trig_window(fwrt, id, ms)) {
+		IWL_WARN(fwrt, "Trigger %d fired in no-collect window\n", id);
+		return false;
+	}
+
+	return true;
+}
+
+#define iwl_fw_ini_trigger_on(fwrt, wdev, id) ({		\
+	BUILD_BUG_ON(!__builtin_constant_p(id));		\
+	BUILD_BUG_ON((id) >= IWL_FW_TRIGGER_ID_NUM);		\
+	_iwl_fw_ini_trigger_on((fwrt), (wdev), (id));		\
+})
+
 static inline void
 _iwl_fw_dbg_trigger_simple_stop(struct iwl_fw_runtime *fwrt,
 				struct wireless_dev *wdev,
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/runtime.h b/drivers/net/wireless/intel/iwlwifi/fw/runtime.h
index 886227b7c949..891947cd26ae 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/runtime.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/runtime.h
@@ -138,7 +138,7 @@ struct iwl_fw_runtime {
 		u8 conf;
 
 		/* ts of the beginning of a non-collect fw dbg data period */
-		unsigned long non_collect_ts_start[FW_DBG_TRIGGER_MAX - 1];
+		unsigned long non_collect_ts_start[IWL_FW_TRIGGER_ID_NUM - 1];
 		u32 *d3_debug_data;
 		struct iwl_fw_ini_active_regs active_regs[IWL_FW_INI_MAX_REGION_ID];
 		struct iwl_fw_ini_active_triggers active_trigs[IWL_FW_TRIGGER_ID_NUM];
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
index 3b6b3d8fb961..52c361a6124c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
@@ -1284,7 +1284,7 @@ static ssize_t iwl_dbgfs_fw_dbg_collect_write(struct iwl_mvm *mvm,
 		return 0;
 
 	iwl_fw_dbg_collect(&mvm->fwrt, FW_DBG_TRIGGER_USER, buf,
-			   (count - 1), NULL);
+			   (count - 1));
 
 	iwl_mvm_unref(mvm, IWL_MVM_REF_PRPH_WRITE);
 
-- 
2.19.1

