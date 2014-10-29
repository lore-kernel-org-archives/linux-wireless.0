Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:40716 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756904AbaJ2R5l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 13:57:41 -0400
Received: by mail-wg0-f52.google.com with SMTP id b13so1904752wgh.39
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2014 10:57:39 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH v2 21/48] staging: vt6655: dead code remove michael.c/h
Date: Wed, 29 Oct 2014 17:55:39 +0000
Message-Id: <1414605366-9335-22-git-send-email-tvboxspy@gmail.com> (sfid-20141029_185752_577142_2B3752E7)
In-Reply-To: <1414605366-9335-1-git-send-email-tvboxspy@gmail.com>
References: <1414605366-9335-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/Makefile  |   1 -
 drivers/staging/vt6655/michael.c | 148 ---------------------------------------
 drivers/staging/vt6655/michael.h |  52 --------------
 drivers/staging/vt6655/rxtx.c    |   1 -
 4 files changed, 202 deletions(-)
 delete mode 100644 drivers/staging/vt6655/michael.c
 delete mode 100644 drivers/staging/vt6655/michael.h

diff --git a/drivers/staging/vt6655/Makefile b/drivers/staging/vt6655/Makefile
index f49f12b..5449ced 100644
--- a/drivers/staging/vt6655/Makefile
+++ b/drivers/staging/vt6655/Makefile
@@ -17,7 +17,6 @@ vt6655_stage-y +=	device_main.o \
 	tether.o \
 	tcrc.o \
 	key.o \
-	michael.o \
 	rf.o \
 	vntwifi.o
 
diff --git a/drivers/staging/vt6655/michael.c b/drivers/staging/vt6655/michael.c
deleted file mode 100644
index edee487..0000000
--- a/drivers/staging/vt6655/michael.c
+++ /dev/null
@@ -1,148 +0,0 @@
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
- *      s_dwGetUINT32 - Convert from unsigned char [] to unsigned long in a portable way
- *      s_vPutUINT32 - Convert from unsigned long to unsigned char [] in a portable way
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
-/*---------------------  Static Definitions -------------------------*/
-
-/*---------------------  Static Variables  --------------------------*/
-
-/*---------------------  Static Functions  --------------------------*/
-
-static void s_vClear(void);                       // Clear the internal message,
-// resets the object to the state just after construction.
-static void s_vSetKey(u32  dwK0, u32  dwK1);
-static void s_vAppendByte(unsigned char b);            // Add a single byte to the internal message
-
-/*---------------------  Export Variables  --------------------------*/
-static u32 L, R;	/* Current state */
-
-static u32 K0, K1;	/* Key */
-static u32 M;		/* Message accumulator (single word) */
-static unsigned int nBytesInM;      // # bytes in M
-
-/*---------------------  Export Functions  --------------------------*/
-
-static void s_vClear(void)
-{
-	// Reset the state to the empty message.
-	L = K0;
-	R = K1;
-	nBytesInM = 0;
-	M = 0;
-}
-
-static void s_vSetKey(u32 dwK0, u32 dwK1)
-{
-	// Set the key
-	K0 = dwK0;
-	K1 = dwK1;
-	// and reset the message
-	s_vClear();
-}
-
-static void s_vAppendByte(unsigned char b)
-{
-	// Append the byte to our word-sized buffer
-	M |= b << (8*nBytesInM);
-	nBytesInM++;
-	// Process the word if it is full.
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
-		// Clear the buffer
-		M = 0;
-		nBytesInM = 0;
-	}
-}
-
-void MIC_vInit(u32 dwK0, u32 dwK1)
-{
-	// Set the key
-	s_vSetKey(dwK0, dwK1);
-}
-
-void MIC_vUnInit(void)
-{
-	// Wipe the key material
-	K0 = 0;
-	K1 = 0;
-
-	// And the other fields as well.
-	//Note that this sets (L,R) to (K0,K1) which is just fine.
-	s_vClear();
-}
-
-void MIC_vAppend(unsigned char *src, unsigned int nBytes)
-{
-	// This is simple
-	while (nBytes > 0) {
-		s_vAppendByte(*src++);
-		nBytes--;
-	}
-}
-
-void MIC_vGetMIC(u32 *pdwL, u32 *pdwR)
-{
-	// Append the minimum padding
-	s_vAppendByte(0x5a);
-	s_vAppendByte(0);
-	s_vAppendByte(0);
-	s_vAppendByte(0);
-	s_vAppendByte(0);
-	// and then zeroes until the length is a multiple of 4
-	while (nBytesInM != 0)
-		s_vAppendByte(0);
-
-	// The s_vAppendByte function has already computed the result.
-	*pdwL = L;
-	*pdwR = R;
-	// Reset to the empty message.
-	s_vClear();
-}
diff --git a/drivers/staging/vt6655/michael.h b/drivers/staging/vt6655/michael.h
deleted file mode 100644
index 86cb140..0000000
--- a/drivers/staging/vt6655/michael.h
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
-/* Append bytes to the message to be MICed */
-void MIC_vAppend(unsigned char *src, unsigned int nBytes);
-
-/* Get the MIC result. Destination should accept 8 bytes of result. */
-/* This also resets the message to empty. */
-void MIC_vGetMIC(u32 *pdwL, u32 *pdwR);
-
-/* Rotation functions on 32 bit values */
-#define ROL32(A, n)							\
-	(((A) << (n)) | (((A)>>(32-(n)))  & ((1UL << (n)) - 1)))
-#define ROR32(A, n) ROL32((A), 32-(n))
-
-#endif /*__MICHAEL_H__ */
diff --git a/drivers/staging/vt6655/rxtx.c b/drivers/staging/vt6655/rxtx.c
index 5ece2db..4770b9c 100644
--- a/drivers/staging/vt6655/rxtx.c
+++ b/drivers/staging/vt6655/rxtx.c
@@ -55,7 +55,6 @@
 #include "bssdb.h"
 #include "mac.h"
 #include "baseband.h"
-#include "michael.h"
 #include "tcrc.h"
 #include "wctl.h"
 #include "rf.h"
-- 
2.1.0

