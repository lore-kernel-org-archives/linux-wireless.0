Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:34362 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753735AbdFVVVz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Jun 2017 17:21:55 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Liad Kaufman <liad.kaufman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 23 Jun 2017 00:20:59 +0300
Message-Id: <20170622212101.16422-24-luca@coelho.fi> (sfid-20170622_232200_267563_58237E6B)
In-Reply-To: <20170622212101.16422-1-luca@coelho.fi>
References: <20170622212101.16422-1-luca@coelho.fi>
Subject: [PATCH 23/25] iwlwifi: mvm: support aggregations on A000 HW
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

On A000 HW, the SCD rdptr has only 8 bits allocated
for it, thus when checking if a queue is full, or
when checking if the SSN is equal to the TID's
next_reclaimed, A000 HW should trim the SSN.

Fix this by "normalizing" the SSN to wrap around
0xFF when comparing to the next_reclaimed on A000
HW.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c      |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c      | 27 +++++++++++++++++++++--
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h      |  8 ++-----
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c       | 15 ++++++++++---
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c    |  2 +-
 6 files changed, 42 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 2449be6f95a5..d608ce8305c7 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -2395,7 +2395,7 @@ static void __iwl_mvm_mac_sta_notify(struct ieee80211_hw *hw,
 
 		__set_bit(tid_data->txq_id, &txqs);
 
-		if (iwl_mvm_tid_queued(tid_data) == 0)
+		if (iwl_mvm_tid_queued(mvm, tid_data) == 0)
 			continue;
 
 		__set_bit(tid, &tids);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 30fc756b5b01..3a8c95162811 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -1323,7 +1323,7 @@ static bool iwl_mvm_disallow_offloading(struct iwl_mvm *mvm,
 		 * for offloading in order to prevent reuse of the same
 		 * qos seq counters.
 		 */
-		if (iwl_mvm_tid_queued(tid_data))
+		if (iwl_mvm_tid_queued(mvm, tid_data))
 			continue;
 
 		if (tid_data->state != IWL_AGG_OFF)
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 59cd2486a449..0249300c4600 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -2529,6 +2529,7 @@ int iwl_mvm_sta_tx_agg_start(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 {
 	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
 	struct iwl_mvm_tid_data *tid_data;
+	u16 normalized_ssn;
 	int txq_id;
 	int ret;
 
@@ -2616,7 +2617,15 @@ int iwl_mvm_sta_tx_agg_start(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 			    mvmsta->sta_id, tid, txq_id, tid_data->ssn,
 			    tid_data->next_reclaimed);
 
-	if (tid_data->ssn == tid_data->next_reclaimed) {
+	/*
+	 * In A000 HW, the next_reclaimed index is only 8 bit, so we'll need
+	 * to align the wrap around of ssn so we compare relevant values.
+	 */
+	normalized_ssn = tid_data->ssn;
+	if (mvm->trans->cfg->gen2)
+		normalized_ssn &= 0xff;
+
+	if (normalized_ssn == tid_data->next_reclaimed) {
 		tid_data->state = IWL_AGG_STARTING;
 		ieee80211_start_tx_ba_cb_irqsafe(vif, sta->addr, tid);
 	} else {
@@ -3540,7 +3549,7 @@ void iwl_mvm_sta_modify_sleep_tx_count(struct iwl_mvm *mvm,
 				return;
 			}
 
-			n_queued = iwl_mvm_tid_queued(tid_data);
+			n_queued = iwl_mvm_tid_queued(mvm, tid_data);
 			if (n_queued > remaining) {
 				more_data = true;
 				remaining = 0;
@@ -3722,3 +3731,17 @@ void iwl_mvm_csa_client_absent(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 
 	rcu_read_unlock();
 }
+
+u16 iwl_mvm_tid_queued(struct iwl_mvm *mvm, struct iwl_mvm_tid_data *tid_data)
+{
+	u16 sn = IEEE80211_SEQ_TO_SN(tid_data->seq_number);
+
+	/*
+	 * In A000 HW, the next_reclaimed index is only 8 bit, so we'll need
+	 * to align the wrap around of ssn so we compare relevant values.
+	 */
+	if (mvm->trans->cfg->gen2)
+		sn &= 0xff;
+
+	return ieee80211_sn_sub(sn, tid_data->next_reclaimed);
+}
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.h b/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
index 357ff2bf75c1..05fecbe87da4 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
@@ -341,12 +341,6 @@ struct iwl_mvm_tid_data {
 	bool is_tid_active;
 };
 
-static inline u16 iwl_mvm_tid_queued(struct iwl_mvm_tid_data *tid_data)
-{
-	return ieee80211_sn_sub(IEEE80211_SEQ_TO_SN(tid_data->seq_number),
-				tid_data->next_reclaimed);
-}
-
 struct iwl_mvm_key_pn {
 	struct rcu_head rcu_head;
 	struct {
@@ -447,6 +441,8 @@ struct iwl_mvm_sta {
 	u8 avg_energy;
 };
 
+u16 iwl_mvm_tid_queued(struct iwl_mvm *mvm, struct iwl_mvm_tid_data *tid_data);
+
 static inline struct iwl_mvm_sta *
 iwl_mvm_sta_from_mac80211(struct ieee80211_sta *sta)
 {
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index da05801c9ca1..288505114153 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -1129,13 +1129,14 @@ static void iwl_mvm_check_ratid_empty(struct iwl_mvm *mvm,
 	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
 	struct iwl_mvm_tid_data *tid_data = &mvmsta->tid_data[tid];
 	struct ieee80211_vif *vif = mvmsta->vif;
+	u16 normalized_ssn;
 
 	lockdep_assert_held(&mvmsta->lock);
 
 	if ((tid_data->state == IWL_AGG_ON ||
 	     tid_data->state == IWL_EMPTYING_HW_QUEUE_DELBA ||
 	     iwl_mvm_is_dqa_supported(mvm)) &&
-	    iwl_mvm_tid_queued(tid_data) == 0) {
+	    iwl_mvm_tid_queued(mvm, tid_data) == 0) {
 		/*
 		 * Now that this aggregation or DQA queue is empty tell
 		 * mac80211 so it knows we no longer have frames buffered for
@@ -1144,7 +1145,15 @@ static void iwl_mvm_check_ratid_empty(struct iwl_mvm *mvm,
 		ieee80211_sta_set_buffered(sta, tid, false);
 	}
 
-	if (tid_data->ssn != tid_data->next_reclaimed)
+	/*
+	 * In A000 HW, the next_reclaimed index is only 8 bit, so we'll need
+	 * to align the wrap around of ssn so we compare relevant values.
+	 */
+	normalized_ssn = tid_data->ssn;
+	if (mvm->trans->cfg->gen2)
+		normalized_ssn &= 0xff;
+
+	if (normalized_ssn != tid_data->next_reclaimed)
 		return;
 
 	switch (tid_data->state) {
@@ -1488,7 +1497,7 @@ static void iwl_mvm_rx_tx_cmd_single(struct iwl_mvm *mvm,
 			if (mvmsta->sleep_tx_count) {
 				mvmsta->sleep_tx_count--;
 				if (mvmsta->sleep_tx_count &&
-				    !iwl_mvm_tid_queued(tid_data)) {
+				    !iwl_mvm_tid_queued(mvm, tid_data)) {
 					/*
 					 * The number of frames in the queue
 					 * dropped to 0 even if we sent less
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index cc5a56818db8..dc8104d846f9 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -1181,7 +1181,7 @@ static void iwl_mvm_remove_inactive_tids(struct iwl_mvm *mvm,
 	/* Go over all non-active TIDs, incl. IWL_MAX_TID_COUNT (for mgmt) */
 	for_each_set_bit(tid, &tid_bitmap, IWL_MAX_TID_COUNT + 1) {
 		/* If some TFDs are still queued - don't mark TID as inactive */
-		if (iwl_mvm_tid_queued(&mvmsta->tid_data[tid]))
+		if (iwl_mvm_tid_queued(mvm, &mvmsta->tid_data[tid]))
 			tid_bitmap &= ~BIT(tid);
 	}
 
-- 
2.11.0
