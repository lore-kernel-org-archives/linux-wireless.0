Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:33524 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753894AbcGFKpJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2016 06:45:09 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Sara Sharon <sara.sharon@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  6 Jul 2016 13:40:38 +0300
Message-Id: <1467801651-1816-43-git-send-email-luca@coelho.fi> (sfid-20160706_124524_574714_15E500BD)
In-Reply-To: <1467801452.25088.20.camel@coelho.fi>
References: <1467801452.25088.20.camel@coelho.fi>
Subject: [PATCH 43/56] iwlwifi: mvm: add RX aggregation prints
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Add some prints to track BAID assignment.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 6 ++++++
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c  | 7 +++++--
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index d13397a..a1cbf48 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -476,6 +476,9 @@ void iwl_mvm_reorder_timer_expired(unsigned long data)
 		rcu_read_lock();
 		sta = rcu_dereference(buf->mvm->fw_id_to_mac_id[buf->sta_id]);
 		/* SN is set to the last expired frame + 1 */
+		IWL_DEBUG_HT(buf->mvm,
+			     "Releasing expired frames for sta %u, sn %d\n",
+			     buf->sta_id, sn);
 		iwl_mvm_release_frames(buf->mvm, sta, NULL, buf, sn);
 		rcu_read_unlock();
 	} else if (buf->num_stored) {
@@ -956,6 +959,9 @@ void iwl_mvm_rx_frame_release(struct iwl_mvm *mvm, struct napi_struct *napi,
 
 	int baid = release->baid;
 
+	IWL_DEBUG_HT(mvm, "Frame release notification for BAID %u, NSSN %d\n",
+		     release->baid, le16_to_cpu(release->nssn));
+
 	if (WARN_ON_ONCE(baid == IWL_RX_REORDER_DATA_INVALID_BAID))
 		return;
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index a6d6df9..c0c2ea3 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -1768,8 +1768,8 @@ int iwl_mvm_sta_rx_agg(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 
 	switch (status & IWL_ADD_STA_STATUS_MASK) {
 	case ADD_STA_SUCCESS:
-		IWL_DEBUG_INFO(mvm, "RX BA Session %sed in fw\n",
-			       start ? "start" : "stopp");
+		IWL_DEBUG_HT(mvm, "RX BA Session %sed in fw\n",
+			     start ? "start" : "stopp");
 		break;
 	case ADD_STA_IMMEDIATE_BA_FAILURE:
 		IWL_WARN(mvm, "RX BA Session refused by fw\n");
@@ -1824,6 +1824,8 @@ int iwl_mvm_sta_rx_agg(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 		 * supposed to happen) and we will free the session data while
 		 * RX is being processed in parallel
 		 */
+		IWL_DEBUG_HT(mvm, "Sta %d(%d) is assigned to BAID %d\n",
+			     mvm_sta->sta_id, tid, baid);
 		WARN_ON(rcu_access_pointer(mvm->baid_map[baid]));
 		rcu_assign_pointer(mvm->baid_map[baid], baid_data);
 	} else if (mvm->rx_ba_sessions > 0) {
@@ -1846,6 +1848,7 @@ int iwl_mvm_sta_rx_agg(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 		del_timer_sync(&baid_data->session_timer);
 		RCU_INIT_POINTER(mvm->baid_map[baid], NULL);
 		kfree_rcu(baid_data, rcu_head);
+		IWL_DEBUG_HT(mvm, "BAID %d is free\n", baid);
 	}
 	return 0;
 
-- 
2.8.1

