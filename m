Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:32380 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752627Ab1BPRdq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Feb 2011 12:33:46 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 16 Feb 2011 09:33:25 -0800
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linux-wireless@vger.kernel.org>
CC: Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [RFC/RFT] ath9k: configure opmode sepecific beacon timers dynamically
Date: Wed, 16 Feb 2011 23:03:24 +0530
Message-ID: <1297877604-8084-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Current ath9k code does not handle beacon timers on opmode
specific. One such example is that a STA beacon config overwrites
already configured AP vif's beacon timers during scan.

So select a vif as primary based on opmode and configure that
vif's bss and beacon config in hw and update the primary vif
on opmode change, interface up/down and bss info change.

And also while moving back to single STA vif from multi STA vifs,
power save is enabled and hw has to be reconfigured with proper
beacon and bssid. Otherwise connection poll will be triggered
so frequently due to beacon loss.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h  |    9 ++-
 drivers/net/wireless/ath/ath9k/beacon.c |  140 +++++++++++++++++++----------
 drivers/net/wireless/ath/ath9k/main.c   |  146 +++++++++++++++++++++++--------
 drivers/net/wireless/ath/ath9k/recv.c   |    2 +-
 4 files changed, 208 insertions(+), 89 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index ba436cd..6d1e865 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -372,11 +372,14 @@ struct ath_vif {
 #define IEEE80211_MS_TO_TU(x)           (((x) * 1000) / 1024)
 
 struct ath_beacon_config {
+	struct ieee80211_vif *vif;
+	enum nl80211_iftype opmode;
 	int beacon_interval;
 	u16 listen_interval;
 	u16 dtim_period;
 	u16 bmiss_timeout;
 	u8 dtim_count;
+	bool update;
 };
 
 struct ath_beacon {
@@ -400,11 +403,15 @@ struct ath_beacon {
 };
 
 void ath_beacon_tasklet(unsigned long data);
-void ath_beacon_config(struct ath_softc *sc, struct ieee80211_vif *vif);
+void ath_beacon_config(struct ath_softc *sc);
 int ath_beacon_alloc(struct ath_softc *sc, struct ieee80211_vif *vif);
 void ath_beacon_return(struct ath_softc *sc, struct ath_vif *avp);
 int ath_beaconq_config(struct ath_softc *sc);
 void ath9k_set_beaconing_status(struct ath_softc *sc, bool status);
+void ath_fill_beacon_conf(struct ath_beacon_config *cur_conf,
+			  struct ieee80211_vif *vif);
+void ath9k_update_vif_beacon(struct ieee80211_hw *hw,
+			     struct ath_beacon_config *beacon_conf);
 
 /*******/
 /* ANI */
diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index a4bdfdb..6420b0d 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -694,45 +694,12 @@ static void ath_beacon_config_adhoc(struct ath_softc *sc,
 	ath9k_hw_set_interrupts(ah, ah->imask);
 }
 
-void ath_beacon_config(struct ath_softc *sc, struct ieee80211_vif *vif)
+void ath_beacon_config(struct ath_softc *sc)
 {
 	struct ath_beacon_config *cur_conf = &sc->cur_beacon_conf;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
-	enum nl80211_iftype iftype;
 
-	/* Setup the beacon configuration parameters */
-	if (vif) {
-		struct ieee80211_bss_conf *bss_conf = &vif->bss_conf;
-		iftype = vif->type;
-		cur_conf->beacon_interval = bss_conf->beacon_int;
-		cur_conf->dtim_period = bss_conf->dtim_period;
-	} else {
-		iftype = sc->sc_ah->opmode;
-	}
-
-	cur_conf->listen_interval = 1;
-	cur_conf->dtim_count = 1;
-	cur_conf->bmiss_timeout =
-		ATH_DEFAULT_BMISS_LIMIT * cur_conf->beacon_interval;
-
-	/*
-	 * It looks like mac80211 may end up using beacon interval of zero in
-	 * some cases (at least for mesh point). Avoid getting into an
-	 * infinite loop by using a bit safer value instead. To be safe,
-	 * do sanity check on beacon interval for all operating modes.
-	 */
-	if (cur_conf->beacon_interval == 0)
-		cur_conf->beacon_interval = 100;
-
-	/*
-	 * We don't parse dtim period from mac80211 during the driver
-	 * initialization as it breaks association with hidden-ssid
-	 * AP and it causes latency in roaming
-	 */
-	if (cur_conf->dtim_period == 0)
-		cur_conf->dtim_period = 1;
-
-	switch (iftype) {
+	switch (sc->sc_ah->opmode) {
 	case NL80211_IFTYPE_AP:
 		ath_beacon_config_ap(sc, cur_conf);
 		break;
@@ -750,6 +717,7 @@ void ath_beacon_config(struct ath_softc *sc, struct ieee80211_vif *vif)
 	}
 
 	sc->sc_flags |= SC_OP_BEACONS;
+	cur_conf->update = false;
 }
 
 void ath9k_set_beaconing_status(struct ath_softc *sc, bool status)
@@ -759,22 +727,22 @@ void ath9k_set_beaconing_status(struct ath_softc *sc, bool status)
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
+	ath9k_ps_wakeup(sc);
+	if (status) {
+		/* Re-enable beaconing */
+		ah->imask |= ATH9K_INT_SWBA;
+		ath9k_hw_set_interrupts(ah, ah->imask);
 	} else {
 		/* Disable SWBA interrupt */
 		ah->imask &= ~ATH9K_INT_SWBA;
@@ -784,3 +752,77 @@ void ath9k_set_beaconing_status(struct ath_softc *sc, bool status)
 	}
 	ath9k_ps_restore(sc);
 }
+
+
+static void ath9k_beacon_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
+{
+	struct ieee80211_bss_conf *bss_conf = &vif->bss_conf;
+	struct ath_beacon_config *beacon_conf = data;
+
+	/* Get matching vif with opmode */
+	if (beacon_conf->opmode != vif->type)
+		return;
+
+	switch (vif->type) {
+	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_ADHOC:
+		if (bss_conf->enable_beacon)
+			ath_fill_beacon_conf(beacon_conf, vif);
+		break;
+	case NL80211_IFTYPE_STATION:
+		if (bss_conf->assoc)
+			ath_fill_beacon_conf(beacon_conf, vif);
+		break;
+	default:
+	       break;
+	}
+}
+
+void ath9k_update_vif_beacon(struct ieee80211_hw *hw,
+			     struct ath_beacon_config *beacon_conf)
+{
+	struct ath_softc *sc = hw->priv;
+
+	ieee80211_iterate_active_interfaces_atomic(hw, ath9k_beacon_iter,
+						   beacon_conf);
+	if (beacon_conf->update) {
+		if (sc->sc_ah->opmode == NL80211_IFTYPE_AP)
+			sc->ps_flags &= ~(PS_WAIT_FOR_BEACON | PS_BEACON_SYNC);
+		else
+			sc->ps_flags |= PS_WAIT_FOR_BEACON | PS_BEACON_SYNC;
+	} else
+		beacon_conf->vif = NULL;
+}
+
+void ath_fill_beacon_conf(struct ath_beacon_config *cur_conf,
+			  struct ieee80211_vif *vif)
+{
+	struct ieee80211_bss_conf *bss_conf = &vif->bss_conf;
+
+	cur_conf->beacon_interval = bss_conf->beacon_int;
+	cur_conf->dtim_period = bss_conf->dtim_period;
+	cur_conf->listen_interval = 1;
+	cur_conf->dtim_count = 1;
+	cur_conf->bmiss_timeout =
+		ATH_DEFAULT_BMISS_LIMIT * cur_conf->beacon_interval;
+
+	/*
+	 * It looks like mac80211 may end up using beacon interval of zero in
+	 * some cases (at least for mesh point). Avoid getting into an
+	 * infinite loop by using a bit safer value instead. To be safe,
+	 * do sanity check on beacon interval for all operating modes.
+	 */
+	if (cur_conf->beacon_interval == 0)
+		cur_conf->beacon_interval = 100;
+
+	/*
+	 * We don't parse dtim period from mac80211 during the driver
+	 * initialization as it breaks association with hidden-ssid
+	 * AP and it causes latency in roaming
+	 */
+	if (cur_conf->dtim_period == 0)
+		cur_conf->dtim_period = 1;
+
+	cur_conf->vif = vif;
+	cur_conf->update = true;
+}
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 4f568b8..fd14cca 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -226,6 +226,7 @@ int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
 	cancel_delayed_work_sync(&sc->hw_pll_work);
 
 	ath9k_ps_wakeup(sc);
+	ath9k_set_beaconing_status(sc, false);
 
 	spin_lock_bh(&sc->sc_pcu_lock);
 
@@ -279,15 +280,15 @@ int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
 
 	ath9k_cmn_update_txpow(ah, sc->curtxpow,
 			       sc->config.txpowlimit, &sc->curtxpow);
-	ath9k_hw_set_interrupts(ah, ah->imask);
 
 	if (!(sc->sc_flags & (SC_OP_OFFCHANNEL))) {
 		if (sc->sc_flags & SC_OP_BEACONS)
-			ath_beacon_config(sc, NULL);
+			ath_beacon_config(sc);
 		ieee80211_queue_delayed_work(sc->hw, &sc->tx_complete_work, 0);
 		ieee80211_queue_delayed_work(sc->hw, &sc->hw_pll_work, HZ/2);
 		ath_start_ani(common);
 	}
+	ath9k_hw_set_interrupts(ah, ah->imask);
 
  ps_restore:
 	ieee80211_wake_queues(hw);
@@ -812,6 +813,45 @@ chip_reset:
 #undef SCHED_INTR
 }
 
+static bool ath9k_is_primary_vif(struct ath_softc *sc,
+				 struct ieee80211_vif *vif)
+{
+	int ret = false, slot;
+	struct ath_vif *avp;
+
+	if (sc->sc_ah->opmode != vif->type)
+		goto out;
+
+	if (!(sc->sc_flags & SC_OP_BEACONS)) {
+		ret = true;
+		goto out;
+	} else if ((sc->sc_flags & SC_OP_BEACONS) &&
+		   (sc->cur_beacon_conf.vif &&
+		   (sc->cur_beacon_conf.vif != vif)))
+		goto out;
+
+	switch (sc->sc_ah->opmode) {
+	case NL80211_IFTYPE_AP:
+		/* Do not allow if an AP vif is beaconing */
+		for (slot = 0; slot < ATH_BCBUF; slot++) {
+			if (sc->beacon.bslot[slot]) {
+				avp = (void *)sc->beacon.bslot[slot]->drv_priv;
+				if (avp->is_bslot_active)
+					goto out;
+			}
+		}
+		ret = true;
+		break;
+	case NL80211_IFTYPE_ADHOC:
+	case NL80211_IFTYPE_STATION:
+		ret = true;
+	default:
+		break;
+	}
+out:
+	return ret;
+}
+
 static void ath9k_bss_assoc_info(struct ath_softc *sc,
 				 struct ieee80211_hw *hw,
 				 struct ieee80211_vif *vif,
@@ -825,19 +865,23 @@ static void ath9k_bss_assoc_info(struct ath_softc *sc,
 			"Bss Info ASSOC %d, bssid: %pM\n",
 			bss_conf->aid, common->curbssid);
 
-		/* New association, store aid */
-		common->curaid = bss_conf->aid;
-		ath9k_hw_write_associd(ah);
+		if (ath9k_is_primary_vif(sc, vif)) {
+			/*
+			 * Request a re-configuration of Beacon related timers
+			 * on the receipt of the first Beacon frame (i.e.,
+			 * after time sync with the AP).
+			 */
+			sc->ps_flags |= PS_BEACON_SYNC;
+
+			ath_fill_beacon_conf(&sc->cur_beacon_conf, vif);
 
-		/*
-		 * Request a re-configuration of Beacon related timers
-		 * on the receipt of the first Beacon frame (i.e.,
-		 * after time sync with the AP).
-		 */
-		sc->ps_flags |= PS_BEACON_SYNC;
+			/* Configure the beacon */
+			ath_beacon_config(sc);
 
-		/* Configure the beacon */
-		ath_beacon_config(sc, vif);
+			/* New association, store aid */
+			common->curaid = bss_conf->aid;
+			ath9k_hw_write_associd(ah);
+		}
 
 		/* Reset rssi stats */
 		sc->last_rssi = ATH_RSSI_DUMMY_MARKER;
@@ -847,10 +891,24 @@ static void ath9k_bss_assoc_info(struct ath_softc *sc,
 		ath_start_ani(common);
 	} else {
 		ath_dbg(common, ATH_DBG_CONFIG, "Bss Info DISASSOC\n");
-		common->curaid = 0;
-		/* Stop ANI */
-		sc->sc_flags &= ~SC_OP_ANI_RUN;
-		del_timer_sync(&common->ani.timer);
+		if (ath9k_is_primary_vif(sc, vif)) {
+			ath9k_update_vif_beacon(hw, &sc->cur_beacon_conf);
+			if (sc->cur_beacon_conf.vif) {
+				/* Set BSSID */
+				memcpy(common->curbssid,
+					sc->cur_beacon_conf.vif->bss_conf.bssid,
+					ETH_ALEN);
+				/* New association, store aid */
+				common->curaid =
+					sc->cur_beacon_conf.vif->bss_conf.aid;
+				ath9k_hw_write_associd(ah);
+			} else {
+				common->curaid = 0;
+				/* Stop ANI */
+				sc->sc_flags &= ~SC_OP_ANI_RUN;
+				del_timer_sync(&common->ani.timer);
+			}
+		}
 	}
 }
 
@@ -883,7 +941,7 @@ void ath_radio_enable(struct ath_softc *sc, struct ieee80211_hw *hw)
 		goto out;
 	}
 	if (sc->sc_flags & SC_OP_BEACONS)
-		ath_beacon_config(sc, NULL);	/* restart beacons */
+		ath_beacon_config(sc);	/* restart beacons */
 
 	/* Re-Enable  interrupts */
 	ath9k_hw_set_interrupts(ah, ah->imask);
@@ -986,7 +1044,7 @@ int ath_reset(struct ath_softc *sc, bool retry_tx)
 			       sc->config.txpowlimit, &sc->curtxpow);
 
 	if ((sc->sc_flags & SC_OP_BEACONS) || !(sc->sc_flags & (SC_OP_OFFCHANNEL)))
-		ath_beacon_config(sc, NULL);	/* restart beacons */
+		ath_beacon_config(sc);	/* restart beacons */
 
 	ath9k_hw_set_interrupts(ah, ah->imask);
 
@@ -1294,7 +1352,8 @@ static void ath9k_reclaim_beacon(struct ath_softc *sc,
 	ath9k_set_beaconing_status(sc, false);
 	ath_beacon_return(sc, avp);
 	ath9k_set_beaconing_status(sc, true);
-	sc->sc_flags &= ~SC_OP_BEACONS;
+	if (sc->cur_beacon_conf.vif == vif)
+		sc->sc_flags &= ~SC_OP_BEACONS;
 }
 
 static void ath9k_vif_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
@@ -1402,11 +1461,12 @@ static void ath9k_calculate_summary_state(struct ieee80211_hw *hw,
 	ath9k_hw_set_interrupts(ah, ah->imask);
 	ath9k_ps_restore(sc);
 
+	sc->cur_beacon_conf.opmode = ah->opmode;
 	/* Set up ANI */
 	if ((iter_data.naps + iter_data.nadhocs) > 0) {
 		sc->sc_flags |= SC_OP_ANI_RUN;
 		ath_start_ani(common);
-	} else {
+	} else if (!sc->cur_beacon_conf.vif) {
 		sc->sc_flags &= ~SC_OP_ANI_RUN;
 		del_timer_sync(&common->ani.timer);
 	}
@@ -1431,9 +1491,10 @@ static void ath9k_do_vif_add_setup(struct ieee80211_hw *hw,
 		ath9k_set_beaconing_status(sc, false);
 		error = ath_beacon_alloc(sc, vif);
 		if (!error)
-			ath_beacon_config(sc, vif);
+			ath_beacon_config(sc);
 		ath9k_set_beaconing_status(sc, true);
 	}
+	ath9k_update_vif_beacon(hw, &sc->cur_beacon_conf);
 }
 
 
@@ -1556,6 +1617,7 @@ static void ath9k_remove_interface(struct ieee80211_hw *hw,
 		ath9k_reclaim_beacon(sc, vif);
 
 	ath9k_calculate_summary_state(hw, NULL);
+	ath9k_update_vif_beacon(hw, &sc->cur_beacon_conf);
 
 	mutex_unlock(&sc->mutex);
 }
@@ -1886,20 +1948,28 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 	mutex_lock(&sc->mutex);
 
 	if (changed & BSS_CHANGED_BSSID) {
-		/* Set BSSID */
-		memcpy(common->curbssid, bss_conf->bssid, ETH_ALEN);
-		memcpy(avp->bssid, bss_conf->bssid, ETH_ALEN);
-		common->curaid = 0;
-		ath9k_hw_write_associd(ah);
 
-		/* Set aggregation protection mode parameters */
-		sc->config.ath_aggr_prot = 0;
+		if (!common->curaid || (sc->cur_beacon_conf.vif &&
+		    !memcmp(sc->cur_beacon_conf.vif->bss_conf.bssid,
+			    bss_conf->bssid, ETH_ALEN))) {
+			/* Set BSSID */
+			memcpy(common->curbssid, bss_conf->bssid, ETH_ALEN);
+			memcpy(avp->bssid, bss_conf->bssid, ETH_ALEN);
+			ath9k_hw_write_associd(ah);
 
-		ath_dbg(common, ATH_DBG_CONFIG, "BSSID: %pM aid: 0x%x\n",
-			common->curbssid, common->curaid);
+			/* Set aggregation protection mode parameters */
+			sc->config.ath_aggr_prot = 0;
 
+			ath_dbg(common, ATH_DBG_CONFIG,
+				"BSSID: %pM aid: 0x%x\n",
+				common->curbssid, common->curaid);
+		} else {
+			common->curaid = 0;
+			memset(common->curbssid, 0, ETH_ALEN);
+		}
 		/* need to reconfigure the beacon */
-		sc->sc_flags &= ~SC_OP_BEACONS ;
+		if (sc->cur_beacon_conf.vif == vif)
+			sc->sc_flags &= ~SC_OP_BEACONS ;
 	}
 
 	/* Enable transmission of beacons (AP, IBSS, MESH) */
@@ -1908,7 +1978,7 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 		ath9k_set_beaconing_status(sc, false);
 		error = ath_beacon_alloc(sc, vif);
 		if (!error)
-			ath_beacon_config(sc, vif);
+			ath_beacon_config(sc);
 		ath9k_set_beaconing_status(sc, true);
 	}
 
@@ -1933,7 +2003,8 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 
 	/* Disable transmission of beacons */
 	if ((changed & BSS_CHANGED_BEACON_ENABLED) &&
-	    !bss_conf->enable_beacon) {
+	    !bss_conf->enable_beacon &&
+	    ath9k_is_primary_vif(sc, vif)) {
 		ath9k_set_beaconing_status(sc, false);
 		avp->is_bslot_active = false;
 		ath9k_set_beaconing_status(sc, true);
@@ -1950,11 +2021,10 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 			ath9k_set_beaconing_status(sc, false);
 			error = ath_beacon_alloc(sc, vif);
 			if (!error)
-				ath_beacon_config(sc, vif);
+				ath_beacon_config(sc);
 			ath9k_set_beaconing_status(sc, true);
-		} else {
-			ath_beacon_config(sc, vif);
-		}
+		} else if (ath9k_is_primary_vif(sc, vif))
+			ath_beacon_config(sc);
 	}
 
 	if (changed & BSS_CHANGED_ERP_PREAMBLE) {
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index daf171d..a42b0c3 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -576,7 +576,7 @@ static void ath_rx_ps_beacon(struct ath_softc *sc, struct sk_buff *skb)
 		sc->ps_flags &= ~PS_BEACON_SYNC;
 		ath_dbg(common, ATH_DBG_PS,
 			"Reconfigure Beacon timers based on timestamp from the AP\n");
-		ath_beacon_config(sc, NULL);
+		ath_beacon_config(sc);
 	}
 
 	if (ath_beacon_dtim_pending_cab(skb)) {
-- 
1.7.4

