Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:50975 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751525AbZA3JCw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2009 04:02:52 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 30 Jan 2009 01:02:52 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18818.49507.719006.748245@gargle.gargle.HOWL> (sfid-20090130_100259_278787_23CCF1CC)
Date: Fri, 30 Jan 2009 14:29:15 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 1/3] ath9k: Cleanup get_rate() interface
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The interface to calculate the TX rate for a data frame
was convoluted with lots of redundant arguments being
passed around. Remove all of that and make it simple.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/rc.c |   67 ++++++++++++++++----------------------
 1 files changed, 28 insertions(+), 39 deletions(-)

diff --git a/drivers/net/wireless/ath9k/rc.c b/drivers/net/wireless/ath9k/rc.c
index eb557ad..dc0438c 100644
--- a/drivers/net/wireless/ath9k/rc.c
+++ b/drivers/net/wireless/ath9k/rc.c
@@ -631,8 +631,7 @@ static u8 ath_rc_setvalid_htrates(struct ath_rate_priv *ath_rc_priv,
 static u8 ath_rc_ratefind_ht(struct ath_softc *sc,
 			     struct ath_rate_priv *ath_rc_priv,
 			     struct ath_rate_table *rate_table,
-			     int probe_allowed, int *is_probing,
-			     int is_retry)
+			     int *is_probing)
 {
 	u32 dt, best_thruput, this_thruput, now_msec;
 	u8 rate, next_rate, best_rate, maxindex, minindex;
@@ -714,13 +713,6 @@ static u8 ath_rc_ratefind_ht(struct ath_softc *sc,
 	}
 
 	rate = best_rate;
-
-	/* if we are retrying for more than half the number
-	 * of max retries, use the min rate for the next retry
-	 */
-	if (is_retry)
-		rate = ath_rc_priv->valid_rate_index[minindex];
-
 	ath_rc_priv->rssi_last_lookup = rssi_last;
 
 	/*
@@ -728,13 +720,12 @@ static u8 ath_rc_ratefind_ht(struct ath_softc *sc,
 	 * non-monoticity of 11g's rate table
 	 */
 
-	if (rate >= ath_rc_priv->rate_max_phy && probe_allowed) {
+	if (rate >= ath_rc_priv->rate_max_phy) {
 		rate = ath_rc_priv->rate_max_phy;
 
 		/* Probe the next allowed phy state */
-		/* FIXME:XXXX Check to make sure ratMax is checked properly */
 		if (ath_rc_get_nextvalid_txrate(rate_table,
-						ath_rc_priv, rate, &next_rate) &&
+					ath_rc_priv, rate, &next_rate) &&
 		    (now_msec - ath_rc_priv->probe_time >
 		     rate_table->probe_interval) &&
 		    (ath_rc_priv->hw_maxretry_pktcnt >= 1)) {
@@ -804,54 +795,54 @@ static u8 ath_rc_rate_getidx(struct ath_softc *sc,
 
 static void ath_rc_ratefind(struct ath_softc *sc,
 			    struct ath_rate_priv *ath_rc_priv,
-			    int num_tries, int num_rates,
-			    struct ieee80211_tx_info *tx_info, int *is_probe,
-			    int is_retry)
+			    struct ieee80211_tx_rate_control *txrc)
 {
-	u8 try_per_rate = 0, i = 0, rix, nrix;
 	struct ath_rate_table *rate_table;
+	struct sk_buff *skb = txrc->skb;
+	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_tx_rate *rates = tx_info->control.rates;
+	u8 try_per_rate = 0, i = 0, rix, nrix;
+	int is_probe = 0;
 
 	rate_table = sc->cur_rate_table;
-	rix = ath_rc_ratefind_ht(sc, ath_rc_priv, rate_table, 1,
-				 is_probe, is_retry);
+	rix = ath_rc_ratefind_ht(sc, ath_rc_priv, rate_table, &is_probe);
 	nrix = rix;
 
-	if (*is_probe) {
+	if (is_probe) {
 		/* set one try for probe rates. For the
 		 * probes don't enable rts */
-		ath_rc_rate_set_series(rate_table,
-			&rates[i++], 1, nrix, 0);
+		ath_rc_rate_set_series(rate_table, &rates[i++],
+				       1, nrix, 0);
 
-		try_per_rate = (num_tries/num_rates);
+		try_per_rate = (ATH_11N_TXMAXTRY/4);
 		/* Get the next tried/allowed rate. No RTS for the next series
 		 * after the probe rate
 		 */
-		nrix = ath_rc_rate_getidx(sc,
-			ath_rc_priv, rate_table, nrix, 1, 0);
-		ath_rc_rate_set_series(rate_table,
-			&rates[i++], try_per_rate, nrix, 0);
+		nrix = ath_rc_rate_getidx(sc, ath_rc_priv,
+					  rate_table, nrix, 1, 0);
+		ath_rc_rate_set_series(rate_table, &rates[i++],
+				       try_per_rate, nrix, 0);
 	} else {
-		try_per_rate = (num_tries/num_rates);
+		try_per_rate = (ATH_11N_TXMAXTRY/4);
 		/* Set the choosen rate. No RTS for first series entry. */
-		ath_rc_rate_set_series(rate_table,
-			&rates[i++], try_per_rate, nrix, 0);
+		ath_rc_rate_set_series(rate_table, &rates[i++],
+				       try_per_rate, nrix, 0);
 	}
 
 	/* Fill in the other rates for multirate retry */
-	for ( ; i < num_rates; i++) {
+	for ( ; i < 4; i++) {
 		u8 try_num;
 		u8 min_rate;
 
-		try_num = ((i + 1) == num_rates) ?
-			num_tries - (try_per_rate * i) : try_per_rate ;
-		min_rate = (((i + 1) == num_rates) && 0);
+		try_num = ((i + 1) == 4) ?
+			ATH_11N_TXMAXTRY - (try_per_rate * i) : try_per_rate ;
+		min_rate = (((i + 1) == 4) && 0);
 
 		nrix = ath_rc_rate_getidx(sc, ath_rc_priv,
 					  rate_table, nrix, 1, min_rate);
 		/* All other rates in the series have RTS enabled */
-		ath_rc_rate_set_series(rate_table,
-				       &rates[i], try_num, nrix, 1);
+		ath_rc_rate_set_series(rate_table, &rates[i],
+				       try_num, nrix, 1);
 	}
 
 	/*
@@ -1489,11 +1480,10 @@ static void ath_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
 	struct ieee80211_supported_band *sband = txrc->sband;
 	struct sk_buff *skb = txrc->skb;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 	struct ath_softc *sc = priv;
 	struct ieee80211_hw *hw = sc->hw;
 	struct ath_rate_priv *ath_rc_priv = priv_sta;
-	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
-	int is_probe = 0;
 	__le16 fc = hdr->frame_control;
 
 	/* lowest rate for management and multicast/broadcast frames */
@@ -1506,8 +1496,7 @@ static void ath_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
 	}
 
 	/* Find tx rate for unicast frames */
-	ath_rc_ratefind(sc, ath_rc_priv, ATH_11N_TXMAXTRY, 4,
-			tx_info, &is_probe, false);
+	ath_rc_ratefind(sc, ath_rc_priv, txrc);
 
 	/* Check if aggregation has to be enabled for this tid */
 	if (conf_is_ht(&hw->conf)) {
-- 
1.6.1

