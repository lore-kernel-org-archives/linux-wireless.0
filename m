Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:63510 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395AbaEZNAT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2014 09:00:19 -0400
Received: by mail-wi0-f179.google.com with SMTP id bs8so4347694wib.0
        for <linux-wireless@vger.kernel.org>; Mon, 26 May 2014 06:00:17 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 10/11] staging: vt6656: dead code remove control.c/h
Date: Mon, 26 May 2014 13:59:07 +0100
Message-Id: <1401109148-3593-10-git-send-email-tvboxspy@gmail.com> (sfid-20140526_150027_265228_1815416D)
In-Reply-To: <1401109148-3593-1-git-send-email-tvboxspy@gmail.com>
References: <1401109148-3593-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace control.h headers with usbpipe.h

Also add to usbpipe.c its header 

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/Makefile   |  1 -
 drivers/staging/vt6656/baseband.c |  2 +-
 drivers/staging/vt6656/bssdb.c    |  2 +-
 drivers/staging/vt6656/card.c     |  2 +-
 drivers/staging/vt6656/control.c  | 52 ---------------------------------------
 drivers/staging/vt6656/control.h  | 39 -----------------------------
 drivers/staging/vt6656/firmware.c |  2 +-
 drivers/staging/vt6656/iwctl.c    |  2 +-
 drivers/staging/vt6656/key.c      |  2 +-
 drivers/staging/vt6656/mac.c      |  2 +-
 drivers/staging/vt6656/main_usb.c |  2 +-
 drivers/staging/vt6656/power.c    |  2 +-
 drivers/staging/vt6656/rf.c       |  2 +-
 drivers/staging/vt6656/usbpipe.c  |  1 +
 drivers/staging/vt6656/wcmd.c     |  2 +-
 drivers/staging/vt6656/wmgr.c     |  2 +-
 drivers/staging/vt6656/wpactl.c   |  2 +-
 17 files changed, 14 insertions(+), 105 deletions(-)
 delete mode 100644 drivers/staging/vt6656/control.c
 delete mode 100644 drivers/staging/vt6656/control.h

diff --git a/drivers/staging/vt6656/Makefile b/drivers/staging/vt6656/Makefile
index e39d249..b5ec483 100644
--- a/drivers/staging/vt6656/Makefile
+++ b/drivers/staging/vt6656/Makefile
@@ -27,7 +27,6 @@ vt6656_stage-y +=	main_usb.o \
 			wpactl.o \
 			usbpipe.o \
 			channel.o \
-			control.o \
 			firmware.o \
 			int.o
 
diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index 4cdea2c..d96308f 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -40,7 +40,7 @@
 #include "mac.h"
 #include "baseband.h"
 #include "rf.h"
-#include "control.h"
+#include "usbpipe.h"
 #include "datarate.h"
 
 static u8 abyVT3184_AGC[] = {
diff --git a/drivers/staging/vt6656/bssdb.c b/drivers/staging/vt6656/bssdb.c
index 12b6436..f53d3bf 100644
--- a/drivers/staging/vt6656/bssdb.c
+++ b/drivers/staging/vt6656/bssdb.c
@@ -53,7 +53,7 @@
 #include "card.h"
 #include "mac.h"
 #include "wpa2.h"
-#include "control.h"
+#include "usbpipe.h"
 #include "iowpa.h"
 #include "power.h"
 
diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index 9313730..06f8b00 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -57,7 +57,7 @@
 #include "rc4.h"
 #include "country.h"
 #include "datarate.h"
-#include "control.h"
+#include "usbpipe.h"
 
 //const u16 cwRXBCNTSFOff[MAX_RATE] =
 //{17, 34, 96, 192, 34, 23, 17, 11, 8, 5, 4, 3};
diff --git a/drivers/staging/vt6656/control.c b/drivers/staging/vt6656/control.c
deleted file mode 100644
index b6e31f3..0000000
--- a/drivers/staging/vt6656/control.c
+++ /dev/null
@@ -1,52 +0,0 @@
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
- *
- * File: control.c
- *
- * Purpose: Handle USB control endpoint
- *
- * Author: Jerry Chen
- *
- * Date: Apr. 5, 2004
- *
- * Functions:
- *      vnt_control_out - Write variable length bytes to MEM/BB/MAC/EEPROM
- *      ControlvReadByte - Read one byte from MEM/BB/MAC/EEPROM
- *      ControlvMaskByte - Read one byte from MEM/BB/MAC/EEPROM and clear/set
- *				some bits in the same address
- *
- * Revision History:
- *      04-05-2004 Jerry Chen:  Initial release
- *      11-24-2004 Warren Hsu: Add ControlvWriteByte, ControlvReadByte,
- *					ControlvMaskByte
- *
- */
-
-#include "control.h"
-
-/* static int          msglevel                =MSG_LEVEL_INFO;  */
-/* static int          msglevel                =MSG_LEVEL_DEBUG; */
-
-void ControlvReadByte(struct vnt_private *pDevice, u8 reg, u8 reg_off,
-			u8 *data)
-{
-	vnt_control_in(pDevice, MESSAGE_TYPE_READ,
-			reg_off, reg, sizeof(u8), data);
-	return;
-}
diff --git a/drivers/staging/vt6656/control.h b/drivers/staging/vt6656/control.h
deleted file mode 100644
index 48f4836..0000000
--- a/drivers/staging/vt6656/control.h
+++ /dev/null
@@ -1,39 +0,0 @@
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
- *
- * File: control.h
- *
- * Purpose:
- *
- * Author: Jerry Chen
- *
- * Date: Apr. 5, 2004
- *
- */
-
-#ifndef __CONTROL_H__
-#define __CONTROL_H__
-
-#include "device.h"
-#include "usbpipe.h"
-
-void ControlvReadByte(struct vnt_private *pDevice, u8 reg, u8 reg_off,
-			u8 *data);
-
-#endif /* __CONTROL_H__ */
diff --git a/drivers/staging/vt6656/firmware.c b/drivers/staging/vt6656/firmware.c
index f9d685f..1159f0b 100644
--- a/drivers/staging/vt6656/firmware.c
+++ b/drivers/staging/vt6656/firmware.c
@@ -33,7 +33,7 @@
 
 #include <linux/compiler.h>
 #include "firmware.h"
-#include "control.h"
+#include "usbpipe.h"
 
 static int msglevel = MSG_LEVEL_INFO;
 /* static int msglevel = MSG_LEVEL_DEBUG; */
diff --git a/drivers/staging/vt6656/iwctl.c b/drivers/staging/vt6656/iwctl.c
index 0a8e438..94b7fe8 100644
--- a/drivers/staging/vt6656/iwctl.c
+++ b/drivers/staging/vt6656/iwctl.c
@@ -38,7 +38,7 @@
 #include "rf.h"
 #include "iowpa.h"
 #include "wpactl.h"
-#include "control.h"
+#include "usbpipe.h"
 #include "baseband.h"
 
 static const long frequency_list[] = {
diff --git a/drivers/staging/vt6656/key.c b/drivers/staging/vt6656/key.c
index 11aa82a..38ea675 100644
--- a/drivers/staging/vt6656/key.c
+++ b/drivers/staging/vt6656/key.c
@@ -39,7 +39,7 @@
 #include "mac.h"
 #include "tmacro.h"
 #include "key.h"
-#include "control.h"
+#include "usbpipe.h"
 
 static int          msglevel                =MSG_LEVEL_INFO;
 //static int          msglevel                =MSG_LEVEL_DEBUG;
diff --git a/drivers/staging/vt6656/mac.c b/drivers/staging/vt6656/mac.c
index fdb244f..cadf7cd 100644
--- a/drivers/staging/vt6656/mac.c
+++ b/drivers/staging/vt6656/mac.c
@@ -35,7 +35,7 @@
 #include "desc.h"
 #include "mac.h"
 #include "80211hdr.h"
-#include "control.h"
+#include "usbpipe.h"
 
 /*
  * Description:
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index df206e6..e18071f 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -65,7 +65,7 @@
 #include "datarate.h"
 #include "rf.h"
 #include "firmware.h"
-#include "control.h"
+#include "usbpipe.h"
 #include "channel.h"
 #include "int.h"
 #include "iowpa.h"
diff --git a/drivers/staging/vt6656/power.c b/drivers/staging/vt6656/power.c
index b8ebf58..ddbd046 100644
--- a/drivers/staging/vt6656/power.c
+++ b/drivers/staging/vt6656/power.c
@@ -44,7 +44,7 @@
 #include "wcmd.h"
 #include "rxtx.h"
 #include "card.h"
-#include "control.h"
+#include "usbpipe.h"
 
 static int msglevel = MSG_LEVEL_INFO;
 
diff --git a/drivers/staging/vt6656/rf.c b/drivers/staging/vt6656/rf.c
index 58ea16c..d244dab 100644
--- a/drivers/staging/vt6656/rf.c
+++ b/drivers/staging/vt6656/rf.c
@@ -38,7 +38,7 @@
 #include "mac.h"
 #include "rf.h"
 #include "baseband.h"
-#include "control.h"
+#include "usbpipe.h"
 #include "datarate.h"
 
 static int          msglevel                =MSG_LEVEL_INFO;
diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index fc68bad..e4751b7 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -43,6 +43,7 @@
 #include "dpc.h"
 #include "desc.h"
 #include "device.h"
+#include "usbpipe.h"
 
 //endpoint def
 //endpoint 0: control
diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index 91754fd..9a166fb 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -48,7 +48,7 @@
 #include "power.h"
 #include "wctl.h"
 #include "baseband.h"
-#include "control.h"
+#include "usbpipe.h"
 #include "rxtx.h"
 #include "rf.h"
 #include "channel.h"
diff --git a/drivers/staging/vt6656/wmgr.c b/drivers/staging/vt6656/wmgr.c
index 8cb80a6..18723ea 100644
--- a/drivers/staging/vt6656/wmgr.c
+++ b/drivers/staging/vt6656/wmgr.c
@@ -78,7 +78,7 @@
 #include "wpa.h"
 #include "rf.h"
 #include "iowpa.h"
-#include "control.h"
+#include "usbpipe.h"
 
 static int msglevel = MSG_LEVEL_INFO;
 //static int          msglevel                =MSG_LEVEL_DEBUG;
diff --git a/drivers/staging/vt6656/wpactl.c b/drivers/staging/vt6656/wpactl.c
index 587e111..0a06715 100644
--- a/drivers/staging/vt6656/wpactl.c
+++ b/drivers/staging/vt6656/wpactl.c
@@ -38,7 +38,7 @@
 #include "wmgr.h"
 #include "iocmd.h"
 #include "iowpa.h"
-#include "control.h"
+#include "usbpipe.h"
 #include "rf.h"
 
 static int msglevel = MSG_LEVEL_INFO;
-- 
1.9.1

