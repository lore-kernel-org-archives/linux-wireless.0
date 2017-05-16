Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:34936 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752345AbdEPNUE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 May 2017 09:20:04 -0400
Received: by mail-oi0-f68.google.com with SMTP id m17so3303973oik.2
        for <linux-wireless@vger.kernel.org>; Tue, 16 May 2017 06:20:04 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 02/10] rtlwifi: btcoex: 21a 1ant: fix some coding style issues
Date: Tue, 16 May 2017 08:19:49 -0500
Message-Id: <20170516131957.9513-3-Larry.Finger@lwfinger.net> (sfid-20170516_152028_557617_3902EE7F)
In-Reply-To: <20170516131957.9513-1-Larry.Finger@lwfinger.net>
References: <20170516131957.9513-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

Fix alignment for coding style consistency.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c   | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
index a5ac07cf0dca..93644bedaa0f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
@@ -2839,14 +2839,14 @@ void ex_btc8821a1ant_bt_info_notify(struct btc_coexist *btcoexist,
 	}
 
 	if (BT_INFO_SRC_8821A_1ANT_WIFI_FW != rsp_source) {
-		coex_sta->bt_retry_cnt =	/* [3:0]*/
-			coex_sta->bt_info_c2h[rsp_source][2]&0xf;
+		/* [3:0] */
+		coex_sta->bt_retry_cnt =
+			coex_sta->bt_info_c2h[rsp_source][2] & 0xf;
 
 		coex_sta->bt_rssi =
-			coex_sta->bt_info_c2h[rsp_source][3]*2+10;
+			coex_sta->bt_info_c2h[rsp_source][3] * 2 + 10;
 
-		coex_sta->bt_info_ext =
-			coex_sta->bt_info_c2h[rsp_source][4];
+		coex_sta->bt_info_ext = coex_sta->bt_info_c2h[rsp_source][4];
 
 		/* Here we need to resend some wifi info to BT
 		 * because bt is reset and lost the info
@@ -2928,11 +2928,11 @@ void ex_btc8821a1ant_bt_info_notify(struct btc_coexist *btcoexist,
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], BtInfoNotify(), BT Connected-idle!!!\n");
 	} else if ((bt_info&BT_INFO_8821A_1ANT_B_SCO_ESCO) ||
-		(bt_info&BT_INFO_8821A_1ANT_B_SCO_BUSY)) {
+		(bt_info & BT_INFO_8821A_1ANT_B_SCO_BUSY)) {
 		coex_dm->bt_status = BT_8821A_1ANT_BT_STATUS_SCO_BUSY;
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], BtInfoNotify(), BT SCO busy!!!\n");
-	} else if (bt_info&BT_INFO_8821A_1ANT_B_ACL_BUSY) {
+	} else if (bt_info & BT_INFO_8821A_1ANT_B_ACL_BUSY) {
 		if (BT_8821A_1ANT_BT_STATUS_ACL_BUSY != coex_dm->bt_status)
 			coex_dm->auto_tdma_adjust = false;
 		coex_dm->bt_status = BT_8821A_1ANT_BT_STATUS_ACL_BUSY;
-- 
2.12.0
