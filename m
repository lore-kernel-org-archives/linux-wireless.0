Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42880 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274AbcFEVmj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Jun 2016 17:42:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org, linux-wireless@vger.kernel.org,
	ath9k-devel@qca.qualcomm.com, ath9k-devel@lists.ath9k.org,
	Vittorio Gambaletta <linuxbugs@vittgam.net>,
	Kalle Valo <kvalo@qca.qualcomm.com>
Subject: [PATCH 4.4 31/99] ath9k: Add a module parameter to invert LED polarity.
Date: Sun,  5 Jun 2016 14:41:04 -0700
Message-Id: <20160605213906.087797175@linuxfoundation.org> (sfid-20160606_005710_161931_0CD070B2)
In-Reply-To: <20160605213902.974592018@linuxfoundation.org>
References: <20160605213902.974592018@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

4.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vittorio Gambaletta (VittGam) <linux-wireless@vittgam.net>

commit cd84042ce9040ad038e958bc67a46fcfc015c736 upstream.

The LED can be active high instead of active low on some hardware.

Add the led_active_high module parameter. It defaults to -1 to obey
platform data as before.

Setting the parameter to 1 or 0 will force the LED respectively
active high or active low.

Cc: <linux-wireless@vger.kernel.org>
Cc: <ath9k-devel@qca.qualcomm.com>
Cc: <ath9k-devel@lists.ath9k.org>
Signed-off-by: Vittorio Gambaletta <linuxbugs@vittgam.net>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath9k/init.c |    7 +++++++
 1 file changed, 7 insertions(+)

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
@@ -600,6 +604,9 @@ static int ath9k_init_softc(u16 devid, s
 	if (ret)
 		return ret;
 
+	if (ath9k_led_active_high != -1)
+		ah->config.led_active_high = ath9k_led_active_high == 1;
+
 	/*
 	 * Enable WLAN/BT RX Antenna diversity only when:
 	 *


