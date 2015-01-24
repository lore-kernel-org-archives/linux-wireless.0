Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:55317 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbbAXK3q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Jan 2015 05:29:46 -0500
Received: by mail-pa0-f41.google.com with SMTP id kq14so2226192pab.0
        for <linux-wireless@vger.kernel.org>; Sat, 24 Jan 2015 02:29:46 -0800 (PST)
From: Hong Xu <hong@topbug.net>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org, kvalo@codeaurora.org,
	Hong Xu <hong@topbug.net>
Subject: [PATCH v2] ath9k and ath9k_htc: rename variable "led_blink"
Date: Sat, 24 Jan 2015 02:29:37 -0800
Message-Id: <1422095377-14170-1-git-send-email-hong@topbug.net> (sfid-20150124_112952_382437_3558F39E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath9k and ath9k_htc use the variable name "led_blink" to indicate
whether the module parameter "blink" is on. This name is easy to
conflict with other variables, and has caused a compiler error found
by kbuild. The compiler error is as following:

drivers/net/wireless/ath/ath9k/ath9k_htc.o:(.data+0x47c): multiple definition of `led_blink'
drivers/net/wireless/ath/ath9k/ath9k.o:(.bss+0x20): first defined here

Signed-off-by: Hong Xu <hong@topbug.net>
---
 drivers/net/wireless/ath/ath9k/ath9k.h        | 2 +-
 drivers/net/wireless/ath/ath9k/gpio.c         | 2 +-
 drivers/net/wireless/ath/ath9k/htc.h          | 2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_gpio.c | 2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c | 4 ++--
 drivers/net/wireless/ath/ath9k/init.c         | 4 ++--
 6 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 1a9fe09..e84b576 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -34,7 +34,7 @@ struct ath_vif;
 
 extern struct ieee80211_ops ath9k_ops;
 extern int ath9k_modparam_nohwcrypt;
-extern int led_blink;
+extern int ath9k_led_blink;
 extern bool is_ath9k_unloaded;
 extern int ath9k_use_chanctx;
 
diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
index 2fef7a4..da344b2 100644
--- a/drivers/net/wireless/ath/ath9k/gpio.c
+++ b/drivers/net/wireless/ath/ath9k/gpio.c
@@ -49,7 +49,7 @@ void ath_init_leds(struct ath_softc *sc)
 	if (AR_SREV_9100(sc->sc_ah))
 		return;
 
-	if (!led_blink)
+	if (!ath9k_led_blink)
 		sc->led_cdev.default_trigger =
 			ieee80211_get_radio_led_name(sc->hw);
 
diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index c43fec5..300d367 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -45,7 +45,7 @@
 extern struct ieee80211_ops ath9k_htc_ops;
 extern int htc_modparam_nohwcrypt;
 #ifdef CONFIG_MAC80211_LEDS
-extern int led_blink;
+extern int ath9k_htc_led_blink;
 #endif
 
 enum htc_phymode {
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c b/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
index 998b558..2aabcbd 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
@@ -279,7 +279,7 @@ void ath9k_init_leds(struct ath9k_htc_priv *priv)
 	else
 		priv->ah->led_pin = ATH_LED_PIN_DEF;
 
-	if (!led_blink)
+	if (!ath9k_htc_led_blink)
 		priv->led_cdev.default_trigger =
 			ieee80211_get_radio_led_name(priv->hw);
 
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 9470127..fd22940 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -39,8 +39,8 @@ module_param_named(ps_enable, ath9k_ps_enable, int, 0444);
 MODULE_PARM_DESC(ps_enable, "Enable WLAN PowerSave");
 
 #ifdef CONFIG_MAC80211_LEDS
-int led_blink = 1;
-module_param_named(blink, led_blink, int, 0444);
+int ath9k_htc_led_blink = 1;
+module_param_named(blink, ath9k_htc_led_blink, int, 0444);
 MODULE_PARM_DESC(blink, "Enable LED blink on activity");
 
 static const struct ieee80211_tpt_blink ath9k_htc_tpt_blink[] = {
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index d1c3934..2aef14e 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -45,8 +45,8 @@ int ath9k_modparam_nohwcrypt;
 module_param_named(nohwcrypt, ath9k_modparam_nohwcrypt, int, 0444);
 MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption");
 
-int led_blink;
-module_param_named(blink, led_blink, int, 0444);
+int ath9k_led_blink;
+module_param_named(blink, ath9k_led_blink, int, 0444);
 MODULE_PARM_DESC(blink, "Enable LED blink on activity");
 
 static int ath9k_btcoex_enable;
-- 
2.2.2

