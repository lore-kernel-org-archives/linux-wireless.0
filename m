Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:40716 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932087AbaFYUVe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2014 16:21:34 -0400
Received: by mail-we0-f169.google.com with SMTP id t60so2642842wes.14
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jun 2014 13:21:33 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 18/34] staging: vt6656: decode remove tether.c/h
Date: Wed, 25 Jun 2014 21:19:55 +0100
Message-Id: <1403727611-6825-19-git-send-email-tvboxspy@gmail.com> (sfid-20140625_223019_393804_89134902)
In-Reply-To: <1403727611-6825-1-git-send-email-tvboxspy@gmail.com>
References: <1403727611-6825-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/80211mgr.c |   1 -
 drivers/staging/vt6656/Makefile   |   1 -
 drivers/staging/vt6656/baseband.c |   1 -
 drivers/staging/vt6656/baseband.h |   1 -
 drivers/staging/vt6656/desc.h     |   2 -
 drivers/staging/vt6656/device.h   |   1 -
 drivers/staging/vt6656/dpc.c      |   1 -
 drivers/staging/vt6656/key.h      |   1 -
 drivers/staging/vt6656/mac.c      |   1 -
 drivers/staging/vt6656/main_usb.c |   1 -
 drivers/staging/vt6656/rxtx.c     |   1 -
 drivers/staging/vt6656/tether.c   |  60 ----------------------
 drivers/staging/vt6656/tether.h   | 101 --------------------------------------
 13 files changed, 173 deletions(-)
 delete mode 100644 drivers/staging/vt6656/tether.c
 delete mode 100644 drivers/staging/vt6656/tether.h

diff --git a/drivers/staging/vt6656/80211mgr.c b/drivers/staging/vt6656/80211mgr.c
index 48baef9..09bfe24 100644
--- a/drivers/staging/vt6656/80211mgr.c
+++ b/drivers/staging/vt6656/80211mgr.c
@@ -51,7 +51,6 @@
 
 #include "device.h"
 #include "tmacro.h"
-#include "tether.h"
 #include "80211mgr.h"
 #include "80211hdr.h"
 
diff --git a/drivers/staging/vt6656/Makefile b/drivers/staging/vt6656/Makefile
index 2e0361b..0f33000 100644
--- a/drivers/staging/vt6656/Makefile
+++ b/drivers/staging/vt6656/Makefile
@@ -12,7 +12,6 @@ vt6656_stage-y +=	main_usb.o \
 			dpc.o \
 			power.o \
 			datarate.o \
-			tether.o \
 			key.o \
 			rf.o \
 			usbpipe.o \
diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index 19b8fd1..80240e4 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -36,7 +36,6 @@
  */
 
 #include "tmacro.h"
-#include "tether.h"
 #include "mac.h"
 #include "baseband.h"
 #include "rf.h"
diff --git a/drivers/staging/vt6656/baseband.h b/drivers/staging/vt6656/baseband.h
index 4160695..c73244b 100644
--- a/drivers/staging/vt6656/baseband.h
+++ b/drivers/staging/vt6656/baseband.h
@@ -33,7 +33,6 @@
 #ifndef __BASEBAND_H__
 #define __BASEBAND_H__
 
-#include "tether.h"
 #include "device.h"
 
 #define PREAMBLE_LONG   0
diff --git a/drivers/staging/vt6656/desc.h b/drivers/staging/vt6656/desc.h
index 617d479..f79af85 100644
--- a/drivers/staging/vt6656/desc.h
+++ b/drivers/staging/vt6656/desc.h
@@ -34,8 +34,6 @@
 #include <linux/types.h>
 #include <linux/mm.h>
 
-#include "tether.h"
-
 /* max transmit or receive buffer size */
 #define CB_MAX_BUF_SIZE     2900U       /* NOTE: must be multiple of 4 */
 
diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index c5b5b9f..b6ae34f 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -74,7 +74,6 @@
  */
 
 #include "80211hdr.h"
-#include "tether.h"
 #include "wmgr.h"
 #include "wcmd.h"
 #include "desc.h"
diff --git a/drivers/staging/vt6656/dpc.c b/drivers/staging/vt6656/dpc.c
index a0d52d7..60230f2 100644
--- a/drivers/staging/vt6656/dpc.c
+++ b/drivers/staging/vt6656/dpc.c
@@ -38,7 +38,6 @@
 #include "dpc.h"
 #include "device.h"
 #include "rxtx.h"
-#include "tether.h"
 #include "card.h"
 #include "bssdb.h"
 #include "mac.h"
diff --git a/drivers/staging/vt6656/key.h b/drivers/staging/vt6656/key.h
index 7b8c960..4303c54 100644
--- a/drivers/staging/vt6656/key.h
+++ b/drivers/staging/vt6656/key.h
@@ -30,7 +30,6 @@
 #ifndef __KEY_H__
 #define __KEY_H__
 
-#include "tether.h"
 #include "80211mgr.h"
 
 #define MAX_GROUP_KEY       4
diff --git a/drivers/staging/vt6656/mac.c b/drivers/staging/vt6656/mac.c
index a60240c..755ac56 100644
--- a/drivers/staging/vt6656/mac.c
+++ b/drivers/staging/vt6656/mac.c
@@ -31,7 +31,6 @@
  */
 
 #include "tmacro.h"
-#include "tether.h"
 #include "desc.h"
 #include "mac.h"
 #include "80211hdr.h"
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 4a412d9..d9e766b 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -51,7 +51,6 @@
 #include "card.h"
 #include "baseband.h"
 #include "mac.h"
-#include "tether.h"
 #include "wmgr.h"
 #include "power.h"
 #include "wcmd.h"
diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index ab80c46..57c2b94 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -45,7 +45,6 @@
 
 #include "device.h"
 #include "rxtx.h"
-#include "tether.h"
 #include "card.h"
 #include "bssdb.h"
 #include "mac.h"
diff --git a/drivers/staging/vt6656/tether.c b/drivers/staging/vt6656/tether.c
deleted file mode 100644
index 2ef54f6..0000000
--- a/drivers/staging/vt6656/tether.c
+++ /dev/null
@@ -1,60 +0,0 @@
-/*
- * Copyright (c) 2003 VIA Networking, Inc. All rights reserved.
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
- * File: tether.c
- *
- * Purpose:
- *
- * Author: Tevin Chen
- *
- * Date: May 21, 1996
- *
- * Functions:
- *      ETHbIsBufferCrc32Ok - Check CRC value of the buffer if Ok or not
- *
- * Revision History:
- *
- */
-
-#include "device.h"
-#include "tmacro.h"
-#include "tether.h"
-
-/*
- * Description: Check CRC value of the buffer if Ok or not
- *
- * Parameters:
- *  In:
- *		pbyBuffer	    - pointer of buffer (normally is rx buffer)
- *		cbFrameLength	- length of buffer, including CRC portion
- *  Out:
- *      none
- *
- * Return Value: true if ok; false if error.
- *
- */
-bool ETHbIsBufferCrc32Ok(u8 * pbyBuffer, unsigned int cbFrameLength)
-{
-	u32 n_crc = ~ether_crc_le(cbFrameLength - 4, pbyBuffer);
-
-	if (le32_to_cpu(*((__le32 *)(pbyBuffer + cbFrameLength - 4))) != n_crc)
-		return false;
-
-	return true;
-}
-
diff --git a/drivers/staging/vt6656/tether.h b/drivers/staging/vt6656/tether.h
deleted file mode 100644
index f57fcfdc..0000000
--- a/drivers/staging/vt6656/tether.h
+++ /dev/null
@@ -1,101 +0,0 @@
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
- * File: tether.h
- *
- * Purpose:
- *
- * Author: Tevin Chen
- *
- * Date: Jan. 28, 1997
- *
- */
-
-#ifndef __TETHER_H__
-#define __TETHER_H__
-
-#include <linux/if_ether.h>
-
-//
-// constants
-//
-#define U_ETHER_ADDR_STR_LEN (ETH_ALEN * 2 + 1)
-                                        // Ethernet address string length
-#define U_MULTI_ADDR_LEN    8           // multicast address length
-
-#ifdef __BIG_ENDIAN
-
-#define TYPE_MGMT_PROBE_RSP 0x5000
-
-#define FC_TODS             0x0001
-#define FC_FROMDS           0x0002
-#define FC_MOREFRAG         0x0004
-#define FC_RETRY            0x0008
-#define FC_POWERMGT         0x0010
-#define FC_MOREDATA         0x0020
-#define FC_WEP              0x0040
-#define TYPE_802_11_ATIM    0x9000
-
-#define TYPE_802_11_DATA    0x0800
-#define TYPE_802_11_CTL     0x0400
-#define TYPE_802_11_MGMT    0x0000
-#define TYPE_802_11_MASK    0x0C00
-#define TYPE_SUBTYPE_MASK   0xFC00
-#define TYPE_802_11_NODATA  0x4000
-#define TYPE_DATE_NULL      0x4800
-
-#define TYPE_CTL_PSPOLL     0xa400
-#define TYPE_CTL_ACK        0xd400
-
-#else //if LITTLE_ENDIAN
-//
-// wType field in the SEthernetHeader
-//
-// NOTE....
-//   in network byte order, high byte is going first
-
-#define TYPE_MGMT_PROBE_RSP 0x0050
-
-#define FC_TODS             0x0100
-#define FC_FROMDS           0x0200
-#define FC_MOREFRAG         0x0400
-#define FC_RETRY            0x0800
-#define FC_POWERMGT         0x1000
-#define FC_MOREDATA         0x2000
-#define FC_WEP              0x4000
-#define TYPE_802_11_ATIM    0x0090
-
-#define TYPE_802_11_DATA    0x0008
-#define TYPE_802_11_CTL     0x0004
-#define TYPE_802_11_MGMT    0x0000
-#define TYPE_802_11_MASK    0x000C
-#define TYPE_SUBTYPE_MASK   0x00FC
-#define TYPE_802_11_NODATA  0x0040
-#define TYPE_DATE_NULL      0x0048
-
-#define TYPE_CTL_PSPOLL     0x00a4
-#define TYPE_CTL_ACK        0x00d4
-
-#endif //#ifdef __BIG_ENDIAN
-
-#define WEP_IV_MASK         0x00FFFFFF
-
-//u8 ETHbyGetHashIndexByCrc(u8 * pbyMultiAddr);
-bool ETHbIsBufferCrc32Ok(u8 * pbyBuffer, unsigned int cbFrameLength);
-
-#endif /* __TETHER_H__ */
-- 
1.9.1

