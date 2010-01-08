Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:57908 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113Ab0AHEtK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2010 23:49:10 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 07 Jan 2010 20:49:10 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19270.48447.62235.249988@gargle.gargle.HOWL>
Date: Fri, 8 Jan 2010 10:36:07 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 4/7] ath9k: Cleanup init/deinit routines
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The device initialization and termination functions
were messy and convoluted. Introduce helper functions
to clarify init_softc() and simplify things in general.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ahb.c     |   20 +-
 drivers/net/wireless/ath/ath9k/ath9k.h   |    7 +-
 drivers/net/wireless/ath/ath9k/hw.c      |    4 +-
 drivers/net/wireless/ath/ath9k/hw.h      |    2 +-
 drivers/net/wireless/ath/ath9k/init.c    |  515 +++++++++++++++---------------
 drivers/net/wireless/ath/ath9k/pci.c     |   57 ++--
 drivers/net/wireless/ath/ath9k/virtual.c |    2 +-
 7 files changed, 309 insertions(+), 298 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ahb.c b/drivers/net/wireless/ath/ath9k/ahb.c
index 329e6bc..f24b1f4 100644
--- a/drivers/net/wireless/ath/ath9k/ahb.c
+++ b/drivers/net/wireless/ath/ath9k/ahb.c
@@ -121,16 +121,16 @@ static int ath_ahb_probe(struct platform_device *pdev)
 	sc->mem = mem;
 	sc->irq = irq;
 
-	ret = ath_init_device(AR5416_AR9100_DEVID, sc, 0x0, &ath_ahb_bus_ops);
+	ret = request_irq(irq, ath_isr, IRQF_SHARED, "ath9k", sc);
 	if (ret) {
-		dev_err(&pdev->dev, "failed to initialize device\n");
+		dev_err(&pdev->dev, "request_irq failed\n");
 		goto err_free_hw;
 	}
 
-	ret = request_irq(irq, ath_isr, IRQF_SHARED, "ath9k", sc);
+	ret = ath9k_init_device(AR5416_AR9100_DEVID, sc, 0x0, &ath_ahb_bus_ops);
 	if (ret) {
-		dev_err(&pdev->dev, "request_irq failed\n");
-		goto err_detach;
+		dev_err(&pdev->dev, "failed to initialize device\n");
+		goto err_irq;
 	}
 
 	ah = sc->sc_ah;
@@ -143,8 +143,8 @@ static int ath_ahb_probe(struct platform_device *pdev)
 
 	return 0;
 
- err_detach:
-	ath_detach(sc);
+ err_irq:
+	free_irq(irq, sc);
  err_free_hw:
 	ieee80211_free_hw(hw);
 	platform_set_drvdata(pdev, NULL);
@@ -161,8 +161,12 @@ static int ath_ahb_remove(struct platform_device *pdev)
 	if (hw) {
 		struct ath_wiphy *aphy = hw->priv;
 		struct ath_softc *sc = aphy->sc;
+		struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 
-		ath_cleanup(sc);
+		ath9k_deinit_device(sc);
+		free_irq(sc->irq, sc);
+		ieee80211_free_hw(sc->hw);
+		ath_bus_cleanup(common);
 		platform_set_drvdata(pdev, NULL);
 	}
 
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index f4645a4..bf3d4c4 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -544,13 +544,12 @@ extern struct ieee80211_ops ath9k_ops;
 extern int modparam_nohwcrypt;
 
 irqreturn_t ath_isr(int irq, void *dev);
-void ath_cleanup(struct ath_softc *sc);
-int ath_init_device(u16 devid, struct ath_softc *sc, u16 subsysid,
+int ath9k_init_device(u16 devid, struct ath_softc *sc, u16 subsysid,
 		    const struct ath_bus_ops *bus_ops);
-void ath_detach(struct ath_softc *sc);
+void ath9k_deinit_device(struct ath_softc *sc);
 const char *ath_mac_bb_name(u32 mac_bb_version);
 const char *ath_rf_name(u16 rf_version);
-void ath_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw);
+void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw);
 void ath9k_update_ichannel(struct ath_softc *sc, struct ieee80211_hw *hw,
 			   struct ath9k_channel *ichan);
 void ath_update_chainmask(struct ath_softc *sc, int is_ht);
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 9474f9f..2311fe7 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1242,7 +1242,7 @@ static void ath9k_hw_init_user_settings(struct ath_hw *ah)
 		ath9k_hw_set_global_txtimeout(ah, ah->globaltxtimeout);
 }
 
-void ath9k_hw_detach(struct ath_hw *ah)
+void ath9k_hw_deinit(struct ath_hw *ah)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
 
@@ -1260,7 +1260,7 @@ free_hw:
 	kfree(ah);
 	ah = NULL;
 }
-EXPORT_SYMBOL(ath9k_hw_detach);
+EXPORT_SYMBOL(ath9k_hw_deinit);
 
 /*******/
 /* INI */
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 8849450..3f0f055 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -616,7 +616,7 @@ static inline struct ath_regulatory *ath9k_hw_regulatory(struct ath_hw *ah)
 
 /* Initialization, Detach, Reset */
 const char *ath9k_hw_probe(u16 vendorid, u16 devid);
-void ath9k_hw_detach(struct ath_hw *ah);
+void ath9k_hw_deinit(struct ath_hw *ah);
 int ath9k_hw_init(struct ath_hw *ah);
 int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 		   bool bChannelChange);
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 2bea089..16d1efb 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -128,7 +128,7 @@ static struct ieee80211_rate ath9k_legacy_rates[] = {
 	RATE(540, 0x0c, 0),
 };
 
-static void ath9k_uninit_hw(struct ath_softc *sc);
+static void ath9k_deinit_softc(struct ath_softc *sc);
 
 /*
  * Read and write, they both share the same lock. We do this to serialize
@@ -333,67 +333,13 @@ fail:
 #undef DS2PHYS
 }
 
-static int ath_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid,
-			  const struct ath_bus_ops *bus_ops)
+static void ath9k_init_crypto(struct ath_softc *sc)
 {
-	struct ath_hw *ah = NULL;
-	struct ath_common *common;
-	int r = 0, i;
-	int csz = 0;
-	int qnum;
-
-	/* XXX: hardware will not be ready until ath_open() being called */
-	sc->sc_flags |= SC_OP_INVALID;
-
-	spin_lock_init(&sc->wiphy_lock);
-	spin_lock_init(&sc->sc_resetlock);
-	spin_lock_init(&sc->sc_serial_rw);
-	spin_lock_init(&sc->sc_pm_lock);
-	mutex_init(&sc->mutex);
-	tasklet_init(&sc->intr_tq, ath9k_tasklet, (unsigned long)sc);
-	tasklet_init(&sc->bcon_tasklet, ath_beacon_tasklet,
-		     (unsigned long)sc);
-
-	ah = kzalloc(sizeof(struct ath_hw), GFP_KERNEL);
-	if (!ah)
-		return -ENOMEM;
-
-	ah->hw_version.devid = devid;
-	ah->hw_version.subsysid = subsysid;
-	sc->sc_ah = ah;
-
-	common = ath9k_hw_common(ah);
-	common->ops = &ath9k_common_ops;
-	common->bus_ops = bus_ops;
-	common->ah = ah;
-	common->hw = sc->hw;
-	common->priv = sc;
-	common->debug_mask = ath9k_debug;
-
-	/*
-	 * Cache line size is used to size and align various
-	 * structures used to communicate with the hardware.
-	 */
-	ath_read_cachesize(common, &csz);
-	/* XXX assert csz is non-zero */
-	common->cachelsz = csz << 2;	/* convert to bytes */
-
-	r = ath9k_hw_init(ah);
-	if (r) {
-		ath_print(common, ATH_DBG_FATAL,
-			  "Unable to initialize hardware; "
-			  "initialization status: %d\n", r);
-		goto bad_free_hw;
-	}
-
-	if (ath9k_init_debug(ah) < 0) {
-		ath_print(common, ATH_DBG_FATAL,
-			  "Unable to create debugfs files\n");
-		goto bad_free_hw;
-	}
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	int i = 0;
 
 	/* Get the hardware key cache size. */
-	common->keymax = ah->caps.keycache_size;
+	common->keymax = sc->sc_ah->caps.keycache_size;
 	if (common->keymax > ATH_KEYMAX) {
 		ath_print(common, ATH_DBG_ANY,
 			  "Warning, using only %u entries in %u key cache\n",
@@ -406,185 +352,273 @@ static int ath_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid,
 	 * reset the contents on initial power up.
 	 */
 	for (i = 0; i < common->keymax; i++)
-		ath9k_hw_keyreset(ah, (u16) i);
+		ath9k_hw_keyreset(sc->sc_ah, (u16) i);
 
-	/* default to MONITOR mode */
-	sc->sc_ah->opmode = NL80211_IFTYPE_MONITOR;
+	if (ath9k_hw_getcapability(sc->sc_ah, ATH9K_CAP_CIPHER,
+				   ATH9K_CIPHER_TKIP, NULL)) {
+		/*
+		 * Whether we should enable h/w TKIP MIC.
+		 * XXX: if we don't support WME TKIP MIC, then we wouldn't
+		 * report WMM capable, so it's always safe to turn on
+		 * TKIP MIC in this case.
+		 */
+		ath9k_hw_setcapability(sc->sc_ah, ATH9K_CAP_TKIP_MIC, 0, 1, NULL);
+	}
 
 	/*
-	 * Allocate hardware transmit queues: one queue for
-	 * beacon frames and one data queue for each QoS
-	 * priority.  Note that the hal handles reseting
-	 * these queues at the needed time.
+	 * Check whether the separate key cache entries
+	 * are required to handle both tx+rx MIC keys.
+	 * With split mic keys the number of stations is limited
+	 * to 27 otherwise 59.
 	 */
-	sc->beacon.beaconq = ath9k_hw_beaconq_setup(ah);
+	if (ath9k_hw_getcapability(sc->sc_ah, ATH9K_CAP_CIPHER,
+				   ATH9K_CIPHER_TKIP, NULL)
+	    && ath9k_hw_getcapability(sc->sc_ah, ATH9K_CAP_CIPHER,
+				      ATH9K_CIPHER_MIC, NULL)
+	    && ath9k_hw_getcapability(sc->sc_ah, ATH9K_CAP_TKIP_SPLIT,
+				      0, NULL))
+		common->splitmic = 1;
+
+	/* turn on mcast key search if possible */
+	if (!ath9k_hw_getcapability(sc->sc_ah, ATH9K_CAP_MCAST_KEYSRCH, 0, NULL))
+		(void)ath9k_hw_setcapability(sc->sc_ah, ATH9K_CAP_MCAST_KEYSRCH,
+					     1, 1, NULL);
+
+}
+
+static int ath9k_init_btcoex(struct ath_softc *sc)
+{
+	int r, qnum;
+
+	switch (sc->sc_ah->btcoex_hw.scheme) {
+	case ATH_BTCOEX_CFG_NONE:
+		break;
+	case ATH_BTCOEX_CFG_2WIRE:
+		ath9k_hw_btcoex_init_2wire(sc->sc_ah);
+		break;
+	case ATH_BTCOEX_CFG_3WIRE:
+		ath9k_hw_btcoex_init_3wire(sc->sc_ah);
+		r = ath_init_btcoex_timer(sc);
+		if (r)
+			return -1;
+		qnum = ath_tx_get_qnum(sc, ATH9K_TX_QUEUE_DATA, ATH9K_WME_AC_BE);
+		ath9k_hw_init_btcoex_hw(sc->sc_ah, qnum);
+		sc->btcoex.bt_stomp_type = ATH_BTCOEX_STOMP_LOW;
+		break;
+	default:
+		WARN_ON(1);
+		break;
+	}
+
+	return 0;
+}
+
+static int ath9k_init_queues(struct ath_softc *sc)
+{
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	int i = 0;
+
+	for (i = 0; i < ARRAY_SIZE(sc->tx.hwq_map); i++)
+		sc->tx.hwq_map[i] = -1;
+
+	sc->beacon.beaconq = ath9k_hw_beaconq_setup(sc->sc_ah);
 	if (sc->beacon.beaconq == -1) {
 		ath_print(common, ATH_DBG_FATAL,
 			  "Unable to setup a beacon xmit queue\n");
-		r = -EIO;
-		goto bad2;
+		goto err;
 	}
+
 	sc->beacon.cabq = ath_txq_setup(sc, ATH9K_TX_QUEUE_CAB, 0);
 	if (sc->beacon.cabq == NULL) {
 		ath_print(common, ATH_DBG_FATAL,
 			  "Unable to setup CAB xmit queue\n");
-		r = -EIO;
-		goto bad2;
+		goto err;
 	}
 
 	sc->config.cabqReadytime = ATH_CABQ_READY_TIME;
 	ath_cabq_update(sc);
 
-	for (i = 0; i < ARRAY_SIZE(sc->tx.hwq_map); i++)
-		sc->tx.hwq_map[i] = -1;
-
-	/* Setup data queues */
-	/* NB: ensure BK queue is the lowest priority h/w queue */
 	if (!ath_tx_setup(sc, ATH9K_WME_AC_BK)) {
 		ath_print(common, ATH_DBG_FATAL,
 			  "Unable to setup xmit queue for BK traffic\n");
-		r = -EIO;
-		goto bad2;
+		goto err;
 	}
 
 	if (!ath_tx_setup(sc, ATH9K_WME_AC_BE)) {
 		ath_print(common, ATH_DBG_FATAL,
 			  "Unable to setup xmit queue for BE traffic\n");
-		r = -EIO;
-		goto bad2;
+		goto err;
 	}
 	if (!ath_tx_setup(sc, ATH9K_WME_AC_VI)) {
 		ath_print(common, ATH_DBG_FATAL,
 			  "Unable to setup xmit queue for VI traffic\n");
-		r = -EIO;
-		goto bad2;
+		goto err;
 	}
 	if (!ath_tx_setup(sc, ATH9K_WME_AC_VO)) {
 		ath_print(common, ATH_DBG_FATAL,
 			  "Unable to setup xmit queue for VO traffic\n");
-		r = -EIO;
-		goto bad2;
+		goto err;
 	}
 
-	/* Initializes the noise floor to a reasonable default value.
-	 * Later on this will be updated during ANI processing. */
+	return 0;
 
-	common->ani.noise_floor = ATH_DEFAULT_NOISE_FLOOR;
-	setup_timer(&common->ani.timer, ath_ani_calibrate, (unsigned long)sc);
+err:
+	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++)
+		if (ATH_TXQ_SETUP(sc, i))
+			ath_tx_cleanupq(sc, &sc->tx.txq[i]);
 
-	if (ath9k_hw_getcapability(ah, ATH9K_CAP_CIPHER,
-				   ATH9K_CIPHER_TKIP, NULL)) {
-		/*
-		 * Whether we should enable h/w TKIP MIC.
-		 * XXX: if we don't support WME TKIP MIC, then we wouldn't
-		 * report WMM capable, so it's always safe to turn on
-		 * TKIP MIC in this case.
-		 */
-		ath9k_hw_setcapability(sc->sc_ah, ATH9K_CAP_TKIP_MIC,
-				       0, 1, NULL);
+	return -EIO;
+}
+
+static void ath9k_init_channels_rates(struct ath_softc *sc)
+{
+	if (test_bit(ATH9K_MODE_11G, sc->sc_ah->caps.wireless_modes)) {
+		sc->sbands[IEEE80211_BAND_2GHZ].channels = ath9k_2ghz_chantable;
+		sc->sbands[IEEE80211_BAND_2GHZ].band = IEEE80211_BAND_2GHZ;
+		sc->sbands[IEEE80211_BAND_2GHZ].n_channels =
+			ARRAY_SIZE(ath9k_2ghz_chantable);
+		sc->sbands[IEEE80211_BAND_2GHZ].bitrates = ath9k_legacy_rates;
+		sc->sbands[IEEE80211_BAND_2GHZ].n_bitrates =
+			ARRAY_SIZE(ath9k_legacy_rates);
 	}
 
-	/*
-	 * Check whether the separate key cache entries
-	 * are required to handle both tx+rx MIC keys.
-	 * With split mic keys the number of stations is limited
-	 * to 27 otherwise 59.
-	 */
-	if (ath9k_hw_getcapability(ah, ATH9K_CAP_CIPHER,
-				   ATH9K_CIPHER_TKIP, NULL)
-	    && ath9k_hw_getcapability(ah, ATH9K_CAP_CIPHER,
-				      ATH9K_CIPHER_MIC, NULL)
-	    && ath9k_hw_getcapability(ah, ATH9K_CAP_TKIP_SPLIT,
-				      0, NULL))
-		common->splitmic = 1;
+	if (test_bit(ATH9K_MODE_11A, sc->sc_ah->caps.wireless_modes)) {
+		sc->sbands[IEEE80211_BAND_5GHZ].channels = ath9k_5ghz_chantable;
+		sc->sbands[IEEE80211_BAND_5GHZ].band = IEEE80211_BAND_5GHZ;
+		sc->sbands[IEEE80211_BAND_5GHZ].n_channels =
+			ARRAY_SIZE(ath9k_5ghz_chantable);
+		sc->sbands[IEEE80211_BAND_5GHZ].bitrates =
+			ath9k_legacy_rates + 4;
+		sc->sbands[IEEE80211_BAND_5GHZ].n_bitrates =
+			ARRAY_SIZE(ath9k_legacy_rates) - 4;
+	}
+}
 
-	/* turn on mcast key search if possible */
-	if (!ath9k_hw_getcapability(ah, ATH9K_CAP_MCAST_KEYSRCH, 0, NULL))
-		(void)ath9k_hw_setcapability(ah, ATH9K_CAP_MCAST_KEYSRCH, 1,
-					     1, NULL);
+static void ath9k_init_misc(struct ath_softc *sc)
+{
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	int i = 0;
+
+	common->ani.noise_floor = ATH_DEFAULT_NOISE_FLOOR;
+	setup_timer(&common->ani.timer, ath_ani_calibrate, (unsigned long)sc);
 
 	sc->config.txpowlimit = ATH_TXPOWER_MAX;
 
-	/* 11n Capabilities */
-	if (ah->caps.hw_caps & ATH9K_HW_CAP_HT) {
+	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_HT) {
 		sc->sc_flags |= SC_OP_TXAGGR;
 		sc->sc_flags |= SC_OP_RXAGGR;
 	}
 
-	common->tx_chainmask = ah->caps.tx_chainmask;
-	common->rx_chainmask = ah->caps.rx_chainmask;
+	common->tx_chainmask = sc->sc_ah->caps.tx_chainmask;
+	common->rx_chainmask = sc->sc_ah->caps.rx_chainmask;
 
-	ath9k_hw_setcapability(ah, ATH9K_CAP_DIVERSITY, 1, true, NULL);
-	sc->rx.defant = ath9k_hw_getdefantenna(ah);
+	ath9k_hw_setcapability(sc->sc_ah, ATH9K_CAP_DIVERSITY, 1, true, NULL);
+	sc->rx.defant = ath9k_hw_getdefantenna(sc->sc_ah);
 
-	if (ah->caps.hw_caps & ATH9K_HW_CAP_BSSIDMASK)
+	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_BSSIDMASK)
 		memcpy(common->bssidmask, ath_bcast_mac, ETH_ALEN);
 
-	sc->beacon.slottime = ATH9K_SLOT_TIME_9;	/* default to short slot time */
+	sc->beacon.slottime = ATH9K_SLOT_TIME_9;
 
-	/* initialize beacon slots */
 	for (i = 0; i < ARRAY_SIZE(sc->beacon.bslot); i++) {
 		sc->beacon.bslot[i] = NULL;
 		sc->beacon.bslot_aphy[i] = NULL;
 	}
+}
 
-	/* setup channels and rates */
+static int ath9k_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid,
+			    const struct ath_bus_ops *bus_ops)
+{
+	struct ath_hw *ah = NULL;
+	struct ath_common *common;
+	int ret = 0, i;
+	int csz = 0;
 
-	if (test_bit(ATH9K_MODE_11G, sc->sc_ah->caps.wireless_modes)) {
-		sc->sbands[IEEE80211_BAND_2GHZ].channels = ath9k_2ghz_chantable;
-		sc->sbands[IEEE80211_BAND_2GHZ].band = IEEE80211_BAND_2GHZ;
-		sc->sbands[IEEE80211_BAND_2GHZ].n_channels =
-			ARRAY_SIZE(ath9k_2ghz_chantable);
-		sc->sbands[IEEE80211_BAND_2GHZ].bitrates = ath9k_legacy_rates;
-		sc->sbands[IEEE80211_BAND_2GHZ].n_bitrates =
-			ARRAY_SIZE(ath9k_legacy_rates);
-	}
+	sc->sc_flags |= SC_OP_INVALID;
 
-	if (test_bit(ATH9K_MODE_11A, sc->sc_ah->caps.wireless_modes)) {
-		sc->sbands[IEEE80211_BAND_5GHZ].channels = ath9k_5ghz_chantable;
-		sc->sbands[IEEE80211_BAND_5GHZ].band = IEEE80211_BAND_5GHZ;
-		sc->sbands[IEEE80211_BAND_5GHZ].n_channels =
-			ARRAY_SIZE(ath9k_5ghz_chantable);
-		sc->sbands[IEEE80211_BAND_5GHZ].bitrates =
-			ath9k_legacy_rates + 4;
-		sc->sbands[IEEE80211_BAND_5GHZ].n_bitrates =
-			ARRAY_SIZE(ath9k_legacy_rates) - 4;
+	ah = kzalloc(sizeof(struct ath_hw), GFP_KERNEL);
+	if (!ah)
+		return -ENOMEM;
+
+	ah->hw_version.devid = devid;
+	ah->hw_version.subsysid = subsysid;
+	sc->sc_ah = ah;
+
+	common = ath9k_hw_common(ah);
+	common->ops = &ath9k_common_ops;
+	common->bus_ops = bus_ops;
+	common->ah = ah;
+	common->hw = sc->hw;
+	common->priv = sc;
+	common->debug_mask = ath9k_debug;
+
+	spin_lock_init(&sc->wiphy_lock);
+	spin_lock_init(&sc->sc_resetlock);
+	spin_lock_init(&sc->sc_serial_rw);
+	spin_lock_init(&sc->sc_pm_lock);
+	mutex_init(&sc->mutex);
+	tasklet_init(&sc->intr_tq, ath9k_tasklet, (unsigned long)sc);
+	tasklet_init(&sc->bcon_tasklet, ath_beacon_tasklet,
+		     (unsigned long)sc);
+
+	/*
+	 * Cache line size is used to size and align various
+	 * structures used to communicate with the hardware.
+	 */
+	ath_read_cachesize(common, &csz);
+	common->cachelsz = csz << 2; /* convert to bytes */
+
+	ret = ath9k_hw_init(ah);
+	if (ret) {
+		ath_print(common, ATH_DBG_FATAL,
+			  "Unable to initialize hardware; "
+			  "initialization status: %d\n", ret);
+		goto err_hw;
 	}
 
-	switch (ah->btcoex_hw.scheme) {
-	case ATH_BTCOEX_CFG_NONE:
-		break;
-	case ATH_BTCOEX_CFG_2WIRE:
-		ath9k_hw_btcoex_init_2wire(ah);
-		break;
-	case ATH_BTCOEX_CFG_3WIRE:
-		ath9k_hw_btcoex_init_3wire(ah);
-		r = ath_init_btcoex_timer(sc);
-		if (r)
-			goto bad2;
-		qnum = ath_tx_get_qnum(sc, ATH9K_TX_QUEUE_DATA, ATH9K_WME_AC_BE);
-		ath9k_hw_init_btcoex_hw(ah, qnum);
-		sc->btcoex.bt_stomp_type = ATH_BTCOEX_STOMP_LOW;
-		break;
-	default:
-		WARN_ON(1);
-		break;
+	ret = ath9k_init_debug(ah);
+	if (ret) {
+		ath_print(common, ATH_DBG_FATAL,
+			  "Unable to create debugfs files\n");
+		goto err_debug;
 	}
 
+	ret = ath9k_init_queues(sc);
+	if (ret)
+		goto err_queues;
+
+	ret =  ath9k_init_btcoex(sc);
+	if (ret)
+		goto err_btcoex;
+
+	ath9k_init_crypto(sc);
+	ath9k_init_channels_rates(sc);
+	ath9k_init_misc(sc);
+
 	return 0;
-bad2:
-	/* cleanup tx queues */
+
+err_btcoex:
 	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++)
 		if (ATH_TXQ_SETUP(sc, i))
 			ath_tx_cleanupq(sc, &sc->tx.txq[i]);
+err_queues:
+	ath9k_exit_debug(ah);
+err_debug:
+	ath9k_hw_deinit(ah);
+err_hw:
+	tasklet_kill(&sc->intr_tq);
+	tasklet_kill(&sc->bcon_tasklet);
 
-bad_free_hw:
-	ath9k_uninit_hw(sc);
-	return r;
+	kfree(ah);
+	sc->sc_ah = NULL;
+
+	return ret;
 }
 
-void ath_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
+void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 {
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+
 	hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
 		IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
 		IEEE80211_HW_SIGNAL_DBM |
@@ -621,85 +655,85 @@ void ath_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 	if (test_bit(ATH9K_MODE_11A, sc->sc_ah->caps.wireless_modes))
 		hw->wiphy->bands[IEEE80211_BAND_5GHZ] =
 			&sc->sbands[IEEE80211_BAND_5GHZ];
+
+	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_HT) {
+		if (test_bit(ATH9K_MODE_11G, sc->sc_ah->caps.wireless_modes))
+			setup_ht_cap(sc, &sc->sbands[IEEE80211_BAND_2GHZ].ht_cap);
+		if (test_bit(ATH9K_MODE_11A, sc->sc_ah->caps.wireless_modes))
+			setup_ht_cap(sc, &sc->sbands[IEEE80211_BAND_5GHZ].ht_cap);
+	}
+
+	SET_IEEE80211_PERM_ADDR(hw, common->macaddr);
 }
 
-/* Device driver core initialization */
-int ath_init_device(u16 devid, struct ath_softc *sc, u16 subsysid,
+int ath9k_init_device(u16 devid, struct ath_softc *sc, u16 subsysid,
 		    const struct ath_bus_ops *bus_ops)
 {
 	struct ieee80211_hw *hw = sc->hw;
 	struct ath_common *common;
 	struct ath_hw *ah;
-	int error = 0, i;
+	int error = 0;
 	struct ath_regulatory *reg;
 
-	dev_dbg(sc->dev, "Attach ATH hw\n");
-
-	error = ath_init_softc(devid, sc, subsysid, bus_ops);
+	/* Bring up device */
+	error = ath9k_init_softc(devid, sc, subsysid, bus_ops);
 	if (error != 0)
-		return error;
+		goto error_init;
 
 	ah = sc->sc_ah;
 	common = ath9k_hw_common(ah);
+	ath9k_set_hw_capab(sc, hw);
 
-	/* get mac address from hardware and set in mac80211 */
-
-	SET_IEEE80211_PERM_ADDR(hw, common->macaddr);
-
-	ath_set_hw_capab(sc, hw);
-
+	/* Initialize regulatory */
 	error = ath_regd_init(&common->regulatory, sc->hw->wiphy,
 			      ath9k_reg_notifier);
 	if (error)
-		return error;
+		goto error_regd;
 
 	reg = &common->regulatory;
 
-	if (ah->caps.hw_caps & ATH9K_HW_CAP_HT) {
-		if (test_bit(ATH9K_MODE_11G, ah->caps.wireless_modes))
-			setup_ht_cap(sc,
-				     &sc->sbands[IEEE80211_BAND_2GHZ].ht_cap);
-		if (test_bit(ATH9K_MODE_11A, ah->caps.wireless_modes))
-			setup_ht_cap(sc,
-				     &sc->sbands[IEEE80211_BAND_5GHZ].ht_cap);
-	}
-
-	/* initialize tx/rx engine */
+	/* Setup TX DMA */
 	error = ath_tx_init(sc, ATH_TXBUF);
 	if (error != 0)
-		goto error_attach;
+		goto error_tx;
 
+	/* Setup RX DMA */
 	error = ath_rx_init(sc, ATH_RXBUF);
 	if (error != 0)
-		goto error_attach;
-
-	INIT_WORK(&sc->chan_work, ath9k_wiphy_chan_work);
-	INIT_DELAYED_WORK(&sc->wiphy_work, ath9k_wiphy_work);
-	sc->wiphy_scheduler_int = msecs_to_jiffies(500);
+		goto error_rx;
 
+	/* Register with mac80211 */
 	error = ieee80211_register_hw(hw);
+	if (error)
+		goto error_register;
 
+	/* Handle world regulatory */
 	if (!ath_is_world_regd(reg)) {
 		error = regulatory_hint(hw->wiphy, reg->alpha2);
 		if (error)
-			goto error_attach;
+			goto error_world;
 	}
 
-	/* Initialize LED control */
-	ath_init_leds(sc);
+	INIT_WORK(&sc->chan_work, ath9k_wiphy_chan_work);
+	INIT_DELAYED_WORK(&sc->wiphy_work, ath9k_wiphy_work);
+	sc->wiphy_scheduler_int = msecs_to_jiffies(500);
 
+	ath_init_leds(sc);
 	ath_start_rfkill_poll(sc);
 
 	return 0;
 
-error_attach:
-	/* cleanup tx queues */
-	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++)
-		if (ATH_TXQ_SETUP(sc, i))
-			ath_tx_cleanupq(sc, &sc->tx.txq[i]);
-
-	ath9k_uninit_hw(sc);
-
+error_world:
+	ieee80211_unregister_hw(hw);
+error_register:
+	ath_rx_cleanup(sc);
+error_rx:
+	ath_tx_cleanup(sc);
+error_tx:
+	/* Nothing */
+error_regd:
+	ath9k_deinit_softc(sc);
+error_init:
 	return error;
 }
 
@@ -707,29 +741,34 @@ error_attach:
 /*     De-Initialization     */
 /*****************************/
 
-static void ath9k_uninit_hw(struct ath_softc *sc)
+static void ath9k_deinit_softc(struct ath_softc *sc)
 {
-	struct ath_hw *ah = sc->sc_ah;
+	int i = 0;
 
-	BUG_ON(!ah);
+        if ((sc->btcoex.no_stomp_timer) &&
+	    sc->sc_ah->btcoex_hw.scheme == ATH_BTCOEX_CFG_3WIRE)
+		ath_gen_timer_free(sc->sc_ah, sc->btcoex.no_stomp_timer);
 
-	ath9k_exit_debug(ah);
-	ath9k_hw_detach(ah);
-	sc->sc_ah = NULL;
+	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++)
+		if (ATH_TXQ_SETUP(sc, i))
+			ath_tx_cleanupq(sc, &sc->tx.txq[i]);
+
+	ath9k_exit_debug(sc->sc_ah);
+	ath9k_hw_deinit(sc->sc_ah);
+
+	tasklet_kill(&sc->intr_tq);
+	tasklet_kill(&sc->bcon_tasklet);
 }
 
-static void ath_clean_core(struct ath_softc *sc)
+void ath9k_deinit_device(struct ath_softc *sc)
 {
 	struct ieee80211_hw *hw = sc->hw;
-	struct ath_hw *ah = sc->sc_ah;
 	int i = 0;
 
 	ath9k_ps_wakeup(sc);
 
-	dev_dbg(sc->dev, "Detach ATH hw\n");
-
-	ath_deinit_leds(sc);
 	wiphy_rfkill_stop_polling(sc->hw->wiphy);
+	ath_deinit_leds(sc);
 
 	for (i = 0; i < sc->num_sec_wiphy; i++) {
 		struct ath_wiphy *aphy = sc->sec_wiphy[i];
@@ -739,24 +778,12 @@ static void ath_clean_core(struct ath_softc *sc)
 		ieee80211_unregister_hw(aphy->hw);
 		ieee80211_free_hw(aphy->hw);
 	}
+	kfree(sc->sec_wiphy);
+
 	ieee80211_unregister_hw(hw);
 	ath_rx_cleanup(sc);
 	ath_tx_cleanup(sc);
-
-	tasklet_kill(&sc->intr_tq);
-	tasklet_kill(&sc->bcon_tasklet);
-
-	if (!(sc->sc_flags & SC_OP_INVALID))
-		ath9k_setpower(sc, ATH9K_PM_AWAKE);
-
-	/* cleanup tx queues */
-	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++)
-		if (ATH_TXQ_SETUP(sc, i))
-			ath_tx_cleanupq(sc, &sc->tx.txq[i]);
-
-	if ((sc->btcoex.no_stomp_timer) &&
-	    ah->btcoex_hw.scheme == ATH_BTCOEX_CFG_3WIRE)
-		ath_gen_timer_free(ah, sc->btcoex.no_stomp_timer);
+	ath9k_deinit_softc(sc);
 }
 
 void ath_descdma_cleanup(struct ath_softc *sc,
@@ -771,26 +798,6 @@ void ath_descdma_cleanup(struct ath_softc *sc,
 	memset(dd, 0, sizeof(*dd));
 }
 
-void ath_detach(struct ath_softc *sc)
-{
-	ath_clean_core(sc);
-	ath9k_uninit_hw(sc);
-}
-
-void ath_cleanup(struct ath_softc *sc)
-{
-	struct ath_hw *ah = sc->sc_ah;
-	struct ath_common *common = ath9k_hw_common(ah);
-
-	ath_clean_core(sc);
-	free_irq(sc->irq, sc);
-	ath_bus_cleanup(common);
-	kfree(sc->sec_wiphy);
-	ieee80211_free_hw(sc->hw);
-
-	ath9k_uninit_hw(sc);
-}
-
 /************************/
 /*     Module Hooks     */
 /************************/
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index f7af5ea..95b9a07 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -113,25 +113,22 @@ static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	u16 subsysid;
 	u32 val;
 	int ret = 0;
-	struct ath_hw *ah;
 	char hw_name[64];
 
 	if (pci_enable_device(pdev))
 		return -EIO;
 
 	ret =  pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
-
 	if (ret) {
 		printk(KERN_ERR "ath9k: 32-bit DMA not available\n");
-		goto bad;
+		goto err_dma;
 	}
 
 	ret = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
-
 	if (ret) {
 		printk(KERN_ERR "ath9k: 32-bit DMA consistent "
 			"DMA enable failed\n");
-		goto bad;
+		goto err_dma;
 	}
 
 	/*
@@ -171,22 +168,22 @@ static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (ret) {
 		dev_err(&pdev->dev, "PCI memory region reserve error\n");
 		ret = -ENODEV;
-		goto bad;
+		goto err_region;
 	}
 
 	mem = pci_iomap(pdev, 0, 0);
 	if (!mem) {
 		printk(KERN_ERR "PCI memory map error\n") ;
 		ret = -EIO;
-		goto bad1;
+		goto err_iomap;
 	}
 
 	hw = ieee80211_alloc_hw(sizeof(struct ath_wiphy) +
 				sizeof(struct ath_softc), &ath9k_ops);
 	if (!hw) {
-		dev_err(&pdev->dev, "no memory for ieee80211_hw\n");
+		dev_err(&pdev->dev, "No memory for ieee80211_hw\n");
 		ret = -ENOMEM;
-		goto bad2;
+		goto err_alloc_hw;
 	}
 
 	SET_IEEE80211_DEV(hw, &pdev->dev);
@@ -201,25 +198,22 @@ static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	sc->dev = &pdev->dev;
 	sc->mem = mem;
 
-	pci_read_config_word(pdev, PCI_SUBSYSTEM_ID, &subsysid);
-	ret = ath_init_device(id->device, sc, subsysid, &ath_pci_bus_ops);
-	if (ret) {
-		dev_err(&pdev->dev, "failed to initialize device\n");
-		goto bad3;
-	}
-
-	/* setup interrupt service routine */
-
 	ret = request_irq(pdev->irq, ath_isr, IRQF_SHARED, "ath9k", sc);
 	if (ret) {
 		dev_err(&pdev->dev, "request_irq failed\n");
-		goto bad4;
+		goto err_irq;
 	}
 
 	sc->irq = pdev->irq;
 
-	ah = sc->sc_ah;
-	ath9k_hw_name(ah, hw_name, sizeof(hw_name));
+	pci_read_config_word(pdev, PCI_SUBSYSTEM_ID, &subsysid);
+	ret = ath9k_init_device(id->device, sc, subsysid, &ath_pci_bus_ops);
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to initialize device\n");
+		goto err_init;
+	}
+
+	ath9k_hw_name(sc->sc_ah, hw_name, sizeof(hw_name));
 	printk(KERN_INFO
 	       "%s: %s mem=0x%lx, irq=%d\n",
 	       wiphy_name(hw->wiphy),
@@ -227,15 +221,18 @@ static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	       (unsigned long)mem, pdev->irq);
 
 	return 0;
-bad4:
-	ath_detach(sc);
-bad3:
+
+err_init:
+	free_irq(sc->irq, sc);
+err_irq:
 	ieee80211_free_hw(hw);
-bad2:
+err_alloc_hw:
 	pci_iounmap(pdev, mem);
-bad1:
+err_iomap:
 	pci_release_region(pdev, 0);
-bad:
+err_region:
+	/* Nothing */
+err_dma:
 	pci_disable_device(pdev);
 	return ret;
 }
@@ -245,8 +242,12 @@ static void ath_pci_remove(struct pci_dev *pdev)
 	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
 	struct ath_wiphy *aphy = hw->priv;
 	struct ath_softc *sc = aphy->sc;
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 
-	ath_cleanup(sc);
+	ath9k_deinit_device(sc);
+	free_irq(sc->irq, sc);
+	ieee80211_free_hw(sc->hw);
+	ath_bus_cleanup(common);
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/net/wireless/ath/ath9k/virtual.c b/drivers/net/wireless/ath/ath9k/virtual.c
index cd26caa..a43fbf8 100644
--- a/drivers/net/wireless/ath/ath9k/virtual.c
+++ b/drivers/net/wireless/ath/ath9k/virtual.c
@@ -152,7 +152,7 @@ int ath9k_wiphy_add(struct ath_softc *sc)
 
 	SET_IEEE80211_PERM_ADDR(hw, addr);
 
-	ath_set_hw_capab(sc, hw);
+	ath9k_set_hw_capab(sc, hw);
 
 	error = ieee80211_register_hw(hw);
 
-- 
1.6.6

