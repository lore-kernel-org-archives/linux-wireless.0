Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:14103 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337Ab1DYQIQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Apr 2011 12:08:16 -0400
Received: from mail.atheros.com ([10.234.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 25 Apr 2011 09:07:49 -0700
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	<compat@orbit-lab.org>
Subject: [PATCH v2 1/5] ath9k: Fix LED gpio for AR93xx chipsets.
Date: Mon, 25 Apr 2011 21:37:49 +0530
Message-ID: <1303747669-2163-1-git-send-email-senthilkumar@atheros.com> (sfid-20110425_180819_807189_11C0FA9D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The LED gpio is incorrectly programmed for AR9300 and so the led
is not working propelry. AR93xx uses gpio 10 for LED and not the
default.

Cc: compat@orbit-lab.org
Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
---
v2: ccing compat@orbit-lab.org

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

