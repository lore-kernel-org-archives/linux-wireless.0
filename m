Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:54818 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751952AbYHNII2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Aug 2008 04:08:28 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 14 Aug 2008 01:08:28 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18595.58695.248247.207076@localhost.localdomain> (sfid-20080814_100832_828402_6CAF04A3)
Date: Thu, 14 Aug 2008 13:26:55 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 2/6] ath9k: Random cleanup
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove dead code, add newlines, fix indentation.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/core.c |    5 +-
 drivers/net/wireless/ath9k/hw.c   |   13 +---
 drivers/net/wireless/ath9k/rc.c   |  159 +++++++++++++++++++------------------
 3 files changed, 83 insertions(+), 94 deletions(-)

diff --git a/drivers/net/wireless/ath9k/core.c b/drivers/net/wireless/ath9k/core.c
index a9e8ad0..e3682b6 100644
--- a/drivers/net/wireless/ath9k/core.c
+++ b/drivers/net/wireless/ath9k/core.c
@@ -1025,7 +1025,6 @@ int ath_init(u16 devid, struct ath_softc *sc)
 	int status;
 	int error = 0, i;
 	int csz = 0;
-	u32 rd;
 
 	/* XXX: hardware will not be ready until ath_open() being called */
 	sc->sc_flags |= SC_OP_INVALID;
@@ -1091,8 +1090,6 @@ int ath_init(u16 devid, struct ath_softc *sc)
 	 * is resposible for filtering this list based on settings
 	 * like the phy mode.
 	 */
-	rd = ah->ah_currentRD;
-
 	error = ath_setup_channels(sc);
 	if (error)
 		goto bad;
@@ -1169,7 +1166,7 @@ int ath_init(u16 devid, struct ath_softc *sc)
 
 	sc->sc_rc = ath_rate_attach(ah);
 	if (sc->sc_rc == NULL) {
-		error = EIO;
+		error = -EIO;
 		goto bad2;
 	}
 
diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index 72ad3f3..23eb789 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -7650,8 +7650,7 @@ bool ath9k_hw_resettxqueue(struct ath_hal *ah, u32 q)
 	REG_WRITE(ah, AR_DRETRY_LIMIT(q),
 		  SM(INIT_SSH_RETRY, AR_D_RETRY_LIMIT_STA_SH)
 		  | SM(INIT_SLG_RETRY, AR_D_RETRY_LIMIT_STA_LG)
-		  | SM(qi->tqi_shretry, AR_D_RETRY_LIMIT_FR_SH)
-		);
+		  | SM(qi->tqi_shretry, AR_D_RETRY_LIMIT_FR_SH));
 
 	REG_WRITE(ah, AR_QMISC(q), AR_Q_MISC_DCU_EARLY_TERM_REQ);
 	REG_WRITE(ah, AR_DMISC(q),
@@ -8296,15 +8295,7 @@ struct ath_hal *ath9k_hw_attach(u16 devid,
 		*error = -ENXIO;
 		break;
 	}
-	if (ah != NULL) {
-		ah->ah_devid = ah->ah_devid;
-		ah->ah_subvendorid = ah->ah_subvendorid;
-		ah->ah_macVersion = ah->ah_macVersion;
-		ah->ah_macRev = ah->ah_macRev;
-		ah->ah_phyRev = ah->ah_phyRev;
-		ah->ah_analog5GhzRev = ah->ah_analog5GhzRev;
-		ah->ah_analog2GhzRev = ah->ah_analog2GhzRev;
-	}
+
 	return ah;
 }
 
diff --git a/drivers/net/wireless/ath9k/rc.c b/drivers/net/wireless/ath9k/rc.c
index 1392361..1dd7c71 100644
--- a/drivers/net/wireless/ath9k/rc.c
+++ b/drivers/net/wireless/ath9k/rc.c
@@ -653,8 +653,8 @@ ath_rc_sib_init_validrates(struct ath_rate_node *ath_rc_priv,
 	rate_ctrl = (struct ath_tx_ratectrl *)(ath_rc_priv);
 	for (i = 0; i < rate_table->rate_cnt; i++) {
 		valid = (ath_rc_priv->single_stream ?
-				rate_table->info[i].valid_single_stream :
-				rate_table->info[i].valid);
+			 rate_table->info[i].valid_single_stream :
+			 rate_table->info[i].valid);
 		if (valid == TRUE) {
 			u32 phy = rate_table->info[i].phy;
 			u8 valid_rate_count = 0;
@@ -740,14 +740,14 @@ ath_rc_sib_setvalid_htrates(struct ath_rate_node *ath_rc_priv,
 		for (j = 0; j < rate_table->rate_cnt; j++) {
 			u32 phy = rate_table->info[j].phy;
 			u32 valid = (ath_rc_priv->single_stream ?
-				rate_table->info[j].valid_single_stream :
-				rate_table->info[j].valid);
+				     rate_table->info[j].valid_single_stream :
+				     rate_table->info[j].valid);
 
 			if (((((struct ath_rateset *)
-				mcs_set)->rs_rates[i] & 0x7F) !=
-				(rate_table->info[j].dot11rate & 0x7F)) ||
-					!WLAN_RC_PHY_HT(phy) ||
-					!WLAN_RC_PHY_HT_VALID(valid, capflag))
+			       mcs_set)->rs_rates[i] & 0x7F) !=
+			     (rate_table->info[j].dot11rate & 0x7F)) ||
+			    !WLAN_RC_PHY_HT(phy) ||
+			    !WLAN_RC_PHY_HT_VALID(valid, capflag))
 				continue;
 
 			if (!ath_rc_valid_phyrate(phy, capflag, FALSE))
@@ -866,10 +866,10 @@ void ath_rate_newstate(struct ath_softc *sc, struct ath_vap *avp)
 }
 
 static u8 ath_rc_ratefind_ht(struct ath_softc *sc,
-				   struct ath_rate_node *ath_rc_priv,
-				   const struct ath_rate_table *rate_table,
-				   int probe_allowed, int *is_probing,
-				   int is_retry)
+			     struct ath_rate_node *ath_rc_priv,
+			     const struct ath_rate_table *rate_table,
+			     int probe_allowed, int *is_probing,
+			     int is_retry)
 {
 	u32 dt, best_thruput, this_thruput, now_msec;
 	u8 rate, next_rate, best_rate, maxindex, minindex;
@@ -997,8 +997,8 @@ static u8 ath_rc_ratefind_ht(struct ath_softc *sc,
 		rate = rate_ctrl->rate_table_size - 1;
 
 	ASSERT((rate_table->info[rate].valid && !ath_rc_priv->single_stream) ||
-		(rate_table->info[rate].valid_single_stream &&
-			ath_rc_priv->single_stream));
+	       (rate_table->info[rate].valid_single_stream &&
+		ath_rc_priv->single_stream));
 
 	return rate;
 }
@@ -1023,10 +1023,10 @@ static void ath_rc_rate_set_series(const struct ath_rate_table *rate_table ,
 }
 
 static u8 ath_rc_rate_getidx(struct ath_softc *sc,
-				   struct ath_rate_node *ath_rc_priv,
-				   const struct ath_rate_table *rate_table,
-				   u8 rix, u16 stepdown,
-				   u16 min_rate)
+			     struct ath_rate_node *ath_rc_priv,
+			     const struct ath_rate_table *rate_table,
+			     u8 rix, u16 stepdown,
+			     u16 min_rate)
 {
 	u32 j;
 	u8 nextindex;
@@ -1066,8 +1066,8 @@ static void ath_rc_ratefind(struct ath_softc *sc,
 	rate_table =
 		(struct ath_rate_table *)asc->hw_rate_table[sc->sc_curmode];
 	rix = ath_rc_ratefind_ht(sc, ath_rc_priv, rate_table,
-				(rcflag & ATH_RC_PROBE_ALLOWED) ? 1 : 0,
-				is_probe, is_retry);
+				 (rcflag & ATH_RC_PROBE_ALLOWED) ? 1 : 0,
+				 is_probe, is_retry);
 	nrix = rix;
 
 	if ((rcflag & ATH_RC_PROBE_ALLOWED) && (*is_probe)) {
@@ -1099,13 +1099,13 @@ static void ath_rc_ratefind(struct ath_softc *sc,
 		try_num = ((i + 1) == num_rates) ?
 			num_tries - (try_per_rate * i) : try_per_rate ;
 		min_rate = (((i + 1) == num_rates) &&
-			(rcflag & ATH_RC_MINRATE_LASTRATE)) ? 1 : 0;
+			    (rcflag & ATH_RC_MINRATE_LASTRATE)) ? 1 : 0;
 
 		nrix = ath_rc_rate_getidx(sc, ath_rc_priv,
-			rate_table, nrix, 1, min_rate);
+					  rate_table, nrix, 1, min_rate);
 		/* All other rates in the series have RTS enabled */
 		ath_rc_rate_set_series(rate_table,
-			&series[i], try_num, nrix, TRUE);
+				       &series[i], try_num, nrix, TRUE);
 	}
 
 	/*
@@ -1124,13 +1124,13 @@ static void ath_rc_ratefind(struct ath_softc *sc,
 	 * above conditions.
 	 */
 	if ((sc->sc_curmode == ATH9K_MODE_11NG_HT20) ||
-			(sc->sc_curmode == ATH9K_MODE_11NG_HT40PLUS) ||
-			(sc->sc_curmode == ATH9K_MODE_11NG_HT40MINUS)) {
+	    (sc->sc_curmode == ATH9K_MODE_11NG_HT40PLUS) ||
+	    (sc->sc_curmode == ATH9K_MODE_11NG_HT40MINUS)) {
 		u8  dot11rate = rate_table->info[rix].dot11rate;
 		u8 phy = rate_table->info[rix].phy;
 		if (i == 4 &&
 		    ((dot11rate == 2 && phy == WLAN_RC_PHY_HT_40_SS) ||
-		    (dot11rate == 3 && phy == WLAN_RC_PHY_HT_20_SS))) {
+		     (dot11rate == 3 && phy == WLAN_RC_PHY_HT_20_SS))) {
 			series[3].rix = series[2].rix;
 			series[3].flags = series[2].flags;
 			series[3].max_4ms_framelen = series[2].max_4ms_framelen;
@@ -1152,7 +1152,8 @@ void ath_rate_findrate(struct ath_softc *sc,
 {
 	struct ath_vap *avp = ath_rc_priv->avp;
 
-	DPRINTF(sc, ATH_DBG_RATE, "%s", __func__);
+	DPRINTF(sc, ATH_DBG_RATE, "%s\n", __func__);
+
 	if (!num_rates || !num_tries)
 		return;
 
@@ -1174,9 +1175,8 @@ void ath_rate_findrate(struct ath_softc *sc,
 			unsigned int    mcs;
 			u8 series_rix = 0;
 
-			series[idx].tries =
-				IEEE80211_RATE_IDX_ENTRY(
-					avp->av_config.av_fixed_retryset, idx);
+			series[idx].tries = IEEE80211_RATE_IDX_ENTRY(
+				avp->av_config.av_fixed_retryset, idx);
 
 			mcs = IEEE80211_RATE_IDX_ENTRY(
 				avp->av_config.av_fixed_rateset, idx);
@@ -1228,7 +1228,7 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 	u32 now_msec = jiffies_to_msecs(jiffies);
 	int state_change = FALSE, rate, count;
 	u8 last_per;
-	struct ath_rate_softc  *asc = (struct ath_rate_softc *)sc->sc_rc;
+	struct ath_rate_softc *asc = (struct ath_rate_softc *)sc->sc_rc;
 	struct ath_rate_table *rate_table =
 		(struct ath_rate_table *)asc->hw_rate_table[sc->sc_curmode];
 
@@ -1272,14 +1272,14 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 		} else {
 			/* xretries == 2 */
 			count = sizeof(nretry_to_per_lookup) /
-					sizeof(nretry_to_per_lookup[0]);
+				sizeof(nretry_to_per_lookup[0]);
 			if (retries >= count)
 				retries = count - 1;
 			/* new_PER = 7/8*old_PER + 1/8*(currentPER) */
 			rate_ctrl->state[tx_rate].per =
 				(u8)(rate_ctrl->state[tx_rate].per -
-				(rate_ctrl->state[tx_rate].per >> 3) +
-				((100) >> 3));
+				     (rate_ctrl->state[tx_rate].per >> 3) +
+				     ((100) >> 3));
 		}
 
 		/* xretries == 1 or 2 */
@@ -1295,8 +1295,7 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 		if (retries >= count)
 			retries = count - 1;
 		if (info_priv->n_bad_frames) {
-			/* new_PER = 7/8*old_PER + 1/8*(currentPER)  */
-			/*
+			/* new_PER = 7/8*old_PER + 1/8*(currentPER)
 			 * Assuming that n_frames is not 0.  The current PER
 			 * from the retries is 100 * retries / (retries+1),
 			 * since the first retries attempts failed, and the
@@ -1386,7 +1385,7 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 			 * rssi_ack values.
 			 */
 			if (tx_rate == rate_ctrl->rate_max_phy &&
-					rate_ctrl->hw_maxretry_pktcnt < 255) {
+			    rate_ctrl->hw_maxretry_pktcnt < 255) {
 				rate_ctrl->hw_maxretry_pktcnt++;
 			}
 
@@ -1418,7 +1417,7 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 					/* Now reduce the current
 					 * rssi threshold. */
 					if ((rssi_ackAvg < rssi_thres + 2) &&
-						(rssi_thres > rssi_ack_vmin)) {
+					    (rssi_thres > rssi_ack_vmin)) {
 						rate_ctrl->state[tx_rate].
 							rssi_thres--;
 					}
@@ -1436,10 +1435,10 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 	 * a while (except if we are probing).
 	 */
 	if (rate_ctrl->state[tx_rate].per >= 55 && tx_rate > 0 &&
-			rate_table->info[tx_rate].ratekbps <=
-			rate_table->info[rate_ctrl->rate_max_phy].ratekbps) {
+	    rate_table->info[tx_rate].ratekbps <=
+	    rate_table->info[rate_ctrl->rate_max_phy].ratekbps) {
 		ath_rc_get_nextlowervalid_txrate(rate_table, rate_ctrl,
-				(u8) tx_rate, &rate_ctrl->rate_max_phy);
+				 (u8) tx_rate, &rate_ctrl->rate_max_phy);
 
 		/* Don't probe for a little while. */
 		rate_ctrl->probe_time = now_msec;
@@ -1460,43 +1459,43 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 				break;
 
 			if (rate_ctrl->state[rate].rssi_thres +
-				rate_table->info[rate].rssi_ack_deltamin >
-					rate_ctrl->state[rate+1].rssi_thres) {
+			    rate_table->info[rate].rssi_ack_deltamin >
+			    rate_ctrl->state[rate+1].rssi_thres) {
 				rate_ctrl->state[rate+1].rssi_thres =
 					rate_ctrl->state[rate].
-						rssi_thres +
+					rssi_thres +
 					rate_table->info[rate].
-						rssi_ack_deltamin;
+					rssi_ack_deltamin;
 			}
 		}
 
 		/* Make sure the rates below this have lower rssi thresholds. */
 		for (rate = tx_rate - 1; rate >= 0; rate--) {
 			if (rate_table->info[rate].phy !=
-				rate_table->info[tx_rate].phy)
+			    rate_table->info[tx_rate].phy)
 				break;
 
 			if (rate_ctrl->state[rate].rssi_thres +
-				rate_table->info[rate].rssi_ack_deltamin >
-					rate_ctrl->state[rate+1].rssi_thres) {
+			    rate_table->info[rate].rssi_ack_deltamin >
+			    rate_ctrl->state[rate+1].rssi_thres) {
 				if (rate_ctrl->state[rate+1].rssi_thres <
-					rate_table->info[rate].
-					rssi_ack_deltamin)
+				    rate_table->info[rate].
+				    rssi_ack_deltamin)
 					rate_ctrl->state[rate].rssi_thres = 0;
 				else {
 					rate_ctrl->state[rate].rssi_thres =
 						rate_ctrl->state[rate+1].
-							rssi_thres -
-							rate_table->info[rate].
-							rssi_ack_deltamin;
+						rssi_thres -
+						rate_table->info[rate].
+						rssi_ack_deltamin;
 				}
 
 				if (rate_ctrl->state[rate].rssi_thres <
-					rate_table->info[rate].
-						rssi_ack_validmin) {
+				    rate_table->info[rate].
+				    rssi_ack_validmin) {
 					rate_ctrl->state[rate].rssi_thres =
 						rate_table->info[rate].
-							rssi_ack_validmin;
+						rssi_ack_validmin;
 				}
 			}
 		}
@@ -1507,11 +1506,11 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 	if (rate_ctrl->state[tx_rate].per < last_per) {
 		for (rate = tx_rate - 1; rate >= 0; rate--) {
 			if (rate_table->info[rate].phy !=
-				rate_table->info[tx_rate].phy)
+			    rate_table->info[tx_rate].phy)
 				break;
 
 			if (rate_ctrl->state[rate].per >
-					rate_ctrl->state[rate+1].per) {
+			    rate_ctrl->state[rate+1].per) {
 				rate_ctrl->state[rate].per =
 					rate_ctrl->state[rate+1].per;
 			}
@@ -1528,11 +1527,11 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 	/* Every so often, we reduce the thresholds and
 	 * PER (different for CCK and OFDM). */
 	if (now_msec - rate_ctrl->rssi_down_time >=
-		rate_table->rssi_reduce_interval) {
+	    rate_table->rssi_reduce_interval) {
 
 		for (rate = 0; rate < rate_ctrl->rate_table_size; rate++) {
 			if (rate_ctrl->state[rate].rssi_thres >
-				rate_table->info[rate].rssi_ack_validmin)
+			    rate_table->info[rate].rssi_ack_validmin)
 				rate_ctrl->state[rate].rssi_thres -= 1;
 		}
 		rate_ctrl->rssi_down_time = now_msec;
@@ -1541,7 +1540,7 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 	/* Every so often, we reduce the thresholds
 	 * and PER (different for CCK and OFDM). */
 	if (now_msec - rate_ctrl->per_down_time >=
-		rate_table->rssi_reduce_interval) {
+	    rate_table->rssi_reduce_interval) {
 		for (rate = 0; rate < rate_ctrl->rate_table_size; rate++) {
 			rate_ctrl->state[rate].per =
 				7 * rate_ctrl->state[rate].per / 8;
@@ -1560,7 +1559,7 @@ static void ath_rc_update(struct ath_softc *sc,
 			  struct ath_tx_info_priv *info_priv, int final_ts_idx,
 			  int xretries, int long_retry)
 {
-	struct ath_rate_softc  *asc = (struct ath_rate_softc *)sc->sc_rc;
+	struct ath_rate_softc *asc = (struct ath_rate_softc *)sc->sc_rc;
 	struct ath_rate_table *rate_table;
 	struct ath_tx_ratectrl *rate_ctrl;
 	struct ath_rc_series rcs[4];
@@ -1637,7 +1636,6 @@ static void ath_rc_update(struct ath_softc *sc,
 		xretries, long_retry);
 }
 
-
 /*
  * Process a tx descriptor for a completed transmit (success or failure).
  */
@@ -1651,13 +1649,13 @@ static void ath_rate_tx_complete(struct ath_softc *sc,
 	struct ath_vap *avp;
 
 	avp = rc_priv->avp;
-	if ((avp->av_config.av_fixed_rateset != IEEE80211_FIXED_RATE_NONE)
-			|| info_priv->tx.ts_status & ATH9K_TXERR_FILT)
+	if ((avp->av_config.av_fixed_rateset != IEEE80211_FIXED_RATE_NONE) ||
+	    (info_priv->tx.ts_status & ATH9K_TXERR_FILT))
 		return;
 
 	if (info_priv->tx.ts_rssi > 0) {
 		ATH_RSSI_LPF(an->an_chainmask_sel.tx_avgrssi,
-				info_priv->tx.ts_rssi);
+			     info_priv->tx.ts_rssi);
 	}
 
 	/*
@@ -1682,7 +1680,6 @@ static void ath_rate_tx_complete(struct ath_softc *sc,
 		      info_priv->tx.ts_longretry);
 }
 
-
 /*
  *  Update the SIB's rate control information
  *
@@ -1701,8 +1698,8 @@ static void ath_rc_sib_update(struct ath_softc *sc,
 	struct ath_rate_softc *asc = (struct ath_rate_softc *)sc->sc_rc;
 	struct ath_rateset *rateset = negotiated_rates;
 	u8 *ht_mcs = (u8 *)negotiated_htrates;
-	struct ath_tx_ratectrl *rate_ctrl  = (struct ath_tx_ratectrl *)
-		(ath_rc_priv);
+	struct ath_tx_ratectrl *rate_ctrl =
+		(struct ath_tx_ratectrl *)ath_rc_priv;
 	u8 i, j, k, hi = 0, hthi = 0;
 
 	rate_table = (struct ath_rate_table *)
@@ -1824,7 +1821,8 @@ static void ath_setup_rates(struct ieee80211_local *local, struct sta_info *sta)
 	struct ath_rate_node *rc_priv = sta->rate_ctrl_priv;
 	int i, j = 0;
 
-	DPRINTF(sc, ATH_DBG_RATE, "%s", __func__);
+	DPRINTF(sc, ATH_DBG_RATE, "%s\n", __func__);
+
 	sband =  local->hw.wiphy->bands[local->hw.conf.channel->band];
 	for (i = 0; i < sband->n_bitrates; i++) {
 		if (sta->supp_rates[local->hw.conf.channel->band] & BIT(i)) {
@@ -1962,7 +1960,7 @@ static void ath_get_rate(void *priv, struct net_device *dev,
 	tx_info_priv->min_rate = (sband->bitrates[lowest_idx].bitrate * 2) / 10;
 	/* lowest rate for management and multicast/broadcast frames */
 	if (!ieee80211_is_data(fc) ||
-			is_multicast_ether_addr(hdr->addr1) || !sta) {
+	    is_multicast_ether_addr(hdr->addr1) || !sta) {
 		sel->rate_idx = lowest_idx;
 		return;
 	}
@@ -1978,7 +1976,7 @@ static void ath_get_rate(void *priv, struct net_device *dev,
 			  false);
 	if (is_probe)
 		sel->probe_idx = ((struct ath_tx_ratectrl *)
-			sta->rate_ctrl_priv)->probe_rate;
+				  sta->rate_ctrl_priv)->probe_rate;
 
 	/* Ratecontrol sometimes returns invalid rate index */
 	if (tx_info_priv->rcs[0].rix != 0xff)
@@ -2035,6 +2033,7 @@ static void ath_rate_init(void *priv, void *priv_sta,
 	struct ieee80211_hw *hw = local_to_hw(local);
 	struct ieee80211_conf *conf = &local->hw.conf;
 	struct ath_softc *sc = hw->priv;
+	struct ath_rate_node *ath_rc_priv = priv_sta;
 	int i, j = 0;
 
 	DPRINTF(sc, ATH_DBG_RATE, "%s\n", __func__);
@@ -2046,12 +2045,11 @@ static void ath_rate_init(void *priv, void *priv_sta,
 	if (conf->flags & IEEE80211_CONF_SUPPORT_HT_MODE) {
 		for (i = 0; i < MCS_SET_SIZE; i++) {
 			if (conf->ht_conf.supp_mcs_set[i/8] & (1<<(i%8)))
-				((struct ath_rate_node *)
-				priv_sta)->neg_ht_rates.rs_rates[j++] = i;
+				ath_rc_priv->neg_ht_rates.rs_rates[j++] = i;
 			if (j == ATH_RATE_MAX)
 				break;
 		}
-		((struct ath_rate_node *)priv_sta)->neg_ht_rates.rs_nrates = j;
+		ath_rc_priv->neg_ht_rates.rs_nrates = j;
 	}
 	ath_rc_node_update(hw, priv_sta);
 }
@@ -2066,7 +2064,7 @@ static void *ath_rate_alloc(struct ieee80211_local *local)
 	struct ieee80211_hw *hw = local_to_hw(local);
 	struct ath_softc *sc = hw->priv;
 
-	DPRINTF(sc, ATH_DBG_RATE, "%s", __func__);
+	DPRINTF(sc, ATH_DBG_RATE, "%s\n", __func__);
 	return local->hw.priv;
 }
 
@@ -2081,14 +2079,17 @@ static void *ath_rate_alloc_sta(void *priv, gfp_t gfp)
 	struct ath_vap *avp = sc->sc_vaps[0];
 	struct ath_rate_node *rate_priv;
 
-	DPRINTF(sc, ATH_DBG_RATE, "%s", __func__);
+	DPRINTF(sc, ATH_DBG_RATE, "%s\n", __func__);
+
 	rate_priv = ath_rate_node_alloc(avp, sc->sc_rc, gfp);
 	if (!rate_priv) {
-		DPRINTF(sc, ATH_DBG_FATAL, "%s:Unable to allocate"
-				"private rate control structure", __func__);
+		DPRINTF(sc, ATH_DBG_FATAL,
+			"%s: Unable to allocate private rc structure\n",
+			__func__);
 		return NULL;
 	}
 	ath_rc_sib_init(rate_priv);
+
 	return rate_priv;
 }
 
-- 
1.5.6.5

