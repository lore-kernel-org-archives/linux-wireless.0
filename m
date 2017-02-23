Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:33798 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751634AbdBWRUS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Feb 2017 12:20:18 -0500
Received: by mail-oi0-f68.google.com with SMTP id f204so1767900oia.1
        for <linux-wireless@vger.kernel.org>; Thu, 23 Feb 2017 09:20:17 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 3/4] rtlwifi: Add code to read new versions of firmware
Date: Thu, 23 Feb 2017 11:19:56 -0600
Message-Id: <20170223171957.22500-4-Larry.Finger@lwfinger.net> (sfid-20170223_182202_828642_D093213E)
In-Reply-To: <20170223171957.22500-1-Larry.Finger@lwfinger.net>
References: <20170223171957.22500-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Changes in the drivers for RTL8723BE and RTL8821AE require corresponding
changes in the firmware. This new firmware has been accepted into the
Linux firmware repo. To handle the case where the kernel has been
updated before the firmware, the new versions have been given new names.
The code will attempt to read the new name, and fall back to the old one
if the new one is not available.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8723be/sw.c | 15 ++++++++++++---
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c | 15 ++++++++++++---
 2 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/sw.c
index 92dbfa8..8c0ac96 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/sw.c
@@ -91,7 +91,7 @@ int rtl8723be_init_sw_vars(struct ieee80211_hw *hw)
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
-	char *fw_name = "rtlwifi/rtl8723befw.bin";
+	char *fw_name = "rtlwifi/rtl8723befw_36.bin";
 
 	rtl8723be_bt_reg_init(hw);
 	rtlpriv->btcoexist.btc_ops = rtl_btc_get_ops_pointer();
@@ -187,8 +187,16 @@ int rtl8723be_init_sw_vars(struct ieee80211_hw *hw)
 				      rtlpriv->io.dev, GFP_KERNEL, hw,
 				      rtl_fw_cb);
 	if (err) {
-		pr_err("Failed to request firmware!\n");
-		return 1;
+		/* Failed to get firmware. Check if old version available */
+		fw_name = "rtlwifi/rtl8723befw.bin";
+		pr_info("Using firmware %s\n", fw_name);
+		err = request_firmware_nowait(THIS_MODULE, 1, fw_name,
+					      rtlpriv->io.dev, GFP_KERNEL, hw,
+					      rtl_fw_cb);
+		if (err) {
+			pr_err("Failed to request firmware!\n");
+			return 1;
+		}
 	}
 	return 0;
 }
@@ -384,6 +392,7 @@ MODULE_AUTHOR("Realtek WlanFAE	<wlanfae@realtek.com>");
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Realtek 8723BE 802.11n PCI wireless");
 MODULE_FIRMWARE("rtlwifi/rtl8723befw.bin");
+MODULE_FIRMWARE("rtlwifi/rtl8723befw_36.bin");
 
 module_param_named(swenc, rtl8723be_mod_params.sw_crypto, bool, 0444);
 module_param_named(debug_level, rtl8723be_mod_params.debug_level, int, 0644);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c
index 77cf3b2..abaf34c 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c
@@ -203,7 +203,7 @@ int rtl8821ae_init_sw_vars(struct ieee80211_hw *hw)
 		fw_name = "rtlwifi/rtl8812aefw.bin";
 		wowlan_fw_name = "rtlwifi/rtl8812aefw_wowlan.bin";
 	} else {
-		fw_name = "rtlwifi/rtl8821aefw.bin";
+		fw_name = "rtlwifi/rtl8821aefw_29.bin";
 		wowlan_fw_name = "rtlwifi/rtl8821aefw_wowlan.bin";
 	}
 
@@ -214,8 +214,16 @@ int rtl8821ae_init_sw_vars(struct ieee80211_hw *hw)
 				      rtlpriv->io.dev, GFP_KERNEL, hw,
 				      rtl_fw_cb);
 	if (err) {
-		pr_err("Failed to request normal firmware!\n");
-		return 1;
+		/* Failed to get firmware. Check if old version available */
+		fw_name = "rtlwifi/rtl8821aefw.bin";
+		pr_info("Using firmware %s\n", fw_name);
+		err = request_firmware_nowait(THIS_MODULE, 1, fw_name,
+					      rtlpriv->io.dev, GFP_KERNEL, hw,
+					      rtl_fw_cb);
+		if (err) {
+			pr_err("Failed to request normal firmware!\n");
+			return 1;
+		}
 	}
 	/*load wowlan firmware*/
 	pr_info("Using firmware %s\n", wowlan_fw_name);
@@ -428,6 +436,7 @@ MODULE_AUTHOR("Realtek WlanFAE	<wlanfae@realtek.com>");
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Realtek 8821ae 802.11ac PCI wireless");
 MODULE_FIRMWARE("rtlwifi/rtl8821aefw.bin");
+MODULE_FIRMWARE("rtlwifi/rtl8821aefw_29.bin");
 
 module_param_named(swenc, rtl8821ae_mod_params.sw_crypto, bool, 0444);
 module_param_named(debug_level, rtl8821ae_mod_params.debug_level, int, 0644);
-- 
2.10.2
