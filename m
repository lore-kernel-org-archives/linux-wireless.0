Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:35769 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316Ab2GIJQZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 05:16:25 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20474.41240.703774.538724@gargle.gargle.HOWL> (sfid-20120709_111629_403141_C2625689)
Date: Mon, 9 Jul 2012 14:45:04 +0530
To: <linux-wireless@vger.kernel.org>
CC: <ath9k-devel@lists.ath9k.org>
Subject: [RFC/WIP 05/11] ath9k: Cleanup beacon logic
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* The beaconing status routine is not required, since in
  multi-VIF cases the HW beacon parameters should not be
  re-configured.

* Remove SC_OP_TSF_RESET - when a beaconing interface comes
  up the first time, the TSF has to be reset.

* Simplify ath9k_allow_beacon_config().

* Handle setting/clearing the SWBA interrupt properly.

* General code cleanup.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h  |   8 +-
 drivers/net/wireless/ath/ath9k/beacon.c | 218 ++++++++++++--------------------
 drivers/net/wireless/ath/ath9k/main.c   |  25 +---
 drivers/net/wireless/ath/ath9k/recv.c   |   2 +-
 4 files changed, 95 insertions(+), 158 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index ea1bd45..18ef8d3 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -386,6 +386,7 @@ struct ath_beacon_config {
 	u16 dtim_period;
 	u16 bmiss_timeout;
 	u8 dtim_count;
+	bool enable_beacon;
 };
 
 struct ath_beacon {
@@ -412,11 +413,13 @@ struct ath_beacon {
 };
 
 void ath_beacon_tasklet(unsigned long data);
-void ath_beacon_config(struct ath_softc *sc, struct ieee80211_vif *vif);
+bool ath9k_allow_beacon_config(struct ath_softc *sc, struct ieee80211_vif *vif);
+void ath9k_beacon_config(struct ath_softc *sc, struct ieee80211_vif *vif,
+			 u32 changed);
 void ath9k_beacon_assign_slot(struct ath_softc *sc, struct ieee80211_vif *vif);
 void ath9k_beacon_remove_slot(struct ath_softc *sc, struct ieee80211_vif *vif);
 int ath_beaconq_config(struct ath_softc *sc);
-void ath_set_beacon(struct ath_softc *sc);
+void ath9k_set_beacon(struct ath_softc *sc);
 void ath9k_set_beaconing_status(struct ath_softc *sc, bool status);
 
 /*******************/
@@ -613,7 +616,6 @@ enum sc_op_flags {
 	SC_OP_INVALID,
 	SC_OP_BEACONS,
 	SC_OP_RXFLUSH,
-	SC_OP_TSF_RESET,
 	SC_OP_ANI_RUN,
 	SC_OP_PRIM_STA_VIF,
 	SC_OP_HW_RESET,
diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index d357002..f295116 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -315,7 +315,6 @@ void ath_beacon_tasklet(unsigned long data)
 		} else if (sc->beacon.bmisscnt >= BSTUCK_THRESH) {
 			ath_dbg(common, BSTUCK, "beacon is officially stuck\n");
 			sc->beacon.bmisscnt = 0;
-			set_bit(SC_OP_TSF_RESET, &sc->sc_flags);
 			ieee80211_queue_work(sc->hw, &sc->hw_reset_work);
 		}
 
@@ -401,21 +400,16 @@ void ath_beacon_tasklet(unsigned long data)
 	}
 }
 
-static void ath9k_beacon_init(struct ath_softc *sc,
-			      u32 next_beacon,
-			      u32 beacon_period)
+static void ath9k_beacon_init(struct ath_softc *sc, u32 nexttbtt, u32 intval)
 {
-	if (test_bit(SC_OP_TSF_RESET, &sc->sc_flags)) {
-		ath9k_ps_wakeup(sc);
-		ath9k_hw_reset_tsf(sc->sc_ah);
-	}
-
-	ath9k_hw_beaconinit(sc->sc_ah, next_beacon, beacon_period);
+	struct ath_hw *ah = sc->sc_ah;
 
-	if (test_bit(SC_OP_TSF_RESET, &sc->sc_flags)) {
-		ath9k_ps_restore(sc);
-		clear_bit(SC_OP_TSF_RESET, &sc->sc_flags);
-	}
+	ath9k_hw_disable_interrupts(ah);
+	ath9k_hw_reset_tsf(ah);
+	ath9k_hw_beaconinit(ah, nexttbtt, intval);
+	sc->beacon.bmisscnt = 0;
+	ath9k_hw_set_interrupts(ah);
+	ath9k_hw_enable_interrupts(ah);
 }
 
 /*
@@ -423,32 +417,28 @@ static void ath9k_beacon_init(struct ath_softc *sc,
  * burst together.  For the former arrange for the SWBA to be delivered for each
  * slot. Slots that are not occupied will generate nothing.
  */
-static void ath_beacon_config_ap(struct ath_softc *sc,
-				 struct ath_beacon_config *conf)
+static void ath9k_beacon_config_ap(struct ath_softc *sc,
+				   struct ath_beacon_config *conf)
 {
 	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
 	u32 nexttbtt, intval;
 
 	/* NB: the beacon interval is kept internally in TU's */
 	intval = TU_TO_USEC(conf->beacon_interval);
-	intval /= ATH_BCBUF;    /* for staggered beacons */
+	intval /= ATH_BCBUF;
 	nexttbtt = intval;
 
-	/*
-	 * In AP mode we enable the beacon timers and SWBA interrupts to
-	 * prepare beacon frames.
-	 */
-	ah->imask |= ATH9K_INT_SWBA;
-	ath_beaconq_config(sc);
+	if (conf->enable_beacon)
+		ah->imask |= ATH9K_INT_SWBA;
+	else
+		ah->imask &= ~ATH9K_INT_SWBA;
 
-	/* Set the computed AP beacon timers */
+	ath_dbg(common, BEACON, "AP nexttbtt: %u intval: %u conf_intval: %u\n",
+		nexttbtt, intval, conf->beacon_interval);
 
-	ath9k_hw_disable_interrupts(ah);
-	set_bit(SC_OP_TSF_RESET, &sc->sc_flags);
+	ath_beaconq_config(sc);
 	ath9k_beacon_init(sc, nexttbtt, intval);
-	sc->beacon.bmisscnt = 0;
-	ath9k_hw_set_interrupts(ah);
-	ath9k_hw_enable_interrupts(ah);
 }
 
 /*
@@ -459,8 +449,8 @@ static void ath_beacon_config_ap(struct ath_softc *sc,
  * we'll receive a BMISS interrupt when we stop seeing beacons from the AP
  * we've associated with.
  */
-static void ath_beacon_config_sta(struct ath_softc *sc,
-				  struct ath_beacon_config *conf)
+static void ath9k_beacon_config_sta(struct ath_softc *sc,
+				    struct ath_beacon_config *conf)
 {
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
@@ -579,8 +569,8 @@ static void ath_beacon_config_sta(struct ath_softc *sc,
 	ath9k_hw_enable_interrupts(ah);
 }
 
-static void ath_beacon_config_adhoc(struct ath_softc *sc,
-				    struct ath_beacon_config *conf)
+static void ath9k_beacon_config_adhoc(struct ath_softc *sc,
+				      struct ath_beacon_config *conf)
 {
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
@@ -594,82 +584,54 @@ static void ath_beacon_config_adhoc(struct ath_softc *sc,
 	tsf = roundup(ath9k_hw_gettsf32(ah) + TU_TO_USEC(FUDGE), intval);
 	nexttbtt = tsf + intval;
 
-	ath_dbg(common, BEACON, "IBSS nexttbtt %u intval %u (%u)\n",
-		nexttbtt, intval, conf->beacon_interval);
+	if (conf->enable_beacon)
+		ah->imask |= ATH9K_INT_SWBA;
+	else
+		ah->imask &= ~ATH9K_INT_SWBA;
 
-	/*
-	 * In IBSS mode enable the beacon timers but only enable SWBA interrupts
-	 * if we need to manually prepare beacon frames.  Otherwise we use a
-	 * self-linked tx descriptor and let the hardware deal with things.
-	 */
-	ah->imask |= ATH9K_INT_SWBA;
+	ath_dbg(common, BEACON, "IBSS nexttbtt: %u intval: %u conf_intval: %u\n",
+		nexttbtt, intval, conf->beacon_interval);
 
 	ath_beaconq_config(sc);
-
-	/* Set the computed ADHOC beacon timers */
-
-	ath9k_hw_disable_interrupts(ah);
 	ath9k_beacon_init(sc, nexttbtt, intval);
-	sc->beacon.bmisscnt = 0;
-
-	ath9k_hw_set_interrupts(ah);
-	ath9k_hw_enable_interrupts(ah);
 }
 
-static bool ath9k_allow_beacon_config(struct ath_softc *sc,
-				      struct ieee80211_vif *vif)
+bool ath9k_allow_beacon_config(struct ath_softc *sc, struct ieee80211_vif *vif)
 {
-	struct ath_beacon_config *cur_conf = &sc->cur_beacon_conf;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
-	struct ieee80211_bss_conf *bss_conf = &vif->bss_conf;
 	struct ath_vif *avp = (void *)vif->drv_priv;
 
-	/*
-	 * Can not have different beacon interval on multiple
-	 * AP interface case
-	 */
-	if ((sc->sc_ah->opmode == NL80211_IFTYPE_AP) &&
-	    (sc->nbcnvifs > 1) &&
-	    (vif->type == NL80211_IFTYPE_AP) &&
-	    (cur_conf->beacon_interval != bss_conf->beacon_int)) {
-		ath_dbg(common, CONFIG,
-			"Changing beacon interval of multiple AP interfaces !\n");
-		return false;
-	}
-	/*
-	 * Can not configure station vif's beacon config
-	 * while on AP opmode
-	 */
-	if ((sc->sc_ah->opmode == NL80211_IFTYPE_AP) &&
-	    (vif->type != NL80211_IFTYPE_AP)) {
-		ath_dbg(common, CONFIG,
-			"STA vif's beacon not allowed on AP mode\n");
-		return false;
+	if (sc->sc_ah->opmode == NL80211_IFTYPE_AP) {
+		if ((vif->type != NL80211_IFTYPE_AP) ||
+		    (sc->nbcnvifs > 1)) {
+			ath_dbg(common, CONFIG,
+				"An AP interface is already present !\n");
+			return false;
+		}
 	}
-	/*
-	 * Do not allow beacon config if HW was already configured
-	 * with another STA vif
-	 */
-	if ((sc->sc_ah->opmode == NL80211_IFTYPE_STATION) &&
-	    (vif->type == NL80211_IFTYPE_STATION) &&
-	    test_bit(SC_OP_BEACONS, &sc->sc_flags) &&
-	    !avp->primary_sta_vif) {
-		ath_dbg(common, CONFIG,
-			"Beacon already configured for a station interface\n");
-		return false;
+
+	if (sc->sc_ah->opmode == NL80211_IFTYPE_STATION) {
+		if ((vif->type == NL80211_IFTYPE_STATION) &&
+		    test_bit(SC_OP_BEACONS, &sc->sc_flags) &&
+		    !avp->primary_sta_vif) {
+			ath_dbg(common, CONFIG,
+				"Beacon already configured for a station interface\n");
+			return false;
+		}
 	}
+
 	return true;
 }
 
-void ath_beacon_config(struct ath_softc *sc, struct ieee80211_vif *vif)
+static void ath9k_cache_beacon_config(struct ath_softc *sc,
+				      struct ieee80211_bss_conf *bss_conf)
 {
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_beacon_config *cur_conf = &sc->cur_beacon_conf;
-	struct ieee80211_bss_conf *bss_conf = &vif->bss_conf;
 
-	if (!ath9k_allow_beacon_config(sc, vif))
-		return;
+	ath_dbg(common, BEACON,
+		"Caching beacon data for BSS: %pM\n", bss_conf->bssid);
 
-	/* Setup the beacon configuration parameters */
 	cur_conf->beacon_interval = bss_conf->beacon_int;
 	cur_conf->dtim_period = bss_conf->dtim_period;
 	cur_conf->listen_interval = 1;
@@ -694,73 +656,59 @@ void ath_beacon_config(struct ath_softc *sc, struct ieee80211_vif *vif)
 	if (cur_conf->dtim_period == 0)
 		cur_conf->dtim_period = 1;
 
-	ath_set_beacon(sc);
 }
 
-static bool ath_has_valid_bslot(struct ath_softc *sc)
+void ath9k_beacon_config(struct ath_softc *sc, struct ieee80211_vif *vif,
+			 u32 changed)
 {
-	struct ath_vif *avp;
-	int slot;
-	bool found = false;
+	struct ieee80211_bss_conf *bss_conf = &vif->bss_conf;
+	struct ath_beacon_config *cur_conf = &sc->cur_beacon_conf;
 
-	for (slot = 0; slot < ATH_BCBUF; slot++) {
-		if (sc->beacon.bslot[slot]) {
-			avp = (void *)sc->beacon.bslot[slot]->drv_priv;
-			if (avp->is_bslot_active) {
-				found = true;
-				break;
-			}
+	ath9k_cache_beacon_config(sc, bss_conf);
+
+	if (sc->sc_ah->opmode == NL80211_IFTYPE_STATION) {
+		ath9k_set_beacon(sc);
+		set_bit(SC_OP_BEACONS, &sc->sc_flags);
+	} else {
+		/*
+		 * Take care of multiple interfaces when
+		 * enabling/disabling SWBA.
+		 */
+		if (changed & BSS_CHANGED_BEACON_ENABLED) {
+			if (!bss_conf->enable_beacon &&
+			    (sc->nbcnvifs <= 1))
+				cur_conf->enable_beacon = false;
+			else if (bss_conf->enable_beacon)
+				cur_conf->enable_beacon = true;
 		}
+
+		ath9k_set_beacon(sc);
+
+		if (cur_conf->enable_beacon)
+			set_bit(SC_OP_BEACONS, &sc->sc_flags);
+		else
+			clear_bit(SC_OP_BEACONS, &sc->sc_flags);
 	}
-	return found;
 }
 
-
-void ath_set_beacon(struct ath_softc *sc)
+void ath9k_set_beacon(struct ath_softc *sc)
 {
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_beacon_config *cur_conf = &sc->cur_beacon_conf;
 
 	switch (sc->sc_ah->opmode) {
 	case NL80211_IFTYPE_AP:
-		if (ath_has_valid_bslot(sc))
-			ath_beacon_config_ap(sc, cur_conf);
+		ath9k_beacon_config_ap(sc, cur_conf);
 		break;
 	case NL80211_IFTYPE_ADHOC:
 	case NL80211_IFTYPE_MESH_POINT:
-		ath_beacon_config_adhoc(sc, cur_conf);
+		ath9k_beacon_config_adhoc(sc, cur_conf);
 		break;
 	case NL80211_IFTYPE_STATION:
-		ath_beacon_config_sta(sc, cur_conf);
+		ath9k_beacon_config_sta(sc, cur_conf);
 		break;
 	default:
 		ath_dbg(common, CONFIG, "Unsupported beaconing mode\n");
 		return;
 	}
-
-	set_bit(SC_OP_BEACONS, &sc->sc_flags);
-}
-
-void ath9k_set_beaconing_status(struct ath_softc *sc, bool status)
-{
-	struct ath_hw *ah = sc->sc_ah;
-
-	if (!ath_has_valid_bslot(sc)) {
-		clear_bit(SC_OP_BEACONS, &sc->sc_flags);
-		return;
-	}
-
-	ath9k_ps_wakeup(sc);
-	if (status) {
-		/* Re-enable beaconing */
-		ah->imask |= ATH9K_INT_SWBA;
-		ath9k_hw_set_interrupts(ah);
-	} else {
-		/* Disable SWBA interrupt */
-		ah->imask &= ~ATH9K_INT_SWBA;
-		ath9k_hw_set_interrupts(ah);
-		tasklet_kill(&sc->bcon_tasklet);
-		ath9k_hw_stop_dma_queue(ah, sc->beacon.beaconq);
-	}
-	ath9k_ps_restore(sc);
 }
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index f5ee884..e8bae97 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -236,7 +236,7 @@ static bool ath_complete_reset(struct ath_softc *sc, bool start)
 		if (!test_bit(SC_OP_BEACONS, &sc->sc_flags))
 			goto work;
 
-		ath_set_beacon(sc);
+		ath9k_set_beacon(sc);
 
 		if (ah->opmode == NL80211_IFTYPE_STATION &&
 		    test_bit(SC_OP_PRIM_STA_VIF, &sc->sc_flags)) {
@@ -1507,24 +1507,11 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 		}
 	}
 
-	/*
-	 * In case of AP mode, the HW TSF has to be reset
-	 * when the beacon interval changes.
-	 */
-	if ((changed & BSS_CHANGED_BEACON_INT) &&
-	    (vif->type == NL80211_IFTYPE_AP))
-		set_bit(SC_OP_TSF_RESET, &sc->sc_flags);
-
-	/* Configure beaconing (AP, IBSS, MESH) */
-	if (ath9k_uses_beacons(vif->type) &&
-	    ((changed & BSS_CHANGED_BEACON) ||
-	     (changed & BSS_CHANGED_BEACON_ENABLED) ||
-	     (changed & BSS_CHANGED_BEACON_INT))) {
-		ath9k_set_beaconing_status(sc, false);
-		if (!bss_conf->enable_beacon)
-			avp->is_bslot_active = false;
-		ath_beacon_config(sc, vif);
-		ath9k_set_beaconing_status(sc, true);
+	if ((changed & BSS_CHANGED_BEACON) ||
+	    (changed & BSS_CHANGED_BEACON_ENABLED) ||
+	    (changed & BSS_CHANGED_BEACON_INT)) {
+		if (ath9k_allow_beacon_config(sc, vif))
+			ath9k_beacon_config(sc, vif, changed);
 	}
 
 	if (changed & BSS_CHANGED_ERP_SLOT) {
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 11f3703..12aca02 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -553,7 +553,7 @@ static void ath_rx_ps_beacon(struct ath_softc *sc, struct sk_buff *skb)
 		sc->ps_flags &= ~PS_BEACON_SYNC;
 		ath_dbg(common, PS,
 			"Reconfigure Beacon timers based on timestamp from the AP\n");
-		ath_set_beacon(sc);
+		ath9k_set_beacon(sc);
 	}
 
 	if (ath_beacon_dtim_pending_cab(skb)) {
-- 
1.7.11.1

