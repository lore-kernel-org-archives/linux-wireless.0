Return-Path: <SRS0=RoeA=MU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F5C2C64EB8
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 08:17:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 33D7F2087D
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 08:17:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 33D7F2087D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbeJHP2T (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Oct 2018 11:28:19 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:56338 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726995AbeJHP2T (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Oct 2018 11:28:19 -0400
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1g9Qjb-0003w6-6x; Mon, 08 Oct 2018 11:17:47 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Mon,  8 Oct 2018 11:17:24 +0300
Message-Id: <20181008081735.3401-8-luca@coelho.fi>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <20181008081735.3401-1-luca@coelho.fi>
References: <20181008081735.3401-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 07/18] iwlwifi: mvm: move rt status check to the start of the resume flow
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

Move the rt status checking to the start of the resume flow in order
to avoid sending D0I3_END_CMD to the FW.  Also, collect dump if an
assert was encountered.

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c | 60 ++++++++++++---------
 1 file changed, 35 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index fb981270f224..843f3b41b72e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -1638,32 +1638,10 @@ struct iwl_wowlan_status *iwl_mvm_send_wowlan_get_status(struct iwl_mvm *mvm)
 }
 
 static struct iwl_wowlan_status *
-iwl_mvm_get_wakeup_status(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
+iwl_mvm_get_wakeup_status(struct iwl_mvm *mvm)
 {
-	u32 base = mvm->error_event_table[0];
-	struct error_table_start {
-		/* cf. struct iwl_error_event_table */
-		u32 valid;
-		u32 error_id;
-	} err_info;
 	int ret;
 
-	iwl_trans_read_mem_bytes(mvm->trans, base,
-				 &err_info, sizeof(err_info));
-
-	if (err_info.valid) {
-		IWL_INFO(mvm, "error table is valid (%d) with error (%d)\n",
-			 err_info.valid, err_info.error_id);
-		if (err_info.error_id == RF_KILL_INDICATOR_FOR_WOWLAN) {
-			struct cfg80211_wowlan_wakeup wakeup = {
-				.rfkill_release = true,
-			};
-			ieee80211_report_wowlan_wakeup(vif, &wakeup,
-						       GFP_KERNEL);
-		}
-		return ERR_PTR(-EIO);
-	}
-
 	/* only for tracing for now */
 	ret = iwl_mvm_send_cmd_pdu(mvm, OFFLOADS_QUERY_CMD, 0, 0, NULL);
 	if (ret)
@@ -1682,7 +1660,7 @@ static bool iwl_mvm_query_wakeup_reasons(struct iwl_mvm *mvm,
 	bool keep;
 	struct iwl_mvm_sta *mvm_ap_sta;
 
-	fw_status = iwl_mvm_get_wakeup_status(mvm, vif);
+	fw_status = iwl_mvm_get_wakeup_status(mvm);
 	if (IS_ERR_OR_NULL(fw_status))
 		goto out_unlock;
 
@@ -1807,7 +1785,7 @@ static void iwl_mvm_query_netdetect_reasons(struct iwl_mvm *mvm,
 	u32 reasons = 0;
 	int i, j, n_matches, ret;
 
-	fw_status = iwl_mvm_get_wakeup_status(mvm, vif);
+	fw_status = iwl_mvm_get_wakeup_status(mvm);
 	if (!IS_ERR_OR_NULL(fw_status)) {
 		reasons = le32_to_cpu(fw_status->wakeup_reasons);
 		kfree(fw_status);
@@ -1920,6 +1898,29 @@ static void iwl_mvm_d3_disconnect_iter(void *data, u8 *mac,
 		ieee80211_resume_disconnect(vif);
 }
 
+static int iwl_mvm_check_rt_status(struct iwl_mvm *mvm,
+				   struct ieee80211_vif *vif)
+{
+	u32 base = mvm->error_event_table[0];
+	struct error_table_start {
+		/* cf. struct iwl_error_event_table */
+		u32 valid;
+		u32 error_id;
+	} err_info;
+
+	iwl_trans_read_mem_bytes(mvm->trans, base,
+				 &err_info, sizeof(err_info));
+
+	if (err_info.valid &&
+	    err_info.error_id == RF_KILL_INDICATOR_FOR_WOWLAN) {
+		struct cfg80211_wowlan_wakeup wakeup = {
+			.rfkill_release = true,
+		};
+		ieee80211_report_wowlan_wakeup(vif, &wakeup, GFP_KERNEL);
+	}
+	return err_info.valid;
+}
+
 static int __iwl_mvm_resume(struct iwl_mvm *mvm, bool test)
 {
 	struct ieee80211_vif *vif = NULL;
@@ -1951,6 +1952,15 @@ static int __iwl_mvm_resume(struct iwl_mvm *mvm, bool test)
 	/* query SRAM first in case we want event logging */
 	iwl_mvm_read_d3_sram(mvm);
 
+	if (iwl_mvm_check_rt_status(mvm, vif)) {
+		set_bit(STATUS_FW_ERROR, &mvm->trans->status);
+		iwl_mvm_dump_nic_error_log(mvm);
+		iwl_fw_dbg_collect_desc(&mvm->fwrt, &iwl_dump_desc_assert,
+					NULL, 0);
+		ret = 1;
+		goto err;
+	}
+
 	if (d0i3_first) {
 		ret = iwl_mvm_send_cmd_pdu(mvm, D0I3_END_CMD, 0, 0, NULL);
 		if (ret < 0) {
-- 
2.19.0

