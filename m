Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:34274 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932425AbdDQALe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 16 Apr 2017 20:11:34 -0400
Received: by mail-oi0-f67.google.com with SMTP id t14so15969446oif.1
        for <linux-wireless@vger.kernel.org>; Sun, 16 Apr 2017 17:11:34 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 19/27] rtlwifi: btcoex: 23b 1ant: define wifi in high priority task.
Date: Sun, 16 Apr 2017 19:11:03 -0500
Message-Id: <20170417001111.29384-20-Larry.Finger@lwfinger.net> (sfid-20170417_021156_940714_9797A5FA)
In-Reply-To: <20170417001111.29384-1-Larry.Finger@lwfinger.net>
References: <20170417001111.29384-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

Add the definition of wifi in high priority task for bt inquiry.
According to driver's notifications, btc will knows whether wifi is in high
prioirty tasks or not.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c  | 15 +++++++++++++++
 .../wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.h  |  1 +
 2 files changed, 16 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
index 77a9cc782d55..5377f55b162a 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
@@ -2636,6 +2636,7 @@ void ex_halbtc8723b1ant_scan_notify(struct btc_coexist *btcoexist, u8 type)
 		return;
 
 	if (type == BTC_SCAN_START) {
+		coex_sta->wifi_is_high_pri_task = true;
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], SCAN START notify\n");
 		/* Force antenna setup for no scan result issue */
@@ -2650,6 +2651,7 @@ void ex_halbtc8723b1ant_scan_notify(struct btc_coexist *btcoexist, u8 type)
 			 "[BTCoex], 0x948=0x%x, 0x765=0x%x, 0x67=0x%x\n",
 			 u32tmp, u8tmpa, u8tmpb);
 	} else {
+		coex_sta->wifi_is_high_pri_task = false;
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], SCAN FINISH notify\n");
 
@@ -2722,6 +2724,8 @@ void ex_halbtc8723b1ant_connect_notify(struct btc_coexist *btcoexist, u8 type)
 		return;
 
 	if (type == BTC_ASSOCIATE_START) {
+		coex_sta->wifi_is_high_pri_task = true;
+
 		/* Force antenna setup for no scan result issue */
 		halbtc8723b1ant_ps_tdma(btcoexist, FORCE_EXEC, false, 8);
 		halbtc8723b1ant_set_ant_path(btcoexist, BTC_ANT_PATH_PTA,
@@ -2730,6 +2734,7 @@ void ex_halbtc8723b1ant_connect_notify(struct btc_coexist *btcoexist, u8 type)
 			 "[BTCoex], CONNECT START notify\n");
 		coex_dm->arp_cnt = 0;
 	} else {
+		coex_sta->wifi_is_high_pri_task = false;
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], CONNECT FINISH notify\n");
 	}
@@ -2880,11 +2885,21 @@ void ex_halbtc8723b1ant_special_packet_notify(struct btc_coexist *btcoexist,
 			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 				 "[BTCoex], ARP Packet Count = %d\n",
 				 coex_dm->arp_cnt);
+
+			if ((coex_dm->arp_cnt >= 10) && (!under_4way))
+				/* if APR PKT > 10 after connect, do not go to
+				 * ActionWifiConnectedSpecificPacket(btcoexist)
+				 */
+				coex_sta->wifi_is_high_pri_task = false;
+			else
+				coex_sta->wifi_is_high_pri_task = true;
 		} else {
+			coex_sta->wifi_is_high_pri_task = true;
 			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 				 "[BTCoex], special Packet DHCP or EAPOL notify\n");
 		}
 	} else {
+		coex_sta->wifi_is_high_pri_task = false;
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], special Packet [Type = %d] notify\n",
 			 type);
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.h
index 038ac2f7768f..beeed22aa3dc 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.h
@@ -168,6 +168,7 @@ struct coex_sta_8723b_1ant {
 	bool bt_whck_test;
 	bool c2h_bt_inquiry_page;
 	bool c2h_bt_remote_name_req;
+	bool wifi_is_high_pri_task;
 	u8 bt_retry_cnt;
 	u8 bt_info_ext;
 	u8 scan_ap_num;
-- 
2.12.0
