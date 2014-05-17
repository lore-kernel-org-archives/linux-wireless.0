Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:61566 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932145AbaEQIw6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 May 2014 04:52:58 -0400
Received: by mail-we0-f174.google.com with SMTP id k48so3509502wev.19
        for <linux-wireless@vger.kernel.org>; Sat, 17 May 2014 01:52:57 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 07/22] staging: vt6656: device_cfg.h Move macros to device.h
Date: Sat, 17 May 2014 09:50:24 +0100
Message-Id: <1400316639-4430-7-git-send-email-tvboxspy@gmail.com> (sfid-20140517_105308_039507_1A2B216B)
In-Reply-To: <1400316639-4430-1-git-send-email-tvboxspy@gmail.com>
References: <1400316639-4430-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove device_cfg.h

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h     | 13 +++++++++++-
 drivers/staging/vt6656/device_cfg.h | 42 -------------------------------------
 2 files changed, 12 insertions(+), 43 deletions(-)
 delete mode 100644 drivers/staging/vt6656/device_cfg.h

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 410e028..3c2c4ce 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -60,11 +60,12 @@
 #define RT_DOWNDEV_EVENT_FLAG                        0x0105
 #define RT_RMMOD_EVENT_FLAG                              0x0106
 
+#define MAX_RATE			12
+
 /*
  * device specific
  */
 
-#include "device_cfg.h"
 #include "80211hdr.h"
 #include "tether.h"
 #include "wmgr.h"
@@ -79,6 +80,16 @@
 #define VNT_USB_VENDOR_ID                     0x160a
 #define VNT_USB_PRODUCT_ID                    0x3184
 
+#define DEVICE_NAME			"vt6656"
+#define DEVICE_FULL_DRV_NAM		"VIA Networking Wireless LAN USB Driver"
+
+#define DEVICE_VERSION			"1.19_12"
+
+#define CONFIG_PATH			"/etc/vntconfiguration.dat"
+
+#define MAX_UINTS			8
+#define OPTION_DEFAULT			{ [0 ... MAX_UINTS-1] = -1}
+
 #define MAC_MAX_CONTEXT_REG     (256+128)
 
 #define MAX_MULTICAST_ADDRESS_NUM       32
diff --git a/drivers/staging/vt6656/device_cfg.h b/drivers/staging/vt6656/device_cfg.h
deleted file mode 100644
index b018339..0000000
--- a/drivers/staging/vt6656/device_cfg.h
+++ /dev/null
@@ -1,42 +0,0 @@
-/*
- * Copyright (c) 1996, 2003 VIA Networking Technologies, Inc.
- * All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License along
- * with this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
- *
- * File: device_cfg.h
- *
- * Purpose: Driver configuration header
- * Author: Lyndon Chen
- *
- * Date: Dec 9, 2005
- *
- */
-#ifndef __DEVICE_CONFIG_H
-#define __DEVICE_CONFIG_H
-
-#define DEVICE_NAME         "vt6656"
-#define DEVICE_FULL_DRV_NAM "VIA Networking Wireless LAN USB Driver"
-
-#define DEVICE_VERSION       "1.19_12"
-
-#define MAX_RATE	12
-
-#define CONFIG_PATH            "/etc/vntconfiguration.dat"
-
-#define MAX_UINTS           8
-#define OPTION_DEFAULT      { [0 ... MAX_UINTS-1] = -1}
-
-#endif
-- 
1.9.1

