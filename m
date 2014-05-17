Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:39371 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932279AbaEQIw5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 May 2014 04:52:57 -0400
Received: by mail-we0-f175.google.com with SMTP id t61so3579512wes.34
        for <linux-wireless@vger.kernel.org>; Sat, 17 May 2014 01:52:55 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 06/22] staging: vt6656: device_cfg.h remove dead code.
Date: Sat, 17 May 2014 09:50:23 +0100
Message-Id: <1400316639-4430-6-git-send-email-tvboxspy@gmail.com> (sfid-20140517_105304_967921_10A8A398)
In-Reply-To: <1400316639-4430-1-git-send-email-tvboxspy@gmail.com>
References: <1400316639-4430-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also unneeded #ifndef

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device_cfg.h | 45 -------------------------------------
 1 file changed, 45 deletions(-)

diff --git a/drivers/staging/vt6656/device_cfg.h b/drivers/staging/vt6656/device_cfg.h
index 0b9d834..b018339 100644
--- a/drivers/staging/vt6656/device_cfg.h
+++ b/drivers/staging/vt6656/device_cfg.h
@@ -27,61 +27,16 @@
 #ifndef __DEVICE_CONFIG_H
 #define __DEVICE_CONFIG_H
 
-#include <linux/types.h>
-
-typedef
-struct _version {
-    unsigned char   major;
-    unsigned char   minor;
-    unsigned char   build;
-} version_t, *pversion_t;
-
-#ifndef false
-#define false   (0)
-#endif
-
-#ifndef true
-#define true    (!(false))
-#endif
-
-#define VID_TABLE_SIZE      64
-#define MCAST_TABLE_SIZE    64
-#define MCAM_SIZE           32
-#define VCAM_SIZE           32
-#define TX_QUEUE_NO         8
-
 #define DEVICE_NAME         "vt6656"
 #define DEVICE_FULL_DRV_NAM "VIA Networking Wireless LAN USB Driver"
 
-#ifndef MAJOR_VERSION
-#define MAJOR_VERSION       1
-#endif
-
-#ifndef MINOR_VERSION
-#define MINOR_VERSION       13
-#endif
-
-#ifndef DEVICE_VERSION
 #define DEVICE_VERSION       "1.19_12"
-#endif
 
 #define MAX_RATE	12
 
-/* config file */
-#include <linux/fs.h>
-#include <linux/fcntl.h>
-#ifndef CONFIG_PATH
 #define CONFIG_PATH            "/etc/vntconfiguration.dat"
-#endif
-
-/* Max: 2378 = 2312 Payload + 30HD + 4CRC + 2Padding + 4Len + 8TSF + 4RSR */
-#define PKT_BUF_SZ          2390
 
 #define MAX_UINTS           8
 #define OPTION_DEFAULT      { [0 ... MAX_UINTS-1] = -1}
 
-typedef enum  _chip_type {
-    VT3184 = 1
-} CHIP_TYPE, *PCHIP_TYPE;
-
 #endif
-- 
1.9.1

