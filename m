Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:52798 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755798AbdL2Ibn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Dec 2017 03:31:43 -0500
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <yhchuang@realtek.com>, <Larry.Finger@lwfinger.net>,
        <johannes.berg@intel.com>, <linux-wireless@vger.kernel.org>
Subject: [PATCH 08/11] rtlwifi: rtl8723: Add error handling to no existing firmware
Date: Fri, 29 Dec 2017 16:31:09 +0800
Message-ID: <20171229083112.31540-9-pkshih@realtek.com> (sfid-20171229_093249_963638_0361B32F)
In-Reply-To: <20171229083112.31540-1-pkshih@realtek.com>
References: <20171229083112.31540-1-pkshih@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

Without firmware, driver wastes time to download and wait for MCU bootup,
and then kernel core dump finally. If request_firmware fails, the value
max_fw_size=0 is set, so we check the value before downloading firmware.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8723com/fw_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723com/fw_common.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723com/fw_common.c
index efa7e1262461..0d1ebc861720 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723com/fw_common.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723com/fw_common.c
@@ -196,7 +196,7 @@ int rtl8723_download_fw(struct ieee80211_hw *hw,
 	enum version_8723e version = rtlhal->version;
 	int max_page;
 
-	if (!rtlhal->pfirmware)
+	if (rtlpriv->max_fw_size == 0 || !rtlhal->pfirmware)
 		return 1;
 
 	pfwheader = (struct rtlwifi_firmware_header *)rtlhal->pfirmware;
-- 
2.14.1
