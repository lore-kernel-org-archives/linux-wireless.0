Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f179.google.com ([209.85.212.179]:46498 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754543Ab0LNIT5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Dec 2010 03:19:57 -0500
Received: by pxi20 with SMTP id 20so83407pxi.10
        for <linux-wireless@vger.kernel.org>; Tue, 14 Dec 2010 00:19:57 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19719.10364.75022.257291@gargle.gargle.HOWL>
Date: Tue, 14 Dec 2010 13:49:08 +0530
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Sujith <m.sujith@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] mac80211: Change BA timeout
In-Reply-To: <1292312835.3569.5.camel@jlt3.sipsolutions.net>
References: <19719.8288.322475.954293@gargle.gargle.HOWL>
	<1292312835.3569.5.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Tue, 2010-12-14 at 13:14 +0530, Sujith wrote:
> > The BlockAck session timout value is currently an arbitrary 5000.
> > This results in BA sessions being created and torn down incessantly
> > when mac80211 is used with a driver (say ath9k) in AP mode.
> > 
> > The 802.11 standard doesn't specify any default value for the timeout field.
> > And there is no benefit to be gained by tearing down BA sessions and
> > recreating them. The current value of 5000 doesn't cause any problems,
> > but it is hard to find an AP/STA in the field that uses a non-zero timeout.
> 
> Please make it configurable in the request API. Each session consumes
> one of a very limited number of hardware queues on iwlwifi, and once we
> go to having multiple connected stations to it as an AP, it would be
> good to time out idle sessions.

Something like this ?

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index 31fad82..33f3602 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -251,7 +251,7 @@ void ath9k_tx_tasklet(unsigned long data)
 				ista = (struct ath9k_htc_sta *)sta->drv_priv;
 
 				if (ath9k_htc_check_tx_aggr(priv, ista, tid)) {
-					ieee80211_start_tx_ba_session(sta, tid);
+					ieee80211_start_tx_ba_session(sta, tid, 0);
 					spin_lock_bh(&priv->tx_lock);
 					ista->tid_state[tid] = AGGR_PROGRESS;
 					spin_unlock_bh(&priv->tx_lock);
diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index 2061a75..896d129 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -1373,7 +1373,7 @@ static void ath_tx_status(void *priv, struct ieee80211_supported_band *sband,
 			an = (struct ath_node *)sta->drv_priv;
 
 			if(ath_tx_aggr_check(sc, an, tid))
-				ieee80211_start_tx_ba_session(sta, tid);
+				ieee80211_start_tx_ba_session(sta, tid, 0);
 		}
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index f450adc..732b329 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -387,7 +387,7 @@ static int rs_tl_turn_on_agg_for_tid(struct iwl_priv *priv,
 	if (load > IWL_AGG_LOAD_THRESHOLD) {
 		IWL_DEBUG_HT(priv, "Starting Tx agg: STA: %pM tid: %d\n",
 				sta->addr, tid);
-		ret = ieee80211_start_tx_ba_session(sta, tid);
+		ret = ieee80211_start_tx_ba_session(sta, tid, 5000);
 		if (ret == -EAGAIN) {
 			/*
 			 * driver and mac80211 is out of sync
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index e411cf8..69ded1e 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2435,6 +2435,7 @@ void ieee80211_queue_delayed_work(struct ieee80211_hw *hw,
  * ieee80211_start_tx_ba_session - Start a tx Block Ack session.
  * @sta: the station for which to start a BA session
  * @tid: the TID to BA on.
+ * @timeout: session timeout value (in TUs)
  *
  * Return: success if addBA request was sent, failure otherwise
  *
@@ -2442,7 +2443,8 @@ void ieee80211_queue_delayed_work(struct ieee80211_hw *hw,
  * the need to start aggregation on a certain RA/TID, the session level
  * will be managed by the mac80211.
  */
-int ieee80211_start_tx_ba_session(struct ieee80211_sta *sta, u16 tid);
+int ieee80211_start_tx_ba_session(struct ieee80211_sta *sta, u16 tid,
+				  u16 timeout);
 
 /**
  * ieee80211_start_tx_ba_cb_irqsafe - low level driver ready to aggregate.
diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index d4679b2..9cc472c 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -342,10 +342,11 @@ void ieee80211_tx_ba_session_handle_start(struct sta_info *sta, int tid)
 	/* send AddBA request */
 	ieee80211_send_addba_request(sdata, sta->sta.addr, tid,
 				     tid_tx->dialog_token, start_seq_num,
-				     0x40, 5000);
+				     0x40, tid_tx->timeout);
 }
 
-int ieee80211_start_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid)
+int ieee80211_start_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid,
+				  u16 timeout)
 {
 	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
@@ -420,6 +421,8 @@ int ieee80211_start_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid)
 	skb_queue_head_init(&tid_tx->pending);
 	__set_bit(HT_AGG_STATE_WANT_START, &tid_tx->state);
 
+	tid_tx->timeout = timeout;
+
 	/* Tx timer */
 	tid_tx->addba_resp_timer.function = sta_addba_resp_timer_expired;
 	tid_tx->addba_resp_timer.data = (unsigned long)&sta->timer_to_tid[tid];
diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index 8bb5af8..c04a139 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -189,7 +189,7 @@ static ssize_t sta_agg_status_write(struct file *file, const char __user *userbu
 
 	if (tx) {
 		if (start)
-			ret = ieee80211_start_tx_ba_session(&sta->sta, tid);
+			ret = ieee80211_start_tx_ba_session(&sta->sta, tid, 5000);
 		else
 			ret = ieee80211_stop_tx_ba_session(&sta->sta, tid);
 	} else {
diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 4ad7a36..165a451 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -374,7 +374,7 @@ minstrel_aggr_check(struct minstrel_priv *mp, struct ieee80211_sta *pubsta, stru
 	if (skb_get_queue_mapping(skb) == IEEE80211_AC_VO)
 		return;
 
-	ieee80211_start_tx_ba_session(pubsta, tid);
+	ieee80211_start_tx_ba_session(pubsta, tid, 5000);
 }
 
 static void
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index fdca52c..bbdd2a8 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -78,6 +78,7 @@ enum ieee80211_sta_info_flags {
  * @addba_resp_timer: timer for peer's response to addba request
  * @pending: pending frames queue -- use sta's spinlock to protect
  * @dialog_token: dialog token for aggregation session
+ * @timeout: session timeout value to be filled in ADDBA requests
  * @state: session state (see above)
  * @stop_initiator: initiator of a session stop
  * @tx_stop: TX DelBA frame when stopping
@@ -96,6 +97,7 @@ struct tid_ampdu_tx {
 	struct timer_list addba_resp_timer;
 	struct sk_buff_head pending;
 	unsigned long state;
+	u16 timeout;
 	u8 dialog_token;
 	u8 stop_initiator;
 	bool tx_stop;

