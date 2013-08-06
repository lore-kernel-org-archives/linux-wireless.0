Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:57810 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756218Ab3HFMSY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Aug 2013 08:18:24 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, sujith@msujith.org
Subject: [PATCH v2 07/12] ath9k: prepare queueing code for handling unaggregated traffic
Date: Tue,  6 Aug 2013 14:18:08 +0200
Message-Id: <1375791493-83971-7-git-send-email-nbd@openwrt.org> (sfid-20130806_141832_550773_C46B5AAB)
In-Reply-To: <1375791493-83971-1-git-send-email-nbd@openwrt.org>
References: <1375791493-83971-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

- Allow ath_tx_get_tid_subframe to return non-AMPDU subframes.
- Reset the tid paused state on aggregation stop
- Initialize software queues even when HT is not supported

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/main.c |  3 ---
 drivers/net/wireless/ath/ath9k/xmit.c | 20 ++++++++++++++------
 2 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index afeab3c..252497a 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1371,9 +1371,6 @@ static void ath9k_sta_notify(struct ieee80211_hw *hw,
 	struct ath_softc *sc = hw->priv;
 	struct ath_node *an = (struct ath_node *) sta->drv_priv;
 
-	if (!sta->ht_cap.ht_supported)
-		return;
-
 	switch (cmd) {
 	case STA_NOTIFY_SLEEP:
 		an->sleeping = true;
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index d66e8b8..e69f7fe 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -672,7 +672,7 @@ static void ath_tx_process_buffer(struct ath_softc *sc, struct ath_txq *txq,
 	} else
 		ath_tx_complete_aggr(sc, txq, bf, bf_head, ts, txok);
 
-	if ((sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_HT) && !flush)
+	if (!flush)
 		ath_txq_schedule(sc, txq);
 }
 
@@ -848,6 +848,7 @@ static struct ath_buf *
 ath_tx_get_tid_subframe(struct ath_softc *sc, struct ath_txq *txq,
 			struct ath_atx_tid *tid, struct sk_buff_head **q)
 {
+	struct ieee80211_tx_info *tx_info;
 	struct ath_frame_info *fi;
 	struct sk_buff *skb;
 	struct ath_buf *bf;
@@ -874,6 +875,16 @@ ath_tx_get_tid_subframe(struct ath_softc *sc, struct ath_txq *txq,
 			continue;
 		}
 
+		bf->bf_next = NULL;
+		bf->bf_lastbf = bf;
+
+		tx_info = IEEE80211_SKB_CB(skb);
+		tx_info->flags &= ~IEEE80211_TX_CTL_CLEAR_PS_FILT;
+		if (!(tx_info->flags & IEEE80211_TX_CTL_AMPDU)) {
+			bf->bf_state.bf_type = 0;
+			return bf;
+		}
+
 		bf->bf_state.bf_type = BUF_AMPDU | BUF_AGGR;
 		seqno = bf->bf_state.seqno;
 
@@ -893,8 +904,6 @@ ath_tx_get_tid_subframe(struct ath_softc *sc, struct ath_txq *txq,
 			continue;
 		}
 
-		bf->bf_next = NULL;
-		bf->bf_lastbf = bf;
 		return bf;
 	}
 
@@ -1356,7 +1365,7 @@ void ath_tx_aggr_stop(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid)
 
 	ath_txq_lock(sc, txq);
 	txtid->active = false;
-	txtid->paused = true;
+	txtid->paused = false;
 	ath_tx_flush_tid(sc, txtid);
 	ath_txq_unlock_complete(sc, txq);
 }
@@ -2425,8 +2434,7 @@ static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 
 		if (list_empty(&txq->axq_q)) {
 			txq->axq_link = NULL;
-			if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_HT)
-				ath_txq_schedule(sc, txq);
+			ath_txq_schedule(sc, txq);
 			break;
 		}
 		bf = list_first_entry(&txq->axq_q, struct ath_buf, list);
-- 
1.8.0.2

