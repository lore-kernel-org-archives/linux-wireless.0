Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:34087 "EHLO
	mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411AbcEQWwp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 May 2016 18:52:45 -0400
Received: by mail-pa0-f65.google.com with SMTP id yl2so3028900pac.1
        for <linux-wireless@vger.kernel.org>; Tue, 17 May 2016 15:52:44 -0700 (PDT)
From: Dan Lenski <dlenski@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Dan Lenski <dlenski@gmail.com>, jes.sorensen@redhat.com
Subject: [PATCH] Make firmware startup polling timeout configurable, and increase default
Date: Tue, 17 May 2016 15:48:15 -0700
Message-Id: <1463525295-10818-2-git-send-email-dlenski@gmail.com> (sfid-20160518_005248_190871_1554D490)
In-Reply-To: <1463525295-10818-1-git-send-email-dlenski@gmail.com>
References: <1463525295-10818-1-git-send-email-dlenski@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch:

- increases the default value for the maximum number of polling loops to
  wait for the rtl8xxxu MCU to start after the firmware is loaded (from
  1000 to 5000)
- makes this a configurable module parameter

With RTL8723AU chipset, I frequently encounter "Firmware failed to start"
errors from rtl8xxxu after a cold boot.

It appears that other chipsets supported by the driver have the same
problem. Here are a couple of relevant bug reports:
- http://ubuntuforums.org/showthread.php?t=2321756
- https://www.mail-archive.com/ubuntu-bugs-nLRlyDuq1AZFpShjVBNYrg <at> public.gmane.org/msg4942468.html

This issue seems to occur because RTL8XXXU_FIRMWARE_POLL_MAX (1000) is
too short, and the MCU fails to start up as quickly as expected.

With a longer value (5000), the driver starts up consistently and
successfully after cold-boot.
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 11 +++++++----
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h |  2 +-
 2 files changed, 8 insertions(+), 5 deletions(-)

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
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index f2a1bac..f2838e1 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -49,7 +49,7 @@
 #define TX_PAGE_NUM_NORM_PQ		0x02
 
 #define RTL_FW_PAGE_SIZE		4096
-#define RTL8XXXU_FIRMWARE_POLL_MAX	1000
+#define RTL8XXXU_FIRMWARE_POLL_MAX	5000
 
 #define RTL8723A_CHANNEL_GROUPS		3
 #define RTL8723A_MAX_RF_PATHS		2
-- 
2.8.2

