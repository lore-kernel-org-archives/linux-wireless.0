Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45320 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727599AbeHaMiC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Aug 2018 08:38:02 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Date: Fri, 31 Aug 2018 11:31:08 +0300
Message-Id: <20180831083130.15525-7-luca@coelho.fi> (sfid-20180831_103153_779115_01679AD2)
In-Reply-To: <20180831083130.15525-1-luca@coelho.fi>
References: <20180831083130.15525-1-luca@coelho.fi>
Subject: [PATCH 06/28] mac80211: add an optional TXQ for other PS-buffered frames
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Some drivers may want to also use the TXQ abstraction with
non-data packets that need powersave buffering, so add a
hardware flag to allow this.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h     | 17 ++++++++++++-----
 net/mac80211/debugfs.c     |  2 ++
 net/mac80211/debugfs_sta.c |  6 ++++--
 net/mac80211/rx.c          |  2 +-
 net/mac80211/sta_info.c    | 21 +++++++++++++--------
 net/mac80211/tx.c          | 37 +++++++++++++++++++++++++++----------
 6 files changed, 59 insertions(+), 26 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index e248f5fe5b19..03e1dfd311f7 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -101,8 +101,9 @@
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
@@ -1843,7 +1844,8 @@ struct ieee80211_sta_rates {
  *	unlimited.
  * @support_p2p_ps: indicates whether the STA supports P2P PS mechanism or not.
  * @max_rc_amsdu_len: Maximum A-MSDU size in bytes recommended by rate control.
- * @txq: per-TID data TX queues (if driver uses the TXQ abstraction)
+ * @txq: per-TID data TX queues (if driver uses the TXQ abstraction); note that
+ *	the last entry (%IEEE80211_NUM_TIDS) is used for non-data frames
  */
 struct ieee80211_sta {
 	u32 supp_rates[NUM_NL80211_BANDS];
@@ -1884,7 +1886,7 @@ struct ieee80211_sta {
 	bool support_p2p_ps;
 	u16 max_rc_amsdu_len;
 
-	struct ieee80211_txq *txq[IEEE80211_NUM_TIDS];
+	struct ieee80211_txq *txq[IEEE80211_NUM_TIDS + 1];
 
 	/* must be last */
 	u8 drv_priv[0] __aligned(sizeof(void *));
@@ -1918,7 +1920,8 @@ struct ieee80211_tx_control {
  *
  * @vif: &struct ieee80211_vif pointer from the add_interface callback.
  * @sta: station table entry, %NULL for per-vif queue
- * @tid: the TID for this queue (unused for per-vif queue)
+ * @tid: the TID for this queue (unused for per-vif queue),
+ *	%IEEE80211_NUM_TIDS for non-data (if enabled)
  * @ac: the AC for this queue
  * @drv_priv: driver private area, sized by hw->txq_data_size
  *
@@ -2131,6 +2134,9 @@ struct ieee80211_txq {
  * @IEEE80211_HW_DOESNT_SUPPORT_QOS_NDP: The driver (or firmware) doesn't
  *	support QoS NDP for AP probing - that's most likely a driver bug.
  *
+ * @IEEE80211_HW_BUFF_MMPDU_TXQ: use the TXQ for bufferable MMPDUs, this of
+ *	course requires the driver to use TXQs to start with.
+ *
  * @NUM_IEEE80211_HW_FLAGS: number of hardware flags, used for sizing arrays
  */
 enum ieee80211_hw_flags {
@@ -2176,6 +2182,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_SUPPORTS_TDLS_BUFFER_STA,
 	IEEE80211_HW_DEAUTH_NEED_MGD_TX_PREP,
 	IEEE80211_HW_DOESNT_SUPPORT_QOS_NDP,
+	IEEE80211_HW_BUFF_MMPDU_TXQ,
 
 	/* keep last, obviously */
 	NUM_IEEE80211_HW_FLAGS
diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index b5adf3625d16..964663f49e58 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -3,6 +3,7 @@
  *
  * Copyright 2007	Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
+ * Copyright (C) 2018 Intel Corporation
  *
  * GPLv2
  *
@@ -214,6 +215,7 @@ static const char *hw_flag_names[] = {
 	FLAG(SUPPORTS_TDLS_BUFFER_STA),
 	FLAG(DEAUTH_NEED_MGD_TX_PREP),
 	FLAG(DOESNT_SUPPORT_QOS_NDP),
+	FLAG(BUFF_MMPDU_TXQ),
 #undef FLAG
 };
 
diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index de66f685a107..95124978947f 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -141,7 +141,7 @@ static ssize_t sta_aqm_read(struct file *file, char __user *userbuf,
 {
 	struct sta_info *sta = file->private_data;
 	struct ieee80211_local *local = sta->local;
-	size_t bufsz = AQM_TXQ_ENTRY_LEN*(IEEE80211_NUM_TIDS+1);
+	size_t bufsz = AQM_TXQ_ENTRY_LEN * (IEEE80211_NUM_TIDS + 2);
 	char *buf = kzalloc(bufsz, GFP_KERNEL), *p = buf;
 	struct txq_info *txqi;
 	ssize_t rv;
@@ -163,7 +163,9 @@ static ssize_t sta_aqm_read(struct file *file, char __user *userbuf,
 		       bufsz+buf-p,
 		       "tid ac backlog-bytes backlog-packets new-flows drops marks overlimit collisions tx-bytes tx-packets flags\n");
 
-	for (i = 0; i < IEEE80211_NUM_TIDS; i++) {
+	for (i = 0; i < ARRAY_SIZE(sta->sta.txq); i++) {
+		if (!sta->sta.txq[i])
+			continue;
 		txqi = to_txq_info(sta->sta.txq[i]);
 		p += scnprintf(p, bufsz+buf-p,
 			       "%d %d %u %u %u %u %u %u %u %u %u 0x%lx(%s%s%s)\n",
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index f988609e1283..46223b694227 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1505,7 +1505,7 @@ static void sta_ps_start(struct sta_info *sta)
 	if (!sta->sta.txq[0])
 		return;
 
-	for (tid = 0; tid < ARRAY_SIZE(sta->sta.txq); tid++) {
+	for (tid = 0; tid < IEEE80211_NUM_TIDS; tid++) {
 		if (txq_has_queue(sta->sta.txq[tid]))
 			set_bit(tid, &sta->txq_buffered_tids);
 		else
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index a231d623b2d2..fb8c2252ac0e 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -113,7 +113,12 @@ static void __cleanup_single_sta(struct sta_info *sta)
 
 	if (sta->sta.txq[0]) {
 		for (i = 0; i < ARRAY_SIZE(sta->sta.txq); i++) {
-			struct txq_info *txqi = to_txq_info(sta->sta.txq[i]);
+			struct txq_info *txqi;
+
+			if (!sta->sta.txq[i])
+				continue;
+
+			txqi = to_txq_info(sta->sta.txq[i]);
 
 			spin_lock_bh(&fq->lock);
 			ieee80211_txq_purge(local, txqi);
@@ -374,6 +379,7 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 		for (i = 0; i < ARRAY_SIZE(sta->sta.txq); i++) {
 			struct txq_info *txq = txq_data + i * size;
 
+			/* might not do anything for the bufferable MMPDU TXQ */
 			ieee80211_txq_init(sdata, sta, txq, i);
 		}
 	}
@@ -1239,13 +1245,11 @@ void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta)
 	if (!ieee80211_hw_check(&local->hw, AP_LINK_PS))
 		drv_sta_notify(local, sdata, STA_NOTIFY_AWAKE, &sta->sta);
 
-	if (sta->sta.txq[0]) {
-		for (i = 0; i < ARRAY_SIZE(sta->sta.txq); i++) {
-			if (!txq_has_queue(sta->sta.txq[i]))
-				continue;
+	for (i = 0; i < ARRAY_SIZE(sta->sta.txq); i++) {
+		if (!sta->sta.txq[i] || !txq_has_queue(sta->sta.txq[i]))
+			continue;
 
-			drv_wake_tx_queue(local, to_txq_info(sta->sta.txq[i]));
-		}
+		drv_wake_tx_queue(local, to_txq_info(sta->sta.txq[i]));
 	}
 
 	skb_queue_head_init(&pending);
@@ -1683,7 +1687,8 @@ ieee80211_sta_ps_deliver_response(struct sta_info *sta,
 			return;
 
 		for (tid = 0; tid < ARRAY_SIZE(sta->sta.txq); tid++) {
-			if (!(driver_release_tids & BIT(tid)) ||
+			if (!sta->sta.txq[tid] ||
+			    !(driver_release_tids & BIT(tid)) ||
 			    txq_has_queue(sta->sta.txq[tid]))
 				continue;
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 093108077edc..6eced0626522 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1249,10 +1249,17 @@ static struct txq_info *ieee80211_get_txq(struct ieee80211_local *local,
 	    (info->control.flags & IEEE80211_TX_CTRL_PS_RESPONSE))
 		return NULL;
 
-	if (!ieee80211_is_data_present(hdr->frame_control))
-		return NULL;
-
-	if (sta) {
+	if (unlikely(!ieee80211_is_data_present(hdr->frame_control))) {
+		if ((!ieee80211_is_mgmt(hdr->frame_control) ||
+		     ieee80211_is_bufferable_mmpdu(hdr->frame_control)) &&
+		    sta && sta->uploaded) {
+			/*
+			 * This will be NULL if the driver didn't set the
+			 * opt-in hardware flag.
+			 */
+			txq = sta->sta.txq[IEEE80211_NUM_TIDS];
+		}
+	} else if (sta) {
 		u8 tid = skb->priority & IEEE80211_QOS_CTL_TID_MASK;
 
 		if (!sta->uploaded)
@@ -1440,16 +1447,26 @@ void ieee80211_txq_init(struct ieee80211_sub_if_data *sdata,
 
 	txqi->txq.vif = &sdata->vif;
 
-	if (sta) {
-		txqi->txq.sta = &sta->sta;
-		sta->sta.txq[tid] = &txqi->txq;
-		txqi->txq.tid = tid;
-		txqi->txq.ac = ieee80211_ac_from_tid(tid);
-	} else {
+	if (!sta) {
 		sdata->vif.txq = &txqi->txq;
 		txqi->txq.tid = 0;
 		txqi->txq.ac = IEEE80211_AC_BE;
+
+		return;
+	}
+
+	if (tid == IEEE80211_NUM_TIDS) {
+		/* Drivers need to opt in to the bufferable MMPDU TXQ */
+		if (!ieee80211_hw_check(&sdata->local->hw, BUFF_MMPDU_TXQ))
+			return;
+		txqi->txq.ac = IEEE80211_AC_VO;
+	} else {
+		txqi->txq.ac = ieee80211_ac_from_tid(tid);
 	}
+
+	txqi->txq.sta = &sta->sta;
+	txqi->txq.tid = tid;
+	sta->sta.txq[tid] = &txqi->txq;
 }
 
 void ieee80211_txq_purge(struct ieee80211_local *local,
-- 
2.18.0
