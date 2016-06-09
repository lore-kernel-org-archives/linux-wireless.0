Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:50678 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693AbcFIVRl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2016 17:17:41 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	kernel-team@lists.ubuntu.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
	ath9k-devel@lists.ath9k.org,
	Vittorio Gambaletta <linuxbugs@vittgam.net>,
	Kalle Valo <kvalo@qca.qualcomm.com>,
	Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 4.2.y-ckt 029/206] ath9k: Add a module parameter to invert LED polarity.
Date: Thu,  9 Jun 2016 14:13:58 -0700
Message-Id: <1465507015-23052-30-git-send-email-kamal@canonical.com> (sfid-20160610_001435_380860_CE7582BE)
In-Reply-To: <1465507015-23052-1-git-send-email-kamal@canonical.com>
References: <1465507015-23052-1-git-send-email-kamal@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

4.2.8-ckt12 -stable review patch.  If anyone has any objections, please let me know.

---8<------------------------------------------------------------

From: "Vittorio Gambaletta (VittGam)" <linux-wireless@vittgam.net>

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/wireless/ath/ath9k/init.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index fc6dc52..6a571d8 100644
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
-- 
2.7.4

