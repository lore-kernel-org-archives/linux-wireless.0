Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0351C43143
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 12:11:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 929A22084C
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 12:11:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 929A22084C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729361AbeJASsq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 14:48:46 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:54458 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729111AbeJASsq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 14:48:46 -0400
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1g6x1y-0006wq-Pn; Mon, 01 Oct 2018 15:10:31 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Mon,  1 Oct 2018 15:10:09 +0300
Message-Id: <20181001121010.29684-16-luca@coelho.fi>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <20181001121010.29684-1-luca@coelho.fi>
References: <20181001121010.29684-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 15/16] iwlwifi: dbg: decrement occurrences for all triggers
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

iwl_fw_dbg_collect can be called by any function that already
has the error string ready. iwl_fw_dbg_collect_trig, on the
other hand, does string formatting. The occurrences decrement
is at iwl_fw_dbg_collect_trig, instead of iwl_fw_dbg_collect,
which causes it to sometimes be skipped. Move it to the right
location.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c | 16 ++++++++++------
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h |  2 +-
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index a049367ac08a..1ae04577aed3 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -1044,10 +1044,13 @@ IWL_EXPORT_SYMBOL(iwl_fw_dbg_collect_desc);
 int iwl_fw_dbg_collect(struct iwl_fw_runtime *fwrt,
 		       enum iwl_fw_dbg_trigger trig,
 		       const char *str, size_t len,
-		       const struct iwl_fw_dbg_trigger_tlv *trigger)
+		       struct iwl_fw_dbg_trigger_tlv *trigger)
 {
 	struct iwl_fw_dump_desc *desc;
 
+	if (trigger && !le16_to_cpu(trigger->occurrences))
+		return 0;
+
 	if (trigger && trigger->flags & IWL_FW_DBG_FORCE_RESTART) {
 		IWL_WARN(fwrt, "Force restart: trigger %d fired.\n", trig);
 		iwl_force_nmi(fwrt->trans);
@@ -1058,6 +1061,12 @@ int iwl_fw_dbg_collect(struct iwl_fw_runtime *fwrt,
 	if (!desc)
 		return -ENOMEM;
 
+	if (trigger) {
+		u16 occurrences = le16_to_cpu(trigger->occurrences) - 1;
+
+		trigger->occurrences = cpu_to_le16(occurrences);
+	}
+
 	desc->len = len;
 	desc->trig_desc.type = cpu_to_le32(trig);
 	memcpy(desc->trig_desc.data, str, len);
@@ -1070,13 +1079,9 @@ int iwl_fw_dbg_collect_trig(struct iwl_fw_runtime *fwrt,
 			    struct iwl_fw_dbg_trigger_tlv *trigger,
 			    const char *fmt, ...)
 {
-	u16 occurrences = le16_to_cpu(trigger->occurrences);
 	int ret, len = 0;
 	char buf[64];
 
-	if (!occurrences)
-		return 0;
-
 	if (fmt) {
 		va_list ap;
 
@@ -1099,7 +1104,6 @@ int iwl_fw_dbg_collect_trig(struct iwl_fw_runtime *fwrt,
 	if (ret)
 		return ret;
 
-	trigger->occurrences = cpu_to_le16(occurrences - 1);
 	return 0;
 }
 IWL_EXPORT_SYMBOL(iwl_fw_dbg_collect_trig);
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
index bee7a938a721..701bac1aba4d 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
@@ -111,7 +111,7 @@ int iwl_fw_dbg_collect_desc(struct iwl_fw_runtime *fwrt,
 int iwl_fw_dbg_collect(struct iwl_fw_runtime *fwrt,
 		       enum iwl_fw_dbg_trigger trig,
 		       const char *str, size_t len,
-		       const struct iwl_fw_dbg_trigger_tlv *trigger);
+		       struct iwl_fw_dbg_trigger_tlv *trigger);
 int iwl_fw_dbg_collect_trig(struct iwl_fw_runtime *fwrt,
 			    struct iwl_fw_dbg_trigger_tlv *trigger,
 			    const char *fmt, ...) __printf(3, 4);
-- 
2.19.0

