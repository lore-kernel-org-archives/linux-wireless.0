Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:36595 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752151AbeF1CCl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Jun 2018 22:02:41 -0400
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <linux-wireless@vger.kernel.org>, <Larry.Finger@lwfinger.net>,
        <stable@vger.kernel.org>
Subject: [PATCH v3] rtlwifi: rtl8821ae: fix firmware is not ready to run
Date: Thu, 28 Jun 2018 10:02:27 +0800
Message-ID: <20180628020227.8776-1-pkshih@realtek.com> (sfid-20180628_040244_902203_5F9E153A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

Without this patch, firmware will not run properly on rtl8821ae, and it
causes bad user experience. For example, bad connection performance with
low rate, higher power consumption, and so on.

rtl8821ae uses two kinds of firmwares for normal and WoWlan cases, and
each firmware has firmware data buffer and size individually. Original
code always overwrite size of normal firmware rtlpriv->rtlhal.fwsize, and
this mismatch causes firmware checksum error, then firmware can't start.

In this situation, driver gives message "Firmware is not ready to run!".

Fixes: fe89707f0afa ("rtlwifi: rtl8821ae: Simplify loading of WOWLAN firmware")
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Cc: Stable <stable@vger.kernel.org> # 4.0+
Reviewed-by: Larry Finger <Larry.Finger@lwfinger.net>
---
V3: Add more commit logs, Cc and Reviewed-by. Thank you, Larry.
v2: fix commit log typo.
---
 drivers/net/wireless/realtek/rtlwifi/core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/core.c b/drivers/net/wireless/realtek/rtlwifi/core.c
index a3f46203ee7a..4bf7967590ca 100644
--- a/drivers/net/wireless/realtek/rtlwifi/core.c
+++ b/drivers/net/wireless/realtek/rtlwifi/core.c
@@ -130,7 +130,6 @@ static void rtl_fw_do_work(const struct firmware *firmware, void *context,
 		       firmware->size);
 		rtlpriv->rtlhal.wowlan_fwsize = firmware->size;
 	}
-	rtlpriv->rtlhal.fwsize = firmware->size;
 	release_firmware(firmware);
 }
 
-- 
2.15.1
