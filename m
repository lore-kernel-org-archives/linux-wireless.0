Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:36644 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652AbbFGL3S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Jun 2015 07:29:18 -0400
Received: by wgbgq6 with SMTP id gq6so83742277wgb.3
        for <linux-wireless@vger.kernel.org>; Sun, 07 Jun 2015 04:29:17 -0700 (PDT)
From: Hans Ulli Kroll <ulli.kroll@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	Hans Ulli Kroll <ulli.kroll@googlemail.com>
Subject: [PATCH] net:rtlwifi:fix tm_trigger usage
Date: Sun,  7 Jun 2015 13:19:16 +0200
Message-Id: <1433675956-5787-1-git-send-email-ulli.kroll@googlemail.com> (sfid-20150607_132925_257144_EC349C4A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While working on getting my rtl8821au driver in pretty shape for
inclusion, it is dicosvered that the tm_trigger flag is used only for
the first device using this driver.
This flag handles the thermal power management in the hardware.

To change this add a entry in sttruct rtl_dm, so each device can handle
is separately.

Signed-off-by: Hans Ulli Kroll <ulli.kroll@googlemail.com>
---
 drivers/net/wireless/rtlwifi/rtl8188ee/dm.c       |  7 +++----
 drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c |  7 +++----
 drivers/net/wireless/rtlwifi/rtl8192de/dm.c       |  7 +++----
 drivers/net/wireless/rtlwifi/rtl8192se/dm.c       |  7 +++----
 drivers/net/wireless/rtlwifi/rtl8723be/dm.c       |  7 +++----
 drivers/net/wireless/rtlwifi/rtl8821ae/dm.c       | 14 +++++---------
 drivers/net/wireless/rtlwifi/wifi.h               |  1 +
 7 files changed, 21 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/dm.c b/drivers/net/wireless/rtlwifi/rtl8188ee/dm.c
index d930c1f..ce4da9d 100644
--- a/drivers/net/wireless/rtlwifi/rtl8188ee/dm.c
+++ b/drivers/net/wireless/rtlwifi/rtl8188ee/dm.c
@@ -1123,23 +1123,22 @@ static void rtl88e_dm_init_txpower_tracking(struct ieee80211_hw *hw)
 void rtl88e_dm_check_txpower_tracking(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	static u8 tm_trigger;
 
 	if (!rtlpriv->dm.txpower_tracking)
 		return;
 
-	if (!tm_trigger) {
+	if (!rtlpriv->dm.tm_trigger) {
 		rtl_set_rfreg(hw, RF90_PATH_A, RF_T_METER, BIT(17)|BIT(16),
 			      0x03);
 		RT_TRACE(rtlpriv, COMP_POWER_TRACKING, DBG_LOUD,
 			 "Trigger 88E Thermal Meter!!\n");
-		tm_trigger = 1;
+		rtlpriv->dm.tm_trigger = 1;
 		return;
 	} else {
 		RT_TRACE(rtlpriv, COMP_POWER_TRACKING, DBG_LOUD,
 			 "Schedule TxPowerTracking !!\n");
 				dm_txpower_track_cb_therm(hw);
-		tm_trigger = 0;
+		rtlpriv->dm.tm_trigger = 0;
 	}
 }
 
diff --git a/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c b/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
index f5ee67c..0aca6f4 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
@@ -1169,23 +1169,22 @@ static void rtl92c_dm_check_txpower_tracking_thermal_meter(
 						struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	static u8 tm_trigger;
 
 	if (!rtlpriv->dm.txpower_tracking)
 		return;
 
-	if (!tm_trigger) {
+	if (!rtlpriv->dm.tm_trigger) {
 		rtl_set_rfreg(hw, RF90_PATH_A, RF_T_METER, RFREG_OFFSET_MASK,
 			      0x60);
 		RT_TRACE(rtlpriv, COMP_POWER_TRACKING, DBG_LOUD,
 			 "Trigger 92S Thermal Meter!!\n");
-		tm_trigger = 1;
+		rtlpriv->dm.tm_trigger = 1;
 		return;
 	} else {
 		RT_TRACE(rtlpriv, COMP_POWER_TRACKING, DBG_LOUD,
 			 "Schedule TxPowerTracking direct call!!\n");
 		rtl92c_dm_txpower_tracking_directcall(hw);
-		tm_trigger = 0;
+		rtlpriv->dm.tm_trigger = 0;
 	}
 }
 
diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/dm.c b/drivers/net/wireless/rtlwifi/rtl8192de/dm.c
index a1be5a6..587b8c5 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192de/dm.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/dm.c
@@ -1240,23 +1240,22 @@ static void rtl92d_dm_initialize_txpower_tracking(struct ieee80211_hw *hw)
 void rtl92d_dm_check_txpower_tracking_thermal_meter(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	static u8 tm_trigger;
 
 	if (!rtlpriv->dm.txpower_tracking)
 		return;
 
-	if (!tm_trigger) {
+	if (!rtlpriv->dm.tm_trigger) {
 		rtl_set_rfreg(hw, RF90_PATH_A, RF_T_METER, BIT(17) |
 			      BIT(16), 0x03);
 		RT_TRACE(rtlpriv, COMP_POWER_TRACKING, DBG_LOUD,
 			 "Trigger 92S Thermal Meter!!\n");
-		tm_trigger = 1;
+		rtlpriv->dm.tm_trigger = 1;
 		return;
 	} else {
 		RT_TRACE(rtlpriv, COMP_POWER_TRACKING, DBG_LOUD,
 			 "Schedule TxPowerTracking direct call!!\n");
 		rtl92d_dm_txpower_tracking_callback_thermalmeter(hw);
-		tm_trigger = 0;
+		rtlpriv->dm.tm_trigger = 0;
 	}
 }
 
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/dm.c b/drivers/net/wireless/rtlwifi/rtl8192se/dm.c
index 575980b..9bae5a9 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/dm.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/dm.c
@@ -200,7 +200,6 @@ static void _rtl92s_dm_check_txpowertracking_thermalmeter(
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
-	static u8 tm_trigger;
 	u8 tx_power_checkcnt = 5;
 
 	/* 2T2R TP issue */
@@ -215,13 +214,13 @@ static void _rtl92s_dm_check_txpowertracking_thermalmeter(
 		return;
 	}
 
-	if (!tm_trigger) {
+	if (!rtlpriv->dm.tm_trigger) {
 		rtl_set_rfreg(hw, RF90_PATH_A, RF_T_METER,
 			      RFREG_OFFSET_MASK, 0x60);
-		tm_trigger = 1;
+		rtlpriv->dm.tm_trigger = 1;
 	} else {
 		_rtl92s_dm_txpowertracking_callback_thermalmeter(hw);
-		tm_trigger = 0;
+		rtlpriv->dm.tm_trigger = 0;
 	}
 }
 
diff --git a/drivers/net/wireless/rtlwifi/rtl8723be/dm.c b/drivers/net/wireless/rtlwifi/rtl8723be/dm.c
index e77c3a4..3a81cdb 100644
--- a/drivers/net/wireless/rtlwifi/rtl8723be/dm.c
+++ b/drivers/net/wireless/rtlwifi/rtl8723be/dm.c
@@ -909,23 +909,22 @@ static void rtl8723be_dm_txpower_tracking_callback_thermalmeter(
 void rtl8723be_dm_check_txpower_tracking(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	static u8 tm_trigger;
 
 	if (!rtlpriv->dm.txpower_tracking)
 		return;
 
-	if (!tm_trigger) {
+	if (!rtlpriv->dm.tm_trigger) {
 		rtl_set_rfreg(hw, RF90_PATH_A, RF_T_METER, BIT(17) | BIT(16),
 			      0x03);
 		RT_TRACE(rtlpriv, COMP_POWER_TRACKING, DBG_LOUD,
 			 "Trigger 8723be Thermal Meter!!\n");
-		tm_trigger = 1;
+		rtlpriv->dm.tm_trigger = 1;
 		return;
 	} else {
 		RT_TRACE(rtlpriv, COMP_POWER_TRACKING, DBG_LOUD,
 			 "Schedule TxPowerTracking !!\n");
 		rtl8723be_dm_txpower_tracking_callback_thermalmeter(hw);
-		tm_trigger = 0;
+		rtlpriv->dm.tm_trigger = 0;
 	}
 }
 
diff --git a/drivers/net/wireless/rtlwifi/rtl8821ae/dm.c b/drivers/net/wireless/rtlwifi/rtl8821ae/dm.c
index 342678d..b57cfd9 100644
--- a/drivers/net/wireless/rtlwifi/rtl8821ae/dm.c
+++ b/drivers/net/wireless/rtlwifi/rtl8821ae/dm.c
@@ -1068,20 +1068,18 @@ static void rtl8812ae_dm_check_txpower_tracking_thermalmeter(
 		struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	static u8 tm_trigger;
 
-	if (!tm_trigger) {
+	if (!rtlpriv->dm.tm_trigger) {
 		rtl_set_rfreg(hw, RF90_PATH_A, RF_T_METER_88E,
 			      BIT(17) | BIT(16), 0x03);
 		RT_TRACE(rtlpriv, COMP_POWER_TRACKING, DBG_LOUD,
 			 "Trigger 8812 Thermal Meter!!\n");
-		tm_trigger = 1;
+		rtlpriv->dm.tm_trigger = 1;
 		return;
 	}
 	RT_TRACE(rtlpriv, COMP_POWER_TRACKING, DBG_LOUD,
 		 "Schedule TxPowerTracking direct call!!\n");
 	rtl8812ae_dm_txpower_tracking_callback_thermalmeter(hw);
-	tm_trigger = 0;
 }
 
 static void rtl8821ae_dm_iq_calibrate(struct ieee80211_hw *hw)
@@ -2519,21 +2517,19 @@ void rtl8821ae_dm_txpower_tracking_callback_thermalmeter(
 void rtl8821ae_dm_check_txpower_tracking_thermalmeter(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	static u8 tm_trigger;
-
-	if (!tm_trigger) {
+	if (!rtlpriv->dm.tm_trigger) {
 		rtl_set_rfreg(hw, RF90_PATH_A, RF_T_METER_88E, BIT(17)|BIT(16),
 			      0x03);
 		RT_TRACE(rtlpriv, COMP_POWER_TRACKING, DBG_LOUD,
 			 "Trigger 8821ae Thermal Meter!!\n");
-		tm_trigger = 1;
+		rtlpriv->dm.tm_trigger = 1;
 		return;
 	} else {
 		RT_TRACE(rtlpriv, COMP_POWER_TRACKING, DBG_LOUD,
 			 "Schedule TxPowerTracking !!\n");
 
 		rtl8821ae_dm_txpower_tracking_callback_thermalmeter(hw);
-		tm_trigger = 0;
+		rtlpriv->dm.tm_trigger = 0;
 	}
 }
 
diff --git a/drivers/net/wireless/rtlwifi/wifi.h b/drivers/net/wireless/rtlwifi/wifi.h
index 5157291..2b770b5 100644
--- a/drivers/net/wireless/rtlwifi/wifi.h
+++ b/drivers/net/wireless/rtlwifi/wifi.h
@@ -1665,6 +1665,7 @@ struct rtl_dm {
 	u8 last_dtp_lvl;
 	u8 thermalvalue_avg[AVG_THERMAL_NUM];
 	u8 thermalvalue_avg_index;
+	u8 tm_trigger;
 	bool done_txpower;
 	u8 dynamic_txhighpower_lvl;	/*Tx high power level */
 	u8 dm_flag;		/*Indicate each dynamic mechanism's status. */
-- 
2.4.2

