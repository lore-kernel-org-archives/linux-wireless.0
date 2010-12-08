Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:26452 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754643Ab0LHOJp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Dec 2010 09:09:45 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 08 Dec 2010 06:09:30 -0800
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH v5 2/2] ath9k: Add change_interface callback
Date: Wed, 8 Dec 2010 19:38:55 +0530
Message-ID: <1291817335-5973-2-git-send-email-rmanoharan@atheros.com>
In-Reply-To: <1291817335-5973-1-git-send-email-rmanoharan@atheros.com>
References: <1291817335-5973-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add support to change interface type
without bringing down the interface.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
v2: - ieee80211_iftype_p2p not needed
    - missed to store p2p value
v3:   nbcnvifs has to be checked while changing to beaconing mode
v4:   rebased
v5:   s/ath_print/ath_[err/dbg]/

 drivers/net/wireless/ath/ath9k/main.c |   90 +++++++++++++++++++++++++--------
 1 files changed, 69 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 699dbaa..8637806 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1425,13 +1425,78 @@ out:
 	return ret;
 }
 
+static void ath9k_reclaim_beacon(struct ath_softc *sc,
+				 struct ieee80211_vif *vif)
+{
+	struct ath_vif *avp = (void *)vif->drv_priv;
+
+	/* Disable SWBA interrupt */
+	sc->sc_ah->imask &= ~ATH9K_INT_SWBA;
+	ath9k_ps_wakeup(sc);
+	ath9k_hw_set_interrupts(sc->sc_ah, sc->sc_ah->imask);
+	ath9k_hw_stoptxdma(sc->sc_ah, sc->beacon.beaconq);
+	tasklet_kill(&sc->bcon_tasklet);
+	ath9k_ps_restore(sc);
+
+	ath_beacon_return(sc, avp);
+	sc->sc_flags &= ~SC_OP_BEACONS;
+
+	if (sc->nbcnvifs > 0) {
+		/* Re-enable beaconing */
+		sc->sc_ah->imask |= ATH9K_INT_SWBA;
+		ath9k_ps_wakeup(sc);
+		ath9k_hw_set_interrupts(sc->sc_ah, sc->sc_ah->imask);
+		ath9k_ps_restore(sc);
+	}
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
+	ath_dbg(common, ATH_DBG_CONFIG, "Change Interface\n");
+	mutex_lock(&sc->mutex);
+
+	switch (new_type) {
+	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_ADHOC:
+		if (sc->nbcnvifs >= ATH_BCBUF) {
+			ath_err(common, "No beacon slot available\n");
+			return -ENOBUFS;
+		}
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
+		ath_err(common, "Interface type %d not yet supported\n",
+				vif->type);
+		mutex_unlock(&sc->mutex);
+		return -ENOTSUPP;
+	}
+	vif->type = new_type;
+	vif->p2p = p2p;
+
+	mutex_unlock(&sc->mutex);
+	return 0;
+}
+
 static void ath9k_remove_interface(struct ieee80211_hw *hw,
 				   struct ieee80211_vif *vif)
 {
 	struct ath_wiphy *aphy = hw->priv;
 	struct ath_softc *sc = aphy->sc;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
-	struct ath_vif *avp = (void *)vif->drv_priv;
 
 	ath_dbg(common, ATH_DBG_CONFIG, "Detach Interface\n");
 
@@ -1444,26 +1509,8 @@ static void ath9k_remove_interface(struct ieee80211_hw *hw,
 	/* Reclaim beacon resources */
 	if ((sc->sc_ah->opmode == NL80211_IFTYPE_AP) ||
 	    (sc->sc_ah->opmode == NL80211_IFTYPE_ADHOC) ||
-	    (sc->sc_ah->opmode == NL80211_IFTYPE_MESH_POINT)) {
-		/* Disable SWBA interrupt */
-		sc->sc_ah->imask &= ~ATH9K_INT_SWBA;
-		ath9k_ps_wakeup(sc);
-		ath9k_hw_set_interrupts(sc->sc_ah, sc->sc_ah->imask);
-		ath9k_hw_stoptxdma(sc->sc_ah, sc->beacon.beaconq);
-		ath9k_ps_restore(sc);
-		tasklet_kill(&sc->bcon_tasklet);
-	}
-
-	ath_beacon_return(sc, avp);
-	sc->sc_flags &= ~SC_OP_BEACONS;
-
-	if (sc->nbcnvifs) {
-		/* Re-enable SWBA interrupt */
-		sc->sc_ah->imask |= ATH9K_INT_SWBA;
-		ath9k_ps_wakeup(sc);
-		ath9k_hw_set_interrupts(sc->sc_ah, sc->sc_ah->imask);
-		ath9k_ps_restore(sc);
-	}
+	    (sc->sc_ah->opmode == NL80211_IFTYPE_MESH_POINT))
+		ath9k_reclaim_beacon(sc, vif);
 
 	sc->nvifs--;
 
@@ -2108,6 +2155,7 @@ struct ieee80211_ops ath9k_ops = {
 	.start 		    = ath9k_start,
 	.stop 		    = ath9k_stop,
 	.add_interface 	    = ath9k_add_interface,
+	.change_interface   = ath9k_change_interface,
 	.remove_interface   = ath9k_remove_interface,
 	.config 	    = ath9k_config,
 	.configure_filter   = ath9k_configure_filter,
-- 
1.7.3.3

