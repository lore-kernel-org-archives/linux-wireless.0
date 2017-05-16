Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:35909 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753074AbdEPNUL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 May 2017 09:20:11 -0400
Received: by mail-oi0-f68.google.com with SMTP id w138so3299796oiw.3
        for <linux-wireless@vger.kernel.org>; Tue, 16 May 2017 06:20:10 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 09/10] rtlwifi: btcoex: 23b 1ant: monitor bt is enabled or disabled
Date: Tue, 16 May 2017 08:19:56 -0500
Message-Id: <20170516131957.9513-10-Larry.Finger@lwfinger.net> (sfid-20170516_152019_349943_ED463FA5)
In-Reply-To: <20170516131957.9513-1-Larry.Finger@lwfinger.net>
References: <20170516131957.9513-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

Check BT's status, and record it in field bt_disabled. When BT is disabled,
We do special action called wifi_only.  Also, we move the field from
'struct btc_coexist' to 'struct coex_sta_8723b_1ant'.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
index 9178cccb5ddf..b07883eaec5e 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
@@ -2136,7 +2136,7 @@ void ex_halbtc8723b1ant_display_coex_info(struct btc_coexist *btcoexist)
 
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = [%s/ %d/ %d] ",
 		 "BT [status/ rssi/ retryCnt]",
-		 ((btcoexist->bt_info.bt_disabled) ? ("disabled") :
+		 ((coex_sta->bt_disabled) ? ("disabled") :
 		  ((coex_sta->c2h_bt_inquiry_page) ? ("inquiry/page scan") :
 		   ((BT_8723B_1ANT_BT_STATUS_NON_CONNECTED_IDLE ==
 		     coex_dm->bt_status) ?
@@ -2422,7 +2422,7 @@ void ex_halbtc8723b1ant_connect_notify(struct btc_coexist *btcoexist, u8 type)
 	u8 agg_buf_size = 5;
 
 	if (btcoexist->manual_control || btcoexist->stop_coex_dm ||
-	    btcoexist->bt_info.bt_disabled)
+	    coex_sta->bt_disabled)
 		return;
 
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_LINK_STATUS,
@@ -2472,7 +2472,7 @@ void ex_halbtc8723b1ant_media_status_notify(struct btc_coexist *btcoexist,
 	u8 wifi_central_chnl;
 
 	if (btcoexist->manual_control || btcoexist->stop_coex_dm ||
-	    btcoexist->bt_info.bt_disabled)
+	    coex_sta->bt_disabled)
 		return;
 
 	if (BTC_MEDIA_CONNECT == type)
@@ -2519,7 +2519,7 @@ void ex_halbtc8723b1ant_special_packet_notify(struct btc_coexist *btcoexist,
 	u8 agg_buf_size = 5;
 
 	if (btcoexist->manual_control || btcoexist->stop_coex_dm ||
-	    btcoexist->bt_info.bt_disabled)
+	    coex_sta->bt_disabled)
 		return;
 
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_LINK_STATUS,
-- 
2.12.0
