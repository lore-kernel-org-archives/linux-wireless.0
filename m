Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f176.google.com ([209.85.215.176]:34495 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512AbaBCUjh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 15:39:37 -0500
Received: by mail-ea0-f176.google.com with SMTP id h14so3947683eaj.7
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 12:39:36 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 6/8] iwlwifi: mvm: don't leak a station when we drain
Date: Mon,  3 Feb 2014 22:39:20 +0200
Message-Id: <1391459962-7381-6-git-send-email-egrumbach@gmail.com> (sfid-20140203_213942_824797_50CB8F93)
In-Reply-To: <52EFFCE8.6070505@gmail.com>
References: <52EFFCE8.6070505@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

We had a bug that prevented us from removing a station
after we entered the drain flow:

We assign sta to be NULL if it was an error value.
Then we tested it against -EBUSY, but forget to retrieve
the value again from mvm->fw_id_to_mac_id[sta_id].

Due to this bug, we ended up never removing the STA from
the firmware. This led to an firmware assert when we remove
the GO vif.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/tx.c |   73 +++++++++++++++++----------------
 1 file changed, 37 insertions(+), 36 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/tx.c b/drivers/net/wireless/iwlwifi/mvm/tx.c
index 90378c2..4df12fa 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tx.c
@@ -659,8 +659,14 @@ static void iwl_mvm_rx_tx_cmd_single(struct iwl_mvm *mvm,
 	rcu_read_lock();
 
 	sta = rcu_dereference(mvm->fw_id_to_mac_id[sta_id]);
+	/*
+	 * sta can't be NULL otherwise it'd mean that the sta has been freed in
+	 * the firmware while we still have packets for it in the Tx queues.
+	 */
+	if (WARN_ON_ONCE(!sta))
+		goto out;
 
-	if (!IS_ERR_OR_NULL(sta)) {
+	if (!IS_ERR(sta)) {
 		mvmsta = iwl_mvm_sta_from_mac80211(sta);
 
 		if (tid != IWL_TID_NON_QOS) {
@@ -675,7 +681,6 @@ static void iwl_mvm_rx_tx_cmd_single(struct iwl_mvm *mvm,
 			spin_unlock_bh(&mvmsta->lock);
 		}
 	} else {
-		sta = NULL;
 		mvmsta = NULL;
 	}
 
@@ -683,42 +688,38 @@ static void iwl_mvm_rx_tx_cmd_single(struct iwl_mvm *mvm,
 	 * If the txq is not an AMPDU queue, there is no chance we freed
 	 * several skbs. Check that out...
 	 */
-	if (txq_id < mvm->first_agg_queue && !WARN_ON(skb_freed > 1) &&
-	    atomic_sub_and_test(skb_freed, &mvm->pending_frames[sta_id])) {
-		if (mvmsta) {
-			/*
-			 * If there are no pending frames for this STA, notify
-			 * mac80211 that this station can go to sleep in its
-			 * STA table.
-			 */
-			if (mvmsta->vif->type == NL80211_IFTYPE_AP)
-				ieee80211_sta_block_awake(mvm->hw, sta, false);
-			/*
-			 * We might very well have taken mvmsta pointer while
-			 * the station was being removed. The remove flow might
-			 * have seen a pending_frame (because we didn't take
-			 * the lock) even if now the queues are drained. So make
-			 * really sure now that this the station is not being
-			 * removed. If it is, run the drain worker to remove it.
-			 */
-			spin_lock_bh(&mvmsta->lock);
-			sta = rcu_dereference(mvm->fw_id_to_mac_id[sta_id]);
-			if (!sta || PTR_ERR(sta) == -EBUSY) {
-				/*
-				 * Station disappeared in the meantime:
-				 * so we are draining.
-				 */
-				set_bit(sta_id, mvm->sta_drained);
-				schedule_work(&mvm->sta_drained_wk);
-			}
-			spin_unlock_bh(&mvmsta->lock);
-		} else if (!mvmsta && PTR_ERR(sta) == -EBUSY) {
-			/* Tx response without STA, so we are draining */
-			set_bit(sta_id, mvm->sta_drained);
-			schedule_work(&mvm->sta_drained_wk);
-		}
+	if (txq_id >= mvm->first_agg_queue)
+		goto out;
+
+	/* We can't free more than one frame at once on a shared queue */
+	WARN_ON(skb_freed > 1);
+
+	/* If we have still frames from this STA nothing to do here */
+	if (!atomic_sub_and_test(skb_freed, &mvm->pending_frames[sta_id]))
+		goto out;
+
+	if (mvmsta && mvmsta->vif->type == NL80211_IFTYPE_AP) {
+		/*
+		 * If there are no pending frames for this STA, notify
+		 * mac80211 that this station can go to sleep in its
+		 * STA table.
+		 * If mvmsta is not NULL, sta is valid.
+		 */
+		ieee80211_sta_block_awake(mvm->hw, sta, false);
+	}
+
+	if (PTR_ERR(sta) == -EBUSY || PTR_ERR(sta) == -ENOENT) {
+		/*
+		 * We are draining and this was the last packet - pre_rcu_remove
+		 * has been called already. We might be after the
+		 * synchronize_net already.
+		 * Don't rely on iwl_mvm_rm_sta to see the empty Tx queues.
+		 */
+		set_bit(sta_id, mvm->sta_drained);
+		schedule_work(&mvm->sta_drained_wk);
 	}
 
+out:
 	rcu_read_unlock();
 }
 
-- 
1.7.9.5

