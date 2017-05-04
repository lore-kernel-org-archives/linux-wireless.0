Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:36529 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755886AbdEDSrK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 May 2017 14:47:10 -0400
Received: by mail-it0-f66.google.com with SMTP id x188so2721220itb.3
        for <linux-wireless@vger.kernel.org>; Thu, 04 May 2017 11:47:10 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH v2 4/4] rtlwifi: btcoex: Remove 92e 2ant configuration parameter
Date: Thu,  4 May 2017 13:47:01 -0500
Message-Id: <20170504184701.16560-5-Larry.Finger@lwfinger.net> (sfid-20170504_204721_927664_70DACE11)
In-Reply-To: <20170504184701.16560-1-Larry.Finger@lwfinger.net>
References: <20170504184701.16560-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In file halbtc8192e2ant.c, there are directives that depend on an
undocumented configuration parameter BT_AUTO_REPORT_ONLY_8192E_2ANT
that cannot be set from Kconfig. This parameter is replaced by a
boolean in the main structure used by all routines. It still cannot
be changed dynamically, but it is easier to document.

Upon the advice of Realtek, the auto report option is turned on with
this patch.

Routine btc8192e2ant_is_wifi_status_changed() is restored.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
v2 - Some earlier patches were missed in v1.
---
 .../realtek/rtlwifi/btcoexist/halbtc8192e2ant.c    | 68 ++++++++++++++++------
 .../realtek/rtlwifi/btcoexist/halbtc8192e2ant.h    |  2 -
 2 files changed, 49 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c
index 57e633dbf9a9..9015512ed647 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c
@@ -456,6 +456,39 @@ static void btc8192e2ant_query_bt_info(struct btc_coexist *btcoexist)
 	btcoexist->btc_fill_h2c(btcoexist, 0x61, 1, h2c_parameter);
 }
 
+static
+bool btc8192e2ant_is_wifi_status_changed(struct btc_coexist *btcoexist)
+{
+	static bool pre_wifi_busy = false, pre_under_4way = false,
+		    pre_bt_hs_on = false;
+	bool wifi_busy = false, under_4way = false, bt_hs_on = false;
+	bool wifi_connected = false;
+
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_CONNECTED,
+			   &wifi_connected);
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_BUSY, &wifi_busy);
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_HS_OPERATION, &bt_hs_on);
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_4_WAY_PROGRESS,
+			   &under_4way);
+
+	if (wifi_connected) {
+		if (wifi_busy != pre_wifi_busy) {
+			pre_wifi_busy = wifi_busy;
+			return true;
+		}
+		if (under_4way != pre_under_4way) {
+			pre_under_4way = under_4way;
+			return true;
+		}
+		if (bt_hs_on != pre_bt_hs_on) {
+			pre_bt_hs_on = bt_hs_on;
+			return true;
+		}
+	}
+
+	return false;
+}
+
 static void btc8192e2ant_update_bt_link_info(struct btc_coexist *btcoexist)
 {
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
@@ -2886,9 +2919,8 @@ void ex_btc8192e2ant_display_coex_info(struct btc_coexist *btcoexist)
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = %d/ %d",
 		 "0x774(lp rx[31:16]/tx[15:0])",
 		 coex_sta->low_priority_rx, coex_sta->low_priority_tx);
-#if (BT_AUTO_REPORT_ONLY_8192E_2ANT == 1)
-	btc8192e2ant_monitor_bt_ctr(btcoexist);
-#endif
+	if (btcoexist->auto_report_2ant)
+		btc8192e2ant_monitor_bt_ctr(btcoexist);
 	btcoexist->btc_disp_dbg_msg(btcoexist, BTC_DBG_DISP_COEX_STATISTICS);
 }
 
@@ -3078,14 +3110,12 @@ void ex_btc8192e2ant_bt_info_notify(struct btc_coexist *btcoexist,
 			 */
 		}
 
-#if (BT_AUTO_REPORT_ONLY_8192E_2ANT == 0)
-		if ((coex_sta->bt_info_ext & BIT4)) {
-			/* BT auto report already enabled, do nothing */
-		} else {
-			btc8192e2ant_bt_auto_report(btcoexist, FORCE_EXEC,
-						    true);
+		if (!btcoexist->auto_report_2ant) {
+			if (!(coex_sta->bt_info_ext & BIT4))
+				btc8192e2ant_bt_auto_report(btcoexist,
+							    FORCE_EXEC,
+							    true);
 		}
-#endif
 	}
 
 	/* check BIT2 first ==> check if bt is under inquiry or page scan */
@@ -3207,13 +3237,13 @@ void ex_btc8192e2ant_periodical(struct btc_coexist *btcoexist)
 			 "************************************************\n");
 	}
 
-#if (BT_AUTO_REPORT_ONLY_8192E_2ANT == 0)
-	btc8192e2ant_query_bt_info(btcoexist);
-	btc8192e2ant_monitor_bt_ctr(btcoexist);
-	btc8192e2ant_monitor_bt_enable_disable(btcoexist);
-#else
-	if (btc8192e2ant_is_wifi_status_changed(btcoexist) ||
-	    coex_dm->auto_tdma_adjust)
-		btc8192e2ant_run_coexist_mechanism(btcoexist);
-#endif
+	if (!btcoexist->auto_report_2ant) {
+		btc8192e2ant_query_bt_info(btcoexist);
+		btc8192e2ant_monitor_bt_ctr(btcoexist);
+		btc8192e2ant_monitor_bt_enable_disable(btcoexist);
+	} else {
+		if (btc8192e2ant_is_wifi_status_changed(btcoexist) ||
+		    coex_dm->auto_tdma_adjust)
+			btc8192e2ant_run_coexist_mechanism(btcoexist);
+	}
 }
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.h
index fc0fa87ec404..a57d6947eaf7 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.h
@@ -25,8 +25,6 @@
 /*****************************************************************
  *   The following is for 8192E 2Ant BT Co-exist definition
  *****************************************************************/
-#define	BT_AUTO_REPORT_ONLY_8192E_2ANT			0
-
 #define	BT_INFO_8192E_2ANT_B_FTP			BIT7
 #define	BT_INFO_8192E_2ANT_B_A2DP			BIT6
 #define	BT_INFO_8192E_2ANT_B_HID			BIT5
-- 
2.12.2
