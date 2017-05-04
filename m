Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:33014 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754701AbdEDSrH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 May 2017 14:47:07 -0400
Received: by mail-it0-f67.google.com with SMTP id v135so2730656itv.0
        for <linux-wireless@vger.kernel.org>; Thu, 04 May 2017 11:47:07 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH v2 1/4] rtlwifi: btcoex: Remove 21a 1ant configuration parameter
Date: Thu,  4 May 2017 13:46:58 -0500
Message-Id: <20170504184701.16560-2-Larry.Finger@lwfinger.net> (sfid-20170504_204717_434031_3FBE6BD2)
In-Reply-To: <20170504184701.16560-1-Larry.Finger@lwfinger.net>
References: <20170504184701.16560-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In file halbtc8821a1ant.c, there are directives that depend on an
undocumented configuration parameter BT_AUTO_REPORT_ONLY_8821A_1ANT
that cannot be set from Kconfig. This parameter is replaced by a
boolean in the main structure used by all routines. It still cannot
be changed dynamically, but it is easier to document.

Using a suggestion from Realtek, the auto report is turned on with this
patch.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
v2 - Some earlier patches were missed in v1.
---
 .../realtek/rtlwifi/btcoexist/halbtc8821a1ant.c        | 18 +++++++++---------
 .../realtek/rtlwifi/btcoexist/halbtc8821a1ant.h        |  2 --
 .../wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h  |  5 +++++
 3 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
index 5e9f3b0f7a25..bd5f752f153d 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
@@ -2116,6 +2116,7 @@ static void btc8821a1ant_init_hw_config(struct btc_coexist *btcoexist,
 void ex_btc8821a1ant_init_hwconfig(struct btc_coexist *btcoexist, bool wifionly)
 {
 	btc8821a1ant_init_hw_config(btcoexist, true, wifionly);
+	btcoexist->auto_report_1ant = true;
 }
 
 void ex_btc8821a1ant_init_coex_dm(struct btc_coexist *btcoexist)
@@ -2406,9 +2407,8 @@ void ex_btc8821a1ant_display_coex_info(struct btc_coexist *btcoexist)
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
 		 "\r\n %-35s = %d/ %d", "0x774(low-pri rx/tx)",
 		 coex_sta->low_priority_rx, coex_sta->low_priority_tx);
-#if (BT_AUTO_REPORT_ONLY_8821A_1ANT == 1)
-	btc8821a1ant_monitor_bt_ctr(btcoexist);
-#endif
+	if (btcoexist->auto_report_1ant)
+		btc8821a1ant_monitor_bt_ctr(btcoexist);
 	btcoexist->btc_disp_dbg_msg(btcoexist, BTC_DBG_DISP_COEX_STATISTICS);
 }
 
@@ -2964,10 +2964,10 @@ void ex_btc8821a1ant_periodical(struct btc_coexist *btcoexist)
 			 "[BTCoex], ****************************************************************\n");
 	}
 
-#if (BT_AUTO_REPORT_ONLY_8821A_1ANT == 0)
-	btc8821a1ant_query_bt_info(btcoexist);
-	btc8821a1ant_monitor_bt_ctr(btcoexist);
-#else
-	coex_sta->special_pkt_period_cnt++;
-#endif
+	if (!btcoexist->auto_report_1ant) {
+		btc8821a1ant_query_bt_info(btcoexist);
+		btc8821a1ant_monitor_bt_ctr(btcoexist);
+	} else {
+		coex_sta->special_pkt_period_cnt++;
+	}
 }
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.h
index 1bd1ebe3364e..d6dacf32a4c4 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.h
@@ -27,8 +27,6 @@
  * The following is for 8821A 1ANT BT Co-exist definition
  *===========================================
  */
-#define	BT_AUTO_REPORT_ONLY_8821A_1ANT				0
-
 #define	BT_INFO_8821A_1ANT_B_FTP	BIT7
 #define	BT_INFO_8821A_1ANT_B_A2DP	BIT6
 #define	BT_INFO_8821A_1ANT_B_HID	BIT5
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
index c8271135aaaa..ab2e31a44253 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
@@ -496,6 +496,11 @@ struct btc_coexist {
 	enum btc_chip_interface	chip_interface;
 	struct btc_bt_link_info bt_link_info;
 
+	/* boolean variables to replace BT_AUTO_REPORT_ONLY_XXXXY_ZANT
+	 * configuration parameters
+	 */
+	bool auto_report_1ant;
+	bool auto_report_2ant;
 	bool initilized;
 	bool stop_coex_dm;
 	bool manual_control;
-- 
2.12.2
