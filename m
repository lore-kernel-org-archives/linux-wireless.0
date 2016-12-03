Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:36003 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753060AbcLCRcd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 3 Dec 2016 12:32:33 -0500
Received: by mail-oi0-f66.google.com with SMTP id u15so31484777oie.3
        for <linux-wireless@vger.kernel.org>; Sat, 03 Dec 2016 09:32:33 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 6/7] rtlwifi: Add btcoex record_pwr_mode
Date: Sat,  3 Dec 2016 11:32:06 -0600
Message-Id: <20161203173207.17774-7-Larry.Finger@lwfinger.net> (sfid-20161203_183244_051660_C5F11BD6)
In-Reply-To: <20161203173207.17774-1-Larry.Finger@lwfinger.net>
References: <20161203173207.17774-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

Add code to set the power mode bits in the descriptor. These bits are
valid in RTL8723BE, RTL8821AE, RTL8812AE, and RTL8192EE.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 .../wireless/realtek/rtlwifi/btcoexist/rtl_btc.c   | 13 +++++++++
 .../wireless/realtek/rtlwifi/btcoexist/rtl_btc.h   |  1 +
 .../net/wireless/realtek/rtlwifi/rtl8192ee/fw.c    |  6 +++-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/fw.h    |  4 ++-
 .../net/wireless/realtek/rtlwifi/rtl8723be/fw.c    |  6 +++-
 .../net/wireless/realtek/rtlwifi/rtl8723be/fw.h    | 23 +++++++++------
 .../net/wireless/realtek/rtlwifi/rtl8821ae/fw.c    |  6 +++-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/fw.h    | 33 ++++++++++++----------
 drivers/net/wireless/realtek/rtlwifi/wifi.h        |  1 +
 9 files changed, 65 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c
index b1f0f2b..b1f8fd2 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c
@@ -46,8 +46,21 @@ static struct rtl_btc_ops rtl_btc_operation = {
 	.btc_is_disable_edca_turbo = rtl_btc_is_disable_edca_turbo,
 	.btc_is_bt_disabled = rtl_btc_is_bt_disabled,
 	.btc_special_packet_notify = rtl_btc_special_packet_notify,
+	.btc_record_pwr_mode = rtl_btc_record_pwr_mode,
 };
 
+void rtl_btc_record_pwr_mode(struct rtl_priv *rtlpriv, u8 *buf, u8 len)
+{
+	u8 safe_len;
+
+	safe_len = sizeof(gl_bt_coexist.pwr_mode_val);
+
+	if (safe_len > len)
+		safe_len = len;
+
+	memcpy(gl_bt_coexist.pwr_mode_val, buf, safe_len);
+}
+
 void rtl_btc_init_variables(struct rtl_priv *rtlpriv)
 {
 	exhalbtc_initlize_variables();
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.h
index 08e50f8..d145909 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.h
@@ -44,6 +44,7 @@ bool rtl_btc_is_limited_dig(struct rtl_priv *rtlpriv);
 bool rtl_btc_is_disable_edca_turbo(struct rtl_priv *rtlpriv);
 bool rtl_btc_is_bt_disabled(struct rtl_priv *rtlpriv);
 void rtl_btc_special_packet_notify(struct rtl_priv *rtlpriv, u8 pkt_type);
+void rtl_btc_record_pwr_mode(struct rtl_priv *rtlpriv, u8 *buf, u8 len);
 
 struct rtl_btc_ops *rtl_btc_get_ops_pointer(void);
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c
index 4fc8dee..77edf0d 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c
@@ -500,7 +500,7 @@ void rtl92ee_set_fw_pwrmode_cmd(struct ieee80211_hw *hw, u8 mode)
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	u8 u1_h2c_set_pwrmode[H2C_92E_PWEMODE_LENGTH] = { 0 };
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
-	u8 rlbm , power_state = 0;
+	u8 rlbm, power_state = 0, byte5 = 0x40;
 
 	RT_TRACE(rtlpriv, COMP_POWER, DBG_LOUD , "FW LPS mode = %d\n", mode);
 
@@ -518,10 +518,14 @@ void rtl92ee_set_fw_pwrmode_cmd(struct ieee80211_hw *hw, u8 mode)
 	else
 		power_state |= FW_PWR_STATE_RF_OFF;
 	SET_H2CCMD_PWRMODE_PARM_PWR_STATE(u1_h2c_set_pwrmode, power_state);
+	SET_H2CCMD_PWRMODE_PARM_BYTE5(u1_h2c_set_pwrmode, byte5);
 
 	RT_PRINT_DATA(rtlpriv, COMP_CMD, DBG_DMESG,
 		      "rtl92c_set_fw_pwrmode(): u1_h2c_set_pwrmode\n",
 		      u1_h2c_set_pwrmode, H2C_92E_PWEMODE_LENGTH);
+	rtlpriv->btcoexist.btc_ops->btc_record_pwr_mode(rtlpriv,
+							u1_h2c_set_pwrmode,
+							H2C_92E_PWEMODE_LENGTH);
 	rtl92ee_fill_h2c_cmd(hw, H2C_92E_SETPWRMODE, H2C_92E_PWEMODE_LENGTH,
 			     u1_h2c_set_pwrmode);
 }
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.h
index 72da3f9..7dcb57a 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.h
@@ -37,7 +37,7 @@
 #define USE_OLD_WOWLAN_DEBUG_FW 0
 
 #define H2C_92E_RSVDPAGE_LOC_LEN		5
-#define H2C_92E_PWEMODE_LENGTH			5
+#define H2C_92E_PWEMODE_LENGTH			7
 #define H2C_92E_JOINBSSRPT_LENGTH		1
 #define H2C_92E_AP_OFFLOAD_LENGTH		3
 #define H2C_92E_WOWLAN_LENGTH			3
@@ -154,6 +154,8 @@ enum rtl8192e_c2h_evt {
 	SET_BITS_TO_LE_1BYTE((__cmd)+3, 0, 8, __val)
 #define SET_H2CCMD_PWRMODE_PARM_PWR_STATE(__cmd, __val)		\
 	SET_BITS_TO_LE_1BYTE((__cmd)+4, 0, 8, __val)
+#define SET_H2CCMD_PWRMODE_PARM_BYTE5(__cmd, __val)		\
+	SET_BITS_TO_LE_1BYTE((__cmd) + 5, 0, 8, __val)
 #define GET_92E_H2CCMD_PWRMODE_PARM_MODE(__cmd)			\
 	LE_BITS_TO_1BYTE(__cmd, 0, 8)
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/fw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/fw.c
index 83e27ca..cacbac7 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/fw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/fw.c
@@ -241,7 +241,7 @@ void rtl8723be_set_fw_pwrmode_cmd(struct ieee80211_hw *hw, u8 mode)
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	u8 u1_h2c_set_pwrmode[H2C_PWEMODE_LENGTH] = { 0 };
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
-	u8 rlbm, power_state = 0;
+	u8 rlbm, power_state = 0, byte5 = 0x40;
 	RT_TRACE(rtlpriv, COMP_POWER, DBG_LOUD, "FW LPS mode = %d\n", mode);
 
 	SET_H2CCMD_PWRMODE_PARM_MODE(u1_h2c_set_pwrmode, ((mode) ? 1 : 0));
@@ -258,10 +258,14 @@ void rtl8723be_set_fw_pwrmode_cmd(struct ieee80211_hw *hw, u8 mode)
 	else
 		power_state |= FW_PWR_STATE_RF_OFF;
 	SET_H2CCMD_PWRMODE_PARM_PWR_STATE(u1_h2c_set_pwrmode, power_state);
+	SET_H2CCMD_PWRMODE_PARM_BYTE5(u1_h2c_set_pwrmode, byte5);
 
 	RT_PRINT_DATA(rtlpriv, COMP_CMD, DBG_DMESG,
 		      "rtl92c_set_fw_pwrmode(): u1_h2c_set_pwrmode\n",
 		      u1_h2c_set_pwrmode, H2C_PWEMODE_LENGTH);
+	rtlpriv->btcoexist.btc_ops->btc_record_pwr_mode(rtlpriv,
+							u1_h2c_set_pwrmode,
+							H2C_PWEMODE_LENGTH);
 	rtl8723be_fill_h2c_cmd(hw, H2C_8723B_SETPWRMODE, H2C_PWEMODE_LENGTH,
 			       u1_h2c_set_pwrmode);
 }
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/fw.h b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/fw.h
index c652fa1..990a116 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/fw.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/fw.h
@@ -33,7 +33,7 @@
 
 #define USE_OLD_WOWLAN_DEBUG_FW			0
 
-#define H2C_PWEMODE_LENGTH			5
+#define H2C_PWEMODE_LENGTH			7
 
 /* Fw PS state for RPWM.
 *BIT[2:0] = HW state
@@ -116,15 +116,17 @@ enum rtl8723b_c2h_evt {
 #define SET_H2CCMD_PWRMODE_PARM_MODE(__ph2ccmd, __val)			\
 	SET_BITS_TO_LE_1BYTE(__ph2ccmd, 0, 8, __val)
 #define SET_H2CCMD_PWRMODE_PARM_RLBM(__ph2ccmd, __val)			\
-	SET_BITS_TO_LE_1BYTE((__ph2ccmd)+1, 0, 4, __val)
+	SET_BITS_TO_LE_1BYTE((__ph2ccmd) + 1, 0, 4, __val)
 #define SET_H2CCMD_PWRMODE_PARM_SMART_PS(__ph2ccmd, __val)		\
-	SET_BITS_TO_LE_1BYTE((__ph2ccmd)+1, 4, 4, __val)
+	SET_BITS_TO_LE_1BYTE((__ph2ccmd) + 1, 4, 4, __val)
 #define SET_H2CCMD_PWRMODE_PARM_AWAKE_INTERVAL(__ph2ccmd, __val)	\
-	SET_BITS_TO_LE_1BYTE((__ph2ccmd)+2, 0, 8, __val)
+	SET_BITS_TO_LE_1BYTE((__ph2ccmd) + 2, 0, 8, __val)
 #define SET_H2CCMD_PWRMODE_PARM_ALL_QUEUE_UAPSD(__ph2ccmd, __val)	\
-	SET_BITS_TO_LE_1BYTE((__ph2ccmd)+3, 0, 8, __val)
+	SET_BITS_TO_LE_1BYTE((__ph2ccmd) + 3, 0, 8, __val)
 #define SET_H2CCMD_PWRMODE_PARM_PWR_STATE(__ph2ccmd, __val)		\
-	SET_BITS_TO_LE_1BYTE((__ph2ccmd)+4, 0, 8, __val)
+	SET_BITS_TO_LE_1BYTE((__ph2ccmd) + 4, 0, 8, __val)
+#define SET_H2CCMD_PWRMODE_PARM_BYTE5(__ph2ccmd, __val)			\
+	SET_BITS_TO_LE_1BYTE((__ph2ccmd) + 5, 0, 8, __val)
 #define GET_88E_H2CCMD_PWRMODE_PARM_MODE(__ph2ccmd)			\
 	LE_BITS_TO_1BYTE(__ph2ccmd, 0, 8)
 
@@ -136,10 +138,13 @@ enum rtl8723b_c2h_evt {
 #define SET_H2CCMD_RSVDPAGE_LOC_PROBE_RSP(__ph2ccmd, __val)		\
 	SET_BITS_TO_LE_1BYTE(__ph2ccmd, 0, 8, __val)
 #define SET_H2CCMD_RSVDPAGE_LOC_PSPOLL(__ph2ccmd, __val)		\
-	SET_BITS_TO_LE_1BYTE((__ph2ccmd)+1, 0, 8, __val)
+	SET_BITS_TO_LE_1BYTE((__ph2ccmd) + 1, 0, 8, __val)
 #define SET_H2CCMD_RSVDPAGE_LOC_NULL_DATA(__ph2ccmd, __val)		\
-	SET_BITS_TO_LE_1BYTE((__ph2ccmd)+2, 0, 8, __val)
-
+	SET_BITS_TO_LE_1BYTE((__ph2ccmd) + 2, 0, 8, __val)
+#define SET_H2CCMD_RSVDPAGE_LOC_QOS_NULL_DATA(__ph2ccmd, __val)	\
+	SET_BITS_TO_LE_1BYTE((__ph2ccmd) + 3, 0, 8, __val)
+#define SET_H2CCMD_RSVDPAGE_LOC_BT_QOS_NULL_DATA(__ph2ccmd, __val)	\
+	SET_BITS_TO_LE_1BYTE((__ph2ccmd) + 4, 0, 8, __val)
 
 void rtl8723be_fill_h2c_cmd(struct ieee80211_hw *hw, u8 element_id,
 			    u32 cmd_len, u8 *p_cmdbuffer);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c
index 7112d65..0ce65ef 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c
@@ -558,7 +558,7 @@ void rtl8821ae_set_fw_pwrmode_cmd(struct ieee80211_hw *hw, u8 mode)
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	u8 u1_h2c_set_pwrmode[H2C_8821AE_PWEMODE_LENGTH] = { 0 };
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
-	u8 rlbm, power_state = 0;
+	u8 rlbm, power_state = 0, byte5 = 0x40;
 
 	RT_TRACE(rtlpriv, COMP_POWER, DBG_LOUD, "FW LPS mode = %d\n", mode);
 
@@ -577,10 +577,14 @@ void rtl8821ae_set_fw_pwrmode_cmd(struct ieee80211_hw *hw, u8 mode)
 		power_state |= FW_PWR_STATE_RF_OFF;
 
 	SET_H2CCMD_PWRMODE_PARM_PWR_STATE(u1_h2c_set_pwrmode, power_state);
+	SET_H2CCMD_PWRMODE_PARM_BYTE5(u1_h2c_set_pwrmode, byte5);
 
 	RT_PRINT_DATA(rtlpriv, COMP_CMD, DBG_DMESG,
 		      "rtl92c_set_fw_pwrmode(): u1_h2c_set_pwrmode\n",
 		      u1_h2c_set_pwrmode, H2C_8821AE_PWEMODE_LENGTH);
+	rtlpriv->btcoexist.btc_ops->btc_record_pwr_mode(rtlpriv,
+							u1_h2c_set_pwrmode,
+						H2C_8821AE_PWEMODE_LENGTH);
 	rtl8821ae_fill_h2c_cmd(hw, H2C_8821AE_SETPWRMODE,
 			       H2C_8821AE_PWEMODE_LENGTH,
 			       u1_h2c_set_pwrmode);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.h b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.h
index 90a98ed..f7ffc330 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.h
@@ -42,7 +42,7 @@
 #define USE_OLD_WOWLAN_DEBUG_FW 0
 
 #define H2C_8821AE_RSVDPAGE_LOC_LEN		5
-#define H2C_8821AE_PWEMODE_LENGTH			5
+#define H2C_8821AE_PWEMODE_LENGTH			7
 #define H2C_8821AE_JOINBSSRPT_LENGTH		1
 #define H2C_8821AE_AP_OFFLOAD_LENGTH		3
 #define H2C_8821AE_WOWLAN_LENGTH			3
@@ -218,6 +218,8 @@ enum rtl8821a_h2c_cmd {
 	SET_BITS_TO_LE_1BYTE((__cmd)+3, 0, 8, __value)
 #define SET_H2CCMD_PWRMODE_PARM_PWR_STATE(__cmd, __value)	\
 	SET_BITS_TO_LE_1BYTE((__cmd)+4, 0, 8, __value)
+#define SET_H2CCMD_PWRMODE_PARM_BYTE5(__cmd, __value)		\
+	SET_BITS_TO_LE_1BYTE((__cmd) + 5, 0, 8, __value)
 #define GET_8821AE_H2CCMD_PWRMODE_PARM_MODE(__cmd)		\
 	LE_BITS_TO_1BYTE(__cmd, 0, 8)
 
@@ -236,19 +238,19 @@ enum rtl8821a_h2c_cmd {
 #define SET_H2CCMD_MSRRPT_PARM_MACID_IND(__cmd, __value)	\
 	SET_BITS_TO_LE_1BYTE(__cmd, 1, 1, __value)
 #define SET_H2CCMD_MSRRPT_PARM_MACID(__cmd, __value)	\
-	SET_BITS_TO_LE_1BYTE(__cmd+1, 0, 8, __value)
+	SET_BITS_TO_LE_1BYTE(__cmd + 1, 0, 8, __value)
 #define SET_H2CCMD_MSRRPT_PARM_MACID_END(__cmd, __value)	\
-	SET_BITS_TO_LE_1BYTE(__cmd+2, 0, 8, __value)
+	SET_BITS_TO_LE_1BYTE(__cmd + 2, 0, 8, __value)
 
 /* AP_OFFLOAD */
 #define SET_H2CCMD_AP_OFFLOAD_ON(__cmd, __value)	\
 	SET_BITS_TO_LE_1BYTE(__cmd, 0, 8, __value)
 #define SET_H2CCMD_AP_OFFLOAD_HIDDEN(__cmd, __value)	\
-	SET_BITS_TO_LE_1BYTE((__cmd)+1, 0, 8, __value)
+	SET_BITS_TO_LE_1BYTE((__cmd) + 1, 0, 8, __value)
 #define SET_H2CCMD_AP_OFFLOAD_DENYANY(__cmd, __value)	\
-	SET_BITS_TO_LE_1BYTE((__cmd)+2, 0, 8, __value)
+	SET_BITS_TO_LE_1BYTE((__cmd) + 2, 0, 8, __value)
 #define SET_H2CCMD_AP_OFFLOAD_WAKEUP_EVT_RPT(__cmd, __value) \
-	SET_BITS_TO_LE_1BYTE((__cmd)+3, 0, 8, __value)
+	SET_BITS_TO_LE_1BYTE((__cmd) + 3, 0, 8, __value)
 
 /* Keep Alive Control*/
 #define SET_8812_H2CCMD_KEEP_ALIVE_ENABLE(__cmd, __value)	\
@@ -256,7 +258,7 @@ enum rtl8821a_h2c_cmd {
 #define SET_8812_H2CCMD_KEEP_ALIVE_ACCPEPT_USER_DEFINED(__cmd, __value)	\
 	SET_BITS_TO_LE_1BYTE(__cmd, 1, 1, __value)
 #define SET_8812_H2CCMD_KEEP_ALIVE_PERIOD(__cmd, __value)	\
-	SET_BITS_TO_LE_1BYTE((__cmd)+1, 0, 8, __value)
+	SET_BITS_TO_LE_1BYTE((__cmd) + 1, 0, 8, __value)
 
 /*REMOTE_WAKE_CTRL */
 #define SET_8812_H2CCMD_REMOTE_WAKECTRL_ENABLE(__cmd, __value)	\
@@ -274,31 +276,32 @@ enum rtl8821a_h2c_cmd {
 #define SET_8812_H2CCMD_AOAC_GLOBAL_INFO_PAIRWISE_ENC_ALG(__cmd, __value)\
 	SET_BITS_TO_LE_1BYTE(__cmd, 0, 8, __value)
 #define SET_8812_H2CCMD_AOAC_GLOBAL_INFO_GROUP_ENC_ALG(__cmd, __value)	\
-	SET_BITS_TO_LE_1BYTE((__cmd)+1, 0, 8, __value)
+	SET_BITS_TO_LE_1BYTE((__cmd) + 1, 0, 8, __value)
 
 /* AOAC_RSVDPAGE_LOC */
 #define SET_8821AE_H2CCMD_AOAC_RSVDPAGE_LOC_REMOTE_WAKE_CTRL_INFO(__cmd, __value)	\
 	SET_BITS_TO_LE_1BYTE((__cmd), 0, 8, __value)
 #define SET_8821AE_H2CCMD_AOAC_RSVDPAGE_LOC_ARP_RSP(__cmd, __value)	\
-	SET_BITS_TO_LE_1BYTE((__cmd)+1, 0, 8, __value)
+	SET_BITS_TO_LE_1BYTE((__cmd) + 1, 0, 8, __value)
 #define SET_8821AE_H2CCMD_AOAC_RSVDPAGE_LOC_NEIGHBOR_ADV(__cmd, __value)\
-	SET_BITS_TO_LE_1BYTE((__cmd)+2, 0, 8, __value)
+	SET_BITS_TO_LE_1BYTE((__cmd) + 2, 0, 8, __value)
 #define SET_8821AE_H2CCMD_AOAC_RSVDPAGE_LOC_GTK_RSP(__cmd, __value)	\
-	SET_BITS_TO_LE_1BYTE((__cmd)+3, 0, 8, __value)
+	SET_BITS_TO_LE_1BYTE((__cmd) + 3, 0, 8, __value)
 #define SET_8821AE_H2CCMD_AOAC_RSVDPAGE_LOC_GTK_INFO(__cmd, __value)	\
-	SET_BITS_TO_LE_1BYTE((__cmd)+4, 0, 8, __value)
+	SET_BITS_TO_LE_1BYTE((__cmd) + 4, 0, 8, __value)
 #define SET_8821AE_H2CCMD_AOAC_RSVDPAGE_LOC_GTK_EXT_MEM(__cmd, __value)	\
-	SET_BITS_TO_LE_1BYTE((__cmd)+5, 0, 8, __value)
+	SET_BITS_TO_LE_1BYTE((__cmd) + 5, 0, 8, __value)
 
 /* Disconnect_Decision_Control */
 #define SET_8812_H2CCMD_DISCONNECT_DECISION_CTRL_ENABLE(__cmd, __value)	\
 	SET_BITS_TO_LE_1BYTE(__cmd, 0, 1, __value)
 #define SET_8812_H2CCMD_DISCONNECT_DECISION_CTRL_USER_SETTING(__cmd, __value)\
 	SET_BITS_TO_LE_1BYTE(__cmd, 1, 1, __value)
+/* unit: beacon period */
 #define SET_8812_H2CCMD_DISCONNECT_DECISION_CTRL_CHECK_PERIOD(__cmd, __value)\
-	SET_BITS_TO_LE_1BYTE((__cmd)+1, 0, 8, __value) /* unit: beacon period */
+	SET_BITS_TO_LE_1BYTE((__cmd) + 1, 0, 8, __value)
 #define SET_8812_H2CCMD_DISCONNECT_DECISION_CTRL_TRYPKT_NUM(__cmd, __value)\
-	SET_BITS_TO_LE_1BYTE((__cmd)+2, 0, 8, __value)
+	SET_BITS_TO_LE_1BYTE((__cmd) + 2, 0, 8, __value)
 
 int rtl8821ae_download_fw(struct ieee80211_hw *hw, bool buse_wake_on_wlan_fw);
 #if (USE_SPECIFIC_FW_TO_SUPPORT_WOWLAN == 1)
diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index 13070bc..783e08f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -2564,6 +2564,7 @@ struct rtl_btc_ops {
 	bool (*btc_is_bt_disabled) (struct rtl_priv *rtlpriv);
 	void (*btc_special_packet_notify)(struct rtl_priv *rtlpriv,
 					  u8 pkt_type);
+	void (*btc_record_pwr_mode)(struct rtl_priv *rtlpriv, u8 *buf, u8 len);
 };
 
 struct proxim {
-- 
2.10.2
