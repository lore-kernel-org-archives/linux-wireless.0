Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:58732 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457AbaJYUJj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Oct 2014 16:09:39 -0400
Received: by mail-wi0-f169.google.com with SMTP id q5so3385729wiv.2
        for <linux-wireless@vger.kernel.org>; Sat, 25 Oct 2014 13:09:37 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 28/48] staging: vt6655: dead code remove wctl.c/h
Date: Sat, 25 Oct 2014 09:40:06 +0100
Message-Id: <1414226426-5811-29-git-send-email-tvboxspy@gmail.com> (sfid-20141025_220941_640417_E69454FC)
In-Reply-To: <1414226426-5811-1-git-send-email-tvboxspy@gmail.com>
References: <1414226426-5811-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/Makefile      |   1 -
 drivers/staging/vt6655/device_main.c |   1 -
 drivers/staging/vt6655/rxtx.c        |   1 -
 drivers/staging/vt6655/wctl.c        | 233 -----------------------------------
 drivers/staging/vt6655/wctl.h        | 105 ----------------
 5 files changed, 341 deletions(-)
 delete mode 100644 drivers/staging/vt6655/wctl.c
 delete mode 100644 drivers/staging/vt6655/wctl.h

diff --git a/drivers/staging/vt6655/Makefile b/drivers/staging/vt6655/Makefile
index 5f3c019..115b951 100644
--- a/drivers/staging/vt6655/Makefile
+++ b/drivers/staging/vt6655/Makefile
@@ -7,7 +7,6 @@ vt6655_stage-y +=	device_main.o \
 	channel.o \
 	mac.o \
 	baseband.o \
-	wctl.o \
 	rxtx.o \
 	dpc.o \
 	power.o \
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index e581e72..27d8ce1 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -60,7 +60,6 @@
 #include "mac.h"
 #include "tether.h"
 #include "wmgr.h"
-#include "wctl.h"
 #include "power.h"
 #include "wcmd.h"
 #include "iocmd.h"
diff --git a/drivers/staging/vt6655/rxtx.c b/drivers/staging/vt6655/rxtx.c
index b8ff8c6..00ae6de 100644
--- a/drivers/staging/vt6655/rxtx.c
+++ b/drivers/staging/vt6655/rxtx.c
@@ -55,7 +55,6 @@
 #include "bssdb.h"
 #include "mac.h"
 #include "baseband.h"
-#include "wctl.h"
 #include "rf.h"
 
 /*---------------------  Static Definitions -------------------------*/
diff --git a/drivers/staging/vt6655/wctl.c b/drivers/staging/vt6655/wctl.c
deleted file mode 100644
index 5a54d98..0000000
--- a/drivers/staging/vt6655/wctl.c
+++ /dev/null
@@ -1,233 +0,0 @@
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
- * File: wctl.c
- *
- * Purpose: handle WMAC duplicate filter & defragment
- *
- * Author: Jerry Chen
- *
- * Date: Jun. 27, 2002
- *
- * Functions:
- *      WCTLbIsDuplicate - Test if duplicate packet
- *      WCTLuSearchDFCB - Search DeFragment Control Database
- *      WCTLuInsertDFCB - Insert DeFragment Control Database
- *      WCTLbHandleFragment - Handle received fragment packet
- *
- * Revision History:
- *
- */
-
-#include "wctl.h"
-#include "device.h"
-#include "card.h"
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
- * Description:
- *      Scan Rx cache.  Return true if packet is duplicate, else
- *      inserts in receive cache and returns false.
- *
- * Parameters:
- *  In:
- *      pCache      - Receive packets history
- *      pMACHeader  - 802.11 MAC Header of received packet
- *  Out:
- *      none
- *
- * Return Value: true if packet duplicate; otherwise false
- *
- */
-
-bool WCTLbIsDuplicate(PSCache pCache, PS802_11Header pMACHeader)
-{
-	unsigned int uIndex;
-	unsigned int ii;
-	PSCacheEntry    pCacheEntry;
-
-	if (IS_FC_RETRY(pMACHeader)) {
-		uIndex = pCache->uInPtr;
-		for (ii = 0; ii < DUPLICATE_RX_CACHE_LENGTH; ii++) {
-			pCacheEntry = &(pCache->asCacheEntry[uIndex]);
-			if ((pCacheEntry->wFmSequence == pMACHeader->wSeqCtl) &&
-			    ether_addr_equal(pCacheEntry->abyAddr2,
-					     pMACHeader->abyAddr2)) {
-				/* Duplicate match */
-				return true;
-			}
-			ADD_ONE_WITH_WRAP_AROUND(uIndex, DUPLICATE_RX_CACHE_LENGTH);
-		}
-	}
-	/* Not fount in cache - insert */
-	pCacheEntry = &pCache->asCacheEntry[pCache->uInPtr];
-	pCacheEntry->wFmSequence = pMACHeader->wSeqCtl;
-	memcpy(&(pCacheEntry->abyAddr2[0]), &(pMACHeader->abyAddr2[0]), ETH_ALEN);
-	ADD_ONE_WITH_WRAP_AROUND(pCache->uInPtr, DUPLICATE_RX_CACHE_LENGTH);
-	return false;
-}
-
-/*
- * Description:
- *      Found if sequence number of received fragment packet in Defragment Database
- *
- * Parameters:
- *  In:
- *      pDevice     - Pointer to adapter
- *      pMACHeader  - 802.11 MAC Header of received packet
- *  Out:
- *      none
- *
- * Return Value: index number in Defragment Database
- *
- */
-unsigned int WCTLuSearchDFCB(struct vnt_private *pDevice,
-			     PS802_11Header pMACHeader)
-{
-	unsigned int ii;
-
-	for (ii = 0; ii < pDevice->cbDFCB; ii++) {
-		if (pDevice->sRxDFCB[ii].bInUse &&
-		    ether_addr_equal(pDevice->sRxDFCB[ii].abyAddr2,
-				     pMACHeader->abyAddr2)) {
-			return ii;
-		}
-	}
-	return pDevice->cbDFCB;
-}
-
-/*
- * Description:
- *      Insert received fragment packet in Defragment Database
- *
- * Parameters:
- *  In:
- *      pDevice     - Pointer to adapter
- *      pMACHeader  - 802.11 MAC Header of received packet
- *  Out:
- *      none
- *
- * Return Value: index number in Defragment Database
- *
- */
-unsigned int WCTLuInsertDFCB(struct vnt_private *pDevice, PS802_11Header pMACHeader)
-{
-	unsigned int ii;
-
-	if (pDevice->cbFreeDFCB == 0)
-		return pDevice->cbDFCB;
-	for (ii = 0; ii < pDevice->cbDFCB; ii++) {
-		if (!pDevice->sRxDFCB[ii].bInUse) {
-			pDevice->cbFreeDFCB--;
-			pDevice->sRxDFCB[ii].uLifetime = pDevice->dwMaxReceiveLifetime;
-			pDevice->sRxDFCB[ii].bInUse = true;
-			pDevice->sRxDFCB[ii].wSequence = (pMACHeader->wSeqCtl >> 4);
-			pDevice->sRxDFCB[ii].wFragNum = (pMACHeader->wSeqCtl & 0x000F);
-			memcpy(&(pDevice->sRxDFCB[ii].abyAddr2[0]), &(pMACHeader->abyAddr2[0]), ETH_ALEN);
-			return ii;
-		}
-	}
-	return pDevice->cbDFCB;
-}
-
-/*
- * Description:
- *      Handle received fragment packet
- *
- * Parameters:
- *  In:
- *      pDevice         - Pointer to adapter
- *      pMACHeader      - 802.11 MAC Header of received packet
- *      cbFrameLength   - Frame length
- *      bWEP            - is WEP packet
- *  Out:
- *      none
- *
- * Return Value: true if it is valid fragment packet and we have resource to defragment; otherwise false
- *
- */
-bool WCTLbHandleFragment(struct vnt_private *pDevice, PS802_11Header pMACHeader,
-			 unsigned int cbFrameLength, bool bWEP, bool bExtIV)
-{
-	unsigned int uHeaderSize;
-
-	if (bWEP) {
-		uHeaderSize = 28;
-		if (bExtIV)
-			// ExtIV
-			uHeaderSize += 4;
-	} else {
-		uHeaderSize = 24;
-	}
-
-	if (IS_FIRST_FRAGMENT_PKT(pMACHeader)) {
-		pDevice->uCurrentDFCBIdx = WCTLuSearchDFCB(pDevice, pMACHeader);
-		if (pDevice->uCurrentDFCBIdx < pDevice->cbDFCB) {
-			// duplicate, we must flush previous DCB
-			pDevice->sRxDFCB[pDevice->uCurrentDFCBIdx].uLifetime = pDevice->dwMaxReceiveLifetime;
-			pDevice->sRxDFCB[pDevice->uCurrentDFCBIdx].wSequence = (pMACHeader->wSeqCtl >> 4);
-			pDevice->sRxDFCB[pDevice->uCurrentDFCBIdx].wFragNum = (pMACHeader->wSeqCtl & 0x000F);
-		} else {
-			pDevice->uCurrentDFCBIdx = WCTLuInsertDFCB(pDevice, pMACHeader);
-			if (pDevice->uCurrentDFCBIdx == pDevice->cbDFCB)
-				return false;
-		}
-		// reserve 4 byte to match MAC RX Buffer
-		pDevice->sRxDFCB[pDevice->uCurrentDFCBIdx].pbyRxBuffer = (unsigned char *)(pDevice->sRxDFCB[pDevice->uCurrentDFCBIdx].skb->data + 4);
-		memcpy(pDevice->sRxDFCB[pDevice->uCurrentDFCBIdx].pbyRxBuffer, pMACHeader, cbFrameLength);
-		pDevice->sRxDFCB[pDevice->uCurrentDFCBIdx].cbFrameLength = cbFrameLength;
-		pDevice->sRxDFCB[pDevice->uCurrentDFCBIdx].pbyRxBuffer += cbFrameLength;
-		pDevice->sRxDFCB[pDevice->uCurrentDFCBIdx].wFragNum++;
-		return false;
-	} else {
-		pDevice->uCurrentDFCBIdx = WCTLuSearchDFCB(pDevice, pMACHeader);
-		if (pDevice->uCurrentDFCBIdx != pDevice->cbDFCB) {
-			if ((pDevice->sRxDFCB[pDevice->uCurrentDFCBIdx].wSequence == (pMACHeader->wSeqCtl >> 4)) &&
-			    (pDevice->sRxDFCB[pDevice->uCurrentDFCBIdx].wFragNum == (pMACHeader->wSeqCtl & 0x000F)) &&
-			    ((pDevice->sRxDFCB[pDevice->uCurrentDFCBIdx].cbFrameLength + cbFrameLength - uHeaderSize) < 2346)) {
-				memcpy(pDevice->sRxDFCB[pDevice->uCurrentDFCBIdx].pbyRxBuffer, ((unsigned char *)(pMACHeader) + uHeaderSize), (cbFrameLength - uHeaderSize));
-				pDevice->sRxDFCB[pDevice->uCurrentDFCBIdx].cbFrameLength += (cbFrameLength - uHeaderSize);
-				pDevice->sRxDFCB[pDevice->uCurrentDFCBIdx].pbyRxBuffer += (cbFrameLength - uHeaderSize);
-				pDevice->sRxDFCB[pDevice->uCurrentDFCBIdx].wFragNum++;
-			} else {
-				// seq error or frag # error flush DFCB
-				pDevice->cbFreeDFCB++;
-				pDevice->sRxDFCB[pDevice->uCurrentDFCBIdx].bInUse = false;
-				return false;
-			}
-		} else {
-			return false;
-		}
-		if (IS_LAST_FRAGMENT_PKT(pMACHeader)) {
-			//enq defragcontrolblock
-			pDevice->cbFreeDFCB++;
-			pDevice->sRxDFCB[pDevice->uCurrentDFCBIdx].bInUse = false;
-			return true;
-		}
-		return false;
-	}
-}
diff --git a/drivers/staging/vt6655/wctl.h b/drivers/staging/vt6655/wctl.h
deleted file mode 100644
index f0995d8..0000000
--- a/drivers/staging/vt6655/wctl.h
+++ /dev/null
@@ -1,105 +0,0 @@
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
- * File: wctl.h
- *
- * Purpose:
- *
- * Author: Jerry Chen
- *
- * Date: Jun. 27, 2002
- *
- */
-
-#ifndef __WCTL_H__
-#define __WCTL_H__
-
-#include "ttype.h"
-#include "tether.h"
-#include "device.h"
-
-/*---------------------  Export Definitions -------------------------*/
-
-#define IS_TYPE_DATA(pMACHeader)					\
-	((((PS802_11Header) pMACHeader)->wFrameCtl & TYPE_802_11_MASK) == TYPE_802_11_DATA)
-
-#define IS_TYPE_MGMT(pMACHeader)					\
-	((((PS802_11Header) pMACHeader)->wFrameCtl & TYPE_802_11_MASK) == TYPE_802_11_MGMT)
-
-#define IS_TYPE_CONTROL(pMACHeader)					\
-	((((PS802_11Header) pMACHeader)->wFrameCtl & TYPE_802_11_MASK) == TYPE_802_11_CTL)
-
-#define IS_FC_MOREDATA(pMACHeader)					\
-	((((PS802_11Header) pMACHeader)->wFrameCtl & FC_MOREDATA) == FC_MOREDATA)
-
-#define IS_FC_POWERMGT(pMACHeader)					\
-	((((PS802_11Header) pMACHeader)->wFrameCtl & FC_POWERMGT) == FC_POWERMGT)
-
-#define IS_FC_RETRY(pMACHeader)						\
-	((((PS802_11Header) pMACHeader)->wFrameCtl & FC_RETRY) == FC_RETRY)
-
-#define IS_FC_WEP(pMACHeader)						\
-	((((PS802_11Header) pMACHeader)->wFrameCtl & FC_WEP) == FC_WEP)
-
-#ifdef __BIG_ENDIAN
-
-#define IS_FRAGMENT_PKT(pMACHeader)					\
-	(((((PS802_11Header) pMACHeader)->wFrameCtl & FC_MOREFRAG) != 0) | \
-	 ((((PS802_11Header) pMACHeader)->wSeqCtl & 0x0F00) != 0))
-
-#define IS_FIRST_FRAGMENT_PKT(pMACHeader)				\
-	((((PS802_11Header) pMACHeader)->wSeqCtl & 0x0F00) == 0)
-
-#else
-
-#define IS_FRAGMENT_PKT(pMACHeader)					\
-	(((((PS802_11Header) pMACHeader)->wFrameCtl & FC_MOREFRAG) != 0) | \
-	 ((((PS802_11Header) pMACHeader)->wSeqCtl & 0x000F) != 0))
-
-#define IS_FIRST_FRAGMENT_PKT(pMACHeader)				\
-	((((PS802_11Header) pMACHeader)->wSeqCtl & 0x000F) == 0)
-
-#endif//#ifdef __BIG_ENDIAN
-
-#define IS_LAST_FRAGMENT_PKT(pMACHeader)				\
-	((((PS802_11Header) pMACHeader)->wFrameCtl & FC_MOREFRAG) == 0)
-
-#define IS_CTL_PSPOLL(pMACHeader)					\
-	((((PS802_11Header) pMACHeader)->wFrameCtl & TYPE_SUBTYPE_MASK) == TYPE_CTL_PSPOLL)
-
-#define ADD_ONE_WITH_WRAP_AROUND(uVar, uModulo)		\
-do {							\
-	if ((uVar) >= ((uModulo) - 1))			\
-		(uVar) = 0;				\
-	else						\
-		(uVar)++;				\
-} while (0)
-
-/*---------------------  Export Classes  ----------------------------*/
-
-/*---------------------  Export Variables  --------------------------*/
-
-/*---------------------  Export Functions  --------------------------*/
-
-bool WCTLbIsDuplicate(PSCache pCache, PS802_11Header pMACHeader);
-bool WCTLbHandleFragment(struct vnt_private *, PS802_11Header pMACHeader,
-			 unsigned int cbFrameLength, bool bWEP, bool bExtIV);
-unsigned int WCTLuSearchDFCB(struct vnt_private *, PS802_11Header pMACHeader);
-unsigned int WCTLuInsertDFCB(struct vnt_private *, PS802_11Header pMACHeader);
-
-#endif // __WCTL_H__
-- 
1.9.1

