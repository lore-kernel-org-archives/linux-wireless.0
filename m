Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:43572 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756555AbaJ2R52 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 13:57:28 -0400
Received: by mail-wg0-f51.google.com with SMTP id l18so3919631wgh.10
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2014 10:57:27 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH v2 15/48] staging: vt6655: dead code datarate.c/h
Date: Wed, 29 Oct 2014 17:55:33 +0000
Message-Id: <1414605366-9335-16-git-send-email-tvboxspy@gmail.com> (sfid-20141029_185746_481474_62688417)
In-Reply-To: <1414605366-9335-1-git-send-email-tvboxspy@gmail.com>
References: <1414605366-9335-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/Makefile      |   1 -
 drivers/staging/vt6655/datarate.c    | 410 -----------------------------------
 drivers/staging/vt6655/datarate.h    |  78 -------
 drivers/staging/vt6655/device_main.c |   1 -
 drivers/staging/vt6655/vntwifi.c     |  14 --
 5 files changed, 504 deletions(-)
 delete mode 100644 drivers/staging/vt6655/datarate.c
 delete mode 100644 drivers/staging/vt6655/datarate.h

diff --git a/drivers/staging/vt6655/Makefile b/drivers/staging/vt6655/Makefile
index 2c0b7932..3c993a8 100644
--- a/drivers/staging/vt6655/Makefile
+++ b/drivers/staging/vt6655/Makefile
@@ -12,7 +12,6 @@ vt6655_stage-y +=	device_main.o \
 	rxtx.o \
 	dpc.o \
 	power.o \
-	datarate.o \
 	srom.o \
 	mib.o \
 	rc4.o \
diff --git a/drivers/staging/vt6655/datarate.c b/drivers/staging/vt6655/datarate.c
deleted file mode 100644
index 52907a4..0000000
--- a/drivers/staging/vt6655/datarate.c
+++ /dev/null
@@ -1,410 +0,0 @@
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
-#include "ttype.h"
-#include "tmacro.h"
-#include "mac.h"
-#include "80211mgr.h"
-#include "bssdb.h"
-#include "datarate.h"
-#include "card.h"
-#include "baseband.h"
-#include "srom.h"
-
-/*---------------------  Static Definitions -------------------------*/
-
-/*---------------------  Static Classes  ----------------------------*/
-
-extern unsigned short TxRate_iwconfig; /* 2008-5-8 <add> by chester */
-/*---------------------  Static Variables  --------------------------*/
-static const unsigned char acbyIERate[MAX_RATE] = {
-0x02, 0x04, 0x0B, 0x16, 0x0C, 0x12, 0x18, 0x24, 0x30, 0x48, 0x60, 0x6C
-};
-
-#define AUTORATE_TXOK_CNT       0x0400
-#define AUTORATE_TXFAIL_CNT     0x0064
-#define AUTORATE_TIMEOUT        10
-
-/*---------------------  Static Functions  --------------------------*/
-
-void s_vResetCounter(
-	PKnownNodeDB psNodeDBTable
-);
-
-void
-s_vResetCounter(
-	PKnownNodeDB psNodeDBTable
-)
-{
-	unsigned char ii;
-
-	/* clear statistic counter for auto_rate */
-	for (ii = 0; ii <= MAX_RATE; ii++) {
-		psNodeDBTable->uTxOk[ii] = 0;
-		psNodeDBTable->uTxFail[ii] = 0;
-	}
-}
-
-/*---------------------  Export Variables  --------------------------*/
-
-/*---------------------  Export Functions  --------------------------*/
-
-/*+
- *
- * Description:
- *      Get RateIdx from the value in SuppRates IE or ExtSuppRates IE
- *
- * Parameters:
- *  In:
- *      unsigned char - Rate value in SuppRates IE or ExtSuppRates IE
- *  Out:
- *      none
- *
- * Return Value: RateIdx
- *
- -*/
-unsigned char
-DATARATEbyGetRateIdx(
-	unsigned char byRate
-)
-{
-	unsigned char ii;
-
-	/* Erase basicRate flag. */
-	byRate = byRate & 0x7F;/* 0111 1111 */
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
- * Routine Description:
- *      Rate fallback Algorithm Implementation
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
- -*/
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
- *      unsigned char - Rate value in SuppRates IE or ExtSuppRates IE
- *  Out:
- *      none
- *
- * Return Value: RateIdx
- *
- -*/
-unsigned short
-wGetRateIdx(
-	unsigned char byRate
-)
-{
-	unsigned short ii;
-
-	/* Erase basicRate flag. */
-	byRate = byRate & 0x7F;/* 0111 1111 */
-
-	for (ii = 0; ii < MAX_RATE; ii++) {
-		if (acbyIERate[ii] == byRate)
-			return ii;
-	}
-
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
- -*/
-void
-RATEvParseMaxRate(
-	void *pDeviceHandler,
-	PWLAN_IE_SUPP_RATES pItemRates,
-	PWLAN_IE_SUPP_RATES pItemExtRates,
-	bool bUpdateBasicRate,
-	unsigned short *pwMaxBasicRate,
-	unsigned short *pwMaxSuppRate,
-	unsigned short *pwSuppRate,
-	unsigned char *pbyTopCCKRate,
-	unsigned char *pbyTopOFDMRate
-)
-{
-	struct vnt_private *pDevice = pDeviceHandler;
-	unsigned int ii;
-	unsigned char byHighSuppRate = 0;
-	unsigned char byRate = 0;
-	unsigned short wOldBasicRate = pDevice->wBasicRate;
-	unsigned int uRateLen;
-
-	if (pItemRates == NULL)
-		return;
-
-	*pwSuppRate = 0;
-	uRateLen = pItemRates->len;
-
-	pr_debug("ParseMaxRate Len: %d\n", uRateLen);
-	if (pDevice->eCurrentPHYType != PHY_TYPE_11B) {
-		if (uRateLen > WLAN_RATES_MAXLEN)
-			uRateLen = WLAN_RATES_MAXLEN;
-	} else {
-		if (uRateLen > WLAN_RATES_MAXLEN_11B)
-			uRateLen = WLAN_RATES_MAXLEN_11B;
-	}
-
-	for (ii = 0; ii < uRateLen; ii++) {
-		byRate = (unsigned char)(pItemRates->abyRates[ii]);
-		if (WLAN_MGMT_IS_BASICRATE(byRate) && bUpdateBasicRate)  {
-			/* Add to basic rate set, update pDevice->byTopCCKBasicRate and pDevice->byTopOFDMBasicRate */
-			CARDbAddBasicRate((void *)pDevice, wGetRateIdx(byRate));
-			pr_debug("ParseMaxRate AddBasicRate: %d\n",
-				 wGetRateIdx(byRate));
-		}
-		byRate = (unsigned char)(pItemRates->abyRates[ii]&0x7F);
-		if (byHighSuppRate == 0)
-			byHighSuppRate = byRate;
-		if (byRate > byHighSuppRate)
-			byHighSuppRate = byRate;
-		*pwSuppRate |= (1<<wGetRateIdx(byRate));
-	}
-	if ((pItemExtRates != NULL) && (pItemExtRates->byElementID == WLAN_EID_EXTSUPP_RATES) &&
-	    (pDevice->eCurrentPHYType != PHY_TYPE_11B)) {
-		unsigned int uExtRateLen = pItemExtRates->len;
-
-		if (uExtRateLen > WLAN_RATES_MAXLEN)
-			uExtRateLen = WLAN_RATES_MAXLEN;
-
-		for (ii = 0; ii < uExtRateLen; ii++) {
-			byRate = (unsigned char)(pItemExtRates->abyRates[ii]);
-			/* select highest basic rate */
-			if (WLAN_MGMT_IS_BASICRATE(pItemExtRates->abyRates[ii])) {
-				/* Add to basic rate set, update pDevice->byTopCCKBasicRate and pDevice->byTopOFDMBasicRate */
-				CARDbAddBasicRate((void *)pDevice, wGetRateIdx(byRate));
-				pr_debug("ParseMaxRate AddBasicRate: %d\n",
-					 wGetRateIdx(byRate));
-			}
-			byRate = (unsigned char)(pItemExtRates->abyRates[ii]&0x7F);
-			if (byHighSuppRate == 0)
-				byHighSuppRate = byRate;
-			if (byRate > byHighSuppRate)
-				byHighSuppRate = byRate;
-			*pwSuppRate |= (1<<wGetRateIdx(byRate));
-		}
-	}
-
-	if ((pDevice->byPacketType == PK_TYPE_11GB) && CARDbIsOFDMinBasicRate((void *)pDevice))
-		pDevice->byPacketType = PK_TYPE_11GA;
-
-	*pbyTopCCKRate = pDevice->byTopCCKBasicRate;
-	*pbyTopOFDMRate = pDevice->byTopOFDMBasicRate;
-	*pwMaxSuppRate = wGetRateIdx(byHighSuppRate);
-	if ((pDevice->byPacketType == PK_TYPE_11B) || (pDevice->byPacketType == PK_TYPE_11GB))
-		*pwMaxBasicRate = pDevice->byTopCCKBasicRate;
-	else
-		*pwMaxBasicRate = pDevice->byTopOFDMBasicRate;
-	if (wOldBasicRate != pDevice->wBasicRate)
-		CARDvSetRSPINF((void *)pDevice, pDevice->eCurrentPHYType);
-
-	pr_debug("Exit ParseMaxRate\n");
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
- -*/
-#define AUTORATE_TXCNT_THRESHOLD        20
-#define AUTORATE_INC_THRESHOLD          30
-
-void
-RATEvTxRateFallBack(
-	void *pDeviceHandler,
-	PKnownNodeDB psNodeDBTable
-)
-{
-	struct vnt_private *pDevice = pDeviceHandler;
-	unsigned short wIdxDownRate = 0;
-	unsigned int ii;
-	bool bAutoRate[MAX_RATE]    = {true, true, true, true, false, false, true, true, true, true, true, true};
-	unsigned long dwThroughputTbl[MAX_RATE] = {10, 20, 55, 110, 60, 90, 120, 180, 240, 360, 480, 540};
-	unsigned long dwThroughput = 0;
-	unsigned short wIdxUpRate = 0;
-	unsigned long dwTxDiff = 0;
-
-	if (pDevice->pMgmt->eScanState != WMAC_NO_SCANNING)
-		/* Don't do Fallback when scanning Channel */
-		return;
-
-	psNodeDBTable->uTimeCount++;
-
-	if (psNodeDBTable->uTxFail[MAX_RATE] > psNodeDBTable->uTxOk[MAX_RATE])
-		dwTxDiff = psNodeDBTable->uTxFail[MAX_RATE] - psNodeDBTable->uTxOk[MAX_RATE];
-
-	if ((psNodeDBTable->uTxOk[MAX_RATE] < AUTORATE_TXOK_CNT) &&
-	    (dwTxDiff < AUTORATE_TXFAIL_CNT) &&
-	    (psNodeDBTable->uTimeCount < AUTORATE_TIMEOUT)) {
-		return;
-	}
-
-	if (psNodeDBTable->uTimeCount >= AUTORATE_TIMEOUT)
-		psNodeDBTable->uTimeCount = 0;
-
-	for (ii = 0; ii < MAX_RATE; ii++) {
-		if (psNodeDBTable->wSuppRate & (0x0001<<ii)) {
-			if (bAutoRate[ii])
-				wIdxUpRate = (unsigned short) ii;
-
-		} else {
-			bAutoRate[ii] = false;
-		}
-	}
-
-	for (ii = 0; ii <= psNodeDBTable->wTxDataRate; ii++) {
-		if ((psNodeDBTable->uTxOk[ii] != 0) ||
-		    (psNodeDBTable->uTxFail[ii] != 0)) {
-			dwThroughputTbl[ii] *= psNodeDBTable->uTxOk[ii];
-			if (ii < RATE_11M)
-				psNodeDBTable->uTxFail[ii] *= 4;
-
-			dwThroughputTbl[ii] /= (psNodeDBTable->uTxOk[ii] + psNodeDBTable->uTxFail[ii]);
-		}
-	}
-	dwThroughput = dwThroughputTbl[psNodeDBTable->wTxDataRate];
-
-	wIdxDownRate = psNodeDBTable->wTxDataRate;
-	for (ii = psNodeDBTable->wTxDataRate; ii > 0;) {
-		ii--;
-		if ((dwThroughputTbl[ii] > dwThroughput) && bAutoRate[ii]) {
-			dwThroughput = dwThroughputTbl[ii];
-			wIdxDownRate = (unsigned short) ii;
-		}
-	}
-	psNodeDBTable->wTxDataRate = wIdxDownRate;
-	if (psNodeDBTable->uTxOk[MAX_RATE]) {
-		if (psNodeDBTable->uTxOk[MAX_RATE] >
-		    (psNodeDBTable->uTxFail[MAX_RATE] * 4)) {
-			psNodeDBTable->wTxDataRate = wIdxUpRate;
-		}
-	} else {
-		/* adhoc, if uTxOk =0 & uTxFail = 0 */
-		if (psNodeDBTable->uTxFail[MAX_RATE] == 0)
-			psNodeDBTable->wTxDataRate = wIdxUpRate;
-	}
-
-	/* 2008-5-8 <add> by chester */
-	TxRate_iwconfig = psNodeDBTable->wTxDataRate;
-	s_vResetCounter(psNodeDBTable);
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
- -*/
-unsigned char
-RATEuSetIE(
-	PWLAN_IE_SUPP_RATES pSrcRates,
-	PWLAN_IE_SUPP_RATES pDstRates,
-	unsigned int uRateLen
-)
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
-	return (unsigned char)uRateCnt;
-}
diff --git a/drivers/staging/vt6655/datarate.h b/drivers/staging/vt6655/datarate.h
deleted file mode 100644
index d55b074..0000000
--- a/drivers/staging/vt6655/datarate.h
+++ /dev/null
@@ -1,78 +0,0 @@
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
-#define FALLBACK_PKT_COLLECT_TR_H  50
-#define FALLBACK_PKT_COLLECT_TR_L  10
-#define FALLBACK_POLL_SECOND       5
-#define FALLBACK_RECOVER_SECOND    30
-#define FALLBACK_THRESHOLD         15
-#define UPGRADE_THRESHOLD          5
-#define UPGRADE_CNT_THRD           3
-#define RETRY_TIMES_THRD_H         2
-#define RETRY_TIMES_THRD_L         1
-
-void
-RATEvParseMaxRate(
-	void *pDeviceHandler,
-	PWLAN_IE_SUPP_RATES pItemRates,
-	PWLAN_IE_SUPP_RATES pItemExtRates,
-	bool bUpdateBasicRate,
-	unsigned short *pwMaxBasicRate,
-	unsigned short *pwMaxSuppRate,
-	unsigned short *pwSuppRate,
-	unsigned char *pbyTopCCKRate,
-	unsigned char *pbyTopOFDMRate
-);
-
-void
-RATEvTxRateFallBack(
-	void *pDeviceHandler,
-	PKnownNodeDB psNodeDBTable
-);
-
-unsigned char
-RATEuSetIE(
-	PWLAN_IE_SUPP_RATES pSrcRates,
-	PWLAN_IE_SUPP_RATES pDstRates,
-	unsigned int uRateLen
-);
-
-unsigned short
-wGetRateIdx(
-	unsigned char byRate
-);
-
-unsigned char
-DATARATEbyGetRateIdx(
-	unsigned char byRate
-);
-
-#endif /* __DATARATE_H__ */
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 991a276..848c258 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -69,7 +69,6 @@
 #include "wroute.h"
 #include "bssdb.h"
 #include "dpc.h"
-#include "datarate.h"
 #include "rf.h"
 #include "iowpa.h"
 #include <linux/delay.h>
diff --git a/drivers/staging/vt6655/vntwifi.c b/drivers/staging/vt6655/vntwifi.c
index 85374de..27e055e 100644
--- a/drivers/staging/vt6655/vntwifi.c
+++ b/drivers/staging/vt6655/vntwifi.c
@@ -36,7 +36,6 @@
 #include "country.h"
 #include "device.h"
 #include "wmgr.h"
-#include "datarate.h"
 
 /*---------------------  Static Definitions -------------------------*/
 
@@ -210,7 +209,6 @@ VNTWIFIbyGetMaxSupportRate(
 
 	if (pSupportRateIEs) {
 		for (ii = 0; ii < pSupportRateIEs->len; ii++) {
-			bySupportRate = DATARATEbyGetRateIdx(pSupportRateIEs->abyRates[ii]);
 			if (bySupportRate > byMaxSupportRate)
 				byMaxSupportRate = bySupportRate;
 
@@ -218,7 +216,6 @@ VNTWIFIbyGetMaxSupportRate(
 	}
 	if (pExtSupportRateIEs) {
 		for (ii = 0; ii < pExtSupportRateIEs->len; ii++) {
-			bySupportRate = DATARATEbyGetRateIdx(pExtSupportRateIEs->abyRates[ii]);
 			if (bySupportRate > byMaxSupportRate)
 				byMaxSupportRate = bySupportRate;
 
@@ -252,7 +249,6 @@ VNTWIFIbyGetACKTxRate(
 )
 {
 	unsigned char byMaxAckRate;
-	unsigned char byBasicRate;
 	unsigned int ii;
 
 	if (byRxDataRate <= RATE_11M) {
@@ -264,22 +260,12 @@ VNTWIFIbyGetACKTxRate(
 	if (pSupportRateIEs) {
 		for (ii = 0; ii < pSupportRateIEs->len; ii++) {
 			if (pSupportRateIEs->abyRates[ii] & 0x80) {
-				byBasicRate = DATARATEbyGetRateIdx(pSupportRateIEs->abyRates[ii]);
-				if ((byBasicRate <= byRxDataRate) &&
-				    (byBasicRate > byMaxAckRate))  {
-					byMaxAckRate = byBasicRate;
-				}
 			}
 		}
 	}
 	if (pExtSupportRateIEs) {
 		for (ii = 0; ii < pExtSupportRateIEs->len; ii++) {
 			if (pExtSupportRateIEs->abyRates[ii] & 0x80) {
-				byBasicRate = DATARATEbyGetRateIdx(pExtSupportRateIEs->abyRates[ii]);
-				if ((byBasicRate <= byRxDataRate) &&
-				    (byBasicRate > byMaxAckRate))  {
-					byMaxAckRate = byBasicRate;
-				}
 			}
 		}
 	}
-- 
2.1.0

