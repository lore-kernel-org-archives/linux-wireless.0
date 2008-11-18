Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:27606 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752897AbYKRDji (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Nov 2008 22:39:38 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 17 Nov 2008 19:39:38 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18722.14412.737205.251438@gargle.gargle.HOWL> (sfid-20081118_043954_503915_D8FCD5E5)
Date: Tue, 18 Nov 2008 09:06:44 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 09/18] ath9k: Remove rate control reference in VAP
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rate control init is now confined to itself, using the
HT capabilites of the STA from rate_init().

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/core.h |   47 ++++++++++-----------
 drivers/net/wireless/ath9k/main.c |    4 --
 drivers/net/wireless/ath9k/rc.c   |   82 ++++++++++++-------------------------
 drivers/net/wireless/ath9k/rc.h   |    2 -
 4 files changed, 50 insertions(+), 85 deletions(-)

diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index 5500ef4..2ff33b8 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -540,6 +540,29 @@ void ath_newassoc(struct ath_softc *sc,
 void ath_node_attach(struct ath_softc *sc, struct ieee80211_sta *sta);
 void ath_node_detach(struct ath_softc *sc, struct ieee80211_sta *sta);
 
+/********/
+/* VAPs */
+/********/
+
+/*
+ * Define the scheme that we select MAC address for multiple
+ * BSS on the same radio. The very first VAP will just use the MAC
+ * address from the EEPROM. For the next 3 VAPs, we set the
+ * U/L bit (bit 1) in MAC address, and use the next two bits as the
+ * index of the VAP.
+ */
+
+#define ATH_SET_VAP_BSSID_MASK(bssid_mask) \
+	((bssid_mask)[0] &= ~(((ATH_BCBUF-1)<<2)|0x02))
+
+/* driver-specific vap state */
+struct ath_vap {
+	int av_bslot;			/* beacon slot index */
+	enum ath9k_opmode av_opmode;	/* VAP operational mode */
+	struct ath_buf *av_bcbuf;	/* beacon buffer */
+	struct ath_tx_control av_btxctl;  /* txctl information for beacon */
+};
+
 /*******************/
 /* Beacon Handling */
 /*******************/
@@ -579,30 +602,6 @@ void ath_beacon_sync(struct ath_softc *sc, int if_id);
 void ath_get_beaconconfig(struct ath_softc *sc,
 			  int if_id,
 			  struct ath_beacon_config *conf);
-/********/
-/* VAPs */
-/********/
-
-/*
- * Define the scheme that we select MAC address for multiple
- * BSS on the same radio. The very first VAP will just use the MAC
- * address from the EEPROM. For the next 3 VAPs, we set the
- * U/L bit (bit 1) in MAC address, and use the next two bits as the
- * index of the VAP.
- */
-
-#define ATH_SET_VAP_BSSID_MASK(bssid_mask) \
-	((bssid_mask)[0] &= ~(((ATH_BCBUF-1)<<2)|0x02))
-
-/* driver-specific vap state */
-struct ath_vap {
-	int av_bslot;			/* beacon slot index */
-	enum ath9k_opmode av_opmode;	/* VAP operational mode */
-	struct ath_buf *av_bcbuf;	/* beacon buffer */
-	struct ath_tx_control av_btxctl;  /* txctl information for beacon */
-	struct ath_rate_node *rc_node;
-};
-
 /*********************/
 /* Antenna diversity */
 /*********************/
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 2f5d15b..c4038c7 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -317,10 +317,6 @@ static void ath9k_bss_assoc_info(struct ath_softc *sc,
 			DPRINTF(sc, ATH_DBG_FATAL,
 				"%s: Unable to set channel\n",
 				__func__);
-
-		/* Update ratectrl about the new state */
-		ath_rc_node_update(hw, avp->rc_node);
-
 		/* Start ANI */
 		mod_timer(&sc->sc_ani.timer,
 			jiffies + msecs_to_jiffies(ATH_ANI_POLLINTERVAL));
diff --git a/drivers/net/wireless/ath9k/rc.c b/drivers/net/wireless/ath9k/rc.c
index 8a45b25..0fa1b30 100644
--- a/drivers/net/wireless/ath9k/rc.c
+++ b/drivers/net/wireless/ath9k/rc.c
@@ -1446,35 +1446,39 @@ static void ath_rate_tx_complete(struct ath_softc *sc,
 		      info_priv->tx.ts_longretry);
 }
 
-/*
- *  Update the SIB's rate control information
- *
- *  This should be called when the supported rates change
- *  (e.g. SME operation, wireless mode change)
- *
- *  It will determine which rates are valid for use.
- */
-static void ath_rc_sib_update(struct ath_softc *sc,
-			      struct ath_rate_node *ath_rc_priv,
-			      u32 capflag, int keep_state,
-			      struct ath_rateset *negotiated_rates,
-			      struct ath_rateset *negotiated_htrates)
+static void ath_rc_init(struct ath_softc *sc,
+			struct ath_rate_node *ath_rc_priv,
+			struct ieee80211_supported_band *sband,
+			struct ieee80211_sta *sta)
 {
 	struct ath_rate_table *rate_table = NULL;
 	struct ath_rate_softc *asc = (struct ath_rate_softc *)sc->sc_rc;
-	struct ath_rateset *rateset = negotiated_rates;
-	u8 *ht_mcs = (u8 *)negotiated_htrates;
+	struct ath_rateset *rateset = &ath_rc_priv->neg_rates;
+	u8 *ht_mcs = (u8 *)&ath_rc_priv->neg_ht_rates;
 	u8 i, j, k, hi = 0, hthi = 0;
 
 	rate_table = (struct ath_rate_table *)
 		asc->hw_rate_table[sc->sc_curmode];
 
+	if (sta->ht_cap.ht_supported) {
+		if (sband->band == IEEE80211_BAND_2GHZ)
+			rate_table = (struct ath_rate_table *)
+				asc->hw_rate_table[ATH9K_MODE_11NG_HT20];
+		else
+			rate_table = (struct ath_rate_table *)
+				asc->hw_rate_table[ATH9K_MODE_11NA_HT20];
+
+		ath_rc_priv->ht_cap = (WLAN_RC_HT_FLAG | WLAN_RC_DS_FLAG);
+		if (sta->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40)
+			ath_rc_priv->ht_cap |= WLAN_RC_40_FLAG;
+	}
+
 	/* Initial rate table size. Will change depending
 	 * on the working rate set */
 	ath_rc_priv->rate_table_size = MAX_TX_RATE_TBL;
 
 	/* Initialize thresholds according to the global rate table */
-	for (i = 0 ; (i < ath_rc_priv->rate_table_size) && (!keep_state); i++) {
+	for (i = 0 ; i < ath_rc_priv->rate_table_size; i++) {
 		ath_rc_priv->state[i].rssi_thres =
 			rate_table->info[i].rssi_ack_validmin;
 		ath_rc_priv->state[i].per = 0;
@@ -1488,24 +1492,24 @@ static void ath_rc_sib_update(struct ath_softc *sc,
 			ath_rc_priv->valid_phy_rateidx[i][j] = 0;
 		ath_rc_priv->valid_phy_ratecnt[i] = 0;
 	}
-	ath_rc_priv->rc_phy_mode = (capflag & WLAN_RC_40_FLAG);
+	ath_rc_priv->rc_phy_mode = (ath_rc_priv->ht_cap & WLAN_RC_40_FLAG);
 
 	/* Set stream capability */
-	ath_rc_priv->single_stream = (capflag & WLAN_RC_DS_FLAG) ? 0 : 1;
+	ath_rc_priv->single_stream = (ath_rc_priv->ht_cap & WLAN_RC_DS_FLAG) ? 0 : 1;
 
 	if (!rateset->rs_nrates) {
 		/* No working rate, just initialize valid rates */
 		hi = ath_rc_sib_init_validrates(ath_rc_priv, rate_table,
-						capflag);
+						ath_rc_priv->ht_cap);
 	} else {
 		/* Use intersection of working rates and valid rates */
 		hi = ath_rc_sib_setvalid_rates(ath_rc_priv, rate_table,
-					       rateset, capflag);
-		if (capflag & WLAN_RC_HT_FLAG) {
+					       rateset, ath_rc_priv->ht_cap);
+		if (ath_rc_priv->ht_cap & WLAN_RC_HT_FLAG) {
 			hthi = ath_rc_sib_setvalid_htrates(ath_rc_priv,
 							   rate_table,
 							   ht_mcs,
-							   capflag);
+							   ath_rc_priv->ht_cap);
 		}
 		hi = A_MAX(hi, hthi);
 	}
@@ -1539,29 +1543,6 @@ static void ath_rc_sib_update(struct ath_softc *sc,
 	ath_rc_priv->rate_max_phy = ath_rc_priv->valid_rate_index[k-4];
 }
 
-void ath_rc_node_update(struct ieee80211_hw *hw, struct ath_rate_node *rc_priv)
-{
-	struct ath_softc *sc = hw->priv;
-	u32 capflag = 0;
-
-	if (hw->conf.ht.enabled) {
-		capflag |= ATH_RC_HT_FLAG | ATH_RC_DS_FLAG;
-		if (sc->sc_ht_info.tx_chan_width == ATH9K_HT_MACMODE_2040)
-			capflag |= ATH_RC_CW40_FLAG;
-	}
-
-	rc_priv->ht_cap =
-		((capflag & ATH_RC_DS_FLAG) ? WLAN_RC_DS_FLAG : 0) |
-		((capflag & ATH_RC_SGI_FLAG) ? WLAN_RC_SGI_FLAG : 0) |
-		((capflag & ATH_RC_HT_FLAG)  ? WLAN_RC_HT_FLAG : 0) |
-		((capflag & ATH_RC_CW40_FLAG) ? WLAN_RC_40_FLAG : 0);
-
-
-	ath_rc_sib_update(sc, rc_priv, rc_priv->ht_cap, 0,
-			  &rc_priv->neg_rates,
-			  &rc_priv->neg_ht_rates);
-}
-
 /* Rate Control callbacks */
 static void ath_tx_status(void *priv, struct ieee80211_supported_band *sband,
 			  struct ieee80211_sta *sta, void *priv_sta,
@@ -1684,7 +1665,7 @@ static void ath_rate_init(void *priv, struct ieee80211_supported_band *sband,
 		ath_rc_priv->neg_ht_rates.rs_nrates = j;
 	}
 
-	ath_rc_node_update(sc->hw, priv_sta);
+	ath_rc_init(sc, priv_sta, sband, sta);
 }
 
 static void *ath_rate_alloc(struct ieee80211_hw *hw, struct dentry *debugfsdir)
@@ -1699,16 +1680,9 @@ static void ath_rate_free(void *priv)
 
 static void *ath_rate_alloc_sta(void *priv, struct ieee80211_sta *sta, gfp_t gfp)
 {
-	struct ieee80211_vif *vif;
 	struct ath_softc *sc = priv;
-	struct ath_vap *avp;
 	struct ath_rate_node *rate_priv;
 
-	vif = sc->sc_vaps[0];
-	ASSERT(vif);
-
-	avp = (void *)vif->drv_priv;
-
 	rate_priv = kzalloc(sizeof(struct ath_rate_node), gfp);
 	if (!rate_priv) {
 		DPRINTF(sc, ATH_DBG_FATAL,
@@ -1717,9 +1691,7 @@ static void *ath_rate_alloc_sta(void *priv, struct ieee80211_sta *sta, gfp_t gfp
 		return NULL;
 	}
 
-	rate_priv->avp = avp;
 	rate_priv->asc = sc->sc_rc;
-	avp->rc_node = rate_priv;
 	rate_priv->rssi_down_time = jiffies_to_msecs(jiffies);
 
 	return rate_priv;
diff --git a/drivers/net/wireless/ath9k/rc.h b/drivers/net/wireless/ath9k/rc.h
index 8d0650a..07319c6 100644
--- a/drivers/net/wireless/ath9k/rc.h
+++ b/drivers/net/wireless/ath9k/rc.h
@@ -265,7 +265,6 @@ struct ath_rate_node {
 	struct ath_rateset neg_rates;
 	struct ath_rateset neg_ht_rates;
 	struct ath_rate_softc *asc;
-	struct ath_vap *avp;
 };
 
 /* Driver data of ieee80211_tx_info */
@@ -279,7 +278,6 @@ struct ath_tx_info_priv {
 
 struct ath_rate_softc *ath_rate_attach(struct ath_softc *sch);
 void ath_rate_detach(struct ath_rate_softc *asc);
-void ath_rc_node_update(struct ieee80211_hw *hw, struct ath_rate_node *rc_priv);
 u8 ath_rate_findrateix(struct ath_softc *sc, u8 dot11_rate);
 int ath_rate_control_register(void);
 void ath_rate_control_unregister(void);
-- 
1.6.0.3

