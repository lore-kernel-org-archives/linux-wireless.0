Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38903 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754418Ab3HPLJT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Aug 2013 07:09:19 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 15/20] iwlwifi: mvm: refactor resume from WoWLAN code
Date: Fri, 16 Aug 2013 13:07:05 +0200
Message-Id: <1376651230-1060-15-git-send-email-johannes@sipsolutions.net> (sfid-20130816_130922_649049_44E1F756)
In-Reply-To: <1376651230-1060-1-git-send-email-johannes@sipsolutions.net>
References: <1376651161.15299.24.camel@jlt4.sipsolutions.net>
 <1376651230-1060-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

To be able to add more logic to the resume code, refactor it a bit,
moving some status checking/reporting logic into a new function.
The locking becomes a bit odd (one of the new functions now unlocks
the mutex) but this will be required to call new mac80211 APIs in
there later.

Reviewed-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/d3.c | 151 ++++++++++++++++++++--------------
 1 file changed, 88 insertions(+), 63 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/d3.c b/drivers/net/wireless/iwlwifi/mvm/d3.c
index ebf7f94..ec07f0a 100644
--- a/drivers/net/wireless/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/iwlwifi/mvm/d3.c
@@ -1104,73 +1104,16 @@ int iwl_mvm_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 	return __iwl_mvm_suspend(hw, wowlan, false);
 }
 
-static void iwl_mvm_query_wakeup_reasons(struct iwl_mvm *mvm,
-					 struct ieee80211_vif *vif)
+static void iwl_mvm_report_wakeup_reasons(struct iwl_mvm *mvm,
+					  struct ieee80211_vif *vif,
+					  struct iwl_wowlan_status *status)
 {
-	u32 base = mvm->error_event_table;
-	struct error_table_start {
-		/* cf. struct iwl_error_event_table */
-		u32 valid;
-		u32 error_id;
-	} err_info;
+	struct sk_buff *pkt = NULL;
 	struct cfg80211_wowlan_wakeup wakeup = {
 		.pattern_idx = -1,
 	};
 	struct cfg80211_wowlan_wakeup *wakeup_report = &wakeup;
-	struct iwl_host_cmd cmd = {
-		.id = WOWLAN_GET_STATUSES,
-		.flags = CMD_SYNC | CMD_WANT_SKB,
-	};
-	struct iwl_wowlan_status *status;
-	u32 reasons;
-	int ret, len;
-	struct sk_buff *pkt = NULL;
-
-	iwl_trans_read_mem_bytes(mvm->trans, base,
-				 &err_info, sizeof(err_info));
-
-	if (err_info.valid) {
-		IWL_INFO(mvm, "error table is valid (%d)\n",
-			 err_info.valid);
-		if (err_info.error_id == RF_KILL_INDICATOR_FOR_WOWLAN) {
-			wakeup.rfkill_release = true;
-			ieee80211_report_wowlan_wakeup(vif, &wakeup,
-						       GFP_KERNEL);
-		}
-		return;
-	}
-
-	/* only for tracing for now */
-	ret = iwl_mvm_send_cmd_pdu(mvm, OFFLOADS_QUERY_CMD, CMD_SYNC, 0, NULL);
-	if (ret)
-		IWL_ERR(mvm, "failed to query offload statistics (%d)\n", ret);
-
-	ret = iwl_mvm_send_cmd(mvm, &cmd);
-	if (ret) {
-		IWL_ERR(mvm, "failed to query status (%d)\n", ret);
-		return;
-	}
-
-	/* RF-kill already asserted again... */
-	if (!cmd.resp_pkt)
-		return;
-
-	len = le32_to_cpu(cmd.resp_pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK;
-	if (len - sizeof(struct iwl_cmd_header) < sizeof(*status)) {
-		IWL_ERR(mvm, "Invalid WoWLAN status response!\n");
-		goto out;
-	}
-
-	status = (void *)cmd.resp_pkt->data;
-
-	if (len - sizeof(struct iwl_cmd_header) !=
-	    sizeof(*status) +
-	    ALIGN(le32_to_cpu(status->wake_packet_bufsize), 4)) {
-		IWL_ERR(mvm, "Invalid WoWLAN status response!\n");
-		goto out;
-	}
-
-	reasons = le32_to_cpu(status->wakeup_reasons);
+	u32 reasons = le32_to_cpu(status->wakeup_reasons);
 
 	if (reasons == IWL_WOWLAN_WAKEUP_BY_NON_WIRELESS) {
 		wakeup_report = NULL;
@@ -1233,6 +1176,12 @@ static void iwl_mvm_query_wakeup_reasons(struct iwl_mvm *mvm,
 			pktsize -= hdrlen;
 
 			if (ieee80211_has_protected(hdr->frame_control)) {
+				/*
+				 * This is unlocked and using gtk_i(c)vlen,
+				 * but since everything is under RTNL still
+				 * that's not really a problem - changing
+				 * it would be difficult.
+				 */
 				if (is_multicast_ether_addr(hdr->addr1)) {
 					ivlen = mvm->gtk_ivlen;
 					icvlen += mvm->gtk_icvlen;
@@ -1283,9 +1232,82 @@ static void iwl_mvm_query_wakeup_reasons(struct iwl_mvm *mvm,
  report:
 	ieee80211_report_wowlan_wakeup(vif, wakeup_report, GFP_KERNEL);
 	kfree_skb(pkt);
+}
 
- out:
+/* releases the MVM mutex */
+static void iwl_mvm_query_wakeup_reasons(struct iwl_mvm *mvm,
+					 struct ieee80211_vif *vif)
+{
+	u32 base = mvm->error_event_table;
+	struct error_table_start {
+		/* cf. struct iwl_error_event_table */
+		u32 valid;
+		u32 error_id;
+	} err_info;
+	struct iwl_host_cmd cmd = {
+		.id = WOWLAN_GET_STATUSES,
+		.flags = CMD_SYNC | CMD_WANT_SKB,
+	};
+	struct iwl_wowlan_status *status;
+	int ret, len;
+
+	iwl_trans_read_mem_bytes(mvm->trans, base,
+				 &err_info, sizeof(err_info));
+
+	if (err_info.valid) {
+		IWL_INFO(mvm, "error table is valid (%d)\n",
+			 err_info.valid);
+		if (err_info.error_id == RF_KILL_INDICATOR_FOR_WOWLAN) {
+			struct cfg80211_wowlan_wakeup wakeup = {
+				.rfkill_release = true,
+			};
+			ieee80211_report_wowlan_wakeup(vif, &wakeup,
+						       GFP_KERNEL);
+		}
+		goto out_unlock;
+	}
+
+	/* only for tracing for now */
+	ret = iwl_mvm_send_cmd_pdu(mvm, OFFLOADS_QUERY_CMD, CMD_SYNC, 0, NULL);
+	if (ret)
+		IWL_ERR(mvm, "failed to query offload statistics (%d)\n", ret);
+
+	ret = iwl_mvm_send_cmd(mvm, &cmd);
+	if (ret) {
+		IWL_ERR(mvm, "failed to query status (%d)\n", ret);
+		goto out_unlock;
+	}
+
+	/* RF-kill already asserted again... */
+	if (!cmd.resp_pkt)
+		goto out_unlock;
+
+	len = le32_to_cpu(cmd.resp_pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK;
+	if (len - sizeof(struct iwl_cmd_header) < sizeof(*status)) {
+		IWL_ERR(mvm, "Invalid WoWLAN status response!\n");
+		goto out_free_resp;
+	}
+
+	status = (void *)cmd.resp_pkt->data;
+
+	if (len - sizeof(struct iwl_cmd_header) !=
+	    sizeof(*status) +
+	    ALIGN(le32_to_cpu(status->wake_packet_bufsize), 4)) {
+		IWL_ERR(mvm, "Invalid WoWLAN status response!\n");
+		goto out_free_resp;
+	}
+
+	/* now we have all the data we need, unlock to avoid mac80211 issues */
+	mutex_unlock(&mvm->mutex);
+
+	iwl_mvm_report_wakeup_reasons(mvm, vif, status);
+	iwl_free_resp(&cmd);
+	return;
+
+ out_free_resp:
 	iwl_free_resp(&cmd);
+ out_unlock:
+	mutex_unlock(&mvm->mutex);
 }
 
 static void iwl_mvm_read_d3_sram(struct iwl_mvm *mvm)
@@ -1342,10 +1364,13 @@ static int __iwl_mvm_resume(struct iwl_mvm *mvm, bool test)
 	iwl_mvm_read_d3_sram(mvm);
 
 	iwl_mvm_query_wakeup_reasons(mvm, vif);
+	/* has unlocked the mutex, so skip that */
+	goto out;
 
  out_unlock:
 	mutex_unlock(&mvm->mutex);
 
+ out:
 	if (!test && vif)
 		ieee80211_resume_disconnect(vif);
 
-- 
1.8.4.rc2

