Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:60430 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362Ab1AOTN6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Jan 2011 14:13:58 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@venema.h4ckr.net, Ben Greear <greearb@candelatech.com>
Subject: [PATCH v3 1/2] ath9k:  Fix up hardware mode and beacons with multiple vifs.
Date: Sat, 15 Jan 2011 11:13:48 -0800
Message-Id: <1295118829-7464-1-git-send-email-greearb@candelatech.com>
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

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

v3:  Remove vif counters and use iterator to build current
   state for all interfaces as needed.  Move bssid mask setting
   logic to 'main.c', and combine with other summary state
   setting.

:100644 100644 3108699... dab0271... M	drivers/net/wireless/ath/ath9k/ath9k.h
:100644 100644 385ba03... 8de591e... M	drivers/net/wireless/ath/ath9k/beacon.c
:100644 100644 0452580... e91d927... M	drivers/net/wireless/ath/ath9k/main.c
:100644 100644 ea2f67c... 8def8c2... M	drivers/net/wireless/ath/ath9k/recv.c
:100644 100644 2dc7095... d205c66... M	drivers/net/wireless/ath/ath9k/virtual.c
 drivers/net/wireless/ath/ath9k/ath9k.h   |   23 ++-
 drivers/net/wireless/ath/ath9k/beacon.c  |   14 +-
 drivers/net/wireless/ath/ath9k/main.c    |  308 +++++++++++++++++++++---------
 drivers/net/wireless/ath/ath9k/recv.c    |   16 ++-
 drivers/net/wireless/ath/ath9k/virtual.c |   48 -----
 5 files changed, 263 insertions(+), 146 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 3108699..dab0271 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -568,6 +568,20 @@ struct ath_ant_comb {
 struct ath_wiphy;
 struct ath_rate_table;
 
+struct ath9k_vif_iter_data {
+	const u8 *hw_macaddr; /* phy's hardware address, set
+			       * before starting iteration for
+			       * valid bssid mask.
+			       */
+	u8 mask[ETH_ALEN]; /* bssid mask */
+	int naps;      /* number of AP vifs */
+	int nmeshes;   /* number of mesh vifs */
+	int nstations; /* number of station vifs */
+	int nwds;      /* number of nwd vifs */
+	int nadhocs;   /* number of adhoc vifs */
+	int nothers;   /* number of vifs not specified above. */
+};
+
 struct ath_softc {
 	struct ieee80211_hw *hw;
 	struct device *dev;
@@ -607,10 +621,10 @@ struct ath_softc {
 	u32 sc_flags; /* SC_OP_* */
 	u16 ps_flags; /* PS_* */
 	u16 curtxpow;
-	u8 nbcnvifs;
-	u16 nvifs;
 	bool ps_enabled;
 	bool ps_idle;
+	short nbcnvifs;
+	short nvifs;
 	unsigned long ps_usecount;
 
 	struct ath_config config;
@@ -694,6 +708,7 @@ int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
 void ath_radio_enable(struct ath_softc *sc, struct ieee80211_hw *hw);
 void ath_radio_disable(struct ath_softc *sc, struct ieee80211_hw *hw);
 bool ath9k_setpower(struct ath_softc *sc, enum ath9k_power_mode mode);
+bool ath9k_uses_beacons(int type);
 
 #ifdef CONFIG_PCI
 int ath_pci_init(void);
@@ -738,5 +753,9 @@ bool ath_mac80211_start_queue(struct ath_softc *sc, u16 skb_queue);
 
 void ath_start_rfkill_poll(struct ath_softc *sc);
 extern void ath9k_rfkill_poll_state(struct ieee80211_hw *hw);
+void ath9k_calculate_iter_data(struct ieee80211_hw *hw,
+			       struct ieee80211_vif *vif,
+			       struct ath9k_vif_iter_data *iter_data);
+
 
 #endif /* ATH9K_H */
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
index 0452580..e91d927 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1366,112 +1366,251 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 	ath_dbg(common, ATH_DBG_CONFIG, "Driver halt\n");
 }
 
-static int ath9k_add_interface(struct ieee80211_hw *hw,
-			       struct ieee80211_vif *vif)
+bool ath9k_uses_beacons(int type)
+{
+	switch (type) {
+	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_ADHOC:
+	case NL80211_IFTYPE_MESH_POINT:
+		return true;
+	default:
+		return false;
+	}
+}
+
+static void ath9k_reclaim_beacon(struct ath_softc *sc,
+				 struct ieee80211_vif *vif)
 {
-	struct ath_wiphy *aphy = hw->priv;
-	struct ath_softc *sc = aphy->sc;
-	struct ath_hw *ah = sc->sc_ah;
-	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath_vif *avp = (void *)vif->drv_priv;
-	enum nl80211_iftype ic_opmode = NL80211_IFTYPE_UNSPECIFIED;
-	int ret = 0;
 
-	mutex_lock(&sc->mutex);
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
+static void ath9k_vif_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
+{
+	struct ath9k_vif_iter_data *iter_data = data;
+	int i;
+
+	if (iter_data->hw_macaddr)
+		for (i = 0; i < ETH_ALEN; i++)
+			iter_data->mask[i] &=
+				~(iter_data->hw_macaddr[i] ^ mac[i]);
 
 	switch (vif->type) {
-	case NL80211_IFTYPE_STATION:
-		ic_opmode = NL80211_IFTYPE_STATION;
+	case NL80211_IFTYPE_AP:
+		iter_data->naps++;
 		break;
-	case NL80211_IFTYPE_WDS:
-		ic_opmode = NL80211_IFTYPE_WDS;
+	case NL80211_IFTYPE_STATION:
+		iter_data->nstations++;
 		break;
 	case NL80211_IFTYPE_ADHOC:
-	case NL80211_IFTYPE_AP:
+		iter_data->nadhocs++;
+		break;
 	case NL80211_IFTYPE_MESH_POINT:
-		if (sc->nbcnvifs >= ATH_BCBUF) {
-			ret = -ENOBUFS;
-			goto out;
-		}
-		ic_opmode = vif->type;
+		iter_data->nmeshes++;
+		break;
+	case NL80211_IFTYPE_WDS:
+		iter_data->nwds++;
 		break;
 	default:
-		ath_err(common, "Interface type %d not yet supported\n",
-			vif->type);
-		ret = -EOPNOTSUPP;
-		goto out;
+		iter_data->nothers++;
+		break;
 	}
+}
 
-	ath_dbg(common, ATH_DBG_CONFIG,
-		"Attach a VIF of type: %d\n", ic_opmode);
+/* Called with sc->mutex held. */
+void ath9k_calculate_iter_data(struct ieee80211_hw *hw,
+			       struct ieee80211_vif *vif,
+			       struct ath9k_vif_iter_data *iter_data)
+{
+	struct ath_wiphy *aphy = hw->priv;
+	struct ath_softc *sc = aphy->sc;
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
+	int i;
 
-	/* Set the VIF opmode */
-	avp->av_opmode = ic_opmode;
-	avp->av_bslot = -1;
+	/*
+	 * Use the hardware MAC address as reference, the hardware uses it
+	 * together with the BSSID mask when matching addresses.
+	 */
+	memset(iter_data, 0, sizeof(*iter_data));
+	iter_data->hw_macaddr = common->macaddr;
+	memset(&iter_data->mask, 0xff, ETH_ALEN);
 
-	sc->nvifs++;
+	if (vif)
+		ath9k_vif_iter(iter_data, vif->addr, vif);
+
+	/* Get list of all active MAC addresses */
+	spin_lock_bh(&sc->wiphy_lock);
+	ieee80211_iterate_active_interfaces_atomic(sc->hw, ath9k_vif_iter,
+						   iter_data);
+	for (i = 0; i < sc->num_sec_wiphy; i++) {
+		if (sc->sec_wiphy[i] == NULL)
+			continue;
+		ieee80211_iterate_active_interfaces_atomic(
+			sc->sec_wiphy[i]->hw, ath9k_vif_iter, iter_data);
+	}
+	spin_unlock_bh(&sc->wiphy_lock);
+}
+
+/* Called with sc->mutex held. */
+static void ath9k_calculate_summary_state(struct ieee80211_hw *hw,
+					  struct ieee80211_vif *vif)
+{
+	struct ath_wiphy *aphy = hw->priv;
+	struct ath_softc *sc = aphy->sc;
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
+	struct ath9k_vif_iter_data iter_data;
 
-	ath9k_set_bssid_mask(hw, vif);
+	ath9k_calculate_iter_data(hw, vif, &iter_data);
 
-	if (sc->nvifs > 1)
-		goto out; /* skip global settings for secondary vif */
+	/* Set BSSID mask. */
+	memcpy(common->bssidmask, iter_data.mask, ETH_ALEN);
+	ath_hw_setbssidmask(common);
 
-	if (ic_opmode == NL80211_IFTYPE_AP) {
+	/* Set op-mode & TSF */
+	if (iter_data.naps > 0) {
 		ath9k_hw_set_tsfadjust(ah, 1);
 		sc->sc_flags |= SC_OP_TSF_RESET;
-	}
+		ah->opmode = NL80211_IFTYPE_AP;
+	} else {
+		ath9k_hw_set_tsfadjust(ah, 0);
+		sc->sc_flags &= ~SC_OP_TSF_RESET;
 
-	/* Set the device opmode */
-	ah->opmode = ic_opmode;
+		if (iter_data.nwds + iter_data.nmeshes)
+			ah->opmode = NL80211_IFTYPE_AP;
+		else if (iter_data.nadhocs)
+			ah->opmode = NL80211_IFTYPE_ADHOC;
+		else
+			ah->opmode = NL80211_IFTYPE_STATION;
+	}
 
 	/*
 	 * Enable MIB interrupts when there are hardware phy counters.
-	 * Note we only do this (at the moment) for station mode.
 	 */
-	if ((vif->type == NL80211_IFTYPE_STATION) ||
-	    (vif->type == NL80211_IFTYPE_ADHOC) ||
-	    (vif->type == NL80211_IFTYPE_MESH_POINT)) {
+	if ((iter_data.nstations + iter_data.nadhocs + iter_data.nmeshes) > 0) {
 		if (ah->config.enable_ani)
 			ah->imask |= ATH9K_INT_MIB;
 		ah->imask |= ATH9K_INT_TSFOOR;
+	} else {
+		ah->imask &= ~ATH9K_INT_MIB;
+		ah->imask &= ~ATH9K_INT_TSFOOR;
 	}
 
 	ath9k_hw_set_interrupts(ah, ah->imask);
 
-	if (vif->type == NL80211_IFTYPE_AP    ||
-	    vif->type == NL80211_IFTYPE_ADHOC) {
+	/* Set up ANI */
+	if ((iter_data.naps + iter_data.nadhocs) > 0) {
 		sc->sc_flags |= SC_OP_ANI_RUN;
 		ath_start_ani(common);
+	} else {
+		sc->sc_flags &= ~SC_OP_ANI_RUN;
+		del_timer_sync(&common->ani.timer);
 	}
+}
 
-out:
-	mutex_unlock(&sc->mutex);
-	return ret;
+/* Called with sc->mutex held, vif counts set up properly. */
+static void ath9k_do_vif_add_setup(struct ieee80211_hw *hw,
+				   struct ieee80211_vif *vif)
+{
+	struct ath_wiphy *aphy = hw->priv;
+	struct ath_softc *sc = aphy->sc;
+
+	ath9k_calculate_summary_state(hw, vif);
+
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
+	sc->nvifs++;
+
+	ath9k_do_vif_add_setup(hw, vif);
+out:
+	mutex_unlock(&sc->mutex);
+	return ret;
 }
 
 static int ath9k_change_interface(struct ieee80211_hw *hw,
@@ -1487,32 +1626,33 @@ static int ath9k_change_interface(struct ieee80211_hw *hw,
 	ath_dbg(common, ATH_DBG_CONFIG, "Change Interface\n");
 	mutex_lock(&sc->mutex);
 
-	switch (new_type) {
-	case NL80211_IFTYPE_AP:
-	case NL80211_IFTYPE_ADHOC:
+	/* See if new interface type is valid. */
+	if ((new_type == NL80211_IFTYPE_ADHOC) &&
+	    (sc->nvifs > 1)) {
+		ath_err(common, "When using ADHOC, it must be the only"
+			" interface.\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (ath9k_uses_beacons(new_type) &&
+	    !ath9k_uses_beacons(vif->type)) {
 		if (sc->nbcnvifs >= ATH_BCBUF) {
 			ath_err(common, "No beacon slot available\n");
 			ret = -ENOBUFS;
 			goto out;
 		}
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
 	}
+
+	/* Clean up old vif stuff */
+	if (ath9k_uses_beacons(vif->type))
+		ath9k_reclaim_beacon(sc, vif);
+
+	/* Add new settings */
 	vif->type = new_type;
 	vif->p2p = p2p;
 
+	ath9k_do_vif_add_setup(hw, vif);
 out:
 	mutex_unlock(&sc->mutex);
 	return ret;
@@ -1529,17 +1669,13 @@ static void ath9k_remove_interface(struct ieee80211_hw *hw,
 
 	mutex_lock(&sc->mutex);
 
-	/* Stop ANI */
-	sc->sc_flags &= ~SC_OP_ANI_RUN;
-	del_timer_sync(&common->ani.timer);
+	sc->nvifs--;
 
 	/* Reclaim beacon resources */
-	if ((sc->sc_ah->opmode == NL80211_IFTYPE_AP) ||
-	    (sc->sc_ah->opmode == NL80211_IFTYPE_ADHOC) ||
-	    (sc->sc_ah->opmode == NL80211_IFTYPE_MESH_POINT))
+	if (ath9k_uses_beacons(vif->type))
 		ath9k_reclaim_beacon(sc, vif);
 
-	sc->nvifs--;
+	ath9k_calculate_summary_state(hw, NULL);
 
 	mutex_unlock(&sc->mutex);
 }
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index ea2f67c..8def8c2 100644
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
 
@@ -985,8 +991,14 @@ static void ath9k_process_rssi(struct ath_common *common,
 
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
diff --git a/drivers/net/wireless/ath/ath9k/virtual.c b/drivers/net/wireless/ath/ath9k/virtual.c
index 2dc7095..d205c66 100644
--- a/drivers/net/wireless/ath/ath9k/virtual.c
+++ b/drivers/net/wireless/ath/ath9k/virtual.c
@@ -18,54 +18,6 @@
 
 #include "ath9k.h"
 
-struct ath9k_vif_iter_data {
-	const u8 *hw_macaddr;
-	u8 mask[ETH_ALEN];
-};
-
-static void ath9k_vif_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
-{
-	struct ath9k_vif_iter_data *iter_data = data;
-	int i;
-
-	for (i = 0; i < ETH_ALEN; i++)
-		iter_data->mask[i] &= ~(iter_data->hw_macaddr[i] ^ mac[i]);
-}
-
-void ath9k_set_bssid_mask(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
-{
-	struct ath_wiphy *aphy = hw->priv;
-	struct ath_softc *sc = aphy->sc;
-	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
-	struct ath9k_vif_iter_data iter_data;
-	int i;
-
-	/*
-	 * Use the hardware MAC address as reference, the hardware uses it
-	 * together with the BSSID mask when matching addresses.
-	 */
-	iter_data.hw_macaddr = common->macaddr;
-	memset(&iter_data.mask, 0xff, ETH_ALEN);
-
-	if (vif)
-		ath9k_vif_iter(&iter_data, vif->addr, vif);
-
-	/* Get list of all active MAC addresses */
-	spin_lock_bh(&sc->wiphy_lock);
-	ieee80211_iterate_active_interfaces_atomic(sc->hw, ath9k_vif_iter,
-						   &iter_data);
-	for (i = 0; i < sc->num_sec_wiphy; i++) {
-		if (sc->sec_wiphy[i] == NULL)
-			continue;
-		ieee80211_iterate_active_interfaces_atomic(
-			sc->sec_wiphy[i]->hw, ath9k_vif_iter, &iter_data);
-	}
-	spin_unlock_bh(&sc->wiphy_lock);
-
-	memcpy(common->bssidmask, iter_data.mask, ETH_ALEN);
-	ath_hw_setbssidmask(common);
-}
-
 int ath9k_wiphy_add(struct ath_softc *sc)
 {
 	int i, error;
-- 
1.7.2.3

