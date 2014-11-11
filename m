Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:59667 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbaKKHGH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Nov 2014 02:06:07 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
	Russell Hu <rhu@qca.qualcomm.com>
Subject: [PATCH 5/6] ath9k: Fix LED configuration
Date: Tue, 11 Nov 2014 12:37:23 +0530
Message-Id: <1415689644-29693-6-git-send-email-sujith@msujith.org> (sfid-20141111_080613_864629_B7A1C91B)
In-Reply-To: <1415689644-29693-1-git-send-email-sujith@msujith.org>
References: <1415689644-29693-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

On some x86 platforms, the LED gpio is active high
instead of active low. Identify such cards and modify
the GPIO usage to make sure LED works properly.

Cc: Russell Hu <rhu@qca.qualcomm.com>
Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h | 1 +
 drivers/net/wireless/ath/ath9k/gpio.c  | 9 +++++++--
 drivers/net/wireless/ath/ath9k/hw.h    | 1 +
 drivers/net/wireless/ath/ath9k/init.c  | 3 +++
 drivers/net/wireless/ath/ath9k/main.c  | 6 ++++--
 drivers/net/wireless/ath/ath9k/pci.c   | 4 +++-
 6 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 85d74ff..9e7ba9b 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -931,6 +931,7 @@ void ath_ant_comb_scan(struct ath_softc *sc, struct ath_rx_status *rs);
 #define ATH9K_PCI_AR9565_2ANT     0x0100
 #define ATH9K_PCI_NO_PLL_PWRSAVE  0x0200
 #define ATH9K_PCI_KILLER          0x0400
+#define ATH9K_PCI_LED_ACT_HI      0x0800
 
 /*
  * Default cache line size, in bytes.
diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
index b1956bf..2fef7a4 100644
--- a/drivers/net/wireless/ath/ath9k/gpio.c
+++ b/drivers/net/wireless/ath/ath9k/gpio.c
@@ -25,7 +25,12 @@ static void ath_led_brightness(struct led_classdev *led_cdev,
 			       enum led_brightness brightness)
 {
 	struct ath_softc *sc = container_of(led_cdev, struct ath_softc, led_cdev);
-	ath9k_hw_set_gpio(sc->sc_ah, sc->sc_ah->led_pin, (brightness == LED_OFF));
+	u32 val = (brightness == LED_OFF);
+
+	if (sc->sc_ah->config.led_active_high)
+		val = !val;
+
+	ath9k_hw_set_gpio(sc->sc_ah, sc->sc_ah->led_pin, val);
 }
 
 void ath_deinit_leds(struct ath_softc *sc)
@@ -82,7 +87,7 @@ void ath_fill_led_pin(struct ath_softc *sc)
 	ath9k_hw_cfg_output(ah, ah->led_pin, AR_GPIO_OUTPUT_MUX_AS_OUTPUT);
 
 	/* LED off, active low */
-	ath9k_hw_set_gpio(ah, ah->led_pin, 1);
+	ath9k_hw_set_gpio(ah, ah->led_pin, (ah->config.led_active_high) ? 0 : 1);
 }
 #endif
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index e49721e8..10ab060 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -329,6 +329,7 @@ struct ath9k_ops_config {
 	bool alt_mingainidx;
 	bool no_pll_pwrsave;
 	bool tx_gain_buffalo;
+	bool led_active_high;
 };
 
 enum ath9k_int {
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index a4d69a0..ccf29b7 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -422,6 +422,9 @@ static void ath9k_init_pcoem_platform(struct ath_softc *sc)
 		ah->config.no_pll_pwrsave = true;
 		ath_info(common, "Disable PLL PowerSave\n");
 	}
+
+	if (sc->driver_data & ATH9K_PCI_LED_ACT_HI)
+		ah->config.led_active_high = true;
 }
 
 static void ath9k_eeprom_request_cb(const struct firmware *eeprom_blob,
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index a91ee92..081e1ca 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -726,7 +726,8 @@ static int ath9k_start(struct ieee80211_hw *hw)
 	if (ah->led_pin >= 0) {
 		ath9k_hw_cfg_output(ah, ah->led_pin,
 				    AR_GPIO_OUTPUT_MUX_AS_OUTPUT);
-		ath9k_hw_set_gpio(ah, ah->led_pin, 0);
+		ath9k_hw_set_gpio(ah, ah->led_pin,
+				  (ah->config.led_active_high) ? 1 : 0);
 	}
 
 	/*
@@ -868,7 +869,8 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 	spin_lock_bh(&sc->sc_pcu_lock);
 
 	if (ah->led_pin >= 0) {
-		ath9k_hw_set_gpio(ah, ah->led_pin, 1);
+		ath9k_hw_set_gpio(ah, ah->led_pin,
+				  (ah->config.led_active_high) ? 0 : 1);
 		ath9k_hw_cfg_gpio_input(ah, ah->led_pin);
 	}
 
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index e3f60d5..f009b5b 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -657,7 +657,9 @@ static const struct pci_device_id ath_pci_id_table[] = {
 			 0x0036,
 			 PCI_VENDOR_ID_DELL,
 			 0x020E),
-	  .driver_data = ATH9K_PCI_AR9565_2ANT | ATH9K_PCI_BT_ANT_DIV },
+	  .driver_data = ATH9K_PCI_AR9565_2ANT |
+			 ATH9K_PCI_BT_ANT_DIV |
+			 ATH9K_PCI_LED_ACT_HI},
 
 	/* PCI-E AR9565 (WB335) */
 	{ PCI_VDEVICE(ATHEROS, 0x0036),
-- 
2.1.3

