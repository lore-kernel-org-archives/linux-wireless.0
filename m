Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:62343 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753982Ab2IKFe7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Sep 2012 01:34:59 -0400
From: Sujith Manoharan <c_manoha@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20558.52552.450844.898561@gargle.gargle.HOWL> (sfid-20120911_073503_803395_573140B2)
Date: Tue, 11 Sep 2012 11:04:00 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath9k: Choose correct LED pin for AR9565
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/gpio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
index 9f83f71..a69d9fa 100644
--- a/drivers/net/wireless/ath/ath9k/gpio.c
+++ b/drivers/net/wireless/ath/ath9k/gpio.c
@@ -51,7 +51,7 @@ void ath_init_leds(struct ath_softc *sc)
 			sc->sc_ah->led_pin = ATH_LED_PIN_9485;
 		else if (AR_SREV_9300(sc->sc_ah))
 			sc->sc_ah->led_pin = ATH_LED_PIN_9300;
-		else if (AR_SREV_9462(sc->sc_ah))
+		else if (AR_SREV_9462(sc->sc_ah) || AR_SREV_9565(sc->sc_ah))
 			sc->sc_ah->led_pin = ATH_LED_PIN_9462;
 		else
 			sc->sc_ah->led_pin = ATH_LED_PIN_DEF;
-- 
1.7.12

