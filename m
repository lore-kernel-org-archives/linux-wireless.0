Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:35511 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1948601AbdEZSmA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 May 2017 14:42:00 -0400
Received: by mail-oi0-f66.google.com with SMTP id v80so2985986oie.2
        for <linux-wireless@vger.kernel.org>; Fri, 26 May 2017 11:42:00 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH v2 5/7] rtlwifi: btcoex: Fix Sparse messages for undeclared symbols
Date: Fri, 26 May 2017 13:41:45 -0500
Message-Id: <20170526184147.31239-6-Larry.Finger@lwfinger.net> (sfid-20170526_204333_516888_3BDD0F37)
In-Reply-To: <20170526184147.31239-1-Larry.Finger@lwfinger.net>
References: <20170526184147.31239-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A number of functions can be set to static.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Ping-Ke Shih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
v2 - no changes
---
 .../realtek/rtlwifi/btcoexist/halbtc8723b1ant.c    |  1 +
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.c    |  1 +
 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.c    |  1 +
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.c       | 84 ++--------------------
 4 files changed, 8 insertions(+), 79 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
index de536b184571..db68793fc55c 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
@@ -1442,6 +1442,7 @@ static void halbtc8723b1ant_ps_tdma(struct btc_coexist *btcoexist,
 	coex_dm->pre_ps_tdma = coex_dm->cur_ps_tdma;
 }
 
+static
 void btc8723b1ant_tdma_dur_adj_for_acl(struct btc_coexist *btcoexist,
 				       u8 wifi_status)
 {
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
index 31965f0ef69d..014df3f8020f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
@@ -833,6 +833,7 @@ static void btc8723b2ant_set_sw_fulltime_dac_swing(struct btc_coexist *btcoex,
 		btc8723b2ant_set_dac_swing_reg(btcoex, 0x18);
 }
 
+static
 void btc8723b2ant_dac_swing(struct btc_coexist *btcoexist,
 			    bool force_exec, bool dac_swing_on,
 			    u32 dac_swing_lvl)
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
index c27488f77573..4c7df8860f4d 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
@@ -1517,6 +1517,7 @@ static void btc8821a2ant_action_bt_inquiry(struct btc_coexist *btcoexist)
 	btc8821a2ant_sw_mechanism2(btcoexist, false, false, false, 0x18);
 }
 
+static
 void btc8821a2ant_action_wifi_link_process(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
index f00d6e6ab69b..4d3e9b920d69 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
@@ -24,6 +24,7 @@
  ******************************************************************************/
 
 #include "halbt_precomp.h"
+#include "rtl_btc.h"
 
 /***********************************************
  *		Global variables
@@ -37,19 +38,6 @@ u32 btc_dbg_type[BTC_MSG_MAX];
  *		Debug related function
  ***************************************************/
 
-const char *const gl_btc_wifi_bw_string[] = {
-	"11bg",
-	"HT20",
-	"HT40",
-	"HT80",
-	"HT160"
-};
-
-const char *const gl_btc_wifi_freq_string[] = {
-	"2.4G",
-	"5G"
-};
-
 static bool halbtc_is_bt_coexist_available(struct btc_coexist *btcoexist)
 {
 	if (!btcoexist->binded || NULL == btcoexist->adapter)
@@ -313,7 +301,7 @@ static u32 halbtc_get_bt_patch_version(struct btc_coexist *btcoexist)
 	return 0;
 }
 
-u32 halbtc_get_wifi_link_status(struct btc_coexist *btcoexist)
+static u32 halbtc_get_wifi_link_status(struct btc_coexist *btcoexist)
 {
 	/* return value:
 	 * [31:16] => connected port number
@@ -671,6 +659,7 @@ static void halbtc_write_4byte(void *bt_context, u32 reg_addr, u32 data)
 	rtl_write_dword(rtlpriv, reg_addr, data);
 }
 
+static
 void halbtc_write_local_reg_1byte(void *btc_context, u32 reg_addr, u8 data)
 {
 	struct btc_coexist *btcoexist = (struct btc_coexist *)btc_context;
@@ -684,22 +673,6 @@ void halbtc_write_local_reg_1byte(void *btc_context, u32 reg_addr, u8 data)
 		rtl_write_byte(rtlpriv, reg_addr, data);
 }
 
-void halbtc_set_macreg(void *btc_context, u32 reg_addr, u32 bit_mask, u32 data)
-{
-	struct btc_coexist *btcoexist = (struct btc_coexist *)btc_context;
-	struct rtl_priv *rtlpriv = btcoexist->adapter;
-
-	rtl_set_bbreg(rtlpriv->mac80211.hw, reg_addr, bit_mask, data);
-}
-
-u32 halbtc_get_macreg(void *btc_context, u32 reg_addr, u32 bit_mask)
-{
-	struct btc_coexist *btcoexist = (struct btc_coexist *)btc_context;
-	struct rtl_priv *rtlpriv = btcoexist->adapter;
-
-	return rtl_get_bbreg(rtlpriv->mac80211.hw, reg_addr, bit_mask);
-}
-
 static void halbtc_set_bbreg(void *bt_context, u32 reg_addr, u32 bit_mask,
 			     u32 data)
 {
@@ -745,6 +718,7 @@ static void halbtc_fill_h2c_cmd(void *bt_context, u8 element_id,
 					cmd_len, cmd_buf);
 }
 
+static
 void halbtc_set_bt_reg(void *btc_context, u8 reg_type, u32 offset, u32 set_val)
 {
 	struct btc_coexist *btcoexist = (struct btc_coexist *)btc_context;
@@ -776,7 +750,7 @@ void halbtc_set_bt_reg(void *btc_context, u8 reg_type, u32 offset, u32 set_val)
 	}
 }
 
-bool halbtc_under_ips(struct btc_coexist *btcoexist)
+static bool halbtc_under_ips(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtlpriv);
@@ -884,34 +858,6 @@ bool exhalbtc_bind_bt_coex_withadapter(void *adapter)
 	return true;
 }
 
-void exhalbtc_power_on_setting(struct btc_coexist *btcoexist)
-{
-	if (!halbtc_is_bt_coexist_available(btcoexist))
-		return;
-
-	btcoexist->statistics.cnt_power_on++;
-
-	if (IS_HARDWARE_TYPE_8723B(btcoexist->adapter)) {
-		if (btcoexist->board_info.btdm_ant_num == 2)
-			ex_btc8723b2ant_power_on_setting(btcoexist);
-		else if (btcoexist->board_info.btdm_ant_num == 1)
-			ex_btc8723b1ant_power_on_setting(btcoexist);
-	}
-}
-
-void exhalbtc_pre_load_firmware(struct btc_coexist *btcoexist)
-{
-	if (!halbtc_is_bt_coexist_available(btcoexist))
-		return;
-
-	btcoexist->statistics.cnt_pre_load_firmware++;
-
-	if (IS_HARDWARE_TYPE_8723B(btcoexist->adapter)) {
-		if (btcoexist->board_info.btdm_ant_num == 2)
-			ex_btc8723b2ant_pre_load_firmware(btcoexist);
-	}
-}
-
 void exhalbtc_init_hw_config(struct btc_coexist *btcoexist)
 {
 	bool wifi_only = true;
@@ -1214,19 +1160,6 @@ void exhalbtc_bt_info_notify(struct btc_coexist *btcoexist,
 	halbtc_normal_low_power(btcoexist);
 }
 
-void exhalbtc_rf_status_notify(struct btc_coexist *btcoexist, u8 type)
-{
-	if (!halbtc_is_bt_coexist_available(btcoexist))
-		return;
-
-	if (IS_HARDWARE_TYPE_8821(btcoexist->adapter)) {
-	} else if (IS_HARDWARE_TYPE_8723B(btcoexist->adapter)) {
-		if (btcoexist->board_info.btdm_ant_num == 1)
-			ex_btc8723b1ant_rf_status_notify(btcoexist, type);
-	} else if (IS_HARDWARE_TYPE_8192E(btcoexist->adapter)) {
-	}
-}
-
 void exhalbtc_stack_operation_notify(struct btc_coexist *btcoexist, u8 type)
 {
 	u8 stack_op_type;
@@ -1362,13 +1295,6 @@ void exhalbtc_dbg_control(struct btc_coexist *btcoexist,
 	halbtc_normal_low_power(btcoexist);
 }
 
-void exhalbtc_antenna_detection(struct btc_coexist *btcoexist, u32 cent_freq,
-				u32 offset, u32 span, u32 seconds)
-{
-	if (!halbtc_is_bt_coexist_available(btcoexist))
-		return;
-}
-
 void exhalbtc_stack_update_profile_info(void)
 {
 }
-- 
2.12.0
