Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:36135 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755497AbcLBBsy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Dec 2016 20:48:54 -0500
Received: by mail-oi0-f68.google.com with SMTP id u15so25525991oie.3
        for <linux-wireless@vger.kernel.org>; Thu, 01 Dec 2016 17:48:54 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 08/14] rtlwifi: rtl8723be: btcoex: add package_type function to btcoex
Date: Thu,  1 Dec 2016 19:48:27 -0600
Message-Id: <20161202014833.6856-9-Larry.Finger@lwfinger.net> (sfid-20161202_024910_165228_FBA0A01D)
In-Reply-To: <20161202014833.6856-1-Larry.Finger@lwfinger.net>
References: <20161202014833.6856-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

The new code handles the package-type of the chip.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.c       |  7 +++++
 .../wireless/realtek/rtlwifi/btcoexist/rtl_btc.h   |  2 ++
 drivers/net/wireless/realtek/rtlwifi/efuse.c       |  5 ++--
 drivers/net/wireless/realtek/rtlwifi/efuse.h       |  1 +
 .../net/wireless/realtek/rtlwifi/rtl8723be/hw.c    | 33 ++++++++++++++++++++++
 drivers/net/wireless/realtek/rtlwifi/wifi.h        |  9 ++++++
 6 files changed, 54 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
index d69bf32..d2e4960 100644
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
index 7becfef..a6985e1 100644
--- a/drivers/net/wireless/realtek/rtlwifi/efuse.c
+++ b/drivers/net/wireless/realtek/rtlwifi/efuse.c
@@ -70,8 +70,6 @@ static void efuse_word_enable_data_read(u8 word_en, u8 *sourdata,
 					u8 *targetdata);
 static u8 enable_efuse_data_write(struct ieee80211_hw *hw,
 				  u16 efuse_addr, u8 word_en, u8 *data);
-static void efuse_power_switch(struct ieee80211_hw *hw, u8 write,
-			       u8 pwrstate);
 static u16 efuse_get_current_size(struct ieee80211_hw *hw);
 static u8 efuse_calculate_word_cnts(u8 word_en);
 
@@ -1121,7 +1119,7 @@ static u8 enable_efuse_data_write(struct ieee80211_hw *hw,
 	return badworden;
 }
 
-static void efuse_power_switch(struct ieee80211_hw *hw, u8 write, u8 pwrstate)
+void efuse_power_switch(struct ieee80211_hw *hw, u8 write, u8 pwrstate)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
@@ -1207,6 +1205,7 @@ static void efuse_power_switch(struct ieee80211_hw *hw, u8 write, u8 pwrstate)
 		}
 	}
 }
+EXPORT_SYMBOL(efuse_power_switch);
 
 static u16 efuse_get_current_size(struct ieee80211_hw *hw)
 {
diff --git a/drivers/net/wireless/realtek/rtlwifi/efuse.h b/drivers/net/wireless/realtek/rtlwifi/efuse.h
index 51aa121..49a5fb2 100644
--- a/drivers/net/wireless/realtek/rtlwifi/efuse.h
+++ b/drivers/net/wireless/realtek/rtlwifi/efuse.h
@@ -109,6 +109,7 @@ bool efuse_shadow_update_chk(struct ieee80211_hw *hw);
 void rtl_efuse_shadow_map_update(struct ieee80211_hw *hw);
 void efuse_force_write_vendor_Id(struct ieee80211_hw *hw);
 void efuse_re_pg_section(struct ieee80211_hw *hw, u8 section_idx);
+void efuse_power_switch(struct ieee80211_hw *hw, u8 write, u8 pwrstate);
 int rtl_get_hwinfo(struct ieee80211_hw *hw, struct rtl_priv *rtlpriv,
 		   int max_size, u8 *hwinfo, int *params);
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
index 54a26da..c2cd99f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
@@ -2022,6 +2022,37 @@ static void _rtl8723be_read_txpower_info_from_hwpg(struct ieee80211_hw *hw,
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
@@ -2080,6 +2111,8 @@ static void _rtl8723be_read_adapter_info(struct ieee80211_hw *hw,
 						 rtlefuse->autoload_failflag,
 						 hwinfo);
 
+	rtlhal->package_type = _rtl8723be_read_package_type(hw);
+
 	/* set channel plan from efuse */
 	rtlefuse->channel_plan = rtlefuse->eeprom_channelplan;
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index 4e3b441..e443af2 100644
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
