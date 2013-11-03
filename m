Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:60513 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753754Ab3KCTCv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Nov 2013 14:02:51 -0500
Received: by mail-we0-f169.google.com with SMTP id q58so1339419wes.0
        for <linux-wireless@vger.kernel.org>; Sun, 03 Nov 2013 11:02:50 -0800 (PST)
Message-ID: <1383505361.3130.3.camel@canaries32-MCP7A> (sfid-20131103_200309_069118_91EE50A0)
Subject: [PATCH] staging: vt6656: main_usb.c ether_crc use kernel code
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Sun, 03 Nov 2013 19:02:41 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

use ether_crc already in kernel and remove local version.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h   |  1 +
 drivers/staging/vt6656/main_usb.c | 16 ----------------
 2 files changed, 1 insertion(+), 16 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 739cda4..b7a6e14 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -44,6 +44,7 @@
 #include <net/cfg80211.h>
 #include <linux/timer.h>
 #include <linux/usb.h>
+#include <linux/crc32.h>
 
 #ifdef SIOCETHTOOL
 #define DEVICE_ETHTOOL_IOCTL_SUPPORT
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 21805c6..4cb7aa7 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -1194,22 +1194,6 @@ out:
 	return NETDEV_TX_OK;
 }
 
-static unsigned const ethernet_polynomial = 0x04c11db7U;
-static inline u32 ether_crc(int length, unsigned char *data)
-{
-    int crc = -1;
-
-    while(--length >= 0) {
-        unsigned char current_octet = *data++;
-        int bit;
-        for (bit = 0; bit < 8; bit++, current_octet >>= 1) {
-            crc = (crc << 1) ^
-                ((crc < 0) ^ (current_octet & 1) ? ethernet_polynomial : 0);
-        }
-    }
-    return crc;
-}
-
 /* find out the start position of str2 from str1 */
 static unsigned char *kstrstr(const unsigned char *str1,
 			      const unsigned char *str2) {
-- 
1.8.3.2

