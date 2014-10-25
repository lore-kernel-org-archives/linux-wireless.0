Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:50543 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765AbaJYTen (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Oct 2014 15:34:43 -0400
Received: by mail-wg0-f45.google.com with SMTP id l18so3170399wgh.16
        for <linux-wireless@vger.kernel.org>; Sat, 25 Oct 2014 12:34:42 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 16/48] staging: vt6655: dead code remove IEEE11.h.c/h
Date: Sat, 25 Oct 2014 09:39:54 +0100
Message-Id: <1414226426-5811-17-git-send-email-tvboxspy@gmail.com> (sfid-20141025_213446_473525_77D57636)
In-Reply-To: <1414226426-5811-1-git-send-email-tvboxspy@gmail.com>
References: <1414226426-5811-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/IEEE11h.c | 139 ---------------------------------------
 drivers/staging/vt6655/IEEE11h.h |  42 ------------
 drivers/staging/vt6655/Makefile  |   3 +-
 drivers/staging/vt6655/vntwifi.c |   3 -
 4 files changed, 1 insertion(+), 186 deletions(-)
 delete mode 100644 drivers/staging/vt6655/IEEE11h.c
 delete mode 100644 drivers/staging/vt6655/IEEE11h.h

diff --git a/drivers/staging/vt6655/IEEE11h.c b/drivers/staging/vt6655/IEEE11h.c
deleted file mode 100644
index 65eb482..0000000
--- a/drivers/staging/vt6655/IEEE11h.c
+++ /dev/null
@@ -1,139 +0,0 @@
-/*
- * Copyright (c) 1996, 2005 VIA Networking Technologies, Inc.
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
- * File: IEEE11h.c
- *
- * Purpose:
- *
- * Functions:
- *
- * Revision History:
- *
- * Author: Yiching Chen
- *
- * Date: Mar. 31, 2005
- *
- */
-
-#include "ttype.h"
-#include "tmacro.h"
-#include "tether.h"
-#include "IEEE11h.h"
-#include "device.h"
-#include "wmgr.h"
-#include "rxtx.h"
-#include "channel.h"
-
-/*---------------------  Static Definitions -------------------------*/
-
-#pragma pack(1)
-
-typedef struct _WLAN_FRAME_ACTION {
-	WLAN_80211HDR_A3    Header;
-	unsigned char byCategory;
-	unsigned char byAction;
-	unsigned char abyVars[1];
-} WLAN_FRAME_ACTION, *PWLAN_FRAME_ACTION;
-
-typedef struct _WLAN_FRAME_MSRREQ {
-	WLAN_80211HDR_A3    Header;
-	unsigned char byCategory;
-	unsigned char byAction;
-	unsigned char byDialogToken;
-	WLAN_IE_MEASURE_REQ sMSRReqEIDs[1];
-} WLAN_FRAME_MSRREQ, *PWLAN_FRAME_MSRREQ;
-
-typedef struct _WLAN_FRAME_MSRREP {
-	WLAN_80211HDR_A3    Header;
-	unsigned char byCategory;
-	unsigned char byAction;
-	unsigned char byDialogToken;
-	WLAN_IE_MEASURE_REP sMSRRepEIDs[1];
-} WLAN_FRAME_MSRREP, *PWLAN_FRAME_MSRREP;
-
-typedef struct _WLAN_FRAME_TPCREQ {
-	WLAN_80211HDR_A3    Header;
-	unsigned char byCategory;
-	unsigned char byAction;
-	unsigned char byDialogToken;
-	WLAN_IE_TPC_REQ     sTPCReqEIDs;
-} WLAN_FRAME_TPCREQ, *PWLAN_FRAME_TPCREQ;
-
-typedef struct _WLAN_FRAME_TPCREP {
-	WLAN_80211HDR_A3    Header;
-	unsigned char byCategory;
-	unsigned char byAction;
-	unsigned char byDialogToken;
-	WLAN_IE_TPC_REP     sTPCRepEIDs;
-} WLAN_FRAME_TPCREP, *PWLAN_FRAME_TPCREP;
-
-#pragma pack()
-
-/* action field reference ieee 802.11h Table 20e */
-#define ACTION_MSRREQ       0
-#define ACTION_MSRREP       1
-#define ACTION_TPCREQ       2
-#define ACTION_TPCREP       3
-#define ACTION_CHSW         4
-
-/*---------------------  Static Classes  ----------------------------*/
-
-/*---------------------  Static Variables  --------------------------*/
-
-/*---------------------  Static Functions  --------------------------*/
-
-/*---------------------  Export Variables  --------------------------*/
-
-/*---------------------  Export Functions  --------------------------*/
-
-bool IEEE11hbMSRRepTx(void *pMgmtHandle)
-{
-	PSMgmtObject            pMgmt = (PSMgmtObject) pMgmtHandle;
-	PWLAN_FRAME_MSRREP      pMSRRep = (PWLAN_FRAME_MSRREP)
-		(pMgmt->abyCurrentMSRRep + sizeof(STxMgmtPacket));
-	size_t                    uLength = 0;
-	PSTxMgmtPacket          pTxPacket = NULL;
-
-	pTxPacket = (PSTxMgmtPacket)pMgmt->abyCurrentMSRRep;
-	memset(pTxPacket, 0, sizeof(STxMgmtPacket) + WLAN_A3FR_MAXLEN);
-	pTxPacket->p80211Header = (PUWLAN_80211HDR)((unsigned char *)pTxPacket +
-						    sizeof(STxMgmtPacket));
-
-	pMSRRep->Header.wFrameCtl = (WLAN_SET_FC_FTYPE(WLAN_FTYPE_MGMT) |
-				     WLAN_SET_FC_FSTYPE(WLAN_FSTYPE_ACTION)
-);
-
-	memcpy(pMSRRep->Header.abyAddr1, ((PWLAN_FRAME_MSRREQ)
-					  (pMgmt->abyCurrentMSRReq))->Header.abyAddr2, WLAN_ADDR_LEN);
-	memcpy(pMSRRep->Header.abyAddr2,
-	       CARDpGetCurrentAddress(pMgmt->pAdapter), WLAN_ADDR_LEN);
-	memcpy(pMSRRep->Header.abyAddr3, pMgmt->abyCurrBSSID, WLAN_BSSID_LEN);
-
-	pMSRRep->byCategory = 0;
-	pMSRRep->byAction = 1;
-	pMSRRep->byDialogToken = ((PWLAN_FRAME_MSRREQ)
-				  (pMgmt->abyCurrentMSRReq))->byDialogToken;
-
-	uLength = pMgmt->uLengthOfRepEIDs + offsetof(WLAN_FRAME_MSRREP,
-						     sMSRRepEIDs);
-
-	pTxPacket->cbMPDULen = uLength;
-	pTxPacket->cbPayloadLen = uLength - WLAN_HDR_ADDR3_LEN;
-	return true;
-}
diff --git a/drivers/staging/vt6655/IEEE11h.h b/drivers/staging/vt6655/IEEE11h.h
deleted file mode 100644
index 5519220..0000000
--- a/drivers/staging/vt6655/IEEE11h.h
+++ /dev/null
@@ -1,42 +0,0 @@
-/*
- * Copyright (c) 1996, 2005 VIA Networking Technologies, Inc.
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
- * File: IEEE11h.h
- *
- * Purpose: Defines the macros, types, and functions for dealing
- *          with IEEE 802.11h.
- *
- * Author: Yiching Chen
- *
- * Date: Mar. 31, 2005
- *
- */
-
-#ifndef __IEEE11h_H__
-#define __IEEE11h_H__
-
-#include "ttype.h"
-#include "80211hdr.h"
-#include "80211mgr.h"
-
-bool IEEE11hbMSRRepTx(
-	void *pMgmtHandle
-);
-
-#endif // __IEEE11h_H__
diff --git a/drivers/staging/vt6655/Makefile b/drivers/staging/vt6655/Makefile
index 3c993a8..141c0c1 100644
--- a/drivers/staging/vt6655/Makefile
+++ b/drivers/staging/vt6655/Makefile
@@ -25,7 +25,6 @@ vt6655_stage-y +=	device_main.o \
 	rf.o \
 	wpa2.o \
 	aes_ccmp.o \
-	vntwifi.o \
-	IEEE11h.o
+	vntwifi.o
 
 obj-$(CONFIG_VT6655) +=	vt6655_stage.o
diff --git a/drivers/staging/vt6655/vntwifi.c b/drivers/staging/vt6655/vntwifi.c
index 27e055e..a5eccf7 100644
--- a/drivers/staging/vt6655/vntwifi.c
+++ b/drivers/staging/vt6655/vntwifi.c
@@ -32,7 +32,6 @@
  */
 
 #include "vntwifi.h"
-#include "IEEE11h.h"
 #include "country.h"
 #include "device.h"
 #include "wmgr.h"
@@ -648,8 +647,6 @@ VNTWIFIbMeasureReport(
 		pMgmt->uLengthOfRepEIDs += (2 + pMgmt->pCurrMeasureEIDRep->len);
 		pMgmt->pCurrMeasureEIDRep = (PWLAN_IE_MEASURE_REP) pbyCurrentEID;
 	}
-	if (bEndOfReport)
-		IEEE11hbMSRRepTx(pMgmt);
 
 	return true;
 }
-- 
1.9.1

