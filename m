Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:41871 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932124AbaFYUV3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2014 16:21:29 -0400
Received: by mail-we0-f176.google.com with SMTP id u56so2684927wes.7
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jun 2014 13:21:28 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 15/34] staging: vt6656: dead code remove micheal.c/h
Date: Wed, 25 Jun 2014 21:19:52 +0100
Message-Id: <1403727611-6825-16-git-send-email-tvboxspy@gmail.com> (sfid-20140625_223008_236565_20C22531)
In-Reply-To: <1403727611-6825-1-git-send-email-tvboxspy@gmail.com>
References: <1403727611-6825-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/Makefile  |   1 -
 drivers/staging/vt6656/dpc.c     |   1 -
 drivers/staging/vt6656/michael.c | 167 ---------------------------------------
 drivers/staging/vt6656/michael.h |  52 ------------
 drivers/staging/vt6656/rxtx.c    |   1 -
 5 files changed, 222 deletions(-)
 delete mode 100644 drivers/staging/vt6656/michael.c
 delete mode 100644 drivers/staging/vt6656/michael.h

diff --git a/drivers/staging/vt6656/Makefile b/drivers/staging/vt6656/Makefile
index ad39400..ca1c425 100644
--- a/drivers/staging/vt6656/Makefile
+++ b/drivers/staging/vt6656/Makefile
@@ -15,7 +15,6 @@ vt6656_stage-y +=	main_usb.o \
 			rc4.o \
 			tether.o \
 			key.o \
-			michael.o \
 			rf.o \
 			usbpipe.o \
 			channel.o \
diff --git a/drivers/staging/vt6656/dpc.c b/drivers/staging/vt6656/dpc.c
index 167520f..fe4b6ac 100644
--- a/drivers/staging/vt6656/dpc.c
+++ b/drivers/staging/vt6656/dpc.c
@@ -43,7 +43,6 @@
 #include "bssdb.h"
 #include "mac.h"
 #include "baseband.h"
-#include "michael.h"
 #include "rf.h"
 #include "iowpa.h"
 #include "datarate.h"
diff --git a/drivers/staging/vt6656/michael.c b/drivers/staging/vt6656/michael.c
deleted file mode 100644
index 9a5a0b6..0000000
--- a/drivers/staging/vt6656/michael.c
+++ /dev/null
@@ -1,167 +0,0 @@
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
- * File: michael.cpp
- *
- * Purpose: The implementation of LIST data structure.
- *
- * Author: Kyle Hsu
- *
- * Date: Sep 4, 2002
- *
- * Functions:
- *      s_dwGetUINT32 - Convert from u8[] to u32 in a portable way
- *      s_vPutUINT32 - Convert from u32 to u8[] in a portable way
- *      s_vClear - Reset the state to the empty message.
- *      s_vSetKey - Set the key.
- *      MIC_vInit - Set the key.
- *      s_vAppendByte - Append the byte to our word-sized buffer.
- *      MIC_vAppend - call s_vAppendByte.
- *      MIC_vGetMIC - Append the minimum padding and call s_vAppendByte.
- *
- * Revision History:
- *
- */
-
-#include "tmacro.h"
-#include "michael.h"
-
-/*
- * static u32 s_dwGetUINT32(u8 * p);         Get u32 from
- *							4 bytes LSByte first
- * static void s_vPutUINT32(u8* p, u32 val); Put u32 into
- *							4 bytes LSByte first
- */
-static void s_vClear(void);		/* Clear the internal message,
-					 * resets the object to the
-					 * state just after construction. */
-static void s_vSetKey(u32 dwK0, u32 dwK1);
-static void s_vAppendByte(u8 b);	/* Add a single byte to the internal
-					 * message */
-
-static u32  L, R;		/* Current state */
-static u32  K0, K1;		/* Key */
-static u32  M;		/* Message accumulator (single word) */
-static unsigned int   nBytesInM;	/* # bytes in M */
-
-/*
-static u32 s_dwGetUINT32 (u8 * p)
-// Convert from u8[] to u32 in a portable way
-{
-	u32 res = 0;
-	unsigned int i;
-	for (i = 0; i < 4; i++)
-		res |= (*p++) << (8*i);
-	return res;
-}
-
-static void s_vPutUINT32(u8 *p, u32 val)
-// Convert from u32 to u8[] in a portable way
-{
-	unsigned int i;
-	for (i = 0; i < 4; i++) {
-		*p++ = (u8) (val & 0xff);
-		val >>= 8;
-	}
-}
-*/
-
-static void s_vClear(void)
-{
-	/* Reset the state to the empty message. */
-	L = K0;
-	R = K1;
-	nBytesInM = 0;
-	M = 0;
-}
-
-static void s_vSetKey(u32 dwK0, u32 dwK1)
-{
-	/* Set the key */
-	K0 = dwK0;
-	K1 = dwK1;
-	/* and reset the message */
-	s_vClear();
-}
-
-static void s_vAppendByte(u8 b)
-{
-	/* Append the byte to our word-sized buffer */
-	M |= b << (8*nBytesInM);
-	nBytesInM++;
-	/* Process the word if it is full. */
-	if (nBytesInM >= 4) {
-		L ^= M;
-		R ^= ROL32(L, 17);
-		L += R;
-		R ^= ((L & 0xff00ff00) >> 8) | ((L & 0x00ff00ff) << 8);
-		L += R;
-		R ^= ROL32(L, 3);
-		L += R;
-		R ^= ROR32(L, 2);
-		L += R;
-		/* Clear the buffer */
-		M = 0;
-		nBytesInM = 0;
-	}
-}
-
-void MIC_vInit(u32 dwK0, u32 dwK1)
-{
-	/* Set the key */
-	s_vSetKey(dwK0, dwK1);
-}
-
-void MIC_vUnInit(void)
-{
-	/* Wipe the key material */
-	K0 = 0;
-	K1 = 0;
-
-	/* And the other fields as well. */
-	/* Note that this sets (L,R) to (K0,K1) which is just fine. */
-	s_vClear();
-}
-
-void MIC_vAppend(u8 * src, unsigned int nBytes)
-{
-    /* This is simple */
-	while (nBytes > 0) {
-		s_vAppendByte(*src++);
-		nBytes--;
-	}
-}
-
-void MIC_vGetMIC(u32 * pdwL, u32 * pdwR)
-{
-	/* Append the minimum padding */
-	s_vAppendByte(0x5a);
-	s_vAppendByte(0);
-	s_vAppendByte(0);
-	s_vAppendByte(0);
-	s_vAppendByte(0);
-	/* and then zeroes until the length is a multiple of 4 */
-	while (nBytesInM != 0)
-		s_vAppendByte(0);
-	/* The s_vAppendByte function has already computed the result. */
-	*pdwL = L;
-	*pdwR = R;
-	/* Reset to the empty message. */
-	s_vClear();
-}
diff --git a/drivers/staging/vt6656/michael.h b/drivers/staging/vt6656/michael.h
deleted file mode 100644
index 9c69a42..0000000
--- a/drivers/staging/vt6656/michael.h
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
- * File: Michael.h
- *
- * Purpose: Reference implementation for Michael
- *          written by Niels Ferguson
- *
- * Author: Kyle Hsu
- *
- * Date: Jan 2, 2003
- *
- */
-
-#ifndef __MICHAEL_H__
-#define __MICHAEL_H__
-
-#include <linux/types.h>
-
-void MIC_vInit(u32 dwK0, u32 dwK1);
-
-void MIC_vUnInit(void);
-
-// Append bytes to the message to be MICed
-void MIC_vAppend(u8 * src, unsigned int nBytes);
-
-// Get the MIC result. Destination should accept 8 bytes of result.
-// This also resets the message to empty.
-void MIC_vGetMIC(u32 * pdwL, u32 * pdwR);
-
-// Rotation functions on 32 bit values
-#define ROL32(A, n) \
- (((A) << (n)) | (((A)>>(32-(n)))  & ((1UL << (n)) - 1)))
-#define ROR32(A, n) ROL32((A), 32-(n))
-
-#endif /* __MICHAEL_H__ */
diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index b286072..ab80c46 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -49,7 +49,6 @@
 #include "card.h"
 #include "bssdb.h"
 #include "mac.h"
-#include "michael.h"
 #include "rf.h"
 #include "datarate.h"
 #include "usbpipe.h"
-- 
1.9.1

