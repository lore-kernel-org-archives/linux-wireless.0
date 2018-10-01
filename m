Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E2A2C43143
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 12:11:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E22F2084C
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 12:11:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2E22F2084C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729350AbeJASsf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 14:48:35 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:54434 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729111AbeJASse (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 14:48:34 -0400
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1g6x1z-0006wq-HB; Mon, 01 Oct 2018 15:10:31 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Mon,  1 Oct 2018 15:10:10 +0300
Message-Id: <20181001121010.29684-17-luca@coelho.fi>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <20181001121010.29684-1-luca@coelho.fi>
References: <20181001121010.29684-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 16/16] iwlwifi: dbg: make trigger functions type agnostic
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

As preparation for new trigger type, make iwl_fw_dbg_collect_desc
agnostic to the trigger structure.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c  | 37 ++++++++++----------
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h  |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c |  2 +-
 3 files changed, 20 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 1ae04577aed3..f44c716b1130 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -998,14 +998,9 @@ void iwl_fw_alive_error_dump(struct iwl_fw_runtime *fwrt)
 IWL_EXPORT_SYMBOL(iwl_fw_alive_error_dump);
 
 int iwl_fw_dbg_collect_desc(struct iwl_fw_runtime *fwrt,
-			    const struct iwl_fw_dump_desc *desc,
-			    const struct iwl_fw_dbg_trigger_tlv *trigger)
+			    const struct iwl_fw_dump_desc *desc, void *trigger,
+			    unsigned int delay)
 {
-	unsigned int delay = 0;
-
-	if (trigger)
-		delay = msecs_to_jiffies(le32_to_cpu(trigger->stop_delay));
-
 	/*
 	 * If the loading of the FW completed successfully, the next step is to
 	 * get the SMEM config data. Thus, if fwrt->smem_cfg.num_lmacs is non
@@ -1047,31 +1042,35 @@ int iwl_fw_dbg_collect(struct iwl_fw_runtime *fwrt,
 		       struct iwl_fw_dbg_trigger_tlv *trigger)
 {
 	struct iwl_fw_dump_desc *desc;
+	unsigned int delay = 0;
 
-	if (trigger && !le16_to_cpu(trigger->occurrences))
-		return 0;
+	if (trigger) {
+		u16 occurrences = le16_to_cpu(trigger->occurrences) - 1;
 
-	if (trigger && trigger->flags & IWL_FW_DBG_FORCE_RESTART) {
-		IWL_WARN(fwrt, "Force restart: trigger %d fired.\n", trig);
-		iwl_force_nmi(fwrt->trans);
-		return 0;
+		if (!le16_to_cpu(trigger->occurrences))
+			return 0;
+
+		if (trigger->flags & IWL_FW_DBG_FORCE_RESTART) {
+			IWL_WARN(fwrt, "Force restart: trigger %d fired.\n",
+				 trig);
+			iwl_force_nmi(fwrt->trans);
+			return 0;
+		}
+
+		trigger->occurrences = cpu_to_le16(occurrences);
+		delay = le16_to_cpu(trigger->trig_dis_ms);
 	}
 
 	desc = kzalloc(sizeof(*desc) + len, GFP_ATOMIC);
 	if (!desc)
 		return -ENOMEM;
 
-	if (trigger) {
-		u16 occurrences = le16_to_cpu(trigger->occurrences) - 1;
-
-		trigger->occurrences = cpu_to_le16(occurrences);
-	}
 
 	desc->len = len;
 	desc->trig_desc.type = cpu_to_le32(trig);
 	memcpy(desc->trig_desc.data, str, len);
 
-	return iwl_fw_dbg_collect_desc(fwrt, desc, trigger);
+	return iwl_fw_dbg_collect_desc(fwrt, desc, trigger, delay);
 }
 IWL_EXPORT_SYMBOL(iwl_fw_dbg_collect);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
index 701bac1aba4d..d9578dcec24c 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
@@ -107,7 +107,7 @@ static inline void iwl_fw_free_dump_desc(struct iwl_fw_runtime *fwrt)
 void iwl_fw_error_dump(struct iwl_fw_runtime *fwrt);
 int iwl_fw_dbg_collect_desc(struct iwl_fw_runtime *fwrt,
 			    const struct iwl_fw_dump_desc *desc,
-			    const struct iwl_fw_dbg_trigger_tlv *trigger);
+			    void *trigger, unsigned int delay);
 int iwl_fw_dbg_collect(struct iwl_fw_runtime *fwrt,
 		       enum iwl_fw_dbg_trigger trig,
 		       const char *str, size_t len,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 3acf512bad47..0e2092526fae 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -1240,7 +1240,7 @@ void iwl_mvm_nic_restart(struct iwl_mvm *mvm, bool fw_error)
 	 */
 	if (!mvm->fw_restart && fw_error) {
 		iwl_fw_dbg_collect_desc(&mvm->fwrt, &iwl_dump_desc_assert,
-					NULL);
+					NULL, 0);
 	} else if (test_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status)) {
 		struct iwl_mvm_reprobe *reprobe;
 
-- 
2.19.0

