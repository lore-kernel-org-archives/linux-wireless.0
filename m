Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49011 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752644AbcB2WFx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:05:53 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 012/113] rtl8xxxu: Initial rtl8723bu chip identification
Date: Mon, 29 Feb 2016 17:04:10 -0500
Message-Id: <1456783551-28315-13-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_232949_542315_7980E2F5)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

This provides initial detection of 8723bu devices, and selects the
correct firmware image to load.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 40 ++++++++++++++++++++++--
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h |  2 +-
 2 files changed, 38 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index b6c20e3..cd0c84a 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -55,6 +55,8 @@ MODULE_FIRMWARE("rtlwifi/rtl8192cufw_A.bin");
 MODULE_FIRMWARE("rtlwifi/rtl8192cufw_B.bin");
 MODULE_FIRMWARE("rtlwifi/rtl8192cufw_TMSC.bin");
 MODULE_FIRMWARE("rtlwifi/rtl8192eu_nic.bin");
+MODULE_FIRMWARE("rtlwifi/rtl8723bu_nic.bin");
+MODULE_FIRMWARE("rtlwifi/rtl8723bu_bt.bin");
 
 module_param_named(debug, rtl8xxxu_debug, int, 0600);
 MODULE_PARM_DESC(debug, "Set debug mask");
@@ -1700,11 +1702,17 @@ static int rtl8xxxu_identify_chip(struct rtl8xxxu_priv *priv)
 	}
 
 	if (val32 & SYS_CFG_BT_FUNC) {
-		sprintf(priv->chip_name, "8723AU");
+		if (priv->chip_cut >= 3) {
+			sprintf(priv->chip_name, "8723BU");
+			priv->rtlchip = 0x8723b;
+		} else {
+			sprintf(priv->chip_name, "8723AU");
+			priv->rtlchip = 0x8723a;
+		}
+
 		priv->rf_paths = 1;
 		priv->rx_paths = 1;
 		priv->tx_paths = 1;
-		priv->rtlchip = 0x8723a;
 
 		val32 = rtl8xxxu_read32(priv, REG_MULTI_FUNC_CTRL);
 		if (val32 & MULTI_WIFI_FUNC_EN)
@@ -1807,6 +1815,7 @@ static int rtl8xxxu_identify_chip(struct rtl8xxxu_priv *priv)
 	 */
 	if (!priv->ep_tx_count) {
 		switch (priv->nr_out_eps) {
+		case 4:
 		case 3:
 			priv->ep_tx_low_queue = 1;
 			priv->ep_tx_count++;
@@ -2321,6 +2330,7 @@ static int rtl8xxxu_load_firmware(struct rtl8xxxu_priv *priv, char *fw_name)
 	case 0x92e0:
 	case 0x92c0:
 	case 0x88c0:
+	case 0x5300:
 	case 0x2300:
 		break;
 	default:
@@ -2362,6 +2372,20 @@ static int rtl8723au_load_firmware(struct rtl8xxxu_priv *priv)
 	return ret;
 }
 
+static int rtl8723bu_load_firmware(struct rtl8xxxu_priv *priv)
+{
+	char *fw_name;
+	int ret;
+
+	if (priv->enable_bluetooth)
+		fw_name = "rtlwifi/rtl8723bu_bt.bin";
+	else
+		fw_name = "rtlwifi/rtl8723bu_nic.bin";
+
+	ret = rtl8xxxu_load_firmware(priv, fw_name);
+	return ret;
+}
+
 #ifdef CONFIG_RTL8XXXU_UNTESTED
 
 static int rtl8192cu_load_firmware(struct rtl8xxxu_priv *priv)
@@ -2587,7 +2611,7 @@ static int rtl8xxxu_init_phy_bb(struct rtl8xxxu_priv *priv)
 	else
 		rtl8xxxu_init_phy_regs(priv, rtl8xxx_agc_standard_table);
 
-	if (priv->rtlchip == 0x8723a &&
+	if ((priv->rtlchip == 0x8723a || priv->rtlchip == 0x8723b) &&
 	    priv->efuse_wifi.efuse8723.version >= 0x01) {
 		val32 = rtl8xxxu_read32(priv, REG_MAC_PHY_CTRL);
 
@@ -6117,6 +6141,14 @@ static struct rtl8xxxu_fileops rtl8723au_fops = {
 	.writeN_block_size = 1024,
 };
 
+static struct rtl8xxxu_fileops rtl8723bu_fops = {
+	.parse_efuse = rtl8723au_parse_efuse,
+	.load_firmware = rtl8723bu_load_firmware,
+	.power_on = rtl8723au_power_on,
+	.llt_init = rtl8xxxu_auto_llt_table,
+	.writeN_block_size = 128,
+};
+
 #ifdef CONFIG_RTL8XXXU_UNTESTED
 
 static struct rtl8xxxu_fileops rtl8192cu_fops = {
@@ -6146,6 +6178,8 @@ static struct usb_device_id dev_table[] = {
 	.driver_info = (unsigned long)&rtl8723au_fops},
 {USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_REALTEK, 0x818b, 0xff, 0xff, 0xff),
 	.driver_info = (unsigned long)&rtl8192eu_fops},
+{USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_REALTEK, 0xb720, 0xff, 0xff, 0xff),
+	.driver_info = (unsigned long)&rtl8723bu_fops},
 #ifdef CONFIG_RTL8XXXU_UNTESTED
 /* Still supported by rtlwifi */
 {USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_REALTEK, 0x8176, 0xff, 0xff, 0xff),
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index 56c4e0a..dd4c563 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -34,7 +34,7 @@
 #define RTL8XXXU_MAX_REG_POLL		500
 #define	USB_INTR_CONTENT_LENGTH		56
 
-#define RTL8XXXU_OUT_ENDPOINTS		3
+#define RTL8XXXU_OUT_ENDPOINTS		4
 
 #define REALTEK_USB_READ		0xc0
 #define REALTEK_USB_WRITE		0x40
-- 
2.5.0

