Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:53443 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660Ab1ALObl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jan 2011 09:31:41 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 12 Jan 2011 06:31:23 -0800
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linux-wireless@vger.kernel.org>
CC: Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [RFC] ath9k: Handle interface changes properly
Date: Wed, 12 Jan 2011 20:00:52 +0530
Message-ID: <1294842652-7406-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The commit ""ath9k: Add change_interface callback" was failed
to update of hw opmode, ani and interrupt mask. This leads
to break p2p functionality on ath9k. And the existing add and
remove interface functions are not handling hw opmode and
ANI properly.

This patch combines the common code in interface callbacks
and also takes care of multi-vif cases.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    7 +
 drivers/net/wireless/ath/ath9k/main.c  |  195 +++++++++++++------------------
 drivers/net/wireless/ath/ath9k/recv.c  |    2 +-
 3 files changed, 90 insertions(+), 114 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 3681caf5..ef00f93 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -309,6 +309,7 @@ int ath_startrecv(struct ath_softc *sc);
 bool ath_stoprecv(struct ath_softc *sc);
 void ath_flushrecv(struct ath_softc *sc);
 u32 ath_calcrxfilter(struct ath_softc *sc);
+void ath_opmode_init(struct ath_softc *sc);
 int ath_rx_init(struct ath_softc *sc, int nbufs);
 void ath_rx_cleanup(struct ath_softc *sc);
 int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp);
@@ -337,6 +338,12 @@ void ath_tx_aggr_resume(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid
 /* VIFs */
 /********/
 
+enum ath_iface_optype {
+	ATH9K_ADD_IFACE,
+	ATH9K_MOD_IFACE,
+	ATH9K_DEL_IFACE,
+};
+
 struct ath_vif {
 	int av_bslot;
 	__le64 tsf_adjust; /* TSF adjustment for staggered beacons */
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index f90a6ca..b6dd7d0 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1341,64 +1341,114 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 	ath_dbg(common, ATH_DBG_CONFIG, "Driver halt\n");
 }
 
-static int ath9k_add_interface(struct ieee80211_hw *hw,
-			       struct ieee80211_vif *vif)
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
+static int ath9k_iface_work(struct ieee80211_hw *hw,
+			    struct ieee80211_vif *vif,
+			    enum nl80211_iftype new_type,
+			    bool p2p,
+			    u8 optype)
 {
 	struct ath_wiphy *aphy = hw->priv;
 	struct ath_softc *sc = aphy->sc;
 	struct ath_hw *ah = sc->sc_ah;
-	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath_vif *avp = (void *)vif->drv_priv;
-	enum nl80211_iftype ic_opmode = NL80211_IFTYPE_UNSPECIFIED;
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	enum nl80211_iftype iftype;
 	int ret = 0;
 
 	mutex_lock(&sc->mutex);
 
-	switch (vif->type) {
+	/* Stop ANI timer */
+	del_timer_sync(&common->ani.timer);
+
+	iftype = (optype == ATH9K_MOD_IFACE) ? new_type : vif->type;
+
+	/* Remove interface */
+	if (optype == ATH9K_DEL_IFACE) {
+		if ((iftype == NL80211_IFTYPE_AP) ||
+		    (iftype == NL80211_IFTYPE_ADHOC)) {
+			ath9k_reclaim_beacon(sc, vif);
+			if (!sc->nbcnvifs)
+				sc->sc_flags &= ~SC_OP_ANI_RUN;
+		}
+		ath_dbg(common, ATH_DBG_CONFIG, "Detach Interface\n");
+		sc->nvifs--;
+		goto out;
+	}
+
+	switch (iftype) {
 	case NL80211_IFTYPE_STATION:
-		ic_opmode = NL80211_IFTYPE_STATION;
+		if ((optype == ATH9K_MOD_IFACE) &&
+		    ((vif->type == NL80211_IFTYPE_AP) ||
+		     (vif->type == NL80211_IFTYPE_ADHOC)))
+			ath9k_reclaim_beacon(sc, vif);
+		if (!sc->nbcnvifs) {
+			sc->sc_flags &= ~SC_OP_ANI_RUN;
+			ah->opmode = iftype;
+		}
 		break;
 	case NL80211_IFTYPE_WDS:
-		ic_opmode = NL80211_IFTYPE_WDS;
+		ah->opmode = iftype;
 		break;
 	case NL80211_IFTYPE_ADHOC:
-	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_MESH_POINT:
+	case NL80211_IFTYPE_AP:
 		if (sc->nbcnvifs >= ATH_BCBUF) {
 			ret = -ENOBUFS;
 			goto out;
 		}
-		ic_opmode = vif->type;
+		sc->sc_flags |= SC_OP_ANI_RUN;
+		ah->opmode = iftype;
 		break;
 	default:
 		ath_err(common, "Interface type %d not yet supported\n",
-			vif->type);
+				iftype);
 		ret = -EOPNOTSUPP;
 		goto out;
 	}
-
-	ath_dbg(common, ATH_DBG_CONFIG,
-		"Attach a VIF of type: %d\n", ic_opmode);
-
-	/* Set the VIF opmode */
-	avp->av_opmode = ic_opmode;
+	avp->av_opmode = iftype;
 	avp->av_bslot = -1;
+	vif->type = iftype;
+	vif->p2p = p2p;
 
-	sc->nvifs++;
-
-	ath9k_set_bssid_mask(hw, vif);
-
-	if (sc->nvifs > 1)
-		goto out; /* skip global settings for secondary vif */
+	if (optype == ATH9K_ADD_IFACE) {
+		ath_dbg(common, ATH_DBG_CONFIG,
+			"Attach Interface of type %d\n", vif->type);
+		sc->nvifs++;
+	} else
+		ath_dbg(common, ATH_DBG_CONFIG,
+			"Change Interface to type %d\n", vif->type);
 
-	if (ic_opmode == NL80211_IFTYPE_AP) {
+	ath_opmode_init(sc);
+	if (vif->type == NL80211_IFTYPE_AP) {
 		ath9k_hw_set_tsfadjust(ah, 1);
 		sc->sc_flags |= SC_OP_TSF_RESET;
 	}
 
-	/* Set the device opmode */
-	ah->opmode = ic_opmode;
-
 	/*
 	 * Enable MIB interrupts when there are hardware phy counters.
 	 * Note we only do this (at the moment) for station mode.
@@ -1410,43 +1460,18 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 			ah->imask |= ATH9K_INT_MIB;
 		ah->imask |= ATH9K_INT_TSFOOR;
 	}
-
 	ath9k_hw_set_interrupts(ah, ah->imask);
 
-	if (vif->type == NL80211_IFTYPE_AP    ||
-	    vif->type == NL80211_IFTYPE_ADHOC) {
-		sc->sc_flags |= SC_OP_ANI_RUN;
-		ath_start_ani(common);
-	}
-
 out:
+	ath_start_ani(common);
 	mutex_unlock(&sc->mutex);
 	return ret;
 }
 
-static void ath9k_reclaim_beacon(struct ath_softc *sc,
-				 struct ieee80211_vif *vif)
+static int ath9k_add_interface(struct ieee80211_hw *hw,
+			       struct ieee80211_vif *vif)
 {
-	struct ath_vif *avp = (void *)vif->drv_priv;
-
-	/* Disable SWBA interrupt */
-	sc->sc_ah->imask &= ~ATH9K_INT_SWBA;
-	ath9k_ps_wakeup(sc);
-	ath9k_hw_set_interrupts(sc->sc_ah, sc->sc_ah->imask);
-	ath9k_hw_stoptxdma(sc->sc_ah, sc->beacon.beaconq);
-	tasklet_kill(&sc->bcon_tasklet);
-	ath9k_ps_restore(sc);
-
-	ath_beacon_return(sc, avp);
-	sc->sc_flags &= ~SC_OP_BEACONS;
-
-	if (sc->nbcnvifs > 0) {
-		/* Re-enable beaconing */
-		sc->sc_ah->imask |= ATH9K_INT_SWBA;
-		ath9k_ps_wakeup(sc);
-		ath9k_hw_set_interrupts(sc->sc_ah, sc->sc_ah->imask);
-		ath9k_ps_restore(sc);
-	}
+	return ath9k_iface_work(hw, vif, vif->type, vif->p2p, ATH9K_ADD_IFACE);
 }
 
 static int ath9k_change_interface(struct ieee80211_hw *hw,
@@ -1454,69 +1479,13 @@ static int ath9k_change_interface(struct ieee80211_hw *hw,
 				  enum nl80211_iftype new_type,
 				  bool p2p)
 {
-	struct ath_wiphy *aphy = hw->priv;
-	struct ath_softc *sc = aphy->sc;
-	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
-	int ret = 0;
-
-	ath_dbg(common, ATH_DBG_CONFIG, "Change Interface\n");
-	mutex_lock(&sc->mutex);
-
-	switch (new_type) {
-	case NL80211_IFTYPE_AP:
-	case NL80211_IFTYPE_ADHOC:
-		if (sc->nbcnvifs >= ATH_BCBUF) {
-			ath_err(common, "No beacon slot available\n");
-			ret = -ENOBUFS;
-			goto out;
-		}
-		break;
-	case NL80211_IFTYPE_STATION:
-		/* Stop ANI */
-		sc->sc_flags &= ~SC_OP_ANI_RUN;
-		del_timer_sync(&common->ani.timer);
-		if ((vif->type == NL80211_IFTYPE_AP) ||
-		    (vif->type == NL80211_IFTYPE_ADHOC))
-			ath9k_reclaim_beacon(sc, vif);
-		break;
-	default:
-		ath_err(common, "Interface type %d not yet supported\n",
-				vif->type);
-		ret = -ENOTSUPP;
-		goto out;
-	}
-	vif->type = new_type;
-	vif->p2p = p2p;
-
-out:
-	mutex_unlock(&sc->mutex);
-	return ret;
+	return ath9k_iface_work(hw, vif, new_type, p2p, ATH9K_MOD_IFACE);
 }
 
 static void ath9k_remove_interface(struct ieee80211_hw *hw,
 				   struct ieee80211_vif *vif)
 {
-	struct ath_wiphy *aphy = hw->priv;
-	struct ath_softc *sc = aphy->sc;
-	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
-
-	ath_dbg(common, ATH_DBG_CONFIG, "Detach Interface\n");
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
-	    (sc->sc_ah->opmode == NL80211_IFTYPE_MESH_POINT))
-		ath9k_reclaim_beacon(sc, vif);
-
-	sc->nvifs--;
-
-	mutex_unlock(&sc->mutex);
+	ath9k_iface_work(hw, vif, vif->type, vif->p2p, ATH9K_DEL_IFACE);
 }
 
 static void ath9k_enable_ps(struct ath_softc *sc)
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index b2497b8..f02a709 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -107,7 +107,7 @@ static void ath_setdefantenna(struct ath_softc *sc, u32 antenna)
 	sc->rx.rxotherant = 0;
 }
 
-static void ath_opmode_init(struct ath_softc *sc)
+void ath_opmode_init(struct ath_softc *sc)
 {
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
-- 
1.7.3.5

