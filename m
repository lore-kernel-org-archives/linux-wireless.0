Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:33207 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112Ab1DJXa0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Apr 2011 19:30:26 -0400
Date: Sun, 10 Apr 2011 18:30:23 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: chaoming_li@realsil.com.cn, linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: rtl8192ce: Fix LED initialization
Message-ID: <4da23d8f.C5/W7DWoHsTK1/u/%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chaoming Li <chaoming_li@realsil.com.cn>

Driver rtl8192ce does not initialize the LED correctly.

Signed-off-by: Chaoming Li <chaoming_li@realsil.com.cn>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This patch should probably be in 2.6.39, but I would not force the issue.

Larry
---

Index: wireless-testing/drivers/net/wireless/rtlwifi/base.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/base.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/base.c
@@ -251,14 +251,16 @@ void rtl_init_rfkill(struct ieee80211_hw
 	bool blocked;
 	u8 valid = 0;
 
-	radio_state = rtlpriv->cfg->ops->radio_onoff_checking(hw, &valid);
+	/*set init state to on */
+	rtlpriv->rfkill.rfkill_state = 1;
+	wiphy_rfkill_set_hw_state(hw->wiphy, 0);
 
-	/*set init state to that of switch */
-	rtlpriv->rfkill.rfkill_state = radio_state;
-	printk(KERN_INFO "rtlwifi: wireless switch is %s\n",
-	       rtlpriv->rfkill.rfkill_state ? "on" : "off");
+	radio_state = rtlpriv->cfg->ops->radio_onoff_checking(hw, &valid);
 
 	if (valid) {
+		printk(KERN_INFO "rtlwifi: wireless switch is %s\n",
+				rtlpriv->rfkill.rfkill_state ? "on" : "off");
+
 		rtlpriv->rfkill.rfkill_state = radio_state;
 
 		blocked = (rtlpriv->rfkill.rfkill_state == 1) ? 0 : 1;
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/led.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/led.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/led.c
@@ -32,6 +32,14 @@
 #include "reg.h"
 #include "led.h"
 
+static void _rtl92ce_init_led(struct ieee80211_hw *hw,
+			      struct rtl_led *pled, enum rtl_led_pin ledpin)
+{
+	pled->hw = hw;
+	pled->ledpin = ledpin;
+	pled->ledon = false;
+}
+
 void rtl92ce_sw_led_on(struct ieee80211_hw *hw, struct rtl_led *pled)
 {
 	u8 ledcfg;
@@ -97,10 +105,10 @@ void rtl92ce_sw_led_off(struct ieee80211
 
 void rtl92ce_init_sw_leds(struct ieee80211_hw *hw)
 {
-}
+	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
 
-void rtl92ce_deinit_sw_leds(struct ieee80211_hw *hw)
-{
+	_rtl92ce_init_led(hw, &(pcipriv->ledctl.sw_led0), LED_PIN_LED0);
+	_rtl92ce_init_led(hw, &(pcipriv->ledctl.sw_led1), LED_PIN_LED1);
 }
 
 void _rtl92ce_sw_led_control(struct ieee80211_hw *hw,
Index: wireless-testing/drivers/net/wireless/rtlwifi/pci.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/pci.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/pci.c
@@ -1785,7 +1785,8 @@ void rtl_pci_disconnect(struct pci_dev *
 
 	rtl_pci_deinit(hw);
 	rtl_deinit_core(hw);
-	rtlpriv->cfg->ops->deinit_sw_leds(hw);
+	if (rtlpriv->cfg->ops->deinit_sw_leds)
+		rtlpriv->cfg->ops->deinit_sw_leds(hw);
 	_rtl_pci_io_handler_release(hw);
 	rtlpriv->cfg->ops->deinit_sw_vars(hw);
 
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/led.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/led.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/led.h
@@ -31,7 +31,6 @@
 #define __RTL92CE_LED_H__
 
 void rtl92ce_init_sw_leds(struct ieee80211_hw *hw);
-void rtl92ce_deinit_sw_leds(struct ieee80211_hw *hw);
 void rtl92ce_sw_led_on(struct ieee80211_hw *hw, struct rtl_led *pled);
 void rtl92ce_sw_led_off(struct ieee80211_hw *hw, struct rtl_led *pled);
 void rtl92ce_led_control(struct ieee80211_hw *hw, enum led_ctl_mode ledaction);
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
@@ -131,7 +131,6 @@ static struct rtl_hal_ops rtl8192ce_hal_
 	.enable_hw_sec = rtl92ce_enable_hw_security_config,
 	.set_key = rtl92ce_set_key,
 	.init_sw_leds = rtl92ce_init_sw_leds,
-	.deinit_sw_leds = rtl92ce_deinit_sw_leds,
 	.get_bbreg = rtl92c_phy_query_bb_reg,
 	.set_bbreg = rtl92c_phy_set_bb_reg,
 	.get_rfreg = rtl92ce_phy_query_rf_reg,
