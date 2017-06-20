Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34348 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751767AbdFTVDR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Jun 2017 17:03:17 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: nbd@nbd.name, Johannes Berg <johannes.berg@intel.com>
Subject: [RFC] mac80211: support non-data TXQs
Date: Tue, 20 Jun 2017 23:03:09 +0200
Message-Id: <20170620210309.1193-1-johannes@sipsolutions.net> (sfid-20170620_230321_402397_A3FCC329)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Some drivers may want to also use the TXQ abstraction with
non-data packets, so add a hardware flag to allow this.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h     |  9 +++++++--
 net/mac80211/debugfs.c     |  1 +
 net/mac80211/debugfs_sta.c |  4 +++-
 net/mac80211/sta_info.c    | 15 ++++++++++++---
 net/mac80211/tx.c          | 20 ++++++++++++++------
 5 files changed, 37 insertions(+), 12 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 13c59e6f88d4..b64148c49db0 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1908,7 +1908,7 @@ struct ieee80211_sta {
 	bool support_p2p_ps;
 	u16 max_rc_amsdu_len;
 
-	struct ieee80211_txq *txq[IEEE80211_NUM_TIDS];
+	struct ieee80211_txq *txq[IEEE80211_NUM_TIDS + 1];
 
 	/* must be last */
 	u8 drv_priv[0] __aligned(sizeof(void *));
@@ -1942,7 +1942,8 @@ struct ieee80211_tx_control {
  *
  * @vif: &struct ieee80211_vif pointer from the add_interface callback.
  * @sta: station table entry, %NULL for per-vif queue
- * @tid: the TID for this queue (unused for per-vif queue)
+ * @tid: the TID for this queue (unused for per-vif queue),
+ *	%IEEE80211_NUM_TIDS for non-data (if enabled)
  * @ac: the AC for this queue
  * @drv_priv: driver private area, sized by hw->txq_data_size
  *
@@ -2141,6 +2142,9 @@ struct ieee80211_txq {
  *	The stack will not do fragmentation.
  *	The callback for @set_frag_threshold should be set as well.
  *
+ * @IEEE80211_HW_WANT_NONDATA_TXQ: The driver/hardware wants to have a TXQ
+ *	(&struct ieee80211_txq) for non-data frames
+ *
  * @NUM_IEEE80211_HW_FLAGS: number of hardware flags, used for sizing arrays
  */
 enum ieee80211_hw_flags {
@@ -2183,6 +2187,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_TX_FRAG_LIST,
 	IEEE80211_HW_REPORTS_LOW_ACK,
 	IEEE80211_HW_SUPPORTS_TX_FRAG,
+	IEEE80211_HW_WANT_NONDATA_TXQ,
 
 	/* keep last, obviously */
 	NUM_IEEE80211_HW_FLAGS
diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index d40ec17829a9..d754dc9ff56f 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -791,6 +791,7 @@ static const char *hw_flag_names[] = {
 	FLAG(TX_FRAG_LIST),
 	FLAG(REPORTS_LOW_ACK),
 	FLAG(SUPPORTS_TX_FRAG),
+	FLAG(WANT_NONDATA_TXQ),
 #undef FLAG
 };
 
diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index 0f122a554d2e..48984f6cabd9 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -171,7 +171,9 @@ static ssize_t sta_aqm_read(struct file *file, char __user *userbuf,
 		       bufsz+buf-p,
 		       "tid ac backlog-bytes backlog-packets new-flows drops marks overlimit collisions tx-bytes tx-packets\n");
 
-	for (i = 0; i < IEEE80211_NUM_TIDS; i++) {
+	for (i = 0; i < ARRAY_SIZE(sta->sta.txq); i++) {
+		if (!sta->sta.txq[i])
+			continue;
 		txqi = to_txq_info(sta->sta.txq[i]);
 		p += scnprintf(p, bufsz+buf-p,
 			       "%d %d %u %u %u %u %u %u %u %u %u\n",
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 0297f544e0cc..8b71960eb2a0 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -112,7 +112,12 @@ static void __cleanup_single_sta(struct sta_info *sta)
 
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
@@ -384,15 +389,19 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 		ewma_signal_init(&sta->rx_stats_avg.chain_signal[i]);
 
 	if (local->ops->wake_tx_queue) {
+		int num_queues = IEEE80211_NUM_TIDS;
 		void *txq_data;
 		int size = sizeof(struct txq_info) +
 			   ALIGN(hw->txq_data_size, sizeof(void *));
 
-		txq_data = kcalloc(ARRAY_SIZE(sta->sta.txq), size, gfp);
+		if (ieee80211_hw_check(&local->hw, WANT_NONDATA_TXQ))
+			num_queues++;
+
+		txq_data = kcalloc(num_queues, size, gfp);
 		if (!txq_data)
 			goto free;
 
-		for (i = 0; i < ARRAY_SIZE(sta->sta.txq); i++) {
+		for (i = 0; i < num_queues; i++) {
 			struct txq_info *txq = txq_data + i * size;
 
 			ieee80211_txq_init(sdata, sta, txq, i);
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 3d3e37f29bcb..d1cef5ad91ee 100644
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
@@ -1245,24 +1246,28 @@ static struct txq_info *ieee80211_get_txq(struct ieee80211_local *local,
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	struct ieee80211_txq *txq = NULL;
+	struct ieee80211_txq *txq;
 
 	if ((info->flags & IEEE80211_TX_CTL_SEND_AFTER_DTIM) ||
 	    (info->control.flags & IEEE80211_TX_CTRL_PS_RESPONSE))
 		return NULL;
 
-	if (!ieee80211_is_data(hdr->frame_control))
+	if (!vif) {
 		return NULL;
+	} else if (!sta) {
+		txq = vif->txq;
+	} else if (!ieee80211_is_data(hdr->frame_control)) {
+		if (!sta->uploaded)
+			return NULL;
 
-	if (sta) {
+		txq = sta->sta.txq[IEEE80211_NUM_TIDS];
+	} else {
 		u8 tid = skb->priority & IEEE80211_QOS_CTL_TID_MASK;
 
 		if (!sta->uploaded)
 			return NULL;
 
 		txq = sta->sta.txq[tid];
-	} else if (vif) {
-		txq = vif->txq;
 	}
 
 	if (!txq)
@@ -1417,7 +1422,10 @@ void ieee80211_txq_init(struct ieee80211_sub_if_data *sdata,
 		txqi->txq.sta = &sta->sta;
 		sta->sta.txq[tid] = &txqi->txq;
 		txqi->txq.tid = tid;
-		txqi->txq.ac = ieee80211_ac_from_tid(tid);
+		if (tid == IEEE80211_NUM_TIDS + 1)
+			txqi->txq.ac = IEEE80211_AC_VO;
+		else
+			txqi->txq.ac = ieee80211_ac_from_tid(tid);
 	} else {
 		sdata->vif.txq = &txqi->txq;
 		txqi->txq.tid = 0;
-- 
2.11.0
