Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:41763 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbbAXJSn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Jan 2015 04:18:43 -0500
Received: by mail-pd0-f182.google.com with SMTP id z10so2393376pdj.13
        for <linux-wireless@vger.kernel.org>; Sat, 24 Jan 2015 01:18:42 -0800 (PST)
From: Hong Xu <hong@topbug.net>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Hong Xu <hong@topbug.net>
Subject: [PATCH v3] ath9k_htc: Add a module parameter to disable blink
Date: Sat, 24 Jan 2015 01:18:23 -0800
Message-Id: <1422091103-10579-1-git-send-email-hong@topbug.net> (sfid-20150124_101855_468117_45FC1BFB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add an option "blink" to enable or disable the LED blink. The default
value is set to 1 so that existing users would not experience any
unexpected changes.

Signed-off-by: Hong Xu <hong@topbug.net>
---
 drivers/net/wireless/ath/ath9k/htc.h          | 3 +++
 drivers/net/wireless/ath/ath9k/htc_drv_gpio.c | 4 ++++
 drivers/net/wireless/ath/ath9k/htc_drv_init.c | 4 ++++
 3 files changed, 11 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 9dde265..300d367 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -44,6 +44,9 @@
 
 extern struct ieee80211_ops ath9k_htc_ops;
 extern int htc_modparam_nohwcrypt;
+#ifdef CONFIG_MAC80211_LEDS
+extern int ath9k_htc_led_blink;
+#endif
 
 enum htc_phymode {
 	HTC_MODE_11NA		= 0,
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c b/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
index 50f74a2..2aabcbd 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
@@ -279,6 +279,10 @@ void ath9k_init_leds(struct ath9k_htc_priv *priv)
 	else
 		priv->ah->led_pin = ATH_LED_PIN_DEF;
 
+	if (!ath9k_htc_led_blink)
+		priv->led_cdev.default_trigger =
+			ieee80211_get_radio_led_name(priv->hw);
+
 	ath9k_configure_leds(priv);
 
 	snprintf(priv->led_name, sizeof(priv->led_name),
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index e8fa944..fd22940 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -39,6 +39,10 @@ module_param_named(ps_enable, ath9k_ps_enable, int, 0444);
 MODULE_PARM_DESC(ps_enable, "Enable WLAN PowerSave");
 
 #ifdef CONFIG_MAC80211_LEDS
+int ath9k_htc_led_blink = 1;
+module_param_named(blink, ath9k_htc_led_blink, int, 0444);
+MODULE_PARM_DESC(blink, "Enable LED blink on activity");
+
 static const struct ieee80211_tpt_blink ath9k_htc_tpt_blink[] = {
 	{ .throughput = 0 * 1024, .blink_time = 334 },
 	{ .throughput = 1 * 1024, .blink_time = 260 },
-- 
2.2.2

