Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47710 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933199Ab3BLQCU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2013 11:02:20 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 10/15] iwlwifi: mvm: report wakeup reasons
Date: Tue, 12 Feb 2013 17:02:02 +0100
Message-Id: <1360684927-1367-10-git-send-email-johannes@sipsolutions.net> (sfid-20130212_170226_935715_F0E67B72)
In-Reply-To: <1360684927-1367-1-git-send-email-johannes@sipsolutions.net>
References: <1360684891.29913.4.camel@jlt4.sipsolutions.net>
 <1360684927-1367-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Query the wakeup reasons properly and then
report them to mac80211.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/d3.c | 168 ++++++++++++++++++++++++++++------
 1 file changed, 141 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/d3.c b/drivers/net/wireless/iwlwifi/mvm/d3.c
index 5b2c675..a00267f 100644
--- a/drivers/net/wireless/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/iwlwifi/mvm/d3.c
@@ -763,6 +763,146 @@ int iwl_mvm_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 	return ret;
 }
 
+static void iwl_mvm_query_wakeup_reasons(struct iwl_mvm *mvm,
+					 struct ieee80211_vif *vif)
+{
+	u32 base = mvm->error_event_table;
+	struct error_table_start {
+		/* cf. struct iwl_error_event_table */
+		u32 valid;
+		u32 error_id;
+	} err_info;
+	struct cfg80211_wowlan_wakeup wakeup = {
+		.pattern_idx = -1,
+	};
+	struct cfg80211_wowlan_wakeup *wakeup_report = &wakeup;
+	struct iwl_host_cmd cmd = {
+		.id = WOWLAN_GET_STATUSES,
+		.flags = CMD_SYNC | CMD_WANT_SKB,
+	};
+	struct iwl_wowlan_status *status;
+	u32 reasons;
+	int ret, len;
+	bool pkt8023 = false;
+	struct sk_buff *pkt = NULL;
+
+	iwl_trans_read_mem_bytes(mvm->trans, base,
+				 &err_info, sizeof(err_info));
+
+	if (err_info.valid) {
+		IWL_INFO(mvm, "error table is valid (%d)\n",
+			 err_info.valid);
+		if (err_info.error_id == RF_KILL_INDICATOR_FOR_WOWLAN) {
+			wakeup.rfkill_release = true;
+			ieee80211_report_wowlan_wakeup(vif, &wakeup,
+						       GFP_KERNEL);
+		}
+		return;
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
+		return;
+	}
+
+	/* RF-kill already asserted again... */
+	if (!cmd.resp_pkt)
+		return;
+
+	len = le32_to_cpu(cmd.resp_pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK;
+	if (len - sizeof(struct iwl_cmd_header) < sizeof(*status)) {
+		IWL_ERR(mvm, "Invalid WoWLAN status response!\n");
+		goto out;
+	}
+
+	status = (void *)cmd.resp_pkt->data;
+
+	if (len - sizeof(struct iwl_cmd_header) !=
+	    sizeof(*status) + le32_to_cpu(status->wake_packet_bufsize)) {
+		IWL_ERR(mvm, "Invalid WoWLAN status response!\n");
+		goto out;
+	}
+
+	reasons = le32_to_cpu(status->wakeup_reasons);
+
+	if (reasons == IWL_WOWLAN_WAKEUP_BY_NON_WIRELESS) {
+		wakeup_report = NULL;
+		goto report;
+	}
+
+	if (reasons & IWL_WOWLAN_WAKEUP_BY_MAGIC_PACKET) {
+		wakeup.magic_pkt = true;
+		pkt8023 = true;
+	}
+
+	if (reasons & IWL_WOWLAN_WAKEUP_BY_PATTERN) {
+		wakeup.pattern_idx =
+			le16_to_cpu(status->pattern_number);
+		pkt8023 = true;
+	}
+
+	if (reasons & (IWL_WOWLAN_WAKEUP_BY_DISCONNECTION_ON_MISSED_BEACON |
+		       IWL_WOWLAN_WAKEUP_BY_DISCONNECTION_ON_DEAUTH))
+		wakeup.disconnect = true;
+
+	if (reasons & IWL_WOWLAN_WAKEUP_BY_GTK_REKEY_FAILURE) {
+		wakeup.gtk_rekey_failure = true;
+		pkt8023 = true;
+	}
+
+	if (reasons & IWL_WOWLAN_WAKEUP_BY_RFKILL_DEASSERTED) {
+		wakeup.rfkill_release = true;
+		pkt8023 = true;
+	}
+
+	if (reasons & IWL_WOWLAN_WAKEUP_BY_EAPOL_REQUEST) {
+		wakeup.eap_identity_req = true;
+		pkt8023 = true;
+	}
+
+	if (reasons & IWL_WOWLAN_WAKEUP_BY_FOUR_WAY_HANDSHAKE) {
+		wakeup.four_way_handshake = true;
+		pkt8023 = true;
+	}
+
+	if (status->wake_packet_bufsize) {
+		u32 pktsize = le32_to_cpu(status->wake_packet_bufsize);
+		u32 pktlen = le32_to_cpu(status->wake_packet_length);
+
+		if (pkt8023) {
+			pkt = alloc_skb(pktsize, GFP_KERNEL);
+			if (!pkt)
+				goto report;
+			memcpy(skb_put(pkt, pktsize), status->wake_packet,
+			       pktsize);
+			if (ieee80211_data_to_8023(pkt, vif->addr, vif->type))
+				goto report;
+			wakeup.packet = pkt->data;
+			wakeup.packet_present_len = pkt->len;
+			wakeup.packet_len = pkt->len - (pktlen - pktsize);
+			wakeup.packet_80211 = false;
+		} else {
+			wakeup.packet = status->wake_packet;
+			wakeup.packet_present_len = pktsize;
+			wakeup.packet_len = pktlen;
+			wakeup.packet_80211 = true;
+		}
+	}
+
+ report:
+	ieee80211_report_wowlan_wakeup(vif, wakeup_report, GFP_KERNEL);
+	kfree_skb(pkt);
+
+ out:
+	iwl_free_resp(&cmd);
+}
+
 int iwl_mvm_resume(struct ieee80211_hw *hw)
 {
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
@@ -770,14 +910,8 @@ int iwl_mvm_resume(struct ieee80211_hw *hw)
 		.mvm = mvm,
 	};
 	struct ieee80211_vif *vif = NULL;
-	u32 base;
 	int ret;
 	enum iwl_d3_status d3_status;
-	struct error_table_start {
-		/* cf. struct iwl_error_event_table */
-		u32 valid;
-		u32 error_id;
-	} err_info;
 
 	mutex_lock(&mvm->mutex);
 
@@ -800,27 +934,7 @@ int iwl_mvm_resume(struct ieee80211_hw *hw)
 		goto out_unlock;
 	}
 
-	base = mvm->error_event_table;
-
-	iwl_trans_read_mem_bytes(mvm->trans, base,
-				 &err_info, sizeof(err_info));
-
-	if (err_info.valid) {
-		IWL_INFO(mvm, "error table is valid (%d)\n",
-			 err_info.valid);
-		if (err_info.error_id == RF_KILL_INDICATOR_FOR_WOWLAN)
-			IWL_ERR(mvm, "this was due to RF-kill\n");
-		goto out_unlock;
-	}
-
-	/* TODO: get status and whatever else ... */
-	ret = iwl_mvm_send_cmd_pdu(mvm, WOWLAN_GET_STATUSES, CMD_SYNC, 0, NULL);
-	if (ret)
-		IWL_ERR(mvm, "failed to query status (%d)\n", ret);
-
-	ret = iwl_mvm_send_cmd_pdu(mvm, OFFLOADS_QUERY_CMD, CMD_SYNC, 0, NULL);
-	if (ret)
-		IWL_ERR(mvm, "failed to query offloads (%d)\n", ret);
+	iwl_mvm_query_wakeup_reasons(mvm, vif);
 
  out_unlock:
 	mutex_unlock(&mvm->mutex);
-- 
1.8.0

