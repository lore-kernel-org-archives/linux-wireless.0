Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:53563 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751611Ab3LLOat (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Dec 2013 09:30:49 -0500
Received: from ultralex.lan ([93.218.116.213]) by mail.gmx.com (mrgmx001) with
 ESMTPSA (Nemesis) id 0M6SJX-1VbnWZ4283-00yQfP for
 <linux-wireless@vger.kernel.org>; Thu, 12 Dec 2013 15:30:46 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH] ath9k_htc: reconfigure led_gpios after resume
Date: Thu, 12 Dec 2013 15:30:36 +0100
Message-Id: <1386858636-11407-1-git-send-email-linux@rempel-privat.de> (sfid-20131212_153052_295394_6976FD98)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On suspend/resume, firmware will restart and gpios
configuration will be reseted. Restore this
configureation at least for LEDs

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/htc.h          |  5 +++++
 drivers/net/wireless/ath/ath9k/htc_drv_gpio.c | 17 ++++++++++++-----
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |  2 ++
 3 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 055d7c2..58da346 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -600,10 +600,15 @@ void ath9k_htc_rfkill_poll_state(struct ieee80211_hw *hw);
 struct base_eep_header *ath9k_htc_get_eeprom_base(struct ath9k_htc_priv *priv);
 
 #ifdef CONFIG_MAC80211_LEDS
+void ath9k_configure_leds(struct ath9k_htc_priv *priv);
 void ath9k_init_leds(struct ath9k_htc_priv *priv);
 void ath9k_deinit_leds(struct ath9k_htc_priv *priv);
 void ath9k_led_work(struct work_struct *work);
 #else
+static inline void ath9k_configure_leds(struct ath9k_htc_priv *priv)
+{
+}
+
 static inline void ath9k_init_leds(struct ath9k_htc_priv *priv)
 {
 }
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c b/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
index 105582d..50f74a2 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
@@ -255,6 +255,17 @@ void ath9k_deinit_leds(struct ath9k_htc_priv *priv)
 	cancel_work_sync(&priv->led_work);
 }
 
+
+void ath9k_configure_leds(struct ath9k_htc_priv *priv)
+{
+	/* Configure gpio 1 for output */
+	ath9k_hw_cfg_output(priv->ah, priv->ah->led_pin,
+			    AR_GPIO_OUTPUT_MUX_AS_OUTPUT);
+	/* LED off, active low */
+	ath9k_hw_set_gpio(priv->ah, priv->ah->led_pin, 1);
+
+}
+
 void ath9k_init_leds(struct ath9k_htc_priv *priv)
 {
 	int ret;
@@ -268,11 +279,7 @@ void ath9k_init_leds(struct ath9k_htc_priv *priv)
 	else
 		priv->ah->led_pin = ATH_LED_PIN_DEF;
 
-	/* Configure gpio 1 for output */
-	ath9k_hw_cfg_output(priv->ah, priv->ah->led_pin,
-			    AR_GPIO_OUTPUT_MUX_AS_OUTPUT);
-	/* LED off, active low */
-	ath9k_hw_set_gpio(priv->ah, priv->ah->led_pin, 1);
+	ath9k_configure_leds(priv);
 
 	snprintf(priv->led_name, sizeof(priv->led_name),
 		"ath9k_htc-%s", wiphy_name(priv->hw->wiphy));
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index c3676bf..b576c44 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -1000,6 +1000,8 @@ int ath9k_htc_resume(struct htc_target *htc_handle)
 
 	ret = ath9k_init_htc_services(priv, priv->ah->hw_version.devid,
 				      priv->ah->hw_version.usbdev);
+	ath9k_configure_leds(priv);
+
 	return ret;
 }
 #endif
-- 
1.8.3.2

