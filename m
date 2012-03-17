Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:39180 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753105Ab2CQXBH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Mar 2012 19:01:07 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net
Subject: [PATCH 3/3] mac80211: optimize aggregation session timeout handling
Date: Sun, 18 Mar 2012 00:00:54 +0100
Message-Id: <1332025254-5048-3-git-send-email-nbd@openwrt.org> (sfid-20120318_000113_974640_4463ECAF)
In-Reply-To: <1332025254-5048-2-git-send-email-nbd@openwrt.org>
References: <1332025254-5048-1-git-send-email-nbd@openwrt.org>
 <1332025254-5048-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Calling mod_timer from the rx/tx hotpath is somewhat expensive, and the
timeout doesn't need to be so precise.

Switch to a different strategy: Schedule the timer initially, store jiffies
of all last rx/tx activity which would previously modify the timer, and
let the timer re-arm itself after checking the last rx/tx timestamp.
This visibly reduces CPU load under high network load on small embedded
systems.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/agg-rx.c      |   16 +++++++++++++++-
 net/mac80211/agg-tx.c      |   16 +++++++++++++++-
 net/mac80211/ieee80211_i.h |    3 ++-
 net/mac80211/rx.c          |    3 +--
 net/mac80211/sta_info.h    |    4 ++++
 net/mac80211/tx.c          |    3 +--
 6 files changed, 38 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index 1068f66..d92b345 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -141,6 +141,18 @@ static void sta_rx_agg_session_timer_expired(unsigned long data)
 	u8 *timer_to_id = ptid - *ptid;
 	struct sta_info *sta = container_of(timer_to_id, struct sta_info,
 					 timer_to_tid[0]);
+	struct tid_ampdu_rx *tid_rx;
+	unsigned long timeout;
+
+	tid_rx = rcu_dereference(sta->ampdu_mlme.tid_rx[*ptid]);
+	if (!tid_rx)
+		return;
+
+	timeout = tid_rx->last_rx + TU_TO_JIFFIES(tid_rx->timeout);
+	if (time_is_after_jiffies(timeout)) {
+		mod_timer(&tid_rx->session_timer, timeout);
+		return;
+	}
 
 #ifdef CONFIG_MAC80211_HT_DEBUG
 	printk(KERN_DEBUG "rx session timer expired on tid %d\n", (u16)*ptid);
@@ -334,8 +346,10 @@ void ieee80211_process_addba_request(struct ieee80211_local *local,
 	/* activate it for RX */
 	rcu_assign_pointer(sta->ampdu_mlme.tid_rx[tid], tid_agg_rx);
 
-	if (timeout)
+	if (timeout) {
 		mod_timer(&tid_agg_rx->session_timer, TU_TO_EXP_TIME(timeout));
+		tid_agg_rx->last_rx = jiffies;
+	}
 
 end:
 	mutex_unlock(&sta->ampdu_mlme.mtx);
diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index 76be617..16632fa 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -417,6 +417,18 @@ static void sta_tx_agg_session_timer_expired(unsigned long data)
 	u8 *timer_to_id = ptid - *ptid;
 	struct sta_info *sta = container_of(timer_to_id, struct sta_info,
 					 timer_to_tid[0]);
+	struct tid_ampdu_tx *tid_tx;
+	unsigned long timeout;
+
+	tid_tx = rcu_dereference_protected_tid_tx(sta, *ptid);
+	if (!tid_tx)
+		return;
+
+	timeout = tid_tx->last_tx + TU_TO_JIFFIES(tid_tx->timeout);
+	if (time_is_after_jiffies(timeout)) {
+		mod_timer(&tid_tx->session_timer, timeout);
+		return;
+	}
 
 #ifdef CONFIG_MAC80211_HT_DEBUG
 	printk(KERN_DEBUG "tx session timer expired on tid %d\n", (u16)*ptid);
@@ -884,9 +896,11 @@ void ieee80211_process_addba_resp(struct ieee80211_local *local,
 
 		sta->ampdu_mlme.addba_req_num[tid] = 0;
 
-		if (tid_tx->timeout)
+		if (tid_tx->timeout) {
 			mod_timer(&tid_tx->session_timer,
 				  TU_TO_EXP_TIME(tid_tx->timeout));
+			tid_tx->last_tx = jiffies;
+		}
 
 	} else {
 		___ieee80211_stop_tx_ba_session(sta, tid, WLAN_BACK_INITIATOR,
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index d9798a3..2785976 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -52,7 +52,8 @@ struct ieee80211_local;
  * increased memory use (about 2 kB of RAM per entry). */
 #define IEEE80211_FRAGMENT_MAX 4
 
-#define TU_TO_EXP_TIME(x)	(jiffies + usecs_to_jiffies((x) * 1024))
+#define TU_TO_JIFFIES(x)	(usecs_to_jiffies((x) * 1024))
+#define TU_TO_EXP_TIME(x)	(jiffies + TU_TO_JIFFIES(x))
 
 #define IEEE80211_DEFAULT_UAPSD_QUEUES \
 	(IEEE80211_WMM_IE_STA_QOSINFO_AC_BK |	\
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index bcfe8c7..8da3b36 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -793,8 +793,7 @@ static void ieee80211_rx_reorder_ampdu(struct ieee80211_rx_data *rx)
 
 	/* reset session timer */
 	if (tid_agg_rx->timeout)
-		mod_timer(&tid_agg_rx->session_timer,
-			  TU_TO_EXP_TIME(tid_agg_rx->timeout));
+		tid_agg_rx->last_rx = jiffies;
 
 	/* if this mpdu is fragmented - terminate rx aggregation session */
 	sc = le16_to_cpu(hdr->seq_ctrl);
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index ab05768..e21652b 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -101,6 +101,7 @@ enum ieee80211_sta_info_flags {
  * @dialog_token: dialog token for aggregation session
  * @timeout: session timeout value to be filled in ADDBA requests
  * @state: session state (see above)
+ * @last_tx: jiffies of last tx activity
  * @stop_initiator: initiator of a session stop
  * @tx_stop: TX DelBA frame when stopping
  * @buf_size: reorder buffer size at receiver
@@ -122,6 +123,7 @@ struct tid_ampdu_tx {
 	struct timer_list addba_resp_timer;
 	struct sk_buff_head pending;
 	unsigned long state;
+	unsigned long last_tx;
 	u16 timeout;
 	u8 dialog_token;
 	u8 stop_initiator;
@@ -139,6 +141,7 @@ struct tid_ampdu_tx {
  * @reorder_time: jiffies when skb was added
  * @session_timer: check if peer keeps Tx-ing on the TID (by timeout value)
  * @reorder_timer: releases expired frames from the reorder buffer.
+ * @last_rx: jiffies of last rx activity
  * @head_seq_num: head sequence number in reordering buffer.
  * @stored_mpdu_num: number of MPDUs in reordering buffer
  * @ssn: Starting Sequence Number expected to be aggregated.
@@ -163,6 +166,7 @@ struct tid_ampdu_rx {
 	unsigned long *reorder_time;
 	struct timer_list session_timer;
 	struct timer_list reorder_timer;
+	unsigned long last_rx;
 	u16 head_seq_num;
 	u16 stored_mpdu_num;
 	u16 ssn;
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 782a601..5ad2c40 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1118,8 +1118,7 @@ static bool ieee80211_tx_prep_agg(struct ieee80211_tx_data *tx,
 
 	/* reset session timer */
 	if (reset_agg_timer && tid_tx->timeout)
-		mod_timer(&tid_tx->session_timer,
-			  TU_TO_EXP_TIME(tid_tx->timeout));
+		tid_tx->last_tx = jiffies;
 
 	return queued;
 }
-- 
1.7.3.2

