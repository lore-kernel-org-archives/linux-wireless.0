Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:26774 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061AbYKRDgH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Nov 2008 22:36:07 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 17 Nov 2008 19:36:07 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18722.14200.89344.185454@gargle.gargle.HOWL> (sfid-20081118_043612_522230_87F1BE4F)
Date: Tue, 18 Nov 2008 09:03:12 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 01/18] ath9k: Merge struct ath_tx_ratectrl with ath_rate_node
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Avoid casting of ath_tx_ratctrl and access the elements directly.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/rc.c |  346 ++++++++++++++++++---------------------
 drivers/net/wireless/ath9k/rc.h |   71 ++++-----
 2 files changed, 192 insertions(+), 225 deletions(-)

diff --git a/drivers/net/wireless/ath9k/rc.c b/drivers/net/wireless/ath9k/rc.c
index 517992d..21116c5 100644
--- a/drivers/net/wireless/ath9k/rc.c
+++ b/drivers/net/wireless/ath9k/rc.c
@@ -542,19 +542,19 @@ static inline int8_t median(int8_t a, int8_t b, int8_t c)
 }
 
 static void ath_rc_sort_validrates(const struct ath_rate_table *rate_table,
-				   struct ath_tx_ratectrl *rate_ctrl)
+				   struct ath_rate_node *ath_rc_priv)
 {
 	u8 i, j, idx, idx_next;
 
-	for (i = rate_ctrl->max_valid_rate - 1; i > 0; i--) {
+	for (i = ath_rc_priv->max_valid_rate - 1; i > 0; i--) {
 		for (j = 0; j <= i-1; j++) {
-			idx = rate_ctrl->valid_rate_index[j];
-			idx_next = rate_ctrl->valid_rate_index[j+1];
+			idx = ath_rc_priv->valid_rate_index[j];
+			idx_next = ath_rc_priv->valid_rate_index[j+1];
 
 			if (rate_table->info[idx].ratekbps >
 				rate_table->info[idx_next].ratekbps) {
-				rate_ctrl->valid_rate_index[j] = idx_next;
-				rate_ctrl->valid_rate_index[j+1] = idx;
+				ath_rc_priv->valid_rate_index[j] = idx_next;
+				ath_rc_priv->valid_rate_index[j+1] = idx;
 			}
 		}
 	}
@@ -562,40 +562,40 @@ static void ath_rc_sort_validrates(const struct ath_rate_table *rate_table,
 
 /* Access functions for valid_txrate_mask */
 
-static void ath_rc_init_valid_txmask(struct ath_tx_ratectrl *rate_ctrl)
+static void ath_rc_init_valid_txmask(struct ath_rate_node *ath_rc_priv)
 {
 	u8 i;
 
-	for (i = 0; i < rate_ctrl->rate_table_size; i++)
-		rate_ctrl->valid_rate_index[i] = FALSE;
+	for (i = 0; i < ath_rc_priv->rate_table_size; i++)
+		ath_rc_priv->valid_rate_index[i] = FALSE;
 }
 
-static inline void ath_rc_set_valid_txmask(struct ath_tx_ratectrl *rate_ctrl,
+static inline void ath_rc_set_valid_txmask(struct ath_rate_node *ath_rc_priv,
 					   u8 index, int valid_tx_rate)
 {
-	ASSERT(index <= rate_ctrl->rate_table_size);
-	rate_ctrl->valid_rate_index[index] = valid_tx_rate ? TRUE : FALSE;
+	ASSERT(index <= ath_rc_priv->rate_table_size);
+	ath_rc_priv->valid_rate_index[index] = valid_tx_rate ? TRUE : FALSE;
 }
 
-static inline int ath_rc_isvalid_txmask(struct ath_tx_ratectrl *rate_ctrl,
+static inline int ath_rc_isvalid_txmask(struct ath_rate_node *ath_rc_priv,
 					u8 index)
 {
-	ASSERT(index <= rate_ctrl->rate_table_size);
-	return rate_ctrl->valid_rate_index[index];
+	ASSERT(index <= ath_rc_priv->rate_table_size);
+	return ath_rc_priv->valid_rate_index[index];
 }
 
 /* Iterators for valid_txrate_mask */
 static inline int
 ath_rc_get_nextvalid_txrate(const struct ath_rate_table *rate_table,
-			    struct ath_tx_ratectrl *rate_ctrl,
+			    struct ath_rate_node *ath_rc_priv,
 			    u8 cur_valid_txrate,
 			    u8 *next_idx)
 {
 	u8 i;
 
-	for (i = 0; i < rate_ctrl->max_valid_rate - 1; i++) {
-		if (rate_ctrl->valid_rate_index[i] == cur_valid_txrate) {
-			*next_idx = rate_ctrl->valid_rate_index[i+1];
+	for (i = 0; i < ath_rc_priv->max_valid_rate - 1; i++) {
+		if (ath_rc_priv->valid_rate_index[i] == cur_valid_txrate) {
+			*next_idx = ath_rc_priv->valid_rate_index[i+1];
 			return TRUE;
 		}
 	}
@@ -625,14 +625,14 @@ static int ath_rc_valid_phyrate(u32 phy, u32 capflag, int ignore_cw)
 
 static inline int
 ath_rc_get_nextlowervalid_txrate(const struct ath_rate_table *rate_table,
-				 struct ath_tx_ratectrl *rate_ctrl,
+				 struct ath_rate_node *ath_rc_priv,
 				 u8 cur_valid_txrate, u8 *next_idx)
 {
 	int8_t i;
 
-	for (i = 1; i < rate_ctrl->max_valid_rate ; i++) {
-		if (rate_ctrl->valid_rate_index[i] == cur_valid_txrate) {
-			*next_idx = rate_ctrl->valid_rate_index[i-1];
+	for (i = 1; i < ath_rc_priv->max_valid_rate ; i++) {
+		if (ath_rc_priv->valid_rate_index[i] == cur_valid_txrate) {
+			*next_idx = ath_rc_priv->valid_rate_index[i-1];
 			return TRUE;
 		}
 	}
@@ -647,11 +647,9 @@ ath_rc_sib_init_validrates(struct ath_rate_node *ath_rc_priv,
 			   const struct ath_rate_table *rate_table,
 			   u32 capflag)
 {
-	struct ath_tx_ratectrl *rate_ctrl;
 	u8 i, hi = 0;
 	u32 valid;
 
-	rate_ctrl = (struct ath_tx_ratectrl *)(ath_rc_priv);
 	for (i = 0; i < rate_table->rate_cnt; i++) {
 		valid = (ath_rc_priv->single_stream ?
 			 rate_table->info[i].valid_single_stream :
@@ -663,11 +661,11 @@ ath_rc_sib_init_validrates(struct ath_rate_node *ath_rc_priv,
 			if (!ath_rc_valid_phyrate(phy, capflag, FALSE))
 				continue;
 
-			valid_rate_count = rate_ctrl->valid_phy_ratecnt[phy];
+			valid_rate_count = ath_rc_priv->valid_phy_ratecnt[phy];
 
-			rate_ctrl->valid_phy_rateidx[phy][valid_rate_count] = i;
-			rate_ctrl->valid_phy_ratecnt[phy] += 1;
-			ath_rc_set_valid_txmask(rate_ctrl, i, TRUE);
+			ath_rc_priv->valid_phy_rateidx[phy][valid_rate_count] = i;
+			ath_rc_priv->valid_phy_ratecnt[phy] += 1;
+			ath_rc_set_valid_txmask(ath_rc_priv, i, TRUE);
 			hi = A_MAX(hi, i);
 		}
 	}
@@ -685,8 +683,6 @@ ath_rc_sib_setvalid_rates(struct ath_rate_node *ath_rc_priv,
 {
 	/* XXX: Clean me up and make identation friendly */
 	u8 i, j, hi = 0;
-	struct ath_tx_ratectrl *rate_ctrl =
-		(struct ath_tx_ratectrl *)(ath_rc_priv);
 
 	/* Use intersection of working rates and valid rates */
 	for (i = 0; i < rateset->rs_nrates; i++) {
@@ -714,12 +710,12 @@ ath_rc_sib_setvalid_rates(struct ath_rate_node *ath_rc_priv,
 					continue;
 
 				valid_rate_count =
-					rate_ctrl->valid_phy_ratecnt[phy];
+					ath_rc_priv->valid_phy_ratecnt[phy];
 
-				rate_ctrl->valid_phy_rateidx[phy]
+				ath_rc_priv->valid_phy_rateidx[phy]
 					[valid_rate_count] = j;
-				rate_ctrl->valid_phy_ratecnt[phy] += 1;
-				ath_rc_set_valid_txmask(rate_ctrl, j, TRUE);
+				ath_rc_priv->valid_phy_ratecnt[phy] += 1;
+				ath_rc_set_valid_txmask(ath_rc_priv, j, TRUE);
 				hi = A_MAX(hi, j);
 			}
 		}
@@ -733,8 +729,6 @@ ath_rc_sib_setvalid_htrates(struct ath_rate_node *ath_rc_priv,
 			    u8 *mcs_set, u32 capflag)
 {
 	u8 i, j, hi = 0;
-	struct ath_tx_ratectrl *rate_ctrl =
-		(struct ath_tx_ratectrl *)(ath_rc_priv);
 
 	/* Use intersection of working rates and valid rates */
 	for (i = 0; i <  ((struct ath_rateset *)mcs_set)->rs_nrates; i++) {
@@ -754,10 +748,10 @@ ath_rc_sib_setvalid_htrates(struct ath_rate_node *ath_rc_priv,
 			if (!ath_rc_valid_phyrate(phy, capflag, FALSE))
 				continue;
 
-			rate_ctrl->valid_phy_rateidx[phy]
-				[rate_ctrl->valid_phy_ratecnt[phy]] = j;
-			rate_ctrl->valid_phy_ratecnt[phy] += 1;
-			ath_rc_set_valid_txmask(rate_ctrl, j, TRUE);
+			ath_rc_priv->valid_phy_rateidx[phy]
+				[ath_rc_priv->valid_phy_ratecnt[phy]] = j;
+			ath_rc_priv->valid_phy_ratecnt[phy] += 1;
+			ath_rc_set_valid_txmask(ath_rc_priv, j, TRUE);
 			hi = A_MAX(hi, j);
 		}
 	}
@@ -875,16 +869,12 @@ static u8 ath_rc_ratefind_ht(struct ath_softc *sc,
 	u32 dt, best_thruput, this_thruput, now_msec;
 	u8 rate, next_rate, best_rate, maxindex, minindex;
 	int8_t  rssi_last, rssi_reduce = 0, index = 0;
-	struct ath_tx_ratectrl  *rate_ctrl = NULL;
-
-	rate_ctrl = (struct ath_tx_ratectrl *)(ath_rc_priv ?
-					       (ath_rc_priv) : NULL);
 
 	*is_probing = FALSE;
 
-	rssi_last = median(rate_ctrl->rssi_last,
-			   rate_ctrl->rssi_last_prev,
-			   rate_ctrl->rssi_last_prev2);
+	rssi_last = median(ath_rc_priv->rssi_last,
+			   ath_rc_priv->rssi_last_prev,
+			   ath_rc_priv->rssi_last_prev2);
 
 	/*
 	 * Age (reduce) last ack rssi based on how old it is.
@@ -896,7 +886,7 @@ static u8 ath_rc_ratefind_ht(struct ath_softc *sc,
 	 */
 
 	now_msec = jiffies_to_msecs(jiffies);
-	dt = now_msec - rate_ctrl->rssi_time;
+	dt = now_msec - ath_rc_priv->rssi_time;
 
 	if (dt >= 185)
 		rssi_reduce = 10;
@@ -915,7 +905,7 @@ static u8 ath_rc_ratefind_ht(struct ath_softc *sc,
 	 */
 
 	best_thruput = 0;
-	maxindex = rate_ctrl->max_valid_rate-1;
+	maxindex = ath_rc_priv->max_valid_rate-1;
 
 	minindex = 0;
 	best_rate = minindex;
@@ -927,8 +917,8 @@ static u8 ath_rc_ratefind_ht(struct ath_softc *sc,
 	for (index = maxindex; index >= minindex ; index--) {
 		u8 per_thres;
 
-		rate = rate_ctrl->valid_rate_index[index];
-		if (rate > rate_ctrl->rate_max_phy)
+		rate = ath_rc_priv->valid_rate_index[index];
+		if (rate > ath_rc_priv->rate_max_phy)
 			continue;
 
 		/*
@@ -942,7 +932,7 @@ static u8 ath_rc_ratefind_ht(struct ath_softc *sc,
 		 * 10-15 and we would be worse off then staying
 		 * at the current rate.
 		 */
-		per_thres = rate_ctrl->state[rate].per;
+		per_thres = ath_rc_priv->state[rate].per;
 		if (per_thres < 12)
 			per_thres = 12;
 
@@ -961,29 +951,29 @@ static u8 ath_rc_ratefind_ht(struct ath_softc *sc,
 	 * of max retries, use the min rate for the next retry
 	 */
 	if (is_retry)
-		rate = rate_ctrl->valid_rate_index[minindex];
+		rate = ath_rc_priv->valid_rate_index[minindex];
 
-	rate_ctrl->rssi_last_lookup = rssi_last;
+	ath_rc_priv->rssi_last_lookup = rssi_last;
 
 	/*
 	 * Must check the actual rate (ratekbps) to account for
 	 * non-monoticity of 11g's rate table
 	 */
 
-	if (rate >= rate_ctrl->rate_max_phy && probe_allowed) {
-		rate = rate_ctrl->rate_max_phy;
+	if (rate >= ath_rc_priv->rate_max_phy && probe_allowed) {
+		rate = ath_rc_priv->rate_max_phy;
 
 		/* Probe the next allowed phy state */
 		/* FIXME:XXXX Check to make sure ratMax is checked properly */
 		if (ath_rc_get_nextvalid_txrate(rate_table,
-						rate_ctrl, rate, &next_rate) &&
-		    (now_msec - rate_ctrl->probe_time >
+						ath_rc_priv, rate, &next_rate) &&
+		    (now_msec - ath_rc_priv->probe_time >
 		     rate_table->probe_interval) &&
-		    (rate_ctrl->hw_maxretry_pktcnt >= 1)) {
+		    (ath_rc_priv->hw_maxretry_pktcnt >= 1)) {
 			rate = next_rate;
-			rate_ctrl->probe_rate = rate;
-			rate_ctrl->probe_time = now_msec;
-			rate_ctrl->hw_maxretry_pktcnt = 0;
+			ath_rc_priv->probe_rate = rate;
+			ath_rc_priv->probe_time = now_msec;
+			ath_rc_priv->hw_maxretry_pktcnt = 0;
 			*is_probing = TRUE;
 		}
 	}
@@ -994,8 +984,8 @@ static u8 ath_rc_ratefind_ht(struct ath_softc *sc,
 	 * normally 1 rather than 0 because of the rate 9 vs 6 issue
 	 * in the old code.
 	 */
-	if (rate > (rate_ctrl->rate_table_size - 1))
-		rate = rate_ctrl->rate_table_size - 1;
+	if (rate > (ath_rc_priv->rate_table_size - 1))
+		rate = ath_rc_priv->rate_table_size - 1;
 
 	ASSERT((rate_table->info[rate].valid && !ath_rc_priv->single_stream) ||
 	       (rate_table->info[rate].valid_single_stream &&
@@ -1031,13 +1021,11 @@ static u8 ath_rc_rate_getidx(struct ath_softc *sc,
 {
 	u32 j;
 	u8 nextindex;
-	struct ath_tx_ratectrl *rate_ctrl =
-		(struct ath_tx_ratectrl *)(ath_rc_priv);
 
 	if (min_rate) {
 		for (j = RATE_TABLE_SIZE; j > 0; j--) {
 			if (ath_rc_get_nextlowervalid_txrate(rate_table,
-						rate_ctrl, rix, &nextindex))
+						ath_rc_priv, rix, &nextindex))
 				rix = nextindex;
 			else
 				break;
@@ -1045,7 +1033,7 @@ static u8 ath_rc_rate_getidx(struct ath_softc *sc,
 	} else {
 		for (j = stepdown; j > 0; j--) {
 			if (ath_rc_get_nextlowervalid_txrate(rate_table,
-						rate_ctrl, rix, &nextindex))
+						ath_rc_priv, rix, &nextindex))
 				rix = nextindex;
 			else
 				break;
@@ -1225,7 +1213,6 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 			     struct ath_tx_info_priv *info_priv,
 			     int tx_rate, int xretries, int retries)
 {
-	struct ath_tx_ratectrl *rate_ctrl;
 	u32 now_msec = jiffies_to_msecs(jiffies);
 	int state_change = FALSE, rate, count;
 	u8 last_per;
@@ -1249,8 +1236,6 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 	if (!ath_rc_priv)
 		return;
 
-	rate_ctrl = (struct ath_tx_ratectrl *)(ath_rc_priv);
-
 	ASSERT(tx_rate >= 0);
 	if (tx_rate < 0)
 		return;
@@ -1262,30 +1247,30 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 			info_priv->tx.ts_rssi < 3 ? 0 :
 			info_priv->tx.ts_rssi - 3;
 
-	last_per = rate_ctrl->state[tx_rate].per;
+	last_per = ath_rc_priv->state[tx_rate].per;
 
 	if (xretries) {
 		/* Update the PER. */
 		if (xretries == 1) {
-			rate_ctrl->state[tx_rate].per += 30;
-			if (rate_ctrl->state[tx_rate].per > 100)
-				rate_ctrl->state[tx_rate].per = 100;
+			ath_rc_priv->state[tx_rate].per += 30;
+			if (ath_rc_priv->state[tx_rate].per > 100)
+				ath_rc_priv->state[tx_rate].per = 100;
 		} else {
 			/* xretries == 2 */
 			count = ARRAY_SIZE(nretry_to_per_lookup);
 			if (retries >= count)
 				retries = count - 1;
 			/* new_PER = 7/8*old_PER + 1/8*(currentPER) */
-			rate_ctrl->state[tx_rate].per =
-				(u8)(rate_ctrl->state[tx_rate].per -
-				     (rate_ctrl->state[tx_rate].per >> 3) +
+			ath_rc_priv->state[tx_rate].per =
+				(u8)(ath_rc_priv->state[tx_rate].per -
+				     (ath_rc_priv->state[tx_rate].per >> 3) +
 				     ((100) >> 3));
 		}
 
 		/* xretries == 1 or 2 */
 
-		if (rate_ctrl->probe_rate == tx_rate)
-			rate_ctrl->probe_rate = 0;
+		if (ath_rc_priv->probe_rate == tx_rate)
+			ath_rc_priv->probe_rate = 0;
 
 	} else {	/* xretries == 0 */
 		/* Update the PER. */
@@ -1307,10 +1292,10 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 			 * simplified version of the sum of these two terms.
 			 */
 			if (info_priv->n_frames > 0)
-				rate_ctrl->state[tx_rate].per
+				ath_rc_priv->state[tx_rate].per
 				      = (u8)
-					(rate_ctrl->state[tx_rate].per -
-					(rate_ctrl->state[tx_rate].per >> 3) +
+					(ath_rc_priv->state[tx_rate].per -
+					(ath_rc_priv->state[tx_rate].per >> 3) +
 					((100*(retries*info_priv->n_frames +
 					info_priv->n_bad_frames) /
 					(info_priv->n_frames *
@@ -1318,23 +1303,23 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 		} else {
 			/* new_PER = 7/8*old_PER + 1/8*(currentPER) */
 
-			rate_ctrl->state[tx_rate].per = (u8)
-				(rate_ctrl->state[tx_rate].per -
-				(rate_ctrl->state[tx_rate].per >> 3) +
+			ath_rc_priv->state[tx_rate].per = (u8)
+				(ath_rc_priv->state[tx_rate].per -
+				(ath_rc_priv->state[tx_rate].per >> 3) +
 				(nretry_to_per_lookup[retries] >> 3));
 		}
 
-		rate_ctrl->rssi_last_prev2 = rate_ctrl->rssi_last_prev;
-		rate_ctrl->rssi_last_prev  = rate_ctrl->rssi_last;
-		rate_ctrl->rssi_last = info_priv->tx.ts_rssi;
-		rate_ctrl->rssi_time = now_msec;
+		ath_rc_priv->rssi_last_prev2 = ath_rc_priv->rssi_last_prev;
+		ath_rc_priv->rssi_last_prev  = ath_rc_priv->rssi_last;
+		ath_rc_priv->rssi_last = info_priv->tx.ts_rssi;
+		ath_rc_priv->rssi_time = now_msec;
 
 		/*
 		 * If we got at most one retry then increase the max rate if
 		 * this was a probe.  Otherwise, ignore the probe.
 		 */
 
-		if (rate_ctrl->probe_rate && rate_ctrl->probe_rate == tx_rate) {
+		if (ath_rc_priv->probe_rate && ath_rc_priv->probe_rate == tx_rate) {
 			if (retries > 0 || 2 * info_priv->n_bad_frames >
 				info_priv->n_frames) {
 				/*
@@ -1344,17 +1329,17 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 				 * the subframes were bad then also consider
 				 * the probe a failure.
 				 */
-				rate_ctrl->probe_rate = 0;
+				ath_rc_priv->probe_rate = 0;
 			} else {
 				u8 probe_rate = 0;
 
-				rate_ctrl->rate_max_phy = rate_ctrl->probe_rate;
-				probe_rate = rate_ctrl->probe_rate;
+				ath_rc_priv->rate_max_phy = ath_rc_priv->probe_rate;
+				probe_rate = ath_rc_priv->probe_rate;
 
-				if (rate_ctrl->state[probe_rate].per > 30)
-					rate_ctrl->state[probe_rate].per = 20;
+				if (ath_rc_priv->state[probe_rate].per > 30)
+					ath_rc_priv->state[probe_rate].per = 20;
 
-				rate_ctrl->probe_rate = 0;
+				ath_rc_priv->probe_rate = 0;
 
 				/*
 				 * Since this probe succeeded, we allow the next
@@ -1362,7 +1347,7 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 				 * to move up faster if the probes are
 				 * succesful.
 				 */
-				rate_ctrl->probe_time = now_msec -
+				ath_rc_priv->probe_time = now_msec -
 					rate_table->probe_interval / 2;
 			}
 		}
@@ -1373,51 +1358,51 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 			 * this was because of collisions or poor signal.
 			 *
 			 * Later: if rssi_ack is close to
-			 * rate_ctrl->state[txRate].rssi_thres and we see lots
+			 * ath_rc_priv->state[txRate].rssi_thres and we see lots
 			 * of retries, then we could increase
-			 * rate_ctrl->state[txRate].rssi_thres.
+			 * ath_rc_priv->state[txRate].rssi_thres.
 			 */
-			rate_ctrl->hw_maxretry_pktcnt = 0;
+			ath_rc_priv->hw_maxretry_pktcnt = 0;
 		} else {
 			/*
 			 * It worked with no retries. First ignore bogus (small)
 			 * rssi_ack values.
 			 */
-			if (tx_rate == rate_ctrl->rate_max_phy &&
-			    rate_ctrl->hw_maxretry_pktcnt < 255) {
-				rate_ctrl->hw_maxretry_pktcnt++;
+			if (tx_rate == ath_rc_priv->rate_max_phy &&
+			    ath_rc_priv->hw_maxretry_pktcnt < 255) {
+				ath_rc_priv->hw_maxretry_pktcnt++;
 			}
 
 			if (info_priv->tx.ts_rssi >=
 				rate_table->info[tx_rate].rssi_ack_validmin) {
 				/* Average the rssi */
-				if (tx_rate != rate_ctrl->rssi_sum_rate) {
-					rate_ctrl->rssi_sum_rate = tx_rate;
-					rate_ctrl->rssi_sum =
-						rate_ctrl->rssi_sum_cnt = 0;
+				if (tx_rate != ath_rc_priv->rssi_sum_rate) {
+					ath_rc_priv->rssi_sum_rate = tx_rate;
+					ath_rc_priv->rssi_sum =
+						ath_rc_priv->rssi_sum_cnt = 0;
 				}
 
-				rate_ctrl->rssi_sum += info_priv->tx.ts_rssi;
-				rate_ctrl->rssi_sum_cnt++;
+				ath_rc_priv->rssi_sum += info_priv->tx.ts_rssi;
+				ath_rc_priv->rssi_sum_cnt++;
 
-				if (rate_ctrl->rssi_sum_cnt > 4) {
+				if (ath_rc_priv->rssi_sum_cnt > 4) {
 					int32_t rssi_ackAvg =
-						(rate_ctrl->rssi_sum + 2) / 4;
+						(ath_rc_priv->rssi_sum + 2) / 4;
 					int8_t rssi_thres =
-						rate_ctrl->state[tx_rate].
+						ath_rc_priv->state[tx_rate].
 						rssi_thres;
 					int8_t rssi_ack_vmin =
 						rate_table->info[tx_rate].
 						rssi_ack_validmin;
 
-					rate_ctrl->rssi_sum =
-						rate_ctrl->rssi_sum_cnt = 0;
+					ath_rc_priv->rssi_sum =
+						ath_rc_priv->rssi_sum_cnt = 0;
 
 					/* Now reduce the current
 					 * rssi threshold. */
 					if ((rssi_ackAvg < rssi_thres + 2) &&
 					    (rssi_thres > rssi_ack_vmin)) {
-						rate_ctrl->state[tx_rate].
+						ath_rc_priv->state[tx_rate].
 							rssi_thres--;
 					}
 
@@ -1433,14 +1418,14 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 	 * If this rate looks bad (high PER) then stop using it for
 	 * a while (except if we are probing).
 	 */
-	if (rate_ctrl->state[tx_rate].per >= 55 && tx_rate > 0 &&
+	if (ath_rc_priv->state[tx_rate].per >= 55 && tx_rate > 0 &&
 	    rate_table->info[tx_rate].ratekbps <=
-	    rate_table->info[rate_ctrl->rate_max_phy].ratekbps) {
-		ath_rc_get_nextlowervalid_txrate(rate_table, rate_ctrl,
-				 (u8) tx_rate, &rate_ctrl->rate_max_phy);
+	    rate_table->info[ath_rc_priv->rate_max_phy].ratekbps) {
+		ath_rc_get_nextlowervalid_txrate(rate_table, ath_rc_priv,
+				 (u8) tx_rate, &ath_rc_priv->rate_max_phy);
 
 		/* Don't probe for a little while. */
-		rate_ctrl->probe_time = now_msec;
+		ath_rc_priv->probe_time = now_msec;
 	}
 
 	if (state_change) {
@@ -1452,16 +1437,16 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 		 *         increasing between the CCK and OFDM rates.)
 		 */
 		for (rate = tx_rate; rate <
-				rate_ctrl->rate_table_size - 1; rate++) {
+				ath_rc_priv->rate_table_size - 1; rate++) {
 			if (rate_table->info[rate+1].phy !=
 				rate_table->info[tx_rate].phy)
 				break;
 
-			if (rate_ctrl->state[rate].rssi_thres +
+			if (ath_rc_priv->state[rate].rssi_thres +
 			    rate_table->info[rate].rssi_ack_deltamin >
-			    rate_ctrl->state[rate+1].rssi_thres) {
-				rate_ctrl->state[rate+1].rssi_thres =
-					rate_ctrl->state[rate].
+			    ath_rc_priv->state[rate+1].rssi_thres) {
+				ath_rc_priv->state[rate+1].rssi_thres =
+					ath_rc_priv->state[rate].
 					rssi_thres +
 					rate_table->info[rate].
 					rssi_ack_deltamin;
@@ -1474,25 +1459,25 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 			    rate_table->info[tx_rate].phy)
 				break;
 
-			if (rate_ctrl->state[rate].rssi_thres +
+			if (ath_rc_priv->state[rate].rssi_thres +
 			    rate_table->info[rate].rssi_ack_deltamin >
-			    rate_ctrl->state[rate+1].rssi_thres) {
-				if (rate_ctrl->state[rate+1].rssi_thres <
+			    ath_rc_priv->state[rate+1].rssi_thres) {
+				if (ath_rc_priv->state[rate+1].rssi_thres <
 				    rate_table->info[rate].
 				    rssi_ack_deltamin)
-					rate_ctrl->state[rate].rssi_thres = 0;
+					ath_rc_priv->state[rate].rssi_thres = 0;
 				else {
-					rate_ctrl->state[rate].rssi_thres =
-						rate_ctrl->state[rate+1].
+					ath_rc_priv->state[rate].rssi_thres =
+						ath_rc_priv->state[rate+1].
 						rssi_thres -
 						rate_table->info[rate].
 						rssi_ack_deltamin;
 				}
 
-				if (rate_ctrl->state[rate].rssi_thres <
+				if (ath_rc_priv->state[rate].rssi_thres <
 				    rate_table->info[rate].
 				    rssi_ack_validmin) {
-					rate_ctrl->state[rate].rssi_thres =
+					ath_rc_priv->state[rate].rssi_thres =
 						rate_table->info[rate].
 						rssi_ack_validmin;
 				}
@@ -1502,50 +1487,50 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 
 	/* Make sure the rates below this have lower PER */
 	/* Monotonicity is kept only for rates below the current rate. */
-	if (rate_ctrl->state[tx_rate].per < last_per) {
+	if (ath_rc_priv->state[tx_rate].per < last_per) {
 		for (rate = tx_rate - 1; rate >= 0; rate--) {
 			if (rate_table->info[rate].phy !=
 			    rate_table->info[tx_rate].phy)
 				break;
 
-			if (rate_ctrl->state[rate].per >
-			    rate_ctrl->state[rate+1].per) {
-				rate_ctrl->state[rate].per =
-					rate_ctrl->state[rate+1].per;
+			if (ath_rc_priv->state[rate].per >
+			    ath_rc_priv->state[rate+1].per) {
+				ath_rc_priv->state[rate].per =
+					ath_rc_priv->state[rate+1].per;
 			}
 		}
 	}
 
 	/* Maintain monotonicity for rates above the current rate */
-	for (rate = tx_rate; rate < rate_ctrl->rate_table_size - 1; rate++) {
-		if (rate_ctrl->state[rate+1].per < rate_ctrl->state[rate].per)
-			rate_ctrl->state[rate+1].per =
-				rate_ctrl->state[rate].per;
+	for (rate = tx_rate; rate < ath_rc_priv->rate_table_size - 1; rate++) {
+		if (ath_rc_priv->state[rate+1].per < ath_rc_priv->state[rate].per)
+			ath_rc_priv->state[rate+1].per =
+				ath_rc_priv->state[rate].per;
 	}
 
 	/* Every so often, we reduce the thresholds and
 	 * PER (different for CCK and OFDM). */
-	if (now_msec - rate_ctrl->rssi_down_time >=
+	if (now_msec - ath_rc_priv->rssi_down_time >=
 	    rate_table->rssi_reduce_interval) {
 
-		for (rate = 0; rate < rate_ctrl->rate_table_size; rate++) {
-			if (rate_ctrl->state[rate].rssi_thres >
+		for (rate = 0; rate < ath_rc_priv->rate_table_size; rate++) {
+			if (ath_rc_priv->state[rate].rssi_thres >
 			    rate_table->info[rate].rssi_ack_validmin)
-				rate_ctrl->state[rate].rssi_thres -= 1;
+				ath_rc_priv->state[rate].rssi_thres -= 1;
 		}
-		rate_ctrl->rssi_down_time = now_msec;
+		ath_rc_priv->rssi_down_time = now_msec;
 	}
 
 	/* Every so often, we reduce the thresholds
 	 * and PER (different for CCK and OFDM). */
-	if (now_msec - rate_ctrl->per_down_time >=
+	if (now_msec - ath_rc_priv->per_down_time >=
 	    rate_table->rssi_reduce_interval) {
-		for (rate = 0; rate < rate_ctrl->rate_table_size; rate++) {
-			rate_ctrl->state[rate].per =
-				7 * rate_ctrl->state[rate].per / 8;
+		for (rate = 0; rate < ath_rc_priv->rate_table_size; rate++) {
+			ath_rc_priv->state[rate].per =
+				7 * ath_rc_priv->state[rate].per / 8;
 		}
 
-		rate_ctrl->per_down_time = now_msec;
+		ath_rc_priv->per_down_time = now_msec;
 	}
 }
 
@@ -1560,7 +1545,6 @@ static void ath_rc_update(struct ath_softc *sc,
 {
 	struct ath_rate_softc *asc = (struct ath_rate_softc *)sc->sc_rc;
 	struct ath_rate_table *rate_table;
-	struct ath_tx_ratectrl *rate_ctrl;
 	struct ath_rc_series rcs[4];
 	u8 flags;
 	u32 series = 0, rix;
@@ -1568,7 +1552,6 @@ static void ath_rc_update(struct ath_softc *sc,
 	memcpy(rcs, info_priv->rcs, 4 * sizeof(rcs[0]));
 	rate_table = (struct ath_rate_table *)
 		asc->hw_rate_table[sc->sc_curmode];
-	rate_ctrl = (struct ath_tx_ratectrl *)(ath_rc_priv);
 	ASSERT(rcs[0].tries != 0);
 
 	/*
@@ -1583,7 +1566,7 @@ static void ath_rc_update(struct ath_softc *sc,
 				/* If HT40 and we have switched mode from
 				 * 40 to 20 => don't update */
 				if ((flags & ATH_RC_CW40_FLAG) &&
-					(rate_ctrl->rc_phy_mode !=
+					(ath_rc_priv->rc_phy_mode !=
 					(flags & ATH_RC_CW40_FLAG)))
 					return;
 				if ((flags & ATH_RC_CW40_FLAG) &&
@@ -1619,7 +1602,7 @@ static void ath_rc_update(struct ath_softc *sc,
 	flags = rcs[series].flags;
 	/* If HT40 and we have switched mode from 40 to 20 => don't update */
 	if ((flags & ATH_RC_CW40_FLAG) &&
-		(rate_ctrl->rc_phy_mode != (flags & ATH_RC_CW40_FLAG)))
+		(ath_rc_priv->rc_phy_mode != (flags & ATH_RC_CW40_FLAG)))
 		return;
 
 	if ((flags & ATH_RC_CW40_FLAG) && (flags & ATH_RC_SGI_FLAG))
@@ -1697,8 +1680,6 @@ static void ath_rc_sib_update(struct ath_softc *sc,
 	struct ath_rate_softc *asc = (struct ath_rate_softc *)sc->sc_rc;
 	struct ath_rateset *rateset = negotiated_rates;
 	u8 *ht_mcs = (u8 *)negotiated_htrates;
-	struct ath_tx_ratectrl *rate_ctrl =
-		(struct ath_tx_ratectrl *)ath_rc_priv;
 	u8 i, j, k, hi = 0, hthi = 0;
 
 	rate_table = (struct ath_rate_table *)
@@ -1706,24 +1687,24 @@ static void ath_rc_sib_update(struct ath_softc *sc,
 
 	/* Initial rate table size. Will change depending
 	 * on the working rate set */
-	rate_ctrl->rate_table_size = MAX_TX_RATE_TBL;
+	ath_rc_priv->rate_table_size = MAX_TX_RATE_TBL;
 
 	/* Initialize thresholds according to the global rate table */
-	for (i = 0 ; (i < rate_ctrl->rate_table_size) && (!keep_state); i++) {
-		rate_ctrl->state[i].rssi_thres =
+	for (i = 0 ; (i < ath_rc_priv->rate_table_size) && (!keep_state); i++) {
+		ath_rc_priv->state[i].rssi_thres =
 			rate_table->info[i].rssi_ack_validmin;
-		rate_ctrl->state[i].per = 0;
+		ath_rc_priv->state[i].per = 0;
 	}
 
 	/* Determine the valid rates */
-	ath_rc_init_valid_txmask(rate_ctrl);
+	ath_rc_init_valid_txmask(ath_rc_priv);
 
 	for (i = 0; i < WLAN_RC_PHY_MAX; i++) {
 		for (j = 0; j < MAX_TX_RATE_PHY; j++)
-			rate_ctrl->valid_phy_rateidx[i][j] = 0;
-		rate_ctrl->valid_phy_ratecnt[i] = 0;
+			ath_rc_priv->valid_phy_rateidx[i][j] = 0;
+		ath_rc_priv->valid_phy_ratecnt[i] = 0;
 	}
-	rate_ctrl->rc_phy_mode = (capflag & WLAN_RC_40_FLAG);
+	ath_rc_priv->rc_phy_mode = (capflag & WLAN_RC_40_FLAG);
 
 	/* Set stream capability */
 	ath_rc_priv->single_stream = (capflag & WLAN_RC_DS_FLAG) ? 0 : 1;
@@ -1745,33 +1726,33 @@ static void ath_rc_sib_update(struct ath_softc *sc,
 		hi = A_MAX(hi, hthi);
 	}
 
-	rate_ctrl->rate_table_size = hi + 1;
-	rate_ctrl->rate_max_phy = 0;
-	ASSERT(rate_ctrl->rate_table_size <= MAX_TX_RATE_TBL);
+	ath_rc_priv->rate_table_size = hi + 1;
+	ath_rc_priv->rate_max_phy = 0;
+	ASSERT(ath_rc_priv->rate_table_size <= MAX_TX_RATE_TBL);
 
 	for (i = 0, k = 0; i < WLAN_RC_PHY_MAX; i++) {
-		for (j = 0; j < rate_ctrl->valid_phy_ratecnt[i]; j++) {
-			rate_ctrl->valid_rate_index[k++] =
-				rate_ctrl->valid_phy_rateidx[i][j];
+		for (j = 0; j < ath_rc_priv->valid_phy_ratecnt[i]; j++) {
+			ath_rc_priv->valid_rate_index[k++] =
+				ath_rc_priv->valid_phy_rateidx[i][j];
 		}
 
 		if (!ath_rc_valid_phyrate(i, rate_table->initial_ratemax, TRUE)
-		    || !rate_ctrl->valid_phy_ratecnt[i])
+		    || !ath_rc_priv->valid_phy_ratecnt[i])
 			continue;
 
-		rate_ctrl->rate_max_phy = rate_ctrl->valid_phy_rateidx[i][j-1];
+		ath_rc_priv->rate_max_phy = ath_rc_priv->valid_phy_rateidx[i][j-1];
 	}
-	ASSERT(rate_ctrl->rate_table_size <= MAX_TX_RATE_TBL);
+	ASSERT(ath_rc_priv->rate_table_size <= MAX_TX_RATE_TBL);
 	ASSERT(k <= MAX_TX_RATE_TBL);
 
-	rate_ctrl->max_valid_rate = k;
+	ath_rc_priv->max_valid_rate = k;
 	/*
 	 * Some third party vendors don't send the supported rate series in
 	 * order. So sorting to make sure its in order, otherwise our RateFind
 	 * Algo will select wrong rates
 	 */
-	ath_rc_sort_validrates(rate_table, rate_ctrl);
-	rate_ctrl->rate_max_phy = rate_ctrl->valid_rate_index[k-4];
+	ath_rc_sort_validrates(rate_table, ath_rc_priv);
+	ath_rc_priv->rate_max_phy = ath_rc_priv->valid_rate_index[k-4];
 }
 
 /*
@@ -1804,10 +1785,7 @@ static int ath_rate_newassoc(struct ath_softc *sc,
  */
 static void ath_rc_sib_init(struct ath_rate_node *ath_rc_priv)
 {
-	struct ath_tx_ratectrl *rate_ctrl;
-
-	rate_ctrl = (struct ath_tx_ratectrl *)(ath_rc_priv);
-	rate_ctrl->rssi_down_time = jiffies_to_msecs(jiffies);
+	ath_rc_priv->rssi_down_time = jiffies_to_msecs(jiffies);
 }
 
 
diff --git a/drivers/net/wireless/ath9k/rc.h b/drivers/net/wireless/ath9k/rc.h
index 6671097..2166243 100644
--- a/drivers/net/wireless/ath9k/rc.h
+++ b/drivers/net/wireless/ath9k/rc.h
@@ -204,8 +204,22 @@ struct ath_tx_ratectrl_state {
 	u8 per;			/* recent estimate of packet error rate (%) */
 };
 
+struct ath_rateset {
+	u8 rs_nrates;
+	u8 rs_rates[ATH_RATE_MAX];
+};
+
+/* per-device state */
+struct ath_rate_softc {
+	/* phy tables that contain rate control data */
+	const void *hw_rate_table[ATH9K_MODE_MAX];
+
+	/* -1 or index of fixed rate */
+	int fixedrix;
+};
+
 /**
- * struct ath_tx_ratectrl - TX Rate control Information
+ * struct ath_rate_node - Rate Control priv data
  * @state: RC state
  * @rssi_last: last ACK rssi
  * @rssi_last_lookup: last ACK rssi used for lookup
@@ -224,9 +238,15 @@ struct ath_tx_ratectrl_state {
  * @valid_phy_ratecnt: valid rate count
  * @rate_max_phy: phy index for the max rate
  * @probe_interval: interval for ratectrl to probe for other rates
+ * @prev_data_rix: rate idx of last data frame
+ * @ht_cap: HT capabilities
+ * @single_stream: When TRUE, only single TX stream possible
+ * @neg_rates: Negotatied rates
+ * @neg_ht_rates: Negotiated HT rates
  */
-struct ath_tx_ratectrl {
-	struct ath_tx_ratectrl_state state[MAX_TX_RATE_TBL];
+
+/* per-node state */
+struct ath_rate_node {
 	int8_t rssi_last;
 	int8_t rssi_last_lookup;
 	int8_t rssi_last_prev;
@@ -236,55 +256,24 @@ struct ath_tx_ratectrl {
 	int32_t rssi_sum;
 	u8 rate_table_size;
 	u8 probe_rate;
-	u32 rssi_time;
-	u32 rssi_down_time;
-	u32 probe_time;
 	u8 hw_maxretry_pktcnt;
 	u8 max_valid_rate;
 	u8 valid_rate_index[MAX_TX_RATE_TBL];
-	u32 per_down_time;
-
-	/* 11n state */
+	u8 ht_cap;
+	u8 single_stream;
 	u8 valid_phy_ratecnt[WLAN_RC_PHY_MAX];
 	u8 valid_phy_rateidx[WLAN_RC_PHY_MAX][MAX_TX_RATE_TBL];
 	u8 rc_phy_mode;
 	u8 rate_max_phy;
+	u32 rssi_time;
+	u32 rssi_down_time;
+	u32 probe_time;
+	u32 per_down_time;
 	u32 probe_interval;
-};
-
-struct ath_rateset {
-	u8 rs_nrates;
-	u8 rs_rates[ATH_RATE_MAX];
-};
-
-/* per-device state */
-struct ath_rate_softc {
-	/* phy tables that contain rate control data */
-	const void *hw_rate_table[ATH9K_MODE_MAX];
-
-	/* -1 or index of fixed rate */
-	int fixedrix;
-};
-
-/* per-node state */
-struct ath_rate_node {
-	struct ath_tx_ratectrl tx_ratectrl;
-
-	/* rate idx of last data frame */
 	u32 prev_data_rix;
-
-	/* ht capabilities */
-	u8 ht_cap;
-
-	/* When TRUE, only single stream Tx possible */
-	u8 single_stream;
-
-	/* Negotiated rates */
+	struct ath_tx_ratectrl_state state[MAX_TX_RATE_TBL];
 	struct ath_rateset neg_rates;
-
-	/* Negotiated HT rates */
 	struct ath_rateset neg_ht_rates;
-
 	struct ath_rate_softc *asc;
 	struct ath_vap *avp;
 };
-- 
1.6.0.3

