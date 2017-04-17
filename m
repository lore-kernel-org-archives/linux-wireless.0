Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:35807 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932307AbdDQALV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 16 Apr 2017 20:11:21 -0400
Received: by mail-oi0-f67.google.com with SMTP id a21so8760264oic.2
        for <linux-wireless@vger.kernel.org>; Sun, 16 Apr 2017 17:11:21 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 05/27] rtlwifi: btcoex: 23b 1ant: check if BT high priority packet exist
Date: Sun, 16 Apr 2017 19:10:49 -0500
Message-Id: <20170417001111.29384-6-Larry.Finger@lwfinger.net> (sfid-20170417_021128_738616_DD413260)
In-Reply-To: <20170417001111.29384-1-Larry.Finger@lwfinger.net>
References: <20170417001111.29384-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

If there are BT high priority packets, we arrange more time to BT.
To make user experience to  be better, HID and SCO are also seen as
high priority packet exist.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c  | 11 +++++++++++
 .../net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.h  |  1 +
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h |  1 +
 3 files changed, 13 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
index 851c11d18d9c..52b138d548f3 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
@@ -407,6 +407,7 @@ static void halbtc8723b1ant_update_bt_link_info(struct btc_coexist *btcoexist)
 	bt_link_info->a2dp_exist = coex_sta->a2dp_exist;
 	bt_link_info->pan_exist = coex_sta->pan_exist;
 	bt_link_info->hid_exist = coex_sta->hid_exist;
+	bt_link_info->bt_hi_pri_link_exist = coex_sta->bt_hi_pri_link_exist;
 
 	/* work around for HS mode. */
 	if (bt_hs_on) {
@@ -2563,6 +2564,8 @@ void ex_halbtc8723b1ant_bt_info_notify(struct btc_coexist *btcoexist,
 		coex_sta->a2dp_exist = false;
 		coex_sta->hid_exist = false;
 		coex_sta->sco_exist = false;
+
+		coex_sta->bt_hi_pri_link_exist = false;
 	} else {
 		/* connection exists */
 		coex_sta->bt_link_exist = true;
@@ -2582,6 +2585,14 @@ void ex_halbtc8723b1ant_bt_info_notify(struct btc_coexist *btcoexist,
 			coex_sta->sco_exist = true;
 		else
 			coex_sta->sco_exist = false;
+
+		/* Add Hi-Pri Tx/Rx counter to avoid false detection */
+		if (((coex_sta->hid_exist) || (coex_sta->sco_exist)) &&
+		    (coex_sta->high_priority_tx + coex_sta->high_priority_rx >=
+		     160) &&
+		    (!coex_sta->c2h_bt_inquiry_page))
+			coex_sta->bt_hi_pri_link_exist = true;
+
 	}
 
 	halbtc8723b1ant_update_bt_link_info(btcoexist);
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.h
index c3472fbb12ef..b86a28f519aa 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.h
@@ -143,6 +143,7 @@ struct coex_sta_8723b_1ant {
 	bool a2dp_exist;
 	bool hid_exist;
 	bool pan_exist;
+	bool bt_hi_pri_link_exist;
 
 	bool under_lps;
 	bool under_ips;
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
index c8271135aaaa..911db7680478 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
@@ -468,6 +468,7 @@ struct btc_statistics {
 
 struct btc_bt_link_info {
 	bool bt_link_exist;
+	bool bt_hi_pri_link_exist;
 	bool sco_exist;
 	bool sco_only;
 	bool a2dp_exist;
-- 
2.12.0
