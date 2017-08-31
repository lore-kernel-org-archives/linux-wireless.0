Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:33950 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751285AbdHaOtM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Aug 2017 10:49:12 -0400
Received: by mail-oi0-f67.google.com with SMTP id w10so765807oie.1
        for <linux-wireless@vger.kernel.org>; Thu, 31 Aug 2017 07:49:12 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH] rtlwifi: btcoexist: 23b 1ant: fix duplicated code for different branches
Date: Thu, 31 Aug 2017 09:48:59 -0500
Message-Id: <20170831144859.2291-1-Larry.Finger@lwfinger.net> (sfid-20170831_164916_144904_BF51750E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A typo led to this issue, which was detected with the help of Coccinelle.

In addition to fixing the error, the code is refactored to eliminate an
if statement.

Addresses-Coverity-ID: 1226788

Reported-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Ping-Ke Shih <pkshih@realtek.com>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c    | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
index c04425236ce4..5f726f6d3567 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
@@ -2260,14 +2260,11 @@ static void halbtc8723b1ant_run_coexist_mechanism(struct btc_coexist *btcoexist)
 
 		if (iot_peer != BTC_IOT_PEER_CISCO &&
 		    iot_peer != BTC_IOT_PEER_BROADCOM) {
-			if (bt_link_info->sco_exist)
-				halbtc8723b1ant_limited_rx(btcoexist,
-							   NORMAL_EXEC, false,
-							   false, 0x5);
-			else
-				halbtc8723b1ant_limited_rx(btcoexist,
-							   NORMAL_EXEC, false,
-							   false, 0x5);
+			bool sco_exist = bt_link_info->sco_exist;
+
+			halbtc8723b1ant_limited_rx(btcoexist,
+						   NORMAL_EXEC, sco_exist,
+						   false, 0x5);
 		} else {
 			if (bt_link_info->sco_exist) {
 				halbtc8723b1ant_limited_rx(btcoexist,
-- 
2.12.3
