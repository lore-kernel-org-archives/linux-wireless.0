Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:41299 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756210AbaJ2R5s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 13:57:48 -0400
Received: by mail-wi0-f170.google.com with SMTP id q5so2215364wiv.1
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2014 10:57:46 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH v2 25/48] staging: vt6655L remove tether.c functions
Date: Wed, 29 Oct 2014 17:55:43 +0000
Message-Id: <1414605366-9335-26-git-send-email-tvboxspy@gmail.com> (sfid-20141029_185754_962340_7FA77220)
In-Reply-To: <1414605366-9335-1-git-send-email-tvboxspy@gmail.com>
References: <1414605366-9335-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

remove
ETHbyGetHashIndexByCrc32
ETHbIsBufferCrc32Ok

tether.h header will be removed later

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/Makefile |   1 -
 drivers/staging/vt6655/tether.c | 105 ----------------------------------------
 drivers/staging/vt6655/tether.h |   4 --
 3 files changed, 110 deletions(-)
 delete mode 100644 drivers/staging/vt6655/tether.c

diff --git a/drivers/staging/vt6655/Makefile b/drivers/staging/vt6655/Makefile
index d571e6f..1a5876d 100644
--- a/drivers/staging/vt6655/Makefile
+++ b/drivers/staging/vt6655/Makefile
@@ -14,7 +14,6 @@ vt6655_stage-y +=	device_main.o \
 	power.o \
 	srom.o \
 	mib.o \
-	tether.o \
 	tcrc.o \
 	key.o \
 	rf.o
diff --git a/drivers/staging/vt6655/tether.c b/drivers/staging/vt6655/tether.c
deleted file mode 100644
index 1e7d3e2..0000000
--- a/drivers/staging/vt6655/tether.c
+++ /dev/null
@@ -1,105 +0,0 @@
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
- *      ETHbyGetHashIndexByCrc32 - Calculate multicast hash value by CRC32
- *      ETHbIsBufferCrc32Ok - Check CRC value of the buffer if Ok or not
- *
- * Revision History:
- *
- */
-
-#include "device.h"
-#include "tmacro.h"
-#include "tcrc.h"
-#include "tether.h"
-
-/*---------------------  Static Definitions -------------------------*/
-
-/*---------------------  Static Classes  ----------------------------*/
-
-/*---------------------  Static Variables  --------------------------*/
-
-/*---------------------  Static Functions  --------------------------*/
-
-/*---------------------  Export Variables  --------------------------*/
-
-/*
- * Description: Calculate multicast hash value by CRC32
- *
- * Parameters:
- *  In:
- *		pbyMultiAddr    - Multicast Address
- *  Out:
- *      none
- *
- * Return Value: Hash value
- *
- */
-unsigned char ETHbyGetHashIndexByCrc32(unsigned char *pbyMultiAddr)
-{
-	int     ii;
-	unsigned char byTmpHash;
-	unsigned char byHash = 0;
-
-	// get the least 6-bits from CRC generator
-	byTmpHash = (unsigned char)(CRCdwCrc32(pbyMultiAddr, ETH_ALEN,
-					       0xFFFFFFFFL) & 0x3F);
-	// reverse most bit to least bit
-	for (ii = 0; ii < (sizeof(byTmpHash) * 8); ii++) {
-		byHash <<= 1;
-		if (byTmpHash & 0x01)
-			byHash |= 1;
-		byTmpHash >>= 1;
-	}
-
-	// adjust 6-bits to the right most
-	return byHash >> 2;
-}
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
-bool ETHbIsBufferCrc32Ok(unsigned char *pbyBuffer, unsigned int cbFrameLength)
-{
-	unsigned long dwCRC;
-
-	dwCRC = CRCdwGetCrc32(pbyBuffer, cbFrameLength - 4);
-	if (cpu_to_le32(*((unsigned long *)(pbyBuffer + cbFrameLength - 4))) != dwCRC)
-		return false;
-
-	return true;
-}
diff --git a/drivers/staging/vt6655/tether.h b/drivers/staging/vt6655/tether.h
index 94cc883..850554c 100644
--- a/drivers/staging/vt6655/tether.h
+++ b/drivers/staging/vt6655/tether.h
@@ -185,8 +185,4 @@ S802_11Header, *PS802_11Header;
 
 /*---------------------  Export Functions  --------------------------*/
 
-unsigned char ETHbyGetHashIndexByCrc32(unsigned char *pbyMultiAddr);
-//unsigned char ETHbyGetHashIndexByCrc(unsigned char *pbyMultiAddr);
-bool ETHbIsBufferCrc32Ok(unsigned char *pbyBuffer, unsigned int cbFrameLength);
-
 #endif // __TETHER_H__
-- 
2.1.0

