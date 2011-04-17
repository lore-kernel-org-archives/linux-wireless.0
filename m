Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:57094 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754440Ab1DQQIQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Apr 2011 12:08:16 -0400
Received: from mail.atheros.com ([10.234.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 17 Apr 2011 09:07:50 -0700
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH] ath9k: Fix beacon generation on foreign channel
Date: Sun, 17 Apr 2011 21:38:10 +0530
Message-ID: <1303056490-6775-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While leaving the oper channel, beacon generation is stopped
by mac80211 and beacon slots are marked as inactive.
During the scan, ath9k configures beacon timers
based on IEEE80211_CONF_OFFCHANNEL which inturn generates
beacon alert even though bslot is inactive.

ath9k fails to disable beacon alert while moving to offchannel
if none of the beacon slot is active. This is causing beacon
transmission on foreign channel. This patch enables swba
based on active bslots.

This issue was reported with two vifs (AP+STA) and triggered
scan in STA vif in unassociated state.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/beacon.c |   36 +++++++++++++++++++------------
 1 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 9193a38..24f565b 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -746,6 +746,25 @@ void ath_beacon_config(struct ath_softc *sc, struct ieee80211_vif *vif)
 	ath_set_beacon(sc);
 }
 
+static bool ath_has_valid_bslot(struct ath_softc *sc)
+{
+	struct ath_vif *avp;
+	int slot;
+	bool found = false;
+
+	for (slot = 0; slot < ATH_BCBUF; slot++) {
+		if (sc->beacon.bslot[slot]) {
+			avp = (void *)sc->beacon.bslot[slot]->drv_priv;
+			if (avp->is_bslot_active) {
+				found = true;
+				break;
+			}
+		}
+	}
+	return found;
+}
+
+
 void ath_set_beacon(struct ath_softc *sc)
 {
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
@@ -753,7 +772,8 @@ void ath_set_beacon(struct ath_softc *sc)
 
 	switch (sc->sc_ah->opmode) {
 	case NL80211_IFTYPE_AP:
-		ath_beacon_config_ap(sc, cur_conf);
+		if (ath_has_valid_bslot(sc))
+			ath_beacon_config_ap(sc, cur_conf);
 		break;
 	case NL80211_IFTYPE_ADHOC:
 	case NL80211_IFTYPE_MESH_POINT:
@@ -780,20 +800,8 @@ void ath_set_beacon(struct ath_softc *sc)
 void ath9k_set_beaconing_status(struct ath_softc *sc, bool status)
 {
 	struct ath_hw *ah = sc->sc_ah;
-	struct ath_vif *avp;
-	int slot;
-	bool found = false;
 
-	for (slot = 0; slot < ATH_BCBUF; slot++) {
-		if (sc->beacon.bslot[slot]) {
-			avp = (void *)sc->beacon.bslot[slot]->drv_priv;
-			if (avp->is_bslot_active) {
-				found = true;
-				break;
-			}
-		}
-	}
-	if (!found)
+	if (!ath_has_valid_bslot(sc))
 		return;
 
 	ath9k_ps_wakeup(sc);
-- 
1.7.4.4

