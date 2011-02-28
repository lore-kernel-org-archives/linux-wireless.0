Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:62119 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753005Ab1B1Jqy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Feb 2011 04:46:54 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 28 Feb 2011 01:46:32 -0800
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: [PATCH] ath9k: Fix incorrect GPIO LED pin for AR9485
Date: Mon, 28 Feb 2011 15:16:47 +0530
Message-ID: <1298886407-8034-1-git-send-email-senthilkumar@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

AR9485 doesn't use the default GPIO pin for LED and GPIO 6 is actually
used for this.

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    1 +
 drivers/net/wireless/ath/ath9k/gpio.c  |    2 ++
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 367b514..c718ab5 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -449,6 +449,7 @@ void ath9k_btcoex_timer_pause(struct ath_softc *sc);
 
 #define ATH_LED_PIN_DEF 		1
 #define ATH_LED_PIN_9287		8
+#define ATH_LED_PIN_9485		6
 
 #ifdef CONFIG_MAC80211_LEDS
 void ath_init_leds(struct ath_softc *sc);
diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
index e369bf7..0fb8f8a 100644
--- a/drivers/net/wireless/ath/ath9k/gpio.c
+++ b/drivers/net/wireless/ath/ath9k/gpio.c
@@ -43,6 +43,8 @@ void ath_init_leds(struct ath_softc *sc)
 
 	if (AR_SREV_9287(sc->sc_ah))
 		sc->sc_ah->led_pin = ATH_LED_PIN_9287;
+	else if (AR_SREV_9485(sc->sc_ah))
+		sc->sc_ah->led_pin = ATH_LED_PIN_9485;
 	else
 		sc->sc_ah->led_pin = ATH_LED_PIN_DEF;
 
-- 
1.7.3.4

