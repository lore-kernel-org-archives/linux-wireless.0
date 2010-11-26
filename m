Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:44585 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754264Ab0KZRzI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Nov 2010 12:55:08 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 26 Nov 2010 09:54:54 -0800
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH 2/3] ath9k: Add change_interface callback
Date: Fri, 26 Nov 2010 23:24:32 +0530
Message-ID: <1290794073-5309-2-git-send-email-rmanoharan@atheros.com>
In-Reply-To: <1290794073-5309-1-git-send-email-rmanoharan@atheros.com>
References: <1290794073-5309-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add support to change interface type
without bringing down the interface.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |   91 +++++++++++++++++++++++++--------
 1 files changed, 69 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 6298603..bc51133 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1429,40 +1429,26 @@ out:
 	return ret;
 }
 
-static void ath9k_remove_interface(struct ieee80211_hw *hw,
-				   struct ieee80211_vif *vif)
+static void ath9k_reclaim_beacon(struct ath_softc *sc,
+				 struct ieee80211_vif *vif)
 {
-	struct ath_wiphy *aphy = hw->priv;
-	struct ath_softc *sc = aphy->sc;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_vif *avp = (void *)vif->drv_priv;
 	bool bs_valid = false;
 	int i;
 
-	ath_print(common, ATH_DBG_CONFIG, "Detach Interface\n");
-
-	mutex_lock(&sc->mutex);
-
-	/* Stop ANI */
-	sc->sc_flags &= ~SC_OP_ANI_RUN;
-	del_timer_sync(&common->ani.timer);
-
-	/* Reclaim beacon resources */
-	if ((sc->sc_ah->opmode == NL80211_IFTYPE_AP) ||
-	    (sc->sc_ah->opmode == NL80211_IFTYPE_ADHOC) ||
-	    (sc->sc_ah->opmode == NL80211_IFTYPE_MESH_POINT)) {
-		ath9k_ps_wakeup(sc);
-		ath9k_hw_stoptxdma(sc->sc_ah, sc->beacon.beaconq);
-		ath9k_ps_restore(sc);
-	}
+	ath9k_ps_wakeup(sc);
+	ath9k_hw_stoptxdma(sc->sc_ah, sc->beacon.beaconq);
+	ath9k_ps_restore(sc);
 
 	ath_beacon_return(sc, avp);
 	sc->sc_flags &= ~SC_OP_BEACONS;
 
 	for (i = 0; i < ARRAY_SIZE(sc->beacon.bslot); i++) {
 		if (sc->beacon.bslot[i] == vif) {
-			printk(KERN_DEBUG "%s: vif had allocated beacon "
-			       "slot\n", __func__);
+			ath_print(common, ATH_DBG_BEACON,
+				"%s: vif had allocated beacon "
+				"slot\n", __func__);
 			sc->beacon.bslot[i] = NULL;
 			sc->beacon.bslot_aphy[i] = NULL;
 		} else if (sc->beacon.bslot[i])
@@ -1475,6 +1461,66 @@ static void ath9k_remove_interface(struct ieee80211_hw *hw,
 		ath9k_hw_set_interrupts(sc->sc_ah, sc->sc_ah->imask);
 		ath9k_ps_restore(sc);
 	}
+}
+
+static int ath9k_change_interface(struct ieee80211_hw *hw,
+				  struct ieee80211_vif *vif,
+				  enum nl80211_iftype new_type,
+				  bool p2p)
+{
+	struct ath_wiphy *aphy = hw->priv;
+	struct ath_softc *sc = aphy->sc;
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+
+	ath_print(common, ATH_DBG_CONFIG, "Change Interface\n");
+	mutex_lock(&sc->mutex);
+
+	new_type = ieee80211_iftype_p2p(new_type, p2p);
+
+	switch (new_type) {
+	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_ADHOC:
+		break;
+	case NL80211_IFTYPE_STATION:
+		/* Stop ANI */
+		sc->sc_flags &= ~SC_OP_ANI_RUN;
+		del_timer_sync(&common->ani.timer);
+		if ((vif->type == NL80211_IFTYPE_AP) ||
+		    (vif->type == NL80211_IFTYPE_ADHOC))
+			ath9k_reclaim_beacon(sc, vif);
+		break;
+	default:
+		ath_print(common, ATH_DBG_FATAL,
+			"Interface type %d not yet supported\n", vif->type);
+		mutex_unlock(&sc->mutex);
+		return -ENOTSUPP;
+	}
+	vif->type = new_type;
+
+	mutex_unlock(&sc->mutex);
+	return 0;
+}
+
+static void ath9k_remove_interface(struct ieee80211_hw *hw,
+				   struct ieee80211_vif *vif)
+{
+	struct ath_wiphy *aphy = hw->priv;
+	struct ath_softc *sc = aphy->sc;
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+
+	ath_print(common, ATH_DBG_CONFIG, "Detach Interface\n");
+
+	mutex_lock(&sc->mutex);
+
+	/* Stop ANI */
+	sc->sc_flags &= ~SC_OP_ANI_RUN;
+	del_timer_sync(&common->ani.timer);
+
+	/* Reclaim beacon resources */
+	if ((sc->sc_ah->opmode == NL80211_IFTYPE_AP) ||
+	    (sc->sc_ah->opmode == NL80211_IFTYPE_ADHOC) ||
+	    (sc->sc_ah->opmode == NL80211_IFTYPE_MESH_POINT))
+		ath9k_reclaim_beacon(sc, vif);
 
 	sc->nvifs--;
 
@@ -2123,6 +2169,7 @@ struct ieee80211_ops ath9k_ops = {
 	.start 		    = ath9k_start,
 	.stop 		    = ath9k_stop,
 	.add_interface 	    = ath9k_add_interface,
+	.change_interface   = ath9k_change_interface,
 	.remove_interface   = ath9k_remove_interface,
 	.config 	    = ath9k_config,
 	.configure_filter   = ath9k_configure_filter,
-- 
1.7.3.2

