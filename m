Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:41075 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932613AbaLBSLj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2014 13:11:39 -0500
Received: by mail-wi0-f176.google.com with SMTP id ex7so28865852wid.9
        for <linux-wireless@vger.kernel.org>; Tue, 02 Dec 2014 10:11:38 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 11/26] iwlwifi: mvm: add channel information to the netdetect notifications
Date: Tue,  2 Dec 2014 20:11:02 +0200
Message-Id: <1417543877-24193-11-git-send-email-egrumbach@gmail.com> (sfid-20141202_191346_600774_249A12C5)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB31B5A7D27@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB31B5A7D27@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Add the channels on which there was a match for every match reported
by the firmware.  The firmware reports the channels as indices to the
array of channels that was passed in the scheduled scan request, so we
need to save the array when entering D3 to make sure it is available
when we resume.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/d3.c  | 63 ++++++++++++++++++++++++++++------
 drivers/net/wireless/iwlwifi/mvm/mvm.h |  2 ++
 2 files changed, 54 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/d3.c b/drivers/net/wireless/iwlwifi/mvm/d3.c
index c20d8de..744de26 100644
--- a/drivers/net/wireless/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/iwlwifi/mvm/d3.c
@@ -982,10 +982,10 @@ iwl_mvm_netdetect_config(struct iwl_mvm *mvm,
 	if (ret)
 		return ret;
 
-	if (WARN_ON(mvm->nd_match_sets))
+	if (WARN_ON(mvm->nd_match_sets || mvm->nd_channels))
 		return -EBUSY;
 
-	/* save the sched scan matchsets for later reporting */
+	/* save the sched scan matchsets... */
 	if (nd_config->n_match_sets) {
 		mvm->nd_match_sets = kmemdup(nd_config->match_sets,
 					     sizeof(*nd_config->match_sets) *
@@ -995,6 +995,14 @@ iwl_mvm_netdetect_config(struct iwl_mvm *mvm,
 			mvm->n_nd_match_sets = nd_config->n_match_sets;
 	}
 
+	/* ...and the sched scan channels for later reporting */
+	mvm->nd_channels = kmemdup(nd_config->channels,
+				   sizeof(*nd_config->channels) *
+				   nd_config->n_channels,
+				   GFP_KERNEL);
+	if (mvm->nd_channels)
+		mvm->n_nd_channels = nd_config->n_channels;
+
 	return 0;
 }
 
@@ -1003,6 +1011,9 @@ static void iwl_mvm_free_nd(struct iwl_mvm *mvm)
 	kfree(mvm->nd_match_sets);
 	mvm->nd_match_sets = NULL;
 	mvm->n_nd_match_sets = 0;
+	kfree(mvm->nd_channels);
+	mvm->nd_channels = NULL;
+	mvm->n_nd_channels = 0;
 }
 
 static int __iwl_mvm_suspend(struct ieee80211_hw *hw,
@@ -1640,7 +1651,14 @@ out_unlock:
 	return false;
 }
 
-static u32 iwl_mvm_netdetect_query_results(struct iwl_mvm *mvm)
+struct iwl_mvm_nd_query_results {
+	u32 matched_profiles;
+	struct iwl_scan_offload_profile_match matches[IWL_SCAN_MAX_PROFILES];
+};
+
+static int
+iwl_mvm_netdetect_query_results(struct iwl_mvm *mvm,
+				struct iwl_mvm_nd_query_results *results)
 {
 	struct iwl_scan_offload_profiles_query *query;
 	struct iwl_host_cmd cmd = {
@@ -1652,22 +1670,26 @@ static u32 iwl_mvm_netdetect_query_results(struct iwl_mvm *mvm)
 	ret = iwl_mvm_send_cmd(mvm, &cmd);
 	if (ret) {
 		IWL_ERR(mvm, "failed to query matched profiles (%d)\n", ret);
-		return 0;
+		return ret;
 	}
 
 	/* RF-kill already asserted again... */
-	if (!cmd.resp_pkt)
+	if (!cmd.resp_pkt) {
+		ret = -ERFKILL;
 		goto out_free_resp;
+	}
 
 	len = iwl_rx_packet_payload_len(cmd.resp_pkt);
 	if (len < sizeof(*query)) {
 		IWL_ERR(mvm, "Invalid scan offload profiles query response!\n");
+		ret = -EIO;
 		goto out_free_resp;
 	}
 
 	query = (void *)cmd.resp_pkt->data;
 
-	ret = le32_to_cpu(query->matched_profiles);
+	results->matched_profiles = le32_to_cpu(query->matched_profiles);
+	memcpy(results->matches, query->matches, sizeof(results->matches));
 
 out_free_resp:
 	iwl_free_resp(&cmd);
@@ -1682,10 +1704,11 @@ static void iwl_mvm_query_netdetect_reasons(struct iwl_mvm *mvm,
 		.pattern_idx = -1,
 	};
 	struct cfg80211_wowlan_wakeup *wakeup_report = &wakeup;
+	struct iwl_mvm_nd_query_results query;
 	struct iwl_wowlan_status *fw_status;
 	unsigned long matched_profiles;
 	u32 reasons = 0;
-	int i, n_matches;
+	int i, j, n_matches, ret;
 
 	fw_status = iwl_mvm_get_wakeup_status(mvm, vif);
 	if (!IS_ERR_OR_NULL(fw_status))
@@ -1697,12 +1720,13 @@ static void iwl_mvm_query_netdetect_reasons(struct iwl_mvm *mvm,
 	if (reasons != IWL_WOWLAN_WAKEUP_BY_NON_WIRELESS)
 		goto out;
 
-	matched_profiles = iwl_mvm_netdetect_query_results(mvm);
-	if (!matched_profiles) {
+	ret = iwl_mvm_netdetect_query_results(mvm, &query);
+	if (ret || !query.matched_profiles) {
 		wakeup_report = NULL;
 		goto out;
 	}
 
+	matched_profiles = query.matched_profiles;
 	if (mvm->n_nd_match_sets) {
 		n_matches = hweight_long(matched_profiles);
 	} else {
@@ -1717,17 +1741,34 @@ static void iwl_mvm_query_netdetect_reasons(struct iwl_mvm *mvm,
 		goto out_report_nd;
 
 	for_each_set_bit(i, &matched_profiles, mvm->n_nd_match_sets) {
+		struct iwl_scan_offload_profile_match *fw_match;
 		struct cfg80211_wowlan_nd_match *match;
+		int n_channels = 0;
+
+		fw_match = &query.matches[i];
+
+		for (j = 0; j < SCAN_OFFLOAD_MATCHING_CHANNELS_LEN; j++)
+			n_channels += hweight8(fw_match->matching_channels[j]);
 
-		match = kzalloc(sizeof(*match), GFP_KERNEL);
+		match = kzalloc(sizeof(*match) +
+				(n_channels * sizeof(*match->channels)),
+				GFP_KERNEL);
 		if (!match)
 			goto out_report_nd;
 
+		net_detect->matches[net_detect->n_matches++] = match;
+
 		match->ssid.ssid_len = mvm->nd_match_sets[i].ssid.ssid_len;
 		memcpy(match->ssid.ssid, mvm->nd_match_sets[i].ssid.ssid,
 		       match->ssid.ssid_len);
 
-		net_detect->matches[net_detect->n_matches++] = match;
+		if (mvm->n_nd_channels < n_channels)
+			continue;
+
+		for (j = 0; j < SCAN_OFFLOAD_MATCHING_CHANNELS_LEN * 8; j++)
+			if (fw_match->matching_channels[j / 8] & (BIT(j % 8)))
+				match->channels[match->n_channels++] =
+					mvm->nd_channels[j]->center_freq;
 	}
 
 out_report_nd:
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index d69cc86..bb7953b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -687,6 +687,8 @@ struct iwl_mvm {
 	struct ieee80211_scan_ies nd_ies;
 	struct cfg80211_match_set *nd_match_sets;
 	int n_nd_match_sets;
+	struct ieee80211_channel **nd_channels;
+	int n_nd_channels;
 	bool net_detect;
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 	u32 d3_wake_sysassert; /* must be u32 for debugfs_create_bool */
-- 
1.9.1

