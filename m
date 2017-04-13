Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:36630 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755282AbdDMSHT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Apr 2017 14:07:19 -0400
Received: by mail-oi0-f66.google.com with SMTP id b187so13575806oif.3
        for <linux-wireless@vger.kernel.org>; Thu, 13 Apr 2017 11:07:19 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>
Subject: [PATCH 04/19] rtlwifi: btcoex: 21a 2ant: update bt profiling information
Date: Thu, 13 Apr 2017 13:06:55 -0500
Message-Id: <20170413180710.19953-5-Larry.Finger@lwfinger.net> (sfid-20170413_200922_376161_753399D0)
In-Reply-To: <20170413180710.19953-1-Larry.Finger@lwfinger.net>
References: <20170413180710.19953-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

This function updates the information of bt profiling to help us decide
the network status and dispatch the resource properly.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.c    | 51 +++++++++++++++++++++-
 1 file changed, 49 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
index e23670a23e4d..a9ce79d7f4b4 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
@@ -359,6 +359,54 @@ static void btc8821a2ant_query_bt_info(struct btc_coexist *btcoexist)
 	btcoexist->btc_fill_h2c(btcoexist, 0x61, 1, h2c_parameter);
 }
 
+static void btc8821a2ant_update_bt_link_info(struct btc_coexist *btcoexist)
+{
+	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
+	bool bt_hs_on = false;
+
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_HS_OPERATION, &bt_hs_on);
+
+	bt_link_info->bt_link_exist = coex_sta->bt_link_exist;
+	bt_link_info->sco_exist = coex_sta->sco_exist;
+	bt_link_info->a2dp_exist = coex_sta->a2dp_exist;
+	bt_link_info->pan_exist = coex_sta->pan_exist;
+	bt_link_info->hid_exist = coex_sta->hid_exist;
+
+	/* work around for HS mode. */
+	if (bt_hs_on) {
+		bt_link_info->pan_exist = true;
+		bt_link_info->bt_link_exist = true;
+	}
+
+	/* check if Sco only */
+	if (bt_link_info->sco_exist && !bt_link_info->a2dp_exist &&
+	    !bt_link_info->pan_exist && !bt_link_info->hid_exist)
+		bt_link_info->sco_only = true;
+	else
+		bt_link_info->sco_only = false;
+
+	/* check if A2dp only */
+	if (!bt_link_info->sco_exist && bt_link_info->a2dp_exist &&
+	    !bt_link_info->pan_exist && !bt_link_info->hid_exist)
+		bt_link_info->a2dp_only = true;
+	else
+		bt_link_info->a2dp_only = false;
+
+	/* check if Pan only */
+	if (!bt_link_info->sco_exist && !bt_link_info->a2dp_exist &&
+	    bt_link_info->pan_exist && !bt_link_info->hid_exist)
+		bt_link_info->pan_only = true;
+	else
+		bt_link_info->pan_only = false;
+
+	/* check if Hid only */
+	if (!bt_link_info->sco_exist && !bt_link_info->a2dp_exist &&
+	    !bt_link_info->pan_exist && bt_link_info->hid_exist)
+		bt_link_info->hid_only = true;
+	else
+		bt_link_info->hid_only = false;
+}
+
 static u8 btc8821a2ant_action_algorithm(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
@@ -2856,8 +2904,7 @@ void ex_btc8821a2ant_bt_info_notify(struct btc_coexist *btcoexist,
 			coex_dm->bt_status = BT_8821A_2ANT_BT_STATUS_IDLE;
 		}
 
-		if (bt_hs_on)
-			coex_dm->bt_status = BT_8821A_2ANT_BT_STATUS_NON_IDLE;
+		btc8821a2ant_update_bt_link_info(btcoexist);
 	}
 
 	if (BT_8821A_2ANT_BT_STATUS_NON_IDLE == coex_dm->bt_status)
-- 
2.12.0
