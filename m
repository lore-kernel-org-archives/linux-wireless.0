Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:33941 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808Ab2DSNnD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Apr 2012 09:43:03 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 1/2] ath9k: simplify beacon configuration for beaconing vifs
Date: Thu, 19 Apr 2012 19:13:51 +0530
Message-ID: <1334843032-14544-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120419_154308_752754_3A828822)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As of now beacon configuration is being called multiple times
in bss info change notification. This patch avoids multiple
configuration and make it simpler.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/beacon.c |    4 +-
 drivers/net/wireless/ath/ath9k/main.c   |   62 ++++++++++---------------------
 2 files changed, 23 insertions(+), 43 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 702e5ab..11bc55e 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -817,8 +817,10 @@ void ath9k_set_beaconing_status(struct ath_softc *sc, bool status)
 {
 	struct ath_hw *ah = sc->sc_ah;
 
-	if (!ath_has_valid_bslot(sc))
+	if (!ath_has_valid_bslot(sc)) {
+		sc->sc_flags &= ~SC_OP_BEACONS;
 		return;
+	}
 
 	ath9k_ps_wakeup(sc);
 	if (status) {
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index d0a4b9b..e4bc14b 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1245,7 +1245,6 @@ static void ath9k_reclaim_beacon(struct ath_softc *sc,
 	ath9k_set_beaconing_status(sc, false);
 	ath_beacon_return(sc, avp);
 	ath9k_set_beaconing_status(sc, true);
-	sc->sc_flags &= ~SC_OP_BEACONS;
 }
 
 static void ath9k_vif_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
@@ -1376,17 +1375,9 @@ static void ath9k_do_vif_add_setup(struct ieee80211_hw *hw,
 	ath9k_calculate_summary_state(hw, vif);
 
 	if (ath9k_uses_beacons(vif->type)) {
-		int error;
-		/* This may fail because upper levels do not have beacons
-		 * properly configured yet.  That's OK, we assume it
-		 * will be properly configured and then we will be notified
-		 * in the info_changed method and set up beacons properly
-		 * there.
-		 */
+		/* Reserve a beacon slot for the vif */
 		ath9k_set_beaconing_status(sc, false);
-		error = ath_beacon_alloc(sc, vif);
-		if (!error)
-			ath_beacon_config(sc, vif);
+		ath_beacon_alloc(sc, vif);
 		ath9k_set_beaconing_status(sc, true);
 	}
 }
@@ -1993,7 +1984,6 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath_vif *avp = (void *)vif->drv_priv;
 	int slottime;
-	int error;
 
 	ath9k_ps_wakeup(sc);
 	mutex_lock(&sc->mutex);
@@ -2026,13 +2016,25 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 		}
 	}
 
-	/* Enable transmission of beacons (AP, IBSS, MESH) */
-	if ((changed & BSS_CHANGED_BEACON) ||
-	    ((changed & BSS_CHANGED_BEACON_ENABLED) && bss_conf->enable_beacon)) {
+	/*
+	 * In case of AP mode, the HW TSF has to be reset
+	 * when the beacon interval changes.
+	 */
+	if ((changed & BSS_CHANGED_BEACON_INT) &&
+	    (vif->type == NL80211_IFTYPE_AP))
+		sc->sc_flags |= SC_OP_TSF_RESET;
+
+	/* Configure beaconing (AP, IBSS, MESH) */
+	if (ath9k_uses_beacons(vif->type) &&
+	    ((changed & BSS_CHANGED_BEACON) ||
+	     (changed & BSS_CHANGED_BEACON_ENABLED) ||
+	     (changed & BSS_CHANGED_BEACON_INT))) {
 		ath9k_set_beaconing_status(sc, false);
-		error = ath_beacon_alloc(sc, vif);
-		if (!error)
-			ath_beacon_config(sc, vif);
+		if (bss_conf->enable_beacon)
+			ath_beacon_alloc(sc, vif);
+		else
+			avp->is_bslot_active = false;
+		ath_beacon_config(sc, vif);
 		ath9k_set_beaconing_status(sc, true);
 	}
 
@@ -2055,30 +2057,6 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 		}
 	}
 
-	/* Disable transmission of beacons */
-	if ((changed & BSS_CHANGED_BEACON_ENABLED) &&
-	    !bss_conf->enable_beacon) {
-		ath9k_set_beaconing_status(sc, false);
-		avp->is_bslot_active = false;
-		ath9k_set_beaconing_status(sc, true);
-	}
-
-	if (changed & BSS_CHANGED_BEACON_INT) {
-		/*
-		 * In case of AP mode, the HW TSF has to be reset
-		 * when the beacon interval changes.
-		 */
-		if (vif->type == NL80211_IFTYPE_AP) {
-			sc->sc_flags |= SC_OP_TSF_RESET;
-			ath9k_set_beaconing_status(sc, false);
-			error = ath_beacon_alloc(sc, vif);
-			if (!error)
-				ath_beacon_config(sc, vif);
-			ath9k_set_beaconing_status(sc, true);
-		} else
-			ath_beacon_config(sc, vif);
-	}
-
 	mutex_unlock(&sc->mutex);
 	ath9k_ps_restore(sc);
 }
-- 
1.7.10

