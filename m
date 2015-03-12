Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:10481 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754580AbbCLNGS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 09:06:18 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 41/49] iwlwifi: mvm: freeze the non-shared queues when a station goes to sleep
Date: Thu, 12 Mar 2015 15:04:26 +0200
Message-Id: <1426165474-25586-41-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150312_143418_206552_81D72628)
In-Reply-To: <1426164431.19690.4.camel@egrumbacBox>
References: <1426164431.19690.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When a station goes to sleep, we can't transmit any frame
to it. This means that until that station will wake up, a
queue that is dedicated to this station won't progress at
all. Take this into account when monitoring stuck queues
and don't account for the time the station was asleep.
This allows to mask false positives where the queues are
stuck not because of a bug, but because of the station
being asleep.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 36 ++++++++++++++++++++---------
 1 file changed, 25 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 7eab892..6b3f4d0 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -2427,25 +2427,35 @@ static void iwl_mvm_mac_sta_notify(struct ieee80211_hw *hw,
 {
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
 	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
+	unsigned long txqs = 0, tids = 0;
 	int tid;
 
+	spin_lock_bh(&mvmsta->lock);
+	for (tid = 0; tid < IWL_MAX_TID_COUNT; tid++) {
+		struct iwl_mvm_tid_data *tid_data = &mvmsta->tid_data[tid];
+
+		if (tid_data->state != IWL_AGG_ON &&
+		    tid_data->state != IWL_EMPTYING_HW_QUEUE_DELBA)
+			continue;
+
+		__set_bit(tid_data->txq_id, &txqs);
+
+		if (iwl_mvm_tid_queued(tid_data) == 0)
+			continue;
+
+		__set_bit(tid, &tids);
+	}
+
 	switch (cmd) {
 	case STA_NOTIFY_SLEEP:
 		if (atomic_read(&mvm->pending_frames[mvmsta->sta_id]) > 0)
 			ieee80211_sta_block_awake(hw, sta, true);
-		spin_lock_bh(&mvmsta->lock);
-		for (tid = 0; tid < IWL_MAX_TID_COUNT; tid++) {
-			struct iwl_mvm_tid_data *tid_data;
 
-			tid_data = &mvmsta->tid_data[tid];
-			if (tid_data->state != IWL_AGG_ON &&
-			    tid_data->state != IWL_EMPTYING_HW_QUEUE_DELBA)
-				continue;
-			if (iwl_mvm_tid_queued(tid_data) == 0)
-				continue;
+		for_each_set_bit(tid, &tids, IWL_MAX_TID_COUNT)
 			ieee80211_sta_set_buffered(sta, tid, true);
-		}
-		spin_unlock_bh(&mvmsta->lock);
+
+		if (txqs)
+			iwl_trans_freeze_txq_timer(mvm->trans, txqs, true);
 		/*
 		 * The fw updates the STA to be asleep. Tx packets on the Tx
 		 * queues to this station will not be transmitted. The fw will
@@ -2455,11 +2465,15 @@ static void iwl_mvm_mac_sta_notify(struct ieee80211_hw *hw,
 	case STA_NOTIFY_AWAKE:
 		if (WARN_ON(mvmsta->sta_id == IWL_MVM_STATION_COUNT))
 			break;
+
+		if (txqs)
+			iwl_trans_freeze_txq_timer(mvm->trans, txqs, false);
 		iwl_mvm_sta_modify_ps_wake(mvm, sta);
 		break;
 	default:
 		break;
 	}
+	spin_unlock_bh(&mvmsta->lock);
 }
 
 static void iwl_mvm_sta_pre_rcu_remove(struct ieee80211_hw *hw,
-- 
1.9.1

