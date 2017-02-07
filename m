Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:36635 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751789AbdBGDa0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Feb 2017 22:30:26 -0500
Received: by mail-oi0-f66.google.com with SMTP id u143so7925974oif.3
        for <linux-wireless@vger.kernel.org>; Mon, 06 Feb 2017 19:30:25 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 08/11 V4] rtlwifi: rtl8723be: btcoex: add package_type function to btcoex
Date: Mon,  6 Feb 2017 21:30:05 -0600
Message-Id: <20170120212716.29887-9-Larry.Finger@lwfinger.net> (sfid-20170207_043048_375029_690A192B)
In-Reply-To: <20170120212716.29887-1-Larry.Finger@lwfinger.net>
References: <20170120212716.29887-1-Larry.Finger@lwfinger.net>
In-Reply-To: <20170120212716.29887-1-Larry.Finger@lwfinger.net>
References: <20170120212716.29887-1-Larry.Finger@lwfinger.net>
In-Reply-To: <20170120212716.29887-1-Larry.Finger@lwfinger.net>
References: <20170120212716.29887-1-Larry.Finger@lwfinger.net>
In-Reply-To: <20170120212716.29887-1-Larry.Finger@lwfinger.net>
References: <20170120212716.29887-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

The new code handles the package-type of the chip.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
V2 - no changes
V3 - no changes
V4 - no changes
---
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.c       |  7 +++++
 .../wireless/realtek/rtlwifi/btcoexist/rtl_btc.h   |  2 ++
 drivers/net/wireless/realtek/rtlwifi/efuse.c       |  5 ++--
 drivers/net/wireless/realtek/rtlwifi/efuse.h       |  1 +
 .../net/wireless/realtek/rtlwifi/rtl8723be/hw.c    | 33 ++++++++++++++++++++++
 drivers/net/wireless/realtek/rtlwifi/wifi.h        |  9 ++++++
 6 files changed, 54 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
index 3958422..1cc955e 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
@@ -163,6 +163,13 @@ u8 rtl_get_hwpg_ant_num(struct rtl_priv *rtlpriv)
 	return num;
 }
 
+u8 rtl_get_hwpg_package_type(struct rtl_priv *rtlpriv)
+{
+	struct rtl_hal *rtlhal = rtl_hal(rtlpriv);
+
+	return rtlhal->package_type;
+}
+
 static void halbtc_leave_lps(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv;
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.h
index bba7e23e..fff5117 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.h
@@ -50,6 +50,8 @@ u8 rtl_get_hwpg_bt_exist(struct rtl_priv *rtlpriv);
 u8 rtl_get_hwpg_bt_type(struct rtl_priv *rtlpriv);
 u8 rtl_get_hwpg_ant_num(struct rtl_priv *rtlpriv);
 u8 rtl_get_hwpg_single_ant_path(struct rtl_priv *rtlpriv);
+u8 rtl_get_hwpg_package_type(struct rtl_priv *rtlpriv);
+
 enum rt_media_status mgnt_link_status_query(struct ieee80211_hw *hw);
 
 #endif
diff --git a/drivers/net/wireless/realtek/rtlwifi/efuse.c b/drivers/net/wireless/realtek/rtlwifi/efuse.c
index eb58633..ef9acd4 100644
--- a/drivers/net/wireless/realtek/rtlwifi/efuse.c
+++ b/drivers/net/wireless/realtek/rtlwifi/efuse.c
@@ -73,8 +73,6 @@ static void efuse_word_enable_data_read(u8 word_en, u8 *sourdata,
 					u8 *targetdata);
 static u8 enable_efuse_data_write(struct ieee80211_hw *hw,
 				  u16 efuse_addr, u8 word_en, u8 *data);
-static void efuse_power_switch(struct ieee80211_hw *hw, u8 write,
-			       u8 pwrstate);
 static u16 efuse_get_current_size(struct ieee80211_hw *hw);
 static u8 efuse_calculate_word_cnts(u8 word_en);
 
@@ -1124,7 +1122,7 @@ static u8 enable_efuse_data_write(struct ieee80211_hw *hw,
 	return badworden;
 }
 
-static void efuse_power_switch(struct ieee80211_hw *hw, u8 write, u8 pwrstate)
+void efuse_power_switch(struct ieee80211_hw *hw, u8 write, u8 pwrstate)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
@@ -1210,6 +1208,7 @@ static void efuse_power_switch(struct ieee80211_hw *hw, u8 write, u8 pwrstate)
 		}
 	}
 }
+EXPORT_SYMBOL(efuse_power_switch);
 
 static u16 efuse_get_current_size(struct ieee80211_hw *hw)
 {
diff --git a/drivers/net/wireless/realtek/rtlwifi/efuse.h b/drivers/net/wireless/realtek/rtlwifi/efuse.h
index 1338ae6..952fdc2 100644
--- a/drivers/net/wireless/realtek/rtlwifi/efuse.h
+++ b/drivers/net/wireless/realtek/rtlwifi/efuse.h
@@ -109,6 +109,7 @@ bool efuse_shadow_update_chk(struct ieee80211_hw *hw);
 void rtl_efuse_shadow_map_update(struct ieee80211_hw *hw);
 void efuse_force_write_vendor_Id(struct ieee80211_hw *hw);
 void efuse_re_pg_section(struct ieee80211_hw *hw, u8 section_idx);
+void efuse_power_switch(struct ieee80211_hw *hw, u8 write, u8 pwrstate);
 int rtl_get_hwinfo(struct ieee80211_hw *hw, struct rtl_priv *rtlpriv,
 		   int max_size, u8 *hwinfo, int *params);
 void rtl_fill_dummy(u8 *pfwbuf, u32 *pfwlen);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
index b46874b..66e9e4a 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
@@ -2020,6 +2020,37 @@ static void _rtl8723be_read_txpower_info_from_hwpg(struct ieee80211_hw *hw,
 		"eeprom_regulatory = 0x%x\n", rtlefuse->eeprom_regulatory);
 }
 
+static u8 _rtl8723be_read_package_type(struct ieee80211_hw *hw)
+{
+	u8 package_type;
+	u8 value;
+
+	efuse_power_switch(hw, false, true);
+	if (!efuse_one_byte_read(hw, 0x1FB, &value))
+		value = 0;
+	efuse_power_switch(hw, false, false);
+
+	switch (value & 0x7) {
+	case 0x4:
+		package_type = PACKAGE_TFBGA79;
+		break;
+	case 0x5:
+		package_type = PACKAGE_TFBGA90;
+		break;
+	case 0x6:
+		package_type = PACKAGE_QFN68;
+		break;
+	case 0x7:
+		package_type = PACKAGE_TFBGA80;
+		break;
+	default:
+		package_type = PACKAGE_DEFAULT;
+		break;
+	}
+
+	return package_type;
+}
+
 static void _rtl8723be_read_adapter_info(struct ieee80211_hw *hw,
 					 bool pseudo_test)
 {
@@ -2078,6 +2109,8 @@ static void _rtl8723be_read_adapter_info(struct ieee80211_hw *hw,
 						 rtlefuse->autoload_failflag,
 						 hwinfo);
 
+	rtlhal->package_type = _rtl8723be_read_package_type(hw);
+
 	/* set channel plan from efuse */
 	rtlefuse->channel_plan = rtlefuse->eeprom_channelplan;
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index 9a5a8a9..4dad962 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -925,6 +925,14 @@ enum wolpattern_type {
 	UNKNOWN_TYPE = 4,
 };
 
+enum package_type {
+	PACKAGE_DEFAULT,
+	PACKAGE_QFN68,
+	PACKAGE_TFBGA90,
+	PACKAGE_TFBGA80,
+	PACKAGE_TFBGA79
+};
+
 struct octet_string {
 	u8 *octet;
 	u16 length;
@@ -1509,6 +1517,7 @@ struct rtl_hal {
 	u32 version;		/*version of chip */
 	u8 state;		/*stop 0, start 1 */
 	u8 board_type;
+	u8 package_type;
 	u8 external_pa;
 
 	u8 pa_mode;
-- 
2.10.2
