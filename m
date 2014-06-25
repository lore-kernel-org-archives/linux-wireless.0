Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:63048 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932158AbaFYUVc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2014 16:21:32 -0400
Received: by mail-we0-f181.google.com with SMTP id q59so2685643wes.40
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jun 2014 13:21:31 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 17/34] staging: vt6656: dead code remove iowpa.h
Date: Wed, 25 Jun 2014 21:19:54 +0100
Message-Id: <1403727611-6825-18-git-send-email-tvboxspy@gmail.com> (sfid-20140625_222951_897917_F3A54C3A)
In-Reply-To: <1403727611-6825-1-git-send-email-tvboxspy@gmail.com>
References: <1403727611-6825-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/dpc.c      |  1 -
 drivers/staging/vt6656/iowpa.h    | 75 ---------------------------------------
 drivers/staging/vt6656/main_usb.c |  1 -
 drivers/staging/vt6656/wcmd.c     |  1 -
 4 files changed, 78 deletions(-)
 delete mode 100644 drivers/staging/vt6656/iowpa.h

diff --git a/drivers/staging/vt6656/dpc.c b/drivers/staging/vt6656/dpc.c
index fe4b6ac..a0d52d7 100644
--- a/drivers/staging/vt6656/dpc.c
+++ b/drivers/staging/vt6656/dpc.c
@@ -44,7 +44,6 @@
 #include "mac.h"
 #include "baseband.h"
 #include "rf.h"
-#include "iowpa.h"
 #include "datarate.h"
 #include "usbpipe.h"
 
diff --git a/drivers/staging/vt6656/iowpa.h b/drivers/staging/vt6656/iowpa.h
deleted file mode 100644
index 98f2b21..0000000
--- a/drivers/staging/vt6656/iowpa.h
+++ /dev/null
@@ -1,75 +0,0 @@
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
- * File: iowpa.h
- *
- * Purpose: Handles wpa supplicant ioctl interface
- *
- * Author: Lyndon Chen
- *
- * Date: May 8, 2002
- *
- */
-
-#ifndef __IOWPA_H__
-#define __IOWPA_H__
-
-#define WPA_IE_LEN 64
-
-struct viawget_wpa_param {
-	u32 cmd;
-	u8 addr[6];
-	union {
-		struct {
-			u8 len;
-			u8 data[0];
-		} generic_elem;
-		struct {
-			u8 bssid[6];
-			u8 ssid[32];
-			u8 ssid_len;
-			u8 *wpa_ie;
-			u16 wpa_ie_len;
-			int pairwise_suite;
-			int group_suite;
-			int key_mgmt_suite;
-			int auth_alg;
-			int mode;
-			u8 roam_dbm;
-		} wpa_associate;
-		struct {
-			int alg_name;
-			u16 key_index;
-			u16 set_tx;
-			u8 *seq;
-			u16 seq_len;
-			u8 *key;
-			u16 key_len;
-		} wpa_key;
-		struct {
-			u8 ssid_len;
-			u8 ssid[32];
-		} scan_req;
-		struct {
-			u16 scan_count;
-			u8 *buf;
-		} scan_results;
-	} u;
-} __packed;
-
-#endif /* __IOWPA_H__ */
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index b9915a2..4a412d9 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -64,7 +64,6 @@
 #include "usbpipe.h"
 #include "channel.h"
 #include "int.h"
-#include "iowpa.h"
 
 /* static int msglevel = MSG_LEVEL_DEBUG; */
 static int          msglevel                =MSG_LEVEL_INFO;
diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index 00bed8c..d063229 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -51,7 +51,6 @@
 #include "rxtx.h"
 #include "rf.h"
 #include "channel.h"
-#include "iowpa.h"
 
 static int msglevel = MSG_LEVEL_INFO;
 //static int msglevel = MSG_LEVEL_DEBUG;
-- 
1.9.1

