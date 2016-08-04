Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:57589 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759014AbcHDVtn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Aug 2016 17:49:43 -0400
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH 2/2] ath9k: improve powersave filter handling
Date: Thu,  4 Aug 2016 23:49:40 +0200
Message-Id: <20160804214940.78476-2-nbd@nbd.name> (sfid-20160804_235001_014377_6FBFC307)
In-Reply-To: <20160804214940.78476-1-nbd@nbd.name>
References: <20160804214940.78476-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For non-aggregated frames, ath9k was leaving handling of powersave
filtered packets to mac80211. This can be too slow if the intermediate
queue is already filled with packets and mac80211 does not immediately
send a new packet via drv_tx().

Improve response time with filtered frames by triggering clearing the
powersave filter internally.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 5693558..a3e292f 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -461,13 +461,13 @@ static void ath_tx_count_frames(struct ath_softc *sc, struct ath_buf *bf,
 static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 				 struct ath_buf *bf, struct list_head *bf_q,
 				 struct ieee80211_sta *sta,
+				 struct ath_atx_tid *tid,
 				 struct ath_tx_status *ts, int txok)
 {
 	struct ath_node *an = NULL;
 	struct sk_buff *skb;
 	struct ieee80211_hdr *hdr;
 	struct ieee80211_tx_info *tx_info;
-	struct ath_atx_tid *tid = NULL;
 	struct ath_buf *bf_next, *bf_last = bf->bf_lastbf;
 	struct list_head bf_head;
 	struct sk_buff_head bf_pending;
@@ -509,7 +509,6 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 	}
 
 	an = (struct ath_node *)sta->drv_priv;
-	tid = ath_get_skb_tid(sc, an, skb);
 	seq_first = tid->seq_start;
 	isba = ts->ts_flags & ATH9K_TX_BA;
 
@@ -695,6 +694,7 @@ static void ath_tx_process_buffer(struct ath_softc *sc, struct ath_txq *txq,
 	struct ieee80211_tx_info *info;
 	struct ieee80211_sta *sta;
 	struct ieee80211_hdr *hdr;
+	struct ath_atx_tid *tid = NULL;
 	bool txok, flush;
 
 	txok = !(ts->ts_status & ATH9K_TXERR_MASK);
@@ -710,6 +710,12 @@ static void ath_tx_process_buffer(struct ath_softc *sc, struct ath_txq *txq,
 
 	hdr = (struct ieee80211_hdr *) bf->bf_mpdu->data;
 	sta = ieee80211_find_sta_by_ifaddr(hw, hdr->addr1, hdr->addr2);
+	if (sta) {
+		struct ath_node *an = (struct ath_node *)sta->drv_priv;
+		tid = ath_get_skb_tid(sc, an, bf->bf_mpdu);
+		if (ts->ts_status & (ATH9K_TXERR_FILT | ATH9K_TXERR_XRETRY))
+			tid->clear_ps_filter = true;
+	}
 
 	if (!bf_isampdu(bf)) {
 		if (!flush) {
@@ -721,7 +727,7 @@ static void ath_tx_process_buffer(struct ath_softc *sc, struct ath_txq *txq,
 		}
 		ath_tx_complete_buf(sc, bf, txq, bf_head, sta, ts, txok);
 	} else
-		ath_tx_complete_aggr(sc, txq, bf, bf_head, sta, ts, txok);
+		ath_tx_complete_aggr(sc, txq, bf, bf_head, sta, tid, ts, txok);
 
 	if (!flush)
 		ath_txq_schedule(sc, txq);
-- 
2.8.4

