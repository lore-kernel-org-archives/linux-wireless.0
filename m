Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:45801 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751632AbZHZPrK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2009 11:47:10 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2009 08:47:13 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Luis.Rodriguez@atheros.com>,
	<Jouni.Malinen@atheros.com>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 4/8] ath9k: Move btcoex related data to a separate struct
Date: Wed, 26 Aug 2009 21:08:46 +0530
Message-ID: <1251301130-10912-5-git-send-email-vasanth@atheros.com>
In-Reply-To: <1251301130-10912-4-git-send-email-vasanth@atheros.com>
References: <1251301130-10912-1-git-send-email-vasanth@atheros.com>
 <1251301130-10912-2-git-send-email-vasanth@atheros.com>
 <1251301130-10912-3-git-send-email-vasanth@atheros.com>
 <1251301130-10912-4-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also define macros for wlanactive and btactive (5 & 6) gpios.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h  |    1 +
 drivers/net/wireless/ath/ath9k/btcoex.c |   16 +++++++++++-----
 drivers/net/wireless/ath/ath9k/btcoex.h |    8 ++++++++
 drivers/net/wireless/ath/ath9k/hw.c     |    4 ++--
 drivers/net/wireless/ath/ath9k/hw.h     |    2 --
 5 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 1a8d679..83f2c8f 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -611,6 +611,7 @@ struct ath_softc {
 	struct ath_bus_ops *bus_ops;
 	struct ath_beacon_config cur_beacon_conf;
 	struct delayed_work tx_complete_work;
+	struct ath_btcoex_info btcoex_info;
 };
 
 struct ath_wiphy {
diff --git a/drivers/net/wireless/ath/ath9k/btcoex.c b/drivers/net/wireless/ath/ath9k/btcoex.c
index abaf92d..9f19cd1 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.c
+++ b/drivers/net/wireless/ath/ath9k/btcoex.c
@@ -18,6 +18,8 @@
 
 void ath9k_hw_btcoex_init(struct ath_hw *ah)
 {
+	struct ath_btcoex_info *btcoex_info = &ah->ah_sc->btcoex_info;
+
 	/* connect bt_active to baseband */
 	REG_CLR_BIT(ah, AR_GPIO_INPUT_EN_VAL,
 			(AR_GPIO_INPUT_EN_VAL_BT_PRIORITY_DEF |
@@ -29,16 +31,18 @@ void ath9k_hw_btcoex_init(struct ath_hw *ah)
 	/* Set input mux for bt_active to gpio pin */
 	REG_RMW_FIELD(ah, AR_GPIO_INPUT_MUX1,
 			AR_GPIO_INPUT_MUX1_BT_ACTIVE,
-			ah->btactive_gpio);
+			btcoex_info->btactive_gpio);
 
 	/* Configure the desired gpio port for input */
-	ath9k_hw_cfg_gpio_input(ah, ah->btactive_gpio);
+	ath9k_hw_cfg_gpio_input(ah, btcoex_info->btactive_gpio);
 }
 
 void ath9k_hw_btcoex_enable(struct ath_hw *ah)
 {
+	struct ath_btcoex_info *btcoex_info = &ah->ah_sc->btcoex_info;
+
 	/* Configure the desired GPIO port for TX_FRAME output */
-	ath9k_hw_cfg_output(ah, ah->wlanactive_gpio,
+	ath9k_hw_cfg_output(ah, btcoex_info->wlanactive_gpio,
 			    AR_GPIO_OUTPUT_MUX_AS_TX_FRAME);
 
 	ah->ah_sc->sc_flags |= SC_OP_BTCOEX_ENABLED;
@@ -46,9 +50,11 @@ void ath9k_hw_btcoex_enable(struct ath_hw *ah)
 
 void ath9k_hw_btcoex_disable(struct ath_hw *ah)
 {
-	ath9k_hw_set_gpio(ah, ah->wlanactive_gpio, 0);
+	struct ath_btcoex_info *btcoex_info = &ah->ah_sc->btcoex_info;
+
+	ath9k_hw_set_gpio(ah, btcoex_info->wlanactive_gpio, 0);
 
-	ath9k_hw_cfg_output(ah, ah->wlanactive_gpio,
+	ath9k_hw_cfg_output(ah, btcoex_info->wlanactive_gpio,
 			AR_GPIO_OUTPUT_MUX_AS_OUTPUT);
 
 	ah->ah_sc->sc_flags &= ~SC_OP_BTCOEX_ENABLED;
diff --git a/drivers/net/wireless/ath/ath9k/btcoex.h b/drivers/net/wireless/ath/ath9k/btcoex.h
index 9954280..c80492b 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.h
+++ b/drivers/net/wireless/ath/ath9k/btcoex.h
@@ -17,6 +17,14 @@
 #ifndef BTCOEX_H
 #define BTCOEX_H
 
+#define ATH_WLANACTIVE_GPIO	5
+#define ATH_BTACTIVE_GPIO	6
+
+struct ath_btcoex_info {
+	u8 wlanactive_gpio;
+	u8 btactive_gpio;
+};
+
 void ath9k_hw_btcoex_init(struct ath_hw *ah);
 void ath9k_hw_btcoex_enable(struct ath_hw *ah);
 void ath9k_hw_btcoex_disable(struct ath_hw *ah);
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index d7e03f9..3bb6abd 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -3666,8 +3666,8 @@ void ath9k_hw_fill_cap_info(struct ath_hw *ah)
 
 	if (AR_SREV_9280_10_OR_LATER(ah) && btcoex_enable) {
 		pCap->hw_caps |= ATH9K_HW_CAP_BT_COEX;
-		ah->btactive_gpio = 6;
-		ah->wlanactive_gpio = 5;
+		ah->ah_sc->btcoex_info.btactive_gpio = ATH_BTACTIVE_GPIO;
+		ah->ah_sc->btcoex_info.wlanactive_gpio = ATH_WLANACTIVE_GPIO;
 	}
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 32f7c4b..259936c 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -414,8 +414,6 @@ struct ath_hw {
 	u16 rfsilent;
 	u32 rfkill_gpio;
 	u32 rfkill_polarity;
-	u32 btactive_gpio;
-	u32 wlanactive_gpio;
 	u32 ah_flags;
 
 	bool htc_reset_init;
-- 
1.5.5.1

