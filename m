Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:35901 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752643AbdFTAcb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Jun 2017 20:32:31 -0400
Received: by mail-oi0-f67.google.com with SMTP id g14so10724096oib.3
        for <linux-wireless@vger.kernel.org>; Mon, 19 Jun 2017 17:32:30 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 05/10] rtlwifi: Add return value to btc_set.
Date: Mon, 19 Jun 2017 19:32:13 -0500
Message-Id: <20170620003218.17010-6-Larry.Finger@lwfinger.net> (sfid-20170620_023246_829804_8287993F)
In-Reply-To: <20170620003218.17010-1-Larry.Finger@lwfinger.net>
References: <20170620003218.17010-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

We will use return value to handle error case.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
index d8fb2442f795..ffa7a517b665 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
@@ -534,6 +534,7 @@ static bool halbtc_set(void *void_btcoexist, u8 set_type, void *in_buf)
 	bool *bool_tmp = (bool *)in_buf;
 	u8 *u8_tmp = (u8 *)in_buf;
 	u32 *u32_tmp = (u32 *)in_buf;
+	bool ret = true;
 
 	if (!halbtc_is_bt_coexist_available(btcoexist))
 		return false;
@@ -577,6 +578,7 @@ static bool halbtc_set(void *void_btcoexist, u8 set_type, void *in_buf)
 
 	/* the following are some action which will be triggered */
 	case BTC_SET_ACT_GET_BT_RSSI:
+		ret = false;
 		break;
 	case BTC_SET_ACT_AGGREGATE_CTRL:
 		halbtc_aggregation_check(btcoexist);
@@ -622,7 +624,7 @@ static bool halbtc_set(void *void_btcoexist, u8 set_type, void *in_buf)
 		break;
 	}
 
-	return true;
+	return ret;
 }
 
 /************************************************************
-- 
2.12.3
