Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:60777 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756974AbaJ2R6a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 13:58:30 -0400
Received: by mail-wg0-f50.google.com with SMTP id z12so2455955wgg.23
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2014 10:58:28 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH v2 48/48] staging: vt6655: dead code remove header type.h
Date: Wed, 29 Oct 2014 17:56:06 +0000
Message-Id: <1414605366-9335-49-git-send-email-tvboxspy@gmail.com> (sfid-20141029_185845_504250_965BC0BD)
In-Reply-To: <1414605366-9335-1-git-send-email-tvboxspy@gmail.com>
References: <1414605366-9335-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/baseband.h   |  1 -
 drivers/staging/vt6655/card.h       |  1 -
 drivers/staging/vt6655/channel.h    |  1 -
 drivers/staging/vt6655/desc.h       |  1 -
 drivers/staging/vt6655/device.h     |  1 -
 drivers/staging/vt6655/device_cfg.h |  2 --
 drivers/staging/vt6655/key.h        |  2 --
 drivers/staging/vt6655/mac.h        |  1 -
 drivers/staging/vt6655/mib.h        |  1 -
 drivers/staging/vt6655/power.c      |  1 -
 drivers/staging/vt6655/rf.h         |  1 -
 drivers/staging/vt6655/rxtx.h       |  1 -
 drivers/staging/vt6655/srom.h       |  2 --
 drivers/staging/vt6655/tmacro.h     |  2 --
 drivers/staging/vt6655/ttype.h      | 42 -------------------------------------
 drivers/staging/vt6655/upc.h        |  1 -
 16 files changed, 61 deletions(-)
 delete mode 100644 drivers/staging/vt6655/ttype.h

diff --git a/drivers/staging/vt6655/baseband.h b/drivers/staging/vt6655/baseband.h
index 772ea0d..bfdd422 100644
--- a/drivers/staging/vt6655/baseband.h
+++ b/drivers/staging/vt6655/baseband.h
@@ -30,7 +30,6 @@
 #ifndef __BASEBAND_H__
 #define __BASEBAND_H__
 
-#include "ttype.h"
 #include "device.h"
 
 /*
diff --git a/drivers/staging/vt6655/card.h b/drivers/staging/vt6655/card.h
index 3a626a3..f5effdb 100644
--- a/drivers/staging/vt6655/card.h
+++ b/drivers/staging/vt6655/card.h
@@ -29,7 +29,6 @@
 #ifndef __CARD_H__
 #define __CARD_H__
 
-#include "ttype.h"
 #include <linux/types.h>
 #include <linux/nl80211.h>
 
diff --git a/drivers/staging/vt6655/channel.h b/drivers/staging/vt6655/channel.h
index ee00f4e..4f4264e 100644
--- a/drivers/staging/vt6655/channel.h
+++ b/drivers/staging/vt6655/channel.h
@@ -23,7 +23,6 @@
 #ifndef _CHANNEL_H_
 #define _CHANNEL_H_
 
-#include "ttype.h"
 #include "card.h"
 
 void vnt_init_bands(struct vnt_private *);
diff --git a/drivers/staging/vt6655/desc.h b/drivers/staging/vt6655/desc.h
index 32dd1ca..758eeb2 100644
--- a/drivers/staging/vt6655/desc.h
+++ b/drivers/staging/vt6655/desc.h
@@ -34,7 +34,6 @@
 #include <linux/types.h>
 #include <linux/mm.h>
 #include "linux/ieee80211.h"
-#include "ttype.h"
 
 #define B_OWNED_BY_CHIP     1
 #define B_OWNED_BY_HOST     0
diff --git a/drivers/staging/vt6655/device.h b/drivers/staging/vt6655/device.h
index d0855bd..93d2ccb 100644
--- a/drivers/staging/vt6655/device.h
+++ b/drivers/staging/vt6655/device.h
@@ -67,7 +67,6 @@
 /* device specific */
 
 #include "device_cfg.h"
-#include "ttype.h"
 #include "card.h"
 #include "mib.h"
 #include "srom.h"
diff --git a/drivers/staging/vt6655/device_cfg.h b/drivers/staging/vt6655/device_cfg.h
index 7221824..a4a8a84 100644
--- a/drivers/staging/vt6655/device_cfg.h
+++ b/drivers/staging/vt6655/device_cfg.h
@@ -29,8 +29,6 @@
 
 #include <linux/types.h>
 
-#include "ttype.h"
-
 typedef
 struct _version {
 	unsigned char   major;
diff --git a/drivers/staging/vt6655/key.h b/drivers/staging/vt6655/key.h
index 5615f39..c01d4af 100644
--- a/drivers/staging/vt6655/key.h
+++ b/drivers/staging/vt6655/key.h
@@ -32,8 +32,6 @@
 
 #include <net/mac80211.h>
 
-#include "ttype.h"
-
 /*---------------------  Export Definitions -------------------------*/
 #define MAX_GROUP_KEY       4
 #define MAX_KEY_TABLE       11
diff --git a/drivers/staging/vt6655/mac.h b/drivers/staging/vt6655/mac.h
index 0bf9375..5391277 100644
--- a/drivers/staging/vt6655/mac.h
+++ b/drivers/staging/vt6655/mac.h
@@ -34,7 +34,6 @@
 #ifndef __MAC_H__
 #define __MAC_H__
 
-#include "ttype.h"
 #include "tmacro.h"
 #include "upc.h"
 
diff --git a/drivers/staging/vt6655/mib.h b/drivers/staging/vt6655/mib.h
index a2e6106..5cb59b8 100644
--- a/drivers/staging/vt6655/mib.h
+++ b/drivers/staging/vt6655/mib.h
@@ -29,7 +29,6 @@
 #ifndef __MIB_H__
 #define __MIB_H__
 
-#include "ttype.h"
 #include "desc.h"
 
 //
diff --git a/drivers/staging/vt6655/power.c b/drivers/staging/vt6655/power.c
index a8aedee..e826f07 100644
--- a/drivers/staging/vt6655/power.c
+++ b/drivers/staging/vt6655/power.c
@@ -37,7 +37,6 @@
  *
  */
 
-#include "ttype.h"
 #include "mac.h"
 #include "device.h"
 #include "power.h"
diff --git a/drivers/staging/vt6655/rf.h b/drivers/staging/vt6655/rf.h
index be4ef88..e8a7372 100644
--- a/drivers/staging/vt6655/rf.h
+++ b/drivers/staging/vt6655/rf.h
@@ -30,7 +30,6 @@
 #ifndef __RF_H__
 #define __RF_H__
 
-#include "ttype.h"
 #include "device.h"
 
 /*---------------------  Export Definitions -------------------------*/
diff --git a/drivers/staging/vt6655/rxtx.h b/drivers/staging/vt6655/rxtx.h
index cf0dfa6..b9bd163 100644
--- a/drivers/staging/vt6655/rxtx.h
+++ b/drivers/staging/vt6655/rxtx.h
@@ -29,7 +29,6 @@
 #ifndef __RXTX_H__
 #define __RXTX_H__
 
-#include "ttype.h"
 #include "device.h"
 
 #define DEFAULT_MSDU_LIFETIME_RES_64us	8000 /* 64us */
diff --git a/drivers/staging/vt6655/srom.h b/drivers/staging/vt6655/srom.h
index 3128e53..9f309c4 100644
--- a/drivers/staging/vt6655/srom.h
+++ b/drivers/staging/vt6655/srom.h
@@ -30,8 +30,6 @@
 #ifndef __SROM_H__
 #define __SROM_H__
 
-#include "ttype.h"
-
 /*---------------------  Export Definitions -------------------------*/
 
 #define EEP_MAX_CONTEXT_SIZE    256
diff --git a/drivers/staging/vt6655/tmacro.h b/drivers/staging/vt6655/tmacro.h
index 59c6e72..607b78f 100644
--- a/drivers/staging/vt6655/tmacro.h
+++ b/drivers/staging/vt6655/tmacro.h
@@ -29,8 +29,6 @@
 #ifndef __TMACRO_H__
 #define __TMACRO_H__
 
-#include "ttype.h"
-
 /****** Common helper macros ***********************************************/
 
 #if !defined(LOBYTE)
diff --git a/drivers/staging/vt6655/ttype.h b/drivers/staging/vt6655/ttype.h
deleted file mode 100644
index 747ef62..0000000
--- a/drivers/staging/vt6655/ttype.h
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
- * File: ttype.h
- *
- * Purpose: define basic common types and macros
- *
- * Author: Tevin Chen
- *
- * Date: May 21, 1996
- *
- */
-
-#ifndef __TTYPE_H__
-#define __TTYPE_H__
-
-/******* Common definitions and typedefs ***********************************/
-
-#ifndef WPA_SM_Transtatus
-#define WPA_SM_Transtatus
-#endif
-
-#ifndef Calcu_LinkQual
-#define Calcu_LinkQual
-#endif
-
-#endif // __TTYPE_H__
diff --git a/drivers/staging/vt6655/upc.h b/drivers/staging/vt6655/upc.h
index c5c889ca..c53703a 100644
--- a/drivers/staging/vt6655/upc.h
+++ b/drivers/staging/vt6655/upc.h
@@ -30,7 +30,6 @@
 #define __UPC_H__
 
 #include "device.h"
-#include "ttype.h"
 
 /*---------------------  Export Definitions -------------------------*/
 
-- 
2.1.0

