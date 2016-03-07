Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48497 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154AbcCGCjB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2016 21:39:01 -0500
From: miaoqing@codeaurora.org
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
	kvalo@qca.qualcomm.com, Miaoqing Pan <miaoqing@codeaurora.org>
Subject: [PATCH v4 3/8] ath9k: free GPIO resource for SOC GPIOs
Date: Mon,  7 Mar 2016 10:38:16 +0800
Message-Id: <1457318301-27701-4-git-send-email-miaoqing@codeaurora.org> (sfid-20160307_033924_466131_2C0993C2)
In-Reply-To: <1457318301-27701-1-git-send-email-miaoqing@codeaurora.org>
References: <1457318301-27701-1-git-send-email-miaoqing@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Miaoqing Pan <miaoqing@codeaurora.org>

For SOC GPIOs, should call ath9k_hw_gpio_free() to release
the GPIO resource.

Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>
---
 drivers/net/wireless/ath/ath9k/btcoex.c       | 10 ++++++++++
 drivers/net/wireless/ath/ath9k/btcoex.h       |  1 +
 drivers/net/wireless/ath/ath9k/gpio.c         |  9 +++++++++
 drivers/net/wireless/ath/ath9k/htc_drv_gpio.c |  2 ++
 drivers/net/wireless/ath/ath9k/hw.c           |  1 +
 5 files changed, 23 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/btcoex.c b/drivers/net/wireless/ath/ath9k/btcoex.c
index 7719cb1..4737aa9 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.c
+++ b/drivers/net/wireless/ath/ath9k/btcoex.c
@@ -174,6 +174,16 @@ void ath9k_hw_btcoex_init_3wire(struct ath_hw *ah)
 }
 EXPORT_SYMBOL(ath9k_hw_btcoex_init_3wire);
 
+void ath9k_hw_btcoex_deinit(struct ath_hw *ah)
+{
+	struct ath_btcoex_hw *btcoex_hw = &ah->btcoex_hw;
+
+	ath9k_hw_gpio_free(ah, btcoex_hw->btactive_gpio);
+	ath9k_hw_gpio_free(ah, btcoex_hw->btpriority_gpio);
+	ath9k_hw_gpio_free(ah, btcoex_hw->wlanactive_gpio);
+}
+EXPORT_SYMBOL(ath9k_hw_btcoex_deinit);
+
 void ath9k_hw_btcoex_init_mci(struct ath_hw *ah)
 {
 	ah->btcoex_hw.mci.ready = false;
diff --git a/drivers/net/wireless/ath/ath9k/btcoex.h b/drivers/net/wireless/ath/ath9k/btcoex.h
index cd2f0a2..0f7c4e6 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.h
+++ b/drivers/net/wireless/ath/ath9k/btcoex.h
@@ -123,6 +123,7 @@ struct ath_btcoex_hw {
 void ath9k_hw_btcoex_init_scheme(struct ath_hw *ah);
 void ath9k_hw_btcoex_init_2wire(struct ath_hw *ah);
 void ath9k_hw_btcoex_init_3wire(struct ath_hw *ah);
+void ath9k_hw_btcoex_deinit(struct ath_hw *ah);
 void ath9k_hw_btcoex_init_mci(struct ath_hw *ah);
 void ath9k_hw_init_btcoex_hw(struct ath_hw *ah, int qnum);
 void ath9k_hw_btcoex_set_weight(struct ath_hw *ah,
diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
index b41dfb7..4964bb3 100644
--- a/drivers/net/wireless/ath/ath9k/gpio.c
+++ b/drivers/net/wireless/ath/ath9k/gpio.c
@@ -40,6 +40,8 @@ void ath_deinit_leds(struct ath_softc *sc)
 
 	ath_led_brightness(&sc->led_cdev, LED_OFF);
 	led_classdev_unregister(&sc->led_cdev);
+
+	ath9k_hw_gpio_free(sc->sc_ah, sc->sc_ah->led_pin);
 }
 
 void ath_init_leds(struct ath_softc *sc)
@@ -404,6 +406,13 @@ void ath9k_deinit_btcoex(struct ath_softc *sc)
 
 	if (ath9k_hw_mci_is_enabled(ah))
 		ath_mci_cleanup(sc);
+	else {
+		enum ath_btcoex_scheme scheme = ath9k_hw_get_btcoex_scheme(ah);
+
+		if (scheme == ATH_BTCOEX_CFG_2WIRE ||
+		    scheme == ATH_BTCOEX_CFG_3WIRE)
+			ath9k_hw_btcoex_deinit(sc->sc_ah);
+	}
 }
 
 int ath9k_init_btcoex(struct ath_softc *sc)
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c b/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
index d9b640a..ecb848b 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
@@ -253,6 +253,8 @@ void ath9k_deinit_leds(struct ath9k_htc_priv *priv)
 	ath9k_led_brightness(&priv->led_cdev, LED_OFF);
 	led_classdev_unregister(&priv->led_cdev);
 	cancel_work_sync(&priv->led_work);
+
+	ath9k_hw_gpio_free(priv->ah, priv->ah->led_pin);
 }
 
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 4046949..1fd6155 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1575,6 +1575,7 @@ static void ath9k_hw_apply_gpio_override(struct ath_hw *ah)
 		ath9k_hw_gpio_request_out(ah, i, NULL,
 					  AR_GPIO_OUTPUT_MUX_AS_OUTPUT);
 		ath9k_hw_set_gpio(ah, i, !!(ah->gpio_val & BIT(i)));
+		ath9k_hw_gpio_free(ah, i);
 	}
 }
 
-- 
1.9.1

