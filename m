Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:60525 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751932AbdJFLw5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Oct 2017 07:52:57 -0400
From: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Subject: [RFC] mac80211: Add airtime fairness accounting
Date: Fri,  6 Oct 2017 13:52:32 +0200
Message-Id: <20171006115232.28688-1-toke@toke.dk> (sfid-20171006_135301_379557_9AE74A5E)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds accounting of each station's airtime usage to mac80211. On the RX
side, airtime is calculated from the packet length and duration. On the TX side,
the driver has to fill in status.tx_time with the packet send duration.

When a station's airtime deficit runs into the negative, no more packets will be
returned from ieee80211_tx_dequeue(), but rather instead ERR_PTR(-EAGAIN). The
driver is expected to handle this and to keep scheduling such a station.
It is assumed that the driver schedules active TXQs in a round-robin manner.

This is still incomplete. Missing:
- The actual calculation of RX airtime
- Updates of the drivers to check for the ERR_PTR and set tx_time

Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
---
 net/mac80211/ieee80211_i.h |  3 +++
 net/mac80211/rx.c          | 30 ++++++++++++++++++++++++++++++
 net/mac80211/sta_info.c    |  1 +
 net/mac80211/sta_info.h    |  7 +++++++
 net/mac80211/status.c      |  8 ++++++++
 net/mac80211/tx.c          | 17 ++++++++++++++---
 6 files changed, 63 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 9675814f64db..2bc259cf2c30 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -90,6 +90,9 @@ extern const u8 ieee80211_ac_to_qos_mask[IEEE80211_NUM_ACS];
 
 #define IEEE80211_MAX_NAN_INSTANCE_ID 255
 
+/* How much to increase airtime deficit on each scheduling round */
+#define IEEE80211_AIRTIME_QUANTUM        1000 /* usec */
+
 struct ieee80211_fragment_entry {
 	struct sk_buff_head skb_list;
 	unsigned long first_frag_time;
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 70e9d2ca8bbe..031dae70c7ad 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1673,6 +1673,35 @@ ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
 	return RX_CONTINUE;
 } /* ieee80211_rx_h_sta_process */
 
+static ieee80211_rx_result debug_noinline
+ieee80211_rx_h_airtime(struct ieee80211_rx_data *rx)
+{
+	struct sta_info *sta = rx->sta;
+	struct sk_buff *skb = rx->skb;
+	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	struct ieee80211_sub_if_data *sdata = rx->sdata;
+	const struct ieee80211_rate *rate;
+	u32 airtime = 0;
+	int i;
+	u8 ac;
+
+	if (!sta || !ieee80211_is_data(hdr->frame_control))
+		return RX_CONTINUE;
+
+	ac = ieee80211_select_queue_80211(sdata, skb, hdr);
+	/* FIXME: implement this
+	airtime = ieee80211_pkt_duration(status, skb->len); */
+
+	spin_lock_bh(&sta->lock);
+	sta->airtime_deficit[ac] -= airtime;
+	sta->airtime_stats.rx_airtime += airtime;
+	spin_unlock_bh(&sta->lock);
+
+	return RX_CONTINUE;
+} /* ieee80211_rx_h_airtime */
+
+
 static ieee80211_rx_result debug_noinline
 ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
 {
@@ -3392,6 +3421,7 @@ static void ieee80211_rx_handlers(struct ieee80211_rx_data *rx,
 		CALL_RXH(ieee80211_rx_h_check_more_data);
 		CALL_RXH(ieee80211_rx_h_uapsd_and_pspoll);
 		CALL_RXH(ieee80211_rx_h_sta_process);
+		CALL_RXH(ieee80211_rx_h_airtime);
 		CALL_RXH(ieee80211_rx_h_decrypt);
 		CALL_RXH(ieee80211_rx_h_defragment);
 		CALL_RXH(ieee80211_rx_h_michael_mic_verify);
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index ffcd25c4908c..cf33c2998bdd 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -388,6 +388,7 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 	for (i = 0; i < IEEE80211_NUM_ACS; i++) {
 		skb_queue_head_init(&sta->ps_tx_buf[i]);
 		skb_queue_head_init(&sta->tx_filtered[i]);
+		sta->airtime_deficit[i] = IEEE80211_AIRTIME_QUANTUM;
 	}
 
 	for (i = 0; i < IEEE80211_NUM_TIDS; i++)
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index a35c964f6217..43eb4b3da12a 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -548,6 +548,13 @@ struct sta_info {
 	} tx_stats;
 	u16 tid_seq[IEEE80211_QOS_CTL_TID_MASK + 1];
 
+	/* Airtime stats and deficit, protected by lock */
+	struct {
+		u64 rx_airtime;
+		u64 tx_airtime;
+	} airtime_stats;
+	s64 airtime_deficit[IEEE80211_NUM_ACS];
+
 	/*
 	 * Aggregation information, locked with lock.
 	 */
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index da7427a41529..5998004401f6 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -823,6 +823,14 @@ static void __ieee80211_tx_status(struct ieee80211_hw *hw,
 				ieee80211_lost_packet(sta, info);
 			}
 		}
+
+		if (info->status.tx_time) {
+			int ac = skb_get_queue_mapping(skb);
+			spin_lock_bh(&sta->lock);
+			sta->airtime_stats.tx_airtime += info->status.tx_time;
+			sta->airtime_deficit[ac] -= info->status.tx_time;
+			spin_unlock_bh(&sta->lock);
+		}
 	}
 
 	/* SNMP counters
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 94826680cf2b..4b11d199bf8e 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3410,6 +3410,7 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 	struct ieee80211_tx_data tx;
 	ieee80211_tx_result r;
 	struct ieee80211_vif *vif;
+	struct sta_info *sta = NULL;
 
 	spin_lock_bh(&fq->lock);
 
@@ -3421,6 +3422,18 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 	if (skb)
 		goto out;
 
+	if (txq->sta) {
+		sta = container_of(txq->sta, struct sta_info, sta);
+		spin_lock_bh(&sta->lock);
+		if (sta.airtime_deficit[txq->ac] <= 0) {
+			sta.airtime_deficit[txq->ac] += IEEE80211_AIRTIME_QUANTUM;
+			skb = ERR_PTR(-EAGAIN);
+			spin_unlock_bh(&sta->lock);
+			goto out;
+		}
+		spin_unlock_bh(&sta->lock);
+	}
+
 begin:
 	skb = fq_tin_dequeue(fq, tin, fq_tin_dequeue_func);
 	if (!skb)
@@ -3434,9 +3447,7 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 	tx.local = local;
 	tx.skb = skb;
 	tx.sdata = vif_to_sdata(info->control.vif);
-
-	if (txq->sta)
-		tx.sta = container_of(txq->sta, struct sta_info, sta);
+	tx.sta = sta;
 
 	/*
 	 * The key can be removed while the packet was queued, so need to call
-- 
2.14.1
