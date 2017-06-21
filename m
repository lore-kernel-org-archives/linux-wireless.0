Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53032 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751940AbdFUXu0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Jun 2017 19:50:26 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: nbd@nbd.name, Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 3/6] mac80211: add a TXQ for other powersave-buffered frames
Date: Thu, 22 Jun 2017 01:50:19 +0200
Message-Id: <20170621235022.25362-3-johannes@sipsolutions.net> (sfid-20170622_015037_199350_B3597170)
In-Reply-To: <20170621235022.25362-1-johannes@sipsolutions.net>
References: <20170621235022.25362-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Some drivers may want to also use the TXQ abstraction with
non-data packets that need powersave buffering, so add a
hardware flag to allow this.

Change ath9k/ath10k to use these by dequeuing the frames
immediately and invoking the normal TX path for them.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ath/ath10k/mac.c  | 13 +++++++++++++
 drivers/net/wireless/ath/ath9k/ath9k.h |  2 ++
 drivers/net/wireless/ath/ath9k/main.c  |  5 ++---
 drivers/net/wireless/ath/ath9k/xmit.c  | 20 ++++++++++++++++++--
 include/net/mac80211.h                 | 13 ++++++++-----
 net/mac80211/debugfs_sta.c             |  4 ++--
 net/mac80211/rx.c                      |  2 +-
 net/mac80211/tx.c                      | 16 +++++++++++-----
 8 files changed, 57 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 16cf250f6c39..ee11a01e4f61 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -4236,6 +4236,19 @@ static void ath10k_mac_op_wake_tx_queue(struct ieee80211_hw *hw,
 	int ret = 0;
 	int max = 16;
 
+	if (unlikely(txq->tid == IEEE80211_NUM_TIDS)) {
+		struct sk_buff *skb = ieee80211_tx_dequeue(hw, txq);
+		struct ieee80211_tx_control control = {
+			.sta = txq->sta,
+		};
+
+		if (WARN_ON(!skb))
+			return;
+
+		ath10k_mac_op_tx(hw, &control, skb);
+		return;
+	}
+
 	spin_lock_bh(&ar->txqs_lock);
 	if (list_empty(&artxq->list))
 		list_add_tail(&artxq->list, &ar->txqs);
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index cf076719c27e..4a427248e9fe 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -618,6 +618,8 @@ void ath9k_release_buffered_frames(struct ieee80211_hw *hw,
 				   u16 tids, int nframes,
 				   enum ieee80211_frame_release_type reason,
 				   bool more_data);
+void ath9k_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
+	      struct sk_buff *skb);
 void ath9k_wake_tx_queue(struct ieee80211_hw *hw, struct ieee80211_txq *queue);
 
 /********/
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 9e65d14e7b1e..6ddb01d26ac6 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -740,9 +740,8 @@ static int ath9k_start(struct ieee80211_hw *hw)
 	return 0;
 }
 
-static void ath9k_tx(struct ieee80211_hw *hw,
-		     struct ieee80211_tx_control *control,
-		     struct sk_buff *skb)
+void ath9k_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
+	      struct sk_buff *skb)
 {
 	struct ath_softc *sc = hw->priv;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 396bf05c6bf6..8ff00ebff261 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -154,8 +154,24 @@ void ath9k_wake_tx_queue(struct ieee80211_hw *hw, struct ieee80211_txq *queue)
 {
 	struct ath_softc *sc = hw->priv;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
-	struct ath_atx_tid *tid = (struct ath_atx_tid *) queue->drv_priv;
-	struct ath_txq *txq = tid->txq;
+	struct ath_atx_tid *tid;
+	struct ath_txq *txq;
+
+	if (unlikely(queue->tid == IEEE80211_NUM_TIDS)) {
+		struct sk_buff *skb = ieee80211_tx_dequeue(hw, queue);
+		struct ieee80211_tx_control control = {
+			.sta = queue->sta,
+		};
+
+		if (WARN_ON(!skb))
+			return;
+
+		ath9k_tx(hw, &control, skb);
+		return;
+	}
+
+	tid = (struct ath_atx_tid *) queue->drv_priv;
+	txq = tid->txq;
 
 	ath_dbg(common, QUEUE, "Waking TX queue: %pM (%d)\n",
 		queue->sta ? queue->sta->addr : queue->vif->addr,
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 263cb30d77c8..871e4399a999 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -99,8 +99,9 @@
  * Drivers indicate that they use this model by implementing the .wake_tx_queue
  * driver operation.
  *
- * Intermediate queues (struct ieee80211_txq) are kept per-sta per-tid, with a
- * single per-vif queue for multicast data frames.
+ * Intermediate queues (struct ieee80211_txq) are kept per-sta per-tid, with
+ * another per-sta for non-data/non-mgmt and bufferable management frames, and
+ * a single per-vif queue for multicast data frames.
  *
  * The driver is expected to initialize its private per-queue data for stations
  * and interfaces in the .add_interface and .sta_add ops.
@@ -1783,7 +1784,8 @@ struct ieee80211_sta_rates {
  *	unlimited.
  * @support_p2p_ps: indicates whether the STA supports P2P PS mechanism or not.
  * @max_rc_amsdu_len: Maximum A-MSDU size in bytes recommended by rate control.
- * @txq: per-TID data TX queues (if driver uses the TXQ abstraction)
+ * @txq: per-TID data TX queues (if driver uses the TXQ abstraction); note that
+ *	the last entry (%IEEE80211_NUM_TIDS) is used for non-data frames
  */
 struct ieee80211_sta {
 	u32 supp_rates[NUM_NL80211_BANDS];
@@ -1823,7 +1825,7 @@ struct ieee80211_sta {
 	bool support_p2p_ps;
 	u16 max_rc_amsdu_len;
 
-	struct ieee80211_txq *txq[IEEE80211_NUM_TIDS];
+	struct ieee80211_txq *txq[IEEE80211_NUM_TIDS + 1];
 
 	/* must be last */
 	u8 drv_priv[0] __aligned(sizeof(void *));
@@ -1857,7 +1859,8 @@ struct ieee80211_tx_control {
  *
  * @vif: &struct ieee80211_vif pointer from the add_interface callback.
  * @sta: station table entry, %NULL for per-vif queue
- * @tid: the TID for this queue (unused for per-vif queue)
+ * @tid: the TID for this queue (unused for per-vif queue),
+ *	%IEEE80211_NUM_TIDS for non-data (if enabled)
  * @ac: the AC for this queue
  * @drv_priv: driver private area, sized by hw->txq_data_size
  *
diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index b15412c21ac9..d046c17ea48d 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -140,7 +140,7 @@ static ssize_t sta_aqm_read(struct file *file, char __user *userbuf,
 {
 	struct sta_info *sta = file->private_data;
 	struct ieee80211_local *local = sta->local;
-	size_t bufsz = AQM_TXQ_ENTRY_LEN*(IEEE80211_NUM_TIDS+1);
+	size_t bufsz = AQM_TXQ_ENTRY_LEN * (IEEE80211_NUM_TIDS + 2);
 	char *buf = kzalloc(bufsz, GFP_KERNEL), *p = buf;
 	struct txq_info *txqi;
 	ssize_t rv;
@@ -162,7 +162,7 @@ static ssize_t sta_aqm_read(struct file *file, char __user *userbuf,
 		       bufsz+buf-p,
 		       "tid ac backlog-bytes backlog-packets new-flows drops marks overlimit collisions tx-bytes tx-packets\n");
 
-	for (i = 0; i < IEEE80211_NUM_TIDS; i++) {
+	for (i = 0; i < ARRAY_SIZE(sta->sta.txq); i++) {
 		txqi = to_txq_info(sta->sta.txq[i]);
 		p += scnprintf(p, bufsz+buf-p,
 			       "%d %d %u %u %u %u %u %u %u %u %u\n",
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 70e9d2ca8bbe..0444e2f0169f 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1387,7 +1387,7 @@ static void sta_ps_start(struct sta_info *sta)
 	if (!sta->sta.txq[0])
 		return;
 
-	for (tid = 0; tid < ARRAY_SIZE(sta->sta.txq); tid++) {
+	for (tid = 0; tid < IEEE80211_NUM_TIDS; tid++) {
 		if (txq_has_queue(sta->sta.txq[tid]))
 			set_bit(tid, &sta->txq_buffered_tids);
 		else
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index bd609326d77c..1b3ac635fbdd 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -4,6 +4,7 @@
  * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
  * Copyright 2007	Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
+ * Copyright 2017	Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -1251,10 +1252,12 @@ static struct txq_info *ieee80211_get_txq(struct ieee80211_local *local,
 	    (info->control.flags & IEEE80211_TX_CTRL_PS_RESPONSE))
 		return NULL;
 
-	if (!ieee80211_is_data(hdr->frame_control))
-		return NULL;
-
-	if (sta) {
+	if (!ieee80211_is_data(hdr->frame_control)) {
+		if ((!ieee80211_is_mgmt(hdr->frame_control) ||
+		     ieee80211_is_bufferable_mmpdu(hdr->frame_control)) &&
+		    sta && sta->uploaded)
+			txq = sta->sta.txq[IEEE80211_NUM_TIDS];
+	} else if (sta) {
 		u8 tid = skb->priority & IEEE80211_QOS_CTL_TID_MASK;
 
 		if (!sta->uploaded)
@@ -1412,7 +1415,10 @@ void ieee80211_txq_init(struct ieee80211_sub_if_data *sdata,
 		txqi->txq.sta = &sta->sta;
 		sta->sta.txq[tid] = &txqi->txq;
 		txqi->txq.tid = tid;
-		txqi->txq.ac = ieee80211_ac_from_tid(tid);
+		if (tid == IEEE80211_NUM_TIDS)
+			txqi->txq.ac = IEEE80211_AC_VO;
+		else
+			txqi->txq.ac = ieee80211_ac_from_tid(tid);
 	} else {
 		sdata->vif.txq = &txqi->txq;
 		txqi->txq.tid = 0;
-- 
2.11.0
