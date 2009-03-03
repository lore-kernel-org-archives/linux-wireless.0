Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:35421 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754753AbZCCRY5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2009 12:24:57 -0500
Message-Id: <20090303172449.797008601@atheros.com> (sfid-20090303_182500_288615_304267D0)
References: <20090303172325.437810138@atheros.com>
Date: Tue, 03 Mar 2009 19:23:28 +0200
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>
Subject: [PATCH 03/15] ath9k: Add data structure for supporting virtual radio/wiphy operation
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is the initial step in allowing ath9k to register multiple
virtual radios (wiphys). The goal of virtual radios is to allow the
same radio to be shared for multiple virtual interfaces that may
operate on different channels. The mac80211 virtual interface support
is designed only for single channel operation and as such, it is not
suitable for this type of use. Anyway, it can be used on top of the
virtual radio concept, if desired (e.g., use two virtual radios to
handle two channels and then add multiple mac80211 virtual interfaces
on top of each virtual radio).

The new struct ath_wiphy is now registered as the driver data
structure for wiphy. This structure has a pointer to the shared (among
virtual wiphys of the same physical radio) struct ath_softc data. The
primary wiphy maintains the allocated memory for ath_softc. Secondary
(virtual) wiphys will only allocate the new ath_wiphy structure.

Registration of secondary wiphys is added in a separate patch.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 drivers/net/wireless/ath9k/ahb.c     |   12 +++++--
 drivers/net/wireless/ath9k/ath9k.h   |    8 ++++
 drivers/net/wireless/ath9k/main.c    |   58 ++++++++++++++++++++++-------------
 drivers/net/wireless/ath9k/pci.c     |   19 ++++++++---
 drivers/net/wireless/ath9k/rc.c      |    3 +
 drivers/net/wireless/ath9k/recv.c    |   15 ++++++---
 drivers/net/wireless/ath9k/regd.c    |    6 ++-
 drivers/net/wireless/ath9k/virtual.c |    3 +
 8 files changed, 88 insertions(+), 36 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/ath9k/ath9k.h	2009-03-03 18:30:22.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/ath9k.h	2009-03-03 18:30:34.000000000 +0200
@@ -549,9 +549,12 @@ struct ath_bus_ops {
 	bool		(*eeprom_read)(struct ath_hw *ah, u32 off, u16 *data);
 };
 
+struct ath_wiphy;
+
 struct ath_softc {
 	struct ieee80211_hw *hw;
 	struct device *dev;
+	struct ath_wiphy *pri_wiphy;
 	struct tasklet_struct intr_tq;
 	struct tasklet_struct bcon_tasklet;
 	struct ath_hw *sc_ah;
@@ -607,6 +610,11 @@ struct ath_softc {
 	struct ath_bus_ops *bus_ops;
 };
 
+struct ath_wiphy {
+	struct ath_softc *sc; /* shared for all virtual wiphys */
+	struct ieee80211_hw *hw;
+};
+
 int ath_reset(struct ath_softc *sc, bool retry_tx);
 int ath_get_hal_qnum(u16 queue, struct ath_softc *sc);
 int ath_get_mac80211_qnum(u32 queue, struct ath_softc *sc);
--- wireless-testing.orig/drivers/net/wireless/ath9k/pci.c	2009-02-27 10:53:01.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/pci.c	2009-03-03 18:30:34.000000000 +0200
@@ -83,6 +83,7 @@ static struct ath_bus_ops ath_pci_bus_op
 static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	void __iomem *mem;
+	struct ath_wiphy *aphy;
 	struct ath_softc *sc;
 	struct ieee80211_hw *hw;
 	u8 csz;
@@ -155,7 +156,8 @@ static int ath_pci_probe(struct pci_dev 
 		goto bad1;
 	}
 
-	hw = ieee80211_alloc_hw(sizeof(struct ath_softc), &ath9k_ops);
+	hw = ieee80211_alloc_hw(sizeof(struct ath_wiphy) +
+				sizeof(struct ath_softc), &ath9k_ops);
 	if (hw == NULL) {
 		printk(KERN_ERR "ath_pci: no memory for ieee80211_hw\n");
 		goto bad2;
@@ -164,7 +166,11 @@ static int ath_pci_probe(struct pci_dev 
 	SET_IEEE80211_DEV(hw, &pdev->dev);
 	pci_set_drvdata(pdev, hw);
 
-	sc = hw->priv;
+	aphy = hw->priv;
+	sc = (struct ath_softc *) (aphy + 1);
+	aphy->sc = sc;
+	aphy->hw = hw;
+	sc->pri_wiphy = aphy;
 	sc->hw = hw;
 	sc->dev = &pdev->dev;
 	sc->mem = mem;
@@ -214,7 +220,8 @@ bad:
 static void ath_pci_remove(struct pci_dev *pdev)
 {
 	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
-	struct ath_softc *sc = hw->priv;
+	struct ath_wiphy *aphy = hw->priv;
+	struct ath_softc *sc = aphy->sc;
 
 	ath_cleanup(sc);
 }
@@ -224,7 +231,8 @@ static void ath_pci_remove(struct pci_de
 static int ath_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 {
 	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
-	struct ath_softc *sc = hw->priv;
+	struct ath_wiphy *aphy = hw->priv;
+	struct ath_softc *sc = aphy->sc;
 
 	ath9k_hw_set_gpio(sc->sc_ah, ATH_LED_PIN, 1);
 
@@ -243,7 +251,8 @@ static int ath_pci_suspend(struct pci_de
 static int ath_pci_resume(struct pci_dev *pdev)
 {
 	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
-	struct ath_softc *sc = hw->priv;
+	struct ath_wiphy *aphy = hw->priv;
+	struct ath_softc *sc = aphy->sc;
 	u32 val;
 	int err;
 
--- wireless-testing.orig/drivers/net/wireless/ath9k/main.c	2009-03-03 18:30:22.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/main.c	2009-03-03 18:30:34.000000000 +0200
@@ -1932,7 +1932,8 @@ static void ath9k_update_ichannel(struct
 
 static int ath9k_start(struct ieee80211_hw *hw)
 {
-	struct ath_softc *sc = hw->priv;
+	struct ath_wiphy *aphy = hw->priv;
+	struct ath_softc *sc = aphy->sc;
 	struct ieee80211_channel *curchan = hw->conf.channel;
 	struct ath9k_channel *init_channel;
 	int r, pos;
@@ -2010,7 +2011,7 @@ static int ath9k_start(struct ieee80211_
 	sc->imask &= ~(ATH9K_INT_SWBA | ATH9K_INT_BMISS);
 	ath9k_hw_set_interrupts(sc->sc_ah, sc->imask);
 
-	ieee80211_wake_queues(sc->hw);
+	ieee80211_wake_queues(hw);
 
 #if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
 	r = ath_start_rfkill_poll(sc);
@@ -2026,7 +2027,8 @@ static int ath9k_tx(struct ieee80211_hw 
 		    struct sk_buff *skb)
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	struct ath_softc *sc = hw->priv;
+	struct ath_wiphy *aphy = hw->priv;
+	struct ath_softc *sc = aphy->sc;
 	struct ath_tx_control txctl;
 	int hdrlen, padsize;
 
@@ -2076,7 +2078,8 @@ exit:
 
 static void ath9k_stop(struct ieee80211_hw *hw)
 {
-	struct ath_softc *sc = hw->priv;
+	struct ath_wiphy *aphy = hw->priv;
+	struct ath_softc *sc = aphy->sc;
 
 	if (sc->sc_flags & SC_OP_INVALID) {
 		DPRINTF(sc, ATH_DBG_ANY, "Device not present\n");
@@ -2085,7 +2088,7 @@ static void ath9k_stop(struct ieee80211_
 
 	mutex_lock(&sc->mutex);
 
-	ieee80211_stop_queues(sc->hw);
+	ieee80211_stop_queues(hw);
 
 	/* make sure h/w will not generate any interrupt
 	 * before setting the invalid flag. */
@@ -2116,7 +2119,8 @@ static void ath9k_stop(struct ieee80211_
 static int ath9k_add_interface(struct ieee80211_hw *hw,
 			       struct ieee80211_if_init_conf *conf)
 {
-	struct ath_softc *sc = hw->priv;
+	struct ath_wiphy *aphy = hw->priv;
+	struct ath_softc *sc = aphy->sc;
 	struct ath_vif *avp = (void *)conf->vif->drv_priv;
 	enum nl80211_iftype ic_opmode = NL80211_IFTYPE_UNSPECIFIED;
 	int ret = 0;
@@ -2215,7 +2219,8 @@ out:
 static void ath9k_remove_interface(struct ieee80211_hw *hw,
 				   struct ieee80211_if_init_conf *conf)
 {
-	struct ath_softc *sc = hw->priv;
+	struct ath_wiphy *aphy = hw->priv;
+	struct ath_softc *sc = aphy->sc;
 	struct ath_vif *avp = (void *)conf->vif->drv_priv;
 	int i;
 
@@ -2250,7 +2255,8 @@ static void ath9k_remove_interface(struc
 
 static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 {
-	struct ath_softc *sc = hw->priv;
+	struct ath_wiphy *aphy = hw->priv;
+	struct ath_softc *sc = aphy->sc;
 	struct ieee80211_conf *conf = &hw->conf;
 
 	mutex_lock(&sc->mutex);
@@ -2317,7 +2323,8 @@ static int ath9k_config_interface(struct
 				  struct ieee80211_vif *vif,
 				  struct ieee80211_if_conf *conf)
 {
-	struct ath_softc *sc = hw->priv;
+	struct ath_wiphy *aphy = hw->priv;
+	struct ath_softc *sc = aphy->sc;
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_vif *avp = (void *)vif->drv_priv;
 	u32 rfilt = 0;
@@ -2422,7 +2429,8 @@ static void ath9k_configure_filter(struc
 				   int mc_count,
 				   struct dev_mc_list *mclist)
 {
-	struct ath_softc *sc = hw->priv;
+	struct ath_wiphy *aphy = hw->priv;
+	struct ath_softc *sc = aphy->sc;
 	u32 rfilt;
 
 	changed_flags &= SUPPORTED_FILTERS;
@@ -2448,7 +2456,8 @@ static void ath9k_sta_notify(struct ieee
 			     enum sta_notify_cmd cmd,
 			     struct ieee80211_sta *sta)
 {
-	struct ath_softc *sc = hw->priv;
+	struct ath_wiphy *aphy = hw->priv;
+	struct ath_softc *sc = aphy->sc;
 
 	switch (cmd) {
 	case STA_NOTIFY_ADD:
@@ -2465,7 +2474,8 @@ static void ath9k_sta_notify(struct ieee
 static int ath9k_conf_tx(struct ieee80211_hw *hw, u16 queue,
 			 const struct ieee80211_tx_queue_params *params)
 {
-	struct ath_softc *sc = hw->priv;
+	struct ath_wiphy *aphy = hw->priv;
+	struct ath_softc *sc = aphy->sc;
 	struct ath9k_tx_queue_info qi;
 	int ret = 0, qnum;
 
@@ -2501,7 +2511,8 @@ static int ath9k_set_key(struct ieee8021
 			 struct ieee80211_sta *sta,
 			 struct ieee80211_key_conf *key)
 {
-	struct ath_softc *sc = hw->priv;
+	struct ath_wiphy *aphy = hw->priv;
+	struct ath_softc *sc = aphy->sc;
 	int ret = 0;
 
 	if (modparam_nohwcrypt)
@@ -2543,7 +2554,8 @@ static void ath9k_bss_info_changed(struc
 				   struct ieee80211_bss_conf *bss_conf,
 				   u32 changed)
 {
-	struct ath_softc *sc = hw->priv;
+	struct ath_wiphy *aphy = hw->priv;
+	struct ath_softc *sc = aphy->sc;
 
 	mutex_lock(&sc->mutex);
 
@@ -2578,7 +2590,8 @@ static void ath9k_bss_info_changed(struc
 static u64 ath9k_get_tsf(struct ieee80211_hw *hw)
 {
 	u64 tsf;
-	struct ath_softc *sc = hw->priv;
+	struct ath_wiphy *aphy = hw->priv;
+	struct ath_softc *sc = aphy->sc;
 
 	mutex_lock(&sc->mutex);
 	tsf = ath9k_hw_gettsf64(sc->sc_ah);
@@ -2589,7 +2602,8 @@ static u64 ath9k_get_tsf(struct ieee8021
 
 static void ath9k_set_tsf(struct ieee80211_hw *hw, u64 tsf)
 {
-	struct ath_softc *sc = hw->priv;
+	struct ath_wiphy *aphy = hw->priv;
+	struct ath_softc *sc = aphy->sc;
 
 	mutex_lock(&sc->mutex);
 	ath9k_hw_settsf64(sc->sc_ah, tsf);
@@ -2598,7 +2612,8 @@ static void ath9k_set_tsf(struct ieee802
 
 static void ath9k_reset_tsf(struct ieee80211_hw *hw)
 {
-	struct ath_softc *sc = hw->priv;
+	struct ath_wiphy *aphy = hw->priv;
+	struct ath_softc *sc = aphy->sc;
 
 	mutex_lock(&sc->mutex);
 	ath9k_hw_reset_tsf(sc->sc_ah);
@@ -2610,7 +2625,8 @@ static int ath9k_ampdu_action(struct iee
 			      struct ieee80211_sta *sta,
 			      u16 tid, u16 *ssn)
 {
-	struct ath_softc *sc = hw->priv;
+	struct ath_wiphy *aphy = hw->priv;
+	struct ath_softc *sc = aphy->sc;
 	int ret = 0;
 
 	switch (action) {
@@ -2648,7 +2664,8 @@ static int ath9k_ampdu_action(struct iee
 
 static void ath9k_sw_scan_start(struct ieee80211_hw *hw)
 {
-	struct ath_softc *sc = hw->priv;
+	struct ath_wiphy *aphy = hw->priv;
+	struct ath_softc *sc = aphy->sc;
 
 	mutex_lock(&sc->mutex);
 	sc->sc_flags |= SC_OP_SCANNING;
@@ -2657,7 +2674,8 @@ static void ath9k_sw_scan_start(struct i
 
 static void ath9k_sw_scan_complete(struct ieee80211_hw *hw)
 {
-	struct ath_softc *sc = hw->priv;
+	struct ath_wiphy *aphy = hw->priv;
+	struct ath_softc *sc = aphy->sc;
 
 	mutex_lock(&sc->mutex);
 	sc->sc_flags &= ~SC_OP_SCANNING;
--- wireless-testing.orig/drivers/net/wireless/ath9k/ahb.c	2009-02-27 10:53:01.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/ahb.c	2009-03-03 18:30:34.000000000 +0200
@@ -96,7 +96,8 @@ static int ath_ahb_probe(struct platform
 
 	irq = res->start;
 
-	hw = ieee80211_alloc_hw(sizeof(struct ath_softc), &ath9k_ops);
+	hw = ieee80211_alloc_hw(sizeof(struct ath_wiphy) +
+				sizeof(struct ath_softc), &ath9k_ops);
 	if (hw == NULL) {
 		dev_err(&pdev->dev, "no memory for ieee80211_hw\n");
 		ret = -ENOMEM;
@@ -106,7 +107,11 @@ static int ath_ahb_probe(struct platform
 	SET_IEEE80211_DEV(hw, &pdev->dev);
 	platform_set_drvdata(pdev, hw);
 
-	sc = hw->priv;
+	aphy = hw->priv;
+	sc = (struct ath_softc *) (aphy + 1);
+	aphy->sc = sc;
+	aphy->hw = hw;
+	sc->pri_wiphy = aphy;
 	sc->hw = hw;
 	sc->dev = &pdev->dev;
 	sc->mem = mem;
@@ -156,7 +161,8 @@ static int ath_ahb_remove(struct platfor
 	struct ieee80211_hw *hw = platform_get_drvdata(pdev);
 
 	if (hw) {
-		struct ath_softc *sc = hw->priv;
+		struct ath_wiphy *aphy = hw->priv;
+		struct ath_softc *sc = aphy->sc;
 
 		ath_cleanup(sc);
 		platform_set_drvdata(pdev, NULL);
--- wireless-testing.orig/drivers/net/wireless/ath9k/rc.c	2009-02-28 00:24:24.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/rc.c	2009-03-03 18:30:34.000000000 +0200
@@ -1611,7 +1611,8 @@ static void ath_rate_init(void *priv, st
 
 static void *ath_rate_alloc(struct ieee80211_hw *hw, struct dentry *debugfsdir)
 {
-	return hw->priv;
+	struct ath_wiphy *aphy = hw->priv;
+	return aphy->sc;
 }
 
 static void ath_rate_free(void *priv)
--- wireless-testing.orig/drivers/net/wireless/ath9k/regd.c	2009-02-27 10:53:01.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/regd.c	2009-03-03 18:30:34.000000000 +0200
@@ -311,7 +311,8 @@ void ath9k_reg_apply_radar_flags(struct 
 void ath9k_reg_apply_world_flags(struct wiphy *wiphy, enum reg_set_by setby)
 {
 	struct ieee80211_hw *hw = wiphy_to_ieee80211_hw(wiphy);
-	struct ath_softc *sc = hw->priv;
+	struct ath_wiphy *aphy = hw->priv;
+	struct ath_softc *sc = aphy->sc;
 	struct ath_hw *ah = sc->sc_ah;
 
 	switch (ah->regulatory.regpair->regDmnEnum) {
@@ -332,7 +333,8 @@ void ath9k_reg_apply_world_flags(struct 
 int ath9k_reg_notifier(struct wiphy *wiphy, struct regulatory_request *request)
 {
 	struct ieee80211_hw *hw = wiphy_to_ieee80211_hw(wiphy);
-	struct ath_softc *sc = hw->priv;
+	struct ath_wiphy *aphy = hw->priv;
+	struct ath_softc *sc = aphy->sc;
 
 	/* We always apply this */
 	ath9k_reg_apply_radar_flags(wiphy);
--- wireless-testing.orig/drivers/net/wireless/ath9k/recv.c	2009-02-27 10:53:01.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/recv.c	2009-03-03 18:30:34.000000000 +0200
@@ -16,6 +16,12 @@
 
 #include "ath9k.h"
 
+static struct ieee80211_hw * ath_get_virt_hw(struct ath_softc *sc,
+					     struct ieee80211_hdr *hdr)
+{
+	return sc->pri_wiphy->hw;
+}
+
 /*
  * Setup and link descriptors.
  *
@@ -123,10 +129,12 @@ static int ath_rx_prepare(struct sk_buff
 	struct ieee80211_hdr *hdr;
 	u8 ratecode;
 	__le16 fc;
+	struct ieee80211_hw *hw;
 
 	hdr = (struct ieee80211_hdr *)skb->data;
 	fc = hdr->frame_control;
 	memset(rx_status, 0, sizeof(struct ieee80211_rx_status));
+	hw = ath_get_virt_hw(sc, hdr);
 
 	if (ds->ds_rxstat.rs_more) {
 		/*
@@ -186,7 +194,6 @@ static int ath_rx_prepare(struct sk_buff
 		rx_status->rate_idx = ratecode & 0x7f;
 	} else {
 		int i = 0, cur_band, n_rates;
-		struct ieee80211_hw *hw = sc->hw;
 
 		cur_band = hw->conf.channel->band;
 		n_rates = sc->sbands[cur_band].n_bitrates;
@@ -208,8 +215,8 @@ static int ath_rx_prepare(struct sk_buff
 	}
 
 	rx_status->mactime = ath_extend_tsf(sc, ds->ds_rxstat.rs_tstamp);
-	rx_status->band = sc->hw->conf.channel->band;
-	rx_status->freq =  sc->hw->conf.channel->center_freq;
+	rx_status->band = hw->conf.channel->band;
+	rx_status->freq = hw->conf.channel->center_freq;
 	rx_status->noise = sc->ani.noise_floor;
 	rx_status->signal = rx_status->noise + ds->ds_rxstat.rs_rssi;
 	rx_status->antenna = ds->ds_rxstat.rs_antenna;
@@ -604,7 +611,7 @@ int ath_rx_tasklet(struct ath_softc *sc,
 		}
 
 		/* Send the frame to mac80211 */
-		__ieee80211_rx(sc->hw, skb, &rx_status);
+		__ieee80211_rx(ath_get_virt_hw(sc, hdr), skb, &rx_status);
 
 		/* We will now give hardware our shiny new allocated skb */
 		bf->bf_mpdu = requeue_skb;
--- wireless-testing.orig/drivers/net/wireless/ath9k/virtual.c	2009-03-03 18:30:22.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/virtual.c	2009-03-03 18:30:34.000000000 +0200
@@ -38,7 +38,8 @@ static void ath9k_vif_iter(void *data, u
 
 void ath9k_set_bssid_mask(struct ieee80211_hw *hw)
 {
-	struct ath_softc *sc = hw->priv;
+	struct ath_wiphy *aphy = hw->priv;
+	struct ath_softc *sc = aphy->sc;
 	struct ath9k_vif_iter_data iter_data;
 	int i, j;
 	u8 mask[ETH_ALEN];

-- 

-- 
Jouni Malinen                                            PGP id EFC895FA
