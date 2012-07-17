Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:26788 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989Ab2GQLr3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jul 2012 07:47:29 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20485.20609.738827.444626@gargle.gargle.HOWL> (sfid-20120717_134733_075201_6CC256A4)
Date: Tue, 17 Jul 2012 17:16:09 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 07/12] ath9k: Cleanup beacon queue configuration
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
 drivers/net/wireless/ath/ath9k/xmit.c   | 10 ----------
 4 files changed, 4 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 641ca9e..ae3e940 100644
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
index 2962b3e..02fbd3e 100644
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
 
@@ -584,7 +582,6 @@ static void ath9k_beacon_config_adhoc(struct ath_softc *sc,
 	ath_dbg(common, BEACON, "IBSS nexttbtt: %u intval: %u conf_intval: %u\n",
 		nexttbtt, intval, conf->beacon_interval);
 
-	ath_beaconq_config(sc);
 	ath9k_beacon_init(sc, nexttbtt, intval);
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index e58c657..7760dc3 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1358,10 +1358,6 @@ static int ath9k_conf_tx(struct ieee80211_hw *hw,
 	if (ret)
 		ath_err(common, "TXQ Update failed\n");
 
-	if (sc->sc_ah->opmode == NL80211_IFTYPE_ADHOC)
-		if (queue == WME_AC_BE && !ret)
-			ath_beaconq_config(sc);
-
 	mutex_unlock(&sc->mutex);
 	ath9k_ps_restore(sc);
 
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index cafb4a0..6c509b0 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1403,16 +1403,6 @@ int ath_txq_update(struct ath_softc *sc, int qnum,
 	int error = 0;
 	struct ath9k_tx_queue_info qi;
 
-	if (qnum == sc->beacon.beaconq) {
-		/*
-		 * XXX: for beacon queue, we just save the parameter.
-		 * It will be picked up by ath_beaconq_config when
-		 * it's necessary.
-		 */
-		sc->beacon.beacon_qi = *qinfo;
-		return 0;
-	}
-
 	BUG_ON(sc->tx.txq[qnum].axq_qnum != qnum);
 
 	ath9k_hw_get_txq_props(ah, qnum, &qi);
-- 
1.7.11.2

