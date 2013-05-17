Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:34102 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753669Ab3EQK6c (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 May 2013 06:58:32 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH v2 3.10 1/3] ath9k: fix aggregation stop/flush handling
Date: Fri, 17 May 2013 12:58:24 +0200
Message-Id: <1368788306-1605-1-git-send-email-nbd@openwrt.org> (sfid-20130517_125836_031242_32BA1035)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When aggregation stop is requested, don't run the mac80211 aggregation
stop callback yet, while the session is still blocked.
Also, when aggregation flush is requested, don't run the callback at all.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |  4 ++-
 drivers/net/wireless/ath/ath9k/main.c  |  8 +++--
 drivers/net/wireless/ath/ath9k/xmit.c  | 61 ++++++++++++++++++++++------------
 3 files changed, 48 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 8a1888d..366002f 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -254,6 +254,7 @@ struct ath_atx_tid {
 	int sched;
 	int paused;
 	u8 state;
+	bool stop_cb;
 };
 
 struct ath_node {
@@ -351,7 +352,8 @@ void ath_tx_tasklet(struct ath_softc *sc);
 void ath_tx_edma_tasklet(struct ath_softc *sc);
 int ath_tx_aggr_start(struct ath_softc *sc, struct ieee80211_sta *sta,
 		      u16 tid, u16 *ssn);
-void ath_tx_aggr_stop(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid);
+bool ath_tx_aggr_stop(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid,
+		      bool flush);
 void ath_tx_aggr_resume(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid);
 
 void ath_tx_aggr_wakeup(struct ath_softc *sc, struct ath_node *an);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index a18414b..2382d12 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1687,6 +1687,7 @@ static int ath9k_ampdu_action(struct ieee80211_hw *hw,
 			      u16 tid, u16 *ssn, u8 buf_size)
 {
 	struct ath_softc *sc = hw->priv;
+	bool flush = false;
 	int ret = 0;
 
 	local_bh_disable();
@@ -1703,12 +1704,13 @@ static int ath9k_ampdu_action(struct ieee80211_hw *hw,
 			ieee80211_start_tx_ba_cb_irqsafe(vif, sta->addr, tid);
 		ath9k_ps_restore(sc);
 		break;
-	case IEEE80211_AMPDU_TX_STOP_CONT:
 	case IEEE80211_AMPDU_TX_STOP_FLUSH:
 	case IEEE80211_AMPDU_TX_STOP_FLUSH_CONT:
+		flush = true;
+	case IEEE80211_AMPDU_TX_STOP_CONT:
 		ath9k_ps_wakeup(sc);
-		ath_tx_aggr_stop(sc, sta, tid);
-		ieee80211_stop_tx_ba_cb_irqsafe(vif, sta->addr, tid);
+		if (ath_tx_aggr_stop(sc, sta, tid, flush))
+			ieee80211_stop_tx_ba_cb_irqsafe(vif, sta->addr, tid);
 		ath9k_ps_restore(sc);
 		break;
 	case IEEE80211_AMPDU_TX_OPERATIONAL:
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index eab0fcb..a47bf69 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -164,7 +164,20 @@ static void ath_set_rates(struct ieee80211_vif *vif, struct ieee80211_sta *sta,
 			       ARRAY_SIZE(bf->rates));
 }
 
-static void ath_tx_flush_tid(struct ath_softc *sc, struct ath_atx_tid *tid)
+static void ath_tx_clear_tid(struct ath_softc *sc, struct ath_atx_tid *tid)
+{
+	tid->state &= ~AGGR_ADDBA_COMPLETE;
+	tid->state &= ~AGGR_CLEANUP;
+	if (!tid->stop_cb)
+		return;
+
+	ieee80211_start_tx_ba_cb_irqsafe(tid->an->vif, tid->an->sta->addr,
+					 tid->tidno);
+	tid->stop_cb = false;
+}
+
+static void ath_tx_flush_tid(struct ath_softc *sc, struct ath_atx_tid *tid,
+			     bool flush_packets)
 {
 	struct ath_txq *txq = tid->ac->txq;
 	struct sk_buff *skb;
@@ -181,16 +194,15 @@ static void ath_tx_flush_tid(struct ath_softc *sc, struct ath_atx_tid *tid)
 	while ((skb = __skb_dequeue(&tid->buf_q))) {
 		fi = get_frame_info(skb);
 		bf = fi->bf;
+		if (!bf && !flush_packets)
+			bf = ath_tx_setup_buffer(sc, txq, tid, skb);
 
 		if (!bf) {
-			bf = ath_tx_setup_buffer(sc, txq, tid, skb);
-			if (!bf) {
-				ieee80211_free_txskb(sc->hw, skb);
-				continue;
-			}
+			ieee80211_free_txskb(sc->hw, skb);
+			continue;
 		}
 
-		if (fi->retries) {
+		if (fi->retries || flush_packets) {
 			list_add_tail(&bf->list, &bf_head);
 			ath_tx_update_baw(sc, tid, bf->bf_state.seqno);
 			ath_tx_complete_buf(sc, bf, txq, &bf_head, &ts, 0);
@@ -201,12 +213,10 @@ static void ath_tx_flush_tid(struct ath_softc *sc, struct ath_atx_tid *tid)
 		}
 	}
 
-	if (tid->baw_head == tid->baw_tail) {
-		tid->state &= ~AGGR_ADDBA_COMPLETE;
-		tid->state &= ~AGGR_CLEANUP;
-	}
+	if (tid->baw_head == tid->baw_tail)
+		ath_tx_clear_tid(sc, tid);
 
-	if (sendbar) {
+	if (sendbar && !flush_packets) {
 		ath_txq_unlock(sc, txq);
 		ath_send_bar(tid, tid->seq_start);
 		ath_txq_lock(sc, txq);
@@ -602,7 +612,7 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 	}
 
 	if (tid->state & AGGR_CLEANUP)
-		ath_tx_flush_tid(sc, tid);
+		ath_tx_flush_tid(sc, tid, false);
 
 	rcu_read_unlock();
 
@@ -1256,18 +1266,23 @@ int ath_tx_aggr_start(struct ath_softc *sc, struct ieee80211_sta *sta,
 	return 0;
 }
 
-void ath_tx_aggr_stop(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid)
+bool ath_tx_aggr_stop(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid,
+		      bool flush)
 {
 	struct ath_node *an = (struct ath_node *)sta->drv_priv;
 	struct ath_atx_tid *txtid = ATH_AN_2_TID(an, tid);
 	struct ath_txq *txq = txtid->ac->txq;
+	bool ret = !flush;
+
+	if (flush)
+		txtid->stop_cb = false;
 
 	if (txtid->state & AGGR_CLEANUP)
-		return;
+		return false;
 
 	if (!(txtid->state & AGGR_ADDBA_COMPLETE)) {
 		txtid->state &= ~AGGR_ADDBA_PROGRESS;
-		return;
+		return ret;
 	}
 
 	ath_txq_lock(sc, txq);
@@ -1279,13 +1294,17 @@ void ath_tx_aggr_stop(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid)
 	 * TID can only be reused after all in-progress subframes have been
 	 * completed.
 	 */
-	if (txtid->baw_head != txtid->baw_tail)
+	if (txtid->baw_head != txtid->baw_tail) {
 		txtid->state |= AGGR_CLEANUP;
-	else
+		ret = false;
+		txtid->stop_cb = !flush;
+	} else {
 		txtid->state &= ~AGGR_ADDBA_COMPLETE;
+	}
 
-	ath_tx_flush_tid(sc, txtid);
+	ath_tx_flush_tid(sc, txtid, flush);
 	ath_txq_unlock_complete(sc, txq);
+	return ret;
 }
 
 void ath_tx_aggr_sleep(struct ieee80211_sta *sta, struct ath_softc *sc,
@@ -2415,6 +2434,7 @@ void ath_tx_node_init(struct ath_softc *sc, struct ath_node *an)
 		tid->ac = &an->ac[acno];
 		tid->state &= ~AGGR_ADDBA_COMPLETE;
 		tid->state &= ~AGGR_ADDBA_PROGRESS;
+		tid->stop_cb = false;
 	}
 
 	for (acno = 0, ac = &an->ac[acno];
@@ -2451,8 +2471,7 @@ void ath_tx_node_cleanup(struct ath_softc *sc, struct ath_node *an)
 		}
 
 		ath_tid_drain(sc, txq, tid);
-		tid->state &= ~AGGR_ADDBA_COMPLETE;
-		tid->state &= ~AGGR_CLEANUP;
+		ath_tx_clear_tid(sc, tid);
 
 		ath_txq_unlock(sc, txq);
 	}
-- 
1.8.0.2

