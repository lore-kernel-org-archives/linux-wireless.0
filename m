Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:39945 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752412Ab3ATRwN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jan 2013 12:52:13 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 3/8] ath9k: use ath_tx_process_buffer instead of open-coding similar code
Date: Sun, 20 Jan 2013 18:51:54 +0100
Message-Id: <1358704319-81749-3-git-send-email-nbd@openwrt.org> (sfid-20130120_185221_735143_C03FC7BF)
In-Reply-To: <1358704319-81749-2-git-send-email-nbd@openwrt.org>
References: <1358704319-81749-1-git-send-email-nbd@openwrt.org>
 <1358704319-81749-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 69 ++++++++++++++++-------------------
 1 file changed, 32 insertions(+), 37 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index ac9ee67..feacaaf 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -604,6 +604,37 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 		ath9k_queue_reset(sc, RESET_TYPE_TX_ERROR);
 }
 
+static bool bf_is_ampdu_not_probing(struct ath_buf *bf)
+{
+    struct ieee80211_tx_info *info = IEEE80211_SKB_CB(bf->bf_mpdu);
+    return bf_isampdu(bf) && !(info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE);
+}
+
+static void ath_tx_process_buffer(struct ath_softc *sc, struct ath_txq *txq,
+				  struct ath_tx_status *ts, struct ath_buf *bf,
+				  struct list_head *bf_head)
+{
+	bool txok, flush;
+
+	txok = !(ts->ts_status & ATH9K_TXERR_MASK);
+	flush = !!(ts->ts_status & ATH9K_TX_FLUSH);
+	txq->axq_tx_inprogress = false;
+
+	txq->axq_depth--;
+	if (bf_is_ampdu_not_probing(bf))
+		txq->axq_ampdu_depth--;
+
+	if (!bf_isampdu(bf)) {
+		if (!flush)
+			ath_tx_rc_status(sc, bf, ts, 1, txok ? 0 : 1, txok);
+		ath_tx_complete_buf(sc, bf, txq, bf_head, ts, txok);
+	} else
+		ath_tx_complete_aggr(sc, txq, bf, bf_head, ts, txok);
+
+	if ((sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_HT) && !flush)
+		ath_txq_schedule(sc, txq);
+}
+
 static bool ath_lookup_legacy(struct ath_buf *bf)
 {
 	struct sk_buff *skb;
@@ -1453,12 +1484,6 @@ int ath_cabq_update(struct ath_softc *sc)
 	return 0;
 }
 
-static bool bf_is_ampdu_not_probing(struct ath_buf *bf)
-{
-    struct ieee80211_tx_info *info = IEEE80211_SKB_CB(bf->bf_mpdu);
-    return bf_isampdu(bf) && !(info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE);
-}
-
 static void ath_drain_txq_list(struct ath_softc *sc, struct ath_txq *txq,
 			       struct list_head *list)
 {
@@ -1482,15 +1507,7 @@ static void ath_drain_txq_list(struct ath_softc *sc, struct ath_txq *txq,
 
 		lastbf = bf->bf_lastbf;
 		list_cut_position(&bf_head, list, &lastbf->list);
-
-		txq->axq_depth--;
-		if (bf_is_ampdu_not_probing(bf))
-			txq->axq_ampdu_depth--;
-
-		if (bf_isampdu(bf))
-			ath_tx_complete_aggr(sc, txq, bf, &bf_head, &ts, 0);
-		else
-			ath_tx_complete_buf(sc, bf, txq, &bf_head, &ts, 0);
+		ath_tx_process_buffer(sc, txq, &ts, bf, &bf_head);
 	}
 }
 
@@ -2152,28 +2169,6 @@ static void ath_tx_rc_status(struct ath_softc *sc, struct ath_buf *bf,
 	tx_info->status.rates[tx_rateindex].count = ts->ts_longretry + 1;
 }
 
-static void ath_tx_process_buffer(struct ath_softc *sc, struct ath_txq *txq,
-				  struct ath_tx_status *ts, struct ath_buf *bf,
-				  struct list_head *bf_head)
-{
-	int txok;
-
-	txq->axq_depth--;
-	txok = !(ts->ts_status & ATH9K_TXERR_MASK);
-	txq->axq_tx_inprogress = false;
-	if (bf_is_ampdu_not_probing(bf))
-		txq->axq_ampdu_depth--;
-
-	if (!bf_isampdu(bf)) {
-		ath_tx_rc_status(sc, bf, ts, 1, txok ? 0 : 1, txok);
-		ath_tx_complete_buf(sc, bf, txq, bf_head, ts, txok);
-	} else
-		ath_tx_complete_aggr(sc, txq, bf, bf_head, ts, txok);
-
-	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_HT)
-		ath_txq_schedule(sc, txq);
-}
-
 static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 {
 	struct ath_hw *ah = sc->sc_ah;
-- 
1.8.0.2

