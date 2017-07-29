Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:57298 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753612AbdG2JV5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 29 Jul 2017 05:21:57 -0400
From: Sven Joachim <svenjoac@gmx.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH] rtlwifi: Fix fallback firmware loading
References: <87k22sq0de.fsf@turtle.gmx.de>
Date: Sat, 29 Jul 2017 11:21:31 +0200
In-Reply-To: <87k22sq0de.fsf@turtle.gmx.de> (Sven Joachim's message of "Fri,
        28 Jul 2017 13:14:37 +0200")
Message-ID: <87a83noaxw.fsf@turtle.gmx.de> (sfid-20170729_112202_702939_EDD9AC45)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit f70e4df2 ("rtlwifi: Add code to read new versions of firmware")
added code to load an old firmware file if the new one is not
available.  Unfortunately that code is never reached because
request_firmware_nowait() does not wait for the firmware to show up
and returns 0 even if the file is not there.

Use the existing fallback mechanism introduced by commit
62009b7f ("rtlwifi: rtl8192cu: Add new firmware") instead.

Fixes: f70e4df2b384d21e36a7c30a591639592692e0ec
Cc: stable@vger.kernel.org
Signed-off-by: Sven Joachim <svenjoac@gmx.de>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8723be/sw.c | 13 +++----------
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c | 13 +++----------
 2 files changed, 6 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/sw.c
index f9d10f1e7cf8..1c2d5f6dd3ff 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/sw.c
@@ -187,16 +187,8 @@ int rtl8723be_init_sw_vars(struct ieee80211_hw *hw)
 				      rtlpriv->io.dev, GFP_KERNEL, hw,
 				      rtl_fw_cb);
 	if (err) {
-		/* Failed to get firmware. Check if old version available */
-		fw_name = "rtlwifi/rtl8723befw.bin";
-		pr_info("Using firmware %s\n", fw_name);
-		err = request_firmware_nowait(THIS_MODULE, 1, fw_name,
-					      rtlpriv->io.dev, GFP_KERNEL, hw,
-					      rtl_fw_cb);
-		if (err) {
-			pr_err("Failed to request firmware!\n");
-			return 1;
-		}
+		pr_err("Failed to request firmware!\n");
+		return 1;
 	}
 	return 0;
 }
@@ -287,6 +279,7 @@ static const struct rtl_hal_cfg rtl8723be_hal_cfg = {
 	.bar_id = 2,
 	.write_readback = true,
 	.name = "rtl8723be_pci",
+	.alt_fw_name = "rtlwifi/rtl8723befw.bin",
 	.ops = &rtl8723be_hal_ops,
 	.mod_params = &rtl8723be_mod_params,
 	.maps[SYS_ISO_CTRL] = REG_SYS_ISO_CTRL,
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c
index d71d2776ca03..0801576bfa89 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c
@@ -214,16 +214,8 @@ int rtl8821ae_init_sw_vars(struct ieee80211_hw *hw)
 				      rtlpriv->io.dev, GFP_KERNEL, hw,
 				      rtl_fw_cb);
 	if (err) {
-		/* Failed to get firmware. Check if old version available */
-		fw_name = "rtlwifi/rtl8821aefw.bin";
-		pr_info("Using firmware %s\n", fw_name);
-		err = request_firmware_nowait(THIS_MODULE, 1, fw_name,
-					      rtlpriv->io.dev, GFP_KERNEL, hw,
-					      rtl_fw_cb);
-		if (err) {
-			pr_err("Failed to request normal firmware!\n");
-			return 1;
-		}
+		pr_err("Failed to request normal firmware!\n");
+		return 1;
 	}
 	/*load wowlan firmware*/
 	pr_info("Using firmware %s\n", wowlan_fw_name);
@@ -325,6 +317,7 @@ static const struct rtl_hal_cfg rtl8821ae_hal_cfg = {
 	.bar_id = 2,
 	.write_readback = true,
 	.name = "rtl8821ae_pci",
+	.alt_fw_name = "rtlwifi/rtl8821aefw.bin",
 	.ops = &rtl8821ae_hal_ops,
 	.mod_params = &rtl8821ae_mod_params,
 	.maps[SYS_ISO_CTRL] = REG_SYS_ISO_CTRL,
-- 
2.13.3
