Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:40199 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400Ab3LKVZr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Dec 2013 16:25:47 -0500
Received: by mail-wi0-f173.google.com with SMTP id hn9so7742775wib.6
        for <linux-wireless@vger.kernel.org>; Wed, 11 Dec 2013 13:25:46 -0800 (PST)
Message-ID: <1386797138.7790.10.camel@canaries64-MCP7A> (sfid-20131211_222606_925478_576F9EAA)
Subject: [PATCH 2/2] staging: vt6656: dead code remove mib.c mic.h from
 driver.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Wed, 11 Dec 2013 21:25:38 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As result of patch
staging: vt6656: Remove unused scStatistic data from driver.

mib.c mic.h is dead code

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/Makefile |   1 -
 drivers/staging/vt6656/bssdb.h  |   1 -
 drivers/staging/vt6656/device.h |   1 -
 drivers/staging/vt6656/int.c    |   1 -
 drivers/staging/vt6656/mib.c    | 400 ----------------------------------------
 drivers/staging/vt6656/mib.h    | 374 -------------------------------------
 6 files changed, 778 deletions(-)
 delete mode 100644 drivers/staging/vt6656/mib.c
 delete mode 100644 drivers/staging/vt6656/mib.h

diff --git a/drivers/staging/vt6656/Makefile b/drivers/staging/vt6656/Makefile
index c998547..1d829b4 100644
--- a/drivers/staging/vt6656/Makefile
+++ b/drivers/staging/vt6656/Makefile
@@ -16,7 +16,6 @@ vt6656_stage-y +=	main_usb.o \
 			dpc.o \
 			power.o \
 			datarate.o \
-			mib.o \
 			rc4.o \
 			tether.o \
 			tcrc.o \
diff --git a/drivers/staging/vt6656/bssdb.h b/drivers/staging/vt6656/bssdb.h
index 8b28ef6..8df3fb2 100644
--- a/drivers/staging/vt6656/bssdb.h
+++ b/drivers/staging/vt6656/bssdb.h
@@ -34,7 +34,6 @@
 #include "80211hdr.h"
 #include "80211mgr.h"
 #include "card.h"
-#include "mib.h"
 
 #define MAX_NODE_NUM             64
 #define MAX_BSS_NUM              42
diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 7dfe89d..95b4fa1 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -70,7 +70,6 @@
 #include "tether.h"
 #include "wmgr.h"
 #include "wcmd.h"
-#include "mib.h"
 #include "srom.h"
 #include "rc4.h"
 #include "desc.h"
diff --git a/drivers/staging/vt6656/int.c b/drivers/staging/vt6656/int.c
index a2778a4..e0e9386 100644
--- a/drivers/staging/vt6656/int.c
+++ b/drivers/staging/vt6656/int.c
@@ -33,7 +33,6 @@
  */
 
 #include "int.h"
-#include "mib.h"
 #include "tmacro.h"
 #include "mac.h"
 #include "power.h"
diff --git a/drivers/staging/vt6656/mib.c b/drivers/staging/vt6656/mib.c
deleted file mode 100644
index 002f2b2..0000000
--- a/drivers/staging/vt6656/mib.c
+++ /dev/null
@@ -1,400 +0,0 @@
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
- *      STAvUpdateRDStatCounter - Update Rx statistic counter
- *      STAvUpdateTDStatCounter - Update Tx statistic counter
- *      STAvUpdateTDStatCounterEx - Update Tx statistic counter and copy tx data
- *      STAvUpdate802_11Counter - Update 802.11 mib counter
- *
- * Revision History:
- *
- */
-
-#include "mac.h"
-#include "tether.h"
-#include "mib.h"
-#include "wctl.h"
-#include "baseband.h"
-
-static int          msglevel                =MSG_LEVEL_INFO;
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
-void STAvUpdateIsrStatCounter (PSStatCounter pStatistic, u8 byIsr0, u8 byIsr1)
-{
-    /**********************/
-    /* ABNORMAL interrupt */
-    /**********************/
-    // not any IMR bit invoke irq
-    if (byIsr0 == 0) {
-        pStatistic->ISRStat.dwIsrUnknown++;
-        return;
-    }
-
-    if (byIsr0 & ISR_ACTX)              // ISR, bit0
-        pStatistic->ISRStat.dwIsrTx0OK++;           // TXDMA0 successful
-
-    if (byIsr0 & ISR_BNTX)              // ISR, bit2
-        pStatistic->ISRStat.dwIsrBeaconTxOK++;      // BeaconTx successful
-
-    if (byIsr0 & ISR_RXDMA0)            // ISR, bit3
-        pStatistic->ISRStat.dwIsrRx0OK++;           // Rx0 successful
-
-    if (byIsr0 & ISR_TBTT)              // ISR, bit4
-        pStatistic->ISRStat.dwIsrTBTTInt++;         // TBTT successful
-
-    if (byIsr0 & ISR_SOFTTIMER)         // ISR, bit6
-        pStatistic->ISRStat.dwIsrSTIMERInt++;
-
-    if (byIsr0 & ISR_WATCHDOG)          // ISR, bit7
-        pStatistic->ISRStat.dwIsrWatchDog++;
-
-    if (byIsr1 & ISR_FETALERR)              // ISR, bit8
-        pStatistic->ISRStat.dwIsrUnrecoverableError++;
-
-    if (byIsr1 & ISR_SOFTINT)               // ISR, bit9
-        pStatistic->ISRStat.dwIsrSoftInterrupt++;       // software interrupt
-
-    if (byIsr1 & ISR_MIBNEARFULL)           // ISR, bit10
-        pStatistic->ISRStat.dwIsrMIBNearfull++;
-
-    if (byIsr1 & ISR_RXNOBUF)               // ISR, bit11
-        pStatistic->ISRStat.dwIsrRxNoBuf++;             // Rx No Buff
-
-}
-
-/*
- * Description: Update Rx Statistic Counter
- *
- * Parameters:
- *  In:
- *      pStatistic      - Pointer to Statistic Counter Data Structure
- *      byRSR           - Rx Status
- *      byNewRSR        - Rx Status
- *      pbyBuffer       - Rx Buffer
- *      cbFrameLength   - Rx Length
- *  Out:
- *      none
- *
- * Return Value: none
- *
- */
-void STAvUpdateRDStatCounter(PSStatCounter pStatistic,
-			     u8 byRSR, u8 byNewRSR,
-			     u8 byRxSts, u8 byRxRate,
-			     u8 * pbyBuffer, unsigned int cbFrameLength)
-{
-	/* need change */
-	struct ieee80211_hdr *pHeader = (struct ieee80211_hdr *)pbyBuffer;
-
-	if (byRSR & RSR_ADDROK)
-		pStatistic->dwRsrADDROk++;
-	if (byRSR & RSR_CRCOK) {
-		pStatistic->dwRsrCRCOk++;
-		pStatistic->ullRsrOK++;
-
-		if (cbFrameLength >= ETH_ALEN) {
-			/* update counters in case of successful transmission */
-            if (byRSR & RSR_ADDRBROAD) {
-                pStatistic->ullRxBroadcastFrames++;
-		pStatistic->ullRxBroadcastBytes +=
-		  (unsigned long long) cbFrameLength;
-            }
-            else if (byRSR & RSR_ADDRMULTI) {
-                pStatistic->ullRxMulticastFrames++;
-		pStatistic->ullRxMulticastBytes +=
-		  (unsigned long long) cbFrameLength;
-            }
-            else {
-                pStatistic->ullRxDirectedFrames++;
-		pStatistic->ullRxDirectedBytes +=
-		  (unsigned long long) cbFrameLength;
-            }
-        }
-    }
-
-    if(byRxRate==22) {
-        pStatistic->CustomStat.ullRsr11M++;
-        if(byRSR & RSR_CRCOK) {
-            pStatistic->CustomStat.ullRsr11MCRCOk++;
-        }
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "11M: ALL[%d], OK[%d]:[%02x]\n",
-		(signed int) pStatistic->CustomStat.ullRsr11M,
-		(signed int) pStatistic->CustomStat.ullRsr11MCRCOk, byRSR);
-    }
-    else if(byRxRate==11) {
-        pStatistic->CustomStat.ullRsr5M++;
-        if(byRSR & RSR_CRCOK) {
-            pStatistic->CustomStat.ullRsr5MCRCOk++;
-        }
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " 5M: ALL[%d], OK[%d]:[%02x]\n",
-		(signed int) pStatistic->CustomStat.ullRsr5M,
-		(signed int) pStatistic->CustomStat.ullRsr5MCRCOk, byRSR);
-    }
-    else if(byRxRate==4) {
-        pStatistic->CustomStat.ullRsr2M++;
-        if(byRSR & RSR_CRCOK) {
-            pStatistic->CustomStat.ullRsr2MCRCOk++;
-        }
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " 2M: ALL[%d], OK[%d]:[%02x]\n",
-		(signed int) pStatistic->CustomStat.ullRsr2M,
-		(signed int) pStatistic->CustomStat.ullRsr2MCRCOk, byRSR);
-    }
-    else if(byRxRate==2){
-        pStatistic->CustomStat.ullRsr1M++;
-        if(byRSR & RSR_CRCOK) {
-            pStatistic->CustomStat.ullRsr1MCRCOk++;
-        }
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " 1M: ALL[%d], OK[%d]:[%02x]\n",
-		(signed int) pStatistic->CustomStat.ullRsr1M,
-		(signed int) pStatistic->CustomStat.ullRsr1MCRCOk, byRSR);
-    }
-    else if(byRxRate==12){
-        pStatistic->CustomStat.ullRsr6M++;
-        if(byRSR & RSR_CRCOK) {
-            pStatistic->CustomStat.ullRsr6MCRCOk++;
-        }
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " 6M: ALL[%d], OK[%d]\n",
-		(signed int) pStatistic->CustomStat.ullRsr6M,
-		(signed int) pStatistic->CustomStat.ullRsr6MCRCOk);
-    }
-    else if(byRxRate==18){
-        pStatistic->CustomStat.ullRsr9M++;
-        if(byRSR & RSR_CRCOK) {
-            pStatistic->CustomStat.ullRsr9MCRCOk++;
-        }
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " 9M: ALL[%d], OK[%d]\n",
-		(signed int) pStatistic->CustomStat.ullRsr9M,
-		(signed int) pStatistic->CustomStat.ullRsr9MCRCOk);
-    }
-    else if(byRxRate==24){
-        pStatistic->CustomStat.ullRsr12M++;
-        if(byRSR & RSR_CRCOK) {
-            pStatistic->CustomStat.ullRsr12MCRCOk++;
-        }
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "12M: ALL[%d], OK[%d]\n",
-		(signed int) pStatistic->CustomStat.ullRsr12M,
-		(signed int) pStatistic->CustomStat.ullRsr12MCRCOk);
-    }
-    else if(byRxRate==36){
-        pStatistic->CustomStat.ullRsr18M++;
-        if(byRSR & RSR_CRCOK) {
-            pStatistic->CustomStat.ullRsr18MCRCOk++;
-        }
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "18M: ALL[%d], OK[%d]\n",
-		(signed int) pStatistic->CustomStat.ullRsr18M,
-		(signed int) pStatistic->CustomStat.ullRsr18MCRCOk);
-    }
-    else if(byRxRate==48){
-        pStatistic->CustomStat.ullRsr24M++;
-        if(byRSR & RSR_CRCOK) {
-            pStatistic->CustomStat.ullRsr24MCRCOk++;
-        }
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "24M: ALL[%d], OK[%d]\n",
-		(signed int) pStatistic->CustomStat.ullRsr24M,
-		(signed int) pStatistic->CustomStat.ullRsr24MCRCOk);
-    }
-    else if(byRxRate==72){
-        pStatistic->CustomStat.ullRsr36M++;
-        if(byRSR & RSR_CRCOK) {
-            pStatistic->CustomStat.ullRsr36MCRCOk++;
-        }
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "36M: ALL[%d], OK[%d]\n",
-		(signed int) pStatistic->CustomStat.ullRsr36M,
-		(signed int) pStatistic->CustomStat.ullRsr36MCRCOk);
-    }
-    else if(byRxRate==96){
-        pStatistic->CustomStat.ullRsr48M++;
-        if(byRSR & RSR_CRCOK) {
-            pStatistic->CustomStat.ullRsr48MCRCOk++;
-        }
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "48M: ALL[%d], OK[%d]\n",
-		(signed int) pStatistic->CustomStat.ullRsr48M,
-		(signed int) pStatistic->CustomStat.ullRsr48MCRCOk);
-    }
-    else if(byRxRate==108){
-        pStatistic->CustomStat.ullRsr54M++;
-        if(byRSR & RSR_CRCOK) {
-            pStatistic->CustomStat.ullRsr54MCRCOk++;
-        }
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "54M: ALL[%d], OK[%d]\n",
-		(signed int) pStatistic->CustomStat.ullRsr54M,
-		(signed int) pStatistic->CustomStat.ullRsr54MCRCOk);
-    }
-    else {
-	    DBG_PRT(MSG_LEVEL_DEBUG,
-		    KERN_INFO "Unknown: Total[%d], CRCOK[%d]\n",
-		    (signed int) pStatistic->dwRsrRxPacket+1,
-		    (signed int)pStatistic->dwRsrCRCOk);
-    }
-
-    if (byRSR & RSR_BSSIDOK)
-        pStatistic->dwRsrBSSIDOk++;
-
-    if (byRSR & RSR_BCNSSIDOK)
-        pStatistic->dwRsrBCNSSIDOk++;
-    if (byRSR & RSR_IVLDLEN)  //invalid len (> 2312 byte)
-        pStatistic->dwRsrLENErr++;
-    if (byRSR & RSR_IVLDTYP)  //invalid packet type
-        pStatistic->dwRsrTYPErr++;
-    if ((byRSR & (RSR_IVLDTYP | RSR_IVLDLEN)) || !(byRSR & RSR_CRCOK))
-        pStatistic->dwRsrErr++;
-
-    if (byNewRSR & NEWRSR_DECRYPTOK)
-        pStatistic->dwNewRsrDECRYPTOK++;
-    if (byNewRSR & NEWRSR_CFPIND)
-        pStatistic->dwNewRsrCFP++;
-    if (byNewRSR & NEWRSR_HWUTSF)
-        pStatistic->dwNewRsrUTSF++;
-    if (byNewRSR & NEWRSR_BCNHITAID)
-        pStatistic->dwNewRsrHITAID++;
-    if (byNewRSR & NEWRSR_BCNHITAID0)
-        pStatistic->dwNewRsrHITAID0++;
-
-    // increase rx packet count
-    pStatistic->dwRsrRxPacket++;
-    pStatistic->dwRsrRxOctet += cbFrameLength;
-
-    if (IS_TYPE_DATA(pbyBuffer)) {
-        pStatistic->dwRsrRxData++;
-    } else if (IS_TYPE_MGMT(pbyBuffer)){
-        pStatistic->dwRsrRxManage++;
-    } else if (IS_TYPE_CONTROL(pbyBuffer)){
-        pStatistic->dwRsrRxControl++;
-    }
-
-    if (byRSR & RSR_ADDRBROAD)
-        pStatistic->dwRsrBroadcast++;
-    else if (byRSR & RSR_ADDRMULTI)
-        pStatistic->dwRsrMulticast++;
-    else
-        pStatistic->dwRsrDirected++;
-
-    if (WLAN_GET_FC_MOREFRAG(pHeader->frame_control))
-        pStatistic->dwRsrRxFragment++;
-
-    if (cbFrameLength < ETH_ZLEN + 4) {
-        pStatistic->dwRsrRunt++;
-    } else if (cbFrameLength == ETH_ZLEN + 4) {
-        pStatistic->dwRsrRxFrmLen64++;
-    }
-    else if ((65 <= cbFrameLength) && (cbFrameLength <= 127)) {
-        pStatistic->dwRsrRxFrmLen65_127++;
-    }
-    else if ((128 <= cbFrameLength) && (cbFrameLength <= 255)) {
-        pStatistic->dwRsrRxFrmLen128_255++;
-    }
-    else if ((256 <= cbFrameLength) && (cbFrameLength <= 511)) {
-        pStatistic->dwRsrRxFrmLen256_511++;
-    }
-    else if ((512 <= cbFrameLength) && (cbFrameLength <= 1023)) {
-        pStatistic->dwRsrRxFrmLen512_1023++;
-    } else if ((1024 <= cbFrameLength) &&
-	       (cbFrameLength <= ETH_FRAME_LEN + 4)) {
-        pStatistic->dwRsrRxFrmLen1024_1518++;
-    } else if (cbFrameLength > ETH_FRAME_LEN + 4) {
-        pStatistic->dwRsrLong++;
-    }
-}
-
-/*
- * Description: Update 802.11 mib counter
- *
- * Parameters:
- *  In:
- *      p802_11Counter  - Pointer to 802.11 mib counter
- *      pStatistic      - Pointer to Statistic Counter Data Structure
- *      dwCounter       - hardware counter for 802.11 mib
- *  Out:
- *      none
- *
- * Return Value: none
- *
- */
-void
-STAvUpdate802_11Counter(
-    PSDot11Counters         p802_11Counter,
-    PSStatCounter           pStatistic,
-    u8                    byRTSSuccess,
-    u8                    byRTSFail,
-    u8                    byACKFail,
-    u8                    byFCSErr
-    )
-{
-    //p802_11Counter->TransmittedFragmentCount
-    p802_11Counter->MulticastTransmittedFrameCount =
-      (unsigned long long) (pStatistic->dwTsrBroadcast +
-			    pStatistic->dwTsrMulticast);
-    p802_11Counter->FailedCount = (unsigned long long) (pStatistic->dwTsrErr);
-    p802_11Counter->RetryCount = (unsigned long long) (pStatistic->dwTsrRetry);
-    p802_11Counter->MultipleRetryCount =
-      (unsigned long long) (pStatistic->dwTsrMoreThanOnceRetry);
-    //p802_11Counter->FrameDuplicateCount
-    p802_11Counter->RTSSuccessCount += (unsigned long long) byRTSSuccess;
-    p802_11Counter->RTSFailureCount += (unsigned long long) byRTSFail;
-    p802_11Counter->ACKFailureCount += (unsigned long long) byACKFail;
-    p802_11Counter->FCSErrorCount +=   (unsigned long long) byFCSErr;
-    //p802_11Counter->ReceivedFragmentCount
-    p802_11Counter->MulticastReceivedFrameCount =
-      (unsigned long long) (pStatistic->dwRsrBroadcast +
-			    pStatistic->dwRsrMulticast);
-}
-
-/*
- * Description: Clear 802.11 mib counter
- *
- * Parameters:
- *  In:
- *      pUsbCounter  - Pointer to USB mib counter
- *      ntStatus - URB status
- *  Out:
- *      none
- *
- * Return Value: none
- *
- */
-
-void STAvUpdateUSBCounter(PSUSBCounter pUsbCounter, int ntStatus)
-{
-
-//    if ( ntStatus == USBD_STATUS_CRC ) {
-        pUsbCounter->dwCrc++;
-//    }
-
-}
diff --git a/drivers/staging/vt6656/mib.h b/drivers/staging/vt6656/mib.h
deleted file mode 100644
index c342dad..0000000
--- a/drivers/staging/vt6656/mib.h
+++ /dev/null
@@ -1,374 +0,0 @@
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
-#include "tether.h"
-#include "desc.h"
-
-//
-// USB counter
-//
-typedef struct tagSUSBCounter {
-    u32 dwCrc;
-
-} SUSBCounter, *PSUSBCounter;
-
-//
-// 802.11 counter
-//
-
-typedef struct tagSDot11Counters {
-  /* unsigned long Length; // Length of structure */
-    unsigned long long   TransmittedFragmentCount;
-    unsigned long long   MulticastTransmittedFrameCount;
-    unsigned long long   FailedCount;
-    unsigned long long   RetryCount;
-    unsigned long long   MultipleRetryCount;
-    unsigned long long   RTSSuccessCount;
-    unsigned long long   RTSFailureCount;
-    unsigned long long   ACKFailureCount;
-    unsigned long long   FrameDuplicateCount;
-    unsigned long long   ReceivedFragmentCount;
-    unsigned long long   MulticastReceivedFrameCount;
-    unsigned long long   FCSErrorCount;
-    unsigned long long   TKIPLocalMICFailures;
-    unsigned long long   TKIPRemoteMICFailures;
-    unsigned long long   TKIPICVErrors;
-    unsigned long long   TKIPReplays;
-    unsigned long long   CCMPFormatErrors;
-    unsigned long long   CCMPReplays;
-    unsigned long long   CCMPDecryptErrors;
-    unsigned long long   FourWayHandshakeFailures;
-  /*
-   * unsigned long long   WEPUndecryptableCount;
-   * unsigned long long   WEPICVErrorCount;
-   * unsigned long long   DecryptSuccessCount;
-   * unsigned long long   DecryptFailureCount;
-   */
-} SDot11Counters, *PSDot11Counters;
-
-//
-// MIB2 counter
-//
-typedef struct tagSMib2Counter {
-    signed long    ifIndex;
-    char    ifDescr[256];               // max size 255 plus zero ending
-                                        // e.g. "interface 1"
-    signed long    ifType;
-    signed long    ifMtu;
-    u32   ifSpeed;
-    u8    ifPhysAddress[ETH_ALEN];
-    signed long    ifAdminStatus;
-    signed long    ifOperStatus;
-    u32   ifLastChange;
-    u32   ifInOctets;
-    u32   ifInUcastPkts;
-    u32   ifInNUcastPkts;
-    u32   ifInDiscards;
-    u32   ifInErrors;
-    u32   ifInUnknownProtos;
-    u32   ifOutOctets;
-    u32   ifOutUcastPkts;
-    u32   ifOutNUcastPkts;
-    u32   ifOutDiscards;
-    u32   ifOutErrors;
-    u32   ifOutQLen;
-    u32   ifSpecific;
-} SMib2Counter, *PSMib2Counter;
-
-// Value in the ifType entry
-#define WIRELESSLANIEEE80211b      6           //
-
-// Value in the ifAdminStatus/ifOperStatus entry
-#define UP                  1           //
-#define DOWN                2           //
-#define TESTING             3           //
-
-//
-// RMON counter
-//
-typedef struct tagSRmonCounter {
-    signed long    etherStatsIndex;
-    u32   etherStatsDataSource;
-    u32   etherStatsDropEvents;
-    u32   etherStatsOctets;
-    u32   etherStatsPkts;
-    u32   etherStatsBroadcastPkts;
-    u32   etherStatsMulticastPkts;
-    u32   etherStatsCRCAlignErrors;
-    u32   etherStatsUndersizePkts;
-    u32   etherStatsOversizePkts;
-    u32   etherStatsFragments;
-    u32   etherStatsJabbers;
-    u32   etherStatsCollisions;
-    u32   etherStatsPkt64Octets;
-    u32   etherStatsPkt65to127Octets;
-    u32   etherStatsPkt128to255Octets;
-    u32   etherStatsPkt256to511Octets;
-    u32   etherStatsPkt512to1023Octets;
-    u32   etherStatsPkt1024to1518Octets;
-    u32   etherStatsOwners;
-    u32   etherStatsStatus;
-} SRmonCounter, *PSRmonCounter;
-
-//
-// Custom counter
-//
-typedef struct tagSCustomCounters {
-    unsigned long       Length;
-
-    unsigned long long   ullTsrAllOK;
-
-    unsigned long long   ullRsr11M;
-    unsigned long long   ullRsr5M;
-    unsigned long long   ullRsr2M;
-    unsigned long long   ullRsr1M;
-
-    unsigned long long   ullRsr11MCRCOk;
-    unsigned long long   ullRsr5MCRCOk;
-    unsigned long long   ullRsr2MCRCOk;
-    unsigned long long   ullRsr1MCRCOk;
-
-    unsigned long long   ullRsr54M;
-    unsigned long long   ullRsr48M;
-    unsigned long long   ullRsr36M;
-    unsigned long long   ullRsr24M;
-    unsigned long long   ullRsr18M;
-    unsigned long long   ullRsr12M;
-    unsigned long long   ullRsr9M;
-    unsigned long long   ullRsr6M;
-
-    unsigned long long   ullRsr54MCRCOk;
-    unsigned long long   ullRsr48MCRCOk;
-    unsigned long long   ullRsr36MCRCOk;
-    unsigned long long   ullRsr24MCRCOk;
-    unsigned long long   ullRsr18MCRCOk;
-    unsigned long long   ullRsr12MCRCOk;
-    unsigned long long   ullRsr9MCRCOk;
-    unsigned long long   ullRsr6MCRCOk;
-
-} SCustomCounters, *PSCustomCounters;
-
-//
-// Custom counter
-//
-typedef struct tagSISRCounters {
-    unsigned long   Length;
-
-    u32   dwIsrTx0OK;
-    u32   dwIsrAC0TxOK;
-    u32   dwIsrBeaconTxOK;
-    u32   dwIsrRx0OK;
-    u32   dwIsrTBTTInt;
-    u32   dwIsrSTIMERInt;
-    u32   dwIsrWatchDog;
-    u32   dwIsrUnrecoverableError;
-    u32   dwIsrSoftInterrupt;
-    u32   dwIsrMIBNearfull;
-    u32   dwIsrRxNoBuf;
-
-    u32   dwIsrUnknown;               // unknown interrupt count
-
-    u32   dwIsrRx1OK;
-    u32   dwIsrATIMTxOK;
-    u32   dwIsrSYNCTxOK;
-    u32   dwIsrCFPEnd;
-    u32   dwIsrATIMEnd;
-    u32   dwIsrSYNCFlushOK;
-    u32   dwIsrSTIMER1Int;
-    /////////////////////////////////////
-} SISRCounters, *PSISRCounters;
-
-// Value in the etherStatsStatus entry
-#define VALID               1           //
-#define CREATE_REQUEST      2           //
-#define UNDER_CREATION      3           //
-#define INVALID             4           //
-
-//
-// Tx packet information
-//
-typedef struct tagSTxPktInfo {
-    u8    byBroadMultiUni;
-    u16    wLength;
-    u16    wFIFOCtl;
-    u8    abyDestAddr[ETH_ALEN];
-} STxPktInfo, *PSTxPktInfo;
-
-//
-// statistic counter
-//
-typedef struct tagSStatCounter {
-    //
-    // ISR status count
-    //
-
-    SISRCounters ISRStat;
-
-    // RSR status count
-    //
-    u32   dwRsrFrmAlgnErr;
-    u32   dwRsrErr;
-    u32   dwRsrCRCErr;
-    u32   dwRsrCRCOk;
-    u32   dwRsrBSSIDOk;
-    u32   dwRsrADDROk;
-    u32   dwRsrBCNSSIDOk;
-    u32   dwRsrLENErr;
-    u32   dwRsrTYPErr;
-
-    u32   dwNewRsrDECRYPTOK;
-    u32   dwNewRsrCFP;
-    u32   dwNewRsrUTSF;
-    u32   dwNewRsrHITAID;
-    u32   dwNewRsrHITAID0;
-
-    u32   dwRsrLong;
-    u32   dwRsrRunt;
-
-    u32   dwRsrRxControl;
-    u32   dwRsrRxData;
-    u32   dwRsrRxManage;
-
-    u32   dwRsrRxPacket;
-    u32   dwRsrRxOctet;
-    u32   dwRsrBroadcast;
-    u32   dwRsrMulticast;
-    u32   dwRsrDirected;
-    // 64-bit OID
-    unsigned long long   ullRsrOK;
-
-    // for some optional OIDs (64 bits) and DMI support
-    unsigned long long   ullRxBroadcastBytes;
-    unsigned long long   ullRxMulticastBytes;
-    unsigned long long   ullRxDirectedBytes;
-    unsigned long long   ullRxBroadcastFrames;
-    unsigned long long   ullRxMulticastFrames;
-    unsigned long long   ullRxDirectedFrames;
-
-    u32   dwRsrRxFragment;
-    u32   dwRsrRxFrmLen64;
-    u32   dwRsrRxFrmLen65_127;
-    u32   dwRsrRxFrmLen128_255;
-    u32   dwRsrRxFrmLen256_511;
-    u32   dwRsrRxFrmLen512_1023;
-    u32   dwRsrRxFrmLen1024_1518;
-
-    // TSR status count
-    //
-    u32   dwTsrTotalRetry;        // total collision retry count
-    u32   dwTsrOnceRetry;         // this packet only occur one collision
-    u32   dwTsrMoreThanOnceRetry; // this packet occur more than one collision
-    u32   dwTsrRetry;             // this packet has ever occur collision,
-                                         // that is (dwTsrOnceCollision0 + dwTsrMoreThanOnceCollision0)
-    u32   dwTsrACKData;
-    u32   dwTsrErr;
-    u32   dwAllTsrOK;
-    u32   dwTsrRetryTimeout;
-    u32   dwTsrTransmitTimeout;
-
-    u32   dwTsrTxPacket;
-    u32   dwTsrTxOctet;
-    u32   dwTsrBroadcast;
-    u32   dwTsrMulticast;
-    u32   dwTsrDirected;
-
-    // RD/TD count
-    u32   dwCntRxFrmLength;
-    u32   dwCntTxBufLength;
-
-    u8    abyCntRxPattern[16];
-    u8    abyCntTxPattern[16];
-
-    // Software check....
-    u32   dwCntRxDataErr;             // rx buffer data software compare CRC err count
-    u32   dwCntDecryptErr;            // rx buffer data software compare CRC err count
-    u32   dwCntRxICVErr;              // rx buffer data software compare CRC err count
-
-    // 64-bit OID
-    unsigned long long   ullTsrOK;
-
-    // for some optional OIDs (64 bits) and DMI support
-    unsigned long long   ullTxBroadcastFrames;
-    unsigned long long   ullTxMulticastFrames;
-    unsigned long long   ullTxDirectedFrames;
-    unsigned long long   ullTxBroadcastBytes;
-    unsigned long long   ullTxMulticastBytes;
-    unsigned long long   ullTxDirectedBytes;
-
-    // for autorate
-    u32   dwTxOk[MAX_RATE+1];
-    u32   dwTxFail[MAX_RATE+1];
-    u32   dwTxRetryCount[8];
-
-    STxPktInfo  abyTxPktInfo[16];
-
-    SUSBCounter USB_EP0Stat;
-    SUSBCounter USB_BulkInStat;
-    SUSBCounter USB_BulkOutStat;
-    SUSBCounter USB_InterruptStat;
-
-    SCustomCounters CustomStat;
-
-       //Tx count:
-  unsigned long TxNoRetryOkCount;         /* success tx no retry ! */
-  unsigned long TxRetryOkCount;           /* success tx but retry ! */
-  unsigned long TxFailCount;              /* fail tx ? */
-      //Rx count:
-  unsigned long RxOkCnt;                  /* success rx ! */
-  unsigned long RxFcsErrCnt;              /* fail rx ? */
-      //statistic
-    unsigned long SignalStren;
-    unsigned long LinkQuality;
-
-} SStatCounter, *PSStatCounter;
-
-void STAvUpdateIsrStatCounter(PSStatCounter pStatistic,
-			      u8 byIsr0,
-			      u8 byIsr1);
-
-void STAvUpdateRDStatCounter(PSStatCounter pStatistic,
-			     u8 byRSR, u8 byNewRSR, u8 byRxSts,
-			     u8 byRxRate, u8 * pbyBuffer,
-			     unsigned int cbFrameLength);
-
-void
-STAvUpdate802_11Counter(
-    PSDot11Counters         p802_11Counter,
-    PSStatCounter           pStatistic,
-    u8                    byRTSSuccess,
-    u8                    byRTSFail,
-    u8                    byACKFail,
-    u8                    byFCSErr
-    );
-
-void STAvUpdateUSBCounter(PSUSBCounter pUsbCounter, int ntStatus);
-
-#endif /* __MIB_H__ */
-- 
1.8.3.2

