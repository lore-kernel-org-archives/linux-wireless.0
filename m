Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:20479 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751178Ab1GTURT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jul 2011 16:17:19 -0400
Subject: [PATCH v3] ath5k: merge ath5k_hw and ath5k_softc
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
From: Pavel Roskin <proski@gnu.org>
Date: Wed, 20 Jul 2011 16:17:15 -0400
Message-ID: <20110720201623.549.72957.stgit@mj.roinet.com> (sfid-20110720_221725_849688_0AC5500B)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Both ath5k_hw and ath5k_softc represent one instance of the hardware.
This duplication is historical and is not needed anymore.

Keep the name "ath5k_hw" for the merged structure and "ah" for the
variable pointing to it.  "ath5k_hw" is shorter than "ath5k_softc", more
descriptive and more widely used.

Put the combined structure to ath5k.h where the old ath5k_softc used to
be. Move some code from base.h to ath5k.h as needed.

Remove memory allocation for struct ath5k_hw and the corresponding error
handling.  Merge iobase and ah_iobase fields.

Rename ath5k_init_softc() and ath5k_deinit_softc() to ath5k_init_ah() and
ath5k_deinit_ah() respectively.

Signed-off-by: Pavel Roskin <proski@gnu.org>
Acked-by: Nick Kossifidis <mickflemm@gmail.com>
---

This version of the patch was tested on both wireless-testing and
linux-next (thanks to Sedat Dilek).  It also removes all occurrences of
"softc", as they are not very meaningful now.

 drivers/net/wireless/ath/ath5k/ahb.c          |   44 -
 drivers/net/wireless/ath/ath5k/ani.c          |   84 +-
 drivers/net/wireless/ath/ath5k/ath5k.h        |  243 +++++
 drivers/net/wireless/ath/ath5k/attach.c       |   31 -
 drivers/net/wireless/ath/ath5k/base.c         | 1132 ++++++++++++-------------
 drivers/net/wireless/ath/ath5k/base.h         |  199 ----
 drivers/net/wireless/ath/ath5k/debug.c        |  218 ++---
 drivers/net/wireless/ath/ath5k/debug.h        |   21 
 drivers/net/wireless/ath/ath5k/desc.c         |   10 
 drivers/net/wireless/ath/ath5k/dma.c          |   12 
 drivers/net/wireless/ath/ath5k/eeprom.c       |    4 
 drivers/net/wireless/ath/ath5k/initvals.c     |    2 
 drivers/net/wireless/ath/ath5k/led.c          |   68 +-
 drivers/net/wireless/ath/ath5k/mac80211-ops.c |  243 +++--
 drivers/net/wireless/ath/ath5k/pci.c          |   38 -
 drivers/net/wireless/ath/ath5k/pcu.c          |   24 -
 drivers/net/wireless/ath/ath5k/phy.c          |   32 -
 drivers/net/wireless/ath/ath5k/qcu.c          |    9 
 drivers/net/wireless/ath/ath5k/reset.c        |   44 -
 drivers/net/wireless/ath/ath5k/rfkill.c       |   65 +
 drivers/net/wireless/ath/ath5k/sysfs.c        |   32 -
 drivers/net/wireless/ath/ath5k/trace.h        |   12 
 22 files changed, 1250 insertions(+), 1317 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ahb.c b/drivers/net/wireless/ath/ath5k/ahb.c
index ba682a0..a43ab71 100644
--- a/drivers/net/wireless/ath/ath5k/ahb.c
+++ b/drivers/net/wireless/ath/ath5k/ahb.c
@@ -35,8 +35,8 @@ static void ath5k_ahb_read_cachesize(struct ath_common *common, int *csz)
 static bool
 ath5k_ahb_eeprom_read(struct ath_common *common, u32 off, u16 *data)
 {
-	struct ath5k_softc *sc = common->priv;
-	struct platform_device *pdev = to_platform_device(sc->dev);
+	struct ath5k_hw *ah = common->priv;
+	struct platform_device *pdev = to_platform_device(ah->dev);
 	struct ar231x_board_config *bcfg = pdev->dev.platform_data;
 	u16 *eeprom, *eeprom_end;
 
@@ -56,8 +56,7 @@ ath5k_ahb_eeprom_read(struct ath_common *common, u32 off, u16 *data)
 
 int ath5k_hw_read_srev(struct ath5k_hw *ah)
 {
-	struct ath5k_softc *sc = ah->ah_sc;
-	struct platform_device *pdev = to_platform_device(sc->dev);
+	struct platform_device *pdev = to_platform_device(ah->dev);
 	struct ar231x_board_config *bcfg = pdev->dev.platform_data;
 	ah->ah_mac_srev = bcfg->devid;
 	return 0;
@@ -65,12 +64,11 @@ int ath5k_hw_read_srev(struct ath5k_hw *ah)
 
 static int ath5k_ahb_eeprom_read_mac(struct ath5k_hw *ah, u8 *mac)
 {
-	struct ath5k_softc *sc = ah->ah_sc;
-	struct platform_device *pdev = to_platform_device(sc->dev);
+	struct platform_device *pdev = to_platform_device(ah->dev);
 	struct ar231x_board_config *bcfg = pdev->dev.platform_data;
 	u8 *cfg_mac;
 
-	if (to_platform_device(sc->dev)->id == 0)
+	if (to_platform_device(ah->dev)->id == 0)
 		cfg_mac = bcfg->config->wlan0_mac;
 	else
 		cfg_mac = bcfg->config->wlan1_mac;
@@ -90,7 +88,7 @@ static const struct ath_bus_ops ath_ahb_bus_ops = {
 static int ath_ahb_probe(struct platform_device *pdev)
 {
 	struct ar231x_board_config *bcfg = pdev->dev.platform_data;
-	struct ath5k_softc *sc;
+	struct ath5k_hw *ah;
 	struct ieee80211_hw *hw;
 	struct resource *res;
 	void __iomem *mem;
@@ -127,19 +125,19 @@ static int ath_ahb_probe(struct platform_device *pdev)
 
 	irq = res->start;
 
-	hw = ieee80211_alloc_hw(sizeof(struct ath5k_softc), &ath5k_hw_ops);
+	hw = ieee80211_alloc_hw(sizeof(struct ath5k_hw), &ath5k_hw_ops);
 	if (hw == NULL) {
 		dev_err(&pdev->dev, "no memory for ieee80211_hw\n");
 		ret = -ENOMEM;
 		goto err_out;
 	}
 
-	sc = hw->priv;
-	sc->hw = hw;
-	sc->dev = &pdev->dev;
-	sc->iobase = mem;
-	sc->irq = irq;
-	sc->devid = bcfg->devid;
+	ah = hw->priv;
+	ah->hw = hw;
+	ah->dev = &pdev->dev;
+	ah->iobase = mem;
+	ah->irq = irq;
+	ah->devid = bcfg->devid;
 
 	if (bcfg->devid >= AR5K_SREV_AR2315_R6) {
 		/* Enable WMAC AHB arbitration */
@@ -155,7 +153,7 @@ static int ath_ahb_probe(struct platform_device *pdev)
 		/* Enable WMAC DMA access (assuming 5312 or 231x*/
 		/* TODO: check other platforms */
 		reg = __raw_readl((void __iomem *) AR5K_AR5312_ENABLE);
-		if (to_platform_device(sc->dev)->id == 0)
+		if (to_platform_device(ah->dev)->id == 0)
 			reg |= AR5K_AR5312_ENABLE_WLAN0;
 		else
 			reg |= AR5K_AR5312_ENABLE_WLAN1;
@@ -166,13 +164,13 @@ static int ath_ahb_probe(struct platform_device *pdev)
 		 * used as pass-through. Disable 2 GHz support in the
 		 * driver for it
 		 */
-		if (to_platform_device(sc->dev)->id == 0 &&
+		if (to_platform_device(ah->dev)->id == 0 &&
 		    (bcfg->config->flags & (BD_WLAN0 | BD_WLAN1)) ==
 		     (BD_WLAN1 | BD_WLAN0))
-			__set_bit(ATH_STAT_2G_DISABLED, sc->status);
+			__set_bit(ATH_STAT_2G_DISABLED, ah->status);
 	}
 
-	ret = ath5k_init_softc(sc, &ath_ahb_bus_ops);
+	ret = ath5k_init_ah(ah, &ath_ahb_bus_ops);
 	if (ret != 0) {
 		dev_err(&pdev->dev, "failed to attach device, err=%d\n", ret);
 		ret = -ENODEV;
@@ -194,13 +192,13 @@ static int ath_ahb_remove(struct platform_device *pdev)
 {
 	struct ar231x_board_config *bcfg = pdev->dev.platform_data;
 	struct ieee80211_hw *hw = platform_get_drvdata(pdev);
-	struct ath5k_softc *sc;
+	struct ath5k_hw *ah;
 	u32 reg;
 
 	if (!hw)
 		return 0;
 
-	sc = hw->priv;
+	ah = hw->priv;
 
 	if (bcfg->devid >= AR5K_SREV_AR2315_R6) {
 		/* Disable WMAC AHB arbitration */
@@ -210,14 +208,14 @@ static int ath_ahb_remove(struct platform_device *pdev)
 	} else {
 		/*Stop DMA access */
 		reg = __raw_readl((void __iomem *) AR5K_AR5312_ENABLE);
-		if (to_platform_device(sc->dev)->id == 0)
+		if (to_platform_device(ah->dev)->id == 0)
 			reg &= ~AR5K_AR5312_ENABLE_WLAN0;
 		else
 			reg &= ~AR5K_AR5312_ENABLE_WLAN1;
 		__raw_writel(reg, (void __iomem *) AR5K_AR5312_ENABLE);
 	}
 
-	ath5k_deinit_softc(sc);
+	ath5k_deinit_ah(ah);
 	platform_set_drvdata(pdev, NULL);
 	ieee80211_free_hw(hw);
 
diff --git a/drivers/net/wireless/ath/ath5k/ani.c b/drivers/net/wireless/ath/ath5k/ani.c
index 2f0b967..603ae15 100644
--- a/drivers/net/wireless/ath/ath5k/ani.c
+++ b/drivers/net/wireless/ath/ath5k/ani.c
@@ -74,7 +74,7 @@ ath5k_ani_set_noise_immunity_level(struct ath5k_hw *ah, int level)
 	static const s8 fr[] = { -78, -80 };
 #endif
 	if (level < 0 || level >= ARRAY_SIZE(sz)) {
-		ATH5K_ERR(ah->ah_sc, "noise immunity level %d out of range",
+		ATH5K_ERR(ah, "noise immunity level %d out of range",
 			  level);
 		return;
 	}
@@ -88,8 +88,8 @@ ath5k_ani_set_noise_immunity_level(struct ath5k_hw *ah, int level)
 	AR5K_REG_WRITE_BITS(ah, AR5K_PHY_SIG,
 				AR5K_PHY_SIG_FIRPWR, fr[level]);
 
-	ah->ah_sc->ani_state.noise_imm_level = level;
-	ATH5K_DBG_UNLIMIT(ah->ah_sc, ATH5K_DEBUG_ANI, "new level %d", level);
+	ah->ani_state.noise_imm_level = level;
+	ATH5K_DBG_UNLIMIT(ah, ATH5K_DEBUG_ANI, "new level %d", level);
 }
 
 
@@ -105,8 +105,8 @@ ath5k_ani_set_spur_immunity_level(struct ath5k_hw *ah, int level)
 	static const int val[] = { 2, 4, 6, 8, 10, 12, 14, 16 };
 
 	if (level < 0 || level >= ARRAY_SIZE(val) ||
-	    level > ah->ah_sc->ani_state.max_spur_level) {
-		ATH5K_ERR(ah->ah_sc, "spur immunity level %d out of range",
+	    level > ah->ani_state.max_spur_level) {
+		ATH5K_ERR(ah, "spur immunity level %d out of range",
 			  level);
 		return;
 	}
@@ -114,8 +114,8 @@ ath5k_ani_set_spur_immunity_level(struct ath5k_hw *ah, int level)
 	AR5K_REG_WRITE_BITS(ah, AR5K_PHY_OFDM_SELFCORR,
 		AR5K_PHY_OFDM_SELFCORR_CYPWR_THR1, val[level]);
 
-	ah->ah_sc->ani_state.spur_level = level;
-	ATH5K_DBG_UNLIMIT(ah->ah_sc, ATH5K_DEBUG_ANI, "new level %d", level);
+	ah->ani_state.spur_level = level;
+	ATH5K_DBG_UNLIMIT(ah, ATH5K_DEBUG_ANI, "new level %d", level);
 }
 
 
@@ -130,15 +130,15 @@ ath5k_ani_set_firstep_level(struct ath5k_hw *ah, int level)
 	static const int val[] = { 0, 4, 8 };
 
 	if (level < 0 || level >= ARRAY_SIZE(val)) {
-		ATH5K_ERR(ah->ah_sc, "firstep level %d out of range", level);
+		ATH5K_ERR(ah, "firstep level %d out of range", level);
 		return;
 	}
 
 	AR5K_REG_WRITE_BITS(ah, AR5K_PHY_SIG,
 				AR5K_PHY_SIG_FIRSTEP, val[level]);
 
-	ah->ah_sc->ani_state.firstep_level = level;
-	ATH5K_DBG_UNLIMIT(ah->ah_sc, ATH5K_DEBUG_ANI, "new level %d", level);
+	ah->ani_state.firstep_level = level;
+	ATH5K_DBG_UNLIMIT(ah, ATH5K_DEBUG_ANI, "new level %d", level);
 }
 
 
@@ -178,8 +178,8 @@ ath5k_ani_set_ofdm_weak_signal_detection(struct ath5k_hw *ah, bool on)
 		AR5K_REG_DISABLE_BITS(ah, AR5K_PHY_WEAK_OFDM_LOW_THR,
 				AR5K_PHY_WEAK_OFDM_LOW_THR_SELFCOR_EN);
 
-	ah->ah_sc->ani_state.ofdm_weak_sig = on;
-	ATH5K_DBG_UNLIMIT(ah->ah_sc, ATH5K_DEBUG_ANI, "turned %s",
+	ah->ani_state.ofdm_weak_sig = on;
+	ATH5K_DBG_UNLIMIT(ah, ATH5K_DEBUG_ANI, "turned %s",
 			  on ? "on" : "off");
 }
 
@@ -195,8 +195,8 @@ ath5k_ani_set_cck_weak_signal_detection(struct ath5k_hw *ah, bool on)
 	static const int val[] = { 8, 6 };
 	AR5K_REG_WRITE_BITS(ah, AR5K_PHY_CCK_CROSSCORR,
 				AR5K_PHY_CCK_CROSSCORR_WEAK_SIG_THR, val[on]);
-	ah->ah_sc->ani_state.cck_weak_sig = on;
-	ATH5K_DBG_UNLIMIT(ah->ah_sc, ATH5K_DEBUG_ANI, "turned %s",
+	ah->ani_state.cck_weak_sig = on;
+	ATH5K_DBG_UNLIMIT(ah, ATH5K_DEBUG_ANI, "turned %s",
 			  on ? "on" : "off");
 }
 
@@ -218,7 +218,7 @@ ath5k_ani_raise_immunity(struct ath5k_hw *ah, struct ath5k_ani_state *as,
 {
 	int rssi = ewma_read(&ah->ah_beacon_rssi_avg);
 
-	ATH5K_DBG_UNLIMIT(ah->ah_sc, ATH5K_DEBUG_ANI, "raise immunity (%s)",
+	ATH5K_DBG_UNLIMIT(ah, ATH5K_DEBUG_ANI, "raise immunity (%s)",
 		ofdm_trigger ? "ODFM" : "CCK");
 
 	/* first: raise noise immunity */
@@ -229,13 +229,13 @@ ath5k_ani_raise_immunity(struct ath5k_hw *ah, struct ath5k_ani_state *as,
 
 	/* only OFDM: raise spur immunity level */
 	if (ofdm_trigger &&
-	    as->spur_level < ah->ah_sc->ani_state.max_spur_level) {
+	    as->spur_level < ah->ani_state.max_spur_level) {
 		ath5k_ani_set_spur_immunity_level(ah, as->spur_level + 1);
 		return;
 	}
 
 	/* AP mode */
-	if (ah->ah_sc->opmode == NL80211_IFTYPE_AP) {
+	if (ah->opmode == NL80211_IFTYPE_AP) {
 		if (as->firstep_level < ATH5K_ANI_MAX_FIRSTEP_LVL)
 			ath5k_ani_set_firstep_level(ah, as->firstep_level + 1);
 		return;
@@ -248,7 +248,7 @@ ath5k_ani_raise_immunity(struct ath5k_hw *ah, struct ath5k_ani_state *as,
 	 * don't shut out a remote node by raising immunity too high. */
 
 	if (rssi > ATH5K_ANI_RSSI_THR_HIGH) {
-		ATH5K_DBG_UNLIMIT(ah->ah_sc, ATH5K_DEBUG_ANI,
+		ATH5K_DBG_UNLIMIT(ah, ATH5K_DEBUG_ANI,
 				  "beacon RSSI high");
 		/* only OFDM: beacon RSSI is high, we can disable ODFM weak
 		 * signal detection */
@@ -265,7 +265,7 @@ ath5k_ani_raise_immunity(struct ath5k_hw *ah, struct ath5k_ani_state *as,
 	} else if (rssi > ATH5K_ANI_RSSI_THR_LOW) {
 		/* beacon RSSI in mid range, we need OFDM weak signal detect,
 		 * but can raise firstep level */
-		ATH5K_DBG_UNLIMIT(ah->ah_sc, ATH5K_DEBUG_ANI,
+		ATH5K_DBG_UNLIMIT(ah, ATH5K_DEBUG_ANI,
 				  "beacon RSSI mid");
 		if (ofdm_trigger && as->ofdm_weak_sig == false)
 			ath5k_ani_set_ofdm_weak_signal_detection(ah, true);
@@ -275,7 +275,7 @@ ath5k_ani_raise_immunity(struct ath5k_hw *ah, struct ath5k_ani_state *as,
 	} else if (ah->ah_current_channel->band == IEEE80211_BAND_2GHZ) {
 		/* beacon RSSI is low. in B/G mode turn of OFDM weak signal
 		 * detect and zero firstep level to maximize CCK sensitivity */
-		ATH5K_DBG_UNLIMIT(ah->ah_sc, ATH5K_DEBUG_ANI,
+		ATH5K_DBG_UNLIMIT(ah, ATH5K_DEBUG_ANI,
 				  "beacon RSSI low, 2GHz");
 		if (ofdm_trigger && as->ofdm_weak_sig == true)
 			ath5k_ani_set_ofdm_weak_signal_detection(ah, false);
@@ -303,9 +303,9 @@ ath5k_ani_lower_immunity(struct ath5k_hw *ah, struct ath5k_ani_state *as)
 {
 	int rssi = ewma_read(&ah->ah_beacon_rssi_avg);
 
-	ATH5K_DBG_UNLIMIT(ah->ah_sc, ATH5K_DEBUG_ANI, "lower immunity");
+	ATH5K_DBG_UNLIMIT(ah, ATH5K_DEBUG_ANI, "lower immunity");
 
-	if (ah->ah_sc->opmode == NL80211_IFTYPE_AP) {
+	if (ah->opmode == NL80211_IFTYPE_AP) {
 		/* AP mode */
 		if (as->firstep_level > 0) {
 			ath5k_ani_set_firstep_level(ah, as->firstep_level - 1);
@@ -464,7 +464,7 @@ ath5k_ani_period_restart(struct ath5k_hw *ah, struct ath5k_ani_state *as)
 void
 ath5k_ani_calibration(struct ath5k_hw *ah)
 {
-	struct ath5k_ani_state *as = &ah->ah_sc->ani_state;
+	struct ath5k_ani_state *as = &ah->ani_state;
 	int listen, ofdm_high, ofdm_low, cck_high, cck_low;
 
 	/* get listen time since last call and add it to the counter because we
@@ -483,9 +483,9 @@ ath5k_ani_calibration(struct ath5k_hw *ah)
 	ofdm_low = as->listen_time * ATH5K_ANI_OFDM_TRIG_LOW / 1000;
 	cck_low = as->listen_time * ATH5K_ANI_CCK_TRIG_LOW / 1000;
 
-	ATH5K_DBG_UNLIMIT(ah->ah_sc, ATH5K_DEBUG_ANI,
+	ATH5K_DBG_UNLIMIT(ah, ATH5K_DEBUG_ANI,
 		"listen %d (now %d)", as->listen_time, listen);
-	ATH5K_DBG_UNLIMIT(ah->ah_sc, ATH5K_DEBUG_ANI,
+	ATH5K_DBG_UNLIMIT(ah, ATH5K_DEBUG_ANI,
 		"check high ofdm %d/%d cck %d/%d",
 		as->ofdm_errors, ofdm_high, as->cck_errors, cck_high);
 
@@ -498,7 +498,7 @@ ath5k_ani_calibration(struct ath5k_hw *ah)
 	} else if (as->listen_time > 5 * ATH5K_ANI_LISTEN_PERIOD) {
 		/* If more than 5 (TODO: why 5?) periods have passed and we got
 		 * relatively little errors we can try to lower immunity */
-		ATH5K_DBG_UNLIMIT(ah->ah_sc, ATH5K_DEBUG_ANI,
+		ATH5K_DBG_UNLIMIT(ah, ATH5K_DEBUG_ANI,
 			"check low ofdm %d/%d cck %d/%d",
 			as->ofdm_errors, ofdm_low, as->cck_errors, cck_low);
 
@@ -525,7 +525,7 @@ ath5k_ani_calibration(struct ath5k_hw *ah)
 void
 ath5k_ani_mib_intr(struct ath5k_hw *ah)
 {
-	struct ath5k_ani_state *as = &ah->ah_sc->ani_state;
+	struct ath5k_ani_state *as = &ah->ani_state;
 
 	/* nothing to do here if HW does not have PHY error counters - they
 	 * can't be the reason for the MIB interrupt then */
@@ -536,7 +536,7 @@ ath5k_ani_mib_intr(struct ath5k_hw *ah)
 	ath5k_hw_reg_write(ah, 0, AR5K_OFDM_FIL_CNT);
 	ath5k_hw_reg_write(ah, 0, AR5K_CCK_FIL_CNT);
 
-	if (ah->ah_sc->ani_state.ani_mode != ATH5K_ANI_MODE_AUTO)
+	if (ah->ani_state.ani_mode != ATH5K_ANI_MODE_AUTO)
 		return;
 
 	/* If one of the errors triggered, we can get a superfluous second
@@ -547,7 +547,7 @@ ath5k_ani_mib_intr(struct ath5k_hw *ah)
 
 	if (as->ofdm_errors > ATH5K_ANI_OFDM_TRIG_HIGH ||
 	    as->cck_errors > ATH5K_ANI_CCK_TRIG_HIGH)
-		tasklet_schedule(&ah->ah_sc->ani_tasklet);
+		tasklet_schedule(&ah->ani_tasklet);
 }
 
 
@@ -561,16 +561,16 @@ void
 ath5k_ani_phy_error_report(struct ath5k_hw *ah,
 			   enum ath5k_phy_error_code phyerr)
 {
-	struct ath5k_ani_state *as = &ah->ah_sc->ani_state;
+	struct ath5k_ani_state *as = &ah->ani_state;
 
 	if (phyerr == AR5K_RX_PHY_ERROR_OFDM_TIMING) {
 		as->ofdm_errors++;
 		if (as->ofdm_errors > ATH5K_ANI_OFDM_TRIG_HIGH)
-			tasklet_schedule(&ah->ah_sc->ani_tasklet);
+			tasklet_schedule(&ah->ani_tasklet);
 	} else if (phyerr == AR5K_RX_PHY_ERROR_CCK_TIMING) {
 		as->cck_errors++;
 		if (as->cck_errors > ATH5K_ANI_CCK_TRIG_HIGH)
-			tasklet_schedule(&ah->ah_sc->ani_tasklet);
+			tasklet_schedule(&ah->ani_tasklet);
 	}
 }
 
@@ -631,24 +631,24 @@ ath5k_ani_init(struct ath5k_hw *ah, enum ath5k_ani_mode mode)
 		return;
 
 	if (mode < ATH5K_ANI_MODE_OFF || mode > ATH5K_ANI_MODE_AUTO) {
-		ATH5K_ERR(ah->ah_sc, "ANI mode %d out of range", mode);
+		ATH5K_ERR(ah, "ANI mode %d out of range", mode);
 		return;
 	}
 
 	/* clear old state information */
-	memset(&ah->ah_sc->ani_state, 0, sizeof(ah->ah_sc->ani_state));
+	memset(&ah->ani_state, 0, sizeof(ah->ani_state));
 
 	/* older hardware has more spur levels than newer */
 	if (ah->ah_mac_srev < AR5K_SREV_AR2414)
-		ah->ah_sc->ani_state.max_spur_level = 7;
+		ah->ani_state.max_spur_level = 7;
 	else
-		ah->ah_sc->ani_state.max_spur_level = 2;
+		ah->ani_state.max_spur_level = 2;
 
 	/* initial values for our ani parameters */
 	if (mode == ATH5K_ANI_MODE_OFF) {
-		ATH5K_DBG_UNLIMIT(ah->ah_sc, ATH5K_DEBUG_ANI, "ANI off\n");
+		ATH5K_DBG_UNLIMIT(ah, ATH5K_DEBUG_ANI, "ANI off\n");
 	} else if (mode == ATH5K_ANI_MODE_MANUAL_LOW) {
-		ATH5K_DBG_UNLIMIT(ah->ah_sc, ATH5K_DEBUG_ANI,
+		ATH5K_DBG_UNLIMIT(ah, ATH5K_DEBUG_ANI,
 			"ANI manual low -> high sensitivity\n");
 		ath5k_ani_set_noise_immunity_level(ah, 0);
 		ath5k_ani_set_spur_immunity_level(ah, 0);
@@ -656,17 +656,17 @@ ath5k_ani_init(struct ath5k_hw *ah, enum ath5k_ani_mode mode)
 		ath5k_ani_set_ofdm_weak_signal_detection(ah, true);
 		ath5k_ani_set_cck_weak_signal_detection(ah, true);
 	} else if (mode == ATH5K_ANI_MODE_MANUAL_HIGH) {
-		ATH5K_DBG_UNLIMIT(ah->ah_sc, ATH5K_DEBUG_ANI,
+		ATH5K_DBG_UNLIMIT(ah, ATH5K_DEBUG_ANI,
 			"ANI manual high -> low sensitivity\n");
 		ath5k_ani_set_noise_immunity_level(ah,
 					ATH5K_ANI_MAX_NOISE_IMM_LVL);
 		ath5k_ani_set_spur_immunity_level(ah,
-					ah->ah_sc->ani_state.max_spur_level);
+					ah->ani_state.max_spur_level);
 		ath5k_ani_set_firstep_level(ah, ATH5K_ANI_MAX_FIRSTEP_LVL);
 		ath5k_ani_set_ofdm_weak_signal_detection(ah, false);
 		ath5k_ani_set_cck_weak_signal_detection(ah, false);
 	} else if (mode == ATH5K_ANI_MODE_AUTO) {
-		ATH5K_DBG_UNLIMIT(ah->ah_sc, ATH5K_DEBUG_ANI, "ANI auto\n");
+		ATH5K_DBG_UNLIMIT(ah, ATH5K_DEBUG_ANI, "ANI auto\n");
 		ath5k_ani_set_noise_immunity_level(ah, 0);
 		ath5k_ani_set_spur_immunity_level(ah, 0);
 		ath5k_ani_set_firstep_level(ah, 0);
@@ -692,7 +692,7 @@ ath5k_ani_init(struct ath5k_hw *ah, enum ath5k_ani_mode mode)
 						   ~AR5K_RX_FILTER_PHYERR);
 	}
 
-	ah->ah_sc->ani_state.ani_mode = mode;
+	ah->ani_state.ani_mode = mode;
 }
 
 
diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index 8ff1794..ae16787 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -26,6 +26,11 @@
 #include <linux/io.h>
 #include <linux/types.h>
 #include <linux/average.h>
+#include <linux/leds.h>
+#include <linux/interrupt.h>
+#include <linux/list.h>
+#include <linux/rfkill.h>
+#include <linux/workqueue.h>
 #include <net/mac80211.h>
 
 /* RX/TX descriptor hw structs
@@ -36,7 +41,9 @@
  * TODO: Make a more generic struct (eg. add more stuff to ath5k_capabilities)
  * and clean up common bits, then introduce set/get functions in eeprom.c */
 #include "eeprom.h"
+#include "debug.h"
 #include "../ath.h"
+#include "ani.h"
 
 /* PCI IDs */
 #define PCI_DEVICE_ID_ATHEROS_AR5210		0x0007 /* AR5210 */
@@ -538,6 +545,27 @@ enum ath5k_tx_queue_id {
 #define AR5K_TXQ_FLAG_COMPRESSION_ENABLE	0x2000	/* Enable hw compression -not implemented-*/
 
 /*
+ * Data transmit queue state.  One of these exists for each
+ * hardware transmit queue.  Packets sent to us from above
+ * are assigned to queues based on their priority.  Not all
+ * devices support a complete set of hardware transmit queues.
+ * For those devices the array sc_ac2q will map multiple
+ * priorities to fewer hardware queues (typically all to one
+ * hardware queue).
+ */
+struct ath5k_txq {
+	unsigned int		qnum;	/* hardware q number */
+	u32			*link;	/* link ptr in last TX desc */
+	struct list_head	q;	/* transmit queue */
+	spinlock_t		lock;	/* lock on q and link */
+	bool			setup;
+	int			txq_len; /* number of queued buffers */
+	int			txq_max; /* max allowed num of queued buffers */
+	bool			txq_poll_mark;
+	unsigned int		txq_stuck;	/* informational counter */
+};
+
+/*
  * A struct to hold tx queue's parameters
  */
 struct ath5k_txq_info {
@@ -1027,9 +1055,66 @@ struct ath5k_avg_val {
 	int avg_weight;
 };
 
-/***************************************\
-  HARDWARE ABSTRACTION LAYER STRUCTURE
-\***************************************/
+#define ATH5K_LED_MAX_NAME_LEN 31
+
+/*
+ * State for LED triggers
+ */
+struct ath5k_led {
+	char name[ATH5K_LED_MAX_NAME_LEN + 1];	/* name of the LED in sysfs */
+	struct ath5k_hw *ah;			/* driver state */
+	struct led_classdev led_dev;		/* led classdev */
+};
+
+/* Rfkill */
+struct ath5k_rfkill {
+	/* GPIO PIN for rfkill */
+	u16 gpio;
+	/* polarity of rfkill GPIO PIN */
+	bool polarity;
+	/* RFKILL toggle tasklet */
+	struct tasklet_struct toggleq;
+};
+
+/* statistics */
+struct ath5k_statistics {
+	/* antenna use */
+	unsigned int antenna_rx[5];	/* frames count per antenna RX */
+	unsigned int antenna_tx[5];	/* frames count per antenna TX */
+
+	/* frame errors */
+	unsigned int rx_all_count;	/* all RX frames, including errors */
+	unsigned int tx_all_count;	/* all TX frames, including errors */
+	unsigned int rx_bytes_count;	/* all RX bytes, including errored pkts
+					 * and the MAC headers for each packet
+					 */
+	unsigned int tx_bytes_count;	/* all TX bytes, including errored pkts
+					 * and the MAC headers and padding for
+					 * each packet.
+					 */
+	unsigned int rxerr_crc;
+	unsigned int rxerr_phy;
+	unsigned int rxerr_phy_code[32];
+	unsigned int rxerr_fifo;
+	unsigned int rxerr_decrypt;
+	unsigned int rxerr_mic;
+	unsigned int rxerr_proc;
+	unsigned int rxerr_jumbo;
+	unsigned int txerr_retry;
+	unsigned int txerr_fifo;
+	unsigned int txerr_filt;
+
+	/* MIB counters */
+	unsigned int ack_fail;
+	unsigned int rts_fail;
+	unsigned int rts_ok;
+	unsigned int fcs_error;
+	unsigned int beacons;
+
+	unsigned int mib_intr;
+	unsigned int rxorn_intr;
+	unsigned int rxeol_intr;
+};
 
 /*
  * Misc defines
@@ -1038,12 +1123,114 @@ struct ath5k_avg_val {
 #define AR5K_MAX_GPIO		10
 #define AR5K_MAX_RF_BANKS	8
 
-/* TODO: Clean up and merge with ath5k_softc */
+#if CHAN_DEBUG
+#define ATH_CHAN_MAX	(26 + 26 + 26 + 200 + 200)
+#else
+#define ATH_CHAN_MAX	(14 + 14 + 14 + 252 + 20)
+#endif
+
+#define	ATH_RXBUF	40		/* number of RX buffers */
+#define	ATH_TXBUF	200		/* number of TX buffers */
+#define ATH_BCBUF	4		/* number of beacon buffers */
+#define ATH5K_TXQ_LEN_MAX	(ATH_TXBUF / 4)		/* bufs per queue */
+#define ATH5K_TXQ_LEN_LOW	(ATH5K_TXQ_LEN_MAX / 2)	/* low mark */
+
+/* Driver state associated with an instance of a device */
 struct ath5k_hw {
 	struct ath_common       common;
 
-	struct ath5k_softc	*ah_sc;
-	void __iomem		*ah_iobase;
+	struct pci_dev		*pdev;
+	struct device		*dev;		/* for dma mapping */
+	int irq;
+	u16 devid;
+	void __iomem		*iobase;	/* address of the device */
+	struct mutex		lock;		/* dev-level lock */
+	struct ieee80211_hw	*hw;		/* IEEE 802.11 common */
+	struct ieee80211_supported_band sbands[IEEE80211_NUM_BANDS];
+	struct ieee80211_channel channels[ATH_CHAN_MAX];
+	struct ieee80211_rate	rates[IEEE80211_NUM_BANDS][AR5K_MAX_RATES];
+	s8			rate_idx[IEEE80211_NUM_BANDS][AR5K_MAX_RATES];
+	enum nl80211_iftype	opmode;
+
+#ifdef CONFIG_ATH5K_DEBUG
+	struct ath5k_dbg_info	debug;		/* debug info */
+#endif /* CONFIG_ATH5K_DEBUG */
+
+	struct ath5k_buf	*bufptr;	/* allocated buffer ptr */
+	struct ath5k_desc	*desc;		/* TX/RX descriptors */
+	dma_addr_t		desc_daddr;	/* DMA (physical) address */
+	size_t			desc_len;	/* size of TX/RX descriptors */
+
+	DECLARE_BITMAP(status, 6);
+#define ATH_STAT_INVALID	0		/* disable hardware accesses */
+#define ATH_STAT_MRRETRY	1		/* multi-rate retry support */
+#define ATH_STAT_PROMISC	2
+#define ATH_STAT_LEDSOFT	3		/* enable LED gpio status */
+#define ATH_STAT_STARTED	4		/* opened & irqs enabled */
+#define ATH_STAT_2G_DISABLED	5		/* multiband radio without 2G */
+
+	unsigned int		filter_flags;	/* HW flags, AR5K_RX_FILTER_* */
+	struct ieee80211_channel *curchan;	/* current h/w channel */
+
+	u16			nvifs;
+
+	enum ath5k_int		imask;		/* interrupt mask copy */
+
+	spinlock_t		irqlock;
+	bool			rx_pending;	/* rx tasklet pending */
+	bool			tx_pending;	/* tx tasklet pending */
+
+	u8			lladdr[ETH_ALEN];
+	u8			bssidmask[ETH_ALEN];
+
+	unsigned int		led_pin,	/* GPIO pin for driving LED */
+				led_on;		/* pin setting for LED on */
+
+	struct work_struct	reset_work;	/* deferred chip reset */
+
+	unsigned int		rxbufsize;	/* rx size based on mtu */
+	struct list_head	rxbuf;		/* receive buffer */
+	spinlock_t		rxbuflock;
+	u32			*rxlink;	/* link ptr in last RX desc */
+	struct tasklet_struct	rxtq;		/* rx intr tasklet */
+	struct ath5k_led	rx_led;		/* rx led */
+
+	struct list_head	txbuf;		/* transmit buffer */
+	spinlock_t		txbuflock;
+	unsigned int		txbuf_len;	/* buf count in txbuf list */
+	struct ath5k_txq	txqs[AR5K_NUM_TX_QUEUES];	/* tx queues */
+	struct tasklet_struct	txtq;		/* tx intr tasklet */
+	struct ath5k_led	tx_led;		/* tx led */
+
+	struct ath5k_rfkill	rf_kill;
+
+	struct tasklet_struct	calib;		/* calibration tasklet */
+
+	spinlock_t		block;		/* protects beacon */
+	struct tasklet_struct	beacontq;	/* beacon intr tasklet */
+	struct list_head	bcbuf;		/* beacon buffer */
+	struct ieee80211_vif	*bslot[ATH_BCBUF];
+	u16			num_ap_vifs;
+	u16			num_adhoc_vifs;
+	unsigned int		bhalq,		/* SW q for outgoing beacons */
+				bmisscount,	/* missed beacon transmits */
+				bintval,	/* beacon interval in TU */
+				bsent;
+	unsigned int		nexttbtt;	/* next beacon time in TU */
+	struct ath5k_txq	*cabq;		/* content after beacon */
+
+	int			power_level;	/* Requested tx power in dBm */
+	bool			assoc;		/* associate state */
+	bool			enable_beacon;	/* true if beacons are on */
+
+	struct ath5k_statistics	stats;
+
+	struct ath5k_ani_state	ani_state;
+	struct tasklet_struct	ani_tasklet;	/* ANI calibration */
+
+	struct delayed_work	tx_complete_work;
+
+	struct survey_info	survey;		/* collected survey info */
 
 	enum ath5k_int		ah_imr;
 
@@ -1172,43 +1359,43 @@ struct ath_bus_ops {
 extern const struct ieee80211_ops ath5k_hw_ops;
 
 /* Initialization and detach functions */
-int ath5k_init_softc(struct ath5k_softc *sc, const struct ath_bus_ops *bus_ops);
-void ath5k_deinit_softc(struct ath5k_softc *sc);
-int ath5k_hw_init(struct ath5k_softc *sc);
+int ath5k_init_ah(struct ath5k_hw *ah, const struct ath_bus_ops *bus_ops);
+void ath5k_deinit_ah(struct ath5k_hw *ah);
+int ath5k_hw_init(struct ath5k_hw *ah);
 void ath5k_hw_deinit(struct ath5k_hw *ah);
 
-int ath5k_sysfs_register(struct ath5k_softc *sc);
-void ath5k_sysfs_unregister(struct ath5k_softc *sc);
+int ath5k_sysfs_register(struct ath5k_hw *ah);
+void ath5k_sysfs_unregister(struct ath5k_hw *ah);
 
 /* base.c */
 struct ath5k_buf;
 struct ath5k_txq;
 
 void ath5k_set_beacon_filter(struct ieee80211_hw *hw, bool enable);
-bool ath5k_any_vif_assoc(struct ath5k_softc *sc);
+bool ath5k_any_vif_assoc(struct ath5k_hw *ah);
 void ath5k_tx_queue(struct ieee80211_hw *hw, struct sk_buff *skb,
 		    struct ath5k_txq *txq);
-int ath5k_init_hw(struct ath5k_softc *sc);
-int ath5k_stop_hw(struct ath5k_softc *sc);
-void ath5k_mode_setup(struct ath5k_softc *sc, struct ieee80211_vif *vif);
-void ath5k_update_bssid_mask_and_opmode(struct ath5k_softc *sc,
+int ath5k_init_hw(struct ath5k_hw *ah);
+int ath5k_stop_hw(struct ath5k_hw *ah);
+void ath5k_mode_setup(struct ath5k_hw *ah, struct ieee80211_vif *vif);
+void ath5k_update_bssid_mask_and_opmode(struct ath5k_hw *ah,
 					struct ieee80211_vif *vif);
-int ath5k_chan_set(struct ath5k_softc *sc, struct ieee80211_channel *chan);
-void ath5k_beacon_update_timers(struct ath5k_softc *sc, u64 bc_tsf);
+int ath5k_chan_set(struct ath5k_hw *ah, struct ieee80211_channel *chan);
+void ath5k_beacon_update_timers(struct ath5k_hw *ah, u64 bc_tsf);
 int ath5k_beacon_update(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
-void ath5k_beacon_config(struct ath5k_softc *sc);
-void ath5k_txbuf_free_skb(struct ath5k_softc *sc, struct ath5k_buf *bf);
-void ath5k_rxbuf_free_skb(struct ath5k_softc *sc, struct ath5k_buf *bf);
+void ath5k_beacon_config(struct ath5k_hw *ah);
+void ath5k_txbuf_free_skb(struct ath5k_hw *ah, struct ath5k_buf *bf);
+void ath5k_rxbuf_free_skb(struct ath5k_hw *ah, struct ath5k_buf *bf);
 
 /*Chip id helper functions */
 const char *ath5k_chip_name(enum ath5k_srev_type type, u_int16_t val);
 int ath5k_hw_read_srev(struct ath5k_hw *ah);
 
 /* LED functions */
-int ath5k_init_leds(struct ath5k_softc *sc);
-void ath5k_led_enable(struct ath5k_softc *sc);
-void ath5k_led_off(struct ath5k_softc *sc);
-void ath5k_unregister_leds(struct ath5k_softc *sc);
+int ath5k_init_leds(struct ath5k_hw *ah);
+void ath5k_led_enable(struct ath5k_hw *ah);
+void ath5k_led_off(struct ath5k_hw *ah);
+void ath5k_unregister_leds(struct ath5k_hw *ah);
 
 
 /* Reset Functions */
@@ -1384,7 +1571,7 @@ static inline void __iomem *ath5k_ahb_reg(struct ath5k_hw *ah, u16 reg)
 	    (ah->ah_mac_srev >= AR5K_SREV_AR2315_R6)))
 		return AR5K_AR2315_PCI_BASE + reg;
 
-	return ah->ah_iobase + reg;
+	return ah->iobase + reg;
 }
 
 static inline u32 ath5k_hw_reg_read(struct ath5k_hw *ah, u16 reg)
@@ -1401,12 +1588,12 @@ static inline void ath5k_hw_reg_write(struct ath5k_hw *ah, u32 val, u16 reg)
 
 static inline u32 ath5k_hw_reg_read(struct ath5k_hw *ah, u16 reg)
 {
-	return ioread32(ah->ah_iobase + reg);
+	return ioread32(ah->iobase + reg);
 }
 
 static inline void ath5k_hw_reg_write(struct ath5k_hw *ah, u32 val, u16 reg)
 {
-	iowrite32(val, ah->ah_iobase + reg);
+	iowrite32(val, ah->iobase + reg);
 }
 
 #endif
diff --git a/drivers/net/wireless/ath/ath5k/attach.c b/drivers/net/wireless/ath/ath5k/attach.c
index 14dc52e..58bf8d0 100644
--- a/drivers/net/wireless/ath/ath5k/attach.c
+++ b/drivers/net/wireless/ath/ath5k/attach.c
@@ -59,7 +59,7 @@ static int ath5k_hw_post(struct ath5k_hw *ah)
 			cur_val = ath5k_hw_reg_read(ah, cur_reg);
 
 			if (cur_val != var_pattern) {
-				ATH5K_ERR(ah->ah_sc, "POST Failed !!!\n");
+				ATH5K_ERR(ah, "POST Failed !!!\n");
 				return -EAGAIN;
 			}
 
@@ -74,7 +74,7 @@ static int ath5k_hw_post(struct ath5k_hw *ah)
 			cur_val = ath5k_hw_reg_read(ah, cur_reg);
 
 			if (cur_val != var_pattern) {
-				ATH5K_ERR(ah->ah_sc, "POST Failed !!!\n");
+				ATH5K_ERR(ah, "POST Failed !!!\n");
 				return -EAGAIN;
 			}
 
@@ -95,19 +95,18 @@ static int ath5k_hw_post(struct ath5k_hw *ah)
 /**
  * ath5k_hw_init - Check if hw is supported and init the needed structs
  *
- * @sc: The &struct ath5k_softc we got from the driver's init_softc function
+ * @ah: The &struct ath5k_hw we got from the driver's init_ah function
  *
  * Check if the device is supported, perform a POST and initialize the needed
  * structs. Returns -ENOMEM if we don't have memory for the needed structs,
  * -ENODEV if the device is not supported or prints an error msg if something
  * else went wrong.
  */
-int ath5k_hw_init(struct ath5k_softc *sc)
+int ath5k_hw_init(struct ath5k_hw *ah)
 {
 	static const u8 zero_mac[ETH_ALEN] = { };
-	struct ath5k_hw *ah = sc->ah;
 	struct ath_common *common = ath5k_hw_common(ah);
-	struct pci_dev *pdev = sc->pdev;
+	struct pci_dev *pdev = ah->pdev;
 	struct ath5k_eeprom_info *ee;
 	int ret;
 	u32 srev;
@@ -123,8 +122,8 @@ int ath5k_hw_init(struct ath5k_softc *sc)
 	ah->ah_retry_long = AR5K_INIT_RETRY_LONG;
 	ah->ah_ant_mode = AR5K_ANTMODE_DEFAULT;
 	ah->ah_noise_floor = -95;	/* until first NF calibration is run */
-	sc->ani_state.ani_mode = ATH5K_ANI_MODE_AUTO;
-	ah->ah_current_channel = &sc->channels[0];
+	ah->ani_state.ani_mode = ATH5K_ANI_MODE_AUTO;
+	ah->ah_current_channel = &ah->channels[0];
 
 	/*
 	 * Find the mac version
@@ -237,7 +236,7 @@ int ath5k_hw_init(struct ath5k_softc *sc)
 			ah->ah_single_chip = true;
 			ah->ah_radio_5ghz_revision = AR5K_SREV_RAD_2413;
 		} else {
-			ATH5K_ERR(sc, "Couldn't identify radio revision.\n");
+			ATH5K_ERR(ah, "Couldn't identify radio revision.\n");
 			ret = -ENODEV;
 			goto err;
 		}
@@ -246,7 +245,7 @@ int ath5k_hw_init(struct ath5k_softc *sc)
 
 	/* Return on unsupported chips (unsupported eeprom etc) */
 	if ((srev >= AR5K_SREV_AR5416) && (srev < AR5K_SREV_AR2425)) {
-		ATH5K_ERR(sc, "Device not yet supported.\n");
+		ATH5K_ERR(ah, "Device not yet supported.\n");
 		ret = -ENODEV;
 		goto err;
 	}
@@ -268,7 +267,7 @@ int ath5k_hw_init(struct ath5k_softc *sc)
 	 */
 	ret = ath5k_eeprom_init(ah);
 	if (ret) {
-		ATH5K_ERR(sc, "unable to init EEPROM\n");
+		ATH5K_ERR(ah, "unable to init EEPROM\n");
 		goto err;
 	}
 
@@ -309,17 +308,17 @@ int ath5k_hw_init(struct ath5k_softc *sc)
 	/* Get misc capabilities */
 	ret = ath5k_hw_set_capabilities(ah);
 	if (ret) {
-		ATH5K_ERR(sc, "unable to get device capabilities\n");
+		ATH5K_ERR(ah, "unable to get device capabilities\n");
 		goto err;
 	}
 
-	if (test_bit(ATH_STAT_2G_DISABLED, sc->status)) {
+	if (test_bit(ATH_STAT_2G_DISABLED, ah->status)) {
 		__clear_bit(AR5K_MODE_11B, ah->ah_capabilities.cap_mode);
 		__clear_bit(AR5K_MODE_11G, ah->ah_capabilities.cap_mode);
 	}
 
 	/* Crypto settings */
-	common->keymax = (sc->ah->ah_version == AR5K_AR5210 ?
+	common->keymax = (ah->ah_version == AR5K_AR5210 ?
 			  AR5K_KEYTABLE_SIZE_5210 : AR5K_KEYTABLE_SIZE_5211);
 
 	if (srev >= AR5K_SREV_AR5212_V4 &&
@@ -339,7 +338,7 @@ int ath5k_hw_init(struct ath5k_softc *sc)
 	/* Set BSSID to bcast address: ff:ff:ff:ff:ff:ff for now */
 	memcpy(common->curbssid, ath_bcast_mac, ETH_ALEN);
 	ath5k_hw_set_bssid(ah);
-	ath5k_hw_set_opmode(ah, sc->opmode);
+	ath5k_hw_set_opmode(ah, ah->opmode);
 
 	ath5k_hw_rfgain_opt_init(ah);
 
@@ -360,7 +359,7 @@ err:
  */
 void ath5k_hw_deinit(struct ath5k_hw *ah)
 {
-	__set_bit(ATH_STAT_INVALID, ah->ah_sc->status);
+	__set_bit(ATH_STAT_INVALID, ah->status);
 
 	if (ah->ah_rf_banks != NULL)
 		kfree(ah->ah_rf_banks);
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 5f055d6..9979d15 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -85,7 +85,7 @@ MODULE_SUPPORTED_DEVICE("Atheros 5xxx WLAN cards");
 MODULE_LICENSE("Dual BSD/GPL");
 
 static int ath5k_init(struct ieee80211_hw *hw);
-static int ath5k_reset(struct ath5k_softc *sc, struct ieee80211_channel *chan,
+static int ath5k_reset(struct ath5k_hw *ah, struct ieee80211_channel *chan,
 								bool skip_pcu);
 
 /* Known SREVs */
@@ -237,8 +237,8 @@ static const struct ath_ops ath5k_common_ops = {
 static int ath5k_reg_notifier(struct wiphy *wiphy, struct regulatory_request *request)
 {
 	struct ieee80211_hw *hw = wiphy_to_ieee80211_hw(wiphy);
-	struct ath5k_softc *sc = hw->priv;
-	struct ath_regulatory *regulatory = ath5k_hw_regulatory(sc->ah);
+	struct ath5k_hw *ah = hw->priv;
+	struct ath_regulatory *regulatory = ath5k_hw_regulatory(ah);
 
 	return ath_reg_notifier_apply(wiphy, request, regulatory);
 }
@@ -288,7 +288,7 @@ ath5k_setup_channels(struct ath5k_hw *ah, struct ieee80211_channel *channels,
 		band = IEEE80211_BAND_2GHZ;
 		break;
 	default:
-		ATH5K_WARN(ah->ah_sc, "bad mode, not copying channels\n");
+		ATH5K_WARN(ah, "bad mode, not copying channels\n");
 		return 0;
 	}
 
@@ -326,51 +326,50 @@ ath5k_setup_channels(struct ath5k_hw *ah, struct ieee80211_channel *channels,
 }
 
 static void
-ath5k_setup_rate_idx(struct ath5k_softc *sc, struct ieee80211_supported_band *b)
+ath5k_setup_rate_idx(struct ath5k_hw *ah, struct ieee80211_supported_band *b)
 {
 	u8 i;
 
 	for (i = 0; i < AR5K_MAX_RATES; i++)
-		sc->rate_idx[b->band][i] = -1;
+		ah->rate_idx[b->band][i] = -1;
 
 	for (i = 0; i < b->n_bitrates; i++) {
-		sc->rate_idx[b->band][b->bitrates[i].hw_value] = i;
+		ah->rate_idx[b->band][b->bitrates[i].hw_value] = i;
 		if (b->bitrates[i].hw_value_short)
-			sc->rate_idx[b->band][b->bitrates[i].hw_value_short] = i;
+			ah->rate_idx[b->band][b->bitrates[i].hw_value_short] = i;
 	}
 }
 
 static int
 ath5k_setup_bands(struct ieee80211_hw *hw)
 {
-	struct ath5k_softc *sc = hw->priv;
-	struct ath5k_hw *ah = sc->ah;
+	struct ath5k_hw *ah = hw->priv;
 	struct ieee80211_supported_band *sband;
 	int max_c, count_c = 0;
 	int i;
 
-	BUILD_BUG_ON(ARRAY_SIZE(sc->sbands) < IEEE80211_NUM_BANDS);
-	max_c = ARRAY_SIZE(sc->channels);
+	BUILD_BUG_ON(ARRAY_SIZE(ah->sbands) < IEEE80211_NUM_BANDS);
+	max_c = ARRAY_SIZE(ah->channels);
 
 	/* 2GHz band */
-	sband = &sc->sbands[IEEE80211_BAND_2GHZ];
+	sband = &ah->sbands[IEEE80211_BAND_2GHZ];
 	sband->band = IEEE80211_BAND_2GHZ;
-	sband->bitrates = &sc->rates[IEEE80211_BAND_2GHZ][0];
+	sband->bitrates = &ah->rates[IEEE80211_BAND_2GHZ][0];
 
-	if (test_bit(AR5K_MODE_11G, sc->ah->ah_capabilities.cap_mode)) {
+	if (test_bit(AR5K_MODE_11G, ah->ah_capabilities.cap_mode)) {
 		/* G mode */
 		memcpy(sband->bitrates, &ath5k_rates[0],
 		       sizeof(struct ieee80211_rate) * 12);
 		sband->n_bitrates = 12;
 
-		sband->channels = sc->channels;
+		sband->channels = ah->channels;
 		sband->n_channels = ath5k_setup_channels(ah, sband->channels,
 					AR5K_MODE_11G, max_c);
 
 		hw->wiphy->bands[IEEE80211_BAND_2GHZ] = sband;
 		count_c = sband->n_channels;
 		max_c -= count_c;
-	} else if (test_bit(AR5K_MODE_11B, sc->ah->ah_capabilities.cap_mode)) {
+	} else if (test_bit(AR5K_MODE_11B, ah->ah_capabilities.cap_mode)) {
 		/* B mode */
 		memcpy(sband->bitrates, &ath5k_rates[0],
 		       sizeof(struct ieee80211_rate) * 4);
@@ -389,7 +388,7 @@ ath5k_setup_bands(struct ieee80211_hw *hw)
 			}
 		}
 
-		sband->channels = sc->channels;
+		sband->channels = ah->channels;
 		sband->n_channels = ath5k_setup_channels(ah, sband->channels,
 					AR5K_MODE_11B, max_c);
 
@@ -397,27 +396,27 @@ ath5k_setup_bands(struct ieee80211_hw *hw)
 		count_c = sband->n_channels;
 		max_c -= count_c;
 	}
-	ath5k_setup_rate_idx(sc, sband);
+	ath5k_setup_rate_idx(ah, sband);
 
 	/* 5GHz band, A mode */
-	if (test_bit(AR5K_MODE_11A, sc->ah->ah_capabilities.cap_mode)) {
-		sband = &sc->sbands[IEEE80211_BAND_5GHZ];
+	if (test_bit(AR5K_MODE_11A, ah->ah_capabilities.cap_mode)) {
+		sband = &ah->sbands[IEEE80211_BAND_5GHZ];
 		sband->band = IEEE80211_BAND_5GHZ;
-		sband->bitrates = &sc->rates[IEEE80211_BAND_5GHZ][0];
+		sband->bitrates = &ah->rates[IEEE80211_BAND_5GHZ][0];
 
 		memcpy(sband->bitrates, &ath5k_rates[4],
 		       sizeof(struct ieee80211_rate) * 8);
 		sband->n_bitrates = 8;
 
-		sband->channels = &sc->channels[count_c];
+		sband->channels = &ah->channels[count_c];
 		sband->n_channels = ath5k_setup_channels(ah, sband->channels,
 					AR5K_MODE_11A, max_c);
 
 		hw->wiphy->bands[IEEE80211_BAND_5GHZ] = sband;
 	}
-	ath5k_setup_rate_idx(sc, sband);
+	ath5k_setup_rate_idx(ah, sband);
 
-	ath5k_debug_dump_bands(sc);
+	ath5k_debug_dump_bands(ah);
 
 	return 0;
 }
@@ -427,14 +426,14 @@ ath5k_setup_bands(struct ieee80211_hw *hw)
  * To accomplish this we must first cleanup any pending DMA,
  * then restart stuff after a la  ath5k_init.
  *
- * Called with sc->lock.
+ * Called with ah->lock.
  */
 int
-ath5k_chan_set(struct ath5k_softc *sc, struct ieee80211_channel *chan)
+ath5k_chan_set(struct ath5k_hw *ah, struct ieee80211_channel *chan)
 {
-	ATH5K_DBG(sc, ATH5K_DEBUG_RESET,
+	ATH5K_DBG(ah, ATH5K_DEBUG_RESET,
 		  "channel set, resetting (%u -> %u MHz)\n",
-		  sc->curchan->center_freq, chan->center_freq);
+		  ah->curchan->center_freq, chan->center_freq);
 
 	/*
 	 * To switch channels clear any pending DMA operations;
@@ -442,7 +441,7 @@ ath5k_chan_set(struct ath5k_softc *sc, struct ieee80211_channel *chan)
 	 * hardware at the new frequency, and then re-enable
 	 * the relevant bits of the h/w.
 	 */
-	return ath5k_reset(sc, chan, true);
+	return ath5k_reset(ah, chan, true);
 }
 
 void ath5k_vif_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
@@ -486,10 +485,10 @@ void ath5k_vif_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
 }
 
 void
-ath5k_update_bssid_mask_and_opmode(struct ath5k_softc *sc,
+ath5k_update_bssid_mask_and_opmode(struct ath5k_hw *ah,
 				   struct ieee80211_vif *vif)
 {
-	struct ath_common *common = ath5k_hw_common(sc->ah);
+	struct ath_common *common = ath5k_hw_common(ah);
 	struct ath5k_vif_iter_data iter_data;
 	u32 rfilt;
 
@@ -508,24 +507,24 @@ ath5k_update_bssid_mask_and_opmode(struct ath5k_softc *sc,
 		ath5k_vif_iter(&iter_data, vif->addr, vif);
 
 	/* Get list of all active MAC addresses */
-	ieee80211_iterate_active_interfaces_atomic(sc->hw, ath5k_vif_iter,
+	ieee80211_iterate_active_interfaces_atomic(ah->hw, ath5k_vif_iter,
 						   &iter_data);
-	memcpy(sc->bssidmask, iter_data.mask, ETH_ALEN);
+	memcpy(ah->bssidmask, iter_data.mask, ETH_ALEN);
 
-	sc->opmode = iter_data.opmode;
-	if (sc->opmode == NL80211_IFTYPE_UNSPECIFIED)
+	ah->opmode = iter_data.opmode;
+	if (ah->opmode == NL80211_IFTYPE_UNSPECIFIED)
 		/* Nothing active, default to station mode */
-		sc->opmode = NL80211_IFTYPE_STATION;
+		ah->opmode = NL80211_IFTYPE_STATION;
 
-	ath5k_hw_set_opmode(sc->ah, sc->opmode);
-	ATH5K_DBG(sc, ATH5K_DEBUG_MODE, "mode setup opmode %d (%s)\n",
-		  sc->opmode, ath_opmode_to_string(sc->opmode));
+	ath5k_hw_set_opmode(ah, ah->opmode);
+	ATH5K_DBG(ah, ATH5K_DEBUG_MODE, "mode setup opmode %d (%s)\n",
+		  ah->opmode, ath_opmode_to_string(ah->opmode));
 
 	if (iter_data.need_set_hw_addr && iter_data.found_active)
-		ath5k_hw_set_lladdr(sc->ah, iter_data.active_mac);
+		ath5k_hw_set_lladdr(ah, iter_data.active_mac);
 
-	if (ath5k_hw_hasbssidmask(sc->ah))
-		ath5k_hw_set_bssid_mask(sc->ah, sc->bssidmask);
+	if (ath5k_hw_hasbssidmask(ah))
+		ath5k_hw_set_bssid_mask(ah, ah->bssidmask);
 
 	/* Set up RX Filter */
 	if (iter_data.n_stas > 1) {
@@ -533,16 +532,16 @@ ath5k_update_bssid_mask_and_opmode(struct ath5k_softc *sc,
 		 * different APs, ARPs are not received (most of the time?)
 		 * Enabling PROMISC appears to fix that problem.
 		 */
-		sc->filter_flags |= AR5K_RX_FILTER_PROM;
+		ah->filter_flags |= AR5K_RX_FILTER_PROM;
 	}
 
-	rfilt = sc->filter_flags;
-	ath5k_hw_set_rx_filter(sc->ah, rfilt);
-	ATH5K_DBG(sc, ATH5K_DEBUG_MODE, "RX filter 0x%x\n", rfilt);
+	rfilt = ah->filter_flags;
+	ath5k_hw_set_rx_filter(ah, rfilt);
+	ATH5K_DBG(ah, ATH5K_DEBUG_MODE, "RX filter 0x%x\n", rfilt);
 }
 
 static inline int
-ath5k_hw_to_driver_rix(struct ath5k_softc *sc, int hw_rix)
+ath5k_hw_to_driver_rix(struct ath5k_hw *ah, int hw_rix)
 {
 	int rix;
 
@@ -551,7 +550,7 @@ ath5k_hw_to_driver_rix(struct ath5k_softc *sc, int hw_rix)
 			"hw_rix out of bounds: %x\n", hw_rix))
 		return 0;
 
-	rix = sc->rate_idx[sc->curchan->band][hw_rix];
+	rix = ah->rate_idx[ah->curchan->band][hw_rix];
 	if (WARN(rix < 0, "invalid hw_rix: %x\n", hw_rix))
 		rix = 0;
 
@@ -563,9 +562,9 @@ ath5k_hw_to_driver_rix(struct ath5k_softc *sc, int hw_rix)
 \***************/
 
 static
-struct sk_buff *ath5k_rx_skb_alloc(struct ath5k_softc *sc, dma_addr_t *skb_addr)
+struct sk_buff *ath5k_rx_skb_alloc(struct ath5k_hw *ah, dma_addr_t *skb_addr)
 {
-	struct ath_common *common = ath5k_hw_common(sc->ah);
+	struct ath_common *common = ath5k_hw_common(ah);
 	struct sk_buff *skb;
 
 	/*
@@ -577,17 +576,17 @@ struct sk_buff *ath5k_rx_skb_alloc(struct ath5k_softc *sc, dma_addr_t *skb_addr)
 			      GFP_ATOMIC);
 
 	if (!skb) {
-		ATH5K_ERR(sc, "can't alloc skbuff of size %u\n",
+		ATH5K_ERR(ah, "can't alloc skbuff of size %u\n",
 				common->rx_bufsize);
 		return NULL;
 	}
 
-	*skb_addr = dma_map_single(sc->dev,
+	*skb_addr = dma_map_single(ah->dev,
 				   skb->data, common->rx_bufsize,
 				   DMA_FROM_DEVICE);
 
-	if (unlikely(dma_mapping_error(sc->dev, *skb_addr))) {
-		ATH5K_ERR(sc, "%s: DMA mapping failed\n", __func__);
+	if (unlikely(dma_mapping_error(ah->dev, *skb_addr))) {
+		ATH5K_ERR(ah, "%s: DMA mapping failed\n", __func__);
 		dev_kfree_skb(skb);
 		return NULL;
 	}
@@ -595,15 +594,14 @@ struct sk_buff *ath5k_rx_skb_alloc(struct ath5k_softc *sc, dma_addr_t *skb_addr)
 }
 
 static int
-ath5k_rxbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf)
+ath5k_rxbuf_setup(struct ath5k_hw *ah, struct ath5k_buf *bf)
 {
-	struct ath5k_hw *ah = sc->ah;
 	struct sk_buff *skb = bf->skb;
 	struct ath5k_desc *ds;
 	int ret;
 
 	if (!skb) {
-		skb = ath5k_rx_skb_alloc(sc, &bf->skbaddr);
+		skb = ath5k_rx_skb_alloc(ah, &bf->skbaddr);
 		if (!skb)
 			return -ENOMEM;
 		bf->skb = skb;
@@ -629,13 +627,13 @@ ath5k_rxbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf)
 	ds->ds_data = bf->skbaddr;
 	ret = ath5k_hw_setup_rx_desc(ah, ds, ah->common.rx_bufsize, 0);
 	if (ret) {
-		ATH5K_ERR(sc, "%s: could not setup RX desc\n", __func__);
+		ATH5K_ERR(ah, "%s: could not setup RX desc\n", __func__);
 		return ret;
 	}
 
-	if (sc->rxlink != NULL)
-		*sc->rxlink = bf->daddr;
-	sc->rxlink = &ds->ds_link;
+	if (ah->rxlink != NULL)
+		*ah->rxlink = bf->daddr;
+	ah->rxlink = &ds->ds_link;
 	return 0;
 }
 
@@ -663,10 +661,9 @@ static enum ath5k_pkt_type get_hw_packet_type(struct sk_buff *skb)
 }
 
 static int
-ath5k_txbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf,
+ath5k_txbuf_setup(struct ath5k_hw *ah, struct ath5k_buf *bf,
 		  struct ath5k_txq *txq, int padsize)
 {
-	struct ath5k_hw *ah = sc->ah;
 	struct ath5k_desc *ds = bf->desc;
 	struct sk_buff *skb = bf->skb;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
@@ -682,10 +679,10 @@ ath5k_txbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf,
 	flags = AR5K_TXDESC_INTREQ | AR5K_TXDESC_CLRDMASK;
 
 	/* XXX endianness */
-	bf->skbaddr = dma_map_single(sc->dev, skb->data, skb->len,
+	bf->skbaddr = dma_map_single(ah->dev, skb->data, skb->len,
 			DMA_TO_DEVICE);
 
-	rate = ieee80211_get_tx_rate(sc->hw, info);
+	rate = ieee80211_get_tx_rate(ah->hw, info);
 	if (!rate) {
 		ret = -EINVAL;
 		goto err_unmap;
@@ -709,20 +706,20 @@ ath5k_txbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf,
 	}
 	if (rc_flags & IEEE80211_TX_RC_USE_RTS_CTS) {
 		flags |= AR5K_TXDESC_RTSENA;
-		cts_rate = ieee80211_get_rts_cts_rate(sc->hw, info)->hw_value;
-		duration = le16_to_cpu(ieee80211_rts_duration(sc->hw,
+		cts_rate = ieee80211_get_rts_cts_rate(ah->hw, info)->hw_value;
+		duration = le16_to_cpu(ieee80211_rts_duration(ah->hw,
 			info->control.vif, pktlen, info));
 	}
 	if (rc_flags & IEEE80211_TX_RC_USE_CTS_PROTECT) {
 		flags |= AR5K_TXDESC_CTSENA;
-		cts_rate = ieee80211_get_rts_cts_rate(sc->hw, info)->hw_value;
-		duration = le16_to_cpu(ieee80211_ctstoself_duration(sc->hw,
+		cts_rate = ieee80211_get_rts_cts_rate(ah->hw, info)->hw_value;
+		duration = le16_to_cpu(ieee80211_ctstoself_duration(ah->hw,
 			info->control.vif, pktlen, info));
 	}
 	ret = ah->ah_setup_tx_desc(ah, ds, pktlen,
 		ieee80211_get_hdrlen_from_skb(skb), padsize,
 		get_hw_packet_type(skb),
-		(sc->power_level * 2),
+		(ah->power_level * 2),
 		hw_rate,
 		info->control.rates[0].count, keyidx, ah->ah_tx_ant, flags,
 		cts_rate, duration);
@@ -732,7 +729,7 @@ ath5k_txbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf,
 	memset(mrr_rate, 0, sizeof(mrr_rate));
 	memset(mrr_tries, 0, sizeof(mrr_tries));
 	for (i = 0; i < 3; i++) {
-		rate = ieee80211_get_alt_retry_rate(sc->hw, info, i);
+		rate = ieee80211_get_alt_retry_rate(ah->hw, info, i);
 		if (!rate)
 			break;
 
@@ -763,7 +760,7 @@ ath5k_txbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf,
 
 	return 0;
 err_unmap:
-	dma_unmap_single(sc->dev, bf->skbaddr, skb->len, DMA_TO_DEVICE);
+	dma_unmap_single(ah->dev, bf->skbaddr, skb->len, DMA_TO_DEVICE);
 	return ret;
 }
 
@@ -772,7 +769,7 @@ err_unmap:
 \*******************/
 
 static int
-ath5k_desc_alloc(struct ath5k_softc *sc)
+ath5k_desc_alloc(struct ath5k_hw *ah)
 {
 	struct ath5k_desc *ds;
 	struct ath5k_buf *bf;
@@ -781,68 +778,68 @@ ath5k_desc_alloc(struct ath5k_softc *sc)
 	int ret;
 
 	/* allocate descriptors */
-	sc->desc_len = sizeof(struct ath5k_desc) *
+	ah->desc_len = sizeof(struct ath5k_desc) *
 			(ATH_TXBUF + ATH_RXBUF + ATH_BCBUF + 1);
 
-	sc->desc = dma_alloc_coherent(sc->dev, sc->desc_len,
-				&sc->desc_daddr, GFP_KERNEL);
-	if (sc->desc == NULL) {
-		ATH5K_ERR(sc, "can't allocate descriptors\n");
+	ah->desc = dma_alloc_coherent(ah->dev, ah->desc_len,
+				&ah->desc_daddr, GFP_KERNEL);
+	if (ah->desc == NULL) {
+		ATH5K_ERR(ah, "can't allocate descriptors\n");
 		ret = -ENOMEM;
 		goto err;
 	}
-	ds = sc->desc;
-	da = sc->desc_daddr;
-	ATH5K_DBG(sc, ATH5K_DEBUG_ANY, "DMA map: %p (%zu) -> %llx\n",
-		ds, sc->desc_len, (unsigned long long)sc->desc_daddr);
+	ds = ah->desc;
+	da = ah->desc_daddr;
+	ATH5K_DBG(ah, ATH5K_DEBUG_ANY, "DMA map: %p (%zu) -> %llx\n",
+		ds, ah->desc_len, (unsigned long long)ah->desc_daddr);
 
 	bf = kcalloc(1 + ATH_TXBUF + ATH_RXBUF + ATH_BCBUF,
 			sizeof(struct ath5k_buf), GFP_KERNEL);
 	if (bf == NULL) {
-		ATH5K_ERR(sc, "can't allocate bufptr\n");
+		ATH5K_ERR(ah, "can't allocate bufptr\n");
 		ret = -ENOMEM;
 		goto err_free;
 	}
-	sc->bufptr = bf;
+	ah->bufptr = bf;
 
-	INIT_LIST_HEAD(&sc->rxbuf);
+	INIT_LIST_HEAD(&ah->rxbuf);
 	for (i = 0; i < ATH_RXBUF; i++, bf++, ds++, da += sizeof(*ds)) {
 		bf->desc = ds;
 		bf->daddr = da;
-		list_add_tail(&bf->list, &sc->rxbuf);
+		list_add_tail(&bf->list, &ah->rxbuf);
 	}
 
-	INIT_LIST_HEAD(&sc->txbuf);
-	sc->txbuf_len = ATH_TXBUF;
+	INIT_LIST_HEAD(&ah->txbuf);
+	ah->txbuf_len = ATH_TXBUF;
 	for (i = 0; i < ATH_TXBUF; i++, bf++, ds++, da += sizeof(*ds)) {
 		bf->desc = ds;
 		bf->daddr = da;
-		list_add_tail(&bf->list, &sc->txbuf);
+		list_add_tail(&bf->list, &ah->txbuf);
 	}
 
 	/* beacon buffers */
-	INIT_LIST_HEAD(&sc->bcbuf);
+	INIT_LIST_HEAD(&ah->bcbuf);
 	for (i = 0; i < ATH_BCBUF; i++, bf++, ds++, da += sizeof(*ds)) {
 		bf->desc = ds;
 		bf->daddr = da;
-		list_add_tail(&bf->list, &sc->bcbuf);
+		list_add_tail(&bf->list, &ah->bcbuf);
 	}
 
 	return 0;
 err_free:
-	dma_free_coherent(sc->dev, sc->desc_len, sc->desc, sc->desc_daddr);
+	dma_free_coherent(ah->dev, ah->desc_len, ah->desc, ah->desc_daddr);
 err:
-	sc->desc = NULL;
+	ah->desc = NULL;
 	return ret;
 }
 
 void
-ath5k_txbuf_free_skb(struct ath5k_softc *sc, struct ath5k_buf *bf)
+ath5k_txbuf_free_skb(struct ath5k_hw *ah, struct ath5k_buf *bf)
 {
 	BUG_ON(!bf);
 	if (!bf->skb)
 		return;
-	dma_unmap_single(sc->dev, bf->skbaddr, bf->skb->len,
+	dma_unmap_single(ah->dev, bf->skbaddr, bf->skb->len,
 			DMA_TO_DEVICE);
 	dev_kfree_skb_any(bf->skb);
 	bf->skb = NULL;
@@ -851,15 +848,14 @@ ath5k_txbuf_free_skb(struct ath5k_softc *sc, struct ath5k_buf *bf)
 }
 
 void
-ath5k_rxbuf_free_skb(struct ath5k_softc *sc, struct ath5k_buf *bf)
+ath5k_rxbuf_free_skb(struct ath5k_hw *ah, struct ath5k_buf *bf)
 {
-	struct ath5k_hw *ah = sc->ah;
 	struct ath_common *common = ath5k_hw_common(ah);
 
 	BUG_ON(!bf);
 	if (!bf->skb)
 		return;
-	dma_unmap_single(sc->dev, bf->skbaddr, common->rx_bufsize,
+	dma_unmap_single(ah->dev, bf->skbaddr, common->rx_bufsize,
 			DMA_FROM_DEVICE);
 	dev_kfree_skb_any(bf->skb);
 	bf->skb = NULL;
@@ -868,24 +864,24 @@ ath5k_rxbuf_free_skb(struct ath5k_softc *sc, struct ath5k_buf *bf)
 }
 
 static void
-ath5k_desc_free(struct ath5k_softc *sc)
+ath5k_desc_free(struct ath5k_hw *ah)
 {
 	struct ath5k_buf *bf;
 
-	list_for_each_entry(bf, &sc->txbuf, list)
-		ath5k_txbuf_free_skb(sc, bf);
-	list_for_each_entry(bf, &sc->rxbuf, list)
-		ath5k_rxbuf_free_skb(sc, bf);
-	list_for_each_entry(bf, &sc->bcbuf, list)
-		ath5k_txbuf_free_skb(sc, bf);
+	list_for_each_entry(bf, &ah->txbuf, list)
+		ath5k_txbuf_free_skb(ah, bf);
+	list_for_each_entry(bf, &ah->rxbuf, list)
+		ath5k_rxbuf_free_skb(ah, bf);
+	list_for_each_entry(bf, &ah->bcbuf, list)
+		ath5k_txbuf_free_skb(ah, bf);
 
 	/* Free memory associated with all descriptors */
-	dma_free_coherent(sc->dev, sc->desc_len, sc->desc, sc->desc_daddr);
-	sc->desc = NULL;
-	sc->desc_daddr = 0;
+	dma_free_coherent(ah->dev, ah->desc_len, ah->desc, ah->desc_daddr);
+	ah->desc = NULL;
+	ah->desc_daddr = 0;
 
-	kfree(sc->bufptr);
-	sc->bufptr = NULL;
+	kfree(ah->bufptr);
+	ah->bufptr = NULL;
 }
 
 
@@ -894,10 +890,9 @@ ath5k_desc_free(struct ath5k_softc *sc)
 \**************/
 
 static struct ath5k_txq *
-ath5k_txq_setup(struct ath5k_softc *sc,
+ath5k_txq_setup(struct ath5k_hw *ah,
 		int qtype, int subtype)
 {
-	struct ath5k_hw *ah = sc->ah;
 	struct ath5k_txq *txq;
 	struct ath5k_txq_info qi = {
 		.tqi_subtype = subtype,
@@ -931,13 +926,13 @@ ath5k_txq_setup(struct ath5k_softc *sc,
 		 */
 		return ERR_PTR(qnum);
 	}
-	if (qnum >= ARRAY_SIZE(sc->txqs)) {
-		ATH5K_ERR(sc, "hw qnum %u out of range, max %tu!\n",
-			qnum, ARRAY_SIZE(sc->txqs));
+	if (qnum >= ARRAY_SIZE(ah->txqs)) {
+		ATH5K_ERR(ah, "hw qnum %u out of range, max %tu!\n",
+			qnum, ARRAY_SIZE(ah->txqs));
 		ath5k_hw_release_tx_queue(ah, qnum);
 		return ERR_PTR(-EINVAL);
 	}
-	txq = &sc->txqs[qnum];
+	txq = &ah->txqs[qnum];
 	if (!txq->setup) {
 		txq->qnum = qnum;
 		txq->link = NULL;
@@ -949,7 +944,7 @@ ath5k_txq_setup(struct ath5k_softc *sc,
 		txq->txq_poll_mark = false;
 		txq->txq_stuck = 0;
 	}
-	return &sc->txqs[qnum];
+	return &ah->txqs[qnum];
 }
 
 static int
@@ -969,18 +964,17 @@ ath5k_beaconq_setup(struct ath5k_hw *ah)
 }
 
 static int
-ath5k_beaconq_config(struct ath5k_softc *sc)
+ath5k_beaconq_config(struct ath5k_hw *ah)
 {
-	struct ath5k_hw *ah = sc->ah;
 	struct ath5k_txq_info qi;
 	int ret;
 
-	ret = ath5k_hw_get_tx_queueprops(ah, sc->bhalq, &qi);
+	ret = ath5k_hw_get_tx_queueprops(ah, ah->bhalq, &qi);
 	if (ret)
 		goto err;
 
-	if (sc->opmode == NL80211_IFTYPE_AP ||
-	    sc->opmode == NL80211_IFTYPE_MESH_POINT) {
+	if (ah->opmode == NL80211_IFTYPE_AP ||
+	    ah->opmode == NL80211_IFTYPE_MESH_POINT) {
 		/*
 		 * Always burst out beacon and CAB traffic
 		 * (aifs = cwmin = cwmax = 0)
@@ -988,7 +982,7 @@ ath5k_beaconq_config(struct ath5k_softc *sc)
 		qi.tqi_aifs = 0;
 		qi.tqi_cw_min = 0;
 		qi.tqi_cw_max = 0;
-	} else if (sc->opmode == NL80211_IFTYPE_ADHOC) {
+	} else if (ah->opmode == NL80211_IFTYPE_ADHOC) {
 		/*
 		 * Adhoc mode; backoff between 0 and (2 * cw_min).
 		 */
@@ -997,17 +991,17 @@ ath5k_beaconq_config(struct ath5k_softc *sc)
 		qi.tqi_cw_max = 2 * AR5K_TUNE_CWMIN;
 	}
 
-	ATH5K_DBG(sc, ATH5K_DEBUG_BEACON,
+	ATH5K_DBG(ah, ATH5K_DEBUG_BEACON,
 		"beacon queueprops tqi_aifs:%d tqi_cw_min:%d tqi_cw_max:%d\n",
 		qi.tqi_aifs, qi.tqi_cw_min, qi.tqi_cw_max);
 
-	ret = ath5k_hw_set_tx_queueprops(ah, sc->bhalq, &qi);
+	ret = ath5k_hw_set_tx_queueprops(ah, ah->bhalq, &qi);
 	if (ret) {
-		ATH5K_ERR(sc, "%s: unable to update parameters for beacon "
+		ATH5K_ERR(ah, "%s: unable to update parameters for beacon "
 			"hardware queue!\n", __func__);
 		goto err;
 	}
-	ret = ath5k_hw_reset_tx_queue(ah, sc->bhalq); /* push to h/w */
+	ret = ath5k_hw_reset_tx_queue(ah, ah->bhalq); /* push to h/w */
 	if (ret)
 		goto err;
 
@@ -1016,7 +1010,7 @@ ath5k_beaconq_config(struct ath5k_softc *sc)
 	if (ret)
 		goto err;
 
-	qi.tqi_ready_time = (sc->bintval * 80) / 100;
+	qi.tqi_ready_time = (ah->bintval * 80) / 100;
 	ret = ath5k_hw_set_tx_queueprops(ah, AR5K_TX_QUEUE_ID_CAB, &qi);
 	if (ret)
 		goto err;
@@ -1029,7 +1023,7 @@ err:
 /**
  * ath5k_drain_tx_buffs - Empty tx buffers
  *
- * @sc The &struct ath5k_softc
+ * @ah The &struct ath5k_hw
  *
  * Empty tx buffers from all queues in preparation
  * of a reset or during shutdown.
@@ -1038,26 +1032,26 @@ err:
  *	we do not need to block ath5k_tx_tasklet
  */
 static void
-ath5k_drain_tx_buffs(struct ath5k_softc *sc)
+ath5k_drain_tx_buffs(struct ath5k_hw *ah)
 {
 	struct ath5k_txq *txq;
 	struct ath5k_buf *bf, *bf0;
 	int i;
 
-	for (i = 0; i < ARRAY_SIZE(sc->txqs); i++) {
-		if (sc->txqs[i].setup) {
-			txq = &sc->txqs[i];
+	for (i = 0; i < ARRAY_SIZE(ah->txqs); i++) {
+		if (ah->txqs[i].setup) {
+			txq = &ah->txqs[i];
 			spin_lock_bh(&txq->lock);
 			list_for_each_entry_safe(bf, bf0, &txq->q, list) {
-				ath5k_debug_printtxbuf(sc, bf);
+				ath5k_debug_printtxbuf(ah, bf);
 
-				ath5k_txbuf_free_skb(sc, bf);
+				ath5k_txbuf_free_skb(ah, bf);
 
-				spin_lock_bh(&sc->txbuflock);
-				list_move_tail(&bf->list, &sc->txbuf);
-				sc->txbuf_len++;
+				spin_lock_bh(&ah->txbuflock);
+				list_move_tail(&bf->list, &ah->txbuf);
+				ah->txbuf_len++;
 				txq->txq_len--;
-				spin_unlock_bh(&sc->txbuflock);
+				spin_unlock_bh(&ah->txbuflock);
 			}
 			txq->link = NULL;
 			txq->txq_poll_mark = false;
@@ -1067,14 +1061,14 @@ ath5k_drain_tx_buffs(struct ath5k_softc *sc)
 }
 
 static void
-ath5k_txq_release(struct ath5k_softc *sc)
+ath5k_txq_release(struct ath5k_hw *ah)
 {
-	struct ath5k_txq *txq = sc->txqs;
+	struct ath5k_txq *txq = ah->txqs;
 	unsigned int i;
 
-	for (i = 0; i < ARRAY_SIZE(sc->txqs); i++, txq++)
+	for (i = 0; i < ARRAY_SIZE(ah->txqs); i++, txq++)
 		if (txq->setup) {
-			ath5k_hw_release_tx_queue(sc->ah, txq->qnum);
+			ath5k_hw_release_tx_queue(ah, txq->qnum);
 			txq->setup = false;
 		}
 }
@@ -1088,33 +1082,32 @@ ath5k_txq_release(struct ath5k_softc *sc)
  * Enable the receive h/w following a reset.
  */
 static int
-ath5k_rx_start(struct ath5k_softc *sc)
+ath5k_rx_start(struct ath5k_hw *ah)
 {
-	struct ath5k_hw *ah = sc->ah;
 	struct ath_common *common = ath5k_hw_common(ah);
 	struct ath5k_buf *bf;
 	int ret;
 
 	common->rx_bufsize = roundup(IEEE80211_MAX_FRAME_LEN, common->cachelsz);
 
-	ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "cachelsz %u rx_bufsize %u\n",
+	ATH5K_DBG(ah, ATH5K_DEBUG_RESET, "cachelsz %u rx_bufsize %u\n",
 		  common->cachelsz, common->rx_bufsize);
 
-	spin_lock_bh(&sc->rxbuflock);
-	sc->rxlink = NULL;
-	list_for_each_entry(bf, &sc->rxbuf, list) {
-		ret = ath5k_rxbuf_setup(sc, bf);
+	spin_lock_bh(&ah->rxbuflock);
+	ah->rxlink = NULL;
+	list_for_each_entry(bf, &ah->rxbuf, list) {
+		ret = ath5k_rxbuf_setup(ah, bf);
 		if (ret != 0) {
-			spin_unlock_bh(&sc->rxbuflock);
+			spin_unlock_bh(&ah->rxbuflock);
 			goto err;
 		}
 	}
-	bf = list_first_entry(&sc->rxbuf, struct ath5k_buf, list);
+	bf = list_first_entry(&ah->rxbuf, struct ath5k_buf, list);
 	ath5k_hw_set_rxdp(ah, bf->daddr);
-	spin_unlock_bh(&sc->rxbuflock);
+	spin_unlock_bh(&ah->rxbuflock);
 
 	ath5k_hw_start_rx_dma(ah);	/* enable recv descriptors */
-	ath5k_update_bssid_mask_and_opmode(sc, NULL); /* set filters, etc. */
+	ath5k_update_bssid_mask_and_opmode(ah, NULL); /* set filters, etc. */
 	ath5k_hw_start_rx_pcu(ah);	/* re-enable PCU/DMA engine */
 
 	return 0;
@@ -1130,21 +1123,19 @@ err:
  * does.
  */
 static void
-ath5k_rx_stop(struct ath5k_softc *sc)
+ath5k_rx_stop(struct ath5k_hw *ah)
 {
-	struct ath5k_hw *ah = sc->ah;
 
 	ath5k_hw_set_rx_filter(ah, 0);	/* clear recv filter */
 	ath5k_hw_stop_rx_pcu(ah);	/* disable PCU */
 
-	ath5k_debug_printrxbuffs(sc, ah);
+	ath5k_debug_printrxbuffs(ah);
 }
 
 static unsigned int
-ath5k_rx_decrypted(struct ath5k_softc *sc, struct sk_buff *skb,
+ath5k_rx_decrypted(struct ath5k_hw *ah, struct sk_buff *skb,
 		   struct ath5k_rx_status *rs)
 {
-	struct ath5k_hw *ah = sc->ah;
 	struct ath_common *common = ath5k_hw_common(ah);
 	struct ieee80211_hdr *hdr = (void *)skb->data;
 	unsigned int keyix, hlen;
@@ -1171,10 +1162,10 @@ ath5k_rx_decrypted(struct ath5k_softc *sc, struct sk_buff *skb,
 
 
 static void
-ath5k_check_ibss_tsf(struct ath5k_softc *sc, struct sk_buff *skb,
+ath5k_check_ibss_tsf(struct ath5k_hw *ah, struct sk_buff *skb,
 		     struct ieee80211_rx_status *rxs)
 {
-	struct ath_common *common = ath5k_hw_common(sc->ah);
+	struct ath_common *common = ath5k_hw_common(ah);
 	u64 tsf, bc_tstamp;
 	u32 hw_tu;
 	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *)skb->data;
@@ -1187,11 +1178,11 @@ ath5k_check_ibss_tsf(struct ath5k_softc *sc, struct sk_buff *skb,
 		 * have updated the local TSF. We have to work around various
 		 * hardware bugs, though...
 		 */
-		tsf = ath5k_hw_get_tsf64(sc->ah);
+		tsf = ath5k_hw_get_tsf64(ah);
 		bc_tstamp = le64_to_cpu(mgmt->u.beacon.timestamp);
 		hw_tu = TSF_TO_TU(tsf);
 
-		ATH5K_DBG_UNLIMIT(sc, ATH5K_DEBUG_BEACON,
+		ATH5K_DBG_UNLIMIT(ah, ATH5K_DEBUG_BEACON,
 			"beacon %llx mactime %llx (diff %lld) tsf now %llx\n",
 			(unsigned long long)bc_tstamp,
 			(unsigned long long)rxs->mactime,
@@ -1210,7 +1201,7 @@ ath5k_check_ibss_tsf(struct ath5k_softc *sc, struct sk_buff *skb,
 		 * received, not like mac80211 which defines it at the start.
 		 */
 		if (bc_tstamp > rxs->mactime) {
-			ATH5K_DBG_UNLIMIT(sc, ATH5K_DEBUG_BEACON,
+			ATH5K_DBG_UNLIMIT(ah, ATH5K_DEBUG_BEACON,
 				"fixing mactime from %llx to %llx\n",
 				(unsigned long long)rxs->mactime,
 				(unsigned long long)tsf);
@@ -1223,25 +1214,24 @@ ath5k_check_ibss_tsf(struct ath5k_softc *sc, struct sk_buff *skb,
 		 * beacons. This also takes care of synchronizing beacon sending
 		 * times with other stations.
 		 */
-		if (hw_tu >= sc->nexttbtt)
-			ath5k_beacon_update_timers(sc, bc_tstamp);
+		if (hw_tu >= ah->nexttbtt)
+			ath5k_beacon_update_timers(ah, bc_tstamp);
 
 		/* Check if the beacon timers are still correct, because a TSF
 		 * update might have created a window between them - for a
 		 * longer description see the comment of this function: */
-		if (!ath5k_hw_check_beacon_timers(sc->ah, sc->bintval)) {
-			ath5k_beacon_update_timers(sc, bc_tstamp);
-			ATH5K_DBG_UNLIMIT(sc, ATH5K_DEBUG_BEACON,
+		if (!ath5k_hw_check_beacon_timers(ah, ah->bintval)) {
+			ath5k_beacon_update_timers(ah, bc_tstamp);
+			ATH5K_DBG_UNLIMIT(ah, ATH5K_DEBUG_BEACON,
 				"fixed beacon timers after beacon receive\n");
 		}
 	}
 }
 
 static void
-ath5k_update_beacon_rssi(struct ath5k_softc *sc, struct sk_buff *skb, int rssi)
+ath5k_update_beacon_rssi(struct ath5k_hw *ah, struct sk_buff *skb, int rssi)
 {
 	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *)skb->data;
-	struct ath5k_hw *ah = sc->ah;
 	struct ath_common *common = ath5k_hw_common(ah);
 
 	/* only beacons from our BSSID */
@@ -1323,7 +1313,7 @@ static int ath5k_remove_padding(struct sk_buff *skb)
 }
 
 static void
-ath5k_receive_frame(struct ath5k_softc *sc, struct sk_buff *skb,
+ath5k_receive_frame(struct ath5k_hw *ah, struct sk_buff *skb,
 		    struct ath5k_rx_status *rs)
 {
 	struct ieee80211_rx_status *rxs;
@@ -1356,37 +1346,37 @@ ath5k_receive_frame(struct ath5k_softc *sc, struct sk_buff *skb,
 	 * impossible to comply to that. This affects IBSS merge only
 	 * right now, so it's not too bad...
 	 */
-	rxs->mactime = ath5k_extend_tsf(sc->ah, rs->rs_tstamp);
+	rxs->mactime = ath5k_extend_tsf(ah, rs->rs_tstamp);
 	rxs->flag |= RX_FLAG_MACTIME_MPDU;
 
-	rxs->freq = sc->curchan->center_freq;
-	rxs->band = sc->curchan->band;
+	rxs->freq = ah->curchan->center_freq;
+	rxs->band = ah->curchan->band;
 
-	rxs->signal = sc->ah->ah_noise_floor + rs->rs_rssi;
+	rxs->signal = ah->ah_noise_floor + rs->rs_rssi;
 
 	rxs->antenna = rs->rs_antenna;
 
 	if (rs->rs_antenna > 0 && rs->rs_antenna < 5)
-		sc->stats.antenna_rx[rs->rs_antenna]++;
+		ah->stats.antenna_rx[rs->rs_antenna]++;
 	else
-		sc->stats.antenna_rx[0]++; /* invalid */
+		ah->stats.antenna_rx[0]++; /* invalid */
 
-	rxs->rate_idx = ath5k_hw_to_driver_rix(sc, rs->rs_rate);
-	rxs->flag |= ath5k_rx_decrypted(sc, skb, rs);
+	rxs->rate_idx = ath5k_hw_to_driver_rix(ah, rs->rs_rate);
+	rxs->flag |= ath5k_rx_decrypted(ah, skb, rs);
 
 	if (rxs->rate_idx >= 0 && rs->rs_rate ==
-	    sc->sbands[sc->curchan->band].bitrates[rxs->rate_idx].hw_value_short)
+	    ah->sbands[ah->curchan->band].bitrates[rxs->rate_idx].hw_value_short)
 		rxs->flag |= RX_FLAG_SHORTPRE;
 
-	trace_ath5k_rx(sc, skb);
+	trace_ath5k_rx(ah, skb);
 
-	ath5k_update_beacon_rssi(sc, skb, rs->rs_rssi);
+	ath5k_update_beacon_rssi(ah, skb, rs->rs_rssi);
 
 	/* check beacons in IBSS mode */
-	if (sc->opmode == NL80211_IFTYPE_ADHOC)
-		ath5k_check_ibss_tsf(sc, skb, rxs);
+	if (ah->opmode == NL80211_IFTYPE_ADHOC)
+		ath5k_check_ibss_tsf(ah, skb, rxs);
 
-	ieee80211_rx(sc->hw, skb);
+	ieee80211_rx(ah->hw, skb);
 }
 
 /** ath5k_frame_receive_ok() - Do we want to receive this frame or not?
@@ -1395,20 +1385,20 @@ ath5k_receive_frame(struct ath5k_softc *sc, struct sk_buff *skb,
  * statistics. Return true if we want this frame, false if not.
  */
 static bool
-ath5k_receive_frame_ok(struct ath5k_softc *sc, struct ath5k_rx_status *rs)
+ath5k_receive_frame_ok(struct ath5k_hw *ah, struct ath5k_rx_status *rs)
 {
-	sc->stats.rx_all_count++;
-	sc->stats.rx_bytes_count += rs->rs_datalen;
+	ah->stats.rx_all_count++;
+	ah->stats.rx_bytes_count += rs->rs_datalen;
 
 	if (unlikely(rs->rs_status)) {
 		if (rs->rs_status & AR5K_RXERR_CRC)
-			sc->stats.rxerr_crc++;
+			ah->stats.rxerr_crc++;
 		if (rs->rs_status & AR5K_RXERR_FIFO)
-			sc->stats.rxerr_fifo++;
+			ah->stats.rxerr_fifo++;
 		if (rs->rs_status & AR5K_RXERR_PHY) {
-			sc->stats.rxerr_phy++;
+			ah->stats.rxerr_phy++;
 			if (rs->rs_phyerr > 0 && rs->rs_phyerr < 32)
-				sc->stats.rxerr_phy_code[rs->rs_phyerr]++;
+				ah->stats.rxerr_phy_code[rs->rs_phyerr]++;
 			return false;
 		}
 		if (rs->rs_status & AR5K_RXERR_DECRYPT) {
@@ -1422,13 +1412,13 @@ ath5k_receive_frame_ok(struct ath5k_softc *sc, struct ath5k_rx_status *rs)
 			 *
 			 * XXX do key cache faulting
 			 */
-			sc->stats.rxerr_decrypt++;
+			ah->stats.rxerr_decrypt++;
 			if (rs->rs_keyix == AR5K_RXKEYIX_INVALID &&
 			    !(rs->rs_status & AR5K_RXERR_CRC))
 				return true;
 		}
 		if (rs->rs_status & AR5K_RXERR_MIC) {
-			sc->stats.rxerr_mic++;
+			ah->stats.rxerr_mic++;
 			return true;
 		}
 
@@ -1438,26 +1428,26 @@ ath5k_receive_frame_ok(struct ath5k_softc *sc, struct ath5k_rx_status *rs)
 	}
 
 	if (unlikely(rs->rs_more)) {
-		sc->stats.rxerr_jumbo++;
+		ah->stats.rxerr_jumbo++;
 		return false;
 	}
 	return true;
 }
 
 static void
-ath5k_set_current_imask(struct ath5k_softc *sc)
+ath5k_set_current_imask(struct ath5k_hw *ah)
 {
 	enum ath5k_int imask;
 	unsigned long flags;
 
-	spin_lock_irqsave(&sc->irqlock, flags);
-	imask = sc->imask;
-	if (sc->rx_pending)
+	spin_lock_irqsave(&ah->irqlock, flags);
+	imask = ah->imask;
+	if (ah->rx_pending)
 		imask &= ~AR5K_INT_RX_ALL;
-	if (sc->tx_pending)
+	if (ah->tx_pending)
 		imask &= ~AR5K_INT_TX_ALL;
-	ath5k_hw_set_imr(sc->ah, imask);
-	spin_unlock_irqrestore(&sc->irqlock, flags);
+	ath5k_hw_set_imr(ah, imask);
+	spin_unlock_irqrestore(&ah->irqlock, flags);
 }
 
 static void
@@ -1466,39 +1456,38 @@ ath5k_tasklet_rx(unsigned long data)
 	struct ath5k_rx_status rs = {};
 	struct sk_buff *skb, *next_skb;
 	dma_addr_t next_skb_addr;
-	struct ath5k_softc *sc = (void *)data;
-	struct ath5k_hw *ah = sc->ah;
+	struct ath5k_hw *ah = (void *)data;
 	struct ath_common *common = ath5k_hw_common(ah);
 	struct ath5k_buf *bf;
 	struct ath5k_desc *ds;
 	int ret;
 
-	spin_lock(&sc->rxbuflock);
-	if (list_empty(&sc->rxbuf)) {
-		ATH5K_WARN(sc, "empty rx buf pool\n");
+	spin_lock(&ah->rxbuflock);
+	if (list_empty(&ah->rxbuf)) {
+		ATH5K_WARN(ah, "empty rx buf pool\n");
 		goto unlock;
 	}
 	do {
-		bf = list_first_entry(&sc->rxbuf, struct ath5k_buf, list);
+		bf = list_first_entry(&ah->rxbuf, struct ath5k_buf, list);
 		BUG_ON(bf->skb == NULL);
 		skb = bf->skb;
 		ds = bf->desc;
 
 		/* bail if HW is still using self-linked descriptor */
-		if (ath5k_hw_get_rxdp(sc->ah) == bf->daddr)
+		if (ath5k_hw_get_rxdp(ah) == bf->daddr)
 			break;
 
-		ret = sc->ah->ah_proc_rx_desc(sc->ah, ds, &rs);
+		ret = ah->ah_proc_rx_desc(ah, ds, &rs);
 		if (unlikely(ret == -EINPROGRESS))
 			break;
 		else if (unlikely(ret)) {
-			ATH5K_ERR(sc, "error in processing rx descriptor\n");
-			sc->stats.rxerr_proc++;
+			ATH5K_ERR(ah, "error in processing rx descriptor\n");
+			ah->stats.rxerr_proc++;
 			break;
 		}
 
-		if (ath5k_receive_frame_ok(sc, &rs)) {
-			next_skb = ath5k_rx_skb_alloc(sc, &next_skb_addr);
+		if (ath5k_receive_frame_ok(ah, &rs)) {
+			next_skb = ath5k_rx_skb_alloc(ah, &next_skb_addr);
 
 			/*
 			 * If we can't replace bf->skb with a new skb under
@@ -1507,24 +1496,24 @@ ath5k_tasklet_rx(unsigned long data)
 			if (!next_skb)
 				goto next;
 
-			dma_unmap_single(sc->dev, bf->skbaddr,
+			dma_unmap_single(ah->dev, bf->skbaddr,
 					 common->rx_bufsize,
 					 DMA_FROM_DEVICE);
 
 			skb_put(skb, rs.rs_datalen);
 
-			ath5k_receive_frame(sc, skb, &rs);
+			ath5k_receive_frame(ah, skb, &rs);
 
 			bf->skb = next_skb;
 			bf->skbaddr = next_skb_addr;
 		}
 next:
-		list_move_tail(&bf->list, &sc->rxbuf);
-	} while (ath5k_rxbuf_setup(sc, bf) == 0);
+		list_move_tail(&bf->list, &ah->rxbuf);
+	} while (ath5k_rxbuf_setup(ah, bf) == 0);
 unlock:
-	spin_unlock(&sc->rxbuflock);
-	sc->rx_pending = false;
-	ath5k_set_current_imask(sc);
+	spin_unlock(&ah->rxbuflock);
+	ah->rx_pending = false;
+	ath5k_set_current_imask(ah);
 }
 
 
@@ -1536,12 +1525,12 @@ void
 ath5k_tx_queue(struct ieee80211_hw *hw, struct sk_buff *skb,
 	       struct ath5k_txq *txq)
 {
-	struct ath5k_softc *sc = hw->priv;
+	struct ath5k_hw *ah = hw->priv;
 	struct ath5k_buf *bf;
 	unsigned long flags;
 	int padsize;
 
-	trace_ath5k_tx(sc, skb, txq);
+	trace_ath5k_tx(ah, skb, txq);
 
 	/*
 	 * The hardware expects the header padded to 4 byte boundaries.
@@ -1549,7 +1538,7 @@ ath5k_tx_queue(struct ieee80211_hw *hw, struct sk_buff *skb,
 	 */
 	padsize = ath5k_add_padding(skb);
 	if (padsize < 0) {
-		ATH5K_ERR(sc, "tx hdrlen not %%4: not enough"
+		ATH5K_ERR(ah, "tx hdrlen not %%4: not enough"
 			  " headroom to pad");
 		goto drop_packet;
 	}
@@ -1558,28 +1547,28 @@ ath5k_tx_queue(struct ieee80211_hw *hw, struct sk_buff *skb,
 	    txq->qnum <= AR5K_TX_QUEUE_ID_DATA_MAX)
 		ieee80211_stop_queue(hw, txq->qnum);
 
-	spin_lock_irqsave(&sc->txbuflock, flags);
-	if (list_empty(&sc->txbuf)) {
-		ATH5K_ERR(sc, "no further txbuf available, dropping packet\n");
-		spin_unlock_irqrestore(&sc->txbuflock, flags);
+	spin_lock_irqsave(&ah->txbuflock, flags);
+	if (list_empty(&ah->txbuf)) {
+		ATH5K_ERR(ah, "no further txbuf available, dropping packet\n");
+		spin_unlock_irqrestore(&ah->txbuflock, flags);
 		ieee80211_stop_queues(hw);
 		goto drop_packet;
 	}
-	bf = list_first_entry(&sc->txbuf, struct ath5k_buf, list);
+	bf = list_first_entry(&ah->txbuf, struct ath5k_buf, list);
 	list_del(&bf->list);
-	sc->txbuf_len--;
-	if (list_empty(&sc->txbuf))
+	ah->txbuf_len--;
+	if (list_empty(&ah->txbuf))
 		ieee80211_stop_queues(hw);
-	spin_unlock_irqrestore(&sc->txbuflock, flags);
+	spin_unlock_irqrestore(&ah->txbuflock, flags);
 
 	bf->skb = skb;
 
-	if (ath5k_txbuf_setup(sc, bf, txq, padsize)) {
+	if (ath5k_txbuf_setup(ah, bf, txq, padsize)) {
 		bf->skb = NULL;
-		spin_lock_irqsave(&sc->txbuflock, flags);
-		list_add_tail(&bf->list, &sc->txbuf);
-		sc->txbuf_len++;
-		spin_unlock_irqrestore(&sc->txbuflock, flags);
+		spin_lock_irqsave(&ah->txbuflock, flags);
+		list_add_tail(&bf->list, &ah->txbuf);
+		ah->txbuf_len++;
+		spin_unlock_irqrestore(&ah->txbuflock, flags);
 		goto drop_packet;
 	}
 	return;
@@ -1589,15 +1578,15 @@ drop_packet:
 }
 
 static void
-ath5k_tx_frame_completed(struct ath5k_softc *sc, struct sk_buff *skb,
+ath5k_tx_frame_completed(struct ath5k_hw *ah, struct sk_buff *skb,
 			 struct ath5k_txq *txq, struct ath5k_tx_status *ts)
 {
 	struct ieee80211_tx_info *info;
 	u8 tries[3];
 	int i;
 
-	sc->stats.tx_all_count++;
-	sc->stats.tx_bytes_count += skb->len;
+	ah->stats.tx_all_count++;
+	ah->stats.tx_bytes_count += skb->len;
 	info = IEEE80211_SKB_CB(skb);
 
 	tries[0] = info->status.rates[0].count;
@@ -1617,15 +1606,15 @@ ath5k_tx_frame_completed(struct ath5k_softc *sc, struct sk_buff *skb,
 	info->status.rates[ts->ts_final_idx + 1].idx = -1;
 
 	if (unlikely(ts->ts_status)) {
-		sc->stats.ack_fail++;
+		ah->stats.ack_fail++;
 		if (ts->ts_status & AR5K_TXERR_FILT) {
 			info->flags |= IEEE80211_TX_STAT_TX_FILTERED;
-			sc->stats.txerr_filt++;
+			ah->stats.txerr_filt++;
 		}
 		if (ts->ts_status & AR5K_TXERR_XRETRY)
-			sc->stats.txerr_retry++;
+			ah->stats.txerr_retry++;
 		if (ts->ts_status & AR5K_TXERR_FIFO)
-			sc->stats.txerr_fifo++;
+			ah->stats.txerr_fifo++;
 	} else {
 		info->flags |= IEEE80211_TX_STAT_ACK;
 		info->status.ack_signal = ts->ts_rssi;
@@ -1641,16 +1630,16 @@ ath5k_tx_frame_completed(struct ath5k_softc *sc, struct sk_buff *skb,
 	ath5k_remove_padding(skb);
 
 	if (ts->ts_antenna > 0 && ts->ts_antenna < 5)
-		sc->stats.antenna_tx[ts->ts_antenna]++;
+		ah->stats.antenna_tx[ts->ts_antenna]++;
 	else
-		sc->stats.antenna_tx[0]++; /* invalid */
+		ah->stats.antenna_tx[0]++; /* invalid */
 
-	trace_ath5k_tx_complete(sc, skb, txq, ts);
-	ieee80211_tx_status(sc->hw, skb);
+	trace_ath5k_tx_complete(ah, skb, txq, ts);
+	ieee80211_tx_status(ah->hw, skb);
 }
 
 static void
-ath5k_tx_processq(struct ath5k_softc *sc, struct ath5k_txq *txq)
+ath5k_tx_processq(struct ath5k_hw *ah, struct ath5k_txq *txq)
 {
 	struct ath5k_tx_status ts = {};
 	struct ath5k_buf *bf, *bf0;
@@ -1667,11 +1656,11 @@ ath5k_tx_processq(struct ath5k_softc *sc, struct ath5k_txq *txq)
 		if (bf->skb != NULL) {
 			ds = bf->desc;
 
-			ret = sc->ah->ah_proc_tx_desc(sc->ah, ds, &ts);
+			ret = ah->ah_proc_tx_desc(ah, ds, &ts);
 			if (unlikely(ret == -EINPROGRESS))
 				break;
 			else if (unlikely(ret)) {
-				ATH5K_ERR(sc,
+				ATH5K_ERR(ah,
 					"error %d while processing "
 					"queue %u\n", ret, txq->qnum);
 				break;
@@ -1680,9 +1669,9 @@ ath5k_tx_processq(struct ath5k_softc *sc, struct ath5k_txq *txq)
 			skb = bf->skb;
 			bf->skb = NULL;
 
-			dma_unmap_single(sc->dev, bf->skbaddr, skb->len,
+			dma_unmap_single(ah->dev, bf->skbaddr, skb->len,
 					DMA_TO_DEVICE);
-			ath5k_tx_frame_completed(sc, skb, txq, &ts);
+			ath5k_tx_frame_completed(ah, skb, txq, &ts);
 		}
 
 		/*
@@ -1691,31 +1680,31 @@ ath5k_tx_processq(struct ath5k_softc *sc, struct ath5k_txq *txq)
 		 * host memory and moved on.
 		 * Always keep the last descriptor to avoid HW races...
 		 */
-		if (ath5k_hw_get_txdp(sc->ah, txq->qnum) != bf->daddr) {
-			spin_lock(&sc->txbuflock);
-			list_move_tail(&bf->list, &sc->txbuf);
-			sc->txbuf_len++;
+		if (ath5k_hw_get_txdp(ah, txq->qnum) != bf->daddr) {
+			spin_lock(&ah->txbuflock);
+			list_move_tail(&bf->list, &ah->txbuf);
+			ah->txbuf_len++;
 			txq->txq_len--;
-			spin_unlock(&sc->txbuflock);
+			spin_unlock(&ah->txbuflock);
 		}
 	}
 	spin_unlock(&txq->lock);
 	if (txq->txq_len < ATH5K_TXQ_LEN_LOW && txq->qnum < 4)
-		ieee80211_wake_queue(sc->hw, txq->qnum);
+		ieee80211_wake_queue(ah->hw, txq->qnum);
 }
 
 static void
 ath5k_tasklet_tx(unsigned long data)
 {
 	int i;
-	struct ath5k_softc *sc = (void *)data;
+	struct ath5k_hw *ah = (void *)data;
 
 	for (i = 0; i < AR5K_NUM_TX_QUEUES; i++)
-		if (sc->txqs[i].setup && (sc->ah->ah_txq_isr & BIT(i)))
-			ath5k_tx_processq(sc, &sc->txqs[i]);
+		if (ah->txqs[i].setup && (ah->ah_txq_isr & BIT(i)))
+			ath5k_tx_processq(ah, &ah->txqs[i]);
 
-	sc->tx_pending = false;
-	ath5k_set_current_imask(sc);
+	ah->tx_pending = false;
+	ath5k_set_current_imask(ah);
 }
 
 
@@ -1727,25 +1716,24 @@ ath5k_tasklet_tx(unsigned long data)
  * Setup the beacon frame for transmit.
  */
 static int
-ath5k_beacon_setup(struct ath5k_softc *sc, struct ath5k_buf *bf)
+ath5k_beacon_setup(struct ath5k_hw *ah, struct ath5k_buf *bf)
 {
 	struct sk_buff *skb = bf->skb;
 	struct	ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	struct ath5k_hw *ah = sc->ah;
 	struct ath5k_desc *ds;
 	int ret = 0;
 	u8 antenna;
 	u32 flags;
 	const int padsize = 0;
 
-	bf->skbaddr = dma_map_single(sc->dev, skb->data, skb->len,
+	bf->skbaddr = dma_map_single(ah->dev, skb->data, skb->len,
 			DMA_TO_DEVICE);
-	ATH5K_DBG(sc, ATH5K_DEBUG_BEACON, "skb %p [data %p len %u] "
+	ATH5K_DBG(ah, ATH5K_DEBUG_BEACON, "skb %p [data %p len %u] "
 			"skbaddr %llx\n", skb, skb->data, skb->len,
 			(unsigned long long)bf->skbaddr);
 
-	if (dma_mapping_error(sc->dev, bf->skbaddr)) {
-		ATH5K_ERR(sc, "beacon DMA mapping failed\n");
+	if (dma_mapping_error(ah->dev, bf->skbaddr)) {
+		ATH5K_ERR(ah, "beacon DMA mapping failed\n");
 		return -EIO;
 	}
 
@@ -1753,7 +1741,7 @@ ath5k_beacon_setup(struct ath5k_softc *sc, struct ath5k_buf *bf)
 	antenna = ah->ah_tx_ant;
 
 	flags = AR5K_TXDESC_NOACK;
-	if (sc->opmode == NL80211_IFTYPE_ADHOC && ath5k_hw_hasveol(ah)) {
+	if (ah->opmode == NL80211_IFTYPE_ADHOC && ath5k_hw_hasveol(ah)) {
 		ds->ds_link = bf->daddr;	/* self-linked */
 		flags |= AR5K_TXDESC_VEOL;
 	} else
@@ -1778,7 +1766,7 @@ ath5k_beacon_setup(struct ath5k_softc *sc, struct ath5k_buf *bf)
 	 * on all of them.
 	 */
 	if (ah->ah_ant_mode == AR5K_ANTMODE_SECTOR_AP)
-		antenna = sc->bsent & 4 ? 2 : 1;
+		antenna = ah->bsent & 4 ? 2 : 1;
 
 
 	/* FIXME: If we are in g mode and rate is a CCK rate
@@ -1787,8 +1775,8 @@ ath5k_beacon_setup(struct ath5k_softc *sc, struct ath5k_buf *bf)
 	ds->ds_data = bf->skbaddr;
 	ret = ah->ah_setup_tx_desc(ah, ds, skb->len,
 			ieee80211_get_hdrlen_from_skb(skb), padsize,
-			AR5K_PKT_TYPE_BEACON, (sc->power_level * 2),
-			ieee80211_get_tx_rate(sc->hw, info)->hw_value,
+			AR5K_PKT_TYPE_BEACON, (ah->power_level * 2),
+			ieee80211_get_tx_rate(ah->hw, info)->hw_value,
 			1, AR5K_TXKEYIX_INVALID,
 			antenna, flags, 0, 0);
 	if (ret)
@@ -1796,7 +1784,7 @@ ath5k_beacon_setup(struct ath5k_softc *sc, struct ath5k_buf *bf)
 
 	return 0;
 err_unmap:
-	dma_unmap_single(sc->dev, bf->skbaddr, skb->len, DMA_TO_DEVICE);
+	dma_unmap_single(ah->dev, bf->skbaddr, skb->len, DMA_TO_DEVICE);
 	return ret;
 }
 
@@ -1811,7 +1799,7 @@ int
 ath5k_beacon_update(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 {
 	int ret;
-	struct ath5k_softc *sc = hw->priv;
+	struct ath5k_hw *ah = hw->priv;
 	struct ath5k_vif *avf = (void *)vif->drv_priv;
 	struct sk_buff *skb;
 
@@ -1827,9 +1815,9 @@ ath5k_beacon_update(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 		goto out;
 	}
 
-	ath5k_txbuf_free_skb(sc, avf->bbuf);
+	ath5k_txbuf_free_skb(ah, avf->bbuf);
 	avf->bbuf->skb = skb;
-	ret = ath5k_beacon_setup(sc, avf->bbuf);
+	ret = ath5k_beacon_setup(ah, avf->bbuf);
 	if (ret)
 		avf->bbuf->skb = NULL;
 out:
@@ -1845,15 +1833,14 @@ out:
  * or user context from ath5k_beacon_config.
  */
 static void
-ath5k_beacon_send(struct ath5k_softc *sc)
+ath5k_beacon_send(struct ath5k_hw *ah)
 {
-	struct ath5k_hw *ah = sc->ah;
 	struct ieee80211_vif *vif;
 	struct ath5k_vif *avf;
 	struct ath5k_buf *bf;
 	struct sk_buff *skb;
 
-	ATH5K_DBG_UNLIMIT(sc, ATH5K_DEBUG_BEACON, "in beacon_send\n");
+	ATH5K_DBG_UNLIMIT(ah, ATH5K_DEBUG_BEACON, "in beacon_send\n");
 
 	/*
 	 * Check if the previous beacon has gone out.  If
@@ -1862,47 +1849,47 @@ ath5k_beacon_send(struct ath5k_softc *sc)
 	 * indicate a problem and should not occur.  If we
 	 * miss too many consecutive beacons reset the device.
 	 */
-	if (unlikely(ath5k_hw_num_tx_pending(ah, sc->bhalq) != 0)) {
-		sc->bmisscount++;
-		ATH5K_DBG(sc, ATH5K_DEBUG_BEACON,
-			"missed %u consecutive beacons\n", sc->bmisscount);
-		if (sc->bmisscount > 10) {	/* NB: 10 is a guess */
-			ATH5K_DBG(sc, ATH5K_DEBUG_BEACON,
+	if (unlikely(ath5k_hw_num_tx_pending(ah, ah->bhalq) != 0)) {
+		ah->bmisscount++;
+		ATH5K_DBG(ah, ATH5K_DEBUG_BEACON,
+			"missed %u consecutive beacons\n", ah->bmisscount);
+		if (ah->bmisscount > 10) {	/* NB: 10 is a guess */
+			ATH5K_DBG(ah, ATH5K_DEBUG_BEACON,
 				"stuck beacon time (%u missed)\n",
-				sc->bmisscount);
-			ATH5K_DBG(sc, ATH5K_DEBUG_RESET,
+				ah->bmisscount);
+			ATH5K_DBG(ah, ATH5K_DEBUG_RESET,
 				  "stuck beacon, resetting\n");
-			ieee80211_queue_work(sc->hw, &sc->reset_work);
+			ieee80211_queue_work(ah->hw, &ah->reset_work);
 		}
 		return;
 	}
-	if (unlikely(sc->bmisscount != 0)) {
-		ATH5K_DBG(sc, ATH5K_DEBUG_BEACON,
+	if (unlikely(ah->bmisscount != 0)) {
+		ATH5K_DBG(ah, ATH5K_DEBUG_BEACON,
 			"resume beacon xmit after %u misses\n",
-			sc->bmisscount);
-		sc->bmisscount = 0;
+			ah->bmisscount);
+		ah->bmisscount = 0;
 	}
 
-	if ((sc->opmode == NL80211_IFTYPE_AP && sc->num_ap_vifs > 1) ||
-			sc->opmode == NL80211_IFTYPE_MESH_POINT) {
+	if ((ah->opmode == NL80211_IFTYPE_AP && ah->num_ap_vifs > 1) ||
+			ah->opmode == NL80211_IFTYPE_MESH_POINT) {
 		u64 tsf = ath5k_hw_get_tsf64(ah);
 		u32 tsftu = TSF_TO_TU(tsf);
-		int slot = ((tsftu % sc->bintval) * ATH_BCBUF) / sc->bintval;
-		vif = sc->bslot[(slot + 1) % ATH_BCBUF];
-		ATH5K_DBG(sc, ATH5K_DEBUG_BEACON,
+		int slot = ((tsftu % ah->bintval) * ATH_BCBUF) / ah->bintval;
+		vif = ah->bslot[(slot + 1) % ATH_BCBUF];
+		ATH5K_DBG(ah, ATH5K_DEBUG_BEACON,
 			"tsf %llx tsftu %x intval %u slot %u vif %p\n",
-			(unsigned long long)tsf, tsftu, sc->bintval, slot, vif);
+			(unsigned long long)tsf, tsftu, ah->bintval, slot, vif);
 	} else /* only one interface */
-		vif = sc->bslot[0];
+		vif = ah->bslot[0];
 
 	if (!vif)
 		return;
 
 	avf = (void *)vif->drv_priv;
 	bf = avf->bbuf;
-	if (unlikely(bf->skb == NULL || sc->opmode == NL80211_IFTYPE_STATION ||
-		     sc->opmode == NL80211_IFTYPE_MONITOR)) {
-		ATH5K_WARN(sc, "bf=%p bf_skb=%p\n", bf, bf ? bf->skb : NULL);
+	if (unlikely(bf->skb == NULL || ah->opmode == NL80211_IFTYPE_STATION ||
+		     ah->opmode == NL80211_IFTYPE_MONITOR)) {
+		ATH5K_WARN(ah, "bf=%p bf_skb=%p\n", bf, bf ? bf->skb : NULL);
 		return;
 	}
 
@@ -1911,40 +1898,40 @@ ath5k_beacon_send(struct ath5k_softc *sc)
 	 * This should never fail since we check above that no frames
 	 * are still pending on the queue.
 	 */
-	if (unlikely(ath5k_hw_stop_beacon_queue(ah, sc->bhalq))) {
-		ATH5K_WARN(sc, "beacon queue %u didn't start/stop ?\n", sc->bhalq);
+	if (unlikely(ath5k_hw_stop_beacon_queue(ah, ah->bhalq))) {
+		ATH5K_WARN(ah, "beacon queue %u didn't start/stop ?\n", ah->bhalq);
 		/* NB: hw still stops DMA, so proceed */
 	}
 
 	/* refresh the beacon for AP or MESH mode */
-	if (sc->opmode == NL80211_IFTYPE_AP ||
-	    sc->opmode == NL80211_IFTYPE_MESH_POINT)
-		ath5k_beacon_update(sc->hw, vif);
+	if (ah->opmode == NL80211_IFTYPE_AP ||
+	    ah->opmode == NL80211_IFTYPE_MESH_POINT)
+		ath5k_beacon_update(ah->hw, vif);
 
-	trace_ath5k_tx(sc, bf->skb, &sc->txqs[sc->bhalq]);
+	trace_ath5k_tx(ah, bf->skb, &ah->txqs[ah->bhalq]);
 
-	ath5k_hw_set_txdp(ah, sc->bhalq, bf->daddr);
-	ath5k_hw_start_tx_dma(ah, sc->bhalq);
-	ATH5K_DBG(sc, ATH5K_DEBUG_BEACON, "TXDP[%u] = %llx (%p)\n",
-		sc->bhalq, (unsigned long long)bf->daddr, bf->desc);
+	ath5k_hw_set_txdp(ah, ah->bhalq, bf->daddr);
+	ath5k_hw_start_tx_dma(ah, ah->bhalq);
+	ATH5K_DBG(ah, ATH5K_DEBUG_BEACON, "TXDP[%u] = %llx (%p)\n",
+		ah->bhalq, (unsigned long long)bf->daddr, bf->desc);
 
-	skb = ieee80211_get_buffered_bc(sc->hw, vif);
+	skb = ieee80211_get_buffered_bc(ah->hw, vif);
 	while (skb) {
-		ath5k_tx_queue(sc->hw, skb, sc->cabq);
+		ath5k_tx_queue(ah->hw, skb, ah->cabq);
 
-		if (sc->cabq->txq_len >= sc->cabq->txq_max)
+		if (ah->cabq->txq_len >= ah->cabq->txq_max)
 			break;
 
-		skb = ieee80211_get_buffered_bc(sc->hw, vif);
+		skb = ieee80211_get_buffered_bc(ah->hw, vif);
 	}
 
-	sc->bsent++;
+	ah->bsent++;
 }
 
 /**
  * ath5k_beacon_update_timers - update beacon timers
  *
- * @sc: struct ath5k_softc pointer we are operating on
+ * @ah: struct ath5k_hw pointer we are operating on
  * @bc_tsf: the timestamp of the beacon. 0 to reset the TSF. -1 to perform a
  *          beacon timer update based on the current HW TSF.
  *
@@ -1958,17 +1945,16 @@ ath5k_beacon_send(struct ath5k_softc *sc)
  * function to have it all together in one place.
  */
 void
-ath5k_beacon_update_timers(struct ath5k_softc *sc, u64 bc_tsf)
+ath5k_beacon_update_timers(struct ath5k_hw *ah, u64 bc_tsf)
 {
-	struct ath5k_hw *ah = sc->ah;
 	u32 nexttbtt, intval, hw_tu, bc_tu;
 	u64 hw_tsf;
 
-	intval = sc->bintval & AR5K_BEACON_PERIOD;
-	if (sc->opmode == NL80211_IFTYPE_AP && sc->num_ap_vifs > 1) {
+	intval = ah->bintval & AR5K_BEACON_PERIOD;
+	if (ah->opmode == NL80211_IFTYPE_AP && ah->num_ap_vifs > 1) {
 		intval /= ATH_BCBUF;	/* staggered multi-bss beacons */
 		if (intval < 15)
-			ATH5K_WARN(sc, "intval %u is too low, min 15\n",
+			ATH5K_WARN(ah, "intval %u is too low, min 15\n",
 				   intval);
 	}
 	if (WARN_ON(!intval))
@@ -2007,7 +1993,7 @@ ath5k_beacon_update_timers(struct ath5k_softc *sc, u64 bc_tsf)
 		 * automatically update the TSF and then we need to reconfigure
 		 * the timers.
 		 */
-		ATH5K_DBG_UNLIMIT(sc, ATH5K_DEBUG_BEACON,
+		ATH5K_DBG_UNLIMIT(ah, ATH5K_DEBUG_BEACON,
 			"need to wait for HW TSF sync\n");
 		return;
 	} else {
@@ -2022,7 +2008,7 @@ ath5k_beacon_update_timers(struct ath5k_softc *sc, u64 bc_tsf)
 	}
 #undef FUDGE
 
-	sc->nexttbtt = nexttbtt;
+	ah->nexttbtt = nexttbtt;
 
 	intval |= AR5K_BEACON_ENA;
 	ath5k_hw_init_beacon(ah, nexttbtt, intval);
@@ -2032,20 +2018,20 @@ ath5k_beacon_update_timers(struct ath5k_softc *sc, u64 bc_tsf)
 	 * of this function
 	 */
 	if (bc_tsf == -1)
-		ATH5K_DBG_UNLIMIT(sc, ATH5K_DEBUG_BEACON,
+		ATH5K_DBG_UNLIMIT(ah, ATH5K_DEBUG_BEACON,
 			"reconfigured timers based on HW TSF\n");
 	else if (bc_tsf == 0)
-		ATH5K_DBG_UNLIMIT(sc, ATH5K_DEBUG_BEACON,
+		ATH5K_DBG_UNLIMIT(ah, ATH5K_DEBUG_BEACON,
 			"reset HW TSF and timers\n");
 	else
-		ATH5K_DBG_UNLIMIT(sc, ATH5K_DEBUG_BEACON,
+		ATH5K_DBG_UNLIMIT(ah, ATH5K_DEBUG_BEACON,
 			"updated timers based on beacon TSF\n");
 
-	ATH5K_DBG_UNLIMIT(sc, ATH5K_DEBUG_BEACON,
+	ATH5K_DBG_UNLIMIT(ah, ATH5K_DEBUG_BEACON,
 			  "bc_tsf %llx hw_tsf %llx bc_tu %u hw_tu %u nexttbtt %u\n",
 			  (unsigned long long) bc_tsf,
 			  (unsigned long long) hw_tsf, bc_tu, hw_tu, nexttbtt);
-	ATH5K_DBG_UNLIMIT(sc, ATH5K_DEBUG_BEACON, "intval %u %s %s\n",
+	ATH5K_DBG_UNLIMIT(ah, ATH5K_DEBUG_BEACON, "intval %u %s %s\n",
 		intval & AR5K_BEACON_PERIOD,
 		intval & AR5K_BEACON_ENA ? "AR5K_BEACON_ENA" : "",
 		intval & AR5K_BEACON_RESET_TSF ? "AR5K_BEACON_RESET_TSF" : "");
@@ -2054,22 +2040,21 @@ ath5k_beacon_update_timers(struct ath5k_softc *sc, u64 bc_tsf)
 /**
  * ath5k_beacon_config - Configure the beacon queues and interrupts
  *
- * @sc: struct ath5k_softc pointer we are operating on
+ * @ah: struct ath5k_hw pointer we are operating on
  *
  * In IBSS mode we use a self-linked tx descriptor if possible. We enable SWBA
  * interrupts to detect TSF updates only.
  */
 void
-ath5k_beacon_config(struct ath5k_softc *sc)
+ath5k_beacon_config(struct ath5k_hw *ah)
 {
-	struct ath5k_hw *ah = sc->ah;
 	unsigned long flags;
 
-	spin_lock_irqsave(&sc->block, flags);
-	sc->bmisscount = 0;
-	sc->imask &= ~(AR5K_INT_BMISS | AR5K_INT_SWBA);
+	spin_lock_irqsave(&ah->block, flags);
+	ah->bmisscount = 0;
+	ah->imask &= ~(AR5K_INT_BMISS | AR5K_INT_SWBA);
 
-	if (sc->enable_beacon) {
+	if (ah->enable_beacon) {
 		/*
 		 * In IBSS mode we use a self-linked tx descriptor and let the
 		 * hardware send the beacons automatically. We have to load it
@@ -2077,27 +2062,27 @@ ath5k_beacon_config(struct ath5k_softc *sc)
 		 * We use the SWBA interrupt only to keep track of the beacon
 		 * timers in order to detect automatic TSF updates.
 		 */
-		ath5k_beaconq_config(sc);
+		ath5k_beaconq_config(ah);
 
-		sc->imask |= AR5K_INT_SWBA;
+		ah->imask |= AR5K_INT_SWBA;
 
-		if (sc->opmode == NL80211_IFTYPE_ADHOC) {
+		if (ah->opmode == NL80211_IFTYPE_ADHOC) {
 			if (ath5k_hw_hasveol(ah))
-				ath5k_beacon_send(sc);
+				ath5k_beacon_send(ah);
 		} else
-			ath5k_beacon_update_timers(sc, -1);
+			ath5k_beacon_update_timers(ah, -1);
 	} else {
-		ath5k_hw_stop_beacon_queue(sc->ah, sc->bhalq);
+		ath5k_hw_stop_beacon_queue(ah, ah->bhalq);
 	}
 
-	ath5k_hw_set_imr(ah, sc->imask);
+	ath5k_hw_set_imr(ah, ah->imask);
 	mmiowb();
-	spin_unlock_irqrestore(&sc->block, flags);
+	spin_unlock_irqrestore(&ah->block, flags);
 }
 
 static void ath5k_tasklet_beacon(unsigned long data)
 {
-	struct ath5k_softc *sc = (struct ath5k_softc *) data;
+	struct ath5k_hw *ah = (struct ath5k_hw *) data;
 
 	/*
 	 * Software beacon alert--time to send a beacon.
@@ -2107,20 +2092,20 @@ static void ath5k_tasklet_beacon(unsigned long data)
 	 * transmission time) in order to detect whether
 	 * automatic TSF updates happened.
 	 */
-	if (sc->opmode == NL80211_IFTYPE_ADHOC) {
+	if (ah->opmode == NL80211_IFTYPE_ADHOC) {
 		/* XXX: only if VEOL supported */
-		u64 tsf = ath5k_hw_get_tsf64(sc->ah);
-		sc->nexttbtt += sc->bintval;
-		ATH5K_DBG(sc, ATH5K_DEBUG_BEACON,
+		u64 tsf = ath5k_hw_get_tsf64(ah);
+		ah->nexttbtt += ah->bintval;
+		ATH5K_DBG(ah, ATH5K_DEBUG_BEACON,
 				"SWBA nexttbtt: %x hw_tu: %x "
 				"TSF: %llx\n",
-				sc->nexttbtt,
+				ah->nexttbtt,
 				TSF_TO_TU(tsf),
 				(unsigned long long) tsf);
 	} else {
-		spin_lock(&sc->block);
-		ath5k_beacon_send(sc);
-		spin_unlock(&sc->block);
+		spin_lock(&ah->block);
+		ath5k_beacon_send(ah);
+		spin_unlock(&ah->block);
 	}
 }
 
@@ -2137,12 +2122,12 @@ ath5k_intr_calibration_poll(struct ath5k_hw *ah)
 		/* run ANI only when full calibration is not active */
 		ah->ah_cal_next_ani = jiffies +
 			msecs_to_jiffies(ATH5K_TUNE_CALIBRATION_INTERVAL_ANI);
-		tasklet_schedule(&ah->ah_sc->ani_tasklet);
+		tasklet_schedule(&ah->ani_tasklet);
 
 	} else if (time_is_before_eq_jiffies(ah->ah_cal_next_full)) {
 		ah->ah_cal_next_full = jiffies +
 			msecs_to_jiffies(ATH5K_TUNE_CALIBRATION_INTERVAL_FULL);
-		tasklet_schedule(&ah->ah_sc->calib);
+		tasklet_schedule(&ah->calib);
 	}
 	/* we could use SWI to generate enough interrupts to meet our
 	 * calibration interval requirements, if necessary:
@@ -2150,44 +2135,43 @@ ath5k_intr_calibration_poll(struct ath5k_hw *ah)
 }
 
 static void
-ath5k_schedule_rx(struct ath5k_softc *sc)
+ath5k_schedule_rx(struct ath5k_hw *ah)
 {
-	sc->rx_pending = true;
-	tasklet_schedule(&sc->rxtq);
+	ah->rx_pending = true;
+	tasklet_schedule(&ah->rxtq);
 }
 
 static void
-ath5k_schedule_tx(struct ath5k_softc *sc)
+ath5k_schedule_tx(struct ath5k_hw *ah)
 {
-	sc->tx_pending = true;
-	tasklet_schedule(&sc->txtq);
+	ah->tx_pending = true;
+	tasklet_schedule(&ah->txtq);
 }
 
 static irqreturn_t
 ath5k_intr(int irq, void *dev_id)
 {
-	struct ath5k_softc *sc = dev_id;
-	struct ath5k_hw *ah = sc->ah;
+	struct ath5k_hw *ah = dev_id;
 	enum ath5k_int status;
 	unsigned int counter = 1000;
 
-	if (unlikely(test_bit(ATH_STAT_INVALID, sc->status) ||
+	if (unlikely(test_bit(ATH_STAT_INVALID, ah->status) ||
 		((ath5k_get_bus_type(ah) != ATH_AHB) &&
 				!ath5k_hw_is_intr_pending(ah))))
 		return IRQ_NONE;
 
 	do {
 		ath5k_hw_get_isr(ah, &status);		/* NB: clears IRQ too */
-		ATH5K_DBG(sc, ATH5K_DEBUG_INTR, "status 0x%x/0x%x\n",
-				status, sc->imask);
+		ATH5K_DBG(ah, ATH5K_DEBUG_INTR, "status 0x%x/0x%x\n",
+				status, ah->imask);
 		if (unlikely(status & AR5K_INT_FATAL)) {
 			/*
 			 * Fatal errors are unrecoverable.
 			 * Typically these are caused by DMA errors.
 			 */
-			ATH5K_DBG(sc, ATH5K_DEBUG_RESET,
+			ATH5K_DBG(ah, ATH5K_DEBUG_RESET,
 				  "fatal int, resetting\n");
-			ieee80211_queue_work(sc->hw, &sc->reset_work);
+			ieee80211_queue_work(ah->hw, &ah->reset_work);
 		} else if (unlikely(status & AR5K_INT_RXORN)) {
 			/*
 			 * Receive buffers are full. Either the bus is busy or
@@ -2198,16 +2182,16 @@ ath5k_intr(int irq, void *dev_id)
 			 * We don't know exactly which versions need a reset -
 			 * this guess is copied from the HAL.
 			 */
-			sc->stats.rxorn_intr++;
+			ah->stats.rxorn_intr++;
 			if (ah->ah_mac_srev < AR5K_SREV_AR5212) {
-				ATH5K_DBG(sc, ATH5K_DEBUG_RESET,
+				ATH5K_DBG(ah, ATH5K_DEBUG_RESET,
 					  "rx overrun, resetting\n");
-				ieee80211_queue_work(sc->hw, &sc->reset_work);
+				ieee80211_queue_work(ah->hw, &ah->reset_work);
 			} else
-				ath5k_schedule_rx(sc);
+				ath5k_schedule_rx(ah);
 		} else {
 			if (status & AR5K_INT_SWBA)
-				tasklet_hi_schedule(&sc->beacontq);
+				tasklet_hi_schedule(&ah->beacontq);
 
 			if (status & AR5K_INT_RXEOL) {
 				/*
@@ -2215,27 +2199,27 @@ ath5k_intr(int irq, void *dev_id)
 				*     RXE bit is written, but it doesn't work at
 				*     least on older hardware revs.
 				*/
-				sc->stats.rxeol_intr++;
+				ah->stats.rxeol_intr++;
 			}
 			if (status & AR5K_INT_TXURN) {
 				/* bump tx trigger level */
 				ath5k_hw_update_tx_triglevel(ah, true);
 			}
 			if (status & (AR5K_INT_RXOK | AR5K_INT_RXERR))
-				ath5k_schedule_rx(sc);
+				ath5k_schedule_rx(ah);
 			if (status & (AR5K_INT_TXOK | AR5K_INT_TXDESC
 					| AR5K_INT_TXERR | AR5K_INT_TXEOL))
-				ath5k_schedule_tx(sc);
+				ath5k_schedule_tx(ah);
 			if (status & AR5K_INT_BMISS) {
 				/* TODO */
 			}
 			if (status & AR5K_INT_MIB) {
-				sc->stats.mib_intr++;
+				ah->stats.mib_intr++;
 				ath5k_hw_update_mib_counters(ah);
 				ath5k_ani_mib_intr(ah);
 			}
 			if (status & AR5K_INT_GPIO)
-				tasklet_schedule(&sc->rf_kill.toggleq);
+				tasklet_schedule(&ah->rf_kill.toggleq);
 
 		}
 
@@ -2244,11 +2228,11 @@ ath5k_intr(int irq, void *dev_id)
 
 	} while (ath5k_hw_is_intr_pending(ah) && --counter > 0);
 
-	if (sc->rx_pending || sc->tx_pending)
-		ath5k_set_current_imask(sc);
+	if (ah->rx_pending || ah->tx_pending)
+		ath5k_set_current_imask(ah);
 
 	if (unlikely(!counter))
-		ATH5K_WARN(sc, "too many interrupts, giving up for now\n");
+		ATH5K_WARN(ah, "too many interrupts, giving up for now\n");
 
 	ath5k_intr_calibration_poll(ah);
 
@@ -2262,28 +2246,27 @@ ath5k_intr(int irq, void *dev_id)
 static void
 ath5k_tasklet_calibrate(unsigned long data)
 {
-	struct ath5k_softc *sc = (void *)data;
-	struct ath5k_hw *ah = sc->ah;
+	struct ath5k_hw *ah = (void *)data;
 
 	/* Only full calibration for now */
 	ah->ah_cal_mask |= AR5K_CALIBRATION_FULL;
 
-	ATH5K_DBG(sc, ATH5K_DEBUG_CALIBRATE, "channel %u/%x\n",
-		ieee80211_frequency_to_channel(sc->curchan->center_freq),
-		sc->curchan->hw_value);
+	ATH5K_DBG(ah, ATH5K_DEBUG_CALIBRATE, "channel %u/%x\n",
+		ieee80211_frequency_to_channel(ah->curchan->center_freq),
+		ah->curchan->hw_value);
 
 	if (ath5k_hw_gainf_calibrate(ah) == AR5K_RFGAIN_NEED_CHANGE) {
 		/*
 		 * Rfgain is out of bounds, reset the chip
 		 * to load new gain values.
 		 */
-		ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "calibration, resetting\n");
-		ieee80211_queue_work(sc->hw, &sc->reset_work);
+		ATH5K_DBG(ah, ATH5K_DEBUG_RESET, "calibration, resetting\n");
+		ieee80211_queue_work(ah->hw, &ah->reset_work);
 	}
-	if (ath5k_hw_phy_calibrate(ah, sc->curchan))
-		ATH5K_ERR(sc, "calibration of channel %u failed\n",
+	if (ath5k_hw_phy_calibrate(ah, ah->curchan))
+		ATH5K_ERR(ah, "calibration of channel %u failed\n",
 			ieee80211_frequency_to_channel(
-				sc->curchan->center_freq));
+				ah->curchan->center_freq));
 
 	/* Noise floor calibration interrupts rx/tx path while I/Q calibration
 	 * doesn't.
@@ -2302,8 +2285,7 @@ ath5k_tasklet_calibrate(unsigned long data)
 static void
 ath5k_tasklet_ani(unsigned long data)
 {
-	struct ath5k_softc *sc = (void *)data;
-	struct ath5k_hw *ah = sc->ah;
+	struct ath5k_hw *ah = (void *)data;
 
 	ah->ah_cal_mask |= AR5K_CALIBRATION_ANI;
 	ath5k_ani_calibration(ah);
@@ -2314,21 +2296,21 @@ ath5k_tasklet_ani(unsigned long data)
 static void
 ath5k_tx_complete_poll_work(struct work_struct *work)
 {
-	struct ath5k_softc *sc = container_of(work, struct ath5k_softc,
+	struct ath5k_hw *ah = container_of(work, struct ath5k_hw,
 			tx_complete_work.work);
 	struct ath5k_txq *txq;
 	int i;
 	bool needreset = false;
 
-	mutex_lock(&sc->lock);
+	mutex_lock(&ah->lock);
 
-	for (i = 0; i < ARRAY_SIZE(sc->txqs); i++) {
-		if (sc->txqs[i].setup) {
-			txq = &sc->txqs[i];
+	for (i = 0; i < ARRAY_SIZE(ah->txqs); i++) {
+		if (ah->txqs[i].setup) {
+			txq = &ah->txqs[i];
 			spin_lock_bh(&txq->lock);
 			if (txq->txq_len > 1) {
 				if (txq->txq_poll_mark) {
-					ATH5K_DBG(sc, ATH5K_DEBUG_XMIT,
+					ATH5K_DBG(ah, ATH5K_DEBUG_XMIT,
 						  "TX queue stuck %d\n",
 						  txq->qnum);
 					needreset = true;
@@ -2344,14 +2326,14 @@ ath5k_tx_complete_poll_work(struct work_struct *work)
 	}
 
 	if (needreset) {
-		ATH5K_DBG(sc, ATH5K_DEBUG_RESET,
+		ATH5K_DBG(ah, ATH5K_DEBUG_RESET,
 			  "TX queues stuck, resetting\n");
-		ath5k_reset(sc, NULL, true);
+		ath5k_reset(ah, NULL, true);
 	}
 
-	mutex_unlock(&sc->lock);
+	mutex_unlock(&ah->lock);
 
-	ieee80211_queue_delayed_work(sc->hw, &sc->tx_complete_work,
+	ieee80211_queue_delayed_work(ah->hw, &ah->tx_complete_work,
 		msecs_to_jiffies(ATH5K_TX_COMPLETE_POLL_INT));
 }
 
@@ -2361,15 +2343,15 @@ ath5k_tx_complete_poll_work(struct work_struct *work)
 \*************************/
 
 int __devinit
-ath5k_init_softc(struct ath5k_softc *sc, const struct ath_bus_ops *bus_ops)
+ath5k_init_ah(struct ath5k_hw *ah, const struct ath_bus_ops *bus_ops)
 {
-	struct ieee80211_hw *hw = sc->hw;
+	struct ieee80211_hw *hw = ah->hw;
 	struct ath_common *common;
 	int ret;
 	int csz;
 
 	/* Initialize driver private data */
-	SET_IEEE80211_DEV(hw, sc->dev);
+	SET_IEEE80211_DEV(hw, ah->dev);
 	hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
 			IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
 			IEEE80211_HW_SIGNAL_DBM |
@@ -2392,39 +2374,29 @@ ath5k_init_softc(struct ath5k_softc *sc, const struct ath_bus_ops *bus_ops)
 	 * Mark the device as detached to avoid processing
 	 * interrupts until setup is complete.
 	 */
-	__set_bit(ATH_STAT_INVALID, sc->status);
+	__set_bit(ATH_STAT_INVALID, ah->status);
 
-	sc->opmode = NL80211_IFTYPE_STATION;
-	sc->bintval = 1000;
-	mutex_init(&sc->lock);
-	spin_lock_init(&sc->rxbuflock);
-	spin_lock_init(&sc->txbuflock);
-	spin_lock_init(&sc->block);
-	spin_lock_init(&sc->irqlock);
+	ah->opmode = NL80211_IFTYPE_STATION;
+	ah->bintval = 1000;
+	mutex_init(&ah->lock);
+	spin_lock_init(&ah->rxbuflock);
+	spin_lock_init(&ah->txbuflock);
+	spin_lock_init(&ah->block);
+	spin_lock_init(&ah->irqlock);
 
 	/* Setup interrupt handler */
-	ret = request_irq(sc->irq, ath5k_intr, IRQF_SHARED, "ath", sc);
+	ret = request_irq(ah->irq, ath5k_intr, IRQF_SHARED, "ath", ah);
 	if (ret) {
-		ATH5K_ERR(sc, "request_irq failed\n");
+		ATH5K_ERR(ah, "request_irq failed\n");
 		goto err;
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
+	common = ath5k_hw_common(ah);
 	common->ops = &ath5k_common_ops;
 	common->bus_ops = bus_ops;
-	common->ah = sc->ah;
+	common->ah = ah;
 	common->hw = hw;
-	common->priv = sc;
+	common->priv = ah;
 	common->clockrate = 40;
 
 	/*
@@ -2437,12 +2409,12 @@ ath5k_init_softc(struct ath5k_softc *sc, const struct ath_bus_ops *bus_ops)
 	spin_lock_init(&common->cc_lock);
 
 	/* Initialize device */
-	ret = ath5k_hw_init(sc);
+	ret = ath5k_hw_init(ah);
 	if (ret)
-		goto err_free_ah;
+		goto err_irq;
 
 	/* set up multi-rate retry capabilities */
-	if (sc->ah->ah_version == AR5K_AR5212) {
+	if (ah->ah_version == AR5K_AR5212) {
 		hw->max_rates = 4;
 		hw->max_rate_tries = max(AR5K_INIT_RETRY_SHORT,
 					 AR5K_INIT_RETRY_LONG);
@@ -2455,77 +2427,74 @@ ath5k_init_softc(struct ath5k_softc *sc, const struct ath_bus_ops *bus_ops)
 	if (ret)
 		goto err_ah;
 
-	ATH5K_INFO(sc, "Atheros AR%s chip found (MAC: 0x%x, PHY: 0x%x)\n",
-			ath5k_chip_name(AR5K_VERSION_MAC, sc->ah->ah_mac_srev),
-					sc->ah->ah_mac_srev,
-					sc->ah->ah_phy_revision);
+	ATH5K_INFO(ah, "Atheros AR%s chip found (MAC: 0x%x, PHY: 0x%x)\n",
+			ath5k_chip_name(AR5K_VERSION_MAC, ah->ah_mac_srev),
+					ah->ah_mac_srev,
+					ah->ah_phy_revision);
 
-	if (!sc->ah->ah_single_chip) {
+	if (!ah->ah_single_chip) {
 		/* Single chip radio (!RF5111) */
-		if (sc->ah->ah_radio_5ghz_revision &&
-			!sc->ah->ah_radio_2ghz_revision) {
+		if (ah->ah_radio_5ghz_revision &&
+			!ah->ah_radio_2ghz_revision) {
 			/* No 5GHz support -> report 2GHz radio */
 			if (!test_bit(AR5K_MODE_11A,
-				sc->ah->ah_capabilities.cap_mode)) {
-				ATH5K_INFO(sc, "RF%s 2GHz radio found (0x%x)\n",
+				ah->ah_capabilities.cap_mode)) {
+				ATH5K_INFO(ah, "RF%s 2GHz radio found (0x%x)\n",
 					ath5k_chip_name(AR5K_VERSION_RAD,
-						sc->ah->ah_radio_5ghz_revision),
-						sc->ah->ah_radio_5ghz_revision);
+						ah->ah_radio_5ghz_revision),
+						ah->ah_radio_5ghz_revision);
 			/* No 2GHz support (5110 and some
 			 * 5GHz only cards) -> report 5GHz radio */
 			} else if (!test_bit(AR5K_MODE_11B,
-				sc->ah->ah_capabilities.cap_mode)) {
-				ATH5K_INFO(sc, "RF%s 5GHz radio found (0x%x)\n",
+				ah->ah_capabilities.cap_mode)) {
+				ATH5K_INFO(ah, "RF%s 5GHz radio found (0x%x)\n",
 					ath5k_chip_name(AR5K_VERSION_RAD,
-						sc->ah->ah_radio_5ghz_revision),
-						sc->ah->ah_radio_5ghz_revision);
+						ah->ah_radio_5ghz_revision),
+						ah->ah_radio_5ghz_revision);
 			/* Multiband radio */
 			} else {
-				ATH5K_INFO(sc, "RF%s multiband radio found"
+				ATH5K_INFO(ah, "RF%s multiband radio found"
 					" (0x%x)\n",
 					ath5k_chip_name(AR5K_VERSION_RAD,
-						sc->ah->ah_radio_5ghz_revision),
-						sc->ah->ah_radio_5ghz_revision);
+						ah->ah_radio_5ghz_revision),
+						ah->ah_radio_5ghz_revision);
 			}
 		}
 		/* Multi chip radio (RF5111 - RF2111) ->
 		 * report both 2GHz/5GHz radios */
-		else if (sc->ah->ah_radio_5ghz_revision &&
-				sc->ah->ah_radio_2ghz_revision) {
-			ATH5K_INFO(sc, "RF%s 5GHz radio found (0x%x)\n",
+		else if (ah->ah_radio_5ghz_revision &&
+				ah->ah_radio_2ghz_revision) {
+			ATH5K_INFO(ah, "RF%s 5GHz radio found (0x%x)\n",
 				ath5k_chip_name(AR5K_VERSION_RAD,
-					sc->ah->ah_radio_5ghz_revision),
-					sc->ah->ah_radio_5ghz_revision);
-			ATH5K_INFO(sc, "RF%s 2GHz radio found (0x%x)\n",
+					ah->ah_radio_5ghz_revision),
+					ah->ah_radio_5ghz_revision);
+			ATH5K_INFO(ah, "RF%s 2GHz radio found (0x%x)\n",
 				ath5k_chip_name(AR5K_VERSION_RAD,
-					sc->ah->ah_radio_2ghz_revision),
-					sc->ah->ah_radio_2ghz_revision);
+					ah->ah_radio_2ghz_revision),
+					ah->ah_radio_2ghz_revision);
 		}
 	}
 
-	ath5k_debug_init_device(sc);
+	ath5k_debug_init_device(ah);
 
 	/* ready to process interrupts */
-	__clear_bit(ATH_STAT_INVALID, sc->status);
+	__clear_bit(ATH_STAT_INVALID, ah->status);
 
 	return 0;
 err_ah:
-	ath5k_hw_deinit(sc->ah);
-err_free_ah:
-	kfree(sc->ah);
+	ath5k_hw_deinit(ah);
 err_irq:
-	free_irq(sc->irq, sc);
+	free_irq(ah->irq, ah);
 err:
 	return ret;
 }
 
 static int
-ath5k_stop_locked(struct ath5k_softc *sc)
+ath5k_stop_locked(struct ath5k_hw *ah)
 {
-	struct ath5k_hw *ah = sc->ah;
 
-	ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "invalid %u\n",
-			test_bit(ATH_STAT_INVALID, sc->status));
+	ATH5K_DBG(ah, ATH5K_DEBUG_RESET, "invalid %u\n",
+			test_bit(ATH_STAT_INVALID, ah->status));
 
 	/*
 	 * Shutdown the hardware and driver:
@@ -2542,15 +2511,15 @@ ath5k_stop_locked(struct ath5k_softc *sc)
 	 * Note that some of this work is not possible if the
 	 * hardware is gone (invalid).
 	 */
-	ieee80211_stop_queues(sc->hw);
+	ieee80211_stop_queues(ah->hw);
 
-	if (!test_bit(ATH_STAT_INVALID, sc->status)) {
-		ath5k_led_off(sc);
+	if (!test_bit(ATH_STAT_INVALID, ah->status)) {
+		ath5k_led_off(ah);
 		ath5k_hw_set_imr(ah, 0);
-		synchronize_irq(sc->irq);
-		ath5k_rx_stop(sc);
+		synchronize_irq(ah->irq);
+		ath5k_rx_stop(ah);
 		ath5k_hw_dma_stop(ah);
-		ath5k_drain_tx_buffs(sc);
+		ath5k_drain_tx_buffs(ah);
 		ath5k_hw_phy_disable(ah);
 	}
 
@@ -2558,21 +2527,20 @@ ath5k_stop_locked(struct ath5k_softc *sc)
 }
 
 int
-ath5k_init_hw(struct ath5k_softc *sc)
+ath5k_init_hw(struct ath5k_hw *ah)
 {
-	struct ath5k_hw *ah = sc->ah;
 	struct ath_common *common = ath5k_hw_common(ah);
 	int ret, i;
 
-	mutex_lock(&sc->lock);
+	mutex_lock(&ah->lock);
 
-	ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "mode %d\n", sc->opmode);
+	ATH5K_DBG(ah, ATH5K_DEBUG_RESET, "mode %d\n", ah->opmode);
 
 	/*
 	 * Stop anything previously setup.  This is safe
 	 * no matter this is the first time through or not.
 	 */
-	ath5k_stop_locked(sc);
+	ath5k_stop_locked(ah);
 
 	/*
 	 * The basic interface to setting the hardware in a good
@@ -2581,12 +2549,12 @@ ath5k_init_hw(struct ath5k_softc *sc)
 	 * be followed by initialization of the appropriate bits
 	 * and then setup of the interrupt mask.
 	 */
-	sc->curchan = sc->hw->conf.channel;
-	sc->imask = AR5K_INT_RXOK | AR5K_INT_RXERR | AR5K_INT_RXEOL |
+	ah->curchan = ah->hw->conf.channel;
+	ah->imask = AR5K_INT_RXOK | AR5K_INT_RXERR | AR5K_INT_RXEOL |
 		AR5K_INT_RXORN | AR5K_INT_TXDESC | AR5K_INT_TXEOL |
 		AR5K_INT_FATAL | AR5K_INT_GLOBAL | AR5K_INT_MIB;
 
-	ret = ath5k_reset(sc, NULL, false);
+	ret = ath5k_reset(ah, NULL, false);
 	if (ret)
 		goto done;
 
@@ -2603,29 +2571,29 @@ ath5k_init_hw(struct ath5k_softc *sc)
 	 * rate */
 	ah->ah_ack_bitrate_high = true;
 
-	for (i = 0; i < ARRAY_SIZE(sc->bslot); i++)
-		sc->bslot[i] = NULL;
+	for (i = 0; i < ARRAY_SIZE(ah->bslot); i++)
+		ah->bslot[i] = NULL;
 
 	ret = 0;
 done:
 	mmiowb();
-	mutex_unlock(&sc->lock);
+	mutex_unlock(&ah->lock);
 
-	ieee80211_queue_delayed_work(sc->hw, &sc->tx_complete_work,
+	ieee80211_queue_delayed_work(ah->hw, &ah->tx_complete_work,
 			msecs_to_jiffies(ATH5K_TX_COMPLETE_POLL_INT));
 
 	return ret;
 }
 
-static void ath5k_stop_tasklets(struct ath5k_softc *sc)
+static void ath5k_stop_tasklets(struct ath5k_hw *ah)
 {
-	sc->rx_pending = false;
-	sc->tx_pending = false;
-	tasklet_kill(&sc->rxtq);
-	tasklet_kill(&sc->txtq);
-	tasklet_kill(&sc->calib);
-	tasklet_kill(&sc->beacontq);
-	tasklet_kill(&sc->ani_tasklet);
+	ah->rx_pending = false;
+	ah->tx_pending = false;
+	tasklet_kill(&ah->rxtq);
+	tasklet_kill(&ah->txtq);
+	tasklet_kill(&ah->calib);
+	tasklet_kill(&ah->beacontq);
+	tasklet_kill(&ah->ani_tasklet);
 }
 
 /*
@@ -2635,13 +2603,13 @@ static void ath5k_stop_tasklets(struct ath5k_softc *sc)
  * stop is preempted).
  */
 int
-ath5k_stop_hw(struct ath5k_softc *sc)
+ath5k_stop_hw(struct ath5k_hw *ah)
 {
 	int ret;
 
-	mutex_lock(&sc->lock);
-	ret = ath5k_stop_locked(sc);
-	if (ret == 0 && !test_bit(ATH_STAT_INVALID, sc->status)) {
+	mutex_lock(&ah->lock);
+	ret = ath5k_stop_locked(ah);
+	if (ret == 0 && !test_bit(ATH_STAT_INVALID, ah->status)) {
 		/*
 		 * Don't set the card in full sleep mode!
 		 *
@@ -2662,20 +2630,20 @@ ath5k_stop_hw(struct ath5k_softc *sc)
 		 * and Sam's HAL do anyway). Instead Perform a full reset
 		 * on the device (same as initial state after attach) and
 		 * leave it idle (keep MAC/BB on warm reset) */
-		ret = ath5k_hw_on_hold(sc->ah);
+		ret = ath5k_hw_on_hold(ah);
 
-		ATH5K_DBG(sc, ATH5K_DEBUG_RESET,
+		ATH5K_DBG(ah, ATH5K_DEBUG_RESET,
 				"putting device to sleep\n");
 	}
 
 	mmiowb();
-	mutex_unlock(&sc->lock);
+	mutex_unlock(&ah->lock);
 
-	ath5k_stop_tasklets(sc);
+	ath5k_stop_tasklets(ah);
 
-	cancel_delayed_work_sync(&sc->tx_complete_work);
+	cancel_delayed_work_sync(&ah->tx_complete_work);
 
-	ath5k_rfkill_hw_stop(sc->ah);
+	ath5k_rfkill_hw_stop(ah);
 
 	return ret;
 }
@@ -2684,47 +2652,46 @@ ath5k_stop_hw(struct ath5k_softc *sc)
  * Reset the hardware.  If chan is not NULL, then also pause rx/tx
  * and change to the given channel.
  *
- * This should be called with sc->lock.
+ * This should be called with ah->lock.
  */
 static int
-ath5k_reset(struct ath5k_softc *sc, struct ieee80211_channel *chan,
+ath5k_reset(struct ath5k_hw *ah, struct ieee80211_channel *chan,
 							bool skip_pcu)
 {
-	struct ath5k_hw *ah = sc->ah;
 	struct ath_common *common = ath5k_hw_common(ah);
 	int ret, ani_mode;
 	bool fast;
 
-	ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "resetting\n");
+	ATH5K_DBG(ah, ATH5K_DEBUG_RESET, "resetting\n");
 
 	ath5k_hw_set_imr(ah, 0);
-	synchronize_irq(sc->irq);
-	ath5k_stop_tasklets(sc);
+	synchronize_irq(ah->irq);
+	ath5k_stop_tasklets(ah);
 
 	/* Save ani mode and disable ANI during
 	 * reset. If we don't we might get false
 	 * PHY error interrupts. */
-	ani_mode = ah->ah_sc->ani_state.ani_mode;
+	ani_mode = ah->ani_state.ani_mode;
 	ath5k_ani_init(ah, ATH5K_ANI_MODE_OFF);
 
 	/* We are going to empty hw queues
 	 * so we should also free any remaining
 	 * tx buffers */
-	ath5k_drain_tx_buffs(sc);
+	ath5k_drain_tx_buffs(ah);
 	if (chan)
-		sc->curchan = chan;
+		ah->curchan = chan;
 
 	fast = ((chan != NULL) && modparam_fastchanswitch) ? 1 : 0;
 
-	ret = ath5k_hw_reset(ah, sc->opmode, sc->curchan, fast, skip_pcu);
+	ret = ath5k_hw_reset(ah, ah->opmode, ah->curchan, fast, skip_pcu);
 	if (ret) {
-		ATH5K_ERR(sc, "can't reset hardware (%d)\n", ret);
+		ATH5K_ERR(ah, "can't reset hardware (%d)\n", ret);
 		goto err;
 	}
 
-	ret = ath5k_rx_start(sc);
+	ret = ath5k_rx_start(ah);
 	if (ret) {
-		ATH5K_ERR(sc, "can't start recv logic\n");
+		ATH5K_ERR(ah, "can't start recv logic\n");
 		goto err;
 	}
 
@@ -2736,7 +2703,7 @@ ath5k_reset(struct ath5k_softc *sc, struct ieee80211_channel *chan,
 	ewma_init(&ah->ah_beacon_rssi_avg, 1024, 8);
 
 	/* clear survey data and cycle counters */
-	memset(&sc->survey, 0, sizeof(sc->survey));
+	memset(&ah->survey, 0, sizeof(ah->survey));
 	spin_lock_bh(&common->cc_lock);
 	ath_hw_cycle_counters_update(common);
 	memset(&common->cc_survey, 0, sizeof(common->cc_survey));
@@ -2752,12 +2719,12 @@ ath5k_reset(struct ath5k_softc *sc, struct ieee80211_channel *chan,
 	 *
 	 * XXX needed?
 	 */
-/*	ath5k_chan_change(sc, c); */
+/*	ath5k_chan_change(ah, c); */
 
-	ath5k_beacon_config(sc);
+	ath5k_beacon_config(ah);
 	/* intrs are enabled by ath5k_beacon_config */
 
-	ieee80211_wake_queues(sc->hw);
+	ieee80211_wake_queues(ah->hw);
 
 	return 0;
 err:
@@ -2766,20 +2733,19 @@ err:
 
 static void ath5k_reset_work(struct work_struct *work)
 {
-	struct ath5k_softc *sc = container_of(work, struct ath5k_softc,
+	struct ath5k_hw *ah = container_of(work, struct ath5k_hw,
 		reset_work);
 
-	mutex_lock(&sc->lock);
-	ath5k_reset(sc, NULL, true);
-	mutex_unlock(&sc->lock);
+	mutex_lock(&ah->lock);
+	ath5k_reset(ah, NULL, true);
+	mutex_unlock(&ah->lock);
 }
 
 static int __devinit
 ath5k_init(struct ieee80211_hw *hw)
 {
 
-	struct ath5k_softc *sc = hw->priv;
-	struct ath5k_hw *ah = sc->ah;
+	struct ath5k_hw *ah = hw->priv;
 	struct ath_regulatory *regulatory = ath5k_hw_regulatory(ah);
 	struct ath5k_txq *txq;
 	u8 mac[ETH_ALEN] = {};
@@ -2798,7 +2764,7 @@ ath5k_init(struct ieee80211_hw *hw)
 	if (ret < 0)
 		goto err;
 	if (ret > 0)
-		__set_bit(ATH_STAT_MRRETRY, sc->status);
+		__set_bit(ATH_STAT_MRRETRY, ah->status);
 
 	/*
 	 * Collect the channel list.  The 802.11 layer
@@ -2808,16 +2774,16 @@ ath5k_init(struct ieee80211_hw *hw)
 	 */
 	ret = ath5k_setup_bands(hw);
 	if (ret) {
-		ATH5K_ERR(sc, "can't get channels\n");
+		ATH5K_ERR(ah, "can't get channels\n");
 		goto err;
 	}
 
 	/*
 	 * Allocate tx+rx descriptors and populate the lists.
 	 */
-	ret = ath5k_desc_alloc(sc);
+	ret = ath5k_desc_alloc(ah);
 	if (ret) {
-		ATH5K_ERR(sc, "can't allocate descriptors\n");
+		ATH5K_ERR(ah, "can't allocate descriptors\n");
 		goto err;
 	}
 
@@ -2829,14 +2795,14 @@ ath5k_init(struct ieee80211_hw *hw)
 	 */
 	ret = ath5k_beaconq_setup(ah);
 	if (ret < 0) {
-		ATH5K_ERR(sc, "can't setup a beacon xmit queue\n");
+		ATH5K_ERR(ah, "can't setup a beacon xmit queue\n");
 		goto err_desc;
 	}
-	sc->bhalq = ret;
-	sc->cabq = ath5k_txq_setup(sc, AR5K_TX_QUEUE_CAB, 0);
-	if (IS_ERR(sc->cabq)) {
-		ATH5K_ERR(sc, "can't setup cab queue\n");
-		ret = PTR_ERR(sc->cabq);
+	ah->bhalq = ret;
+	ah->cabq = ath5k_txq_setup(ah, AR5K_TX_QUEUE_CAB, 0);
+	if (IS_ERR(ah->cabq)) {
+		ATH5K_ERR(ah, "can't setup cab queue\n");
+		ret = PTR_ERR(ah->cabq);
 		goto err_bhal;
 	}
 
@@ -2845,97 +2811,97 @@ ath5k_init(struct ieee80211_hw *hw)
 	if (ah->ah_capabilities.cap_queues.q_tx_num >= 6) {
 		/* This order matches mac80211's queue priority, so we can
 		* directly use the mac80211 queue number without any mapping */
-		txq = ath5k_txq_setup(sc, AR5K_TX_QUEUE_DATA, AR5K_WME_AC_VO);
+		txq = ath5k_txq_setup(ah, AR5K_TX_QUEUE_DATA, AR5K_WME_AC_VO);
 		if (IS_ERR(txq)) {
-			ATH5K_ERR(sc, "can't setup xmit queue\n");
+			ATH5K_ERR(ah, "can't setup xmit queue\n");
 			ret = PTR_ERR(txq);
 			goto err_queues;
 		}
-		txq = ath5k_txq_setup(sc, AR5K_TX_QUEUE_DATA, AR5K_WME_AC_VI);
+		txq = ath5k_txq_setup(ah, AR5K_TX_QUEUE_DATA, AR5K_WME_AC_VI);
 		if (IS_ERR(txq)) {
-			ATH5K_ERR(sc, "can't setup xmit queue\n");
+			ATH5K_ERR(ah, "can't setup xmit queue\n");
 			ret = PTR_ERR(txq);
 			goto err_queues;
 		}
-		txq = ath5k_txq_setup(sc, AR5K_TX_QUEUE_DATA, AR5K_WME_AC_BE);
+		txq = ath5k_txq_setup(ah, AR5K_TX_QUEUE_DATA, AR5K_WME_AC_BE);
 		if (IS_ERR(txq)) {
-			ATH5K_ERR(sc, "can't setup xmit queue\n");
+			ATH5K_ERR(ah, "can't setup xmit queue\n");
 			ret = PTR_ERR(txq);
 			goto err_queues;
 		}
-		txq = ath5k_txq_setup(sc, AR5K_TX_QUEUE_DATA, AR5K_WME_AC_BK);
+		txq = ath5k_txq_setup(ah, AR5K_TX_QUEUE_DATA, AR5K_WME_AC_BK);
 		if (IS_ERR(txq)) {
-			ATH5K_ERR(sc, "can't setup xmit queue\n");
+			ATH5K_ERR(ah, "can't setup xmit queue\n");
 			ret = PTR_ERR(txq);
 			goto err_queues;
 		}
 		hw->queues = 4;
 	} else {
 		/* older hardware (5210) can only support one data queue */
-		txq = ath5k_txq_setup(sc, AR5K_TX_QUEUE_DATA, AR5K_WME_AC_BE);
+		txq = ath5k_txq_setup(ah, AR5K_TX_QUEUE_DATA, AR5K_WME_AC_BE);
 		if (IS_ERR(txq)) {
-			ATH5K_ERR(sc, "can't setup xmit queue\n");
+			ATH5K_ERR(ah, "can't setup xmit queue\n");
 			ret = PTR_ERR(txq);
 			goto err_queues;
 		}
 		hw->queues = 1;
 	}
 
-	tasklet_init(&sc->rxtq, ath5k_tasklet_rx, (unsigned long)sc);
-	tasklet_init(&sc->txtq, ath5k_tasklet_tx, (unsigned long)sc);
-	tasklet_init(&sc->calib, ath5k_tasklet_calibrate, (unsigned long)sc);
-	tasklet_init(&sc->beacontq, ath5k_tasklet_beacon, (unsigned long)sc);
-	tasklet_init(&sc->ani_tasklet, ath5k_tasklet_ani, (unsigned long)sc);
+	tasklet_init(&ah->rxtq, ath5k_tasklet_rx, (unsigned long)ah);
+	tasklet_init(&ah->txtq, ath5k_tasklet_tx, (unsigned long)ah);
+	tasklet_init(&ah->calib, ath5k_tasklet_calibrate, (unsigned long)ah);
+	tasklet_init(&ah->beacontq, ath5k_tasklet_beacon, (unsigned long)ah);
+	tasklet_init(&ah->ani_tasklet, ath5k_tasklet_ani, (unsigned long)ah);
 
-	INIT_WORK(&sc->reset_work, ath5k_reset_work);
-	INIT_DELAYED_WORK(&sc->tx_complete_work, ath5k_tx_complete_poll_work);
+	INIT_WORK(&ah->reset_work, ath5k_reset_work);
+	INIT_DELAYED_WORK(&ah->tx_complete_work, ath5k_tx_complete_poll_work);
 
 	ret = ath5k_hw_common(ah)->bus_ops->eeprom_read_mac(ah, mac);
 	if (ret) {
-		ATH5K_ERR(sc, "unable to read address from EEPROM\n");
+		ATH5K_ERR(ah, "unable to read address from EEPROM\n");
 		goto err_queues;
 	}
 
 	SET_IEEE80211_PERM_ADDR(hw, mac);
-	memcpy(&sc->lladdr, mac, ETH_ALEN);
+	memcpy(&ah->lladdr, mac, ETH_ALEN);
 	/* All MAC address bits matter for ACKs */
-	ath5k_update_bssid_mask_and_opmode(sc, NULL);
+	ath5k_update_bssid_mask_and_opmode(ah, NULL);
 
 	regulatory->current_rd = ah->ah_capabilities.cap_eeprom.ee_regdomain;
 	ret = ath_regd_init(regulatory, hw->wiphy, ath5k_reg_notifier);
 	if (ret) {
-		ATH5K_ERR(sc, "can't initialize regulatory system\n");
+		ATH5K_ERR(ah, "can't initialize regulatory system\n");
 		goto err_queues;
 	}
 
 	ret = ieee80211_register_hw(hw);
 	if (ret) {
-		ATH5K_ERR(sc, "can't register ieee80211 hw\n");
+		ATH5K_ERR(ah, "can't register ieee80211 hw\n");
 		goto err_queues;
 	}
 
 	if (!ath_is_world_regd(regulatory))
 		regulatory_hint(hw->wiphy, regulatory->alpha2);
 
-	ath5k_init_leds(sc);
+	ath5k_init_leds(ah);
 
-	ath5k_sysfs_register(sc);
+	ath5k_sysfs_register(ah);
 
 	return 0;
 err_queues:
-	ath5k_txq_release(sc);
+	ath5k_txq_release(ah);
 err_bhal:
-	ath5k_hw_release_tx_queue(ah, sc->bhalq);
+	ath5k_hw_release_tx_queue(ah, ah->bhalq);
 err_desc:
-	ath5k_desc_free(sc);
+	ath5k_desc_free(ah);
 err:
 	return ret;
 }
 
 void
-ath5k_deinit_softc(struct ath5k_softc *sc)
+ath5k_deinit_ah(struct ath5k_hw *ah)
 {
-	struct ieee80211_hw *hw = sc->hw;
+	struct ieee80211_hw *hw = ah->hw;
 
 	/*
 	 * NB: the order of these is important:
@@ -2951,24 +2917,23 @@ ath5k_deinit_softc(struct ath5k_softc *sc)
 	 * Other than that, it's straightforward...
 	 */
 	ieee80211_unregister_hw(hw);
-	ath5k_desc_free(sc);
-	ath5k_txq_release(sc);
-	ath5k_hw_release_tx_queue(sc->ah, sc->bhalq);
-	ath5k_unregister_leds(sc);
+	ath5k_desc_free(ah);
+	ath5k_txq_release(ah);
+	ath5k_hw_release_tx_queue(ah, ah->bhalq);
+	ath5k_unregister_leds(ah);
 
-	ath5k_sysfs_unregister(sc);
+	ath5k_sysfs_unregister(ah);
 	/*
 	 * NB: can't reclaim these until after ieee80211_ifdetach
 	 * returns because we'll get called back to reclaim node
 	 * state and potentially want to use them.
 	 */
-	ath5k_hw_deinit(sc->ah);
-	kfree(sc->ah);
-	free_irq(sc->irq, sc);
+	ath5k_hw_deinit(ah);
+	free_irq(ah->irq, ah);
 }
 
 bool
-ath5k_any_vif_assoc(struct ath5k_softc *sc)
+ath5k_any_vif_assoc(struct ath5k_hw *ah)
 {
 	struct ath5k_vif_iter_data iter_data;
 	iter_data.hw_macaddr = NULL;
@@ -2976,7 +2941,7 @@ ath5k_any_vif_assoc(struct ath5k_softc *sc)
 	iter_data.need_set_hw_addr = false;
 	iter_data.found_active = true;
 
-	ieee80211_iterate_active_interfaces_atomic(sc->hw, ath5k_vif_iter,
+	ieee80211_iterate_active_interfaces_atomic(ah->hw, ath5k_vif_iter,
 						   &iter_data);
 	return iter_data.any_assoc;
 }
@@ -2984,8 +2949,7 @@ ath5k_any_vif_assoc(struct ath5k_softc *sc)
 void
 ath5k_set_beacon_filter(struct ieee80211_hw *hw, bool enable)
 {
-	struct ath5k_softc *sc = hw->priv;
-	struct ath5k_hw *ah = sc->ah;
+	struct ath5k_hw *ah = hw->priv;
 	u32 rfilt;
 	rfilt = ath5k_hw_get_rx_filter(ah);
 	if (enable)
@@ -2993,5 +2957,5 @@ ath5k_set_beacon_filter(struct ieee80211_hw *hw, bool enable)
 	else
 		rfilt &= ~AR5K_RX_FILTER_BEACON;
 	ath5k_hw_set_rx_filter(ah, rfilt);
-	sc->filter_flags = rfilt;
+	ah->filter_flags = rfilt;
 }
diff --git a/drivers/net/wireless/ath/ath5k/base.h b/drivers/net/wireless/ath/ath5k/base.h
index 0a98777..d8ceb97 100644
--- a/drivers/net/wireless/ath/ath5k/base.h
+++ b/drivers/net/wireless/ath/ath5k/base.h
@@ -41,27 +41,14 @@
 #ifndef _DEV_ATH_ATHVAR_H
 #define _DEV_ATH_ATHVAR_H
 
-#include <linux/interrupt.h>
 #include <linux/list.h>
 #include <linux/wireless.h>
 #include <linux/if_ether.h>
-#include <linux/leds.h>
-#include <linux/rfkill.h>
-#include <linux/workqueue.h>
 
 #include "ath5k.h"
-#include "debug.h"
-#include "ani.h"
-
 #include "../regd.h"
 #include "../ath.h"
 
-#define	ATH_RXBUF	40		/* number of RX buffers */
-#define	ATH_TXBUF	200		/* number of TX buffers */
-#define ATH_BCBUF	4		/* number of beacon buffers */
-#define ATH5K_TXQ_LEN_MAX	(ATH_TXBUF / 4)		/* bufs per queue */
-#define ATH5K_TXQ_LEN_LOW	(ATH5K_TXQ_LEN_MAX / 2)	/* low mark */
-
 struct ath5k_buf {
 	struct list_head	list;
 	struct ath5k_desc	*desc;	/* virtual addr of desc */
@@ -70,94 +57,6 @@ struct ath5k_buf {
 	dma_addr_t		skbaddr;/* physical addr of skb data */
 };
 
-/*
- * Data transmit queue state.  One of these exists for each
- * hardware transmit queue.  Packets sent to us from above
- * are assigned to queues based on their priority.  Not all
- * devices support a complete set of hardware transmit queues.
- * For those devices the array sc_ac2q will map multiple
- * priorities to fewer hardware queues (typically all to one
- * hardware queue).
- */
-struct ath5k_txq {
-	unsigned int		qnum;	/* hardware q number */
-	u32			*link;	/* link ptr in last TX desc */
-	struct list_head	q;	/* transmit queue */
-	spinlock_t		lock;	/* lock on q and link */
-	bool			setup;
-	int			txq_len; /* number of queued buffers */
-	int			txq_max; /* max allowed num of queued buffers */
-	bool			txq_poll_mark;
-	unsigned int		txq_stuck;	/* informational counter */
-};
-
-#define ATH5K_LED_MAX_NAME_LEN 31
-
-/*
- * State for LED triggers
- */
-struct ath5k_led {
-	char name[ATH5K_LED_MAX_NAME_LEN + 1];	/* name of the LED in sysfs */
-	struct ath5k_softc *sc;			/* driver state */
-	struct led_classdev led_dev;		/* led classdev */
-};
-
-/* Rfkill */
-struct ath5k_rfkill {
-	/* GPIO PIN for rfkill */
-	u16 gpio;
-	/* polarity of rfkill GPIO PIN */
-	bool polarity;
-	/* RFKILL toggle tasklet */
-	struct tasklet_struct toggleq;
-};
-
-/* statistics */
-struct ath5k_statistics {
-	/* antenna use */
-	unsigned int antenna_rx[5];	/* frames count per antenna RX */
-	unsigned int antenna_tx[5];	/* frames count per antenna TX */
-
-	/* frame errors */
-	unsigned int rx_all_count;	/* all RX frames, including errors */
-	unsigned int tx_all_count;	/* all TX frames, including errors */
-	unsigned int rx_bytes_count;	/* all RX bytes, including errored pkts
-					 * and the MAC headers for each packet
-					 */
-	unsigned int tx_bytes_count;	/* all TX bytes, including errored pkts
-					 * and the MAC headers and padding for
-					 * each packet.
-					 */
-	unsigned int rxerr_crc;
-	unsigned int rxerr_phy;
-	unsigned int rxerr_phy_code[32];
-	unsigned int rxerr_fifo;
-	unsigned int rxerr_decrypt;
-	unsigned int rxerr_mic;
-	unsigned int rxerr_proc;
-	unsigned int rxerr_jumbo;
-	unsigned int txerr_retry;
-	unsigned int txerr_fifo;
-	unsigned int txerr_filt;
-
-	/* MIB counters */
-	unsigned int ack_fail;
-	unsigned int rts_fail;
-	unsigned int rts_ok;
-	unsigned int fcs_error;
-	unsigned int beacons;
-
-	unsigned int mib_intr;
-	unsigned int rxorn_intr;
-	unsigned int rxeol_intr;
-};
-
-#if CHAN_DEBUG
-#define ATH_CHAN_MAX	(26 + 26 + 26 + 200 + 200)
-#else
-#define ATH_CHAN_MAX	(14 + 14 + 14 + 252 + 20)
-#endif
-
 struct ath5k_vif {
 	bool			assoc; /* are we associated or not */
 	enum nl80211_iftype	opmode;
@@ -166,104 +65,6 @@ struct ath5k_vif {
 	u8			lladdr[ETH_ALEN];
 };
 
-/* Software Carrier, keeps track of the driver state
- * associated with an instance of a device */
-struct ath5k_softc {
-	struct pci_dev		*pdev;
-	struct device		*dev;		/* for dma mapping */
-	int irq;
-	u16 devid;
-	void __iomem		*iobase;	/* address of the device */
-	struct mutex		lock;		/* dev-level lock */
-	struct ieee80211_hw	*hw;		/* IEEE 802.11 common */
-	struct ieee80211_supported_band sbands[IEEE80211_NUM_BANDS];
-	struct ieee80211_channel channels[ATH_CHAN_MAX];
-	struct ieee80211_rate	rates[IEEE80211_NUM_BANDS][AR5K_MAX_RATES];
-	s8			rate_idx[IEEE80211_NUM_BANDS][AR5K_MAX_RATES];
-	enum nl80211_iftype	opmode;
-	struct ath5k_hw		*ah;		/* Atheros HW */
-
-#ifdef CONFIG_ATH5K_DEBUG
-	struct ath5k_dbg_info	debug;		/* debug info */
-#endif /* CONFIG_ATH5K_DEBUG */
-
-	struct ath5k_buf	*bufptr;	/* allocated buffer ptr */
-	struct ath5k_desc	*desc;		/* TX/RX descriptors */
-	dma_addr_t		desc_daddr;	/* DMA (physical) address */
-	size_t			desc_len;	/* size of TX/RX descriptors */
-
-	DECLARE_BITMAP(status, 6);
-#define ATH_STAT_INVALID	0		/* disable hardware accesses */
-#define ATH_STAT_MRRETRY	1		/* multi-rate retry support */
-#define ATH_STAT_PROMISC	2
-#define ATH_STAT_LEDSOFT	3		/* enable LED gpio status */
-#define ATH_STAT_STARTED	4		/* opened & irqs enabled */
-#define ATH_STAT_2G_DISABLED	5		/* multiband radio without 2G */
-
-	unsigned int		filter_flags;	/* HW flags, AR5K_RX_FILTER_* */
-	struct ieee80211_channel *curchan;	/* current h/w channel */
-
-	u16			nvifs;
-
-	enum ath5k_int		imask;		/* interrupt mask copy */
-
-	spinlock_t		irqlock;
-	bool			rx_pending;	/* rx tasklet pending */
-	bool			tx_pending;	/* tx tasklet pending */
-
-	u8			lladdr[ETH_ALEN];
-	u8			bssidmask[ETH_ALEN];
-
-	unsigned int		led_pin,	/* GPIO pin for driving LED */
-				led_on;		/* pin setting for LED on */
-
-	struct work_struct	reset_work;	/* deferred chip reset */
-
-	unsigned int		rxbufsize;	/* rx size based on mtu */
-	struct list_head	rxbuf;		/* receive buffer */
-	spinlock_t		rxbuflock;
-	u32			*rxlink;	/* link ptr in last RX desc */
-	struct tasklet_struct	rxtq;		/* rx intr tasklet */
-	struct ath5k_led	rx_led;		/* rx led */
-
-	struct list_head	txbuf;		/* transmit buffer */
-	spinlock_t		txbuflock;
-	unsigned int		txbuf_len;	/* buf count in txbuf list */
-	struct ath5k_txq	txqs[AR5K_NUM_TX_QUEUES];	/* tx queues */
-	struct tasklet_struct	txtq;		/* tx intr tasklet */
-	struct ath5k_led	tx_led;		/* tx led */
-
-	struct ath5k_rfkill	rf_kill;
-
-	struct tasklet_struct	calib;		/* calibration tasklet */
-
-	spinlock_t		block;		/* protects beacon */
-	struct tasklet_struct	beacontq;	/* beacon intr tasklet */
-	struct list_head	bcbuf;		/* beacon buffer */
-	struct ieee80211_vif	*bslot[ATH_BCBUF];
-	u16			num_ap_vifs;
-	u16			num_adhoc_vifs;
-	unsigned int		bhalq,		/* SW q for outgoing beacons */
-				bmisscount,	/* missed beacon transmits */
-				bintval,	/* beacon interval in TU */
-				bsent;
-	unsigned int		nexttbtt;	/* next beacon time in TU */
-	struct ath5k_txq	*cabq;		/* content after beacon */
-
-	int			power_level;	/* Requested tx power in dBm */
-	bool			assoc;		/* associate state */
-	bool			enable_beacon;	/* true if beacons are on */
-
-	struct ath5k_statistics	stats;
-
-	struct ath5k_ani_state	ani_state;
-	struct tasklet_struct	ani_tasklet;	/* ANI calibration */
-
-	struct delayed_work	tx_complete_work;
-
-	struct survey_info	survey;		/* collected survey info */
-};
-
 struct ath5k_vif_iter_data {
 	const u8	*hw_macaddr;
 	u8		mask[ETH_ALEN];
diff --git a/drivers/net/wireless/ath/ath5k/debug.c b/drivers/net/wireless/ath/ath5k/debug.c
index 4edca70..ccca724 100644
--- a/drivers/net/wireless/ath/ath5k/debug.c
+++ b/drivers/net/wireless/ath/ath5k/debug.c
@@ -157,10 +157,10 @@ static void *reg_next(struct seq_file *seq, void *p, loff_t *pos)
 
 static int reg_show(struct seq_file *seq, void *p)
 {
-	struct ath5k_softc *sc = seq->private;
+	struct ath5k_hw *ah = seq->private;
 	struct reg *r = p;
 	seq_printf(seq, "%-25s0x%08x\n", r->name,
-		ath5k_hw_reg_read(sc->ah, r->addr));
+		ath5k_hw_reg_read(ah, r->addr));
 	return 0;
 }
 
@@ -197,42 +197,41 @@ static const struct file_operations fops_registers = {
 static ssize_t read_file_beacon(struct file *file, char __user *user_buf,
 				   size_t count, loff_t *ppos)
 {
-	struct ath5k_softc *sc = file->private_data;
-	struct ath5k_hw *ah = sc->ah;
+	struct ath5k_hw *ah = file->private_data;
 	char buf[500];
 	unsigned int len = 0;
 	unsigned int v;
 	u64 tsf;
 
-	v = ath5k_hw_reg_read(sc->ah, AR5K_BEACON);
+	v = ath5k_hw_reg_read(ah, AR5K_BEACON);
 	len += snprintf(buf + len, sizeof(buf) - len,
 		"%-24s0x%08x\tintval: %d\tTIM: 0x%x\n",
 		"AR5K_BEACON", v, v & AR5K_BEACON_PERIOD,
 		(v & AR5K_BEACON_TIM) >> AR5K_BEACON_TIM_S);
 
 	len += snprintf(buf + len, sizeof(buf) - len, "%-24s0x%08x\n",
-		"AR5K_LAST_TSTP", ath5k_hw_reg_read(sc->ah, AR5K_LAST_TSTP));
+		"AR5K_LAST_TSTP", ath5k_hw_reg_read(ah, AR5K_LAST_TSTP));
 
 	len += snprintf(buf + len, sizeof(buf) - len, "%-24s0x%08x\n\n",
-		"AR5K_BEACON_CNT", ath5k_hw_reg_read(sc->ah, AR5K_BEACON_CNT));
+		"AR5K_BEACON_CNT", ath5k_hw_reg_read(ah, AR5K_BEACON_CNT));
 
-	v = ath5k_hw_reg_read(sc->ah, AR5K_TIMER0);
+	v = ath5k_hw_reg_read(ah, AR5K_TIMER0);
 	len += snprintf(buf + len, sizeof(buf) - len, "%-24s0x%08x\tTU: %08x\n",
 		"AR5K_TIMER0 (TBTT)", v, v);
 
-	v = ath5k_hw_reg_read(sc->ah, AR5K_TIMER1);
+	v = ath5k_hw_reg_read(ah, AR5K_TIMER1);
 	len += snprintf(buf + len, sizeof(buf) - len, "%-24s0x%08x\tTU: %08x\n",
 		"AR5K_TIMER1 (DMA)", v, v >> 3);
 
-	v = ath5k_hw_reg_read(sc->ah, AR5K_TIMER2);
+	v = ath5k_hw_reg_read(ah, AR5K_TIMER2);
 	len += snprintf(buf + len, sizeof(buf) - len, "%-24s0x%08x\tTU: %08x\n",
 		"AR5K_TIMER2 (SWBA)", v, v >> 3);
 
-	v = ath5k_hw_reg_read(sc->ah, AR5K_TIMER3);
+	v = ath5k_hw_reg_read(ah, AR5K_TIMER3);
 	len += snprintf(buf + len, sizeof(buf) - len, "%-24s0x%08x\tTU: %08x\n",
 		"AR5K_TIMER3 (ATIM)", v, v);
 
-	tsf = ath5k_hw_get_tsf64(sc->ah);
+	tsf = ath5k_hw_get_tsf64(ah);
 	len += snprintf(buf + len, sizeof(buf) - len,
 		"TSF\t\t0x%016llx\tTU: %08x\n",
 		(unsigned long long)tsf, TSF_TO_TU(tsf));
@@ -247,8 +246,7 @@ static ssize_t write_file_beacon(struct file *file,
 				 const char __user *userbuf,
 				 size_t count, loff_t *ppos)
 {
-	struct ath5k_softc *sc = file->private_data;
-	struct ath5k_hw *ah = sc->ah;
+	struct ath5k_hw *ah = file->private_data;
 	char buf[20];
 
 	if (copy_from_user(buf, userbuf, min(count, sizeof(buf))))
@@ -279,9 +277,9 @@ static ssize_t write_file_reset(struct file *file,
 				 const char __user *userbuf,
 				 size_t count, loff_t *ppos)
 {
-	struct ath5k_softc *sc = file->private_data;
-	ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "debug file triggered reset\n");
-	ieee80211_queue_work(sc->hw, &sc->reset_work);
+	struct ath5k_hw *ah = file->private_data;
+	ATH5K_DBG(ah, ATH5K_DEBUG_RESET, "debug file triggered reset\n");
+	ieee80211_queue_work(ah->hw, &ah->reset_work);
 	return count;
 }
 
@@ -318,23 +316,23 @@ static const struct {
 static ssize_t read_file_debug(struct file *file, char __user *user_buf,
 				   size_t count, loff_t *ppos)
 {
-	struct ath5k_softc *sc = file->private_data;
+	struct ath5k_hw *ah = file->private_data;
 	char buf[700];
 	unsigned int len = 0;
 	unsigned int i;
 
 	len += snprintf(buf + len, sizeof(buf) - len,
-		"DEBUG LEVEL: 0x%08x\n\n", sc->debug.level);
+		"DEBUG LEVEL: 0x%08x\n\n", ah->debug.level);
 
 	for (i = 0; i < ARRAY_SIZE(dbg_info) - 1; i++) {
 		len += snprintf(buf + len, sizeof(buf) - len,
 			"%10s %c 0x%08x - %s\n", dbg_info[i].name,
-			sc->debug.level & dbg_info[i].level ? '+' : ' ',
+			ah->debug.level & dbg_info[i].level ? '+' : ' ',
 			dbg_info[i].level, dbg_info[i].desc);
 	}
 	len += snprintf(buf + len, sizeof(buf) - len,
 		"%10s %c 0x%08x - %s\n", dbg_info[i].name,
-		sc->debug.level == dbg_info[i].level ? '+' : ' ',
+		ah->debug.level == dbg_info[i].level ? '+' : ' ',
 		dbg_info[i].level, dbg_info[i].desc);
 
 	if (len > sizeof(buf))
@@ -347,7 +345,7 @@ static ssize_t write_file_debug(struct file *file,
 				 const char __user *userbuf,
 				 size_t count, loff_t *ppos)
 {
-	struct ath5k_softc *sc = file->private_data;
+	struct ath5k_hw *ah = file->private_data;
 	unsigned int i;
 	char buf[20];
 
@@ -357,7 +355,7 @@ static ssize_t write_file_debug(struct file *file,
 	for (i = 0; i < ARRAY_SIZE(dbg_info); i++) {
 		if (strncmp(buf, dbg_info[i].name,
 					strlen(dbg_info[i].name)) == 0) {
-			sc->debug.level ^= dbg_info[i].level; /* toggle bit */
+			ah->debug.level ^= dbg_info[i].level; /* toggle bit */
 			break;
 		}
 	}
@@ -378,33 +376,33 @@ static const struct file_operations fops_debug = {
 static ssize_t read_file_antenna(struct file *file, char __user *user_buf,
 				   size_t count, loff_t *ppos)
 {
-	struct ath5k_softc *sc = file->private_data;
+	struct ath5k_hw *ah = file->private_data;
 	char buf[700];
 	unsigned int len = 0;
 	unsigned int i;
 	unsigned int v;
 
 	len += snprintf(buf + len, sizeof(buf) - len, "antenna mode\t%d\n",
-		sc->ah->ah_ant_mode);
+		ah->ah_ant_mode);
 	len += snprintf(buf + len, sizeof(buf) - len, "default antenna\t%d\n",
-		sc->ah->ah_def_ant);
+		ah->ah_def_ant);
 	len += snprintf(buf + len, sizeof(buf) - len, "tx antenna\t%d\n",
-		sc->ah->ah_tx_ant);
+		ah->ah_tx_ant);
 
 	len += snprintf(buf + len, sizeof(buf) - len, "\nANTENNA\t\tRX\tTX\n");
-	for (i = 1; i < ARRAY_SIZE(sc->stats.antenna_rx); i++) {
+	for (i = 1; i < ARRAY_SIZE(ah->stats.antenna_rx); i++) {
 		len += snprintf(buf + len, sizeof(buf) - len,
 			"[antenna %d]\t%d\t%d\n",
-			i, sc->stats.antenna_rx[i], sc->stats.antenna_tx[i]);
+			i, ah->stats.antenna_rx[i], ah->stats.antenna_tx[i]);
 	}
 	len += snprintf(buf + len, sizeof(buf) - len, "[invalid]\t%d\t%d\n",
-			sc->stats.antenna_rx[0], sc->stats.antenna_tx[0]);
+			ah->stats.antenna_rx[0], ah->stats.antenna_tx[0]);
 
-	v = ath5k_hw_reg_read(sc->ah, AR5K_DEFAULT_ANTENNA);
+	v = ath5k_hw_reg_read(ah, AR5K_DEFAULT_ANTENNA);
 	len += snprintf(buf + len, sizeof(buf) - len,
 			"\nAR5K_DEFAULT_ANTENNA\t0x%08x\n", v);
 
-	v = ath5k_hw_reg_read(sc->ah, AR5K_STA_ID1);
+	v = ath5k_hw_reg_read(ah, AR5K_STA_ID1);
 	len += snprintf(buf + len, sizeof(buf) - len,
 		"AR5K_STA_ID1_DEFAULT_ANTENNA\t%d\n",
 		(v & AR5K_STA_ID1_DEFAULT_ANTENNA) != 0);
@@ -418,25 +416,25 @@ static ssize_t read_file_antenna(struct file *file, char __user *user_buf,
 		"AR5K_STA_ID1_SELFGEN_DEF_ANT\t%d\n",
 		(v & AR5K_STA_ID1_SELFGEN_DEF_ANT) != 0);
 
-	v = ath5k_hw_reg_read(sc->ah, AR5K_PHY_AGCCTL);
+	v = ath5k_hw_reg_read(ah, AR5K_PHY_AGCCTL);
 	len += snprintf(buf + len, sizeof(buf) - len,
 		"\nAR5K_PHY_AGCCTL_OFDM_DIV_DIS\t%d\n",
 		(v & AR5K_PHY_AGCCTL_OFDM_DIV_DIS) != 0);
 
-	v = ath5k_hw_reg_read(sc->ah, AR5K_PHY_RESTART);
+	v = ath5k_hw_reg_read(ah, AR5K_PHY_RESTART);
 	len += snprintf(buf + len, sizeof(buf) - len,
 		"AR5K_PHY_RESTART_DIV_GC\t\t%x\n",
 		(v & AR5K_PHY_RESTART_DIV_GC) >> AR5K_PHY_RESTART_DIV_GC_S);
 
-	v = ath5k_hw_reg_read(sc->ah, AR5K_PHY_FAST_ANT_DIV);
+	v = ath5k_hw_reg_read(ah, AR5K_PHY_FAST_ANT_DIV);
 	len += snprintf(buf + len, sizeof(buf) - len,
 		"AR5K_PHY_FAST_ANT_DIV_EN\t%d\n",
 		(v & AR5K_PHY_FAST_ANT_DIV_EN) != 0);
 
-	v = ath5k_hw_reg_read(sc->ah, AR5K_PHY_ANT_SWITCH_TABLE_0);
+	v = ath5k_hw_reg_read(ah, AR5K_PHY_ANT_SWITCH_TABLE_0);
 	len += snprintf(buf + len, sizeof(buf) - len,
 			"\nAR5K_PHY_ANT_SWITCH_TABLE_0\t0x%08x\n", v);
-	v = ath5k_hw_reg_read(sc->ah, AR5K_PHY_ANT_SWITCH_TABLE_1);
+	v = ath5k_hw_reg_read(ah, AR5K_PHY_ANT_SWITCH_TABLE_1);
 	len += snprintf(buf + len, sizeof(buf) - len,
 			"AR5K_PHY_ANT_SWITCH_TABLE_1\t0x%08x\n", v);
 
@@ -450,7 +448,7 @@ static ssize_t write_file_antenna(struct file *file,
 				 const char __user *userbuf,
 				 size_t count, loff_t *ppos)
 {
-	struct ath5k_softc *sc = file->private_data;
+	struct ath5k_hw *ah = file->private_data;
 	unsigned int i;
 	char buf[20];
 
@@ -458,18 +456,18 @@ static ssize_t write_file_antenna(struct file *file,
 		return -EFAULT;
 
 	if (strncmp(buf, "diversity", 9) == 0) {
-		ath5k_hw_set_antenna_mode(sc->ah, AR5K_ANTMODE_DEFAULT);
+		ath5k_hw_set_antenna_mode(ah, AR5K_ANTMODE_DEFAULT);
 		printk(KERN_INFO "ath5k debug: enable diversity\n");
 	} else if (strncmp(buf, "fixed-a", 7) == 0) {
-		ath5k_hw_set_antenna_mode(sc->ah, AR5K_ANTMODE_FIXED_A);
+		ath5k_hw_set_antenna_mode(ah, AR5K_ANTMODE_FIXED_A);
 		printk(KERN_INFO "ath5k debugfs: fixed antenna A\n");
 	} else if (strncmp(buf, "fixed-b", 7) == 0) {
-		ath5k_hw_set_antenna_mode(sc->ah, AR5K_ANTMODE_FIXED_B);
+		ath5k_hw_set_antenna_mode(ah, AR5K_ANTMODE_FIXED_B);
 		printk(KERN_INFO "ath5k debug: fixed antenna B\n");
 	} else if (strncmp(buf, "clear", 5) == 0) {
-		for (i = 0; i < ARRAY_SIZE(sc->stats.antenna_rx); i++) {
-			sc->stats.antenna_rx[i] = 0;
-			sc->stats.antenna_tx[i] = 0;
+		for (i = 0; i < ARRAY_SIZE(ah->stats.antenna_rx); i++) {
+			ah->stats.antenna_rx[i] = 0;
+			ah->stats.antenna_tx[i] = 0;
 		}
 		printk(KERN_INFO "ath5k debug: cleared antenna stats\n");
 	}
@@ -489,13 +487,13 @@ static const struct file_operations fops_antenna = {
 static ssize_t read_file_misc(struct file *file, char __user *user_buf,
 				   size_t count, loff_t *ppos)
 {
-	struct ath5k_softc *sc = file->private_data;
+	struct ath5k_hw *ah = file->private_data;
 	char buf[700];
 	unsigned int len = 0;
-	u32 filt = ath5k_hw_get_rx_filter(sc->ah);
+	u32 filt = ath5k_hw_get_rx_filter(ah);
 
 	len += snprintf(buf + len, sizeof(buf) - len, "bssid-mask: %pM\n",
-			sc->bssidmask);
+			ah->bssidmask);
 	len += snprintf(buf + len, sizeof(buf) - len, "filter-flags: 0x%x ",
 			filt);
 	if (filt & AR5K_RX_FILTER_UCAST)
@@ -524,7 +522,7 @@ static ssize_t read_file_misc(struct file *file, char __user *user_buf,
 		len += snprintf(buf + len, sizeof(buf) - len, " RADARERR-5211");
 
 	len += snprintf(buf + len, sizeof(buf) - len, "\nopmode: %s (%d)\n",
-			ath_opmode_to_string(sc->opmode), sc->opmode);
+			ath_opmode_to_string(ah->opmode), ah->opmode);
 
 	if (len > sizeof(buf))
 		len = sizeof(buf);
@@ -544,8 +542,8 @@ static const struct file_operations fops_misc = {
 static ssize_t read_file_frameerrors(struct file *file, char __user *user_buf,
 				   size_t count, loff_t *ppos)
 {
-	struct ath5k_softc *sc = file->private_data;
-	struct ath5k_statistics *st = &sc->stats;
+	struct ath5k_hw *ah = file->private_data;
+	struct ath5k_statistics *st = &ah->stats;
 	char buf[700];
 	unsigned int len = 0;
 	int i;
@@ -621,8 +619,8 @@ static ssize_t write_file_frameerrors(struct file *file,
 				 const char __user *userbuf,
 				 size_t count, loff_t *ppos)
 {
-	struct ath5k_softc *sc = file->private_data;
-	struct ath5k_statistics *st = &sc->stats;
+	struct ath5k_hw *ah = file->private_data;
+	struct ath5k_statistics *st = &ah->stats;
 	char buf[20];
 
 	if (copy_from_user(buf, userbuf, min(count, sizeof(buf))))
@@ -660,16 +658,16 @@ static const struct file_operations fops_frameerrors = {
 static ssize_t read_file_ani(struct file *file, char __user *user_buf,
 				   size_t count, loff_t *ppos)
 {
-	struct ath5k_softc *sc = file->private_data;
-	struct ath5k_statistics *st = &sc->stats;
-	struct ath5k_ani_state *as = &sc->ani_state;
+	struct ath5k_hw *ah = file->private_data;
+	struct ath5k_statistics *st = &ah->stats;
+	struct ath5k_ani_state *as = &ah->ani_state;
 
 	char buf[700];
 	unsigned int len = 0;
 
 	len += snprintf(buf + len, sizeof(buf) - len,
 			"HW has PHY error counters:\t%s\n",
-			sc->ah->ah_capabilities.cap_has_phyerr_counters ?
+			ah->ah_capabilities.cap_has_phyerr_counters ?
 			"yes" : "no");
 	len += snprintf(buf + len, sizeof(buf) - len,
 			"HW max spur immunity level:\t%d\n",
@@ -718,7 +716,7 @@ static ssize_t read_file_ani(struct file *file, char __user *user_buf,
 			st->mib_intr);
 	len += snprintf(buf + len, sizeof(buf) - len,
 			"beacon RSSI average:\t%d\n",
-			(int)ewma_read(&sc->ah->ah_beacon_rssi_avg));
+			(int)ewma_read(&ah->ah_beacon_rssi_avg));
 
 #define CC_PRINT(_struct, _field) \
 	_struct._field, \
@@ -750,14 +748,14 @@ static ssize_t read_file_ani(struct file *file, char __user *user_buf,
 			as->sum_cck_errors);
 	len += snprintf(buf + len, sizeof(buf) - len,
 			"AR5K_PHYERR_CNT1\t%x\t(=%d)\n",
-			ath5k_hw_reg_read(sc->ah, AR5K_PHYERR_CNT1),
+			ath5k_hw_reg_read(ah, AR5K_PHYERR_CNT1),
 			ATH5K_ANI_OFDM_TRIG_HIGH - (ATH5K_PHYERR_CNT_MAX -
-			ath5k_hw_reg_read(sc->ah, AR5K_PHYERR_CNT1)));
+			ath5k_hw_reg_read(ah, AR5K_PHYERR_CNT1)));
 	len += snprintf(buf + len, sizeof(buf) - len,
 			"AR5K_PHYERR_CNT2\t%x\t(=%d)\n",
-			ath5k_hw_reg_read(sc->ah, AR5K_PHYERR_CNT2),
+			ath5k_hw_reg_read(ah, AR5K_PHYERR_CNT2),
 			ATH5K_ANI_CCK_TRIG_HIGH - (ATH5K_PHYERR_CNT_MAX -
-			ath5k_hw_reg_read(sc->ah, AR5K_PHYERR_CNT2)));
+			ath5k_hw_reg_read(ah, AR5K_PHYERR_CNT2)));
 
 	if (len > sizeof(buf))
 		len = sizeof(buf);
@@ -769,42 +767,42 @@ static ssize_t write_file_ani(struct file *file,
 				 const char __user *userbuf,
 				 size_t count, loff_t *ppos)
 {
-	struct ath5k_softc *sc = file->private_data;
+	struct ath5k_hw *ah = file->private_data;
 	char buf[20];
 
 	if (copy_from_user(buf, userbuf, min(count, sizeof(buf))))
 		return -EFAULT;
 
 	if (strncmp(buf, "sens-low", 8) == 0) {
-		ath5k_ani_init(sc->ah, ATH5K_ANI_MODE_MANUAL_HIGH);
+		ath5k_ani_init(ah, ATH5K_ANI_MODE_MANUAL_HIGH);
 	} else if (strncmp(buf, "sens-high", 9) == 0) {
-		ath5k_ani_init(sc->ah, ATH5K_ANI_MODE_MANUAL_LOW);
+		ath5k_ani_init(ah, ATH5K_ANI_MODE_MANUAL_LOW);
 	} else if (strncmp(buf, "ani-off", 7) == 0) {
-		ath5k_ani_init(sc->ah, ATH5K_ANI_MODE_OFF);
+		ath5k_ani_init(ah, ATH5K_ANI_MODE_OFF);
 	} else if (strncmp(buf, "ani-on", 6) == 0) {
-		ath5k_ani_init(sc->ah, ATH5K_ANI_MODE_AUTO);
+		ath5k_ani_init(ah, ATH5K_ANI_MODE_AUTO);
 	} else if (strncmp(buf, "noise-low", 9) == 0) {
-		ath5k_ani_set_noise_immunity_level(sc->ah, 0);
+		ath5k_ani_set_noise_immunity_level(ah, 0);
 	} else if (strncmp(buf, "noise-high", 10) == 0) {
-		ath5k_ani_set_noise_immunity_level(sc->ah,
+		ath5k_ani_set_noise_immunity_level(ah,
 						   ATH5K_ANI_MAX_NOISE_IMM_LVL);
 	} else if (strncmp(buf, "spur-low", 8) == 0) {
-		ath5k_ani_set_spur_immunity_level(sc->ah, 0);
+		ath5k_ani_set_spur_immunity_level(ah, 0);
 	} else if (strncmp(buf, "spur-high", 9) == 0) {
-		ath5k_ani_set_spur_immunity_level(sc->ah,
-						  sc->ani_state.max_spur_level);
+		ath5k_ani_set_spur_immunity_level(ah,
+						  ah->ani_state.max_spur_level);
 	} else if (strncmp(buf, "fir-low", 7) == 0) {
-		ath5k_ani_set_firstep_level(sc->ah, 0);
+		ath5k_ani_set_firstep_level(ah, 0);
 	} else if (strncmp(buf, "fir-high", 8) == 0) {
-		ath5k_ani_set_firstep_level(sc->ah, ATH5K_ANI_MAX_FIRSTEP_LVL);
+		ath5k_ani_set_firstep_level(ah, ATH5K_ANI_MAX_FIRSTEP_LVL);
 	} else if (strncmp(buf, "ofdm-off", 8) == 0) {
-		ath5k_ani_set_ofdm_weak_signal_detection(sc->ah, false);
+		ath5k_ani_set_ofdm_weak_signal_detection(ah, false);
 	} else if (strncmp(buf, "ofdm-on", 7) == 0) {
-		ath5k_ani_set_ofdm_weak_signal_detection(sc->ah, true);
+		ath5k_ani_set_ofdm_weak_signal_detection(ah, true);
 	} else if (strncmp(buf, "cck-off", 7) == 0) {
-		ath5k_ani_set_cck_weak_signal_detection(sc->ah, false);
+		ath5k_ani_set_cck_weak_signal_detection(ah, false);
 	} else if (strncmp(buf, "cck-on", 6) == 0) {
-		ath5k_ani_set_cck_weak_signal_detection(sc->ah, true);
+		ath5k_ani_set_cck_weak_signal_detection(ah, true);
 	}
 	return count;
 }
@@ -823,7 +821,7 @@ static const struct file_operations fops_ani = {
 static ssize_t read_file_queue(struct file *file, char __user *user_buf,
 				   size_t count, loff_t *ppos)
 {
-	struct ath5k_softc *sc = file->private_data;
+	struct ath5k_hw *ah = file->private_data;
 	char buf[700];
 	unsigned int len = 0;
 
@@ -832,10 +830,10 @@ static ssize_t read_file_queue(struct file *file, char __user *user_buf,
 	int i, n;
 
 	len += snprintf(buf + len, sizeof(buf) - len,
-			"available txbuffers: %d\n", sc->txbuf_len);
+			"available txbuffers: %d\n", ah->txbuf_len);
 
-	for (i = 0; i < ARRAY_SIZE(sc->txqs); i++) {
-		txq = &sc->txqs[i];
+	for (i = 0; i < ARRAY_SIZE(ah->txqs); i++) {
+		txq = &ah->txqs[i];
 
 		len += snprintf(buf + len, sizeof(buf) - len,
 			"%02d: %ssetup\n", i, txq->setup ? "" : "not ");
@@ -865,16 +863,16 @@ static ssize_t write_file_queue(struct file *file,
 				 const char __user *userbuf,
 				 size_t count, loff_t *ppos)
 {
-	struct ath5k_softc *sc = file->private_data;
+	struct ath5k_hw *ah = file->private_data;
 	char buf[20];
 
 	if (copy_from_user(buf, userbuf, min(count, sizeof(buf))))
 		return -EFAULT;
 
 	if (strncmp(buf, "start", 5) == 0)
-		ieee80211_wake_queues(sc->hw);
+		ieee80211_wake_queues(ah->hw);
 	else if (strncmp(buf, "stop", 4) == 0)
-		ieee80211_stop_queues(sc->hw);
+		ieee80211_stop_queues(ah->hw);
 
 	return count;
 }
@@ -890,57 +888,57 @@ static const struct file_operations fops_queue = {
 
 
 void
-ath5k_debug_init_device(struct ath5k_softc *sc)
+ath5k_debug_init_device(struct ath5k_hw *ah)
 {
 	struct dentry *phydir;
 
-	sc->debug.level = ath5k_debug;
+	ah->debug.level = ath5k_debug;
 
-	phydir = debugfs_create_dir("ath5k", sc->hw->wiphy->debugfsdir);
+	phydir = debugfs_create_dir("ath5k", ah->hw->wiphy->debugfsdir);
 	if (!phydir)
 		return;
 
-	debugfs_create_file("debug", S_IWUSR | S_IRUSR, phydir, sc,
+	debugfs_create_file("debug", S_IWUSR | S_IRUSR, phydir, ah,
 			    &fops_debug);
 
-	debugfs_create_file("registers", S_IRUSR, phydir, sc, &fops_registers);
+	debugfs_create_file("registers", S_IRUSR, phydir, ah, &fops_registers);
 
-	debugfs_create_file("beacon", S_IWUSR | S_IRUSR, phydir, sc,
+	debugfs_create_file("beacon", S_IWUSR | S_IRUSR, phydir, ah,
 			    &fops_beacon);
 
-	debugfs_create_file("reset", S_IWUSR, phydir, sc, &fops_reset);
+	debugfs_create_file("reset", S_IWUSR, phydir, ah, &fops_reset);
 
-	debugfs_create_file("antenna", S_IWUSR | S_IRUSR, phydir, sc,
+	debugfs_create_file("antenna", S_IWUSR | S_IRUSR, phydir, ah,
 			    &fops_antenna);
 
-	debugfs_create_file("misc", S_IRUSR, phydir, sc, &fops_misc);
+	debugfs_create_file("misc", S_IRUSR, phydir, ah, &fops_misc);
 
-	debugfs_create_file("frameerrors", S_IWUSR | S_IRUSR, phydir, sc,
+	debugfs_create_file("frameerrors", S_IWUSR | S_IRUSR, phydir, ah,
 			    &fops_frameerrors);
 
-	debugfs_create_file("ani", S_IWUSR | S_IRUSR, phydir, sc, &fops_ani);
+	debugfs_create_file("ani", S_IWUSR | S_IRUSR, phydir, ah, &fops_ani);
 
-	debugfs_create_file("queue", S_IWUSR | S_IRUSR, phydir, sc,
+	debugfs_create_file("queue", S_IWUSR | S_IRUSR, phydir, ah,
 			    &fops_queue);
 
 	debugfs_create_bool("32khz_clock", S_IWUSR | S_IRUSR, phydir,
-			    &sc->ah->ah_use_32khz_clock);
+			    &ah->ah_use_32khz_clock);
 }
 
 /* functions used in other places */
 
 void
-ath5k_debug_dump_bands(struct ath5k_softc *sc)
+ath5k_debug_dump_bands(struct ath5k_hw *ah)
 {
 	unsigned int b, i;
 
-	if (likely(!(sc->debug.level & ATH5K_DEBUG_DUMPBANDS)))
+	if (likely(!(ah->debug.level & ATH5K_DEBUG_DUMPBANDS)))
 		return;
 
-	BUG_ON(!sc->sbands);
+	BUG_ON(!ah->sbands);
 
 	for (b = 0; b < IEEE80211_NUM_BANDS; b++) {
-		struct ieee80211_supported_band *band = &sc->sbands[b];
+		struct ieee80211_supported_band *band = &ah->sbands[b];
 		char bname[6];
 		switch (band->band) {
 		case IEEE80211_BAND_2GHZ:
@@ -990,41 +988,41 @@ ath5k_debug_printrxbuf(struct ath5k_buf *bf, int done,
 }
 
 void
-ath5k_debug_printrxbuffs(struct ath5k_softc *sc, struct ath5k_hw *ah)
+ath5k_debug_printrxbuffs(struct ath5k_hw *ah)
 {
 	struct ath5k_desc *ds;
 	struct ath5k_buf *bf;
 	struct ath5k_rx_status rs = {};
 	int status;
 
-	if (likely(!(sc->debug.level & ATH5K_DEBUG_DESC)))
+	if (likely(!(ah->debug.level & ATH5K_DEBUG_DESC)))
 		return;
 
 	printk(KERN_DEBUG "rxdp %x, rxlink %p\n",
-		ath5k_hw_get_rxdp(ah), sc->rxlink);
+		ath5k_hw_get_rxdp(ah), ah->rxlink);
 
-	spin_lock_bh(&sc->rxbuflock);
-	list_for_each_entry(bf, &sc->rxbuf, list) {
+	spin_lock_bh(&ah->rxbuflock);
+	list_for_each_entry(bf, &ah->rxbuf, list) {
 		ds = bf->desc;
 		status = ah->ah_proc_rx_desc(ah, ds, &rs);
 		if (!status)
 			ath5k_debug_printrxbuf(bf, status == 0, &rs);
 	}
-	spin_unlock_bh(&sc->rxbuflock);
+	spin_unlock_bh(&ah->rxbuflock);
 }
 
 void
-ath5k_debug_printtxbuf(struct ath5k_softc *sc, struct ath5k_buf *bf)
+ath5k_debug_printtxbuf(struct ath5k_hw *ah, struct ath5k_buf *bf)
 {
 	struct ath5k_desc *ds = bf->desc;
 	struct ath5k_hw_5212_tx_desc *td = &ds->ud.ds_tx5212;
 	struct ath5k_tx_status ts = {};
 	int done;
 
-	if (likely(!(sc->debug.level & ATH5K_DEBUG_DESC)))
+	if (likely(!(ah->debug.level & ATH5K_DEBUG_DESC)))
 		return;
 
-	done = sc->ah->ah_proc_tx_desc(sc->ah, bf->desc, &ts);
+	done = ah->ah_proc_tx_desc(ah, bf->desc, &ts);
 
 	printk(KERN_DEBUG "T (%p %llx) %08x %08x %08x %08x %08x %08x %08x "
 		"%08x %c\n", ds, (unsigned long long)bf->daddr, ds->ds_link,
diff --git a/drivers/net/wireless/ath/ath5k/debug.h b/drivers/net/wireless/ath/ath5k/debug.h
index 193dd2d..7f37df3 100644
--- a/drivers/net/wireless/ath/ath5k/debug.h
+++ b/drivers/net/wireless/ath/ath5k/debug.h
@@ -61,7 +61,6 @@
 #ifndef _ATH5K_DEBUG_H
 #define _ATH5K_DEBUG_H
 
-struct ath5k_softc;
 struct ath5k_hw;
 struct sk_buff;
 struct ath5k_buf;
@@ -127,39 +126,39 @@ enum ath5k_debug_level {
 	} while (0)
 
 void
-ath5k_debug_init_device(struct ath5k_softc *sc);
+ath5k_debug_init_device(struct ath5k_hw *ah);
 
 void
-ath5k_debug_printrxbuffs(struct ath5k_softc *sc, struct ath5k_hw *ah);
+ath5k_debug_printrxbuffs(struct ath5k_hw *ah);
 
 void
-ath5k_debug_dump_bands(struct ath5k_softc *sc);
+ath5k_debug_dump_bands(struct ath5k_hw *ah);
 
 void
-ath5k_debug_printtxbuf(struct ath5k_softc *sc, struct ath5k_buf *bf);
+ath5k_debug_printtxbuf(struct ath5k_hw *ah, struct ath5k_buf *bf);
 
 #else /* no debugging */
 
 #include <linux/compiler.h>
 
 static inline void __attribute__ ((format (printf, 3, 4)))
-ATH5K_DBG(struct ath5k_softc *sc, unsigned int m, const char *fmt, ...) {}
+ATH5K_DBG(struct ath5k_hw *ah, unsigned int m, const char *fmt, ...) {}
 
 static inline void __attribute__ ((format (printf, 3, 4)))
-ATH5K_DBG_UNLIMIT(struct ath5k_softc *sc, unsigned int m, const char *fmt, ...)
+ATH5K_DBG_UNLIMIT(struct ath5k_hw *ah, unsigned int m, const char *fmt, ...)
 {}
 
 static inline void
-ath5k_debug_init_device(struct ath5k_softc *sc) {}
+ath5k_debug_init_device(struct ath5k_hw *ah) {}
 
 static inline void
-ath5k_debug_printrxbuffs(struct ath5k_softc *sc, struct ath5k_hw *ah) {}
+ath5k_debug_printrxbuffs(struct ath5k_hw *ah) {}
 
 static inline void
-ath5k_debug_dump_bands(struct ath5k_softc *sc) {}
+ath5k_debug_dump_bands(struct ath5k_hw *ah) {}
 
 static inline void
-ath5k_debug_printtxbuf(struct ath5k_softc *sc, struct ath5k_buf *bf) {}
+ath5k_debug_printtxbuf(struct ath5k_hw *ah, struct ath5k_buf *bf) {}
 
 #endif /* ifdef CONFIG_ATH5K_DEBUG */
 
diff --git a/drivers/net/wireless/ath/ath5k/desc.c b/drivers/net/wireless/ath/ath5k/desc.c
index f82383b..846535f 100644
--- a/drivers/net/wireless/ath/ath5k/desc.c
+++ b/drivers/net/wireless/ath/ath5k/desc.c
@@ -55,12 +55,12 @@ ath5k_hw_setup_2word_tx_desc(struct ath5k_hw *ah, struct ath5k_desc *desc,
 	 *   noise on the channel, so it is important to avoid this.
 	 */
 	if (unlikely(tx_tries0 == 0)) {
-		ATH5K_ERR(ah->ah_sc, "zero retries\n");
+		ATH5K_ERR(ah, "zero retries\n");
 		WARN_ON(1);
 		return -EINVAL;
 	}
 	if (unlikely(tx_rate0 == 0)) {
-		ATH5K_ERR(ah->ah_sc, "zero rate\n");
+		ATH5K_ERR(ah, "zero rate\n");
 		WARN_ON(1);
 		return -EINVAL;
 	}
@@ -203,12 +203,12 @@ static int ath5k_hw_setup_4word_tx_desc(struct ath5k_hw *ah,
 	 *   noise on the channel, so it is important to avoid this.
 	 */
 	if (unlikely(tx_tries0 == 0)) {
-		ATH5K_ERR(ah->ah_sc, "zero retries\n");
+		ATH5K_ERR(ah, "zero retries\n");
 		WARN_ON(1);
 		return -EINVAL;
 	}
 	if (unlikely(tx_rate0 == 0)) {
-		ATH5K_ERR(ah->ah_sc, "zero rate\n");
+		ATH5K_ERR(ah, "zero rate\n");
 		WARN_ON(1);
 		return -EINVAL;
 	}
@@ -316,7 +316,7 @@ ath5k_hw_setup_mrr_tx_desc(struct ath5k_hw *ah, struct ath5k_desc *desc,
 	if (unlikely((tx_rate1 == 0 && tx_tries1 != 0) ||
 		     (tx_rate2 == 0 && tx_tries2 != 0) ||
 		     (tx_rate3 == 0 && tx_tries3 != 0))) {
-		ATH5K_ERR(ah->ah_sc, "zero rate\n");
+		ATH5K_ERR(ah, "zero rate\n");
 		WARN_ON(1);
 		return -EINVAL;
 	}
diff --git a/drivers/net/wireless/ath/ath5k/dma.c b/drivers/net/wireless/ath/ath5k/dma.c
index b788ecf..0d5d403 100644
--- a/drivers/net/wireless/ath/ath5k/dma.c
+++ b/drivers/net/wireless/ath/ath5k/dma.c
@@ -73,7 +73,7 @@ static int ath5k_hw_stop_rx_dma(struct ath5k_hw *ah)
 		udelay(100);
 
 	if (!i)
-		ATH5K_DBG(ah->ah_sc, ATH5K_DEBUG_DMA,
+		ATH5K_DBG(ah, ATH5K_DEBUG_DMA,
 				"failed to stop RX DMA !\n");
 
 	return i ? 0 : -EBUSY;
@@ -100,7 +100,7 @@ u32 ath5k_hw_get_rxdp(struct ath5k_hw *ah)
 int ath5k_hw_set_rxdp(struct ath5k_hw *ah, u32 phys_addr)
 {
 	if (ath5k_hw_reg_read(ah, AR5K_CR) & AR5K_CR_RXE) {
-		ATH5K_DBG(ah->ah_sc, ATH5K_DEBUG_DMA,
+		ATH5K_DBG(ah, ATH5K_DEBUG_DMA,
 				"tried to set RXDP while rx was active !\n");
 		return -EIO;
 	}
@@ -243,7 +243,7 @@ static int ath5k_hw_stop_tx_dma(struct ath5k_hw *ah, unsigned int queue)
 			udelay(100);
 
 		if (AR5K_REG_READ_Q(ah, AR5K_QCU_TXE, queue))
-			ATH5K_DBG(ah->ah_sc, ATH5K_DEBUG_DMA,
+			ATH5K_DBG(ah, ATH5K_DEBUG_DMA,
 				"queue %i didn't stop !\n", queue);
 
 		/* Check for pending frames */
@@ -295,7 +295,7 @@ static int ath5k_hw_stop_tx_dma(struct ath5k_hw *ah, unsigned int queue)
 					AR5K_DIAG_SW_CHANNEL_IDLE_HIGH);
 
 			if (pending)
-				ATH5K_DBG(ah->ah_sc, ATH5K_DEBUG_DMA,
+				ATH5K_DBG(ah, ATH5K_DEBUG_DMA,
 					"quiet mechanism didn't work q:%i !\n",
 					queue);
 		}
@@ -309,7 +309,7 @@ static int ath5k_hw_stop_tx_dma(struct ath5k_hw *ah, unsigned int queue)
 		/* Clear register */
 		ath5k_hw_reg_write(ah, 0, AR5K_QCU_TXD);
 		if (pending) {
-			ATH5K_DBG(ah->ah_sc, ATH5K_DEBUG_DMA,
+			ATH5K_DBG(ah, ATH5K_DEBUG_DMA,
 					"tx dma didn't stop (q:%i, frm:%i) !\n",
 					queue, pending);
 			return -EBUSY;
@@ -333,7 +333,7 @@ int ath5k_hw_stop_beacon_queue(struct ath5k_hw *ah, unsigned int queue)
 	int ret;
 	ret = ath5k_hw_stop_tx_dma(ah, queue);
 	if (ret) {
-		ATH5K_DBG(ah->ah_sc, ATH5K_DEBUG_DMA,
+		ATH5K_DBG(ah, ATH5K_DEBUG_DMA,
 				"beacon queue didn't stop !\n");
 		return -EIO;
 	}
diff --git a/drivers/net/wireless/ath/ath5k/eeprom.c b/drivers/net/wireless/ath/ath5k/eeprom.c
index d9e605e..9068b91 100644
--- a/drivers/net/wireless/ath/ath5k/eeprom.c
+++ b/drivers/net/wireless/ath/ath5k/eeprom.c
@@ -105,7 +105,7 @@ ath5k_eeprom_init_header(struct ath5k_hw *ah)
 		 * big still, waiting on a better value.
 		 */
 		if (eep_max > (3 * AR5K_EEPROM_INFO_MAX)) {
-			ATH5K_ERR(ah->ah_sc, "Invalid max custom EEPROM size: "
+			ATH5K_ERR(ah, "Invalid max custom EEPROM size: "
 				  "%d (0x%04x) max expected: %d (0x%04x)\n",
 				  eep_max, eep_max,
 				  3 * AR5K_EEPROM_INFO_MAX,
@@ -119,7 +119,7 @@ ath5k_eeprom_init_header(struct ath5k_hw *ah)
 		cksum ^= val;
 	}
 	if (cksum != AR5K_EEPROM_INFO_CKSUM) {
-		ATH5K_ERR(ah->ah_sc, "Invalid EEPROM "
+		ATH5K_ERR(ah, "Invalid EEPROM "
 			  "checksum: 0x%04x eep_max: 0x%04x (%s)\n",
 			  cksum, eep_max,
 			  eep_max == AR5K_EEPROM_INFO_MAX ?
diff --git a/drivers/net/wireless/ath/ath5k/initvals.c b/drivers/net/wireless/ath/ath5k/initvals.c
index 855d1af..5ab607f 100644
--- a/drivers/net/wireless/ath/ath5k/initvals.c
+++ b/drivers/net/wireless/ath/ath5k/initvals.c
@@ -1542,7 +1542,7 @@ int ath5k_hw_write_initvals(struct ath5k_hw *ah, u8 mode, bool skip_pcu)
 
 		/* AR5K_MODE_11B */
 		if (mode > 2) {
-			ATH5K_ERR(ah->ah_sc,
+			ATH5K_ERR(ah,
 				"unsupported channel mode: %d\n", mode);
 			return -EINVAL;
 		}
diff --git a/drivers/net/wireless/ath/ath5k/led.c b/drivers/net/wireless/ath/ath5k/led.c
index 127bfbd..8c17a00 100644
--- a/drivers/net/wireless/ath/ath5k/led.c
+++ b/drivers/net/wireless/ath/ath5k/led.c
@@ -86,26 +86,26 @@ static DEFINE_PCI_DEVICE_TABLE(ath5k_led_devices) = {
 	{ }
 };
 
-void ath5k_led_enable(struct ath5k_softc *sc)
+void ath5k_led_enable(struct ath5k_hw *ah)
 {
-	if (test_bit(ATH_STAT_LEDSOFT, sc->status)) {
-		ath5k_hw_set_gpio_output(sc->ah, sc->led_pin);
-		ath5k_led_off(sc);
+	if (test_bit(ATH_STAT_LEDSOFT, ah->status)) {
+		ath5k_hw_set_gpio_output(ah, ah->led_pin);
+		ath5k_led_off(ah);
 	}
 }
 
-static void ath5k_led_on(struct ath5k_softc *sc)
+static void ath5k_led_on(struct ath5k_hw *ah)
 {
-	if (!test_bit(ATH_STAT_LEDSOFT, sc->status))
+	if (!test_bit(ATH_STAT_LEDSOFT, ah->status))
 		return;
-	ath5k_hw_set_gpio(sc->ah, sc->led_pin, sc->led_on);
+	ath5k_hw_set_gpio(ah, ah->led_pin, ah->led_on);
 }
 
-void ath5k_led_off(struct ath5k_softc *sc)
+void ath5k_led_off(struct ath5k_hw *ah)
 {
-	if (!test_bit(ATH_STAT_LEDSOFT, sc->status))
+	if (!test_bit(ATH_STAT_LEDSOFT, ah->status))
 		return;
-	ath5k_hw_set_gpio(sc->ah, sc->led_pin, !sc->led_on);
+	ath5k_hw_set_gpio(ah, ah->led_pin, !ah->led_on);
 }
 
 static void
@@ -116,27 +116,27 @@ ath5k_led_brightness_set(struct led_classdev *led_dev,
 		led_dev);
 
 	if (brightness == LED_OFF)
-		ath5k_led_off(led->sc);
+		ath5k_led_off(led->ah);
 	else
-		ath5k_led_on(led->sc);
+		ath5k_led_on(led->ah);
 }
 
 static int
-ath5k_register_led(struct ath5k_softc *sc, struct ath5k_led *led,
+ath5k_register_led(struct ath5k_hw *ah, struct ath5k_led *led,
 		   const char *name, char *trigger)
 {
 	int err;
 
-	led->sc = sc;
+	led->ah = ah;
 	strncpy(led->name, name, sizeof(led->name));
 	led->led_dev.name = led->name;
 	led->led_dev.default_trigger = trigger;
 	led->led_dev.brightness_set = ath5k_led_brightness_set;
 
-	err = led_classdev_register(sc->dev, &led->led_dev);
+	err = led_classdev_register(ah->dev, &led->led_dev);
 	if (err) {
-		ATH5K_WARN(sc, "could not register LED %s\n", name);
-		led->sc = NULL;
+		ATH5K_WARN(ah, "could not register LED %s\n", name);
+		led->ah = NULL;
 	}
 	return err;
 }
@@ -144,30 +144,30 @@ ath5k_register_led(struct ath5k_softc *sc, struct ath5k_led *led,
 static void
 ath5k_unregister_led(struct ath5k_led *led)
 {
-	if (!led->sc)
+	if (!led->ah)
 		return;
 	led_classdev_unregister(&led->led_dev);
-	ath5k_led_off(led->sc);
-	led->sc = NULL;
+	ath5k_led_off(led->ah);
+	led->ah = NULL;
 }
 
-void ath5k_unregister_leds(struct ath5k_softc *sc)
+void ath5k_unregister_leds(struct ath5k_hw *ah)
 {
-	ath5k_unregister_led(&sc->rx_led);
-	ath5k_unregister_led(&sc->tx_led);
+	ath5k_unregister_led(&ah->rx_led);
+	ath5k_unregister_led(&ah->tx_led);
 }
 
-int __devinit ath5k_init_leds(struct ath5k_softc *sc)
+int __devinit ath5k_init_leds(struct ath5k_hw *ah)
 {
 	int ret = 0;
-	struct ieee80211_hw *hw = sc->hw;
+	struct ieee80211_hw *hw = ah->hw;
 #ifndef CONFIG_ATHEROS_AR231X
-	struct pci_dev *pdev = sc->pdev;
+	struct pci_dev *pdev = ah->pdev;
 #endif
 	char name[ATH5K_LED_MAX_NAME_LEN + 1];
 	const struct pci_device_id *match;
 
-	if (!sc->pdev)
+	if (!ah->pdev)
 		return 0;
 
 #ifdef CONFIG_ATHEROS_AR231X
@@ -176,24 +176,24 @@ int __devinit ath5k_init_leds(struct ath5k_softc *sc)
 	match = pci_match_id(&ath5k_led_devices[0], pdev);
 #endif
 	if (match) {
-		__set_bit(ATH_STAT_LEDSOFT, sc->status);
-		sc->led_pin = ATH_PIN(match->driver_data);
-		sc->led_on = ATH_POLARITY(match->driver_data);
+		__set_bit(ATH_STAT_LEDSOFT, ah->status);
+		ah->led_pin = ATH_PIN(match->driver_data);
+		ah->led_on = ATH_POLARITY(match->driver_data);
 	}
 
-	if (!test_bit(ATH_STAT_LEDSOFT, sc->status))
+	if (!test_bit(ATH_STAT_LEDSOFT, ah->status))
 		goto out;
 
-	ath5k_led_enable(sc);
+	ath5k_led_enable(ah);
 
 	snprintf(name, sizeof(name), "ath5k-%s::rx", wiphy_name(hw->wiphy));
-	ret = ath5k_register_led(sc, &sc->rx_led, name,
+	ret = ath5k_register_led(ah, &ah->rx_led, name,
 		ieee80211_get_rx_led_name(hw));
 	if (ret)
 		goto out;
 
 	snprintf(name, sizeof(name), "ath5k-%s::tx", wiphy_name(hw->wiphy));
-	ret = ath5k_register_led(sc, &sc->tx_led, name,
+	ret = ath5k_register_led(ah, &ah->tx_led, name,
 		ieee80211_get_tx_led_name(hw));
 out:
 	return ret;
diff --git a/drivers/net/wireless/ath/ath5k/mac80211-ops.c b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
index 0d5ab34..7aa2a63 100644
--- a/drivers/net/wireless/ath/ath5k/mac80211-ops.c
+++ b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
@@ -53,15 +53,15 @@
 static void
 ath5k_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
-	struct ath5k_softc *sc = hw->priv;
+	struct ath5k_hw *ah = hw->priv;
 	u16 qnum = skb_get_queue_mapping(skb);
 
-	if (WARN_ON(qnum >= sc->ah->ah_capabilities.cap_queues.q_tx_num)) {
+	if (WARN_ON(qnum >= ah->ah_capabilities.cap_queues.q_tx_num)) {
 		dev_kfree_skb_any(skb);
 		return;
 	}
 
-	ath5k_tx_queue(hw, skb, &sc->txqs[qnum]);
+	ath5k_tx_queue(hw, skb, &ah->txqs[qnum]);
 }
 
 
@@ -82,15 +82,15 @@ ath5k_stop(struct ieee80211_hw *hw)
 static int
 ath5k_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 {
-	struct ath5k_softc *sc = hw->priv;
+	struct ath5k_hw *ah = hw->priv;
 	int ret;
 	struct ath5k_vif *avf = (void *)vif->drv_priv;
 
-	mutex_lock(&sc->lock);
+	mutex_lock(&ah->lock);
 
 	if ((vif->type == NL80211_IFTYPE_AP ||
 	     vif->type == NL80211_IFTYPE_ADHOC)
-	    && (sc->num_ap_vifs + sc->num_adhoc_vifs) >= ATH_BCBUF) {
+	    && (ah->num_ap_vifs + ah->num_adhoc_vifs) >= ATH_BCBUF) {
 		ret = -ELNRNG;
 		goto end;
 	}
@@ -100,9 +100,9 @@ ath5k_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	 * We would need to operate the HW in ad-hoc mode to allow TSF updates
 	 * for the IBSS, but this breaks with additional AP or STA interfaces
 	 * at the moment. */
-	if (sc->num_adhoc_vifs ||
-	    (sc->nvifs && vif->type == NL80211_IFTYPE_ADHOC)) {
-		ATH5K_ERR(sc, "Only one single ad-hoc interface is allowed.\n");
+	if (ah->num_adhoc_vifs ||
+	    (ah->nvifs && vif->type == NL80211_IFTYPE_ADHOC)) {
+		ATH5K_ERR(ah, "Only one single ad-hoc interface is allowed.\n");
 		ret = -ELNRNG;
 		goto end;
 	}
@@ -119,8 +119,8 @@ ath5k_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 		goto end;
 	}
 
-	sc->nvifs++;
-	ATH5K_DBG(sc, ATH5K_DEBUG_MODE, "add interface mode %d\n", avf->opmode);
+	ah->nvifs++;
+	ATH5K_DBG(ah, ATH5K_DEBUG_MODE, "add interface mode %d\n", avf->opmode);
 
 	/* Assign the vap/adhoc to a beacon xmit slot. */
 	if ((avf->opmode == NL80211_IFTYPE_AP) ||
@@ -128,38 +128,38 @@ ath5k_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	    (avf->opmode == NL80211_IFTYPE_MESH_POINT)) {
 		int slot;
 
-		WARN_ON(list_empty(&sc->bcbuf));
-		avf->bbuf = list_first_entry(&sc->bcbuf, struct ath5k_buf,
+		WARN_ON(list_empty(&ah->bcbuf));
+		avf->bbuf = list_first_entry(&ah->bcbuf, struct ath5k_buf,
 					     list);
 		list_del(&avf->bbuf->list);
 
 		avf->bslot = 0;
 		for (slot = 0; slot < ATH_BCBUF; slot++) {
-			if (!sc->bslot[slot]) {
+			if (!ah->bslot[slot]) {
 				avf->bslot = slot;
 				break;
 			}
 		}
-		BUG_ON(sc->bslot[avf->bslot] != NULL);
-		sc->bslot[avf->bslot] = vif;
+		BUG_ON(ah->bslot[avf->bslot] != NULL);
+		ah->bslot[avf->bslot] = vif;
 		if (avf->opmode == NL80211_IFTYPE_AP)
-			sc->num_ap_vifs++;
+			ah->num_ap_vifs++;
 		else if (avf->opmode == NL80211_IFTYPE_ADHOC)
-			sc->num_adhoc_vifs++;
+			ah->num_adhoc_vifs++;
 	}
 
 	/* Any MAC address is fine, all others are included through the
 	 * filter.
 	 */
-	memcpy(&sc->lladdr, vif->addr, ETH_ALEN);
-	ath5k_hw_set_lladdr(sc->ah, vif->addr);
+	memcpy(&ah->lladdr, vif->addr, ETH_ALEN);
+	ath5k_hw_set_lladdr(ah, vif->addr);
 
 	memcpy(&avf->lladdr, vif->addr, ETH_ALEN);
 
-	ath5k_update_bssid_mask_and_opmode(sc, vif);
+	ath5k_update_bssid_mask_and_opmode(ah, vif);
 	ret = 0;
 end:
-	mutex_unlock(&sc->lock);
+	mutex_unlock(&ah->lock);
 	return ret;
 }
 
@@ -168,31 +168,31 @@ static void
 ath5k_remove_interface(struct ieee80211_hw *hw,
 		       struct ieee80211_vif *vif)
 {
-	struct ath5k_softc *sc = hw->priv;
+	struct ath5k_hw *ah = hw->priv;
 	struct ath5k_vif *avf = (void *)vif->drv_priv;
 	unsigned int i;
 
-	mutex_lock(&sc->lock);
-	sc->nvifs--;
+	mutex_lock(&ah->lock);
+	ah->nvifs--;
 
 	if (avf->bbuf) {
-		ath5k_txbuf_free_skb(sc, avf->bbuf);
-		list_add_tail(&avf->bbuf->list, &sc->bcbuf);
+		ath5k_txbuf_free_skb(ah, avf->bbuf);
+		list_add_tail(&avf->bbuf->list, &ah->bcbuf);
 		for (i = 0; i < ATH_BCBUF; i++) {
-			if (sc->bslot[i] == vif) {
-				sc->bslot[i] = NULL;
+			if (ah->bslot[i] == vif) {
+				ah->bslot[i] = NULL;
 				break;
 			}
 		}
 		avf->bbuf = NULL;
 	}
 	if (avf->opmode == NL80211_IFTYPE_AP)
-		sc->num_ap_vifs--;
+		ah->num_ap_vifs--;
 	else if (avf->opmode == NL80211_IFTYPE_ADHOC)
-		sc->num_adhoc_vifs--;
+		ah->num_adhoc_vifs--;
 
-	ath5k_update_bssid_mask_and_opmode(sc, NULL);
-	mutex_unlock(&sc->lock);
+	ath5k_update_bssid_mask_and_opmode(ah, NULL);
+	mutex_unlock(&ah->lock);
 }
 
 
@@ -202,23 +202,22 @@ ath5k_remove_interface(struct ieee80211_hw *hw,
 static int
 ath5k_config(struct ieee80211_hw *hw, u32 changed)
 {
-	struct ath5k_softc *sc = hw->priv;
-	struct ath5k_hw *ah = sc->ah;
+	struct ath5k_hw *ah = hw->priv;
 	struct ieee80211_conf *conf = &hw->conf;
 	int ret = 0;
 	int i;
 
-	mutex_lock(&sc->lock);
+	mutex_lock(&ah->lock);
 
 	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
-		ret = ath5k_chan_set(sc, conf->channel);
+		ret = ath5k_chan_set(ah, conf->channel);
 		if (ret < 0)
 			goto unlock;
 	}
 
 	if ((changed & IEEE80211_CONF_CHANGE_POWER) &&
-	(sc->power_level != conf->power_level)) {
-		sc->power_level = conf->power_level;
+	(ah->power_level != conf->power_level)) {
+		ah->power_level = conf->power_level;
 
 		/* Half dB steps */
 		ath5k_hw_set_txpower_limit(ah, (conf->power_level * 2));
@@ -252,7 +251,7 @@ ath5k_config(struct ieee80211_hw *hw, u32 changed)
 	ath5k_hw_set_antenna_mode(ah, ah->ah_ant_mode);
 
 unlock:
-	mutex_unlock(&sc->lock);
+	mutex_unlock(&ah->lock);
 	return ret;
 }
 
@@ -262,12 +261,11 @@ ath5k_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		       struct ieee80211_bss_conf *bss_conf, u32 changes)
 {
 	struct ath5k_vif *avf = (void *)vif->drv_priv;
-	struct ath5k_softc *sc = hw->priv;
-	struct ath5k_hw *ah = sc->ah;
+	struct ath5k_hw *ah = hw->priv;
 	struct ath_common *common = ath5k_hw_common(ah);
 	unsigned long flags;
 
-	mutex_lock(&sc->lock);
+	mutex_lock(&ah->lock);
 
 	if (changes & BSS_CHANGED_BSSID) {
 		/* Cache for later use during resets */
@@ -278,7 +276,7 @@ ath5k_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	}
 
 	if (changes & BSS_CHANGED_BEACON_INT)
-		sc->bintval = bss_conf->beacon_int;
+		ah->bintval = bss_conf->beacon_int;
 
 	if (changes & BSS_CHANGED_ERP_SLOT) {
 		int slot_time;
@@ -292,16 +290,16 @@ ath5k_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	if (changes & BSS_CHANGED_ASSOC) {
 		avf->assoc = bss_conf->assoc;
 		if (bss_conf->assoc)
-			sc->assoc = bss_conf->assoc;
+			ah->assoc = bss_conf->assoc;
 		else
-			sc->assoc = ath5k_any_vif_assoc(sc);
+			ah->assoc = ath5k_any_vif_assoc(ah);
 
-		if (sc->opmode == NL80211_IFTYPE_STATION)
-			ath5k_set_beacon_filter(hw, sc->assoc);
-		ath5k_hw_set_ledstate(sc->ah, sc->assoc ?
+		if (ah->opmode == NL80211_IFTYPE_STATION)
+			ath5k_set_beacon_filter(hw, ah->assoc);
+		ath5k_hw_set_ledstate(ah, ah->assoc ?
 			AR5K_LED_ASSOC : AR5K_LED_INIT);
 		if (bss_conf->assoc) {
-			ATH5K_DBG(sc, ATH5K_DEBUG_ANY,
+			ATH5K_DBG(ah, ATH5K_DEBUG_ANY,
 				  "Bss Info ASSOC %d, bssid: %pM\n",
 				  bss_conf->aid, common->curbssid);
 			common->curaid = bss_conf->aid;
@@ -311,19 +309,19 @@ ath5k_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	}
 
 	if (changes & BSS_CHANGED_BEACON) {
-		spin_lock_irqsave(&sc->block, flags);
+		spin_lock_irqsave(&ah->block, flags);
 		ath5k_beacon_update(hw, vif);
-		spin_unlock_irqrestore(&sc->block, flags);
+		spin_unlock_irqrestore(&ah->block, flags);
 	}
 
 	if (changes & BSS_CHANGED_BEACON_ENABLED)
-		sc->enable_beacon = bss_conf->enable_beacon;
+		ah->enable_beacon = bss_conf->enable_beacon;
 
 	if (changes & (BSS_CHANGED_BEACON | BSS_CHANGED_BEACON_ENABLED |
 		       BSS_CHANGED_BEACON_INT))
-		ath5k_beacon_config(sc);
+		ath5k_beacon_config(ah);
 
-	mutex_unlock(&sc->lock);
+	mutex_unlock(&ah->lock);
 }
 
 
@@ -384,12 +382,11 @@ ath5k_configure_filter(struct ieee80211_hw *hw, unsigned int changed_flags,
 	FIF_PLCPFAIL | FIF_CONTROL | FIF_OTHER_BSS | \
 	FIF_BCN_PRBRESP_PROMISC)
 
-	struct ath5k_softc *sc = hw->priv;
-	struct ath5k_hw *ah = sc->ah;
+	struct ath5k_hw *ah = hw->priv;
 	u32 mfilt[2], rfilt;
 	struct ath5k_vif_iter_data iter_data; /* to count STA interfaces */
 
-	mutex_lock(&sc->lock);
+	mutex_lock(&ah->lock);
 
 	mfilt[0] = multicast;
 	mfilt[1] = multicast >> 32;
@@ -407,12 +404,12 @@ ath5k_configure_filter(struct ieee80211_hw *hw, unsigned int changed_flags,
 
 	if (changed_flags & (FIF_PROMISC_IN_BSS | FIF_OTHER_BSS)) {
 		if (*new_flags & FIF_PROMISC_IN_BSS)
-			__set_bit(ATH_STAT_PROMISC, sc->status);
+			__set_bit(ATH_STAT_PROMISC, ah->status);
 		else
-			__clear_bit(ATH_STAT_PROMISC, sc->status);
+			__clear_bit(ATH_STAT_PROMISC, ah->status);
 	}
 
-	if (test_bit(ATH_STAT_PROMISC, sc->status))
+	if (test_bit(ATH_STAT_PROMISC, ah->status))
 		rfilt |= AR5K_RX_FILTER_PROM;
 
 	/* Note, AR5K_RX_FILTER_MCAST is already enabled */
@@ -427,7 +424,7 @@ ath5k_configure_filter(struct ieee80211_hw *hw, unsigned int changed_flags,
 
 	/* FIF_BCN_PRBRESP_PROMISC really means to enable beacons
 	* and probes for any BSSID */
-	if ((*new_flags & FIF_BCN_PRBRESP_PROMISC) || (sc->nvifs > 1))
+	if ((*new_flags & FIF_BCN_PRBRESP_PROMISC) || (ah->nvifs > 1))
 		rfilt |= AR5K_RX_FILTER_BEACON;
 
 	/* FIF_CONTROL doc says that if FIF_PROMISC_IN_BSS is not
@@ -442,7 +439,7 @@ ath5k_configure_filter(struct ieee80211_hw *hw, unsigned int changed_flags,
 
 	/* XXX move these to mac80211, and add a beacon IFF flag to mac80211 */
 
-	switch (sc->opmode) {
+	switch (ah->opmode) {
 	case NL80211_IFTYPE_MESH_POINT:
 		rfilt |= AR5K_RX_FILTER_CONTROL |
 			 AR5K_RX_FILTER_BEACON |
@@ -455,7 +452,7 @@ ath5k_configure_filter(struct ieee80211_hw *hw, unsigned int changed_flags,
 			 AR5K_RX_FILTER_BEACON;
 		break;
 	case NL80211_IFTYPE_STATION:
-		if (sc->assoc)
+		if (ah->assoc)
 			rfilt |= AR5K_RX_FILTER_BEACON;
 	default:
 		break;
@@ -464,7 +461,7 @@ ath5k_configure_filter(struct ieee80211_hw *hw, unsigned int changed_flags,
 	iter_data.hw_macaddr = NULL;
 	iter_data.n_stas = 0;
 	iter_data.need_set_hw_addr = false;
-	ieee80211_iterate_active_interfaces_atomic(sc->hw, ath5k_vif_iter,
+	ieee80211_iterate_active_interfaces_atomic(ah->hw, ath5k_vif_iter,
 						   &iter_data);
 
 	/* Set up RX Filter */
@@ -483,9 +480,9 @@ ath5k_configure_filter(struct ieee80211_hw *hw, unsigned int changed_flags,
 	ath5k_hw_set_mcast_filter(ah, mfilt[0], mfilt[1]);
 	/* Set the cached hw filter flags, this will later actually
 	 * be set in HW */
-	sc->filter_flags = rfilt;
+	ah->filter_flags = rfilt;
 
-	mutex_unlock(&sc->lock);
+	mutex_unlock(&ah->lock);
 }
 
 
@@ -494,8 +491,7 @@ ath5k_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	      struct ieee80211_vif *vif, struct ieee80211_sta *sta,
 	      struct ieee80211_key_conf *key)
 {
-	struct ath5k_softc *sc = hw->priv;
-	struct ath5k_hw *ah = sc->ah;
+	struct ath5k_hw *ah = hw->priv;
 	struct ath_common *common = ath5k_hw_common(ah);
 	int ret = 0;
 
@@ -516,7 +512,7 @@ ath5k_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		return -EINVAL;
 	}
 
-	mutex_lock(&sc->lock);
+	mutex_lock(&ah->lock);
 
 	switch (cmd) {
 	case SET_KEY:
@@ -540,7 +536,7 @@ ath5k_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	}
 
 	mmiowb();
-	mutex_unlock(&sc->lock);
+	mutex_unlock(&ah->lock);
 	return ret;
 }
 
@@ -548,17 +544,17 @@ ath5k_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 static void
 ath5k_sw_scan_start(struct ieee80211_hw *hw)
 {
-	struct ath5k_softc *sc = hw->priv;
-	if (!sc->assoc)
-		ath5k_hw_set_ledstate(sc->ah, AR5K_LED_SCAN);
+	struct ath5k_hw *ah = hw->priv;
+	if (!ah->assoc)
+		ath5k_hw_set_ledstate(ah, AR5K_LED_SCAN);
 }
 
 
 static void
 ath5k_sw_scan_complete(struct ieee80211_hw *hw)
 {
-	struct ath5k_softc *sc = hw->priv;
-	ath5k_hw_set_ledstate(sc->ah, sc->assoc ?
+	struct ath5k_hw *ah = hw->priv;
+	ath5k_hw_set_ledstate(ah, ah->assoc ?
 		AR5K_LED_ASSOC : AR5K_LED_INIT);
 }
 
@@ -567,15 +563,15 @@ static int
 ath5k_get_stats(struct ieee80211_hw *hw,
 		struct ieee80211_low_level_stats *stats)
 {
-	struct ath5k_softc *sc = hw->priv;
+	struct ath5k_hw *ah = hw->priv;
 
 	/* Force update */
-	ath5k_hw_update_mib_counters(sc->ah);
+	ath5k_hw_update_mib_counters(ah);
 
-	stats->dot11ACKFailureCount = sc->stats.ack_fail;
-	stats->dot11RTSFailureCount = sc->stats.rts_fail;
-	stats->dot11RTSSuccessCount = sc->stats.rts_ok;
-	stats->dot11FCSErrorCount = sc->stats.fcs_error;
+	stats->dot11ACKFailureCount = ah->stats.ack_fail;
+	stats->dot11RTSFailureCount = ah->stats.rts_fail;
+	stats->dot11RTSSuccessCount = ah->stats.rts_ok;
+	stats->dot11FCSErrorCount = ah->stats.fcs_error;
 
 	return 0;
 }
@@ -585,15 +581,14 @@ static int
 ath5k_conf_tx(struct ieee80211_hw *hw, u16 queue,
 	      const struct ieee80211_tx_queue_params *params)
 {
-	struct ath5k_softc *sc = hw->priv;
-	struct ath5k_hw *ah = sc->ah;
+	struct ath5k_hw *ah = hw->priv;
 	struct ath5k_txq_info qi;
 	int ret = 0;
 
 	if (queue >= ah->ah_capabilities.cap_queues.q_tx_num)
 		return 0;
 
-	mutex_lock(&sc->lock);
+	mutex_lock(&ah->lock);
 
 	ath5k_hw_get_tx_queueprops(ah, queue, &qi);
 
@@ -602,20 +597,20 @@ ath5k_conf_tx(struct ieee80211_hw *hw, u16 queue,
 	qi.tqi_cw_max = params->cw_max;
 	qi.tqi_burst_time = params->txop;
 
-	ATH5K_DBG(sc, ATH5K_DEBUG_ANY,
+	ATH5K_DBG(ah, ATH5K_DEBUG_ANY,
 		  "Configure tx [queue %d],  "
 		  "aifs: %d, cw_min: %d, cw_max: %d, txop: %d\n",
 		  queue, params->aifs, params->cw_min,
 		  params->cw_max, params->txop);
 
 	if (ath5k_hw_set_tx_queueprops(ah, queue, &qi)) {
-		ATH5K_ERR(sc,
+		ATH5K_ERR(ah,
 			  "Unable to update hardware queue %u!\n", queue);
 		ret = -EIO;
 	} else
 		ath5k_hw_reset_tx_queue(ah, queue);
 
-	mutex_unlock(&sc->lock);
+	mutex_unlock(&ah->lock);
 
 	return ret;
 }
@@ -624,43 +619,43 @@ ath5k_conf_tx(struct ieee80211_hw *hw, u16 queue,
 static u64
 ath5k_get_tsf(struct ieee80211_hw *hw)
 {
-	struct ath5k_softc *sc = hw->priv;
+	struct ath5k_hw *ah = hw->priv;
 
-	return ath5k_hw_get_tsf64(sc->ah);
+	return ath5k_hw_get_tsf64(ah);
 }
 
 
 static void
 ath5k_set_tsf(struct ieee80211_hw *hw, u64 tsf)
 {
-	struct ath5k_softc *sc = hw->priv;
+	struct ath5k_hw *ah = hw->priv;
 
-	ath5k_hw_set_tsf64(sc->ah, tsf);
+	ath5k_hw_set_tsf64(ah, tsf);
 }
 
 
 static void
 ath5k_reset_tsf(struct ieee80211_hw *hw)
 {
-	struct ath5k_softc *sc = hw->priv;
+	struct ath5k_hw *ah = hw->priv;
 
 	/*
 	 * in IBSS mode we need to update the beacon timers too.
 	 * this will also reset the TSF if we call it with 0
 	 */
-	if (sc->opmode == NL80211_IFTYPE_ADHOC)
-		ath5k_beacon_update_timers(sc, 0);
+	if (ah->opmode == NL80211_IFTYPE_ADHOC)
+		ath5k_beacon_update_timers(ah, 0);
 	else
-		ath5k_hw_reset_tsf(sc->ah);
+		ath5k_hw_reset_tsf(ah);
 }
 
 
 static int
 ath5k_get_survey(struct ieee80211_hw *hw, int idx, struct survey_info *survey)
 {
-	struct ath5k_softc *sc = hw->priv;
+	struct ath5k_hw *ah = hw->priv;
 	struct ieee80211_conf *conf = &hw->conf;
-	struct ath_common *common = ath5k_hw_common(sc->ah);
+	struct ath_common *common = ath5k_hw_common(ah);
 	struct ath_cycle_counters *cc = &common->cc_survey;
 	unsigned int div = common->clockrate * 1000;
 
@@ -670,18 +665,18 @@ ath5k_get_survey(struct ieee80211_hw *hw, int idx, struct survey_info *survey)
 	spin_lock_bh(&common->cc_lock);
 	ath_hw_cycle_counters_update(common);
 	if (cc->cycles > 0) {
-		sc->survey.channel_time += cc->cycles / div;
-		sc->survey.channel_time_busy += cc->rx_busy / div;
-		sc->survey.channel_time_rx += cc->rx_frame / div;
-		sc->survey.channel_time_tx += cc->tx_frame / div;
+		ah->survey.channel_time += cc->cycles / div;
+		ah->survey.channel_time_busy += cc->rx_busy / div;
+		ah->survey.channel_time_rx += cc->rx_frame / div;
+		ah->survey.channel_time_tx += cc->tx_frame / div;
 	}
 	memset(cc, 0, sizeof(*cc));
 	spin_unlock_bh(&common->cc_lock);
 
-	memcpy(survey, &sc->survey, sizeof(*survey));
+	memcpy(survey, &ah->survey, sizeof(*survey));
 
 	survey->channel = conf->channel;
-	survey->noise = sc->ah->ah_noise_floor;
+	survey->noise = ah->ah_noise_floor;
 	survey->filled = SURVEY_INFO_NOISE_DBM |
 			SURVEY_INFO_CHANNEL_TIME |
 			SURVEY_INFO_CHANNEL_TIME_BUSY |
@@ -705,25 +700,25 @@ ath5k_get_survey(struct ieee80211_hw *hw, int idx, struct survey_info *survey)
 static void
 ath5k_set_coverage_class(struct ieee80211_hw *hw, u8 coverage_class)
 {
-	struct ath5k_softc *sc = hw->priv;
+	struct ath5k_hw *ah = hw->priv;
 
-	mutex_lock(&sc->lock);
-	ath5k_hw_set_coverage_class(sc->ah, coverage_class);
-	mutex_unlock(&sc->lock);
+	mutex_lock(&ah->lock);
+	ath5k_hw_set_coverage_class(ah, coverage_class);
+	mutex_unlock(&ah->lock);
 }
 
 
 static int
 ath5k_set_antenna(struct ieee80211_hw *hw, u32 tx_ant, u32 rx_ant)
 {
-	struct ath5k_softc *sc = hw->priv;
+	struct ath5k_hw *ah = hw->priv;
 
 	if (tx_ant == 1 && rx_ant == 1)
-		ath5k_hw_set_antenna_mode(sc->ah, AR5K_ANTMODE_FIXED_A);
+		ath5k_hw_set_antenna_mode(ah, AR5K_ANTMODE_FIXED_A);
 	else if (tx_ant == 2 && rx_ant == 2)
-		ath5k_hw_set_antenna_mode(sc->ah, AR5K_ANTMODE_FIXED_B);
+		ath5k_hw_set_antenna_mode(ah, AR5K_ANTMODE_FIXED_B);
 	else if ((tx_ant & 3) == 3 && (rx_ant & 3) == 3)
-		ath5k_hw_set_antenna_mode(sc->ah, AR5K_ANTMODE_DEFAULT);
+		ath5k_hw_set_antenna_mode(ah, AR5K_ANTMODE_DEFAULT);
 	else
 		return -EINVAL;
 	return 0;
@@ -733,9 +728,9 @@ ath5k_set_antenna(struct ieee80211_hw *hw, u32 tx_ant, u32 rx_ant)
 static int
 ath5k_get_antenna(struct ieee80211_hw *hw, u32 *tx_ant, u32 *rx_ant)
 {
-	struct ath5k_softc *sc = hw->priv;
+	struct ath5k_hw *ah = hw->priv;
 
-	switch (sc->ah->ah_ant_mode) {
+	switch (ah->ah_ant_mode) {
 	case AR5K_ANTMODE_FIXED_A:
 		*tx_ant = 1; *rx_ant = 1; break;
 	case AR5K_ANTMODE_FIXED_B:
@@ -750,9 +745,9 @@ ath5k_get_antenna(struct ieee80211_hw *hw, u32 *tx_ant, u32 *rx_ant)
 static void ath5k_get_ringparam(struct ieee80211_hw *hw,
 				u32 *tx, u32 *tx_max, u32 *rx, u32 *rx_max)
 {
-	struct ath5k_softc *sc = hw->priv;
+	struct ath5k_hw *ah = hw->priv;
 
-	*tx = sc->txqs[AR5K_TX_QUEUE_ID_DATA_MIN].txq_max;
+	*tx = ah->txqs[AR5K_TX_QUEUE_ID_DATA_MIN].txq_max;
 
 	*tx_max = ATH5K_TXQ_LEN_MAX;
 	*rx = *rx_max = ATH_RXBUF;
@@ -761,7 +756,7 @@ static void ath5k_get_ringparam(struct ieee80211_hw *hw,
 
 static int ath5k_set_ringparam(struct ieee80211_hw *hw, u32 tx, u32 rx)
 {
-	struct ath5k_softc *sc = hw->priv;
+	struct ath5k_hw *ah = hw->priv;
 	u16 qnum;
 
 	/* only support setting tx ring size for now */
@@ -772,16 +767,16 @@ static int ath5k_set_ringparam(struct ieee80211_hw *hw, u32 tx, u32 rx)
 	if (!tx || tx > ATH5K_TXQ_LEN_MAX)
 		return -EINVAL;
 
-	for (qnum = 0; qnum < ARRAY_SIZE(sc->txqs); qnum++) {
-		if (!sc->txqs[qnum].setup)
+	for (qnum = 0; qnum < ARRAY_SIZE(ah->txqs); qnum++) {
+		if (!ah->txqs[qnum].setup)
 			continue;
-		if (sc->txqs[qnum].qnum < AR5K_TX_QUEUE_ID_DATA_MIN ||
-		    sc->txqs[qnum].qnum > AR5K_TX_QUEUE_ID_DATA_MAX)
+		if (ah->txqs[qnum].qnum < AR5K_TX_QUEUE_ID_DATA_MIN ||
+		    ah->txqs[qnum].qnum > AR5K_TX_QUEUE_ID_DATA_MAX)
 			continue;
 
-		sc->txqs[qnum].txq_max = tx;
-		if (sc->txqs[qnum].txq_len >= sc->txqs[qnum].txq_max)
-			ieee80211_stop_queue(hw, sc->txqs[qnum].qnum);
+		ah->txqs[qnum].txq_max = tx;
+		if (ah->txqs[qnum].txq_len >= ah->txqs[qnum].txq_max)
+			ieee80211_stop_queue(hw, ah->txqs[qnum].qnum);
 	}
 
 	return 0;
diff --git a/drivers/net/wireless/ath/ath5k/pci.c b/drivers/net/wireless/ath/ath5k/pci.c
index aac5b78..c1dff2c 100644
--- a/drivers/net/wireless/ath/ath5k/pci.c
+++ b/drivers/net/wireless/ath/ath5k/pci.c
@@ -51,10 +51,10 @@ MODULE_DEVICE_TABLE(pci, ath5k_pci_id_table);
 /* return bus cachesize in 4B word units */
 static void ath5k_pci_read_cachesize(struct ath_common *common, int *csz)
 {
-	struct ath5k_softc *sc = (struct ath5k_softc *) common->priv;
+	struct ath5k_hw *ah = (struct ath5k_hw *) common->priv;
 	u8 u8tmp;
 
-	pci_read_config_byte(sc->pdev, PCI_CACHE_LINE_SIZE, &u8tmp);
+	pci_read_config_byte(ah->pdev, PCI_CACHE_LINE_SIZE, &u8tmp);
 	*csz = (int)u8tmp;
 
 	/*
@@ -156,7 +156,7 @@ ath5k_pci_probe(struct pci_dev *pdev,
 		const struct pci_device_id *id)
 {
 	void __iomem *mem;
-	struct ath5k_softc *sc;
+	struct ath5k_hw *ah;
 	struct ieee80211_hw *hw;
 	int ret;
 	u8 csz;
@@ -243,7 +243,7 @@ ath5k_pci_probe(struct pci_dev *pdev,
 	 * Allocate hw (mac80211 main struct)
 	 * and hw->priv (driver private data)
 	 */
-	hw = ieee80211_alloc_hw(sizeof(*sc), &ath5k_hw_ops);
+	hw = ieee80211_alloc_hw(sizeof(*ah), &ath5k_hw_ops);
 	if (hw == NULL) {
 		dev_err(&pdev->dev, "cannot allocate ieee80211_hw\n");
 		ret = -ENOMEM;
@@ -252,16 +252,16 @@ ath5k_pci_probe(struct pci_dev *pdev,
 
 	dev_info(&pdev->dev, "registered as '%s'\n", wiphy_name(hw->wiphy));
 
-	sc = hw->priv;
-	sc->hw = hw;
-	sc->pdev = pdev;
-	sc->dev = &pdev->dev;
-	sc->irq = pdev->irq;
-	sc->devid = id->device;
-	sc->iobase = mem; /* So we can unmap it on detach */
+	ah = hw->priv;
+	ah->hw = hw;
+	ah->pdev = pdev;
+	ah->dev = &pdev->dev;
+	ah->irq = pdev->irq;
+	ah->devid = id->device;
+	ah->iobase = mem; /* So we can unmap it on detach */
 
 	/* Initialize */
-	ret = ath5k_init_softc(sc, &ath_pci_bus_ops);
+	ret = ath5k_init_ah(ah, &ath_pci_bus_ops);
 	if (ret)
 		goto err_free;
 
@@ -285,10 +285,10 @@ static void __devexit
 ath5k_pci_remove(struct pci_dev *pdev)
 {
 	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
-	struct ath5k_softc *sc = hw->priv;
+	struct ath5k_hw *ah = hw->priv;
 
-	ath5k_deinit_softc(sc);
-	pci_iounmap(pdev, sc->iobase);
+	ath5k_deinit_ah(ah);
+	pci_iounmap(pdev, ah->iobase);
 	pci_release_region(pdev, 0);
 	pci_disable_device(pdev);
 	ieee80211_free_hw(hw);
@@ -299,9 +299,9 @@ static int ath5k_pci_suspend(struct device *dev)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
-	struct ath5k_softc *sc = hw->priv;
+	struct ath5k_hw *ah = hw->priv;
 
-	ath5k_led_off(sc);
+	ath5k_led_off(ah);
 	return 0;
 }
 
@@ -309,7 +309,7 @@ static int ath5k_pci_resume(struct device *dev)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
-	struct ath5k_softc *sc = hw->priv;
+	struct ath5k_hw *ah = hw->priv;
 
 	/*
 	 * Suspend/Resume resets the PCI configuration space, so we have to
@@ -318,7 +318,7 @@ static int ath5k_pci_resume(struct device *dev)
 	 */
 	pci_write_config_byte(pdev, 0x41, 0);
 
-	ath5k_led_enable(sc);
+	ath5k_led_enable(ah);
 	return 0;
 }
 
diff --git a/drivers/net/wireless/ath/ath5k/pcu.c b/drivers/net/wireless/ath/ath5k/pcu.c
index 618ee54..0673138 100644
--- a/drivers/net/wireless/ath/ath5k/pcu.c
+++ b/drivers/net/wireless/ath/ath5k/pcu.c
@@ -77,14 +77,13 @@ static const unsigned int ack_rates_high[] =
 int ath5k_hw_get_frame_duration(struct ath5k_hw *ah,
 		int len, struct ieee80211_rate *rate, bool shortpre)
 {
-	struct ath5k_softc *sc = ah->ah_sc;
 	int sifs, preamble, plcp_bits, sym_time;
 	int bitrate, bits, symbols, symbol_bits;
 	int dur;
 
 	/* Fallback */
 	if (!ah->ah_bwmode) {
-		__le16 raw_dur = ieee80211_generic_frame_duration(sc->hw,
+		__le16 raw_dur = ieee80211_generic_frame_duration(ah->hw,
 					NULL, len, rate);
 
 		/* subtract difference between long and short preamble */
@@ -205,7 +204,7 @@ unsigned int ath5k_hw_get_default_sifs(struct ath5k_hw *ah)
  */
 void ath5k_hw_update_mib_counters(struct ath5k_hw *ah)
 {
-	struct ath5k_statistics *stats = &ah->ah_sc->stats;
+	struct ath5k_statistics *stats = &ah->stats;
 
 	/* Read-And-Clear */
 	stats->ack_fail += ath5k_hw_reg_read(ah, AR5K_ACK_FAIL);
@@ -240,25 +239,24 @@ void ath5k_hw_update_mib_counters(struct ath5k_hw *ah)
  */
 static inline void ath5k_hw_write_rate_duration(struct ath5k_hw *ah)
 {
-	struct ath5k_softc *sc = ah->ah_sc;
 	struct ieee80211_rate *rate;
 	unsigned int i;
 	/* 802.11g covers both OFDM and CCK */
 	u8 band = IEEE80211_BAND_2GHZ;
 
 	/* Write rate duration table */
-	for (i = 0; i < sc->sbands[band].n_bitrates; i++) {
+	for (i = 0; i < ah->sbands[band].n_bitrates; i++) {
 		u32 reg;
 		u16 tx_time;
 
 		if (ah->ah_ack_bitrate_high)
-			rate = &sc->sbands[band].bitrates[ack_rates_high[i]];
+			rate = &ah->sbands[band].bitrates[ack_rates_high[i]];
 		/* CCK -> 1Mb */
 		else if (i < 4)
-			rate = &sc->sbands[band].bitrates[0];
+			rate = &ah->sbands[band].bitrates[0];
 		/* OFDM -> 6Mb */
 		else
-			rate = &sc->sbands[band].bitrates[4];
+			rate = &ah->sbands[band].bitrates[4];
 
 		/* Set ACK timeout */
 		reg = AR5K_RATE_DUR(rate->hw_value);
@@ -586,7 +584,7 @@ void ath5k_hw_init_beacon(struct ath5k_hw *ah, u32 next_beacon, u32 interval)
 	/*
 	 * Set the additional timers by mode
 	 */
-	switch (ah->ah_sc->opmode) {
+	switch (ah->opmode) {
 	case NL80211_IFTYPE_MONITOR:
 	case NL80211_IFTYPE_STATION:
 		/* In STA mode timer1 is used as next wakeup
@@ -623,8 +621,8 @@ void ath5k_hw_init_beacon(struct ath5k_hw *ah, u32 next_beacon, u32 interval)
 	 * Set the beacon register and enable all timers.
 	 */
 	/* When in AP or Mesh Point mode zero timer0 to start TSF */
-	if (ah->ah_sc->opmode == NL80211_IFTYPE_AP ||
-	    ah->ah_sc->opmode == NL80211_IFTYPE_MESH_POINT)
+	if (ah->opmode == NL80211_IFTYPE_AP ||
+	    ah->opmode == NL80211_IFTYPE_MESH_POINT)
 		ath5k_hw_reg_write(ah, 0, AR5K_TIMER0);
 
 	ath5k_hw_reg_write(ah, next_beacon, AR5K_TIMER0);
@@ -814,7 +812,7 @@ int ath5k_hw_set_opmode(struct ath5k_hw *ah, enum nl80211_iftype op_mode)
 	struct ath_common *common = ath5k_hw_common(ah);
 	u32 pcu_reg, beacon_reg, low_id, high_id;
 
-	ATH5K_DBG(ah->ah_sc, ATH5K_DEBUG_MODE, "mode %d\n", op_mode);
+	ATH5K_DBG(ah, ATH5K_DEBUG_MODE, "mode %d\n", op_mode);
 
 	/* Preserve rest settings */
 	pcu_reg = ath5k_hw_reg_read(ah, AR5K_STA_ID1) & 0xffff0000;
@@ -890,7 +888,7 @@ void ath5k_hw_pcu_init(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 	 * XXX: rethink this after new mode changes to
 	 * mac80211 are integrated */
 	if (ah->ah_version == AR5K_AR5212 &&
-		ah->ah_sc->nvifs)
+		ah->nvifs)
 		ath5k_hw_write_rate_duration(ah);
 
 	/* Set RSSI/BRSSI thresholds
diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index dd2b417..a0c66cf 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -561,7 +561,7 @@ static s8 ath5k_hw_rf_gainf_adjust(struct ath5k_hw *ah)
 	}
 
 done:
-	ATH5K_DBG(ah->ah_sc, ATH5K_DEBUG_CALIBRATE,
+	ATH5K_DBG(ah, ATH5K_DEBUG_CALIBRATE,
 		"ret %d, gain step %u, current gain %u, target gain %u\n",
 		ret, ah->ah_gain.g_step_idx, ah->ah_gain.g_current,
 		ah->ah_gain.g_target);
@@ -773,7 +773,7 @@ static int ath5k_hw_rfregs_init(struct ath5k_hw *ah,
 		ah->ah_rf_banks = kmalloc(sizeof(u32) * ah->ah_rf_banks_size,
 								GFP_KERNEL);
 		if (ah->ah_rf_banks == NULL) {
-			ATH5K_ERR(ah->ah_sc, "out of memory\n");
+			ATH5K_ERR(ah, "out of memory\n");
 			return -ENOMEM;
 		}
 	}
@@ -783,7 +783,7 @@ static int ath5k_hw_rfregs_init(struct ath5k_hw *ah,
 
 	for (i = 0; i < ah->ah_rf_banks_size; i++) {
 		if (ini_rfb[i].rfb_bank >= AR5K_MAX_RF_BANKS) {
-			ATH5K_ERR(ah->ah_sc, "invalid bank\n");
+			ATH5K_ERR(ah, "invalid bank\n");
 			return -EINVAL;
 		}
 
@@ -1268,7 +1268,7 @@ static int ath5k_hw_channel(struct ath5k_hw *ah,
 	 * (CHANNEL_2GHZ, or CHANNEL_5GHZ) so we inform ath5k_channel_ok()
 	 * of the band by that */
 	if (!ath5k_channel_ok(ah, channel->center_freq, channel->hw_value)) {
-		ATH5K_ERR(ah->ah_sc,
+		ATH5K_ERR(ah,
 			"channel frequency (%u MHz) out of supported "
 			"band range\n",
 			channel->center_freq);
@@ -1356,7 +1356,7 @@ static s16 ath5k_hw_get_median_noise_floor(struct ath5k_hw *ah)
 		}
 	}
 	for (i = 0; i < ATH5K_NF_CAL_HIST_MAX; i++) {
-		ATH5K_DBG(ah->ah_sc, ATH5K_DEBUG_CALIBRATE,
+		ATH5K_DBG(ah, ATH5K_DEBUG_CALIBRATE,
 			"cal %d:%d\n", i, sort[i]);
 	}
 	return sort[(ATH5K_NF_CAL_HIST_MAX - 1) / 2];
@@ -1382,7 +1382,7 @@ void ath5k_hw_update_noise_floor(struct ath5k_hw *ah)
 
 	/* keep last value if calibration hasn't completed */
 	if (ath5k_hw_reg_read(ah, AR5K_PHY_AGCCTL) & AR5K_PHY_AGCCTL_NF) {
-		ATH5K_DBG(ah->ah_sc, ATH5K_DEBUG_CALIBRATE,
+		ATH5K_DBG(ah, ATH5K_DEBUG_CALIBRATE,
 			"NF did not complete in calibration window\n");
 
 		return;
@@ -1395,7 +1395,7 @@ void ath5k_hw_update_noise_floor(struct ath5k_hw *ah)
 	threshold = ee->ee_noise_floor_thr[ee_mode];
 
 	if (nf > threshold) {
-		ATH5K_DBG(ah->ah_sc, ATH5K_DEBUG_CALIBRATE,
+		ATH5K_DBG(ah, ATH5K_DEBUG_CALIBRATE,
 			"noise floor failure detected; "
 			"read %d, threshold %d\n",
 			nf, threshold);
@@ -1432,7 +1432,7 @@ void ath5k_hw_update_noise_floor(struct ath5k_hw *ah)
 
 	ah->ah_noise_floor = nf;
 
-	ATH5K_DBG(ah->ah_sc, ATH5K_DEBUG_CALIBRATE,
+	ATH5K_DBG(ah, ATH5K_DEBUG_CALIBRATE,
 		"noise floor calibrated: %d\n", nf);
 }
 
@@ -1520,7 +1520,7 @@ static int ath5k_hw_rf5110_calibrate(struct ath5k_hw *ah,
 	ath5k_hw_reg_write(ah, phy_sat, AR5K_PHY_ADCSAT);
 
 	if (ret) {
-		ATH5K_ERR(ah->ah_sc, "calibration timeout (%uMHz)\n",
+		ATH5K_ERR(ah, "calibration timeout (%uMHz)\n",
 				channel->center_freq);
 		return ret;
 	}
@@ -1555,7 +1555,7 @@ ath5k_hw_rf511x_iq_calibrate(struct ath5k_hw *ah)
 		iq_corr = ath5k_hw_reg_read(ah, AR5K_PHY_IQRES_CAL_CORR);
 		i_pwr = ath5k_hw_reg_read(ah, AR5K_PHY_IQRES_CAL_PWR_I);
 		q_pwr = ath5k_hw_reg_read(ah, AR5K_PHY_IQRES_CAL_PWR_Q);
-		ATH5K_DBG_UNLIMIT(ah->ah_sc, ATH5K_DEBUG_CALIBRATE,
+		ATH5K_DBG_UNLIMIT(ah, ATH5K_DEBUG_CALIBRATE,
 			"iq_corr:%x i_pwr:%x q_pwr:%x", iq_corr, i_pwr, q_pwr);
 		if (i_pwr && q_pwr)
 			break;
@@ -1581,7 +1581,7 @@ ath5k_hw_rf511x_iq_calibrate(struct ath5k_hw *ah)
 		q_coff = (i_pwr / q_coffd) - 128;
 	q_coff = clamp(q_coff, -16, 15); /* signed 5 bit */
 
-	ATH5K_DBG_UNLIMIT(ah->ah_sc, ATH5K_DEBUG_CALIBRATE,
+	ATH5K_DBG_UNLIMIT(ah, ATH5K_DEBUG_CALIBRATE,
 			"new I:%d Q:%d (i_coffd:%x q_coffd:%x)",
 			i_coff, q_coff, i_coffd, q_coffd);
 
@@ -1966,7 +1966,7 @@ ath5k_hw_set_antenna_mode(struct ath5k_hw *ah, u8 ant_mode)
 
 	ee_mode = ath5k_eeprom_mode_from_channel(channel);
 	if (ee_mode < 0) {
-		ATH5K_ERR(ah->ah_sc,
+		ATH5K_ERR(ah,
 			"invalid channel: %d\n", channel->center_freq);
 		return;
 	}
@@ -3122,13 +3122,13 @@ ath5k_hw_txpower(struct ath5k_hw *ah, struct ieee80211_channel *channel,
 	int ret;
 
 	if (txpower > AR5K_TUNE_MAX_TXPOWER) {
-		ATH5K_ERR(ah->ah_sc, "invalid tx power: %u\n", txpower);
+		ATH5K_ERR(ah, "invalid tx power: %u\n", txpower);
 		return -EINVAL;
 	}
 
 	ee_mode = ath5k_eeprom_mode_from_channel(channel);
 	if (ee_mode < 0) {
-		ATH5K_ERR(ah->ah_sc,
+		ATH5K_ERR(ah,
 			"invalid channel: %d\n", channel->center_freq);
 		return -EINVAL;
 	}
@@ -3229,7 +3229,7 @@ ath5k_hw_txpower(struct ath5k_hw *ah, struct ieee80211_channel *channel,
 
 int ath5k_hw_set_txpower_limit(struct ath5k_hw *ah, u8 txpower)
 {
-	ATH5K_DBG(ah->ah_sc, ATH5K_DEBUG_TXPOWER,
+	ATH5K_DBG(ah, ATH5K_DEBUG_TXPOWER,
 		"changing txpower to %d\n", txpower);
 
 	return ath5k_hw_txpower(ah, ah->ah_current_channel, txpower);
@@ -3440,7 +3440,7 @@ int ath5k_hw_phy_init(struct ath5k_hw *ah, struct ieee80211_channel *channel,
 	 * during ath5k_phy_calibrate) */
 	if (ath5k_hw_register_timeout(ah, AR5K_PHY_AGCCTL,
 			AR5K_PHY_AGCCTL_CAL, 0, false)) {
-		ATH5K_ERR(ah->ah_sc, "gain calibration timeout (%uMHz)\n",
+		ATH5K_ERR(ah, "gain calibration timeout (%uMHz)\n",
 			channel->center_freq);
 	}
 
diff --git a/drivers/net/wireless/ath/ath5k/qcu.c b/drivers/net/wireless/ath/ath5k/qcu.c
index b18c502..65f1039 100644
--- a/drivers/net/wireless/ath/ath5k/qcu.c
+++ b/drivers/net/wireless/ath/ath5k/qcu.c
@@ -187,7 +187,7 @@ int ath5k_hw_setup_tx_queue(struct ath5k_hw *ah, enum ath5k_tx_queue queue_type,
 			break;
 		case AR5K_TX_QUEUE_XR_DATA:
 			if (ah->ah_version != AR5K_AR5212)
-				ATH5K_ERR(ah->ah_sc,
+				ATH5K_ERR(ah,
 					"XR data queues only supported in"
 					" 5212!\n");
 			queue = AR5K_TX_QUEUE_ID_XR_DATA;
@@ -510,7 +510,6 @@ int ath5k_hw_reset_tx_queue(struct ath5k_hw *ah, unsigned int queue)
 int ath5k_hw_set_ifs_intervals(struct ath5k_hw *ah, unsigned int slot_time)
 {
 	struct ieee80211_channel *channel = ah->ah_current_channel;
-	struct ath5k_softc *sc = ah->ah_sc;
 	struct ieee80211_rate *rate;
 	u32 ack_tx_time, eifs, eifs_clock, sifs, sifs_clock;
 	u32 slot_time_clock = ath5k_hw_htoclock(ah, slot_time);
@@ -546,9 +545,9 @@ int ath5k_hw_set_ifs_intervals(struct ath5k_hw *ah, unsigned int slot_time)
 	 * Also we have different lowest rate for 802.11a
 	 */
 	if (channel->hw_value & CHANNEL_5GHZ)
-		rate = &sc->sbands[IEEE80211_BAND_5GHZ].bitrates[0];
+		rate = &ah->sbands[IEEE80211_BAND_5GHZ].bitrates[0];
 	else
-		rate = &sc->sbands[IEEE80211_BAND_2GHZ].bitrates[0];
+		rate = &ah->sbands[IEEE80211_BAND_2GHZ].bitrates[0];
 
 	ack_tx_time = ath5k_hw_get_frame_duration(ah, 10, rate, false);
 
@@ -622,7 +621,7 @@ int ath5k_hw_init_queues(struct ath5k_hw *ah)
 		for (i = 0; i < ah->ah_capabilities.cap_queues.q_tx_num; i++) {
 			ret = ath5k_hw_reset_tx_queue(ah, i);
 			if (ret) {
-				ATH5K_ERR(ah->ah_sc,
+				ATH5K_ERR(ah,
 					"failed to reset TX queue #%d\n", i);
 				return ret;
 			}
diff --git a/drivers/net/wireless/ath/ath5k/reset.c b/drivers/net/wireless/ath/ath5k/reset.c
index 9f9c2ad..0686c5d 100644
--- a/drivers/net/wireless/ath/ath5k/reset.c
+++ b/drivers/net/wireless/ath/ath5k/reset.c
@@ -390,7 +390,7 @@ static int ath5k_hw_wisoc_reset(struct ath5k_hw *ah, u32 flags)
 	u32 val = 0;
 
 	/* ah->ah_mac_srev is not available at this point yet */
-	if (ah->ah_sc->devid >= AR5K_SREV_AR2315_R6) {
+	if (ah->devid >= AR5K_SREV_AR2315_R6) {
 		reg = (u32 __iomem *) AR5K_AR2315_RESET;
 		if (mask & AR5K_RESET_CTL_PCU)
 			val |= AR5K_AR2315_RESET_WMAC;
@@ -398,7 +398,7 @@ static int ath5k_hw_wisoc_reset(struct ath5k_hw *ah, u32 flags)
 			val |= AR5K_AR2315_RESET_BB_WARM;
 	} else {
 		reg = (u32 __iomem *) AR5K_AR5312_RESET;
-		if (to_platform_device(ah->ah_sc->dev)->id == 0) {
+		if (to_platform_device(ah->dev)->id == 0) {
 			if (mask & AR5K_RESET_CTL_PCU)
 				val |= AR5K_AR5312_RESET_WMAC0;
 			if (mask & AR5K_RESET_CTL_BASEBAND)
@@ -530,7 +530,7 @@ commit:
  */
 int ath5k_hw_on_hold(struct ath5k_hw *ah)
 {
-	struct pci_dev *pdev = ah->ah_sc->pdev;
+	struct pci_dev *pdev = ah->pdev;
 	u32 bus_flags;
 	int ret;
 
@@ -540,7 +540,7 @@ int ath5k_hw_on_hold(struct ath5k_hw *ah)
 	/* Make sure device is awake */
 	ret = ath5k_hw_set_power(ah, AR5K_PM_AWAKE, true, 0);
 	if (ret) {
-		ATH5K_ERR(ah->ah_sc, "failed to wakeup the MAC Chip\n");
+		ATH5K_ERR(ah, "failed to wakeup the MAC Chip\n");
 		return ret;
 	}
 
@@ -565,14 +565,14 @@ int ath5k_hw_on_hold(struct ath5k_hw *ah)
 	}
 
 	if (ret) {
-		ATH5K_ERR(ah->ah_sc, "failed to put device on warm reset\n");
+		ATH5K_ERR(ah, "failed to put device on warm reset\n");
 		return -EIO;
 	}
 
 	/* ...wakeup again!*/
 	ret = ath5k_hw_set_power(ah, AR5K_PM_AWAKE, true, 0);
 	if (ret) {
-		ATH5K_ERR(ah->ah_sc, "failed to put device on hold\n");
+		ATH5K_ERR(ah, "failed to put device on hold\n");
 		return ret;
 	}
 
@@ -584,7 +584,7 @@ int ath5k_hw_on_hold(struct ath5k_hw *ah)
  */
 int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int flags, bool initial)
 {
-	struct pci_dev *pdev = ah->ah_sc->pdev;
+	struct pci_dev *pdev = ah->pdev;
 	u32 turbo, mode, clock, bus_flags;
 	int ret;
 
@@ -596,7 +596,7 @@ int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int flags, bool initial)
 		/* Wakeup the device */
 		ret = ath5k_hw_set_power(ah, AR5K_PM_AWAKE, true, 0);
 		if (ret) {
-			ATH5K_ERR(ah->ah_sc, "failed to wakeup the MAC Chip\n");
+			ATH5K_ERR(ah, "failed to wakeup the MAC Chip\n");
 			return ret;
 		}
 	}
@@ -626,14 +626,14 @@ int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int flags, bool initial)
 	}
 
 	if (ret) {
-		ATH5K_ERR(ah->ah_sc, "failed to reset the MAC Chip\n");
+		ATH5K_ERR(ah, "failed to reset the MAC Chip\n");
 		return -EIO;
 	}
 
 	/* ...wakeup again!...*/
 	ret = ath5k_hw_set_power(ah, AR5K_PM_AWAKE, true, 0);
 	if (ret) {
-		ATH5K_ERR(ah->ah_sc, "failed to resume the MAC Chip\n");
+		ATH5K_ERR(ah, "failed to resume the MAC Chip\n");
 		return ret;
 	}
 
@@ -646,7 +646,7 @@ int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int flags, bool initial)
 		ret = ath5k_hw_nic_reset(ah, 0);
 
 	if (ret) {
-		ATH5K_ERR(ah->ah_sc, "failed to warm reset the MAC Chip\n");
+		ATH5K_ERR(ah, "failed to warm reset the MAC Chip\n");
 		return -EIO;
 	}
 
@@ -687,7 +687,7 @@ int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int flags, bool initial)
 				else
 					mode |= AR5K_PHY_MODE_MOD_DYN;
 			} else {
-				ATH5K_ERR(ah->ah_sc,
+				ATH5K_ERR(ah,
 					"invalid radio modulation mode\n");
 				return -EINVAL;
 			}
@@ -703,12 +703,12 @@ int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int flags, bool initial)
 			if (flags & CHANNEL_OFDM)
 				mode |= AR5K_PHY_MODE_MOD_OFDM;
 			else {
-				ATH5K_ERR(ah->ah_sc,
+				ATH5K_ERR(ah,
 					"invalid radio modulation mode\n");
 				return -EINVAL;
 			}
 		} else {
-			ATH5K_ERR(ah->ah_sc, "invalid radio frequency mode\n");
+			ATH5K_ERR(ah, "invalid radio frequency mode\n");
 			return -EINVAL;
 		}
 
@@ -1076,7 +1076,7 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 	/* RF Bus grant won't work if we have pending
 	 * frames */
 	if (ret && fast) {
-		ATH5K_DBG(ah->ah_sc, ATH5K_DEBUG_RESET,
+		ATH5K_DBG(ah, ATH5K_DEBUG_RESET,
 			"DMA didn't stop, falling back to normal reset\n");
 		fast = 0;
 		/* Non fatal, just continue with
@@ -1091,7 +1091,7 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 	case CHANNEL_G:
 
 		if (ah->ah_version <= AR5K_AR5211) {
-			ATH5K_ERR(ah->ah_sc,
+			ATH5K_ERR(ah,
 				"G mode not available on 5210/5211");
 			return -EINVAL;
 		}
@@ -1101,7 +1101,7 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 	case CHANNEL_B:
 
 		if (ah->ah_version < AR5K_AR5211) {
-			ATH5K_ERR(ah->ah_sc,
+			ATH5K_ERR(ah,
 				"B mode not available on 5210");
 			return -EINVAL;
 		}
@@ -1110,14 +1110,14 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 		break;
 	case CHANNEL_XR:
 		if (ah->ah_version == AR5K_AR5211) {
-			ATH5K_ERR(ah->ah_sc,
+			ATH5K_ERR(ah,
 				"XR mode not available on 5211");
 			return -EINVAL;
 		}
 		mode = AR5K_MODE_XR;
 		break;
 	default:
-		ATH5K_ERR(ah->ah_sc,
+		ATH5K_ERR(ah,
 			"invalid channel: %d\n", channel->center_freq);
 		return -EINVAL;
 	}
@@ -1129,13 +1129,13 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 	if (fast) {
 		ret = ath5k_hw_phy_init(ah, channel, mode, true);
 		if (ret) {
-			ATH5K_DBG(ah->ah_sc, ATH5K_DEBUG_RESET,
+			ATH5K_DBG(ah, ATH5K_DEBUG_RESET,
 				"fast chan change failed, falling back to normal reset\n");
 			/* Non fatal, can happen eg.
 			 * on mode change */
 			ret = 0;
 		} else {
-			ATH5K_DBG(ah->ah_sc, ATH5K_DEBUG_RESET,
+			ATH5K_DBG(ah, ATH5K_DEBUG_RESET,
 				"fast chan change successful\n");
 			return 0;
 		}
@@ -1268,7 +1268,7 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 	 */
 	ret = ath5k_hw_phy_init(ah, channel, mode, false);
 	if (ret) {
-		ATH5K_ERR(ah->ah_sc,
+		ATH5K_ERR(ah,
 			"failed to initialize PHY (%i) !\n", ret);
 		return ret;
 	}
diff --git a/drivers/net/wireless/ath/ath5k/rfkill.c b/drivers/net/wireless/ath/ath5k/rfkill.c
index 41a877b..945fc9f 100644
--- a/drivers/net/wireless/ath/ath5k/rfkill.c
+++ b/drivers/net/wireless/ath/ath5k/rfkill.c
@@ -36,86 +36,81 @@
 #include "base.h"
 
 
-static inline void ath5k_rfkill_disable(struct ath5k_softc *sc)
+static inline void ath5k_rfkill_disable(struct ath5k_hw *ah)
 {
-	ATH5K_DBG(sc, ATH5K_DEBUG_ANY, "rfkill disable (gpio:%d polarity:%d)\n",
-		sc->rf_kill.gpio, sc->rf_kill.polarity);
-	ath5k_hw_set_gpio_output(sc->ah, sc->rf_kill.gpio);
-	ath5k_hw_set_gpio(sc->ah, sc->rf_kill.gpio, !sc->rf_kill.polarity);
+	ATH5K_DBG(ah, ATH5K_DEBUG_ANY, "rfkill disable (gpio:%d polarity:%d)\n",
+		ah->rf_kill.gpio, ah->rf_kill.polarity);
+	ath5k_hw_set_gpio_output(ah, ah->rf_kill.gpio);
+	ath5k_hw_set_gpio(ah, ah->rf_kill.gpio, !ah->rf_kill.polarity);
 }
 
 
-static inline void ath5k_rfkill_enable(struct ath5k_softc *sc)
+static inline void ath5k_rfkill_enable(struct ath5k_hw *ah)
 {
-	ATH5K_DBG(sc, ATH5K_DEBUG_ANY, "rfkill enable (gpio:%d polarity:%d)\n",
-		sc->rf_kill.gpio, sc->rf_kill.polarity);
-	ath5k_hw_set_gpio_output(sc->ah, sc->rf_kill.gpio);
-	ath5k_hw_set_gpio(sc->ah, sc->rf_kill.gpio, sc->rf_kill.polarity);
+	ATH5K_DBG(ah, ATH5K_DEBUG_ANY, "rfkill enable (gpio:%d polarity:%d)\n",
+		ah->rf_kill.gpio, ah->rf_kill.polarity);
+	ath5k_hw_set_gpio_output(ah, ah->rf_kill.gpio);
+	ath5k_hw_set_gpio(ah, ah->rf_kill.gpio, ah->rf_kill.polarity);
 }
 
-static inline void ath5k_rfkill_set_intr(struct ath5k_softc *sc, bool enable)
+static inline void ath5k_rfkill_set_intr(struct ath5k_hw *ah, bool enable)
 {
-	struct ath5k_hw *ah = sc->ah;
 	u32 curval;
 
-	ath5k_hw_set_gpio_input(ah, sc->rf_kill.gpio);
-	curval = ath5k_hw_get_gpio(ah, sc->rf_kill.gpio);
-	ath5k_hw_set_gpio_intr(ah, sc->rf_kill.gpio, enable ?
+	ath5k_hw_set_gpio_input(ah, ah->rf_kill.gpio);
+	curval = ath5k_hw_get_gpio(ah, ah->rf_kill.gpio);
+	ath5k_hw_set_gpio_intr(ah, ah->rf_kill.gpio, enable ?
 					!!curval : !curval);
 }
 
 static bool
-ath5k_is_rfkill_set(struct ath5k_softc *sc)
+ath5k_is_rfkill_set(struct ath5k_hw *ah)
 {
 	/* configuring GPIO for input for some reason disables rfkill */
-	/*ath5k_hw_set_gpio_input(sc->ah, sc->rf_kill.gpio);*/
-	return ath5k_hw_get_gpio(sc->ah, sc->rf_kill.gpio) ==
-							sc->rf_kill.polarity;
+	/*ath5k_hw_set_gpio_input(ah, ah->rf_kill.gpio);*/
+	return ath5k_hw_get_gpio(ah, ah->rf_kill.gpio) ==
+							ah->rf_kill.polarity;
 }
 
 static void
 ath5k_tasklet_rfkill_toggle(unsigned long data)
 {
-	struct ath5k_softc *sc = (void *)data;
+	struct ath5k_hw *ah = (void *)data;
 	bool blocked;
 
-	blocked = ath5k_is_rfkill_set(sc);
-	wiphy_rfkill_set_hw_state(sc->hw->wiphy, blocked);
+	blocked = ath5k_is_rfkill_set(ah);
+	wiphy_rfkill_set_hw_state(ah->hw->wiphy, blocked);
 }
 
 
 void
 ath5k_rfkill_hw_start(struct ath5k_hw *ah)
 {
-	struct ath5k_softc *sc = ah->ah_sc;
-
 	/* read rfkill GPIO configuration from EEPROM header */
-	sc->rf_kill.gpio = ah->ah_capabilities.cap_eeprom.ee_rfkill_pin;
-	sc->rf_kill.polarity = ah->ah_capabilities.cap_eeprom.ee_rfkill_pol;
+	ah->rf_kill.gpio = ah->ah_capabilities.cap_eeprom.ee_rfkill_pin;
+	ah->rf_kill.polarity = ah->ah_capabilities.cap_eeprom.ee_rfkill_pol;
 
-	tasklet_init(&sc->rf_kill.toggleq, ath5k_tasklet_rfkill_toggle,
-		(unsigned long)sc);
+	tasklet_init(&ah->rf_kill.toggleq, ath5k_tasklet_rfkill_toggle,
+		(unsigned long)ah);
 
-	ath5k_rfkill_disable(sc);
+	ath5k_rfkill_disable(ah);
 
 	/* enable interrupt for rfkill switch */
 	if (AR5K_EEPROM_HDR_RFKILL(ah->ah_capabilities.cap_eeprom.ee_header))
-		ath5k_rfkill_set_intr(sc, true);
+		ath5k_rfkill_set_intr(ah, true);
 }
 
 
 void
 ath5k_rfkill_hw_stop(struct ath5k_hw *ah)
 {
-	struct ath5k_softc *sc = ah->ah_sc;
-
 	/* disable interrupt for rfkill switch */
 	if (AR5K_EEPROM_HDR_RFKILL(ah->ah_capabilities.cap_eeprom.ee_header))
-		ath5k_rfkill_set_intr(sc, false);
+		ath5k_rfkill_set_intr(ah, false);
 
-	tasklet_kill(&sc->rf_kill.toggleq);
+	tasklet_kill(&ah->rf_kill.toggleq);
 
 	/* enable RFKILL when stopping HW so Wifi LED is turned off */
-	ath5k_rfkill_enable(sc);
+	ath5k_rfkill_enable(ah);
 }
 
diff --git a/drivers/net/wireless/ath/ath5k/sysfs.c b/drivers/net/wireless/ath/ath5k/sysfs.c
index d8ad0e4..0244a36 100644
--- a/drivers/net/wireless/ath/ath5k/sysfs.c
+++ b/drivers/net/wireless/ath/ath5k/sysfs.c
@@ -11,7 +11,7 @@ static ssize_t ath5k_attr_show_##name(struct device *dev,		\
 			char *buf)					\
 {									\
 	struct ieee80211_hw *hw = dev_get_drvdata(dev);			\
-	struct ath5k_softc *sc = hw->priv;				\
+	struct ath5k_hw *ah = hw->priv;				\
 	return snprintf(buf, PAGE_SIZE, "%d\n", get);			\
 }									\
 									\
@@ -20,13 +20,13 @@ static ssize_t ath5k_attr_store_##name(struct device *dev,		\
 			const char *buf, size_t count)			\
 {									\
 	struct ieee80211_hw *hw = dev_get_drvdata(dev);			\
-	struct ath5k_softc *sc = hw->priv;				\
+	struct ath5k_hw *ah = hw->priv;				\
 	int val, ret;							\
 									\
 	ret = kstrtoint(buf, 10, &val);					\
 	if (ret < 0)							\
 		return ret;						\
-	set(sc->ah, val);						\
+	set(ah, val);						\
 	return count;							\
 }									\
 static DEVICE_ATTR(name, S_IRUGO | S_IWUSR,				\
@@ -38,25 +38,25 @@ static ssize_t ath5k_attr_show_##name(struct device *dev,		\
 			char *buf)					\
 {									\
 	struct ieee80211_hw *hw = dev_get_drvdata(dev);			\
-	struct ath5k_softc *sc = hw->priv;				\
+	struct ath5k_hw *ah = hw->priv;				\
 	return snprintf(buf, PAGE_SIZE, "%d\n", get);			\
 }									\
 static DEVICE_ATTR(name, S_IRUGO, ath5k_attr_show_##name, NULL)
 
 /*** ANI ***/
 
-SIMPLE_SHOW_STORE(ani_mode, sc->ani_state.ani_mode, ath5k_ani_init);
-SIMPLE_SHOW_STORE(noise_immunity_level, sc->ani_state.noise_imm_level,
+SIMPLE_SHOW_STORE(ani_mode, ah->ani_state.ani_mode, ath5k_ani_init);
+SIMPLE_SHOW_STORE(noise_immunity_level, ah->ani_state.noise_imm_level,
 			ath5k_ani_set_noise_immunity_level);
-SIMPLE_SHOW_STORE(spur_level, sc->ani_state.spur_level,
+SIMPLE_SHOW_STORE(spur_level, ah->ani_state.spur_level,
 			ath5k_ani_set_spur_immunity_level);
-SIMPLE_SHOW_STORE(firstep_level, sc->ani_state.firstep_level,
+SIMPLE_SHOW_STORE(firstep_level, ah->ani_state.firstep_level,
 			ath5k_ani_set_firstep_level);
-SIMPLE_SHOW_STORE(ofdm_weak_signal_detection, sc->ani_state.ofdm_weak_sig,
+SIMPLE_SHOW_STORE(ofdm_weak_signal_detection, ah->ani_state.ofdm_weak_sig,
 			ath5k_ani_set_ofdm_weak_signal_detection);
-SIMPLE_SHOW_STORE(cck_weak_signal_detection, sc->ani_state.cck_weak_sig,
+SIMPLE_SHOW_STORE(cck_weak_signal_detection, ah->ani_state.cck_weak_sig,
 			ath5k_ani_set_cck_weak_signal_detection);
-SIMPLE_SHOW(spur_level_max, sc->ani_state.max_spur_level);
+SIMPLE_SHOW(spur_level_max, ah->ani_state.max_spur_level);
 
 static ssize_t ath5k_attr_show_noise_immunity_level_max(struct device *dev,
 			struct device_attribute *attr,
@@ -98,14 +98,14 @@ static struct attribute_group ath5k_attribute_group_ani = {
 /*** register / unregister ***/
 
 int
-ath5k_sysfs_register(struct ath5k_softc *sc)
+ath5k_sysfs_register(struct ath5k_hw *ah)
 {
-	struct device *dev = sc->dev;
+	struct device *dev = ah->dev;
 	int err;
 
 	err = sysfs_create_group(&dev->kobj, &ath5k_attribute_group_ani);
 	if (err) {
-		ATH5K_ERR(sc, "failed to create sysfs group\n");
+		ATH5K_ERR(ah, "failed to create sysfs group\n");
 		return err;
 	}
 
@@ -113,9 +113,9 @@ ath5k_sysfs_register(struct ath5k_softc *sc)
 }
 
 void
-ath5k_sysfs_unregister(struct ath5k_softc *sc)
+ath5k_sysfs_unregister(struct ath5k_hw *ah)
 {
-	struct device *dev = sc->dev;
+	struct device *dev = ah->dev;
 
 	sysfs_remove_group(&dev->kobj, &ath5k_attribute_group_ani);
 }
diff --git a/drivers/net/wireless/ath/ath5k/trace.h b/drivers/net/wireless/ath/ath5k/trace.h
index 235e076..c741c87 100644
--- a/drivers/net/wireless/ath/ath5k/trace.h
+++ b/drivers/net/wireless/ath/ath5k/trace.h
@@ -16,10 +16,10 @@ struct sk_buff;
 #define TRACE_SYSTEM ath5k
 
 TRACE_EVENT(ath5k_rx,
-	TP_PROTO(struct ath5k_softc *priv, struct sk_buff *skb),
+	TP_PROTO(struct ath5k_hw *priv, struct sk_buff *skb),
 	TP_ARGS(priv, skb),
 	TP_STRUCT__entry(
-		__field(struct ath5k_softc *, priv)
+		__field(struct ath5k_hw *, priv)
 		__field(unsigned long, skbaddr)
 		__dynamic_array(u8, frame, skb->len)
 	),
@@ -34,13 +34,13 @@ TRACE_EVENT(ath5k_rx,
 );
 
 TRACE_EVENT(ath5k_tx,
-	TP_PROTO(struct ath5k_softc *priv, struct sk_buff *skb,
+	TP_PROTO(struct ath5k_hw *priv, struct sk_buff *skb,
 		 struct ath5k_txq *q),
 
 	TP_ARGS(priv, skb, q),
 
 	TP_STRUCT__entry(
-		__field(struct ath5k_softc *, priv)
+		__field(struct ath5k_hw *, priv)
 		__field(unsigned long, skbaddr)
 		__field(u8, qnum)
 		__dynamic_array(u8, frame, skb->len)
@@ -60,13 +60,13 @@ TRACE_EVENT(ath5k_tx,
 );
 
 TRACE_EVENT(ath5k_tx_complete,
-	TP_PROTO(struct ath5k_softc *priv, struct sk_buff *skb,
+	TP_PROTO(struct ath5k_hw *priv, struct sk_buff *skb,
 		 struct ath5k_txq *q, struct ath5k_tx_status *ts),
 
 	TP_ARGS(priv, skb, q, ts),
 
 	TP_STRUCT__entry(
-		__field(struct ath5k_softc *, priv)
+		__field(struct ath5k_hw *, priv)
 		__field(unsigned long, skbaddr)
 		__field(u8, qnum)
 		__field(u8, ts_status)
