Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:36924 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932756AbaLBSLk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2014 13:11:40 -0500
Received: by mail-wg0-f49.google.com with SMTP id n12so9540745wgh.36
        for <linux-wireless@vger.kernel.org>; Tue, 02 Dec 2014 10:11:39 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 10/26] iwlwifi: mvm: add SSID match information for net-detect
Date: Tue,  2 Dec 2014 20:11:01 +0200
Message-Id: <1417543877-24193-10-git-send-email-egrumbach@gmail.com> (sfid-20141202_191144_915844_13DC598E)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB31B5A7D27@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB31B5A7D27@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Add SSID information to the net-detect indication to userspace.  Fetch
the matched profiles from the firmware in order to find the correct
SSIDs in the profiles that matched.

Since the net-detect information is stored in cfg80211, and in theory
it could change while we are waking up and reading the matched
profiles, we need to save it when we enter D3 so it is available
during resume.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/d3.c  | 71 +++++++++++++++++++++++++++++++---
 drivers/net/wireless/iwlwifi/mvm/mvm.h |  2 +
 2 files changed, 68 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/d3.c b/drivers/net/wireless/iwlwifi/mvm/d3.c
index c7297c5..c20d8de 100644
--- a/drivers/net/wireless/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/iwlwifi/mvm/d3.c
@@ -979,8 +979,30 @@ iwl_mvm_netdetect_config(struct iwl_mvm *mvm,
 		return ret;
 
 	ret = iwl_mvm_scan_offload_start(mvm, vif, nd_config, &mvm->nd_ies);
+	if (ret)
+		return ret;
 
-	return ret;
+	if (WARN_ON(mvm->nd_match_sets))
+		return -EBUSY;
+
+	/* save the sched scan matchsets for later reporting */
+	if (nd_config->n_match_sets) {
+		mvm->nd_match_sets = kmemdup(nd_config->match_sets,
+					     sizeof(*nd_config->match_sets) *
+					     nd_config->n_match_sets,
+					     GFP_KERNEL);
+		if (mvm->nd_match_sets)
+			mvm->n_nd_match_sets = nd_config->n_match_sets;
+	}
+
+	return 0;
+}
+
+static void iwl_mvm_free_nd(struct iwl_mvm *mvm)
+{
+	kfree(mvm->nd_match_sets);
+	mvm->nd_match_sets = NULL;
+	mvm->n_nd_match_sets = 0;
 }
 
 static int __iwl_mvm_suspend(struct ieee80211_hw *hw,
@@ -1094,8 +1116,10 @@ static int __iwl_mvm_suspend(struct ieee80211_hw *hw,
 
 	iwl_trans_d3_suspend(mvm->trans, test);
  out:
-	if (ret < 0)
+	if (ret < 0) {
 		ieee80211_restart_hw(mvm->hw);
+		iwl_mvm_free_nd(mvm);
+	}
  out_noreset:
 	mutex_unlock(&mvm->mutex);
 
@@ -1653,14 +1677,15 @@ out_free_resp:
 static void iwl_mvm_query_netdetect_reasons(struct iwl_mvm *mvm,
 					    struct ieee80211_vif *vif)
 {
-	struct cfg80211_wowlan_nd_info net_detect = {};
+	struct cfg80211_wowlan_nd_info *net_detect = NULL;
 	struct cfg80211_wowlan_wakeup wakeup = {
 		.pattern_idx = -1,
 	};
 	struct cfg80211_wowlan_wakeup *wakeup_report = &wakeup;
 	struct iwl_wowlan_status *fw_status;
-	u32 matched_profiles;
+	unsigned long matched_profiles;
 	u32 reasons = 0;
+	int i, n_matches;
 
 	fw_status = iwl_mvm_get_wakeup_status(mvm, vif);
 	if (!IS_ERR_OR_NULL(fw_status))
@@ -1678,10 +1703,46 @@ static void iwl_mvm_query_netdetect_reasons(struct iwl_mvm *mvm,
 		goto out;
 	}
 
-	wakeup.net_detect = &net_detect;
+	if (mvm->n_nd_match_sets) {
+		n_matches = hweight_long(matched_profiles);
+	} else {
+		IWL_ERR(mvm, "no net detect match information available\n");
+		n_matches = 0;
+	}
+
+	net_detect = kzalloc(sizeof(*net_detect) +
+			     (n_matches * sizeof(net_detect->matches[0])),
+			     GFP_KERNEL);
+	if (!net_detect || !n_matches)
+		goto out_report_nd;
+
+	for_each_set_bit(i, &matched_profiles, mvm->n_nd_match_sets) {
+		struct cfg80211_wowlan_nd_match *match;
+
+		match = kzalloc(sizeof(*match), GFP_KERNEL);
+		if (!match)
+			goto out_report_nd;
+
+		match->ssid.ssid_len = mvm->nd_match_sets[i].ssid.ssid_len;
+		memcpy(match->ssid.ssid, mvm->nd_match_sets[i].ssid.ssid,
+		       match->ssid.ssid_len);
+
+		net_detect->matches[net_detect->n_matches++] = match;
+	}
+
+out_report_nd:
+	wakeup.net_detect = net_detect;
 out:
+	iwl_mvm_free_nd(mvm);
+
 	mutex_unlock(&mvm->mutex);
 	ieee80211_report_wowlan_wakeup(vif, wakeup_report, GFP_KERNEL);
+
+	if (net_detect) {
+		for (i = 0; i < net_detect->n_matches; i++)
+			kfree(net_detect->matches[i]);
+		kfree(net_detect);
+	}
 }
 
 static void iwl_mvm_read_d3_sram(struct iwl_mvm *mvm)
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 09d4833..d69cc86 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -685,6 +685,8 @@ struct iwl_mvm {
 	/* sched scan settings for net detect */
 	struct cfg80211_sched_scan_request *nd_config;
 	struct ieee80211_scan_ies nd_ies;
+	struct cfg80211_match_set *nd_match_sets;
+	int n_nd_match_sets;
 	bool net_detect;
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 	u32 d3_wake_sysassert; /* must be u32 for debugfs_create_bool */
-- 
1.9.1

