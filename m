Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:33041 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754320AbeBGU0z (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Feb 2018 15:26:55 -0500
Received: by mail-pf0-f193.google.com with SMTP id u15so822909pfa.0
        for <linux-wireless@vger.kernel.org>; Wed, 07 Feb 2018 12:26:55 -0800 (PST)
From: Matthias Kaehlcke <mka@chromium.org>
To: Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Guenter Roeck <groeck@chromium.org>,
        Justin TerAvest <teravest@chromium.org>,
        Craig Bergstrom <craigb@chromium.org>,
        Matthias Kaehlcke <mka@chromium.org>
Subject: [PATCH] rtlwifi: rtl8192cu: Remove variable self-assignment in rf.c
Date: Wed,  7 Feb 2018 12:26:34 -0800
Message-Id: <20180207202634.98937-1-mka@chromium.org> (sfid-20180207_212746_610093_D087C94C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In _rtl92c_get_txpower_writeval_by_regulatory() the variable writeVal
is assigned to itself in an if ... else statement, apparently only to
document that the branch condition is handled and that a previously read
value should be returned unmodified. The self-assignment causes clang to
raise the following warning:

drivers/net/wireless/realtek/rtlwifi/rtl8192cu/rf.c:304:13:
  error: explicitly assigning value of variable of type 'u32'
    (aka 'unsigned int') to itself [-Werror,-Wself-assign]
  writeVal = writeVal;

Replace the self-assignment with a semicolon, which still serves to
document the 'handling' of the branch condition.

Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/rf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/rf.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/rf.c
index 9cff6bc4049c..4db92496c122 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/rf.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/rf.c
@@ -301,7 +301,7 @@ static void _rtl92c_get_txpower_writeval_by_regulatory(struct ieee80211_hw *hw,
 			writeVal = writeVal - 0x06060606;
 		else if (rtlpriv->dm.dynamic_txhighpower_lvl ==
 			 TXHIGHPWRLEVEL_BT2)
-			writeVal = writeVal;
+			;
 		*(p_outwriteval + rf) = writeVal;
 	}
 }
-- 
2.16.0.rc1.238.g530d649a79-goog
