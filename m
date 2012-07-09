Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:1734 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316Ab2GIJQR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 05:16:17 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20474.41234.26520.832853@gargle.gargle.HOWL> (sfid-20120709_111620_151404_45B268EF)
Date: Mon, 9 Jul 2012 14:44:58 +0530
To: <linux-wireless@vger.kernel.org>
CC: <ath9k-devel@lists.ath9k.org>
Subject: [RFC/WIP 04/11] ath9k: Simplify ASSOC handling
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup the messy logic dealing with station association
and disassociation.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/main.c | 100 +++++++++++-----------------------
 1 file changed, 32 insertions(+), 68 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 2619bd3..f5ee884 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1419,85 +1419,36 @@ static int ath9k_set_key(struct ieee80211_hw *hw,
 
 	return ret;
 }
-static void ath9k_bss_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
+
+static void ath9k_bss_assoc_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
 {
 	struct ath_softc *sc = data;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
-	struct ieee80211_bss_conf *bss_conf = &vif->bss_conf;
 	struct ath_vif *avp = (void *)vif->drv_priv;
+	struct ieee80211_bss_conf *bss_conf = &vif->bss_conf;
 	unsigned long flags;
-	/*
-	 * Skip iteration if primary station vif's bss info
-	 * was not changed
-	 */
+
 	if (test_bit(SC_OP_PRIM_STA_VIF, &sc->sc_flags))
 		return;
 
 	if (bss_conf->assoc) {
 		set_bit(SC_OP_PRIM_STA_VIF, &sc->sc_flags);
 		avp->primary_sta_vif = true;
+
 		memcpy(common->curbssid, bss_conf->bssid, ETH_ALEN);
 		common->curaid = bss_conf->aid;
 		ath9k_hw_write_associd(sc->sc_ah);
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
 
-		/* Reset rssi stats */
 		sc->last_rssi = ATH_RSSI_DUMMY_MARKER;
 		sc->sc_ah->stats.avgbrssi = ATH_RSSI_DUMMY_MARKER;
 
-		ath_start_rx_poll(sc, 3);
-
-		if (!common->disable_ani) {
-			set_bit(SC_OP_ANI_RUN, &sc->sc_flags);
-			ath_start_ani(common);
-		}
-
-	}
-}
-
-static void ath9k_config_bss(struct ath_softc *sc, struct ieee80211_vif *vif)
-{
-	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
-	struct ieee80211_bss_conf *bss_conf = &vif->bss_conf;
-	struct ath_vif *avp = (void *)vif->drv_priv;
-
-	if (sc->sc_ah->opmode != NL80211_IFTYPE_STATION)
-		return;
+		spin_lock_irqsave(&sc->sc_pm_lock, flags);
+		sc->ps_flags |= PS_BEACON_SYNC | PS_WAIT_FOR_BEACON;
+		spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
 
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
+		ath_dbg(common, CONFIG,
+			"Primary Station interface: %pM, BSSID: %pM\n",
+			vif->addr, common->curbssid);
 	}
 }
 
@@ -1516,30 +1467,43 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 	mutex_lock(&sc->mutex);
 
 	if (changed & BSS_CHANGED_ASSOC) {
-		ath9k_config_bss(sc, vif);
+		ath_dbg(common, CONFIG, "BSSID %pM Changed ASSOC %d\n",
+			bss_conf->bssid, bss_conf->assoc);
+
+		/*
+		 * Do not do anything when the opmode is not STATION.
+		 */
+		if (ah->opmode == NL80211_IFTYPE_STATION) {
+			if (avp->primary_sta_vif && !bss_conf->assoc) {
+				clear_bit(SC_OP_PRIM_STA_VIF, &sc->sc_flags);
+				clear_bit(SC_OP_BEACONS, &sc->sc_flags);
+				avp->primary_sta_vif = false;
+			}
 
-		ath_dbg(common, CONFIG, "BSSID: %pM aid: 0x%x\n",
-			common->curbssid, common->curaid);
+			ieee80211_iterate_active_interfaces_atomic(sc->hw,
+						   ath9k_bss_assoc_iter, sc);
+
+			if (!test_bit(SC_OP_PRIM_STA_VIF, &sc->sc_flags)) {
+				memset(common->curbssid, 0, ETH_ALEN);
+				common->curaid = 0;
+				ath9k_hw_write_associd(sc->sc_ah);
+			}
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
1.7.11.1

