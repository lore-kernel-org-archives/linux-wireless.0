Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:62891 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753586AbcCBH6N (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Mar 2016 02:58:13 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 34/43] iwlwifi: mvm: kill iwl_mvm_enable_agg_txq
Date: Wed,  2 Mar 2016 09:56:35 +0200
Message-Id: <1456905404-14435-34-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160302_085952_884206_6A2EF4BB)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32EA50146@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32EA50146@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

iwl_mvm_enable_agg_txq has only one user. Kill it and
adapt the call site.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h | 16 ----------------
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 16 +++++++++++-----
 2 files changed, 11 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 21986f6..b461b90 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1549,22 +1549,6 @@ void iwl_mvm_enable_ac_txq(struct iwl_mvm *mvm, int queue, int mac80211_queue,
 	iwl_mvm_enable_txq(mvm, queue, mac80211_queue, ssn, &cfg, wdg_timeout);
 }
 
-static inline void iwl_mvm_enable_agg_txq(struct iwl_mvm *mvm, int queue,
-					  int mac80211_queue, int fifo,
-					  int sta_id, int tid, int frame_limit,
-					  u16 ssn, unsigned int wdg_timeout)
-{
-	struct iwl_trans_txq_scd_cfg cfg = {
-		.fifo = fifo,
-		.sta_id = sta_id,
-		.tid = tid,
-		.frame_limit = frame_limit,
-		.aggregate = true,
-	};
-
-	iwl_mvm_enable_txq(mvm, queue, mac80211_queue, ssn, &cfg, wdg_timeout);
-}
-
 /* Thermal management and CT-kill */
 void iwl_mvm_tt_tx_backoff(struct iwl_mvm *mvm, u32 backoff);
 void iwl_mvm_tt_temp_changed(struct iwl_mvm *mvm, u32 temp);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 4717b18..ef99942 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -1052,9 +1052,16 @@ int iwl_mvm_sta_tx_agg_oper(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	struct iwl_mvm_tid_data *tid_data = &mvmsta->tid_data[tid];
 	unsigned int wdg_timeout =
 		iwl_mvm_get_wd_timeout(mvm, vif, sta->tdls, false);
-	int queue, fifo, ret;
+	int queue, ret;
 	u16 ssn;
 
+	struct iwl_trans_txq_scd_cfg cfg = {
+		.sta_id = mvmsta->sta_id,
+		.tid = tid,
+		.frame_limit = buf_size,
+		.aggregate = true,
+	};
+
 	BUILD_BUG_ON((sizeof(mvmsta->agg_tids) * BITS_PER_BYTE)
 		     != IWL_MAX_TID_COUNT);
 
@@ -1069,11 +1076,10 @@ int iwl_mvm_sta_tx_agg_oper(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	tid_data->amsdu_in_ampdu_allowed = amsdu;
 	spin_unlock_bh(&mvmsta->lock);
 
-	fifo = iwl_mvm_ac_to_tx_fifo[tid_to_mac80211_ac[tid]];
+	cfg.fifo = iwl_mvm_ac_to_tx_fifo[tid_to_mac80211_ac[tid]];
 
-	iwl_mvm_enable_agg_txq(mvm, queue,
-			       vif->hw_queue[tid_to_mac80211_ac[tid]], fifo,
-			       mvmsta->sta_id, tid, buf_size, ssn, wdg_timeout);
+	iwl_mvm_enable_txq(mvm, queue, vif->hw_queue[tid_to_mac80211_ac[tid]],
+			   ssn, &cfg, wdg_timeout);
 
 	ret = iwl_mvm_sta_tx_agg(mvm, sta, tid, queue, true);
 	if (ret)
-- 
2.5.0

