Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:60748 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751212AbdFBL0Q (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Jun 2017 07:26:16 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  2 Jun 2017 14:25:29 +0300
Message-Id: <20170602112553.2466-2-luca@coelho.fi> (sfid-20170602_132638_679648_239BAE56)
In-Reply-To: <20170602112553.2466-1-luca@coelho.fi>
References: <20170602112553.2466-1-luca@coelho.fi>
Subject: [PATCH 01/25] iwlwifi: mvm: flush per station for DQA mode
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Avoid using the global flush and move to flush per
station whenever possible in DQA mode.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  | 26 ++++++++++++----------
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |  2 ++
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |  6 ++++-
 .../net/wireless/intel/iwlwifi/mvm/time-event.c    |  5 ++++-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        | 17 ++++++++++++++
 5 files changed, 42 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index a67aa1f5a51c..f4437d5b2e73 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -1451,7 +1451,7 @@ static void iwl_mvm_prepare_mac_removal(struct iwl_mvm *mvm,
 {
 	u32 tfd_msk = iwl_mvm_mac_get_queues_mask(vif);
 
-	if (tfd_msk) {
+	if (tfd_msk && !iwl_mvm_is_dqa_supported(mvm)) {
 		/*
 		 * mac80211 first removes all the stations of the vif and
 		 * then removes the vif. When it removes a station it also
@@ -1460,6 +1460,8 @@ static void iwl_mvm_prepare_mac_removal(struct iwl_mvm *mvm,
 		 * of these AMPDU sessions are properly closed.
 		 * We still need to take care of the shared queues of the vif.
 		 * Flush them here.
+		 * For DQA mode there is no need - broacast and multicast queue
+		 * are flushed separately.
 		 */
 		mutex_lock(&mvm->mutex);
 		iwl_mvm_flush_tx_path(mvm, tfd_msk, 0);
@@ -3988,21 +3990,21 @@ static void iwl_mvm_mac_flush(struct ieee80211_hw *hw,
 		/* make sure only TDLS peers or the AP are flushed */
 		WARN_ON(i != mvmvif->ap_sta_id && !sta->tdls);
 
-		msk |= mvmsta->tfd_queue_msk;
+		if (drop) {
+			if (iwl_mvm_flush_sta(mvm, mvmsta, false, 0))
+				IWL_ERR(mvm, "flush request fail\n");
+		} else {
+			msk |= mvmsta->tfd_queue_msk;
+		}
 	}
 
-	if (drop) {
-		if (iwl_mvm_flush_tx_path(mvm, msk, 0))
-			IWL_ERR(mvm, "flush request fail\n");
-		mutex_unlock(&mvm->mutex);
-	} else {
-		mutex_unlock(&mvm->mutex);
+	mutex_unlock(&mvm->mutex);
 
-		/* this can take a while, and we may need/want other operations
-		 * to succeed while doing this, so do it without the mutex held
-		 */
+	/* this can take a while, and we may need/want other operations
+	 * to succeed while doing this, so do it without the mutex held
+	 */
+	if (!drop)
 		iwl_trans_wait_tx_queues_empty(mvm->trans, msk);
-	}
 }
 
 static int iwl_mvm_mac_get_survey(struct ieee80211_hw *hw, int idx,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 4e74a6b90e70..53fbdb9136ab 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1355,6 +1355,8 @@ const char *iwl_mvm_get_tx_fail_reason(u32 status);
 static inline const char *iwl_mvm_get_tx_fail_reason(u32 status) { return ""; }
 #endif
 int iwl_mvm_flush_tx_path(struct iwl_mvm *mvm, u32 tfd_msk, u32 flags);
+int iwl_mvm_flush_sta(struct iwl_mvm *mvm, void *sta, bool int_sta, u32 flags);
+
 void iwl_mvm_async_handlers_purge(struct iwl_mvm *mvm);
 
 static inline void iwl_mvm_set_tx_cmd_ccmp(struct ieee80211_tx_info *info,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index f5c786ddc526..bf105c6572ba 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -1611,7 +1611,7 @@ int iwl_mvm_rm_sta(struct iwl_mvm *mvm,
 		if (ret)
 			return ret;
 		/* flush its queues here since we are freeing mvm_sta */
-		ret = iwl_mvm_flush_tx_path(mvm, mvm_sta->tfd_queue_msk, 0);
+		ret = iwl_mvm_flush_sta(mvm, mvm_sta, false, 0);
 		if (ret)
 			return ret;
 		ret = iwl_trans_wait_tx_queues_empty(mvm->trans,
@@ -1978,6 +1978,8 @@ static void iwl_mvm_free_bcast_sta_queues(struct iwl_mvm *mvm,
 
 	lockdep_assert_held(&mvm->mutex);
 
+	iwl_mvm_flush_sta(mvm, &mvmvif->bcast_sta, true, 0);
+
 	if (vif->type == NL80211_IFTYPE_AP ||
 	    vif->type == NL80211_IFTYPE_ADHOC)
 		iwl_mvm_disable_txq(mvm, vif->cab_queue, vif->cab_queue,
@@ -2176,6 +2178,8 @@ int iwl_mvm_rm_mcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 	if (!iwl_mvm_is_dqa_supported(mvm))
 		return 0;
 
+	iwl_mvm_flush_sta(mvm, &mvmvif->mcast_sta, true, 0);
+
 	iwl_mvm_disable_txq(mvm, mvmvif->cab_queue, vif->cab_queue,
 			    IWL_MAX_TID_COUNT, 0);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
index 2c12789e7550..3e4fa853b44d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
@@ -130,7 +130,10 @@ void iwl_mvm_roc_done_wk(struct work_struct *wk)
 	 * issue as it will have to complete before the next command is
 	 * executed, and a new time event means a new command.
 	 */
-	iwl_mvm_flush_tx_path(mvm, queues, CMD_ASYNC);
+	if (iwl_mvm_is_dqa_supported(mvm))
+		iwl_mvm_flush_sta(mvm, &mvm->aux_sta, true, CMD_ASYNC);
+	else
+		iwl_mvm_flush_tx_path(mvm, queues, CMD_ASYNC);
 }
 
 static void iwl_mvm_roc_finished(struct iwl_mvm *mvm)
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index bcaceb64a6e8..aa76c8baecce 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -1884,3 +1884,20 @@ int iwl_mvm_flush_tx_path(struct iwl_mvm *mvm, u32 tfd_msk, u32 flags)
 		IWL_ERR(mvm, "Failed to send flush command (%d)\n", ret);
 	return ret;
 }
+
+int iwl_mvm_flush_sta(struct iwl_mvm *mvm, void *sta, bool int_sta, u32 flags)
+{
+	u32 mask;
+
+	if (int_sta) {
+		struct iwl_mvm_int_sta *int_sta = sta;
+
+		mask = int_sta->tfd_queue_msk;
+	} else {
+		struct iwl_mvm_sta *mvm_sta = sta;
+
+		mask = mvm_sta->tfd_queue_msk;
+	}
+
+	return iwl_mvm_flush_tx_path(mvm, mask, flags);
+}
-- 
2.11.0
