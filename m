Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:33693 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303Ab0LVBkg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Dec 2010 20:40:36 -0500
Date: Tue, 21 Dec 2010 19:40:40 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: chaoming_li@realsil.com.cn, linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: rtl8192ce: Fix driver problem when radio switch
 off at module load
Message-ID: <4d115718.RbblalG02+GgJdyY%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If the radio enable switch is off when the driver is loaded, it is not
possible to get radio output until the driver is unloaded and reloaded
with the switch on.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
@@ -962,17 +962,6 @@ int rtl92ce_hw_init(struct ieee80211_hw
 	rtl_cam_reset_all_entry(hw);
 	rtl92ce_enable_hw_security_config(hw);
 	ppsc->rfpwr_state = ERFON;
-	tmp_u1b = rtl_read_byte(rtlpriv, REG_MAC_PINMUX_CFG)&(~BIT(3));
-	rtl_write_byte(rtlpriv, REG_MAC_PINMUX_CFG, tmp_u1b);
-	tmp_u1b = rtl_read_byte(rtlpriv, REG_GPIO_IO_SEL);
-	ppsc->rfoff_reason |= (tmp_u1b & BIT(3)) ? 0 : RF_CHANGE_BY_HW;
-	if (ppsc->rfoff_reason > RF_CHANGE_BY_PS)
-		rtl_ps_set_rf_state(hw, ERFOFF, ppsc->rfoff_reason, true);
-	else {
-		ppsc->rfpwr_state = ERFON;
-		ppsc->rfoff_reason = 0;
-		rtlpriv->cfg->ops->led_control(hw, LED_CTL_POWER_ON);
-	}
 	rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_ETHER_ADDR, mac->mac_addr);
 	_rtl92ce_enable_aspm_back_door(hw);
 	rtlpriv->intf_ops->enable_aspm(hw);
Index: wireless-testing/drivers/net/wireless/rtlwifi/base.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/base.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/base.c
@@ -251,16 +251,14 @@ void rtl_init_rfkill(struct ieee80211_hw
 	bool blocked;
 	u8 valid = 0;
 
-	/*set init state to rf on */
-	rtlpriv->rfkill.rfkill_state = 1;
-
 	radio_state = rtlpriv->cfg->ops->radio_onoff_checking(hw, &valid);
 
-	if (valid) {
-		RT_TRACE(rtlpriv, COMP_RF, DBG_DMESG,
-			 (KERN_INFO "wireless switch is %s\n",
-			  rtlpriv->rfkill.rfkill_state ? "on" : "off"));
+	/*set init state to that of switch */
+	rtlpriv->rfkill.rfkill_state = radio_state;
+	printk(KERN_INFO "rtlwifi: wireless switch is %s\n",
+	       rtlpriv->rfkill.rfkill_state ? "on" : "off");
 
+	if (valid) {
 		rtlpriv->rfkill.rfkill_state = radio_state;
 
 		blocked = (rtlpriv->rfkill.rfkill_state == 1) ? 0 : 1;

