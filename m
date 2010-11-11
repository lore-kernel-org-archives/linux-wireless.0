Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:56601 "EHLO mail.neratec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407Ab0KKO5p (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Nov 2010 09:57:45 -0500
Date: Thu, 11 Nov 2010 15:57:41 +0100 (CET)
From: Wojciech Dubowik <dubowoj@neratec.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Message-ID: <11581781.1031289487462262.JavaMail.wlan@CHBU500181>
In-Reply-To: <7180198.951289487321198.JavaMail.wlan@CHBU500181>
Subject: [PATCH 2/9] ath5k: AHB port. Use ath_bus_opts structure.
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In main ath folder ath_bus_opts is used to specify AHB/PCI/USB specific functions. Use it for ath5k since it's needed for AHB support.
PCI initialization has been split to bus specific and common which have been moved to ath5k_attach.

Signed-off-by: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
---
 drivers/net/wireless/ath/ath5k/ath5k.h |    5 +
 drivers/net/wireless/ath/ath5k/base.c  |  343 +++++++++++++++++++-------------
 drivers/net/wireless/ath/ath5k/base.h  |    1 +
 3 files changed, 206 insertions(+), 143 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index 308b79e..09c3ede 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -1303,6 +1303,11 @@ static inline void ath5k_hw_reg_write(struct ath5k_hw *ah, u32 val, u16 reg)
 	iowrite32(val, ah->ah_iobase + reg);
 }
 
+static inline void ath5k_read_cachesize(struct ath_common *common, int *csz)
+{
+	common->bus_ops->read_cachesize(common, csz);
+}
+
 static inline u32 ath5k_hw_bitswap(u32 val, unsigned int bits)
 {
 	u32 retval = 0, bit, i;
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 7286b5c..fbe82be 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -80,6 +80,7 @@ MODULE_SUPPORTED_DEVICE("Atheros 5xxx WLAN cards");
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_VERSION("0.6.0 (EXPERIMENTAL)");
 
+static int ath5k_init(struct ieee80211_hw *hw);
 static int ath5k_reset(struct ath5k_softc *sc, struct ieee80211_channel *chan);
 static int ath5k_beacon_update(struct ieee80211_hw *hw,
 		struct ieee80211_vif *vif);
@@ -191,6 +192,32 @@ static const struct ieee80211_rate ath5k_rates[] = {
 	/* XR missing */
 };
 
+/* return bus cachesize in 4B word units */
+static void ath5k_pci_read_cachesize(struct ath_common *common, int *csz)
+{
+	struct ath5k_softc *sc = (struct ath5k_softc *) common->priv;
+	u8 u8tmp;
+
+	pci_read_config_byte(sc->pdev, PCI_CACHE_LINE_SIZE, &u8tmp);
+	*csz = (int)u8tmp;
+
+	/*
+	 * This check was put in to avoid "unplesant" consequences if
+	 * the bootrom has not fully initialized all PCI devices.
+	 * Sometimes the cache line size register is not set
+	 */
+
+	if (*csz == 0)
+		*csz = L1_CACHE_BYTES >> 2;   /* Use the default size */
+}
+
+/* Common ath_bus_opts structure */
+static const struct ath_bus_ops ath_pci_bus_ops = {
+	.ath_bus_type = ATH_PCI,
+	.read_cachesize = ath5k_pci_read_cachesize,
+};
+
+
 static inline void ath5k_txbuf_free_skb(struct ath5k_softc *sc,
 				struct ath5k_buf *bf)
 {
@@ -2179,7 +2206,7 @@ ath5k_intr_calibration_poll(struct ath5k_hw *ah)
 	 * AR5K_REG_ENABLE_BITS(ah, AR5K_CR, AR5K_CR_SWI); */
 }
 
-static irqreturn_t
+irqreturn_t
 ath5k_intr(int irq, void *dev_id)
 {
 	struct ath5k_softc *sc = dev_id;
@@ -2365,6 +2392,159 @@ ath5k_tx_complete_poll_work(struct work_struct *work)
 * Initialization routines *
 \*************************/
 
+int __devinit
+ath5k_attach(struct ath5k_softc *sc, const struct ath_bus_ops *bus_ops)
+{
+	struct ieee80211_hw *hw = sc->hw;
+	struct ath_common *common;
+	int ret;
+	int csz;
+
+	/* Initialize driver private data */
+	SET_IEEE80211_DEV(hw, sc->dev);
+	hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
+		    IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
+		    IEEE80211_HW_SIGNAL_DBM;
+
+	hw->wiphy->interface_modes =
+		BIT(NL80211_IFTYPE_AP) |
+		BIT(NL80211_IFTYPE_STATION) |
+		BIT(NL80211_IFTYPE_ADHOC) |
+		BIT(NL80211_IFTYPE_MESH_POINT);
+
+	hw->extra_tx_headroom = 2;
+	hw->channel_change_time = 5000;
+
+	/*
+	 * Mark the device as detached to avoid processing
+	 * interrupts until setup is complete.
+	 */
+	__set_bit(ATH_STAT_INVALID, sc->status);
+
+	sc->opmode = NL80211_IFTYPE_STATION;
+	sc->bintval = 1000;
+	mutex_init(&sc->lock);
+	spin_lock_init(&sc->rxbuflock);
+	spin_lock_init(&sc->txbuflock);
+	spin_lock_init(&sc->block);
+
+
+	/* Setup interrupt handler */
+	ret = request_irq(sc->irq, ath5k_intr, IRQF_SHARED, "ath", sc);
+	if (ret) {
+		ATH5K_ERR(sc, "request_irq failed\n");
+		goto err;
+	}
+
+	/* If we passed the test, malloc an ath5k_hw struct */
+	sc->ah = kzalloc(sizeof(struct ath5k_hw), GFP_KERNEL);
+	if (!sc->ah) {
+		ret = -ENOMEM;
+		ATH5K_ERR(sc, "out of memory\n");
+		goto err_irq;
+	}
+
+	sc->ah->ah_sc = sc;
+	sc->ah->ah_iobase = sc->iobase;
+	common = ath5k_hw_common(sc->ah);
+	common->ops = &ath5k_common_ops;
+	common->bus_ops = bus_ops;
+	common->ah = sc->ah;
+	common->hw = hw;
+	common->priv = sc;
+
+	/*
+	 * Cache line size is used to size and align various
+	 * structures used to communicate with the hardware.
+	 */
+	ath5k_read_cachesize(common, &csz);
+	common->cachelsz = csz << 2; /* convert to bytes */
+
+	spin_lock_init(&common->cc_lock);
+
+	/* Initialize device */
+	ret = ath5k_hw_attach(sc);
+	if (ret) {
+		goto err_free_ah;
+	}
+
+	/* set up multi-rate retry capabilities */
+	if (sc->ah->ah_version == AR5K_AR5212) {
+		hw->max_rates = 4;
+		hw->max_rate_tries = 11;
+	}
+
+	hw->vif_data_size = sizeof(struct ath5k_vif);
+
+	/* Finish private driver data initialization */
+	ret = ath5k_init(hw);
+	if (ret)
+		goto err_ah;
+
+	ATH5K_INFO(sc, "Atheros AR%s chip found (MAC: 0x%x, PHY: 0x%x)\n",
+			ath5k_chip_name(AR5K_VERSION_MAC, sc->ah->ah_mac_srev),
+					sc->ah->ah_mac_srev,
+					sc->ah->ah_phy_revision);
+
+	if (!sc->ah->ah_single_chip) {
+		/* Single chip radio (!RF5111) */
+		if (sc->ah->ah_radio_5ghz_revision &&
+			!sc->ah->ah_radio_2ghz_revision) {
+			/* No 5GHz support -> report 2GHz radio */
+			if (!test_bit(AR5K_MODE_11A,
+				sc->ah->ah_capabilities.cap_mode)) {
+				ATH5K_INFO(sc, "RF%s 2GHz radio found (0x%x)\n",
+					ath5k_chip_name(AR5K_VERSION_RAD,
+						sc->ah->ah_radio_5ghz_revision),
+						sc->ah->ah_radio_5ghz_revision);
+			/* No 2GHz support (5110 and some
+			 * 5Ghz only cards) -> report 5Ghz radio */
+			} else if (!test_bit(AR5K_MODE_11B,
+				sc->ah->ah_capabilities.cap_mode)) {
+				ATH5K_INFO(sc, "RF%s 5GHz radio found (0x%x)\n",
+					ath5k_chip_name(AR5K_VERSION_RAD,
+						sc->ah->ah_radio_5ghz_revision),
+						sc->ah->ah_radio_5ghz_revision);
+			/* Multiband radio */
+			} else {
+				ATH5K_INFO(sc, "RF%s multiband radio found"
+					" (0x%x)\n",
+					ath5k_chip_name(AR5K_VERSION_RAD,
+						sc->ah->ah_radio_5ghz_revision),
+						sc->ah->ah_radio_5ghz_revision);
+			}
+		}
+		/* Multi chip radio (RF5111 - RF2111) ->
+		 * report both 2GHz/5GHz radios */
+		else if (sc->ah->ah_radio_5ghz_revision &&
+				sc->ah->ah_radio_2ghz_revision){
+			ATH5K_INFO(sc, "RF%s 5GHz radio found (0x%x)\n",
+				ath5k_chip_name(AR5K_VERSION_RAD,
+					sc->ah->ah_radio_5ghz_revision),
+					sc->ah->ah_radio_5ghz_revision);
+			ATH5K_INFO(sc, "RF%s 2GHz radio found (0x%x)\n",
+				ath5k_chip_name(AR5K_VERSION_RAD,
+					sc->ah->ah_radio_2ghz_revision),
+					sc->ah->ah_radio_2ghz_revision);
+		}
+	}
+
+	ath5k_debug_init_device(sc);
+
+	/* ready to process interrupts */
+	__clear_bit(ATH_STAT_INVALID, sc->status);
+
+	return 0;
+err_ah:
+	ath5k_hw_detach(sc->ah);
+err_free_ah:
+	kfree(sc->ah);
+err_irq:
+	free_irq(sc->irq, sc);
+err:
+	return ret;
+}
+
 static int
 ath5k_stop_locked(struct ath5k_softc *sc)
 {
@@ -2405,7 +2585,7 @@ ath5k_stop_locked(struct ath5k_softc *sc)
 }
 
 static int
-ath5k_init(struct ath5k_softc *sc)
+ath5k_init_hw(struct ath5k_softc *sc)
 {
 	struct ath5k_hw *ah = sc->ah;
 	struct ath_common *common = ath5k_hw_common(ah);
@@ -2599,8 +2779,9 @@ static void ath5k_reset_work(struct work_struct *work)
 }
 
 static int
-ath5k_attach(struct pci_dev *pdev, struct ieee80211_hw *hw)
+ath5k_init(struct ieee80211_hw *hw)
 {
+
 	struct ath5k_softc *sc = hw->priv;
 	struct ath5k_hw *ah = sc->ah;
 	struct ath_regulatory *regulatory = ath5k_hw_regulatory(ah);
@@ -2608,7 +2789,6 @@ ath5k_attach(struct pci_dev *pdev, struct ieee80211_hw *hw)
 	u8 mac[ETH_ALEN] = {};
 	int ret;
 
-	ATH5K_DBG(sc, ATH5K_DEBUG_ANY, "devid 0x%x\n", pdev->device);
 
 	/*
 	 * Check if the MAC has multi-rate retry support.
@@ -2750,9 +2930,9 @@ err:
 }
 
 static void
-ath5k_detach(struct pci_dev *pdev, struct ieee80211_hw *hw)
+ath5k_detach(struct ath5k_softc *sc)
 {
-	struct ath5k_softc *sc = hw->priv;
+	struct ieee80211_hw *hw = sc->hw;
 
 	/*
 	 * NB: the order of these is important:
@@ -2767,6 +2947,7 @@ ath5k_detach(struct pci_dev *pdev, struct ieee80211_hw *hw)
 	 * XXX: ??? detach ath5k_hw ???
 	 * Other than that, it's straightforward...
 	 */
+	ath5k_debug_finish_device(sc);
 	ieee80211_unregister_hw(hw);
 	ath5k_desc_free(sc);
 	ath5k_txq_release(sc);
@@ -2779,6 +2960,8 @@ ath5k_detach(struct pci_dev *pdev, struct ieee80211_hw *hw)
 	 * returns because we'll get called back to reclaim node
 	 * state and potentially want to use them.
 	 */
+	ath5k_hw_detach(sc->ah);
+	free_irq(sc->irq, sc);
 }
 
 /********************\
@@ -2801,7 +2984,7 @@ ath5k_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 
 static int ath5k_start(struct ieee80211_hw *hw)
 {
-	return ath5k_init(hw->priv);
+	return ath5k_init_hw(hw->priv);
 }
 
 static void ath5k_stop(struct ieee80211_hw *hw)
@@ -3416,7 +3599,7 @@ static int ath5k_conf_tx(struct ieee80211_hw *hw, u16 queue,
 	return ret;
 }
 
-static const struct ieee80211_ops ath5k_hw_ops = {
+const struct ieee80211_ops ath5k_hw_ops = {
 	.tx 		= ath5k_tx,
 	.start 		= ath5k_start,
 	.stop 		= ath5k_stop,
@@ -3448,7 +3631,6 @@ ath5k_pci_probe(struct pci_dev *pdev,
 {
 	void __iomem *mem;
 	struct ath5k_softc *sc;
-	struct ath_common *common;
 	struct ieee80211_hw *hw;
 	int ret;
 	u8 csz;
@@ -3544,146 +3726,24 @@ ath5k_pci_probe(struct pci_dev *pdev,
 
 	dev_info(&pdev->dev, "registered as '%s'\n", wiphy_name(hw->wiphy));
 
-	/* Initialize driver private data */
-	SET_IEEE80211_DEV(hw, &pdev->dev);
-	hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
-		    IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
-		    IEEE80211_HW_SIGNAL_DBM;
-
-	hw->wiphy->interface_modes =
-		BIT(NL80211_IFTYPE_AP) |
-		BIT(NL80211_IFTYPE_STATION) |
-		BIT(NL80211_IFTYPE_ADHOC) |
-		BIT(NL80211_IFTYPE_MESH_POINT);
-
-	hw->extra_tx_headroom = 2;
-	hw->channel_change_time = 5000;
 	sc = hw->priv;
 	sc->hw = hw;
 	sc->pdev = pdev;
 	sc->dev = &pdev->dev;
 	sc->irq = pdev->irq;
-
-	/*
-	 * Mark the device as detached to avoid processing
-	 * interrupts until setup is complete.
-	 */
-	__set_bit(ATH_STAT_INVALID, sc->status);
-
+	sc->devid = id->device;
 	sc->iobase = mem; /* So we can unmap it on detach */
-	sc->opmode = NL80211_IFTYPE_STATION;
-	sc->bintval = 1000;
-	mutex_init(&sc->lock);
-	spin_lock_init(&sc->rxbuflock);
-	spin_lock_init(&sc->txbuflock);
-	spin_lock_init(&sc->block);
 
-	/* Set private data */
-	pci_set_drvdata(pdev, sc);
-
-	/* Setup interrupt handler */
-	ret = request_irq(pdev->irq, ath5k_intr, IRQF_SHARED, "ath", sc);
+	/* Initialize */
+	ret = ath5k_attach(sc, &ath_pci_bus_ops);
 	if (ret) {
-		ATH5K_ERR(sc, "request_irq failed\n");
 		goto err_free;
 	}
 
-	/* If we passed the test, malloc an ath5k_hw struct */
-	sc->ah = kzalloc(sizeof(struct ath5k_hw), GFP_KERNEL);
-	if (!sc->ah) {
-		ret = -ENOMEM;
-		ATH5K_ERR(sc, "out of memory\n");
-		goto err_irq;
-	}
-
-	sc->ah->ah_sc = sc;
-	sc->ah->ah_iobase = sc->iobase;
-	common = ath5k_hw_common(sc->ah);
-	common->ops = &ath5k_common_ops;
-	common->ah = sc->ah;
-	common->hw = hw;
-	common->cachelsz = csz << 2; /* convert to bytes */
-	spin_lock_init(&common->cc_lock);
-
-	/* Initialize device */
-	ret = ath5k_hw_attach(sc);
-	if (ret) {
-		goto err_free_ah;
-	}
-
-	/* set up multi-rate retry capabilities */
-	if (sc->ah->ah_version == AR5K_AR5212) {
-		hw->max_rates = 4;
-		hw->max_rate_tries = 11;
-	}
-
-	hw->vif_data_size = sizeof(struct ath5k_vif);
-
-	/* Finish private driver data initialization */
-	ret = ath5k_attach(pdev, hw);
-	if (ret)
-		goto err_ah;
-
-	ATH5K_INFO(sc, "Atheros AR%s chip found (MAC: 0x%x, PHY: 0x%x)\n",
-			ath5k_chip_name(AR5K_VERSION_MAC, sc->ah->ah_mac_srev),
-					sc->ah->ah_mac_srev,
-					sc->ah->ah_phy_revision);
-
-	if (!sc->ah->ah_single_chip) {
-		/* Single chip radio (!RF5111) */
-		if (sc->ah->ah_radio_5ghz_revision &&
-			!sc->ah->ah_radio_2ghz_revision) {
-			/* No 5GHz support -> report 2GHz radio */
-			if (!test_bit(AR5K_MODE_11A,
-				sc->ah->ah_capabilities.cap_mode)) {
-				ATH5K_INFO(sc, "RF%s 2GHz radio found (0x%x)\n",
-					ath5k_chip_name(AR5K_VERSION_RAD,
-						sc->ah->ah_radio_5ghz_revision),
-						sc->ah->ah_radio_5ghz_revision);
-			/* No 2GHz support (5110 and some
-			 * 5Ghz only cards) -> report 5Ghz radio */
-			} else if (!test_bit(AR5K_MODE_11B,
-				sc->ah->ah_capabilities.cap_mode)) {
-				ATH5K_INFO(sc, "RF%s 5GHz radio found (0x%x)\n",
-					ath5k_chip_name(AR5K_VERSION_RAD,
-						sc->ah->ah_radio_5ghz_revision),
-						sc->ah->ah_radio_5ghz_revision);
-			/* Multiband radio */
-			} else {
-				ATH5K_INFO(sc, "RF%s multiband radio found"
-					" (0x%x)\n",
-					ath5k_chip_name(AR5K_VERSION_RAD,
-						sc->ah->ah_radio_5ghz_revision),
-						sc->ah->ah_radio_5ghz_revision);
-			}
-		}
-		/* Multi chip radio (RF5111 - RF2111) ->
-		 * report both 2GHz/5GHz radios */
-		else if (sc->ah->ah_radio_5ghz_revision &&
-				sc->ah->ah_radio_2ghz_revision){
-			ATH5K_INFO(sc, "RF%s 5GHz radio found (0x%x)\n",
-				ath5k_chip_name(AR5K_VERSION_RAD,
-					sc->ah->ah_radio_5ghz_revision),
-					sc->ah->ah_radio_5ghz_revision);
-			ATH5K_INFO(sc, "RF%s 2GHz radio found (0x%x)\n",
-				ath5k_chip_name(AR5K_VERSION_RAD,
-					sc->ah->ah_radio_2ghz_revision),
-					sc->ah->ah_radio_2ghz_revision);
-		}
-	}
-
-	ath5k_debug_init_device(sc);
-
-	/* ready to process interrupts */
-	__clear_bit(ATH_STAT_INVALID, sc->status);
+	/* Set private data */
+	pci_set_drvdata(pdev, hw);
 
 	return 0;
-err_ah:
-	ath5k_hw_detach(sc->ah);
-err_free_ah:
-	kfree(sc->ah);
-err_irq:
-	free_irq(pdev->irq, sc);
 err_free:
 	ieee80211_free_hw(hw);
 err_map:
@@ -3699,17 +3759,14 @@ err:
 static void __devexit
 ath5k_pci_remove(struct pci_dev *pdev)
 {
-	struct ath5k_softc *sc = pci_get_drvdata(pdev);
+	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
+	struct ath5k_softc *sc = hw->priv;
 
-	ath5k_debug_finish_device(sc);
-	ath5k_detach(pdev, sc->hw);
-	ath5k_hw_detach(sc->ah);
-	kfree(sc->ah);
-	free_irq(pdev->irq, sc);
+	ath5k_detach(sc);
 	pci_iounmap(pdev, sc->iobase);
 	pci_release_region(pdev, 0);
 	pci_disable_device(pdev);
-	ieee80211_free_hw(sc->hw);
+	ieee80211_free_hw(hw);
 }
 
 #ifdef CONFIG_PM_SLEEP
diff --git a/drivers/net/wireless/ath/ath5k/base.h b/drivers/net/wireless/ath/ath5k/base.h
index 0362f8e..aa6c32a 100644
--- a/drivers/net/wireless/ath/ath5k/base.h
+++ b/drivers/net/wireless/ath/ath5k/base.h
@@ -172,6 +172,7 @@ struct ath5k_softc {
 	struct pci_dev		*pdev;
 	struct device		*dev;		/* for dma mapping */
 	int irq;
+	u16 devid;
 	void __iomem		*iobase;	/* address of the device */
 	struct mutex		lock;		/* dev-level lock */
 	struct ieee80211_hw	*hw;		/* IEEE 802.11 common */
-- 
1.7.1
