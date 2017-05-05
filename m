Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:34801 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750911AbdEEQR3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 May 2017 12:17:29 -0400
Received: by mail-io0-f196.google.com with SMTP id 12so2446298iol.1
        for <linux-wireless@vger.kernel.org>; Fri, 05 May 2017 09:17:29 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH v2 09/10] rtlwifi: btcoex: 21a 2ant: fix PTA unstable problem when hw init
Date: Fri,  5 May 2017 11:17:11 -0500
Message-Id: <20170505161712.8685-10-Larry.Finger@lwfinger.net> (sfid-20170505_181917_139175_A02FB767)
In-Reply-To: <20170505161712.8685-1-Larry.Finger@lwfinger.net>
References: <20170505161712.8685-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

In the hardware initialisation stage, the PTA circuits may be unstable,
so we reset it after 6 secs to fix the problem.

dis_ver_info_cnt is used to indicate the time after init, and we can set
PTA according to it.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
v2 - resubmit after removal of BT_AUTO_REPORT_XXXX symbols.
---
 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.c    | 38 +++++++---------------
 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.h    |  2 ++
 2 files changed, 14 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
index 1307099a02f3..e61016f660a8 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
@@ -3598,6 +3598,7 @@ void ex_btc8821a2ant_init_hwconfig(struct btc_coexist *btcoexist)
 
 	/* Antenna config */
 	btc8821a2ant_set_ant_path(btcoexist, BTC_ANT_WIFI_AT_MAIN, true, false);
+	coex_sta->dis_ver_info_cnt = 0;
 
 	/* PTA parameter */
 	btc8821a2ant_coex_table_with_type(btcoexist, FORCE_EXEC, 0);
@@ -4245,36 +4246,21 @@ void ex_btc8821a2ant_pnp_notify(struct btc_coexist *btcoexist, u8 pnp_state)
 void ex_btc8821a2ant_periodical(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
-	static u8 dis_ver_info_cnt;
-	struct btc_board_info *board_info = &btcoexist->board_info;
-	struct btc_stack_info *stack_info = &btcoexist->stack_info;
-	u32 fw_ver = 0, bt_patch_ver = 0;
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		 "[BTCoex], ==========================Periodical===========================\n");
 
-	if (dis_ver_info_cnt <= 5) {
-		dis_ver_info_cnt += 1;
-		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-			 "[BTCoex], ****************************************************************\n");
-		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-			 "[BTCoex], Ant PG Num/ Ant Mech/ Ant Pos = %d/ %d/ %d\n",
-			 board_info->pg_ant_num,
-			 board_info->btdm_ant_num,
-			 board_info->btdm_ant_pos);
-		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-			 "[BTCoex], BT stack/ hci ext ver = %s / %d\n",
-			 stack_info->profile_notified ? "Yes" : "No",
-			 stack_info->hci_version);
-		btcoexist->btc_get(btcoexist, BTC_GET_U4_BT_PATCH_VER,
-				   &bt_patch_ver);
-		btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_FW_VER, &fw_ver);
-		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-			 "[BTCoex], CoexVer/ FwVer/ PatchVer = %d_%x/ 0x%x/ 0x%x(%d)\n",
-			 glcoex_ver_date_8821a_2ant, glcoex_ver_8821a_2ant,
-			 fw_ver, bt_patch_ver, bt_patch_ver);
-		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-			 "[BTCoex], ****************************************************************\n");
+	if (coex_sta->dis_ver_info_cnt <= 5) {
+		coex_sta->dis_ver_info_cnt += 1;
+		if (coex_sta->dis_ver_info_cnt == 3) {
+			/* Antenna config to set 0x765 = 0x0 (GNT_BT control by
+			 * PTA) after initial
+			 */
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], Set GNT_BT control by PTA\n");
+			btc8821a2ant_set_ant_path(btcoexist,
+					BTC_ANT_WIFI_AT_MAIN, false, false);
+		}
 	}
 
 #ifdef BT_AUTO_REPORT_ONLY_8821A_2ANT
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.h
index d268f424249f..74edfd75875a 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.h
@@ -168,6 +168,8 @@ struct coex_sta_8821a_2ant {
 
 	u8	coex_table_type;
 	bool	force_lps_on;
+
+	u8	dis_ver_info_cnt;
 };
 
 /*===========================================
-- 
2.12.2
