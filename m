Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:41551 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932322AbaKXOgo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:36:44 -0500
Received: by mail-wg0-f50.google.com with SMTP id k14so12498386wgh.9
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 06:36:43 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 66/75] iwlwifi: mvm: refactor iwl_mvm_query_wakeup_reasons()
Date: Mon, 24 Nov 2014 16:34:42 +0200
Message-Id: <1416839691-28533-66-git-send-email-egrumbach@gmail.com> (sfid-20141124_153655_011965_50DE0288)
In-Reply-To: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
References: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Refactor the iwl_mvm_query_wakeup_reasons() function to split the part
that gets the firmware status from the part that sets up the WoWLAN
status.  This will allow netdetect to reuse the code.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/d3.c | 73 ++++++++++++++++++++++-------------
 1 file changed, 47 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/d3.c b/drivers/net/wireless/iwlwifi/mvm/d3.c
index fe27193..c72d2e9 100644
--- a/drivers/net/wireless/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/iwlwifi/mvm/d3.c
@@ -1490,9 +1490,8 @@ out:
 	return true;
 }
 
-/* releases the MVM mutex */
-static bool iwl_mvm_query_wakeup_reasons(struct iwl_mvm *mvm,
-					 struct ieee80211_vif *vif)
+static struct iwl_wowlan_status *
+iwl_mvm_get_wakeup_status(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 {
 	u32 base = mvm->error_event_table;
 	struct error_table_start {
@@ -1504,19 +1503,15 @@ static bool iwl_mvm_query_wakeup_reasons(struct iwl_mvm *mvm,
 		.id = WOWLAN_GET_STATUSES,
 		.flags = CMD_WANT_SKB,
 	};
-	struct iwl_wowlan_status_data status;
-	struct iwl_wowlan_status *fw_status;
-	int ret, len, status_size, i;
-	bool keep;
-	struct ieee80211_sta *ap_sta;
-	struct iwl_mvm_sta *mvm_ap_sta;
+	struct iwl_wowlan_status *status, *fw_status;
+	int ret, len, status_size;
 
 	iwl_trans_read_mem_bytes(mvm->trans, base,
 				 &err_info, sizeof(err_info));
 
 	if (err_info.valid) {
-		IWL_INFO(mvm, "error table is valid (%d)\n",
-			 err_info.valid);
+		IWL_INFO(mvm, "error table is valid (%d) with error (%d)\n",
+			 err_info.valid, err_info.error_id);
 		if (err_info.error_id == RF_KILL_INDICATOR_FOR_WOWLAN) {
 			struct cfg80211_wowlan_wakeup wakeup = {
 				.rfkill_release = true,
@@ -1524,7 +1519,7 @@ static bool iwl_mvm_query_wakeup_reasons(struct iwl_mvm *mvm,
 			ieee80211_report_wowlan_wakeup(vif, &wakeup,
 						       GFP_KERNEL);
 		}
-		goto out_unlock;
+		return ERR_PTR(-EIO);
 	}
 
 	/* only for tracing for now */
@@ -1535,22 +1530,53 @@ static bool iwl_mvm_query_wakeup_reasons(struct iwl_mvm *mvm,
 	ret = iwl_mvm_send_cmd(mvm, &cmd);
 	if (ret) {
 		IWL_ERR(mvm, "failed to query status (%d)\n", ret);
-		goto out_unlock;
+		return ERR_PTR(ret);
 	}
 
 	/* RF-kill already asserted again... */
-	if (!cmd.resp_pkt)
-		goto out_unlock;
+	if (!cmd.resp_pkt) {
+		ret = -ERFKILL;
+		goto out_free_resp;
+	}
 
 	status_size = sizeof(*fw_status);
 
 	len = iwl_rx_packet_payload_len(cmd.resp_pkt);
 	if (len < status_size) {
 		IWL_ERR(mvm, "Invalid WoWLAN status response!\n");
+		ret = -EIO;
+		goto out_free_resp;
+	}
+
+	status = (void *)cmd.resp_pkt->data;
+	if (len != (status_size +
+		    ALIGN(le32_to_cpu(status->wake_packet_bufsize), 4))) {
+		IWL_ERR(mvm, "Invalid WoWLAN status response!\n");
+		ret = -EIO;
 		goto out_free_resp;
 	}
 
-	fw_status = (void *)cmd.resp_pkt->data;
+	fw_status = kmemdup(status, len, GFP_KERNEL);
+
+out_free_resp:
+	iwl_free_resp(&cmd);
+	return ret ? ERR_PTR(ret) : fw_status;
+}
+
+/* releases the MVM mutex */
+static bool iwl_mvm_query_wakeup_reasons(struct iwl_mvm *mvm,
+					 struct ieee80211_vif *vif)
+{
+	struct iwl_wowlan_status_data status;
+	struct iwl_wowlan_status *fw_status;
+	int i;
+	bool keep;
+	struct ieee80211_sta *ap_sta;
+	struct iwl_mvm_sta *mvm_ap_sta;
+
+	fw_status = iwl_mvm_get_wakeup_status(mvm, vif);
+	if (IS_ERR_OR_NULL(fw_status))
+		goto out_unlock;
 
 	status.pattern_number = le16_to_cpu(fw_status->pattern_number);
 	for (i = 0; i < 8; i++)
@@ -1563,17 +1589,12 @@ static bool iwl_mvm_query_wakeup_reasons(struct iwl_mvm *mvm,
 		le32_to_cpu(fw_status->wake_packet_bufsize);
 	status.wake_packet = fw_status->wake_packet;
 
-	if (len != status_size + ALIGN(status.wake_packet_bufsize, 4)) {
-		IWL_ERR(mvm, "Invalid WoWLAN status response!\n");
-		goto out_free_resp;
-	}
-
 	/* still at hard-coded place 0 for D3 image */
 	ap_sta = rcu_dereference_protected(
 			mvm->fw_id_to_mac_id[0],
 			lockdep_is_held(&mvm->mutex));
 	if (IS_ERR_OR_NULL(ap_sta))
-		goto out_free_resp;
+		goto out_free;
 
 	mvm_ap_sta = (struct iwl_mvm_sta *)ap_sta->drv_priv;
 	for (i = 0; i < IWL_MAX_TID_COUNT; i++) {
@@ -1590,12 +1611,12 @@ static bool iwl_mvm_query_wakeup_reasons(struct iwl_mvm *mvm,
 
 	keep = iwl_mvm_setup_connection_keep(mvm, vif, fw_status);
 
-	iwl_free_resp(&cmd);
+	kfree(fw_status);
 	return keep;
 
- out_free_resp:
-	iwl_free_resp(&cmd);
- out_unlock:
+out_free:
+	kfree(fw_status);
+out_unlock:
 	mutex_unlock(&mvm->mutex);
 	return false;
 }
-- 
1.9.1

