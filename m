Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:44452 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756218AbaJ2R5e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 13:57:34 -0400
Received: by mail-wi0-f179.google.com with SMTP id h11so5315851wiw.6
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2014 10:57:32 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH v2 18/48] staging: vt6655: deadcode remove wroute.c/h
Date: Wed, 29 Oct 2014 17:55:36 +0000
Message-Id: <1414605366-9335-19-git-send-email-tvboxspy@gmail.com> (sfid-20141029_185747_295549_CD41AC3D)
In-Reply-To: <1414605366-9335-1-git-send-email-tvboxspy@gmail.com>
References: <1414605366-9335-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/Makefile      |   1 -
 drivers/staging/vt6655/device_main.c |   1 -
 drivers/staging/vt6655/rxtx.c        |   1 -
 drivers/staging/vt6655/wroute.c      | 177 -----------------------------------
 drivers/staging/vt6655/wroute.h      |  45 ---------
 5 files changed, 225 deletions(-)
 delete mode 100644 drivers/staging/vt6655/wroute.c
 delete mode 100644 drivers/staging/vt6655/wroute.h

diff --git a/drivers/staging/vt6655/Makefile b/drivers/staging/vt6655/Makefile
index 141c0c1..e5ea1ea 100644
--- a/drivers/staging/vt6655/Makefile
+++ b/drivers/staging/vt6655/Makefile
@@ -21,7 +21,6 @@ vt6655_stage-y +=	device_main.o \
 	key.o \
 	tkip.o \
 	michael.o \
-	wroute.o \
 	rf.o \
 	wpa2.o \
 	aes_ccmp.o \
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 848c258..18dad0c 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -66,7 +66,6 @@
 #include "iocmd.h"
 #include "tcrc.h"
 #include "rxtx.h"
-#include "wroute.h"
 #include "bssdb.h"
 #include "dpc.h"
 #include "rf.h"
diff --git a/drivers/staging/vt6655/rxtx.c b/drivers/staging/vt6655/rxtx.c
index c47042c..6ae8594 100644
--- a/drivers/staging/vt6655/rxtx.c
+++ b/drivers/staging/vt6655/rxtx.c
@@ -59,7 +59,6 @@
 #include "tkip.h"
 #include "tcrc.h"
 #include "wctl.h"
-#include "wroute.h"
 #include "rf.h"
 
 /*---------------------  Static Definitions -------------------------*/
diff --git a/drivers/staging/vt6655/wroute.c b/drivers/staging/vt6655/wroute.c
deleted file mode 100644
index 430e944..0000000
--- a/drivers/staging/vt6655/wroute.c
+++ /dev/null
@@ -1,177 +0,0 @@
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
- * File: wroute.c
- *
- * Purpose: handle WMAC frame relay & filtering
- *
- * Author: Lyndon Chen
- *
- * Date: May 20, 2003
- *
- * Functions:
- *      ROUTEbRelay - Relay packet
- *
- * Revision History:
- *
- */
-
-#include "mac.h"
-#include "tcrc.h"
-#include "rxtx.h"
-#include "wroute.h"
-#include "card.h"
-#include "baseband.h"
-
-/*---------------------  Static Definitions -------------------------*/
-
-/*---------------------  Static Classes  ----------------------------*/
-
-/*---------------------  Static Functions  --------------------------*/
-
-/*---------------------  Export Variables  --------------------------*/
-
-/*
- * Description:
- *      Relay packet.  Return true if packet is copy to DMA1
- *
- * Parameters:
- *  In:
- *      pDevice             -
- *      pbySkbData          - rx packet skb data
- *  Out:
- *      true, false
- *
- * Return Value: true if packet duplicate; otherwise false
- *
- */
-bool ROUTEbRelay(struct vnt_private *pDevice, unsigned char *pbySkbData,
-		 unsigned int uDataLen, unsigned int uNodeIndex)
-{
-	PSMgmtObject    pMgmt = pDevice->pMgmt;
-	PSTxDesc        pHeadTD, pLastTD;
-	unsigned int cbFrameBodySize;
-	unsigned int uMACfragNum = 0;
-	unsigned char byPktType;
-	bool bNeedEncryption = false;
-	SKeyItem        STempKey;
-	PSKeyItem       pTransmitKey = NULL;
-	unsigned int ii;
-	unsigned char *pbyBSSID;
-
-	if (AVAIL_TD(pDevice, TYPE_AC0DMA) <= 0) {
-		pr_debug("Relay can't allocate TD1..\n");
-		return false;
-	}
-
-	pHeadTD = pDevice->apCurrTD[TYPE_AC0DMA];
-
-	pHeadTD->m_td1TD1.byTCR = (TCR_EDP | TCR_STP);
-
-	memcpy(pDevice->sTxEthHeader.abyDstAddr, pbySkbData, ETH_HLEN);
-
-	cbFrameBodySize = uDataLen - ETH_HLEN;
-
-	if (ntohs(pDevice->sTxEthHeader.wType) > ETH_DATA_LEN)
-		cbFrameBodySize += 8;
-
-	if (pDevice->bEncryptionEnable == true) {
-		bNeedEncryption = true;
-
-		/* get group key */
-		pbyBSSID = pDevice->abyBroadcastAddr;
-		if (KeybGetTransmitKey(&(pDevice->sKey), pbyBSSID,
-		    GROUP_KEY, &pTransmitKey) == false) {
-			pTransmitKey = NULL;
-			pr_debug("KEY is NULL. [%d]\n",
-				 pDevice->pMgmt->eCurrMode);
-		} else {
-			pr_debug("Get GTK\n");
-		}
-	}
-
-	if (pDevice->bEnableHostWEP) {
-		if (uNodeIndex < MAX_NODE_NUM + 1) {
-			pTransmitKey = &STempKey;
-			pTransmitKey->byCipherSuite = pMgmt->sNodeDBTable[uNodeIndex].byCipherSuite;
-			pTransmitKey->dwKeyIndex = pMgmt->sNodeDBTable[uNodeIndex].dwKeyIndex;
-			pTransmitKey->uKeyLength = pMgmt->sNodeDBTable[uNodeIndex].uWepKeyLength;
-			pTransmitKey->dwTSC47_16 = pMgmt->sNodeDBTable[uNodeIndex].dwTSC47_16;
-			pTransmitKey->wTSC15_0 = pMgmt->sNodeDBTable[uNodeIndex].wTSC15_0;
-			memcpy(pTransmitKey->abyKey,
-			       &pMgmt->sNodeDBTable[uNodeIndex].abyWepKey[0],
-			       pTransmitKey->uKeyLength);
-		}
-	}
-
-	if (uMACfragNum > AVAIL_TD(pDevice, TYPE_AC0DMA))
-		return false;
-
-	byPktType = pDevice->byPacketType;
-
-	if (pDevice->bFixRate) {
-		if (pDevice->eCurrentPHYType == PHY_TYPE_11B) {
-			if (pDevice->uConnectionRate >= RATE_11M)
-				pDevice->wCurrentRate = RATE_11M;
-			else
-				pDevice->wCurrentRate = pDevice->uConnectionRate;
-		} else {
-			if ((pDevice->eCurrentPHYType == PHY_TYPE_11A) &&
-			    (pDevice->uConnectionRate <= RATE_6M)) {
-				pDevice->wCurrentRate = RATE_6M;
-			} else {
-				if (pDevice->uConnectionRate >= RATE_54M)
-					pDevice->wCurrentRate = RATE_54M;
-				else
-					pDevice->wCurrentRate = pDevice->uConnectionRate;
-			}
-		}
-	} else {
-		pDevice->wCurrentRate = pDevice->pMgmt->sNodeDBTable[uNodeIndex].wTxDataRate;
-	}
-
-	if (pDevice->wCurrentRate <= RATE_11M)
-		byPktType = PK_TYPE_11B;
-
-	if (MACbIsRegBitsOn(pDevice->PortOffset, MAC_REG_PSCTL, PSCTL_PS)) {
-		/* Disable PS */
-		MACbPSWakeup(pDevice->PortOffset);
-	}
-
-	pDevice->bPWBitOn = false;
-
-	pLastTD = pHeadTD;
-	for (ii = 0; ii < uMACfragNum; ii++) {
-		/* Poll Transmit the adapter */
-		wmb();
-		pHeadTD->m_td0TD0.f1Owner = OWNED_BY_NIC;
-		wmb();
-		if (ii == (uMACfragNum - 1))
-			pLastTD = pHeadTD;
-		pHeadTD = pHeadTD->next;
-	}
-
-	pLastTD->pTDInfo->skb = NULL;
-	pLastTD->pTDInfo->byFlags = 0;
-
-	pDevice->apCurrTD[TYPE_AC0DMA] = pHeadTD;
-
-	MACvTransmitAC0(pDevice->PortOffset);
-
-	return true;
-}
diff --git a/drivers/staging/vt6655/wroute.h b/drivers/staging/vt6655/wroute.h
deleted file mode 100644
index e59eec9..0000000
--- a/drivers/staging/vt6655/wroute.h
+++ /dev/null
@@ -1,45 +0,0 @@
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
- * File: wroute.h
- *
- * Purpose:
- *
- * Author: Lyndon Chen
- *
- * Date: May 21, 2003
- *
- */
-
-#ifndef __WROUTE_H__
-#define __WROUTE_H__
-
-#include "device.h"
-
-/*---------------------  Export Definitions -------------------------*/
-
-/*---------------------  Export Classes  ----------------------------*/
-
-/*---------------------  Export Variables  --------------------------*/
-
-/*---------------------  Export Functions  --------------------------*/
-
-bool ROUTEbRelay(struct vnt_private *pDevice, unsigned char *pbySkbData,
-		 unsigned int uDataLen, unsigned int uNodeIndex);
-
-#endif /* __WROUTE_H__ */
-- 
2.1.0

