Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:38324 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606Ab1ANR1U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Jan 2011 12:27:20 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@venema.h4ckr.net, Ben Greear <greearb@candelatech.com>
Subject: [RFC 1/2] ath9k:  Fix up hardware mode and beacons with multiple vifs.
Date: Fri, 14 Jan 2011 09:27:08 -0800
Message-Id: <1295026029-21130-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

When using a mixture of AP and Station interfaces,
the hardware mode was using the type of the
last VIF registered.  Instead, we should keep track
of the number of different types of vifs and set the
mode accordingly.

In addtion, use the vif type instead of hardware opmode
when dealing with beacons.

Attempt to move some of the common setup code into smaller
methods so we can re-use it when changing vif mode as
well as adding/deleting vifs.

This needs review.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 3108699... a2da259... M	drivers/net/wireless/ath/ath9k/ath9k.h
:100644 100644 385ba03... 8de591e... M	drivers/net/wireless/ath/ath9k/beacon.c
:100644 100644 0452580... 1a65e53... M	drivers/net/wireless/ath/ath9k/main.c
:100644 100644 ea2f67c... 9a2b4a8... M	drivers/net/wireless/ath/ath9k/recv.c
 drivers/net/wireless/ath/ath9k/ath9k.h  |   10 +-
 drivers/net/wireless/ath/ath9k/beacon.c |   14 +-
 drivers/net/wireless/ath/ath9k/main.c   |  263 ++++++++++++++++++++++---------
 drivers/net/wireless/ath/ath9k/recv.c   |   17 ++-
 4 files changed, 214 insertions(+), 90 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 3108699..a2da259 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -607,10 +607,15 @@ struct ath_softc {
 	u32 sc_flags; /* SC_OP_* */
 	u16 ps_flags; /* PS_* */
 	u16 curtxpow;
-	u8 nbcnvifs;
-	u16 nvifs;
 	bool ps_enabled;
 	bool ps_idle;
+	short nbcnvifs;
+	short nvifs;
+	short naps; /* number of APs */
+	short nmeshes;
+	short nstations;
+	short nwds;
+	short nadhocs;
 	unsigned long ps_usecount;
 
 	struct ath_config config;
@@ -694,6 +699,7 @@ int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
 void ath_radio_enable(struct ath_softc *sc, struct ieee80211_hw *hw);
 void ath_radio_disable(struct ath_softc *sc, struct ieee80211_hw *hw);
 bool ath9k_setpower(struct ath_softc *sc, enum ath9k_power_mode mode);
+bool ath9k_uses_beacons(int type);
 
 #ifdef CONFIG_PCI
 int ath_pci_init(void);
diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 385ba03..8de591e 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -244,9 +244,7 @@ int ath_beacon_alloc(struct ath_wiphy *aphy, struct ieee80211_vif *vif)
 						 struct ath_buf, list);
 		list_del(&avp->av_bcbuf->list);
 
-		if (sc->sc_ah->opmode == NL80211_IFTYPE_AP ||
-		    sc->sc_ah->opmode == NL80211_IFTYPE_ADHOC ||
-		    sc->sc_ah->opmode == NL80211_IFTYPE_MESH_POINT) {
+		if (ath9k_uses_beacons(vif->type)) {
 			int slot;
 			/*
 			 * Assign the vif to a beacon xmit slot. As
@@ -282,7 +280,7 @@ int ath_beacon_alloc(struct ath_wiphy *aphy, struct ieee80211_vif *vif)
 	/* NB: the beacon data buffer must be 32-bit aligned. */
 	skb = ieee80211_beacon_get(sc->hw, vif);
 	if (skb == NULL) {
-		ath_dbg(common, ATH_DBG_BEACON, "cannot get skb\n");
+		ath_err(common, "ieee80211_beacon_get failed\n");
 		return -ENOMEM;
 	}
 
@@ -720,10 +718,10 @@ void ath_beacon_config(struct ath_softc *sc, struct ieee80211_vif *vif)
 		iftype = sc->sc_ah->opmode;
 	}
 
-		cur_conf->listen_interval = 1;
-		cur_conf->dtim_count = 1;
-		cur_conf->bmiss_timeout =
-			ATH_DEFAULT_BMISS_LIMIT * cur_conf->beacon_interval;
+	cur_conf->listen_interval = 1;
+	cur_conf->dtim_count = 1;
+	cur_conf->bmiss_timeout =
+		ATH_DEFAULT_BMISS_LIMIT * cur_conf->beacon_interval;
 
 	/*
 	 * It looks like mac80211 may end up using beacon interval of zero in
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 0452580..1a65e53 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1366,71 +1366,107 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 	ath_dbg(common, ATH_DBG_CONFIG, "Driver halt\n");
 }
 
-static int ath9k_add_interface(struct ieee80211_hw *hw,
-			       struct ieee80211_vif *vif)
+static void decrement_vif_type(struct ath_softc *sc, int type)
 {
-	struct ath_wiphy *aphy = hw->priv;
-	struct ath_softc *sc = aphy->sc;
-	struct ath_hw *ah = sc->sc_ah;
-	struct ath_common *common = ath9k_hw_common(ah);
-	struct ath_vif *avp = (void *)vif->drv_priv;
-	enum nl80211_iftype ic_opmode = NL80211_IFTYPE_UNSPECIFIED;
-	int ret = 0;
-
-	mutex_lock(&sc->mutex);
-
-	switch (vif->type) {
+	switch (type) {
+	case NL80211_IFTYPE_AP:
+		sc->naps--;
+		break;
 	case NL80211_IFTYPE_STATION:
-		ic_opmode = NL80211_IFTYPE_STATION;
+		sc->nstations--;
+		break;
+	case NL80211_IFTYPE_ADHOC:
+		sc->nadhocs--;
+		break;
+	case NL80211_IFTYPE_MESH_POINT:
+		sc->nmeshes--;
 		break;
 	case NL80211_IFTYPE_WDS:
-		ic_opmode = NL80211_IFTYPE_WDS;
+		sc->nwds--;
 		break;
-	case NL80211_IFTYPE_ADHOC:
+	}
+}
+
+static void increment_vif_type(struct ath_softc *sc, int type)
+{
+	switch (type) {
 	case NL80211_IFTYPE_AP:
+		sc->naps++;
+		break;
+	case NL80211_IFTYPE_STATION:
+		sc->nstations++;
+		break;
+	case NL80211_IFTYPE_ADHOC:
+		sc->nadhocs++;
+		break;
 	case NL80211_IFTYPE_MESH_POINT:
-		if (sc->nbcnvifs >= ATH_BCBUF) {
-			ret = -ENOBUFS;
-			goto out;
-		}
-		ic_opmode = vif->type;
+		sc->nmeshes++;
+		break;
+	case NL80211_IFTYPE_WDS:
+		sc->nwds++;
 		break;
+	}
+}
+
+bool ath9k_uses_beacons(int type)
+{
+	switch (type) {
+	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_ADHOC:
+	case NL80211_IFTYPE_MESH_POINT:
+		return true;
 	default:
-		ath_err(common, "Interface type %d not yet supported\n",
-			vif->type);
-		ret = -EOPNOTSUPP;
-		goto out;
+		return false;
 	}
+}
 
-	ath_dbg(common, ATH_DBG_CONFIG,
-		"Attach a VIF of type: %d\n", ic_opmode);
+static void ath9k_reclaim_beacon(struct ath_softc *sc,
+				 struct ieee80211_vif *vif)
+{
+	struct ath_vif *avp = (void *)vif->drv_priv;
 
-	/* Set the VIF opmode */
-	avp->av_opmode = ic_opmode;
-	avp->av_bslot = -1;
+	/* Disable SWBA interrupt */
+	sc->sc_ah->imask &= ~ATH9K_INT_SWBA;
+	ath9k_ps_wakeup(sc);
+	ath9k_hw_set_interrupts(sc->sc_ah, sc->sc_ah->imask);
+	ath9k_hw_stoptxdma(sc->sc_ah, sc->beacon.beaconq);
+	tasklet_kill(&sc->bcon_tasklet);
+	ath9k_ps_restore(sc);
 
-	sc->nvifs++;
+	ath_beacon_return(sc, avp);
+	sc->sc_flags &= ~SC_OP_BEACONS;
 
-	ath9k_set_bssid_mask(hw, vif);
+	if (sc->nbcnvifs > 0) {
+		/* Re-enable beaconing */
+		sc->sc_ah->imask |= ATH9K_INT_SWBA;
+		ath9k_ps_wakeup(sc);
+		ath9k_hw_set_interrupts(sc->sc_ah, sc->sc_ah->imask);
+		ath9k_ps_restore(sc);
+	}
+}
 
-	if (sc->nvifs > 1)
-		goto out; /* skip global settings for secondary vif */
+/* Called with sc->mutex held, vif counts set up properly. */
+static void ath9k_do_vif_add_setup(struct ieee80211_hw *hw,
+				   struct ieee80211_vif *vif)
+{
+	struct ath_wiphy *aphy = hw->priv;
+	struct ath_softc *sc = aphy->sc;
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
 
-	if (ic_opmode == NL80211_IFTYPE_AP) {
+	ath9k_set_bssid_mask(hw, vif);
+
+	if (sc->naps > 0) {
 		ath9k_hw_set_tsfadjust(ah, 1);
 		sc->sc_flags |= SC_OP_TSF_RESET;
-	}
-
-	/* Set the device opmode */
-	ah->opmode = ic_opmode;
+		ah->opmode = NL80211_IFTYPE_AP;
+	} else
+		ah->opmode = vif->type;
 
 	/*
 	 * Enable MIB interrupts when there are hardware phy counters.
-	 * Note we only do this (at the moment) for station mode.
 	 */
-	if ((vif->type == NL80211_IFTYPE_STATION) ||
-	    (vif->type == NL80211_IFTYPE_ADHOC) ||
-	    (vif->type == NL80211_IFTYPE_MESH_POINT)) {
+	if ((sc->nstations + sc->nadhocs + sc->nmeshes) > 0) {
 		if (ah->config.enable_ani)
 			ah->imask |= ATH9K_INT_MIB;
 		ah->imask |= ATH9K_INT_TSFOOR;
@@ -1438,40 +1474,87 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 
 	ath9k_hw_set_interrupts(ah, ah->imask);
 
-	if (vif->type == NL80211_IFTYPE_AP    ||
-	    vif->type == NL80211_IFTYPE_ADHOC) {
+	if ((sc->naps + sc->nadhocs) > 0) {
 		sc->sc_flags |= SC_OP_ANI_RUN;
 		ath_start_ani(common);
 	}
 
-out:
-	mutex_unlock(&sc->mutex);
-	return ret;
+	if (ath9k_uses_beacons(vif->type)) {
+		int error;
+		ath9k_hw_stoptxdma(sc->sc_ah, sc->beacon.beaconq);
+		/* This may fail because upper levels do not have beacons
+		 * properly configured yet.  That's OK, we assume it
+		 * will be properly configured and then we will be notified
+		 * in the info_changed method and set up beacons properly
+		 * there.
+		 */
+		error = ath_beacon_alloc(aphy, vif);
+		if (error)
+			ath9k_reclaim_beacon(sc, vif);
+		else
+			ath_beacon_config(sc, vif);
+	}
 }
 
-static void ath9k_reclaim_beacon(struct ath_softc *sc,
-				 struct ieee80211_vif *vif)
+
+static int ath9k_add_interface(struct ieee80211_hw *hw,
+			       struct ieee80211_vif *vif)
 {
+	struct ath_wiphy *aphy = hw->priv;
+	struct ath_softc *sc = aphy->sc;
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath_vif *avp = (void *)vif->drv_priv;
+	int ret = 0;
 
-	/* Disable SWBA interrupt */
-	sc->sc_ah->imask &= ~ATH9K_INT_SWBA;
-	ath9k_ps_wakeup(sc);
-	ath9k_hw_set_interrupts(sc->sc_ah, sc->sc_ah->imask);
-	ath9k_hw_stoptxdma(sc->sc_ah, sc->beacon.beaconq);
-	tasklet_kill(&sc->bcon_tasklet);
-	ath9k_ps_restore(sc);
+	mutex_lock(&sc->mutex);
 
-	ath_beacon_return(sc, avp);
-	sc->sc_flags &= ~SC_OP_BEACONS;
+	switch (vif->type) {
+	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_WDS:
+	case NL80211_IFTYPE_ADHOC:
+	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_MESH_POINT:
+		break;
+	default:
+		ath_err(common, "Interface type %d not yet supported\n",
+			vif->type);
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
 
-	if (sc->nbcnvifs > 0) {
-		/* Re-enable beaconing */
-		sc->sc_ah->imask |= ATH9K_INT_SWBA;
-		ath9k_ps_wakeup(sc);
-		ath9k_hw_set_interrupts(sc->sc_ah, sc->sc_ah->imask);
-		ath9k_ps_restore(sc);
+	if (ath9k_uses_beacons(vif->type)) {
+		if (sc->nbcnvifs >= ATH_BCBUF) {
+			ath_err(common, "Not enough beacon buffers when adding"
+				" new interface of type: %i\n",
+				vif->type);
+			ret = -ENOBUFS;
+			goto out;
+		}
+	}
+
+	if ((vif->type == NL80211_IFTYPE_ADHOC) &&
+	    sc->nvifs > 0) {
+		ath_err(common, "Cannot create ADHOC interface when other"
+			" interfaces already exist.\n");
+		ret = -EINVAL;
+		goto out;
 	}
+
+	ath_dbg(common, ATH_DBG_CONFIG,
+		"Attach a VIF of type: %d\n", vif->type);
+
+	/* Set the VIF opmode */
+	avp->av_opmode = vif->type;
+	avp->av_bslot = -1;
+
+	increment_vif_type(sc, vif->type);
+	sc->nvifs++;
+
+	ath9k_do_vif_add_setup(hw, vif);
+out:
+	mutex_unlock(&sc->mutex);
+	return ret;
 }
 
 static int ath9k_change_interface(struct ieee80211_hw *hw,
@@ -1487,6 +1570,11 @@ static int ath9k_change_interface(struct ieee80211_hw *hw,
 	ath_dbg(common, ATH_DBG_CONFIG, "Change Interface\n");
 	mutex_lock(&sc->mutex);
 
+	decrement_vif_type(sc, vif->type);
+
+	if (ath9k_uses_beacons(vif->type))
+		ath9k_reclaim_beacon(sc, vif);
+
 	switch (new_type) {
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_ADHOC:
@@ -1497,12 +1585,11 @@ static int ath9k_change_interface(struct ieee80211_hw *hw,
 		}
 		break;
 	case NL80211_IFTYPE_STATION:
-		/* Stop ANI */
-		sc->sc_flags &= ~SC_OP_ANI_RUN;
-		del_timer_sync(&common->ani.timer);
-		if ((vif->type == NL80211_IFTYPE_AP) ||
-		    (vif->type == NL80211_IFTYPE_ADHOC))
-			ath9k_reclaim_beacon(sc, vif);
+		if ((sc->naps + sc->nadhocs) == 0) {
+			/* Stop ANI */
+			sc->sc_flags &= ~SC_OP_ANI_RUN;
+			del_timer_sync(&common->ani.timer);
+		}
 		break;
 	default:
 		ath_err(common, "Interface type %d not yet supported\n",
@@ -1513,6 +1600,8 @@ static int ath9k_change_interface(struct ieee80211_hw *hw,
 	vif->type = new_type;
 	vif->p2p = p2p;
 
+	increment_vif_type(sc, vif->type);
+	ath9k_do_vif_add_setup(hw, vif);
 out:
 	mutex_unlock(&sc->mutex);
 	return ret;
@@ -1524,22 +1613,40 @@ static void ath9k_remove_interface(struct ieee80211_hw *hw,
 	struct ath_wiphy *aphy = hw->priv;
 	struct ath_softc *sc = aphy->sc;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	struct ath_hw *ah = sc->sc_ah;
 
 	ath_dbg(common, ATH_DBG_CONFIG, "Detach Interface\n");
 
 	mutex_lock(&sc->mutex);
 
-	/* Stop ANI */
-	sc->sc_flags &= ~SC_OP_ANI_RUN;
-	del_timer_sync(&common->ani.timer);
+	decrement_vif_type(sc, vif->type);
+	sc->nvifs--;
+
+	if ((sc->naps + sc->nadhocs) == 0) {
+		/* Stop ANI */
+		sc->sc_flags &= ~SC_OP_ANI_RUN;
+		del_timer_sync(&common->ani.timer);
+	}
 
 	/* Reclaim beacon resources */
-	if ((sc->sc_ah->opmode == NL80211_IFTYPE_AP) ||
-	    (sc->sc_ah->opmode == NL80211_IFTYPE_ADHOC) ||
-	    (sc->sc_ah->opmode == NL80211_IFTYPE_MESH_POINT))
+	if (ath9k_uses_beacons(vif->type))
 		ath9k_reclaim_beacon(sc, vif);
 
-	sc->nvifs--;
+	ath9k_set_bssid_mask(hw, NULL);
+
+	if (sc->naps == 0) {
+		ath9k_hw_set_tsfadjust(ah, 0);
+		sc->sc_flags &= ~SC_OP_TSF_RESET;
+		if (sc->nwds)
+			ah->opmode = NL80211_IFTYPE_WDS;
+		else if (sc->nmeshes)
+			ah->opmode = NL80211_IFTYPE_MESH_POINT;
+		else if (sc->nadhocs)
+			ah->opmode = NL80211_IFTYPE_ADHOC;
+		else
+			ah->opmode = NL80211_IFTYPE_STATION;
+	} else
+		ah->opmode = NL80211_IFTYPE_AP;
 
 	mutex_unlock(&sc->mutex);
 }
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index ea2f67c..9a2b4a8 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -589,8 +589,14 @@ static void ath_rx_ps_beacon(struct ath_softc *sc, struct sk_buff *skb)
 		return;
 
 	mgmt = (struct ieee80211_mgmt *)skb->data;
-	if (memcmp(common->curbssid, mgmt->bssid, ETH_ALEN) != 0)
+	if (memcmp(common->curbssid, mgmt->bssid, ETH_ALEN) != 0) {
+		/* TODO:  This doesn't work well if you have stations
+		 * associated to two different APs because curbssid
+		 * is just the last AP that any of the stations associated
+		 * with.
+		 */
 		return; /* not from our current AP */
+	}
 
 	sc->ps_flags &= ~PS_WAIT_FOR_BEACON;
 
@@ -980,13 +986,20 @@ static void ath9k_process_rssi(struct ath_common *common,
 	int last_rssi;
 	__le16 fc;
 
+	/* TODO:  Maybe need to accept this if we have STA vifs active?? */
 	if (ah->opmode != NL80211_IFTYPE_STATION)
 		return;
 
 	fc = hdr->frame_control;
 	if (!ieee80211_is_beacon(fc) ||
-	    compare_ether_addr(hdr->addr3, common->curbssid))
+	    compare_ether_addr(hdr->addr3, common->curbssid)) {
+		/* TODO:  This doesn't work well if you have stations
+		 * associated to two different APs because curbssid
+		 * is just the last AP that any of the stations associated
+		 * with.
+		 */
 		return;
+	}
 
 	if (rx_stats->rs_rssi != ATH9K_RSSI_BAD && !rx_stats->rs_moreaggr)
 		ATH_RSSI_LPF(aphy->last_rssi, rx_stats->rs_rssi);
-- 
1.7.2.3

