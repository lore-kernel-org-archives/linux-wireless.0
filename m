Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:28040 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752394Ab0LGMMn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 07:12:43 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 07 Dec 2010 04:12:28 -0800
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH 2.6.37 v2 1/2] ath9k: fix beacon resource related race condition
Date: Tue, 7 Dec 2010 17:42:18 +0530
Message-ID: <1291723939-19262-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The beacon tasklet is accesssing the bslot info for beacon generation.
Meanwhile the same slot can be freed on interface deletion.
Current the remove_interface disables the beacon alert after freeing the slot.
This may leads to null pointer access.

This patch disables SWBA and kills the beacon tasklet to prevent access
to the slot to be freed. After releasing the slot, swba will be enabled again
upon the availablity of beaconing interfaces.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
v2: updated commit log

 drivers/net/wireless/ath/ath9k/main.c |   21 +++++++--------------
 1 files changed, 7 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index f026a03..509da8f 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1438,8 +1438,6 @@ static void ath9k_remove_interface(struct ieee80211_hw *hw,
 	struct ath_softc *sc = aphy->sc;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_vif *avp = (void *)vif->drv_priv;
-	bool bs_valid = false;
-	int i;
 
 	ath_print(common, ATH_DBG_CONFIG, "Detach Interface\n");
 
@@ -1453,26 +1451,21 @@ static void ath9k_remove_interface(struct ieee80211_hw *hw,
 	if ((sc->sc_ah->opmode == NL80211_IFTYPE_AP) ||
 	    (sc->sc_ah->opmode == NL80211_IFTYPE_ADHOC) ||
 	    (sc->sc_ah->opmode == NL80211_IFTYPE_MESH_POINT)) {
+		/* Disable SWBA interrupt */
+		sc->sc_ah->imask &= ~ATH9K_INT_SWBA;
 		ath9k_ps_wakeup(sc);
+		ath9k_hw_set_interrupts(sc->sc_ah, sc->sc_ah->imask);
 		ath9k_hw_stoptxdma(sc->sc_ah, sc->beacon.beaconq);
 		ath9k_ps_restore(sc);
+		tasklet_kill(&sc->bcon_tasklet);
 	}
 
 	ath_beacon_return(sc, avp);
 	sc->sc_flags &= ~SC_OP_BEACONS;
 
-	for (i = 0; i < ARRAY_SIZE(sc->beacon.bslot); i++) {
-		if (sc->beacon.bslot[i] == vif) {
-			printk(KERN_DEBUG "%s: vif had allocated beacon "
-			       "slot\n", __func__);
-			sc->beacon.bslot[i] = NULL;
-			sc->beacon.bslot_aphy[i] = NULL;
-		} else if (sc->beacon.bslot[i])
-			bs_valid = true;
-	}
-	if (!bs_valid && (sc->sc_ah->imask & ATH9K_INT_SWBA)) {
-		/* Disable SWBA interrupt */
-		sc->sc_ah->imask &= ~ATH9K_INT_SWBA;
+	if (sc->nbcnvifs) {
+		/* Re-enable SWBA interrupt */
+		sc->sc_ah->imask |= ATH9K_INT_SWBA;
 		ath9k_ps_wakeup(sc);
 		ath9k_hw_set_interrupts(sc->sc_ah, sc->sc_ah->imask);
 		ath9k_ps_restore(sc);
-- 
1.7.3.3

