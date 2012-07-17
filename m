Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:14565 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000Ab2GQLrV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jul 2012 07:47:21 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20485.20590.137366.956003@gargle.gargle.HOWL> (sfid-20120717_134723_919098_272BE3D1)
Date: Tue, 17 Jul 2012 17:15:50 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 04/12] ath9k: Simplify ASSOC handling
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup the messy logic dealing with station association
and disassociation.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/beacon.c |   2 +-
 drivers/net/wireless/ath/ath9k/main.c   | 118 +++++++++++++-------------------
 2 files changed, 49 insertions(+), 71 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index d357002..351ded5 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -472,7 +472,7 @@ static void ath_beacon_config_sta(struct ath_softc *sc,
 	int num_beacons, offset, dtim_dec_count, cfp_dec_count;
 
 	/* No need to configure beacon if we are not associated */
-	if (!common->curaid) {
+	if (!test_bit(SC_OP_PRIM_STA_VIF, &sc->sc_flags)) {
 		ath_dbg(common, BEACON,
 			"STA is not yet associated..skipping beacon config\n");
 		return;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index d4060ec..80348d8 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1430,86 +1430,53 @@ static int ath9k_set_key(struct ieee80211_hw *hw,
 
 	return ret;
 }
-static void ath9k_bss_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
+
+static void ath9k_set_assoc_state(struct ath_softc *sc,
+				  struct ieee80211_vif *vif)
 {
-	struct ath_softc *sc = data;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
-	struct ieee80211_bss_conf *bss_conf = &vif->bss_conf;
 	struct ath_vif *avp = (void *)vif->drv_priv;
+	struct ieee80211_bss_conf *bss_conf = &vif->bss_conf;
 	unsigned long flags;
+
+	set_bit(SC_OP_PRIM_STA_VIF, &sc->sc_flags);
+	avp->primary_sta_vif = true;
+
 	/*
-	 * Skip iteration if primary station vif's bss info
-	 * was not changed
+	 * Set the AID, BSSID and do beacon-sync only when
+	 * the HW opmode is STATION.
+	 *
+	 * But the primary bit is set above in any case.
 	 */
-	if (test_bit(SC_OP_PRIM_STA_VIF, &sc->sc_flags))
+	if (sc->sc_ah->opmode != NL80211_IFTYPE_STATION)
 		return;
 
-	if (bss_conf->assoc) {
-		set_bit(SC_OP_PRIM_STA_VIF, &sc->sc_flags);
-		avp->primary_sta_vif = true;
-		memcpy(common->curbssid, bss_conf->bssid, ETH_ALEN);
-		common->curaid = bss_conf->aid;
-		ath9k_hw_write_associd(sc->sc_ah);
-		ath_dbg(common, CONFIG, "Bss Info ASSOC %d, bssid: %pM\n",
-			bss_conf->aid, common->curbssid);
-		ath_beacon_config(sc, vif);
-		/*
-		 * Request a re-configuration of Beacon related timers
-		 * on the receipt of the first Beacon frame (i.e.,
-		 * after time sync with the AP).
-		 */
-		spin_lock_irqsave(&sc->sc_pm_lock, flags);
-		sc->ps_flags |= PS_BEACON_SYNC | PS_WAIT_FOR_BEACON;
-		spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
-
-		/* Reset rssi stats */
-		sc->last_rssi = ATH_RSSI_DUMMY_MARKER;
-		sc->sc_ah->stats.avgbrssi = ATH_RSSI_DUMMY_MARKER;
+	memcpy(common->curbssid, bss_conf->bssid, ETH_ALEN);
+	common->curaid = bss_conf->aid;
+	ath9k_hw_write_associd(sc->sc_ah);
 
-		ath_start_rx_poll(sc, 3);
+	sc->last_rssi = ATH_RSSI_DUMMY_MARKER;
+	sc->sc_ah->stats.avgbrssi = ATH_RSSI_DUMMY_MARKER;
 
-		if (!common->disable_ani) {
-			set_bit(SC_OP_ANI_RUN, &sc->sc_flags);
-			ath_start_ani(common);
-		}
+	spin_lock_irqsave(&sc->sc_pm_lock, flags);
+	sc->ps_flags |= PS_BEACON_SYNC | PS_WAIT_FOR_BEACON;
+	spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
 
-	}
+	ath_dbg(common, CONFIG,
+		"Primary Station interface: %pM, BSSID: %pM\n",
+		vif->addr, common->curbssid);
 }
 
-static void ath9k_config_bss(struct ath_softc *sc, struct ieee80211_vif *vif)
+static void ath9k_bss_assoc_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
 {
-	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	struct ath_softc *sc = data;
 	struct ieee80211_bss_conf *bss_conf = &vif->bss_conf;
-	struct ath_vif *avp = (void *)vif->drv_priv;
 
-	if (sc->sc_ah->opmode != NL80211_IFTYPE_STATION)
+	if (test_bit(SC_OP_PRIM_STA_VIF, &sc->sc_flags))
 		return;
 
-	/* Reconfigure bss info */
-	if (avp->primary_sta_vif && !bss_conf->assoc) {
-		ath_dbg(common, CONFIG, "Bss Info DISASSOC %d, bssid %pM\n",
-			common->curaid, common->curbssid);
-		clear_bit(SC_OP_PRIM_STA_VIF, &sc->sc_flags);
-		clear_bit(SC_OP_BEACONS, &sc->sc_flags);
-		avp->primary_sta_vif = false;
-		memset(common->curbssid, 0, ETH_ALEN);
-		common->curaid = 0;
-	}
-
-	ieee80211_iterate_active_interfaces_atomic(
-			sc->hw, ath9k_bss_iter, sc);
-
-	/*
-	 * None of station vifs are associated.
-	 * Clear bssid & aid
-	 */
-	if (!test_bit(SC_OP_PRIM_STA_VIF, &sc->sc_flags)) {
-		ath9k_hw_write_associd(sc->sc_ah);
-		clear_bit(SC_OP_ANI_RUN, &sc->sc_flags);
-		del_timer_sync(&common->ani.timer);
-		del_timer_sync(&sc->rx_poll_timer);
-		memset(&sc->caldata, 0, sizeof(sc->caldata));
-	}
+	if (bss_conf->assoc)
+		ath9k_set_assoc_state(sc, vif);
 }
 
 static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
@@ -1527,30 +1494,41 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 	mutex_lock(&sc->mutex);
 
 	if (changed & BSS_CHANGED_ASSOC) {
-		ath9k_config_bss(sc, vif);
+		ath_dbg(common, CONFIG, "BSSID %pM Changed ASSOC %d\n",
+			bss_conf->bssid, bss_conf->assoc);
+
+		if (avp->primary_sta_vif && !bss_conf->assoc) {
+			clear_bit(SC_OP_PRIM_STA_VIF, &sc->sc_flags);
+			avp->primary_sta_vif = false;
+
+			if (ah->opmode == NL80211_IFTYPE_STATION)
+				clear_bit(SC_OP_BEACONS, &sc->sc_flags);
+		}
+
+		ieee80211_iterate_active_interfaces_atomic(sc->hw,
+						   ath9k_bss_assoc_iter, sc);
 
-		ath_dbg(common, CONFIG, "BSSID: %pM aid: 0x%x\n",
-			common->curbssid, common->curaid);
+		if (!test_bit(SC_OP_PRIM_STA_VIF, &sc->sc_flags) &&
+		    ah->opmode == NL80211_IFTYPE_STATION) {
+			memset(common->curbssid, 0, ETH_ALEN);
+			common->curaid = 0;
+			ath9k_hw_write_associd(sc->sc_ah);
+		}
 	}
 
 	if (changed & BSS_CHANGED_IBSS) {
-		/* There can be only one vif available */
 		memcpy(common->curbssid, bss_conf->bssid, ETH_ALEN);
 		common->curaid = bss_conf->aid;
 		ath9k_hw_write_associd(sc->sc_ah);
 
 		if (bss_conf->ibss_joined) {
-			sc->sc_ah->stats.avgbrssi = ATH_RSSI_DUMMY_MARKER;
-
 			if (!common->disable_ani) {
 				set_bit(SC_OP_ANI_RUN, &sc->sc_flags);
 				ath_start_ani(common);
 			}
-
 		} else {
 			clear_bit(SC_OP_ANI_RUN, &sc->sc_flags);
 			del_timer_sync(&common->ani.timer);
-			del_timer_sync(&sc->rx_poll_timer);
 		}
 	}
 
-- 
1.7.11.2

