Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:35356 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752948Ab1AXSXZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jan 2011 13:23:25 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH v4 3/5] ath9k: remove support for virtual wiphys
Date: Mon, 24 Jan 2011 19:23:16 +0100
Message-Id: <1295893398-5124-3-git-send-email-nbd@openwrt.org>
In-Reply-To: <1295893398-5124-2-git-send-email-nbd@openwrt.org>
References: <1295893398-5124-1-git-send-email-nbd@openwrt.org>
 <1295893398-5124-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/Makefile  |    1 -
 drivers/net/wireless/ath/ath9k/ahb.c     |    1 -
 drivers/net/wireless/ath/ath9k/ath9k.h   |   41 --
 drivers/net/wireless/ath/ath9k/beacon.c  |    9 +-
 drivers/net/wireless/ath/ath9k/init.c    |   19 +-
 drivers/net/wireless/ath/ath9k/main.c    |  141 +------
 drivers/net/wireless/ath/ath9k/pci.c     |    2 -
 drivers/net/wireless/ath/ath9k/recv.c    |   63 +---
 drivers/net/wireless/ath/ath9k/virtual.c |  669 ------------------------------
 drivers/net/wireless/ath/ath9k/xmit.c    |   28 +-
 10 files changed, 23 insertions(+), 951 deletions(-)
 delete mode 100644 drivers/net/wireless/ath/ath9k/virtual.c

diff --git a/drivers/net/wireless/ath/ath9k/Makefile b/drivers/net/wireless/ath/ath9k/Makefile
index aca0162..4d66ca8 100644
--- a/drivers/net/wireless/ath/ath9k/Makefile
+++ b/drivers/net/wireless/ath/ath9k/Makefile
@@ -4,7 +4,6 @@ ath9k-y +=	beacon.o \
 		main.o \
 		recv.o \
 		xmit.o \
-		virtual.o \
 
 ath9k-$(CONFIG_ATH9K_RATE_CONTROL) += rc.o
 ath9k-$(CONFIG_PCI) += pci.o
diff --git a/drivers/net/wireless/ath/ath9k/ahb.c b/drivers/net/wireless/ath/ath9k/ahb.c
index 25a6e44..72f430e 100644
--- a/drivers/net/wireless/ath/ath9k/ahb.c
+++ b/drivers/net/wireless/ath/ath9k/ahb.c
@@ -107,7 +107,6 @@ static int ath_ahb_probe(struct platform_device *pdev)
 	sc = (struct ath_softc *) (aphy + 1);
 	aphy->sc = sc;
 	aphy->hw = hw;
-	sc->pri_wiphy = aphy;
 	sc->hw = hw;
 	sc->dev = &pdev->dev;
 	sc->mem = mem;
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index dab0271..76e8c0c 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -389,7 +389,6 @@ struct ath_beacon {
 	u32 ast_be_xmit;
 	u64 bc_tstamp;
 	struct ieee80211_vif *bslot[ATH_BCBUF];
-	struct ath_wiphy *bslot_aphy[ATH_BCBUF];
 	int slottime;
 	int slotupdate;
 	struct ath9k_tx_queue_info beacon_qi;
@@ -586,20 +585,8 @@ struct ath_softc {
 	struct ieee80211_hw *hw;
 	struct device *dev;
 
-	spinlock_t wiphy_lock; /* spinlock to protect ath_wiphy data */
-	struct ath_wiphy *pri_wiphy;
-	struct ath_wiphy **sec_wiphy; /* secondary wiphys (virtual radios); may
-				       * have NULL entries */
-	int num_sec_wiphy; /* number of sec_wiphy pointers in the array */
 	int chan_idx;
 	int chan_is_ht;
-	struct ath_wiphy *next_wiphy;
-	struct work_struct chan_work;
-	int wiphy_select_failures;
-	unsigned long wiphy_select_first_fail;
-	struct delayed_work wiphy_work;
-	unsigned long wiphy_scheduler_int;
-	int wiphy_scheduler_index;
 	struct survey_info *cur_survey;
 	struct survey_info survey[ATH9K_NUM_CHANNELS];
 
@@ -666,16 +653,6 @@ struct ath_wiphy {
 	struct ath_softc *sc; /* shared for all virtual wiphys */
 	struct ieee80211_hw *hw;
 	struct ath9k_hw_cal_data caldata;
-	enum ath_wiphy_state {
-		ATH_WIPHY_INACTIVE,
-		ATH_WIPHY_ACTIVE,
-		ATH_WIPHY_PAUSING,
-		ATH_WIPHY_PAUSED,
-		ATH_WIPHY_SCAN,
-	} state;
-	bool idle;
-	int chan_idx;
-	int chan_is_ht;
 	int last_rssi;
 };
 
@@ -732,24 +709,6 @@ void ath9k_ps_restore(struct ath_softc *sc);
 u8 ath_txchainmask_reduction(struct ath_softc *sc, u8 chainmask, u32 rate);
 
 void ath9k_set_bssid_mask(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
-int ath9k_wiphy_add(struct ath_softc *sc);
-int ath9k_wiphy_del(struct ath_wiphy *aphy);
-void ath9k_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb, int ftype);
-int ath9k_wiphy_pause(struct ath_wiphy *aphy);
-int ath9k_wiphy_unpause(struct ath_wiphy *aphy);
-int ath9k_wiphy_select(struct ath_wiphy *aphy);
-void ath9k_wiphy_set_scheduler(struct ath_softc *sc, unsigned int msec_int);
-void ath9k_wiphy_chan_work(struct work_struct *work);
-bool ath9k_wiphy_started(struct ath_softc *sc);
-void ath9k_wiphy_pause_all_forced(struct ath_softc *sc,
-				  struct ath_wiphy *selected);
-bool ath9k_wiphy_scanning(struct ath_softc *sc);
-void ath9k_wiphy_work(struct work_struct *work);
-bool ath9k_all_wiphys_idle(struct ath_softc *sc);
-void ath9k_set_wiphy_idle(struct ath_wiphy *aphy, bool idle);
-
-void ath_mac80211_stop_queue(struct ath_softc *sc, u16 skb_queue);
-bool ath_mac80211_start_queue(struct ath_softc *sc, u16 skb_queue);
 
 void ath_start_rfkill_poll(struct ath_softc *sc);
 extern void ath9k_rfkill_poll_state(struct ieee80211_hw *hw);
diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index ab8c05c..77c8e70 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -142,9 +142,6 @@ static struct ath_buf *ath_beacon_generate(struct ieee80211_hw *hw,
 	struct ieee80211_tx_info *info;
 	int cabq_depth;
 
-	if (aphy->state != ATH_WIPHY_ACTIVE)
-		return NULL;
-
 	avp = (void *)vif->drv_priv;
 	cabq = sc->beacon.cabq;
 
@@ -261,7 +258,6 @@ int ath_beacon_alloc(struct ath_wiphy *aphy, struct ieee80211_vif *vif)
 				}
 			BUG_ON(sc->beacon.bslot[avp->av_bslot] != NULL);
 			sc->beacon.bslot[avp->av_bslot] = vif;
-			sc->beacon.bslot_aphy[avp->av_bslot] = aphy;
 			sc->nbcnvifs++;
 		}
 	}
@@ -332,7 +328,6 @@ void ath_beacon_return(struct ath_softc *sc, struct ath_vif *avp)
 
 		if (avp->av_bslot != -1) {
 			sc->beacon.bslot[avp->av_bslot] = NULL;
-			sc->beacon.bslot_aphy[avp->av_bslot] = NULL;
 			sc->nbcnvifs--;
 		}
 
@@ -358,7 +353,6 @@ void ath_beacon_tasklet(unsigned long data)
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath_buf *bf = NULL;
 	struct ieee80211_vif *vif;
-	struct ath_wiphy *aphy;
 	int slot;
 	u32 bfaddr, bc = 0, tsftu;
 	u64 tsf;
@@ -416,7 +410,6 @@ void ath_beacon_tasklet(unsigned long data)
 	 */
 	slot = ATH_BCBUF - slot - 1;
 	vif = sc->beacon.bslot[slot];
-	aphy = sc->beacon.bslot_aphy[slot];
 
 	ath_dbg(common, ATH_DBG_BEACON,
 		"slot %d [tsf %llu tsftu %u intval %u] vif %p\n",
@@ -424,7 +417,7 @@ void ath_beacon_tasklet(unsigned long data)
 
 	bfaddr = 0;
 	if (vif) {
-		bf = ath_beacon_generate(aphy->hw, vif);
+		bf = ath_beacon_generate(sc->hw, vif);
 		if (bf != NULL) {
 			bfaddr = bf->bf_daddr;
 			bc = 1;
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 5279653..88ff399 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -517,10 +517,8 @@ static void ath9k_init_misc(struct ath_softc *sc)
 
 	sc->beacon.slottime = ATH9K_SLOT_TIME_9;
 
-	for (i = 0; i < ARRAY_SIZE(sc->beacon.bslot); i++) {
+	for (i = 0; i < ARRAY_SIZE(sc->beacon.bslot); i++)
 		sc->beacon.bslot[i] = NULL;
-		sc->beacon.bslot_aphy[i] = NULL;
-	}
 
 	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_ANT_DIV_COMB)
 		sc->ant_comb.count = ATH_ANT_DIV_COMB_INIT_COUNT;
@@ -556,7 +554,6 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid,
 	common->btcoex_enabled = ath9k_btcoex_enable == 1;
 	spin_lock_init(&common->cc_lock);
 
-	spin_lock_init(&sc->wiphy_lock);
 	spin_lock_init(&sc->sc_serial_rw);
 	spin_lock_init(&sc->sc_pm_lock);
 	mutex_init(&sc->mutex);
@@ -762,9 +759,6 @@ int ath9k_init_device(u16 devid, struct ath_softc *sc, u16 subsysid,
 
 	INIT_WORK(&sc->hw_check_work, ath_hw_check);
 	INIT_WORK(&sc->paprd_work, ath_paprd_calibrate);
-	INIT_WORK(&sc->chan_work, ath9k_wiphy_chan_work);
-	INIT_DELAYED_WORK(&sc->wiphy_work, ath9k_wiphy_work);
-	sc->wiphy_scheduler_int = msecs_to_jiffies(500);
 	aphy->last_rssi = ATH_RSSI_DUMMY_MARKER;
 
 	ath_init_leds(sc);
@@ -823,28 +817,17 @@ static void ath9k_deinit_softc(struct ath_softc *sc)
 void ath9k_deinit_device(struct ath_softc *sc)
 {
 	struct ieee80211_hw *hw = sc->hw;
-	int i = 0;
 
 	ath9k_ps_wakeup(sc);
 
 	wiphy_rfkill_stop_polling(sc->hw->wiphy);
 	ath_deinit_leds(sc);
 
-	for (i = 0; i < sc->num_sec_wiphy; i++) {
-		struct ath_wiphy *aphy = sc->sec_wiphy[i];
-		if (aphy == NULL)
-			continue;
-		sc->sec_wiphy[i] = NULL;
-		ieee80211_unregister_hw(aphy->hw);
-		ieee80211_free_hw(aphy->hw);
-	}
-
 	ieee80211_unregister_hw(hw);
 	pm_qos_remove_request(&sc->pm_qos_req);
 	ath_rx_cleanup(sc);
 	ath_tx_cleanup(sc);
 	ath9k_deinit_softc(sc);
-	kfree(sc->sec_wiphy);
 }
 
 void ath_descdma_cleanup(struct ath_softc *sc,
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 7d7b48f..20ccad7 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1089,29 +1089,7 @@ static int ath9k_start(struct ieee80211_hw *hw)
 
 	mutex_lock(&sc->mutex);
 
-	if (ath9k_wiphy_started(sc)) {
-		if (sc->chan_idx == curchan->hw_value) {
-			/*
-			 * Already on the operational channel, the new wiphy
-			 * can be marked active.
-			 */
-			aphy->state = ATH_WIPHY_ACTIVE;
-			ieee80211_wake_queues(hw);
-		} else {
-			/*
-			 * Another wiphy is on another channel, start the new
-			 * wiphy in paused state.
-			 */
-			aphy->state = ATH_WIPHY_PAUSED;
-			ieee80211_stop_queues(hw);
-		}
-		mutex_unlock(&sc->mutex);
-		return 0;
-	}
-	aphy->state = ATH_WIPHY_ACTIVE;
-
 	/* setup initial channel */
-
 	sc->chan_idx = curchan->hw_value;
 
 	init_channel = ath_get_curchannel(sc, hw);
@@ -1221,13 +1199,6 @@ static int ath9k_tx(struct ieee80211_hw *hw,
 	struct ath_tx_control txctl;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 
-	if (aphy->state != ATH_WIPHY_ACTIVE && aphy->state != ATH_WIPHY_SCAN) {
-		ath_dbg(common, ATH_DBG_XMIT,
-			"ath9k: %s: TX in unexpected wiphy state %d\n",
-			wiphy_name(hw->wiphy), aphy->state);
-		goto exit;
-	}
-
 	if (sc->ps_enabled) {
 		/*
 		 * mac80211 does not set PM field for normal data frames, so we
@@ -1290,12 +1261,9 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 	struct ath_softc *sc = aphy->sc;
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
-	int i;
 
 	mutex_lock(&sc->mutex);
 
-	aphy->state = ATH_WIPHY_INACTIVE;
-
 	if (led_blink)
 		cancel_delayed_work_sync(&sc->ath_led_blink_work);
 
@@ -1303,27 +1271,12 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 	cancel_work_sync(&sc->paprd_work);
 	cancel_work_sync(&sc->hw_check_work);
 
-	for (i = 0; i < sc->num_sec_wiphy; i++) {
-		if (sc->sec_wiphy[i])
-			break;
-	}
-
-	if (i == sc->num_sec_wiphy) {
-		cancel_delayed_work_sync(&sc->wiphy_work);
-		cancel_work_sync(&sc->chan_work);
-	}
-
 	if (sc->sc_flags & SC_OP_INVALID) {
 		ath_dbg(common, ATH_DBG_ANY, "Device not present\n");
 		mutex_unlock(&sc->mutex);
 		return;
 	}
 
-	if (ath9k_wiphy_started(sc)) {
-		mutex_unlock(&sc->mutex);
-		return; /* another wiphy still in use */
-	}
-
 	/* Ensure HW is awake when we try to shut it down. */
 	ath9k_ps_wakeup(sc);
 
@@ -1355,7 +1308,6 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 	ath9k_ps_restore(sc);
 
 	sc->ps_idle = true;
-	ath9k_set_wiphy_idle(aphy, true);
 	ath_radio_disable(sc, hw);
 
 	sc->sc_flags |= SC_OP_INVALID;
@@ -1445,7 +1397,6 @@ void ath9k_calculate_iter_data(struct ieee80211_hw *hw,
 	struct ath_softc *sc = aphy->sc;
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
-	int i;
 
 	/*
 	 * Use the hardware MAC address as reference, the hardware uses it
@@ -1459,16 +1410,8 @@ void ath9k_calculate_iter_data(struct ieee80211_hw *hw,
 		ath9k_vif_iter(iter_data, vif->addr, vif);
 
 	/* Get list of all active MAC addresses */
-	spin_lock_bh(&sc->wiphy_lock);
 	ieee80211_iterate_active_interfaces_atomic(sc->hw, ath9k_vif_iter,
 						   iter_data);
-	for (i = 0; i < sc->num_sec_wiphy; i++) {
-		if (sc->sec_wiphy[i] == NULL)
-			continue;
-		ieee80211_iterate_active_interfaces_atomic(
-			sc->sec_wiphy[i]->hw, ath9k_vif_iter, iter_data);
-	}
-	spin_unlock_bh(&sc->wiphy_lock);
 }
 
 /* Called with sc->mutex held. */
@@ -1722,7 +1665,7 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ieee80211_conf *conf = &hw->conf;
-	bool disable_radio;
+	bool disable_radio = false;
 
 	mutex_lock(&sc->mutex);
 
@@ -1733,29 +1676,13 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 	 * the end.
 	 */
 	if (changed & IEEE80211_CONF_CHANGE_IDLE) {
-		bool enable_radio;
-		bool all_wiphys_idle;
-		bool idle = !!(conf->flags & IEEE80211_CONF_IDLE);
-
-		spin_lock_bh(&sc->wiphy_lock);
-		all_wiphys_idle =  ath9k_all_wiphys_idle(sc);
-		ath9k_set_wiphy_idle(aphy, idle);
-
-		enable_radio = (!idle && all_wiphys_idle);
-
-		/*
-		 * After we unlock here its possible another wiphy
-		 * can be re-renabled so to account for that we will
-		 * only disable the radio toward the end of this routine
-		 * if by then all wiphys are still idle.
-		 */
-		spin_unlock_bh(&sc->wiphy_lock);
-
-		if (enable_radio) {
-			sc->ps_idle = false;
+		sc->ps_idle = !!(conf->flags & IEEE80211_CONF_IDLE);
+		if (!sc->ps_idle) {
 			ath_radio_enable(sc, hw);
 			ath_dbg(common, ATH_DBG_CONFIG,
 				"not-idle: enabling radio\n");
+		} else {
+			disable_radio = true;
 		}
 	}
 
@@ -1796,24 +1723,11 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 		if (ah->curchan)
 			old_pos = ah->curchan - &ah->channels[0];
 
-		aphy->chan_idx = pos;
-		aphy->chan_is_ht = conf_is_ht(conf);
 		if (hw->conf.flags & IEEE80211_CONF_OFFCHANNEL)
 			sc->sc_flags |= SC_OP_OFFCHANNEL;
 		else
 			sc->sc_flags &= ~SC_OP_OFFCHANNEL;
 
-		if (aphy->state == ATH_WIPHY_SCAN ||
-		    aphy->state == ATH_WIPHY_ACTIVE)
-			ath9k_wiphy_pause_all_forced(sc, aphy);
-		else {
-			/*
-			 * Do not change operational channel based on a paused
-			 * wiphy changes.
-			 */
-			goto skip_chan_change;
-		}
-
 		ath_dbg(common, ATH_DBG_CONFIG, "Set channel: %d MHz\n",
 			curchan->center_freq);
 
@@ -1860,7 +1774,6 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 			ath_update_survey_nf(sc, old_pos);
 	}
 
-skip_chan_change:
 	if (changed & IEEE80211_CONF_CHANGE_POWER) {
 		sc->config.txpowlimit = 2 * conf->power_level;
 		ath9k_ps_wakeup(sc);
@@ -1868,13 +1781,8 @@ skip_chan_change:
 		ath9k_ps_restore(sc);
 	}
 
-	spin_lock_bh(&sc->wiphy_lock);
-	disable_radio = ath9k_all_wiphys_idle(sc);
-	spin_unlock_bh(&sc->wiphy_lock);
-
 	if (disable_radio) {
 		ath_dbg(common, ATH_DBG_CONFIG, "idle: disabling radio\n");
-		sc->ps_idle = true;
 		ath_radio_disable(sc, hw);
 	}
 
@@ -2265,43 +2173,6 @@ static int ath9k_get_survey(struct ieee80211_hw *hw, int idx,
 	return 0;
 }
 
-static void ath9k_sw_scan_start(struct ieee80211_hw *hw)
-{
-	struct ath_wiphy *aphy = hw->priv;
-	struct ath_softc *sc = aphy->sc;
-
-	mutex_lock(&sc->mutex);
-	if (ath9k_wiphy_scanning(sc)) {
-		/*
-		 * There is a race here in mac80211 but fixing it requires
-		 * we revisit how we handle the scan complete callback.
-		 * After mac80211 fixes we will not have configured hardware
-		 * to the home channel nor would we have configured the RX
-		 * filter yet.
-		 */
-		mutex_unlock(&sc->mutex);
-		return;
-	}
-
-	aphy->state = ATH_WIPHY_SCAN;
-	ath9k_wiphy_pause_all_forced(sc, aphy);
-	mutex_unlock(&sc->mutex);
-}
-
-/*
- * XXX: this requires a revisit after the driver
- * scan_complete gets moved to another place/removed in mac80211.
- */
-static void ath9k_sw_scan_complete(struct ieee80211_hw *hw)
-{
-	struct ath_wiphy *aphy = hw->priv;
-	struct ath_softc *sc = aphy->sc;
-
-	mutex_lock(&sc->mutex);
-	aphy->state = ATH_WIPHY_ACTIVE;
-	mutex_unlock(&sc->mutex);
-}
-
 static void ath9k_set_coverage_class(struct ieee80211_hw *hw, u8 coverage_class)
 {
 	struct ath_wiphy *aphy = hw->priv;
@@ -2333,8 +2204,6 @@ struct ieee80211_ops ath9k_ops = {
 	.reset_tsf 	    = ath9k_reset_tsf,
 	.ampdu_action       = ath9k_ampdu_action,
 	.get_survey	    = ath9k_get_survey,
-	.sw_scan_start      = ath9k_sw_scan_start,
-	.sw_scan_complete   = ath9k_sw_scan_complete,
 	.rfkill_poll        = ath9k_rfkill_poll_state,
 	.set_coverage_class = ath9k_set_coverage_class,
 };
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index 78ef1f1..1f60b8c 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -213,7 +213,6 @@ static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	sc = (struct ath_softc *) (aphy + 1);
 	aphy->sc = sc;
 	aphy->hw = hw;
-	sc->pri_wiphy = aphy;
 	sc->hw = hw;
 	sc->dev = &pdev->dev;
 	sc->mem = mem;
@@ -320,7 +319,6 @@ static int ath_pci_resume(struct device *device)
 	ath9k_ps_restore(sc);
 
 	sc->ps_idle = true;
-	ath9k_set_wiphy_idle(aphy, true);
 	ath_radio_disable(sc, hw);
 
 	return 0;
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 116f058..c84a675 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -34,27 +34,6 @@ static inline bool ath9k_check_auto_sleep(struct ath_softc *sc)
 	       (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_AUTOSLEEP);
 }
 
-static struct ieee80211_hw * ath_get_virt_hw(struct ath_softc *sc,
-					     struct ieee80211_hdr *hdr)
-{
-	struct ieee80211_hw *hw = sc->pri_wiphy->hw;
-	int i;
-
-	spin_lock_bh(&sc->wiphy_lock);
-	for (i = 0; i < sc->num_sec_wiphy; i++) {
-		struct ath_wiphy *aphy = sc->sec_wiphy[i];
-		if (aphy == NULL)
-			continue;
-		if (compare_ether_addr(hdr->addr1, aphy->hw->wiphy->perm_addr)
-		    == 0) {
-			hw = aphy->hw;
-			break;
-		}
-	}
-	spin_unlock_bh(&sc->wiphy_lock);
-	return hw;
-}
-
 /*
  * Setup and link descriptors.
  *
@@ -463,8 +442,7 @@ u32 ath_calcrxfilter(struct ath_softc *sc)
 	if (conf_is_ht(&sc->hw->conf))
 		rfilt |= ATH9K_RX_FILTER_COMP_BAR;
 
-	if (sc->sec_wiphy || (sc->nvifs > 1) ||
-	    (sc->rx.rxfilter & FIF_OTHER_BSS)) {
+	if (sc->nvifs > 1 || (sc->rx.rxfilter & FIF_OTHER_BSS)) {
 		/* The following may also be needed for other older chips */
 		if (sc->sc_ah->hw_version.macVersion == AR_SREV_VERSION_9160)
 			rfilt |= ATH9K_RX_FILTER_PROM;
@@ -668,37 +646,6 @@ static void ath_rx_ps(struct ath_softc *sc, struct sk_buff *skb)
 	}
 }
 
-static void ath_rx_send_to_mac80211(struct ieee80211_hw *hw,
-				    struct ath_softc *sc, struct sk_buff *skb)
-{
-	struct ieee80211_hdr *hdr;
-
-	hdr = (struct ieee80211_hdr *)skb->data;
-
-	/* Send the frame to mac80211 */
-	if (is_multicast_ether_addr(hdr->addr1)) {
-		int i;
-		/*
-		 * Deliver broadcast/multicast frames to all suitable
-		 * virtual wiphys.
-		 */
-		/* TODO: filter based on channel configuration */
-		for (i = 0; i < sc->num_sec_wiphy; i++) {
-			struct ath_wiphy *aphy = sc->sec_wiphy[i];
-			struct sk_buff *nskb;
-			if (aphy == NULL)
-				continue;
-			nskb = skb_copy(skb, GFP_ATOMIC);
-			if (!nskb)
-				continue;
-			ieee80211_rx(aphy->hw, nskb);
-		}
-		ieee80211_rx(sc->hw, skb);
-	} else
-		/* Deliver unicast frames based on receiver address */
-		ieee80211_rx(hw, skb);
-}
-
 static bool ath_edma_get_buffers(struct ath_softc *sc,
 				 enum ath9k_rx_qtype qtype)
 {
@@ -1644,7 +1591,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 	 * virtual wiphy so to account for that we iterate over the active
 	 * wiphys and find the appropriate wiphy and therefore hw.
 	 */
-	struct ieee80211_hw *hw = NULL;
+	struct ieee80211_hw *hw = sc->hw;
 	struct ieee80211_hdr *hdr;
 	int retval;
 	bool decrypt_error = false;
@@ -1689,8 +1636,6 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 		hdr = (struct ieee80211_hdr *) (skb->data + rx_status_len);
 		rxs =  IEEE80211_SKB_RXCB(skb);
 
-		hw = ath_get_virt_hw(sc, hdr);
-
 		ath_debug_stat_rx(sc, &rs);
 
 		/*
@@ -1748,7 +1693,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 			bf->bf_mpdu = NULL;
 			bf->bf_buf_addr = 0;
 			ath_err(common, "dma_mapping_error() on RX\n");
-			ath_rx_send_to_mac80211(hw, sc, skb);
+			ieee80211_rx(hw, skb);
 			break;
 		}
 
@@ -1775,7 +1720,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 		if (ah->caps.hw_caps & ATH9K_HW_CAP_ANT_DIV_COMB)
 			ath_ant_comb_scan(sc, &rs);
 
-		ath_rx_send_to_mac80211(hw, sc, skb);
+		ieee80211_rx(hw, skb);
 
 requeue:
 		if (edma) {
diff --git a/drivers/net/wireless/ath/ath9k/virtual.c b/drivers/net/wireless/ath/ath9k/virtual.c
deleted file mode 100644
index d205c66..0000000
--- a/drivers/net/wireless/ath/ath9k/virtual.c
+++ /dev/null
@@ -1,669 +0,0 @@
-/*
- * Copyright (c) 2008-2009 Atheros Communications Inc.
- *
- * Permission to use, copy, modify, and/or distribute this software for any
- * purpose with or without fee is hereby granted, provided that the above
- * copyright notice and this permission notice appear in all copies.
- *
- * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
- * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
- * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
- * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
- * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
- * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
- * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
- */
-
-#include <linux/slab.h>
-
-#include "ath9k.h"
-
-int ath9k_wiphy_add(struct ath_softc *sc)
-{
-	int i, error;
-	struct ath_wiphy *aphy;
-	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
-	struct ieee80211_hw *hw;
-	u8 addr[ETH_ALEN];
-
-	hw = ieee80211_alloc_hw(sizeof(struct ath_wiphy), &ath9k_ops);
-	if (hw == NULL)
-		return -ENOMEM;
-
-	spin_lock_bh(&sc->wiphy_lock);
-	for (i = 0; i < sc->num_sec_wiphy; i++) {
-		if (sc->sec_wiphy[i] == NULL)
-			break;
-	}
-
-	if (i == sc->num_sec_wiphy) {
-		/* No empty slot available; increase array length */
-		struct ath_wiphy **n;
-		n = krealloc(sc->sec_wiphy,
-			     (sc->num_sec_wiphy + 1) *
-			     sizeof(struct ath_wiphy *),
-			     GFP_ATOMIC);
-		if (n == NULL) {
-			spin_unlock_bh(&sc->wiphy_lock);
-			ieee80211_free_hw(hw);
-			return -ENOMEM;
-		}
-		n[i] = NULL;
-		sc->sec_wiphy = n;
-		sc->num_sec_wiphy++;
-	}
-
-	SET_IEEE80211_DEV(hw, sc->dev);
-
-	aphy = hw->priv;
-	aphy->sc = sc;
-	aphy->hw = hw;
-	sc->sec_wiphy[i] = aphy;
-	aphy->last_rssi = ATH_RSSI_DUMMY_MARKER;
-	spin_unlock_bh(&sc->wiphy_lock);
-
-	memcpy(addr, common->macaddr, ETH_ALEN);
-	addr[0] |= 0x02; /* Locally managed address */
-	/*
-	 * XOR virtual wiphy index into the least significant bits to generate
-	 * a different MAC address for each virtual wiphy.
-	 */
-	addr[5] ^= i & 0xff;
-	addr[4] ^= (i & 0xff00) >> 8;
-	addr[3] ^= (i & 0xff0000) >> 16;
-
-	SET_IEEE80211_PERM_ADDR(hw, addr);
-
-	ath9k_set_hw_capab(sc, hw);
-
-	error = ieee80211_register_hw(hw);
-
-	if (error == 0) {
-		/* Make sure wiphy scheduler is started (if enabled) */
-		ath9k_wiphy_set_scheduler(sc, sc->wiphy_scheduler_int);
-	}
-
-	return error;
-}
-
-int ath9k_wiphy_del(struct ath_wiphy *aphy)
-{
-	struct ath_softc *sc = aphy->sc;
-	int i;
-
-	spin_lock_bh(&sc->wiphy_lock);
-	for (i = 0; i < sc->num_sec_wiphy; i++) {
-		if (aphy == sc->sec_wiphy[i]) {
-			sc->sec_wiphy[i] = NULL;
-			spin_unlock_bh(&sc->wiphy_lock);
-			ieee80211_unregister_hw(aphy->hw);
-			ieee80211_free_hw(aphy->hw);
-			return 0;
-		}
-	}
-	spin_unlock_bh(&sc->wiphy_lock);
-	return -ENOENT;
-}
-
-static int ath9k_send_nullfunc(struct ath_wiphy *aphy,
-			       struct ieee80211_vif *vif, const u8 *bssid,
-			       int ps)
-{
-	struct ath_softc *sc = aphy->sc;
-	struct ath_tx_control txctl;
-	struct sk_buff *skb;
-	struct ieee80211_hdr *hdr;
-	__le16 fc;
-	struct ieee80211_tx_info *info;
-
-	skb = dev_alloc_skb(24);
-	if (skb == NULL)
-		return -ENOMEM;
-	hdr = (struct ieee80211_hdr *) skb_put(skb, 24);
-	memset(hdr, 0, 24);
-	fc = cpu_to_le16(IEEE80211_FTYPE_DATA | IEEE80211_STYPE_NULLFUNC |
-			 IEEE80211_FCTL_TODS);
-	if (ps)
-		fc |= cpu_to_le16(IEEE80211_FCTL_PM);
-	hdr->frame_control = fc;
-	memcpy(hdr->addr1, bssid, ETH_ALEN);
-	memcpy(hdr->addr2, aphy->hw->wiphy->perm_addr, ETH_ALEN);
-	memcpy(hdr->addr3, bssid, ETH_ALEN);
-
-	info = IEEE80211_SKB_CB(skb);
-	memset(info, 0, sizeof(*info));
-	info->flags = IEEE80211_TX_CTL_REQ_TX_STATUS;
-	info->control.vif = vif;
-	info->control.rates[0].idx = 0;
-	info->control.rates[0].count = 4;
-	info->control.rates[1].idx = -1;
-
-	memset(&txctl, 0, sizeof(struct ath_tx_control));
-	txctl.txq = sc->tx.txq_map[WME_AC_VO];
-	txctl.frame_type = ps ? ATH9K_IFT_PAUSE : ATH9K_IFT_UNPAUSE;
-
-	if (ath_tx_start(aphy->hw, skb, &txctl) != 0)
-		goto exit;
-
-	return 0;
-exit:
-	dev_kfree_skb_any(skb);
-	return -1;
-}
-
-static bool __ath9k_wiphy_pausing(struct ath_softc *sc)
-{
-	int i;
-	if (sc->pri_wiphy->state == ATH_WIPHY_PAUSING)
-		return true;
-	for (i = 0; i < sc->num_sec_wiphy; i++) {
-		if (sc->sec_wiphy[i] &&
-		    sc->sec_wiphy[i]->state == ATH_WIPHY_PAUSING)
-			return true;
-	}
-	return false;
-}
-
-static bool ath9k_wiphy_pausing(struct ath_softc *sc)
-{
-	bool ret;
-	spin_lock_bh(&sc->wiphy_lock);
-	ret = __ath9k_wiphy_pausing(sc);
-	spin_unlock_bh(&sc->wiphy_lock);
-	return ret;
-}
-
-static bool __ath9k_wiphy_scanning(struct ath_softc *sc)
-{
-	int i;
-	if (sc->pri_wiphy->state == ATH_WIPHY_SCAN)
-		return true;
-	for (i = 0; i < sc->num_sec_wiphy; i++) {
-		if (sc->sec_wiphy[i] &&
-		    sc->sec_wiphy[i]->state == ATH_WIPHY_SCAN)
-			return true;
-	}
-	return false;
-}
-
-bool ath9k_wiphy_scanning(struct ath_softc *sc)
-{
-	bool ret;
-	spin_lock_bh(&sc->wiphy_lock);
-	ret = __ath9k_wiphy_scanning(sc);
-	spin_unlock_bh(&sc->wiphy_lock);
-	return ret;
-}
-
-static int __ath9k_wiphy_unpause(struct ath_wiphy *aphy);
-
-/* caller must hold wiphy_lock */
-static void __ath9k_wiphy_unpause_ch(struct ath_wiphy *aphy)
-{
-	if (aphy == NULL)
-		return;
-	if (aphy->chan_idx != aphy->sc->chan_idx)
-		return; /* wiphy not on the selected channel */
-	__ath9k_wiphy_unpause(aphy);
-}
-
-static void ath9k_wiphy_unpause_channel(struct ath_softc *sc)
-{
-	int i;
-	spin_lock_bh(&sc->wiphy_lock);
-	__ath9k_wiphy_unpause_ch(sc->pri_wiphy);
-	for (i = 0; i < sc->num_sec_wiphy; i++)
-		__ath9k_wiphy_unpause_ch(sc->sec_wiphy[i]);
-	spin_unlock_bh(&sc->wiphy_lock);
-}
-
-void ath9k_wiphy_chan_work(struct work_struct *work)
-{
-	struct ath_softc *sc = container_of(work, struct ath_softc, chan_work);
-	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
-	struct ath_wiphy *aphy = sc->next_wiphy;
-
-	if (aphy == NULL)
-		return;
-
-	/*
-	 * All pending interfaces paused; ready to change
-	 * channels.
-	 */
-
-	/* Change channels */
-	mutex_lock(&sc->mutex);
-	/* XXX: remove me eventually */
-	ath9k_update_ichannel(sc, aphy->hw,
-			      &sc->sc_ah->channels[sc->chan_idx]);
-
-	/* sync hw configuration for hw code */
-	common->hw = aphy->hw;
-
-	if (ath_set_channel(sc, aphy->hw,
-			    &sc->sc_ah->channels[sc->chan_idx]) < 0) {
-		printk(KERN_DEBUG "ath9k: Failed to set channel for new "
-		       "virtual wiphy\n");
-		mutex_unlock(&sc->mutex);
-		return;
-	}
-	mutex_unlock(&sc->mutex);
-
-	ath9k_wiphy_unpause_channel(sc);
-}
-
-/*
- * ath9k version of ieee80211_tx_status() for TX frames that are generated
- * internally in the driver.
- */
-void ath9k_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb, int ftype)
-{
-	struct ath_wiphy *aphy = hw->priv;
-	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
-
-	if (ftype == ATH9K_IFT_PAUSE && aphy->state == ATH_WIPHY_PAUSING) {
-		if (!(tx_info->flags & IEEE80211_TX_STAT_ACK)) {
-			printk(KERN_DEBUG "ath9k: %s: no ACK for pause "
-			       "frame\n", wiphy_name(hw->wiphy));
-			/*
-			 * The AP did not reply; ignore this to allow us to
-			 * continue.
-			 */
-		}
-		aphy->state = ATH_WIPHY_PAUSED;
-		if (!ath9k_wiphy_pausing(aphy->sc)) {
-			/*
-			 * Drop from tasklet to work to allow mutex for channel
-			 * change.
-			 */
-			ieee80211_queue_work(aphy->sc->hw,
-				   &aphy->sc->chan_work);
-		}
-	}
-
-	dev_kfree_skb(skb);
-}
-
-static void ath9k_mark_paused(struct ath_wiphy *aphy)
-{
-	struct ath_softc *sc = aphy->sc;
-	aphy->state = ATH_WIPHY_PAUSED;
-	if (!__ath9k_wiphy_pausing(sc))
-		ieee80211_queue_work(sc->hw, &sc->chan_work);
-}
-
-static void ath9k_pause_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
-{
-	struct ath_wiphy *aphy = data;
-	struct ath_vif *avp = (void *) vif->drv_priv;
-
-	switch (vif->type) {
-	case NL80211_IFTYPE_STATION:
-		if (!vif->bss_conf.assoc) {
-			ath9k_mark_paused(aphy);
-			break;
-		}
-		/* TODO: could avoid this if already in PS mode */
-		if (ath9k_send_nullfunc(aphy, vif, avp->bssid, 1)) {
-			printk(KERN_DEBUG "%s: failed to send PS nullfunc\n",
-			       __func__);
-			ath9k_mark_paused(aphy);
-		}
-		break;
-	case NL80211_IFTYPE_AP:
-		/* Beacon transmission is paused by aphy->state change */
-		ath9k_mark_paused(aphy);
-		break;
-	default:
-		break;
-	}
-}
-
-/* caller must hold wiphy_lock */
-static int __ath9k_wiphy_pause(struct ath_wiphy *aphy)
-{
-	ieee80211_stop_queues(aphy->hw);
-	aphy->state = ATH_WIPHY_PAUSING;
-	/*
-	 * TODO: handle PAUSING->PAUSED for the case where there are multiple
-	 * active vifs (now we do it on the first vif getting ready; should be
-	 * on the last)
-	 */
-	ieee80211_iterate_active_interfaces_atomic(aphy->hw, ath9k_pause_iter,
-						   aphy);
-	return 0;
-}
-
-int ath9k_wiphy_pause(struct ath_wiphy *aphy)
-{
-	int ret;
-	spin_lock_bh(&aphy->sc->wiphy_lock);
-	ret = __ath9k_wiphy_pause(aphy);
-	spin_unlock_bh(&aphy->sc->wiphy_lock);
-	return ret;
-}
-
-static void ath9k_unpause_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
-{
-	struct ath_wiphy *aphy = data;
-	struct ath_vif *avp = (void *) vif->drv_priv;
-
-	switch (vif->type) {
-	case NL80211_IFTYPE_STATION:
-		if (!vif->bss_conf.assoc)
-			break;
-		ath9k_send_nullfunc(aphy, vif, avp->bssid, 0);
-		break;
-	case NL80211_IFTYPE_AP:
-		/* Beacon transmission is re-enabled by aphy->state change */
-		break;
-	default:
-		break;
-	}
-}
-
-/* caller must hold wiphy_lock */
-static int __ath9k_wiphy_unpause(struct ath_wiphy *aphy)
-{
-	ieee80211_iterate_active_interfaces_atomic(aphy->hw,
-						   ath9k_unpause_iter, aphy);
-	aphy->state = ATH_WIPHY_ACTIVE;
-	ieee80211_wake_queues(aphy->hw);
-	return 0;
-}
-
-int ath9k_wiphy_unpause(struct ath_wiphy *aphy)
-{
-	int ret;
-	spin_lock_bh(&aphy->sc->wiphy_lock);
-	ret = __ath9k_wiphy_unpause(aphy);
-	spin_unlock_bh(&aphy->sc->wiphy_lock);
-	return ret;
-}
-
-static void __ath9k_wiphy_mark_all_paused(struct ath_softc *sc)
-{
-	int i;
-	if (sc->pri_wiphy->state != ATH_WIPHY_INACTIVE)
-		sc->pri_wiphy->state = ATH_WIPHY_PAUSED;
-	for (i = 0; i < sc->num_sec_wiphy; i++) {
-		if (sc->sec_wiphy[i] &&
-		    sc->sec_wiphy[i]->state != ATH_WIPHY_INACTIVE)
-			sc->sec_wiphy[i]->state = ATH_WIPHY_PAUSED;
-	}
-}
-
-/* caller must hold wiphy_lock */
-static void __ath9k_wiphy_pause_all(struct ath_softc *sc)
-{
-	int i;
-	if (sc->pri_wiphy->state == ATH_WIPHY_ACTIVE)
-		__ath9k_wiphy_pause(sc->pri_wiphy);
-	for (i = 0; i < sc->num_sec_wiphy; i++) {
-		if (sc->sec_wiphy[i] &&
-		    sc->sec_wiphy[i]->state == ATH_WIPHY_ACTIVE)
-			__ath9k_wiphy_pause(sc->sec_wiphy[i]);
-	}
-}
-
-int ath9k_wiphy_select(struct ath_wiphy *aphy)
-{
-	struct ath_softc *sc = aphy->sc;
-	bool now;
-
-	spin_lock_bh(&sc->wiphy_lock);
-	if (__ath9k_wiphy_scanning(sc)) {
-		/*
-		 * For now, we are using mac80211 sw scan and it expects to
-		 * have full control over channel changes, so avoid wiphy
-		 * scheduling during a scan. This could be optimized if the
-		 * scanning control were moved into the driver.
-		 */
-		spin_unlock_bh(&sc->wiphy_lock);
-		return -EBUSY;
-	}
-	if (__ath9k_wiphy_pausing(sc)) {
-		if (sc->wiphy_select_failures == 0)
-			sc->wiphy_select_first_fail = jiffies;
-		sc->wiphy_select_failures++;
-		if (time_after(jiffies, sc->wiphy_select_first_fail + HZ / 2))
-		{
-			printk(KERN_DEBUG "ath9k: Previous wiphy select timed "
-			       "out; disable/enable hw to recover\n");
-			__ath9k_wiphy_mark_all_paused(sc);
-			/*
-			 * TODO: this workaround to fix hardware is unlikely to
-			 * be specific to virtual wiphy changes. It can happen
-			 * on normal channel change, too, and as such, this
-			 * should really be made more generic. For example,
-			 * tricker radio disable/enable on GTT interrupt burst
-			 * (say, 10 GTT interrupts received without any TX
-			 * frame being completed)
-			 */
-			spin_unlock_bh(&sc->wiphy_lock);
-			ath_radio_disable(sc, aphy->hw);
-			ath_radio_enable(sc, aphy->hw);
-			/* Only the primary wiphy hw is used for queuing work */
-			ieee80211_queue_work(aphy->sc->hw,
-				   &aphy->sc->chan_work);
-			return -EBUSY; /* previous select still in progress */
-		}
-		spin_unlock_bh(&sc->wiphy_lock);
-		return -EBUSY; /* previous select still in progress */
-	}
-	sc->wiphy_select_failures = 0;
-
-	/* Store the new channel */
-	sc->chan_idx = aphy->chan_idx;
-	sc->chan_is_ht = aphy->chan_is_ht;
-	sc->next_wiphy = aphy;
-
-	__ath9k_wiphy_pause_all(sc);
-	now = !__ath9k_wiphy_pausing(aphy->sc);
-	spin_unlock_bh(&sc->wiphy_lock);
-
-	if (now) {
-		/* Ready to request channel change immediately */
-		ieee80211_queue_work(aphy->sc->hw, &aphy->sc->chan_work);
-	}
-
-	/*
-	 * wiphys will be unpaused in ath9k_tx_status() once channel has been
-	 * changed if any wiphy needs time to become paused.
-	 */
-
-	return 0;
-}
-
-bool ath9k_wiphy_started(struct ath_softc *sc)
-{
-	int i;
-	spin_lock_bh(&sc->wiphy_lock);
-	if (sc->pri_wiphy->state != ATH_WIPHY_INACTIVE) {
-		spin_unlock_bh(&sc->wiphy_lock);
-		return true;
-	}
-	for (i = 0; i < sc->num_sec_wiphy; i++) {
-		if (sc->sec_wiphy[i] &&
-		    sc->sec_wiphy[i]->state != ATH_WIPHY_INACTIVE) {
-			spin_unlock_bh(&sc->wiphy_lock);
-			return true;
-		}
-	}
-	spin_unlock_bh(&sc->wiphy_lock);
-	return false;
-}
-
-static void ath9k_wiphy_pause_chan(struct ath_wiphy *aphy,
-				   struct ath_wiphy *selected)
-{
-	if (selected->state == ATH_WIPHY_SCAN) {
-		if (aphy == selected)
-			return;
-		/*
-		 * Pause all other wiphys for the duration of the scan even if
-		 * they are on the current channel now.
-		 */
-	} else if (aphy->chan_idx == selected->chan_idx)
-		return;
-	aphy->state = ATH_WIPHY_PAUSED;
-	ieee80211_stop_queues(aphy->hw);
-}
-
-void ath9k_wiphy_pause_all_forced(struct ath_softc *sc,
-				  struct ath_wiphy *selected)
-{
-	int i;
-	spin_lock_bh(&sc->wiphy_lock);
-	if (sc->pri_wiphy->state == ATH_WIPHY_ACTIVE)
-		ath9k_wiphy_pause_chan(sc->pri_wiphy, selected);
-	for (i = 0; i < sc->num_sec_wiphy; i++) {
-		if (sc->sec_wiphy[i] &&
-		    sc->sec_wiphy[i]->state == ATH_WIPHY_ACTIVE)
-			ath9k_wiphy_pause_chan(sc->sec_wiphy[i], selected);
-	}
-	spin_unlock_bh(&sc->wiphy_lock);
-}
-
-void ath9k_wiphy_work(struct work_struct *work)
-{
-	struct ath_softc *sc = container_of(work, struct ath_softc,
-					    wiphy_work.work);
-	struct ath_wiphy *aphy = NULL;
-	bool first = true;
-
-	spin_lock_bh(&sc->wiphy_lock);
-
-	if (sc->wiphy_scheduler_int == 0) {
-		/* wiphy scheduler is disabled */
-		spin_unlock_bh(&sc->wiphy_lock);
-		return;
-	}
-
-try_again:
-	sc->wiphy_scheduler_index++;
-	while (sc->wiphy_scheduler_index <= sc->num_sec_wiphy) {
-		aphy = sc->sec_wiphy[sc->wiphy_scheduler_index - 1];
-		if (aphy && aphy->state != ATH_WIPHY_INACTIVE)
-			break;
-
-		sc->wiphy_scheduler_index++;
-		aphy = NULL;
-	}
-	if (aphy == NULL) {
-		sc->wiphy_scheduler_index = 0;
-		if (sc->pri_wiphy->state == ATH_WIPHY_INACTIVE) {
-			if (first) {
-				first = false;
-				goto try_again;
-			}
-			/* No wiphy is ready to be scheduled */
-		} else
-			aphy = sc->pri_wiphy;
-	}
-
-	spin_unlock_bh(&sc->wiphy_lock);
-
-	if (aphy &&
-	    aphy->state != ATH_WIPHY_ACTIVE && aphy->state != ATH_WIPHY_SCAN &&
-	    ath9k_wiphy_select(aphy)) {
-		printk(KERN_DEBUG "ath9k: Failed to schedule virtual wiphy "
-		       "change\n");
-	}
-
-	ieee80211_queue_delayed_work(sc->hw,
-				     &sc->wiphy_work,
-				     sc->wiphy_scheduler_int);
-}
-
-void ath9k_wiphy_set_scheduler(struct ath_softc *sc, unsigned int msec_int)
-{
-	cancel_delayed_work_sync(&sc->wiphy_work);
-	sc->wiphy_scheduler_int = msecs_to_jiffies(msec_int);
-	if (sc->wiphy_scheduler_int)
-		ieee80211_queue_delayed_work(sc->hw, &sc->wiphy_work,
-					     sc->wiphy_scheduler_int);
-}
-
-/* caller must hold wiphy_lock */
-bool ath9k_all_wiphys_idle(struct ath_softc *sc)
-{
-	unsigned int i;
-	if (!sc->pri_wiphy->idle)
-		return false;
-	for (i = 0; i < sc->num_sec_wiphy; i++) {
-		struct ath_wiphy *aphy = sc->sec_wiphy[i];
-		if (!aphy)
-			continue;
-		if (!aphy->idle)
-			return false;
-	}
-	return true;
-}
-
-/* caller must hold wiphy_lock */
-void ath9k_set_wiphy_idle(struct ath_wiphy *aphy, bool idle)
-{
-	struct ath_softc *sc = aphy->sc;
-
-	aphy->idle = idle;
-	ath_dbg(ath9k_hw_common(sc->sc_ah), ATH_DBG_CONFIG,
-		"Marking %s as %sidle\n",
-		wiphy_name(aphy->hw->wiphy), idle ? "" : "not-");
-}
-/* Only bother starting a queue on an active virtual wiphy */
-bool ath_mac80211_start_queue(struct ath_softc *sc, u16 skb_queue)
-{
-	struct ieee80211_hw *hw = sc->pri_wiphy->hw;
-	unsigned int i;
-	bool txq_started = false;
-
-	spin_lock_bh(&sc->wiphy_lock);
-
-	/* Start the primary wiphy */
-	if (sc->pri_wiphy->state == ATH_WIPHY_ACTIVE) {
-		ieee80211_wake_queue(hw, skb_queue);
-		txq_started = true;
-		goto unlock;
-	}
-
-	/* Now start the secondary wiphy queues */
-	for (i = 0; i < sc->num_sec_wiphy; i++) {
-		struct ath_wiphy *aphy = sc->sec_wiphy[i];
-		if (!aphy)
-			continue;
-		if (aphy->state != ATH_WIPHY_ACTIVE)
-			continue;
-
-		hw = aphy->hw;
-		ieee80211_wake_queue(hw, skb_queue);
-		txq_started = true;
-		break;
-	}
-
-unlock:
-	spin_unlock_bh(&sc->wiphy_lock);
-	return txq_started;
-}
-
-/* Go ahead and propagate information to all virtual wiphys, it won't hurt */
-void ath_mac80211_stop_queue(struct ath_softc *sc, u16 skb_queue)
-{
-	struct ieee80211_hw *hw = sc->pri_wiphy->hw;
-	unsigned int i;
-
-	spin_lock_bh(&sc->wiphy_lock);
-
-	/* Stop the primary wiphy */
-	ieee80211_stop_queue(hw, skb_queue);
-
-	/* Now stop the secondary wiphy queues */
-	for (i = 0; i < sc->num_sec_wiphy; i++) {
-		struct ath_wiphy *aphy = sc->sec_wiphy[i];
-		if (!aphy)
-			continue;
-		hw = aphy->hw;
-		ieee80211_stop_queue(hw, skb_queue);
-	}
-	spin_unlock_bh(&sc->wiphy_lock);
-}
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 10eaaf9..b4f4f4b 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1821,7 +1821,7 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 	spin_lock_bh(&txq->axq_lock);
 	if (txq == sc->tx.txq_map[q] &&
 	    ++txq->pending_frames > ATH_MAX_QDEPTH && !txq->stopped) {
-		ath_mac80211_stop_queue(sc, q);
+		ieee80211_stop_queue(sc->hw, q);
 		txq->stopped = 1;
 	}
 	spin_unlock_bh(&txq->axq_lock);
@@ -1879,24 +1879,20 @@ static void ath_tx_complete(struct ath_softc *sc, struct sk_buff *skb,
 					PS_WAIT_FOR_TX_ACK));
 	}
 
-	if (unlikely(ftype))
-		ath9k_tx_status(hw, skb, ftype);
-	else {
-		q = skb_get_queue_mapping(skb);
-		if (txq == sc->tx.txq_map[q]) {
-			spin_lock_bh(&txq->axq_lock);
-			if (WARN_ON(--txq->pending_frames < 0))
-				txq->pending_frames = 0;
+	q = skb_get_queue_mapping(skb);
+	if (txq == sc->tx.txq_map[q]) {
+		spin_lock_bh(&txq->axq_lock);
+		if (WARN_ON(--txq->pending_frames < 0))
+			txq->pending_frames = 0;
 
-			if (txq->stopped && txq->pending_frames < ATH_MAX_QDEPTH) {
-				if (ath_mac80211_start_queue(sc, q))
-					txq->stopped = 0;
-			}
-			spin_unlock_bh(&txq->axq_lock);
+		if (txq->stopped && txq->pending_frames < ATH_MAX_QDEPTH) {
+			ieee80211_wake_queue(sc->hw, q);
+			txq->stopped = 0;
 		}
-
-		ieee80211_tx_status(hw, skb);
+		spin_unlock_bh(&txq->axq_lock);
 	}
+
+	ieee80211_tx_status(hw, skb);
 }
 
 static void ath_tx_complete_buf(struct ath_softc *sc, struct ath_buf *bf,
-- 
1.7.3.2

