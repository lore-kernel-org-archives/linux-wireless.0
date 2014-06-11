Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:11576 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754402AbaFKKtc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2014 06:49:32 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH 15/28] ath9k: Summarize hw state per channel context
Date: Wed, 11 Jun 2014 16:18:03 +0530
Message-ID: <1402483696-2498-16-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20140611_124941_578240_8C565370)
In-Reply-To: <1402483696-2498-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1402483696-2498-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Group and set hw state (opmode, primary_sta, beacon conf) per
channel context instead of whole list of vifs. This would allow
each channel context to run in different mode (STA/AP).

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h  |  13 +-
 drivers/net/wireless/ath/ath9k/beacon.c |  28 +++-
 drivers/net/wireless/ath/ath9k/debug.c  |  26 +--
 drivers/net/wireless/ath/ath9k/main.c   | 275 ++++++++++++++++----------------
 4 files changed, 184 insertions(+), 158 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index d632f8f..a0c7279 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -328,6 +328,9 @@ struct ath_chanctx {
 	struct list_head vifs;
 	struct list_head acq[IEEE80211_NUM_ACS];
 
+	/* do not dereference, use for comparison only */
+	struct ieee80211_vif *primary_sta;
+
 	struct ath_beacon_config beacon;
 	struct ath9k_hw_cal_data caldata;
 	struct timespec tsf_ts;
@@ -438,7 +441,6 @@ struct ath_vif {
 	struct ieee80211_vif *vif;
 	struct ath_node mcast_node;
 	int av_bslot;
-	bool primary_sta_vif;
 	__le64 tsf_adjust; /* TSF adjustment for staggered beacons */
 	struct ath_buf *av_bcbuf;
 	struct ath_chanctx *chanctx;
@@ -451,17 +453,22 @@ struct ath9k_vif_iter_data {
 	u8 hw_macaddr[ETH_ALEN]; /* address of the first vif */
 	u8 mask[ETH_ALEN]; /* bssid mask */
 	bool has_hw_macaddr;
+	u8 slottime;
+	bool beacons;
 
 	int naps;      /* number of AP vifs */
 	int nmeshes;   /* number of mesh vifs */
 	int nstations; /* number of station vifs */
 	int nwds;      /* number of WDS vifs */
 	int nadhocs;   /* number of adhoc vifs */
+	struct ieee80211_vif *primary_sta;
 };
 
-void ath9k_calculate_iter_data(struct ieee80211_hw *hw,
-			       struct ieee80211_vif *vif,
+void ath9k_calculate_iter_data(struct ath_softc *sc,
+			       struct ath_chanctx *ctx,
 			       struct ath9k_vif_iter_data *iter_data);
+void ath9k_calculate_summary_state(struct ath_softc *sc,
+				   struct ath_chanctx *ctx);
 
 /*******************/
 /* Beacon Handling */
diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index c0ff015..d355392 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -277,8 +277,8 @@ static int ath9k_beacon_choose_slot(struct ath_softc *sc)
 static void ath9k_set_tsfadjust(struct ath_softc *sc, struct ieee80211_vif *vif)
 {
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
-	struct ath_beacon_config *cur_conf = &sc->cur_chan->beacon;
 	struct ath_vif *avp = (void *)vif->drv_priv;
+	struct ath_beacon_config *cur_conf = &avp->chanctx->beacon;
 	u32 tsfadjust;
 
 	if (avp->av_bslot == 0)
@@ -500,7 +500,6 @@ static bool ath9k_allow_beacon_config(struct ath_softc *sc,
 				      struct ieee80211_vif *vif)
 {
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
-	struct ath_vif *avp = (void *)vif->drv_priv;
 
 	if (sc->sc_ah->opmode == NL80211_IFTYPE_AP) {
 		if ((vif->type != NL80211_IFTYPE_AP) ||
@@ -514,7 +513,7 @@ static bool ath9k_allow_beacon_config(struct ath_softc *sc,
 	if (sc->sc_ah->opmode == NL80211_IFTYPE_STATION) {
 		if ((vif->type == NL80211_IFTYPE_STATION) &&
 		    test_bit(ATH_OP_BEACONS, &common->op_flags) &&
-		    !avp->primary_sta_vif) {
+		    vif != sc->cur_chan->primary_sta) {
 			ath_dbg(common, CONFIG,
 				"Beacon already configured for a station interface\n");
 			return false;
@@ -525,10 +524,11 @@ static bool ath9k_allow_beacon_config(struct ath_softc *sc,
 }
 
 static void ath9k_cache_beacon_config(struct ath_softc *sc,
+				      struct ath_chanctx *ctx,
 				      struct ieee80211_bss_conf *bss_conf)
 {
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
-	struct ath_beacon_config *cur_conf = &sc->cur_chan->beacon;
+	struct ath_beacon_config *cur_conf = &ctx->beacon;
 
 	ath_dbg(common, BEACON,
 		"Caching beacon data for BSS: %pM\n", bss_conf->bssid);
@@ -564,20 +564,29 @@ void ath9k_beacon_config(struct ath_softc *sc, struct ieee80211_vif *vif,
 			 u32 changed)
 {
 	struct ieee80211_bss_conf *bss_conf = &vif->bss_conf;
-	struct ath_beacon_config *cur_conf = &sc->cur_chan->beacon;
         struct ath_hw *ah = sc->sc_ah;
         struct ath_common *common = ath9k_hw_common(ah);
+	struct ath_vif *avp = (void *)vif->drv_priv;
+	struct ath_chanctx *ctx = avp->chanctx;
+	struct ath_beacon_config *cur_conf;
 	unsigned long flags;
 	bool skip_beacon = false;
 
+	if (!ctx)
+		return;
+
+	cur_conf = &avp->chanctx->beacon;
 	if (vif->type == NL80211_IFTYPE_AP)
 		ath9k_set_tsfadjust(sc, vif);
 
 	if (!ath9k_allow_beacon_config(sc, vif))
 		return;
 
-	if (sc->sc_ah->opmode == NL80211_IFTYPE_STATION) {
-		ath9k_cache_beacon_config(sc, bss_conf);
+	if (vif->type == NL80211_IFTYPE_STATION) {
+		ath9k_cache_beacon_config(sc, ctx, bss_conf);
+		if (ctx != sc->cur_chan)
+			return;
+
 		ath9k_set_beacon(sc);
 		set_bit(ATH_OP_BEACONS, &common->op_flags);
 		return;
@@ -593,10 +602,13 @@ void ath9k_beacon_config(struct ath_softc *sc, struct ieee80211_vif *vif,
 			cur_conf->enable_beacon = false;
 		} else if (bss_conf->enable_beacon) {
 			cur_conf->enable_beacon = true;
-			ath9k_cache_beacon_config(sc, bss_conf);
+			ath9k_cache_beacon_config(sc, ctx, bss_conf);
 		}
 	}
 
+	if (ctx != sc->cur_chan)
+		return;
+
 	/*
 	 * Configure the HW beacon registers only when we have a valid
 	 * beacon interval.
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index f230e2e9..ce073e9 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -750,13 +750,13 @@ static ssize_t read_file_misc(struct file *file, char __user *user_buf,
 {
 	struct ath_softc *sc = file->private_data;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
-	struct ieee80211_hw *hw = sc->hw;
 	struct ath9k_vif_iter_data iter_data;
+	struct ath_chanctx *ctx;
 	char buf[512];
 	unsigned int len = 0;
 	ssize_t retval = 0;
 	unsigned int reg;
-	u32 rxfilter;
+	u32 rxfilter, i;
 
 	len += scnprintf(buf + len, sizeof(buf) - len,
 			 "BSSID: %pM\n", common->curbssid);
@@ -826,14 +826,20 @@ static ssize_t read_file_misc(struct file *file, char __user *user_buf,
 
 	len += scnprintf(buf + len, sizeof(buf) - len, "\n");
 
-	ath9k_calculate_iter_data(hw, NULL, &iter_data);
-
-	len += scnprintf(buf + len, sizeof(buf) - len,
-			 "VIF-COUNTS: AP: %i STA: %i MESH: %i WDS: %i"
-			 " ADHOC: %i TOTAL: %hi BEACON-VIF: %hi\n",
-			 iter_data.naps, iter_data.nstations, iter_data.nmeshes,
-			 iter_data.nwds, iter_data.nadhocs,
-			 sc->nvifs, sc->nbcnvifs);
+	i = 0;
+	ath_for_each_chanctx(sc, ctx) {
+		if (!ctx->assigned || list_empty(&ctx->vifs))
+			continue;
+		ath9k_calculate_iter_data(sc, ctx, &iter_data);
+
+		len += scnprintf(buf + len, sizeof(buf) - len,
+			"VIF-COUNTS: CTX %i AP: %i STA: %i MESH: %i WDS: %i",
+			i++, iter_data.naps, iter_data.nstations,
+			iter_data.nmeshes, iter_data.nwds);
+		len += scnprintf(buf + len, sizeof(buf) - len,
+			" ADHOC: %i TOTAL: %hi BEACON-VIF: %hi\n",
+			iter_data.nadhocs, sc->nvifs, sc->nbcnvifs);
+	}
 
 	if (len > sizeof(buf))
 		len = sizeof(buf);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 6abdf99..9dfb820 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -19,9 +19,6 @@
 #include "ath9k.h"
 #include "btcoex.h"
 
-static void ath9k_set_assoc_state(struct ath_softc *sc,
-				  struct ieee80211_vif *vif);
-
 u8 ath9k_parse_mpdudensity(u8 mpdudensity)
 {
 	/*
@@ -236,8 +233,7 @@ static bool ath_complete_reset(struct ath_softc *sc, bool start)
 			       sc->cur_chan->txpower, &sc->curtxpow);
 
 	clear_bit(ATH_OP_HW_RESET, &common->op_flags);
-	ath9k_hw_set_interrupts(ah);
-	ath9k_hw_enable_interrupts(ah);
+	ath9k_calculate_summary_state(sc, sc->cur_chan);
 
 	if (!sc->cur_chan->offchannel && start) {
 		/* restore per chanctx TSF timer */
@@ -267,6 +263,10 @@ static bool ath_complete_reset(struct ath_softc *sc, bool start)
 	}
 
 	sc->gtt_cnt = 0;
+
+	ath9k_hw_set_interrupts(ah);
+	ath9k_hw_enable_interrupts(ah);
+
 	ieee80211_wake_queues(sc->hw);
 
 	ath9k_p2p_ps_timer(sc);
@@ -905,18 +905,29 @@ static void ath9k_vif_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
 		iter_data->has_hw_macaddr = true;
 	}
 
+	if (!vif->bss_conf.use_short_slot)
+		iter_data->slottime = ATH9K_SLOT_TIME_20;
+
 	switch (vif->type) {
 	case NL80211_IFTYPE_AP:
 		iter_data->naps++;
+		if (vif->bss_conf.enable_beacon)
+			iter_data->beacons = true;
 		break;
 	case NL80211_IFTYPE_STATION:
 		iter_data->nstations++;
+		if (vif->bss_conf.assoc && !iter_data->primary_sta)
+			iter_data->primary_sta = vif;
 		break;
 	case NL80211_IFTYPE_ADHOC:
 		iter_data->nadhocs++;
+		if (vif->bss_conf.enable_beacon)
+			iter_data->beacons = true;
 		break;
 	case NL80211_IFTYPE_MESH_POINT:
 		iter_data->nmeshes++;
+		if (vif->bss_conf.enable_beacon)
+			iter_data->beacons = true;
 		break;
 	case NL80211_IFTYPE_WDS:
 		iter_data->nwds++;
@@ -926,26 +937,12 @@ static void ath9k_vif_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
 	}
 }
 
-static void ath9k_sta_vif_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
-{
-	struct ath_softc *sc = data;
-	struct ath_vif *avp = (void *)vif->drv_priv;
-
-	if (vif->type != NL80211_IFTYPE_STATION)
-		return;
-
-	if (avp->primary_sta_vif)
-		ath9k_set_assoc_state(sc, vif);
-}
-
 /* Called with sc->mutex held. */
-void ath9k_calculate_iter_data(struct ieee80211_hw *hw,
-			       struct ieee80211_vif *vif,
+void ath9k_calculate_iter_data(struct ath_softc *sc,
+			       struct ath_chanctx *ctx,
 			       struct ath9k_vif_iter_data *iter_data)
 {
-	struct ath_softc *sc = hw->priv;
-	struct ath_hw *ah = sc->sc_ah;
-	struct ath_common *common = ath9k_hw_common(ah);
+	struct ath_vif *avp;
 
 	/*
 	 * Pick the MAC address of the first interface as the new hardware
@@ -954,29 +951,80 @@ void ath9k_calculate_iter_data(struct ieee80211_hw *hw,
 	 */
 	memset(iter_data, 0, sizeof(*iter_data));
 	memset(&iter_data->mask, 0xff, ETH_ALEN);
+	iter_data->slottime = ATH9K_SLOT_TIME_9;
+
+	list_for_each_entry(avp, &ctx->vifs, list)
+		ath9k_vif_iter(iter_data, avp->vif->addr, avp->vif);
+
+	if (ctx == &sc->offchannel.chan) {
+		struct ieee80211_vif *vif;
+
+		if (sc->offchannel.state < ATH_OFFCHANNEL_ROC_START)
+			vif = sc->offchannel.scan_vif;
+		else
+			vif = sc->offchannel.roc_vif;
+
+		if (vif)
+			ath9k_vif_iter(iter_data, vif->addr, vif);
+		iter_data->beacons = false;
+	}
+}
+
+static void ath9k_set_assoc_state(struct ath_softc *sc,
+				  struct ieee80211_vif *vif, bool changed)
+{
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	struct ieee80211_bss_conf *bss_conf = &vif->bss_conf;
+	unsigned long flags;
+
+	set_bit(ATH_OP_PRIM_STA_VIF, &common->op_flags);
+	/* Set the AID, BSSID and do beacon-sync only when
+	 * the HW opmode is STATION.
+	 *
+	 * But the primary bit is set above in any case.
+	 */
+	if (sc->sc_ah->opmode != NL80211_IFTYPE_STATION)
+		return;
+
+	ether_addr_copy(common->curbssid, bss_conf->bssid);
+	common->curaid = bss_conf->aid;
+	ath9k_hw_write_associd(sc->sc_ah);
+
+	if (changed) {
+		common->last_rssi = ATH_RSSI_DUMMY_MARKER;
+		sc->sc_ah->stats.avgbrssi = ATH_RSSI_DUMMY_MARKER;
 
-	if (vif)
-		ath9k_vif_iter(iter_data, vif->addr, vif);
+		spin_lock_irqsave(&sc->sc_pm_lock, flags);
+		sc->ps_flags |= PS_BEACON_SYNC | PS_WAIT_FOR_BEACON;
+		spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
+	}
 
-	/* Get list of all active MAC addresses */
-	ieee80211_iterate_active_interfaces_atomic(
-		sc->hw, IEEE80211_IFACE_ITER_RESUME_ALL,
-		ath9k_vif_iter, iter_data);
+	if (ath9k_hw_mci_is_enabled(sc->sc_ah))
+		ath9k_mci_update_wlan_channels(sc, false);
 
-	memcpy(common->macaddr, iter_data->hw_macaddr, ETH_ALEN);
+	ath_dbg(common, CONFIG,
+		"Primary Station interface: %pM, BSSID: %pM\n",
+		vif->addr, common->curbssid);
 }
 
 /* Called with sc->mutex held. */
-static void ath9k_calculate_summary_state(struct ieee80211_hw *hw,
-					  struct ieee80211_vif *vif)
+void ath9k_calculate_summary_state(struct ath_softc *sc,
+				   struct ath_chanctx *ctx)
 {
-	struct ath_softc *sc = hw->priv;
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath9k_vif_iter_data iter_data;
-	enum nl80211_iftype old_opmode = ah->opmode;
 
-	ath9k_calculate_iter_data(hw, vif, &iter_data);
+	ath_chanctx_check_active(sc, ctx);
+
+	if (ctx != sc->cur_chan)
+		return;
+
+	ath9k_ps_wakeup(sc);
+	ath9k_calculate_iter_data(sc, ctx, &iter_data);
+
+	if (iter_data.has_hw_macaddr)
+		ether_addr_copy(common->macaddr, iter_data.hw_macaddr);
 
 	memcpy(common->bssidmask, iter_data.mask, ETH_ALEN);
 	ath_hw_setbssidmask(common);
@@ -1004,19 +1052,48 @@ static void ath9k_calculate_summary_state(struct ieee80211_hw *hw,
 	else
 		ah->imask &= ~ATH9K_INT_TSFOOR;
 
+	ah->imask &= ~ATH9K_INT_SWBA;
+	if (ah->opmode == NL80211_IFTYPE_STATION) {
+		bool changed = (iter_data.primary_sta != ctx->primary_sta);
+
+		iter_data.beacons = true;
+		if (iter_data.primary_sta) {
+			ath9k_set_assoc_state(sc, iter_data.primary_sta,
+					      changed);
+			if (!ctx->primary_sta ||
+			    !ctx->primary_sta->bss_conf.assoc)
+				ctx->primary_sta = iter_data.primary_sta;
+		} else {
+			ctx->primary_sta = NULL;
+			memset(common->curbssid, 0, ETH_ALEN);
+			common->curaid = 0;
+			ath9k_hw_write_associd(sc->sc_ah);
+			if (ath9k_hw_mci_is_enabled(sc->sc_ah))
+				ath9k_mci_update_wlan_channels(sc, true);
+		}
+	} else if (iter_data.beacons) {
+		ah->imask |= ATH9K_INT_SWBA;
+	}
 	ath9k_hw_set_interrupts(ah);
 
-	/*
-	 * If we are changing the opmode to STATION,
-	 * a beacon sync needs to be done.
-	 */
-	if (ah->opmode == NL80211_IFTYPE_STATION &&
-	    old_opmode == NL80211_IFTYPE_AP &&
-	    test_bit(ATH_OP_PRIM_STA_VIF, &common->op_flags)) {
-		ieee80211_iterate_active_interfaces_atomic(
-			sc->hw, IEEE80211_IFACE_ITER_RESUME_ALL,
-			ath9k_sta_vif_iter, sc);
+	if (iter_data.beacons)
+		set_bit(ATH_OP_BEACONS, &common->op_flags);
+	else
+		clear_bit(ATH_OP_BEACONS, &common->op_flags);
+
+	if (ah->slottime != iter_data.slottime) {
+		ah->slottime = iter_data.slottime;
+		ath9k_hw_init_global_settings(ah);
 	}
+
+	if (iter_data.primary_sta)
+		set_bit(ATH_OP_PRIM_STA_VIF, &common->op_flags);
+	else
+		clear_bit(ATH_OP_PRIM_STA_VIF, &common->op_flags);
+
+	ctx->primary_sta = iter_data.primary_sta;
+
+	ath9k_ps_restore(sc);
 }
 
 static int ath9k_add_interface(struct ieee80211_hw *hw,
@@ -1041,16 +1118,14 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 	ath_dbg(common, CONFIG, "Attach a VIF of type: %d\n", vif->type);
 	sc->nvifs++;
 
-	ath9k_ps_wakeup(sc);
-	ath9k_calculate_summary_state(hw, vif);
-	ath9k_ps_restore(sc);
-
 	if (ath9k_uses_beacons(vif->type))
 		ath9k_beacon_assign_slot(sc, vif);
 
 	avp->vif = vif;
-	if (!ath9k_use_chanctx)
+	if (!ath9k_use_chanctx) {
 		avp->chanctx = sc->cur_chan;
+		list_add_tail(&avp->list, &avp->chanctx->vifs);
+	}
 
 	an->sc = sc;
 	an->sta = NULL;
@@ -1086,13 +1161,10 @@ static int ath9k_change_interface(struct ieee80211_hw *hw,
 	vif->type = new_type;
 	vif->p2p = p2p;
 
-	ath9k_ps_wakeup(sc);
-	ath9k_calculate_summary_state(hw, vif);
-	ath9k_ps_restore(sc);
-
 	if (ath9k_uses_beacons(vif->type))
 		ath9k_beacon_assign_slot(sc, vif);
-	ath_chanctx_check_active(sc, avp->chanctx);
+
+	ath9k_calculate_summary_state(sc, avp->chanctx);
 
 	mutex_unlock(&sc->mutex);
 	return 0;
@@ -1141,14 +1213,12 @@ static void ath9k_remove_interface(struct ieee80211_hw *hw,
 
 	sc->nvifs--;
 	sc->tx99_vif = NULL;
+	if (!ath9k_use_chanctx)
+		list_del(&avp->list);
 
 	if (ath9k_uses_beacons(vif->type))
 		ath9k_beacon_remove_slot(sc, vif);
 
-	ath9k_ps_wakeup(sc);
-	ath9k_calculate_summary_state(hw, NULL);
-	ath9k_ps_restore(sc);
-
 	ath_tx_node_cleanup(sc, &avp->mcast_node);
 
 	mutex_unlock(&sc->mutex);
@@ -1585,58 +1655,6 @@ static int ath9k_set_key(struct ieee80211_hw *hw,
 	return ret;
 }
 
-static void ath9k_set_assoc_state(struct ath_softc *sc,
-				  struct ieee80211_vif *vif)
-{
-	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
-	struct ath_vif *avp = (void *)vif->drv_priv;
-	struct ieee80211_bss_conf *bss_conf = &vif->bss_conf;
-	unsigned long flags;
-
-	set_bit(ATH_OP_PRIM_STA_VIF, &common->op_flags);
-	avp->primary_sta_vif = true;
-
-	/*
-	 * Set the AID, BSSID and do beacon-sync only when
-	 * the HW opmode is STATION.
-	 *
-	 * But the primary bit is set above in any case.
-	 */
-	if (sc->sc_ah->opmode != NL80211_IFTYPE_STATION)
-		return;
-
-	memcpy(common->curbssid, bss_conf->bssid, ETH_ALEN);
-	common->curaid = bss_conf->aid;
-	ath9k_hw_write_associd(sc->sc_ah);
-
-	common->last_rssi = ATH_RSSI_DUMMY_MARKER;
-	sc->sc_ah->stats.avgbrssi = ATH_RSSI_DUMMY_MARKER;
-
-	spin_lock_irqsave(&sc->sc_pm_lock, flags);
-	sc->ps_flags |= PS_BEACON_SYNC | PS_WAIT_FOR_BEACON;
-	spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
-
-	if (ath9k_hw_mci_is_enabled(sc->sc_ah))
-		ath9k_mci_update_wlan_channels(sc, false);
-
-	ath_dbg(common, CONFIG,
-		"Primary Station interface: %pM, BSSID: %pM\n",
-		vif->addr, common->curbssid);
-}
-
-static void ath9k_bss_assoc_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
-{
-	struct ath_softc *sc = data;
-	struct ieee80211_bss_conf *bss_conf = &vif->bss_conf;
-	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
-
-	if (test_bit(ATH_OP_PRIM_STA_VIF, &common->op_flags))
-		return;
-
-	if (bss_conf->assoc)
-		ath9k_set_assoc_state(sc, vif);
-}
-
 void ath9k_p2p_ps_timer(void *priv)
 {
 	struct ath_softc *sc = priv;
@@ -1646,7 +1664,7 @@ void ath9k_p2p_ps_timer(void *priv)
 	struct ath_node *an;
 	u32 tsf;
 
-	if (!avp)
+	if (!avp || avp->chanctx != sc->cur_chan)
 		return;
 
 	tsf = ath9k_hw_gettsf32(sc->sc_ah);
@@ -1721,28 +1739,7 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 		ath_dbg(common, CONFIG, "BSSID %pM Changed ASSOC %d\n",
 			bss_conf->bssid, bss_conf->assoc);
 
-		if (avp->primary_sta_vif && !bss_conf->assoc) {
-			clear_bit(ATH_OP_PRIM_STA_VIF, &common->op_flags);
-			avp->primary_sta_vif = false;
-
-			if (ah->opmode == NL80211_IFTYPE_STATION)
-				clear_bit(ATH_OP_BEACONS, &common->op_flags);
-		}
-
-		ieee80211_iterate_active_interfaces_atomic(
-			sc->hw, IEEE80211_IFACE_ITER_RESUME_ALL,
-			ath9k_bss_assoc_iter, sc);
-
-		if (!test_bit(ATH_OP_PRIM_STA_VIF, &common->op_flags) &&
-		    ah->opmode == NL80211_IFTYPE_STATION) {
-			memset(common->curbssid, 0, ETH_ALEN);
-			common->curaid = 0;
-			ath9k_hw_write_associd(sc->sc_ah);
-			if (ath9k_hw_mci_is_enabled(sc->sc_ah))
-				ath9k_mci_update_wlan_channels(sc, true);
-		}
-
-		ath_chanctx_check_active(sc, avp->chanctx);
+		ath9k_calculate_summary_state(sc, avp->chanctx);
 	}
 
 	if (changed & BSS_CHANGED_IBSS) {
@@ -1752,10 +1749,14 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 	}
 
 	if ((changed & BSS_CHANGED_BEACON_ENABLED) ||
-	    (changed & BSS_CHANGED_BEACON_INT))
+	    (changed & BSS_CHANGED_BEACON_INT)) {
+		if (changed & BSS_CHANGED_BEACON_ENABLED)
+			ath9k_calculate_summary_state(sc, avp->chanctx);
 		ath9k_beacon_config(sc, vif, changed);
+	}
 
-	if (changed & BSS_CHANGED_ERP_SLOT) {
+	if ((avp->chanctx == sc->cur_chan) &&
+	    (changed & BSS_CHANGED_ERP_SLOT)) {
 		if (bss_conf->use_short_slot)
 			slottime = 9;
 		else
@@ -2500,7 +2501,7 @@ static int ath9k_assign_vif_chanctx(struct ieee80211_hw *hw,
 	mutex_lock(&sc->mutex);
 	avp->chanctx = ctx;
 	list_add_tail(&avp->list, &ctx->vifs);
-	ath_chanctx_check_active(sc, ctx);
+	ath9k_calculate_summary_state(sc, ctx);
 	mutex_unlock(&sc->mutex);
 
 	return 0;
@@ -2517,7 +2518,7 @@ static void ath9k_unassign_vif_chanctx(struct ieee80211_hw *hw,
 	mutex_lock(&sc->mutex);
 	avp->chanctx = NULL;
 	list_del(&avp->list);
-	ath_chanctx_check_active(sc, ctx);
+	ath9k_calculate_summary_state(sc, ctx);
 	mutex_unlock(&sc->mutex);
 }
 
-- 
2.0.0

