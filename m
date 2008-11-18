Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:27328 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751917AbYKRDi3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Nov 2008 22:38:29 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 17 Nov 2008 19:38:28 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18722.14343.193181.251560@gargle.gargle.HOWL> (sfid-20081118_043831_485340_6E0752AB)
Date: Tue, 18 Nov 2008 09:05:35 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 06/18] ath9k: Nuke fixed rate handling in driver
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/core.c |    4 --
 drivers/net/wireless/ath9k/core.h |    8 ---
 drivers/net/wireless/ath9k/main.c |    8 ---
 drivers/net/wireless/ath9k/rc.c   |   92 +-----------------------------------
 drivers/net/wireless/ath9k/rc.h   |   29 +-----------
 5 files changed, 4 insertions(+), 137 deletions(-)

diff --git a/drivers/net/wireless/ath9k/core.c b/drivers/net/wireless/ath9k/core.c
index bab9eaa..ea332a2 100644
--- a/drivers/net/wireless/ath9k/core.c
+++ b/drivers/net/wireless/ath9k/core.c
@@ -89,13 +89,9 @@ static void ath_setcurmode(struct ath_softc *sc, enum wireless_mode mode)
 	const struct ath9k_rate_table *rt;
 	int i;
 
-	memset(sc->sc_rixmap, 0xff, sizeof(sc->sc_rixmap));
 	rt = ath9k_hw_getratetable(sc->sc_ah, mode);
 	BUG_ON(!rt);
 
-	for (i = 0; i < rt->rateCount; i++)
-		sc->sc_rixmap[rt->info[i].rateCode] = (u8) i;
-
 	memset(sc->sc_hwmap, 0, sizeof(sc->sc_hwmap));
 	for (i = 0; i < 256; i++) {
 		u8 ix = rt->rateCodeToIndex[i];
diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index 69e8d3e..fe9dc99 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -641,19 +641,12 @@ void ath_get_beaconconfig(struct ath_softc *sc,
 #define ATH_SET_VAP_BSSID_MASK(bssid_mask) \
 	((bssid_mask)[0] &= ~(((ATH_BCBUF-1)<<2)|0x02))
 
-/* VAP configuration (from protocol layer) */
-struct ath_vap_config {
-	u32 av_fixed_rateset;
-	u32 av_fixed_retryset;
-};
-
 /* driver-specific vap state */
 struct ath_vap {
 	int av_bslot;			/* beacon slot index */
 	enum ath9k_opmode av_opmode;	/* VAP operational mode */
 	struct ath_buf *av_bcbuf;	/* beacon buffer */
 	struct ath_tx_control av_btxctl;  /* txctl information for beacon */
-	struct ath_vap_config av_config;/* vap configuration parameters*/
 	struct ath_rate_node *rc_node;
 };
 
@@ -915,7 +908,6 @@ struct ath_softc {
 	/* Rate */
 	struct ieee80211_rate rates[IEEE80211_NUM_BANDS][ATH_RATE_MAX];
 	const struct ath9k_rate_table *sc_currates;
-	u8 sc_rixmap[256];	/* IEEE to h/w rate table ix */
 	u8 sc_protrix;		/* protection rate index */
 	struct {
 		u32 rateKbps;	/* transfer rate in kbs */
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index c4f4944..fce6982 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -380,7 +380,6 @@ static void ath9k_bss_assoc_info(struct ath_softc *sc,
 				"%s: Unable to set channel\n",
 				__func__);
 
-		ath_rate_newstate(sc, avp);
 		/* Update ratectrl about the new state */
 		ath_rc_node_update(hw, avp->rc_node);
 
@@ -1100,10 +1099,6 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 	/* Set the device opmode */
 	sc->sc_ah->ah_opmode = ic_opmode;
 
-	/* default VAP configuration */
-	avp->av_config.av_fixed_rateset = IEEE80211_FIXED_RATE_NONE;
-	avp->av_config.av_fixed_retryset = 0x03030303;
-
 	if (conf->type == NL80211_IFTYPE_AP) {
 		/* TODO: is this a suitable place to start ANI for AP mode? */
 		/* Start ANI */
@@ -1207,9 +1202,6 @@ static int ath9k_config_interface(struct ieee80211_hw *hw,
 		switch (vif->type) {
 		case NL80211_IFTYPE_STATION:
 		case NL80211_IFTYPE_ADHOC:
-			/* Update ratectrl about the new state */
-			ath_rate_newstate(sc, avp);
-
 			/* Set BSSID */
 			memcpy(sc->sc_curbssid, conf->bssid, ETH_ALEN);
 			sc->sc_curaid = 0;
diff --git a/drivers/net/wireless/ath9k/rc.c b/drivers/net/wireless/ath9k/rc.c
index aafd10d..8a45b25 100644
--- a/drivers/net/wireless/ath9k/rc.c
+++ b/drivers/net/wireless/ath9k/rc.c
@@ -709,27 +709,6 @@ u8 ath_rate_findrateix(struct ath_softc *sc,
 	return 0;
 }
 
-/*
- * Update rate-control state on a device state change.  When
- * operating as a station this includes associate/reassociate
- * with an AP.  Otherwise this gets called, for example, when
- * the we transition to run state when operating as an AP.
- */
-void ath_rate_newstate(struct ath_softc *sc, struct ath_vap *avp)
-{
-	struct ath_rate_softc *asc = sc->sc_rc;
-
-	if (avp->av_config.av_fixed_rateset != IEEE80211_FIXED_RATE_NONE) {
-		asc->fixedrix =
-			sc->sc_rixmap[avp->av_config.av_fixed_rateset & 0xff];
-		/* NB: check the fixed rate exists */
-		if (asc->fixedrix == 0xff)
-			asc->fixedrix = IEEE80211_FIXED_RATE_NONE;
-	} else {
-		asc->fixedrix = IEEE80211_FIXED_RATE_NONE;
-	}
-}
-
 static u8 ath_rc_ratefind_ht(struct ath_softc *sc,
 			     struct ath_rate_node *ath_rc_priv,
 			     const struct ath_rate_table *rate_table,
@@ -1009,73 +988,11 @@ static void ath_rate_findrate(struct ath_softc *sc,
 			      int *is_probe,
 			      int is_retry)
 {
-	struct ath_vap *avp = ath_rc_priv->avp;
-
-	DPRINTF(sc, ATH_DBG_RATE, "%s\n", __func__);
-
 	if (!num_rates || !num_tries)
 		return;
 
-	if (avp->av_config.av_fixed_rateset == IEEE80211_FIXED_RATE_NONE) {
-		ath_rc_ratefind(sc, ath_rc_priv, num_tries, num_rates,
-				rcflag, series, is_probe, is_retry);
-	} else {
-		/* Fixed rate */
-		int idx;
-		u8 flags;
-		u32 rix;
-		struct ath_rate_softc *asc = ath_rc_priv->asc;
-		struct ath_rate_table *rate_table;
-
-		rate_table = (struct ath_rate_table *)
-			asc->hw_rate_table[sc->sc_curmode];
-
-		for (idx = 0; idx < 4; idx++) {
-			unsigned int    mcs;
-			u8 series_rix = 0;
-
-			series[idx].tries = IEEE80211_RATE_IDX_ENTRY(
-				avp->av_config.av_fixed_retryset, idx);
-
-			mcs = IEEE80211_RATE_IDX_ENTRY(
-				avp->av_config.av_fixed_rateset, idx);
-
-			if (idx == 3 && (mcs & 0xf0) == 0x70)
-				mcs = (mcs & ~0xf0)|0x80;
-
-			if (!(mcs & 0x80))
-				flags = 0;
-			else
-				flags = ((ath_rc_priv->ht_cap &
-						WLAN_RC_DS_FLAG) ?
-						ATH_RC_DS_FLAG : 0) |
-					((ath_rc_priv->ht_cap &
-						WLAN_RC_40_FLAG) ?
-						ATH_RC_CW40_FLAG : 0) |
-					((ath_rc_priv->ht_cap &
-						WLAN_RC_SGI_FLAG) ?
-					((ath_rc_priv->ht_cap &
-						WLAN_RC_40_FLAG) ?
-						ATH_RC_SGI_FLAG : 0) : 0);
-
-			series[idx].rix = sc->sc_rixmap[mcs];
-			series_rix  = series[idx].rix;
-
-			/* XXX: Give me some cleanup love */
-			if ((flags & ATH_RC_CW40_FLAG) &&
-				(flags & ATH_RC_SGI_FLAG))
-				rix = rate_table->info[series_rix].ht_index;
-			else if (flags & ATH_RC_SGI_FLAG)
-				rix = rate_table->info[series_rix].sgi_index;
-			else if (flags & ATH_RC_CW40_FLAG)
-				rix = rate_table->info[series_rix].cw40index;
-			else
-				rix = rate_table->info[series_rix].base_index;
-			series[idx].max_4ms_framelen =
-				rate_table->info[rix].max_4ms_framelen;
-			series[idx].flags = flags;
-		}
-	}
+	ath_rc_ratefind(sc, ath_rc_priv, num_tries, num_rates,
+			rcflag, series, is_probe, is_retry);
 }
 
 static void ath_rc_update_ht(struct ath_softc *sc,
@@ -1498,11 +1415,8 @@ static void ath_rate_tx_complete(struct ath_softc *sc,
 {
 	int final_ts_idx = info_priv->tx.ts_rateindex;
 	int tx_status = 0, is_underrun = 0;
-	struct ath_vap *avp;
 
-	avp = rc_priv->avp;
-	if ((avp->av_config.av_fixed_rateset != IEEE80211_FIXED_RATE_NONE) ||
-	    (info_priv->tx.ts_status & ATH9K_TXERR_FILT))
+	if (info_priv->tx.ts_status & ATH9K_TXERR_FILT)
 		return;
 
 	if (info_priv->tx.ts_rssi > 0) {
diff --git a/drivers/net/wireless/ath9k/rc.h b/drivers/net/wireless/ath9k/rc.h
index 2d8df83..8d0650a 100644
--- a/drivers/net/wireless/ath9k/rc.h
+++ b/drivers/net/wireless/ath9k/rc.h
@@ -60,16 +60,6 @@ struct ath_softc;
 
 #define ATH_RATE_MAX	30
 
-enum ieee80211_fixed_rate_mode {
-	IEEE80211_FIXED_RATE_NONE  = 0,
-	IEEE80211_FIXED_RATE_MCS   = 1  /* HT rates */
-};
-
-/*
- * Use the hal os glue code to get ms time
- */
-#define IEEE80211_RATE_IDX_ENTRY(val, idx) (((val&(0xff<<(idx*8)))>>(idx*8)))
-
 #define WLAN_PHY_HT_20_SS       WLAN_RC_PHY_HT_20_SS
 #define WLAN_PHY_HT_20_DS       WLAN_RC_PHY_HT_20_DS
 #define WLAN_PHY_HT_20_DS_HGI   WLAN_RC_PHY_HT_20_DS_HGI
@@ -287,27 +277,10 @@ struct ath_tx_info_priv {
 	u8 min_rate;
 };
 
-/*
- * Attach/detach a rate control module.
- */
 struct ath_rate_softc *ath_rate_attach(struct ath_softc *sch);
 void ath_rate_detach(struct ath_rate_softc *asc);
-
-/*
- * Update/reset rate control state for 802.11 state transitions.
- * Important mostly as the analog to ath_rate_newassoc when operating
- * in station mode.
- */
 void ath_rc_node_update(struct ieee80211_hw *hw, struct ath_rate_node *rc_priv);
-void ath_rate_newstate(struct ath_softc *sc, struct ath_vap *avp);
-
-/*
- * Return rate index for given Dot11 Rate.
- */
-u8 ath_rate_findrateix(struct ath_softc *sc,
-		       u8 dot11_rate);
-
-/* Routines to register/unregister rate control algorithm */
+u8 ath_rate_findrateix(struct ath_softc *sc, u8 dot11_rate);
 int ath_rate_control_register(void);
 void ath_rate_control_unregister(void);
 
-- 
1.6.0.3

