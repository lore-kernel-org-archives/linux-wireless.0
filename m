Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:53168 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1758185AbdJMNZR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Oct 2017 09:25:17 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 13 Oct 2017 16:24:56 +0300
Message-Id: <20171013132502.10473-4-luca@coelho.fi> (sfid-20171013_152606_021386_C2B8098F)
In-Reply-To: <20171013132502.10473-1-luca@coelho.fi>
References: <20171013132502.10473-1-luca@coelho.fi>
Subject: [PATCH 3/9] iwlwifi: mvm: pass baid_data to iwl_mvm_release_frames()
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

All callers of iwl_mvm_release_frames() already have the baid_data
pointer, so we don't need to (re)calculate it inside the function.
Just pass it instead.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index fea7b965ea49..8e4f3b0a12cd 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -407,11 +407,10 @@ static bool iwl_mvm_is_sn_less(u16 sn1, u16 sn2, u16 buffer_size)
 static void iwl_mvm_release_frames(struct iwl_mvm *mvm,
 				   struct ieee80211_sta *sta,
 				   struct napi_struct *napi,
+				   struct iwl_mvm_baid_data *baid_data,
 				   struct iwl_mvm_reorder_buffer *reorder_buf,
 				   u16 nssn)
 {
-	struct iwl_mvm_baid_data *baid_data =
-		iwl_mvm_baid_data_from_reorder_buf(reorder_buf);
 	struct iwl_mvm_reorder_buf_entry *entries =
 		&baid_data->entries[reorder_buf->queue *
 				    baid_data->entries_per_queue];
@@ -515,7 +514,7 @@ void iwl_mvm_reorder_timer_expired(unsigned long data)
 			     sta_id, sn);
 		iwl_mvm_event_frame_timeout_callback(buf->mvm, mvmsta->vif,
 						     sta, baid_data->tid);
-		iwl_mvm_release_frames(buf->mvm, sta, NULL, buf, sn);
+		iwl_mvm_release_frames(buf->mvm, sta, NULL, baid_data, buf, sn);
 		rcu_read_unlock();
 	} else {
 		/*
@@ -555,7 +554,7 @@ static void iwl_mvm_del_ba(struct iwl_mvm *mvm, int queue,
 
 	/* release all frames that are in the reorder buffer to the stack */
 	spin_lock_bh(&reorder_buf->lock);
-	iwl_mvm_release_frames(mvm, sta, NULL, reorder_buf,
+	iwl_mvm_release_frames(mvm, sta, NULL, ba_data, reorder_buf,
 			       ieee80211_sn_add(reorder_buf->head_sn,
 						reorder_buf->buf_size));
 	spin_unlock_bh(&reorder_buf->lock);
@@ -683,7 +682,7 @@ static bool iwl_mvm_reorder(struct iwl_mvm *mvm,
 	}
 
 	if (ieee80211_is_back_req(hdr->frame_control)) {
-		iwl_mvm_release_frames(mvm, sta, napi, buffer, nssn);
+		iwl_mvm_release_frames(mvm, sta, napi, baid_data, buffer, nssn);
 		goto drop;
 	}
 
@@ -698,7 +697,8 @@ static bool iwl_mvm_reorder(struct iwl_mvm *mvm,
 				buffer->buf_size)) {
 		u16 min_sn = ieee80211_sn_less(sn, nssn) ? sn : nssn;
 
-		iwl_mvm_release_frames(mvm, sta, napi, buffer, min_sn);
+		iwl_mvm_release_frames(mvm, sta, napi, baid_data, buffer,
+				       min_sn);
 	}
 
 	/* drop any oudated packets */
@@ -755,7 +755,7 @@ static bool iwl_mvm_reorder(struct iwl_mvm *mvm,
 	 * release notification with up to date NSSN.
 	 */
 	if (!amsdu || last_subframe)
-		iwl_mvm_release_frames(mvm, sta, napi, buffer, nssn);
+		iwl_mvm_release_frames(mvm, sta, napi, baid_data, buffer, nssn);
 
 	spin_unlock_bh(&buffer->lock);
 	return true;
@@ -1075,7 +1075,7 @@ void iwl_mvm_rx_frame_release(struct iwl_mvm *mvm, struct napi_struct *napi,
 	reorder_buf = &ba_data->reorder_buf[queue];
 
 	spin_lock_bh(&reorder_buf->lock);
-	iwl_mvm_release_frames(mvm, sta, napi, reorder_buf,
+	iwl_mvm_release_frames(mvm, sta, napi, ba_data, reorder_buf,
 			       le16_to_cpu(release->nssn));
 	spin_unlock_bh(&reorder_buf->lock);
 
-- 
2.14.2
