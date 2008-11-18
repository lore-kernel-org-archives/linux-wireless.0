Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:28111 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753451AbYKRDl1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Nov 2008 22:41:27 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 17 Nov 2008 19:41:26 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18722.14521.113269.147690@gargle.gargle.HOWL> (sfid-20081118_044134_469220_89D69EFE)
Date: Tue, 18 Nov 2008 09:08:33 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 14/18] ath9k: Use helpers
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Break down huge functions, use helper functions or
macros instead.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/rc.c |  386 +++++++++++++++++++--------------------
 drivers/net/wireless/ath9k/rc.h |    5 +
 2 files changed, 194 insertions(+), 197 deletions(-)

diff --git a/drivers/net/wireless/ath9k/rc.c b/drivers/net/wireless/ath9k/rc.c
index 51f51af..e118824 100644
--- a/drivers/net/wireless/ath9k/rc.c
+++ b/drivers/net/wireless/ath9k/rc.c
@@ -153,11 +153,6 @@ static struct ath_rate_table ar5416_11na_ratetable = {
 	WLAN_RC_HT_FLAG,  /* Phy rates allowed initially */
 };
 
-/* VALID_ALL - valid for 20/40/Legacy,
- * VALID - Legacy only,
- * VALID_20 - HT 20 only,
- * VALID_40 - HT 40 only */
-
 /* 4ms frame limit not used for NG mode.  The values filled
  * for HT are the 64K max aggregate limit */
 
@@ -471,11 +466,10 @@ static inline int ath_rc_isvalid_txmask(struct ath_rate_priv *ath_rc_priv,
 	return ath_rc_priv->valid_rate_index[index];
 }
 
-static inline int
-ath_rc_get_nextvalid_txrate(struct ath_rate_table *rate_table,
-			    struct ath_rate_priv *ath_rc_priv,
-			    u8 cur_valid_txrate,
-			    u8 *next_idx)
+static inline int ath_rc_get_nextvalid_txrate(struct ath_rate_table *rate_table,
+					      struct ath_rate_priv *ath_rc_priv,
+					      u8 cur_valid_txrate,
+					      u8 *next_idx)
 {
 	u8 i;
 
@@ -488,6 +482,7 @@ ath_rc_get_nextvalid_txrate(struct ath_rate_table *rate_table,
 
 	/* No more valid rates */
 	*next_idx = 0;
+
 	return 0;
 }
 
@@ -522,13 +517,13 @@ ath_rc_get_nextlowervalid_txrate(struct ath_rate_table *rate_table,
 			return 1;
 		}
 	}
+
 	return 0;
 }
 
-static u8
-ath_rc_sib_init_validrates(struct ath_rate_priv *ath_rc_priv,
-			   struct ath_rate_table *rate_table,
-			   u32 capflag)
+static u8 ath_rc_init_validrates(struct ath_rate_priv *ath_rc_priv,
+				 struct ath_rate_table *rate_table,
+				 u32 capflag)
 {
 	u8 i, hi = 0;
 	u32 valid;
@@ -552,14 +547,14 @@ ath_rc_sib_init_validrates(struct ath_rate_priv *ath_rc_priv,
 			hi = A_MAX(hi, i);
 		}
 	}
+
 	return hi;
 }
 
-static u8
-ath_rc_sib_setvalid_rates(struct ath_rate_priv *ath_rc_priv,
-			  struct ath_rate_table *rate_table,
-			  struct ath_rateset *rateset,
-			  u32 capflag)
+static u8 ath_rc_setvalid_rates(struct ath_rate_priv *ath_rc_priv,
+				struct ath_rate_table *rate_table,
+				struct ath_rateset *rateset,
+				u32 capflag)
 {
 	u8 i, j, hi = 0;
 
@@ -570,17 +565,17 @@ ath_rc_sib_setvalid_rates(struct ath_rate_priv *ath_rc_priv,
 			u32 valid = (ath_rc_priv->single_stream ?
 				rate_table->info[j].valid_single_stream :
 				rate_table->info[j].valid);
+			u8 rate = rateset->rs_rates[i];
+			u8 dot11rate = rate_table->info[j].dot11rate;
 
 			/* We allow a rate only if its valid and the
 			 * capflag matches one of the validity
 			 * (VALID/VALID_20/VALID_40) flags */
 
-			if (((rateset->rs_rates[i] & 0x7F) ==
-				(rate_table->info[j].dot11rate & 0x7F)) &&
-				((valid & WLAN_RC_CAP_MODE(capflag)) ==
-				WLAN_RC_CAP_MODE(capflag)) &&
-				!WLAN_RC_PHY_HT(phy)) {
-
+			if (((rate & 0x7F) == (dot11rate & 0x7F)) &&
+			    ((valid & WLAN_RC_CAP_MODE(capflag)) ==
+			     WLAN_RC_CAP_MODE(capflag)) &&
+			    !WLAN_RC_PHY_HT(phy)) {
 				u8 valid_rate_count = 0;
 
 				if (!ath_rc_valid_phyrate(phy, capflag, 0))
@@ -597,27 +592,29 @@ ath_rc_sib_setvalid_rates(struct ath_rate_priv *ath_rc_priv,
 			}
 		}
 	}
+
 	return hi;
 }
 
-static u8
-ath_rc_sib_setvalid_htrates(struct ath_rate_priv *ath_rc_priv,
-			    struct ath_rate_table *rate_table,
-			    u8 *mcs_set, u32 capflag)
+static u8 ath_rc_setvalid_htrates(struct ath_rate_priv *ath_rc_priv,
+				  struct ath_rate_table *rate_table,
+				  u8 *mcs_set, u32 capflag)
 {
+	struct ath_rateset *rateset = (struct ath_rateset *)mcs_set;
+
 	u8 i, j, hi = 0;
 
 	/* Use intersection of working rates and valid rates */
-	for (i = 0; i <  ((struct ath_rateset *)mcs_set)->rs_nrates; i++) {
+	for (i = 0; i < rateset->rs_nrates; i++) {
 		for (j = 0; j < rate_table->rate_cnt; j++) {
 			u32 phy = rate_table->info[j].phy;
 			u32 valid = (ath_rc_priv->single_stream ?
 				     rate_table->info[j].valid_single_stream :
 				     rate_table->info[j].valid);
+			u8 rate = rateset->rs_rates[i];
+			u8 dot11rate = rate_table->info[j].dot11rate;
 
-			if (((((struct ath_rateset *)
-			       mcs_set)->rs_rates[i] & 0x7F) !=
-			     (rate_table->info[j].dot11rate & 0x7F)) ||
+			if (((rate & 0x7F) != (dot11rate & 0x7F)) ||
 			    !WLAN_RC_PHY_HT(phy) ||
 			    !WLAN_RC_PHY_HT_VALID(valid, capflag))
 				continue;
@@ -632,26 +629,8 @@ ath_rc_sib_setvalid_htrates(struct ath_rate_priv *ath_rc_priv,
 			hi = A_MAX(hi, j);
 		}
 	}
-	return hi;
-}
-
-u8 ath_rate_findrateix(struct ath_softc *sc,
-		       u8 dot11rate)
-{
-	struct ath_rate_table *ratetable;
-	int i;
-
-	ratetable = sc->hw_rate_table[sc->sc_curmode];
-
-	if (WARN_ON(!ratetable))
-		return 0;
-
-	for (i = 0; i < ratetable->rate_cnt; i++) {
-		if ((ratetable->info[i].dot11rate & 0x7f) == (dot11rate & 0x7f))
-			return i;
-	}
 
-	return 0;
+	return hi;
 }
 
 static u8 ath_rc_ratefind_ht(struct ath_softc *sc,
@@ -784,9 +763,7 @@ static u8 ath_rc_ratefind_ht(struct ath_softc *sc,
 
 static void ath_rc_rate_set_series(struct ath_rate_table *rate_table ,
 				   struct ieee80211_tx_rate *rate,
-				   u8 tries,
-				   u8 rix,
-				   int rtsctsenable)
+				   u8 tries, u8 rix, int rtsctsenable)
 {
 	rate->count = tries;
 	rate->idx = rix;
@@ -911,15 +888,16 @@ static void ath_rc_ratefind(struct ath_softc *sc,
 	}
 }
 
-static void ath_rc_update_ht(struct ath_softc *sc,
-			     struct ath_rate_priv *ath_rc_priv,
-			     struct ath_tx_info_priv *tx_info_priv,
-			     int tx_rate, int xretries, int retries)
+static bool ath_rc_update_per(struct ath_softc *sc,
+			      struct ath_rate_table *rate_table,
+			      struct ath_rate_priv *ath_rc_priv,
+			      struct ath_tx_info_priv *tx_info_priv,
+			      int tx_rate, int xretries, int retries,
+			      u32 now_msec)
 {
-	u32 now_msec = jiffies_to_msecs(jiffies);
-	int state_change = 0, rate, count;
+	bool state_change = false;
+	int count;
 	u8 last_per;
-	struct ath_rate_table *rate_table = sc->hw_rate_table[sc->sc_curmode];
 	static u32 nretry_to_per_lookup[10] = {
 		100 * 0 / 1,
 		100 * 1 / 4,
@@ -933,24 +911,9 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 		100 * 9 / 10
 	};
 
-	if (!ath_rc_priv)
-		return;
-
-	ASSERT(tx_rate >= 0);
-	if (tx_rate < 0)
-		return;
-
-	/* To compensate for some imbalance between ctrl and ext. channel */
-
-	if (WLAN_RC_PHY_40(rate_table->info[tx_rate].phy))
-		tx_info_priv->tx.ts_rssi =
-			tx_info_priv->tx.ts_rssi < 3 ? 0 :
-			tx_info_priv->tx.ts_rssi - 3;
-
 	last_per = ath_rc_priv->state[tx_rate].per;
 
 	if (xretries) {
-		/* Update the PER. */
 		if (xretries == 1) {
 			ath_rc_priv->state[tx_rate].per += 30;
 			if (ath_rc_priv->state[tx_rate].per > 100)
@@ -960,11 +923,10 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 			count = ARRAY_SIZE(nretry_to_per_lookup);
 			if (retries >= count)
 				retries = count - 1;
+
 			/* new_PER = 7/8*old_PER + 1/8*(currentPER) */
 			ath_rc_priv->state[tx_rate].per =
-				(u8)(ath_rc_priv->state[tx_rate].per -
-				     (ath_rc_priv->state[tx_rate].per >> 3) +
-				     ((100) >> 3));
+				(u8)(last_per - (last_per >> 3) + (100 >> 3));
 		}
 
 		/* xretries == 1 or 2 */
@@ -972,12 +934,11 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 		if (ath_rc_priv->probe_rate == tx_rate)
 			ath_rc_priv->probe_rate = 0;
 
-	} else {	/* xretries == 0 */
-		/* Update the PER. */
-		/* Make sure it doesn't index out of array's bounds. */
+	} else { /* xretries == 0 */
 		count = ARRAY_SIZE(nretry_to_per_lookup);
 		if (retries >= count)
 			retries = count - 1;
+
 		if (tx_info_priv->n_bad_frames) {
 			/* new_PER = 7/8*old_PER + 1/8*(currentPER)
 			 * Assuming that n_frames is not 0.  The current PER
@@ -991,22 +952,21 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 			 * the above PER.  The expression below is a
 			 * simplified version of the sum of these two terms.
 			 */
-			if (tx_info_priv->n_frames > 0)
-				ath_rc_priv->state[tx_rate].per
-				      = (u8)
-					(ath_rc_priv->state[tx_rate].per -
-					(ath_rc_priv->state[tx_rate].per >> 3) +
-					((100*(retries*tx_info_priv->n_frames +
-					tx_info_priv->n_bad_frames) /
-					(tx_info_priv->n_frames *
-						(retries+1))) >> 3));
+			if (tx_info_priv->n_frames > 0) {
+				int n_frames, n_bad_frames;
+				u8 cur_per, new_per;
+
+				n_bad_frames = retries * tx_info_priv->n_frames +
+					tx_info_priv->n_bad_frames;
+				n_frames = tx_info_priv->n_frames * (retries + 1);
+				cur_per = (100 * n_bad_frames / n_frames) >> 3;
+				new_per = (u8)(last_per - (last_per >> 3) + cur_per);
+				ath_rc_priv->state[tx_rate].per = new_per;
+			}
 		} else {
-			/* new_PER = 7/8*old_PER + 1/8*(currentPER) */
-
-			ath_rc_priv->state[tx_rate].per = (u8)
-				(ath_rc_priv->state[tx_rate].per -
-				(ath_rc_priv->state[tx_rate].per >> 3) +
-				(nretry_to_per_lookup[retries] >> 3));
+			ath_rc_priv->state[tx_rate].per =
+				(u8)(last_per - (last_per >> 3) +
+				     (nretry_to_per_lookup[retries] >> 3));
 		}
 
 		ath_rc_priv->rssi_last_prev2 = ath_rc_priv->rssi_last_prev;
@@ -1018,7 +978,6 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 		 * If we got at most one retry then increase the max rate if
 		 * this was a probe.  Otherwise, ignore the probe.
 		 */
-
 		if (ath_rc_priv->probe_rate && ath_rc_priv->probe_rate == tx_rate) {
 			if (retries > 0 || 2 * tx_info_priv->n_bad_frames >
 				tx_info_priv->n_frames) {
@@ -1033,7 +992,8 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 			} else {
 				u8 probe_rate = 0;
 
-				ath_rc_priv->rate_max_phy = ath_rc_priv->probe_rate;
+				ath_rc_priv->rate_max_phy =
+					ath_rc_priv->probe_rate;
 				probe_rate = ath_rc_priv->probe_rate;
 
 				if (ath_rc_priv->state[probe_rate].per > 30)
@@ -1047,8 +1007,8 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 				 * to move up faster if the probes are
 				 * succesful.
 				 */
-				ath_rc_priv->probe_time = now_msec -
-					rate_table->probe_interval / 2;
+				ath_rc_priv->probe_time =
+					now_msec - rate_table->probe_interval / 2;
 			}
 		}
 
@@ -1064,6 +1024,10 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 			 */
 			ath_rc_priv->hw_maxretry_pktcnt = 0;
 		} else {
+			int32_t rssi_ackAvg;
+			int8_t rssi_thres;
+			int8_t rssi_ack_vmin;
+
 			/*
 			 * It worked with no retries. First ignore bogus (small)
 			 * rssi_ack values.
@@ -1073,46 +1037,82 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 				ath_rc_priv->hw_maxretry_pktcnt++;
 			}
 
-			if (tx_info_priv->tx.ts_rssi >=
-				rate_table->info[tx_rate].rssi_ack_validmin) {
-				/* Average the rssi */
-				if (tx_rate != ath_rc_priv->rssi_sum_rate) {
-					ath_rc_priv->rssi_sum_rate = tx_rate;
-					ath_rc_priv->rssi_sum =
-						ath_rc_priv->rssi_sum_cnt = 0;
-				}
+			if (tx_info_priv->tx.ts_rssi <
+			    rate_table->info[tx_rate].rssi_ack_validmin)
+				goto exit;
 
-				ath_rc_priv->rssi_sum += tx_info_priv->tx.ts_rssi;
-				ath_rc_priv->rssi_sum_cnt++;
-
-				if (ath_rc_priv->rssi_sum_cnt > 4) {
-					int32_t rssi_ackAvg =
-						(ath_rc_priv->rssi_sum + 2) / 4;
-					int8_t rssi_thres =
-						ath_rc_priv->state[tx_rate].
-						rssi_thres;
-					int8_t rssi_ack_vmin =
-						rate_table->info[tx_rate].
-						rssi_ack_validmin;
-
-					ath_rc_priv->rssi_sum =
-						ath_rc_priv->rssi_sum_cnt = 0;
-
-					/* Now reduce the current
-					 * rssi threshold. */
-					if ((rssi_ackAvg < rssi_thres + 2) &&
-					    (rssi_thres > rssi_ack_vmin)) {
-						ath_rc_priv->state[tx_rate].
-							rssi_thres--;
-					}
-
-					state_change = 1;
-				}
+			/* Average the rssi */
+			if (tx_rate != ath_rc_priv->rssi_sum_rate) {
+				ath_rc_priv->rssi_sum_rate = tx_rate;
+				ath_rc_priv->rssi_sum =
+					ath_rc_priv->rssi_sum_cnt = 0;
+			}
+
+			ath_rc_priv->rssi_sum += tx_info_priv->tx.ts_rssi;
+			ath_rc_priv->rssi_sum_cnt++;
+
+			if (ath_rc_priv->rssi_sum_cnt < 4)
+				goto exit;
+
+			rssi_ackAvg =
+				(ath_rc_priv->rssi_sum + 2) / 4;
+			rssi_thres =
+				ath_rc_priv->state[tx_rate].rssi_thres;
+			rssi_ack_vmin =
+				rate_table->info[tx_rate].rssi_ack_validmin;
+
+			ath_rc_priv->rssi_sum =
+				ath_rc_priv->rssi_sum_cnt = 0;
+
+			/* Now reduce the current rssi threshold */
+			if ((rssi_ackAvg < rssi_thres + 2) &&
+			    (rssi_thres > rssi_ack_vmin)) {
+				ath_rc_priv->state[tx_rate].rssi_thres--;
 			}
+
+			state_change = true;
 		}
 	}
+exit:
+	return state_change;
+}
+
+/* Update PER, RSSI and whatever else that the code thinks it is doing.
+   If you can make sense of all this, you really need to go out more. */
 
-	/* For all cases */
+static void ath_rc_update_ht(struct ath_softc *sc,
+			     struct ath_rate_priv *ath_rc_priv,
+			     struct ath_tx_info_priv *tx_info_priv,
+			     int tx_rate, int xretries, int retries)
+{
+#define CHK_RSSI(rate)					\
+	((ath_rc_priv->state[(rate)].rssi_thres +	\
+	  rate_table->info[(rate)].rssi_ack_deltamin) > \
+	 ath_rc_priv->state[(rate)+1].rssi_thres)
+
+	u32 now_msec = jiffies_to_msecs(jiffies);
+	int rate;
+	u8 last_per;
+	bool state_change = false;
+	struct ath_rate_table *rate_table = sc->hw_rate_table[sc->sc_curmode];
+	int size = ath_rc_priv->rate_table_size;
+
+	if ((tx_rate < 0) || (tx_rate > rate_table->rate_cnt))
+		return;
+
+	/* To compensate for some imbalance between ctrl and ext. channel */
+
+	if (WLAN_RC_PHY_40(rate_table->info[tx_rate].phy))
+		tx_info_priv->tx.ts_rssi =
+			tx_info_priv->tx.ts_rssi < 3 ? 0 :
+			tx_info_priv->tx.ts_rssi - 3;
+
+	last_per = ath_rc_priv->state[tx_rate].per;
+
+	/* Update PER first */
+	state_change = ath_rc_update_per(sc, rate_table, ath_rc_priv,
+					 tx_info_priv, tx_rate, xretries,
+					 retries, now_msec);
 
 	/*
 	 * If this rate looks bad (high PER) then stop using it for
@@ -1122,7 +1122,7 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 	    rate_table->info[tx_rate].ratekbps <=
 	    rate_table->info[ath_rc_priv->rate_max_phy].ratekbps) {
 		ath_rc_get_nextlowervalid_txrate(rate_table, ath_rc_priv,
-				 (u8) tx_rate, &ath_rc_priv->rate_max_phy);
+				 (u8)tx_rate, &ath_rc_priv->rate_max_phy);
 
 		/* Don't probe for a little while. */
 		ath_rc_priv->probe_time = now_msec;
@@ -1136,20 +1136,15 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 		 *         made to keep the rssi thresholds monotonically
 		 *         increasing between the CCK and OFDM rates.)
 		 */
-		for (rate = tx_rate; rate <
-				ath_rc_priv->rate_table_size - 1; rate++) {
+		for (rate = tx_rate; rate < size - 1; rate++) {
 			if (rate_table->info[rate+1].phy !=
-				rate_table->info[tx_rate].phy)
+			    rate_table->info[tx_rate].phy)
 				break;
 
-			if (ath_rc_priv->state[rate].rssi_thres +
-			    rate_table->info[rate].rssi_ack_deltamin >
-			    ath_rc_priv->state[rate+1].rssi_thres) {
+			if (CHK_RSSI(rate)) {
 				ath_rc_priv->state[rate+1].rssi_thres =
-					ath_rc_priv->state[rate].
-					rssi_thres +
-					rate_table->info[rate].
-					rssi_ack_deltamin;
+					ath_rc_priv->state[rate].rssi_thres +
+					rate_table->info[rate].rssi_ack_deltamin;
 			}
 		}
 
@@ -1159,27 +1154,20 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 			    rate_table->info[tx_rate].phy)
 				break;
 
-			if (ath_rc_priv->state[rate].rssi_thres +
-			    rate_table->info[rate].rssi_ack_deltamin >
-			    ath_rc_priv->state[rate+1].rssi_thres) {
+			if (CHK_RSSI(rate)) {
 				if (ath_rc_priv->state[rate+1].rssi_thres <
-				    rate_table->info[rate].
-				    rssi_ack_deltamin)
+				    rate_table->info[rate].rssi_ack_deltamin)
 					ath_rc_priv->state[rate].rssi_thres = 0;
 				else {
 					ath_rc_priv->state[rate].rssi_thres =
-						ath_rc_priv->state[rate+1].
-						rssi_thres -
-						rate_table->info[rate].
-						rssi_ack_deltamin;
+					ath_rc_priv->state[rate+1].rssi_thres -
+					rate_table->info[rate].rssi_ack_deltamin;
 				}
 
 				if (ath_rc_priv->state[rate].rssi_thres <
-				    rate_table->info[rate].
-				    rssi_ack_validmin) {
+				    rate_table->info[rate].rssi_ack_validmin) {
 					ath_rc_priv->state[rate].rssi_thres =
-						rate_table->info[rate].
-						rssi_ack_validmin;
+					rate_table->info[rate].rssi_ack_validmin;
 				}
 			}
 		}
@@ -1202,8 +1190,9 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 	}
 
 	/* Maintain monotonicity for rates above the current rate */
-	for (rate = tx_rate; rate < ath_rc_priv->rate_table_size - 1; rate++) {
-		if (ath_rc_priv->state[rate+1].per < ath_rc_priv->state[rate].per)
+	for (rate = tx_rate; rate < size - 1; rate++) {
+		if (ath_rc_priv->state[rate+1].per <
+		    ath_rc_priv->state[rate].per)
 			ath_rc_priv->state[rate+1].per =
 				ath_rc_priv->state[rate].per;
 	}
@@ -1213,7 +1202,7 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 	if (now_msec - ath_rc_priv->rssi_down_time >=
 	    rate_table->rssi_reduce_interval) {
 
-		for (rate = 0; rate < ath_rc_priv->rate_table_size; rate++) {
+		for (rate = 0; rate < size; rate++) {
 			if (ath_rc_priv->state[rate].rssi_thres >
 			    rate_table->info[rate].rssi_ack_validmin)
 				ath_rc_priv->state[rate].rssi_thres -= 1;
@@ -1225,13 +1214,33 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 	 * and PER (different for CCK and OFDM). */
 	if (now_msec - ath_rc_priv->per_down_time >=
 	    rate_table->rssi_reduce_interval) {
-		for (rate = 0; rate < ath_rc_priv->rate_table_size; rate++) {
+		for (rate = 0; rate < size; rate++) {
 			ath_rc_priv->state[rate].per =
 				7 * ath_rc_priv->state[rate].per / 8;
 		}
 
 		ath_rc_priv->per_down_time = now_msec;
 	}
+
+#undef CHK_RSSI
+}
+
+static int ath_rc_get_rateindex(struct ath_rate_table *rate_table,
+				struct ieee80211_tx_rate *rate)
+{
+	int rix;
+
+	if ((rate->flags & IEEE80211_TX_RC_40_MHZ_WIDTH) &&
+	    (rate->flags & IEEE80211_TX_RC_SHORT_GI))
+		rix = rate_table->info[rate->idx].ht_index;
+	else if (rate->flags & IEEE80211_TX_RC_SHORT_GI)
+		rix = rate_table->info[rate->idx].sgi_index;
+	else if (rate->flags & IEEE80211_TX_RC_40_MHZ_WIDTH)
+		rix = rate_table->info[rate->idx].cw40index;
+	else
+		rix = rate_table->info[rate->idx].base_index;
+
+	return rix;
 }
 
 static void ath_rc_tx_status(struct ath_softc *sc,
@@ -1243,7 +1252,7 @@ static void ath_rc_tx_status(struct ath_softc *sc,
 	struct ath_rate_table *rate_table;
 	struct ieee80211_tx_rate *rates = tx_info->status.rates;
 	u8 flags;
-	u32 series = 0, rix;
+	u32 i = 0, rix;
 
 	rate_table = sc->hw_rate_table[sc->sc_curmode];
 
@@ -1253,32 +1262,22 @@ static void ath_rc_tx_status(struct ath_softc *sc,
 	 */
 	if (final_ts_idx != 0) {
 		/* Process intermediate rates that failed.*/
-		for (series = 0; series < final_ts_idx ; series++) {
-			if (rates[series].count != 0 && (rates[series].idx >= 0)) {
-				flags = rates[series].flags;
+		for (i = 0; i < final_ts_idx ; i++) {
+			if (rates[i].count != 0 && (rates[i].idx >= 0)) {
+				flags = rates[i].flags;
+
 				/* If HT40 and we have switched mode from
 				 * 40 to 20 => don't update */
+
 				if ((flags & IEEE80211_TX_RC_40_MHZ_WIDTH) &&
 				    (ath_rc_priv->rc_phy_mode != WLAN_RC_40_FLAG))
 					return;
 
-				if ((flags & IEEE80211_TX_RC_40_MHZ_WIDTH) &&
-					(flags & IEEE80211_TX_RC_SHORT_GI))
-					rix = rate_table->info[
-						rates[series].idx].ht_index;
-				else if (flags & IEEE80211_TX_RC_SHORT_GI)
-					rix = rate_table->info[
-						rates[series].idx].sgi_index;
-				else if (flags & IEEE80211_TX_RC_40_MHZ_WIDTH)
-					rix = rate_table->info[
-						rates[series].idx].cw40index;
-				else
-					rix = rate_table->info[
-						rates[series].idx].base_index;
+				rix = ath_rc_get_rateindex(rate_table, &rates[i]);
 				ath_rc_update_ht(sc, ath_rc_priv,
 						tx_info_priv, rix,
 						xretries ? 1 : 2,
-						rates[series].count);
+						rates[i].count);
 			}
 		}
 	} else {
@@ -1292,24 +1291,17 @@ static void ath_rc_tx_status(struct ath_softc *sc,
 			xretries = 2;
 	}
 
-	flags = rates[series].flags;
+	flags = rates[i].flags;
+
 	/* If HT40 and we have switched mode from 40 to 20 => don't update */
 	if ((flags & IEEE80211_TX_RC_40_MHZ_WIDTH) &&
 	    (ath_rc_priv->rc_phy_mode != WLAN_RC_40_FLAG)) {
 		return;
 	}
 
-	if ((flags & IEEE80211_TX_RC_40_MHZ_WIDTH) && (flags & IEEE80211_TX_RC_SHORT_GI))
-		rix = rate_table->info[rates[series].idx].ht_index;
-	else if (flags & IEEE80211_TX_RC_SHORT_GI)
-		rix = rate_table->info[rates[series].idx].sgi_index;
-	else if (flags & IEEE80211_TX_RC_40_MHZ_WIDTH)
-		rix = rate_table->info[rates[series].idx].cw40index;
-	else
-		rix = rate_table->info[rates[series].idx].base_index;
-
+	rix = ath_rc_get_rateindex(rate_table, &rates[i]);
 	ath_rc_update_ht(sc, ath_rc_priv, tx_info_priv, rix,
-		xretries, long_retry);
+			 xretries, long_retry);
 }
 
 static void ath_rc_init(struct ath_softc *sc,
@@ -1362,14 +1354,14 @@ static void ath_rc_init(struct ath_softc *sc,
 
 	if (!rateset->rs_nrates) {
 		/* No working rate, just initialize valid rates */
-		hi = ath_rc_sib_init_validrates(ath_rc_priv, rate_table,
+		hi = ath_rc_init_validrates(ath_rc_priv, rate_table,
 						ath_rc_priv->ht_cap);
 	} else {
 		/* Use intersection of working rates and valid rates */
-		hi = ath_rc_sib_setvalid_rates(ath_rc_priv, rate_table,
+		hi = ath_rc_setvalid_rates(ath_rc_priv, rate_table,
 					       rateset, ath_rc_priv->ht_cap);
 		if (ath_rc_priv->ht_cap & WLAN_RC_HT_FLAG) {
-			hthi = ath_rc_sib_setvalid_htrates(ath_rc_priv,
+			hthi = ath_rc_setvalid_htrates(ath_rc_priv,
 							   rate_table,
 							   ht_mcs,
 							   ath_rc_priv->ht_cap);
diff --git a/drivers/net/wireless/ath9k/rc.h b/drivers/net/wireless/ath9k/rc.h
index dff4b7a..297dff9 100644
--- a/drivers/net/wireless/ath9k/rc.h
+++ b/drivers/net/wireless/ath9k/rc.h
@@ -27,6 +27,11 @@ struct ath_softc;
 #define RATE_TABLE_SIZE  64
 #define MAX_TX_RATE_PHY  48
 
+/* VALID_ALL - valid for 20/40/Legacy,
+ * VALID - Legacy only,
+ * VALID_20 - HT 20 only,
+ * VALID_40 - HT 40 only */
+
 #define INVALID    0x0
 #define VALID      0x1
 #define VALID_20   0x2
-- 
1.6.0.3

