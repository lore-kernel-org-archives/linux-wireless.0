Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17783 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316Ab2GIJQi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 05:16:38 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20474.41255.432069.560757@gargle.gargle.HOWL> (sfid-20120709_111642_324374_F786F58B)
Date: Mon, 9 Jul 2012 14:45:19 +0530
To: <linux-wireless@vger.kernel.org>
CC: <ath9k-devel@lists.ath9k.org>
Subject: [RFC/WIP 07/11] ath9k: Cleanup beacon queue configuration
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Setup the beacon queue parameters after disabling
interrupts. Also, remove the redundant call in conf_tx()
for IBSS mode since the queue would be configured
with the appropriate cwmin/cwmax values when beaconing
is enabled.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h  |  1 -
 drivers/net/wireless/ath/ath9k/beacon.c | 11 ++++-------
 drivers/net/wireless/ath/ath9k/main.c   |  4 ----
 3 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 508ba93..c893f2f 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -418,7 +418,6 @@ void ath9k_beacon_config(struct ath_softc *sc, struct ieee80211_vif *vif,
 			 u32 changed);
 void ath9k_beacon_assign_slot(struct ath_softc *sc, struct ieee80211_vif *vif);
 void ath9k_beacon_remove_slot(struct ath_softc *sc, struct ieee80211_vif *vif);
-int ath_beaconq_config(struct ath_softc *sc);
 void ath9k_set_beacon(struct ath_softc *sc);
 void ath9k_set_beaconing_status(struct ath_softc *sc, bool status);
 
diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 926a2f1..b551041 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -30,7 +30,7 @@ static void ath9k_reset_beacon_status(struct ath_softc *sc)
  *  the operating mode of the station (AP or AdHoc).  Parameters are AIFS
  *  settings and channel width min/max
 */
-int ath_beaconq_config(struct ath_softc *sc)
+static void ath9k_beaconq_config(struct ath_softc *sc)
 {
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
@@ -38,6 +38,7 @@ int ath_beaconq_config(struct ath_softc *sc)
 	struct ath_txq *txq;
 
 	ath9k_hw_get_txq_props(ah, sc->beacon.beaconq, &qi);
+
 	if (sc->sc_ah->opmode == NL80211_IFTYPE_AP) {
 		/* Always burst out beacon and CAB traffic. */
 		qi.tqi_aifs = 1;
@@ -56,12 +57,9 @@ int ath_beaconq_config(struct ath_softc *sc)
 	}
 
 	if (!ath9k_hw_set_txq_props(ah, sc->beacon.beaconq, &qi)) {
-		ath_err(common,
-			"Unable to update h/w beacon queue parameters\n");
-		return 0;
+		ath_err(common, "Unable to update h/w beacon queue parameters\n");
 	} else {
 		ath9k_hw_resettxqueue(ah, sc->beacon.beaconq);
-		return 1;
 	}
 }
 
@@ -401,6 +399,7 @@ static void ath9k_beacon_init(struct ath_softc *sc, u32 nexttbtt, u32 intval)
 
 	ath9k_hw_disable_interrupts(ah);
 	ath9k_hw_reset_tsf(ah);
+	ath9k_beaconq_config(sc);
 	ath9k_hw_beaconinit(ah, nexttbtt, intval);
 	sc->beacon.bmisscnt = 0;
 	ath9k_hw_set_interrupts(ah);
@@ -432,7 +431,6 @@ static void ath9k_beacon_config_ap(struct ath_softc *sc,
 	ath_dbg(common, BEACON, "AP nexttbtt: %u intval: %u conf_intval: %u\n",
 		nexttbtt, intval, conf->beacon_interval);
 
-	ath_beaconq_config(sc);
 	ath9k_beacon_init(sc, nexttbtt, intval);
 }
 
@@ -587,7 +585,6 @@ static void ath9k_beacon_config_adhoc(struct ath_softc *sc,
 	ath_dbg(common, BEACON, "IBSS nexttbtt: %u intval: %u conf_intval: %u\n",
 		nexttbtt, intval, conf->beacon_interval);
 
-	ath_beaconq_config(sc);
 	ath9k_beacon_init(sc, nexttbtt, intval);
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 3c2708d..2621ea1 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1347,10 +1347,6 @@ static int ath9k_conf_tx(struct ieee80211_hw *hw,
 	if (ret)
 		ath_err(common, "TXQ Update failed\n");
 
-	if (sc->sc_ah->opmode == NL80211_IFTYPE_ADHOC)
-		if (queue == WME_AC_BE && !ret)
-			ath_beaconq_config(sc);
-
 	mutex_unlock(&sc->mutex);
 	ath9k_ps_restore(sc);
 
-- 
1.7.11.1

