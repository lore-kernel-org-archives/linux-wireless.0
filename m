Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:65526 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417Ab1F3VrM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2011 17:47:12 -0400
Date: Thu, 30 Jun 2011 16:47:11 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: chaoming_li@realsil.com.cn, linux-wireless@vger.kernel.org
Subject: [PATCH 3/3] rtlwifi: rtl8192de: Remove comparison of boolean with true
Message-ID: <4e0ceedf.l/ZrELmiMBfs4PD/%Larry.Finger@lwfinger.net> (sfid-20110630_234715_027735_142F5364)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tests of a boolean against "true" are not needed as non-zero is sufficient..

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

3.1 material.

Larry
---

Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
@@ -449,7 +449,7 @@ void rtl92de_set_hw_reg(struct ieee80211
 	case HW_VAR_CORRECT_TSF: {
 		u8 btype_ibss = ((u8 *) (val))[0];
 
-		if (btype_ibss == true)
+		if (btype_ibss)
 			_rtl92de_stop_tx_beacon(hw);
 		_rtl92de_set_bcn_ctrl_reg(hw, 0, BIT(3));
 		rtl_write_dword(rtlpriv, REG_TSFTR,
@@ -457,7 +457,7 @@ void rtl92de_set_hw_reg(struct ieee80211
 		rtl_write_dword(rtlpriv, REG_TSFTR + 4,
 				(u32) ((mac->tsf >> 32) & 0xffffffff));
 		_rtl92de_set_bcn_ctrl_reg(hw, BIT(3), 0);
-		if (btype_ibss == true)
+		if (btype_ibss)
 			_rtl92de_resume_tx_beacon(hw);
 
 		break;
@@ -1142,7 +1142,7 @@ void rtl92de_set_check_bssid(struct ieee
 
 	if (rtlpriv->psc.rfpwr_state != ERFON)
 		return;
-	if (check_bssid == true) {
+	if (check_bssid) {
 		reg_rcr |= (RCR_CBSSID_DATA | RCR_CBSSID_BCN);
 		rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_RCR, (u8 *)(&reg_rcr));
 		_rtl92de_set_bcn_ctrl_reg(hw, 0, BIT(4));
@@ -1785,7 +1785,7 @@ static void _rtl92de_read_adapter_info(s
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD, ("Autoload OK\n"));
 		rtlefuse->autoload_failflag = false;
 	}
-	if (rtlefuse->autoload_failflag == true) {
+	if (rtlefuse->autoload_failflag) {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
 			 ("RTL819X Not boot from eeprom, check it !!"));
 		return;
@@ -2147,7 +2147,7 @@ bool rtl92de_gpio_radio_on_off_checking(
 			  REG_MAC_PINMUX_CFG) & ~(BIT(3)));
 	u1tmp = rtl_read_byte(rtlpriv, REG_GPIO_IO_SEL);
 	e_rfpowerstate_toset = (u1tmp & BIT(3)) ? ERFON : ERFOFF;
-	if ((ppsc->hwradiooff == true) && (e_rfpowerstate_toset == ERFON)) {
+	if (ppsc->hwradiooff && (e_rfpowerstate_toset == ERFON)) {
 		RT_TRACE(rtlpriv, COMP_RF, DBG_DMESG,
 			 ("GPIOChangeRF  - HW Radio ON, RF ON\n"));
 		e_rfpowerstate_toset = ERFON;
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192de/led.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192de/led.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192de/led.c
@@ -93,7 +93,7 @@ void rtl92de_sw_led_off(struct ieee80211
 		break;
 	case LED_PIN_LED0:
 		ledcfg &= 0xf0;
-		if (pcipriv->ledctl.led_opendrain == true)
+		if (pcipriv->ledctl.led_opendrain)
 			rtl_write_byte(rtlpriv, REG_LEDCFG2,
 				       (ledcfg | BIT(1) | BIT(5) | BIT(6)));
 		else
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192de/rf.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192de/rf.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192de/rf.c
@@ -87,7 +87,7 @@ void rtl92d_phy_rf6052_set_cck_txpower(s
 
 	if (rtlefuse->eeprom_regulatory != 0)
 		turbo_scanoff = true;
-	if (mac->act_scanning == true) {
+	if (mac->act_scanning) {
 		tx_agc[RF90_PATH_A] = 0x3f3f3f3f;
 		tx_agc[RF90_PATH_B] = 0x3f3f3f3f;
 		if (turbo_scanoff) {
@@ -416,9 +416,9 @@ bool rtl92d_phy_enable_anotherphy(struct
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_hal *rtlhal = &(rtlpriv->rtlhal);
 	u8 u1btmp;
-	u8 direct = bmac0 == true ? BIT(3) | BIT(2) : BIT(3);
-	u8 mac_reg = bmac0 == true ? REG_MAC1 : REG_MAC0;
-	u8 mac_on_bit = bmac0 == true ? MAC1_ON : MAC0_ON;
+	u8 direct = bmac0 ? BIT(3) | BIT(2) : BIT(3);
+	u8 mac_reg = bmac0 ? REG_MAC1 : REG_MAC0;
+	u8 mac_on_bit = bmac0 ? MAC1_ON : MAC0_ON;
 	bool bresult = true; /* true: need to enable BB/RF power */
 
 	rtlhal->during_mac0init_radiob = false;
@@ -447,9 +447,9 @@ void rtl92d_phy_powerdown_anotherphy(str
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_hal *rtlhal = &(rtlpriv->rtlhal);
 	u8 u1btmp;
-	u8 direct = bmac0 == true ? BIT(3) | BIT(2) : BIT(3);
-	u8 mac_reg = bmac0 == true ? REG_MAC1 : REG_MAC0;
-	u8 mac_on_bit = bmac0 == true ? MAC1_ON : MAC0_ON;
+	u8 direct = bmac0 ? BIT(3) | BIT(2) : BIT(3);
+	u8 mac_reg = bmac0 ? REG_MAC1 : REG_MAC0;
+	u8 mac_on_bit = bmac0 ? MAC1_ON : MAC0_ON;
 
 	rtlhal->during_mac0init_radiob = false;
 	rtlhal->during_mac1init_radioa = false;
@@ -573,7 +573,7 @@ bool rtl92d_phy_rf6052_config(struct iee
 		udelay(1);
 		switch (rfpath) {
 		case RF90_PATH_A:
-			if (true_bpath == true)
+			if (true_bpath)
 				rtstatus = rtl92d_phy_config_rf_with_headerfile(
 						hw, radiob_txt,
 						(enum radio_path)rfpath);
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192de/trx.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192de/trx.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192de/trx.c
@@ -614,7 +614,7 @@ bool rtl92de_rx_query_desc(struct ieee80
 						    (u8)
 						    GET_RX_DESC_RXMCS(pdesc));
 	rx_status->mactime = GET_RX_DESC_TSFL(pdesc);
-	if (phystatus == true) {
+	if (phystatus) {
 		p_drvinfo = (struct rx_fwinfo_92d *)(skb->data +
 						     stats->rx_bufshift);
 		_rtl92de_translate_rx_signal_stuff(hw,
@@ -876,7 +876,7 @@ void rtl92de_tx_fill_cmddesc(struct ieee
 
 void rtl92de_set_desc(u8 *pdesc, bool istx, u8 desc_name, u8 *val)
 {
-	if (istx == true) {
+	if (istx) {
 		switch (desc_name) {
 		case HW_DESC_OWN:
 			wmb();
@@ -917,7 +917,7 @@ u32 rtl92de_get_desc(u8 *p_desc, bool is
 {
 	u32 ret = 0;
 
-	if (istx == true) {
+	if (istx) {
 		switch (desc_name) {
 		case HW_DESC_OWN:
 			ret = GET_TX_DESC_OWN(p_desc);
