Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:38155 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751206AbdBLN3n (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 12 Feb 2017 08:29:43 -0500
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, toke@toke.dk
Subject: [PATCH] ath9k: clean up and fix ath_tx_count_airtime
Date: Sun, 12 Feb 2017 14:29:31 +0100
Message-Id: <20170212132931.43510-1-nbd@nbd.name> (sfid-20170212_143215_125866_0B3F8C18)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath_tx_count_airtime is doing a lot of unnecessary work:

- Redundant station lookup
- Redundant rcu_read_lock/unlock
- Useless memcpy of bf->rates
- Useless NULL check of bf->bf_mpdu
- Redundant lookup of the skb tid

Additionally, it tries to look up the mac80211 queue index from the txq,
which fails if the frame was delivered via the power save queue.

This patch fixes all of these issues by passing down the right set of
pointers instead of doing extra work

Cc: stable@vger.kernel.org
Fixes: 63fefa050477 ("ath9k: Introduce airtime fairness scheduling between stations")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 52 +++++++++++------------------------
 1 file changed, 16 insertions(+), 36 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 8f9a87915ba9..30efe79e9d89 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -723,51 +723,31 @@ static bool bf_is_ampdu_not_probing(struct ath_buf *bf)
     return bf_isampdu(bf) && !(info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE);
 }
 
-static void ath_tx_count_airtime(struct ath_softc *sc, struct ath_txq *txq,
-				 struct ath_buf *bf, struct ath_tx_status *ts)
+static void ath_tx_count_airtime(struct ath_softc *sc, struct ath_node *an,
+				 struct ath_atx_tid *tid, struct ath_buf *bf,
+				 struct ath_tx_status *ts)
 {
-	struct ath_node *an;
-	struct ath_acq *acq = &sc->cur_chan->acq[txq->mac80211_qnum];
-	struct sk_buff *skb;
-	struct ieee80211_hdr *hdr;
-	struct ieee80211_hw *hw = sc->hw;
-	struct ieee80211_tx_rate rates[4];
-	struct ieee80211_sta *sta;
-	int i;
+	struct ath_txq *txq = tid->txq;
 	u32 airtime = 0;
-
-	skb = bf->bf_mpdu;
-	if(!skb)
-		return;
-
-	hdr = (struct ieee80211_hdr *)skb->data;
-	memcpy(rates, bf->rates, sizeof(rates));
-
-	rcu_read_lock();
-
-	sta = ieee80211_find_sta_by_ifaddr(hw, hdr->addr1, hdr->addr2);
-	if(!sta)
-		goto exit;
-
-
-	an = (struct ath_node *) sta->drv_priv;
+	int i;
 
 	airtime += ts->duration * (ts->ts_longretry + 1);
+	for(i = 0; i < ts->ts_rateindex; i++) {
+		int rate_dur = ath9k_hw_get_duration(sc->sc_ah, bf->bf_desc, i);
+		airtime += rate_dur * bf->rates[i].count;
+	}
 
-	for(i=0; i < ts->ts_rateindex; i++)
-		airtime += ath9k_hw_get_duration(sc->sc_ah, bf->bf_desc, i) * rates[i].count;
+	if (sc->airtime_flags & AIRTIME_USE_TX) {
+		int q = txq->mac80211_qnum;
+		struct ath_acq *acq = &sc->cur_chan->acq[q];
 
-	if (!!(sc->airtime_flags & AIRTIME_USE_TX)) {
 		spin_lock_bh(&acq->lock);
-		an->airtime_deficit[txq->mac80211_qnum] -= airtime;
-		if (an->airtime_deficit[txq->mac80211_qnum] <= 0)
-			__ath_tx_queue_tid(sc, ath_get_skb_tid(sc, an, skb));
+		an->airtime_deficit[q] -= airtime;
+		if (an->airtime_deficit[q] <= 0)
+			__ath_tx_queue_tid(sc, tid);
 		spin_unlock_bh(&acq->lock);
 	}
 	ath_debug_airtime(sc, an, 0, airtime);
-
-exit:
-	rcu_read_unlock();
 }
 
 static void ath_tx_process_buffer(struct ath_softc *sc, struct ath_txq *txq,
@@ -791,13 +771,13 @@ static void ath_tx_process_buffer(struct ath_softc *sc, struct ath_txq *txq,
 
 	ts->duration = ath9k_hw_get_duration(sc->sc_ah, bf->bf_desc,
 					     ts->ts_rateindex);
-	ath_tx_count_airtime(sc, txq, bf, ts);
 
 	hdr = (struct ieee80211_hdr *) bf->bf_mpdu->data;
 	sta = ieee80211_find_sta_by_ifaddr(hw, hdr->addr1, hdr->addr2);
 	if (sta) {
 		struct ath_node *an = (struct ath_node *)sta->drv_priv;
 		tid = ath_get_skb_tid(sc, an, bf->bf_mpdu);
+		ath_tx_count_airtime(sc, an, tid, bf, ts);
 		if (ts->ts_status & (ATH9K_TXERR_FILT | ATH9K_TXERR_XRETRY))
 			tid->clear_ps_filter = true;
 	}
-- 
2.11.0
