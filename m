Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:50609 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542AbaFYUVW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2014 16:21:22 -0400
Received: by mail-wi0-f177.google.com with SMTP id r20so3205030wiv.16
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jun 2014 13:21:21 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 11/34] staging: vt6656: dead code remove wpa2.c
Date: Wed, 25 Jun 2014 21:19:48 +0100
Message-Id: <1403727611-6825-12-git-send-email-tvboxspy@gmail.com> (sfid-20140625_222958_909794_504834DB)
In-Reply-To: <1403727611-6825-1-git-send-email-tvboxspy@gmail.com>
References: <1403727611-6825-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/Makefile |   1 -
 drivers/staging/vt6656/wmgr.h   |   2 -
 drivers/staging/vt6656/wpa2.c   | 235 ----------------------------------------
 drivers/staging/vt6656/wpa2.h   |  53 ---------
 4 files changed, 291 deletions(-)
 delete mode 100644 drivers/staging/vt6656/wpa2.c
 delete mode 100644 drivers/staging/vt6656/wpa2.h

diff --git a/drivers/staging/vt6656/Makefile b/drivers/staging/vt6656/Makefile
index 466534e..5ac0dbd 100644
--- a/drivers/staging/vt6656/Makefile
+++ b/drivers/staging/vt6656/Makefile
@@ -9,7 +9,6 @@ vt6656_stage-y +=	main_usb.o \
 			wctl.o  \
 			80211mgr.o \
 			wcmd.o\
-			wpa2.o \
 			rxtx.o \
 			dpc.o \
 			power.o \
diff --git a/drivers/staging/vt6656/wmgr.h b/drivers/staging/vt6656/wmgr.h
index 34c2803..2439068 100644
--- a/drivers/staging/vt6656/wmgr.h
+++ b/drivers/staging/vt6656/wmgr.h
@@ -38,7 +38,6 @@
 #include "80211hdr.h"
 #include "wcmd.h"
 #include "bssdb.h"
-#include "wpa2.h"
 #include "card.h"
 
 // Scan time
@@ -324,7 +323,6 @@ struct vnt_manager {
 	KnownNodeDB sNodeDBTable[MAX_NODE_NUM + 1];
 
 	/* WPA2 PMKID Cache */
-	SPMKIDCache gsPMKIDCache;
 	int bRoaming;
 
 	/* associate info */
diff --git a/drivers/staging/vt6656/wpa2.c b/drivers/staging/vt6656/wpa2.c
deleted file mode 100644
index df55417..0000000
--- a/drivers/staging/vt6656/wpa2.c
+++ /dev/null
@@ -1,235 +0,0 @@
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
-#include "device.h"
-#include "wpa2.h"
-
-static int          msglevel                =MSG_LEVEL_INFO;
-//static int          msglevel                =MSG_LEVEL_DEBUG;
-
-static const u8 abyOUIGK[4]      = { 0x00, 0x0F, 0xAC, 0x00 };
-static const u8 abyOUIWEP40[4]   = { 0x00, 0x0F, 0xAC, 0x01 };
-static const u8 abyOUIWEP104[4]  = { 0x00, 0x0F, 0xAC, 0x05 };
-static const u8 abyOUITKIP[4]    = { 0x00, 0x0F, 0xAC, 0x02 };
-static const u8 abyOUICCMP[4]    = { 0x00, 0x0F, 0xAC, 0x04 };
-
-static const u8 abyOUI8021X[4]   = { 0x00, 0x0F, 0xAC, 0x01 };
-static const u8 abyOUIPSK[4]     = { 0x00, 0x0F, 0xAC, 0x02 };
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
--*/
-void
-WPA2_ClearRSN (
-     PKnownBSS        pBSSNode
-    )
-{
-    int ii;
-
-    pBSSNode->bWPA2Valid = false;
-
-    pBSSNode->byCSSGK = WLAN_11i_CSS_CCMP;
-    for (ii=0; ii < 4; ii ++)
-        pBSSNode->abyCSSPK[ii] = WLAN_11i_CSS_CCMP;
-    pBSSNode->wCSSPKCount = 1;
-    for (ii=0; ii < 4; ii ++)
-        pBSSNode->abyAKMSSAuthType[ii] = WLAN_11i_AKMSS_802_1X;
-    pBSSNode->wAKMSSAuthCount = 1;
-    pBSSNode->sRSNCapObj.bRSNCapExist = false;
-    pBSSNode->sRSNCapObj.wRSNCap = 0;
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
--*/
-void
-WPA2vParseRSN (
-     PKnownBSS        pBSSNode,
-     PWLAN_IE_RSN     pRSN
-    )
-{
-    int                 i, j;
-    u16                m = 0, n = 0;
-    u8 *               pbyOUI;
-    bool                bUseGK = false;
-
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"WPA2_ParseRSN: [%d]\n", pRSN->len);
-
-    WPA2_ClearRSN(pBSSNode);
-
-    if (pRSN->len == 2) { // ver(2)
-        if ((pRSN->byElementID == WLAN_EID_RSN) && (pRSN->wVersion == 1)) {
-            pBSSNode->bWPA2Valid = true;
-        }
-        return;
-    }
-
-    if (pRSN->len < 6) { // ver(2) + GK(4)
-        // invalid CSS, P802.11i/D10.0, p31
-        return;
-    }
-
-    // information element header makes sense
-    if ((pRSN->byElementID == WLAN_EID_RSN) &&
-        (pRSN->wVersion == 1)) {
-
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Legal 802.11i RSN\n");
-
-        pbyOUI = &(pRSN->abyRSN[0]);
-        if ( !memcmp(pbyOUI, abyOUIWEP40, 4))
-            pBSSNode->byCSSGK = WLAN_11i_CSS_WEP40;
-        else if ( !memcmp(pbyOUI, abyOUITKIP, 4))
-            pBSSNode->byCSSGK = WLAN_11i_CSS_TKIP;
-        else if ( !memcmp(pbyOUI, abyOUICCMP, 4))
-            pBSSNode->byCSSGK = WLAN_11i_CSS_CCMP;
-        else if ( !memcmp(pbyOUI, abyOUIWEP104, 4))
-            pBSSNode->byCSSGK = WLAN_11i_CSS_WEP104;
-        else if ( !memcmp(pbyOUI, abyOUIGK, 4)) {
-            // invalid CSS, P802.11i/D10.0, p32
-            return;
-        } else
-            // any vendor checks here
-            pBSSNode->byCSSGK = WLAN_11i_CSS_UNKNOWN;
-
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"802.11i CSS: %X\n", pBSSNode->byCSSGK);
-
-        if (pRSN->len == 6) {
-            pBSSNode->bWPA2Valid = true;
-            return;
-        }
-
-        if (pRSN->len >= 8) { // ver(2) + GK(4) + PK count(2)
-            pBSSNode->wCSSPKCount = *((u16 *) &(pRSN->abyRSN[4]));
-            j = 0;
-            pbyOUI = &(pRSN->abyRSN[6]);
-
-            for (i = 0; (i < pBSSNode->wCSSPKCount) && (j < sizeof(pBSSNode->abyCSSPK)/sizeof(u8)); i++) {
-
-                if (pRSN->len >= 8+i*4+4) { // ver(2)+GK(4)+PKCnt(2)+PKS(4*i)
-                    if ( !memcmp(pbyOUI, abyOUIGK, 4)) {
-                        pBSSNode->abyCSSPK[j++] = WLAN_11i_CSS_USE_GROUP;
-                        bUseGK = true;
-                    } else if ( !memcmp(pbyOUI, abyOUIWEP40, 4)) {
-                        // Invalid CSS, continue parsing
-                    } else if ( !memcmp(pbyOUI, abyOUITKIP, 4)) {
-                        if (pBSSNode->byCSSGK != WLAN_11i_CSS_CCMP)
-                            pBSSNode->abyCSSPK[j++] = WLAN_11i_CSS_TKIP;
-                        else
-                            ; // Invalid CSS, continue parsing
-                    } else if ( !memcmp(pbyOUI, abyOUICCMP, 4)) {
-                        pBSSNode->abyCSSPK[j++] = WLAN_11i_CSS_CCMP;
-                    } else if ( !memcmp(pbyOUI, abyOUIWEP104, 4)) {
-                        // Invalid CSS, continue parsing
-                    } else {
-                        // any vendor checks here
-                        pBSSNode->abyCSSPK[j++] = WLAN_11i_CSS_UNKNOWN;
-                    }
-                    pbyOUI += 4;
-                    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"abyCSSPK[%d]: %X\n", j-1, pBSSNode->abyCSSPK[j-1]);
-                } else
-                    break;
-            } //for
-
-            if (bUseGK == true) {
-                if (j != 1) {
-                    // invalid CSS, This should be only PK CSS.
-                    return;
-                }
-                if (pBSSNode->byCSSGK == WLAN_11i_CSS_CCMP) {
-                    // invalid CSS, If CCMP is enable , PK can't be CSSGK.
-                    return;
-                }
-            }
-            if ((pBSSNode->wCSSPKCount != 0) && (j == 0)) {
-                // invalid CSS, No valid PK.
-                return;
-            }
-            pBSSNode->wCSSPKCount = (u16)j;
-            DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"wCSSPKCount: %d\n", pBSSNode->wCSSPKCount);
-        }
-
-        m = *((u16 *) &(pRSN->abyRSN[4]));
-
-        if (pRSN->len >= 10+m*4) { // ver(2) + GK(4) + PK count(2) + PKS(4*m) + AKMSS count(2)
-            pBSSNode->wAKMSSAuthCount = *((u16 *) &(pRSN->abyRSN[6+4*m]));
-            j = 0;
-            pbyOUI = &(pRSN->abyRSN[8+4*m]);
-            for (i = 0; (i < pBSSNode->wAKMSSAuthCount) && (j < sizeof(pBSSNode->abyAKMSSAuthType)/sizeof(u8)); i++) {
-                if (pRSN->len >= 10+(m+i)*4+4) { // ver(2)+GK(4)+PKCnt(2)+PKS(4*m)+AKMSS(2)+AKS(4*i)
-                    if ( !memcmp(pbyOUI, abyOUI8021X, 4))
-                        pBSSNode->abyAKMSSAuthType[j++] = WLAN_11i_AKMSS_802_1X;
-                    else if ( !memcmp(pbyOUI, abyOUIPSK, 4))
-                        pBSSNode->abyAKMSSAuthType[j++] = WLAN_11i_AKMSS_PSK;
-                    else
-                        // any vendor checks here
-                        pBSSNode->abyAKMSSAuthType[j++] = WLAN_11i_AKMSS_UNKNOWN;
-                    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"abyAKMSSAuthType[%d]: %X\n", j-1, pBSSNode->abyAKMSSAuthType[j-1]);
-                } else
-                    break;
-            }
-            pBSSNode->wAKMSSAuthCount = (u16)j;
-            DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"wAKMSSAuthCount: %d\n", pBSSNode->wAKMSSAuthCount);
-
-            n = *((u16 *) &(pRSN->abyRSN[6+4*m]));
-            if (pRSN->len >= 12+4*m+4*n) { // ver(2)+GK(4)+PKCnt(2)+PKS(4*m)+AKMSSCnt(2)+AKMSS(4*n)+Cap(2)
-                pBSSNode->sRSNCapObj.bRSNCapExist = true;
-                pBSSNode->sRSNCapObj.wRSNCap = *((u16 *) &(pRSN->abyRSN[8+4*m+4*n]));
-            }
-        }
-        //ignore PMKID lists bcs only (Re)Assocrequest has this field
-        pBSSNode->bWPA2Valid = true;
-    }
-}
diff --git a/drivers/staging/vt6656/wpa2.h b/drivers/staging/vt6656/wpa2.h
deleted file mode 100644
index dc505ce..0000000
--- a/drivers/staging/vt6656/wpa2.h
+++ /dev/null
@@ -1,53 +0,0 @@
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
-#include "80211mgr.h"
-#include "80211hdr.h"
-#include "bssdb.h"
-
-#define MAX_PMKID_CACHE         16
-
-typedef struct tagsPMKIDInfo {
-    u8    abyBSSID[6];
-    u8    abyPMKID[16];
-} PMKIDInfo, *PPMKIDInfo;
-
-typedef struct tagSPMKIDCache {
-	u32 BSSIDInfoCount;
-	PMKIDInfo BSSIDInfo[MAX_PMKID_CACHE];
-} SPMKIDCache, *PSPMKIDCache;
-
-void WPA2_ClearRSN(PKnownBSS pBSSNode);
-void WPA2vParseRSN(PKnownBSS pBSSNode, PWLAN_IE_RSN pRSN);
-
-#endif /* __WPA2_H__ */
-- 
1.9.1

