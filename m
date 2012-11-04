Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:48189 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605Ab2KDRjN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Nov 2012 12:39:13 -0500
Received: by mail-wg0-f44.google.com with SMTP id dr13so3451414wgb.1
        for <linux-wireless@vger.kernel.org>; Sun, 04 Nov 2012 09:39:11 -0800 (PST)
Message-ID: <1352050742.5774.1.camel@Route3278> (sfid-20121104_183930_084934_F92424D2)
Subject: [PATCH] staging: vt6656: dead code remove upc.h
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Sun, 04 Nov 2012 17:39:02 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/mib.c |    1 -
 drivers/staging/vt6656/upc.h |  162 ------------------------------------------
 2 files changed, 163 deletions(-)
 delete mode 100644 drivers/staging/vt6656/upc.h

diff --git a/drivers/staging/vt6656/mib.c b/drivers/staging/vt6656/mib.c
index 8a6ee72..d4c7b0c 100644
--- a/drivers/staging/vt6656/mib.c
+++ b/drivers/staging/vt6656/mib.c
@@ -37,7 +37,6 @@
  *
  */
 
-#include "upc.h"
 #include "mac.h"
 #include "tether.h"
 #include "mib.h"
diff --git a/drivers/staging/vt6656/upc.h b/drivers/staging/vt6656/upc.h
deleted file mode 100644
index b33aba4..0000000
--- a/drivers/staging/vt6656/upc.h
+++ /dev/null
@@ -1,162 +0,0 @@
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
- * File: upc.h
- *
- * Purpose: Macros to access device
- *
- * Author: Tevin Chen
- *
- * Date: Mar 17, 1997
- *
- */
-
-#ifndef __UPC_H__
-#define __UPC_H__
-
-#include "device.h"
-#include "ttype.h"
-
-/*---------------------  Export Definitions -------------------------*/
-
-
-//
-//  For IO mapped
-//
-
-#ifdef IO_MAP
-
-#define VNSvInPortB(dwIOAddress, pbyData) {                     \
-	*(pbyData) = inb(dwIOAddress);                              \
-}
-
-
-#define VNSvInPortW(dwIOAddress, pwData) {                      \
-	    *(pwData) = inw(dwIOAddress);                           \
-}
-
-#define VNSvInPortD(dwIOAddress, pdwData) {                     \
-	    *(pdwData) = inl(dwIOAddress);                          \
-}
-
-
-#define VNSvOutPortB(dwIOAddress, byData) {                     \
-        outb(byData, dwIOAddress);                              \
-}
-
-
-#define VNSvOutPortW(dwIOAddress, wData) {                      \
-        outw(wData, dwIOAddress);                               \
-}
-
-#define VNSvOutPortD(dwIOAddress, dwData) {                     \
-        outl(dwData, dwIOAddress);                              \
-}
-
-#else
-
-//
-//  For memory mapped IO
-//
-
-
-#define VNSvInPortB(dwIOAddress, pbyData) {                     \
-	volatile BYTE* pbyAddr = ((PBYTE)(dwIOAddress));            \
-	*(pbyData) = readb(pbyAddr);                           \
-}
-
-
-#define VNSvInPortW(dwIOAddress, pwData) {                      \
-	volatile WORD* pwAddr = ((PWORD)(dwIOAddress));             \
-	*(pwData) = readw(pwAddr);                             \
-}
-
-#define VNSvInPortD(dwIOAddress, pdwData) {                     \
-	volatile DWORD* pdwAddr = ((PDWORD)(dwIOAddress));          \
-	*(pdwData) = readl(pdwAddr);                           \
-}
-
-
-#define VNSvOutPortB(dwIOAddress, byData) {                     \
-    volatile BYTE* pbyAddr = ((PBYTE)(dwIOAddress));            \
-    writeb((BYTE)byData, pbyAddr);							\
-}
-
-
-#define VNSvOutPortW(dwIOAddress, wData) {                      \
-    volatile WORD* pwAddr = ((PWORD)(dwIOAddress));             \
-    writew((WORD)wData, pwAddr);							\
-}
-
-#define VNSvOutPortD(dwIOAddress, dwData) {                     \
-    volatile DWORD* pdwAddr = ((PDWORD)(dwIOAddress));          \
-    writel((DWORD)dwData, pdwAddr);					    \
-}
-
-#endif
-
-
-//
-// ALWAYS IO-Mapped IO when in 16-bit/32-bit environment
-//
-#define PCBvInPortB(dwIOAddress, pbyData) {     \
-	    *(pbyData) = inb(dwIOAddress);          \
-}
-
-#define PCBvInPortW(dwIOAddress, pwData) {      \
-	    *(pwData) = inw(dwIOAddress);           \
-}
-
-#define PCBvInPortD(dwIOAddress, pdwData) {     \
-	    *(pdwData) = inl(dwIOAddress);          \
-}
-
-#define PCBvOutPortB(dwIOAddress, byData) {     \
-        outb(byData, dwIOAddress);              \
-}
-
-#define PCBvOutPortW(dwIOAddress, wData) {      \
-        outw(wData, dwIOAddress);               \
-}
-
-#define PCBvOutPortD(dwIOAddress, dwData) {     \
-        outl(dwData, dwIOAddress);              \
-}
-
-
-#define PCAvDelayByIO(uDelayUnit) {             \
-    BYTE    byData;                             \
-    unsigned long   ii;                                 \
-                                                \
-    if (uDelayUnit <= 50) {                     \
-        udelay(uDelayUnit);                     \
-    }                                           \
-    else {                                      \
-        for (ii = 0; ii < (uDelayUnit); ii++)   \
-		     byData = inb(0x61);				\
-    }                                           \
-}
-
-
-/*---------------------  Export Classes  ----------------------------*/
-
-/*---------------------  Export Variables  --------------------------*/
-
-/*---------------------  Export Functions  --------------------------*/
-
-#endif /* __UPC_H__ */
-- 
1.7.10.4


