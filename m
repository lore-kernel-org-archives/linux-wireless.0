Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:54668 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754655Ab1HJTqC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2011 15:46:02 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com,
	johannes@sipsolutions.net
Subject: [PATCH 2/2] ath9k: use ieee80211_send_bar to send BlockAckReq frames
Date: Wed, 10 Aug 2011 13:45:27 -0600
Message-Id: <1313005527-83182-2-git-send-email-nbd@openwrt.org> (sfid-20110810_214606_663461_DEC1839D)
In-Reply-To: <1313005527-83182-1-git-send-email-nbd@openwrt.org>
References: <1313005527-83182-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of letting mac80211 send one BAR per expired subframe, process
all tx status for an aggregate and if a frame was dropped, send only
one BAR afterwards.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    2 +-
 drivers/net/wireless/ath/ath9k/main.c  |    1 +
 drivers/net/wireless/ath/ath9k/xmit.c  |   31 ++++++++++++++-----------------
 3 files changed, 16 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index c03949e..9cbb7ecd 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -251,6 +251,7 @@ struct ath_atx_tid {
 };
 
 struct ath_node {
+	struct ieee80211_vif *vif;
 #ifdef CONFIG_ATH9K_DEBUGFS
 	struct list_head list; /* for sc->nodes */
 	struct ieee80211_sta *sta; /* station struct we're part of */
@@ -277,7 +278,6 @@ struct ath_tx_control {
 
 #define ATH_TX_ERROR        0x01
 #define ATH_TX_XRETRY       0x02
-#define ATH_TX_BAR          0x04
 
 /**
  * @txq_map:  Index is mac80211 queue number.  This is
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 1e7fe8c..313a768 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1801,6 +1801,7 @@ static int ath9k_sta_add(struct ieee80211_hw *hw,
 	struct ieee80211_key_conf ps_key = { };
 
 	ath_node_attach(sc, sta);
+	an->vif = vif;
 
 	if (vif->type != NL80211_IFTYPE_AP &&
 	    vif->type != NL80211_IFTYPE_AP_VLAN)
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index e815e82..46ac061 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -52,7 +52,7 @@ static void ath_tx_send_normal(struct ath_softc *sc, struct ath_txq *txq,
 			       struct list_head *bf_head);
 static void ath_tx_complete_buf(struct ath_softc *sc, struct ath_buf *bf,
 				struct ath_txq *txq, struct list_head *bf_q,
-				struct ath_tx_status *ts, int txok, int sendbar);
+				struct ath_tx_status *ts, int txok);
 static void ath_tx_txqaddbuf(struct ath_softc *sc, struct ath_txq *txq,
 			     struct list_head *head, bool internal);
 static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf, int len);
@@ -167,7 +167,7 @@ static void ath_tx_flush_tid(struct ath_softc *sc, struct ath_atx_tid *tid)
 		fi = get_frame_info(bf->bf_mpdu);
 		if (fi->retries) {
 			ath_tx_update_baw(sc, tid, fi->seqno);
-			ath_tx_complete_buf(sc, bf, txq, &bf_head, &ts, 0, 1);
+			ath_tx_complete_buf(sc, bf, txq, &bf_head, &ts, 0);
 		} else {
 			ath_tx_send_normal(sc, txq, NULL, &bf_head);
 		}
@@ -239,7 +239,7 @@ static void ath_tid_drain(struct ath_softc *sc, struct ath_txq *txq,
 			ath_tx_update_baw(sc, tid, fi->seqno);
 
 		spin_unlock(&txq->axq_lock);
-		ath_tx_complete_buf(sc, bf, txq, &bf_head, &ts, 0, 0);
+		ath_tx_complete_buf(sc, bf, txq, &bf_head, &ts, 0);
 		spin_lock(&txq->axq_lock);
 	}
 
@@ -382,8 +382,7 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 				list_move_tail(&bf->list, &bf_head);
 
 			ath_tx_rc_status(sc, bf, ts, 1, 1, 0, false);
-			ath_tx_complete_buf(sc, bf, txq, &bf_head, ts,
-				0, 0);
+			ath_tx_complete_buf(sc, bf, txq, &bf_head, ts, 0);
 
 			bf = bf_next;
 		}
@@ -427,7 +426,7 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 
 	ath_tx_count_frames(sc, bf, ts, txok, &nframes, &nbad);
 	while (bf) {
-		txfail = txpending = sendbar = 0;
+		txfail = txpending = 0;
 		bf_next = bf->bf_next;
 
 		skb = bf->bf_mpdu;
@@ -490,7 +489,7 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 			}
 
 			ath_tx_complete_buf(sc, bf, txq, &bf_head, ts,
-				!txfail, sendbar);
+				!txfail);
 		} else {
 			/* retry the un-acked ones */
 			ath9k_hw_set_clrdmask(sc->sc_ah, bf->bf_desc, false);
@@ -515,7 +514,7 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 								nbad, 0, false);
 						ath_tx_complete_buf(sc, bf, txq,
 								    &bf_head,
-								    ts, 0, 0);
+								    ts, 0);
 						break;
 					}
 
@@ -564,6 +563,9 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 		}
 	}
 
+	if (sendbar || (tid->state & AGGR_CLEANUP))
+		ieee80211_send_bar(an->vif, sta->addr, tidno, tid->seq_start << 4);
+
 	rcu_read_unlock();
 
 	if (needreset)
@@ -900,6 +902,7 @@ void ath_tx_aggr_stop(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid)
 	spin_unlock_bh(&txq->axq_lock);
 
 	ath_tx_flush_tid(sc, txtid);
+	ieee80211_send_bar(an->vif, sta->addr, tid, txtid->seq_start << 4);
 }
 
 bool ath_tx_aggr_sleep(struct ath_softc *sc, struct ath_node *an)
@@ -1180,7 +1183,7 @@ static void ath_drain_txq_list(struct ath_softc *sc, struct ath_txq *txq,
 			ath_tx_complete_aggr(sc, txq, bf, &bf_head, &ts, 0,
 					     retry_tx);
 		else
-			ath_tx_complete_buf(sc, bf, txq, &bf_head, &ts, 0, 0);
+			ath_tx_complete_buf(sc, bf, txq, &bf_head, &ts, 0);
 		spin_lock_bh(&txq->axq_lock);
 	}
 }
@@ -1885,9 +1888,6 @@ static void ath_tx_complete(struct ath_softc *sc, struct sk_buff *skb,
 
 	ath_dbg(common, ATH_DBG_XMIT, "TX complete: skb: %p\n", skb);
 
-	if (tx_flags & ATH_TX_BAR)
-		tx_info->flags |= IEEE80211_TX_STAT_AMPDU_NO_BACK;
-
 	if (!(tx_flags & (ATH_TX_ERROR | ATH_TX_XRETRY))) {
 		/* Frame was ACKed */
 		tx_info->flags |= IEEE80211_TX_STAT_ACK;
@@ -1932,15 +1932,12 @@ static void ath_tx_complete(struct ath_softc *sc, struct sk_buff *skb,
 
 static void ath_tx_complete_buf(struct ath_softc *sc, struct ath_buf *bf,
 				struct ath_txq *txq, struct list_head *bf_q,
-				struct ath_tx_status *ts, int txok, int sendbar)
+				struct ath_tx_status *ts, int txok)
 {
 	struct sk_buff *skb = bf->bf_mpdu;
 	unsigned long flags;
 	int tx_flags = 0;
 
-	if (sendbar)
-		tx_flags = ATH_TX_BAR;
-
 	if (!txok) {
 		tx_flags |= ATH_TX_ERROR;
 
@@ -2057,7 +2054,7 @@ static void ath_tx_process_buffer(struct ath_softc *sc, struct ath_txq *txq,
 		if (ts->ts_status & ATH9K_TXERR_XRETRY)
 			bf->bf_state.bf_type |= BUF_XRETRY;
 		ath_tx_rc_status(sc, bf, ts, 1, txok ? 0 : 1, txok, true);
-		ath_tx_complete_buf(sc, bf, txq, bf_head, ts, txok, 0);
+		ath_tx_complete_buf(sc, bf, txq, bf_head, ts, txok);
 	} else
 		ath_tx_complete_aggr(sc, txq, bf, bf_head, ts, txok, true);
 
-- 
1.7.3.2

