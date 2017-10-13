Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:53160 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1758179AbdJMNZR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Oct 2017 09:25:17 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 13 Oct 2017 16:24:55 +0300
Message-Id: <20171013132502.10473-3-luca@coelho.fi> (sfid-20171013_152605_400627_EBAC9867)
In-Reply-To: <20171013132502.10473-1-luca@coelho.fi>
References: <20171013132502.10473-1-luca@coelho.fi>
Subject: [PATCH 2/9] iwlwifi: mvm: remove duplicated fields in mvm reorder buffer
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

The reason station id and tid fields are both in baid data and
in the reorder buffer per queue is that we couldn't access the
baid_data in the reorder timer functions.
Now that we do some pointer math and access it anyway, those
fields can be removed.
This save some space and some code.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  | 4 ----
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 7 ++++---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c  | 6 +-----
 3 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index f008d5f4c585..5e37ec9e786e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -585,11 +585,9 @@ enum iwl_mvm_tdls_cs_state {
  * @head_sn: reorder window head sn
  * @num_stored: number of mpdus stored in the buffer
  * @buf_size: the reorder buffer size as set by the last addba request
- * @sta_id: sta id of this reorder buffer
  * @queue: queue of this reorder buffer
  * @last_amsdu: track last ASMDU SN for duplication detection
  * @last_sub_index: track ASMDU sub frame index for duplication detection
- * @tid: the tid
  * @reorder_timer: timer for frames are in the reorder buffer. For AMSDU
  *	it is the time of last received sub-frame
  * @removed: prevent timer re-arming
@@ -601,11 +599,9 @@ struct iwl_mvm_reorder_buffer {
 	u16 head_sn;
 	u16 num_stored;
 	u8 buf_size;
-	u8 sta_id;
 	int queue;
 	u16 last_amsdu;
 	u8 last_sub_index;
-	u8 tid;
 	struct timer_list reorder_timer;
 	bool removed;
 	bool valid;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 14c2d366f256..fea7b965ea49 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -503,17 +503,18 @@ void iwl_mvm_reorder_timer_expired(unsigned long data)
 	if (expired) {
 		struct ieee80211_sta *sta;
 		struct iwl_mvm_sta *mvmsta;
+		u8 sta_id = baid_data->sta_id;
 
 		rcu_read_lock();
-		sta = rcu_dereference(buf->mvm->fw_id_to_mac_id[buf->sta_id]);
+		sta = rcu_dereference(buf->mvm->fw_id_to_mac_id[sta_id]);
 		mvmsta = iwl_mvm_sta_from_mac80211(sta);
 
 		/* SN is set to the last expired frame + 1 */
 		IWL_DEBUG_HT(buf->mvm,
 			     "Releasing expired frames for sta %u, sn %d\n",
-			     buf->sta_id, sn);
+			     sta_id, sn);
 		iwl_mvm_event_frame_timeout_callback(buf->mvm, mvmsta->vif,
-						     sta, buf->tid);
+						     sta, baid_data->tid);
 		iwl_mvm_release_frames(buf->mvm, sta, NULL, buf, sn);
 		rcu_read_unlock();
 	} else {
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index a26cf8e89036..9d0110ee6e54 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -2137,7 +2137,6 @@ static void iwl_mvm_free_reorder(struct iwl_mvm *mvm,
 }
 
 static void iwl_mvm_init_reorder_buffer(struct iwl_mvm *mvm,
-					u32 sta_id,
 					struct iwl_mvm_baid_data *data,
 					u16 ssn, u8 buf_size)
 {
@@ -2161,8 +2160,6 @@ static void iwl_mvm_init_reorder_buffer(struct iwl_mvm *mvm,
 		spin_lock_init(&reorder_buf->lock);
 		reorder_buf->mvm = mvm;
 		reorder_buf->queue = i;
-		reorder_buf->sta_id = sta_id;
-		reorder_buf->tid = data->tid;
 		reorder_buf->valid = false;
 		for (j = 0; j < reorder_buf->buf_size; j++)
 			__skb_queue_head_init(&entries[j].e.frames);
@@ -2294,8 +2291,7 @@ int iwl_mvm_sta_rx_agg(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 			mod_timer(&baid_data->session_timer,
 				  TU_TO_EXP_TIME(timeout * 2));
 
-		iwl_mvm_init_reorder_buffer(mvm, mvm_sta->sta_id,
-					    baid_data, ssn, buf_size);
+		iwl_mvm_init_reorder_buffer(mvm, baid_data, ssn, buf_size);
 		/*
 		 * protect the BA data with RCU to cover a case where our
 		 * internal RX sync mechanism will timeout (not that it's
-- 
2.14.2
