Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39988 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757576Ab1DXP4Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Apr 2011 11:56:16 -0400
Received: by bwz15 with SMTP id 15so1206145bwz.19
        for <linux-wireless@vger.kernel.org>; Sun, 24 Apr 2011 08:56:14 -0700 (PDT)
Message-Id: <d93982039621737cf58e2a45b79fd596938c6c3b.1303660092.git.chunkeey@googlemail.com> (sfid-20110424_175620_074789_7A8BE65F)
In-Reply-To: <060ac4fbe5b4c314227ae3867e1dce0919772ccd.1303660092.git.chunkeey@googlemail.com>
References: <060ac4fbe5b4c314227ae3867e1dce0919772ccd.1303660092.git.chunkeey@googlemail.com>
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Sun, 24 Apr 2011 17:44:19 +0200
Subject: [PATCH 2/2] carl9170: improve unicast PS buffering
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Using the ieee80211_sta_block allows the PS code
to handle awake->doze->awake transitions of our
clients in a race-free manner.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/ath/carl9170/carl9170.h |    2 +
 drivers/net/wireless/ath/carl9170/main.c     |   92 +--------------
 drivers/net/wireless/ath/carl9170/tx.c       |  157 +++++++++++++++++---------
 3 files changed, 112 insertions(+), 139 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/carl9170.h b/drivers/net/wireless/ath/carl9170/carl9170.h
index b0b3d02..71d6d07 100644
--- a/drivers/net/wireless/ath/carl9170/carl9170.h
+++ b/drivers/net/wireless/ath/carl9170/carl9170.h
@@ -460,6 +460,8 @@ struct carl9170_ba_stats {
 
 struct carl9170_sta_info {
 	bool ht_sta;
+	bool sleeping;
+	atomic_t pending_frames;
 	unsigned int ampdu_max_len;
 	struct carl9170_sta_tid *agg[CARL9170_NUM_TID];
 	struct carl9170_ba_stats stats[CARL9170_NUM_TID];
diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
index c10f132..a357281 100644
--- a/drivers/net/wireless/ath/carl9170/main.c
+++ b/drivers/net/wireless/ath/carl9170/main.c
@@ -1193,6 +1193,8 @@ static int carl9170_op_sta_add(struct ieee80211_hw *hw,
 	struct carl9170_sta_info *sta_info = (void *) sta->drv_priv;
 	unsigned int i;
 
+	atomic_set(&sta_info->pending_frames, 0);
+
 	if (sta->ht_cap.ht_supported) {
 		if (sta->ht_cap.ampdu_density > 6) {
 			/*
@@ -1571,99 +1573,17 @@ static void carl9170_op_sta_notify(struct ieee80211_hw *hw,
 				   enum sta_notify_cmd cmd,
 				   struct ieee80211_sta *sta)
 {
-	struct ar9170 *ar = hw->priv;
 	struct carl9170_sta_info *sta_info = (void *) sta->drv_priv;
-	struct sk_buff *skb, *tmp;
-	struct sk_buff_head free;
-	int i;
 
 	switch (cmd) {
 	case STA_NOTIFY_SLEEP:
-		/*
-		 * Since the peer is no longer listening, we have to return
-		 * as many SKBs as possible back to the mac80211 stack.
-		 * It will deal with the retry procedure, once the peer
-		 * has become available again.
-		 *
-		 * NB: Ideally, the driver should return the all frames in
-		 * the correct, ascending order. However, I think that this
-		 * functionality should be implemented in the stack and not
-		 * here...
-		 */
-
-		__skb_queue_head_init(&free);
-
-		if (sta->ht_cap.ht_supported) {
-			rcu_read_lock();
-			for (i = 0; i < CARL9170_NUM_TID; i++) {
-				struct carl9170_sta_tid *tid_info;
-
-				tid_info = rcu_dereference(sta_info->agg[i]);
-
-				if (!tid_info)
-					continue;
-
-				spin_lock_bh(&ar->tx_ampdu_list_lock);
-				if (tid_info->state >
-				    CARL9170_TID_STATE_SUSPEND)
-					tid_info->state =
-						CARL9170_TID_STATE_SUSPEND;
-				spin_unlock_bh(&ar->tx_ampdu_list_lock);
-
-				spin_lock_bh(&tid_info->lock);
-				while ((skb = __skb_dequeue(&tid_info->queue)))
-					__skb_queue_tail(&free, skb);
-				spin_unlock_bh(&tid_info->lock);
-			}
-			rcu_read_unlock();
-		}
-
-		for (i = 0; i < ar->hw->queues; i++) {
-			spin_lock_bh(&ar->tx_pending[i].lock);
-			skb_queue_walk_safe(&ar->tx_pending[i], skb, tmp) {
-				struct _carl9170_tx_superframe *super;
-				struct ieee80211_hdr *hdr;
-				struct ieee80211_tx_info *info;
-
-				super = (void *) skb->data;
-				hdr = (void *) super->frame_data;
-
-				if (compare_ether_addr(hdr->addr1, sta->addr))
-					continue;
-
-				__skb_unlink(skb, &ar->tx_pending[i]);
-
-				info = IEEE80211_SKB_CB(skb);
-				if (info->flags & IEEE80211_TX_CTL_AMPDU)
-					atomic_dec(&ar->tx_ampdu_upload);
-
-				carl9170_tx_status(ar, skb, false);
-			}
-			spin_unlock_bh(&ar->tx_pending[i].lock);
-		}
-
-		while ((skb = __skb_dequeue(&free)))
-			carl9170_tx_status(ar, skb, false);
-
+		sta_info->sleeping = true;
+		if (atomic_read(&sta_info->pending_frames))
+			ieee80211_sta_block_awake(hw, sta, true);
 		break;
 
 	case STA_NOTIFY_AWAKE:
-		if (!sta->ht_cap.ht_supported)
-			return;
-
-		rcu_read_lock();
-		for (i = 0; i < CARL9170_NUM_TID; i++) {
-			struct carl9170_sta_tid *tid_info;
-
-			tid_info = rcu_dereference(sta_info->agg[i]);
-
-			if (!tid_info)
-				continue;
-
-			if ((tid_info->state == CARL9170_TID_STATE_SUSPEND))
-				tid_info->state = CARL9170_TID_STATE_IDLE;
-		}
-		rcu_read_unlock();
+		sta_info->sleeping = false;
 		break;
 	}
 }
diff --git a/drivers/net/wireless/ath/carl9170/tx.c b/drivers/net/wireless/ath/carl9170/tx.c
index cb70ed7..bee2c92 100644
--- a/drivers/net/wireless/ath/carl9170/tx.c
+++ b/drivers/net/wireless/ath/carl9170/tx.c
@@ -104,6 +104,56 @@ static void carl9170_tx_accounting(struct ar9170 *ar, struct sk_buff *skb)
 	spin_unlock_bh(&ar->tx_stats_lock);
 }
 
+/* needs rcu_read_lock */
+static struct ieee80211_sta *__carl9170_get_tx_sta(struct ar9170 *ar,
+						   struct sk_buff *skb)
+{
+	struct _carl9170_tx_superframe *super = (void *) skb->data;
+	struct ieee80211_hdr *hdr = (void *) super->frame_data;
+	struct ieee80211_vif *vif;
+	unsigned int vif_id;
+
+	vif_id = (super->s.misc & CARL9170_TX_SUPER_MISC_VIF_ID) >>
+		 CARL9170_TX_SUPER_MISC_VIF_ID_S;
+
+	if (WARN_ON_ONCE(vif_id >= AR9170_MAX_VIRTUAL_MAC))
+		return NULL;
+
+	vif = rcu_dereference(ar->vif_priv[vif_id].vif);
+	if (unlikely(!vif))
+		return NULL;
+
+	/*
+	 * Normally we should use wrappers like ieee80211_get_DA to get
+	 * the correct peer ieee80211_sta.
+	 *
+	 * But there is a problem with indirect traffic (broadcasts, or
+	 * data which is designated for other stations) in station mode.
+	 * The frame will be directed to the AP for distribution and not
+	 * to the actual destination.
+	 */
+
+	return ieee80211_find_sta(vif, hdr->addr1);
+}
+
+static void carl9170_tx_ps_unblock(struct ar9170 *ar, struct sk_buff *skb)
+{
+	struct ieee80211_sta *sta;
+	struct carl9170_sta_info *sta_info;
+
+	rcu_read_lock();
+	sta = __carl9170_get_tx_sta(ar, skb);
+	if (unlikely(!sta))
+		goto out_rcu;
+
+	sta_info = (struct carl9170_sta_info *) sta->drv_priv;
+	if (atomic_dec_return(&sta_info->pending_frames) == 0)
+		ieee80211_sta_block_awake(ar->hw, sta, false);
+
+out_rcu:
+	rcu_read_unlock();
+}
+
 static void carl9170_tx_accounting_free(struct ar9170 *ar, struct sk_buff *skb)
 {
 	struct ieee80211_tx_info *txinfo;
@@ -135,6 +185,7 @@ static void carl9170_tx_accounting_free(struct ar9170 *ar, struct sk_buff *skb)
 	}
 
 	spin_unlock_bh(&ar->tx_stats_lock);
+
 	if (atomic_dec_and_test(&ar->tx_total_queued))
 		complete(&ar->tx_flush);
 }
@@ -329,13 +380,10 @@ static void carl9170_tx_status_process_ampdu(struct ar9170 *ar,
 {
 	struct _carl9170_tx_superframe *super = (void *) skb->data;
 	struct ieee80211_hdr *hdr = (void *) super->frame_data;
-	struct ieee80211_tx_info *tx_info;
 	struct carl9170_tx_info *ar_info;
-	struct carl9170_sta_info *sta_info;
 	struct ieee80211_sta *sta;
+	struct carl9170_sta_info *sta_info;
 	struct carl9170_sta_tid *tid_info;
-	struct ieee80211_vif *vif;
-	unsigned int vif_id;
 	u8 tid;
 
 	if (!(txinfo->flags & IEEE80211_TX_CTL_AMPDU) ||
@@ -343,30 +391,10 @@ static void carl9170_tx_status_process_ampdu(struct ar9170 *ar,
 	   (!(super->f.mac_control & cpu_to_le16(AR9170_TX_MAC_AGGR))))
 		return;
 
-	tx_info = IEEE80211_SKB_CB(skb);
-	ar_info = (void *) tx_info->rate_driver_data;
-
-	vif_id = (super->s.misc & CARL9170_TX_SUPER_MISC_VIF_ID) >>
-		 CARL9170_TX_SUPER_MISC_VIF_ID_S;
-
-	if (WARN_ON_ONCE(vif_id >= AR9170_MAX_VIRTUAL_MAC))
-		return;
+	ar_info = (void *) txinfo->rate_driver_data;
 
 	rcu_read_lock();
-	vif = rcu_dereference(ar->vif_priv[vif_id].vif);
-	if (unlikely(!vif))
-		goto out_rcu;
-
-	/*
-	 * Normally we should use wrappers like ieee80211_get_DA to get
-	 * the correct peer ieee80211_sta.
-	 *
-	 * But there is a problem with indirect traffic (broadcasts, or
-	 * data which is designated for other stations) in station mode.
-	 * The frame will be directed to the AP for distribution and not
-	 * to the actual destination.
-	 */
-	sta = ieee80211_find_sta(vif, hdr->addr1);
+	sta = __carl9170_get_tx_sta(ar, skb);
 	if (unlikely(!sta))
 		goto out_rcu;
 
@@ -427,6 +455,7 @@ void carl9170_tx_status(struct ar9170 *ar, struct sk_buff *skb,
 	if (txinfo->flags & IEEE80211_TX_CTL_AMPDU)
 		carl9170_tx_status_process_ampdu(ar, skb, txinfo);
 
+	carl9170_tx_ps_unblock(ar, skb);
 	carl9170_tx_put_skb(skb);
 }
 
@@ -540,11 +569,7 @@ static void carl9170_tx_ampdu_timeout(struct ar9170 *ar)
 	struct sk_buff *skb;
 	struct ieee80211_tx_info *txinfo;
 	struct carl9170_tx_info *arinfo;
-	struct _carl9170_tx_superframe *super;
 	struct ieee80211_sta *sta;
-	struct ieee80211_vif *vif;
-	struct ieee80211_hdr *hdr;
-	unsigned int vif_id;
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(iter, &ar->tx_ampdu_list, list) {
@@ -562,20 +587,7 @@ static void carl9170_tx_ampdu_timeout(struct ar9170 *ar)
 		    msecs_to_jiffies(CARL9170_QUEUE_TIMEOUT)))
 			goto unlock;
 
-		super = (void *) skb->data;
-		hdr = (void *) super->frame_data;
-
-		vif_id = (super->s.misc & CARL9170_TX_SUPER_MISC_VIF_ID) >>
-			 CARL9170_TX_SUPER_MISC_VIF_ID_S;
-
-		if (WARN_ON(vif_id >= AR9170_MAX_VIRTUAL_MAC))
-			goto unlock;
-
-		vif = rcu_dereference(ar->vif_priv[vif_id].vif);
-		if (WARN_ON(!vif))
-			goto unlock;
-
-		sta = ieee80211_find_sta(vif, hdr->addr1);
+		sta = __carl9170_get_tx_sta(ar, skb);
 		if (WARN_ON(!sta))
 			goto unlock;
 
@@ -1199,15 +1211,6 @@ static struct sk_buff *carl9170_tx_pick_skb(struct ar9170 *ar,
 	arinfo = (void *) info->rate_driver_data;
 
 	arinfo->timeout = jiffies;
-
-	/*
-	 * increase ref count to "2".
-	 * Ref counting is the easiest way to solve the race between
-	 * the the urb's completion routine: carl9170_tx_callback and
-	 * wlan tx status functions: carl9170_tx_status/janitor.
-	 */
-	carl9170_tx_get_skb(skb);
-
 	return skb;
 
 err_unlock:
@@ -1228,6 +1231,36 @@ void carl9170_tx_drop(struct ar9170 *ar, struct sk_buff *skb)
 	__carl9170_tx_process_status(ar, super->s.cookie, q);
 }
 
+static bool carl9170_tx_ps_drop(struct ar9170 *ar, struct sk_buff *skb)
+{
+	struct ieee80211_sta *sta;
+	struct carl9170_sta_info *sta_info;
+
+	rcu_read_lock();
+	sta = __carl9170_get_tx_sta(ar, skb);
+	if (!sta)
+		goto out_rcu;
+
+	sta_info = (void *) sta->drv_priv;
+	if (unlikely(sta_info->sleeping)) {
+		struct ieee80211_tx_info *tx_info;
+
+		rcu_read_unlock();
+
+		tx_info = IEEE80211_SKB_CB(skb);
+		if (tx_info->flags & IEEE80211_TX_CTL_AMPDU)
+			atomic_dec(&ar->tx_ampdu_upload);
+
+		tx_info->flags |= IEEE80211_TX_STAT_TX_FILTERED;
+		carl9170_tx_status(ar, skb, false);
+		return true;
+	}
+
+out_rcu:
+	rcu_read_unlock();
+	return false;
+}
+
 static void carl9170_tx(struct ar9170 *ar)
 {
 	struct sk_buff *skb;
@@ -1247,6 +1280,9 @@ static void carl9170_tx(struct ar9170 *ar)
 			if (unlikely(!skb))
 				break;
 
+			if (unlikely(carl9170_tx_ps_drop(ar, skb)))
+				continue;
+
 			atomic_inc(&ar->tx_total_pending);
 
 			q = __carl9170_get_queue(ar, i);
@@ -1256,6 +1292,16 @@ static void carl9170_tx(struct ar9170 *ar)
 			 */
 			skb_queue_tail(&ar->tx_status[q], skb);
 
+			/*
+			 * increase ref count to "2".
+			 * Ref counting is the easiest way to solve the
+			 * race between the urb's completion routine:
+			 *	carl9170_tx_callback
+			 * and wlan tx status functions:
+			 *	carl9170_tx_status/janitor.
+			 */
+			carl9170_tx_get_skb(skb);
+
 			carl9170_usb_tx(ar, skb);
 			schedule_garbagecollector = true;
 		}
@@ -1368,6 +1414,11 @@ void carl9170_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	 * all ressouces which are associated with the frame.
 	 */
 
+	if (sta) {
+		struct carl9170_sta_info *stai = (void *) sta->drv_priv;
+		atomic_inc(&stai->pending_frames);
+	}
+
 	if (info->flags & IEEE80211_TX_CTL_AMPDU) {
 		run = carl9170_tx_ampdu_queue(ar, sta, skb);
 		if (run)
-- 
1.7.4.4

