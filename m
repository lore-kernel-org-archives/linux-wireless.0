Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:34417 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754185Ab0FXX0W (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jun 2010 19:26:22 -0400
Message-ID: <4C23E998.2050401@openwrt.org>
Date: Fri, 25 Jun 2010 01:26:16 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	=?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
Subject: [PATCH] ath9k: fix retry count for A-MPDU rate control status reports
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The 'bf_retries' field of the ath_buf structure was used for both
software retries (AMPDU subframes) and hardware retries (legacy
frames). This led to a wrong retry count being reported for the A-MPDU
rate control stats.
This patch changes the code to no longer use bf_retries for reporting
retry counts, but instead always using the real on-chip retry count
from the ath_tx_status.
Additionally, if the first subframe of an A-MPDU was not acked, the tx
status report is submitted along with the first acked subframe, which
may not contain the correct rates in the tx info.
This is easily corrected by saving the tx rate info before looping over
subframes, and then copying it back once the A-MPDU status report is
submitted.
In my tests this change improves throughput visibly.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Reported-by: Björn Smedman <bjorn.smedman@venatech.se>
Cc: stable@kernel.org
---
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -328,6 +328,7 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 	u32 ba[WME_BA_BMP_SIZE >> 5];
 	int isaggr, txfail, txpending, sendbar = 0, needreset = 0, nbad = 0;
 	bool rc_update = true;
+	struct ieee80211_tx_rate rates[4];
 
 	skb = bf->bf_mpdu;
 	hdr = (struct ieee80211_hdr *)skb->data;
@@ -335,6 +336,8 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 	tx_info = IEEE80211_SKB_CB(skb);
 	hw = bf->aphy->hw;
 
+	memcpy(rates, tx_info->control.rates, sizeof(rates));
+
 	rcu_read_lock();
 
 	/* XXX: use ieee80211_find_sta! */
@@ -375,6 +378,9 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 		txfail = txpending = 0;
 		bf_next = bf->bf_next;
 
+		skb = bf->bf_mpdu;
+		tx_info = IEEE80211_SKB_CB(skb);
+
 		if (ATH_BA_ISSET(ba, ATH_BA_INDEX(seq_st, bf->bf_seqno))) {
 			/* transmit completion, subframe is
 			 * acked by block ack */
@@ -428,6 +434,7 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 			spin_unlock_bh(&txq->axq_lock);
 
 			if (rc_update && (acked_cnt == 1 || txfail_cnt == 1)) {
+				memcpy(tx_info->control.rates, rates, sizeof(rates));
 				ath_tx_rc_status(bf, ts, nbad, txok, true);
 				rc_update = false;
 			} else {
@@ -2033,7 +2040,7 @@ static void ath_tx_rc_status(struct ath_buf *bf, struct ath_tx_status *ts,
 		tx_info->status.rates[i].idx = -1;
 	}
 
-	tx_info->status.rates[tx_rateindex].count = bf->bf_retries + 1;
+	tx_info->status.rates[tx_rateindex].count = ts->ts_longretry + 1;
 }
 
 static void ath_wake_mac80211_queue(struct ath_softc *sc, struct ath_txq *txq)
@@ -2144,7 +2151,6 @@ static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 			 * This frame is sent out as a single frame.
 			 * Use hardware retry status for this frame.
 			 */
-			bf->bf_retries = ts.ts_longretry;
 			if (ts.ts_status & ATH9K_TXERR_XRETRY)
 				bf->bf_state.bf_type |= BUF_XRETRY;
 			ath_tx_rc_status(bf, &ts, 0, txok, true);
@@ -2274,7 +2280,6 @@ void ath_tx_edma_tasklet(struct ath_softc *sc)
 		}
 
 		if (!bf_isampdu(bf)) {
-			bf->bf_retries = txs.ts_longretry;
 			if (txs.ts_status & ATH9K_TXERR_XRETRY)
 				bf->bf_state.bf_type |= BUF_XRETRY;
 			ath_tx_rc_status(bf, &txs, 0, txok, true);

