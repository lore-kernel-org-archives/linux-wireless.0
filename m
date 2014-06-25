Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:51898 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932087AbaFYUV0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2014 16:21:26 -0400
Received: by mail-wi0-f170.google.com with SMTP id cc10so8327986wib.5
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jun 2014 13:21:25 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 13/34] staging: vt6656: dead code remove wctl
Date: Wed, 25 Jun 2014 21:19:50 +0100
Message-Id: <1403727611-6825-14-git-send-email-tvboxspy@gmail.com> (sfid-20140625_222953_108533_D19DA0B2)
In-Reply-To: <1403727611-6825-1-git-send-email-tvboxspy@gmail.com>
References: <1403727611-6825-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/Makefile   |   1 -
 drivers/staging/vt6656/dpc.c      |   1 -
 drivers/staging/vt6656/main_usb.c |   1 -
 drivers/staging/vt6656/rxtx.c     |   1 -
 drivers/staging/vt6656/wcmd.c     |   1 -
 drivers/staging/vt6656/wctl.c     | 244 --------------------------------------
 drivers/staging/vt6656/wctl.h     |  94 ---------------
 7 files changed, 343 deletions(-)
 delete mode 100644 drivers/staging/vt6656/wctl.c
 delete mode 100644 drivers/staging/vt6656/wctl.h

diff --git a/drivers/staging/vt6656/Makefile b/drivers/staging/vt6656/Makefile
index 1be7d60..08d313d 100644
--- a/drivers/staging/vt6656/Makefile
+++ b/drivers/staging/vt6656/Makefile
@@ -6,7 +6,6 @@ vt6656_stage-y +=	main_usb.o \
 			card.o  \
 			mac.o   \
 			baseband.o \
-			wctl.o  \
 			80211mgr.o \
 			wcmd.o\
 			rxtx.o \
diff --git a/drivers/staging/vt6656/dpc.c b/drivers/staging/vt6656/dpc.c
index 9570dc6..03242dd 100644
--- a/drivers/staging/vt6656/dpc.c
+++ b/drivers/staging/vt6656/dpc.c
@@ -45,7 +45,6 @@
 #include "baseband.h"
 #include "michael.h"
 #include "tkip.h"
-#include "wctl.h"
 #include "rf.h"
 #include "iowpa.h"
 #include "datarate.h"
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index f4cbeb3..b9915a2 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -53,7 +53,6 @@
 #include "mac.h"
 #include "tether.h"
 #include "wmgr.h"
-#include "wctl.h"
 #include "power.h"
 #include "wcmd.h"
 #include "rxtx.h"
diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index feffd97..e138900 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -51,7 +51,6 @@
 #include "mac.h"
 #include "michael.h"
 #include "tkip.h"
-#include "wctl.h"
 #include "rf.h"
 #include "datarate.h"
 #include "usbpipe.h"
diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index a777841..00bed8c 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -46,7 +46,6 @@
 #include "wcmd.h"
 #include "wmgr.h"
 #include "power.h"
-#include "wctl.h"
 #include "baseband.h"
 #include "usbpipe.h"
 #include "rxtx.h"
diff --git a/drivers/staging/vt6656/wctl.c b/drivers/staging/vt6656/wctl.c
deleted file mode 100644
index efdc5d5..0000000
--- a/drivers/staging/vt6656/wctl.c
+++ /dev/null
@@ -1,244 +0,0 @@
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
-#include "tmacro.h"
-
-// static int          msglevel                =MSG_LEVEL_INFO;
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
-bool WCTLbIsDuplicate (PSCache pCache, struct ieee80211_hdr *pMACHeader)
-{
-    unsigned int            uIndex;
-    unsigned int            ii;
-    PSCacheEntry    pCacheEntry;
-
-    if (IS_FC_RETRY(pMACHeader)) {
-
-        uIndex = pCache->uInPtr;
-        for (ii = 0; ii < DUPLICATE_RX_CACHE_LENGTH; ii++) {
-            pCacheEntry = &(pCache->asCacheEntry[uIndex]);
-            if ((pCacheEntry->wFmSequence == pMACHeader->seq_ctrl) &&
-		ether_addr_equal(pCacheEntry->abyAddr2, pMACHeader->addr2) &&
-		(pCacheEntry->wFrameCtl == pMACHeader->frame_control)
-                ) {
-                /* Duplicate match */
-                return true;
-            }
-            ADD_ONE_WITH_WRAP_AROUND(uIndex, DUPLICATE_RX_CACHE_LENGTH);
-        }
-    }
-    /* Not found in cache - insert */
-    pCacheEntry = &pCache->asCacheEntry[pCache->uInPtr];
-    pCacheEntry->wFmSequence = pMACHeader->seq_ctrl;
-    memcpy(&(pCacheEntry->abyAddr2[0]), &(pMACHeader->addr2[0]), ETH_ALEN);
-    pCacheEntry->wFrameCtl = pMACHeader->frame_control;
-    ADD_ONE_WITH_WRAP_AROUND(pCache->uInPtr, DUPLICATE_RX_CACHE_LENGTH);
-    return false;
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
-
-unsigned int WCTLuSearchDFCB(struct vnt_private *pDevice,
-			     struct ieee80211_hdr *pMACHeader)
-{
-	unsigned int ii;
-
-	for (ii = 0; ii < pDevice->cbDFCB; ii++) {
-		if ((pDevice->sRxDFCB[ii].bInUse == true) &&
-		    ether_addr_equal(pDevice->sRxDFCB[ii].abyAddr2,
-				     pMACHeader->addr2)) {
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
-unsigned int WCTLuInsertDFCB(struct vnt_private *pDevice,
-			     struct ieee80211_hdr *pMACHeader)
-{
-	unsigned int ii;
-
-    if (pDevice->cbFreeDFCB == 0)
-        return(pDevice->cbDFCB);
-    for (ii = 0; ii < pDevice->cbDFCB; ii++) {
-        if (pDevice->sRxDFCB[ii].bInUse == false) {
-            pDevice->cbFreeDFCB--;
-            pDevice->sRxDFCB[ii].uLifetime = pDevice->dwMaxReceiveLifetime;
-            pDevice->sRxDFCB[ii].bInUse = true;
-            pDevice->sRxDFCB[ii].wSequence = (pMACHeader->seq_ctrl >> 4);
-            pDevice->sRxDFCB[ii].wFragNum = (pMACHeader->seq_ctrl & 0x000F);
-	    memcpy(&(pDevice->sRxDFCB[ii].abyAddr2[0]),
-		   &(pMACHeader->addr2[0]),
-		   ETH_ALEN);
-            return(ii);
-        }
-    }
-    return(pDevice->cbDFCB);
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
-bool WCTLbHandleFragment(struct vnt_private *pDevice, struct ieee80211_hdr *pMACHeader,	unsigned int cbFrameLength, bool bWEP, bool bExtIV)
-{
-	unsigned int uHeaderSize;
-
-    if (bWEP == true) {
-        uHeaderSize = 28;
-        if (bExtIV)
-        // ExtIV
-            uHeaderSize +=4;
-    }
-    else {
-        uHeaderSize = 24;
-    }
-
-    if (IS_FIRST_FRAGMENT_PKT(pMACHeader)) {
-        pDevice->uCurrentDFCBIdx = WCTLuSearchDFCB(pDevice, pMACHeader);
-        if (pDevice->uCurrentDFCBIdx < pDevice->cbDFCB) {
-            // duplicate, we must flush previous DCB
-            pDevice->sRxDFCB[pDevice->uCurrentDFCBIdx].uLifetime = pDevice->dwMaxReceiveLifetime;
-            pDevice->sRxDFCB[pDevice->uCurrentDFCBIdx].wSequence = (pMACHeader->seq_ctrl >> 4);
-            pDevice->sRxDFCB[pDevice->uCurrentDFCBIdx].wFragNum = (pMACHeader->seq_ctrl & 0x000F);
-        }
-        else {
-            pDevice->uCurrentDFCBIdx = WCTLuInsertDFCB(pDevice, pMACHeader);
-            if (pDevice->uCurrentDFCBIdx == pDevice->cbDFCB) {
-                return(false);
-            }
-        }
-        // reserve 8 byte to match MAC RX Buffer
-        pDevice->sRxDFCB[pDevice->uCurrentDFCBIdx].pbyRxBuffer = (u8 *) (pDevice->sRxDFCB[pDevice->uCurrentDFCBIdx].skb->data + 8);
-//        pDevice->sRxDFCB[pDevice->uCurrentDFCBIdx].pbyRxBuffer = (u8 *) (pDevice->sRxDFCB[pDevice->uCurrentDFCBIdx].skb->data + 4);
-        memcpy(pDevice->sRxDFCB[pDevice->uCurrentDFCBIdx].pbyRxBuffer, pMACHeader, cbFrameLength);
-        pDevice->sRxDFCB[pDevice->uCurrentDFCBIdx].cbFrameLength = cbFrameLength;
-        pDevice->sRxDFCB[pDevice->uCurrentDFCBIdx].pbyRxBuffer += cbFrameLength;
-        pDevice->sRxDFCB[pDevice->uCurrentDFCBIdx].wFragNum++;
-        //DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "First pDevice->uCurrentDFCBIdx= %d\n", pDevice->uCurrentDFCBIdx);
-        return(false);
-    }
-    else {
-        pDevice->uCurrentDFCBIdx = WCTLuSearchDFCB(pDevice, pMACHeader);
-        if (pDevice->uCurrentDFCBIdx != pDevice->cbDFCB) {
-            if ((pDevice->sRxDFCB[pDevice->uCurrentDFCBIdx].wSequence == (pMACHeader->seq_ctrl >> 4)) &&
-                (pDevice->sRxDFCB[pDevice->uCurrentDFCBIdx].wFragNum == (pMACHeader->seq_ctrl & 0x000F)) &&
-                ((pDevice->sRxDFCB[pDevice->uCurrentDFCBIdx].cbFrameLength + cbFrameLength - uHeaderSize) < 2346)) {
-
-                memcpy(pDevice->sRxDFCB[pDevice->uCurrentDFCBIdx].pbyRxBuffer, ((u8 *) (pMACHeader) + uHeaderSize), (cbFrameLength - uHeaderSize));
-                pDevice->sRxDFCB[pDevice->uCurrentDFCBIdx].cbFrameLength += (cbFrameLength - uHeaderSize);
-                pDevice->sRxDFCB[pDevice->uCurrentDFCBIdx].pbyRxBuffer += (cbFrameLength - uHeaderSize);
-                pDevice->sRxDFCB[pDevice->uCurrentDFCBIdx].wFragNum++;
-                //DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Second pDevice->uCurrentDFCBIdx= %d\n", pDevice->uCurrentDFCBIdx);
-            }
-            else {
-                // seq error or frag # error flush DFCB
-                pDevice->cbFreeDFCB++;
-                pDevice->sRxDFCB[pDevice->uCurrentDFCBIdx].bInUse = false;
-                return(false);
-            }
-        }
-        else {
-            return(false);
-        }
-        if (IS_LAST_FRAGMENT_PKT(pMACHeader)) {
-            //enq defragcontrolblock
-            pDevice->cbFreeDFCB++;
-            pDevice->sRxDFCB[pDevice->uCurrentDFCBIdx].bInUse = false;
-            //DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Last pDevice->uCurrentDFCBIdx= %d\n", pDevice->uCurrentDFCBIdx);
-            return(true);
-        }
-        return(false);
-    }
-}
-
diff --git a/drivers/staging/vt6656/wctl.h b/drivers/staging/vt6656/wctl.h
deleted file mode 100644
index 14cb411..0000000
--- a/drivers/staging/vt6656/wctl.h
+++ /dev/null
@@ -1,94 +0,0 @@
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
-#include "tether.h"
-#include "device.h"
-
-#define IS_TYPE_DATA(pMACHeader)                                                        \
-    ((((struct ieee80211_hdr *) pMACHeader)->frame_control & TYPE_802_11_MASK) == TYPE_802_11_DATA)
-
-#define IS_TYPE_MGMT(pMACHeader)                                                        \
-    ((((struct ieee80211_hdr *) pMACHeader)->frame_control & TYPE_802_11_MASK) == TYPE_802_11_MGMT)
-
-#define IS_TYPE_CONTROL(pMACHeader)                                                     \
-    ((((struct ieee80211_hdr *) pMACHeader)->frame_control & TYPE_802_11_MASK) == TYPE_802_11_CTL)
-
-#define IS_FC_MOREDATA(pMACHeader)                                                      \
-    ((((struct ieee80211_hdr *) pMACHeader)->frame_control & FC_MOREDATA) == FC_MOREDATA)
-
-#define IS_FC_POWERMGT(pMACHeader)                                                      \
-    ((((struct ieee80211_hdr *) pMACHeader)->frame_control & FC_POWERMGT) == FC_POWERMGT)
-
-#define IS_FC_RETRY(pMACHeader)                                                         \
-    ((((struct ieee80211_hdr *) pMACHeader)->frame_control & FC_RETRY) == FC_RETRY)
-
-#define IS_FC_WEP(pMACHeader)                                                           \
-    ((((struct ieee80211_hdr *) pMACHeader)->frame_control & FC_WEP) == FC_WEP)
-
-#ifdef __BIG_ENDIAN
-
-#define IS_FRAGMENT_PKT(pMACHeader)                                                     \
-    (((((struct ieee80211_hdr *) pMACHeader)->frame_control & FC_MOREFRAG) != 0) |                  \
-     ((((struct ieee80211_hdr *) pMACHeader)->seq_ctrl & 0x0F00) != 0))
-
-#define IS_FIRST_FRAGMENT_PKT(pMACHeader)                                               \
-    ((((struct ieee80211_hdr *) pMACHeader)->seq_ctrl & 0x0F00) == 0)
-
-#else
-
-#define IS_FRAGMENT_PKT(pMACHeader)                                                     \
-    (((((struct ieee80211_hdr *) pMACHeader)->frame_control & FC_MOREFRAG) != 0) |                  \
-     ((((struct ieee80211_hdr *) pMACHeader)->seq_ctrl & 0x000F) != 0))
-
-#define IS_FIRST_FRAGMENT_PKT(pMACHeader)                                               \
-    ((((struct ieee80211_hdr *) pMACHeader)->seq_ctrl & 0x000F) == 0)
-
-#endif//#ifdef __BIG_ENDIAN
-
-#define IS_LAST_FRAGMENT_PKT(pMACHeader)                                                \
-    ((((struct ieee80211_hdr *) pMACHeader)->frame_control & FC_MOREFRAG) == 0)
-
-#define IS_CTL_PSPOLL(pMACHeader)                                                       \
-    ((((struct ieee80211_hdr *) pMACHeader)->frame_control & TYPE_SUBTYPE_MASK) == TYPE_CTL_PSPOLL)
-
-#define ADD_ONE_WITH_WRAP_AROUND(uVar, uModulo) {   \
-    if ((uVar) >= ((uModulo) - 1))                  \
-        (uVar) = 0;                                 \
-    else                                            \
-        (uVar)++;                                   \
-}
-
-bool WCTLbIsDuplicate(PSCache pCache, struct ieee80211_hdr *pMACHeader);
-bool WCTLbHandleFragment(struct vnt_private *, struct ieee80211_hdr *pMACHeader, unsigned int cbFrameLength, bool bWEP, bool bExtIV);
-unsigned int WCTLuSearchDFCB(struct vnt_private *, struct ieee80211_hdr *pMACHeader);
-unsigned int WCTLuInsertDFCB(struct vnt_private *, struct ieee80211_hdr *pMACHeader);
-
-#endif /* __WCTL_H__ */
-- 
1.9.1

