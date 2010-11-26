Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:33329 "EHLO mail.neratec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753759Ab0KZJ4f (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Nov 2010 04:56:35 -0500
Date: Fri, 26 Nov 2010 10:56:32 +0100 (CET)
From: Wojciech Dubowik <dubowoj@neratec.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, nbd@openwrt.org,
	ath5k-devel@lists.ath5k.org
Message-ID: <22511574.421290765388121.JavaMail.wlan@CHBU500181>
In-Reply-To: <9299069.221290764962104.JavaMail.wlan@CHBU500181>
Subject: [PATCH v6 2/9] ath5k: Introduce ath5k_init_softc function as in
 ath9k
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Felix Fietkau <nbd@openwrt.org>

Split pci initialization into hardware specific
functions and softc structure initialization.
Make function naming similar to ones ath9k.
Introduce ath_bus_opts in ath5k for later
AHB bus integration.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
---
 drivers/net/wireless/ath/ath5k/ath5k.h  |   13 +-
 drivers/net/wireless/ath/ath5k/attach.c |   10 +-
 drivers/net/wireless/ath/ath5k/base.c   |  344 ++++++++++++++++++-------------
 drivers/net/wireless/ath/ath5k/base.h   |    1 +
 drivers/net/wireless/ath/ath5k/eeprom.c |    2 +-
 5 files changed, 217 insertions(+), 153 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index 2718136..fe7eae4 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -1133,9 +1133,11 @@ struct ath5k_hw {
  * Prototypes
  */
 
-/* Attach/Detach Functions */
-int ath5k_hw_attach(struct ath5k_softc *sc);
-void ath5k_hw_detach(struct ath5k_hw *ah);
+/* Initialization and detach functions */
+int ath5k_init_softc(struct ath5k_softc *sc, const struct ath_bus_ops *bus_ops);
+void ath5k_deinit_softc(struct ath5k_softc *sc);
+int ath5k_hw_init(struct ath5k_softc *sc);
+void ath5k_hw_deinit(struct ath5k_hw *ah);
 
 int ath5k_sysfs_register(struct ath5k_softc *sc);
 void ath5k_sysfs_unregister(struct ath5k_softc *sc);
@@ -1304,6 +1306,11 @@ static inline void ath5k_hw_reg_write(struct ath5k_hw *ah, u32 val, u16 reg)
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
diff --git a/drivers/net/wireless/ath/ath5k/attach.c b/drivers/net/wireless/ath/ath5k/attach.c
index fbe8aca..042b537 100644
--- a/drivers/net/wireless/ath/ath5k/attach.c
+++ b/drivers/net/wireless/ath/ath5k/attach.c
@@ -93,16 +93,16 @@ static int ath5k_hw_post(struct ath5k_hw *ah)
 }
 
 /**
- * ath5k_hw_attach - Check if hw is supported and init the needed structs
+ * ath5k_hw_init - Check if hw is supported and init the needed structs
  *
- * @sc: The &struct ath5k_softc we got from the driver's attach function
+ * @sc: The &struct ath5k_softc we got from the driver's init_softc function
  *
  * Check if the device is supported, perform a POST and initialize the needed
  * structs. Returns -ENOMEM if we don't have memory for the needed structs,
  * -ENODEV if the device is not supported or prints an error msg if something
  * else went wrong.
  */
-int ath5k_hw_attach(struct ath5k_softc *sc)
+int ath5k_hw_init(struct ath5k_softc *sc)
 {
 	struct ath5k_hw *ah = sc->ah;
 	struct ath_common *common = ath5k_hw_common(ah);
@@ -346,11 +346,11 @@ err:
 }
 
 /**
- * ath5k_hw_detach - Free the ath5k_hw struct
+ * ath5k_hw_deinit - Free the ath5k_hw struct
  *
  * @ah: The &struct ath5k_hw
  */
-void ath5k_hw_detach(struct ath5k_hw *ah)
+void ath5k_hw_deinit(struct ath5k_hw *ah)
 {
 	__set_bit(ATH_STAT_INVALID, ah->ah_sc->status);
 
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 0d4398b..f11e548 100644
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
@@ -2173,7 +2200,7 @@ ath5k_intr_calibration_poll(struct ath5k_hw *ah)
 	 * AR5K_REG_ENABLE_BITS(ah, AR5K_CR, AR5K_CR_SWI); */
 }
 
-static irqreturn_t
+irqreturn_t
 ath5k_intr(int irq, void *dev_id)
 {
 	struct ath5k_softc *sc = dev_id;
@@ -2359,6 +2386,158 @@ ath5k_tx_complete_poll_work(struct work_struct *work)
 * Initialization routines *
 \*************************/
 
+int
+ath5k_init_softc(struct ath5k_softc *sc, const struct ath_bus_ops *bus_ops)
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
+	ret = ath5k_hw_init(sc);
+	if (ret)
+		goto err_free_ah;
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
+	ath5k_hw_deinit(sc->ah);
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
@@ -2399,7 +2578,7 @@ ath5k_stop_locked(struct ath5k_softc *sc)
 }
 
 static int
-ath5k_init(struct ath5k_softc *sc)
+ath5k_init_hw(struct ath5k_softc *sc)
 {
 	struct ath5k_hw *ah = sc->ah;
 	struct ath_common *common = ath5k_hw_common(ah);
@@ -2594,8 +2773,9 @@ static void ath5k_reset_work(struct work_struct *work)
 }
 
 static int
-ath5k_attach(struct pci_dev *pdev, struct ieee80211_hw *hw)
+ath5k_init(struct ieee80211_hw *hw)
 {
+
 	struct ath5k_softc *sc = hw->priv;
 	struct ath5k_hw *ah = sc->ah;
 	struct ath_regulatory *regulatory = ath5k_hw_regulatory(ah);
@@ -2603,7 +2783,6 @@ ath5k_attach(struct pci_dev *pdev, struct ieee80211_hw *hw)
 	u8 mac[ETH_ALEN] = {};
 	int ret;
 
-	ATH5K_DBG(sc, ATH5K_DEBUG_ANY, "devid 0x%x\n", pdev->device);
 
 	/*
 	 * Check if the MAC has multi-rate retry support.
@@ -2744,10 +2923,10 @@ err:
 	return ret;
 }
 
-static void
-ath5k_detach(struct pci_dev *pdev, struct ieee80211_hw *hw)
+void
+ath5k_deinit_softc(struct ath5k_softc *sc)
 {
-	struct ath5k_softc *sc = hw->priv;
+	struct ieee80211_hw *hw = sc->hw;
 
 	/*
 	 * NB: the order of these is important:
@@ -2762,6 +2941,7 @@ ath5k_detach(struct pci_dev *pdev, struct ieee80211_hw *hw)
 	 * XXX: ??? detach ath5k_hw ???
 	 * Other than that, it's straightforward...
 	 */
+	ath5k_debug_finish_device(sc);
 	ieee80211_unregister_hw(hw);
 	ath5k_desc_free(sc);
 	ath5k_txq_release(sc);
@@ -2774,6 +2954,8 @@ ath5k_detach(struct pci_dev *pdev, struct ieee80211_hw *hw)
 	 * returns because we'll get called back to reclaim node
 	 * state and potentially want to use them.
 	 */
+	ath5k_hw_deinit(sc->ah);
+	free_irq(sc->irq, sc);
 }
 
 /********************\
@@ -2796,7 +2978,7 @@ ath5k_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 
 static int ath5k_start(struct ieee80211_hw *hw)
 {
-	return ath5k_init(hw->priv);
+	return ath5k_init_hw(hw->priv);
 }
 
 static void ath5k_stop(struct ieee80211_hw *hw)
@@ -3441,7 +3623,7 @@ static int ath5k_get_antenna(struct ieee80211_hw *hw, u32 *tx_ant, u32 *rx_ant)
 	return 0;
 }
 
-static const struct ieee80211_ops ath5k_hw_ops = {
+const struct ieee80211_ops ath5k_hw_ops = {
 	.tx 		= ath5k_tx,
 	.start 		= ath5k_start,
 	.stop 		= ath5k_stop,
@@ -3475,7 +3657,6 @@ ath5k_pci_probe(struct pci_dev *pdev,
 {
 	void __iomem *mem;
 	struct ath5k_softc *sc;
-	struct ath_common *common;
 	struct ieee80211_hw *hw;
 	int ret;
 	u8 csz;
@@ -3571,146 +3752,24 @@ ath5k_pci_probe(struct pci_dev *pdev,
 
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
+	ret = ath5k_init_softc(sc, &ath_pci_bus_ops);
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
@@ -3726,17 +3785,14 @@ err:
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
+	ath5k_deinit_softc(sc);
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
diff --git a/drivers/net/wireless/ath/ath5k/eeprom.c b/drivers/net/wireless/ath/ath5k/eeprom.c
index 39722dd..2112b53 100644
--- a/drivers/net/wireless/ath/ath5k/eeprom.c
+++ b/drivers/net/wireless/ath/ath5k/eeprom.c
@@ -198,7 +198,7 @@ ath5k_eeprom_init_header(struct ath5k_hw *ah)
 	 *
 	 * XXX: Serdes values seem to be fixed so
 	 * no need to read them here, we write them
-	 * during ath5k_hw_attach */
+	 * during ath5k_hw_init */
 	AR5K_EEPROM_READ(AR5K_EEPROM_PCIE_OFFSET, val);
 	ee->ee_serdes = (val == AR5K_EEPROM_PCIE_SERDES_SECTION) ?
 							true : false;
-- 
1.7.1

