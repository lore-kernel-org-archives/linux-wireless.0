Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:36295 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754644AbdGKBdc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Jul 2017 21:33:32 -0400
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Stable <stable@vger.kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 2/2] rtlwifi: fix static checker warning of dereferencing freed memory
Date: Mon, 10 Jul 2017 20:33:13 -0500
Message-Id: <20170711013313.3478-3-Larry.Finger@lwfinger.net> (sfid-20170711_033339_033318_FF7E6560)
In-Reply-To: <20170711013313.3478-1-Larry.Finger@lwfinger.net>
References: <20170711013313.3478-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

Patch c76ab8e75442 ("rtlwifi: Fill ap_num field by driver") leads to the
following static checker warning:

	drivers/net/wireless/realtek/rtlwifi/base.c:1741 rtl_scan_list_expire()
	error: dereferencing freed memory 'entry'

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: c76ab8e75442 ("rtlwifi: Fill ap_num field by driver")
Cc: Stable <stable@vger.kernel.org> # 4.12+
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/realtek/rtlwifi/base.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
index d7a1e2d2d529..7074aee35a11 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.c
+++ b/drivers/net/wireless/realtek/rtlwifi/base.c
@@ -1805,13 +1805,13 @@ void rtl_scan_list_expire(struct ieee80211_hw *hw)
 		if (jiffies_to_msecs(jiffies - entry->age) < 180000)
 			continue;
 
+		RT_TRACE(rtlpriv, COMP_SCAN, DBG_LOUD,
+			 "BSSID=%pM is expire in scan list (total=%d)\n",
+			 entry->bssid, rtlpriv->scan_list.num - 1);
+
 		list_del(&entry->list);
 		kfree(entry);
 		rtlpriv->scan_list.num--;
-
-		RT_TRACE(rtlpriv, COMP_SCAN, DBG_LOUD,
-			 "BSSID=%pM is expire in scan list (total=%d)\n",
-			 entry->bssid, rtlpriv->scan_list.num);
 	}
 
 	spin_unlock_irqrestore(&rtlpriv->locks.scan_list_lock, flags);
-- 
2.12.3
