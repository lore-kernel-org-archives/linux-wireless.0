Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:65165 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755616Ab1K2OgZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Nov 2011 09:36:25 -0500
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
CC: Jouni Malinen <jouni@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	Balasubramanian senthilkumar <senthilb@qca.qualcomm.com>,
	Yang Aeolus <aeolus@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	Russell Hu <rhu@qca.qualcomm.com>
Subject: [PATCH] ath9k: Fix LED GPIO pin for AR9462
Date: Tue, 29 Nov 2011 20:06:15 +0530
Message-ID: <1322577375-16213-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20111129_153629_941490_D8ED3DC3)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

GPIO pin 4 is assigned AR9462 chipsets LED.
while GPIO pin 0 worked for obselete AR9462 chipsets though
they are meant for EEPROM as per Russell

Cc: Senthil Balasubramanian <senthilb@qca.qualcomm.com>
Signed-off-by: Russell Hu <rhu@qca.qualcomm.com>
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 93b45b4..386402c 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -462,7 +462,7 @@ void ath9k_btcoex_timer_pause(struct ath_softc *sc);
 #define ATH_LED_PIN_9287		8
 #define ATH_LED_PIN_9300		10
 #define ATH_LED_PIN_9485		6
-#define ATH_LED_PIN_9462		0
+#define ATH_LED_PIN_9462		4
 
 #ifdef CONFIG_MAC80211_LEDS
 void ath_init_leds(struct ath_softc *sc);
-- 
1.7.0.4

