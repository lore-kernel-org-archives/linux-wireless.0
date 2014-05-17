Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:43829 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757267AbaEQIxI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 May 2014 04:53:08 -0400
Received: by mail-wg0-f48.google.com with SMTP id b13so5811830wgh.31
        for <linux-wireless@vger.kernel.org>; Sat, 17 May 2014 01:53:07 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 13/22] staging: vt6656: rndis.h move all to device.h
Date: Sat, 17 May 2014 09:50:30 +0100
Message-Id: <1400316639-4430-13-git-send-email-tvboxspy@gmail.com> (sfid-20140517_112148_549960_6DB8EFBE)
In-Reply-To: <1400316639-4430-1-git-send-email-tvboxspy@gmail.com>
References: <1400316639-4430-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commands macros are common to all source files.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/baseband.c |  1 -
 drivers/staging/vt6656/bssdb.c    |  1 -
 drivers/staging/vt6656/card.c     |  1 -
 drivers/staging/vt6656/control.c  |  1 -
 drivers/staging/vt6656/device.h   | 56 ++++++++++++++++++++++++-
 drivers/staging/vt6656/firmware.c |  1 -
 drivers/staging/vt6656/iwctl.c    |  1 -
 drivers/staging/vt6656/key.c      |  1 -
 drivers/staging/vt6656/mac.c      |  1 -
 drivers/staging/vt6656/power.c    |  1 -
 drivers/staging/vt6656/rf.c       |  1 -
 drivers/staging/vt6656/rndis.h    | 87 ---------------------------------------
 drivers/staging/vt6656/wcmd.c     |  1 -
 drivers/staging/vt6656/wmgr.c     |  1 -
 drivers/staging/vt6656/wpactl.c   |  1 -
 15 files changed, 55 insertions(+), 101 deletions(-)
 delete mode 100644 drivers/staging/vt6656/rndis.h

diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index 9f3b2fb..b4489d6 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -42,7 +42,6 @@
 #include "rf.h"
 #include "control.h"
 #include "datarate.h"
-#include "rndis.h"
 
 static int          msglevel                =MSG_LEVEL_INFO;
 //static int          msglevel                =MSG_LEVEL_DEBUG;
diff --git a/drivers/staging/vt6656/bssdb.c b/drivers/staging/vt6656/bssdb.c
index b018955..7e8e67a 100644
--- a/drivers/staging/vt6656/bssdb.c
+++ b/drivers/staging/vt6656/bssdb.c
@@ -54,7 +54,6 @@
 #include "mac.h"
 #include "wpa2.h"
 #include "control.h"
-#include "rndis.h"
 #include "iowpa.h"
 #include "power.h"
 
diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index 0d87728..b8f35e7 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -57,7 +57,6 @@
 #include "rc4.h"
 #include "country.h"
 #include "datarate.h"
-#include "rndis.h"
 #include "control.h"
 
 //static int          msglevel                =MSG_LEVEL_DEBUG;
diff --git a/drivers/staging/vt6656/control.c b/drivers/staging/vt6656/control.c
index 026784f..fc19166 100644
--- a/drivers/staging/vt6656/control.c
+++ b/drivers/staging/vt6656/control.c
@@ -41,7 +41,6 @@
  */
 
 #include "control.h"
-#include "rndis.h"
 
 /* static int          msglevel                =MSG_LEVEL_INFO;  */
 /* static int          msglevel                =MSG_LEVEL_DEBUG; */
diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 990b345..59d3828 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -66,7 +66,6 @@
 #include "desc.h"
 #include "key.h"
 #include "card.h"
-#include "rndis.h"
 
 #define VNT_USB_VENDOR_ID                     0x160a
 #define VNT_USB_PRODUCT_ID                    0x3184
@@ -140,6 +139,44 @@
 /* Bits in EEP_OFS_RADIOCTL */
 #define EEP_RADIOCTL_ENABLE	0x80
 
+/* control commands */
+#define MESSAGE_TYPE_READ		0x1
+#define MESSAGE_TYPE_WRITE		0x0
+#define MESSAGE_TYPE_LOCK_OR		0x2
+#define MESSAGE_TYPE_LOCK_AND		0x3
+#define MESSAGE_TYPE_WRITE_MASK		0x4
+#define MESSAGE_TYPE_CARDINIT		0x5
+#define MESSAGE_TYPE_INIT_RSP		0x6
+#define MESSAGE_TYPE_MACSHUTDOWN	0x7
+#define MESSAGE_TYPE_SETKEY		0x8
+#define MESSAGE_TYPE_CLRKEYENTRY	0x9
+#define MESSAGE_TYPE_WRITE_MISCFF	0xa
+#define MESSAGE_TYPE_SET_ANTMD		0xb
+#define MESSAGE_TYPE_SELECT_CHANNLE	0xc
+#define MESSAGE_TYPE_SET_TSFTBTT	0xd
+#define MESSAGE_TYPE_SET_SSTIFS		0xe
+#define MESSAGE_TYPE_CHANGE_BBTYPE	0xf
+#define MESSAGE_TYPE_DISABLE_PS		0x10
+#define MESSAGE_TYPE_WRITE_IFRF		0x11
+
+/* command read/write(index) */
+#define MESSAGE_REQUEST_MEM		0x1
+#define MESSAGE_REQUEST_BBREG		0x2
+#define MESSAGE_REQUEST_MACREG		0x3
+#define MESSAGE_REQUEST_EEPROM		0x4
+#define MESSAGE_REQUEST_TSF		0x5
+#define MESSAGE_REQUEST_TBTT		0x6
+#define MESSAGE_REQUEST_BBAGC		0x7
+#define MESSAGE_REQUEST_VERSION		0x8
+#define MESSAGE_REQUEST_RF_INIT		0x9
+#define MESSAGE_REQUEST_RF_INIT2	0xa
+#define MESSAGE_REQUEST_RF_CH0		0xb
+#define MESSAGE_REQUEST_RF_CH1		0xc
+#define MESSAGE_REQUEST_RF_CH2		0xd
+
+/* USB registers */
+#define USB_REG4			0x604
+
 #ifndef RUN_AT
 #define RUN_AT(x)                       (jiffies+(x))
 #endif
@@ -161,6 +198,23 @@ typedef enum __device_msg_level {
 #define DEVICE_INIT_RESET	0x1 /* reset init or Dx to D0 power remain */
 #define DEVICE_INIT_DXPL	0x2 /* Dx to D0 power lost init */
 
+/* Device init */
+struct vnt_cmd_card_init {
+	u8 init_class;
+	u8 exist_sw_net_addr;
+	u8 sw_net_addr[6];
+	u8 short_retry_limit;
+	u8 long_retry_limit;
+};
+
+struct vnt_rsp_card_init {
+	u8 status;
+	u8 net_addr[6];
+	u8 rf_type;
+	u8 min_channel;
+	u8 max_channel;
+};
+
 /* USB */
 
 /*
diff --git a/drivers/staging/vt6656/firmware.c b/drivers/staging/vt6656/firmware.c
index e03f1f9..1d3d268 100644
--- a/drivers/staging/vt6656/firmware.c
+++ b/drivers/staging/vt6656/firmware.c
@@ -34,7 +34,6 @@
 #include <linux/compiler.h>
 #include "firmware.h"
 #include "control.h"
-#include "rndis.h"
 
 static int msglevel = MSG_LEVEL_INFO;
 /* static int msglevel = MSG_LEVEL_DEBUG; */
diff --git a/drivers/staging/vt6656/iwctl.c b/drivers/staging/vt6656/iwctl.c
index bfd5f37..38739fa 100644
--- a/drivers/staging/vt6656/iwctl.c
+++ b/drivers/staging/vt6656/iwctl.c
@@ -40,7 +40,6 @@
 #include "iowpa.h"
 #include "wpactl.h"
 #include "control.h"
-#include "rndis.h"
 #include "baseband.h"
 
 static const long frequency_list[] = {
diff --git a/drivers/staging/vt6656/key.c b/drivers/staging/vt6656/key.c
index b173ca1..a88c6b18 100644
--- a/drivers/staging/vt6656/key.c
+++ b/drivers/staging/vt6656/key.c
@@ -39,7 +39,6 @@
 #include "mac.h"
 #include "tmacro.h"
 #include "key.h"
-#include "rndis.h"
 #include "control.h"
 
 static int          msglevel                =MSG_LEVEL_INFO;
diff --git a/drivers/staging/vt6656/mac.c b/drivers/staging/vt6656/mac.c
index 8bd3ab0..8298a9e 100644
--- a/drivers/staging/vt6656/mac.c
+++ b/drivers/staging/vt6656/mac.c
@@ -35,7 +35,6 @@
 #include "desc.h"
 #include "mac.h"
 #include "80211hdr.h"
-#include "rndis.h"
 #include "control.h"
 
 //static int          msglevel                =MSG_LEVEL_DEBUG;
diff --git a/drivers/staging/vt6656/power.c b/drivers/staging/vt6656/power.c
index 43da589..c4bea74 100644
--- a/drivers/staging/vt6656/power.c
+++ b/drivers/staging/vt6656/power.c
@@ -45,7 +45,6 @@
 #include "rxtx.h"
 #include "card.h"
 #include "control.h"
-#include "rndis.h"
 
 static int msglevel = MSG_LEVEL_INFO;
 
diff --git a/drivers/staging/vt6656/rf.c b/drivers/staging/vt6656/rf.c
index 64632e9..7217f2c 100644
--- a/drivers/staging/vt6656/rf.c
+++ b/drivers/staging/vt6656/rf.c
@@ -39,7 +39,6 @@
 #include "rf.h"
 #include "baseband.h"
 #include "control.h"
-#include "rndis.h"
 #include "datarate.h"
 
 static int          msglevel                =MSG_LEVEL_INFO;
diff --git a/drivers/staging/vt6656/rndis.h b/drivers/staging/vt6656/rndis.h
deleted file mode 100644
index cf4e0e0..0000000
--- a/drivers/staging/vt6656/rndis.h
+++ /dev/null
@@ -1,87 +0,0 @@
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
- * File: rndis.h
- *
- * Purpose: Interface between firmware and driver
- *
- * Author: Warren Hsu
- *
- * Date: Nov 24, 2004
- *
- */
-
-#ifndef __RNDIS_H__
-#define __RNDIS_H__
-
-#define MESSAGE_TYPE_READ               0x01
-#define MESSAGE_TYPE_WRITE              0x00
-#define MESSAGE_TYPE_LOCK_OR            0x02
-#define MESSAGE_TYPE_LOCK_AND           0x03
-#define MESSAGE_TYPE_WRITE_MASK         0x04
-#define MESSAGE_TYPE_CARDINIT           0x05
-#define MESSAGE_TYPE_INIT_RSP           0x06
-#define MESSAGE_TYPE_MACSHUTDOWN        0x07
-#define MESSAGE_TYPE_SETKEY             0x08
-#define MESSAGE_TYPE_CLRKEYENTRY        0x09
-#define MESSAGE_TYPE_WRITE_MISCFF       0x0A
-#define MESSAGE_TYPE_SET_ANTMD          0x0B
-#define MESSAGE_TYPE_SELECT_CHANNLE     0x0C
-#define MESSAGE_TYPE_SET_TSFTBTT        0x0D
-#define MESSAGE_TYPE_SET_SSTIFS         0x0E
-#define MESSAGE_TYPE_CHANGE_BBTYPE      0x0F
-#define MESSAGE_TYPE_DISABLE_PS         0x10
-#define MESSAGE_TYPE_WRITE_IFRF         0x11
-
-//used for read/write(index)
-#define MESSAGE_REQUEST_MEM             0x01
-#define MESSAGE_REQUEST_BBREG           0x02
-#define MESSAGE_REQUEST_MACREG          0x03
-#define MESSAGE_REQUEST_EEPROM          0x04
-#define MESSAGE_REQUEST_TSF             0x05
-#define MESSAGE_REQUEST_TBTT            0x06
-#define MESSAGE_REQUEST_BBAGC           0x07
-#define MESSAGE_REQUEST_VERSION         0x08
-#define MESSAGE_REQUEST_RF_INIT         0x09
-#define MESSAGE_REQUEST_RF_INIT2        0x0A
-#define MESSAGE_REQUEST_RF_CH0          0x0B
-#define MESSAGE_REQUEST_RF_CH1          0x0C
-#define MESSAGE_REQUEST_RF_CH2          0x0D
-
-#define USB_REG4	0x604
-
-struct vnt_cmd_card_init
-{
-	u8 init_class;
-	u8 exist_sw_net_addr;
-	u8 sw_net_addr[6];
-	u8 short_retry_limit;
-	u8 long_retry_limit;
-};
-
-struct vnt_rsp_card_init
-{
-	u8 status;
-	u8 net_addr[6];
-	u8 rf_type;
-	u8 min_channel;
-	u8 max_channel;
-};
-
-#endif /* _RNDIS_H_ */
diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index 66d59d5..8fecb34 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -51,7 +51,6 @@
 #include "control.h"
 #include "rxtx.h"
 #include "rf.h"
-#include "rndis.h"
 #include "channel.h"
 #include "iowpa.h"
 
diff --git a/drivers/staging/vt6656/wmgr.c b/drivers/staging/vt6656/wmgr.c
index cce67cd..64edc16 100644
--- a/drivers/staging/vt6656/wmgr.c
+++ b/drivers/staging/vt6656/wmgr.c
@@ -79,7 +79,6 @@
 #include "rf.h"
 #include "iowpa.h"
 #include "control.h"
-#include "rndis.h"
 
 static int msglevel = MSG_LEVEL_INFO;
 //static int          msglevel                =MSG_LEVEL_DEBUG;
diff --git a/drivers/staging/vt6656/wpactl.c b/drivers/staging/vt6656/wpactl.c
index f4a8a5c..b6885a9 100644
--- a/drivers/staging/vt6656/wpactl.c
+++ b/drivers/staging/vt6656/wpactl.c
@@ -39,7 +39,6 @@
 #include "iocmd.h"
 #include "iowpa.h"
 #include "control.h"
-#include "rndis.h"
 #include "rf.h"
 
 static int msglevel = MSG_LEVEL_INFO;
-- 
1.9.1

