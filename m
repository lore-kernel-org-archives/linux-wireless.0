Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:59052 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935737Ab1ETMWn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 May 2011 08:22:43 -0400
Received: from mail.atheros.com ([10.234.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 20 May 2011 05:22:13 -0700
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH 3/6] ath9k: Handle IBSS status changes in BSS_CHANGED_IBSS
Date: Fri, 20 May 2011 17:52:12 +0530
Message-ID: <1305894135-14036-3-git-send-email-rmanoharan@atheros.com> (sfid-20110520_142246_780624_15980B93)
In-Reply-To: <1305894135-14036-1-git-send-email-rmanoharan@atheros.com>
References: <1305894135-14036-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Configure ibss node's bss_changes under BSS_CHANGED_IBSS.
And also start/stop ani timer only if the station join/leave
the group.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |   85 +++++++++++++++++----------------
 1 files changed, 44 insertions(+), 41 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 2ca351f..81708ed 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1412,7 +1412,7 @@ static void ath9k_calculate_summary_state(struct ieee80211_hw *hw,
 	ath9k_hw_set_interrupts(ah, ah->imask);
 
 	/* Set up ANI */
-	if ((iter_data.naps + iter_data.nadhocs) > 0) {
+	if (iter_data.naps > 0) {
 		sc->sc_ah->stats.avgbrssi = ATH_RSSI_DUMMY_MARKER;
 		sc->sc_flags |= SC_OP_ANI_RUN;
 		ath_start_ani(common);
@@ -1952,50 +1952,35 @@ static void ath9k_bss_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
 	struct ieee80211_bss_conf *bss_conf = &vif->bss_conf;
 	struct ath_vif *avp = (void *)vif->drv_priv;
 
-	switch (sc->sc_ah->opmode) {
-	case NL80211_IFTYPE_ADHOC:
-		/* There can be only one vif available */
+	/*
+	 * Skip iteration if primary station vif's bss info
+	 * was not changed
+	 */
+	if (sc->sc_flags & SC_OP_PRIM_STA_VIF)
+		return;
+
+	if (bss_conf->assoc) {
+		sc->sc_flags |= SC_OP_PRIM_STA_VIF;
+		avp->primary_sta_vif = true;
 		memcpy(common->curbssid, bss_conf->bssid, ETH_ALEN);
 		common->curaid = bss_conf->aid;
 		ath9k_hw_write_associd(sc->sc_ah);
-		/* configure beacon */
-		if (bss_conf->enable_beacon)
-			ath_beacon_config(sc, vif);
-		break;
-	case NL80211_IFTYPE_STATION:
-		/*
-		 * Skip iteration if primary station vif's bss info
-		 * was not changed
-		 */
-		if (sc->sc_flags & SC_OP_PRIM_STA_VIF)
-			break;
-
-		if (bss_conf->assoc) {
-			sc->sc_flags |= SC_OP_PRIM_STA_VIF;
-			avp->primary_sta_vif = true;
-			memcpy(common->curbssid, bss_conf->bssid, ETH_ALEN);
-			common->curaid = bss_conf->aid;
-			ath9k_hw_write_associd(sc->sc_ah);
-			ath_dbg(common, ATH_DBG_CONFIG,
+		ath_dbg(common, ATH_DBG_CONFIG,
 				"Bss Info ASSOC %d, bssid: %pM\n",
 				bss_conf->aid, common->curbssid);
-			ath_beacon_config(sc, vif);
-			/*
-			 * Request a re-configuration of Beacon related timers
-			 * on the receipt of the first Beacon frame (i.e.,
-			 * after time sync with the AP).
-			 */
-			sc->ps_flags |= PS_BEACON_SYNC | PS_WAIT_FOR_BEACON;
-			/* Reset rssi stats */
-			sc->last_rssi = ATH_RSSI_DUMMY_MARKER;
-			sc->sc_ah->stats.avgbrssi = ATH_RSSI_DUMMY_MARKER;
+		ath_beacon_config(sc, vif);
+		/*
+		 * Request a re-configuration of Beacon related timers
+		 * on the receipt of the first Beacon frame (i.e.,
+		 * after time sync with the AP).
+		 */
+		sc->ps_flags |= PS_BEACON_SYNC | PS_WAIT_FOR_BEACON;
+		/* Reset rssi stats */
+		sc->last_rssi = ATH_RSSI_DUMMY_MARKER;
+		sc->sc_ah->stats.avgbrssi = ATH_RSSI_DUMMY_MARKER;
 
-			sc->sc_flags |= SC_OP_ANI_RUN;
-			ath_start_ani(common);
-		}
-		break;
-	default:
-		break;
+		sc->sc_flags |= SC_OP_ANI_RUN;
+		ath_start_ani(common);
 	}
 }
 
@@ -2005,6 +1990,9 @@ static void ath9k_config_bss(struct ath_softc *sc, struct ieee80211_vif *vif)
 	struct ieee80211_bss_conf *bss_conf = &vif->bss_conf;
 	struct ath_vif *avp = (void *)vif->drv_priv;
 
+	if (sc->sc_ah->opmode != NL80211_IFTYPE_STATION)
+		return;
+
 	/* Reconfigure bss info */
 	if (avp->primary_sta_vif && !bss_conf->assoc) {
 		ath_dbg(common, ATH_DBG_CONFIG,
@@ -2023,8 +2011,7 @@ static void ath9k_config_bss(struct ath_softc *sc, struct ieee80211_vif *vif)
 	 * None of station vifs are associated.
 	 * Clear bssid & aid
 	 */
-	if ((sc->sc_ah->opmode == NL80211_IFTYPE_STATION) &&
-	    !(sc->sc_flags & SC_OP_PRIM_STA_VIF)) {
+	if (!(sc->sc_flags & SC_OP_PRIM_STA_VIF)) {
 		ath9k_hw_write_associd(sc->sc_ah);
 		/* Stop ANI */
 		sc->sc_flags &= ~SC_OP_ANI_RUN;
@@ -2054,6 +2041,22 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 			common->curbssid, common->curaid);
 	}
 
+	if (changed & BSS_CHANGED_IBSS) {
+		/* There can be only one vif available */
+		memcpy(common->curbssid, bss_conf->bssid, ETH_ALEN);
+		common->curaid = bss_conf->aid;
+		ath9k_hw_write_associd(sc->sc_ah);
+
+		if (bss_conf->ibss_joined) {
+			sc->sc_ah->stats.avgbrssi = ATH_RSSI_DUMMY_MARKER;
+			sc->sc_flags |= SC_OP_ANI_RUN;
+			ath_start_ani(common);
+		} else {
+			sc->sc_flags &= ~SC_OP_ANI_RUN;
+			del_timer_sync(&common->ani.timer);
+		}
+	}
+
 	/* Enable transmission of beacons (AP, IBSS, MESH) */
 	if ((changed & BSS_CHANGED_BEACON) ||
 	    ((changed & BSS_CHANGED_BEACON_ENABLED) && bss_conf->enable_beacon)) {
-- 
1.7.5.1

