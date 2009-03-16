Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pool-71-115-160-52.gdrpmi.dsl-w.verizon.net ([71.115.160.52]:34250
	"EHLO s0be.servebeer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754316AbZCPWg1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2009 18:36:27 -0400
Message-ID: <49BED464.2010904@erley.org> (sfid-20090316_233631_951441_68D057DC)
Date: Mon, 16 Mar 2009 18:36:20 -0400
From: Pat Erley <pat-lkml@erley.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: ath9k-devel@lists.ath9k.org,
	"andrey@cozybit.com >> Andrey Yurovsky" <andrey@cozybit.com>,
	brian@cozybit.com, javier@cozybit.com, colin@cozybit.com
Subject: [rfc] Implement ath9k mesh point operation
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch enables mesh point operation for ath9k.  Tested with b43
and ath5k as peers. 

Signed-off-by: Pat Erley <pat-lkml@erley.org>
---
Currently, you need to trigger a scan on the mesh point interface to
enable beaconing.  This is the same behavior the ath5k, rt2500usb and 
rt61pci drivers exhibit.  Is this a mac80211 design flaw, or something
in all of these drivers?

diff --git a/drivers/net/wireless/ath9k/beacon.c b/drivers/net/wireless/ath9k/beacon.c
index 039c781..68e05ed 100644
--- a/drivers/net/wireless/ath9k/beacon.c
+++ b/drivers/net/wireless/ath9k/beacon.c
@@ -70,7 +70,8 @@ static void ath_beacon_setup(struct ath_softc *sc, struct ath_vif *avp,
 	ds = bf->bf_desc;
 	flags = ATH9K_TXDESC_NOACK;
 
-	if (sc->sc_ah->opmode == NL80211_IFTYPE_ADHOC &&
+	if (((sc->sc_ah->opmode == NL80211_IFTYPE_ADHOC) ||
+	     (sc->sc_ah->opmode == NL80211_IFTYPE_MESH_POINT)) &&
 	    (ah->caps.hw_caps & ATH9K_HW_CAP_VEOL)) {
 		ds->ds_link = bf->bf_daddr; /* self-linked */
 		flags |= ATH9K_TXDESC_VEOL;
@@ -728,6 +729,7 @@ void ath_beacon_config(struct ath_softc *sc, struct ieee80211_vif *vif)
 			ath_beacon_config_ap(sc, &conf, avp);
 			break;
 		case NL80211_IFTYPE_ADHOC:
+		case NL80211_IFTYPE_MESH_POINT:
 			ath_beacon_config_adhoc(sc, &conf, avp, vif);
 			break;
 		case NL80211_IFTYPE_STATION:
diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index ea550cc..a69328e 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -1424,6 +1424,7 @@ static void ath9k_hw_set_operating_mode(struct ath_hw *ah, int opmode)
 		REG_CLR_BIT(ah, AR_CFG, AR_CFG_AP_ADHOC_INDICATION);
 		break;
 	case NL80211_IFTYPE_ADHOC:
+	case NL80211_IFTYPE_MESH_POINT:
 		REG_WRITE(ah, AR_STA_ID1, val | AR_STA_ID1_ADHOC
 			  | AR_STA_ID1_KSRCH_MODE);
 		REG_SET_BIT(ah, AR_CFG, AR_CFG_AP_ADHOC_INDICATION);
@@ -3129,6 +3130,7 @@ void ath9k_hw_beaconinit(struct ath_hw *ah, u32 next_beacon, u32 beacon_period)
 		flags |= AR_TBTT_TIMER_EN;
 		break;
 	case NL80211_IFTYPE_ADHOC:
+	case NL80211_IFTYPE_MESH_POINT:
 		REG_SET_BIT(ah, AR_TXCFG,
 			    AR_TXCFG_ADHOC_BEACON_ATIM_TX_POLICY);
 		REG_WRITE(ah, AR_NEXT_NDP_TIMER,
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index a2f5af6..0f9f6ca 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -1591,7 +1591,8 @@ void ath_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 	hw->wiphy->interface_modes =
 		BIT(NL80211_IFTYPE_AP) |
 		BIT(NL80211_IFTYPE_STATION) |
-		BIT(NL80211_IFTYPE_ADHOC);
+		BIT(NL80211_IFTYPE_ADHOC) |
+		BIT(NL80211_IFTYPE_MESH_POINT);
 
 	hw->wiphy->reg_notifier = ath9k_reg_notifier;
 	hw->wiphy->strict_regulatory = true;
@@ -2199,18 +2200,13 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 		ic_opmode = NL80211_IFTYPE_STATION;
 		break;
 	case NL80211_IFTYPE_ADHOC:
-		if (sc->nbcnvifs >= ATH_BCBUF) {
-			ret = -ENOBUFS;
-			goto out;
-		}
-		ic_opmode = NL80211_IFTYPE_ADHOC;
-		break;
 	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_MESH_POINT:
 		if (sc->nbcnvifs >= ATH_BCBUF) {
 			ret = -ENOBUFS;
 			goto out;
 		}
-		ic_opmode = NL80211_IFTYPE_AP;
+		ic_opmode = conf->type;
 		break;
 	default:
 		DPRINTF(sc, ATH_DBG_FATAL,
@@ -2246,7 +2242,8 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 	 * Note we only do this (at the moment) for station mode.
 	 */
 	if ((conf->type == NL80211_IFTYPE_STATION) ||
-	    (conf->type == NL80211_IFTYPE_ADHOC)) {
+	    (conf->type == NL80211_IFTYPE_ADHOC) ||
+	    (conf->type == NL80211_IFTYPE_MESH_POINT)) {
 		if (ath9k_hw_phycounters(sc->sc_ah))
 			sc->imask |= ATH9K_INT_MIB;
 		sc->imask |= ATH9K_INT_TSFOOR;
@@ -2293,8 +2290,9 @@ static void ath9k_remove_interface(struct ieee80211_hw *hw,
 	del_timer_sync(&sc->ani.timer);
 
 	/* Reclaim beacon resources */
-	if (sc->sc_ah->opmode == NL80211_IFTYPE_AP ||
-	    sc->sc_ah->opmode == NL80211_IFTYPE_ADHOC) {
+	if ((sc->sc_ah->opmode == NL80211_IFTYPE_AP) ||
+	    (sc->sc_ah->opmode == NL80211_IFTYPE_ADHOC) ||
+	    (sc->sc_ah->opmode == NL80211_IFTYPE_MESH_POINT)) {
 		ath9k_hw_stoptxdma(sc->sc_ah, sc->beacon.beaconq);
 		ath_beacon_return(sc, avp);
 	}
@@ -2427,6 +2425,7 @@ static int ath9k_config_interface(struct ieee80211_hw *hw,
 		switch (vif->type) {
 		case NL80211_IFTYPE_STATION:
 		case NL80211_IFTYPE_ADHOC:
+		case NL80211_IFTYPE_MESH_POINT:
 			/* Set BSSID */
 			memcpy(sc->curbssid, conf->bssid, ETH_ALEN);
 			memcpy(avp->bssid, conf->bssid, ETH_ALEN);
@@ -2450,7 +2449,8 @@ static int ath9k_config_interface(struct ieee80211_hw *hw,
 	}
 
 	if ((vif->type == NL80211_IFTYPE_ADHOC) ||
-	    (vif->type == NL80211_IFTYPE_AP)) {
+	    (vif->type == NL80211_IFTYPE_AP) ||
+	    (vif->type == NL80211_IFTYPE_MESH_POINT)) {
 		if ((conf->changed & IEEE80211_IFCC_BEACON) ||
 		    (conf->changed & IEEE80211_IFCC_BEACON_ENABLED &&
 		     conf->enable_beacon)) {
diff --git a/drivers/net/wireless/ath9k/rc.c b/drivers/net/wireless/ath9k/rc.c
index 8327356..31a6a2a 100644
--- a/drivers/net/wireless/ath9k/rc.c
+++ b/drivers/net/wireless/ath9k/rc.c
@@ -1615,6 +1615,7 @@ static void ath_rate_init(void *priv, struct ieee80211_supported_band *sband,
 	/* Choose rate table first */
 
 	if ((sc->sc_ah->opmode == NL80211_IFTYPE_STATION) ||
+	    (sc->sc_ah->opmode == NL80211_IFTYPE_MESH_POINT) ||
 	    (sc->sc_ah->opmode == NL80211_IFTYPE_ADHOC)) {
 		rate_table = ath_choose_rate_table(sc, sband->band,
 						   sta->ht_cap.ht_supported,
