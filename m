Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:42875 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932184AbaFYUVg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2014 16:21:36 -0400
Received: by mail-wi0-f173.google.com with SMTP id cc10so8647850wib.0
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jun 2014 13:21:34 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 19/34] staging: vt6656: remove dead code datarate
Date: Wed, 25 Jun 2014 21:19:56 +0100
Message-Id: <1403727611-6825-20-git-send-email-tvboxspy@gmail.com> (sfid-20140625_222957_230318_40A90C48)
In-Reply-To: <1403727611-6825-1-git-send-email-tvboxspy@gmail.com>
References: <1403727611-6825-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/Makefile   |   1 -
 drivers/staging/vt6656/baseband.c |   1 -
 drivers/staging/vt6656/card.c     |   1 -
 drivers/staging/vt6656/channel.c  |   1 -
 drivers/staging/vt6656/datarate.c | 364 --------------------------------------
 drivers/staging/vt6656/datarate.h |  62 -------
 drivers/staging/vt6656/dpc.c      |   1 -
 drivers/staging/vt6656/main_usb.c |   1 -
 drivers/staging/vt6656/rf.c       |   1 -
 drivers/staging/vt6656/rxtx.c     |   1 -
 10 files changed, 434 deletions(-)
 delete mode 100644 drivers/staging/vt6656/datarate.c
 delete mode 100644 drivers/staging/vt6656/datarate.h

diff --git a/drivers/staging/vt6656/Makefile b/drivers/staging/vt6656/Makefile
index 0f33000..92c6aa7 100644
--- a/drivers/staging/vt6656/Makefile
+++ b/drivers/staging/vt6656/Makefile
@@ -11,7 +11,6 @@ vt6656_stage-y +=	main_usb.o \
 			rxtx.o \
 			dpc.o \
 			power.o \
-			datarate.o \
 			key.o \
 			rf.o \
 			usbpipe.o \
diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index 80240e4..e67502e 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -40,7 +40,6 @@
 #include "baseband.h"
 #include "rf.h"
 #include "usbpipe.h"
-#include "datarate.h"
 
 static u8 abyVT3184_AGC[] = {
     0x00,   //0
diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index 6652633..9a3e3ce 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -54,7 +54,6 @@
 #include "rf.h"
 #include "power.h"
 #include "key.h"
-#include "datarate.h"
 #include "usbpipe.h"
 
 //const u16 cwRXBCNTSFOff[MAX_RATE] =
diff --git a/drivers/staging/vt6656/channel.c b/drivers/staging/vt6656/channel.c
index 3317b77..db1451e 100644
--- a/drivers/staging/vt6656/channel.c
+++ b/drivers/staging/vt6656/channel.c
@@ -36,7 +36,6 @@
 
 #include <linux/kernel.h>
 #include "device.h"
-#include "datarate.h"
 #include "channel.h"
 #include "rf.h"
 
diff --git a/drivers/staging/vt6656/datarate.c b/drivers/staging/vt6656/datarate.c
deleted file mode 100644
index c44d3a0..0000000
--- a/drivers/staging/vt6656/datarate.c
+++ /dev/null
@@ -1,364 +0,0 @@
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
- * File: datarate.c
- *
- * Purpose: Handles the auto fallback & data rates functions
- *
- * Author: Lyndon Chen
- *
- * Date: July 17, 2002
- *
- * Functions:
- *      RATEvParseMaxRate - Parsing the highest basic & support rate in rate field of frame
- *      RATEvTxRateFallBack - Rate fallback Algorithm Implementaion
- *      RATEuSetIE- Set rate IE field.
- *
- * Revision History:
- *
- */
-
-#include "tmacro.h"
-#include "mac.h"
-#include "80211mgr.h"
-#include "bssdb.h"
-#include "datarate.h"
-#include "card.h"
-#include "baseband.h"
-#include "rf.h"
-
-/* static int msglevel = MSG_LEVEL_DEBUG; */
-static int msglevel = MSG_LEVEL_INFO;
-static const u8 acbyIERate[MAX_RATE] = {0x02, 0x04, 0x0B, 0x16, 0x0C, 0x12, 0x18,
-	0x24, 0x30, 0x48, 0x60, 0x6C};
-
-#define AUTORATE_TXOK_CNT       0x0400
-#define AUTORATE_TXFAIL_CNT     0x0064
-#define AUTORATE_TIMEOUT        10
-
-void s_vResetCounter(PKnownNodeDB psNodeDBTable);
-
-void s_vResetCounter(PKnownNodeDB psNodeDBTable)
-{
-	u8 ii;
-
-	/* clear statistics counter for auto_rate */
-	for (ii = 0; ii <= MAX_RATE; ii++) {
-		psNodeDBTable->uTxOk[ii] = 0;
-		psNodeDBTable->uTxFail[ii] = 0;
-	}
-}
-
-/*+
- *
- * Routine Description:
- *      Rate fallback Algorithm Implementaion
- *
- * Parameters:
- *  In:
- *      pDevice         - Pointer to the adapter
- *      psNodeDBTable   - Pointer to Node Data Base
- *  Out:
- *      none
- *
- * Return Value: none
- *
--*/
-#define AUTORATE_TXCNT_THRESHOLD        20
-#define AUTORATE_INC_THRESHOLD          30
-
-/*+
- *
- * Description:
- *      Get RateIdx from the value in SuppRates IE or ExtSuppRates IE
- *
- * Parameters:
- *  In:
- *      u8    - Rate value in SuppRates IE or ExtSuppRates IE
- *  Out:
- *      none
- *
- * Return Value: RateIdx
- *
--*/
-u16 RATEwGetRateIdx(u8 byRate)
-{
-	u16 ii;
-
-	/* erase BasicRate flag */
-	byRate = byRate & 0x7F;
-
-	for (ii = 0; ii < MAX_RATE; ii++) {
-		if (acbyIERate[ii] == byRate)
-			return ii;
-	}
-	return 0;
-}
-
-/*+
- *
- * Description:
- *      Parsing the highest basic & support rate in rate field of frame.
- *
- * Parameters:
- *  In:
- *      pDevice         - Pointer to the adapter
- *      pItemRates      - Pointer to Rate field defined in 802.11 spec.
- *      pItemExtRates      - Pointer to Extended Rate field defined in 802.11 spec.
- *  Out:
- *      pwMaxBasicRate  - Maximum Basic Rate
- *      pwMaxSuppRate   - Maximum Supported Rate
- *      pbyTopCCKRate   - Maximum Basic Rate in CCK mode
- *      pbyTopOFDMRate  - Maximum Basic Rate in OFDM mode
- *
- * Return Value: none
- *
--*/
-
-void RATEvParseMaxRate(struct vnt_private *pDevice,
-	PWLAN_IE_SUPP_RATES pItemRates, PWLAN_IE_SUPP_RATES pItemExtRates,
-	int bUpdateBasicRate, u16 *pwMaxBasicRate, u16 *pwMaxSuppRate,
-	u16 *pwSuppRate, u8 *pbyTopCCKRate, u8 *pbyTopOFDMRate)
-{
-	int ii;
-	u8 byHighSuppRate = 0, byRate = 0;
-	u16 wOldBasicRate = pDevice->wBasicRate;
-	u32 uRateLen;
-
-	if (pItemRates == NULL)
-		return;
-
-	*pwSuppRate = 0;
-	uRateLen = pItemRates->len;
-
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"ParseMaxRate Len: %d\n", uRateLen);
-	if (pDevice->byBBType != BB_TYPE_11B) {
-		if (uRateLen > WLAN_RATES_MAXLEN)
-			uRateLen = WLAN_RATES_MAXLEN;
-	} else {
-		if (uRateLen > WLAN_RATES_MAXLEN_11B)
-			uRateLen = WLAN_RATES_MAXLEN_11B;
-	}
-
-	for (ii = 0; ii < uRateLen; ii++) {
-		byRate = (u8)(pItemRates->abyRates[ii]);
-		if (WLAN_MGMT_IS_BASICRATE(byRate) &&
-				(bUpdateBasicRate == true)) {
-			/*
-			 * add to basic rate set, update pDevice->byTopCCKBasicRate and
-			 * pDevice->byTopOFDMBasicRate
-			 */
-			vnt_add_basic_rate(pDevice, RATEwGetRateIdx(byRate));
-			DBG_PRT(MSG_LEVEL_DEBUG,
-				KERN_INFO"ParseMaxRate AddBasicRate: %d\n",
-				RATEwGetRateIdx(byRate));
-		}
-		byRate = (u8)(pItemRates->abyRates[ii]&0x7F);
-		if (byHighSuppRate == 0)
-			byHighSuppRate = byRate;
-		if (byRate > byHighSuppRate)
-			byHighSuppRate = byRate;
-		*pwSuppRate |= (1<<RATEwGetRateIdx(byRate));
-	}
-	if ((pItemExtRates != NULL) && (pItemExtRates->byElementID == WLAN_EID_EXTSUPP_RATES) &&
-			(pDevice->byBBType != BB_TYPE_11B)) {
-
-		unsigned int uExtRateLen = pItemExtRates->len;
-
-		if (uExtRateLen > WLAN_RATES_MAXLEN)
-			uExtRateLen = WLAN_RATES_MAXLEN;
-
-		for (ii = 0; ii < uExtRateLen; ii++) {
-			byRate = (u8)(pItemExtRates->abyRates[ii]);
-			/* select highest basic rate */
-			if (WLAN_MGMT_IS_BASICRATE(pItemExtRates->abyRates[ii])) {
-				/*
-				 * add to basic rate set, update pDevice->byTopCCKBasicRate and
-				 * pDevice->byTopOFDMBasicRate
-				 */
-				vnt_add_basic_rate(pDevice, RATEwGetRateIdx(byRate));
-				DBG_PRT(MSG_LEVEL_DEBUG,
-						KERN_INFO"ParseMaxRate AddBasicRate: %d\n",
-						RATEwGetRateIdx(byRate));
-			}
-			byRate = (u8)(pItemExtRates->abyRates[ii]&0x7F);
-			if (byHighSuppRate == 0)
-				byHighSuppRate = byRate;
-			if (byRate > byHighSuppRate)
-				byHighSuppRate = byRate;
-			*pwSuppRate |= (1<<RATEwGetRateIdx(byRate));
-
-			/* DBG_PRN_GRP09(("ParseMaxRate : HighSuppRate: %d, %X\n",
-			 * RATEwGetRateIdx(byRate), byRate));
-			 */
-		}
-	}
-
-	if ((pDevice->byPacketType == PK_TYPE_11GB)
-			&& vnt_ofdm_min_rate(pDevice)) {
-		pDevice->byPacketType = PK_TYPE_11GA;
-	}
-
-	*pbyTopCCKRate = pDevice->byTopCCKBasicRate;
-	*pbyTopOFDMRate = pDevice->byTopOFDMBasicRate;
-	*pwMaxSuppRate = RATEwGetRateIdx(byHighSuppRate);
-	if ((pDevice->byPacketType == PK_TYPE_11B) || (pDevice->byPacketType == PK_TYPE_11GB))
-		*pwMaxBasicRate = pDevice->byTopCCKBasicRate;
-	else
-		*pwMaxBasicRate = pDevice->byTopOFDMBasicRate;
-	if (wOldBasicRate != pDevice->wBasicRate)
-		vnt_set_rspinf(pDevice, pDevice->byBBType);
-
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Exit ParseMaxRate\n");
-}
-
-/*+
- *
- * Routine Description:
- *      Rate fallback Algorithm Implementaion
- *
- * Parameters:
- *  In:
- *      pDevice         - Pointer to the adapter
- *      psNodeDBTable   - Pointer to Node Data Base
- *  Out:
- *      none
- *
- * Return Value: none
- *
--*/
-#define AUTORATE_TXCNT_THRESHOLD        20
-#define AUTORATE_INC_THRESHOLD          30
-
-void RATEvTxRateFallBack(struct vnt_private *pDevice,
-	PKnownNodeDB psNodeDBTable)
-{
-	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
-	u16 wIdxDownRate = 0;
-	int ii;
-	int bAutoRate[MAX_RATE] = {true, true, true, true, false, false, true,
-					 true, true, true, true, true};
-	u32 dwThroughputTbl[MAX_RATE] = {10, 20, 55, 110, 60, 90, 120, 180,
-		240, 360, 480, 540};
-	u32 dwThroughput = 0;
-	u16 wIdxUpRate = 0;
-	u32 dwTxDiff = 0;
-
-	if (pMgmt->eScanState != WMAC_NO_SCANNING)
-		return; /* Don't do Fallback when scanning Channel */
-
-	psNodeDBTable->uTimeCount++;
-
-	if (psNodeDBTable->uTxFail[MAX_RATE] > psNodeDBTable->uTxOk[MAX_RATE])
-		dwTxDiff = psNodeDBTable->uTxFail[MAX_RATE] - psNodeDBTable->uTxOk[MAX_RATE];
-
-	if ((psNodeDBTable->uTxOk[MAX_RATE] < AUTORATE_TXOK_CNT) &&
-			(dwTxDiff < AUTORATE_TXFAIL_CNT) &&
-			(psNodeDBTable->uTimeCount < AUTORATE_TIMEOUT)) {
-		return;
-	}
-
-	if (psNodeDBTable->uTimeCount >= AUTORATE_TIMEOUT)
-		psNodeDBTable->uTimeCount = 0;
-
-	for (ii = 0; ii < MAX_RATE; ii++) {
-		if (psNodeDBTable->wSuppRate & (0x0001<<ii)) {
-			if (bAutoRate[ii] == true)
-				wIdxUpRate = (u16) ii;
-		} else {
-			bAutoRate[ii] = false;
-		}
-	}
-
-	for (ii = 0; ii <= psNodeDBTable->wTxDataRate; ii++) {
-		if ((psNodeDBTable->uTxOk[ii] != 0) ||
-				(psNodeDBTable->uTxFail[ii] != 0)) {
-			dwThroughputTbl[ii] *= psNodeDBTable->uTxOk[ii];
-			if (ii < RATE_11M)
-				psNodeDBTable->uTxFail[ii] *= 4;
-			dwThroughputTbl[ii] /= (psNodeDBTable->uTxOk[ii] + psNodeDBTable->uTxFail[ii]);
-		}
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Rate %d,Ok: %d, Fail:%d, Throughput:%d\n",
-				ii, (int)psNodeDBTable->uTxOk[ii], (int)psNodeDBTable->uTxFail[ii], (int)dwThroughputTbl[ii]);
-	}
-	dwThroughput = dwThroughputTbl[psNodeDBTable->wTxDataRate];
-
-	wIdxDownRate = psNodeDBTable->wTxDataRate;
-	for (ii = psNodeDBTable->wTxDataRate; ii > 0;) {
-		ii--;
-		if ((dwThroughputTbl[ii] > dwThroughput) &&
-				(bAutoRate[ii] == true)) {
-			dwThroughput = dwThroughputTbl[ii];
-			wIdxDownRate = (u16) ii;
-		}
-	}
-	psNodeDBTable->wTxDataRate = wIdxDownRate;
-	if (psNodeDBTable->uTxOk[MAX_RATE]) {
-		if (psNodeDBTable->uTxOk[MAX_RATE] >
-				(psNodeDBTable->uTxFail[MAX_RATE] * 4)) {
-			psNodeDBTable->wTxDataRate = wIdxUpRate;
-		}
-	} else { /* adhoc, if uTxOk(total) == 0 & uTxFail(total) == 0 */
-		if (psNodeDBTable->uTxFail[MAX_RATE] == 0)
-			psNodeDBTable->wTxDataRate = wIdxUpRate;
-	}
-
-	if (pDevice->byBBType == BB_TYPE_11A) {
-		if (psNodeDBTable->wTxDataRate <= RATE_11M)
-			psNodeDBTable->wTxDataRate = RATE_6M;
-	}
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"uTxOk[MAX_RATE] %d, uTxFail[MAX_RATE]:%d\n", (int)psNodeDBTable->uTxOk[MAX_RATE], (int)psNodeDBTable->uTxFail[MAX_RATE]);
-	s_vResetCounter(psNodeDBTable);
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Rate: %d, U:%d, D:%d\n", (int)psNodeDBTable->wTxDataRate, (int)wIdxUpRate, (int)wIdxDownRate);
-	return;
-}
-
-/*+
- *
- * Description:
- *    This routine is used to assemble available Rate IE.
- *
- * Parameters:
- *  In:
- *    pDevice
- *  Out:
- *
- * Return Value: None
- *
--*/
-u8 RATEuSetIE(PWLAN_IE_SUPP_RATES pSrcRates, PWLAN_IE_SUPP_RATES pDstRates,
-		unsigned int uRateLen)
-{
-	unsigned int ii, uu, uRateCnt = 0;
-
-	if ((pSrcRates == NULL) || (pDstRates == NULL))
-		return 0;
-
-	if (pSrcRates->len == 0)
-		return 0;
-
-	for (ii = 0; ii < uRateLen; ii++) {
-		for (uu = 0; uu < pSrcRates->len; uu++) {
-			if ((pSrcRates->abyRates[uu] & 0x7F) == acbyIERate[ii]) {
-				pDstRates->abyRates[uRateCnt++] = pSrcRates->abyRates[uu];
-				break;
-			}
-		}
-	}
-	return (u8)uRateCnt;
-}
diff --git a/drivers/staging/vt6656/datarate.h b/drivers/staging/vt6656/datarate.h
deleted file mode 100644
index 19b2c66..0000000
--- a/drivers/staging/vt6656/datarate.h
+++ /dev/null
@@ -1,62 +0,0 @@
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
- * File: datarate.h
- *
- * Purpose: Handles the auto fallback & data rates functions
- *
- * Author: Lyndon Chen
- *
- * Date: July 16, 2002
- *
- */
-#ifndef __DATARATE_H__
-#define __DATARATE_H__
-
-#define FALLBACK_PKT_COLLECT_TR_H  50   /* pkts */
-#define FALLBACK_PKT_COLLECT_TR_L  10   /* pkts */
-#define FALLBACK_POLL_SECOND       5    /* 5 sec */
-#define FALLBACK_RECOVER_SECOND    30   /* 30 sec */
-#define FALLBACK_THRESHOLD         15   /* percent */
-#define UPGRADE_THRESHOLD          5    /* percent */
-#define UPGRADE_CNT_THRD           3    /* times */
-#define RETRY_TIMES_THRD_H         2    /* times */
-#define RETRY_TIMES_THRD_L         1    /* times */
-
-void RATEvParseMaxRate(struct vnt_private *, PWLAN_IE_SUPP_RATES pItemRates,
-	PWLAN_IE_SUPP_RATES pItemExtRates, int bUpdateBasicRate,
-	u16 *pwMaxBasicRate, u16 *pwMaxSuppRate, u16 *pwSuppRate,
-	u8 *pbyTopCCKRate, u8 *pbyTopOFDMRate);
-
-void RATEvTxRateFallBack(struct vnt_private *pDevice,
-	PKnownNodeDB psNodeDBTable);
-
-u8
-RATEuSetIE(
-     PWLAN_IE_SUPP_RATES pSrcRates,
-     PWLAN_IE_SUPP_RATES pDstRates,
-     unsigned int                uRateLen
-    );
-
-u16
-RATEwGetRateIdx(
-     u8 byRate
-    );
-
-#endif /* __DATARATE_H__ */
diff --git a/drivers/staging/vt6656/dpc.c b/drivers/staging/vt6656/dpc.c
index 60230f2..f40d6b4 100644
--- a/drivers/staging/vt6656/dpc.c
+++ b/drivers/staging/vt6656/dpc.c
@@ -43,7 +43,6 @@
 #include "mac.h"
 #include "baseband.h"
 #include "rf.h"
-#include "datarate.h"
 #include "usbpipe.h"
 
 //static int          msglevel                =MSG_LEVEL_DEBUG;
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index d9e766b..26fac20 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -57,7 +57,6 @@
 #include "rxtx.h"
 #include "bssdb.h"
 #include "dpc.h"
-#include "datarate.h"
 #include "rf.h"
 #include "firmware.h"
 #include "usbpipe.h"
diff --git a/drivers/staging/vt6656/rf.c b/drivers/staging/vt6656/rf.c
index 6bfd272..8c2c2bd 100644
--- a/drivers/staging/vt6656/rf.c
+++ b/drivers/staging/vt6656/rf.c
@@ -39,7 +39,6 @@
 #include "rf.h"
 #include "baseband.h"
 #include "usbpipe.h"
-#include "datarate.h"
 
 #define BY_AL2230_REG_LEN     23 //24bit
 #define CB_AL2230_INIT_SEQ    15
diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 57c2b94..492d9c3 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -49,7 +49,6 @@
 #include "bssdb.h"
 #include "mac.h"
 #include "rf.h"
-#include "datarate.h"
 #include "usbpipe.h"
 
 static int          msglevel                = MSG_LEVEL_INFO;
-- 
1.9.1

