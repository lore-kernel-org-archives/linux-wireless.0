Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:35290 "EHLO
	mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362AbcERBP3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 May 2016 21:15:29 -0400
Received: by mail-pf0-f196.google.com with SMTP id b66so3395763pfb.2
        for <linux-wireless@vger.kernel.org>; Tue, 17 May 2016 18:15:29 -0700 (PDT)
From: Dan Lenski <dlenski@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Dan Lenski <dlenski@gmail.com>, jes.sorensen@redhat.com
Subject: [PATCH 2/2] rtl8xxxu: Make polling timeout for firmware configurable
Date: Tue, 17 May 2016 18:14:46 -0700
Message-Id: <1463534086-22353-3-git-send-email-dlenski@gmail.com> (sfid-20160518_031532_918884_487F3303)
In-Reply-To: <1463534086-22353-1-git-send-email-dlenski@gmail.com>
References: <1463534086-22353-1-git-send-email-dlenski@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch makes RTL8XXXU_FIRMWARE_POLL_MAX into a configurable module
parameter, firmware_poll_max.

Signed-off-by: Dan Lenski <dlenski@gmail.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 6aed923..a1efb2c 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -44,6 +44,7 @@
 
 static int rtl8xxxu_debug;
 static bool rtl8xxxu_ht40_2g;
+static int rtl8xxxu_firmware_poll_max = RTL8XXXU_FIRMWARE_POLL_MAX;
 
 MODULE_AUTHOR("Jes Sorensen <Jes.Sorensen@redhat.com>");
 MODULE_DESCRIPTION("RTL8XXXu USB mac80211 Wireless LAN Driver");
@@ -59,6 +60,8 @@ module_param_named(debug, rtl8xxxu_debug, int, 0600);
 MODULE_PARM_DESC(debug, "Set debug mask");
 module_param_named(ht40_2g, rtl8xxxu_ht40_2g, bool, 0600);
 MODULE_PARM_DESC(ht40_2g, "Enable HT40 support on the 2.4GHz band");
+module_param_named(firmware_poll_max, rtl8xxxu_firmware_poll_max, int, 0600);
+MODULE_PARM_DESC(firmware_poll_max, "Maximum polling count for firmware startup (increase if firmware fails to start)");
 
 #define USB_VENDOR_ID_REALTEK		0x0bda
 /* Minimum IEEE80211_MAX_FRAME_LEN */
@@ -2050,13 +2053,13 @@ static int rtl8xxxu_start_firmware(struct rtl8xxxu_priv *priv)
 	u32 val32;
 
 	/* Poll checksum report */
-	for (i = 0; i < RTL8XXXU_FIRMWARE_POLL_MAX; i++) {
+	for (i = 0; i < rtl8xxxu_firmware_poll_max; i++) {
 		val32 = rtl8xxxu_read32(priv, REG_MCU_FW_DL);
 		if (val32 & MCU_FW_DL_CSUM_REPORT)
 			break;
 	}
 
-	if (i == RTL8XXXU_FIRMWARE_POLL_MAX) {
+	if (i == rtl8xxxu_firmware_poll_max) {
 		dev_warn(dev, "Firmware checksum poll timed out\n");
 		ret = -EAGAIN;
 		goto exit;
@@ -2068,7 +2071,7 @@ static int rtl8xxxu_start_firmware(struct rtl8xxxu_priv *priv)
 	rtl8xxxu_write32(priv, REG_MCU_FW_DL, val32);
 
 	/* Wait for firmware to become ready */
-	for (i = 0; i < RTL8XXXU_FIRMWARE_POLL_MAX; i++) {
+	for (i = 0; i < rtl8xxxu_firmware_poll_max; i++) {
 		val32 = rtl8xxxu_read32(priv, REG_MCU_FW_DL);
 		if (val32 & MCU_WINT_INIT_READY)
 			break;
@@ -2076,7 +2079,7 @@ static int rtl8xxxu_start_firmware(struct rtl8xxxu_priv *priv)
 		udelay(100);
 	}
 
-	if (i == RTL8XXXU_FIRMWARE_POLL_MAX) {
+	if (i == rtl8xxxu_firmware_poll_max) {
 		dev_warn(dev, "Firmware failed to start\n");
 		ret = -EAGAIN;
 		goto exit;
-- 
2.8.2

