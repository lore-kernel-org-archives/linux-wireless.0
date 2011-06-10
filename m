Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:59778 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757988Ab1FJUKL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jun 2011 16:10:11 -0400
Date: Fri, 10 Jun 2011 15:10:10 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: chaoming_li@realsil.com.cn, linux-wireless@vger.kernel.org
Subject: [PATCH 05/13] rtlwifi: rtl8192de: Merge led routines
Message-ID: <4df27a22.HkFFpccMjRasIIpV%Larry.Finger@lwfinger.net> (sfid-20110610_221014_095625_94446B0F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chaoming Li <chaoming_li@realsil.com.cn>

Merge routines led.c and led.h for RTL8192DE.

Signed-off-by: Chaoming_Li <chaoming_li@realsil.com.cn>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192de/led.c
===================================================================
--- /dev/null
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192de/led.c
@@ -0,0 +1,159 @@
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
+static void _rtl92ce_init_led(struct ieee80211_hw *hw,
+			      struct rtl_led *pled, enum rtl_led_pin ledpin)
+{
+	pled->hw = hw;
+	pled->ledpin = ledpin;
+	pled->ledon = false;
+}
+
+void rtl92ce_sw_led_on(struct ieee80211_hw *hw, struct rtl_led *pled)
+{
+	u8 ledcfg;
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+
+	RT_TRACE(rtlpriv, COMP_LED, DBG_LOUD,
+		 ("LedAddr:%X ledpin=%d\n", REG_LEDCFG2, pled->ledpin));
+
+	switch (pled->ledpin) {
+	case LED_PIN_GPIO0:
+		break;
+	case LED_PIN_LED0:
+		ledcfg = rtl_read_byte(rtlpriv, REG_LEDCFG2);
+
+		if ((rtlpriv->efuse.eeprom_did == 0x8176) ||
+			(rtlpriv->efuse.eeprom_did == 0x8193))
+			/* BIT7 of REG_LEDCFG2 should be set to
+			 * make sure we could emit the led2. */
+			rtl_write_byte(rtlpriv, REG_LEDCFG2, (ledcfg & 0xf0) |
+				       BIT(7) | BIT(5) | BIT(6));
+		else
+			rtl_write_byte(rtlpriv, REG_LEDCFG2, (ledcfg & 0xf0) |
+				       BIT(7) | BIT(5));
+		break;
+	case LED_PIN_LED1:
+		ledcfg = rtl_read_byte(rtlpriv, REG_LEDCFG1);
+
+		rtl_write_byte(rtlpriv, REG_LEDCFG2, (ledcfg & 0x0f) | BIT(5));
+		break;
+	default:
+		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
+			 ("switch case not process\n"));
+		break;
+	}
+	pled->ledon = true;
+}
+
+void rtl92ce_sw_led_off(struct ieee80211_hw *hw, struct rtl_led *pled)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
+	u8 ledcfg;
+
+	RT_TRACE(rtlpriv, COMP_LED, DBG_LOUD,
+		 ("LedAddr:%X ledpin=%d\n", REG_LEDCFG2, pled->ledpin));
+
+	ledcfg = rtl_read_byte(rtlpriv, REG_LEDCFG2);
+
+	switch (pled->ledpin) {
+	case LED_PIN_GPIO0:
+		break;
+	case LED_PIN_LED0:
+		ledcfg &= 0xf0;
+		if (pcipriv->ledctl.led_opendrain == true)
+			rtl_write_byte(rtlpriv, REG_LEDCFG2,
+				       (ledcfg | BIT(1) | BIT(5) | BIT(6)));
+		else
+			rtl_write_byte(rtlpriv, REG_LEDCFG2,
+				       (ledcfg | BIT(3) | BIT(5) | BIT(6)));
+		break;
+	case LED_PIN_LED1:
+		ledcfg &= 0x0f;
+		rtl_write_byte(rtlpriv, REG_LEDCFG2, (ledcfg | BIT(3)));
+		break;
+	default:
+		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
+			 ("switch case not process\n"));
+		break;
+	}
+	pled->ledon = false;
+}
+
+void rtl92de_init_sw_leds(struct ieee80211_hw *hw)
+{
+	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
+	_rtl92ce_init_led(hw, &(pcipriv->ledctl.sw_led0), LED_PIN_LED0);
+	_rtl92ce_init_led(hw, &(pcipriv->ledctl.sw_led1), LED_PIN_LED1);
+}
+
+static void _rtl92ce_sw_led_control(struct ieee80211_hw *hw,
+				    enum led_ctl_mode ledaction)
+{
+	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
+	struct rtl_led *pLed0 = &(pcipriv->ledctl.sw_led0);
+	switch (ledaction) {
+	case LED_CTL_POWER_ON:
+	case LED_CTL_LINK:
+	case LED_CTL_NO_LINK:
+		rtl92ce_sw_led_on(hw, pLed0);
+		break;
+	case LED_CTL_POWER_OFF:
+		rtl92ce_sw_led_off(hw, pLed0);
+		break;
+	default:
+		break;
+	}
+}
+
+void rtl92de_led_control(struct ieee80211_hw *hw, enum led_ctl_mode ledaction)
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
+	RT_TRACE(rtlpriv, COMP_LED, DBG_LOUD, ("ledaction %d,\n", ledaction));
+
+	_rtl92ce_sw_led_control(hw, ledaction);
+}
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192de/led.h
===================================================================
--- /dev/null
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192de/led.h
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
+
+#ifndef __RTL92CE_LED_H__
+#define __RTL92CE_LED_H__
+
+void rtl92de_init_sw_leds(struct ieee80211_hw *hw);
+void rtl92ce_sw_led_on(struct ieee80211_hw *hw, struct rtl_led *pled);
+void rtl92ce_sw_led_off(struct ieee80211_hw *hw, struct rtl_led *pled);
+void rtl92de_led_control(struct ieee80211_hw *hw, enum led_ctl_mode ledaction);
+
+#endif
