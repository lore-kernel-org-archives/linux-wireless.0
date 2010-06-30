Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:10676 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752578Ab0F3JOW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jun 2010 05:14:22 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 30 Jun 2010 02:14:22 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19499.2927.278554.556609@gargle.gargle.HOWL>
Date: Wed, 30 Jun 2010 14:46:31 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath9k_htc: Add LED support for AR7010
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc.h          |    1 +
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |    2 +
 drivers/net/wireless/ath/ath9k/hw.c           |   34 ++++++++++++++++++++++---
 drivers/net/wireless/ath/ath9k/reg.h          |   23 +++++++++++++++++
 4 files changed, 56 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 58f52a1..3756400 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -287,6 +287,7 @@ struct ath9k_debug {
 #define ATH_LED_PIN_DEF             1
 #define ATH_LED_PIN_9287            8
 #define ATH_LED_PIN_9271            15
+#define ATH_LED_PIN_7010            12
 #define ATH_LED_ON_DURATION_IDLE    350	/* in msecs */
 #define ATH_LED_OFF_DURATION_IDLE   250	/* in msecs */
 
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 05445d8..e38ca66 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -931,6 +931,8 @@ void ath9k_init_leds(struct ath9k_htc_priv *priv)
 		priv->ah->led_pin = ATH_LED_PIN_9287;
 	else if (AR_SREV_9271(priv->ah))
 		priv->ah->led_pin = ATH_LED_PIN_9271;
+	else if (AR_DEVID_7010(priv->ah))
+		priv->ah->led_pin = ATH_LED_PIN_7010;
 	else
 		priv->ah->led_pin = ATH_LED_PIN_DEF;
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 1ed1440..3c76ecb 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2176,6 +2176,8 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 
 	if (AR_SREV_9271(ah))
 		pCap->num_gpio_pins = AR9271_NUM_GPIO;
+	else if (AR_DEVID_7010(ah))
+		pCap->num_gpio_pins = AR7010_NUM_GPIO;
 	else if (AR_SREV_9285_10_OR_LATER(ah))
 		pCap->num_gpio_pins = AR9285_NUM_GPIO;
 	else if (AR_SREV_9280_10_OR_LATER(ah))
@@ -2316,8 +2318,15 @@ void ath9k_hw_cfg_gpio_input(struct ath_hw *ah, u32 gpio)
 
 	BUG_ON(gpio >= ah->caps.num_gpio_pins);
 
-	gpio_shift = gpio << 1;
+	if (AR_DEVID_7010(ah)) {
+		gpio_shift = gpio;
+		REG_RMW(ah, AR7010_GPIO_OE,
+			(AR7010_GPIO_OE_AS_INPUT << gpio_shift),
+			(AR7010_GPIO_OE_MASK << gpio_shift));
+		return;
+	}
 
+	gpio_shift = gpio << 1;
 	REG_RMW(ah,
 		AR_GPIO_OE_OUT,
 		(AR_GPIO_OE_OUT_DRV_NO << gpio_shift),
@@ -2333,7 +2342,11 @@ u32 ath9k_hw_gpio_get(struct ath_hw *ah, u32 gpio)
 	if (gpio >= ah->caps.num_gpio_pins)
 		return 0xffffffff;
 
-	if (AR_SREV_9300_20_OR_LATER(ah))
+	if (AR_DEVID_7010(ah)) {
+		u32 val;
+		val = REG_READ(ah, AR7010_GPIO_IN);
+		return (MS(val, AR7010_GPIO_IN_VAL) & AR_GPIO_BIT(gpio)) == 0;
+	} else if (AR_SREV_9300_20_OR_LATER(ah))
 		return MS_REG_READ(AR9300, gpio) != 0;
 	else if (AR_SREV_9271(ah))
 		return MS_REG_READ(AR9271, gpio) != 0;
@@ -2353,10 +2366,16 @@ void ath9k_hw_cfg_output(struct ath_hw *ah, u32 gpio,
 {
 	u32 gpio_shift;
 
-	ath9k_hw_gpio_cfg_output_mux(ah, gpio, ah_signal_type);
+	if (AR_DEVID_7010(ah)) {
+		gpio_shift = gpio;
+		REG_RMW(ah, AR7010_GPIO_OE,
+			(AR7010_GPIO_OE_AS_OUTPUT << gpio_shift),
+			(AR7010_GPIO_OE_MASK << gpio_shift));
+		return;
+	}
 
+	ath9k_hw_gpio_cfg_output_mux(ah, gpio, ah_signal_type);
 	gpio_shift = 2 * gpio;
-
 	REG_RMW(ah,
 		AR_GPIO_OE_OUT,
 		(AR_GPIO_OE_OUT_DRV_ALL << gpio_shift),
@@ -2366,6 +2385,13 @@ EXPORT_SYMBOL(ath9k_hw_cfg_output);
 
 void ath9k_hw_set_gpio(struct ath_hw *ah, u32 gpio, u32 val)
 {
+	if (AR_DEVID_7010(ah)) {
+		val = val ? 0 : 1;
+		REG_RMW(ah, AR7010_GPIO_OUT, ((val&1) << gpio),
+			AR_GPIO_BIT(gpio));
+		return;
+	}
+
 	if (AR_SREV_9271(ah))
 		val = ~val;
 
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index 47be667..633e3d9 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -882,6 +882,7 @@
 #define AR_SREV_9271_11(_ah) \
     (AR_SREV_9271(_ah) && \
      ((_ah)->hw_version.macRev == AR_SREV_REVISION_9271_11))
+
 #define AR_SREV_9300(_ah) \
 	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9300))
 #define AR_SREV_9300_20(_ah) \
@@ -896,6 +897,10 @@
     (AR_SREV_9285_12_OR_LATER(_ah) && \
      ((REG_READ(_ah, AR_AN_SYNTH9) & 0x7) == 0x1))
 
+#define AR_DEVID_7010(_ah) \
+	(((_ah)->hw_version.devid == 0x7010) || \
+	 ((_ah)->hw_version.devid == 0x9018))
+
 #define AR_RADIO_SREV_MAJOR                   0xf0
 #define AR_RAD5133_SREV_MAJOR                 0xc0
 #define AR_RAD2133_SREV_MAJOR                 0xd0
@@ -993,6 +998,7 @@ enum {
 #define AR9287_NUM_GPIO                          11
 #define AR9271_NUM_GPIO                          16
 #define AR9300_NUM_GPIO                          17
+#define AR7010_NUM_GPIO                          16
 
 #define AR_GPIO_IN_OUT                           0x4048
 #define AR_GPIO_IN_VAL                           0x0FFFC000
@@ -1007,6 +1013,8 @@ enum {
 #define AR9271_GPIO_IN_VAL_S                     16
 #define AR9300_GPIO_IN_VAL                       0x0001FFFF
 #define AR9300_GPIO_IN_VAL_S                     0
+#define AR7010_GPIO_IN_VAL                       0x0000FFFF
+#define AR7010_GPIO_IN_VAL_S                     0
 
 #define AR_GPIO_OE_OUT                           (AR_SREV_9300_20_OR_LATER(ah) ? 0x4050 : 0x404c)
 #define AR_GPIO_OE_OUT_DRV                       0x3
@@ -1015,6 +1023,21 @@ enum {
 #define AR_GPIO_OE_OUT_DRV_HI                    0x2
 #define AR_GPIO_OE_OUT_DRV_ALL                   0x3
 
+#define AR7010_GPIO_OE                           0x52000
+#define AR7010_GPIO_OE_MASK                      0x1
+#define AR7010_GPIO_OE_AS_OUTPUT                 0x0
+#define AR7010_GPIO_OE_AS_INPUT                  0x1
+#define AR7010_GPIO_IN                           0x52004
+#define AR7010_GPIO_OUT                          0x52008
+#define AR7010_GPIO_SET                          0x5200C
+#define AR7010_GPIO_CLEAR                        0x52010
+#define AR7010_GPIO_INT                          0x52014
+#define AR7010_GPIO_INT_TYPE                     0x52018
+#define AR7010_GPIO_INT_POLARITY                 0x5201C
+#define AR7010_GPIO_PENDING                      0x52020
+#define AR7010_GPIO_INT_MASK                     0x52024
+#define AR7010_GPIO_FUNCTION                     0x52028
+
 #define AR_GPIO_INTR_POL                         (AR_SREV_9300_20_OR_LATER(ah) ? 0x4058 : 0x4050)
 #define AR_GPIO_INTR_POL_VAL                     0x0001FFFF
 #define AR_GPIO_INTR_POL_VAL_S                   0
-- 
1.7.1

