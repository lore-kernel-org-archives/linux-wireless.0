Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:54510 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932087AbaFYUVb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2014 16:21:31 -0400
Received: by mail-wg0-f43.google.com with SMTP id b13so2555658wgh.26
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jun 2014 13:21:29 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 16/34] staging: vt6656: dead code remove rc4.c/h
Date: Wed, 25 Jun 2014 21:19:53 +0100
Message-Id: <1403727611-6825-17-git-send-email-tvboxspy@gmail.com> (sfid-20140625_223001_660397_FC301F2F)
In-Reply-To: <1403727611-6825-1-git-send-email-tvboxspy@gmail.com>
References: <1403727611-6825-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/Makefile |  1 -
 drivers/staging/vt6656/card.c   |  1 -
 drivers/staging/vt6656/device.h |  2 -
 drivers/staging/vt6656/rc4.c    | 87 -----------------------------------------
 drivers/staging/vt6656/rc4.h    | 46 ----------------------
 5 files changed, 137 deletions(-)
 delete mode 100644 drivers/staging/vt6656/rc4.c
 delete mode 100644 drivers/staging/vt6656/rc4.h

diff --git a/drivers/staging/vt6656/Makefile b/drivers/staging/vt6656/Makefile
index ca1c425..2e0361b 100644
--- a/drivers/staging/vt6656/Makefile
+++ b/drivers/staging/vt6656/Makefile
@@ -12,7 +12,6 @@ vt6656_stage-y +=	main_usb.o \
 			dpc.o \
 			power.o \
 			datarate.o \
-			rc4.o \
 			tether.o \
 			key.o \
 			rf.o \
diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index 9181709..6652633 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -54,7 +54,6 @@
 #include "rf.h"
 #include "power.h"
 #include "key.h"
-#include "rc4.h"
 #include "datarate.h"
 #include "usbpipe.h"
 
diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index c2e495b..c5b5b9f 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -77,7 +77,6 @@
 #include "tether.h"
 #include "wmgr.h"
 #include "wcmd.h"
-#include "rc4.h"
 #include "desc.h"
 #include "key.h"
 #include "card.h"
@@ -640,7 +639,6 @@ struct vnt_private {
 	SKeyManagement sKey;
 	u32 dwIVCounter;
 
-	RC4Ext SBox;
 	u8 abyPRNG[WLAN_WEPMAX_KEYLEN+3];
 	u8 byKeyIndex;
 
diff --git a/drivers/staging/vt6656/rc4.c b/drivers/staging/vt6656/rc4.c
deleted file mode 100644
index 2fd836f..0000000
--- a/drivers/staging/vt6656/rc4.c
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
- * File: rc4.c
- *
- * Purpose:
- *
- * Functions:
- *
- * Revision History:
- *
- * Author: Kyle Hsu
- *
- * Date: Sep 4, 2002
- *
- */
-
-#include "rc4.h"
-
-void rc4_init(PRC4Ext pRC4, u8 * pbyKey, unsigned int cbKey_len)
-{
-	unsigned int  ust1, ust2;
-	unsigned int  keyindex;
-	unsigned int  stateindex;
-	u8 * pbyst;
-	unsigned int  idx;
-
-	pbyst = pRC4->abystate;
-	pRC4->ux = 0;
-	pRC4->uy = 0;
-	for (idx = 0; idx < 256; idx++)
-		pbyst[idx] = (u8)idx;
-	keyindex = 0;
-	stateindex = 0;
-	for (idx = 0; idx < 256; idx++) {
-		ust1 = pbyst[idx];
-		stateindex = (stateindex + pbyKey[keyindex] + ust1) & 0xff;
-		ust2 = pbyst[stateindex];
-		pbyst[stateindex] = (u8)ust1;
-		pbyst[idx] = (u8)ust2;
-		if (++keyindex >= cbKey_len)
-			keyindex = 0;
-	}
-}
-
-unsigned int rc4_byte(PRC4Ext pRC4)
-{
-	unsigned int ux;
-	unsigned int uy;
-	unsigned int ustx, usty;
-	u8 * pbyst;
-
-	pbyst = pRC4->abystate;
-	ux = (pRC4->ux + 1) & 0xff;
-	ustx = pbyst[ux];
-	uy = (ustx + pRC4->uy) & 0xff;
-	usty = pbyst[uy];
-	pRC4->ux = ux;
-	pRC4->uy = uy;
-	pbyst[uy] = (u8)ustx;
-	pbyst[ux] = (u8)usty;
-
-	return pbyst[(ustx + usty) & 0xff];
-}
-
-void rc4_encrypt(PRC4Ext pRC4, u8 * pbyDest,
-			u8 * pbySrc, unsigned int cbData_len)
-{
-	unsigned int ii;
-	for (ii = 0; ii < cbData_len; ii++)
-		pbyDest[ii] = (u8)(pbySrc[ii] ^ rc4_byte(pRC4));
-}
diff --git a/drivers/staging/vt6656/rc4.h b/drivers/staging/vt6656/rc4.h
deleted file mode 100644
index d376e1a..0000000
--- a/drivers/staging/vt6656/rc4.h
+++ /dev/null
@@ -1,46 +0,0 @@
-/*
- * File: rc4.h
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
- * Purpose:
- *
- * Functions:
- *
- * Revision History:
- *
- * Author: Kyle Hsu
- *
- * Date: Sep 4, 2002
- *
- */
-
-#ifndef __RC4_H__
-#define __RC4_H__
-
-#include <linux/types.h>
-
-typedef struct {
-    unsigned int ux;
-    unsigned int uy;
-    u8 abystate[256];
-} RC4Ext, *PRC4Ext;
-
-void rc4_init(PRC4Ext pRC4, u8 * pbyKey, unsigned int cbKey_len);
-unsigned int rc4_byte(PRC4Ext pRC4);
-void rc4_encrypt(PRC4Ext pRC4, u8 * pbyDest, u8 * pbySrc,
-		 unsigned int cbData_len);
-
-#endif /* __RC4_H__ */
-- 
1.9.1

