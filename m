Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:54332 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1954311AbdDYUaK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Apr 2017 16:30:10 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 25 Apr 2017 23:22:30 +0300
Message-Id: <20170425202243.7844-13-luca@coelho.fi> (sfid-20170425_223021_069730_FFDB3338)
In-Reply-To: <20170425202243.7844-1-luca@coelho.fi>
References: <20170425202243.7844-1-luca@coelho.fi>
Subject: [PATCH 12/25] iwlwifi: mvm: move internally to use bigger INVALID_TXQ
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

We can't use IEEE80211_INVAL_HW_QUEUE to mark a queue as
invalid since 255 will be a valid value for a TVQM queue
index.
Use IWL_MVM_INVALID_QUEUE instead for accessing txq_id.
reserved_queue can stay a u8 since reserved_queue is not
used when TVQM is enabled.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h      |  2 ++
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c      | 12 ++++++------
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c       |  6 +++---
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c    |  2 +-
 5 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index f35f295d0c81..8ee5cf1419f4 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -2363,7 +2363,7 @@ static void __iwl_mvm_mac_sta_notify(struct ieee80211_hw *hw,
 		    tid_data->state != IWL_EMPTYING_HW_QUEUE_DELBA)
 			continue;
 
-		if (tid_data->txq_id == IEEE80211_INVAL_HW_QUEUE)
+		if (tid_data->txq_id == IWL_MVM_INVALID_QUEUE)
 			continue;
 
 		__set_bit(tid_data->txq_id, &txqs);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 1dbe37f8b08c..ab4864f2f4cb 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -717,6 +717,8 @@ enum iwl_mvm_queue_status {
 };
 
 #define IWL_MVM_DQA_QUEUE_TIMEOUT	(5 * HZ)
+#define IWL_MVM_INVALID_QUEUE		0xFFFF
+
 #define IWL_MVM_NUM_CIPHERS             10
 
 #ifdef CONFIG_ACPI
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 2d5d1fc10013..99fa6b17a4a0 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -464,7 +464,7 @@ static int iwl_mvm_remove_sta_queue_marking(struct iwl_mvm *mvm, int queue)
 	for_each_set_bit(tid, &tid_bitmap, IWL_MAX_TID_COUNT + 1) {
 		if (mvmsta->tid_data[tid].state == IWL_AGG_ON)
 			disable_agg_tids |= BIT(tid);
-		mvmsta->tid_data[tid].txq_id = IEEE80211_INVAL_HW_QUEUE;
+		mvmsta->tid_data[tid].txq_id = IWL_MVM_INVALID_QUEUE;
 	}
 
 	mvmsta->tfd_queue_msk &= ~BIT(queue); /* Don't use this queue anymore */
@@ -1086,7 +1086,7 @@ static void iwl_mvm_tx_deferred_stream(struct iwl_mvm *mvm,
 	ac = iwl_mvm_tid_to_ac_queue(tid);
 	mac_queue = IEEE80211_SKB_CB(skb)->hw_queue;
 
-	if (tid_data->txq_id == IEEE80211_INVAL_HW_QUEUE &&
+	if (tid_data->txq_id == IWL_MVM_INVALID_QUEUE &&
 	    iwl_mvm_sta_alloc_queue(mvm, sta, ac, tid, hdr)) {
 		IWL_ERR(mvm,
 			"Can't alloc TXQ for sta %d tid %d - dropping frame\n",
@@ -1267,7 +1267,7 @@ static void iwl_mvm_realloc_queues_after_restart(struct iwl_mvm *mvm,
 		int ac;
 		u8 mac_queue;
 
-		if (txq_id == IEEE80211_INVAL_HW_QUEUE)
+		if (txq_id == IWL_MVM_INVALID_QUEUE)
 			continue;
 
 		skb_queue_head_init(&tid_data->deferred_tx_frames);
@@ -1375,7 +1375,7 @@ int iwl_mvm_add_sta(struct iwl_mvm *mvm,
 		 * Mark all queues for this STA as unallocated and defer TX
 		 * frames until the queue is allocated
 		 */
-		mvm_sta->tid_data[i].txq_id = IEEE80211_INVAL_HW_QUEUE;
+		mvm_sta->tid_data[i].txq_id = IWL_MVM_INVALID_QUEUE;
 		skb_queue_head_init(&mvm_sta->tid_data[i].deferred_tx_frames);
 	}
 	mvm_sta->deferred_traffic_tid_map = 0;
@@ -1574,13 +1574,13 @@ static void iwl_mvm_disable_sta_queues(struct iwl_mvm *mvm,
 	lockdep_assert_held(&mvm->mutex);
 
 	for (i = 0; i < ARRAY_SIZE(mvm_sta->tid_data); i++) {
-		if (mvm_sta->tid_data[i].txq_id == IEEE80211_INVAL_HW_QUEUE)
+		if (mvm_sta->tid_data[i].txq_id == IWL_MVM_INVALID_QUEUE)
 			continue;
 
 		ac = iwl_mvm_tid_to_ac_queue(i);
 		iwl_mvm_disable_txq(mvm, mvm_sta->tid_data[i].txq_id,
 				    vif->hw_queue[ac], i, 0);
-		mvm_sta->tid_data[i].txq_id = IEEE80211_INVAL_HW_QUEUE;
+		mvm_sta->tid_data[i].txq_id = IWL_MVM_INVALID_QUEUE;
 	}
 }
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 06bd7cc562ff..5e305d391ffe 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -920,7 +920,7 @@ static int iwl_mvm_tx_mpdu(struct iwl_mvm *mvm, struct sk_buff *skb,
 	__le16 fc;
 	u16 seq_number = 0;
 	u8 tid = IWL_MAX_TID_COUNT;
-	u8 txq_id = info->hw_queue;
+	u16 txq_id = info->hw_queue;
 	bool is_ampdu = false;
 	int hdrlen;
 
@@ -990,11 +990,11 @@ static int iwl_mvm_tx_mpdu(struct iwl_mvm *mvm, struct sk_buff *skb,
 	WARN_ON_ONCE(info->flags & IEEE80211_TX_CTL_SEND_AFTER_DTIM);
 
 	/* Check if TXQ needs to be allocated or re-activated */
-	if (unlikely(txq_id == IEEE80211_INVAL_HW_QUEUE ||
+	if (unlikely(txq_id == IWL_MVM_INVALID_QUEUE ||
 		     !mvmsta->tid_data[tid].is_tid_active) &&
 	    iwl_mvm_is_dqa_supported(mvm)) {
 		/* If TXQ needs to be allocated... */
-		if (txq_id == IEEE80211_INVAL_HW_QUEUE) {
+		if (txq_id == IWL_MVM_INVALID_QUEUE) {
 			iwl_mvm_tx_add_stream(mvm, mvmsta, tid, skb);
 
 			/*
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index 175e927493d6..0e594899c615 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -1203,7 +1203,7 @@ static void iwl_mvm_remove_inactive_tids(struct iwl_mvm *mvm,
 	for_each_set_bit(tid, &tid_bitmap, IWL_MAX_TID_COUNT + 1) {
 		int mac_queue = mvmsta->vif->hw_queue[tid_to_mac80211_ac[tid]];
 
-		mvmsta->tid_data[tid].txq_id = IEEE80211_INVAL_HW_QUEUE;
+		mvmsta->tid_data[tid].txq_id = IWL_MVM_INVALID_QUEUE;
 		mvm->queue_info[queue].hw_queue_to_mac80211 &= ~BIT(mac_queue);
 		mvm->queue_info[queue].hw_queue_refcount--;
 		mvm->queue_info[queue].tid_bitmap &= ~BIT(tid);
-- 
2.11.0
