Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:41405 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751287AbeEDCmd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 May 2018 22:42:33 -0400
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>
Subject: [PATCH] rtlwifi: remove duplicate definition of antenna number for btcoex
Date: Fri, 4 May 2018 10:42:04 +0800
Message-ID: <20180504024204.6138-1-pkshih@realtek.com> (sfid-20180504_044235_993670_47B85334)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

Two enumerations bt_total_ant_num and bt_ant_num are identical, so one
can be removed.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.c | 4 ++--
 drivers/net/wireless/realtek/rtlwifi/wifi.h         | 5 -----
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.c
index fd7928fdbd1a..3f2295fdb02d 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.c
@@ -2574,11 +2574,11 @@ void rtl92ee_read_bt_coexist_info_from_hwpg(struct ieee80211_hw *hw,
 			rtlpriv->btcoexist.btc_info.btcoexist = 0;
 
 		rtlpriv->btcoexist.btc_info.bt_type = BT_RTL8192E;
-		rtlpriv->btcoexist.btc_info.ant_num = ANT_TOTAL_X2;
+		rtlpriv->btcoexist.btc_info.ant_num = ANT_X2;
 	} else {
 		rtlpriv->btcoexist.btc_info.btcoexist = 1;
 		rtlpriv->btcoexist.btc_info.bt_type = BT_RTL8192E;
-		rtlpriv->btcoexist.btc_info.ant_num = ANT_TOTAL_X1;
+		rtlpriv->btcoexist.btc_info.ant_num = ANT_X1;
 	}
 }
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index ce1754054a07..208010fcde21 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -2842,11 +2842,6 @@ enum bt_co_type {
 	BT_RTL8812A = 11,
 };
 
-enum bt_total_ant_num {
-	ANT_TOTAL_X2 = 0,
-	ANT_TOTAL_X1 = 1
-};
-
 enum bt_cur_state {
 	BT_OFF = 0,
 	BT_ON = 1,
-- 
2.15.1
