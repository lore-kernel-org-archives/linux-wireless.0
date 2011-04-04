Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:63923 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751569Ab1DDR0a (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Apr 2011 13:26:30 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 04 Apr 2011 10:26:05 -0700
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH 4/5] ath9k: configure beacons based on hw opmode
Date: Mon, 4 Apr 2011 22:56:19 +0530
Message-ID: <1301937979-14770-4-git-send-email-rmanoharan@atheros.com>
In-Reply-To: <1301937979-14770-1-git-send-email-rmanoharan@atheros.com>
References: <1301937979-14770-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Current ath9k code does not handle beacon timers on opmode
specific. One such example is that a STA beacon config overwrites
already configured AP vif's beacon timers during scan.

On multi station vif case, configure beacon timers beased
on primary vif selected. This also helps while moving back
to single STA vif from multi STA vifs, where the power save
is enabled and hw has to be reconfigured with proper
beacon and bssid/aid. Otherwise connection poll will be triggered
so frequently due to beacon loss.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h  |    1 +
 drivers/net/wireless/ath/ath9k/beacon.c |  101 +++++++++++++++++++++++--------
 drivers/net/wireless/ath/ath9k/main.c   |   84 ++++++++------------------
 drivers/net/wireless/ath/ath9k/recv.c   |    2 +-
 4 files changed, 104 insertions(+), 84 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 1ffe8d4..e6f8fa6 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -399,6 +399,7 @@ void ath_beacon_config(struct ath_softc *sc, struct ieee80211_vif *vif);
 int ath_beacon_alloc(struct ath_softc *sc, struct ieee80211_vif *vif);
 void ath_beacon_return(struct ath_softc *sc, struct ath_vif *avp);
 int ath_beaconq_config(struct ath_softc *sc);
+void ath_set_beacon(struct ath_softc *sc);
 void ath9k_set_beaconing_status(struct ath_softc *sc, bool status);
 
 /*******/
diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index fec9255..801c3c0 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -671,22 +671,63 @@ static void ath_beacon_config_adhoc(struct ath_softc *sc,
 	ath9k_hw_set_interrupts(ah, ah->imask);
 }
 
-void ath_beacon_config(struct ath_softc *sc, struct ieee80211_vif *vif)
+static bool ath9k_allow_beacon_config(struct ath_softc *sc,
+				      struct ieee80211_vif *vif)
 {
 	struct ath_beacon_config *cur_conf = &sc->cur_beacon_conf;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
-	enum nl80211_iftype iftype;
+	struct ieee80211_bss_conf *bss_conf = &vif->bss_conf;
+	struct ath_vif *avp = (void *)vif->drv_priv;
 
-	/* Setup the beacon configuration parameters */
-	if (vif) {
-		struct ieee80211_bss_conf *bss_conf = &vif->bss_conf;
-		iftype = vif->type;
-		cur_conf->beacon_interval = bss_conf->beacon_int;
-		cur_conf->dtim_period = bss_conf->dtim_period;
-	} else {
-		iftype = sc->sc_ah->opmode;
+	/*
+	 * Can not have different beacon interval on multiple
+	 * AP interface case
+	 */
+	if ((sc->sc_ah->opmode == NL80211_IFTYPE_AP) &&
+	    (sc->nbcnvifs > 1) &&
+	    (vif->type == NL80211_IFTYPE_AP) &&
+	    (cur_conf->beacon_interval != bss_conf->beacon_int)) {
+		ath_dbg(common, ATH_DBG_CONFIG,
+			"Changing beacon interval of multiple \
+			AP interfaces !\n");
+		return false;
+	}
+	/*
+	 * Can not configure station vif's beacon config
+	 * while on AP opmode
+	 */
+	if ((sc->sc_ah->opmode == NL80211_IFTYPE_AP) &&
+	    (vif->type != NL80211_IFTYPE_AP)) {
+		ath_dbg(common, ATH_DBG_CONFIG,
+			"STA vif's beacon not allowed on AP mode\n");
+		return false;
+	}
+	/*
+	 * Do not allow beacon config if HW was already configured
+	 * with another STA vif
+	 */
+	if ((sc->sc_ah->opmode == NL80211_IFTYPE_STATION) &&
+	    (vif->type == NL80211_IFTYPE_STATION) &&
+	    (sc->sc_flags & SC_OP_BEACONS) &&
+	    !avp->primary_sta_vif) {
+		ath_dbg(common, ATH_DBG_CONFIG,
+			"Beacon already configured for a station interface\n");
+		return false;
 	}
+	return true;
+}
+
+void ath_beacon_config(struct ath_softc *sc, struct ieee80211_vif *vif)
+{
+	struct ath_beacon_config *cur_conf = &sc->cur_beacon_conf;
+	struct ieee80211_bss_conf *bss_conf = &vif->bss_conf;
 
+	if (!ath9k_allow_beacon_config(sc, vif))
+		return;
+
+	/* Setup the beacon configuration parameters */
+	cur_conf->beacon_interval = bss_conf->beacon_int;
+	cur_conf->dtim_period = bss_conf->dtim_period;
 	cur_conf->listen_interval = 1;
 	cur_conf->dtim_count = 1;
 	cur_conf->bmiss_timeout =
@@ -709,7 +750,16 @@ void ath_beacon_config(struct ath_softc *sc, struct ieee80211_vif *vif)
 	if (cur_conf->dtim_period == 0)
 		cur_conf->dtim_period = 1;
 
-	switch (iftype) {
+	ath_set_beacon(sc);
+	sc->ps_flags |= PS_BEACON_SYNC | PS_WAIT_FOR_BEACON;
+}
+
+void ath_set_beacon(struct ath_softc *sc)
+{
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	struct ath_beacon_config *cur_conf = &sc->cur_beacon_conf;
+
+	switch (sc->sc_ah->opmode) {
 	case NL80211_IFTYPE_AP:
 		ath_beacon_config_ap(sc, cur_conf);
 		break;
@@ -736,22 +786,23 @@ void ath9k_set_beaconing_status(struct ath_softc *sc, bool status)
 	int slot;
 	bool found = false;
 
-	ath9k_ps_wakeup(sc);
-	if (status) {
-		for (slot = 0; slot < ATH_BCBUF; slot++) {
-			if (sc->beacon.bslot[slot]) {
-				avp = (void *)sc->beacon.bslot[slot]->drv_priv;
-				if (avp->is_bslot_active) {
-					found = true;
-					break;
-				}
+	for (slot = 0; slot < ATH_BCBUF; slot++) {
+		if (sc->beacon.bslot[slot]) {
+			avp = (void *)sc->beacon.bslot[slot]->drv_priv;
+			if (avp->is_bslot_active) {
+				found = true;
+				break;
 			}
 		}
-		if (found) {
-			/* Re-enable beaconing */
-			ah->imask |= ATH9K_INT_SWBA;
-			ath9k_hw_set_interrupts(ah, ah->imask);
-		}
+	}
+	if (!found)
+		return;
+
+	ath9k_ps_wakeup(sc);
+	if (status) {
+		/* Re-enable beaconing */
+		ah->imask |= ATH9K_INT_SWBA;
+		ath9k_hw_set_interrupts(ah, ah->imask);
 	} else {
 		/* Disable SWBA interrupt */
 		ah->imask &= ~ATH9K_INT_SWBA;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index e5a9f69..ba1c9a6 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -299,7 +299,7 @@ int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
 
 	if (!(sc->sc_flags & (SC_OP_OFFCHANNEL))) {
 		if (sc->sc_flags & SC_OP_BEACONS)
-			ath_beacon_config(sc, NULL);
+			ath_set_beacon(sc);
 		ieee80211_queue_delayed_work(sc->hw, &sc->tx_complete_work, 0);
 		ieee80211_queue_delayed_work(sc->hw, &sc->hw_pll_work, HZ/2);
 		ath_start_ani(common);
@@ -828,43 +828,6 @@ chip_reset:
 #undef SCHED_INTR
 }
 
-static void ath9k_bss_assoc_info(struct ath_softc *sc,
-				 struct ieee80211_hw *hw,
-				 struct ieee80211_vif *vif,
-				 struct ieee80211_bss_conf *bss_conf)
-{
-	struct ath_hw *ah = sc->sc_ah;
-	struct ath_common *common = ath9k_hw_common(ah);
-
-	if (bss_conf->assoc) {
-		ath_dbg(common, ATH_DBG_CONFIG,
-			"Bss Info ASSOC %d, bssid: %pM\n",
-			bss_conf->aid, common->curbssid);
-
-		/*
-		 * Request a re-configuration of Beacon related timers
-		 * on the receipt of the first Beacon frame (i.e.,
-		 * after time sync with the AP).
-		 */
-		sc->ps_flags |= PS_BEACON_SYNC;
-
-		/* Configure the beacon */
-		ath_beacon_config(sc, vif);
-
-		/* Reset rssi stats */
-		sc->last_rssi = ATH_RSSI_DUMMY_MARKER;
-		sc->sc_ah->stats.avgbrssi = ATH_RSSI_DUMMY_MARKER;
-
-		sc->sc_flags |= SC_OP_ANI_RUN;
-		ath_start_ani(common);
-	} else {
-		ath_dbg(common, ATH_DBG_CONFIG, "Bss Info DISASSOC\n");
-		/* Stop ANI */
-		sc->sc_flags &= ~SC_OP_ANI_RUN;
-		del_timer_sync(&common->ani.timer);
-	}
-}
-
 void ath_radio_enable(struct ath_softc *sc, struct ieee80211_hw *hw)
 {
 	struct ath_hw *ah = sc->sc_ah;
@@ -894,7 +857,7 @@ void ath_radio_enable(struct ath_softc *sc, struct ieee80211_hw *hw)
 		goto out;
 	}
 	if (sc->sc_flags & SC_OP_BEACONS)
-		ath_beacon_config(sc, NULL);	/* restart beacons */
+		ath_set_beacon(sc);	/* restart beacons */
 
 	/* Re-Enable  interrupts */
 	ath9k_hw_set_interrupts(ah, ah->imask);
@@ -1001,7 +964,7 @@ int ath_reset(struct ath_softc *sc, bool retry_tx)
 			       sc->config.txpowlimit, &sc->curtxpow);
 
 	if ((sc->sc_flags & SC_OP_BEACONS) || !(sc->sc_flags & (SC_OP_OFFCHANNEL)))
-		ath_beacon_config(sc, NULL);	/* restart beacons */
+		ath_set_beacon(sc);	/* restart beacons */
 
 	ath9k_hw_set_interrupts(ah, ah->imask);
 
@@ -1412,9 +1375,6 @@ static void ath9k_calculate_summary_state(struct ieee80211_hw *hw,
 	if ((iter_data.naps + iter_data.nadhocs) > 0) {
 		sc->sc_flags |= SC_OP_ANI_RUN;
 		ath_start_ani(common);
-	} else {
-		sc->sc_flags &= ~SC_OP_ANI_RUN;
-		del_timer_sync(&common->ani.timer);
 	}
 }
 
@@ -1898,6 +1858,9 @@ static void ath9k_bss_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
 		memcpy(common->curbssid, bss_conf->bssid, ETH_ALEN);
 		common->curaid = bss_conf->aid;
 		ath9k_hw_write_associd(sc->sc_ah);
+		/* configure beacon */
+		if (bss_conf->enable_beacon)
+			ath_beacon_config(sc, vif);
 		break;
 	case NL80211_IFTYPE_STATION:
 		/*
@@ -1913,6 +1876,16 @@ static void ath9k_bss_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
 			memcpy(common->curbssid, bss_conf->bssid, ETH_ALEN);
 			common->curaid = bss_conf->aid;
 			ath9k_hw_write_associd(sc->sc_ah);
+			ath_dbg(common, ATH_DBG_CONFIG,
+				"Bss Info ASSOC %d, bssid: %pM\n",
+				bss_conf->aid, common->curbssid);
+			ath_beacon_config(sc, vif);
+			/* Reset rssi stats */
+			sc->last_rssi = ATH_RSSI_DUMMY_MARKER;
+			sc->sc_ah->stats.avgbrssi = ATH_RSSI_DUMMY_MARKER;
+
+			sc->sc_flags |= SC_OP_ANI_RUN;
+			ath_start_ani(common);
 		}
 		break;
 	default:
@@ -1928,7 +1901,10 @@ static void ath9k_config_bss(struct ath_softc *sc, struct ieee80211_vif *vif)
 
 	/* Reconfigure bss info */
 	if (avp->primary_sta_vif && !bss_conf->assoc) {
-		sc->sc_flags &= ~SC_OP_PRIM_STA_VIF;
+		ath_dbg(common, ATH_DBG_CONFIG,
+			"Bss Info DISASSOC %d, bssid %pM\n",
+			common->curaid, common->curbssid);
+		sc->sc_flags &= ~(SC_OP_PRIM_STA_VIF | SC_OP_BEACONS);
 		avp->primary_sta_vif = false;
 		memset(common->curbssid, 0, ETH_ALEN);
 		common->curaid = 0;
@@ -1942,8 +1918,12 @@ static void ath9k_config_bss(struct ath_softc *sc, struct ieee80211_vif *vif)
 	 * Clear bssid & aid
 	 */
 	if ((sc->sc_ah->opmode == NL80211_IFTYPE_STATION) &&
-	    !(sc->sc_flags & SC_OP_PRIM_STA_VIF))
+	    !(sc->sc_flags & SC_OP_PRIM_STA_VIF)) {
 		ath9k_hw_write_associd(sc->sc_ah);
+		/* Stop ANI */
+		sc->sc_flags &= ~SC_OP_ANI_RUN;
+		del_timer_sync(&common->ani.timer);
+	}
 }
 
 static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
@@ -1952,7 +1932,6 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 				   u32 changed)
 {
 	struct ath_softc *sc = hw->priv;
-	struct ath_beacon_config *cur_conf = &sc->cur_beacon_conf;
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath_vif *avp = (void *)vif->drv_priv;
@@ -1969,9 +1948,6 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 
 		ath_dbg(common, ATH_DBG_CONFIG, "BSSID: %pM aid: 0x%x\n",
 			common->curbssid, common->curaid);
-
-		/* need to reconfigure the beacon */
-		sc->sc_flags &= ~SC_OP_BEACONS ;
 	}
 
 	/* Enable transmission of beacons (AP, IBSS, MESH) */
@@ -2012,7 +1988,6 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 	}
 
 	if (changed & BSS_CHANGED_BEACON_INT) {
-		cur_conf->beacon_interval = bss_conf->beacon_int;
 		/*
 		 * In case of AP mode, the HW TSF has to be reset
 		 * when the beacon interval changes.
@@ -2024,9 +1999,8 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 			if (!error)
 				ath_beacon_config(sc, vif);
 			ath9k_set_beaconing_status(sc, true);
-		} else {
+		} else
 			ath_beacon_config(sc, vif);
-		}
 	}
 
 	if (changed & BSS_CHANGED_ERP_PREAMBLE) {
@@ -2048,12 +2022,6 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 			sc->sc_flags &= ~SC_OP_PROTECT_ENABLE;
 	}
 
-	if (changed & BSS_CHANGED_ASSOC) {
-		ath_dbg(common, ATH_DBG_CONFIG, "BSS Changed ASSOC %d\n",
-			bss_conf->assoc);
-		ath9k_bss_assoc_info(sc, hw, vif, bss_conf);
-	}
-
 	mutex_unlock(&sc->mutex);
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index a9c3f46..3842b75 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -574,7 +574,7 @@ static void ath_rx_ps_beacon(struct ath_softc *sc, struct sk_buff *skb)
 		sc->ps_flags &= ~PS_BEACON_SYNC;
 		ath_dbg(common, ATH_DBG_PS,
 			"Reconfigure Beacon timers based on timestamp from the AP\n");
-		ath_beacon_config(sc, NULL);
+		ath_set_beacon(sc);
 	}
 
 	if (ath_beacon_dtim_pending_cab(skb)) {
-- 
1.7.4.2

