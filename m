Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:35427 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754801AbZCCRZD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2009 12:25:03 -0500
Message-Id: <20090303172454.489783253@atheros.com> (sfid-20090303_182507_652618_A041B151)
References: <20090303172325.437810138@atheros.com>
Date: Tue, 03 Mar 2009 19:23:29 +0200
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>
Subject: [PATCH 04/15] ath9k: Add support for multiple secondary virtual wiphys
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The new struct ath_softc::sec_wiphy array is used to store information
about virtual wiphys and select which wiphy is used in calls to
mac80211. Each virtual wiphy will be assigned a different MAC address
based on the virtual wiphy index.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 drivers/net/wireless/ath9k/ath9k.h   |   15 ++++-
 drivers/net/wireless/ath9k/beacon.c  |   21 +++++---
 drivers/net/wireless/ath9k/main.c    |   65 ++++++++++++++++---------
 drivers/net/wireless/ath9k/rc.h      |    1 
 drivers/net/wireless/ath9k/recv.c    |   41 +++++++++++++++
 drivers/net/wireless/ath9k/virtual.c |   90 ++++++++++++++++++++++++++++++++++-
 drivers/net/wireless/ath9k/xmit.c    |   20 +++++--
 7 files changed, 212 insertions(+), 41 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/ath9k/ath9k.h	2009-03-03 18:30:34.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/ath9k.h	2009-03-03 18:30:47.000000000 +0200
@@ -373,10 +373,10 @@ int ath_tx_cleanup(struct ath_softc *sc)
 struct ath_txq *ath_test_get_txq(struct ath_softc *sc, struct sk_buff *skb);
 int ath_txq_update(struct ath_softc *sc, int qnum,
 		   struct ath9k_tx_queue_info *q);
-int ath_tx_start(struct ath_softc *sc, struct sk_buff *skb,
+int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 		 struct ath_tx_control *txctl);
 void ath_tx_tasklet(struct ath_softc *sc);
-void ath_tx_cabq(struct ath_softc *sc, struct sk_buff *skb);
+void ath_tx_cabq(struct ieee80211_hw *hw, struct sk_buff *skb);
 bool ath_tx_aggr_check(struct ath_softc *sc, struct ath_node *an, u8 tidno);
 int ath_tx_aggr_start(struct ath_softc *sc, struct ieee80211_sta *sta,
 		      u16 tid, u16 *ssn);
@@ -429,6 +429,7 @@ struct ath_beacon {
 	u32 ast_be_xmit;
 	u64 bc_tstamp;
 	struct ieee80211_vif *bslot[ATH_BCBUF];
+	struct ath_wiphy *bslot_aphy[ATH_BCBUF];
 	int slottime;
 	int slotupdate;
 	struct ath9k_tx_queue_info beacon_qi;
@@ -440,7 +441,7 @@ struct ath_beacon {
 void ath_beacon_tasklet(unsigned long data);
 void ath_beacon_config(struct ath_softc *sc, struct ieee80211_vif *vif);
 int ath_beaconq_setup(struct ath_hw *ah);
-int ath_beacon_alloc(struct ath_softc *sc, struct ieee80211_vif *vif);
+int ath_beacon_alloc(struct ath_wiphy *aphy, struct ieee80211_vif *vif);
 void ath_beacon_return(struct ath_softc *sc, struct ath_vif *avp);
 
 /*******/
@@ -554,7 +555,12 @@ struct ath_wiphy;
 struct ath_softc {
 	struct ieee80211_hw *hw;
 	struct device *dev;
+
+	spinlock_t wiphy_lock; /* spinlock to protect ath_wiphy data */
 	struct ath_wiphy *pri_wiphy;
+	struct ath_wiphy **sec_wiphy; /* secondary wiphys (virtual radios); may
+				       * have NULL entries */
+	int num_sec_wiphy; /* number of sec_wiphy pointers in the array */
 	struct tasklet_struct intr_tq;
 	struct tasklet_struct bcon_tasklet;
 	struct ath_hw *sc_ah;
@@ -638,6 +644,7 @@ int ath_attach(u16 devid, struct ath_sof
 void ath_detach(struct ath_softc *sc);
 const char *ath_mac_bb_name(u32 mac_bb_version);
 const char *ath_rf_name(u16 rf_version);
+void ath_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw);
 
 #ifdef CONFIG_PCI
 int ath_pci_init(void);
@@ -674,5 +681,7 @@ static inline void ath9k_ps_restore(stru
 
 
 void ath9k_set_bssid_mask(struct ieee80211_hw *hw);
+int ath9k_wiphy_add(struct ath_softc *sc);
+int ath9k_wiphy_del(struct ath_wiphy *aphy);
 
 #endif /* ATH9K_H */
--- wireless-testing.orig/drivers/net/wireless/ath9k/main.c	2009-03-03 18:30:34.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/main.c	2009-03-03 18:30:47.000000000 +0200
@@ -1305,6 +1305,7 @@ void ath_cleanup(struct ath_softc *sc)
 	ath_detach(sc);
 	free_irq(sc->irq, sc);
 	ath_bus_cleanup(sc);
+	kfree(sc->sec_wiphy);
 	ieee80211_free_hw(sc->hw);
 }
 
@@ -1322,6 +1323,14 @@ void ath_detach(struct ath_softc *sc)
 #endif
 	ath_deinit_leds(sc);
 
+	for (i = 0; i < sc->num_sec_wiphy; i++) {
+		struct ath_wiphy *aphy = sc->sec_wiphy[i];
+		if (aphy == NULL)
+			continue;
+		sc->sec_wiphy[i] = NULL;
+		ieee80211_unregister_hw(aphy->hw);
+		ieee80211_free_hw(aphy->hw);
+	}
 	ieee80211_unregister_hw(hw);
 	ath_rx_cleanup(sc);
 	ath_tx_cleanup(sc);
@@ -1355,6 +1364,7 @@ static int ath_init(u16 devid, struct at
 	if (ath9k_init_debug(sc) < 0)
 		printk(KERN_ERR "Unable to create debugfs files\n");
 
+	spin_lock_init(&sc->wiphy_lock);
 	spin_lock_init(&sc->sc_resetlock);
 	mutex_init(&sc->mutex);
 	tasklet_init(&sc->intr_tq, ath9k_tasklet, (unsigned long)sc);
@@ -1518,8 +1528,10 @@ static int ath_init(u16 devid, struct at
 	sc->beacon.slottime = ATH9K_SLOT_TIME_9;	/* default to short slot time */
 
 	/* initialize beacon slots */
-	for (i = 0; i < ARRAY_SIZE(sc->beacon.bslot); i++)
+	for (i = 0; i < ARRAY_SIZE(sc->beacon.bslot); i++) {
 		sc->beacon.bslot[i] = NULL;
+		sc->beacon.bslot_aphy[i] = NULL;
+	}
 
 	/* save MISC configurations */
 	sc->config.swBeaconProcess = 1;
@@ -1559,22 +1571,8 @@ bad:
 	return error;
 }
 
-int ath_attach(u16 devid, struct ath_softc *sc)
+void ath_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 {
-	struct ieee80211_hw *hw = sc->hw;
-	const struct ieee80211_regdomain *regd;
-	int error = 0, i;
-
-	DPRINTF(sc, ATH_DBG_CONFIG, "Attach ATH hw\n");
-
-	error = ath_init(devid, sc);
-	if (error != 0)
-		return error;
-
-	/* get mac address from hardware and set in mac80211 */
-
-	SET_IEEE80211_PERM_ADDR(hw, sc->sc_ah->macaddr);
-
 	hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
 		IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
 		IEEE80211_HW_SIGNAL_DBM |
@@ -1602,17 +1600,37 @@ int ath_attach(u16 devid, struct ath_sof
 
 	hw->rate_control_algorithm = "ath9k_rate_control";
 
+	hw->wiphy->bands[IEEE80211_BAND_2GHZ] =
+		&sc->sbands[IEEE80211_BAND_2GHZ];
+	if (test_bit(ATH9K_MODE_11A, sc->sc_ah->caps.wireless_modes))
+		hw->wiphy->bands[IEEE80211_BAND_5GHZ] =
+			&sc->sbands[IEEE80211_BAND_5GHZ];
+}
+
+int ath_attach(u16 devid, struct ath_softc *sc)
+{
+	struct ieee80211_hw *hw = sc->hw;
+	const struct ieee80211_regdomain *regd;
+	int error = 0, i;
+
+	DPRINTF(sc, ATH_DBG_CONFIG, "Attach ATH hw\n");
+
+	error = ath_init(devid, sc);
+	if (error != 0)
+		return error;
+
+	/* get mac address from hardware and set in mac80211 */
+
+	SET_IEEE80211_PERM_ADDR(hw, sc->sc_ah->macaddr);
+
+	ath_set_hw_capab(sc, hw);
+
 	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_HT) {
 		setup_ht_cap(sc, &sc->sbands[IEEE80211_BAND_2GHZ].ht_cap);
 		if (test_bit(ATH9K_MODE_11A, sc->sc_ah->caps.wireless_modes))
 			setup_ht_cap(sc, &sc->sbands[IEEE80211_BAND_5GHZ].ht_cap);
 	}
 
-	hw->wiphy->bands[IEEE80211_BAND_2GHZ] =	&sc->sbands[IEEE80211_BAND_2GHZ];
-	if (test_bit(ATH9K_MODE_11A, sc->sc_ah->caps.wireless_modes))
-		hw->wiphy->bands[IEEE80211_BAND_5GHZ] =
-			&sc->sbands[IEEE80211_BAND_5GHZ];
-
 	/* initialize tx/rx engine */
 	error = ath_tx_init(sc, ATH_TXBUF);
 	if (error != 0)
@@ -2065,7 +2083,7 @@ static int ath9k_tx(struct ieee80211_hw 
 
 	DPRINTF(sc, ATH_DBG_XMIT, "transmitting packet, skb: %p\n", skb);
 
-	if (ath_tx_start(sc, skb, &txctl) != 0) {
+	if (ath_tx_start(hw, skb, &txctl) != 0) {
 		DPRINTF(sc, ATH_DBG_XMIT, "TX failed\n");
 		goto exit;
 	}
@@ -2245,6 +2263,7 @@ static void ath9k_remove_interface(struc
 			printk(KERN_DEBUG "%s: vif had allocated beacon "
 			       "slot\n", __func__);
 			sc->beacon.bslot[i] = NULL;
+			sc->beacon.bslot_aphy[i] = NULL;
 		}
 	}
 
@@ -2386,7 +2405,7 @@ static int ath9k_config_interface(struct
 			 */
 			ath9k_hw_stoptxdma(sc->sc_ah, sc->beacon.beaconq);
 
-			error = ath_beacon_alloc(sc, vif);
+			error = ath_beacon_alloc(aphy, vif);
 			if (error != 0) {
 				mutex_unlock(&sc->mutex);
 				return error;
--- wireless-testing.orig/drivers/net/wireless/ath9k/recv.c	2009-03-03 18:30:34.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/recv.c	2009-03-03 18:30:47.000000000 +0200
@@ -19,7 +19,22 @@
 static struct ieee80211_hw * ath_get_virt_hw(struct ath_softc *sc,
 					     struct ieee80211_hdr *hdr)
 {
-	return sc->pri_wiphy->hw;
+	struct ieee80211_hw *hw = sc->pri_wiphy->hw;
+	int i;
+
+	spin_lock_bh(&sc->wiphy_lock);
+	for (i = 0; i < sc->num_sec_wiphy; i++) {
+		struct ath_wiphy *aphy = sc->sec_wiphy[i];
+		if (aphy == NULL)
+			continue;
+		if (compare_ether_addr(hdr->addr1, aphy->hw->wiphy->perm_addr)
+		    == 0) {
+			hw = aphy->hw;
+			break;
+		}
+	}
+	spin_unlock_bh(&sc->wiphy_lock);
+	return hw;
 }
 
 /*
@@ -611,7 +626,29 @@ int ath_rx_tasklet(struct ath_softc *sc,
 		}
 
 		/* Send the frame to mac80211 */
-		__ieee80211_rx(ath_get_virt_hw(sc, hdr), skb, &rx_status);
+		if (hdr->addr1[5] & 0x01) {
+			int i;
+			/*
+			 * Deliver broadcast/multicast frames to all suitable
+			 * virtual wiphys.
+			 */
+			/* TODO: filter based on channel configuration */
+			for (i = 0; i < sc->num_sec_wiphy; i++) {
+				struct ath_wiphy *aphy = sc->sec_wiphy[i];
+				struct sk_buff *nskb;
+				if (aphy == NULL)
+					continue;
+				nskb = skb_copy(skb, GFP_ATOMIC);
+				if (nskb)
+					__ieee80211_rx(aphy->hw, nskb,
+						       &rx_status);
+			}
+			__ieee80211_rx(sc->hw, skb, &rx_status);
+		} else {
+			/* Deliver unicast frames based on receiver address */
+			__ieee80211_rx(ath_get_virt_hw(sc, hdr), skb,
+				       &rx_status);
+		}
 
 		/* We will now give hardware our shiny new allocated skb */
 		bf->bf_mpdu = requeue_skb;
--- wireless-testing.orig/drivers/net/wireless/ath9k/beacon.c	2009-03-03 18:29:02.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/beacon.c	2009-03-03 18:30:47.000000000 +0200
@@ -113,9 +113,11 @@ static void ath_beacon_setup(struct ath_
 				     series, 4, 0);
 }
 
-static struct ath_buf *ath_beacon_generate(struct ath_softc *sc,
+static struct ath_buf *ath_beacon_generate(struct ieee80211_hw *hw,
 					   struct ieee80211_vif *vif)
 {
+	struct ath_wiphy *aphy = hw->priv;
+	struct ath_softc *sc = aphy->sc;
 	struct ath_buf *bf;
 	struct ath_vif *avp;
 	struct sk_buff *skb;
@@ -144,7 +146,7 @@ static struct ath_buf *ath_beacon_genera
 
 	/* Get a new beacon from mac80211 */
 
-	skb = ieee80211_beacon_get(sc->hw, vif);
+	skb = ieee80211_beacon_get(hw, vif);
 	bf->bf_mpdu = skb;
 	if (skb == NULL)
 		return NULL;
@@ -171,7 +173,7 @@ static struct ath_buf *ath_beacon_genera
 		return NULL;
 	}
 
-	skb = ieee80211_get_buffered_bc(sc->hw, vif);
+	skb = ieee80211_get_buffered_bc(hw, vif);
 
 	/*
 	 * if the CABQ traffic from previous DTIM is pending and the current
@@ -196,8 +198,8 @@ static struct ath_buf *ath_beacon_genera
 	ath_beacon_setup(sc, avp, bf);
 
 	while (skb) {
-		ath_tx_cabq(sc, skb);
-		skb = ieee80211_get_buffered_bc(sc->hw, vif);
+		ath_tx_cabq(hw, skb);
+		skb = ieee80211_get_buffered_bc(hw, vif);
 	}
 
 	return bf;
@@ -244,8 +246,9 @@ int ath_beaconq_setup(struct ath_hw *ah)
 	return ath9k_hw_setuptxqueue(ah, ATH9K_TX_QUEUE_BEACON, &qi);
 }
 
-int ath_beacon_alloc(struct ath_softc *sc, struct ieee80211_vif *vif)
+int ath_beacon_alloc(struct ath_wiphy *aphy, struct ieee80211_vif *vif)
 {
+	struct ath_softc *sc = aphy->sc;
 	struct ath_vif *avp;
 	struct ieee80211_hdr *hdr;
 	struct ath_buf *bf;
@@ -286,6 +289,7 @@ int ath_beacon_alloc(struct ath_softc *s
 				}
 			BUG_ON(sc->beacon.bslot[avp->av_bslot] != NULL);
 			sc->beacon.bslot[avp->av_bslot] = vif;
+			sc->beacon.bslot_aphy[avp->av_bslot] = aphy;
 			sc->nbcnvifs++;
 		}
 	}
@@ -368,6 +372,7 @@ void ath_beacon_return(struct ath_softc 
 
 		if (avp->av_bslot != -1) {
 			sc->beacon.bslot[avp->av_bslot] = NULL;
+			sc->beacon.bslot_aphy[avp->av_bslot] = NULL;
 			sc->nbcnvifs--;
 		}
 
@@ -391,6 +396,7 @@ void ath_beacon_tasklet(unsigned long da
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_buf *bf = NULL;
 	struct ieee80211_vif *vif;
+	struct ath_wiphy *aphy;
 	int slot;
 	u32 bfaddr, bc = 0, tsftu;
 	u64 tsf;
@@ -439,6 +445,7 @@ void ath_beacon_tasklet(unsigned long da
 	tsftu = TSF_TO_TU(tsf>>32, tsf);
 	slot = ((tsftu % intval) * ATH_BCBUF) / intval;
 	vif = sc->beacon.bslot[(slot + 1) % ATH_BCBUF];
+	aphy = sc->beacon.bslot_aphy[(slot + 1) % ATH_BCBUF];
 
 	DPRINTF(sc, ATH_DBG_BEACON,
 		"slot %d [tsf %llu tsftu %u intval %u] vif %p\n",
@@ -446,7 +453,7 @@ void ath_beacon_tasklet(unsigned long da
 
 	bfaddr = 0;
 	if (vif) {
-		bf = ath_beacon_generate(sc, vif);
+		bf = ath_beacon_generate(aphy->hw, vif);
 		if (bf != NULL) {
 			bfaddr = bf->bf_daddr;
 			bc = 1;
--- wireless-testing.orig/drivers/net/wireless/ath9k/rc.h	2009-02-28 00:24:24.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/rc.h	2009-03-03 18:30:47.000000000 +0200
@@ -195,6 +195,7 @@ struct ath_rate_priv {
 };
 
 struct ath_tx_info_priv {
+	struct ath_wiphy *aphy;
 	struct ath_tx_status tx;
 	int n_frames;
 	int n_bad_frames;
--- wireless-testing.orig/drivers/net/wireless/ath9k/xmit.c	2009-02-27 10:53:01.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/xmit.c	2009-03-03 18:30:47.000000000 +0200
@@ -1497,10 +1497,12 @@ static void ath_buf_set_rate(struct ath_
 		ath9k_hw_set11n_burstduration(sc->sc_ah, bf->bf_desc, 8192);
 }
 
-static int ath_tx_setup_buffer(struct ath_softc *sc, struct ath_buf *bf,
+static int ath_tx_setup_buffer(struct ieee80211_hw *hw, struct ath_buf *bf,
 				struct sk_buff *skb,
 				struct ath_tx_control *txctl)
 {
+	struct ath_wiphy *aphy = hw->priv;
+	struct ath_softc *sc = aphy->sc;
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct ath_tx_info_priv *tx_info_priv;
@@ -1511,6 +1513,7 @@ static int ath_tx_setup_buffer(struct at
 	if (unlikely(!tx_info_priv))
 		return -ENOMEM;
 	tx_info->rate_driver_data[0] = tx_info_priv;
+	tx_info_priv->aphy = aphy;
 	hdrlen = ieee80211_get_hdrlen_from_skb(skb);
 	fc = hdr->frame_control;
 
@@ -1614,9 +1617,11 @@ static void ath_tx_start_dma(struct ath_
 }
 
 /* Upon failure caller should free skb */
-int ath_tx_start(struct ath_softc *sc, struct sk_buff *skb,
+int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 		 struct ath_tx_control *txctl)
 {
+	struct ath_wiphy *aphy = hw->priv;
+	struct ath_softc *sc = aphy->sc;
 	struct ath_buf *bf;
 	int r;
 
@@ -1626,7 +1631,7 @@ int ath_tx_start(struct ath_softc *sc, s
 		return -1;
 	}
 
-	r = ath_tx_setup_buffer(sc, bf, skb, txctl);
+	r = ath_tx_setup_buffer(hw, bf, skb, txctl);
 	if (unlikely(r)) {
 		struct ath_txq *txq = txctl->txq;
 
@@ -1656,8 +1661,10 @@ int ath_tx_start(struct ath_softc *sc, s
 	return 0;
 }
 
-void ath_tx_cabq(struct ath_softc *sc, struct sk_buff *skb)
+void ath_tx_cabq(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
+	struct ath_wiphy *aphy = hw->priv;
+	struct ath_softc *sc = aphy->sc;
 	int hdrlen, padsize;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ath_tx_control txctl;
@@ -1694,7 +1701,7 @@ void ath_tx_cabq(struct ath_softc *sc, s
 
 	DPRINTF(sc, ATH_DBG_XMIT, "transmitting CABQ packet, skb: %p\n", skb);
 
-	if (ath_tx_start(sc, skb, &txctl) != 0) {
+	if (ath_tx_start(hw, skb, &txctl) != 0) {
 		DPRINTF(sc, ATH_DBG_XMIT, "CABQ TX failed\n");
 		goto exit;
 	}
@@ -1718,6 +1725,9 @@ static void ath_tx_complete(struct ath_s
 
 	DPRINTF(sc, ATH_DBG_XMIT, "TX complete: skb: %p\n", skb);
 
+	if (tx_info_priv)
+		hw = tx_info_priv->aphy->hw;
+
 	if (tx_info->flags & IEEE80211_TX_CTL_NO_ACK ||
 	    tx_info->flags & IEEE80211_TX_STAT_TX_FILTERED) {
 		kfree(tx_info_priv);
--- wireless-testing.orig/drivers/net/wireless/ath9k/virtual.c	2009-03-03 18:30:34.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/virtual.c	2009-03-03 18:30:47.000000000 +0200
@@ -57,8 +57,16 @@ void ath9k_set_bssid_mask(struct ieee802
 		iter_data.count = 0;
 
 	/* Get list of all active MAC addresses */
-	ieee80211_iterate_active_interfaces_atomic(hw, ath9k_vif_iter,
+	spin_lock_bh(&sc->wiphy_lock);
+	ieee80211_iterate_active_interfaces_atomic(sc->hw, ath9k_vif_iter,
 						   &iter_data);
+	for (i = 0; i < sc->num_sec_wiphy; i++) {
+		if (sc->sec_wiphy[i] == NULL)
+			continue;
+		ieee80211_iterate_active_interfaces_atomic(
+			sc->sec_wiphy[i]->hw, ath9k_vif_iter, &iter_data);
+	}
+	spin_unlock_bh(&sc->wiphy_lock);
 
 	/* Generate an address mask to cover all active addresses */
 	memset(mask, 0, ETH_ALEN);
@@ -87,3 +95,83 @@ void ath9k_set_bssid_mask(struct ieee802
 
 	ath9k_hw_setbssidmask(sc);
 }
+
+int ath9k_wiphy_add(struct ath_softc *sc)
+{
+	int i, error;
+	struct ath_wiphy *aphy;
+	struct ieee80211_hw *hw;
+	u8 addr[ETH_ALEN];
+
+	hw = ieee80211_alloc_hw(sizeof(struct ath_wiphy), &ath9k_ops);
+	if (hw == NULL)
+		return -ENOMEM;
+
+	spin_lock_bh(&sc->wiphy_lock);
+	for (i = 0; i < sc->num_sec_wiphy; i++) {
+		if (sc->sec_wiphy[i] == NULL)
+			break;
+	}
+
+	if (i == sc->num_sec_wiphy) {
+		/* No empty slot available; increase array length */
+		struct ath_wiphy **n;
+		n = krealloc(sc->sec_wiphy,
+			     (sc->num_sec_wiphy + 1) *
+			     sizeof(struct ath_wiphy *),
+			     GFP_ATOMIC);
+		if (n == NULL) {
+			spin_unlock_bh(&sc->wiphy_lock);
+			ieee80211_free_hw(hw);
+			return -ENOMEM;
+		}
+		n[i] = NULL;
+		sc->sec_wiphy = n;
+		sc->num_sec_wiphy++;
+	}
+
+	SET_IEEE80211_DEV(hw, sc->dev);
+
+	aphy = hw->priv;
+	aphy->sc = sc;
+	aphy->hw = hw;
+	sc->sec_wiphy[i] = aphy;
+	spin_unlock_bh(&sc->wiphy_lock);
+
+	memcpy(addr, sc->sc_ah->macaddr, ETH_ALEN);
+	addr[0] |= 0x02; /* Locally managed address */
+	/*
+	 * XOR virtual wiphy index into the least significant bits to generate
+	 * a different MAC address for each virtual wiphy.
+	 */
+	addr[5] ^= i & 0xff;
+	addr[4] ^= (i & 0xff00) >> 8;
+	addr[3] ^= (i & 0xff0000) >> 16;
+
+	SET_IEEE80211_PERM_ADDR(hw, addr);
+
+	ath_set_hw_capab(sc, hw);
+
+	error = ieee80211_register_hw(hw);
+
+	return error;
+}
+
+int ath9k_wiphy_del(struct ath_wiphy *aphy)
+{
+	struct ath_softc *sc = aphy->sc;
+	int i;
+
+	spin_lock_bh(&sc->wiphy_lock);
+	for (i = 0; i < sc->num_sec_wiphy; i++) {
+		if (aphy == sc->sec_wiphy[i]) {
+			sc->sec_wiphy[i] = NULL;
+			spin_unlock_bh(&sc->wiphy_lock);
+			ieee80211_unregister_hw(aphy->hw);
+			ieee80211_free_hw(aphy->hw);
+			return 0;
+		}
+	}
+	spin_unlock_bh(&sc->wiphy_lock);
+	return -ENOENT;
+}

-- 

-- 
Jouni Malinen                                            PGP id EFC895FA
