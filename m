Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:33472 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753724AbcGFKov (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2016 06:44:51 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Liad Kaufman <liad.kaufman@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  6 Jul 2016 13:40:36 +0300
Message-Id: <1467801651-1816-41-git-send-email-luca@coelho.fi> (sfid-20160706_124456_110713_44B41473)
In-Reply-To: <1467801452.25088.20.camel@coelho.fi>
References: <1467801452.25088.20.camel@coelho.fi>
Subject: [PATCH 41/56] iwlwifi: mvm: support tdls in dqa mode
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

Support TDLS when working in DQA mode.

This is done mainly by NOT doing any special things
for TDLS, as the queues are dynamically created anyway,
so no need to allocate them ahead of time.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 31 +++++++++++++++++-----------
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c  |  8 ++++++-
 2 files changed, 26 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 7321bb6..1617de7 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -893,8 +893,11 @@ int iwl_mvm_add_sta(struct iwl_mvm *mvm,
 	mvm_sta->tid_disable_agg = 0xffff; /* No aggs at first */
 	mvm_sta->tfd_queue_msk = 0;
 
-	/* allocate new queues for a TDLS station */
-	if (sta->tdls) {
+	/*
+	 * Allocate new queues for a TDLS station, unless we're in DQA mode,
+	 * and then they'll be allocated dynamically
+	 */
+	if (!iwl_mvm_is_dqa_supported(mvm) && sta->tdls) {
 		ret = iwl_mvm_tdls_sta_init(mvm, sta);
 		if (ret)
 			return ret;
@@ -958,7 +961,8 @@ int iwl_mvm_add_sta(struct iwl_mvm *mvm,
 	return 0;
 
 err:
-	iwl_mvm_tdls_sta_deinit(mvm, sta);
+	if (!iwl_mvm_is_dqa_supported(mvm) && sta->tdls)
+		iwl_mvm_tdls_sta_deinit(mvm, sta);
 	return ret;
 }
 
@@ -1164,16 +1168,19 @@ int iwl_mvm_rm_sta(struct iwl_mvm *mvm,
 		if (iwl_mvm_is_dqa_supported(mvm))
 			iwl_mvm_disable_sta_queues(mvm, vif, mvm_sta);
 
-		/* if we are associated - we can't remove the AP STA now */
-		if (vif->bss_conf.assoc)
-			return ret;
+		if (vif->type == NL80211_IFTYPE_STATION &&
+		    mvmvif->ap_sta_id == mvm_sta->sta_id) {
+			/* if associated - we can't remove the AP STA now */
+			if (vif->bss_conf.assoc)
+				return ret;
 
-		/* unassoc - go ahead - remove the AP STA now */
-		mvmvif->ap_sta_id = IWL_MVM_STATION_COUNT;
+			/* unassoc - go ahead - remove the AP STA now */
+			mvmvif->ap_sta_id = IWL_MVM_STATION_COUNT;
 
-		/* clear d0i3_ap_sta_id if no longer relevant */
-		if (mvm->d0i3_ap_sta_id == mvm_sta->sta_id)
-			mvm->d0i3_ap_sta_id = IWL_MVM_STATION_COUNT;
+			/* clear d0i3_ap_sta_id if no longer relevant */
+			if (mvm->d0i3_ap_sta_id == mvm_sta->sta_id)
+				mvm->d0i3_ap_sta_id = IWL_MVM_STATION_COUNT;
+		}
 	}
 
 	/*
@@ -1211,7 +1218,7 @@ int iwl_mvm_rm_sta(struct iwl_mvm *mvm,
 	} else {
 		spin_unlock_bh(&mvm_sta->lock);
 
-		if (sta->tdls)
+		if (!iwl_mvm_is_dqa_supported(mvm) && sta->tdls)
 			iwl_mvm_tdls_sta_deinit(mvm, sta);
 
 		ret = iwl_mvm_rm_sta_common(mvm, mvm_sta->sta_id);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index f3a6e95..c6585ab 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -546,6 +546,9 @@ int iwl_mvm_tx_skb_non_sta(struct iwl_mvm *mvm, struct sk_buff *skb)
 	 * (this is not possible for unicast packets as a TLDS discovery
 	 * response are sent without a station entry); otherwise use the
 	 * AUX station.
+	 * In DQA mode, if vif is of type STATION and frames are not multicast,
+	 * they should be sent from the BSS queue. For example, TDLS setup
+	 * frames should be sent on this queue, as they go through the AP.
 	 */
 	sta_id = mvm->aux_sta.sta_id;
 	if (info.control.vif) {
@@ -563,6 +566,9 @@ int iwl_mvm_tx_skb_non_sta(struct iwl_mvm *mvm, struct sk_buff *skb)
 
 			if (ap_sta_id != IWL_MVM_STATION_COUNT)
 				sta_id = ap_sta_id;
+		} else if (iwl_mvm_is_dqa_supported(mvm) &&
+			   info.control.vif->type == NL80211_IFTYPE_STATION) {
+			queue = IWL_MVM_DQA_BSS_CLIENT_QUEUE;
 		}
 	}
 
@@ -906,7 +912,7 @@ static int iwl_mvm_tx_mpdu(struct iwl_mvm *mvm, struct sk_buff *skb,
 
 	WARN_ON_ONCE(info->flags & IEEE80211_TX_CTL_SEND_AFTER_DTIM);
 
-	if (sta->tdls) {
+	if (sta->tdls && !iwl_mvm_is_dqa_supported(mvm)) {
 		/* default to TID 0 for non-QoS packets */
 		u8 tdls_tid = tid == IWL_MAX_TID_COUNT ? 0 : tid;
 
-- 
2.8.1

