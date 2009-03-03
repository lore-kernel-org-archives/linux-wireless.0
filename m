Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:35451 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754079AbZCCRZU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2009 12:25:20 -0500
Message-Id: <20090303172507.525952837@atheros.com> (sfid-20090303_182523_432428_E179F8FD)
References: <20090303172325.437810138@atheros.com>
Date: Tue, 03 Mar 2009 19:23:32 +0200
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>
Subject: [PATCH 07/15] ath9k: Add routines for switching between active virtual wiphys
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath9k_wiphy_select() can be used to select a virtual wiphy to be
activated. Other virtual wiphys will be paused and once that is done,
the operational channel is changed and the wiphys that are on the
selected channel will be unpaused.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 drivers/net/wireless/ath9k/ath9k.h   |   14 +++
 drivers/net/wireless/ath9k/main.c    |   27 ++++--
 drivers/net/wireless/ath9k/virtual.c |  147 ++++++++++++++++++++++++++++++++++-
 3 files changed, 176 insertions(+), 12 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/ath9k/ath9k.h	2009-03-03 18:31:09.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/ath9k.h	2009-03-03 18:31:20.000000000 +0200
@@ -563,6 +563,11 @@ struct ath_softc {
 	struct ath_wiphy **sec_wiphy; /* secondary wiphys (virtual radios); may
 				       * have NULL entries */
 	int num_sec_wiphy; /* number of sec_wiphy pointers in the array */
+	int chan_idx;
+	int chan_is_ht;
+	struct ath_wiphy *next_wiphy;
+	struct work_struct chan_work;
+
 	struct tasklet_struct intr_tq;
 	struct tasklet_struct bcon_tasklet;
 	struct ath_hw *sc_ah;
@@ -626,6 +631,8 @@ struct ath_wiphy {
 		ATH_WIPHY_PAUSING,
 		ATH_WIPHY_PAUSED,
 	} state;
+	int chan_idx;
+	int chan_is_ht;
 };
 
 int ath_reset(struct ath_softc *sc, bool retry_tx);
@@ -652,6 +659,11 @@ void ath_detach(struct ath_softc *sc);
 const char *ath_mac_bb_name(u32 mac_bb_version);
 const char *ath_rf_name(u16 rf_version);
 void ath_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw);
+void ath9k_update_ichannel(struct ath_softc *sc, struct ieee80211_hw *hw,
+			   struct ath9k_channel *ichan);
+void ath_update_chainmask(struct ath_softc *sc, int is_ht);
+int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
+		    struct ath9k_channel *hchan);
 
 #ifdef CONFIG_PCI
 int ath_pci_init(void);
@@ -693,5 +705,7 @@ int ath9k_wiphy_del(struct ath_wiphy *ap
 void ath9k_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb);
 int ath9k_wiphy_pause(struct ath_wiphy *aphy);
 int ath9k_wiphy_unpause(struct ath_wiphy *aphy);
+int ath9k_wiphy_select(struct ath_wiphy *aphy);
+void ath9k_wiphy_chan_work(struct work_struct *work);
 
 #endif /* ATH9K_H */
--- wireless-testing.orig/drivers/net/wireless/ath9k/main.c	2009-03-03 18:31:09.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/main.c	2009-03-03 18:31:20.000000000 +0200
@@ -236,11 +236,11 @@ static void ath_setup_rates(struct ath_s
  * by reseting the chip.  To accomplish this we must first cleanup any pending
  * DMA, then restart stuff.
 */
-static int ath_set_channel(struct ath_softc *sc, struct ath9k_channel *hchan)
+int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
+		    struct ath9k_channel *hchan)
 {
 	struct ath_hw *ah = sc->sc_ah;
 	bool fastcc = true, stopped;
-	struct ieee80211_hw *hw = sc->hw;
 	struct ieee80211_channel *channel = hw->conf.channel;
 	int r;
 
@@ -414,7 +414,7 @@ set_timer:
  * the chainmask configuration, for bt coexistence, use
  * the chainmask configuration even in legacy mode.
  */
-static void ath_update_chainmask(struct ath_softc *sc, int is_ht)
+void ath_update_chainmask(struct ath_softc *sc, int is_ht)
 {
 	sc->sc_flags |= SC_OP_CHAINMASK_UPDATE;
 	if (is_ht ||
@@ -1322,6 +1322,7 @@ void ath_detach(struct ath_softc *sc)
 	ath_deinit_rfkill(sc);
 #endif
 	ath_deinit_leds(sc);
+	cancel_work_sync(&sc->chan_work);
 
 	for (i = 0; i < sc->num_sec_wiphy; i++) {
 		struct ath_wiphy *aphy = sc->sec_wiphy[i];
@@ -1667,6 +1668,8 @@ int ath_attach(u16 devid, struct ath_sof
 	ath9k_reg_apply_radar_flags(hw->wiphy);
 	ath9k_reg_apply_world_flags(hw->wiphy, REGDOM_SET_BY_INIT);
 
+	INIT_WORK(&sc->chan_work, ath9k_wiphy_chan_work);
+
 	error = ieee80211_register_hw(hw);
 
 	if (!ath9k_is_world_regd(sc->sc_ah)) {
@@ -1915,10 +1918,9 @@ int ath_get_mac80211_qnum(u32 queue, str
 
 /* XXX: Remove me once we don't depend on ath9k_channel for all
  * this redundant data */
-static void ath9k_update_ichannel(struct ath_softc *sc,
-			  struct ath9k_channel *ichan)
+void ath9k_update_ichannel(struct ath_softc *sc, struct ieee80211_hw *hw,
+			   struct ath9k_channel *ichan)
 {
-	struct ieee80211_hw *hw = sc->hw;
 	struct ieee80211_channel *chan = hw->conf.channel;
 	struct ieee80211_conf *conf = &hw->conf;
 
@@ -1965,8 +1967,9 @@ static int ath9k_start(struct ieee80211_
 
 	pos = curchan->hw_value;
 
+	sc->chan_idx = pos;
 	init_channel = &sc->sc_ah->channels[pos];
-	ath9k_update_ichannel(sc, init_channel);
+	ath9k_update_ichannel(sc, hw, init_channel);
 
 	/* Reset SERDES registers */
 	ath9k_hw_configpcipowersave(sc->sc_ah, 0);
@@ -2305,15 +2308,21 @@ static int ath9k_config(struct ieee80211
 		struct ieee80211_channel *curchan = hw->conf.channel;
 		int pos = curchan->hw_value;
 
+		aphy->chan_idx = pos;
+		aphy->chan_is_ht = conf_is_ht(conf);
+
+		/* TODO: do not change operation channel immediately if there
+		 * are other virtual wiphys that use another channel */
+
 		DPRINTF(sc, ATH_DBG_CONFIG, "Set channel: %d MHz\n",
 			curchan->center_freq);
 
 		/* XXX: remove me eventualy */
-		ath9k_update_ichannel(sc, &sc->sc_ah->channels[pos]);
+		ath9k_update_ichannel(sc, hw, &sc->sc_ah->channels[pos]);
 
 		ath_update_chainmask(sc, conf_is_ht(conf));
 
-		if (ath_set_channel(sc, &sc->sc_ah->channels[pos]) < 0) {
+		if (ath_set_channel(sc, hw, &sc->sc_ah->channels[pos]) < 0) {
 			DPRINTF(sc, ATH_DBG_FATAL, "Unable to set channel\n");
 			mutex_unlock(&sc->mutex);
 			return -EINVAL;
--- wireless-testing.orig/drivers/net/wireless/ath9k/virtual.c	2009-03-03 18:31:09.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/virtual.c	2009-03-03 18:31:20.000000000 +0200
@@ -222,6 +222,81 @@ exit:
 	return -1;
 }
 
+static bool __ath9k_wiphy_pausing(struct ath_softc *sc)
+{
+	int i;
+	if (sc->pri_wiphy->state == ATH_WIPHY_PAUSING)
+		return true;
+	for (i = 0; i < sc->num_sec_wiphy; i++) {
+		if (sc->sec_wiphy[i] &&
+		    sc->sec_wiphy[i]->state == ATH_WIPHY_PAUSING)
+			return true;
+	}
+	return false;
+}
+
+static bool ath9k_wiphy_pausing(struct ath_softc *sc)
+{
+	bool ret;
+	spin_lock_bh(&sc->wiphy_lock);
+	ret = __ath9k_wiphy_pausing(sc);
+	spin_unlock_bh(&sc->wiphy_lock);
+	return ret;
+}
+
+static int __ath9k_wiphy_unpause(struct ath_wiphy *aphy);
+
+/* caller must hold wiphy_lock */
+static void __ath9k_wiphy_unpause_ch(struct ath_wiphy *aphy)
+{
+	if (aphy == NULL)
+		return;
+	if (aphy->chan_idx != aphy->sc->chan_idx)
+		return; /* wiphy not on the selected channel */
+	__ath9k_wiphy_unpause(aphy);
+}
+
+static void ath9k_wiphy_unpause_channel(struct ath_softc *sc)
+{
+	int i;
+	spin_lock_bh(&sc->wiphy_lock);
+	__ath9k_wiphy_unpause_ch(sc->pri_wiphy);
+	for (i = 0; i < sc->num_sec_wiphy; i++)
+		__ath9k_wiphy_unpause_ch(sc->sec_wiphy[i]);
+	spin_unlock_bh(&sc->wiphy_lock);
+}
+
+void ath9k_wiphy_chan_work(struct work_struct *work)
+{
+	struct ath_softc *sc = container_of(work, struct ath_softc, chan_work);
+	struct ath_wiphy *aphy = sc->next_wiphy;
+
+	if (aphy == NULL)
+		return;
+
+	/*
+	 * All pending interfaces paused; ready to change
+	 * channels.
+	 */
+
+	/* Change channels */
+	mutex_lock(&sc->mutex);
+	/* XXX: remove me eventually */
+	ath9k_update_ichannel(sc, aphy->hw,
+			      &sc->sc_ah->channels[sc->chan_idx]);
+	ath_update_chainmask(sc, sc->chan_is_ht);
+	if (ath_set_channel(sc, aphy->hw,
+			    &sc->sc_ah->channels[sc->chan_idx]) < 0) {
+		printk(KERN_DEBUG "ath9k: Failed to set channel for new "
+		       "virtual wiphy\n");
+		mutex_unlock(&sc->mutex);
+		return;
+	}
+	mutex_unlock(&sc->mutex);
+
+	ath9k_wiphy_unpause_channel(sc);
+}
+
 /*
  * ath9k version of ieee80211_tx_status() for TX frames that are generated
  * internally in the driver.
@@ -244,6 +319,14 @@ void ath9k_tx_status(struct ieee80211_hw
 			 */
 		}
 		aphy->state = ATH_WIPHY_PAUSED;
+		if (!ath9k_wiphy_pausing(aphy->sc)) {
+			/*
+			 * Drop from tasklet to work to allow mutex for channel
+			 * change.
+			 */
+			queue_work(aphy->sc->hw->workqueue,
+				   &aphy->sc->chan_work);
+		}
 	}
 
 	kfree(tx_info_priv);
@@ -252,6 +335,14 @@ void ath9k_tx_status(struct ieee80211_hw
 	dev_kfree_skb(skb);
 }
 
+static void ath9k_mark_paused(struct ath_wiphy *aphy)
+{
+	struct ath_softc *sc = aphy->sc;
+	aphy->state = ATH_WIPHY_PAUSED;
+	if (!__ath9k_wiphy_pausing(sc))
+		queue_work(sc->hw->workqueue, &sc->chan_work);
+}
+
 static void ath9k_pause_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
 {
 	struct ath_wiphy *aphy = data;
@@ -260,15 +351,19 @@ static void ath9k_pause_iter(void *data,
 	switch (vif->type) {
 	case NL80211_IFTYPE_STATION:
 		if (!vif->bss_conf.assoc) {
-			aphy->state = ATH_WIPHY_PAUSED;
+			ath9k_mark_paused(aphy);
 			break;
 		}
 		/* TODO: could avoid this if already in PS mode */
-		ath9k_send_nullfunc(aphy, vif, avp->bssid, 1);
+		if (ath9k_send_nullfunc(aphy, vif, avp->bssid, 1)) {
+			printk(KERN_DEBUG "%s: failed to send PS nullfunc\n",
+			       __func__);
+			ath9k_mark_paused(aphy);
+		}
 		break;
 	case NL80211_IFTYPE_AP:
 		/* Beacon transmission is paused by aphy->state change */
-		aphy->state = ATH_WIPHY_PAUSED;
+		ath9k_mark_paused(aphy);
 		break;
 	default:
 		break;
@@ -336,3 +431,49 @@ int ath9k_wiphy_unpause(struct ath_wiphy
 	spin_unlock_bh(&aphy->sc->wiphy_lock);
 	return ret;
 }
+
+/* caller must hold wiphy_lock */
+static void __ath9k_wiphy_pause_all(struct ath_softc *sc)
+{
+	int i;
+	if (sc->pri_wiphy->state == ATH_WIPHY_ACTIVE)
+		__ath9k_wiphy_pause(sc->pri_wiphy);
+	for (i = 0; i < sc->num_sec_wiphy; i++) {
+		if (sc->sec_wiphy[i] &&
+		    sc->sec_wiphy[i]->state == ATH_WIPHY_ACTIVE)
+			__ath9k_wiphy_pause(sc->sec_wiphy[i]);
+	}
+}
+
+int ath9k_wiphy_select(struct ath_wiphy *aphy)
+{
+	struct ath_softc *sc = aphy->sc;
+	bool now;
+
+	spin_lock_bh(&sc->wiphy_lock);
+	if (__ath9k_wiphy_pausing(sc)) {
+		spin_unlock_bh(&sc->wiphy_lock);
+		return -EBUSY; /* previous select still in progress */
+	}
+
+	/* Store the new channel */
+	sc->chan_idx = aphy->chan_idx;
+	sc->chan_is_ht = aphy->chan_is_ht;
+	sc->next_wiphy = aphy;
+
+	__ath9k_wiphy_pause_all(sc);
+	now = !__ath9k_wiphy_pausing(aphy->sc);
+	spin_unlock_bh(&sc->wiphy_lock);
+
+	if (now) {
+		/* Ready to request channel change immediately */
+		queue_work(aphy->sc->hw->workqueue, &aphy->sc->chan_work);
+	}
+
+	/*
+	 * wiphys will be unpaused in ath9k_tx_status() once channel has been
+	 * changed if any wiphy needs time to become paused.
+	 */
+
+	return 0;
+}

-- 

-- 
Jouni Malinen                                            PGP id EFC895FA
