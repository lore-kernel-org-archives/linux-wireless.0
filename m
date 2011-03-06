Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:51009 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab1CFGgW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2011 01:36:22 -0500
Date: Sun, 06 Mar 2011 00:36:20 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: chaoming_li@realsil.com.cn, linux-wireless@vger.kernel.org
Subject: [RFC/RFT 4/11] rtlwifi: rtl8192se: Merge routines for LED
 handling
Message-ID: <4d732b64.I3wMlgEGyXd88a89%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chaoming Li <chaoming_li@realsil.com.cn>

Merge routines led.c and led.h for RTL8192SE.

Signed-off-by: Chaoming_Li <chaoming_li@realsil.com.cn>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192se/led.c
===================================================================
--- /dev/null
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192se/led.c
@@ -0,0 +1,149 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2009-2010  Realtek Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * The full GNU General Public License is included in this distribution in the
+ * file called LICENSE.
+ *
+ * Contact Information:
+ * wlanfae <wlanfae@realtek.com>
+ * Realtek Corporation, No. 2, Innovation Road II, Hsinchu Science Park,
+ * Hsinchu 300, Taiwan.
+ *
+ * Larry Finger <Larry.Finger@lwfinger.net>
+ *
+ *****************************************************************************/
+
+#include "../wifi.h"
+#include "../pci.h"
+#include "reg.h"
+#include "led.h"
+
+static void _rtl92se_init_led(struct ieee80211_hw *hw,
+			      struct rtl_led *led, enum rtl_led_pin ledpin)
+{
+	led->hw = hw;
+	led->ledpin = ledpin;
+	led->ledon = false;
+}
+
+void rtl92se_init_sw_leds(struct ieee80211_hw *hw)
+{
+	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
+	_rtl92se_init_led(hw, &(pcipriv->ledctl.sw_led0), LED_PIN_LED0);
+	_rtl92se_init_led(hw, &(pcipriv->ledctl.sw_led1), LED_PIN_LED1);
+}
+
+void rtl92se_sw_led_on(struct ieee80211_hw *hw, struct rtl_led *led)
+{
+	u8 ledcfg;
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+
+	RT_TRACE(rtlpriv, COMP_LED, DBG_LOUD,
+		 ("LedAddr:%X ledpin=%d\n", LEDCFG, led->ledpin));
+
+	ledcfg = rtl_read_byte(rtlpriv, LEDCFG);
+
+	switch (led->ledpin) {
+	case LED_PIN_GPIO0:
+		break;
+	case LED_PIN_LED0:
+		rtl_write_byte(rtlpriv, LEDCFG, ledcfg & 0xf0);
+		break;
+	case LED_PIN_LED1:
+		rtl_write_byte(rtlpriv, LEDCFG, ledcfg & 0x0f);
+		break;
+	default:
+		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
+			 ("switch case not process\n"));
+		break;
+	}
+	led->ledon = true;
+}
+
+void rtl92se_sw_led_off(struct ieee80211_hw *hw, struct rtl_led *led)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
+	u8 ledcfg;
+
+	RT_TRACE(rtlpriv, COMP_LED, DBG_LOUD,
+		 ("LedAddr:%X ledpin=%d\n", LEDCFG, led->ledpin));
+
+	ledcfg = rtl_read_byte(rtlpriv, LEDCFG);
+
+	switch (led->ledpin) {
+	case LED_PIN_GPIO0:
+		break;
+	case LED_PIN_LED0:
+		ledcfg &= 0xf0;
+		if (pcipriv->ledctl.led_opendrain == true)
+			rtl_write_byte(rtlpriv, LEDCFG, (ledcfg | BIT(1)));
+		else
+			rtl_write_byte(rtlpriv, LEDCFG, (ledcfg | BIT(3)));
+		break;
+	case LED_PIN_LED1:
+		ledcfg &= 0x0f;
+		rtl_write_byte(rtlpriv, LEDCFG, (ledcfg | BIT(3)));
+		break;
+	default:
+		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
+			 ("switch case not process\n"));
+		break;
+	}
+	led->ledon = false;
+}
+
+static void _rtl92se_sw_led_control(struct ieee80211_hw *hw,
+				    enum led_ctl_mode ledaction)
+{
+	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
+	struct rtl_led *led = &(pcipriv->ledctl.sw_led0);
+	switch (ledaction) {
+	case LED_CTL_POWER_ON:
+	case LED_CTL_LINK:
+	case LED_CTL_NO_LINK:
+		rtl92se_sw_led_on(hw, led);
+		break;
+	case LED_CTL_POWER_OFF:
+		rtl92se_sw_led_off(hw, led);
+		break;
+	default:
+		break;
+	}
+}
+
+void rtl92se_led_control(struct ieee80211_hw *hw, enum led_ctl_mode ledaction)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
+
+	if ((ppsc->rfoff_reason > RF_CHANGE_BY_PS) &&
+	    (ledaction == LED_CTL_TX ||
+	     ledaction == LED_CTL_RX ||
+	     ledaction == LED_CTL_SITE_SURVEY ||
+	     ledaction == LED_CTL_LINK ||
+	     ledaction == LED_CTL_NO_LINK ||
+	     ledaction == LED_CTL_START_TO_LINK ||
+	     ledaction == LED_CTL_POWER_ON)) {
+		return;
+	}
+	RT_TRACE(rtlpriv, COMP_LED, DBG_LOUD, ("ledaction %d,\n",
+				ledaction));
+
+	_rtl92se_sw_led_control(hw, ledaction);
+}
+
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192se/led.h
===================================================================
--- /dev/null
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192se/led.h
@@ -0,0 +1,38 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2009-2010  Realtek Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * The full GNU General Public License is included in this distribution in the
+ * file called LICENSE.
+ *
+ * Contact Information:
+ * wlanfae <wlanfae@realtek.com>
+ * Realtek Corporation, No. 2, Innovation Road II, Hsinchu Science Park,
+ * Hsinchu 300, Taiwan.
+ *
+ * Larry Finger <Larry.Finger@lwfinger.net>
+ *
+ *****************************************************************************/
+#ifndef __REALTEK_PCI92SE_LED_H__
+#define __REALTEK_PCI92SE_LED_H__
+
+void rtl92se_init_sw_leds(struct ieee80211_hw *hw);
+void rtl92se_sw_led_on(struct ieee80211_hw *hw,	struct rtl_led *pled);
+void rtl92se_sw_led_off(struct ieee80211_hw *hw, struct rtl_led *pled);
+void rtl92se_led_control(struct ieee80211_hw *hw, enum led_ctl_mode ledaction);
+
+#endif
+
