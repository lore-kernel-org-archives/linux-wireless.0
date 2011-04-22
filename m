Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:35959 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751654Ab1DVGCi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Apr 2011 02:02:38 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 21 Apr 2011 23:02:12 -0700
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: [PATCH 1/5] ath9k: Fix LED gpio for AR93xx chipsets.
Date: Fri, 22 Apr 2011 11:32:08 +0530
Message-ID: <1303452132-5436-1-git-send-email-senthilkumar@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The LED gpio is incorrectly programmed for AR9300 and so the led
is not working propelry. AR93xx uses gpio 10 for LED and not the
default.

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    1 +
 drivers/net/wireless/ath/ath9k/gpio.c  |    2 ++
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index a6b5388..5ebfc57 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -453,6 +453,7 @@ void ath9k_btcoex_timer_pause(struct ath_softc *sc);
 
 #define ATH_LED_PIN_DEF 		1
 #define ATH_LED_PIN_9287		8
+#define ATH_LED_PIN_9300		10
 #define ATH_LED_PIN_9485		6
 
 #ifdef CONFIG_MAC80211_LEDS
diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
index 44a0a88..3e617e7 100644
--- a/drivers/net/wireless/ath/ath9k/gpio.c
+++ b/drivers/net/wireless/ath/ath9k/gpio.c
@@ -46,6 +46,8 @@ void ath_init_leds(struct ath_softc *sc)
 			sc->sc_ah->led_pin = ATH_LED_PIN_9287;
 		else if (AR_SREV_9485(sc->sc_ah))
 			sc->sc_ah->led_pin = ATH_LED_PIN_9485;
+		else if (AR_SREV_9300(sc->sc_ah))
+			sc->sc_ah->led_pin = ATH_LED_PIN_9300;
 		else
 			sc->sc_ah->led_pin = ATH_LED_PIN_DEF;
 	}
-- 
1.7.0.4

