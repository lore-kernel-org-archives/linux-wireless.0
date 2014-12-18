Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:44624 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbaLRJF6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2014 04:05:58 -0500
Received: by mail-oi0-f53.google.com with SMTP id g201so110075oib.40
        for <linux-wireless@vger.kernel.org>; Thu, 18 Dec 2014 01:05:57 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Troy Tan <troy_tan@realsil.com.cn>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 01/16] rtlwifi: rtl8821ae: Simplify loading of WOWLAN firmware
Date: Thu, 18 Dec 2014 03:05:25 -0600
Message-Id: <1418893540-19944-2-git-send-email-Larry.Finger@lwfinger.net> (sfid-20141218_100612_082239_A0362FFE)
In-Reply-To: <1418893540-19944-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1418893540-19944-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Troy Tan <troy_tan@realsil.com.cn>

The existing method for loading both normal and WOWLAN firmware for the
device duplicates a lot of code. This solution is much cleaner.

Signed-off-by: Troy Tan <troy_tan@realsil.com.cn>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/core.c         | 24 +++++++++-
 drivers/net/wireless/rtlwifi/core.h         |  1 +
 drivers/net/wireless/rtlwifi/rtl8821ae/sw.c | 74 ++++++++++-------------------
 drivers/net/wireless/rtlwifi/wifi.h         |  3 +-
 4 files changed, 48 insertions(+), 54 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/core.c b/drivers/net/wireless/rtlwifi/core.c
index 5fc6f52..deab852 100644
--- a/drivers/net/wireless/rtlwifi/core.c
+++ b/drivers/net/wireless/rtlwifi/core.c
@@ -95,7 +95,8 @@ void rtl_bb_delay(struct ieee80211_hw *hw, u32 addr, u32 data)
 }
 EXPORT_SYMBOL(rtl_bb_delay);
 
-void rtl_fw_cb(const struct firmware *firmware, void *context)
+static void rtl_fw_do_work(const struct firmware *firmware, void *context,
+			   bool is_wow)
 {
 	struct ieee80211_hw *hw = context;
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
@@ -125,12 +126,31 @@ found_alt:
 		release_firmware(firmware);
 		return;
 	}
-	memcpy(rtlpriv->rtlhal.pfirmware, firmware->data, firmware->size);
+	if (!is_wow) {
+		memcpy(rtlpriv->rtlhal.pfirmware, firmware->data,
+		       firmware->size);
+		rtlpriv->rtlhal.fwsize = firmware->size;
+	} else {
+		memcpy(rtlpriv->rtlhal.wowlan_firmware, firmware->data,
+		       firmware->size);
+		rtlpriv->rtlhal.wowlan_fwsize = firmware->size;
+	}
 	rtlpriv->rtlhal.fwsize = firmware->size;
 	release_firmware(firmware);
 }
+
+void rtl_fw_cb(const struct firmware *firmware, void *context)
+{
+	rtl_fw_do_work(firmware, context, false);
+}
 EXPORT_SYMBOL(rtl_fw_cb);
 
+void rtl_wowlan_fw_cb(const struct firmware *firmware, void *context)
+{
+	rtl_fw_do_work(firmware, context, true);
+}
+EXPORT_SYMBOL(rtl_wowlan_fw_cb);
+
 /*mutex for start & stop is must here. */
 static int rtl_op_start(struct ieee80211_hw *hw)
 {
diff --git a/drivers/net/wireless/rtlwifi/core.h b/drivers/net/wireless/rtlwifi/core.h
index 624e1dc..8c87eb5 100644
--- a/drivers/net/wireless/rtlwifi/core.h
+++ b/drivers/net/wireless/rtlwifi/core.h
@@ -37,6 +37,7 @@
 
 extern const struct ieee80211_ops rtl_ops;
 void rtl_fw_cb(const struct firmware *firmware, void *context);
+void rtl_wowlan_fw_cb(const struct firmware *firmware, void *context);
 void rtl_addr_delay(u32 addr);
 void rtl_rfreg_delay(struct ieee80211_hw *hw, enum radio_path rfpath, u32 addr,
 		     u32 mask, u32 data);
diff --git a/drivers/net/wireless/rtlwifi/rtl8821ae/sw.c b/drivers/net/wireless/rtlwifi/rtl8821ae/sw.c
index fc92dd6..a4988121 100644
--- a/drivers/net/wireless/rtlwifi/rtl8821ae/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8821ae/sw.c
@@ -85,52 +85,6 @@ static void rtl8821ae_init_aspm_vars(struct ieee80211_hw *hw)
 	rtlpci->const_support_pciaspm = 1;
 }
 
-static void load_wowlan_fw(struct rtl_priv *rtlpriv)
-{
-	/* callback routine to load wowlan firmware after main fw has
-	 * been loaded
-	 */
-	const struct firmware *wowlan_firmware;
-	char *fw_name = NULL;
-	int err;
-
-	/* for wowlan firmware buf */
-	rtlpriv->rtlhal.wowlan_firmware = vzalloc(0x8000);
-	if (!rtlpriv->rtlhal.wowlan_firmware) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "Can't alloc buffer for wowlan fw.\n");
-		return;
-	}
-
-	if (rtlpriv->rtlhal.hw_type == HARDWARE_TYPE_RTL8821AE)
-		fw_name = "rtlwifi/rtl8821aefw_wowlan.bin";
-	else
-		fw_name = "rtlwifi/rtl8812aefw_wowlan.bin";
-	err = request_firmware(&wowlan_firmware, fw_name, rtlpriv->io.dev);
-	if (err) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "Failed to request wowlan firmware!\n");
-		goto error;
-	}
-
-	if (wowlan_firmware->size > 0x8000) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "Wowlan Firmware is too big!\n");
-		goto error;
-	}
-
-	memcpy(rtlpriv->rtlhal.wowlan_firmware, wowlan_firmware->data,
-	       wowlan_firmware->size);
-	rtlpriv->rtlhal.wowlan_fwsize = wowlan_firmware->size;
-	release_firmware(wowlan_firmware);
-
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD, "WOWLAN FirmwareDownload OK\n");
-	return;
-error:
-	release_firmware(wowlan_firmware);
-	vfree(rtlpriv->rtlhal.wowlan_firmware);
-}
-
 /*InitializeVariables8812E*/
 int rtl8821ae_init_sw_vars(struct ieee80211_hw *hw)
 {
@@ -231,7 +185,6 @@ int rtl8821ae_init_sw_vars(struct ieee80211_hw *hw)
 	else if (rtlpriv->psc.reg_fwctrl_lps == 3)
 		rtlpriv->psc.fwctrl_psmode = FW_PS_DTIM_MODE;
 
-	rtlpriv->rtl_fw_second_cb = load_wowlan_fw;
 	/* for firmware buf */
 	rtlpriv->rtlhal.pfirmware = vzalloc(0x8000);
 	if (!rtlpriv->rtlhal.pfirmware) {
@@ -239,20 +192,41 @@ int rtl8821ae_init_sw_vars(struct ieee80211_hw *hw)
 			 "Can't alloc buffer for fw.\n");
 		return 1;
 	}
+	rtlpriv->rtlhal.wowlan_firmware = vzalloc(0x8000);
+	if (!rtlpriv->rtlhal.wowlan_firmware) {
+		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
+			 "Can't alloc buffer for wowlan fw.\n");
+		return 1;
+	}
 
-	if (rtlhal->hw_type == HARDWARE_TYPE_RTL8812AE)
+	if (rtlhal->hw_type == HARDWARE_TYPE_RTL8812AE) {
 		rtlpriv->cfg->fw_name = "rtlwifi/rtl8812aefw.bin";
-	else
+		rtlpriv->cfg->wowlan_fw_name = "rtlwifi/rtl8812aefw_wowlan.bin";
+	} else {
 		rtlpriv->cfg->fw_name = "rtlwifi/rtl8821aefw.bin";
+		rtlpriv->cfg->wowlan_fw_name = "rtlwifi/rtl8821aefw_wowlan.bin";
+	}
 
 	rtlpriv->max_fw_size = 0x8000;
+	/*load normal firmware*/
 	pr_info("Using firmware %s\n", rtlpriv->cfg->fw_name);
 	err = request_firmware_nowait(THIS_MODULE, 1, rtlpriv->cfg->fw_name,
 				      rtlpriv->io.dev, GFP_KERNEL, hw,
 				      rtl_fw_cb);
 	if (err) {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "Failed to request firmware!\n");
+			 "Failed to request normal firmware!\n");
+		return 1;
+	}
+	/*load wowlan firmware*/
+	pr_info("Using firmware %s\n", rtlpriv->cfg->wowlan_fw_name);
+	err = request_firmware_nowait(THIS_MODULE, 1,
+				      rtlpriv->cfg->wowlan_fw_name,
+				      rtlpriv->io.dev, GFP_KERNEL, hw,
+				      rtl_wowlan_fw_cb);
+	if (err) {
+		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
+			 "Failed to request wowlan firmware!\n");
 		return 1;
 	}
 	return 0;
diff --git a/drivers/net/wireless/rtlwifi/wifi.h b/drivers/net/wireless/rtlwifi/wifi.h
index 6866dcf..a233b26 100644
--- a/drivers/net/wireless/rtlwifi/wifi.h
+++ b/drivers/net/wireless/rtlwifi/wifi.h
@@ -2242,6 +2242,7 @@ struct rtl_hal_cfg {
 	char *name;
 	char *fw_name;
 	char *alt_fw_name;
+	char *wowlan_fw_name;
 	struct rtl_hal_ops *ops;
 	struct rtl_mod_params *mod_params;
 	struct rtl_hal_usbint_cfg *usb_interface_cfg;
@@ -2518,8 +2519,6 @@ struct proxim {
 
 struct rtl_priv {
 	struct ieee80211_hw *hw;
-	/* Used to load a second firmware */
-	void (*rtl_fw_second_cb)(struct rtl_priv *rtlpriv);
 	struct completion firmware_loading_complete;
 	struct list_head list;
 	struct rtl_priv *buddy_priv;
-- 
2.1.2

