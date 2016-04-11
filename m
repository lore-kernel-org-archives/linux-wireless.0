Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server1.vittgam.net ([213.239.197.142]:14450 "EHLO
	mail.vittgam.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbcDKC4z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Apr 2016 22:56:55 -0400
Date: Mon, 11 Apr 2016 04:48:54 +0200
From: "Vittorio Gambaletta (VittGam)" <linux-wireless@vittgam.net>
To: <kvalo@codeaurora.org>
Cc: <linux-wireless@vger.kernel.org>, <ath9k-devel@qca.qualcomm.com>,
	<ath9k-devel@venema.h4ckr.net>, <stable@vger.kernel.org>
Subject: [PATCH 1/2] ath9k: Add a module parameter to invert LED polarity.
Content-Type: text/plain; charset=UTF-8
Message-ID: <ath9k-patch-20160411-1@vittgam.net> (sfid-20160411_045657_680447_43A9E30F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The LED can be active high instead of active low on some hardware.

Add the led_active_high module parameter. It defaults to -1 to obey
platform data as before.

Setting the parameter to 1 or 0 will force the LED respectively
active high or active low.

Cc: <linux-wireless@vger.kernel.org>
Cc: <ath9k-devel@qca.qualcomm.com>
Cc: <ath9k-devel@lists.ath9k.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Vittorio Gambaletta <linuxbugs@vittgam.net>
---

--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -49,6 +49,10 @@ int ath9k_led_blink;
 module_param_named(blink, ath9k_led_blink, int, 0444);
 MODULE_PARM_DESC(blink, "Enable LED blink on activity");
 
+static int ath9k_led_active_high = -1;
+module_param_named(led_active_high, ath9k_led_active_high, int, 0444);
+MODULE_PARM_DESC(led_active_high, "Invert LED polarity");
+
 static int ath9k_btcoex_enable;
 module_param_named(btcoex_enable, ath9k_btcoex_enable, int, 0444);
 MODULE_PARM_DESC(btcoex_enable, "Enable wifi-BT coexistence");
@@ -600,6 +604,9 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 	if (ret)
 		return ret;
 
+	if (ath9k_led_active_high != -1)
+		ah->config.led_active_high = ath9k_led_active_high == 1;
+
 	/*
 	 * Enable WLAN/BT RX Antenna diversity only when:
 	 *

