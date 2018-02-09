Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:38029 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751788AbeBIA52 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Feb 2018 19:57:28 -0500
Received: by mail-pg0-f65.google.com with SMTP id l18so2538879pgc.5
        for <linux-wireless@vger.kernel.org>; Thu, 08 Feb 2018 16:57:28 -0800 (PST)
From: Matthias Kaehlcke <mka@chromium.org>
To: Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Guenter Roeck <groeck@chromium.org>,
        Justin TerAvest <teravest@chromium.org>,
        Craig Bergstrom <craigb@chromium.org>,
        Matthias Kaehlcke <mka@chromium.org>
Subject: [PATCH v2] rtlwifi: rtl8192cu: Remove variable self-assignment in rf.c
Date: Thu,  8 Feb 2018 16:57:12 -0800
Message-Id: <20180209005712.29353-1-mka@chromium.org> (sfid-20180209_015752_416942_71D85BF0)
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

Delete the branch with the self-assignment.

Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
---
Changes in v2:
- Delete the 'else if' branch entirely

 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/rf.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/rf.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/rf.c
index 9cff6bc4049c..cf551785eb08 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/rf.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/rf.c
@@ -299,9 +299,6 @@ static void _rtl92c_get_txpower_writeval_by_regulatory(struct ieee80211_hw *hw,
 			writeVal = 0x00000000;
 		if (rtlpriv->dm.dynamic_txhighpower_lvl == TXHIGHPWRLEVEL_BT1)
 			writeVal = writeVal - 0x06060606;
-		else if (rtlpriv->dm.dynamic_txhighpower_lvl ==
-			 TXHIGHPWRLEVEL_BT2)
-			writeVal = writeVal;
 		*(p_outwriteval + rf) = writeVal;
 	}
 }
-- 
2.16.0.rc1.238.g530d649a79-goog
