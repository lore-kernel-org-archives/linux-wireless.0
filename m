Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:59475 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751046AbdGaQLI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 31 Jul 2017 12:11:08 -0400
From: Sven Joachim <svenjoac@gmx.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH v2] rtlwifi: Fix fallback firmware loading
References: <87k22sq0de.fsf@turtle.gmx.de> <87a83noaxw.fsf@turtle.gmx.de>
        <d1c1790d-015d-4dae-8532-42701737eea3@lwfinger.net>
Date: Mon, 31 Jul 2017 18:10:45 +0200
In-Reply-To: <d1c1790d-015d-4dae-8532-42701737eea3@lwfinger.net> (Larry
        Finger's message of "Sun, 30 Jul 2017 18:57:57 -0500")
Message-ID: <87d18gmvsq.fsf_-_@turtle.gmx.de> (sfid-20170731_181113_061448_971F5D06)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit f70e4df2b384 ("rtlwifi: Add code to read new versions of
firmware") added code to load an old firmware file if the new one is
not available.  Unfortunately that code is never reached because
request_firmware_nowait() does not wait for the firmware to show up
and returns 0 even if the file is not there.

Use the existing fallback mechanism introduced by commit 62009b7f1279
("rtlwifi: rtl8192cu: Add new firmware") instead.

Fixes: f70e4df2b384 ("rtlwifi: Add code to read new versions of firmware")
Cc: stable@vger.kernel.org
Signed-off-by: Sven Joachim <svenjoac@gmx.de>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8723be/sw.c | 17 +++++------------
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c | 17 +++++------------
 2 files changed, 10 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/sw.c
index 56c05c4e1499..f47d839f388d 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/sw.c
@@ -187,18 +187,10 @@ int rtl8723be_init_sw_vars(struct ieee80211_hw *hw)
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
-			vfree(rtlpriv->rtlhal.pfirmware);
-			rtlpriv->rtlhal.pfirmware = NULL;
-			return 1;
-		}
+		pr_err("Failed to request firmware!\n");
+		vfree(rtlpriv->rtlhal.pfirmware);
+		rtlpriv->rtlhal.pfirmware = NULL;
+		return 1;
 	}
 	return 0;
 }
@@ -289,6 +281,7 @@ static const struct rtl_hal_cfg rtl8723be_hal_cfg = {
 	.bar_id = 2,
 	.write_readback = true,
 	.name = "rtl8723be_pci",
+	.alt_fw_name = "rtlwifi/rtl8723befw.bin",
 	.ops = &rtl8723be_hal_ops,
 	.mod_params = &rtl8723be_mod_params,
 	.maps[SYS_ISO_CTRL] = REG_SYS_ISO_CTRL,
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c
index ec2d577ba85b..5925edf7877f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c
@@ -216,18 +216,10 @@ int rtl8821ae_init_sw_vars(struct ieee80211_hw *hw)
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
-			vfree(rtlpriv->rtlhal.wowlan_firmware);
-			vfree(rtlpriv->rtlhal.pfirmware);
-			return 1;
-		}
+		pr_err("Failed to request normal firmware!\n");
+		vfree(rtlpriv->rtlhal.wowlan_firmware);
+		vfree(rtlpriv->rtlhal.pfirmware);
+		return 1;
 	}
 	/*load wowlan firmware*/
 	pr_info("Using firmware %s\n", wowlan_fw_name);
@@ -331,6 +323,7 @@ static const struct rtl_hal_cfg rtl8821ae_hal_cfg = {
 	.bar_id = 2,
 	.write_readback = true,
 	.name = "rtl8821ae_pci",
+	.alt_fw_name = "rtlwifi/rtl8821aefw.bin",
 	.ops = &rtl8821ae_hal_ops,
 	.mod_params = &rtl8821ae_mod_params,
 	.maps[SYS_ISO_CTRL] = REG_SYS_ISO_CTRL,
-- 
2.13.3
