Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40612 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751410AbcEJUJI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2016 16:09:08 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com
Date: Tue, 10 May 2016 23:06:05 +0300
Message-Id: <1462910797-20303-9-git-send-email-luca@coelho.fi> (sfid-20160510_220911_889013_B908B832)
In-Reply-To: <1462910797-20303-1-git-send-email-luca@coelho.fi>
References: <1462910585.25219.7.camel@coelho.fi>
 <1462910797-20303-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 09/41] iwlwifi: mvm: add reorder timeout per frame
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Add a timer in order to release expired frames from the
reorder buffer.
This is needed since some APs do not retransmit frames
to fill in the reorder holes and in TCP it results with
a complete stall of traffic.

This has a few side effects on the general design:

The nssn may not reflect the the head of the reorder buffer.
This situation is valid, and packets with SN lower than the
reorder buffer head will be dropped.

Another side effect is that since the reorder timer might expire
we need to lock the reorder buffer.
This however is fine since the locking is only inside a
single reorder buffer between RX path and reorder timeout and
there is no outside contention.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  | 12 ++++
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 81 ++++++++++++++++++++++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c  | 23 +++++++-
 3 files changed, 114 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 8272e54..3c331bd 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -623,6 +623,12 @@ struct iwl_mvm_shared_mem_cfg {
  * @last_amsdu: track last ASMDU SN for duplication detection
  * @last_sub_index: track ASMDU sub frame index for duplication detection
  * @entries: list of skbs stored
+ * @reorder_time: time the packet was stored in the reorder buffer
+ * @reorder_timer: timer for frames are in the reorder buffer. For AMSDU
+ *	it is the time of last received sub-frame
+ * @removed: prevent timer re-arming
+ * @lock: protect reorder buffer internal state
+ * @mvm: mvm pointer, needed for frame timer context
  */
 struct iwl_mvm_reorder_buffer {
 	u16 head_sn;
@@ -633,6 +639,11 @@ struct iwl_mvm_reorder_buffer {
 	u16 last_amsdu;
 	u8 last_sub_index;
 	struct sk_buff_head entries[IEEE80211_MAX_AMPDU_BUF];
+	unsigned long reorder_time[IEEE80211_MAX_AMPDU_BUF];
+	struct timer_list reorder_timer;
+	bool removed;
+	spinlock_t lock;
+	struct iwl_mvm *mvm;
 } ____cacheline_aligned_in_smp;
 
 /**
@@ -1682,6 +1693,7 @@ void iwl_mvm_tdls_ch_switch_work(struct work_struct *work);
 void iwl_mvm_sync_rx_queues_internal(struct iwl_mvm *mvm,
 				     struct iwl_mvm_internal_rxq_notif *notif,
 				     u32 size);
+void iwl_mvm_reorder_timer_expired(unsigned long data);
 struct ieee80211_vif *iwl_mvm_get_bss_vif(struct iwl_mvm *mvm);
 
 void iwl_mvm_nic_restart(struct iwl_mvm *mvm, bool fw_error);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 4f320dc..ed187af 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -395,6 +395,8 @@ int iwl_mvm_notify_rx_queue(struct iwl_mvm *mvm, u32 rxq_mask,
 	return ret;
 }
 
+#define RX_REORDER_BUF_TIMEOUT_MQ (HZ / 10)
+
 static void iwl_mvm_release_frames(struct iwl_mvm *mvm,
 				   struct ieee80211_sta *sta,
 				   struct napi_struct *napi,
@@ -403,6 +405,12 @@ static void iwl_mvm_release_frames(struct iwl_mvm *mvm,
 {
 	u16 ssn = reorder_buf->head_sn;
 
+	lockdep_assert_held(&reorder_buf->lock);
+
+	/* ignore nssn smaller than head sn - this can happen due to timeout */
+	if (ieee80211_sn_less(nssn, ssn))
+		return;
+
 	while (ieee80211_sn_less(ssn, nssn)) {
 		int index = ssn % reorder_buf->buf_size;
 		struct sk_buff_head *skb_list = &reorder_buf->entries[index];
@@ -422,6 +430,66 @@ static void iwl_mvm_release_frames(struct iwl_mvm *mvm,
 		}
 	}
 	reorder_buf->head_sn = nssn;
+
+	if (reorder_buf->num_stored && !reorder_buf->removed) {
+		u16 index = reorder_buf->head_sn % reorder_buf->buf_size;
+
+		while (!skb_peek_tail(&reorder_buf->entries[index]))
+			index = (index + 1) % reorder_buf->buf_size;
+		/* modify timer to match next frame's expiration time */
+		mod_timer(&reorder_buf->reorder_timer,
+			  reorder_buf->reorder_time[index] + 1 +
+			  RX_REORDER_BUF_TIMEOUT_MQ);
+	} else {
+		del_timer(&reorder_buf->reorder_timer);
+	}
+}
+
+void iwl_mvm_reorder_timer_expired(unsigned long data)
+{
+	struct iwl_mvm_reorder_buffer *buf = (void *)data;
+	int i;
+	u16 sn = 0, index = 0;
+	bool expired = false;
+
+	spin_lock_bh(&buf->lock);
+
+	if (!buf->num_stored || buf->removed) {
+		spin_unlock_bh(&buf->lock);
+		return;
+	}
+
+	for (i = 0; i < buf->buf_size ; i++) {
+		index = (buf->head_sn + i) % buf->buf_size;
+
+		if (!skb_peek_tail(&buf->entries[index]))
+			continue;
+		if (!time_after(jiffies, buf->reorder_time[index] +
+				RX_REORDER_BUF_TIMEOUT_MQ))
+			break;
+		expired = true;
+		sn = ieee80211_sn_add(buf->head_sn, i + 1);
+	}
+
+	if (expired) {
+		struct ieee80211_sta *sta;
+
+		rcu_read_lock();
+		sta = rcu_dereference(buf->mvm->fw_id_to_mac_id[buf->sta_id]);
+		/* SN is set to the last expired frame + 1 */
+		iwl_mvm_release_frames(buf->mvm, sta, NULL, buf, sn);
+		rcu_read_unlock();
+	} else if (buf->num_stored) {
+		/*
+		 * If no frame expired and there are stored frames, index is now
+		 * pointing to the first unexpired frame - modify timer
+		 * accordingly to this frame.
+		 */
+		mod_timer(&buf->reorder_timer,
+			  buf->reorder_time[index] +
+			  1 + RX_REORDER_BUF_TIMEOUT_MQ);
+	}
+	spin_unlock_bh(&buf->lock);
 }
 
 static void iwl_mvm_del_ba(struct iwl_mvm *mvm, int queue,
@@ -448,9 +516,12 @@ static void iwl_mvm_del_ba(struct iwl_mvm *mvm, int queue,
 	reorder_buf = &ba_data->reorder_buf[queue];
 
 	/* release all frames that are in the reorder buffer to the stack */
+	spin_lock_bh(&reorder_buf->lock);
 	iwl_mvm_release_frames(mvm, sta, NULL, reorder_buf,
 			       ieee80211_sn_add(reorder_buf->head_sn,
 						reorder_buf->buf_size));
+	spin_unlock_bh(&reorder_buf->lock);
+	del_timer_sync(&reorder_buf->reorder_timer);
 
 out:
 	rcu_read_unlock();
@@ -545,6 +616,8 @@ static bool iwl_mvm_reorder(struct iwl_mvm *mvm,
 
 	buffer = &baid_data->reorder_buf[queue];
 
+	spin_lock_bh(&buffer->lock);
+
 	/*
 	 * If there was a significant jump in the nssn - adjust.
 	 * If the SN is smaller than the NSSN it might need to first go into
@@ -564,8 +637,10 @@ static bool iwl_mvm_reorder(struct iwl_mvm *mvm,
 
 	/* release immediately if allowed by nssn and no stored frames */
 	if (!buffer->num_stored && ieee80211_sn_less(sn, nssn)) {
-		buffer->head_sn = nssn;
+		if (ieee80211_sn_less(buffer->head_sn, nssn))
+			buffer->head_sn = nssn;
 		/* No need to update AMSDU last SN - we are moving the head */
+		spin_unlock_bh(&buffer->lock);
 		return false;
 	}
 
@@ -589,16 +664,20 @@ static bool iwl_mvm_reorder(struct iwl_mvm *mvm,
 	/* put in reorder buffer */
 	__skb_queue_tail(&buffer->entries[index], skb);
 	buffer->num_stored++;
+	buffer->reorder_time[index] = jiffies;
+
 	if (amsdu) {
 		buffer->last_amsdu = sn;
 		buffer->last_sub_index = sub_frame_idx;
 	}
 
 	iwl_mvm_release_frames(mvm, sta, napi, buffer, nssn);
+	spin_unlock_bh(&buffer->lock);
 	return true;
 
 drop:
 	kfree_skb(skb);
+	spin_unlock_bh(&buffer->lock);
 	return true;
 }
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 2b83911..e7f1da5 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -1189,8 +1189,11 @@ static void iwl_mvm_free_reorder(struct iwl_mvm *mvm,
 		struct iwl_mvm_reorder_buffer *reorder_buf =
 			&data->reorder_buf[i];
 
-		if (likely(!reorder_buf->num_stored))
+		spin_lock_bh(&reorder_buf->lock);
+		if (likely(!reorder_buf->num_stored)) {
+			spin_unlock_bh(&reorder_buf->lock);
 			continue;
+		}
 
 		/*
 		 * This shouldn't happen in regular DELBA since the internal
@@ -1201,6 +1204,17 @@ static void iwl_mvm_free_reorder(struct iwl_mvm *mvm,
 
 		for (j = 0; j < reorder_buf->buf_size; j++)
 			__skb_queue_purge(&reorder_buf->entries[j]);
+		/*
+		 * Prevent timer re-arm. This prevents a very far fetched case
+		 * where we timed out on the notification. There may be prior
+		 * RX frames pending in the RX queue before the notification
+		 * that might get processed between now and the actual deletion
+		 * and we would re-arm the timer although we are deleting the
+		 * reorder buffer.
+		 */
+		reorder_buf->removed = true;
+		spin_unlock_bh(&reorder_buf->lock);
+		del_timer_sync(&reorder_buf->reorder_timer);
 	}
 }
 
@@ -1219,6 +1233,13 @@ static void iwl_mvm_init_reorder_buffer(struct iwl_mvm *mvm,
 		reorder_buf->num_stored = 0;
 		reorder_buf->head_sn = ssn;
 		reorder_buf->buf_size = buf_size;
+		/* rx reorder timer */
+		reorder_buf->reorder_timer.function =
+			iwl_mvm_reorder_timer_expired;
+		reorder_buf->reorder_timer.data = (unsigned long)reorder_buf;
+		init_timer(&reorder_buf->reorder_timer);
+		spin_lock_init(&reorder_buf->lock);
+		reorder_buf->mvm = mvm;
 		reorder_buf->queue = i;
 		reorder_buf->sta_id = sta_id;
 		for (j = 0; j < reorder_buf->buf_size; j++)
-- 
2.8.1

