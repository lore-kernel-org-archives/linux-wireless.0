Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40250 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760325AbZFBLNU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2009 07:13:20 -0400
Message-Id: <20090602111112.191915040@sipsolutions.net>
References: <20090602111027.460530075@sipsolutions.net>
Date: Tue, 02 Jun 2009 13:10:29 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Luis Rodriguez <mcgrof@gmail.com>
Subject: [RFT 2/3] ath9k: port to cfg80211 rfkill
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This ports the ath9k rfkill code to the new API offered by
cfg80211 and thus removes a lot of useless stuff.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Luis Rodriguez <mcgrof@gmail.com>
---
 drivers/net/wireless/ath/ath9k/Kconfig |    1 
 drivers/net/wireless/ath/ath9k/ath9k.h |    9 ---
 drivers/net/wireless/ath/ath9k/hw.c    |   29 ++++------
 drivers/net/wireless/ath/ath9k/hw.h    |    3 -
 drivers/net/wireless/ath/ath9k/main.c  |   93 ++++-----------------------------
 5 files changed, 26 insertions(+), 109 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/ath/ath9k/Kconfig	2009-06-02 12:53:43.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath/ath9k/Kconfig	2009-06-02 12:56:10.000000000 +0200
@@ -1,7 +1,6 @@
 config ATH9K
 	tristate "Atheros 802.11n wireless cards support"
 	depends on PCI && MAC80211 && WLAN_80211
-	depends on RFKILL || RFKILL=n
 	select ATH_COMMON
 	select MAC80211_LEDS
 	select LEDS_CLASS
--- wireless-testing.orig/drivers/net/wireless/ath/ath9k/ath9k.h	2009-06-02 12:53:43.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath/ath9k/ath9k.h	2009-06-02 12:56:10.000000000 +0200
@@ -21,7 +21,6 @@
 #include <linux/device.h>
 #include <net/mac80211.h>
 #include <linux/leds.h>
-#include <linux/rfkill.h>
 
 #include "hw.h"
 #include "rc.h"
@@ -464,12 +463,6 @@ struct ath_led {
 	bool registered;
 };
 
-struct ath_rfkill {
-	struct rfkill *rfkill;
-	struct rfkill_ops ops;
-	char rfkill_name[32];
-};
-
 /********************/
 /* Main driver core */
 /********************/
@@ -509,7 +502,6 @@ struct ath_rfkill {
 #define SC_OP_PROTECT_ENABLE    BIT(6)
 #define SC_OP_RXFLUSH           BIT(7)
 #define SC_OP_LED_ASSOCIATED    BIT(8)
-#define SC_OP_RFKILL_REGISTERED BIT(9)
 #define SC_OP_WAIT_FOR_BEACON   BIT(12)
 #define SC_OP_LED_ON            BIT(13)
 #define SC_OP_SCANNING          BIT(14)
@@ -595,7 +587,6 @@ struct ath_softc {
 
 	int beacon_interval;
 
-	struct ath_rfkill rf_kill;
 	struct ath_ani ani;
 	struct ath9k_node_stats nodestats;
 #ifdef CONFIG_ATH9K_DEBUG
--- wireless-testing.orig/drivers/net/wireless/ath/ath9k/hw.c	2009-06-02 12:53:43.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath/ath9k/hw.c	2009-06-02 12:56:10.000000000 +0200
@@ -2186,6 +2186,18 @@ static void ath9k_hw_spur_mitigate(struc
 	REG_WRITE(ah, AR_PHY_MASK2_P_61_45, tmp_mask);
 }
 
+static void ath9k_enable_rfkill(struct ath_hw *ah)
+{
+	REG_SET_BIT(ah, AR_GPIO_INPUT_EN_VAL,
+		    AR_GPIO_INPUT_EN_VAL_RFSILENT_BB);
+
+	REG_CLR_BIT(ah, AR_GPIO_INPUT_MUX2,
+		    AR_GPIO_INPUT_MUX2_RFSILENT);
+
+	ath9k_hw_cfg_gpio_input(ah, ah->rfkill_gpio);
+	REG_SET_BIT(ah, AR_PHY_TEST, RFSILENT_BB);
+}
+
 int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 		    bool bChannelChange)
 {
@@ -2313,10 +2325,9 @@ int ath9k_hw_reset(struct ath_hw *ah, st
 	ath9k_hw_init_interrupt_masks(ah, ah->opmode);
 	ath9k_hw_init_qos(ah);
 
-#if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
 	if (ah->caps.hw_caps & ATH9K_HW_CAP_RFSILENT)
 		ath9k_enable_rfkill(ah);
-#endif
+
 	ath9k_hw_init_user_settings(ah);
 
 	REG_WRITE(ah, AR_STA_ID1,
@@ -3613,20 +3624,6 @@ void ath9k_hw_set_gpio(struct ath_hw *ah
 		AR_GPIO_BIT(gpio));
 }
 
-#if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
-void ath9k_enable_rfkill(struct ath_hw *ah)
-{
-	REG_SET_BIT(ah, AR_GPIO_INPUT_EN_VAL,
-		    AR_GPIO_INPUT_EN_VAL_RFSILENT_BB);
-
-	REG_CLR_BIT(ah, AR_GPIO_INPUT_MUX2,
-		    AR_GPIO_INPUT_MUX2_RFSILENT);
-
-	ath9k_hw_cfg_gpio_input(ah, ah->rfkill_gpio);
-	REG_SET_BIT(ah, AR_PHY_TEST, RFSILENT_BB);
-}
-#endif
-
 u32 ath9k_hw_getdefantenna(struct ath_hw *ah)
 {
 	return REG_READ(ah, AR_DEF_ANTENNA) & 0x7;
--- wireless-testing.orig/drivers/net/wireless/ath/ath9k/hw.h	2009-06-02 12:53:43.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath/ath9k/hw.h	2009-06-02 12:56:10.000000000 +0200
@@ -565,9 +565,6 @@ u32 ath9k_hw_gpio_get(struct ath_hw *ah,
 void ath9k_hw_cfg_output(struct ath_hw *ah, u32 gpio,
 			 u32 ah_signal_type);
 void ath9k_hw_set_gpio(struct ath_hw *ah, u32 gpio, u32 val);
-#if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
-void ath9k_enable_rfkill(struct ath_hw *ah);
-#endif
 u32 ath9k_hw_getdefantenna(struct ath_hw *ah);
 void ath9k_hw_setantenna(struct ath_hw *ah, u32 antenna);
 bool ath9k_hw_setantennaswitch(struct ath_hw *ah,
--- wireless-testing.orig/drivers/net/wireless/ath/ath9k/main.c	2009-06-02 12:53:43.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath/ath9k/main.c	2009-06-02 12:56:10.000000000 +0200
@@ -1178,8 +1178,6 @@ void ath_radio_disable(struct ath_softc 
 	ath9k_ps_restore(sc);
 }
 
-#if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
-
 /*******************/
 /*	Rfkill	   */
 /*******************/
@@ -1192,81 +1190,27 @@ static bool ath_is_rfkill_set(struct ath
 				  ah->rfkill_polarity;
 }
 
-/* s/w rfkill handlers */
-static int ath_rfkill_set_block(void *data, bool blocked)
-{
-	struct ath_softc *sc = data;
-
-	if (blocked)
-		ath_radio_disable(sc);
-	else
-		ath_radio_enable(sc);
-
-	return 0;
-}
-
-static void ath_rfkill_poll_state(struct rfkill *rfkill, void *data)
+static void ath9k_rfkill_poll_state(struct ieee80211_hw *hw)
 {
-	struct ath_softc *sc = data;
+	struct ath_wiphy *aphy = hw->priv;
+	struct ath_softc *sc = aphy->sc;
 	bool blocked = !!ath_is_rfkill_set(sc);
 
-	if (rfkill_set_hw_state(rfkill, blocked))
+	wiphy_rfkill_set_hw_state(hw->wiphy, blocked);
+
+	if (blocked)
 		ath_radio_disable(sc);
 	else
 		ath_radio_enable(sc);
 }
 
-/* Init s/w rfkill */
-static int ath_init_sw_rfkill(struct ath_softc *sc)
+static void ath_start_rfkill_poll(struct ath_softc *sc)
 {
-	sc->rf_kill.ops.set_block = ath_rfkill_set_block;
-	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_RFSILENT)
-		sc->rf_kill.ops.poll = ath_rfkill_poll_state;
-
-	snprintf(sc->rf_kill.rfkill_name, sizeof(sc->rf_kill.rfkill_name),
-		"ath9k-%s::rfkill", wiphy_name(sc->hw->wiphy));
-
-	sc->rf_kill.rfkill = rfkill_alloc(sc->rf_kill.rfkill_name,
-					  wiphy_dev(sc->hw->wiphy),
-					  RFKILL_TYPE_WLAN,
-					  &sc->rf_kill.ops, sc);
-	if (!sc->rf_kill.rfkill) {
-		DPRINTF(sc, ATH_DBG_FATAL, "Failed to allocate rfkill\n");
-		return -ENOMEM;
-	}
-
-	return 0;
-}
-
-/* Deinitialize rfkill */
-static void ath_deinit_rfkill(struct ath_softc *sc)
-{
-	if (sc->sc_flags & SC_OP_RFKILL_REGISTERED) {
-		rfkill_unregister(sc->rf_kill.rfkill);
-		rfkill_destroy(sc->rf_kill.rfkill);
-		sc->sc_flags &= ~SC_OP_RFKILL_REGISTERED;
-	}
-}
-
-static int ath_start_rfkill_poll(struct ath_softc *sc)
-{
-	if (!(sc->sc_flags & SC_OP_RFKILL_REGISTERED)) {
-		if (rfkill_register(sc->rf_kill.rfkill)) {
-			DPRINTF(sc, ATH_DBG_FATAL,
-				"Unable to register rfkill\n");
-			rfkill_destroy(sc->rf_kill.rfkill);
-
-			/* Deinitialize the device */
-			ath_cleanup(sc);
-			return -EIO;
-		} else {
-			sc->sc_flags |= SC_OP_RFKILL_REGISTERED;
-		}
-	}
+	struct ath_hw *ah = sc->sc_ah;
 
-	return 0;
+	if (ah->caps.hw_caps & ATH9K_HW_CAP_RFSILENT)
+		wiphy_rfkill_start_polling(sc->hw->wiphy);
 }
-#endif /* CONFIG_RFKILL */
 
 void ath_cleanup(struct ath_softc *sc)
 {
@@ -1286,9 +1230,6 @@ void ath_detach(struct ath_softc *sc)
 
 	DPRINTF(sc, ATH_DBG_CONFIG, "Detach ATH hw\n");
 
-#if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
-	ath_deinit_rfkill(sc);
-#endif
 	ath_deinit_leds(sc);
 	cancel_work_sync(&sc->chan_work);
 	cancel_delayed_work_sync(&sc->wiphy_work);
@@ -1626,13 +1567,6 @@ int ath_attach(u16 devid, struct ath_sof
 	if (error != 0)
 		goto error_attach;
 
-#if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
-	/* Initialize s/w rfkill */
-	error = ath_init_sw_rfkill(sc);
-	if (error)
-		goto error_attach;
-#endif
-
 	INIT_WORK(&sc->chan_work, ath9k_wiphy_chan_work);
 	INIT_DELAYED_WORK(&sc->wiphy_work, ath9k_wiphy_work);
 	sc->wiphy_scheduler_int = msecs_to_jiffies(500);
@@ -2018,9 +1952,7 @@ static int ath9k_start(struct ieee80211_
 
 	ieee80211_wake_queues(hw);
 
-#if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
-	r = ath_start_rfkill_poll(sc);
-#endif
+	ath_start_rfkill_poll(sc);
 
 mutex_unlock:
 	mutex_unlock(&sc->mutex);
@@ -2159,7 +2091,7 @@ static void ath9k_stop(struct ieee80211_
 	} else
 		sc->rx.rxlink = NULL;
 
-	rfkill_pause_polling(sc->rf_kill.rfkill);
+	wiphy_rfkill_stop_polling(sc->hw->wiphy);
 
 	/* disable HAL and put h/w to sleep */
 	ath9k_hw_disable(sc->sc_ah);
@@ -2765,6 +2697,7 @@ struct ieee80211_ops ath9k_ops = {
 	.ampdu_action       = ath9k_ampdu_action,
 	.sw_scan_start      = ath9k_sw_scan_start,
 	.sw_scan_complete   = ath9k_sw_scan_complete,
+	.rfkill_poll        = ath9k_rfkill_poll_state,
 };
 
 static struct {

-- 

