Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:56652 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753770Ab1LLUGh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Dec 2011 15:06:37 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 3/6] ath9k: reduce indentation level in a few places
Date: Mon, 12 Dec 2011 21:06:23 +0100
Message-Id: <1323720386-46132-3-git-send-email-nbd@openwrt.org> (sfid-20111212_210640_909672_E60782F2)
In-Reply-To: <1323720386-46132-2-git-send-email-nbd@openwrt.org>
References: <1323720386-46132-1-git-send-email-nbd@openwrt.org>
 <1323720386-46132-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/xmit.c |  125 ++++++++++++++++-----------------
 1 files changed, 60 insertions(+), 65 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 649a11e..b1a37d2 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -480,27 +480,25 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 		} else if (!isaggr && txok) {
 			/* transmit completion */
 			acked_cnt++;
+		} else if ((tid->state & AGGR_CLEANUP) || !retry) {
+			/*
+			 * cleanup in progress, just fail
+			 * the un-acked sub-frames
+			 */
+			txfail = 1;
+		} else if (flush) {
+			txpending = 1;
+		} else if (fi->retries < ATH_MAX_SW_RETRIES) {
+			if (txok || !an->sleeping)
+				ath_tx_set_retry(sc, txq, bf->bf_mpdu,
+						 retries);
+
+			txpending = 1;
 		} else {
-			if ((tid->state & AGGR_CLEANUP) || !retry) {
-				/*
-				 * cleanup in progress, just fail
-				 * the un-acked sub-frames
-				 */
-				txfail = 1;
-			} else if (flush) {
-				txpending = 1;
-			} else if (fi->retries < ATH_MAX_SW_RETRIES) {
-				if (txok || !an->sleeping)
-					ath_tx_set_retry(sc, txq, bf->bf_mpdu,
-							 retries);
-
-				txpending = 1;
-			} else {
-				txfail = 1;
-				txfail_cnt++;
-				bar_index = max_t(int, bar_index,
-					ATH_BA_INDEX(seq_first, seqno));
-			}
+			txfail = 1;
+			txfail_cnt++;
+			bar_index = max_t(int, bar_index,
+				ATH_BA_INDEX(seq_first, seqno));
 		}
 
 		/*
@@ -531,32 +529,29 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 				!txfail);
 		} else {
 			/* retry the un-acked ones */
-			if (!(sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA)) {
-				if (bf->bf_next == NULL && bf_last->bf_stale) {
-					struct ath_buf *tbf;
-
-					tbf = ath_clone_txbuf(sc, bf_last);
-					/*
-					 * Update tx baw and complete the
-					 * frame with failed status if we
-					 * run out of tx buf.
-					 */
-					if (!tbf) {
-						spin_lock_bh(&txq->axq_lock);
-						ath_tx_update_baw(sc, tid, seqno);
-						spin_unlock_bh(&txq->axq_lock);
-
-						ath_tx_complete_buf(sc, bf, txq,
-								    &bf_head,
-								    ts, 0);
-						bar_index = max_t(int, bar_index,
-							ATH_BA_INDEX(seq_first,
-								seqno));
-						break;
-					}
-
-					fi->bf = tbf;
+			if (!(sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA) &&
+			    bf->bf_next == NULL && bf_last->bf_stale) {
+				struct ath_buf *tbf;
+
+				tbf = ath_clone_txbuf(sc, bf_last);
+				/*
+				 * Update tx baw and complete the
+				 * frame with failed status if we
+				 * run out of tx buf.
+				 */
+				if (!tbf) {
+					spin_lock_bh(&txq->axq_lock);
+					ath_tx_update_baw(sc, tid, seqno);
+					spin_unlock_bh(&txq->axq_lock);
+
+					ath_tx_complete_buf(sc, bf, txq,
+							    &bf_head, ts, 0);
+					bar_index = max_t(int, bar_index,
+						ATH_BA_INDEX(seq_first, seqno));
+					break;
 				}
+
+				fi->bf = tbf;
 			}
 
 			/*
@@ -644,24 +639,26 @@ static u32 ath_lookup_rate(struct ath_softc *sc, struct ath_buf *bf,
 	max_4ms_framelen = ATH_AMPDU_LIMIT_MAX;
 
 	for (i = 0; i < 4; i++) {
-		if (rates[i].count) {
-			int modeidx;
-			if (!(rates[i].flags & IEEE80211_TX_RC_MCS)) {
-				legacy = 1;
-				break;
-			}
-
-			if (rates[i].flags & IEEE80211_TX_RC_40_MHZ_WIDTH)
-				modeidx = MCS_HT40;
-			else
-				modeidx = MCS_HT20;
+		int modeidx;
 
-			if (rates[i].flags & IEEE80211_TX_RC_SHORT_GI)
-				modeidx++;
+		if (!rates[i].count)
+			continue;
 
-			frmlen = ath_max_4ms_framelen[modeidx][rates[i].idx];
-			max_4ms_framelen = min(max_4ms_framelen, frmlen);
+		if (!(rates[i].flags & IEEE80211_TX_RC_MCS)) {
+			legacy = 1;
+			break;
 		}
+
+		if (rates[i].flags & IEEE80211_TX_RC_40_MHZ_WIDTH)
+			modeidx = MCS_HT40;
+		else
+			modeidx = MCS_HT20;
+
+		if (rates[i].flags & IEEE80211_TX_RC_SHORT_GI)
+			modeidx++;
+
+		frmlen = ath_max_4ms_framelen[modeidx][rates[i].idx];
+		max_4ms_framelen = min(max_4ms_framelen, frmlen);
 	}
 
 	/*
@@ -1587,11 +1584,9 @@ void ath_txq_schedule(struct ath_softc *sc, struct ath_txq *txq)
 				break;
 		}
 
-		if (!list_empty(&ac->tid_q)) {
-			if (!ac->sched) {
-				ac->sched = true;
-				list_add_tail(&ac->list, &txq->axq_acq);
-			}
+		if (!list_empty(&ac->tid_q) && !ac->sched) {
+			ac->sched = true;
+			list_add_tail(&ac->list, &txq->axq_acq);
 		}
 
 		if (ac == last_ac ||
-- 
1.7.3.2

