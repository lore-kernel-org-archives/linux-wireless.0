Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:35219 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752152AbdEDSrJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 May 2017 14:47:09 -0400
Received: by mail-it0-f66.google.com with SMTP id 131so2730529itz.2
        for <linux-wireless@vger.kernel.org>; Thu, 04 May 2017 11:47:09 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH v2 3/4] rtlwifi: btcoex: Remove 23b 2ant configuration parameter
Date: Thu,  4 May 2017 13:47:00 -0500
Message-Id: <20170504184701.16560-4-Larry.Finger@lwfinger.net> (sfid-20170504_204718_530626_83ED39BE)
In-Reply-To: <20170504184701.16560-1-Larry.Finger@lwfinger.net>
References: <20170504184701.16560-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In file halbtc8723b2ant.c, there are directives that depend on an
undocumented configuration parameter BT_AUTO_REPORT_ONLY_8723B_2ANT
that cannot be set from Kconfig. This parameter is replaced by a
boolean in the main structure used by all routines. It still cannot
be changed dynamically, but it is easier to document.

Routines halbtc8723b2ant_set_bt_auto_report(), and
btc8723b2ant_bt_auto_report() are restored.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
v2 - Some earlier patches were missed in v1.
---
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.c    | 79 +++++++++++++++-------
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.h    |  2 -
 2 files changed, 53 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
index 2f3946be4ce2..b071ea2728fc 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
@@ -707,6 +707,36 @@ static void btc8723b2ant_dec_bt_pwr(struct btc_coexist *btcoexist,
 	coex_dm->pre_dec_bt_pwr_lvl = coex_dm->cur_dec_bt_pwr_lvl;
 }
 
+static
+void halbtc8723b2ant_set_bt_auto_report(struct btc_coexist *btcoexist,
+					bool enable_auto_report)
+{
+	u8 h2c_parameter[1] = {0};
+
+	h2c_parameter[0] = 0;
+
+	if (enable_auto_report)
+		h2c_parameter[0] |= BIT(0);
+
+	btcoexist->btc_fill_h2c(btcoexist, 0x68, 1, h2c_parameter);
+}
+
+static
+void btc8723b2ant_bt_auto_report(struct btc_coexist *btcoexist,
+				 bool force_exec, bool enable_auto_report)
+{
+	coex_dm->cur_bt_auto_report = enable_auto_report;
+
+	if (!force_exec) {
+		if (coex_dm->pre_bt_auto_report == coex_dm->cur_bt_auto_report)
+			return;
+	}
+	halbtc8723b2ant_set_bt_auto_report(btcoexist,
+					   coex_dm->cur_bt_auto_report);
+
+	coex_dm->pre_bt_auto_report = coex_dm->cur_bt_auto_report;
+}
+
 static void btc8723b2ant_fw_dac_swing_lvl(struct btc_coexist *btcoexist,
 					  bool force_exec, u8 fw_dac_swing_lvl)
 {
@@ -3666,6 +3696,7 @@ void ex_btc8723b2ant_init_hwconfig(struct btc_coexist *btcoexist)
 	btcoexist->btc_write_1byte(btcoexist, 0x76e, 0x4);
 	btcoexist->btc_write_1byte(btcoexist, 0x778, 0x3);
 	btcoexist->btc_write_1byte_bitmask(btcoexist, 0x40, 0x20, 0x1);
+	btcoexist->auto_report_2ant = true;
 }
 
 void ex_btc8723b2ant_power_on_setting(struct btc_coexist *btcoexist)
@@ -3966,9 +3997,8 @@ void ex_btc8723b2ant_display_coex_info(struct btc_coexist *btcoexist)
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = %d/ %d",
 		 "0x774(low-pri rx/tx)", coex_sta->low_priority_rx,
 		 coex_sta->low_priority_tx);
-#if (BT_AUTO_REPORT_ONLY_8723B_2ANT == 1)
-	btc8723b2ant_monitor_bt_ctr(btcoexist);
-#endif
+	if (btcoexist->auto_report_2ant)
+		btc8723b2ant_monitor_bt_ctr(btcoexist);
 	btcoexist->btc_disp_dbg_msg(btcoexist,
 	BTC_DBG_DISP_COEX_STATISTICS);
 }
@@ -4190,14 +4220,11 @@ void ex_btc8723b2ant_bt_info_notify(struct btc_coexist *btcoexist,
 		} else {
 			/* BT already NOT ignore Wlan active, do nothing here.*/
 		}
-#if (BT_AUTO_REPORT_ONLY_8723B_2ANT == 0)
-		if ((coex_sta->bt_info_ext & BIT4)) {
-			/* BT auto report already enabled, do nothing*/
-		} else {
-			btc8723b2ant_bt_auto_report(btcoexist, FORCE_EXEC,
-						    true);
+		if (!btcoexist->auto_report_2ant) {
+			if (!(coex_sta->bt_info_ext & BIT4))
+				btc8723b2ant_bt_auto_report(btcoexist,
+							    FORCE_EXEC, true);
 		}
-#endif
 	}
 
 	/* check BIT2 first ==> check if bt is under inquiry or page scan */
@@ -4347,21 +4374,22 @@ void ex_btc8723b2ant_periodical(struct btc_coexist *btcoexist)
 		}
 	}
 
-#if (BT_AUTO_REPORT_ONLY_8723B_2ANT == 0)
-	btc8723b2ant_query_bt_info(btcoexist);
-#else
-	btc8723b2ant_monitor_bt_ctr(btcoexist);
-	btc8723b2ant_monitor_wifi_ctr(btcoexist);
+	if (!btcoexist->auto_report_2ant) {
+		btc8723b2ant_query_bt_info(btcoexist);
+	} else {
+		btc8723b2ant_monitor_bt_ctr(btcoexist);
+		btc8723b2ant_monitor_wifi_ctr(btcoexist);
 
-	/* for some BT speakers that High-Priority pkts appear before
-	 * playing, this will cause HID exist
-	 */
-	if ((coex_sta->high_priority_tx + coex_sta->high_priority_rx < 50) &&
-	    (bt_link_info->hid_exist))
-		bt_link_info->hid_exist = false;
-
-	if (btc8723b2ant_is_wifi_status_changed(btcoexist) ||
-	    coex_dm->auto_tdma_adjust)
-		btc8723b2ant_run_coexist_mechanism(btcoexist);
-#endif
+		/* for some BT speakers that High-Priority pkts appear before
+		 * playing, this will cause HID exist
+		 */
+		if ((coex_sta->high_priority_tx +
+		    coex_sta->high_priority_rx < 50) &&
+		    (bt_link_info->hid_exist))
+			bt_link_info->hid_exist = false;
+
+		if (btc8723b2ant_is_wifi_status_changed(btcoexist) ||
+		    coex_dm->auto_tdma_adjust)
+			btc8723b2ant_run_coexist_mechanism(btcoexist);
+	}
 }
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.h
index 18a35c7faba9..50726beaeead 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.h
@@ -28,8 +28,6 @@
 /************************************************************************
  * The following is for 8723B 2Ant BT Co-exist definition
  ************************************************************************/
-#define	BT_AUTO_REPORT_ONLY_8723B_2ANT			1
-
 #define	BT_INFO_8723B_2ANT_B_FTP			BIT7
 #define	BT_INFO_8723B_2ANT_B_A2DP			BIT6
 #define	BT_INFO_8723B_2ANT_B_HID			BIT5
-- 
2.12.2
