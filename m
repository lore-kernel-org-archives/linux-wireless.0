Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:34002 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932301AbdETPtQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 20 May 2017 11:49:16 -0400
Received: by mail-oi0-f68.google.com with SMTP id w10so16697481oif.1
        for <linux-wireless@vger.kernel.org>; Sat, 20 May 2017 08:49:16 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 04/10] rtlwifi: btcoex: 23b 1ant: remove verbose log from periodic function
Date: Sat, 20 May 2017 10:49:01 -0500
Message-Id: <20170520154907.15590-5-Larry.Finger@lwfinger.net> (sfid-20170520_174930_493033_7433E935)
In-Reply-To: <20170520154907.15590-1-Larry.Finger@lwfinger.net>
References: <20170520154907.15590-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

Simplify the debug trace log.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8723b1ant.c    | 33 ----------------------
 1 file changed, 33 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
index e92ede844e3b..0b9d405e72eb 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
@@ -2377,11 +2377,6 @@ void ex_halbtc8723b1ant_display_coex_info(struct btc_coexist *btcoexist)
 			 "\r\n ==========================================");
 	}
 
-	if (!board_info->bt_exist) {
-		RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n BT not exists !!!");
-		return;
-	}
-
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = %d/ %d/ %d",
 		 "Ant PG Num/ Ant Mech/ Ant Pos:",
 		 board_info->pg_ant_num, board_info->btdm_ant_num,
@@ -3336,38 +3331,10 @@ void ex_halbtc8723b1ant_periodical(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
-	struct btc_board_info *board_info = &btcoexist->board_info;
-	struct btc_stack_info *stack_info = &btcoexist->stack_info;
-	static u8 dis_ver_info_cnt;
-	u32 fw_ver = 0, bt_patch_ver = 0;
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		 "[BTCoex], ==========================Periodical===========================\n");
 
-	if (dis_ver_info_cnt <= 5) {
-		dis_ver_info_cnt += 1;
-		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-			 "[BTCoex], ****************************************************************\n");
-		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-			 "[BTCoex], Ant PG Num/ Ant Mech/ Ant Pos = %d/ %d/ %d\n",
-			 board_info->pg_ant_num, board_info->btdm_ant_num,
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
-			 glcoex_ver_date_8723b_1ant,
-			 glcoex_ver_8723b_1ant, fw_ver,
-			 bt_patch_ver, bt_patch_ver);
-		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-			 "[BTCoex], ****************************************************************\n");
-	}
-
 	if (!btcoexist->auto_report_1ant) {
 		halbtc8723b1ant_query_bt_info(btcoexist);
 		halbtc8723b1ant_monitor_bt_enable_disable(btcoexist);
-- 
2.12.0
