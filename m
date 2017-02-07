Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f194.google.com ([74.125.82.194]:33527 "EHLO
        mail-ot0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754877AbdBGPOa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Feb 2017 10:14:30 -0500
Received: by mail-ot0-f194.google.com with SMTP id f9so14497447otd.0
        for <linux-wireless@vger.kernel.org>; Tue, 07 Feb 2017 07:14:30 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH] rtlwifi: Move items out of rtl_pci_priv and rtl_usb_priv
Date: Tue,  7 Feb 2017 09:14:21 -0600
Message-Id: <20170207151421.32559-1-Larry.Finger@lwfinger.net> (sfid-20170207_161438_380188_8A8D47BD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In commit 6773386f977c ("rtlwifi: rtl8192c-common: Fix "BUG: KASAN:"),
a BUG detected when CONFIG_KASAN=y was fixed by reordering the layouts
of struct rtl_pci_priv, and struct rtl_usb_priv so that the variables
used by both PCI and USB drivers have the same offsets in both structs.
The better fix of relocating the critical variables into struct rtl_priv
was deferred as these changes do not have to be applied to stable
kernels.

This change also removes CamelCase variables with pLed0 => pled0.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 .../net/wireless/realtek/rtlwifi/rtl8188ee/hw.c    |  14 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/led.c   |  19 +--
 .../wireless/realtek/rtlwifi/rtl8192c/dm_common.c  | 143 +++++++++---------
 .../net/wireless/realtek/rtlwifi/rtl8192ce/hw.c    | 166 ++++++++++-----------
 .../net/wireless/realtek/rtlwifi/rtl8192ce/led.c   |  19 +--
 .../net/wireless/realtek/rtlwifi/rtl8192cu/hw.c    |   3 +-
 .../net/wireless/realtek/rtlwifi/rtl8192cu/led.c   |  17 ++-
 .../net/wireless/realtek/rtlwifi/rtl8192de/hw.c    |  10 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/led.c   |  19 +--
 .../net/wireless/realtek/rtlwifi/rtl8192ee/hw.c    |   6 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/led.c   |  14 +-
 .../net/wireless/realtek/rtlwifi/rtl8192se/hw.c    |  12 +-
 .../net/wireless/realtek/rtlwifi/rtl8192se/led.c   |  19 +--
 .../net/wireless/realtek/rtlwifi/rtl8723ae/hw.c    |   8 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/led.c   |  19 +--
 .../net/wireless/realtek/rtlwifi/rtl8723be/hw.c    |   8 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/led.c   |  15 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/hw.c    |  10 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/led.c   |  24 ++-
 drivers/net/wireless/realtek/rtlwifi/usb.h         |   1 -
 drivers/net/wireless/realtek/rtlwifi/wifi.h        |   1 +
 21 files changed, 261 insertions(+), 286 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c
index 679e214..0ba26d2 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c
@@ -817,19 +817,18 @@ static bool _rtl88ee_llt_table_init(struct ieee80211_hw *hw)
 static void _rtl88ee_gen_refresh_led_state(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
-	struct rtl_led *pLed0 = &(pcipriv->ledctl.sw_led0);
+	struct rtl_led *pled0 = &rtlpriv->ledctl.sw_led0;
 
 	if (rtlpriv->rtlhal.up_first_time)
 		return;
 
 	if (ppsc->rfoff_reason == RF_CHANGE_BY_IPS)
-		rtl88ee_sw_led_on(hw, pLed0);
+		rtl88ee_sw_led_on(hw, pled0);
 	else if (ppsc->rfoff_reason == RF_CHANGE_BY_INIT)
-		rtl88ee_sw_led_on(hw, pLed0);
+		rtl88ee_sw_led_on(hw, pled0);
 	else
-		rtl88ee_sw_led_off(hw, pLed0);
+		rtl88ee_sw_led_off(hw, pled0);
 }
 
 static bool _rtl88ee_init_mac(struct ieee80211_hw *hw)
@@ -1931,14 +1930,13 @@ static void _rtl88ee_read_adapter_info(struct ieee80211_hw *hw)
 static void _rtl88ee_hal_customized_behavior(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 
-	pcipriv->ledctl.led_opendrain = true;
+	rtlpriv->ledctl.led_opendrain = true;
 
 	switch (rtlhal->oem_id) {
 	case RT_CID_819X_HP:
-		pcipriv->ledctl.led_opendrain = true;
+		rtlpriv->ledctl.led_opendrain = true;
 		break;
 	case RT_CID_819X_LENOVO:
 	case RT_CID_DEFAULT:
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/led.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/led.c
index 6ea7fd7..df3e214 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/led.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/led.c
@@ -67,7 +67,6 @@ void rtl88ee_sw_led_on(struct ieee80211_hw *hw, struct rtl_led *pled)
 void rtl88ee_sw_led_off(struct ieee80211_hw *hw, struct rtl_led *pled)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
 	u8 ledcfg;
 
 	RT_TRACE(rtlpriv, COMP_LED, DBG_LOUD,
@@ -79,7 +78,7 @@ void rtl88ee_sw_led_off(struct ieee80211_hw *hw, struct rtl_led *pled)
 	case LED_PIN_LED0:
 		ledcfg = rtl_read_byte(rtlpriv, REG_LEDCFG2);
 		ledcfg &= 0xf0;
-		if (pcipriv->ledctl.led_opendrain) {
+		if (rtlpriv->ledctl.led_opendrain) {
 			rtl_write_byte(rtlpriv, REG_LEDCFG2,
 				       (ledcfg | BIT(3) | BIT(5) | BIT(6)));
 			ledcfg = rtl_read_byte(rtlpriv, REG_MAC_PINMUX_CFG);
@@ -104,24 +103,26 @@ void rtl88ee_sw_led_off(struct ieee80211_hw *hw, struct rtl_led *pled)
 
 void rtl88ee_init_sw_leds(struct ieee80211_hw *hw)
 {
-	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
-	_rtl88ee_init_led(hw, &pcipriv->ledctl.sw_led0, LED_PIN_LED0);
-	_rtl88ee_init_led(hw, &pcipriv->ledctl.sw_led1, LED_PIN_LED1);
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+
+	_rtl88ee_init_led(hw, &rtlpriv->ledctl.sw_led0, LED_PIN_LED0);
+	_rtl88ee_init_led(hw, &rtlpriv->ledctl.sw_led1, LED_PIN_LED1);
 }
 
 static void _rtl88ee_sw_led_control(struct ieee80211_hw *hw,
 				    enum led_ctl_mode ledaction)
 {
-	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
-	struct rtl_led *pLed0 = &(pcipriv->ledctl.sw_led0);
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_led *pled0 = &rtlpriv->ledctl.sw_led0;
+
 	switch (ledaction) {
 	case LED_CTL_POWER_ON:
 	case LED_CTL_LINK:
 	case LED_CTL_NO_LINK:
-		rtl88ee_sw_led_on(hw, pLed0);
+		rtl88ee_sw_led_on(hw, pled0);
 		break;
 	case LED_CTL_POWER_OFF:
-		rtl88ee_sw_led_off(hw, pLed0);
+		rtl88ee_sw_led_off(hw, pled0);
 		break;
 	default:
 		break;
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/dm_common.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/dm_common.c
index bdc132b..0b5a06f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/dm_common.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/dm_common.c
@@ -638,7 +638,6 @@ EXPORT_SYMBOL(rtl92c_dm_init_edca_turbo);
 static void rtl92c_dm_check_edca_turbo(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_pci_priv *rtlpcipriv = rtl_pcipriv(hw);
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 
 	static u64 last_txok_cnt;
@@ -651,20 +650,20 @@ static void rtl92c_dm_check_edca_turbo(struct ieee80211_hw *hw)
 	u32 edca_be_dl = 0x5ea42b;
 	bool bt_change_edca = false;
 
-	if ((last_bt_edca_ul != rtlpcipriv->bt_coexist.bt_edca_ul) ||
-	    (last_bt_edca_dl != rtlpcipriv->bt_coexist.bt_edca_dl)) {
+	if ((last_bt_edca_ul != rtlpriv->btcoexist.bt_edca_ul) ||
+	    (last_bt_edca_dl != rtlpriv->btcoexist.bt_edca_dl)) {
 		rtlpriv->dm.current_turbo_edca = false;
-		last_bt_edca_ul = rtlpcipriv->bt_coexist.bt_edca_ul;
-		last_bt_edca_dl = rtlpcipriv->bt_coexist.bt_edca_dl;
+		last_bt_edca_ul = rtlpriv->btcoexist.bt_edca_ul;
+		last_bt_edca_dl = rtlpriv->btcoexist.bt_edca_dl;
 	}
 
-	if (rtlpcipriv->bt_coexist.bt_edca_ul != 0) {
-		edca_be_ul = rtlpcipriv->bt_coexist.bt_edca_ul;
+	if (rtlpriv->btcoexist.bt_edca_ul != 0) {
+		edca_be_ul = rtlpriv->btcoexist.bt_edca_ul;
 		bt_change_edca = true;
 	}
 
-	if (rtlpcipriv->bt_coexist.bt_edca_dl != 0) {
-		edca_be_ul = rtlpcipriv->bt_coexist.bt_edca_dl;
+	if (rtlpriv->btcoexist.bt_edca_dl != 0) {
+		edca_be_ul = rtlpriv->btcoexist.bt_edca_dl;
 		bt_change_edca = true;
 	}
 
@@ -673,7 +672,7 @@ static void rtl92c_dm_check_edca_turbo(struct ieee80211_hw *hw)
 		return;
 	}
 
-	if ((!mac->ht_enable) && (!rtlpcipriv->bt_coexist.bt_coexistence)) {
+	if ((!mac->ht_enable) && (!rtlpriv->btcoexist.bt_coexistence)) {
 		if (!(edca_be_ul & 0xffff0000))
 			edca_be_ul |= 0x005e0000;
 
@@ -1471,7 +1470,6 @@ EXPORT_SYMBOL(rtl92c_dm_watchdog);
 u8 rtl92c_bt_rssi_state_change(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_pci_priv *rtlpcipriv = rtl_pcipriv(hw);
 	long undec_sm_pwdb;
 	u8 curr_bt_rssi_state = 0x00;
 
@@ -1510,8 +1508,8 @@ u8 rtl92c_bt_rssi_state_change(struct ieee80211_hw *hw)
 	else
 		curr_bt_rssi_state &= (~BT_RSSI_STATE_BG_EDCA_LOW);
 
-	if (curr_bt_rssi_state != rtlpcipriv->bt_coexist.bt_rssi_state) {
-		rtlpcipriv->bt_coexist.bt_rssi_state = curr_bt_rssi_state;
+	if (curr_bt_rssi_state != rtlpriv->btcoexist.bt_rssi_state) {
+		rtlpriv->btcoexist.bt_rssi_state = curr_bt_rssi_state;
 		return true;
 	} else {
 		return false;
@@ -1522,7 +1520,6 @@ EXPORT_SYMBOL(rtl92c_bt_rssi_state_change);
 static bool rtl92c_bt_state_change(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_pci_priv *rtlpcipriv = rtl_pcipriv(hw);
 
 	u32 polling, ratio_tx, ratio_pri;
 	u32 bt_tx, bt_pri;
@@ -1542,14 +1539,14 @@ static bool rtl92c_bt_state_change(struct ieee80211_hw *hw)
 		return false;
 
 	bt_state &= BIT_OFFSET_LEN_MASK_32(0, 1);
-	if (bt_state != rtlpcipriv->bt_coexist.bt_cur_state) {
-		rtlpcipriv->bt_coexist.bt_cur_state = bt_state;
+	if (bt_state != rtlpriv->btcoexist.bt_cur_state) {
+		rtlpriv->btcoexist.bt_cur_state = bt_state;
 
-		if (rtlpcipriv->bt_coexist.reg_bt_sco == 3) {
-			rtlpcipriv->bt_coexist.bt_service = BT_IDLE;
+		if (rtlpriv->btcoexist.reg_bt_sco == 3) {
+			rtlpriv->btcoexist.bt_service = BT_IDLE;
 
 			bt_state = bt_state |
-			  ((rtlpcipriv->bt_coexist.bt_ant_isolation == 1) ?
+			  ((rtlpriv->btcoexist.bt_ant_isolation == 1) ?
 			  0 : BIT_OFFSET_LEN_MASK_32(1, 1)) |
 			  BIT_OFFSET_LEN_MASK_32(2, 1);
 			rtl_write_byte(rtlpriv, 0x4fd, bt_state);
@@ -1559,10 +1556,10 @@ static bool rtl92c_bt_state_change(struct ieee80211_hw *hw)
 
 	ratio_tx = bt_tx * 1000 / polling;
 	ratio_pri = bt_pri * 1000 / polling;
-	rtlpcipriv->bt_coexist.ratio_tx = ratio_tx;
-	rtlpcipriv->bt_coexist.ratio_pri = ratio_pri;
+	rtlpriv->btcoexist.ratio_tx = ratio_tx;
+	rtlpriv->btcoexist.ratio_pri = ratio_pri;
 
-	if (bt_state && rtlpcipriv->bt_coexist.reg_bt_sco == 3) {
+	if (bt_state && rtlpriv->btcoexist.reg_bt_sco == 3) {
 
 		if ((ratio_tx < 30)  && (ratio_pri < 30))
 			cur_service_type = BT_IDLE;
@@ -1577,17 +1574,17 @@ static bool rtl92c_bt_state_change(struct ieee80211_hw *hw)
 		else
 			cur_service_type = BT_OTHER_ACTION;
 
-		if (cur_service_type != rtlpcipriv->bt_coexist.bt_service) {
-			rtlpcipriv->bt_coexist.bt_service = cur_service_type;
+		if (cur_service_type != rtlpriv->btcoexist.bt_service) {
+			rtlpriv->btcoexist.bt_service = cur_service_type;
 			bt_state = bt_state |
-			   ((rtlpcipriv->bt_coexist.bt_ant_isolation == 1) ?
+			   ((rtlpriv->btcoexist.bt_ant_isolation == 1) ?
 			   0 : BIT_OFFSET_LEN_MASK_32(1, 1)) |
-			   ((rtlpcipriv->bt_coexist.bt_service != BT_IDLE) ?
+			   ((rtlpriv->btcoexist.bt_service != BT_IDLE) ?
 			   0 : BIT_OFFSET_LEN_MASK_32(2, 1));
 
 			/* Add interrupt migration when bt is not ini
 			 * idle state (no traffic). */
-			if (rtlpcipriv->bt_coexist.bt_service != BT_IDLE) {
+			if (rtlpriv->btcoexist.bt_service != BT_IDLE) {
 				rtl_write_word(rtlpriv, 0x504, 0x0ccc);
 				rtl_write_byte(rtlpriv, 0x506, 0x54);
 				rtl_write_byte(rtlpriv, 0x507, 0x54);
@@ -1626,80 +1623,77 @@ static bool rtl92c_bt_wifi_connect_change(struct ieee80211_hw *hw)
 static void rtl92c_bt_set_normal(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_pci_priv *rtlpcipriv = rtl_pcipriv(hw);
-
-
-	if (rtlpcipriv->bt_coexist.bt_service == BT_OTHERBUSY) {
-		rtlpcipriv->bt_coexist.bt_edca_ul = 0x5ea72b;
-		rtlpcipriv->bt_coexist.bt_edca_dl = 0x5ea72b;
-	} else if (rtlpcipriv->bt_coexist.bt_service == BT_BUSY) {
-		rtlpcipriv->bt_coexist.bt_edca_ul = 0x5eb82f;
-		rtlpcipriv->bt_coexist.bt_edca_dl = 0x5eb82f;
-	} else if (rtlpcipriv->bt_coexist.bt_service == BT_SCO) {
-		if (rtlpcipriv->bt_coexist.ratio_tx > 160) {
-			rtlpcipriv->bt_coexist.bt_edca_ul = 0x5ea72f;
-			rtlpcipriv->bt_coexist.bt_edca_dl = 0x5ea72f;
+
+	if (rtlpriv->btcoexist.bt_service == BT_OTHERBUSY) {
+		rtlpriv->btcoexist.bt_edca_ul = 0x5ea72b;
+		rtlpriv->btcoexist.bt_edca_dl = 0x5ea72b;
+	} else if (rtlpriv->btcoexist.bt_service == BT_BUSY) {
+		rtlpriv->btcoexist.bt_edca_ul = 0x5eb82f;
+		rtlpriv->btcoexist.bt_edca_dl = 0x5eb82f;
+	} else if (rtlpriv->btcoexist.bt_service == BT_SCO) {
+		if (rtlpriv->btcoexist.ratio_tx > 160) {
+			rtlpriv->btcoexist.bt_edca_ul = 0x5ea72f;
+			rtlpriv->btcoexist.bt_edca_dl = 0x5ea72f;
 		} else {
-			rtlpcipriv->bt_coexist.bt_edca_ul = 0x5ea32b;
-			rtlpcipriv->bt_coexist.bt_edca_dl = 0x5ea42b;
+			rtlpriv->btcoexist.bt_edca_ul = 0x5ea32b;
+			rtlpriv->btcoexist.bt_edca_dl = 0x5ea42b;
 		}
 	} else {
-		rtlpcipriv->bt_coexist.bt_edca_ul = 0;
-		rtlpcipriv->bt_coexist.bt_edca_dl = 0;
+		rtlpriv->btcoexist.bt_edca_ul = 0;
+		rtlpriv->btcoexist.bt_edca_dl = 0;
 	}
 
-	if ((rtlpcipriv->bt_coexist.bt_service != BT_IDLE) &&
-	     (rtlpriv->mac80211.mode == WIRELESS_MODE_G ||
+	if ((rtlpriv->btcoexist.bt_service != BT_IDLE) &&
+	    (rtlpriv->mac80211.mode == WIRELESS_MODE_G ||
 	     (rtlpriv->mac80211.mode == (WIRELESS_MODE_G | WIRELESS_MODE_B))) &&
-	     (rtlpcipriv->bt_coexist.bt_rssi_state &
+	    (rtlpriv->btcoexist.bt_rssi_state &
 	     BT_RSSI_STATE_BG_EDCA_LOW)) {
-		rtlpcipriv->bt_coexist.bt_edca_ul = 0x5eb82b;
-		rtlpcipriv->bt_coexist.bt_edca_dl = 0x5eb82b;
+		rtlpriv->btcoexist.bt_edca_ul = 0x5eb82b;
+		rtlpriv->btcoexist.bt_edca_dl = 0x5eb82b;
 	}
 }
 
 static void rtl92c_bt_ant_isolation(struct ieee80211_hw *hw, u8 tmp1byte)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_pci_priv *rtlpcipriv = rtl_pcipriv(hw);
 
 
 	/* Only enable HW BT coexist when BT in "Busy" state. */
 	if (rtlpriv->mac80211.vendor == PEER_CISCO &&
-	    rtlpcipriv->bt_coexist.bt_service == BT_OTHER_ACTION) {
+	    rtlpriv->btcoexist.bt_service == BT_OTHER_ACTION) {
 		rtl_write_byte(rtlpriv, REG_GPIO_MUXCFG, 0xa0);
 	} else {
-		if ((rtlpcipriv->bt_coexist.bt_service == BT_BUSY) &&
-		    (rtlpcipriv->bt_coexist.bt_rssi_state &
+		if ((rtlpriv->btcoexist.bt_service == BT_BUSY) &&
+		    (rtlpriv->btcoexist.bt_rssi_state &
 		     BT_RSSI_STATE_NORMAL_POWER)) {
 			rtl_write_byte(rtlpriv, REG_GPIO_MUXCFG, 0xa0);
-		} else if ((rtlpcipriv->bt_coexist.bt_service ==
+		} else if ((rtlpriv->btcoexist.bt_service ==
 			    BT_OTHER_ACTION) && (rtlpriv->mac80211.mode <
 			    WIRELESS_MODE_N_24G) &&
-			    (rtlpcipriv->bt_coexist.bt_rssi_state &
+			    (rtlpriv->btcoexist.bt_rssi_state &
 			    BT_RSSI_STATE_SPECIAL_LOW)) {
 			rtl_write_byte(rtlpriv, REG_GPIO_MUXCFG, 0xa0);
-		} else if (rtlpcipriv->bt_coexist.bt_service == BT_PAN) {
+		} else if (rtlpriv->btcoexist.bt_service == BT_PAN) {
 			rtl_write_byte(rtlpriv, REG_GPIO_MUXCFG, tmp1byte);
 		} else {
 			rtl_write_byte(rtlpriv, REG_GPIO_MUXCFG, tmp1byte);
 		}
 	}
 
-	if (rtlpcipriv->bt_coexist.bt_service == BT_PAN)
+	if (rtlpriv->btcoexist.bt_service == BT_PAN)
 		rtl_write_dword(rtlpriv, REG_GPIO_PIN_CTRL, 0x10100);
 	else
 		rtl_write_dword(rtlpriv, REG_GPIO_PIN_CTRL, 0x0);
 
-	if (rtlpcipriv->bt_coexist.bt_rssi_state &
+	if (rtlpriv->btcoexist.bt_rssi_state &
 	    BT_RSSI_STATE_NORMAL_POWER) {
 		rtl92c_bt_set_normal(hw);
 	} else {
-		rtlpcipriv->bt_coexist.bt_edca_ul = 0;
-		rtlpcipriv->bt_coexist.bt_edca_dl = 0;
+		rtlpriv->btcoexist.bt_edca_ul = 0;
+		rtlpriv->btcoexist.bt_edca_dl = 0;
 	}
 
-	if (rtlpcipriv->bt_coexist.bt_service != BT_IDLE) {
+	if (rtlpriv->btcoexist.bt_service != BT_IDLE) {
 		rtlpriv->cfg->ops->set_rfreg(hw,
 				 RF90_PATH_A,
 				 0x1e,
@@ -1707,12 +1701,12 @@ static void rtl92c_bt_ant_isolation(struct ieee80211_hw *hw, u8 tmp1byte)
 	} else {
 		rtlpriv->cfg->ops->set_rfreg(hw,
 		     RF90_PATH_A, 0x1e, 0xf0,
-		     rtlpcipriv->bt_coexist.bt_rfreg_origin_1e);
+		     rtlpriv->btcoexist.bt_rfreg_origin_1e);
 	}
 
 	if (!rtlpriv->dm.dynamic_txpower_enable) {
-		if (rtlpcipriv->bt_coexist.bt_service != BT_IDLE) {
-			if (rtlpcipriv->bt_coexist.bt_rssi_state &
+		if (rtlpriv->btcoexist.bt_service != BT_IDLE) {
+			if (rtlpriv->btcoexist.bt_rssi_state &
 				BT_RSSI_STATE_TXPOWER_LOW) {
 				rtlpriv->dm.dynamic_txhighpower_lvl =
 							TXHIGHPWRLEVEL_BT2;
@@ -1732,37 +1726,34 @@ static void rtl92c_bt_ant_isolation(struct ieee80211_hw *hw, u8 tmp1byte)
 static void rtl92c_check_bt_change(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_pci_priv *rtlpcipriv = rtl_pcipriv(hw);
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 	u8 tmp1byte = 0;
 
 	if (IS_81XXC_VENDOR_UMC_B_CUT(rtlhal->version) &&
-	    rtlpcipriv->bt_coexist.bt_coexistence)
+	    rtlpriv->btcoexist.bt_coexistence)
 		tmp1byte |= BIT(5);
-	if (rtlpcipriv->bt_coexist.bt_cur_state) {
-		if (rtlpcipriv->bt_coexist.bt_ant_isolation)
+	if (rtlpriv->btcoexist.bt_cur_state) {
+		if (rtlpriv->btcoexist.bt_ant_isolation)
 			rtl92c_bt_ant_isolation(hw, tmp1byte);
 	} else {
 		rtl_write_byte(rtlpriv, REG_GPIO_MUXCFG, tmp1byte);
 		rtlpriv->cfg->ops->set_rfreg(hw, RF90_PATH_A, 0x1e, 0xf0,
-				rtlpcipriv->bt_coexist.bt_rfreg_origin_1e);
+				rtlpriv->btcoexist.bt_rfreg_origin_1e);
 
-		rtlpcipriv->bt_coexist.bt_edca_ul = 0;
-		rtlpcipriv->bt_coexist.bt_edca_dl = 0;
+		rtlpriv->btcoexist.bt_edca_ul = 0;
+		rtlpriv->btcoexist.bt_edca_dl = 0;
 	}
 }
 
 void rtl92c_dm_bt_coexist(struct ieee80211_hw *hw)
 {
-	struct rtl_pci_priv *rtlpcipriv = rtl_pcipriv(hw);
-
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	bool wifi_connect_change;
 	bool bt_state_change;
 	bool rssi_state_change;
 
-	if ((rtlpcipriv->bt_coexist.bt_coexistence) &&
-	     (rtlpcipriv->bt_coexist.bt_coexist_type == BT_CSR_BC4)) {
-
+	if ((rtlpriv->btcoexist.bt_coexistence) &&
+	    (rtlpriv->btcoexist.bt_coexist_type == BT_CSR_BC4)) {
 		wifi_connect_change = rtl92c_bt_wifi_connect_change(hw);
 		bt_state_change = rtl92c_bt_state_change(hw);
 		rssi_state_change = rtl92c_bt_rssi_state_change(hw);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c
index 611987d..9956026 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c
@@ -148,7 +148,6 @@ void rtl92ce_get_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 void rtl92ce_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_pci_priv *rtlpcipriv = rtl_pcipriv(hw);
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
@@ -276,8 +275,8 @@ void rtl92ce_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 			u8 *p_regtoset = NULL;
 			u8 index = 0;
 
-			if ((rtlpcipriv->bt_coexist.bt_coexistence) &&
-			    (rtlpcipriv->bt_coexist.bt_coexist_type ==
+			if ((rtlpriv->btcoexist.bt_coexistence) &&
+			    (rtlpriv->btcoexist.bt_coexist_type ==
 			    BT_CSR_BC4))
 				p_regtoset = regtoset_bt;
 			else
@@ -655,26 +654,25 @@ static bool _rtl92ce_llt_table_init(struct ieee80211_hw *hw)
 
 static void _rtl92ce_gen_refresh_led_state(struct ieee80211_hw *hw)
 {
-	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
-	struct rtl_led *pLed0 = &(pcipriv->ledctl.sw_led0);
+	struct rtl_led *pled0 = &rtlpriv->ledctl.sw_led0;
 
 	if (rtlpci->up_first_time)
 		return;
 
 	if (ppsc->rfoff_reason == RF_CHANGE_BY_IPS)
-		rtl92ce_sw_led_on(hw, pLed0);
+		rtl92ce_sw_led_on(hw, pled0);
 	else if (ppsc->rfoff_reason == RF_CHANGE_BY_INIT)
-		rtl92ce_sw_led_on(hw, pLed0);
+		rtl92ce_sw_led_on(hw, pled0);
 	else
-		rtl92ce_sw_led_off(hw, pLed0);
+		rtl92ce_sw_led_off(hw, pled0);
 }
 
 static bool _rtl92ce_init_mac(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_pci_priv *rtlpcipriv = rtl_pcipriv(hw);
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 
@@ -683,7 +681,7 @@ static bool _rtl92ce_init_mac(struct ieee80211_hw *hw)
 	u16 retry;
 
 	rtl_write_byte(rtlpriv, REG_RSV_CTRL, 0x00);
-	if (rtlpcipriv->bt_coexist.bt_coexistence) {
+	if (rtlpriv->btcoexist.bt_coexistence) {
 		u32 value32;
 		value32 = rtl_read_dword(rtlpriv, REG_APS_FSMCO);
 		value32 |= (SOP_ABG | SOP_AMB | XOP_BTCK);
@@ -692,7 +690,7 @@ static bool _rtl92ce_init_mac(struct ieee80211_hw *hw)
 	rtl_write_byte(rtlpriv, REG_SPS0_CTRL, 0x2b);
 	rtl_write_byte(rtlpriv, REG_AFE_XTAL_CTRL, 0x0F);
 
-	if (rtlpcipriv->bt_coexist.bt_coexistence) {
+	if (rtlpriv->btcoexist.bt_coexistence) {
 		u32 u4b_tmp = rtl_read_dword(rtlpriv, REG_AFE_XTAL_CTRL);
 
 		u4b_tmp &= (~0x00024800);
@@ -726,7 +724,7 @@ static bool _rtl92ce_init_mac(struct ieee80211_hw *hw)
 	rtl_write_byte(rtlpriv, REG_SYS_ISO_CTRL + 1, 0x82);
 	udelay(2);
 
-	if (rtlpcipriv->bt_coexist.bt_coexistence) {
+	if (rtlpriv->btcoexist.bt_coexistence) {
 		bytetmp = rtl_read_byte(rtlpriv, REG_AFE_XTAL_CTRL+2) & 0xfd;
 		rtl_write_byte(rtlpriv, REG_AFE_XTAL_CTRL+2, bytetmp);
 	}
@@ -798,7 +796,6 @@ static void _rtl92ce_hw_configure(struct ieee80211_hw *hw)
 {
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_pci_priv *rtlpcipriv = rtl_pcipriv(hw);
 	u8 reg_bw_opmode;
 	u32 reg_prsr;
 
@@ -828,8 +825,8 @@ static void _rtl92ce_hw_configure(struct ieee80211_hw *hw)
 	rtl_write_dword(rtlpriv, REG_RARFRC, 0x01000000);
 	rtl_write_dword(rtlpriv, REG_RARFRC + 4, 0x07060504);
 
-	if ((rtlpcipriv->bt_coexist.bt_coexistence) &&
-	    (rtlpcipriv->bt_coexist.bt_coexist_type == BT_CSR_BC4))
+	if ((rtlpriv->btcoexist.bt_coexistence) &&
+	    (rtlpriv->btcoexist.bt_coexist_type == BT_CSR_BC4))
 		rtl_write_dword(rtlpriv, REG_AGGLEN_LMT, 0x97427431);
 	else
 		rtl_write_dword(rtlpriv, REG_AGGLEN_LMT, 0xb972a841);
@@ -848,8 +845,8 @@ static void _rtl92ce_hw_configure(struct ieee80211_hw *hw)
 	rtl_write_byte(rtlpriv, REG_PIFS, 0x1C);
 	rtl_write_byte(rtlpriv, REG_AGGR_BREAK_TIME, 0x16);
 
-	if ((rtlpcipriv->bt_coexist.bt_coexistence) &&
-	    (rtlpcipriv->bt_coexist.bt_coexist_type == BT_CSR_BC4)) {
+	if ((rtlpriv->btcoexist.bt_coexistence) &&
+	    (rtlpriv->btcoexist.bt_coexist_type == BT_CSR_BC4)) {
 		rtl_write_word(rtlpriv, REG_NAV_PROT_LEN, 0x0020);
 		rtl_write_word(rtlpriv, REG_PROT_MODE_CTRL, 0x0402);
 	} else {
@@ -857,8 +854,8 @@ static void _rtl92ce_hw_configure(struct ieee80211_hw *hw)
 		rtl_write_word(rtlpriv, REG_NAV_PROT_LEN, 0x0020);
 	}
 
-	if ((rtlpcipriv->bt_coexist.bt_coexistence) &&
-	     (rtlpcipriv->bt_coexist.bt_coexist_type == BT_CSR_BC4))
+	if ((rtlpriv->btcoexist.bt_coexistence) &&
+	    (rtlpriv->btcoexist.bt_coexist_type == BT_CSR_BC4))
 		rtl_write_dword(rtlpriv, REG_FAST_EDCA_CTRL, 0x03086666);
 	else
 		rtl_write_dword(rtlpriv, REG_FAST_EDCA_CTRL, 0x086666);
@@ -1313,7 +1310,6 @@ void rtl92ce_disable_interrupt(struct ieee80211_hw *hw)
 static void _rtl92ce_poweroff_adapter(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_pci_priv *rtlpcipriv = rtl_pcipriv(hw);
 	struct rtl_hal *rtlhal = rtl_hal(rtlpriv);
 	u8 u1b_tmp;
 	u32 u4b_tmp;
@@ -1331,9 +1327,9 @@ static void _rtl92ce_poweroff_adapter(struct ieee80211_hw *hw)
 	rtl_write_byte(rtlpriv, REG_MCUFWDL, 0x00);
 	rtl_write_dword(rtlpriv, REG_GPIO_PIN_CTRL, 0x00000000);
 	u1b_tmp = rtl_read_byte(rtlpriv, REG_GPIO_PIN_CTRL);
-	if ((rtlpcipriv->bt_coexist.bt_coexistence) &&
-	     ((rtlpcipriv->bt_coexist.bt_coexist_type == BT_CSR_BC4) ||
-	     (rtlpcipriv->bt_coexist.bt_coexist_type == BT_CSR_BC8))) {
+	if ((rtlpriv->btcoexist.bt_coexistence) &&
+	    ((rtlpriv->btcoexist.bt_coexist_type == BT_CSR_BC4) ||
+	     (rtlpriv->btcoexist.bt_coexist_type == BT_CSR_BC8))) {
 		rtl_write_dword(rtlpriv, REG_GPIO_PIN_CTRL, 0x00F30000 |
 				(u1b_tmp << 8));
 	} else {
@@ -1345,7 +1341,7 @@ static void _rtl92ce_poweroff_adapter(struct ieee80211_hw *hw)
 	rtl_write_byte(rtlpriv, REG_AFE_PLL_CTRL, 0x80);
 	if (!IS_81XXC_VENDOR_UMC_B_CUT(rtlhal->version))
 		rtl_write_byte(rtlpriv, REG_SPS0_CTRL, 0x23);
-	if (rtlpcipriv->bt_coexist.bt_coexistence) {
+	if (rtlpriv->btcoexist.bt_coexistence) {
 		u4b_tmp = rtl_read_dword(rtlpriv, REG_AFE_XTAL_CTRL);
 		u4b_tmp |= 0x03824800;
 		rtl_write_dword(rtlpriv, REG_AFE_XTAL_CTRL, u4b_tmp);
@@ -1724,12 +1720,11 @@ static void _rtl92ce_read_adapter_info(struct ieee80211_hw *hw)
 static void _rtl92ce_hal_customized_behavior(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 
 	switch (rtlhal->oem_id) {
 	case RT_CID_819X_HP:
-		pcipriv->ledctl.led_opendrain = true;
+		rtlpriv->ledctl.led_opendrain = true;
 		break;
 	case RT_CID_819X_LENOVO:
 	case RT_CID_DEFAULT:
@@ -1782,7 +1777,6 @@ static void rtl92ce_update_hal_rate_table(struct ieee80211_hw *hw,
 		struct ieee80211_sta *sta)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_pci_priv *rtlpcipriv = rtl_pcipriv(hw);
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
@@ -1838,12 +1832,12 @@ static void rtl92ce_update_hal_rate_table(struct ieee80211_hw *hw,
 		break;
 	}
 
-	if ((rtlpcipriv->bt_coexist.bt_coexistence) &&
-	    (rtlpcipriv->bt_coexist.bt_coexist_type == BT_CSR_BC4) &&
-	    (rtlpcipriv->bt_coexist.bt_cur_state) &&
-	    (rtlpcipriv->bt_coexist.bt_ant_isolation) &&
-	    ((rtlpcipriv->bt_coexist.bt_service == BT_SCO) ||
-	    (rtlpcipriv->bt_coexist.bt_service == BT_BUSY)))
+	if ((rtlpriv->btcoexist.bt_coexistence) &&
+	    (rtlpriv->btcoexist.bt_coexist_type == BT_CSR_BC4) &&
+	    (rtlpriv->btcoexist.bt_cur_state) &&
+	    (rtlpriv->btcoexist.bt_ant_isolation) &&
+	    ((rtlpriv->btcoexist.bt_service == BT_SCO) ||
+	    (rtlpriv->btcoexist.bt_service == BT_BUSY)))
 		ratr_value &= 0x0fffcfc0;
 	else
 		ratr_value &= 0x0FFFFFFF;
@@ -2237,65 +2231,64 @@ void rtl92ce_set_key(struct ieee80211_hw *hw, u32 key_index,
 
 static void rtl8192ce_bt_var_init(struct ieee80211_hw *hw)
 {
-	struct rtl_pci_priv *rtlpcipriv = rtl_pcipriv(hw);
-
-	rtlpcipriv->bt_coexist.bt_coexistence =
-			rtlpcipriv->bt_coexist.eeprom_bt_coexist;
-	rtlpcipriv->bt_coexist.bt_ant_num =
-			rtlpcipriv->bt_coexist.eeprom_bt_ant_num;
-	rtlpcipriv->bt_coexist.bt_coexist_type =
-			rtlpcipriv->bt_coexist.eeprom_bt_type;
-
-	if (rtlpcipriv->bt_coexist.reg_bt_iso == 2)
-		rtlpcipriv->bt_coexist.bt_ant_isolation =
-			rtlpcipriv->bt_coexist.eeprom_bt_ant_isol;
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+
+	rtlpriv->btcoexist.bt_coexistence =
+			rtlpriv->btcoexist.eeprom_bt_coexist;
+	rtlpriv->btcoexist.bt_ant_num =
+			rtlpriv->btcoexist.eeprom_bt_ant_num;
+	rtlpriv->btcoexist.bt_coexist_type =
+			rtlpriv->btcoexist.eeprom_bt_type;
+
+	if (rtlpriv->btcoexist.reg_bt_iso == 2)
+		rtlpriv->btcoexist.bt_ant_isolation =
+			rtlpriv->btcoexist.eeprom_bt_ant_isol;
 	else
-		rtlpcipriv->bt_coexist.bt_ant_isolation =
-			rtlpcipriv->bt_coexist.reg_bt_iso;
-
-	rtlpcipriv->bt_coexist.bt_radio_shared_type =
-			rtlpcipriv->bt_coexist.eeprom_bt_radio_shared;
-
-	if (rtlpcipriv->bt_coexist.bt_coexistence) {
-
-		if (rtlpcipriv->bt_coexist.reg_bt_sco == 1)
-			rtlpcipriv->bt_coexist.bt_service = BT_OTHER_ACTION;
-		else if (rtlpcipriv->bt_coexist.reg_bt_sco == 2)
-			rtlpcipriv->bt_coexist.bt_service = BT_SCO;
-		else if (rtlpcipriv->bt_coexist.reg_bt_sco == 4)
-			rtlpcipriv->bt_coexist.bt_service = BT_BUSY;
-		else if (rtlpcipriv->bt_coexist.reg_bt_sco == 5)
-			rtlpcipriv->bt_coexist.bt_service = BT_OTHERBUSY;
+		rtlpriv->btcoexist.bt_ant_isolation =
+			rtlpriv->btcoexist.reg_bt_iso;
+
+	rtlpriv->btcoexist.bt_radio_shared_type =
+			rtlpriv->btcoexist.eeprom_bt_radio_shared;
+
+	if (rtlpriv->btcoexist.bt_coexistence) {
+		if (rtlpriv->btcoexist.reg_bt_sco == 1)
+			rtlpriv->btcoexist.bt_service = BT_OTHER_ACTION;
+		else if (rtlpriv->btcoexist.reg_bt_sco == 2)
+			rtlpriv->btcoexist.bt_service = BT_SCO;
+		else if (rtlpriv->btcoexist.reg_bt_sco == 4)
+			rtlpriv->btcoexist.bt_service = BT_BUSY;
+		else if (rtlpriv->btcoexist.reg_bt_sco == 5)
+			rtlpriv->btcoexist.bt_service = BT_OTHERBUSY;
 		else
-			rtlpcipriv->bt_coexist.bt_service = BT_IDLE;
+			rtlpriv->btcoexist.bt_service = BT_IDLE;
 
-		rtlpcipriv->bt_coexist.bt_edca_ul = 0;
-		rtlpcipriv->bt_coexist.bt_edca_dl = 0;
-		rtlpcipriv->bt_coexist.bt_rssi_state = 0xff;
+		rtlpriv->btcoexist.bt_edca_ul = 0;
+		rtlpriv->btcoexist.bt_edca_dl = 0;
+		rtlpriv->btcoexist.bt_rssi_state = 0xff;
 	}
 }
 
 void rtl8192ce_read_bt_coexist_info_from_hwpg(struct ieee80211_hw *hw,
 					      bool auto_load_fail, u8 *hwinfo)
 {
-	struct rtl_pci_priv *rtlpcipriv = rtl_pcipriv(hw);
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	u8 val;
 
 	if (!auto_load_fail) {
-		rtlpcipriv->bt_coexist.eeprom_bt_coexist =
+		rtlpriv->btcoexist.eeprom_bt_coexist =
 					((hwinfo[RF_OPTION1] & 0xe0) >> 5);
 		val = hwinfo[RF_OPTION4];
-		rtlpcipriv->bt_coexist.eeprom_bt_type = ((val & 0xe) >> 1);
-		rtlpcipriv->bt_coexist.eeprom_bt_ant_num = (val & 0x1);
-		rtlpcipriv->bt_coexist.eeprom_bt_ant_isol = ((val & 0x10) >> 4);
-		rtlpcipriv->bt_coexist.eeprom_bt_radio_shared =
+		rtlpriv->btcoexist.eeprom_bt_type = ((val & 0xe) >> 1);
+		rtlpriv->btcoexist.eeprom_bt_ant_num = (val & 0x1);
+		rtlpriv->btcoexist.eeprom_bt_ant_isol = ((val & 0x10) >> 4);
+		rtlpriv->btcoexist.eeprom_bt_radio_shared =
 							 ((val & 0x20) >> 5);
 	} else {
-		rtlpcipriv->bt_coexist.eeprom_bt_coexist = 0;
-		rtlpcipriv->bt_coexist.eeprom_bt_type = BT_2WIRE;
-		rtlpcipriv->bt_coexist.eeprom_bt_ant_num = ANT_X2;
-		rtlpcipriv->bt_coexist.eeprom_bt_ant_isol = 0;
-		rtlpcipriv->bt_coexist.eeprom_bt_radio_shared = BT_RADIO_SHARED;
+		rtlpriv->btcoexist.eeprom_bt_coexist = 0;
+		rtlpriv->btcoexist.eeprom_bt_type = BT_2WIRE;
+		rtlpriv->btcoexist.eeprom_bt_ant_num = ANT_X2;
+		rtlpriv->btcoexist.eeprom_bt_ant_isol = 0;
+		rtlpriv->btcoexist.eeprom_bt_radio_shared = BT_RADIO_SHARED;
 	}
 
 	rtl8192ce_bt_var_init(hw);
@@ -2303,14 +2296,14 @@ void rtl8192ce_read_bt_coexist_info_from_hwpg(struct ieee80211_hw *hw,
 
 void rtl8192ce_bt_reg_init(struct ieee80211_hw *hw)
 {
-	struct rtl_pci_priv *rtlpcipriv = rtl_pcipriv(hw);
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
 
 	/* 0:Low, 1:High, 2:From Efuse. */
-	rtlpcipriv->bt_coexist.reg_bt_iso = 2;
+	rtlpriv->btcoexist.reg_bt_iso = 2;
 	/* 0:Idle, 1:None-SCO, 2:SCO, 3:From Counter. */
-	rtlpcipriv->bt_coexist.reg_bt_sco = 3;
+	rtlpriv->btcoexist.reg_bt_sco = 3;
 	/* 0:Disable BT control A-MPDU, 1:Enable BT control A-MPDU. */
-	rtlpcipriv->bt_coexist.reg_bt_sco = 0;
+	rtlpriv->btcoexist.reg_bt_sco = 0;
 }
 
 
@@ -2318,23 +2311,22 @@ void rtl8192ce_bt_hw_init(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
-	struct rtl_pci_priv *rtlpcipriv = rtl_pcipriv(hw);
 
 	u8 u1_tmp;
 
-	if (rtlpcipriv->bt_coexist.bt_coexistence &&
-	    ((rtlpcipriv->bt_coexist.bt_coexist_type == BT_CSR_BC4) ||
-	      rtlpcipriv->bt_coexist.bt_coexist_type == BT_CSR_BC8)) {
+	if (rtlpriv->btcoexist.bt_coexistence &&
+	    ((rtlpriv->btcoexist.bt_coexist_type == BT_CSR_BC4) ||
+	      rtlpriv->btcoexist.bt_coexist_type == BT_CSR_BC8)) {
 
-		if (rtlpcipriv->bt_coexist.bt_ant_isolation)
+		if (rtlpriv->btcoexist.bt_ant_isolation)
 			rtl_write_byte(rtlpriv, REG_GPIO_MUXCFG, 0xa0);
 
 		u1_tmp = rtl_read_byte(rtlpriv, 0x4fd) &
 			 BIT_OFFSET_LEN_MASK_32(0, 1);
 		u1_tmp = u1_tmp |
-			 ((rtlpcipriv->bt_coexist.bt_ant_isolation == 1) ?
+			 ((rtlpriv->btcoexist.bt_ant_isolation == 1) ?
 			 0 : BIT_OFFSET_LEN_MASK_32(1, 1)) |
-			 ((rtlpcipriv->bt_coexist.bt_service == BT_SCO) ?
+			 ((rtlpriv->btcoexist.bt_service == BT_SCO) ?
 			 0 : BIT_OFFSET_LEN_MASK_32(2, 1));
 		rtl_write_byte(rtlpriv, 0x4fd, u1_tmp);
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/led.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/led.c
index bdaa848..7edf5af 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/led.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/led.c
@@ -67,7 +67,6 @@ void rtl92ce_sw_led_on(struct ieee80211_hw *hw, struct rtl_led *pled)
 void rtl92ce_sw_led_off(struct ieee80211_hw *hw, struct rtl_led *pled)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
 	u8 ledcfg;
 
 	RT_TRACE(rtlpriv, COMP_LED, DBG_LOUD, "LedAddr:%X ledpin=%d\n",
@@ -80,7 +79,7 @@ void rtl92ce_sw_led_off(struct ieee80211_hw *hw, struct rtl_led *pled)
 		break;
 	case LED_PIN_LED0:
 		ledcfg &= 0xf0;
-		if (pcipriv->ledctl.led_opendrain)
+		if (rtlpriv->ledctl.led_opendrain)
 			rtl_write_byte(rtlpriv, REG_LEDCFG2,
 				       (ledcfg | BIT(1) | BIT(5) | BIT(6)));
 		else
@@ -100,24 +99,26 @@ void rtl92ce_sw_led_off(struct ieee80211_hw *hw, struct rtl_led *pled)
 
 void rtl92ce_init_sw_leds(struct ieee80211_hw *hw)
 {
-	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
-	_rtl92ce_init_led(hw, &(pcipriv->ledctl.sw_led0), LED_PIN_LED0);
-	_rtl92ce_init_led(hw, &(pcipriv->ledctl.sw_led1), LED_PIN_LED1);
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+
+	_rtl92ce_init_led(hw, &rtlpriv->ledctl.sw_led0, LED_PIN_LED0);
+	_rtl92ce_init_led(hw, &rtlpriv->ledctl.sw_led1, LED_PIN_LED1);
 }
 
 static void _rtl92ce_sw_led_control(struct ieee80211_hw *hw,
 				    enum led_ctl_mode ledaction)
 {
-	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
-	struct rtl_led *pLed0 = &(pcipriv->ledctl.sw_led0);
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_led *pled0 = &rtlpriv->ledctl.sw_led0;
+
 	switch (ledaction) {
 	case LED_CTL_POWER_ON:
 	case LED_CTL_LINK:
 	case LED_CTL_NO_LINK:
-		rtl92ce_sw_led_on(hw, pLed0);
+		rtl92ce_sw_led_on(hw, pled0);
 		break;
 	case LED_CTL_POWER_OFF:
-		rtl92ce_sw_led_off(hw, pLed0);
+		rtl92ce_sw_led_off(hw, pled0);
 		break;
 	default:
 		break;
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
index 9db6ec6..f95a645 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
@@ -393,12 +393,11 @@ static void _rtl92cu_read_adapter_info(struct ieee80211_hw *hw)
 static void _rtl92cu_hal_customized_behavior(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_usb_priv *usb_priv = rtl_usbpriv(hw);
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 
 	switch (rtlhal->oem_id) {
 	case RT_CID_819X_HP:
-		usb_priv->ledctl.led_opendrain = true;
+		rtlpriv->ledctl.led_opendrain = true;
 		break;
 	case RT_CID_819X_LENOVO:
 	case RT_CID_DEFAULT:
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/led.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/led.c
index 70ea6c5..66d2784 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/led.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/led.c
@@ -67,7 +67,6 @@ void rtl92cu_sw_led_on(struct ieee80211_hw *hw, struct rtl_led *pled)
 void rtl92cu_sw_led_off(struct ieee80211_hw *hw, struct rtl_led *pled)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_usb_priv *usbpriv = rtl_usbpriv(hw);
 	u8 ledcfg;
 
 	RT_TRACE(rtlpriv, COMP_LED, DBG_LOUD, "LedAddr:%X ledpin=%d\n",
@@ -78,7 +77,7 @@ void rtl92cu_sw_led_off(struct ieee80211_hw *hw, struct rtl_led *pled)
 		break;
 	case LED_PIN_LED0:
 		ledcfg &= 0xf0;
-		if (usbpriv->ledctl.led_opendrain)
+		if (rtlpriv->ledctl.led_opendrain)
 			rtl_write_byte(rtlpriv, REG_LEDCFG2,
 				       (ledcfg | BIT(1) | BIT(5) | BIT(6)));
 		else
@@ -99,16 +98,18 @@ void rtl92cu_sw_led_off(struct ieee80211_hw *hw, struct rtl_led *pled)
 
 void rtl92cu_init_sw_leds(struct ieee80211_hw *hw)
 {
-	struct rtl_usb_priv *usbpriv = rtl_usbpriv(hw);
-	_rtl92cu_init_led(hw, &(usbpriv->ledctl.sw_led0), LED_PIN_LED0);
-	_rtl92cu_init_led(hw, &(usbpriv->ledctl.sw_led1), LED_PIN_LED1);
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+
+	_rtl92cu_init_led(hw, &rtlpriv->ledctl.sw_led0, LED_PIN_LED0);
+	_rtl92cu_init_led(hw, &rtlpriv->ledctl.sw_led1, LED_PIN_LED1);
 }
 
 void rtl92cu_deinit_sw_leds(struct ieee80211_hw *hw)
 {
-	struct rtl_usb_priv *usbpriv = rtl_usbpriv(hw);
-	_rtl92cu_deInit_led(&(usbpriv->ledctl.sw_led0));
-	_rtl92cu_deInit_led(&(usbpriv->ledctl.sw_led1));
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+
+	_rtl92cu_deInit_led(&rtlpriv->ledctl.sw_led0);
+	_rtl92cu_deInit_led(&rtlpriv->ledctl.sw_led1);
 }
 
 static void _rtl92cu_sw_led_control(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c
index 1bd1893..cf28d25 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c
@@ -614,19 +614,19 @@ static bool _rtl92de_llt_table_init(struct ieee80211_hw *hw)
 
 static void _rtl92de_gen_refresh_led_state(struct ieee80211_hw *hw)
 {
-	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
-	struct rtl_led *pLed0 = &(pcipriv->ledctl.sw_led0);
+	struct rtl_led *pled0 = &rtlpriv->ledctl.sw_led0;
 
 	if (rtlpci->up_first_time)
 		return;
 	if (ppsc->rfoff_reason == RF_CHANGE_BY_IPS)
-		rtl92de_sw_led_on(hw, pLed0);
+		rtl92de_sw_led_on(hw, pled0);
 	else if (ppsc->rfoff_reason == RF_CHANGE_BY_INIT)
-		rtl92de_sw_led_on(hw, pLed0);
+		rtl92de_sw_led_on(hw, pled0);
 	else
-		rtl92de_sw_led_off(hw, pLed0);
+		rtl92de_sw_led_off(hw, pled0);
 }
 
 static bool _rtl92de_init_mac(struct ieee80211_hw *hw)
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/led.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/led.c
index 4be787e..8851038 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/led.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/led.c
@@ -76,7 +76,6 @@ void rtl92de_sw_led_on(struct ieee80211_hw *hw, struct rtl_led *pled)
 void rtl92de_sw_led_off(struct ieee80211_hw *hw, struct rtl_led *pled)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
 	u8 ledcfg;
 
 	RT_TRACE(rtlpriv, COMP_LED, DBG_LOUD, "LedAddr:%X ledpin=%d\n",
@@ -89,7 +88,7 @@ void rtl92de_sw_led_off(struct ieee80211_hw *hw, struct rtl_led *pled)
 		break;
 	case LED_PIN_LED0:
 		ledcfg &= 0xf0;
-		if (pcipriv->ledctl.led_opendrain)
+		if (rtlpriv->ledctl.led_opendrain)
 			rtl_write_byte(rtlpriv, REG_LEDCFG2,
 				       (ledcfg | BIT(1) | BIT(5) | BIT(6)));
 		else
@@ -110,24 +109,26 @@ void rtl92de_sw_led_off(struct ieee80211_hw *hw, struct rtl_led *pled)
 
 void rtl92de_init_sw_leds(struct ieee80211_hw *hw)
 {
-	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
-	_rtl92ce_init_led(hw, &(pcipriv->ledctl.sw_led0), LED_PIN_LED0);
-	_rtl92ce_init_led(hw, &(pcipriv->ledctl.sw_led1), LED_PIN_LED1);
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+
+	_rtl92ce_init_led(hw, &rtlpriv->ledctl.sw_led0, LED_PIN_LED0);
+	_rtl92ce_init_led(hw, &rtlpriv->ledctl.sw_led1, LED_PIN_LED1);
 }
 
 static void _rtl92ce_sw_led_control(struct ieee80211_hw *hw,
 				    enum led_ctl_mode ledaction)
 {
-	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
-	struct rtl_led *pLed0 = &(pcipriv->ledctl.sw_led0);
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_led *pled0 = &rtlpriv->ledctl.sw_led0;
+
 	switch (ledaction) {
 	case LED_CTL_POWER_ON:
 	case LED_CTL_LINK:
 	case LED_CTL_NO_LINK:
-		rtl92de_sw_led_on(hw, pLed0);
+		rtl92de_sw_led_on(hw, pled0);
 		break;
 	case LED_CTL_POWER_OFF:
-		rtl92de_sw_led_off(hw, pLed0);
+		rtl92de_sw_led_off(hw, pled0);
 		break;
 	default:
 		break;
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.c
index b44244a..56ca7f5 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.c
@@ -735,9 +735,8 @@ static bool _rtl92ee_llt_table_init(struct ieee80211_hw *hw)
 static void _rtl92ee_gen_refresh_led_state(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
-	struct rtl_led *pled0 = &pcipriv->ledctl.sw_led0;
+	struct rtl_led *pled0 = &rtlpriv->ledctl.sw_led0;
 
 	if (rtlpriv->rtlhal.up_first_time)
 		return;
@@ -2166,10 +2165,9 @@ static void _rtl92ee_read_adapter_info(struct ieee80211_hw *hw)
 static void _rtl92ee_hal_customized_behavior(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 
-	pcipriv->ledctl.led_opendrain = true;
+	rtlpriv->ledctl.led_opendrain = true;
 
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
 		 "RT Customized ID: 0x%02X\n", rtlhal->oem_id);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/led.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/led.c
index 47da05d..96c6478 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/led.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/led.c
@@ -99,26 +99,26 @@ void rtl92ee_sw_led_off(struct ieee80211_hw *hw, struct rtl_led *pled)
 
 void rtl92ee_init_sw_leds(struct ieee80211_hw *hw)
 {
-	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
 
-	_rtl92ee_init_led(hw, &pcipriv->ledctl.sw_led0, LED_PIN_LED0);
-	_rtl92ee_init_led(hw, &pcipriv->ledctl.sw_led1, LED_PIN_LED1);
+	_rtl92ee_init_led(hw, &rtlpriv->ledctl.sw_led0, LED_PIN_LED0);
+	_rtl92ee_init_led(hw, &rtlpriv->ledctl.sw_led1, LED_PIN_LED1);
 }
 
 static void _rtl92ee_sw_led_control(struct ieee80211_hw *hw,
 				    enum led_ctl_mode ledaction)
 {
-	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
-	struct rtl_led *pLed0 = &pcipriv->ledctl.sw_led0;
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_led *pled0 = &rtlpriv->ledctl.sw_led0;
 
 	switch (ledaction) {
 	case LED_CTL_POWER_ON:
 	case LED_CTL_LINK:
 	case LED_CTL_NO_LINK:
-		rtl92ee_sw_led_on(hw, pLed0);
+		rtl92ee_sw_led_on(hw, pled0);
 		break;
 	case LED_CTL_POWER_OFF:
-		rtl92ee_sw_led_off(hw, pLed0);
+		rtl92ee_sw_led_off(hw, pled0);
 		break;
 	default:
 		break;
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c
index d5e86b6..ba1bd78 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c
@@ -753,13 +753,12 @@ static void _rtl92se_macconfig_before_fwdownload(struct ieee80211_hw *hw)
 	/* After MACIO reset,we must refresh LED state. */
 	if ((ppsc->rfoff_reason == RF_CHANGE_BY_IPS) ||
 	   (ppsc->rfoff_reason == 0)) {
-		struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
-		struct rtl_led *pLed0 = &(pcipriv->ledctl.sw_led0);
+		struct rtl_led *pled0 = &rtlpriv->ledctl.sw_led0;
 		enum rf_pwrstate rfpwr_state_toset;
 		rfpwr_state_toset = _rtl92se_rf_onoff_detect(hw);
 
 		if (rfpwr_state_toset == ERFON)
-			rtl92se_sw_led_on(hw, pLed0);
+			rtl92se_sw_led_on(hw, pled0);
 	}
 }
 
@@ -1395,16 +1394,15 @@ static void _rtl92se_gen_refreshledstate(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
-	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
-	struct rtl_led *pLed0 = &(pcipriv->ledctl.sw_led0);
+	struct rtl_led *pled0 = &rtlpriv->ledctl.sw_led0;
 
 	if (rtlpci->up_first_time == 1)
 		return;
 
 	if (rtlpriv->psc.rfoff_reason == RF_CHANGE_BY_IPS)
-		rtl92se_sw_led_on(hw, pLed0);
+		rtl92se_sw_led_on(hw, pled0);
 	else
-		rtl92se_sw_led_off(hw, pLed0);
+		rtl92se_sw_led_off(hw, pled0);
 }
 
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/led.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/led.c
index c740aeb..33c307a 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/led.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/led.c
@@ -38,9 +38,10 @@ static void _rtl92se_init_led(struct ieee80211_hw *hw,
 
 void rtl92se_init_sw_leds(struct ieee80211_hw *hw)
 {
-	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
-	_rtl92se_init_led(hw, &(pcipriv->ledctl.sw_led0), LED_PIN_LED0);
-	_rtl92se_init_led(hw, &(pcipriv->ledctl.sw_led1), LED_PIN_LED1);
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+
+	_rtl92se_init_led(hw, &rtlpriv->ledctl.sw_led0, LED_PIN_LED0);
+	_rtl92se_init_led(hw, &rtlpriv->ledctl.sw_led1, LED_PIN_LED1);
 }
 
 void rtl92se_sw_led_on(struct ieee80211_hw *hw, struct rtl_led *pled)
@@ -73,7 +74,6 @@ void rtl92se_sw_led_on(struct ieee80211_hw *hw, struct rtl_led *pled)
 void rtl92se_sw_led_off(struct ieee80211_hw *hw, struct rtl_led *pled)
 {
 	struct rtl_priv *rtlpriv;
-	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
 	u8 ledcfg;
 
 	rtlpriv = rtl_priv(hw);
@@ -89,7 +89,7 @@ void rtl92se_sw_led_off(struct ieee80211_hw *hw, struct rtl_led *pled)
 		break;
 	case LED_PIN_LED0:
 		ledcfg &= 0xf0;
-		if (pcipriv->ledctl.led_opendrain)
+		if (rtlpriv->ledctl.led_opendrain)
 			rtl_write_byte(rtlpriv, LEDCFG, (ledcfg | BIT(1)));
 		else
 			rtl_write_byte(rtlpriv, LEDCFG, (ledcfg | BIT(3)));
@@ -109,16 +109,17 @@ void rtl92se_sw_led_off(struct ieee80211_hw *hw, struct rtl_led *pled)
 static void _rtl92se_sw_led_control(struct ieee80211_hw *hw,
 				    enum led_ctl_mode ledaction)
 {
-	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
-	struct rtl_led *pLed0 = &(pcipriv->ledctl.sw_led0);
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_led *pled0 = &rtlpriv->ledctl.sw_led0;
+
 	switch (ledaction) {
 	case LED_CTL_POWER_ON:
 	case LED_CTL_LINK:
 	case LED_CTL_NO_LINK:
-		rtl92se_sw_led_on(hw, pLed0);
+		rtl92se_sw_led_on(hw, pled0);
 		break;
 	case LED_CTL_POWER_OFF:
-		rtl92se_sw_led_off(hw, pLed0);
+		rtl92se_sw_led_off(hw, pled0);
 		break;
 	default:
 		break;
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c
index bb9de2f..859c045 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c
@@ -664,9 +664,8 @@ static bool _rtl8723e_llt_table_init(struct ieee80211_hw *hw)
 static void _rtl8723e_gen_refresh_led_state(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
-	struct rtl_led *pled0 = &pcipriv->ledctl.sw_led0;
+	struct rtl_led *pled0 = &rtlpriv->ledctl.sw_led0;
 
 	if (rtlpriv->rtlhal.up_first_time)
 		return;
@@ -1790,13 +1789,12 @@ static void _rtl8723e_read_adapter_info(struct ieee80211_hw *hw,
 static void _rtl8723e_hal_customized_behavior(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 
-	pcipriv->ledctl.led_opendrain = true;
+	rtlpriv->ledctl.led_opendrain = true;
 	switch (rtlhal->oem_id) {
 	case RT_CID_819X_HP:
-		pcipriv->ledctl.led_opendrain = true;
+		rtlpriv->ledctl.led_opendrain = true;
 		break;
 	case RT_CID_819X_LENOVO:
 	case RT_CID_DEFAULT:
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/led.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/led.c
index e1e6d24..d567b0d 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/led.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/led.c
@@ -68,7 +68,6 @@ void rtl8723e_sw_led_on(struct ieee80211_hw *hw, struct rtl_led *pled)
 void rtl8723e_sw_led_off(struct ieee80211_hw *hw, struct rtl_led *pled)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
 	u8 ledcfg;
 
 	RT_TRACE(rtlpriv, COMP_LED, DBG_LOUD,
@@ -81,7 +80,7 @@ void rtl8723e_sw_led_off(struct ieee80211_hw *hw, struct rtl_led *pled)
 		break;
 	case LED_PIN_LED0:
 		ledcfg &= 0xf0;
-		if (pcipriv->ledctl.led_opendrain) {
+		if (rtlpriv->ledctl.led_opendrain) {
 			ledcfg &= 0x90; /* Set to software control. */
 			rtl_write_byte(rtlpriv, REG_LEDCFG2, (ledcfg|BIT(3)));
 			ledcfg = rtl_read_byte(rtlpriv, REG_MAC_PINMUX_CFG);
@@ -109,24 +108,26 @@ void rtl8723e_sw_led_off(struct ieee80211_hw *hw, struct rtl_led *pled)
 
 void rtl8723e_init_sw_leds(struct ieee80211_hw *hw)
 {
-	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
-	_rtl8723e_init_led(hw, &pcipriv->ledctl.sw_led0, LED_PIN_LED0);
-	_rtl8723e_init_led(hw, &pcipriv->ledctl.sw_led1, LED_PIN_LED1);
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+
+	_rtl8723e_init_led(hw, &rtlpriv->ledctl.sw_led0, LED_PIN_LED0);
+	_rtl8723e_init_led(hw, &rtlpriv->ledctl.sw_led1, LED_PIN_LED1);
 }
 
 static void _rtl8723e_sw_led_control(struct ieee80211_hw *hw,
 				     enum led_ctl_mode ledaction)
 {
-	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
-	struct rtl_led *pLed0 = &(pcipriv->ledctl.sw_led0);
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_led *pled0 = &rtlpriv->ledctl.sw_led0;
+
 	switch (ledaction) {
 	case LED_CTL_POWER_ON:
 	case LED_CTL_LINK:
 	case LED_CTL_NO_LINK:
-		rtl8723e_sw_led_on(hw, pLed0);
+		rtl8723e_sw_led_on(hw, pled0);
 		break;
 	case LED_CTL_POWER_OFF:
-		rtl8723e_sw_led_off(hw, pLed0);
+		rtl8723e_sw_led_off(hw, pled0);
 		break;
 	default:
 		break;
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
index e6e5e5b..1acbfb8 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
@@ -809,9 +809,8 @@ static bool _rtl8723be_llt_table_init(struct ieee80211_hw *hw)
 static void _rtl8723be_gen_refresh_led_state(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
-	struct rtl_led *pled0 = &(pcipriv->ledctl.sw_led0);
+	struct rtl_led *pled0 = &rtlpriv->ledctl.sw_led0;
 
 	if (rtlpriv->rtlhal.up_first_time)
 		return;
@@ -2228,13 +2227,12 @@ static void _rtl8723be_read_adapter_info(struct ieee80211_hw *hw,
 static void _rtl8723be_hal_customized_behavior(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 
-	pcipriv->ledctl.led_opendrain = true;
+	rtlpriv->ledctl.led_opendrain = true;
 	switch (rtlhal->oem_id) {
 	case RT_CID_819X_HP:
-		pcipriv->ledctl.led_opendrain = true;
+		rtlpriv->ledctl.led_opendrain = true;
 		break;
 	case RT_CID_819X_LENOVO:
 	case RT_CID_DEFAULT:
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/led.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/led.c
index 8232e01..4f7890d 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/led.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/led.c
@@ -67,7 +67,6 @@ void rtl8723be_sw_led_on(struct ieee80211_hw *hw, struct rtl_led *pled)
 void rtl8723be_sw_led_off(struct ieee80211_hw *hw, struct rtl_led *pled)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
 	u8 ledcfg;
 
 	RT_TRACE(rtlpriv, COMP_LED, DBG_LOUD,
@@ -80,7 +79,7 @@ void rtl8723be_sw_led_off(struct ieee80211_hw *hw, struct rtl_led *pled)
 		break;
 	case LED_PIN_LED0:
 		ledcfg &= 0xf0;
-		if (pcipriv->ledctl.led_opendrain) {
+		if (rtlpriv->ledctl.led_opendrain) {
 			ledcfg &= 0x90; /* Set to software control. */
 			rtl_write_byte(rtlpriv, REG_LEDCFG2, (ledcfg|BIT(3)));
 			ledcfg = rtl_read_byte(rtlpriv, REG_MAC_PINMUX_CFG);
@@ -108,16 +107,18 @@ void rtl8723be_sw_led_off(struct ieee80211_hw *hw, struct rtl_led *pled)
 
 void rtl8723be_init_sw_leds(struct ieee80211_hw *hw)
 {
-	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
-	_rtl8723be_init_led(hw, &(pcipriv->ledctl.sw_led0), LED_PIN_LED0);
-	_rtl8723be_init_led(hw, &(pcipriv->ledctl.sw_led1), LED_PIN_LED1);
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+
+	_rtl8723be_init_led(hw, &rtlpriv->ledctl.sw_led0, LED_PIN_LED0);
+	_rtl8723be_init_led(hw, &rtlpriv->ledctl.sw_led1, LED_PIN_LED1);
 }
 
 static void _rtl8723be_sw_led_control(struct ieee80211_hw *hw,
 				      enum led_ctl_mode ledaction)
 {
-	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
-	struct rtl_led *pled0 = &(pcipriv->ledctl.sw_led0);
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_led *pled0 = &rtlpriv->ledctl.sw_led0;
+
 	switch (ledaction) {
 	case LED_CTL_POWER_ON:
 	case LED_CTL_LINK:
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
index 4f83eee..363d2f2 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
@@ -890,9 +890,8 @@ static bool _rtl8821ae_llt_table_init(struct ieee80211_hw *hw)
 static void _rtl8821ae_gen_refresh_led_state(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
-	struct rtl_led *pled0 = &pcipriv->ledctl.sw_led0;
+	struct rtl_led *pled0 = &rtlpriv->ledctl.sw_led0;
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 
 	if (rtlpriv->rtlhal.up_first_time)
@@ -3098,7 +3097,6 @@ static void _rtl8821ae_read_adapter_info(struct ieee80211_hw *hw, bool b_pseudo_
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
-	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
 	int params[] = {RTL_EEPROM_ID, EEPROM_VID, EEPROM_DID,
 			EEPROM_SVID, EEPROM_SMID, EEPROM_MAC_ADDR,
 			EEPROM_CHANNELPLAN, EEPROM_VERSION, EEPROM_CUSTOMER_ID,
@@ -3193,7 +3191,7 @@ static void _rtl8821ae_read_adapter_info(struct ieee80211_hw *hw, bool b_pseudo_
 		"SWAS: bHwAntDiv = %x, TRxAntDivType = %x\n",
 		rtlefuse->antenna_div_cfg, rtlefuse->antenna_div_type);
 
-	pcipriv->ledctl.led_opendrain = true;
+	rtlpriv->ledctl.led_opendrain = true;
 
 	if (rtlhal->oem_id == RT_CID_DEFAULT) {
 		switch (rtlefuse->eeprom_oemid) {
@@ -3224,10 +3222,10 @@ static void _rtl8821ae_read_adapter_info(struct ieee80211_hw *hw, bool b_pseudo_
 	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 
-	pcipriv->ledctl.led_opendrain = true;
+	rtlpriv->ledctl.led_opendrain = true;
 	switch (rtlhal->oem_id) {
 	case RT_CID_819X_HP:
-		pcipriv->ledctl.led_opendrain = true;
+		rtlpriv->ledctl.led_opendrain = true;
 		break;
 	case RT_CID_819X_LENOVO:
 	case RT_CID_DEFAULT:
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/led.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/led.c
index fcb3b28..405c754 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/led.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/led.c
@@ -101,7 +101,6 @@ void rtl8812ae_sw_led_on(struct ieee80211_hw *hw, struct rtl_led *pled)
 void rtl8821ae_sw_led_off(struct ieee80211_hw *hw, struct rtl_led *pled)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
 	u8 ledcfg;
 
 	RT_TRACE(rtlpriv, COMP_LED, DBG_LOUD,
@@ -114,7 +113,7 @@ void rtl8821ae_sw_led_off(struct ieee80211_hw *hw, struct rtl_led *pled)
 		break;
 	case LED_PIN_LED0:
 		ledcfg &= 0xf0;
-		if (pcipriv->ledctl.led_opendrain) {
+		if (rtlpriv->ledctl.led_opendrain) {
 			ledcfg &= 0x90; /* Set to software control. */
 			rtl_write_byte(rtlpriv, REG_LEDCFG2, (ledcfg|BIT(3)));
 			ledcfg = rtl_read_byte(rtlpriv, REG_MAC_PINMUX_CFG);
@@ -143,7 +142,6 @@ void rtl8812ae_sw_led_off(struct ieee80211_hw *hw, struct rtl_led *pled)
 {
 	u16 ledreg = REG_LEDCFG1;
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
 
 	switch (pled->ledpin) {
 	case LED_PIN_LED0:
@@ -163,7 +161,7 @@ void rtl8812ae_sw_led_off(struct ieee80211_hw *hw, struct rtl_led *pled)
 		 "In SwLedOff,LedAddr:%X LEDPIN=%d\n",
 		 ledreg, pled->ledpin);
 	/*Open-drain arrangement for controlling the LED*/
-	if (pcipriv->ledctl.led_opendrain) {
+	if (rtlpriv->ledctl.led_opendrain) {
 		u8 ledcfg = rtl_read_byte(rtlpriv, ledreg);
 
 		ledreg &= 0xd0; /* Set to software control.*/
@@ -182,17 +180,17 @@ void rtl8812ae_sw_led_off(struct ieee80211_hw *hw, struct rtl_led *pled)
 
 void rtl8821ae_init_sw_leds(struct ieee80211_hw *hw)
 {
-	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
 
-	_rtl8821ae_init_led(hw, &pcipriv->ledctl.sw_led0, LED_PIN_LED0);
-	_rtl8821ae_init_led(hw, &pcipriv->ledctl.sw_led1, LED_PIN_LED1);
+	_rtl8821ae_init_led(hw, &rtlpriv->ledctl.sw_led0, LED_PIN_LED0);
+	_rtl8821ae_init_led(hw, &rtlpriv->ledctl.sw_led1, LED_PIN_LED1);
 }
 
 static void _rtl8821ae_sw_led_control(struct ieee80211_hw *hw,
 				      enum led_ctl_mode ledaction)
 {
-	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
-	struct rtl_led *pLed0 = &pcipriv->ledctl.sw_led0;
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_led *pled0 = &rtlpriv->ledctl.sw_led0;
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 
 	switch (ledaction) {
@@ -200,15 +198,15 @@ static void _rtl8821ae_sw_led_control(struct ieee80211_hw *hw,
 	case LED_CTL_LINK:
 	case LED_CTL_NO_LINK:
 		if (rtlhal->hw_type == HARDWARE_TYPE_RTL8812AE)
-			rtl8812ae_sw_led_on(hw, pLed0);
+			rtl8812ae_sw_led_on(hw, pled0);
 		else
-			rtl8821ae_sw_led_on(hw, pLed0);
+			rtl8821ae_sw_led_on(hw, pled0);
 		break;
 	case LED_CTL_POWER_OFF:
 		if (rtlhal->hw_type == HARDWARE_TYPE_RTL8812AE)
-			rtl8812ae_sw_led_off(hw, pLed0);
+			rtl8812ae_sw_led_off(hw, pled0);
 		else
-			rtl8821ae_sw_led_off(hw, pLed0);
+			rtl8821ae_sw_led_off(hw, pled0);
 		break;
 	default:
 		break;
diff --git a/drivers/net/wireless/realtek/rtlwifi/usb.h b/drivers/net/wireless/realtek/rtlwifi/usb.h
index cdb9e06..c91cec0 100644
--- a/drivers/net/wireless/realtek/rtlwifi/usb.h
+++ b/drivers/net/wireless/realtek/rtlwifi/usb.h
@@ -147,7 +147,6 @@ struct rtl_usb {
 
 struct rtl_usb_priv {
 	struct bt_coexist_info bt_coexist;
-	struct rtl_led_ctl ledctl;
 	struct rtl_usb dev;
 };
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index e464722..c0d2601 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -2587,6 +2587,7 @@ struct rtl_priv {
 	struct rtl_dm dm;
 	struct rtl_security sec;
 	struct rtl_efuse efuse;
+	struct rtl_led_ctl ledctl;
 
 	struct rtl_ps_ctl psc;
 	struct rate_adaptive ra;
-- 
2.10.2
