Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:33377 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751390AbdITVPM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Sep 2017 17:15:12 -0400
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Stable <stable@vger.kernel.org>,
        Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH] rtlwifi: rtl8821ae: Fix connection lost problem
Date: Wed, 20 Sep 2017 16:15:05 -0500
Message-Id: <20170920211505.26171-1-Larry.Finger@lwfinger.net> (sfid-20170920_231515_605890_6AE7214F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In commit 40b368af4b75 ("rtlwifi: Fix alignment issues"), the read
of REG_DBI_READ was changed from 16 to 8 bits. For unknown reasonsi
this change results in reduced stability for the wireless connection.
This regression was located using bisection.

Fixes: 40b368af4b75 ("rtlwifi: Fix alignment issues")
Reported-and-tested-by: James Cameron <quozl@laptop.org>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org> # 4.11+
Cc: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
index 3571ce4bd276..ac2ce86de506 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
@@ -1122,7 +1122,7 @@ static u8 _rtl8821ae_dbi_read(struct rtl_priv *rtlpriv, u16 addr)
 	}
 	if (0 == tmp) {
 		read_addr = REG_DBI_RDATA + addr % 4;
-		ret = rtl_read_byte(rtlpriv, read_addr);
+		ret = rtl_read_word(rtlpriv, read_addr);
 	}
 	return ret;
 }
-- 
2.12.3
