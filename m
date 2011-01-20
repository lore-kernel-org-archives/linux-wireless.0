Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:53657 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752772Ab1ATWZ4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 17:25:56 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 4/4] ath9k: fold struct ath_wiphy into struct ath_softc
Date: Thu, 20 Jan 2011 23:25:49 +0100
Message-Id: <1295562349-17161-4-git-send-email-nbd@openwrt.org>
In-Reply-To: <1295562349-17161-3-git-send-email-nbd@openwrt.org>
References: <1295562349-17161-1-git-send-email-nbd@openwrt.org>
 <1295562349-17161-2-git-send-email-nbd@openwrt.org>
 <1295562349-17161-3-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ahb.c    |   12 +----
 drivers/net/wireless/ath/ath9k/ath9k.h  |   13 ++----
 drivers/net/wireless/ath/ath9k/beacon.c |    9 +--
 drivers/net/wireless/ath/ath9k/gpio.c   |    3 +-
 drivers/net/wireless/ath/ath9k/init.c   |    6 +--
 drivers/net/wireless/ath/ath9k/main.c   |   78 +++++++++++--------------------
 drivers/net/wireless/ath/ath9k/pci.c    |   18 ++-----
 drivers/net/wireless/ath/ath9k/rc.c     |    3 +-
 drivers/net/wireless/ath/ath9k/recv.c   |    6 +-
 drivers/net/wireless/ath/ath9k/xmit.c   |    9 +--
 10 files changed, 52 insertions(+), 105 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ahb.c b/drivers/net/wireless/ath/ath9k/ahb.c
index 72f430e..9936721 100644
--- a/drivers/net/wireless/ath/ath9k/ahb.c
+++ b/drivers/net/wireless/ath/ath9k/ahb.c
@@ -54,7 +54,6 @@ static struct ath_bus_ops ath_ahb_bus_ops  = {
 static int ath_ahb_probe(struct platform_device *pdev)
 {
 	void __iomem *mem;
-	struct ath_wiphy *aphy;
 	struct ath_softc *sc;
 	struct ieee80211_hw *hw;
 	struct resource *res;
@@ -92,8 +91,7 @@ static int ath_ahb_probe(struct platform_device *pdev)
 
 	irq = res->start;
 
-	hw = ieee80211_alloc_hw(sizeof(struct ath_wiphy) +
-				sizeof(struct ath_softc), &ath9k_ops);
+	hw = ieee80211_alloc_hw(sizeof(struct ath_softc), &ath9k_ops);
 	if (hw == NULL) {
 		dev_err(&pdev->dev, "no memory for ieee80211_hw\n");
 		ret = -ENOMEM;
@@ -103,10 +101,7 @@ static int ath_ahb_probe(struct platform_device *pdev)
 	SET_IEEE80211_DEV(hw, &pdev->dev);
 	platform_set_drvdata(pdev, hw);
 
-	aphy = hw->priv;
-	sc = (struct ath_softc *) (aphy + 1);
-	aphy->sc = sc;
-	aphy->hw = hw;
+	sc = hw->priv;
 	sc->hw = hw;
 	sc->dev = &pdev->dev;
 	sc->mem = mem;
@@ -150,8 +145,7 @@ static int ath_ahb_remove(struct platform_device *pdev)
 	struct ieee80211_hw *hw = platform_get_drvdata(pdev);
 
 	if (hw) {
-		struct ath_wiphy *aphy = hw->priv;
-		struct ath_softc *sc = aphy->sc;
+		struct ath_softc *sc = hw->priv;
 		void __iomem *mem = sc->mem;
 
 		ath9k_deinit_device(sc);
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index fe6a69c..887fd4b 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -32,7 +32,6 @@
  */
 
 struct ath_node;
-struct ath_wiphy;
 
 /* Macro to expand scalars to 64-bit objects */
 
@@ -391,7 +390,7 @@ struct ath_beacon {
 
 void ath_beacon_tasklet(unsigned long data);
 void ath_beacon_config(struct ath_softc *sc, struct ieee80211_vif *vif);
-int ath_beacon_alloc(struct ath_wiphy *aphy, struct ieee80211_vif *vif);
+int ath_beacon_alloc(struct ath_softc *sc, struct ieee80211_vif *vif);
 void ath_beacon_return(struct ath_softc *sc, struct ath_vif *avp);
 int ath_beaconq_config(struct ath_softc *sc);
 
@@ -621,6 +620,9 @@ struct ath_softc {
 	int led_on_cnt;
 	int led_off_cnt;
 
+	struct ath9k_hw_cal_data caldata;
+	int last_rssi;
+
 	int beacon_interval;
 
 #ifdef CONFIG_ATH9K_DEBUGFS
@@ -637,13 +639,6 @@ struct ath_softc {
 	struct pm_qos_request_list pm_qos_req;
 };
 
-struct ath_wiphy {
-	struct ath_softc *sc; /* shared for all virtual wiphys */
-	struct ieee80211_hw *hw;
-	struct ath9k_hw_cal_data caldata;
-	int last_rssi;
-};
-
 void ath9k_tasklet(unsigned long data);
 int ath_reset(struct ath_softc *sc, bool retry_tx);
 int ath_cabq_update(struct ath_softc *);
diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 77c8e70..87ba44c 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -112,8 +112,7 @@ static void ath_beacon_setup(struct ath_softc *sc, struct ath_vif *avp,
 
 static void ath_tx_cabq(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
-	struct ath_wiphy *aphy = hw->priv;
-	struct ath_softc *sc = aphy->sc;
+	struct ath_softc *sc = hw->priv;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_tx_control txctl;
 
@@ -132,8 +131,7 @@ static void ath_tx_cabq(struct ieee80211_hw *hw, struct sk_buff *skb)
 static struct ath_buf *ath_beacon_generate(struct ieee80211_hw *hw,
 					   struct ieee80211_vif *vif)
 {
-	struct ath_wiphy *aphy = hw->priv;
-	struct ath_softc *sc = aphy->sc;
+	struct ath_softc *sc = hw->priv;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_buf *bf;
 	struct ath_vif *avp;
@@ -222,9 +220,8 @@ static struct ath_buf *ath_beacon_generate(struct ieee80211_hw *hw,
 	return bf;
 }
 
-int ath_beacon_alloc(struct ath_wiphy *aphy, struct ieee80211_vif *vif)
+int ath_beacon_alloc(struct ath_softc *sc, struct ieee80211_vif *vif)
 {
-	struct ath_softc *sc = aphy->sc;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_vif *avp;
 	struct ath_buf *bf;
diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
index 1337640..fb4f17a 100644
--- a/drivers/net/wireless/ath/ath9k/gpio.c
+++ b/drivers/net/wireless/ath/ath9k/gpio.c
@@ -201,8 +201,7 @@ static bool ath_is_rfkill_set(struct ath_softc *sc)
 
 void ath9k_rfkill_poll_state(struct ieee80211_hw *hw)
 {
-	struct ath_wiphy *aphy = hw->priv;
-	struct ath_softc *sc = aphy->sc;
+	struct ath_softc *sc = hw->priv;
 	bool blocked = !!ath_is_rfkill_set(sc);
 
 	wiphy_rfkill_set_hw_state(hw->wiphy, blocked);
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index b55a1be..83b9523 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -254,8 +254,7 @@ static int ath9k_reg_notifier(struct wiphy *wiphy,
 			      struct regulatory_request *request)
 {
 	struct ieee80211_hw *hw = wiphy_to_ieee80211_hw(wiphy);
-	struct ath_wiphy *aphy = hw->priv;
-	struct ath_softc *sc = aphy->sc;
+	struct ath_softc *sc = hw->priv;
 	struct ath_regulatory *reg = ath9k_hw_regulatory(sc->sc_ah);
 
 	return ath_reg_notifier_apply(wiphy, request, reg);
@@ -698,7 +697,6 @@ int ath9k_init_device(u16 devid, struct ath_softc *sc, u16 subsysid,
 		    const struct ath_bus_ops *bus_ops)
 {
 	struct ieee80211_hw *hw = sc->hw;
-	struct ath_wiphy *aphy = hw->priv;
 	struct ath_common *common;
 	struct ath_hw *ah;
 	int error = 0;
@@ -753,7 +751,7 @@ int ath9k_init_device(u16 devid, struct ath_softc *sc, u16 subsysid,
 
 	INIT_WORK(&sc->hw_check_work, ath_hw_check);
 	INIT_WORK(&sc->paprd_work, ath_paprd_calibrate);
-	aphy->last_rssi = ATH_RSSI_DUMMY_MARKER;
+	sc->last_rssi = ATH_RSSI_DUMMY_MARKER;
 
 	ath_init_leds(sc);
 	ath_start_rfkill_poll(sc);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index deb92fd..086043c 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -215,7 +215,6 @@ static void ath_update_survey_stats(struct ath_softc *sc)
 int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
 		    struct ath9k_channel *hchan)
 {
-	struct ath_wiphy *aphy = hw->priv;
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ieee80211_conf *conf = &common->hw->conf;
@@ -262,7 +261,7 @@ int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
 		fastcc = false;
 
 	if (!(sc->sc_flags & SC_OP_OFFCHANNEL))
-		caldata = &aphy->caldata;
+		caldata = &sc->caldata;
 
 	ath_dbg(common, ATH_DBG_CONFIG,
 		"(%u MHz) -> (%u MHz), conf_is_ht40: %d fastcc: %d\n",
@@ -841,7 +840,6 @@ static void ath9k_bss_assoc_info(struct ath_softc *sc,
 				 struct ieee80211_vif *vif,
 				 struct ieee80211_bss_conf *bss_conf)
 {
-	struct ath_wiphy *aphy = hw->priv;
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
 
@@ -865,7 +863,7 @@ static void ath9k_bss_assoc_info(struct ath_softc *sc,
 		ath_beacon_config(sc, vif);
 
 		/* Reset rssi stats */
-		aphy->last_rssi = ATH_RSSI_DUMMY_MARKER;
+		sc->last_rssi = ATH_RSSI_DUMMY_MARKER;
 		sc->sc_ah->stats.avgbrssi = ATH_RSSI_DUMMY_MARKER;
 
 		sc->sc_flags |= SC_OP_ANI_RUN;
@@ -1062,8 +1060,7 @@ void ath9k_update_ichannel(struct ath_softc *sc, struct ieee80211_hw *hw,
 
 static int ath9k_start(struct ieee80211_hw *hw)
 {
-	struct ath_wiphy *aphy = hw->priv;
-	struct ath_softc *sc = aphy->sc;
+	struct ath_softc *sc = hw->priv;
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ieee80211_channel *curchan = hw->conf.channel;
@@ -1180,8 +1177,7 @@ mutex_unlock:
 static int ath9k_tx(struct ieee80211_hw *hw,
 		    struct sk_buff *skb)
 {
-	struct ath_wiphy *aphy = hw->priv;
-	struct ath_softc *sc = aphy->sc;
+	struct ath_softc *sc = hw->priv;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_tx_control txctl;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
@@ -1244,8 +1240,7 @@ exit:
 
 static void ath9k_stop(struct ieee80211_hw *hw)
 {
-	struct ath_wiphy *aphy = hw->priv;
-	struct ath_softc *sc = aphy->sc;
+	struct ath_softc *sc = hw->priv;
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
 
@@ -1380,8 +1375,7 @@ void ath9k_calculate_iter_data(struct ieee80211_hw *hw,
 			       struct ieee80211_vif *vif,
 			       struct ath9k_vif_iter_data *iter_data)
 {
-	struct ath_wiphy *aphy = hw->priv;
-	struct ath_softc *sc = aphy->sc;
+	struct ath_softc *sc = hw->priv;
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
 
@@ -1405,8 +1399,7 @@ void ath9k_calculate_iter_data(struct ieee80211_hw *hw,
 static void ath9k_calculate_summary_state(struct ieee80211_hw *hw,
 					  struct ieee80211_vif *vif)
 {
-	struct ath_wiphy *aphy = hw->priv;
-	struct ath_softc *sc = aphy->sc;
+	struct ath_softc *sc = hw->priv;
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath9k_vif_iter_data iter_data;
@@ -1462,8 +1455,7 @@ static void ath9k_calculate_summary_state(struct ieee80211_hw *hw,
 static void ath9k_do_vif_add_setup(struct ieee80211_hw *hw,
 				   struct ieee80211_vif *vif)
 {
-	struct ath_wiphy *aphy = hw->priv;
-	struct ath_softc *sc = aphy->sc;
+	struct ath_softc *sc = hw->priv;
 
 	ath9k_calculate_summary_state(hw, vif);
 
@@ -1476,7 +1468,7 @@ static void ath9k_do_vif_add_setup(struct ieee80211_hw *hw,
 		 * in the info_changed method and set up beacons properly
 		 * there.
 		 */
-		error = ath_beacon_alloc(aphy, vif);
+		error = ath_beacon_alloc(sc, vif);
 		if (error)
 			ath9k_reclaim_beacon(sc, vif);
 		else
@@ -1488,8 +1480,7 @@ static void ath9k_do_vif_add_setup(struct ieee80211_hw *hw,
 static int ath9k_add_interface(struct ieee80211_hw *hw,
 			       struct ieee80211_vif *vif)
 {
-	struct ath_wiphy *aphy = hw->priv;
-	struct ath_softc *sc = aphy->sc;
+	struct ath_softc *sc = hw->priv;
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath_vif *avp = (void *)vif->drv_priv;
@@ -1549,8 +1540,7 @@ static int ath9k_change_interface(struct ieee80211_hw *hw,
 				  enum nl80211_iftype new_type,
 				  bool p2p)
 {
-	struct ath_wiphy *aphy = hw->priv;
-	struct ath_softc *sc = aphy->sc;
+	struct ath_softc *sc = hw->priv;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	int ret = 0;
 
@@ -1592,8 +1582,7 @@ out:
 static void ath9k_remove_interface(struct ieee80211_hw *hw,
 				   struct ieee80211_vif *vif)
 {
-	struct ath_wiphy *aphy = hw->priv;
-	struct ath_softc *sc = aphy->sc;
+	struct ath_softc *sc = hw->priv;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 
 	ath_dbg(common, ATH_DBG_CONFIG, "Detach Interface\n");
@@ -1647,8 +1636,7 @@ static void ath9k_disable_ps(struct ath_softc *sc)
 
 static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 {
-	struct ath_wiphy *aphy = hw->priv;
-	struct ath_softc *sc = aphy->sc;
+	struct ath_softc *sc = hw->priv;
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ieee80211_conf *conf = &hw->conf;
@@ -1792,8 +1780,7 @@ static void ath9k_configure_filter(struct ieee80211_hw *hw,
 				   unsigned int *total_flags,
 				   u64 multicast)
 {
-	struct ath_wiphy *aphy = hw->priv;
-	struct ath_softc *sc = aphy->sc;
+	struct ath_softc *sc = hw->priv;
 	u32 rfilt;
 
 	changed_flags &= SUPPORTED_FILTERS;
@@ -1813,8 +1800,7 @@ static int ath9k_sta_add(struct ieee80211_hw *hw,
 			 struct ieee80211_vif *vif,
 			 struct ieee80211_sta *sta)
 {
-	struct ath_wiphy *aphy = hw->priv;
-	struct ath_softc *sc = aphy->sc;
+	struct ath_softc *sc = hw->priv;
 
 	ath_node_attach(sc, sta);
 
@@ -1825,8 +1811,7 @@ static int ath9k_sta_remove(struct ieee80211_hw *hw,
 			    struct ieee80211_vif *vif,
 			    struct ieee80211_sta *sta)
 {
-	struct ath_wiphy *aphy = hw->priv;
-	struct ath_softc *sc = aphy->sc;
+	struct ath_softc *sc = hw->priv;
 
 	ath_node_detach(sc, sta);
 
@@ -1836,8 +1821,7 @@ static int ath9k_sta_remove(struct ieee80211_hw *hw,
 static int ath9k_conf_tx(struct ieee80211_hw *hw, u16 queue,
 			 const struct ieee80211_tx_queue_params *params)
 {
-	struct ath_wiphy *aphy = hw->priv;
-	struct ath_softc *sc = aphy->sc;
+	struct ath_softc *sc = hw->priv;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_txq *txq;
 	struct ath9k_tx_queue_info qi;
@@ -1881,8 +1865,7 @@ static int ath9k_set_key(struct ieee80211_hw *hw,
 			 struct ieee80211_sta *sta,
 			 struct ieee80211_key_conf *key)
 {
-	struct ath_wiphy *aphy = hw->priv;
-	struct ath_softc *sc = aphy->sc;
+	struct ath_softc *sc = hw->priv;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	int ret = 0;
 
@@ -1926,8 +1909,7 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 				   struct ieee80211_bss_conf *bss_conf,
 				   u32 changed)
 {
-	struct ath_wiphy *aphy = hw->priv;
-	struct ath_softc *sc = aphy->sc;
+	struct ath_softc *sc = hw->priv;
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath_vif *avp = (void *)vif->drv_priv;
@@ -1957,7 +1939,7 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 	if ((changed & BSS_CHANGED_BEACON) ||
 	    ((changed & BSS_CHANGED_BEACON_ENABLED) && bss_conf->enable_beacon)) {
 		ath9k_hw_stoptxdma(sc->sc_ah, sc->beacon.beaconq);
-		error = ath_beacon_alloc(aphy, vif);
+		error = ath_beacon_alloc(sc, vif);
 		if (!error)
 			ath_beacon_config(sc, vif);
 	}
@@ -1994,7 +1976,7 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 		if (vif->type == NL80211_IFTYPE_AP) {
 			sc->sc_flags |= SC_OP_TSF_RESET;
 			ath9k_hw_stoptxdma(sc->sc_ah, sc->beacon.beaconq);
-			error = ath_beacon_alloc(aphy, vif);
+			error = ath_beacon_alloc(sc, vif);
 			if (!error)
 				ath_beacon_config(sc, vif);
 		} else {
@@ -2032,9 +2014,8 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 
 static u64 ath9k_get_tsf(struct ieee80211_hw *hw)
 {
+	struct ath_softc *sc = hw->priv;
 	u64 tsf;
-	struct ath_wiphy *aphy = hw->priv;
-	struct ath_softc *sc = aphy->sc;
 
 	mutex_lock(&sc->mutex);
 	ath9k_ps_wakeup(sc);
@@ -2047,8 +2028,7 @@ static u64 ath9k_get_tsf(struct ieee80211_hw *hw)
 
 static void ath9k_set_tsf(struct ieee80211_hw *hw, u64 tsf)
 {
-	struct ath_wiphy *aphy = hw->priv;
-	struct ath_softc *sc = aphy->sc;
+	struct ath_softc *sc = hw->priv;
 
 	mutex_lock(&sc->mutex);
 	ath9k_ps_wakeup(sc);
@@ -2059,8 +2039,7 @@ static void ath9k_set_tsf(struct ieee80211_hw *hw, u64 tsf)
 
 static void ath9k_reset_tsf(struct ieee80211_hw *hw)
 {
-	struct ath_wiphy *aphy = hw->priv;
-	struct ath_softc *sc = aphy->sc;
+	struct ath_softc *sc = hw->priv;
 
 	mutex_lock(&sc->mutex);
 
@@ -2077,8 +2056,7 @@ static int ath9k_ampdu_action(struct ieee80211_hw *hw,
 			      struct ieee80211_sta *sta,
 			      u16 tid, u16 *ssn, u8 buf_size)
 {
-	struct ath_wiphy *aphy = hw->priv;
-	struct ath_softc *sc = aphy->sc;
+	struct ath_softc *sc = hw->priv;
 	int ret = 0;
 
 	local_bh_disable();
@@ -2123,8 +2101,7 @@ static int ath9k_ampdu_action(struct ieee80211_hw *hw,
 static int ath9k_get_survey(struct ieee80211_hw *hw, int idx,
 			     struct survey_info *survey)
 {
-	struct ath_wiphy *aphy = hw->priv;
-	struct ath_softc *sc = aphy->sc;
+	struct ath_softc *sc = hw->priv;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_channel *chan;
@@ -2160,8 +2137,7 @@ static int ath9k_get_survey(struct ieee80211_hw *hw, int idx,
 
 static void ath9k_set_coverage_class(struct ieee80211_hw *hw, u8 coverage_class)
 {
-	struct ath_wiphy *aphy = hw->priv;
-	struct ath_softc *sc = aphy->sc;
+	struct ath_softc *sc = hw->priv;
 	struct ath_hw *ah = sc->sc_ah;
 
 	mutex_lock(&sc->mutex);
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index 1f60b8c..e83128c 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -126,7 +126,6 @@ static const struct ath_bus_ops ath_pci_bus_ops = {
 static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	void __iomem *mem;
-	struct ath_wiphy *aphy;
 	struct ath_softc *sc;
 	struct ieee80211_hw *hw;
 	u8 csz;
@@ -198,8 +197,7 @@ static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto err_iomap;
 	}
 
-	hw = ieee80211_alloc_hw(sizeof(struct ath_wiphy) +
-				sizeof(struct ath_softc), &ath9k_ops);
+	hw = ieee80211_alloc_hw(sizeof(struct ath_softc), &ath9k_ops);
 	if (!hw) {
 		dev_err(&pdev->dev, "No memory for ieee80211_hw\n");
 		ret = -ENOMEM;
@@ -209,10 +207,7 @@ static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	SET_IEEE80211_DEV(hw, &pdev->dev);
 	pci_set_drvdata(pdev, hw);
 
-	aphy = hw->priv;
-	sc = (struct ath_softc *) (aphy + 1);
-	aphy->sc = sc;
-	aphy->hw = hw;
+	sc = hw->priv;
 	sc->hw = hw;
 	sc->dev = &pdev->dev;
 	sc->mem = mem;
@@ -259,8 +254,7 @@ err_dma:
 static void ath_pci_remove(struct pci_dev *pdev)
 {
 	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
-	struct ath_wiphy *aphy = hw->priv;
-	struct ath_softc *sc = aphy->sc;
+	struct ath_softc *sc = hw->priv;
 	void __iomem *mem = sc->mem;
 
 	if (!is_ath9k_unloaded)
@@ -280,8 +274,7 @@ static int ath_pci_suspend(struct device *device)
 {
 	struct pci_dev *pdev = to_pci_dev(device);
 	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
-	struct ath_wiphy *aphy = hw->priv;
-	struct ath_softc *sc = aphy->sc;
+	struct ath_softc *sc = hw->priv;
 
 	ath9k_hw_set_gpio(sc->sc_ah, sc->sc_ah->led_pin, 1);
 
@@ -292,8 +285,7 @@ static int ath_pci_resume(struct device *device)
 {
 	struct pci_dev *pdev = to_pci_dev(device);
 	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
-	struct ath_wiphy *aphy = hw->priv;
-	struct ath_softc *sc = aphy->sc;
+	struct ath_softc *sc = hw->priv;
 	u32 val;
 
 	/*
diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index e451478..960d717 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -1560,8 +1560,7 @@ static void ath_rate_add_sta_debugfs(void *priv, void *priv_sta,
 
 static void *ath_rate_alloc(struct ieee80211_hw *hw, struct dentry *debugfsdir)
 {
-	struct ath_wiphy *aphy = hw->priv;
-	return aphy->sc;
+	return hw->priv;
 }
 
 static void ath_rate_free(void *priv)
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index c84a675..b2b12a2 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -927,7 +927,7 @@ static void ath9k_process_rssi(struct ath_common *common,
 			       struct ieee80211_hdr *hdr,
 			       struct ath_rx_status *rx_stats)
 {
-	struct ath_wiphy *aphy = hw->priv;
+	struct ath_softc *sc = hw->priv;
 	struct ath_hw *ah = common->ah;
 	int last_rssi;
 	__le16 fc;
@@ -947,9 +947,9 @@ static void ath9k_process_rssi(struct ath_common *common,
 	}
 
 	if (rx_stats->rs_rssi != ATH9K_RSSI_BAD && !rx_stats->rs_moreaggr)
-		ATH_RSSI_LPF(aphy->last_rssi, rx_stats->rs_rssi);
+		ATH_RSSI_LPF(sc->last_rssi, rx_stats->rs_rssi);
 
-	last_rssi = aphy->last_rssi;
+	last_rssi = sc->last_rssi;
 	if (likely(last_rssi != ATH_RSSI_DUMMY_MARKER))
 		rx_stats->rs_rssi = ATH_EP_RND(last_rssi,
 					      ATH_RSSI_EP_MULTIPLIER);
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 80dc0cc..0ddfdbc 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1430,8 +1430,7 @@ static enum ath9k_pkt_type get_hw_packet_type(struct sk_buff *skb)
 static void setup_frame_info(struct ieee80211_hw *hw, struct sk_buff *skb,
 			     int framelen)
 {
-	struct ath_wiphy *aphy = hw->priv;
-	struct ath_softc *sc = aphy->sc;
+	struct ath_softc *sc = hw->priv;
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_sta *sta = tx_info->control.sta;
 	struct ieee80211_key_conf *hw_key = tx_info->control.hw_key;
@@ -1649,8 +1648,7 @@ static struct ath_buf *ath_tx_setup_buffer(struct ieee80211_hw *hw,
 					   struct ath_txq *txq,
 					   struct sk_buff *skb)
 {
-	struct ath_wiphy *aphy = hw->priv;
-	struct ath_softc *sc = aphy->sc;
+	struct ath_softc *sc = hw->priv;
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_frame_info *fi = get_frame_info(skb);
@@ -1751,8 +1749,7 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_sta *sta = info->control.sta;
-	struct ath_wiphy *aphy = hw->priv;
-	struct ath_softc *sc = aphy->sc;
+	struct ath_softc *sc = hw->priv;
 	struct ath_txq *txq = txctl->txq;
 	struct ath_buf *bf;
 	int padpos, padsize;
-- 
1.7.3.2

