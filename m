Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:35298 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753161AbdDJQX0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Apr 2017 12:23:26 -0400
Received: by mail-oi0-f68.google.com with SMTP id g204so13131950oib.2
        for <linux-wireless@vger.kernel.org>; Mon, 10 Apr 2017 09:23:26 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 10/14] rtlwifi: btcoex: 21a 1ant: move bt_disabled to global struct
Date: Mon, 10 Apr 2017 11:23:06 -0500
Message-Id: <20170410162310.7515-11-Larry.Finger@lwfinger.net> (sfid-20170410_182343_937273_89DD3D12)
In-Reply-To: <20170410162310.7515-1-Larry.Finger@lwfinger.net>
References: <20170410162310.7515-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

Move the bt disable flag to a global structure to indicate that bt is
turned off.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8821a1ant.c    | 24 ++++++++++------------
 .../realtek/rtlwifi/btcoexist/halbtc8821a1ant.h    |  1 +
 2 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
index 86eab6a4ada2..c6114b32c0ca 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
@@ -2168,7 +2168,7 @@ void ex_btc8821a1ant_display_coex_info(struct btc_coexist *btcoexist)
 		 "uplink" : "downlink")));
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
 		   "\r\n %-35s = [%s/ %d/ %d] ", "BT [status/ rssi/ retryCnt]",
-		   ((btcoexist->bt_info.bt_disabled) ? ("disabled") :
+		   ((coex_sta->bt_disabled) ? ("disabled") :
 		   ((coex_sta->c2h_bt_inquiry_page) ? ("inquiry/page scan") :
 		   ((BT_8821A_1ANT_BT_STATUS_NON_CONNECTED_IDLE ==
 		     coex_dm->bt_status) ?
@@ -2394,9 +2394,10 @@ void ex_btc8821a1ant_scan_notify(struct btc_coexist *btcoexist, u8 type)
 	u32 num_of_wifi_link = 0;
 	u8 agg_buf_size = 5;
 
-	if (btcoexist->manual_control ||
-	    btcoexist->stop_coex_dm ||
-	    btcoexist->bt_info.bt_disabled)
+	if (btcoexist->manual_control || btcoexist->stop_coex_dm)
+		return;
+
+	if (coex_sta->bt_disabled)
 		return;
 
 	btcoexist->btc_get(btcoexist,
@@ -2456,9 +2457,8 @@ void ex_btc8821a1ant_connect_notify(struct btc_coexist *btcoexist, u8 type)
 	bool bt_ctrl_agg_buf_size = false;
 	u8 agg_buf_size = 5;
 
-	if (btcoexist->manual_control ||
-	    btcoexist->stop_coex_dm ||
-	    btcoexist->bt_info.bt_disabled)
+	if (btcoexist->manual_control || btcoexist->stop_coex_dm ||
+	    coex_sta->bt_disabled)
 		return;
 
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_LINK_STATUS,
@@ -2508,9 +2508,8 @@ void ex_btc8821a1ant_media_status_notify(struct btc_coexist *btcoexist,
 	u32 wifi_bw;
 	u8 wifi_central_chnl;
 
-	if (btcoexist->manual_control ||
-	    btcoexist->stop_coex_dm ||
-	    btcoexist->bt_info.bt_disabled)
+	if (btcoexist->manual_control || btcoexist->stop_coex_dm ||
+	    coex_sta->bt_disabled)
 		return;
 
 	if (BTC_MEDIA_CONNECT == type) {
@@ -2559,9 +2558,8 @@ void ex_btc8821a1ant_special_packet_notify(struct btc_coexist *btcoexist,
 	u32 num_of_wifi_link = 0;
 	u8 agg_buf_size = 5;
 
-	if (btcoexist->manual_control ||
-	    btcoexist->stop_coex_dm ||
-	    btcoexist->bt_info.bt_disabled)
+	if (btcoexist->manual_control || btcoexist->stop_coex_dm ||
+	    coex_sta->bt_disabled)
 		return;
 
 	coex_sta->special_pkt_period_cnt = 0;
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.h
index 9f50a1427388..2dec38ab7746 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.h
@@ -140,6 +140,7 @@ struct coex_dm_8821a_1ant {
 };
 
 struct coex_sta_8821a_1ant {
+	bool	bt_disabled;
 	bool	bt_link_exist;
 	bool	sco_exist;
 	bool	a2dp_exist;
-- 
2.12.0
