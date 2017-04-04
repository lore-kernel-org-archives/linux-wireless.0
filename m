Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:34421 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932232AbdDDQu2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Apr 2017 12:50:28 -0400
Received: by mail-oi0-f68.google.com with SMTP id s11so9550260oie.1
        for <linux-wireless@vger.kernel.org>; Tue, 04 Apr 2017 09:50:27 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 05/13] rtlwifi: btcoex: 23b 2ant: fix PTA unstable problem when hw init
Date: Tue,  4 Apr 2017 11:49:58 -0500
Message-Id: <20170404165006.14329-6-Larry.Finger@lwfinger.net> (sfid-20170404_185037_806679_6B16D40A)
In-Reply-To: <20170404165006.14329-1-Larry.Finger@lwfinger.net>
References: <20170404165006.14329-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

In the hardware initialisation stage, the PTA circuits may be unstable,
so we reset it after 6 secs to fix the problem.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.c    | 41 ++++++++--------------
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.h    |  2 ++
 2 files changed, 16 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
index 1f3c2bc..8d8425d 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
@@ -3282,12 +3282,14 @@ void ex_btc8723b2ant_init_hwconfig(struct btc_coexist *btcoexist)
 	/* Antenna config */
 	btc8723b2ant_set_ant_path(btcoexist, BTC_ANT_WIFI_AT_MAIN,
 				  true, false);
+	coex_sta->dis_ver_info_cnt = 0;
+
 	/* PTA parameter */
 	btc8723b2ant_coex_table_with_type(btcoexist, FORCE_EXEC, 0);
 
 	/* Enable counter statistics */
 	/* 0x76e[3] = 1, WLAN_ACT controlled by PTA */
-	btcoexist->btc_write_1byte(btcoexist, 0x76e, 0xc);
+	btcoexist->btc_write_1byte(btcoexist, 0x76e, 0x4);
 	btcoexist->btc_write_1byte(btcoexist, 0x778, 0x3);
 	btcoexist->btc_write_1byte_bitmask(btcoexist, 0x40, 0x20, 0x1);
 }
@@ -3827,36 +3829,21 @@ void ex_btc8723b2ant_halt_notify(struct btc_coexist *btcoexist)
 void ex_btc8723b2ant_periodical(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
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
-			      board_info->pg_ant_num,
-			      board_info->btdm_ant_num,
-			      board_info->btdm_ant_pos);
-		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-			 "[BTCoex], BT stack/ hci ext ver = %s / %d\n",
-			      stack_info->profile_notified ? "Yes" : "No",
-			      stack_info->hci_version);
-		btcoexist->btc_get(btcoexist, BTC_GET_U4_BT_PATCH_VER,
-				   &bt_patch_ver);
-		btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_FW_VER, &fw_ver);
-		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-			 "[BTCoex], CoexVer/ fw_ver/ PatchVer = %d_%x/ 0x%x/ 0x%x(%d)\n",
-			      glcoex_ver_date_8723b_2ant, glcoex_ver_8723b_2ant,
-			      fw_ver, bt_patch_ver, bt_patch_ver);
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
+			btc8723b2ant_set_ant_path(
+				btcoexist, BTC_ANT_WIFI_AT_MAIN, false, false);
+		}
 	}
 
 #if (BT_AUTO_REPORT_ONLY_8723B_2ANT == 0)
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.h
index 9f41206..57eac22 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.h
@@ -167,6 +167,8 @@ struct coex_sta_8723b_2ant {
 	u32 crc_err_11n_agg;
 	bool force_lps_on;
 
+	u8 dis_ver_info_cnt;
+
 	u8 a2dp_bit_pool;
 };
 
-- 
2.10.2
