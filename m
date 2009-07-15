Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:42329 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755739AbZGOAO2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jul 2009 20:14:28 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
Subject: [PATCH 21/21] ath9k: Nuke struct ath_tx_ratectrl_state
Date: Tue, 14 Jul 2009 20:14:13 -0400
Message-Id: <1247616853-11221-22-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1247616853-11221-1-git-send-email-lrodriguez@atheros.com>
References: <1247616853-11221-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vasanthakumar Thiagarajan <vasanth@atheros.com>

Move its only member (u8 per) to struct ath_rate_priv.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/rc.c |   50 +++++++++++++++++-----------------
 drivers/net/wireless/ath/ath9k/rc.h |    7 +---
 2 files changed, 27 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index a97dd7b..a07efa2 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -636,7 +636,7 @@ static u8 ath_rc_get_highest_rix(struct ath_softc *sc,
 		 * 10-15 and we would be worse off then staying
 		 * at the current rate.
 		 */
-		per_thres = ath_rc_priv->state[rate].per;
+		per_thres = ath_rc_priv->per[rate];
 		if (per_thres < 12)
 			per_thres = 12;
 
@@ -881,13 +881,13 @@ static bool ath_rc_update_per(struct ath_softc *sc,
 		100 * 9 / 10
 	};
 
-	last_per = ath_rc_priv->state[tx_rate].per;
+	last_per = ath_rc_priv->per[tx_rate];
 
 	if (xretries) {
 		if (xretries == 1) {
-			ath_rc_priv->state[tx_rate].per += 30;
-			if (ath_rc_priv->state[tx_rate].per > 100)
-				ath_rc_priv->state[tx_rate].per = 100;
+			ath_rc_priv->per[tx_rate] += 30;
+			if (ath_rc_priv->per[tx_rate] > 100)
+				ath_rc_priv->per[tx_rate] = 100;
 		} else {
 			/* xretries == 2 */
 			count = ARRAY_SIZE(nretry_to_per_lookup);
@@ -895,7 +895,7 @@ static bool ath_rc_update_per(struct ath_softc *sc,
 				retries = count - 1;
 
 			/* new_PER = 7/8*old_PER + 1/8*(currentPER) */
-			ath_rc_priv->state[tx_rate].per =
+			ath_rc_priv->per[tx_rate] =
 				(u8)(last_per - (last_per >> 3) + (100 >> 3));
 		}
 
@@ -931,10 +931,10 @@ static bool ath_rc_update_per(struct ath_softc *sc,
 				n_frames = tx_info_priv->n_frames * (retries + 1);
 				cur_per = (100 * n_bad_frames / n_frames) >> 3;
 				new_per = (u8)(last_per - (last_per >> 3) + cur_per);
-				ath_rc_priv->state[tx_rate].per = new_per;
+				ath_rc_priv->per[tx_rate] = new_per;
 			}
 		} else {
-			ath_rc_priv->state[tx_rate].per =
+			ath_rc_priv->per[tx_rate] =
 				(u8)(last_per - (last_per >> 3) +
 				     (nretry_to_per_lookup[retries] >> 3));
 		}
@@ -962,8 +962,8 @@ static bool ath_rc_update_per(struct ath_softc *sc,
 					ath_rc_priv->probe_rate;
 				probe_rate = ath_rc_priv->probe_rate;
 
-				if (ath_rc_priv->state[probe_rate].per > 30)
-					ath_rc_priv->state[probe_rate].per = 20;
+				if (ath_rc_priv->per[probe_rate] > 30)
+					ath_rc_priv->per[probe_rate] = 20;
 
 				ath_rc_priv->probe_rate = 0;
 
@@ -1018,7 +1018,7 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 	if ((tx_rate < 0) || (tx_rate > rate_table->rate_cnt))
 		return;
 
-	last_per = ath_rc_priv->state[tx_rate].per;
+	last_per = ath_rc_priv->per[tx_rate];
 
 	/* Update PER first */
 	state_change = ath_rc_update_per(sc, rate_table, ath_rc_priv,
@@ -1029,7 +1029,7 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 	 * If this rate looks bad (high PER) then stop using it for
 	 * a while (except if we are probing).
 	 */
-	if (ath_rc_priv->state[tx_rate].per >= 55 && tx_rate > 0 &&
+	if (ath_rc_priv->per[tx_rate] >= 55 && tx_rate > 0 &&
 	    rate_table->info[tx_rate].ratekbps <=
 	    rate_table->info[ath_rc_priv->rate_max_phy].ratekbps) {
 		ath_rc_get_lower_rix(rate_table, ath_rc_priv,
@@ -1041,26 +1041,26 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 
 	/* Make sure the rates below this have lower PER */
 	/* Monotonicity is kept only for rates below the current rate. */
-	if (ath_rc_priv->state[tx_rate].per < last_per) {
+	if (ath_rc_priv->per[tx_rate] < last_per) {
 		for (rate = tx_rate - 1; rate >= 0; rate--) {
 			if (rate_table->info[rate].phy !=
 			    rate_table->info[tx_rate].phy)
 				break;
 
-			if (ath_rc_priv->state[rate].per >
-			    ath_rc_priv->state[rate+1].per) {
-				ath_rc_priv->state[rate].per =
-					ath_rc_priv->state[rate+1].per;
+			if (ath_rc_priv->per[rate] >
+			    ath_rc_priv->per[rate+1]) {
+				ath_rc_priv->per[rate] =
+					ath_rc_priv->per[rate+1];
 			}
 		}
 	}
 
 	/* Maintain monotonicity for rates above the current rate */
 	for (rate = tx_rate; rate < size - 1; rate++) {
-		if (ath_rc_priv->state[rate+1].per <
-		    ath_rc_priv->state[rate].per)
-			ath_rc_priv->state[rate+1].per =
-				ath_rc_priv->state[rate].per;
+		if (ath_rc_priv->per[rate+1] <
+		    ath_rc_priv->per[rate])
+			ath_rc_priv->per[rate+1] =
+				ath_rc_priv->per[rate];
 	}
 
 	/* Every so often, we reduce the thresholds
@@ -1068,15 +1068,15 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 	if (now_msec - ath_rc_priv->per_down_time >=
 	    rate_table->probe_interval) {
 		for (rate = 0; rate < size; rate++) {
-			ath_rc_priv->state[rate].per =
-				7 * ath_rc_priv->state[rate].per / 8;
+			ath_rc_priv->per[rate] =
+				7 * ath_rc_priv->per[rate] / 8;
 		}
 
 		ath_rc_priv->per_down_time = now_msec;
 	}
 
 	ath_debug_stat_retries(sc, tx_rate, xretries, retries,
-			       ath_rc_priv->state[tx_rate].per);
+			       ath_rc_priv->per[tx_rate]);
 
 }
 
@@ -1213,7 +1213,7 @@ static void ath_rc_init(struct ath_softc *sc,
 
 	/* Initialize thresholds according to the global rate table */
 	for (i = 0 ; i < ath_rc_priv->rate_table_size; i++) {
-		ath_rc_priv->state[i].per = 0;
+		ath_rc_priv->per[i] = 0;
 	}
 
 	/* Determine the valid rates */
diff --git a/drivers/net/wireless/ath/ath9k/rc.h b/drivers/net/wireless/ath/ath9k/rc.h
index c794d6c..fa21a62 100644
--- a/drivers/net/wireless/ath/ath9k/rc.h
+++ b/drivers/net/wireless/ath/ath9k/rc.h
@@ -122,10 +122,6 @@ struct ath_rate_table {
 	u8 initial_ratemax;
 };
 
-struct ath_tx_ratectrl_state {
-	u8 per;			/* recent estimate of packet error rate (%) */
-};
-
 struct ath_rateset {
 	u8 rs_nrates;
 	u8 rs_rates[ATH_RATE_MAX];
@@ -141,6 +137,7 @@ struct ath_rateset {
  * @per_down_time: msec timestamp for last PER down step
  * @valid_phy_ratecnt: valid rate count
  * @rate_max_phy: phy index for the max rate
+ * @per: PER for every valid rate in %
  * @probe_interval: interval for ratectrl to probe for other rates
  * @prev_data_rix: rate idx of last data frame
  * @ht_cap: HT capabilities
@@ -157,12 +154,12 @@ struct ath_rate_priv {
 	u8 valid_phy_ratecnt[WLAN_RC_PHY_MAX];
 	u8 valid_phy_rateidx[WLAN_RC_PHY_MAX][RATE_TABLE_SIZE];
 	u8 rate_max_phy;
+	u8 per[RATE_TABLE_SIZE];
 	u32 probe_time;
 	u32 per_down_time;
 	u32 probe_interval;
 	u32 prev_data_rix;
 	u32 tx_triglevel_max;
-	struct ath_tx_ratectrl_state state[RATE_TABLE_SIZE];
 	struct ath_rateset neg_rates;
 	struct ath_rateset neg_ht_rates;
 	struct ath_rate_softc *asc;
-- 
1.6.0.6

