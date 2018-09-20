Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45042 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727481AbeIUAub (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Sep 2018 20:50:31 -0400
From: Rajkumar Manoharan <rmanohar@codeaurora.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Rajkumar Manoharan <rmanohar@codeaurora.org>,
        Kan Yan <kyan@google.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Subject: [RFC v2] mac80211: budget outstanding airtime for transmission
Date: Thu, 20 Sep 2018 12:05:31 -0700
Message-Id: <1537470331-6270-1-git-send-email-rmanohar@codeaurora.org> (sfid-20180920_210601_800690_CA693183)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Per frame airtime estimation could be used to track outstanding airtime
of each txq and can be used to throttle ieee80211_tx_dequeue(). This
mechanism on its own will get us the queue limiting and latency
reduction goodness for firmwares with deep queues. And for that it can
be completely independent of the airtime fairness scheduler, which can
use the after-tx-compl airtime information to presumably get more
accurate fairness which includes retransmissions etc.

Signed-off-by: Kan Yan <kyan@google.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
Signed-off-by: Rajkumar Manoharan <rmanohar@codeaurora.org>
---
 include/net/mac80211.h  |  2 +-
 net/mac80211/sta_info.h |  1 +
 net/mac80211/status.c   | 22 ++++++++++++++----
 net/mac80211/tx.c       | 61 +++++++++++++++++++++++++++++++++++++++++++++++--
 4 files changed, 79 insertions(+), 7 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 89b192e93ac9..3a9a61fe30b5 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -947,7 +947,7 @@ struct ieee80211_tx_info {
 					u8 use_cts_prot:1;
 					u8 short_preamble:1;
 					u8 skip_table:1;
-					/* 2 bytes free */
+					u16 airtime_est;
 				};
 				/* only needed before rate control */
 				unsigned long jiffies;
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index b1b0fd6a2e21..06fdac2ee202 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -135,6 +135,7 @@ struct airtime_info {
 	u64 rx_airtime;
 	u64 tx_airtime;
 	s64 deficit;
+	u32 budget;
 };
 
 struct sta_info;
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 664379797c46..81cc4a2c98b2 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -718,6 +718,7 @@ static void __ieee80211_tx_status(struct ieee80211_hw *hw,
 	struct ieee80211_bar *bar;
 	int shift = 0;
 	int tid = IEEE80211_NUM_TIDS;
+	u32 ac = IEEE80211_AC_BE;
 
 	rates_idx = ieee80211_tx_get_rates(hw, info, &retry_count);
 
@@ -733,6 +734,23 @@ static void __ieee80211_tx_status(struct ieee80211_hw *hw,
 
 		acked = !!(info->flags & IEEE80211_TX_STAT_ACK);
 
+		if (ieee80211_is_data_qos(fc)) {
+			u8 *qc = ieee80211_get_qos_ctl(hdr);
+
+			tid = qc[0] & 0xf;
+			ac = ieee80211_ac_from_tid(tid);
+		}
+		if (wiphy_ext_feature_isset(local->hw.wiphy,
+					NL80211_EXT_FEATURE_AIRTIME_FAIRNESS)) {
+			spin_lock_bh(&local->active_txq_lock[ac]);
+			if (sta->airtime[ac].budget < info->control.airtime_est)
+				sta->airtime[ac].budget = 0;
+			else
+				sta->airtime[ac].budget -=
+					info->control.airtime_est;
+			spin_unlock_bh(&local->active_txq_lock[ac]);
+		}
+
 		/* mesh Peer Service Period support */
 		if (ieee80211_vif_is_mesh(&sta->sdata->vif) &&
 		    ieee80211_is_data_qos(fc))
@@ -765,10 +783,6 @@ static void __ieee80211_tx_status(struct ieee80211_hw *hw,
 						& IEEE80211_SCTL_SEQ);
 			ieee80211_send_bar(&sta->sdata->vif, hdr->addr1,
 					   tid, ssn);
-		} else if (ieee80211_is_data_qos(fc)) {
-			u8 *qc = ieee80211_get_qos_ctl(hdr);
-
-			tid = qc[0] & 0xf;
 		}
 
 		if (!acked && ieee80211_is_back_req(fc)) {
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index e4bc43904a8e..c9997a63e5cf 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3485,6 +3485,54 @@ static bool ieee80211_xmit_fast(struct ieee80211_sub_if_data *sdata,
 	return true;
 }
 
+/* The estimated airtime (in microseconds), which is calculated using last
+ * reported TX rate is stored in info context buffer. The budget will be
+ * adjusted upon tx completion.
+ */
+#define IEEE80211_AIRTIME_BUDGET_MAX    4000 /* txq airtime limit: 4ms */
+#define IEEE80211_AIRTIME_OVERHEAD      100  /* IFS + some slot time */
+#define IEEE80211_AIRTIME_OVERHEAD_IFS  16   /* IFS only */
+static void ieee80211_calc_airtime_budget(struct ieee80211_local *local,
+					  struct sta_info *sta,
+					  struct sk_buff *skb, u8 ac)
+{
+	struct ieee80211_tx_info *info;
+	struct ieee80211_hdr *hdr;
+	struct rate_info rinfo;
+	u32 pktlen, bitrate;
+	u16 airtime = 0;
+
+	if (!wiphy_ext_feature_isset(local->hw.wiphy,
+				     NL80211_EXT_FEATURE_AIRTIME_FAIRNESS))
+		return;
+
+	lockdep_assert_held(&local->active_txq_lock[ac]);
+
+	hdr = (struct ieee80211_hdr *)skb->data;
+	info = IEEE80211_SKB_CB(skb);
+
+	sta_set_rate_info_tx(sta, &sta->tx_stats.last_rate, &rinfo);
+	bitrate = cfg80211_calculate_bitrate(&rinfo);
+
+	pktlen = skb->len + 38; /* Assume MAC header 30, SNAP 8 for most case */
+	if (!is_multicast_ether_addr(hdr->addr1)) {
+		/* airtime in us, last tx bitrate in 100kbps */
+		airtime = (pktlen * 8 * (1000 / 100)) / bitrate;
+		airtime += IEEE80211_AIRTIME_OVERHEAD_IFS;
+	} else {
+		/* This is mostly for throttle excessive BC/MC frames, and the
+		 * airtime/rate doesn't need be exact. Airtime of BC/MC frames
+		 * in 2G get some discount, which helps prevent very low rate
+		 * frames from being blocked for too long.
+		 */
+		airtime = (pktlen * 8 * (1000 / 100)) / 60; /* 6M */
+		airtime += IEEE80211_AIRTIME_OVERHEAD;
+	}
+
+	info->control.airtime_est = airtime;
+	sta->airtime[ac].budget += airtime;
+}
+
 struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 				     struct ieee80211_txq *txq)
 {
@@ -3498,6 +3546,7 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 	struct ieee80211_tx_data tx;
 	ieee80211_tx_result r;
 	struct ieee80211_vif *vif = txq->vif;
+	struct sta_info *sta = NULL;
 
 	spin_lock_bh(&fq->lock);
 
@@ -3510,6 +3559,12 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 		goto out;
 	}
 
+	if (txq->sta) {
+		sta = container_of(txq->sta, struct sta_info, sta);
+		if (sta->airtime[txq->ac].budget > IEEE80211_AIRTIME_BUDGET_MAX)
+			goto out;
+	}
+
 	/* Make sure fragments stay together. */
 	skb = __skb_dequeue(&txqi->frags);
 	if (skb)
@@ -3529,8 +3584,7 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 	tx.skb = skb;
 	tx.sdata = vif_to_sdata(info->control.vif);
 
-	if (txq->sta)
-		tx.sta = container_of(txq->sta, struct sta_info, sta);
+	tx.sta = sta;
 
 	/*
 	 * The key can be removed while the packet was queued, so need to call
@@ -3542,6 +3596,9 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 		goto begin;
 	}
 
+	if (sta)
+		ieee80211_calc_airtime_budget(local, sta, skb, txq->ac);
+
 	if (test_bit(IEEE80211_TXQ_AMPDU, &txqi->flags))
 		info->flags |= IEEE80211_TX_CTL_AMPDU;
 	else
-- 
1.9.1
