Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:36268 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753877AbdDFUUF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Apr 2017 16:20:05 -0400
Received: by mail-oi0-f68.google.com with SMTP id b187so8910064oif.3
        for <linux-wireless@vger.kernel.org>; Thu, 06 Apr 2017 13:20:05 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 02/11] rtlwifi: btcoex: 23b 2ant: treat too many low prio packets as retry
Date: Thu,  6 Apr 2017 15:19:49 -0500
Message-Id: <20170406201958.25642-3-Larry.Finger@lwfinger.net> (sfid-20170406_222054_831044_9B29DE2A)
In-Reply-To: <20170406201958.25642-1-Larry.Finger@lwfinger.net>
References: <20170406201958.25642-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
index 327609e3a309..82a5e5357cb7 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
@@ -1884,6 +1884,11 @@ static void btc8723b2ant_tdma_duration_adjust(struct btc_coexist *btcoexist,
 	} else {
 		/*accquire the BT TRx retry count from BT_Info byte2*/
 		retry_count = coex_sta->bt_retry_cnt;
+
+		if ((coex_sta->low_priority_tx) > 1050 ||
+		    (coex_sta->low_priority_rx) > 1250)
+			retry_count++;
+
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], retry_count = %d\n", retry_count);
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-- 
2.12.0
