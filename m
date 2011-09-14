Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:18459 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755747Ab1INJjW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Sep 2011 05:39:22 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <rodrigue@qca.qualcomm.com>,
	<senthilb@qca.qualcomm.com>, <rmanohar@qca.qualcomm.com>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [PATCH 1/2] ath9k: enable LED pin for AR946/8x chipsets
Date: Wed, 14 Sep 2011 15:09:13 +0530
Message-ID: <1315993153-14250-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20110914_113931_301234_02D3BF1A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

now the LED starts working for AR946/8x chipsets

Cc: "Balasubramanian, senthilkumar" <senthilb@qca.qualcomm.com>
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    1 +
 drivers/net/wireless/ath/ath9k/gpio.c  |    2 ++
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 5d9a9aa..fe570e0 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -460,6 +460,7 @@ void ath9k_btcoex_timer_pause(struct ath_softc *sc);
 #define ATH_LED_PIN_9287		8
 #define ATH_LED_PIN_9300		10
 #define ATH_LED_PIN_9485		6
+#define ATH_LED_PIN_9480		0
 
 #ifdef CONFIG_MAC80211_LEDS
 void ath_init_leds(struct ath_softc *sc);
diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
index 5113dd8..afbf540 100644
--- a/drivers/net/wireless/ath/ath9k/gpio.c
+++ b/drivers/net/wireless/ath/ath9k/gpio.c
@@ -48,6 +48,8 @@ void ath_init_leds(struct ath_softc *sc)
 			sc->sc_ah->led_pin = ATH_LED_PIN_9485;
 		else if (AR_SREV_9300(sc->sc_ah))
 			sc->sc_ah->led_pin = ATH_LED_PIN_9300;
+		else if (AR_SREV_9480(sc->sc_ah))
+			sc->sc_ah->led_pin = ATH_LED_PIN_9480;
 		else
 			sc->sc_ah->led_pin = ATH_LED_PIN_DEF;
 	}
-- 
1.7.0.4

