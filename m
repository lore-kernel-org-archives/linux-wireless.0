Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:51737 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932276AbaFYUVq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2014 16:21:46 -0400
Received: by mail-we0-f170.google.com with SMTP id w61so2586363wes.29
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jun 2014 13:21:42 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 23/34] staging: vt6656: dead code remove tmacro.h
Date: Wed, 25 Jun 2014 21:20:00 +0100
Message-Id: <1403727611-6825-24-git-send-email-tvboxspy@gmail.com> (sfid-20140625_222238_590056_26185063)
In-Reply-To: <1403727611-6825-1-git-send-email-tvboxspy@gmail.com>
References: <1403727611-6825-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/baseband.c |  1 -
 drivers/staging/vt6656/card.c     |  1 -
 drivers/staging/vt6656/int.c      |  1 -
 drivers/staging/vt6656/mac.c      |  1 -
 drivers/staging/vt6656/mac.h      |  1 -
 drivers/staging/vt6656/tmacro.h   | 52 ---------------------------------------
 drivers/staging/vt6656/wcmd.c     |  1 -
 7 files changed, 58 deletions(-)
 delete mode 100644 drivers/staging/vt6656/tmacro.h

diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index e67502e..f4060a9 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -35,7 +35,6 @@
  *
  */
 
-#include "tmacro.h"
 #include "mac.h"
 #include "baseband.h"
 #include "rf.h"
diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index 9a3e3ce..2ef45ca 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -46,7 +46,6 @@
  */
 
 #include "device.h"
-#include "tmacro.h"
 #include "card.h"
 #include "baseband.h"
 #include "mac.h"
diff --git a/drivers/staging/vt6656/int.c b/drivers/staging/vt6656/int.c
index b717ace..5961f159 100644
--- a/drivers/staging/vt6656/int.c
+++ b/drivers/staging/vt6656/int.c
@@ -33,7 +33,6 @@
  */
 
 #include "int.h"
-#include "tmacro.h"
 #include "mac.h"
 #include "power.h"
 #include "bssdb.h"
diff --git a/drivers/staging/vt6656/mac.c b/drivers/staging/vt6656/mac.c
index 755ac56..27fad2e 100644
--- a/drivers/staging/vt6656/mac.c
+++ b/drivers/staging/vt6656/mac.c
@@ -30,7 +30,6 @@
  * Revision History:
  */
 
-#include "tmacro.h"
 #include "desc.h"
 #include "mac.h"
 #include "80211hdr.h"
diff --git a/drivers/staging/vt6656/mac.h b/drivers/staging/vt6656/mac.h
index eac2be7..3e17457 100644
--- a/drivers/staging/vt6656/mac.h
+++ b/drivers/staging/vt6656/mac.h
@@ -35,7 +35,6 @@
 #define __MAC_H__
 
 #include "device.h"
-#include "tmacro.h"
 
 #define REV_ID_VT3253_A0    0x00
 #define REV_ID_VT3253_A1    0x01
diff --git a/drivers/staging/vt6656/tmacro.h b/drivers/staging/vt6656/tmacro.h
deleted file mode 100644
index 15e724e..0000000
--- a/drivers/staging/vt6656/tmacro.h
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
- * File: tmacro.h
- *
- * Purpose: define basic common types and macros
- *
- * Author: Tevin Chen
- *
- * Date: May 21, 1996
- *
- */
-
-#ifndef __TMACRO_H__
-#define __TMACRO_H__
-
-/****** Common helper macros ***********************************************/
-
-#if !defined(LOBYTE)
-#define LOBYTE(w)           ((u8)(w))
-#endif
-#if !defined(HIBYTE)
-#define HIBYTE(w)           ((u8)(((u16)(w) >> 8) & 0xFF))
-#endif
-
-#if !defined(LOWORD)
-#define LOWORD(d)           ((u16)(d))
-#endif
-#if !defined(HIWORD)
-#define HIWORD(d)           ((u16)((((u32)(d)) >> 16) & 0xFFFF))
-#endif
-
-#if !defined(MAKEWORD)
-#define MAKEWORD(lb, hb)    ((u16)(((u8)(lb)) | (((u16)((u8)(hb))) << 8)))
-#endif
-
-#endif /* __TMACRO_H__ */
diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index 106c4c4..b190857 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -38,7 +38,6 @@
  *
  */
 
-#include "tmacro.h"
 #include "device.h"
 #include "mac.h"
 #include "card.h"
-- 
1.9.1

