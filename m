Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:61640 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752234AbZFRF3v (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2009 01:29:51 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 17 Jun 2009 22:29:55 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Luis.Rodriguez@atheros.com>,
	<Jouni.Malinen@atheros.com>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 1/4] ath9k: Remove dead code in rate control
Date: Thu, 18 Jun 2009 10:53:29 +0530
Message-ID: <1245302612-18112-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath9k rate control is based on only PER (packet error rate),
remove unused code which was intented to do rssi based rate
selection.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/rc.c |  163 +----------------------------------
 1 files changed, 4 insertions(+), 159 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index e66734c..a39b1a7 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -607,47 +607,14 @@ static u8 ath_rc_get_highest_rix(struct ath_softc *sc,
 				 const struct ath_rate_table *rate_table,
 				 int *is_probing)
 {
-	u32 dt, best_thruput, this_thruput, now_msec;
+	u32 best_thruput, this_thruput, now_msec;
 	u8 rate, next_rate, best_rate, maxindex, minindex;
-	int8_t  rssi_last, rssi_reduce = 0, index = 0;
-
-	*is_probing = 0;
-
-	rssi_last = median(ath_rc_priv->rssi_last,
-			   ath_rc_priv->rssi_last_prev,
-			   ath_rc_priv->rssi_last_prev2);
-
-	/*
-	 * Age (reduce) last ack rssi based on how old it is.
-	 * The bizarre numbers are so the delta is 160msec,
-	 * meaning we divide by 16.
-	 *   0msec   <= dt <= 25msec:   don't derate
-	 *   25msec  <= dt <= 185msec:  derate linearly from 0 to 10dB
-	 *   185msec <= dt:             derate by 10dB
-	 */
+	int8_t index = 0;
 
 	now_msec = jiffies_to_msecs(jiffies);
-	dt = now_msec - ath_rc_priv->rssi_time;
-
-	if (dt >= 185)
-		rssi_reduce = 10;
-	else if (dt >= 25)
-		rssi_reduce = (u8)((dt - 25) >> 4);
-
-	/* Now reduce rssi_last by rssi_reduce */
-	if (rssi_last < rssi_reduce)
-		rssi_last = 0;
-	else
-		rssi_last -= rssi_reduce;
-
-	/*
-	 * Now look up the rate in the rssi table and return it.
-	 * If no rates match then we return 0 (lowest rate)
-	 */
-
+	*is_probing = 0;
 	best_thruput = 0;
 	maxindex = ath_rc_priv->max_valid_rate-1;
-
 	minindex = 0;
 	best_rate = minindex;
 
@@ -687,7 +654,6 @@ static u8 ath_rc_get_highest_rix(struct ath_softc *sc,
 	}
 
 	rate = best_rate;
-	ath_rc_priv->rssi_last_lookup = rssi_last;
 
 	/*
 	 * Must check the actual rate (ratekbps) to account for
@@ -977,10 +943,6 @@ static bool ath_rc_update_per(struct ath_softc *sc,
 				     (nretry_to_per_lookup[retries] >> 3));
 		}
 
-		ath_rc_priv->rssi_last_prev2 = ath_rc_priv->rssi_last_prev;
-		ath_rc_priv->rssi_last_prev  = ath_rc_priv->rssi_last;
-		ath_rc_priv->rssi_last = tx_info_priv->tx.ts_rssi;
-		ath_rc_priv->rssi_time = now_msec;
 
 		/*
 		 * If we got at most one retry then increase the max rate if
@@ -1024,18 +986,9 @@ static bool ath_rc_update_per(struct ath_softc *sc,
 			/*
 			 * Don't update anything.  We don't know if
 			 * this was because of collisions or poor signal.
-			 *
-			 * Later: if rssi_ack is close to
-			 * ath_rc_priv->state[txRate].rssi_thres and we see lots
-			 * of retries, then we could increase
-			 * ath_rc_priv->state[txRate].rssi_thres.
 			 */
 			ath_rc_priv->hw_maxretry_pktcnt = 0;
 		} else {
-			int32_t rssi_ackAvg;
-			int8_t rssi_thres;
-			int8_t rssi_ack_vmin;
-
 			/*
 			 * It worked with no retries. First ignore bogus (small)
 			 * rssi_ack values.
@@ -1045,43 +998,9 @@ static bool ath_rc_update_per(struct ath_softc *sc,
 				ath_rc_priv->hw_maxretry_pktcnt++;
 			}
 
-			if (tx_info_priv->tx.ts_rssi <
-			    rate_table->info[tx_rate].rssi_ack_validmin)
-				goto exit;
-
-			/* Average the rssi */
-			if (tx_rate != ath_rc_priv->rssi_sum_rate) {
-				ath_rc_priv->rssi_sum_rate = tx_rate;
-				ath_rc_priv->rssi_sum =
-					ath_rc_priv->rssi_sum_cnt = 0;
-			}
-
-			ath_rc_priv->rssi_sum += tx_info_priv->tx.ts_rssi;
-			ath_rc_priv->rssi_sum_cnt++;
-
-			if (ath_rc_priv->rssi_sum_cnt < 4)
-				goto exit;
-
-			rssi_ackAvg =
-				(ath_rc_priv->rssi_sum + 2) / 4;
-			rssi_thres =
-				ath_rc_priv->state[tx_rate].rssi_thres;
-			rssi_ack_vmin =
-				rate_table->info[tx_rate].rssi_ack_validmin;
-
-			ath_rc_priv->rssi_sum =
-				ath_rc_priv->rssi_sum_cnt = 0;
-
-			/* Now reduce the current rssi threshold */
-			if ((rssi_ackAvg < rssi_thres + 2) &&
-			    (rssi_thres > rssi_ack_vmin)) {
-				ath_rc_priv->state[tx_rate].rssi_thres--;
-			}
-
-			state_change = true;
 		}
 	}
-exit:
+
 	return state_change;
 }
 
@@ -1093,11 +1012,6 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 			     struct ath_tx_info_priv *tx_info_priv,
 			     int tx_rate, int xretries, int retries)
 {
-#define CHK_RSSI(rate)					\
-	((ath_rc_priv->state[(rate)].rssi_thres +	\
-	  rate_table->info[(rate)].rssi_ack_deltamin) > \
-	 ath_rc_priv->state[(rate)+1].rssi_thres)
-
 	u32 now_msec = jiffies_to_msecs(jiffies);
 	int rate;
 	u8 last_per;
@@ -1108,13 +1022,6 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 	if ((tx_rate < 0) || (tx_rate > rate_table->rate_cnt))
 		return;
 
-	/* To compensate for some imbalance between ctrl and ext. channel */
-
-	if (WLAN_RC_PHY_40(rate_table->info[tx_rate].phy))
-		tx_info_priv->tx.ts_rssi =
-			tx_info_priv->tx.ts_rssi < 3 ? 0 :
-			tx_info_priv->tx.ts_rssi - 3;
-
 	last_per = ath_rc_priv->state[tx_rate].per;
 
 	/* Update PER first */
@@ -1136,51 +1043,6 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 		ath_rc_priv->probe_time = now_msec;
 	}
 
-	if (state_change) {
-		/*
-		 * Make sure the rates above this have higher rssi thresholds.
-		 * (Note:  Monotonicity is kept within the OFDM rates and
-		 *         within the CCK rates. However, no adjustment is
-		 *         made to keep the rssi thresholds monotonically
-		 *         increasing between the CCK and OFDM rates.)
-		 */
-		for (rate = tx_rate; rate < size - 1; rate++) {
-			if (rate_table->info[rate+1].phy !=
-			    rate_table->info[tx_rate].phy)
-				break;
-
-			if (CHK_RSSI(rate)) {
-				ath_rc_priv->state[rate+1].rssi_thres =
-					ath_rc_priv->state[rate].rssi_thres +
-					rate_table->info[rate].rssi_ack_deltamin;
-			}
-		}
-
-		/* Make sure the rates below this have lower rssi thresholds. */
-		for (rate = tx_rate - 1; rate >= 0; rate--) {
-			if (rate_table->info[rate].phy !=
-			    rate_table->info[tx_rate].phy)
-				break;
-
-			if (CHK_RSSI(rate)) {
-				if (ath_rc_priv->state[rate+1].rssi_thres <
-				    rate_table->info[rate].rssi_ack_deltamin)
-					ath_rc_priv->state[rate].rssi_thres = 0;
-				else {
-					ath_rc_priv->state[rate].rssi_thres =
-					ath_rc_priv->state[rate+1].rssi_thres -
-					rate_table->info[rate].rssi_ack_deltamin;
-				}
-
-				if (ath_rc_priv->state[rate].rssi_thres <
-				    rate_table->info[rate].rssi_ack_validmin) {
-					ath_rc_priv->state[rate].rssi_thres =
-					rate_table->info[rate].rssi_ack_validmin;
-				}
-			}
-		}
-	}
-
 	/* Make sure the rates below this have lower PER */
 	/* Monotonicity is kept only for rates below the current rate. */
 	if (ath_rc_priv->state[tx_rate].per < last_per) {
@@ -1205,19 +1067,6 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 				ath_rc_priv->state[rate].per;
 	}
 
-	/* Every so often, we reduce the thresholds and
-	 * PER (different for CCK and OFDM). */
-	if (now_msec - ath_rc_priv->rssi_down_time >=
-	    rate_table->rssi_reduce_interval) {
-
-		for (rate = 0; rate < size; rate++) {
-			if (ath_rc_priv->state[rate].rssi_thres >
-			    rate_table->info[rate].rssi_ack_validmin)
-				ath_rc_priv->state[rate].rssi_thres -= 1;
-		}
-		ath_rc_priv->rssi_down_time = now_msec;
-	}
-
 	/* Every so often, we reduce the thresholds
 	 * and PER (different for CCK and OFDM). */
 	if (now_msec - ath_rc_priv->per_down_time >=
@@ -1233,7 +1082,6 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 	ath_debug_stat_retries(sc, tx_rate, xretries, retries,
 			       ath_rc_priv->state[tx_rate].per);
 
-#undef CHK_RSSI
 }
 
 static int ath_rc_get_rateindex(const struct ath_rate_table *rate_table,
@@ -1369,8 +1217,6 @@ static void ath_rc_init(struct ath_softc *sc,
 
 	/* Initialize thresholds according to the global rate table */
 	for (i = 0 ; i < ath_rc_priv->rate_table_size; i++) {
-		ath_rc_priv->state[i].rssi_thres =
-			rate_table->info[i].rssi_ack_validmin;
 		ath_rc_priv->state[i].per = 0;
 	}
 
@@ -1631,7 +1477,6 @@ static void *ath_rate_alloc_sta(void *priv, struct ieee80211_sta *sta, gfp_t gfp
 		return NULL;
 	}
 
-	rate_priv->rssi_down_time = jiffies_to_msecs(jiffies);
 	rate_priv->tx_triglevel_max = sc->sc_ah->caps.tx_triglevel_max;
 
 	return rate_priv;
-- 
1.5.5.1

