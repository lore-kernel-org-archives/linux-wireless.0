Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:36066 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932380AbdDQALe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 16 Apr 2017 20:11:34 -0400
Received: by mail-oi0-f65.google.com with SMTP id b187so25356714oif.3
        for <linux-wireless@vger.kernel.org>; Sun, 16 Apr 2017 17:11:33 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 18/27] rtlwifi: btcoex: 23b 1ant: Special packets statistic in notification
Date: Sun, 16 Apr 2017 19:11:02 -0500
Message-Id: <20170417001111.29384-19-Larry.Finger@lwfinger.net> (sfid-20170417_021156_363038_A3AB3A79)
In-Reply-To: <20170417001111.29384-1-Larry.Finger@lwfinger.net>
References: <20170417001111.29384-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

Count and log special packets of DHCP, EAPOL and ARP, and check whether
the interface is in 4-way handshake.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8723b1ant.c    | 27 +++++++++++++++++++++-
 .../realtek/rtlwifi/btcoexist/halbtc8723b1ant.h    |  1 +
 2 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
index dddc19054e37..77a9cc782d55 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
@@ -2728,6 +2728,7 @@ void ex_halbtc8723b1ant_connect_notify(struct btc_coexist *btcoexist, u8 type)
 					     FORCE_EXEC, false, false);
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], CONNECT START notify\n");
+		coex_dm->arp_cnt = 0;
 	} else {
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], CONNECT FINISH notify\n");
@@ -2818,6 +2819,7 @@ void ex_halbtc8723b1ant_media_status_notify(struct btc_coexist *btcoexist,
 	} else {
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], MEDIA disconnect notify\n");
+		coex_dm->arp_cnt = 0;
 
 		btcoexist->btc_write_1byte(btcoexist, 0x6cd, 0x0); /* CCK Tx */
 		btcoexist->btc_write_1byte(btcoexist, 0x6cf, 0x0); /* CCK Rx */
@@ -2858,13 +2860,36 @@ void ex_halbtc8723b1ant_special_packet_notify(struct btc_coexist *btcoexist,
 	bool bt_hs_on = false;
 	u32 wifi_link_status = 0;
 	u32 num_of_wifi_link = 0;
-	bool bt_ctrl_agg_buf_size = false;
+	bool bt_ctrl_agg_buf_size = false, under_4way = false;
 	u8 agg_buf_size = 5;
 
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_4_WAY_PROGRESS,
+			   &under_4way);
+
 	if (btcoexist->manual_control || btcoexist->stop_coex_dm ||
 	    coex_sta->bt_disabled)
 		return;
 
+	if (type == BTC_PACKET_DHCP || type == BTC_PACKET_EAPOL ||
+	    type == BTC_PACKET_ARP) {
+		if (type == BTC_PACKET_ARP) {
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], special Packet ARP notify\n");
+
+			coex_dm->arp_cnt++;
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], ARP Packet Count = %d\n",
+				 coex_dm->arp_cnt);
+		} else {
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], special Packet DHCP or EAPOL notify\n");
+		}
+	} else {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], special Packet [Type = %d] notify\n",
+			 type);
+	}
+
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_LINK_STATUS,
 		&wifi_link_status);
 	num_of_wifi_link = wifi_link_status >> 16;
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.h
index 3dd431ac1a51..038ac2f7768f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.h
@@ -136,6 +136,7 @@ struct coex_dm_8723b_1ant {
 	u8 cur_retry_limit_type;
 	u8 pre_ampdu_time_type;
 	u8 cur_ampdu_time_type;
+	u32	arp_cnt;
 
 	u8 error_condition;
 };
-- 
2.12.0
