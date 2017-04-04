Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:35967 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932308AbdDDQug (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Apr 2017 12:50:36 -0400
Received: by mail-oi0-f66.google.com with SMTP id b187so25705183oif.3
        for <linux-wireless@vger.kernel.org>; Tue, 04 Apr 2017 09:50:36 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 13/13] rtlwifi: btcoex: 23b 2ant: set coex table when wifi is linking
Date: Tue,  4 Apr 2017 11:50:06 -0500
Message-Id: <20170404165006.14329-14-Larry.Finger@lwfinger.net> (sfid-20170404_185039_461402_8196E8DC)
In-Reply-To: <20170404165006.14329-1-Larry.Finger@lwfinger.net>
References: <20170404165006.14329-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

When wifi is under linking process, those packets are important. Mark
them as high priority to protect the linking process

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.c    | 33 ++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
index 4fec175..29b2855 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
@@ -1592,6 +1592,27 @@ static void btc8723b2ant_action_bt_inquiry(struct btc_coexist *btcoexist)
 	btc8723b2ant_sw_mechanism(btcoexist, false, false, false, false);
 }
 
+static void btc8723b2ant_action_wifi_link_process(struct btc_coexist
+						     *btcoexist)
+{
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	u32 u32tmp;
+	u8 u8tmpa, u8tmpb;
+
+	btc8723b2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 15);
+	btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 22);
+
+	btc8723b2ant_sw_mechanism(btcoexist, false, false, false, false);
+
+	u32tmp = btcoexist->btc_read_4byte(btcoexist, 0x948);
+	u8tmpa = btcoexist->btc_read_1byte(btcoexist, 0x765);
+	u8tmpb = btcoexist->btc_read_1byte(btcoexist, 0x76e);
+
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], 0x948 = 0x%x, 0x765 = 0x%x, 0x76e = 0x%x\n",
+		 u32tmp, u8tmpa, u8tmpb);
+}
+
 static bool btc8723b2ant_is_common_action(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
@@ -3409,6 +3430,7 @@ static void btc8723b2ant_run_coexist_mechanism(struct btc_coexist *btcoexist)
 	u32 wifi_link_status = 0;
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
 	bool miracast_plus_bt = false;
+	bool scan = false, link = false, roam = false;
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		 "[BTCoex], RunCoexistMechanism()===>\n");
@@ -3440,6 +3462,17 @@ static void btc8723b2ant_run_coexist_mechanism(struct btc_coexist *btcoexist)
 		}
 	}
 
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_SCAN, &scan);
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_LINK, &link);
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_ROAM, &roam);
+
+	if (scan || link || roam) {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], WiFi is under Link Process !!\n");
+		btc8723b2ant_action_wifi_link_process(btcoexist);
+		return;
+	}
+
 	/* for P2P */
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_LINK_STATUS,
 			   &wifi_link_status);
-- 
2.10.2
