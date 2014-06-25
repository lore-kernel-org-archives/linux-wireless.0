Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:39530 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257AbaFYUVY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2014 16:21:24 -0400
Received: by mail-we0-f173.google.com with SMTP id t60so2602850wes.32
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jun 2014 13:21:23 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 12/34] staging: vt6656: remove dead code wpa
Date: Wed, 25 Jun 2014 21:19:49 +0100
Message-Id: <1403727611-6825-13-git-send-email-tvboxspy@gmail.com> (sfid-20140625_222955_864597_2A1BB2EA)
In-Reply-To: <1403727611-6825-1-git-send-email-tvboxspy@gmail.com>
References: <1403727611-6825-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/80211mgr.c |  11 --
 drivers/staging/vt6656/Makefile   |   1 -
 drivers/staging/vt6656/wpa.c      | 314 --------------------------------------
 drivers/staging/vt6656/wpa.h      |  72 ---------
 4 files changed, 398 deletions(-)
 delete mode 100644 drivers/staging/vt6656/wpa.c
 delete mode 100644 drivers/staging/vt6656/wpa.h

diff --git a/drivers/staging/vt6656/80211mgr.c b/drivers/staging/vt6656/80211mgr.c
index 61edb51..48baef9 100644
--- a/drivers/staging/vt6656/80211mgr.c
+++ b/drivers/staging/vt6656/80211mgr.c
@@ -54,7 +54,6 @@
 #include "tether.h"
 #include "80211mgr.h"
 #include "80211hdr.h"
-#include "wpa.h"
 
 static int          msglevel                = MSG_LEVEL_INFO;
 /*static int          msglevel                =MSG_LEVEL_DEBUG;*/
@@ -158,10 +157,6 @@ vMgrDecodeBeacon(
                 pFrame->pRSN = (PWLAN_IE_RSN)pItem;
             break;
         case WLAN_EID_RSN_WPA:
-            if (pFrame->pRSNWPA == NULL) {
-                if (WPAb_Is_RSN((PWLAN_IE_RSN_EXT)pItem) == true)
-                    pFrame->pRSNWPA = (PWLAN_IE_RSN_EXT)pItem;
-            }
             break;
 
         case WLAN_EID_ERP:
@@ -325,8 +320,6 @@ vMgrDecodeAssocRequest(
             break;
         case WLAN_EID_RSN_WPA:
             if (pFrame->pRSNWPA == NULL) {
-                if (WPAb_Is_RSN((PWLAN_IE_RSN_EXT)pItem) == true)
-                    pFrame->pRSNWPA = (PWLAN_IE_RSN_EXT)pItem;
             }
             break;
         case WLAN_EID_EXTSUPP_RATES:
@@ -491,8 +484,6 @@ vMgrDecodeReassocRequest(
             break;
         case WLAN_EID_RSN_WPA:
 		if (pFrame->pRSNWPA == NULL)
-                if (WPAb_Is_RSN((PWLAN_IE_RSN_EXT)pItem) == true)
-                    pFrame->pRSNWPA = (PWLAN_IE_RSN_EXT)pItem;
             break;
 
         case WLAN_EID_EXTSUPP_RATES:
@@ -673,8 +664,6 @@ vMgrDecodeProbeResponse(
             break;
         case WLAN_EID_RSN_WPA:
             if (pFrame->pRSNWPA == NULL) {
-                if (WPAb_Is_RSN((PWLAN_IE_RSN_EXT)pItem) == true)
-                    pFrame->pRSNWPA = (PWLAN_IE_RSN_EXT)pItem;
             }
             break;
         case WLAN_EID_ERP:
diff --git a/drivers/staging/vt6656/Makefile b/drivers/staging/vt6656/Makefile
index 5ac0dbd..1be7d60 100644
--- a/drivers/staging/vt6656/Makefile
+++ b/drivers/staging/vt6656/Makefile
@@ -15,7 +15,6 @@ vt6656_stage-y +=	main_usb.o \
 			datarate.o \
 			rc4.o \
 			tether.o \
-			wpa.o \
 			key.o \
 			tkip.o \
 			michael.o \
diff --git a/drivers/staging/vt6656/wpa.c b/drivers/staging/vt6656/wpa.c
deleted file mode 100644
index 403c295..0000000
--- a/drivers/staging/vt6656/wpa.c
+++ /dev/null
@@ -1,314 +0,0 @@
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
-#include "tmacro.h"
-#include "tether.h"
-#include "device.h"
-#include "80211hdr.h"
-#include "bssdb.h"
-#include "wmgr.h"
-#include "wpa.h"
-#include "80211mgr.h"
-
-static int          msglevel                =MSG_LEVEL_INFO;
-
-static const u8 abyOUI00[4] = { 0x00, 0x50, 0xf2, 0x00 };
-static const u8 abyOUI01[4] = { 0x00, 0x50, 0xf2, 0x01 };
-static const u8 abyOUI02[4] = { 0x00, 0x50, 0xf2, 0x02 };
-static const u8 abyOUI03[4] = { 0x00, 0x50, 0xf2, 0x03 };
-static const u8 abyOUI04[4] = { 0x00, 0x50, 0xf2, 0x04 };
-static const u8 abyOUI05[4] = { 0x00, 0x50, 0xf2, 0x05 };
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
--*/
-
-void
-WPA_ClearRSN(
-     PKnownBSS        pBSSList
-    )
-{
-    int ii;
-    pBSSList->byGKType = WPA_TKIP;
-    for (ii=0; ii < 4; ii ++)
-        pBSSList->abyPKType[ii] = WPA_TKIP;
-    pBSSList->wPKCount = 0;
-    for (ii=0; ii < 4; ii ++)
-        pBSSList->abyAuthType[ii] = WPA_AUTH_IEEE802_1X;
-    pBSSList->wAuthCount = 0;
-    pBSSList->byDefaultK_as_PK = 0;
-    pBSSList->byReplayIdx = 0;
-    pBSSList->sRSNCapObj.bRSNCapExist = false;
-    pBSSList->sRSNCapObj.wRSNCap = 0;
-    pBSSList->bWPAValid = false;
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
--*/
-void
-WPA_ParseRSN(
-     PKnownBSS        pBSSList,
-     PWLAN_IE_RSN_EXT pRSN
-    )
-{
-    PWLAN_IE_RSN_AUTH  pIE_RSN_Auth = NULL;
-    int                i, j, m, n = 0;
-    u8 *              pbyCaps;
-
-    WPA_ClearRSN(pBSSList);
-
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"WPA_ParseRSN: [%d]\n", pRSN->len);
-
-    // information element header makes sense
-    if ((pRSN->len >= 6) // oui1(4)+ver(2)
-         && (pRSN->byElementID == WLAN_EID_RSN_WPA) &&  !memcmp(pRSN->abyOUI, abyOUI01, 4)
-         && (pRSN->wVersion == 1)) {
-
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Legal RSN\n");
-        // update each variable if pRSN is long enough to contain the variable
-        if (pRSN->len >= 10) //oui1(4)+ver(2)+GKSuite(4)
-        {
-            if ( !memcmp(pRSN->abyMulticast, abyOUI01, 4))
-                pBSSList->byGKType = WPA_WEP40;
-            else if ( !memcmp(pRSN->abyMulticast, abyOUI02, 4))
-                pBSSList->byGKType = WPA_TKIP;
-            else if ( !memcmp(pRSN->abyMulticast, abyOUI03, 4))
-                pBSSList->byGKType = WPA_AESWRAP;
-            else if ( !memcmp(pRSN->abyMulticast, abyOUI04, 4))
-                pBSSList->byGKType = WPA_AESCCMP;
-            else if ( !memcmp(pRSN->abyMulticast, abyOUI05, 4))
-                pBSSList->byGKType = WPA_WEP104;
-            else
-                // any vendor checks here
-                pBSSList->byGKType = WPA_NONE;
-
-            DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"byGKType: %x\n", pBSSList->byGKType);
-        }
-
-        if (pRSN->len >= 12) //oui1(4)+ver(2)+GKS(4)+PKSCnt(2)
-        {
-            j = 0;
-            DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"wPKCount: %d, sizeof(pBSSList->abyPKType): %zu\n", pRSN->wPKCount, sizeof(pBSSList->abyPKType));
-	    for (i = 0; (i < pRSN->wPKCount) &&
-		   (j < ARRAY_SIZE(pBSSList->abyPKType)); i++) {
-                if(pRSN->len >= 12+i*4+4) { //oui1(4)+ver(2)+GKS(4)+PKSCnt(2)+PKS(4*i)
-                    if ( !memcmp(pRSN->PKSList[i].abyOUI, abyOUI00, 4))
-                        pBSSList->abyPKType[j++] = WPA_NONE;
-                    else if ( !memcmp(pRSN->PKSList[i].abyOUI, abyOUI02, 4))
-                        pBSSList->abyPKType[j++] = WPA_TKIP;
-                    else if ( !memcmp(pRSN->PKSList[i].abyOUI, abyOUI03, 4))
-                        pBSSList->abyPKType[j++] = WPA_AESWRAP;
-                    else if ( !memcmp(pRSN->PKSList[i].abyOUI, abyOUI04, 4))
-                        pBSSList->abyPKType[j++] = WPA_AESCCMP;
-                    else
-                        // any vendor checks here
-                        ;
-                }
-                else
-                    break;
-                //DBG_PRN_GRP14(("abyPKType[%d]: %X\n", j-1, pBSSList->abyPKType[j-1]));
-            } //for
-            pBSSList->wPKCount = (u16)j;
-            DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"wPKCount: %d\n", pBSSList->wPKCount);
-        }
-
-        m = pRSN->wPKCount;
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"m: %d\n", m);
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"14+m*4: %d\n", 14+m*4);
-
-        if (pRSN->len >= 14+m*4) { //oui1(4)+ver(2)+GKS(4)+PKSCnt(2)+PKS(4*m)+AKC(2)
-            // overlay IE_RSN_Auth structure into correct place
-            pIE_RSN_Auth = (PWLAN_IE_RSN_AUTH) pRSN->PKSList[m].abyOUI;
-            j = 0;
-            DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"wAuthCount: %d, sizeof(pBSSList->abyAuthType): %zu\n",
-                          pIE_RSN_Auth->wAuthCount, sizeof(pBSSList->abyAuthType));
-	    for (i = 0; (i < pIE_RSN_Auth->wAuthCount) &&
-		   (j < ARRAY_SIZE(pBSSList->abyAuthType)); i++) {
-                if(pRSN->len >= 14+4+(m+i)*4) { //oui1(4)+ver(2)+GKS(4)+PKSCnt(2)+PKS(4*m)+AKC(2)+AKS(4*i)
-                    if ( !memcmp(pIE_RSN_Auth->AuthKSList[i].abyOUI, abyOUI01, 4))
-                        pBSSList->abyAuthType[j++] = WPA_AUTH_IEEE802_1X;
-                    else if ( !memcmp(pIE_RSN_Auth->AuthKSList[i].abyOUI, abyOUI02, 4))
-                        pBSSList->abyAuthType[j++] = WPA_AUTH_PSK;
-                    else
-                    // any vendor checks here
-                    ;
-                }
-                else
-                    break;
-                //DBG_PRN_GRP14(("abyAuthType[%d]: %X\n", j-1, pBSSList->abyAuthType[j-1]));
-            }
-            if(j > 0)
-                pBSSList->wAuthCount = (u16)j;
-            DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"wAuthCount: %d\n", pBSSList->wAuthCount);
-        }
-
-        if (pIE_RSN_Auth != NULL) {
-
-            n = pIE_RSN_Auth->wAuthCount;
-
-            DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"n: %d\n", n);
-            DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"14+4+(m+n)*4: %d\n", 14+4+(m+n)*4);
-
-            if(pRSN->len+2 >= 14+4+(m+n)*4) { //oui1(4)+ver(2)+GKS(4)+PKSCnt(2)+PKS(4*m)+AKC(2)+AKS(4*n)+Cap(2)
-                pbyCaps = (u8 *)pIE_RSN_Auth->AuthKSList[n].abyOUI;
-                pBSSList->byDefaultK_as_PK = (*pbyCaps) & WPA_GROUPFLAG;
-                pBSSList->byReplayIdx = 2 << ((*pbyCaps >> WPA_REPLAYBITSSHIFT) & WPA_REPLAYBITS);
-                pBSSList->sRSNCapObj.bRSNCapExist = true;
-                pBSSList->sRSNCapObj.wRSNCap = *(u16 *)pbyCaps;
-                //DBG_PRN_GRP14(("pbyCaps: %X\n", *pbyCaps));
-                //DBG_PRN_GRP14(("byDefaultK_as_PK: %X\n", pBSSList->byDefaultK_as_PK));
-                //DBG_PRN_GRP14(("byReplayIdx: %X\n", pBSSList->byReplayIdx));
-            }
-        }
-        pBSSList->bWPAValid = true;
-    }
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
--*/
-bool
-WPA_SearchRSN(
-    u8                byCmd,
-    u8                byEncrypt,
-     PKnownBSS        pBSSList
-    )
-{
-    int ii;
-    u8 byPKType = WPA_NONE;
-
-    if (pBSSList->bWPAValid == false)
-        return false;
-
-    switch(byCmd) {
-    case 0:
-
-        if (byEncrypt != pBSSList->byGKType)
-            return false;
-
-        if (pBSSList->wPKCount > 0) {
-            for (ii = 0; ii < pBSSList->wPKCount; ii ++) {
-                if (pBSSList->abyPKType[ii] == WPA_AESCCMP)
-                    byPKType = WPA_AESCCMP;
-                else if ((pBSSList->abyPKType[ii] == WPA_TKIP) && (byPKType != WPA_AESCCMP))
-                     byPKType = WPA_TKIP;
-                else if ((pBSSList->abyPKType[ii] == WPA_WEP40) && (byPKType != WPA_AESCCMP) && (byPKType != WPA_TKIP))
-                     byPKType = WPA_WEP40;
-                else if ((pBSSList->abyPKType[ii] == WPA_WEP104) && (byPKType != WPA_AESCCMP) && (byPKType != WPA_TKIP))
-                     byPKType = WPA_WEP104;
-            }
-            if (byEncrypt != byPKType)
-                return false;
-        }
-        return true;
-//        if (pBSSList->wAuthCount > 0)
-//            for (ii=0; ii < pBSSList->wAuthCount; ii ++)
-//                if (byAuth == pBSSList->abyAuthType[ii])
-//                    break;
-        break;
-
-    default:
-        break;
-    }
-    return false;
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
--*/
-bool
-WPAb_Is_RSN(
-     PWLAN_IE_RSN_EXT pRSN
-    )
-{
-    if (pRSN == NULL)
-        return false;
-
-    if ((pRSN->len >= 6) && // oui1(4)+ver(2)
-        (pRSN->byElementID == WLAN_EID_RSN_WPA) &&  !memcmp(pRSN->abyOUI, abyOUI01, 4) &&
-        (pRSN->wVersion == 1)) {
-        return true;
-    }
-    else
-        return false;
-}
-
diff --git a/drivers/staging/vt6656/wpa.h b/drivers/staging/vt6656/wpa.h
deleted file mode 100644
index 2a724c0..0000000
--- a/drivers/staging/vt6656/wpa.h
+++ /dev/null
@@ -1,72 +0,0 @@
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
-#include "80211hdr.h"
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
-void
-WPA_ClearRSN(
-     PKnownBSS        pBSSList
-    );
-
-void
-WPA_ParseRSN(
-     PKnownBSS        pBSSList,
-     PWLAN_IE_RSN_EXT pRSN
-    );
-
-bool
-WPA_SearchRSN(
-    u8                byCmd,
-    u8                byEncrypt,
-     PKnownBSS        pBSSList
-    );
-
-bool
-WPAb_Is_RSN(
-     PWLAN_IE_RSN_EXT pRSN
-    );
-
-#endif /* __WPA_H__ */
-- 
1.9.1

