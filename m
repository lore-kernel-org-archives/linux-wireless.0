Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:34547 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752843AbcLCRce (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 3 Dec 2016 12:32:34 -0500
Received: by mail-oi0-f66.google.com with SMTP id m75so31541761oig.1
        for <linux-wireless@vger.kernel.org>; Sat, 03 Dec 2016 09:32:34 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 7/7] rtlwifi: btcoexist control to enter/leave LPS
Date: Sat,  3 Dec 2016 11:32:07 -0600
Message-Id: <20161203173207.17774-8-Larry.Finger@lwfinger.net> (sfid-20161203_183247_677781_C33C8ADC)
In-Reply-To: <20161203173207.17774-1-Larry.Finger@lwfinger.net>
References: <20161203173207.17774-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

Bluetooth coexistence needs to be able to control the power-save
state. This patch turns the building of btcoexist back on.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/realtek/rtlwifi/base.c        |  8 +++
 .../wireless/realtek/rtlwifi/btcoexist/Makefile    |  2 +
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.c       |  7 ++-
 .../wireless/realtek/rtlwifi/btcoexist/rtl_btc.c   | 18 ++++++
 .../wireless/realtek/rtlwifi/btcoexist/rtl_btc.h   |  3 +
 .../net/wireless/realtek/rtlwifi/rtl8192ee/fw.c    | 63 ++++++++++++++++++---
 .../net/wireless/realtek/rtlwifi/rtl8723be/fw.c    | 64 +++++++++++++++++++---
 .../net/wireless/realtek/rtlwifi/rtl8821ae/fw.c    | 64 +++++++++++++++++++---
 drivers/net/wireless/realtek/rtlwifi/wifi.h        |  8 +--
 9 files changed, 206 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
index a1cfec3..d0aa23c 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.c
+++ b/drivers/net/wireless/realtek/rtlwifi/base.c
@@ -1758,12 +1758,20 @@ void rtl_watchdog_wq_callback(void *data)
 									false;
 		}
 
+		/* PS is controlled by coex. */
+		if (rtlpriv->cfg->ops->get_btc_status() &&
+		    rtlpriv->btcoexist.btc_ops->btc_is_bt_ctrl_lps(rtlpriv))
+			goto label_lps_done;
+
 		if (((rtlpriv->link_info.num_rx_inperiod +
 		      rtlpriv->link_info.num_tx_inperiod) > 8) ||
 		    (rtlpriv->link_info.num_rx_inperiod > 2))
 			rtl_lps_leave(hw);
 		else
 			rtl_lps_enter(hw);
+
+label_lps_done:
+		;
 	}
 
 	rtlpriv->link_info.num_rx_inperiod = 0;
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/Makefile b/drivers/net/wireless/realtek/rtlwifi/btcoexist/Makefile
index c7df4e6..3657e8b 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/Makefile
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/Makefile
@@ -6,5 +6,7 @@ btcoexist-objs :=	halbtc8192e2ant.o	\
 			halbtcoutsrc.o		\
 			rtl_btc.o
 
+obj-$(CONFIG_RTLBTCOEXIST) += btcoexist.o
+
 ccflags-y += -D__CHECK_ENDIAN__
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
index 6e0c0af..c50d5c4 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
@@ -276,14 +276,19 @@ static void halbtc_enter_lps(struct btc_coexist *btcoexist)
 	}
 
 	btcoexist->bt_info.bt_ctrl_lps = true;
-	btcoexist->bt_info.bt_lps_on = false;
+	btcoexist->bt_info.bt_lps_on = true;
 	rtl_lps_enter(rtlpriv->mac80211.hw);
 }
 
 static void halbtc_normal_lps(struct btc_coexist *btcoexist)
 {
+	struct rtl_priv *rtlpriv;
+
+	rtlpriv = btcoexist->adapter;
+
 	if (btcoexist->bt_info.bt_ctrl_lps) {
 		btcoexist->bt_info.bt_lps_on = false;
+		rtl_lps_leave(rtlpriv->mac80211.hw);
 		btcoexist->bt_info.bt_ctrl_lps = false;
 	}
 }
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c
index b1f8fd2..0b70d35 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c
@@ -47,6 +47,9 @@ static struct rtl_btc_ops rtl_btc_operation = {
 	.btc_is_bt_disabled = rtl_btc_is_bt_disabled,
 	.btc_special_packet_notify = rtl_btc_special_packet_notify,
 	.btc_record_pwr_mode = rtl_btc_record_pwr_mode,
+	.btc_get_lps_val = rtl_btc_get_lps_val,
+	.btc_get_rpwm_val = rtl_btc_get_rpwm_val,
+	.btc_is_bt_ctrl_lps = rtl_btc_is_bt_ctrl_lps,
 };
 
 void rtl_btc_record_pwr_mode(struct rtl_priv *rtlpriv, u8 *buf, u8 len)
@@ -61,6 +64,21 @@ void rtl_btc_record_pwr_mode(struct rtl_priv *rtlpriv, u8 *buf, u8 len)
 	memcpy(gl_bt_coexist.pwr_mode_val, buf, safe_len);
 }
 
+u8 rtl_btc_get_lps_val(struct rtl_priv *rtlpriv)
+{
+	return gl_bt_coexist.bt_info.lps_val;
+}
+
+u8 rtl_btc_get_rpwm_val(struct rtl_priv *rtlpriv)
+{
+	return gl_bt_coexist.bt_info.rpwm_val;
+}
+
+bool rtl_btc_is_bt_ctrl_lps(struct rtl_priv *rtlpriv)
+{
+	return gl_bt_coexist.bt_info.bt_ctrl_lps;
+}
+
 void rtl_btc_init_variables(struct rtl_priv *rtlpriv)
 {
 	exhalbtc_initlize_variables();
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.h
index d145909..81c378e 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.h
@@ -45,6 +45,9 @@ bool rtl_btc_is_disable_edca_turbo(struct rtl_priv *rtlpriv);
 bool rtl_btc_is_bt_disabled(struct rtl_priv *rtlpriv);
 void rtl_btc_special_packet_notify(struct rtl_priv *rtlpriv, u8 pkt_type);
 void rtl_btc_record_pwr_mode(struct rtl_priv *rtlpriv, u8 *buf, u8 len);
+u8   rtl_btc_get_lps_val(struct rtl_priv *rtlpriv);
+u8   rtl_btc_get_rpwm_val(struct rtl_priv *rtlpriv);
+bool rtl_btc_is_bt_ctrl_lps(struct rtl_priv *rtlpriv);
 
 struct rtl_btc_ops *rtl_btc_get_ops_pointer(void);
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c
index 77edf0d..0252167 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c
@@ -500,23 +500,70 @@ void rtl92ee_set_fw_pwrmode_cmd(struct ieee80211_hw *hw, u8 mode)
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	u8 u1_h2c_set_pwrmode[H2C_92E_PWEMODE_LENGTH] = { 0 };
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
-	u8 rlbm, power_state = 0, byte5 = 0x40;
+	u8 rlbm, power_state = 0, byte5 = 0;
+	u8 awake_intvl;	/* DTIM = (awake_intvl - 1) */
+	struct rtl_btc_ops *btc_ops = rtlpriv->btcoexist.btc_ops;
+	bool bt_ctrl_lps = btc_ops->btc_is_bt_ctrl_lps(rtlpriv);
+
+	RT_TRACE(rtlpriv, COMP_POWER, DBG_DMESG, "FW LPS mode = %d (coex:%d)\n",
+		 mode, bt_ctrl_lps);
+
+	switch (mode) {
+	case FW_PS_MIN_MODE:
+		rlbm = 0;
+		awake_intvl = 2;
+		break;
+	case FW_PS_MAX_MODE:
+		rlbm = 1;
+		awake_intvl = 2;
+		break;
+	case FW_PS_DTIM_MODE:
+		rlbm = 2;
+		awake_intvl = ppsc->reg_max_lps_awakeintvl;
+		/* hw->conf.ps_dtim_period or mac->vif->bss_conf.dtim_period
+		 * is only used in swlps.
+		 */
+		break;
+	default:
+		rlbm = 2;
+		awake_intvl = 4;
+		break;
+	}
 
-	RT_TRACE(rtlpriv, COMP_POWER, DBG_LOUD , "FW LPS mode = %d\n", mode);
+	if (rtlpriv->mac80211.p2p) {
+		awake_intvl = 2;
+		rlbm = 1;
+	}
+
+	if (mode == FW_PS_ACTIVE_MODE) {
+		byte5 = 0x40;
+		power_state = FW_PWR_STATE_ACTIVE;
+	} else {
+		if (bt_ctrl_lps) {
+			byte5 = btc_ops->btc_get_lps_val(rtlpriv);
+			power_state = btc_ops->btc_get_rpwm_val(rtlpriv);
+
+			if ((rlbm == 2) && (byte5 & BIT(4))) {
+				/* Keep awake interval to 1 to prevent from
+				 * decreasing coex performance
+				 */
+				awake_intvl = 2;
+				rlbm = 2;
+			}
+		} else {
+			byte5 = 0x40;
+			power_state = FW_PWR_STATE_RF_OFF;
+		}
+	}
 
 	SET_H2CCMD_PWRMODE_PARM_MODE(u1_h2c_set_pwrmode, ((mode) ? 1 : 0));
-	rlbm = 0;/*YJ,temp,120316. FW now not support RLBM=2.*/
 	SET_H2CCMD_PWRMODE_PARM_RLBM(u1_h2c_set_pwrmode, rlbm);
 	SET_H2CCMD_PWRMODE_PARM_SMART_PS(u1_h2c_set_pwrmode,
 					 (rtlpriv->mac80211.p2p) ?
 					 ppsc->smart_ps : 1);
 	SET_H2CCMD_PWRMODE_PARM_AWAKE_INTERVAL(u1_h2c_set_pwrmode,
-					       ppsc->reg_max_lps_awakeintvl);
+					       awake_intvl);
 	SET_H2CCMD_PWRMODE_PARM_ALL_QUEUE_UAPSD(u1_h2c_set_pwrmode, 0);
-	if (mode == FW_PS_ACTIVE_MODE)
-		power_state |= FW_PWR_STATE_ACTIVE;
-	else
-		power_state |= FW_PWR_STATE_RF_OFF;
 	SET_H2CCMD_PWRMODE_PARM_PWR_STATE(u1_h2c_set_pwrmode, power_state);
 	SET_H2CCMD_PWRMODE_PARM_BYTE5(u1_h2c_set_pwrmode, byte5);
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/fw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/fw.c
index cacbac7..54f5241 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/fw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/fw.c
@@ -241,22 +241,70 @@ void rtl8723be_set_fw_pwrmode_cmd(struct ieee80211_hw *hw, u8 mode)
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	u8 u1_h2c_set_pwrmode[H2C_PWEMODE_LENGTH] = { 0 };
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
-	u8 rlbm, power_state = 0, byte5 = 0x40;
-	RT_TRACE(rtlpriv, COMP_POWER, DBG_LOUD, "FW LPS mode = %d\n", mode);
+	u8 rlbm, power_state = 0, byte5 = 0;
+	u8 awake_intvl;	/* DTIM = (awake_intvl - 1) */
+	struct rtl_btc_ops *btc_ops = rtlpriv->btcoexist.btc_ops;
+	bool bt_ctrl_lps = btc_ops->btc_is_bt_ctrl_lps(rtlpriv);
+
+	RT_TRACE(rtlpriv, COMP_POWER, DBG_DMESG, "FW LPS mode = %d (coex:%d)\n",
+		 mode, bt_ctrl_lps);
+
+	switch (mode) {
+	case FW_PS_MIN_MODE:
+		rlbm = 0;
+		awake_intvl = 2;
+		break;
+	case FW_PS_MAX_MODE:
+		rlbm = 1;
+		awake_intvl = 2;
+		break;
+	case FW_PS_DTIM_MODE:
+		rlbm = 2;
+		awake_intvl = ppsc->reg_max_lps_awakeintvl;
+		/* hw->conf.ps_dtim_period or mac->vif->bss_conf.dtim_period
+		 * is only used in swlps.
+		 */
+		break;
+	default:
+		rlbm = 2;
+		awake_intvl = 4;
+		break;
+	}
+
+	if (rtlpriv->mac80211.p2p) {
+		awake_intvl = 2;
+		rlbm = 1;
+	}
+
+	if (mode == FW_PS_ACTIVE_MODE) {
+		byte5 = 0x40;
+		power_state = FW_PWR_STATE_ACTIVE;
+	} else {
+		if (bt_ctrl_lps) {
+			byte5 = btc_ops->btc_get_lps_val(rtlpriv);
+			power_state = btc_ops->btc_get_rpwm_val(rtlpriv);
+
+			if ((rlbm == 2) && (byte5 & BIT(4))) {
+				/* Keep awake interval to 1 to prevent from
+				 * decreasing coex performance
+				 */
+				awake_intvl = 2;
+				rlbm = 2;
+			}
+		} else {
+			byte5 = 0x40;
+			power_state = FW_PWR_STATE_RF_OFF;
+		}
+	}
 
 	SET_H2CCMD_PWRMODE_PARM_MODE(u1_h2c_set_pwrmode, ((mode) ? 1 : 0));
-	rlbm = 0;/*YJ,temp,120316. FW now not support RLBM=2.*/
 	SET_H2CCMD_PWRMODE_PARM_RLBM(u1_h2c_set_pwrmode, rlbm);
 	SET_H2CCMD_PWRMODE_PARM_SMART_PS(u1_h2c_set_pwrmode,
 					 (rtlpriv->mac80211.p2p) ?
 					  ppsc->smart_ps : 1);
 	SET_H2CCMD_PWRMODE_PARM_AWAKE_INTERVAL(u1_h2c_set_pwrmode,
-					       ppsc->reg_max_lps_awakeintvl);
+					       awake_intvl);
 	SET_H2CCMD_PWRMODE_PARM_ALL_QUEUE_UAPSD(u1_h2c_set_pwrmode, 0);
-	if (mode == FW_PS_ACTIVE_MODE)
-		power_state |= FW_PWR_STATE_ACTIVE;
-	else
-		power_state |= FW_PWR_STATE_RF_OFF;
 	SET_H2CCMD_PWRMODE_PARM_PWR_STATE(u1_h2c_set_pwrmode, power_state);
 	SET_H2CCMD_PWRMODE_PARM_BYTE5(u1_h2c_set_pwrmode, byte5);
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c
index 0ce65ef..fc40c2d 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c
@@ -558,24 +558,70 @@ void rtl8821ae_set_fw_pwrmode_cmd(struct ieee80211_hw *hw, u8 mode)
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	u8 u1_h2c_set_pwrmode[H2C_8821AE_PWEMODE_LENGTH] = { 0 };
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
-	u8 rlbm, power_state = 0, byte5 = 0x40;
+	u8 rlbm, power_state = 0, byte5 = 0;
+	u8 awake_intvl;	/* DTIM = (awake_intvl - 1) */
+	struct rtl_btc_ops *btc_ops = rtlpriv->btcoexist.btc_ops;
+	bool bt_ctrl_lps = btc_ops->btc_is_bt_ctrl_lps(rtlpriv);
+
+	RT_TRACE(rtlpriv, COMP_POWER, DBG_DMESG, "FW LPS mode = %d (coex:%d)\n",
+		 mode, bt_ctrl_lps);
+
+	switch (mode) {
+	case FW_PS_MIN_MODE:
+		rlbm = 0;
+		awake_intvl = 2;
+		break;
+	case FW_PS_MAX_MODE:
+		rlbm = 1;
+		awake_intvl = 2;
+		break;
+	case FW_PS_DTIM_MODE:
+		rlbm = 2;
+		awake_intvl = ppsc->reg_max_lps_awakeintvl;
+		/* hw->conf.ps_dtim_period or mac->vif->bss_conf.dtim_period
+		 * is only used in swlps.
+		 */
+		break;
+	default:
+		rlbm = 2;
+		awake_intvl = 4;
+		break;
+	}
+
+	if (rtlpriv->mac80211.p2p) {
+		awake_intvl = 2;
+		rlbm = 1;
+	}
 
-	RT_TRACE(rtlpriv, COMP_POWER, DBG_LOUD, "FW LPS mode = %d\n", mode);
+	if (mode == FW_PS_ACTIVE_MODE) {
+		byte5 = 0x40;
+		power_state = FW_PWR_STATE_ACTIVE;
+	} else {
+		if (bt_ctrl_lps) {
+			byte5 = btc_ops->btc_get_lps_val(rtlpriv);
+			power_state = btc_ops->btc_get_rpwm_val(rtlpriv);
+
+			if ((rlbm == 2) && (byte5 & BIT(4))) {
+				/* Keep awake interval to 1 to prevent from
+				 * decreasing coex performance
+				 */
+				awake_intvl = 2;
+				rlbm = 2;
+			}
+		} else {
+			byte5 = 0x40;
+			power_state = FW_PWR_STATE_RF_OFF;
+		}
+	}
 
 	SET_H2CCMD_PWRMODE_PARM_MODE(u1_h2c_set_pwrmode, ((mode) ? 1 : 0));
-	rlbm = 0;/*YJ,temp,120316. FW now not support RLBM=2.*/
 	SET_H2CCMD_PWRMODE_PARM_RLBM(u1_h2c_set_pwrmode, rlbm);
 	SET_H2CCMD_PWRMODE_PARM_SMART_PS(u1_h2c_set_pwrmode,
 					 (rtlpriv->mac80211.p2p) ?
 					 ppsc->smart_ps : 1);
 	SET_H2CCMD_PWRMODE_PARM_AWAKE_INTERVAL(u1_h2c_set_pwrmode,
-					       ppsc->reg_max_lps_awakeintvl);
+					       awake_intvl);
 	SET_H2CCMD_PWRMODE_PARM_ALL_QUEUE_UAPSD(u1_h2c_set_pwrmode, 0);
-	if (mode == FW_PS_ACTIVE_MODE)
-		power_state |= FW_PWR_STATE_ACTIVE;
-	else
-		power_state |= FW_PWR_STATE_RF_OFF;
-
 	SET_H2CCMD_PWRMODE_PARM_PWR_STATE(u1_h2c_set_pwrmode, power_state);
 	SET_H2CCMD_PWRMODE_PARM_BYTE5(u1_h2c_set_pwrmode, byte5);
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index 783e08f..3411f21 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -2565,6 +2565,9 @@ struct rtl_btc_ops {
 	void (*btc_special_packet_notify)(struct rtl_priv *rtlpriv,
 					  u8 pkt_type);
 	void (*btc_record_pwr_mode)(struct rtl_priv *rtlpriv, u8 *buf, u8 len);
+	u8   (*btc_get_lps_val)(struct rtl_priv *rtlpriv);
+	u8   (*btc_get_rpwm_val)(struct rtl_priv *rtlpriv);
+	bool (*btc_is_bt_ctrl_lps)(struct rtl_priv *rtlpriv);
 };
 
 struct proxim {
@@ -3067,9 +3070,4 @@ static inline struct ieee80211_sta *rtl_find_sta(struct ieee80211_hw *hw,
 	return ieee80211_find_sta(mac->vif, mac_addr);
 }
 
-static inline struct rtl_btc_ops *rtl_btc_get_ops_pointer(void)
-{
-	return NULL;
-}
-
 #endif
-- 
2.10.2
