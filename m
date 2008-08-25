Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:39191 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751526AbYHYPWi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Aug 2008 11:22:38 -0400
Date: Mon, 25 Aug 2008 20:47:29 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <jouni.malinen@atheros.com>,
	<luis.rodriguez@atheros.com>
Subject: [PATCH] ath9k: Add LED support
Message-ID: <20080825151729.GA8749@vasanth-lnx.users.atheros.com> (sfid-20080825_172242_299131_82EF9650)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath9k/ath9k.h |   16 ++--
 drivers/net/wireless/ath9k/core.h  |   29 ++++++++
 drivers/net/wireless/ath9k/hw.c    |   33 +--------
 drivers/net/wireless/ath9k/main.c  |  138 +++++++++++++++++++++++++++++++++++-
 drivers/net/wireless/ath9k/reg.h   |    6 --
 5 files changed, 176 insertions(+), 46 deletions(-)

diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath9k/ath9k.h
index 841893b..020b97f 100644
--- a/drivers/net/wireless/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath9k/ath9k.h
@@ -757,14 +757,11 @@ struct ath9k_node_stats {
 
 #define ATH9K_RSSI_EP_MULTIPLIER  (1<<7)
 
-enum ath9k_gpio_output_mux_type {
-	ATH9K_GPIO_OUTPUT_MUX_AS_OUTPUT,
-	ATH9K_GPIO_OUTPUT_MUX_AS_PCIE_ATTENTION_LED,
-	ATH9K_GPIO_OUTPUT_MUX_AS_PCIE_POWER_LED,
-	ATH9K_GPIO_OUTPUT_MUX_AS_MAC_NETWORK_LED,
-	ATH9K_GPIO_OUTPUT_MUX_AS_MAC_POWER_LED,
-	ATH9K_GPIO_OUTPUT_MUX_NUM_ENTRIES
-};
+#define AR_GPIO_OUTPUT_MUX_AS_OUTPUT             0
+#define AR_GPIO_OUTPUT_MUX_AS_PCIE_ATTENTION_LED 1
+#define AR_GPIO_OUTPUT_MUX_AS_PCIE_POWER_LED     2
+#define AR_GPIO_OUTPUT_MUX_AS_MAC_NETWORK_LED    5
+#define AR_GPIO_OUTPUT_MUX_AS_MAC_POWER_LED      6
 
 enum {
 	ATH9K_RESET_POWER_ON,
@@ -1008,4 +1005,7 @@ void ath9k_hw_get_channel_centers(struct ath_hal *ah,
 bool ath9k_get_channel_edges(struct ath_hal *ah,
 			     u16 flags, u16 *low,
 			     u16 *high);
+void ath9k_hw_cfg_output(struct ath_hal *ah, u32 gpio,
+			u32 ah_signal_type);
+void ath9k_hw_set_gpio(struct ath_hal *ah, u32 gpio, u32 value);
 #endif
diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index de1d12f..0692fc3 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -39,6 +39,7 @@
 #include <linux/scatterlist.h>
 #include <asm/page.h>
 #include <net/mac80211.h>
+#include <linux/leds.h>
 
 #include "ath9k.h"
 #include "rc.h"
@@ -803,6 +804,27 @@ void ath_slow_ant_div(struct ath_antdiv *antdiv,
 void ath_setdefantenna(void *sc, u32 antenna);
 
 /********************/
+/*   LED Control    */
+/********************/
+
+#define ATH_LED_PIN	1
+
+enum ath_led_type {
+	ATH_LED_RADIO,
+	ATH_LED_ASSOC,
+	ATH_LED_TX,
+	ATH_LED_RX
+};
+
+struct ath_led {
+	struct ath_softc *sc;
+	struct led_classdev led_cdev;
+	enum ath_led_type led_type;
+	char name[32];
+	bool registered;
+};
+
+/********************/
 /* Main driver core */
 /********************/
 
@@ -884,6 +906,7 @@ struct ath_ht_info {
 #define SC_OP_PREAMBLE_SHORT	BIT(7)
 #define SC_OP_PROTECT_ENABLE	BIT(8)
 #define SC_OP_RXFLUSH		BIT(9)
+#define SC_OP_LED_ASSOCIATED	BIT(10)
 
 struct ath_softc {
 	struct ieee80211_hw *hw;
@@ -988,6 +1011,12 @@ struct ath_softc {
 	spinlock_t sc_txbuflock;
 	spinlock_t sc_resetlock;
 	spinlock_t node_lock;
+
+	/* LEDs */
+	struct ath_led radio_led;
+	struct ath_led assoc_led;
+	struct ath_led tx_led;
+	struct ath_led rx_led;
 };
 
 int ath_init(u16 devid, struct ath_softc *sc);
diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index 41d613b..ff5eedc 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -2800,32 +2800,11 @@ static void ath9k_hw_gpio_cfg_output_mux(struct ath_hal *ah,
 	}
 }
 
-static bool ath9k_hw_cfg_output(struct ath_hal *ah, u32 gpio,
-				enum ath9k_gpio_output_mux_type
-				halSignalType)
+void ath9k_hw_cfg_output(struct ath_hal *ah, u32 gpio,
+			 u32 ah_signal_type)
 {
-	u32 ah_signal_type;
 	u32 gpio_shift;
 
-	static u32 MuxSignalConversionTable[] = {
-
-		AR_GPIO_OUTPUT_MUX_AS_OUTPUT,
-
-		AR_GPIO_OUTPUT_MUX_AS_PCIE_ATTENTION_LED,
-
-		AR_GPIO_OUTPUT_MUX_AS_PCIE_POWER_LED,
-
-		AR_GPIO_OUTPUT_MUX_AS_MAC_NETWORK_LED,
-
-		AR_GPIO_OUTPUT_MUX_AS_MAC_POWER_LED,
-	};
-
-	if ((halSignalType >= 0)
-	    && (halSignalType < ARRAY_SIZE(MuxSignalConversionTable)))
-		ah_signal_type = MuxSignalConversionTable[halSignalType];
-	else
-		return false;
-
 	ath9k_hw_gpio_cfg_output_mux(ah, gpio, ah_signal_type);
 
 	gpio_shift = 2 * gpio;
@@ -2834,16 +2813,12 @@ static bool ath9k_hw_cfg_output(struct ath_hal *ah, u32 gpio,
 		AR_GPIO_OE_OUT,
 		(AR_GPIO_OE_OUT_DRV_ALL << gpio_shift),
 		(AR_GPIO_OE_OUT_DRV << gpio_shift));
-
-	return true;
 }
 
-static bool ath9k_hw_set_gpio(struct ath_hal *ah, u32 gpio,
-			      u32 val)
+void ath9k_hw_set_gpio(struct ath_hal *ah, u32 gpio, u32 val)
 {
 	REG_RMW(ah, AR_GPIO_IN_OUT, ((val & 1) << gpio),
 		AR_GPIO_BIT(gpio));
-	return true;
 }
 
 static u32 ath9k_hw_gpio_get(struct ath_hal *ah, u32 gpio)
@@ -5919,7 +5894,7 @@ bool ath9k_hw_reset(struct ath_hal *ah,
 			else
 				ath9k_hw_set_gpio(ah, 9, 1);
 		}
-		ath9k_hw_cfg_output(ah, 9, ATH9K_GPIO_OUTPUT_MUX_AS_OUTPUT);
+		ath9k_hw_cfg_output(ah, 9, AR_GPIO_OUTPUT_MUX_AS_OUTPUT);
 	}
 
 	ecode = ath9k_hw_process_ini(ah, chan, macmode);
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index dca00c3..996bb9c 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -1172,12 +1172,130 @@ enum ath9k_ht_macmode ath_cwm_macmode(struct ath_softc *sc)
 	return sc->sc_ht_info.tx_chan_width;
 }
 
+/********************************/
+/*	 LED functions		*/
+/********************************/
+
+static void ath_led_brightness(struct led_classdev *led_cdev,
+			       enum led_brightness brightness)
+{
+	struct ath_led *led = container_of(led_cdev, struct ath_led, led_cdev);
+	struct ath_softc *sc = led->sc;
+
+	switch (brightness) {
+	case LED_OFF:
+		if (led->led_type == ATH_LED_ASSOC ||
+		    led->led_type == ATH_LED_RADIO)
+			sc->sc_flags &= ~SC_OP_LED_ASSOCIATED;
+		ath9k_hw_set_gpio(sc->sc_ah, ATH_LED_PIN,
+				(led->led_type == ATH_LED_RADIO) ? 1 :
+				!!(sc->sc_flags & SC_OP_LED_ASSOCIATED));
+		break;
+	case LED_FULL:
+		if (led->led_type == ATH_LED_ASSOC)
+			sc->sc_flags |= SC_OP_LED_ASSOCIATED;
+		ath9k_hw_set_gpio(sc->sc_ah, ATH_LED_PIN, 0);
+		break;
+	default:
+		break;
+	}
+}
+
+static int ath_register_led(struct ath_softc *sc, struct ath_led *led,
+			    char *trigger)
+{
+	int ret;
+
+	led->sc = sc;
+	led->led_cdev.name = led->name;
+	led->led_cdev.default_trigger = trigger;
+	led->led_cdev.brightness_set = ath_led_brightness;
+
+	ret = led_classdev_register(wiphy_dev(sc->hw->wiphy), &led->led_cdev);
+	if (ret)
+		DPRINTF(sc, ATH_DBG_FATAL,
+			"Failed to register led:%s", led->name);
+	else
+		led->registered = 1;
+	return ret;
+}
+
+static void ath_unregister_led(struct ath_led *led)
+{
+	if (led->registered) {
+		led_classdev_unregister(&led->led_cdev);
+		led->registered = 0;
+	}
+}
+
+static void ath_deinit_leds(struct ath_softc *sc)
+{
+	ath_unregister_led(&sc->assoc_led);
+	sc->sc_flags &= ~SC_OP_LED_ASSOCIATED;
+	ath_unregister_led(&sc->tx_led);
+	ath_unregister_led(&sc->rx_led);
+	ath_unregister_led(&sc->radio_led);
+	ath9k_hw_set_gpio(sc->sc_ah, ATH_LED_PIN, 1);
+}
+
+static void ath_init_leds(struct ath_softc *sc)
+{
+	char *trigger;
+	int ret;
+
+	/* Configure gpio 1 for output */
+	ath9k_hw_cfg_output(sc->sc_ah, ATH_LED_PIN,
+			    AR_GPIO_OUTPUT_MUX_AS_OUTPUT);
+	/* LED off, active low */
+	ath9k_hw_set_gpio(sc->sc_ah, ATH_LED_PIN, 1);
+
+	trigger = ieee80211_get_radio_led_name(sc->hw);
+	snprintf(sc->radio_led.name, sizeof(sc->radio_led.name),
+		"ath9k-%s:radio", wiphy_name(sc->hw->wiphy));
+	ret = ath_register_led(sc, &sc->radio_led, trigger);
+	sc->radio_led.led_type = ATH_LED_RADIO;
+	if (ret)
+		goto fail;
+
+	trigger = ieee80211_get_assoc_led_name(sc->hw);
+	snprintf(sc->assoc_led.name, sizeof(sc->assoc_led.name),
+		"ath9k-%s:assoc", wiphy_name(sc->hw->wiphy));
+	ret = ath_register_led(sc, &sc->assoc_led, trigger);
+	sc->assoc_led.led_type = ATH_LED_ASSOC;
+	if (ret)
+		goto fail;
+
+	trigger = ieee80211_get_tx_led_name(sc->hw);
+	snprintf(sc->tx_led.name, sizeof(sc->tx_led.name),
+		"ath9k-%s:tx", wiphy_name(sc->hw->wiphy));
+	ret = ath_register_led(sc, &sc->tx_led, trigger);
+	sc->tx_led.led_type = ATH_LED_TX;
+	if (ret)
+		goto fail;
+
+	trigger = ieee80211_get_rx_led_name(sc->hw);
+	snprintf(sc->rx_led.name, sizeof(sc->rx_led.name),
+		"ath9k-%s:rx", wiphy_name(sc->hw->wiphy));
+	ret = ath_register_led(sc, &sc->rx_led, trigger);
+	sc->rx_led.led_type = ATH_LED_RX;
+	if (ret)
+		goto fail;
+
+	return;
+
+fail:
+	ath_deinit_leds(sc);
+}
+
 static int ath_detach(struct ath_softc *sc)
 {
 	struct ieee80211_hw *hw = sc->hw;
 
 	DPRINTF(sc, ATH_DBG_CONFIG, "%s: Detach ATH hw\n", __func__);
 
+	/* Deinit LED control */
+	ath_deinit_leds(sc);
+
 	/* Unregister hw */
 
 	ieee80211_unregister_hw(hw);
@@ -1271,18 +1389,21 @@ static int ath_attach(u16 devid,
 		goto bad;
 	}
 
+	/* Initialize LED control */
+	ath_init_leds(sc);
+
 	/* initialize tx/rx engine */
 
 	error = ath_tx_init(sc, ATH_TXBUF);
 	if (error != 0)
-		goto bad1;
+		goto detach;
 
 	error = ath_rx_init(sc, ATH_RXBUF);
 	if (error != 0)
-		goto bad1;
+		goto detach;
 
 	return 0;
-bad1:
+detach:
 	ath_detach(sc);
 bad:
 	return error;
@@ -1427,6 +1548,10 @@ static void ath_pci_remove(struct pci_dev *pdev)
 
 static int ath_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 {
+	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
+	struct ath_softc *sc = hw->priv;
+
+	ath9k_hw_set_gpio(sc->sc_ah, ATH_LED_PIN, 1);
 	pci_save_state(pdev);
 	pci_disable_device(pdev);
 	pci_set_power_state(pdev, 3);
@@ -1436,6 +1561,8 @@ static int ath_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 
 static int ath_pci_resume(struct pci_dev *pdev)
 {
+	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
+	struct ath_softc *sc = hw->priv;
 	u32 val;
 	int err;
 
@@ -1452,6 +1579,11 @@ static int ath_pci_resume(struct pci_dev *pdev)
 	if ((val & 0x0000ff00) != 0)
 		pci_write_config_dword(pdev, 0x40, val & 0xffff00ff);
 
+	/* Enable LED */
+	ath9k_hw_cfg_output(sc->sc_ah, ATH_LED_PIN,
+			    AR_GPIO_OUTPUT_MUX_AS_OUTPUT);
+	ath9k_hw_set_gpio(sc->sc_ah, ATH_LED_PIN, 1);
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/ath9k/reg.h b/drivers/net/wireless/ath9k/reg.h
index 42b0890..60617ae 100644
--- a/drivers/net/wireless/ath9k/reg.h
+++ b/drivers/net/wireless/ath9k/reg.h
@@ -899,12 +899,6 @@ enum {
 #define AR_GPIO_OUTPUT_MUX2                      0x4064
 #define AR_GPIO_OUTPUT_MUX3                      0x4068
 
-#define AR_GPIO_OUTPUT_MUX_AS_OUTPUT             0
-#define AR_GPIO_OUTPUT_MUX_AS_PCIE_ATTENTION_LED 1
-#define AR_GPIO_OUTPUT_MUX_AS_PCIE_POWER_LED     2
-#define AR_GPIO_OUTPUT_MUX_AS_MAC_NETWORK_LED    5
-#define AR_GPIO_OUTPUT_MUX_AS_MAC_POWER_LED      6
-
 #define AR_INPUT_STATE                           0x406c
 
 #define AR_EEPROM_STATUS_DATA                    0x407c
-- 
1.5.5.1

