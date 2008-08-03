Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:50700 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751883AbYHCAh2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Aug 2008 20:37:28 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sat, 02 Aug 2008 17:37:28 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	<jouni.malinen@atheros.com>,
	Sujith Manoharan <smanoharan@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	Sujith <Sujith.Manoharan@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 01/12] ath9k: Fix whitespace damage
Date: Sat, 2 Aug 2008 17:37:26 -0700
Message-ID: <1217723846-26418-1-git-send-email-lrodriguez@atheros.com> (sfid-20080803_023734_845749_EDD2A867)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <smanoharan@atheros.com>

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath9k/rc.c |  217 +++++++++++++++++++--------------------
 1 files changed, 108 insertions(+), 109 deletions(-)

diff --git a/drivers/net/wireless/ath9k/rc.c b/drivers/net/wireless/ath9k/rc.c
index 22b6550..83b8f2d 100644
--- a/drivers/net/wireless/ath9k/rc.c
+++ b/drivers/net/wireless/ath9k/rc.c
@@ -22,7 +22,7 @@
 #include "core.h"
 #include "../net/mac80211/rate.h"
 
-static u_int32_t    tx_triglevel_max;
+static u_int32_t tx_triglevel_max;
 
 static struct ath_rate_table ar5416_11na_ratetable = {
 	42,
@@ -159,13 +159,13 @@ static struct ath_rate_table ar5416_11na_ratetable = {
 	WLAN_RC_HT_FLAG,  /* Phy rates allowed initially */
 };
 
-	/* TRUE_ALL - valid for 20/40/Legacy,
-	 * TRUE - Legacy only,
-	 * TRUE_20 - HT 20 only,
-	 * TRUE_40 - HT 40 only */
+/* TRUE_ALL - valid for 20/40/Legacy,
+ * TRUE - Legacy only,
+ * TRUE_20 - HT 20 only,
+ * TRUE_40 - HT 40 only */
 
-	/* 4ms frame limit not used for NG mode.  The values filled
-	 * for HT are the 64K max aggregate limit */
+/* 4ms frame limit not used for NG mode.  The values filled
+ * for HT are the 64K max aggregate limit */
 
 static struct ath_rate_table ar5416_11ng_ratetable = {
 	46,
@@ -541,19 +541,17 @@ static inline int8_t median(int8_t a, int8_t b, int8_t c)
 }
 
 static void ath_rc_sort_validrates(const struct ath_rate_table *rate_table,
-					struct ath_tx_ratectrl *rate_ctrl)
+				   struct ath_tx_ratectrl *rate_ctrl)
 {
 	u_int8_t i, j, idx, idx_next;
 
 	for (i = rate_ctrl->max_valid_rate - 1; i > 0; i--) {
 		for (j = 0; j <= i-1; j++) {
-
 			idx = rate_ctrl->valid_rate_index[j];
 			idx_next = rate_ctrl->valid_rate_index[j+1];
 
 			if (rate_table->info[idx].ratekbps >
 				rate_table->info[idx_next].ratekbps) {
-
 				rate_ctrl->valid_rate_index[j] = idx_next;
 				rate_ctrl->valid_rate_index[j+1] = idx;
 			}
@@ -565,14 +563,14 @@ static void ath_rc_sort_validrates(const struct ath_rate_table *rate_table,
 
 static void ath_rc_init_valid_txmask(struct ath_tx_ratectrl *rate_ctrl)
 {
-	u_int8_t     i;
+	u_int8_t i;
 
 	for (i = 0; i < rate_ctrl->rate_table_size; i++)
 		rate_ctrl->valid_rate_index[i] = FALSE;
 }
 
 static inline void ath_rc_set_valid_txmask(struct ath_tx_ratectrl *rate_ctrl,
-					u_int8_t index, int valid_tx_rate)
+					   u_int8_t index, int valid_tx_rate)
 {
 	ASSERT(index <= rate_ctrl->rate_table_size);
 	rate_ctrl->valid_rate_index[index] = valid_tx_rate ? TRUE : FALSE;
@@ -586,11 +584,11 @@ static inline int ath_rc_isvalid_txmask(struct ath_tx_ratectrl *rate_ctrl,
 }
 
 /* Iterators for valid_txrate_mask */
-static inline int ath_rc_get_nextvalid_txrate(
-	const struct ath_rate_table *rate_table,
-	struct ath_tx_ratectrl *rate_ctrl,
-	u_int8_t cur_valid_txrate,
-	u_int8_t *next_idx)
+static inline int
+ath_rc_get_nextvalid_txrate(const struct ath_rate_table *rate_table,
+			    struct ath_tx_ratectrl *rate_ctrl,
+			    u_int8_t cur_valid_txrate,
+			    u_int8_t *next_idx)
 {
 	u_int8_t i;
 
@@ -624,10 +622,10 @@ static int ath_rc_valid_phyrate(u_int32_t phy, u_int32_t capflag, int ignore_cw)
 	return TRUE;
 }
 
-static inline int ath_rc_get_nextlowervalid_txrate(
-				const struct ath_rate_table *rate_table,
-				struct ath_tx_ratectrl *rate_ctrl,
-				u_int8_t cur_valid_txrate, u_int8_t *next_idx)
+static inline int
+ath_rc_get_nextlowervalid_txrate(const struct ath_rate_table *rate_table,
+				 struct ath_tx_ratectrl *rate_ctrl,
+				 u_int8_t cur_valid_txrate, u_int8_t *next_idx)
 {
 	int8_t i;
 
@@ -643,9 +641,10 @@ static inline int ath_rc_get_nextlowervalid_txrate(
 /*
  * Initialize the Valid Rate Index from valid entries in Rate Table
  */
-static u_int8_t ath_rc_sib_init_validrates(struct ath_rate_node *ath_rc_priv,
-					const struct ath_rate_table *rate_table,
-					u_int32_t capflag)
+static u_int8_t
+ath_rc_sib_init_validrates(struct ath_rate_node *ath_rc_priv,
+			   const struct ath_rate_table *rate_table,
+			   u_int32_t capflag)
 {
 	struct ath_tx_ratectrl *rate_ctrl;
 	u_int8_t i, hi = 0;
@@ -677,10 +676,11 @@ static u_int8_t ath_rc_sib_init_validrates(struct ath_rate_node *ath_rc_priv,
 /*
  * Initialize the Valid Rate Index from Rate Set
  */
-static u_int8_t ath_rc_sib_setvalid_rates(struct ath_rate_node *ath_rc_priv,
-					const struct ath_rate_table *rate_table,
-					struct ath_rateset *rateset,
-					u_int32_t capflag)
+static u_int8_t
+ath_rc_sib_setvalid_rates(struct ath_rate_node *ath_rc_priv,
+			  const struct ath_rate_table *rate_table,
+			  struct ath_rateset *rateset,
+			  u_int32_t capflag)
 {
 	/* XXX: Clean me up and make identation friendly */
 	u_int8_t i, j, hi = 0;
@@ -726,9 +726,10 @@ static u_int8_t ath_rc_sib_setvalid_rates(struct ath_rate_node *ath_rc_priv,
 	return hi;
 }
 
-static u_int8_t ath_rc_sib_setvalid_htrates(struct ath_rate_node *ath_rc_priv,
-				const struct ath_rate_table *rate_table,
-				u_int8_t *mcs_set, u_int32_t capflag)
+static u_int8_t
+ath_rc_sib_setvalid_htrates(struct ath_rate_node *ath_rc_priv,
+			    const struct ath_rate_table *rate_table,
+			    u_int8_t *mcs_set, u_int32_t capflag)
 {
 	u_int8_t i, j, hi = 0;
 	struct ath_tx_ratectrl *rate_ctrl =
@@ -785,8 +786,8 @@ struct ath_rate_softc *ath_rate_attach(struct ath_hal *ah)
 }
 
 static struct ath_rate_node *ath_rate_node_alloc(struct ath_vap *avp,
-						struct ath_rate_softc *rsc,
-						gfp_t gfp)
+						 struct ath_rate_softc *rsc,
+						 gfp_t gfp)
 {
 	struct ath_rate_node *anode;
 
@@ -812,7 +813,7 @@ void ath_rate_detach(struct ath_rate_softc *asc)
 }
 
 u_int8_t ath_rate_findrateix(struct ath_softc *sc,
-				u_int8_t dot11rate)
+			     u_int8_t dot11rate)
 {
 	const struct ath_rate_table *ratetable;
 	struct ath_rate_softc *rsc = sc->sc_rc;
@@ -824,10 +825,10 @@ u_int8_t ath_rate_findrateix(struct ath_softc *sc,
 		return 0;
 
 	for (i = 0; i < ratetable->rate_cnt; i++) {
-		if ((ratetable->info[i].dot11rate & 0x7f) ==
-				(dot11rate & 0x7f))
+		if ((ratetable->info[i].dot11rate & 0x7f) == (dot11rate & 0x7f))
 			return i;
 	}
+
 	return 0;
 }
 
@@ -863,9 +864,10 @@ void ath_rate_newstate(struct ath_softc *sc, struct ath_vap *avp, int up)
 }
 
 static u_int8_t ath_rc_ratefind_ht(struct ath_softc *sc,
-		struct ath_rate_node *ath_rc_priv,
-		const struct ath_rate_table *rate_table,
-		int probe_allowed, int *is_probing, int is_retry)
+				   struct ath_rate_node *ath_rc_priv,
+				   const struct ath_rate_table *rate_table,
+				   int probe_allowed, int *is_probing,
+				   int is_retry)
 {
 	u_int32_t dt, best_thruput, this_thruput, now_msec;
 	u_int8_t rate, next_rate, best_rate, maxindex, minindex;
@@ -873,13 +875,13 @@ static u_int8_t ath_rc_ratefind_ht(struct ath_softc *sc,
 	struct ath_tx_ratectrl  *rate_ctrl = NULL;
 
 	rate_ctrl = (struct ath_tx_ratectrl *)(ath_rc_priv ?
-		(ath_rc_priv) : NULL);
+					       (ath_rc_priv) : NULL);
 
 	*is_probing = FALSE;
 
-	rssi_last   = median(rate_ctrl->rssi_last,
-			rate_ctrl->rssi_last_prev,
-			rate_ctrl->rssi_last_prev2);
+	rssi_last = median(rate_ctrl->rssi_last,
+			   rate_ctrl->rssi_last_prev,
+			   rate_ctrl->rssi_last_prev2);
 
 	/*
 	 * Age (reduce) last ack rssi based on how old it is.
@@ -910,20 +912,19 @@ static u_int8_t ath_rc_ratefind_ht(struct ath_softc *sc,
 	 */
 
 	best_thruput = 0;
-	maxindex    = rate_ctrl->max_valid_rate-1;
+	maxindex = rate_ctrl->max_valid_rate-1;
+
+	minindex = 0;
+	best_rate = minindex;
 
-	minindex    = 0;
-	best_rate    = minindex;
 	/*
 	 * Try the higher rate first. It will reduce memory moving time
 	 * if we have very good channel characteristics.
 	 */
-
 	for (index = maxindex; index >= minindex ; index--) {
 		u_int8_t per_thres;
 
 		rate = rate_ctrl->valid_rate_index[index];
-
 		if (rate > rate_ctrl->rate_max_phy)
 			continue;
 
@@ -967,21 +968,20 @@ static u_int8_t ath_rc_ratefind_ht(struct ath_softc *sc,
 	 */
 
 	if (rate >= rate_ctrl->rate_max_phy && probe_allowed) {
-
 		rate = rate_ctrl->rate_max_phy;
 
 		/* Probe the next allowed phy state */
 		/* FIXME:XXXX Check to make sure ratMax is checked properly */
 		if (ath_rc_get_nextvalid_txrate(rate_table,
-				rate_ctrl, rate, &next_rate) &&
-				(now_msec - rate_ctrl->probe_time >
-					rate_table->probe_interval) &&
-				(rate_ctrl->hw_maxretry_pktcnt >= 1)) {
-			rate                  = next_rate;
-			rate_ctrl->probe_rate        = rate;
-			rate_ctrl->probe_time        = now_msec;
+						rate_ctrl, rate, &next_rate) &&
+		    (now_msec - rate_ctrl->probe_time >
+		     rate_table->probe_interval) &&
+		    (rate_ctrl->hw_maxretry_pktcnt >= 1)) {
+			rate = next_rate;
+			rate_ctrl->probe_rate = rate;
+			rate_ctrl->probe_time = now_msec;
 			rate_ctrl->hw_maxretry_pktcnt = 0;
-			*is_probing            = TRUE;
+			*is_probing = TRUE;
 		}
 	}
 
@@ -1002,26 +1002,29 @@ static u_int8_t ath_rc_ratefind_ht(struct ath_softc *sc,
 }
 
 static void ath_rc_rate_set_series(const struct ath_rate_table *rate_table ,
-		struct ath_rc_series *series, u_int8_t tries, u_int8_t rix,
-		int rtsctsenable)
+				   struct ath_rc_series *series,
+				   u_int8_t tries,
+				   u_int8_t rix,
+				   int rtsctsenable)
 {
 	series->tries = tries;
 	series->flags = (rtsctsenable? ATH_RC_RTSCTS_FLAG : 0) |
 		(WLAN_RC_PHY_DS(rate_table->info[rix].phy) ?
-			ATH_RC_DS_FLAG : 0) |
+		 ATH_RC_DS_FLAG : 0) |
 		(WLAN_RC_PHY_40(rate_table->info[rix].phy) ?
-			ATH_RC_CW40_FLAG : 0) |
+		 ATH_RC_CW40_FLAG : 0) |
 		(WLAN_RC_PHY_SGI(rate_table->info[rix].phy) ?
-			ATH_RC_SGI_FLAG : 0);
+		 ATH_RC_SGI_FLAG : 0);
 
 	series->rix = rate_table->info[rix].base_index;
 	series->max_4ms_framelen = rate_table->info[rix].max_4ms_framelen;
 }
 
 static u_int8_t ath_rc_rate_getidx(struct ath_softc *sc,
-		struct ath_rate_node *ath_rc_priv,
-		const struct ath_rate_table *rate_table,
-		u_int8_t rix, u_int16_t stepdown, u_int16_t min_rate)
+				   struct ath_rate_node *ath_rc_priv,
+				   const struct ath_rate_table *rate_table,
+				   u_int8_t rix, u_int16_t stepdown,
+				   u_int16_t min_rate)
 {
 	u_int32_t j;
 	u_int8_t nextindex;
@@ -1049,9 +1052,10 @@ static u_int8_t ath_rc_rate_getidx(struct ath_softc *sc,
 }
 
 static void ath_rc_ratefind(struct ath_softc *sc,
-		struct ath_rate_node *ath_rc_priv,
-		int num_tries, int num_rates, unsigned int rcflag,
-		struct ath_rc_series series[], int *is_probe, int is_retry)
+			    struct ath_rate_node *ath_rc_priv,
+			    int num_tries, int num_rates, unsigned int rcflag,
+			    struct ath_rc_series series[], int *is_probe,
+			    int is_retry)
 {
 	u_int8_t try_per_rate = 0, i = 0, rix, nrix;
 	struct ath_rate_softc  *asc = (struct ath_rate_softc *)sc->sc_rc;
@@ -1090,7 +1094,7 @@ static void ath_rc_ratefind(struct ath_softc *sc,
 		u_int8_t try_num;
 		u_int8_t min_rate;
 
-		try_num  = ((i + 1) == num_rates) ?
+		try_num = ((i + 1) == num_rates) ?
 			num_tries - (try_per_rate * i) : try_per_rate ;
 		min_rate = (((i + 1) == num_rates) &&
 			(rcflag & ATH_RC_MINRATE_LASTRATE)) ? 1 : 0;
@@ -1135,19 +1139,16 @@ static void ath_rc_ratefind(struct ath_softc *sc,
 /*
  * Return the Tx rate series.
  */
-
-
 void ath_rate_findrate(struct ath_softc *sc,
-		struct ath_rate_node *ath_rc_priv,
-		int num_tries,
-		int num_rates,
-		unsigned int rcflag,
-		struct ath_rc_series series[],
-		int *is_probe,
-		int is_retry
-		)
+		       struct ath_rate_node *ath_rc_priv,
+		       int num_tries,
+		       int num_rates,
+		       unsigned int rcflag,
+		       struct ath_rc_series series[],
+		       int *is_probe,
+		       int is_retry)
 {
-	struct ath_vap         *avp = ath_rc_priv->avp;
+	struct ath_vap *avp = ath_rc_priv->avp;
 
 	DPRINTF(sc, ATH_DBG_RATE, "%s", __func__);
 	if (!num_rates || !num_tries)
@@ -1265,7 +1266,6 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 			rate_ctrl->state[tx_rate].per += 30;
 			if (rate_ctrl->state[tx_rate].per > 100)
 				rate_ctrl->state[tx_rate].per = 100;
-
 		} else {
 			/* xretries == 2 */
 			count = sizeof(nretry_to_per_lookup) /
@@ -1285,7 +1285,6 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 			rate_ctrl->probe_rate = 0;
 
 	} else {	/* xretries == 0 */
-
 		/* Update the PER. */
 		/* Make sure it doesn't index out of array's bounds. */
 		count = sizeof(nretry_to_per_lookup) /
@@ -1326,8 +1325,8 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 
 		rate_ctrl->rssi_last_prev2 = rate_ctrl->rssi_last_prev;
 		rate_ctrl->rssi_last_prev  = rate_ctrl->rssi_last;
-		rate_ctrl->rssi_last      = info_priv->tx.ts_rssi;
-		rate_ctrl->rssi_time      = now_msec;
+		rate_ctrl->rssi_last = info_priv->tx.ts_rssi;
+		rate_ctrl->rssi_time = now_msec;
 
 		/*
 		 * If we got at most one retry then increase the max rate if
@@ -1427,7 +1426,6 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 		}
 	}
 
-
 	/* For all cases */
 
 	/*
@@ -1555,9 +1553,9 @@ static void ath_rc_update_ht(struct ath_softc *sc,
  * the status of previous frames.
  */
 static void ath_rc_update(struct ath_softc *sc,
-		struct ath_rate_node *ath_rc_priv,
-		struct ath_tx_info_priv *info_priv, int final_ts_idx,
-		int xretries, int long_retry)
+			  struct ath_rate_node *ath_rc_priv,
+			  struct ath_tx_info_priv *info_priv, int final_ts_idx,
+			  int xretries, int long_retry)
 {
 	struct ath_rate_softc  *asc = (struct ath_rate_softc *)sc->sc_rc;
 	struct ath_rate_table *rate_table;
@@ -1577,7 +1575,6 @@ static void ath_rc_update(struct ath_softc *sc,
 	 * are intermediate rate failures to be processed.
 	 */
 	if (final_ts_idx != 0) {
-
 		/* Process intermediate rates that failed.*/
 		for (series = 0; series < final_ts_idx ; series++) {
 			if (rcs[series].tries != 0) {
@@ -1641,10 +1638,10 @@ static void ath_rc_update(struct ath_softc *sc,
 /*
  * Process a tx descriptor for a completed transmit (success or failure).
  */
-
 static void ath_rate_tx_complete(struct ath_softc *sc,
-		struct ath_node *an, struct ath_rate_node *rc_priv,
-		struct ath_tx_info_priv *info_priv)
+				 struct ath_node *an,
+				 struct ath_rate_node *rc_priv,
+				 struct ath_tx_info_priv *info_priv)
 {
 	int final_ts_idx = info_priv->tx.ts_rateindex;
 	int tx_status = 0, is_underrun = 0;
@@ -1678,8 +1675,8 @@ static void ath_rate_tx_complete(struct ath_softc *sc,
 		tx_status = 1;
 
 	ath_rc_update(sc, rc_priv, info_priv, final_ts_idx, tx_status,
-			(is_underrun) ? ATH_11N_TXMAXTRY
-			:info_priv->tx.ts_longretry);
+		      (is_underrun) ? ATH_11N_TXMAXTRY :
+		      info_priv->tx.ts_longretry);
 }
 
 
@@ -1692,10 +1689,10 @@ static void ath_rate_tx_complete(struct ath_softc *sc,
  *  It will determine which rates are valid for use.
  */
 static void ath_rc_sib_update(struct ath_softc *sc,
-			struct ath_rate_node *ath_rc_priv,
-			u_int32_t capflag, int keep_state,
-			struct ath_rateset *negotiated_rates,
-			struct ath_rateset *negotiated_htrates)
+			      struct ath_rate_node *ath_rc_priv,
+			      u_int32_t capflag, int keep_state,
+			      struct ath_rateset *negotiated_rates,
+			      struct ath_rateset *negotiated_htrates)
 {
 	struct ath_rate_table *rate_table = NULL;
 	struct ath_rate_softc *asc = (struct ath_rate_softc *)sc->sc_rc;
@@ -1716,7 +1713,7 @@ static void ath_rc_sib_update(struct ath_softc *sc,
 	for (i = 0 ; (i < rate_ctrl->rate_table_size) && (!keep_state); i++) {
 		rate_ctrl->state[i].rssi_thres =
 			rate_table->info[i].rssi_ack_validmin;
-		rate_ctrl->state[i].per       = 0;
+		rate_ctrl->state[i].per = 0;
 	}
 
 	/* Determine the valid rates */
@@ -1739,10 +1736,12 @@ static void ath_rc_sib_update(struct ath_softc *sc,
 	} else {
 		/* Use intersection of working rates and valid rates */
 		hi = ath_rc_sib_setvalid_rates(ath_rc_priv, rate_table,
-						rateset, capflag);
+					       rateset, capflag);
 		if (capflag & WLAN_RC_HT_FLAG) {
 			hthi = ath_rc_sib_setvalid_htrates(ath_rc_priv,
-						rate_table, ht_mcs, capflag);
+							   rate_table,
+							   ht_mcs,
+							   capflag);
 		}
 		hi = A_MAX(hi, hthi);
 	}
@@ -1758,7 +1757,7 @@ static void ath_rc_sib_update(struct ath_softc *sc,
 		}
 
 		if (!ath_rc_valid_phyrate(i, rate_table->initial_ratemax, TRUE)
-				      || !rate_ctrl->valid_phy_ratecnt[i])
+		    || !rate_ctrl->valid_phy_ratecnt[i])
 			continue;
 
 		rate_ctrl->rate_max_phy = rate_ctrl->valid_phy_rateidx[i][j-1];
@@ -1780,10 +1779,10 @@ static void ath_rc_sib_update(struct ath_softc *sc,
  * Update rate-control state on station associate/reassociate.
  */
 static int ath_rate_newassoc(struct ath_softc *sc,
-		struct ath_rate_node *ath_rc_priv,
-		unsigned int capflag,
-		struct ath_rateset *negotiated_rates,
-		struct ath_rateset *negotiated_htrates)
+			     struct ath_rate_node *ath_rc_priv,
+			     unsigned int capflag,
+			     struct ath_rateset *negotiated_rates,
+			     struct ath_rateset *negotiated_htrates)
 {
 
 
@@ -1794,7 +1793,7 @@ static int ath_rate_newassoc(struct ath_softc *sc,
 		((capflag & ATH_RC_CW40_FLAG) ? WLAN_RC_40_FLAG : 0);
 
 	ath_rc_sib_update(sc, ath_rc_priv, ath_rc_priv->ht_cap, 0,
-			negotiated_rates, negotiated_htrates);
+			  negotiated_rates, negotiated_htrates);
 
 	return 0;
 }
@@ -2027,8 +2026,8 @@ static void ath_get_rate(void *priv, struct net_device *dev,
 }
 
 static void ath_rate_init(void *priv, void *priv_sta,
-			    struct ieee80211_local *local,
-			    struct sta_info *sta)
+			  struct ieee80211_local *local,
+			  struct sta_info *sta)
 {
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_hw *hw = local_to_hw(local);
-- 
1.5.6.rc2.15.g457bb.dirty

