Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:39255 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932289AbaJ2R62 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 13:58:28 -0400
Received: by mail-wi0-f182.google.com with SMTP id d1so5305769wiv.3
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2014 10:58:27 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH v2 47/48] staging: vt6655: dead code remove wmgr.h
Date: Wed, 29 Oct 2014 17:56:05 +0000
Message-Id: <1414605366-9335-48-git-send-email-tvboxspy@gmail.com> (sfid-20141029_185848_302988_08589CD1)
In-Reply-To: <1414605366-9335-1-git-send-email-tvboxspy@gmail.com>
References: <1414605366-9335-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

on removal needs to be replaced by card.h in device.h

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device.h      |  2 +-
 drivers/staging/vt6655/device_main.c |  1 -
 drivers/staging/vt6655/power.c       |  1 -
 drivers/staging/vt6655/wmgr.h        | 72 ------------------------------------
 4 files changed, 1 insertion(+), 75 deletions(-)
 delete mode 100644 drivers/staging/vt6655/wmgr.h

diff --git a/drivers/staging/vt6655/device.h b/drivers/staging/vt6655/device.h
index 45181a8..d0855bd 100644
--- a/drivers/staging/vt6655/device.h
+++ b/drivers/staging/vt6655/device.h
@@ -68,7 +68,7 @@
 
 #include "device_cfg.h"
 #include "ttype.h"
-#include "wmgr.h"
+#include "card.h"
 #include "mib.h"
 #include "srom.h"
 #include "desc.h"
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 5c91c2f..f0b336b 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -58,7 +58,6 @@
 #include "channel.h"
 #include "baseband.h"
 #include "mac.h"
-#include "wmgr.h"
 #include "power.h"
 #include "rxtx.h"
 #include "dpc.h"
diff --git a/drivers/staging/vt6655/power.c b/drivers/staging/vt6655/power.c
index 6f83650..a8aedee 100644
--- a/drivers/staging/vt6655/power.c
+++ b/drivers/staging/vt6655/power.c
@@ -40,7 +40,6 @@
 #include "ttype.h"
 #include "mac.h"
 #include "device.h"
-#include "wmgr.h"
 #include "power.h"
 #include "card.h"
 
diff --git a/drivers/staging/vt6655/wmgr.h b/drivers/staging/vt6655/wmgr.h
deleted file mode 100644
index ea23c79..0000000
--- a/drivers/staging/vt6655/wmgr.h
+++ /dev/null
@@ -1,72 +0,0 @@
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
- * File: wmgr.h
- *
- * Purpose:
- *
- * Author: lyndon chen
- *
- * Date: Jan 2, 2003
- *
- * Functions:
- *
- * Revision History:
- *
- */
-
-#ifndef __WMGR_H__
-#define __WMGR_H__
-
-#include "ttype.h"
-#include "card.h"
-
-/*---------------------  Export Definitions -------------------------*/
-
-// Scan time
-#define PROBE_DELAY                  100  // (us)
-#define SWITCH_CHANNEL_DELAY         200 // (us)
-#define WLAN_SCAN_MINITIME           25   // (ms)
-#define WLAN_SCAN_MAXTIME            100  // (ms)
-#define TRIVIAL_SYNC_DIFFERENCE      0    // (us)
-#define DEFAULT_IBSS_BI              100  // (ms)
-
-#define WCMD_ACTIVE_SCAN_TIME   50 //(ms)
-#define WCMD_PASSIVE_SCAN_TIME  100 //(ms)
-
-#define DEFAULT_MSDU_LIFETIME           512  // ms
-
-#define DEFAULT_MGN_LIFETIME            8    // ms
-
-#define TIM_MULTICAST_MASK           0x01
-#define TIM_BITMAPOFFSET_MASK        0xFE
-#define DEFAULT_DTIM_PERIOD             1
-
-#define AP_LONG_RETRY_LIMIT             4
-
-#define DEFAULT_IBSS_CHANNEL            6  //2.4G
-
-/*---------------------  Export Classes  ----------------------------*/
-
-/*---------------------  Export Variables  --------------------------*/
-
-/*---------------------  Export Types  ------------------------------*/
-#define timer_expire(timer, next_tick)   mod_timer(&timer, RUN_AT(next_tick))
-
-#endif // __WMGR_H__
-- 
2.1.0

