Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:49478 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752245AbdIHJNP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Sep 2017 05:13:15 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Naftali Goldstein <naftali.goldstein@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  8 Sep 2017 12:12:50 +0300
Message-Id: <20170908091256.25279-5-luca@coelho.fi> (sfid-20170908_111319_849592_4EA823DE)
In-Reply-To: <20170908091256.25279-1-luca@coelho.fi>
References: <20170908091256.25279-1-luca@coelho.fi>
Subject: [PATCH 04/10] iwlwifi: mvm: change state when queueing agg start work
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Naftali Goldstein <naftali.goldstein@intel.com>

Add a new state to enum iwl_mvm_agg_state, which is used between
queueing the work that starts tx aggregations and actually starting that
work (changing to state IWL_AGG_STARTING).
This solves a race where ieee80211_start_tx_ba_session is called a
second time, before the work queued by the first run has a chance to
change the agg_state. In this case the second call to
ieee80211_start_tx_ba_session returns an error, and the fallback is to
abort the ba session start.

Fixes: 482e48440a0e ("iwlwifi: mvm: change open and close criteria of a BA session")
Signed-off-by: Naftali Goldstein <naftali.goldstein@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c  | 3 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 6 ++++--
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h | 2 ++
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
index ba7bd049d3d4..0fe723ca844e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
@@ -661,7 +661,8 @@ static void rs_tl_turn_on_agg(struct iwl_mvm *mvm, struct iwl_mvm_sta *mvmsta,
 	    (lq_sta->tx_agg_tid_en & BIT(tid)) &&
 	    (tid_data->tx_count_last >= IWL_MVM_RS_AGG_START_THRESHOLD)) {
 		IWL_DEBUG_RATE(mvm, "try to aggregate tid %d\n", tid);
-		rs_tl_turn_on_agg_for_tid(mvm, lq_sta, tid, sta);
+		if (rs_tl_turn_on_agg_for_tid(mvm, lq_sta, tid, sta) == 0)
+			tid_data->state = IWL_AGG_QUEUED;
 	}
 }
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 411a2055dc45..2dafe9bb4d8b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -2385,8 +2385,10 @@ int iwl_mvm_sta_tx_agg_start(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	if (WARN_ON_ONCE(tid >= IWL_MAX_TID_COUNT))
 		return -EINVAL;
 
-	if (mvmsta->tid_data[tid].state != IWL_AGG_OFF) {
-		IWL_ERR(mvm, "Start AGG when state is not IWL_AGG_OFF %d!\n",
+	if (mvmsta->tid_data[tid].state != IWL_AGG_QUEUED &&
+	    mvmsta->tid_data[tid].state != IWL_AGG_OFF) {
+		IWL_ERR(mvm,
+			"Start AGG when state is not IWL_AGG_QUEUED or IWL_AGG_OFF %d!\n",
 			mvmsta->tid_data[tid].state);
 		return -ENXIO;
 	}
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.h b/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
index d13893806513..aedabe101cf0 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
@@ -281,6 +281,7 @@ struct iwl_mvm_vif;
  * These states relate to a specific RA / TID.
  *
  * @IWL_AGG_OFF: aggregation is not used
+ * @IWL_AGG_QUEUED: aggregation start work has been queued
  * @IWL_AGG_STARTING: aggregation are starting (between start and oper)
  * @IWL_AGG_ON: aggregation session is up
  * @IWL_EMPTYING_HW_QUEUE_ADDBA: establishing a BA session - waiting for the
@@ -290,6 +291,7 @@ struct iwl_mvm_vif;
  */
 enum iwl_mvm_agg_state {
 	IWL_AGG_OFF = 0,
+	IWL_AGG_QUEUED,
 	IWL_AGG_STARTING,
 	IWL_AGG_ON,
 	IWL_EMPTYING_HW_QUEUE_ADDBA,
-- 
2.14.1
