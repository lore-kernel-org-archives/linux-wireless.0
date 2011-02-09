Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:27517 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753829Ab1BIMSL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 07:18:11 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 09 Feb 2011 04:17:50 -0800
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH 2/2] ath9k: disable beaconing before stopping beacon queue
Date: Wed, 9 Feb 2011 17:46:39 +0530
Message-ID: <1297253799-9688-2-git-send-email-rmanoharan@atheros.com>
In-Reply-To: <1297253799-9688-1-git-send-email-rmanoharan@atheros.com>
References: <1297253799-9688-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Beaconing should be disabled before stopping beacon queue.
Not doing so could queue up beacons in hw that causes
failure to stop Tx DMA, due to pending frames in hw
and also unnecessary beacon tasklet schedule.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h  |    2 +
 drivers/net/wireless/ath/ath9k/beacon.c |   37 ++++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath9k/main.c   |   35 +++++++++++-----------------
 3 files changed, 52 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 9272278..aa9bcff 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -349,6 +349,7 @@ void ath_tx_aggr_resume(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid
 
 struct ath_vif {
 	int av_bslot;
+	bool is_bslot_active;
 	__le64 tsf_adjust; /* TSF adjustment for staggered beacons */
 	enum nl80211_iftype av_opmode;
 	struct ath_buf *av_bcbuf;
@@ -403,6 +404,7 @@ void ath_beacon_config(struct ath_softc *sc, struct ieee80211_vif *vif);
 int ath_beacon_alloc(struct ath_softc *sc, struct ieee80211_vif *vif);
 void ath_beacon_return(struct ath_softc *sc, struct ath_vif *avp);
 int ath_beaconq_config(struct ath_softc *sc);
+void ath9k_set_beaconing_status(struct ath_softc *sc, bool status);
 
 /*******/
 /* ANI */
diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index fcb36ab..8b42546 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -143,7 +143,7 @@ static struct ath_buf *ath_beacon_generate(struct ieee80211_hw *hw,
 	avp = (void *)vif->drv_priv;
 	cabq = sc->beacon.cabq;
 
-	if (avp->av_bcbuf == NULL)
+	if ((avp->av_bcbuf == NULL) || !avp->is_bslot_active)
 		return NULL;
 
 	/* Release the old beacon first */
@@ -248,6 +248,7 @@ int ath_beacon_alloc(struct ath_softc *sc, struct ieee80211_vif *vif)
 			for (slot = 0; slot < ATH_BCBUF; slot++)
 				if (sc->beacon.bslot[slot] == NULL) {
 					avp->av_bslot = slot;
+					avp->is_bslot_active = false;
 
 					/* NB: keep looking for a double slot */
 					if (slot == 0 || !sc->beacon.bslot[slot-1])
@@ -314,6 +315,7 @@ int ath_beacon_alloc(struct ath_softc *sc, struct ieee80211_vif *vif)
 		ath_err(common, "dma_mapping_error on beacon alloc\n");
 		return -ENOMEM;
 	}
+	avp->is_bslot_active = true;
 
 	return 0;
 }
@@ -747,3 +749,36 @@ void ath_beacon_config(struct ath_softc *sc, struct ieee80211_vif *vif)
 
 	sc->sc_flags |= SC_OP_BEACONS;
 }
+
+void ath9k_set_beaconing_status(struct ath_softc *sc, bool status)
+{
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath_vif *avp;
+	int slot;
+	bool found = false;
+
+	ath9k_ps_wakeup(sc);
+	if (status) {
+		for (slot = 0; slot < ATH_BCBUF; slot++) {
+			if (sc->beacon.bslot[slot]) {
+				avp = (void *)sc->beacon.bslot[slot]->drv_priv;
+				if (avp->is_bslot_active) {
+					found = true;
+					break;
+				}
+			}
+		}
+		if (found) {
+			/* Re-enable beaconing */
+			ah->imask |= ATH9K_INT_SWBA;
+			ath9k_hw_set_interrupts(ah, ah->imask);
+		}
+	} else {
+		/* Disable SWBA interrupt */
+		ah->imask &= ~ATH9K_INT_SWBA;
+		ath9k_hw_set_interrupts(ah, ah->imask);
+		tasklet_kill(&sc->bcon_tasklet);
+		ath9k_hw_stoptxdma(ah, sc->beacon.beaconq);
+	}
+	ath9k_ps_restore(sc);
+}
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 4ed43b2..a61ddc3 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1291,24 +1291,10 @@ static void ath9k_reclaim_beacon(struct ath_softc *sc,
 {
 	struct ath_vif *avp = (void *)vif->drv_priv;
 
-	/* Disable SWBA interrupt */
-	sc->sc_ah->imask &= ~ATH9K_INT_SWBA;
-	ath9k_ps_wakeup(sc);
-	ath9k_hw_set_interrupts(sc->sc_ah, sc->sc_ah->imask);
-	ath9k_hw_stoptxdma(sc->sc_ah, sc->beacon.beaconq);
-	tasklet_kill(&sc->bcon_tasklet);
-	ath9k_ps_restore(sc);
-
+	ath9k_set_beaconing_status(sc, false);
 	ath_beacon_return(sc, avp);
+	ath9k_set_beaconing_status(sc, true);
 	sc->sc_flags &= ~SC_OP_BEACONS;
-
-	if (sc->nbcnvifs > 0) {
-		/* Re-enable beaconing */
-		sc->sc_ah->imask |= ATH9K_INT_SWBA;
-		ath9k_ps_wakeup(sc);
-		ath9k_hw_set_interrupts(sc->sc_ah, sc->sc_ah->imask);
-		ath9k_ps_restore(sc);
-	}
 }
 
 static void ath9k_vif_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
@@ -1436,16 +1422,17 @@ static void ath9k_do_vif_add_setup(struct ieee80211_hw *hw,
 
 	if (ath9k_uses_beacons(vif->type)) {
 		int error;
-		ath9k_hw_stoptxdma(sc->sc_ah, sc->beacon.beaconq);
 		/* This may fail because upper levels do not have beacons
 		 * properly configured yet.  That's OK, we assume it
 		 * will be properly configured and then we will be notified
 		 * in the info_changed method and set up beacons properly
 		 * there.
 		 */
+		ath9k_set_beaconing_status(sc, false);
 		error = ath_beacon_alloc(sc, vif);
 		if (!error)
 			ath_beacon_config(sc, vif);
+		ath9k_set_beaconing_status(sc, true);
 	}
 }
 
@@ -1914,10 +1901,11 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 	/* Enable transmission of beacons (AP, IBSS, MESH) */
 	if ((changed & BSS_CHANGED_BEACON) ||
 	    ((changed & BSS_CHANGED_BEACON_ENABLED) && bss_conf->enable_beacon)) {
-		ath9k_hw_stoptxdma(sc->sc_ah, sc->beacon.beaconq);
+		ath9k_set_beaconing_status(sc, false);
 		error = ath_beacon_alloc(sc, vif);
 		if (!error)
 			ath_beacon_config(sc, vif);
+		ath9k_set_beaconing_status(sc, true);
 	}
 
 	if (changed & BSS_CHANGED_ERP_SLOT) {
@@ -1940,8 +1928,12 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 	}
 
 	/* Disable transmission of beacons */
-	if ((changed & BSS_CHANGED_BEACON_ENABLED) && !bss_conf->enable_beacon)
-		ath9k_hw_stoptxdma(sc->sc_ah, sc->beacon.beaconq);
+	if ((changed & BSS_CHANGED_BEACON_ENABLED) &&
+	    !bss_conf->enable_beacon) {
+		ath9k_set_beaconing_status(sc, false);
+		avp->is_bslot_active = false;
+		ath9k_set_beaconing_status(sc, true);
+	}
 
 	if (changed & BSS_CHANGED_BEACON_INT) {
 		sc->beacon_interval = bss_conf->beacon_int;
@@ -1951,10 +1943,11 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 		 */
 		if (vif->type == NL80211_IFTYPE_AP) {
 			sc->sc_flags |= SC_OP_TSF_RESET;
-			ath9k_hw_stoptxdma(sc->sc_ah, sc->beacon.beaconq);
+			ath9k_set_beaconing_status(sc, false);
 			error = ath_beacon_alloc(sc, vif);
 			if (!error)
 				ath_beacon_config(sc, vif);
+			ath9k_set_beaconing_status(sc, true);
 		} else {
 			ath_beacon_config(sc, vif);
 		}
-- 
1.7.4

