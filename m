Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:45036 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754132AbZFMJ0r (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Jun 2009 05:26:47 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sat, 13 Jun 2009 02:26:50 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Luis.Rodriguez@atheros.com>,
	<Jouni.Malinen@atheros.com>, <ath9k-devel@lists.ath9k.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Luis Rodriguez <mcgrof@gmail.com>
Subject: [PATCH 3/3] ath9k: port to cfg80211 rfkill
Date: Sat, 13 Jun 2009 14:50:26 +0530
Message-ID: <1244884826-3009-4-git-send-email-vasanth@atheros.com>
In-Reply-To: <1244884826-3009-3-git-send-email-vasanth@atheros.com>
References: <1244884826-3009-1-git-send-email-vasanth@atheros.com>
 <1244884826-3009-2-git-send-email-vasanth@atheros.com>
 <1244884826-3009-3-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>

This ports the ath9k rfkill code to the new API offered by
cfg80211 and thus removes a lot of useless stuff.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Luis Rodriguez <mcgrof@gmail.com>
Tested-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/Kconfig |    1 -
 drivers/net/wireless/ath/ath9k/ath9k.h |    9 ---
 drivers/net/wireless/ath/ath9k/hw.c    |   29 +++++------
 drivers/net/wireless/ath/ath9k/hw.h    |    3 -
 drivers/net/wireless/ath/ath9k/main.c  |   93 +++++---------------------------
 5 files changed, 26 insertions(+), 109 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/Kconfig b/drivers/net/wireless/ath/ath9k/Kconfig
index 0ed1ac3..2d79610 100644
--- a/drivers/net/wireless/ath/ath9k/Kconfig
+++ b/drivers/net/wireless/ath/ath9k/Kconfig
@@ -1,7 +1,6 @@
 config ATH9K
 	tristate "Atheros 802.11n wireless cards support"
 	depends on PCI && MAC80211 && WLAN_80211
-	depends on RFKILL || RFKILL=n
 	select ATH_COMMON
 	select MAC80211_LEDS
 	select LEDS_CLASS
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 9d01806..5a167e1 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -21,7 +21,6 @@
 #include <linux/device.h>
 #include <net/mac80211.h>
 #include <linux/leds.h>
-#include <linux/rfkill.h>
 
 #include "hw.h"
 #include "rc.h"
@@ -480,12 +479,6 @@ struct ath_led {
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
@@ -525,7 +518,6 @@ struct ath_rfkill {
 #define SC_OP_PROTECT_ENABLE    BIT(6)
 #define SC_OP_RXFLUSH           BIT(7)
 #define SC_OP_LED_ASSOCIATED    BIT(8)
-#define SC_OP_RFKILL_REGISTERED BIT(9)
 #define SC_OP_WAIT_FOR_BEACON   BIT(12)
 #define SC_OP_LED_ON            BIT(13)
 #define SC_OP_SCANNING          BIT(14)
@@ -612,7 +604,6 @@ struct ath_softc {
 
 	int beacon_interval;
 
-	struct ath_rfkill rf_kill;
 	struct ath_ani ani;
 	struct ath9k_node_stats nodestats;
 #ifdef CONFIG_ATH9K_DEBUG
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index de2c000..9b64720 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2186,6 +2186,18 @@ static void ath9k_hw_spur_mitigate(struct ath_hw *ah, struct ath9k_channel *chan
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
@@ -2313,10 +2325,9 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	ath9k_hw_init_interrupt_masks(ah, ah->opmode);
 	ath9k_hw_init_qos(ah);
 
-#if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
 	if (ah->caps.hw_caps & ATH9K_HW_CAP_RFSILENT)
 		ath9k_enable_rfkill(ah);
-#endif
+
 	ath9k_hw_init_user_settings(ah);
 
 	REG_WRITE(ah, AR_STA_ID1,
@@ -3612,20 +3623,6 @@ void ath9k_hw_set_gpio(struct ath_hw *ah, u32 gpio, u32 val)
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
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 08eb5ae..9a4570d 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -564,9 +564,6 @@ u32 ath9k_hw_gpio_get(struct ath_hw *ah, u32 gpio);
 void ath9k_hw_cfg_output(struct ath_hw *ah, u32 gpio,
 			 u32 ah_signal_type);
 void ath9k_hw_set_gpio(struct ath_hw *ah, u32 gpio, u32 val);
-#if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
-void ath9k_enable_rfkill(struct ath_hw *ah);
-#endif
 u32 ath9k_hw_getdefantenna(struct ath_hw *ah);
 void ath9k_hw_setantenna(struct ath_hw *ah, u32 antenna);
 bool ath9k_hw_setantennaswitch(struct ath_hw *ah,
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 48b117d..1e0152a 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1199,8 +1199,6 @@ void ath_radio_disable(struct ath_softc *sc)
 	ath9k_ps_restore(sc);
 }
 
-#if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
-
 /*******************/
 /*	Rfkill	   */
 /*******************/
@@ -1213,81 +1211,27 @@ static bool ath_is_rfkill_set(struct ath_softc *sc)
 				  ah->rfkill_polarity;
 }
 
-/* s/w rfkill handlers */
-static int ath_rfkill_set_block(void *data, bool blocked)
+static void ath9k_rfkill_poll_state(struct ieee80211_hw *hw)
 {
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
-{
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
-{
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
+static void ath_start_rfkill_poll(struct ath_softc *sc)
 {
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
@@ -1307,9 +1251,6 @@ void ath_detach(struct ath_softc *sc)
 
 	DPRINTF(sc, ATH_DBG_CONFIG, "Detach ATH hw\n");
 
-#if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
-	ath_deinit_rfkill(sc);
-#endif
 	ath_deinit_leds(sc);
 	cancel_work_sync(&sc->chan_work);
 	cancel_delayed_work_sync(&sc->wiphy_work);
@@ -1650,13 +1591,6 @@ int ath_attach(u16 devid, struct ath_softc *sc)
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
@@ -1672,6 +1606,7 @@ int ath_attach(u16 devid, struct ath_softc *sc)
 	/* Initialize LED control */
 	ath_init_leds(sc);
 
+	ath_start_rfkill_poll(sc);
 
 	return 0;
 
@@ -2040,9 +1975,6 @@ static int ath9k_start(struct ieee80211_hw *hw)
 
 	ieee80211_wake_queues(hw);
 
-#if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
-	r = ath_start_rfkill_poll(sc);
-#endif
 	queue_delayed_work(sc->hw->workqueue, &sc->tx_complete_work, 0);
 
 mutex_unlock:
@@ -2182,7 +2114,7 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 	} else
 		sc->rx.rxlink = NULL;
 
-	rfkill_pause_polling(sc->rf_kill.rfkill);
+	wiphy_rfkill_stop_polling(sc->hw->wiphy);
 
 	/* disable HAL and put h/w to sleep */
 	ath9k_hw_disable(sc->sc_ah);
@@ -2790,6 +2722,7 @@ struct ieee80211_ops ath9k_ops = {
 	.ampdu_action       = ath9k_ampdu_action,
 	.sw_scan_start      = ath9k_sw_scan_start,
 	.sw_scan_complete   = ath9k_sw_scan_complete,
+	.rfkill_poll        = ath9k_rfkill_poll_state,
 };
 
 static struct {
-- 
1.5.5.1

