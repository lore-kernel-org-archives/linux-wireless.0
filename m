Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:35211 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757967AbbEaJgC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 May 2015 05:36:02 -0400
Received: by wgme6 with SMTP id e6so92489109wgm.2
        for <linux-wireless@vger.kernel.org>; Sun, 31 May 2015 02:36:00 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 4/9] staging: vt6655: remove mib.c/h dead code.
Date: Sun, 31 May 2015 10:35:23 +0100
Message-Id: <1433064928-2139-4-git-send-email-tvboxspy@gmail.com> (sfid-20150531_113610_355070_D0E4AC1B)
In-Reply-To: <1433064928-2139-1-git-send-email-tvboxspy@gmail.com>
References: <1433064928-2139-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove from makefile and dead variables

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/Makefile |   1 -
 drivers/staging/vt6655/device.h |   4 --
 drivers/staging/vt6655/mib.c    | 112 ----------------------------------------
 drivers/staging/vt6655/mib.h    |  76 ---------------------------
 4 files changed, 193 deletions(-)
 delete mode 100644 drivers/staging/vt6655/mib.c
 delete mode 100644 drivers/staging/vt6655/mib.h

diff --git a/drivers/staging/vt6655/Makefile b/drivers/staging/vt6655/Makefile
index 115b951..d55c3ba 100644
--- a/drivers/staging/vt6655/Makefile
+++ b/drivers/staging/vt6655/Makefile
@@ -11,7 +11,6 @@ vt6655_stage-y +=	device_main.o \
 	dpc.o \
 	power.o \
 	srom.o \
-	mib.o \
 	key.o \
 	rf.o
 
diff --git a/drivers/staging/vt6655/device.h b/drivers/staging/vt6655/device.h
index 62e07f5..e9c4bf3 100644
--- a/drivers/staging/vt6655/device.h
+++ b/drivers/staging/vt6655/device.h
@@ -68,7 +68,6 @@
 
 #include "device_cfg.h"
 #include "card.h"
-#include "mib.h"
 #include "srom.h"
 #include "desc.h"
 #include "key.h"
@@ -286,9 +285,6 @@ struct vnt_private {
 	unsigned char abyCurrentNetAddr[ETH_ALEN]; __aligned(2)
 	bool bLinkPass;          /* link status: OK or fail */
 
-	/* 802.11 counter */
-	SDot11Counters              s802_11Counter;
-
 	unsigned int	uCurrRSSI;
 	unsigned char byCurrSQ;
 
diff --git a/drivers/staging/vt6655/mib.c b/drivers/staging/vt6655/mib.c
deleted file mode 100644
index e9d23a7..0000000
--- a/drivers/staging/vt6655/mib.c
+++ /dev/null
@@ -1,112 +0,0 @@
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
- * File: mib.c
- *
- * Purpose: Implement MIB Data Structure
- *
- * Author: Tevin Chen
- *
- * Date: May 21, 1996
- *
- * Functions:
- *      STAvUpdateIstStatCounter - Update ISR statistic counter
- *      STAvUpdate802_11Counter - Update 802.11 mib counter
- *
- * Revision History:
- *
- */
-
-#include "mac.h"
-#include "mib.h"
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
-/*
- * Description: Update Isr Statistic Counter
- *
- * Parameters:
- *  In:
- *      pStatistic  - Pointer to Statistic Counter Data Structure
- *      wisr        - Interrupt status
- *  Out:
- *      none
- *
- * Return Value: none
- *
- */
-void STAvUpdateIsrStatCounter(PSStatCounter pStatistic, unsigned long dwIsr)
-{
-	/**********************/
-	/* ABNORMAL interrupt */
-	/**********************/
-	/* not any IMR bit invoke irq */
-
-	if (dwIsr == 0) {
-		pStatistic->ISRStat.dwIsrUnknown++;
-		return;
-	}
-
-/* Added by Kyle */
-	if (dwIsr & ISR_TXDMA0)               /* ISR, bit0 */
-		pStatistic->ISRStat.dwIsrTx0OK++;             /* TXDMA0 successful */
-
-	if (dwIsr & ISR_AC0DMA)               /* ISR, bit1 */
-		pStatistic->ISRStat.dwIsrAC0TxOK++;           /* AC0DMA successful */
-
-	if (dwIsr & ISR_BNTX)                 /* ISR, bit2 */
-		pStatistic->ISRStat.dwIsrBeaconTxOK++;        /* BeaconTx successful */
-
-	if (dwIsr & ISR_RXDMA0)               /* ISR, bit3 */
-		pStatistic->ISRStat.dwIsrRx0OK++;             /* Rx0 successful */
-
-	if (dwIsr & ISR_TBTT)                 /* ISR, bit4 */
-		pStatistic->ISRStat.dwIsrTBTTInt++;           /* TBTT successful */
-
-	if (dwIsr & ISR_SOFTTIMER)            /* ISR, bit6 */
-		pStatistic->ISRStat.dwIsrSTIMERInt++;
-
-	if (dwIsr & ISR_WATCHDOG)             /* ISR, bit7 */
-		pStatistic->ISRStat.dwIsrWatchDog++;
-
-	if (dwIsr & ISR_FETALERR)             /* ISR, bit8 */
-		pStatistic->ISRStat.dwIsrUnrecoverableError++;
-
-	if (dwIsr & ISR_SOFTINT)              /* ISR, bit9 */
-		pStatistic->ISRStat.dwIsrSoftInterrupt++;     /* software interrupt */
-
-	if (dwIsr & ISR_MIBNEARFULL)          /* ISR, bit10 */
-		pStatistic->ISRStat.dwIsrMIBNearfull++;
-
-	if (dwIsr & ISR_RXNOBUF)              /* ISR, bit11 */
-		pStatistic->ISRStat.dwIsrRxNoBuf++;           /* Rx No Buff */
-
-	if (dwIsr & ISR_RXDMA1)               /* ISR, bit12 */
-		pStatistic->ISRStat.dwIsrRx1OK++;             /* Rx1 successful */
-
-	if (dwIsr & ISR_SOFTTIMER1)           /* ISR, bit21 */
-		pStatistic->ISRStat.dwIsrSTIMER1Int++;
-}
diff --git a/drivers/staging/vt6655/mib.h b/drivers/staging/vt6655/mib.h
deleted file mode 100644
index 64ca360..0000000
--- a/drivers/staging/vt6655/mib.h
+++ /dev/null
@@ -1,76 +0,0 @@
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
- * File: mib.h
- *
- * Purpose: Implement MIB Data Structure
- *
- * Author: Tevin Chen
- *
- * Date: May 21, 1996
- *
- */
-
-#ifndef __MIB_H__
-#define __MIB_H__
-
-#include "desc.h"
-
-//
-// 802.11 counter
-//
-
-typedef struct tagSDot11Counters {
-	unsigned long long   RTSSuccessCount;
-	unsigned long long   RTSFailureCount;
-	unsigned long long   ACKFailureCount;
-	unsigned long long   FCSErrorCount;
-} SDot11Counters, *PSDot11Counters;
-
-//
-// Custom counter
-//
-typedef struct tagSISRCounters {
-	unsigned long dwIsrTx0OK;
-	unsigned long dwIsrAC0TxOK;
-	unsigned long dwIsrBeaconTxOK;
-	unsigned long dwIsrRx0OK;
-	unsigned long dwIsrTBTTInt;
-	unsigned long dwIsrSTIMERInt;
-	unsigned long dwIsrWatchDog;
-	unsigned long dwIsrUnrecoverableError;
-	unsigned long dwIsrSoftInterrupt;
-	unsigned long dwIsrMIBNearfull;
-	unsigned long dwIsrRxNoBuf;
-
-	unsigned long dwIsrUnknown;
-
-	unsigned long dwIsrRx1OK;
-	unsigned long dwIsrSTIMER1Int;
-} SISRCounters, *PSISRCounters;
-
-//
-// statistic counter
-//
-typedef struct tagSStatCounter {
-	SISRCounters ISRStat;
-} SStatCounter, *PSStatCounter;
-
-void STAvUpdateIsrStatCounter(PSStatCounter pStatistic, unsigned long dwIsr);
-
-#endif // __MIB_H__
-- 
2.1.4

