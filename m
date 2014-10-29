Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:56836 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756904AbaJ2R5g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 13:57:36 -0400
Received: by mail-wi0-f174.google.com with SMTP id d1so2428275wiv.1
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2014 10:57:34 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH v2 19/48] staging: vt6655: dead code remove wpa/wpa2
Date: Wed, 29 Oct 2014 17:55:37 +0000
Message-Id: <1414605366-9335-20-git-send-email-tvboxspy@gmail.com> (sfid-20141029_185748_118998_31138D2B)
In-Reply-To: <1414605366-9335-1-git-send-email-tvboxspy@gmail.com>
References: <1414605366-9335-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/80211mgr.c |  13 --
 drivers/staging/vt6655/Makefile   |   2 -
 drivers/staging/vt6655/vntwifi.c  |   7 -
 drivers/staging/vt6655/vntwifi.h  |   1 -
 drivers/staging/vt6655/wmgr.h     |   2 -
 drivers/staging/vt6655/wpa.c      | 300 -------------------------------
 drivers/staging/vt6655/wpa.h      |  83 ---------
 drivers/staging/vt6655/wpa2.c     | 359 --------------------------------------
 drivers/staging/vt6655/wpa2.h     |  77 --------
 9 files changed, 844 deletions(-)
 delete mode 100644 drivers/staging/vt6655/wpa.c
 delete mode 100644 drivers/staging/vt6655/wpa.h
 delete mode 100644 drivers/staging/vt6655/wpa2.c
 delete mode 100644 drivers/staging/vt6655/wpa2.h

diff --git a/drivers/staging/vt6655/80211mgr.c b/drivers/staging/vt6655/80211mgr.c
index 7d2c647..22ded38 100644
--- a/drivers/staging/vt6655/80211mgr.c
+++ b/drivers/staging/vt6655/80211mgr.c
@@ -57,7 +57,6 @@
 #include "80211mgr.h"
 #include "80211hdr.h"
 #include "device.h"
-#include "wpa.h"
 
 /*---------------------  Static Definitions -------------------------*/
 
@@ -171,9 +170,6 @@ vMgrDecodeBeacon(
 			break;
 		case WLAN_EID_RSN_WPA:
 			if (pFrame->pRSNWPA == NULL) {
-				if (WPAb_Is_RSN((PWLAN_IE_RSN_EXT)pItem) == true)
-					pFrame->pRSNWPA =
-						       (PWLAN_IE_RSN_EXT)pItem;
 			}
 			break;
 
@@ -389,9 +385,6 @@ vMgrDecodeAssocRequest(
 			break;
 		case WLAN_EID_RSN_WPA:
 			if (pFrame->pRSNWPA == NULL) {
-				if (WPAb_Is_RSN((PWLAN_IE_RSN_EXT)pItem) == true)
-					pFrame->pRSNWPA =
-						       (PWLAN_IE_RSN_EXT)pItem;
 			}
 			break;
 		case WLAN_EID_EXTSUPP_RATES:
@@ -574,9 +567,6 @@ vMgrDecodeReassocRequest(
 			break;
 		case WLAN_EID_RSN_WPA:
 			if (pFrame->pRSNWPA == NULL) {
-				if (WPAb_Is_RSN((PWLAN_IE_RSN_EXT)pItem) == true)
-					pFrame->pRSNWPA =
-						       (PWLAN_IE_RSN_EXT)pItem;
 			}
 			break;
 
@@ -767,9 +757,6 @@ vMgrDecodeProbeResponse(
 			break;
 		case WLAN_EID_RSN_WPA:
 			if (pFrame->pRSNWPA == NULL) {
-				if (WPAb_Is_RSN((PWLAN_IE_RSN_EXT)pItem) == true)
-					pFrame->pRSNWPA =
-						       (PWLAN_IE_RSN_EXT)pItem;
 			}
 			break;
 		case WLAN_EID_ERP:
diff --git a/drivers/staging/vt6655/Makefile b/drivers/staging/vt6655/Makefile
index e5ea1ea..7286e32 100644
--- a/drivers/staging/vt6655/Makefile
+++ b/drivers/staging/vt6655/Makefile
@@ -17,12 +17,10 @@ vt6655_stage-y +=	device_main.o \
 	rc4.o \
 	tether.o \
 	tcrc.o \
-	wpa.o \
 	key.o \
 	tkip.o \
 	michael.o \
 	rf.o \
-	wpa2.o \
 	aes_ccmp.o \
 	vntwifi.o
 
diff --git a/drivers/staging/vt6655/vntwifi.c b/drivers/staging/vt6655/vntwifi.c
index a5eccf7..54c65fc 100644
--- a/drivers/staging/vt6655/vntwifi.c
+++ b/drivers/staging/vt6655/vntwifi.c
@@ -557,13 +557,6 @@ VNTWIFIbSetPMKIDCache(
 	void *pPMKIDInfo
 )
 {
-	PSMgmtObject    pMgmt = (PSMgmtObject) pMgmtObject;
-
-	if (ulCount > MAX_PMKID_CACHE)
-		return false;
-
-	pMgmt->gsPMKIDCache.BSSIDInfoCount = ulCount;
-	memcpy(pMgmt->gsPMKIDCache.BSSIDInfo, pPMKIDInfo, (ulCount*sizeof(PMKIDInfo)));
 	return true;
 }
 
diff --git a/drivers/staging/vt6655/vntwifi.h b/drivers/staging/vt6655/vntwifi.h
index 880b8ab..9db734f 100644
--- a/drivers/staging/vt6655/vntwifi.h
+++ b/drivers/staging/vt6655/vntwifi.h
@@ -33,7 +33,6 @@
 #include "ttype.h"
 #include "80211mgr.h"
 #include "card.h"
-#include "wpa2.h"
 
 /*---------------------  Export Definitions -------------------------*/
 #define RATE_1M         0
diff --git a/drivers/staging/vt6655/wmgr.h b/drivers/staging/vt6655/wmgr.h
index 4b7196b..7df62bb 100644
--- a/drivers/staging/vt6655/wmgr.h
+++ b/drivers/staging/vt6655/wmgr.h
@@ -39,7 +39,6 @@
 #include "80211hdr.h"
 #include "wcmd.h"
 #include "bssdb.h"
-#include "wpa2.h"
 #include "vntwifi.h"
 #include "card.h"
 
@@ -291,7 +290,6 @@ typedef struct tagSMgmtObject {
 	KnownNodeDB             sNodeDBTable[MAX_NODE_NUM + 1];
 
 	// WPA2 PMKID Cache
-	SPMKIDCache             gsPMKIDCache;
 	bool bRoaming;
 
 	// rate fall back vars
diff --git a/drivers/staging/vt6655/wpa.c b/drivers/staging/vt6655/wpa.c
deleted file mode 100644
index 5d4eca8..0000000
--- a/drivers/staging/vt6655/wpa.c
+++ /dev/null
@@ -1,300 +0,0 @@
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
- * File: wpa.c
- *
- * Purpose: Handles the Basic Service Set & Node Database functions
- *
- * Functions:
- *      WPA_ParseRSN - Parse RSN IE.
- *
- * Revision History:
- *
- * Author: Kyle Hsu
- *
- * Date: July 14, 2003
- *
- */
-
-#include "ttype.h"
-#include "tmacro.h"
-#include "tether.h"
-#include "device.h"
-#include "80211hdr.h"
-#include "bssdb.h"
-#include "wmgr.h"
-#include "wpa.h"
-#include "80211mgr.h"
-
-/*---------------------  Static Variables  --------------------------*/
-static const unsigned char abyOUI00[4] = { 0x00, 0x50, 0xf2, 0x00 };
-static const unsigned char abyOUI01[4] = { 0x00, 0x50, 0xf2, 0x01 };
-static const unsigned char abyOUI02[4] = { 0x00, 0x50, 0xf2, 0x02 };
-static const unsigned char abyOUI03[4] = { 0x00, 0x50, 0xf2, 0x03 };
-static const unsigned char abyOUI04[4] = { 0x00, 0x50, 0xf2, 0x04 };
-static const unsigned char abyOUI05[4] = { 0x00, 0x50, 0xf2, 0x05 };
-
-/*+
- *
- * Description:
- *    Clear RSN information in BSSList.
- *
- * Parameters:
- *  In:
- *      pBSSList - BSS list.
- *  Out:
- *      none
- *
- * Return Value: none.
- *
- -*/
-
-void
-WPA_ClearRSN(
-	PKnownBSS        pBSSList
-)
-{
-	int ii;
-
-	pBSSList->byGKType = WPA_TKIP;
-	for (ii = 0; ii < 4; ii++)
-		pBSSList->abyPKType[ii] = WPA_TKIP;
-	pBSSList->wPKCount = 0;
-	for (ii = 0; ii < 4; ii++)
-		pBSSList->abyAuthType[ii] = WPA_AUTH_IEEE802_1X;
-	pBSSList->wAuthCount = 0;
-	pBSSList->byDefaultK_as_PK = 0;
-	pBSSList->byReplayIdx = 0;
-	pBSSList->sRSNCapObj.bRSNCapExist = false;
-	pBSSList->sRSNCapObj.wRSNCap = 0;
-	pBSSList->bWPAValid = false;
-}
-
-/*+
- *
- * Description:
- *    Parse RSN IE.
- *
- * Parameters:
- *  In:
- *      pBSSList - BSS list.
- *      pRSN - Pointer to the RSN IE.
- *  Out:
- *      none
- *
- * Return Value: none.
- *
- -*/
-void
-WPA_ParseRSN(
-	PKnownBSS        pBSSList,
-	PWLAN_IE_RSN_EXT pRSN
-)
-{
-	PWLAN_IE_RSN_AUTH  pIE_RSN_Auth = NULL;
-	int                i, j, m, n = 0;
-	unsigned char *pbyCaps;
-
-	WPA_ClearRSN(pBSSList);
-
-	pr_debug("WPA_ParseRSN: [%d]\n", pRSN->len);
-
-	// information element header makes sense
-	if ((pRSN->len >= 6) // oui1(4)+ver(2)
-	    && (pRSN->byElementID == WLAN_EID_RSN_WPA) && !memcmp(pRSN->abyOUI, abyOUI01, 4)
-	    && (pRSN->wVersion == 1)) {
-		pr_debug("Legal RSN\n");
-		// update each variable if pRSN is long enough to contain the variable
-		if (pRSN->len >= 10) {
-			//OUI1(4)+ver(2)+GKSuite(4)
-			if (!memcmp(pRSN->abyMulticast, abyOUI01, 4))
-				pBSSList->byGKType = WPA_WEP40;
-			else if (!memcmp(pRSN->abyMulticast, abyOUI02, 4))
-				pBSSList->byGKType = WPA_TKIP;
-			else if (!memcmp(pRSN->abyMulticast, abyOUI03, 4))
-				pBSSList->byGKType = WPA_AESWRAP;
-			else if (!memcmp(pRSN->abyMulticast, abyOUI04, 4))
-				pBSSList->byGKType = WPA_AESCCMP;
-			else if (!memcmp(pRSN->abyMulticast, abyOUI05, 4))
-				pBSSList->byGKType = WPA_WEP104;
-			else
-				// any vendor checks here
-				pBSSList->byGKType = WPA_NONE;
-
-			pr_debug("byGKType: %x\n", pBSSList->byGKType);
-		}
-
-		if (pRSN->len >= 12) {
-			//oui1(4)+ver(2)+GKS(4)+PKSCnt(2)
-			j = 0;
-			pr_debug("wPKCount: %d, sizeof(pBSSList->abyPKType): %zu\n",
-				 pRSN->wPKCount, sizeof(pBSSList->abyPKType));
-			for (i = 0; (i < pRSN->wPKCount) && (j < ARRAY_SIZE(pBSSList->abyPKType)); i++) {
-				if (pRSN->len >= 12+i*4+4) { //oui1(4)+ver(2)+GKS(4)+PKSCnt(2)+PKS(4*i)
-					if (!memcmp(pRSN->PKSList[i].abyOUI, abyOUI00, 4))
-						pBSSList->abyPKType[j++] = WPA_NONE;
-					else if (!memcmp(pRSN->PKSList[i].abyOUI, abyOUI02, 4))
-						pBSSList->abyPKType[j++] = WPA_TKIP;
-					else if (!memcmp(pRSN->PKSList[i].abyOUI, abyOUI03, 4))
-						pBSSList->abyPKType[j++] = WPA_AESWRAP;
-					else if (!memcmp(pRSN->PKSList[i].abyOUI, abyOUI04, 4))
-						pBSSList->abyPKType[j++] = WPA_AESCCMP;
-					else
-						// any vendor checks here
-						;
-				} else
-					break;
-			}
-			pBSSList->wPKCount = (unsigned short)j;
-			pr_debug("wPKCount: %d\n", pBSSList->wPKCount);
-		}
-
-		m = pRSN->wPKCount;
-		pr_debug("m: %d\n", m);
-		pr_debug("14+m*4: %d\n", 14+m*4);
-
-		if (pRSN->len >= 14+m*4) { //oui1(4)+ver(2)+GKS(4)+PKSCnt(2)+PKS(4*m)+AKC(2)
-			// overlay IE_RSN_Auth structure into correct place
-			pIE_RSN_Auth = (PWLAN_IE_RSN_AUTH) pRSN->PKSList[m].abyOUI;
-			j = 0;
-			pr_debug("wAuthCount: %d, sizeof(pBSSList->abyAuthType): %zu\n",
-				 pIE_RSN_Auth->wAuthCount,
-				 sizeof(pBSSList->abyAuthType));
-			for (i = 0; (i < pIE_RSN_Auth->wAuthCount) && (j < ARRAY_SIZE(pBSSList->abyAuthType)); i++) {
-				if (pRSN->len >= 14+4+(m+i)*4) { //oui1(4)+ver(2)+GKS(4)+PKSCnt(2)+PKS(4*m)+AKC(2)+AKS(4*i)
-					if (!memcmp(pIE_RSN_Auth->AuthKSList[i].abyOUI, abyOUI01, 4))
-						pBSSList->abyAuthType[j++] = WPA_AUTH_IEEE802_1X;
-					else if (!memcmp(pIE_RSN_Auth->AuthKSList[i].abyOUI, abyOUI02, 4))
-						pBSSList->abyAuthType[j++] = WPA_AUTH_PSK;
-					else
-						// any vendor checks here
-						;
-				} else
-					break;
-
-			}
-			if (j > 0)
-				pBSSList->wAuthCount = (unsigned short)j;
-			pr_debug("wAuthCount: %d\n", pBSSList->wAuthCount);
-		}
-
-		if (pIE_RSN_Auth != NULL) {
-			n = pIE_RSN_Auth->wAuthCount;
-
-			pr_debug("n: %d\n", n);
-			pr_debug("14+4+(m+n)*4: %d\n", 14+4+(m+n)*4);
-
-			if (pRSN->len+2 >= 14+4+(m+n)*4) { //oui1(4)+ver(2)+GKS(4)+PKSCnt(2)+PKS(4*m)+AKC(2)+AKS(4*n)+Cap(2)
-				pbyCaps = (unsigned char *)pIE_RSN_Auth->AuthKSList[n].abyOUI;
-				pBSSList->byDefaultK_as_PK = (*pbyCaps) & WPA_GROUPFLAG;
-				pBSSList->byReplayIdx = 2 << ((*pbyCaps >> WPA_REPLAYBITSSHIFT) & WPA_REPLAYBITS);
-				pBSSList->sRSNCapObj.bRSNCapExist = true;
-				pBSSList->sRSNCapObj.wRSNCap = *(unsigned short *)pbyCaps;
-			}
-		}
-		pBSSList->bWPAValid = true;
-	}
-}
-
-/*+
- *
- * Description:
- *    Search RSN information in BSSList.
- *
- * Parameters:
- *  In:
- *      byCmd    - Search type
- *      byEncrypt- Encrypt Type
- *      pBSSList - BSS list
- *  Out:
- *      none
- *
- * Return Value: none.
- *
- -*/
-bool
-WPA_SearchRSN(
-	unsigned char byCmd,
-	unsigned char byEncrypt,
-	PKnownBSS        pBSSList
-)
-{
-	int ii;
-	unsigned char byPKType = WPA_NONE;
-
-	if (!pBSSList->bWPAValid)
-		return false;
-
-	switch (byCmd) {
-	case 0:
-
-		if (byEncrypt != pBSSList->byGKType)
-			return false;
-
-		if (pBSSList->wPKCount > 0) {
-			for (ii = 0; ii < pBSSList->wPKCount; ii++) {
-				if (pBSSList->abyPKType[ii] == WPA_AESCCMP)
-					byPKType = WPA_AESCCMP;
-				else if ((pBSSList->abyPKType[ii] == WPA_TKIP) && (byPKType != WPA_AESCCMP))
-					byPKType = WPA_TKIP;
-				else if ((pBSSList->abyPKType[ii] == WPA_WEP40) && (byPKType != WPA_AESCCMP) && (byPKType != WPA_TKIP))
-					byPKType = WPA_WEP40;
-				else if ((pBSSList->abyPKType[ii] == WPA_WEP104) && (byPKType != WPA_AESCCMP) && (byPKType != WPA_TKIP))
-					byPKType = WPA_WEP104;
-			}
-			if (byEncrypt != byPKType)
-				return false;
-		}
-		return true;
-
-	default:
-		break;
-	}
-	return false;
-}
-
-/*+
- *
- * Description:
- *    Check if RSN IE makes sense.
- *
- * Parameters:
- *  In:
- *      pRSN - Pointer to the RSN IE.
- *  Out:
- *      none
- *
- * Return Value: none.
- *
- -*/
-bool
-WPAb_Is_RSN(
-	PWLAN_IE_RSN_EXT pRSN
-)
-{
-	if (pRSN == NULL)
-		return false;
-
-	if ((pRSN->len >= 6) && // oui1(4)+ver(2)
-	    (pRSN->byElementID == WLAN_EID_RSN_WPA) &&  !memcmp(pRSN->abyOUI, abyOUI01, 4) &&
-	    (pRSN->wVersion == 1)) {
-		return true;
-	} else
-		return false;
-}
diff --git a/drivers/staging/vt6655/wpa.h b/drivers/staging/vt6655/wpa.h
deleted file mode 100644
index d012cb9..0000000
--- a/drivers/staging/vt6655/wpa.h
+++ /dev/null
@@ -1,83 +0,0 @@
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
- * File: wpa.h
- *
- * Purpose: Defines the macros, types, and functions for dealing
- *          with WPA informations.
- *
- * Author: Kyle Hsu
- *
- * Date: Jul 14, 2003
- *
- */
-
-#ifndef __WPA_H__
-#define __WPA_H__
-
-#include "ttype.h"
-#include "80211hdr.h"
-
-/*---------------------  Export Definitions -------------------------*/
-
-#define WPA_NONE            0
-#define WPA_WEP40           1
-#define WPA_TKIP            2
-#define WPA_AESWRAP         3
-#define WPA_AESCCMP         4
-#define WPA_WEP104          5
-#define WPA_AUTH_IEEE802_1X 1
-#define WPA_AUTH_PSK        2
-
-#define WPA_GROUPFLAG       0x02
-#define WPA_REPLAYBITSSHIFT 2
-#define WPA_REPLAYBITS      0x03
-
-/*---------------------  Export Classes  ----------------------------*/
-
-/*---------------------  Export Variables  --------------------------*/
-
-/*---------------------  Export Types  ------------------------------*/
-
-/*---------------------  Export Functions  --------------------------*/
-
-void
-WPA_ClearRSN(
-	PKnownBSS        pBSSList
-);
-
-void
-WPA_ParseRSN(
-	PKnownBSS        pBSSList,
-	PWLAN_IE_RSN_EXT pRSN
-);
-
-bool
-WPA_SearchRSN(
-	unsigned char byCmd,
-	unsigned char byEncrypt,
-	PKnownBSS        pBSSList
-);
-
-bool
-WPAb_Is_RSN(
-	PWLAN_IE_RSN_EXT pRSN
-);
-
-#endif /* __WPA_H__ */
diff --git a/drivers/staging/vt6655/wpa2.c b/drivers/staging/vt6655/wpa2.c
deleted file mode 100644
index bb335ef..0000000
--- a/drivers/staging/vt6655/wpa2.c
+++ /dev/null
@@ -1,359 +0,0 @@
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
- * File: wpa2.c
- *
- * Purpose: Handles the Basic Service Set & Node Database functions
- *
- * Functions:
- *
- * Revision History:
- *
- * Author: Yiching Chen
- *
- * Date: Oct. 4, 2004
- *
- */
-
-#include "wpa2.h"
-#include "device.h"
-#include "wmgr.h"
-
-/*---------------------  Static Classes  ----------------------------*/
-
-/*---------------------  Static Variables  --------------------------*/
-
-static const unsigned char abyOUIGK[4]      = { 0x00, 0x0F, 0xAC, 0x00 };
-static const unsigned char abyOUIWEP40[4]   = { 0x00, 0x0F, 0xAC, 0x01 };
-static const unsigned char abyOUIWEP104[4]  = { 0x00, 0x0F, 0xAC, 0x05 };
-static const unsigned char abyOUITKIP[4]    = { 0x00, 0x0F, 0xAC, 0x02 };
-static const unsigned char abyOUICCMP[4]    = { 0x00, 0x0F, 0xAC, 0x04 };
-
-static const unsigned char abyOUI8021X[4]   = { 0x00, 0x0F, 0xAC, 0x01 };
-static const unsigned char abyOUIPSK[4]     = { 0x00, 0x0F, 0xAC, 0x02 };
-
-/*---------------------  Static Functions  --------------------------*/
-
-/*---------------------  Export Variables  --------------------------*/
-
-/*---------------------  Export Functions  --------------------------*/
-
-/*+
- *
- * Description:
- *    Clear RSN information in BSSList.
- *
- * Parameters:
- *  In:
- *      pBSSNode - BSS list.
- *  Out:
- *      none
- *
- * Return Value: none.
- *
- -*/
-void
-WPA2_ClearRSN(
-	PKnownBSS        pBSSNode
-)
-{
-	int ii;
-
-	pBSSNode->bWPA2Valid = false;
-
-	pBSSNode->byCSSGK = WLAN_11i_CSS_CCMP;
-	for (ii = 0; ii < 4; ii++)
-		pBSSNode->abyCSSPK[ii] = WLAN_11i_CSS_CCMP;
-	pBSSNode->wCSSPKCount = 1;
-	for (ii = 0; ii < 4; ii++)
-		pBSSNode->abyAKMSSAuthType[ii] = WLAN_11i_AKMSS_802_1X;
-	pBSSNode->wAKMSSAuthCount = 1;
-	pBSSNode->sRSNCapObj.bRSNCapExist = false;
-	pBSSNode->sRSNCapObj.wRSNCap = 0;
-}
-
-/*+
- *
- * Description:
- *    Parse RSN IE.
- *
- * Parameters:
- *  In:
- *      pBSSNode - BSS list.
- *      pRSN - Pointer to the RSN IE.
- *  Out:
- *      none
- *
- * Return Value: none.
- *
- -*/
-void
-WPA2vParseRSN(
-	PKnownBSS        pBSSNode,
-	PWLAN_IE_RSN     pRSN
-)
-{
-	int                 i, j;
-	unsigned short m = 0, n = 0;
-	unsigned char *pbyOUI;
-	bool bUseGK = false;
-
-	pr_debug("WPA2_ParseRSN: [%d]\n", pRSN->len);
-
-	WPA2_ClearRSN(pBSSNode);
-
-	if (pRSN->len == 2) { // ver(2)
-		if ((pRSN->byElementID == WLAN_EID_RSN) && (pRSN->wVersion == 1))
-			pBSSNode->bWPA2Valid = true;
-
-		return;
-	}
-
-	if (pRSN->len < 6) { // ver(2) + GK(4)
-		// invalid CSS, P802.11i/D10.0, p31
-		return;
-	}
-
-	// information element header makes sense
-	if ((pRSN->byElementID == WLAN_EID_RSN) &&
-	    (pRSN->wVersion == 1)) {
-		pr_debug("Legal 802.11i RSN\n");
-
-		pbyOUI = &(pRSN->abyRSN[0]);
-		if (!memcmp(pbyOUI, abyOUIWEP40, 4))
-			pBSSNode->byCSSGK = WLAN_11i_CSS_WEP40;
-		else if (!memcmp(pbyOUI, abyOUITKIP, 4))
-			pBSSNode->byCSSGK = WLAN_11i_CSS_TKIP;
-		else if (!memcmp(pbyOUI, abyOUICCMP, 4))
-			pBSSNode->byCSSGK = WLAN_11i_CSS_CCMP;
-		else if (!memcmp(pbyOUI, abyOUIWEP104, 4))
-			pBSSNode->byCSSGK = WLAN_11i_CSS_WEP104;
-		else if (!memcmp(pbyOUI, abyOUIGK, 4)) {
-			// invalid CSS, P802.11i/D10.0, p32
-			return;
-		} else
-			// any vendor checks here
-			pBSSNode->byCSSGK = WLAN_11i_CSS_UNKNOWN;
-
-		pr_debug("802.11i CSS: %X\n", pBSSNode->byCSSGK);
-
-		if (pRSN->len == 6) {
-			pBSSNode->bWPA2Valid = true;
-			return;
-		}
-
-		if (pRSN->len >= 8) { // ver(2) + GK(4) + PK count(2)
-			pBSSNode->wCSSPKCount = *((unsigned short *)&(pRSN->abyRSN[4]));
-			j = 0;
-			pbyOUI = &(pRSN->abyRSN[6]);
-
-			for (i = 0; (i < pBSSNode->wCSSPKCount) && (j < sizeof(pBSSNode->abyCSSPK)/sizeof(unsigned char)); i++) {
-				if (pRSN->len >= 8+i*4+4) { // ver(2)+GK(4)+PKCnt(2)+PKS(4*i)
-					if (!memcmp(pbyOUI, abyOUIGK, 4)) {
-						pBSSNode->abyCSSPK[j++] = WLAN_11i_CSS_USE_GROUP;
-						bUseGK = true;
-					} else if (!memcmp(pbyOUI, abyOUIWEP40, 4)) {
-						// Invalid CSS, continue to parsing
-					} else if (!memcmp(pbyOUI, abyOUITKIP, 4)) {
-						if (pBSSNode->byCSSGK != WLAN_11i_CSS_CCMP)
-							pBSSNode->abyCSSPK[j++] = WLAN_11i_CSS_TKIP;
-						else
-							; // Invalid CSS, continue to parsing
-					} else if (!memcmp(pbyOUI, abyOUICCMP, 4)) {
-						pBSSNode->abyCSSPK[j++] = WLAN_11i_CSS_CCMP;
-					} else if (!memcmp(pbyOUI, abyOUIWEP104, 4)) {
-						// Invalid CSS, continue to parsing
-					} else {
-						// any vendor checks here
-						pBSSNode->abyCSSPK[j++] = WLAN_11i_CSS_UNKNOWN;
-					}
-					pbyOUI += 4;
-					pr_debug("abyCSSPK[%d]: %X\n",
-						 j-1, pBSSNode->abyCSSPK[j-1]);
-				} else
-					break;
-			} //for
-
-			if (bUseGK) {
-				if (j != 1) {
-					// invalid CSS, This should be only PK CSS.
-					return;
-				}
-				if (pBSSNode->byCSSGK == WLAN_11i_CSS_CCMP) {
-					// invalid CSS, If CCMP is enable , PK can't be CSSGK.
-					return;
-				}
-			}
-			if ((pBSSNode->wCSSPKCount != 0) && (j == 0)) {
-				// invalid CSS, No valid PK.
-				return;
-			}
-			pBSSNode->wCSSPKCount = (unsigned short)j;
-			pr_debug("wCSSPKCount: %d\n", pBSSNode->wCSSPKCount);
-		}
-
-		m = *((unsigned short *)&(pRSN->abyRSN[4]));
-
-		if (pRSN->len >= 10+m*4) { // ver(2) + GK(4) + PK count(2) + PKS(4*m) + AKMSS count(2)
-			pBSSNode->wAKMSSAuthCount = *((unsigned short *)&(pRSN->abyRSN[6+4*m]));
-			j = 0;
-			pbyOUI = &(pRSN->abyRSN[8+4*m]);
-			for (i = 0; (i < pBSSNode->wAKMSSAuthCount) && (j < sizeof(pBSSNode->abyAKMSSAuthType)/sizeof(unsigned char)); i++) {
-				if (pRSN->len >= 10+(m+i)*4+4) { // ver(2)+GK(4)+PKCnt(2)+PKS(4*m)+AKMSS(2)+AKS(4*i)
-					if (!memcmp(pbyOUI, abyOUI8021X, 4))
-						pBSSNode->abyAKMSSAuthType[j++] = WLAN_11i_AKMSS_802_1X;
-					else if (!memcmp(pbyOUI, abyOUIPSK, 4))
-						pBSSNode->abyAKMSSAuthType[j++] = WLAN_11i_AKMSS_PSK;
-					else
-						// any vendor checks here
-						pBSSNode->abyAKMSSAuthType[j++] = WLAN_11i_AKMSS_UNKNOWN;
-					pr_debug("abyAKMSSAuthType[%d]: %X\n",
-						 j-1,
-						 pBSSNode->abyAKMSSAuthType[j-1]);
-				} else
-					break;
-			}
-			pBSSNode->wAKMSSAuthCount = (unsigned short)j;
-			pr_debug("wAKMSSAuthCount: %d\n",
-				 pBSSNode->wAKMSSAuthCount);
-
-			n = *((unsigned short *)&(pRSN->abyRSN[6+4*m]));
-			if (pRSN->len >= 12 + 4 * m + 4 * n) { // ver(2)+GK(4)+PKCnt(2)+PKS(4*m)+AKMSSCnt(2)+AKMSS(4*n)+Cap(2)
-				pBSSNode->sRSNCapObj.bRSNCapExist = true;
-				pBSSNode->sRSNCapObj.wRSNCap = *((unsigned short *)&(pRSN->abyRSN[8+4*m+4*n]));
-			}
-		}
-		//ignore PMKID lists bcs only (Re)Assocrequest has this field
-		pBSSNode->bWPA2Valid = true;
-	}
-}
-
-/*+
- *
- * Description:
- *    Set WPA IEs
- *
- * Parameters:
- *  In:
- *      pMgmtHandle - Pointer to management object
- *  Out:
- *      pRSNIEs     - Pointer to the RSN IE to set.
- *
- * Return Value: length of IEs.
- *
- -*/
-unsigned int
-WPA2uSetIEs(
-	void *pMgmtHandle,
-	PWLAN_IE_RSN pRSNIEs
-)
-{
-	PSMgmtObject    pMgmt = (PSMgmtObject) pMgmtHandle;
-	unsigned char *pbyBuffer = NULL;
-	unsigned int ii = 0;
-	unsigned short *pwPMKID = NULL;
-
-	if (pRSNIEs == NULL)
-		return 0;
-
-	if (((pMgmt->eAuthenMode == WMAC_AUTH_WPA2) ||
-	     (pMgmt->eAuthenMode == WMAC_AUTH_WPA2PSK)) &&
-	    (pMgmt->pCurrBSS != NULL)) {
-		/* WPA2 IE */
-		pbyBuffer = (unsigned char *)pRSNIEs;
-		pRSNIEs->byElementID = WLAN_EID_RSN;
-		pRSNIEs->len = 6; //Version(2)+GK(4)
-		pRSNIEs->wVersion = 1;
-		//Group Key Cipher Suite
-		pRSNIEs->abyRSN[0] = 0x00;
-		pRSNIEs->abyRSN[1] = 0x0F;
-		pRSNIEs->abyRSN[2] = 0xAC;
-		if (pMgmt->byCSSGK == KEY_CTL_WEP)
-			pRSNIEs->abyRSN[3] = pMgmt->pCurrBSS->byCSSGK;
-		else if (pMgmt->byCSSGK == KEY_CTL_TKIP)
-			pRSNIEs->abyRSN[3] = WLAN_11i_CSS_TKIP;
-		else if (pMgmt->byCSSGK == KEY_CTL_CCMP)
-			pRSNIEs->abyRSN[3] = WLAN_11i_CSS_CCMP;
-		else
-			pRSNIEs->abyRSN[3] = WLAN_11i_CSS_UNKNOWN;
-
-		// Pairwise Key Cipher Suite
-		pRSNIEs->abyRSN[4] = 1;
-		pRSNIEs->abyRSN[5] = 0;
-		pRSNIEs->abyRSN[6] = 0x00;
-		pRSNIEs->abyRSN[7] = 0x0F;
-		pRSNIEs->abyRSN[8] = 0xAC;
-		if (pMgmt->byCSSPK == KEY_CTL_TKIP)
-			pRSNIEs->abyRSN[9] = WLAN_11i_CSS_TKIP;
-		else if (pMgmt->byCSSPK == KEY_CTL_CCMP)
-			pRSNIEs->abyRSN[9] = WLAN_11i_CSS_CCMP;
-		else if (pMgmt->byCSSPK == KEY_CTL_NONE)
-			pRSNIEs->abyRSN[9] = WLAN_11i_CSS_USE_GROUP;
-		else
-			pRSNIEs->abyRSN[9] = WLAN_11i_CSS_UNKNOWN;
-
-		pRSNIEs->len += 6;
-
-		// Auth Key Management Suite
-		pRSNIEs->abyRSN[10] = 1;
-		pRSNIEs->abyRSN[11] = 0;
-		pRSNIEs->abyRSN[12] = 0x00;
-		pRSNIEs->abyRSN[13] = 0x0F;
-		pRSNIEs->abyRSN[14] = 0xAC;
-		if (pMgmt->eAuthenMode == WMAC_AUTH_WPA2PSK)
-			pRSNIEs->abyRSN[15] = WLAN_11i_AKMSS_PSK;
-		else if (pMgmt->eAuthenMode == WMAC_AUTH_WPA2)
-			pRSNIEs->abyRSN[15] = WLAN_11i_AKMSS_802_1X;
-		else
-			pRSNIEs->abyRSN[15] = WLAN_11i_AKMSS_UNKNOWN;
-
-		pRSNIEs->len += 6;
-
-		// RSN Capabilities
-		if (pMgmt->pCurrBSS->sRSNCapObj.bRSNCapExist == true) {
-			memcpy(&pRSNIEs->abyRSN[16], &pMgmt->pCurrBSS->sRSNCapObj.wRSNCap, 2);
-		} else {
-			pRSNIEs->abyRSN[16] = 0;
-			pRSNIEs->abyRSN[17] = 0;
-		}
-		pRSNIEs->len += 2;
-
-		if ((pMgmt->gsPMKIDCache.BSSIDInfoCount > 0) &&
-		    pMgmt->bRoaming &&
-		    (pMgmt->eAuthenMode == WMAC_AUTH_WPA2)) {
-			// RSN PMKID
-			pwPMKID = (unsigned short *)(&pRSNIEs->abyRSN[18]);  // Point to PMKID count
-			*pwPMKID = 0;                               // Initialize PMKID count
-			pbyBuffer = &pRSNIEs->abyRSN[20];           // Point to PMKID list
-			for (ii = 0; ii < pMgmt->gsPMKIDCache.BSSIDInfoCount; ii++) {
-				if (!memcmp(&pMgmt->gsPMKIDCache.BSSIDInfo[ii].abyBSSID[0], pMgmt->abyCurrBSSID, ETH_ALEN)) {
-					(*pwPMKID)++;
-					memcpy(pbyBuffer, pMgmt->gsPMKIDCache.BSSIDInfo[ii].abyPMKID, 16);
-					pbyBuffer += 16;
-				}
-			}
-			if (*pwPMKID != 0)
-				pRSNIEs->len += (2 + (*pwPMKID)*16);
-			else
-				pbyBuffer = &pRSNIEs->abyRSN[18];
-		}
-		return pRSNIEs->len + WLAN_IEHDR_LEN;
-	}
-	return 0;
-}
diff --git a/drivers/staging/vt6655/wpa2.h b/drivers/staging/vt6655/wpa2.h
deleted file mode 100644
index 2d0bd2e..0000000
--- a/drivers/staging/vt6655/wpa2.h
+++ /dev/null
@@ -1,77 +0,0 @@
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
- * File: wpa2.h
- *
- * Purpose: Defines the macros, types, and functions for dealing
- *          with WPA2 informations.
- *
- * Author: Yiching Chen
- *
- * Date: Oct. 4, 2004
- *
- */
-
-#ifndef __WPA2_H__
-#define __WPA2_H__
-
-#include "ttype.h"
-#include "80211mgr.h"
-#include "80211hdr.h"
-#include "bssdb.h"
-
-/*---------------------  Export Definitions -------------------------*/
-#define MAX_PMKID_CACHE         16
-
-typedef struct tagsPMKIDInfo {
-	unsigned char abyBSSID[6];
-	unsigned char abyPMKID[16];
-} PMKIDInfo, *PPMKIDInfo;
-
-typedef struct tagSPMKIDCache {
-	unsigned long BSSIDInfoCount;
-	PMKIDInfo   BSSIDInfo[MAX_PMKID_CACHE];
-} SPMKIDCache, *PSPMKIDCache;
-
-/*---------------------  Export Classes  ----------------------------*/
-
-/*---------------------  Export Variables  --------------------------*/
-
-/*---------------------  Export Types  ------------------------------*/
-
-/*---------------------  Export Functions  --------------------------*/
-
-void
-WPA2_ClearRSN(
-	PKnownBSS        pBSSNode
-);
-
-void
-WPA2vParseRSN(
-	PKnownBSS        pBSSNode,
-	PWLAN_IE_RSN     pRSN
-);
-
-unsigned int
-WPA2uSetIEs(
-	void *pMgmtHandle,
-	PWLAN_IE_RSN pRSNIEs
-);
-
-#endif // __WPA2_H__
-- 
2.1.0

