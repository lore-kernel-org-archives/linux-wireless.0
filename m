Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:33461 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751144AbZKPGKN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Nov 2009 01:10:13 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 15 Nov 2009 22:10:19 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19200.60648.260654.455459@gargle.gargle.HOWL>
Date: Mon, 16 Nov 2009 11:40:48 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/4] ath9k: Cleanup bss_info_changed callback
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Remove a code chunk dealing with operating mode changes.
  As noted, all such policy changes are to be done in
  add_interface.

* Remove pointless check for empty BSSID.
  Also, remove mode checks - mac80211 does all the needed checks.

* Handle enabling/disabling beacon transmission properly.

* Handle beacon interval changes for AP mode.
  The original code depended on config_interface() to update
  the HW TSF. Since that callback has been removed, handle
  it properly.

* Remove unneeded code dealing with key/privacy.

* Set the chainmasks to 1x1 for IBSS when the BSSID is set.
  This was happening uncondionally before.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |  114 +++++++++++----------------------
 1 files changed, 37 insertions(+), 77 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 3c02b97..3229c39 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2956,90 +2956,62 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath_vif *avp = (void *)vif->drv_priv;
-	u32 rfilt = 0;
-	int error, i;
+	int error;
 
 	mutex_lock(&sc->mutex);
 
-	/*
-	 * TODO: Need to decide which hw opmode to use for
-	 *       multi-interface cases
-	 * XXX: This belongs into add_interface!
-	 */
-	if (vif->type == NL80211_IFTYPE_AP &&
-	    ah->opmode != NL80211_IFTYPE_AP) {
-		ah->opmode = NL80211_IFTYPE_STATION;
-		ath9k_hw_setopmode(ah);
-		memcpy(common->curbssid, common->macaddr, ETH_ALEN);
+	if (changed & BSS_CHANGED_BSSID) {
+		/* Set BSSID */
+		memcpy(common->curbssid, bss_conf->bssid, ETH_ALEN);
+		memcpy(avp->bssid, bss_conf->bssid, ETH_ALEN);
 		common->curaid = 0;
 		ath9k_hw_write_associd(ah);
-		/* Request full reset to get hw opmode changed properly */
-		sc->sc_flags |= SC_OP_FULL_RESET;
-	}
 
-	if ((changed & BSS_CHANGED_BSSID) &&
-	    !is_zero_ether_addr(bss_conf->bssid)) {
-		switch (vif->type) {
-		case NL80211_IFTYPE_STATION:
-		case NL80211_IFTYPE_ADHOC:
-		case NL80211_IFTYPE_MESH_POINT:
-			/* Set BSSID */
-			memcpy(common->curbssid, bss_conf->bssid, ETH_ALEN);
-			memcpy(avp->bssid, bss_conf->bssid, ETH_ALEN);
-			common->curaid = 0;
-			ath9k_hw_write_associd(ah);
+		/* Set aggregation protection mode parameters */
+		sc->config.ath_aggr_prot = 0;
 
-			/* Set aggregation protection mode parameters */
-			sc->config.ath_aggr_prot = 0;
+		/* Only legacy IBSS for now */
+		if (vif->type == NL80211_IFTYPE_ADHOC)
+			ath_update_chainmask(sc, 0);
 
-			ath_print(common, ATH_DBG_CONFIG,
-				  "RX filter 0x%x bssid %pM aid 0x%x\n",
-				  rfilt, common->curbssid, common->curaid);
+		ath_print(common, ATH_DBG_CONFIG,
+			  "BSSID: %pM aid: 0x%x\n",
+			  common->curbssid, common->curaid);
 
-			/* need to reconfigure the beacon */
-			sc->sc_flags &= ~SC_OP_BEACONS ;
+		/* need to reconfigure the beacon */
+		sc->sc_flags &= ~SC_OP_BEACONS ;
+	}
 
-			break;
-		default:
-			break;
-		}
+	/* Enable transmission of beacons (AP, IBSS, MESH) */
+	if ((changed & BSS_CHANGED_BEACON) ||
+	    ((changed & BSS_CHANGED_BEACON_ENABLED) && bss_conf->enable_beacon)) {
+		ath9k_hw_stoptxdma(sc->sc_ah, sc->beacon.beaconq);
+		error = ath_beacon_alloc(aphy, vif);
+		if (!error)
+			ath_beacon_config(sc, vif);
 	}
 
-	if ((vif->type == NL80211_IFTYPE_ADHOC) ||
-	    (vif->type == NL80211_IFTYPE_AP) ||
-	    (vif->type == NL80211_IFTYPE_MESH_POINT)) {
-		if ((changed & BSS_CHANGED_BEACON) ||
-		    (changed & BSS_CHANGED_BEACON_ENABLED &&
-		     bss_conf->enable_beacon)) {
-			/*
-			 * Allocate and setup the beacon frame.
-			 *
-			 * Stop any previous beacon DMA.  This may be
-			 * necessary, for example, when an ibss merge
-			 * causes reconfiguration; we may be called
-			 * with beacon transmission active.
-			 */
-			ath9k_hw_stoptxdma(sc->sc_ah, sc->beacon.beaconq);
+	/* Disable transmission of beacons */
+	if ((changed & BSS_CHANGED_BEACON_ENABLED) && !bss_conf->enable_beacon)
+		ath9k_hw_stoptxdma(sc->sc_ah, sc->beacon.beaconq);
 
+	if (changed & BSS_CHANGED_BEACON_INT) {
+		sc->beacon_interval = bss_conf->beacon_int;
+		/*
+		 * In case of AP mode, the HW TSF has to be reset
+		 * when the beacon interval changes.
+		 */
+		if (vif->type == NL80211_IFTYPE_AP) {
+			sc->sc_flags |= SC_OP_TSF_RESET;
+			ath9k_hw_stoptxdma(sc->sc_ah, sc->beacon.beaconq);
 			error = ath_beacon_alloc(aphy, vif);
 			if (!error)
 				ath_beacon_config(sc, vif);
+		} else {
+			ath_beacon_config(sc, vif);
 		}
 	}
 
-	/* Check for WLAN_CAPABILITY_PRIVACY ? */
-	if ((avp->av_opmode != NL80211_IFTYPE_STATION)) {
-		for (i = 0; i < IEEE80211_WEP_NKID; i++)
-			if (ath9k_hw_keyisvalid(sc->sc_ah, (u16)i))
-				ath9k_hw_keysetmac(sc->sc_ah,
-						   (u16)i,
-						   common->curbssid);
-	}
-
-	/* Only legacy IBSS for now */
-	if (vif->type == NL80211_IFTYPE_ADHOC)
-		ath_update_chainmask(sc, 0);
-
 	if (changed & BSS_CHANGED_ERP_PREAMBLE) {
 		ath_print(common, ATH_DBG_CONFIG, "BSS Changed PREAMBLE %d\n",
 			  bss_conf->use_short_preamble);
@@ -3065,18 +3037,6 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 		ath9k_bss_assoc_info(sc, vif, bss_conf);
 	}
 
-	/*
-	 * The HW TSF has to be reset when the beacon interval changes.
-	 * We set the flag here, and ath_beacon_config_ap() would take this
-	 * into account when it gets called through the subsequent
-	 * config_interface() call - with IFCC_BEACON in the changed field.
-	 */
-
-	if (changed & BSS_CHANGED_BEACON_INT) {
-		sc->sc_flags |= SC_OP_TSF_RESET;
-		sc->beacon_interval = bss_conf->beacon_int;
-	}
-
 	mutex_unlock(&sc->mutex);
 }
 
-- 
1.6.5.2

