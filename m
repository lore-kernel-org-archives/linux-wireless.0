Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:27747 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752133AbYKRDkB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Nov 2008 22:40:01 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 17 Nov 2008 19:40:00 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18722.14434.625219.446986@gargle.gargle.HOWL> (sfid-20081118_044021_697964_1D5F8BDC)
Date: Tue, 18 Nov 2008 09:07:06 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 10/18] ath9k: Remove ath_rate_softc
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move the hw rate tables to ath_softc, and access them directly.
tx_triglevel_max is global, move it to ath_rate_node.
Now that ath_rate_softc is gone, rate control attach becomes simpler.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/core.c |    6 +--
 drivers/net/wireless/ath9k/core.h |    2 +-
 drivers/net/wireless/ath9k/main.c |    1 -
 drivers/net/wireless/ath9k/rc.c   |  110 ++++++++++++++-----------------------
 drivers/net/wireless/ath9k/rc.h   |   13 +----
 5 files changed, 45 insertions(+), 87 deletions(-)

diff --git a/drivers/net/wireless/ath9k/core.c b/drivers/net/wireless/ath9k/core.c
index ea332a2..6c872e7 100644
--- a/drivers/net/wireless/ath9k/core.c
+++ b/drivers/net/wireless/ath9k/core.c
@@ -1071,11 +1071,7 @@ int ath_init(u16 devid, struct ath_softc *sc)
 	sc->sc_ani.sc_noise_floor = ATH_DEFAULT_NOISE_FLOOR;
 	setup_timer(&sc->sc_ani.timer, ath_ani_calibrate, (unsigned long)sc);
 
-	sc->sc_rc = ath_rate_attach(sc);
-	if (sc->sc_rc == NULL) {
-		error = -EIO;
-		goto bad2;
-	}
+	ath_rate_attach(sc);
 
 	if (ath9k_hw_getcapability(ah, ATH9K_CAP_CIPHER,
 				   ATH9K_CIPHER_TKIP, NULL)) {
diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index 2ff33b8..cf2d941 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -784,7 +784,6 @@ struct ath_softc {
 	struct tasklet_struct bcon_tasklet;
 	struct ath_config sc_config;
 	struct ath_hal *sc_ah;
-	struct ath_rate_softc *sc_rc;
 	void __iomem *mem;
 
 	u8 sc_curbssid[ETH_ALEN];
@@ -859,6 +858,7 @@ struct ath_softc {
 
 	/* Rate */
 	struct ieee80211_rate rates[IEEE80211_NUM_BANDS][ATH_RATE_MAX];
+	struct ath_rate_table *hw_rate_table[ATH9K_MODE_MAX];
 	const struct ath9k_rate_table *sc_currates;
 	u8 sc_protrix;		/* protection rate index */
 	struct {
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index c4038c7..7415c63 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -738,7 +738,6 @@ static void ath_detach(struct ath_softc *sc)
 	ath_deinit_rfkill(sc);
 #endif
 	ath_rate_control_unregister();
-	ath_rate_detach(sc->sc_rc);
 
 	ath_rx_cleanup(sc);
 	ath_tx_cleanup(sc);
diff --git a/drivers/net/wireless/ath9k/rc.c b/drivers/net/wireless/ath9k/rc.c
index 0fa1b30..59c146c 100644
--- a/drivers/net/wireless/ath9k/rc.c
+++ b/drivers/net/wireless/ath9k/rc.c
@@ -23,8 +23,6 @@
 /* FIXME: remove this include! */
 #include "../net/mac80211/rate.h"
 
-static u32 tx_triglevel_max;
-
 static struct ath_rate_table ar5416_11na_ratetable = {
 	42,
 	{
@@ -436,7 +434,7 @@ static inline int8_t median(int8_t a, int8_t b, int8_t c)
 	}
 }
 
-static void ath_rc_sort_validrates(const struct ath_rate_table *rate_table,
+static void ath_rc_sort_validrates(struct ath_rate_table *rate_table,
 				   struct ath_rate_node *ath_rc_priv)
 {
 	u8 i, j, idx, idx_next;
@@ -481,7 +479,7 @@ static inline int ath_rc_isvalid_txmask(struct ath_rate_node *ath_rc_priv,
 
 /* Iterators for valid_txrate_mask */
 static inline int
-ath_rc_get_nextvalid_txrate(const struct ath_rate_table *rate_table,
+ath_rc_get_nextvalid_txrate(struct ath_rate_table *rate_table,
 			    struct ath_rate_node *ath_rc_priv,
 			    u8 cur_valid_txrate,
 			    u8 *next_idx)
@@ -519,7 +517,7 @@ static int ath_rc_valid_phyrate(u32 phy, u32 capflag, int ignore_cw)
 }
 
 static inline int
-ath_rc_get_nextlowervalid_txrate(const struct ath_rate_table *rate_table,
+ath_rc_get_nextlowervalid_txrate(struct ath_rate_table *rate_table,
 				 struct ath_rate_node *ath_rc_priv,
 				 u8 cur_valid_txrate, u8 *next_idx)
 {
@@ -539,7 +537,7 @@ ath_rc_get_nextlowervalid_txrate(const struct ath_rate_table *rate_table,
  */
 static u8
 ath_rc_sib_init_validrates(struct ath_rate_node *ath_rc_priv,
-			   const struct ath_rate_table *rate_table,
+			   struct ath_rate_table *rate_table,
 			   u32 capflag)
 {
 	u8 i, hi = 0;
@@ -572,7 +570,7 @@ ath_rc_sib_init_validrates(struct ath_rate_node *ath_rc_priv,
  */
 static u8
 ath_rc_sib_setvalid_rates(struct ath_rate_node *ath_rc_priv,
-			  const struct ath_rate_table *rate_table,
+			  struct ath_rate_table *rate_table,
 			  struct ath_rateset *rateset,
 			  u32 capflag)
 {
@@ -620,7 +618,7 @@ ath_rc_sib_setvalid_rates(struct ath_rate_node *ath_rc_priv,
 
 static u8
 ath_rc_sib_setvalid_htrates(struct ath_rate_node *ath_rc_priv,
-			    const struct ath_rate_table *rate_table,
+			    struct ath_rate_table *rate_table,
 			    u8 *mcs_set, u32 capflag)
 {
 	u8 i, j, hi = 0;
@@ -653,50 +651,13 @@ ath_rc_sib_setvalid_htrates(struct ath_rate_node *ath_rc_priv,
 	return hi;
 }
 
-struct ath_rate_softc *ath_rate_attach(struct ath_softc *sc)
-{
-	struct ath_rate_softc *asc;
-
-	asc = kzalloc(sizeof(struct ath_rate_softc), GFP_KERNEL);
-	if (asc == NULL)
-		return NULL;
-
-	asc->hw_rate_table[ATH9K_MODE_11B] = &ar5416_11b_ratetable;
-	asc->hw_rate_table[ATH9K_MODE_11A] = &ar5416_11a_ratetable;
-	asc->hw_rate_table[ATH9K_MODE_11G] = &ar5416_11g_ratetable;
-
-	asc->hw_rate_table[ATH9K_MODE_11NA_HT20] = &ar5416_11na_ratetable;
-	asc->hw_rate_table[ATH9K_MODE_11NG_HT20] = &ar5416_11ng_ratetable;
-
-	asc->hw_rate_table[ATH9K_MODE_11NA_HT40PLUS] =
-		&ar5416_11na_ratetable;
-	asc->hw_rate_table[ATH9K_MODE_11NA_HT40MINUS] =
-		&ar5416_11na_ratetable;
-	asc->hw_rate_table[ATH9K_MODE_11NG_HT40PLUS] =
-		&ar5416_11ng_ratetable;
-	asc->hw_rate_table[ATH9K_MODE_11NG_HT40MINUS] =
-		&ar5416_11ng_ratetable;
-
-	/* Save Maximum TX Trigger Level (used for 11n) */
-	tx_triglevel_max = sc->sc_ah->ah_caps.tx_triglevel_max;
-
-	return asc;
-}
-
-void ath_rate_detach(struct ath_rate_softc *asc)
-{
-	if (asc != NULL)
-		kfree(asc);
-}
-
 u8 ath_rate_findrateix(struct ath_softc *sc,
 		       u8 dot11rate)
 {
-	const struct ath_rate_table *ratetable;
-	struct ath_rate_softc *rsc = sc->sc_rc;
+	struct ath_rate_table *ratetable;
 	int i;
 
-	ratetable = rsc->hw_rate_table[sc->sc_curmode];
+	ratetable = sc->hw_rate_table[sc->sc_curmode];
 
 	if (WARN_ON(!ratetable))
 		return 0;
@@ -711,7 +672,7 @@ u8 ath_rate_findrateix(struct ath_softc *sc,
 
 static u8 ath_rc_ratefind_ht(struct ath_softc *sc,
 			     struct ath_rate_node *ath_rc_priv,
-			     const struct ath_rate_table *rate_table,
+			     struct ath_rate_table *rate_table,
 			     int probe_allowed, int *is_probing,
 			     int is_retry)
 {
@@ -843,7 +804,7 @@ static u8 ath_rc_ratefind_ht(struct ath_softc *sc,
 	return rate;
 }
 
-static void ath_rc_rate_set_series(const struct ath_rate_table *rate_table ,
+static void ath_rc_rate_set_series(struct ath_rate_table *rate_table ,
 				   struct ath_rc_series *series,
 				   u8 tries,
 				   u8 rix,
@@ -864,7 +825,7 @@ static void ath_rc_rate_set_series(const struct ath_rate_table *rate_table ,
 
 static u8 ath_rc_rate_getidx(struct ath_softc *sc,
 			     struct ath_rate_node *ath_rc_priv,
-			     const struct ath_rate_table *rate_table,
+			     struct ath_rate_table *rate_table,
 			     u8 rix, u16 stepdown,
 			     u16 min_rate)
 {
@@ -898,11 +859,9 @@ static void ath_rc_ratefind(struct ath_softc *sc,
 			    int is_retry)
 {
 	u8 try_per_rate = 0, i = 0, rix, nrix;
-	struct ath_rate_softc  *asc = (struct ath_rate_softc *)sc->sc_rc;
 	struct ath_rate_table *rate_table;
 
-	rate_table =
-		(struct ath_rate_table *)asc->hw_rate_table[sc->sc_curmode];
+	rate_table = sc->hw_rate_table[sc->sc_curmode];
 	rix = ath_rc_ratefind_ht(sc, ath_rc_priv, rate_table,
 				 (rcflag & ATH_RC_PROBE_ALLOWED) ? 1 : 0,
 				 is_probe, is_retry);
@@ -1003,10 +962,7 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 	u32 now_msec = jiffies_to_msecs(jiffies);
 	int state_change = FALSE, rate, count;
 	u8 last_per;
-	struct ath_rate_softc *asc = (struct ath_rate_softc *)sc->sc_rc;
-	struct ath_rate_table *rate_table =
-		(struct ath_rate_table *)asc->hw_rate_table[sc->sc_curmode];
-
+	struct ath_rate_table *rate_table = sc->hw_rate_table[sc->sc_curmode];
 	static u32 nretry_to_per_lookup[10] = {
 		100 * 0 / 1,
 		100 * 1 / 4,
@@ -1330,15 +1286,13 @@ static void ath_rc_update(struct ath_softc *sc,
 			  struct ath_tx_info_priv *info_priv, int final_ts_idx,
 			  int xretries, int long_retry)
 {
-	struct ath_rate_softc *asc = (struct ath_rate_softc *)sc->sc_rc;
 	struct ath_rate_table *rate_table;
 	struct ath_rc_series rcs[4];
 	u8 flags;
 	u32 series = 0, rix;
 
 	memcpy(rcs, info_priv->rcs, 4 * sizeof(rcs[0]));
-	rate_table = (struct ath_rate_table *)
-		asc->hw_rate_table[sc->sc_curmode];
+	rate_table = sc->hw_rate_table[sc->sc_curmode];
 	ASSERT(rcs[0].tries != 0);
 
 	/*
@@ -1432,7 +1386,7 @@ static void ath_rate_tx_complete(struct ath_softc *sc,
 	 */
 	if (info_priv->tx.ts_flags &
 		(ATH9K_TX_DATA_UNDERRUN | ATH9K_TX_DELIM_UNDERRUN) &&
-		((sc->sc_ah->ah_txTrigLevel) >= tx_triglevel_max)) {
+		((sc->sc_ah->ah_txTrigLevel) >= rc_priv->tx_triglevel_max)) {
 		tx_status = 1;
 		is_underrun = 1;
 	}
@@ -1452,21 +1406,17 @@ static void ath_rc_init(struct ath_softc *sc,
 			struct ieee80211_sta *sta)
 {
 	struct ath_rate_table *rate_table = NULL;
-	struct ath_rate_softc *asc = (struct ath_rate_softc *)sc->sc_rc;
 	struct ath_rateset *rateset = &ath_rc_priv->neg_rates;
 	u8 *ht_mcs = (u8 *)&ath_rc_priv->neg_ht_rates;
 	u8 i, j, k, hi = 0, hthi = 0;
 
-	rate_table = (struct ath_rate_table *)
-		asc->hw_rate_table[sc->sc_curmode];
+	rate_table = sc->hw_rate_table[sc->sc_curmode];
 
 	if (sta->ht_cap.ht_supported) {
 		if (sband->band == IEEE80211_BAND_2GHZ)
-			rate_table = (struct ath_rate_table *)
-				asc->hw_rate_table[ATH9K_MODE_11NG_HT20];
+			rate_table = sc->hw_rate_table[ATH9K_MODE_11NG_HT20];
 		else
-			rate_table = (struct ath_rate_table *)
-				asc->hw_rate_table[ATH9K_MODE_11NA_HT20];
+			rate_table = sc->hw_rate_table[ATH9K_MODE_11NA_HT20];
 
 		ath_rc_priv->ht_cap = (WLAN_RC_HT_FLAG | WLAN_RC_DS_FLAG);
 		if (sta->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40)
@@ -1691,8 +1641,8 @@ static void *ath_rate_alloc_sta(void *priv, struct ieee80211_sta *sta, gfp_t gfp
 		return NULL;
 	}
 
-	rate_priv->asc = sc->sc_rc;
 	rate_priv->rssi_down_time = jiffies_to_msecs(jiffies);
+	rate_priv->tx_triglevel_max = sc->sc_ah->ah_caps.tx_triglevel_max;
 
 	return rate_priv;
 }
@@ -1717,6 +1667,28 @@ static struct rate_control_ops ath_rate_ops = {
 	.free_sta = ath_rate_free_sta,
 };
 
+void ath_rate_attach(struct ath_softc *sc)
+{
+	sc->hw_rate_table[ATH9K_MODE_11B] =
+		&ar5416_11b_ratetable;
+	sc->hw_rate_table[ATH9K_MODE_11A] =
+		&ar5416_11a_ratetable;
+	sc->hw_rate_table[ATH9K_MODE_11G] =
+		&ar5416_11g_ratetable;
+	sc->hw_rate_table[ATH9K_MODE_11NA_HT20] =
+		&ar5416_11na_ratetable;
+	sc->hw_rate_table[ATH9K_MODE_11NG_HT20] =
+		&ar5416_11ng_ratetable;
+	sc->hw_rate_table[ATH9K_MODE_11NA_HT40PLUS] =
+		&ar5416_11na_ratetable;
+	sc->hw_rate_table[ATH9K_MODE_11NA_HT40MINUS] =
+		&ar5416_11na_ratetable;
+	sc->hw_rate_table[ATH9K_MODE_11NG_HT40PLUS] =
+		&ar5416_11ng_ratetable;
+	sc->hw_rate_table[ATH9K_MODE_11NG_HT40MINUS] =
+		&ar5416_11ng_ratetable;
+}
+
 int ath_rate_control_register(void)
 {
 	return ieee80211_rate_control_register(&ath_rate_ops);
diff --git a/drivers/net/wireless/ath9k/rc.h b/drivers/net/wireless/ath9k/rc.h
index 07319c6..30248de 100644
--- a/drivers/net/wireless/ath9k/rc.h
+++ b/drivers/net/wireless/ath9k/rc.h
@@ -199,15 +199,6 @@ struct ath_rateset {
 	u8 rs_rates[ATH_RATE_MAX];
 };
 
-/* per-device state */
-struct ath_rate_softc {
-	/* phy tables that contain rate control data */
-	const void *hw_rate_table[ATH9K_MODE_MAX];
-
-	/* -1 or index of fixed rate */
-	int fixedrix;
-};
-
 /**
  * struct ath_rate_node - Rate Control priv data
  * @state: RC state
@@ -261,6 +252,7 @@ struct ath_rate_node {
 	u32 per_down_time;
 	u32 probe_interval;
 	u32 prev_data_rix;
+	u32 tx_triglevel_max;
 	struct ath_tx_ratectrl_state state[MAX_TX_RATE_TBL];
 	struct ath_rateset neg_rates;
 	struct ath_rateset neg_ht_rates;
@@ -276,8 +268,7 @@ struct ath_tx_info_priv {
 	u8 min_rate;
 };
 
-struct ath_rate_softc *ath_rate_attach(struct ath_softc *sch);
-void ath_rate_detach(struct ath_rate_softc *asc);
+void ath_rate_attach(struct ath_softc *sc);
 u8 ath_rate_findrateix(struct ath_softc *sc, u8 dot11_rate);
 int ath_rate_control_register(void);
 void ath_rate_control_unregister(void);
-- 
1.6.0.3

