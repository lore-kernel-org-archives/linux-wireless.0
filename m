Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f196.google.com ([209.85.222.196]:39594 "EHLO
	mail-pz0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755898AbZHNGA5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2009 02:00:57 -0400
Received: by pzk34 with SMTP id 34so908656pzk.4
        for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2009 23:00:59 -0700 (PDT)
Date: Fri, 14 Aug 2009 11:30:52 +0530
From: Vivek Natarajan <vivek.natraj@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3/5] ath9k: Enable LEDs for AR9287 chipsets.
Message-ID: <20090814060052.GC3541@myhost.users.atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    3 ++-
 drivers/net/wireless/ath/ath9k/hw.h    |    1 +
 drivers/net/wireless/ath/ath9k/main.c  |   27 ++++++++++++++++-----------
 drivers/net/wireless/ath/ath9k/pci.c   |    6 +++---
 4 files changed, 22 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 7a5a157..ee2ba96 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -453,7 +453,8 @@ struct ath_ani {
 /*   LED Control    */
 /********************/
 
-#define ATH_LED_PIN	1
+#define ATH_LED_PIN_DEF 		1
+#define ATH_LED_PIN_9287		8
 #define ATH_LED_ON_DURATION_IDLE	350	/* in msecs */
 #define ATH_LED_OFF_DURATION_IDLE	250	/* in msecs */
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 0336981..de31a15 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -522,6 +522,7 @@ struct ath_hw {
 	u32 originalGain[22];
 	int initPDADC;
 	int PDADCdelta;
+	u8 led_pin;
 
 	struct ar5416IniArray iniModes;
 	struct ar5416IniArray iniCommon;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index f452c20..f0e2d41 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -968,9 +968,9 @@ static void ath_led_blink_work(struct work_struct *work)
 
 	if ((sc->led_on_duration == ATH_LED_ON_DURATION_IDLE) ||
 	    (sc->led_off_duration == ATH_LED_OFF_DURATION_IDLE))
-		ath9k_hw_set_gpio(sc->sc_ah, ATH_LED_PIN, 0);
+		ath9k_hw_set_gpio(sc->sc_ah, sc->sc_ah->led_pin, 0);
 	else
-		ath9k_hw_set_gpio(sc->sc_ah, ATH_LED_PIN,
+		ath9k_hw_set_gpio(sc->sc_ah, sc->sc_ah->led_pin,
 				  (sc->sc_flags & SC_OP_LED_ON) ? 1 : 0);
 
 	ieee80211_queue_delayed_work(sc->hw,
@@ -1002,7 +1002,7 @@ static void ath_led_brightness(struct led_classdev *led_cdev,
 	case LED_OFF:
 		if (led->led_type == ATH_LED_ASSOC ||
 		    led->led_type == ATH_LED_RADIO) {
-			ath9k_hw_set_gpio(sc->sc_ah, ATH_LED_PIN,
+			ath9k_hw_set_gpio(sc->sc_ah, sc->sc_ah->led_pin,
 				(led->led_type == ATH_LED_RADIO));
 			sc->sc_flags &= ~SC_OP_LED_ASSOCIATED;
 			if (led->led_type == ATH_LED_RADIO)
@@ -1017,7 +1017,7 @@ static void ath_led_brightness(struct led_classdev *led_cdev,
 			ieee80211_queue_delayed_work(sc->hw,
 						     &sc->ath_led_blink_work, 0);
 		} else if (led->led_type == ATH_LED_RADIO) {
-			ath9k_hw_set_gpio(sc->sc_ah, ATH_LED_PIN, 0);
+			ath9k_hw_set_gpio(sc->sc_ah, sc->sc_ah->led_pin, 0);
 			sc->sc_flags |= SC_OP_LED_ON;
 		} else {
 			sc->led_on_cnt++;
@@ -1062,7 +1062,7 @@ static void ath_deinit_leds(struct ath_softc *sc)
 	ath_unregister_led(&sc->tx_led);
 	ath_unregister_led(&sc->rx_led);
 	ath_unregister_led(&sc->radio_led);
-	ath9k_hw_set_gpio(sc->sc_ah, ATH_LED_PIN, 1);
+	ath9k_hw_set_gpio(sc->sc_ah, sc->sc_ah->led_pin, 1);
 }
 
 static void ath_init_leds(struct ath_softc *sc)
@@ -1070,11 +1070,16 @@ static void ath_init_leds(struct ath_softc *sc)
 	char *trigger;
 	int ret;
 
+	if (AR_SREV_9287(sc->sc_ah))
+		sc->sc_ah->led_pin = ATH_LED_PIN_9287;
+	else
+		sc->sc_ah->led_pin = ATH_LED_PIN_DEF;
+
 	/* Configure gpio 1 for output */
-	ath9k_hw_cfg_output(sc->sc_ah, ATH_LED_PIN,
+	ath9k_hw_cfg_output(sc->sc_ah, sc->sc_ah->led_pin,
 			    AR_GPIO_OUTPUT_MUX_AS_OUTPUT);
 	/* LED off, active low */
-	ath9k_hw_set_gpio(sc->sc_ah, ATH_LED_PIN, 1);
+	ath9k_hw_set_gpio(sc->sc_ah, sc->sc_ah->led_pin, 1);
 
 	INIT_DELAYED_WORK(&sc->ath_led_blink_work, ath_led_blink_work);
 
@@ -1153,9 +1158,9 @@ void ath_radio_enable(struct ath_softc *sc)
 	ath9k_hw_set_interrupts(ah, sc->imask);
 
 	/* Enable LED */
-	ath9k_hw_cfg_output(ah, ATH_LED_PIN,
+	ath9k_hw_cfg_output(ah, ah->led_pin,
 			    AR_GPIO_OUTPUT_MUX_AS_OUTPUT);
-	ath9k_hw_set_gpio(ah, ATH_LED_PIN, 0);
+	ath9k_hw_set_gpio(ah, ah->led_pin, 0);
 
 	ieee80211_wake_queues(sc->hw);
 	ath9k_ps_restore(sc);
@@ -1171,8 +1176,8 @@ void ath_radio_disable(struct ath_softc *sc)
 	ieee80211_stop_queues(sc->hw);
 
 	/* Disable LED */
-	ath9k_hw_set_gpio(ah, ATH_LED_PIN, 1);
-	ath9k_hw_cfg_gpio_input(ah, ATH_LED_PIN);
+	ath9k_hw_set_gpio(ah, ah->led_pin, 1);
+	ath9k_hw_cfg_gpio_input(ah, ah->led_pin);
 
 	/* Disable interrupts */
 	ath9k_hw_set_interrupts(ah, 0);
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index 616bdff..685a8ce 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -236,7 +236,7 @@ static int ath_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 	struct ath_wiphy *aphy = hw->priv;
 	struct ath_softc *sc = aphy->sc;
 
-	ath9k_hw_set_gpio(sc->sc_ah, ATH_LED_PIN, 1);
+	ath9k_hw_set_gpio(sc->sc_ah, sc->sc_ah->led_pin, 1);
 
 	pci_save_state(pdev);
 	pci_disable_device(pdev);
@@ -269,9 +269,9 @@ static int ath_pci_resume(struct pci_dev *pdev)
 		pci_write_config_dword(pdev, 0x40, val & 0xffff00ff);
 
 	/* Enable LED */
-	ath9k_hw_cfg_output(sc->sc_ah, ATH_LED_PIN,
+	ath9k_hw_cfg_output(sc->sc_ah, sc->sc_ah->led_pin,
 			    AR_GPIO_OUTPUT_MUX_AS_OUTPUT);
-	ath9k_hw_set_gpio(sc->sc_ah, ATH_LED_PIN, 1);
+	ath9k_hw_set_gpio(sc->sc_ah, sc->sc_ah->led_pin, 1);
 
 	return 0;
 }
-- 
1.6.0.1

