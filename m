Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:46136 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756914AbaJ2R5p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 13:57:45 -0400
Received: by mail-wi0-f174.google.com with SMTP id d1so2428608wiv.1
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2014 10:57:44 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH v2 24/48] staging: vt6655: mib remove unused functions and structure members
Date: Wed, 29 Oct 2014 17:55:42 +0000
Message-Id: <1414605366-9335-25-git-send-email-tvboxspy@gmail.com> (sfid-20141029_185948_051334_72A3FC61)
In-Reply-To: <1414605366-9335-1-git-send-email-tvboxspy@gmail.com>
References: <1414605366-9335-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/mib.c | 423 -------------------------------------------
 drivers/staging/vt6655/mib.h | 259 --------------------------
 2 files changed, 682 deletions(-)

diff --git a/drivers/staging/vt6655/mib.c b/drivers/staging/vt6655/mib.c
index 111c018..d2f351d 100644
--- a/drivers/staging/vt6655/mib.c
+++ b/drivers/staging/vt6655/mib.c
@@ -25,24 +25,15 @@
  * Date: May 21, 1996
  *
  * Functions:
- *      STAvClearAllCounter - Clear All MIB Counter
  *      STAvUpdateIstStatCounter - Update ISR statistic counter
- *      STAvUpdateRDStatCounter - Update Rx statistic counter
- *      STAvUpdateRDStatCounterEx - Update Rx statistic counter and copy rcv data
- *      STAvUpdateTDStatCounter - Update Tx statistic counter
- *      STAvUpdateTDStatCounterEx - Update Tx statistic counter and copy tx data
  *      STAvUpdate802_11Counter - Update 802.11 mib counter
  *
  * Revision History:
  *
  */
 
-#include "upc.h"
 #include "mac.h"
-#include "tether.h"
 #include "mib.h"
-#include "wctl.h"
-#include "baseband.h"
 
 /*---------------------  Static Classes  ----------------------------*/
 
@@ -55,24 +46,6 @@
 /*---------------------  Export Functions  --------------------------*/
 
 /*
- * Description: Clear All Statistic Counter
- *
- * Parameters:
- *  In:
- *      pStatistic  - Pointer to Statistic Counter Data Structure
- *  Out:
- *      none
- *
- * Return Value: none
- *
- */
-void STAvClearAllCounter(PSStatCounter pStatistic)
-{
-	// set memory to zero
-	memset(pStatistic, 0, sizeof(SStatCounter));
-}
-
-/*
  * Description: Update Isr Statistic Counter
  *
  * Parameters:
@@ -139,373 +112,6 @@ void STAvUpdateIsrStatCounter(PSStatCounter pStatistic, unsigned long dwIsr)
 }
 
 /*
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
-			     unsigned char byRSR, unsigned char byNewRSR, unsigned char byRxRate,
-			     unsigned char *pbyBuffer, unsigned int cbFrameLength)
-{
-	//need change
-	PS802_11Header pHeader = (PS802_11Header)pbyBuffer;
-
-	if (byRSR & RSR_ADDROK)
-		pStatistic->dwRsrADDROk++;
-	if (byRSR & RSR_CRCOK) {
-		pStatistic->dwRsrCRCOk++;
-
-		pStatistic->ullRsrOK++;
-
-		if (cbFrameLength >= ETH_ALEN) {
-			// update counters in case of successful transmit
-			if (byRSR & RSR_ADDRBROAD) {
-				pStatistic->ullRxBroadcastFrames++;
-				pStatistic->ullRxBroadcastBytes += (unsigned long long) cbFrameLength;
-			} else if (byRSR & RSR_ADDRMULTI) {
-				pStatistic->ullRxMulticastFrames++;
-				pStatistic->ullRxMulticastBytes += (unsigned long long) cbFrameLength;
-			} else {
-				pStatistic->ullRxDirectedFrames++;
-				pStatistic->ullRxDirectedBytes += (unsigned long long) cbFrameLength;
-			}
-		}
-	}
-
-	if (byRxRate == 22) {
-		pStatistic->CustomStat.ullRsr11M++;
-		if (byRSR & RSR_CRCOK)
-			pStatistic->CustomStat.ullRsr11MCRCOk++;
-
-		pr_debug("11M: ALL[%d], OK[%d]:[%02x]\n",
-			 (int)pStatistic->CustomStat.ullRsr11M,
-			 (int)pStatistic->CustomStat.ullRsr11MCRCOk, byRSR);
-	} else if (byRxRate == 11) {
-		pStatistic->CustomStat.ullRsr5M++;
-		if (byRSR & RSR_CRCOK)
-			pStatistic->CustomStat.ullRsr5MCRCOk++;
-
-		pr_debug(" 5M: ALL[%d], OK[%d]:[%02x]\n",
-			 (int)pStatistic->CustomStat.ullRsr5M,
-			 (int)pStatistic->CustomStat.ullRsr5MCRCOk, byRSR);
-	} else if (byRxRate == 4) {
-		pStatistic->CustomStat.ullRsr2M++;
-		if (byRSR & RSR_CRCOK)
-			pStatistic->CustomStat.ullRsr2MCRCOk++;
-
-		pr_debug(" 2M: ALL[%d], OK[%d]:[%02x]\n",
-			 (int)pStatistic->CustomStat.ullRsr2M,
-			 (int)pStatistic->CustomStat.ullRsr2MCRCOk, byRSR);
-	} else if (byRxRate == 2) {
-		pStatistic->CustomStat.ullRsr1M++;
-		if (byRSR & RSR_CRCOK)
-			pStatistic->CustomStat.ullRsr1MCRCOk++;
-
-		pr_debug(" 1M: ALL[%d], OK[%d]:[%02x]\n",
-			 (int)pStatistic->CustomStat.ullRsr1M,
-			 (int)pStatistic->CustomStat.ullRsr1MCRCOk, byRSR);
-	} else if (byRxRate == 12) {
-		pStatistic->CustomStat.ullRsr6M++;
-		if (byRSR & RSR_CRCOK)
-			pStatistic->CustomStat.ullRsr6MCRCOk++;
-
-		pr_debug(" 6M: ALL[%d], OK[%d]\n",
-			 (int)pStatistic->CustomStat.ullRsr6M,
-			 (int)pStatistic->CustomStat.ullRsr6MCRCOk);
-	} else if (byRxRate == 18) {
-		pStatistic->CustomStat.ullRsr9M++;
-		if (byRSR & RSR_CRCOK)
-			pStatistic->CustomStat.ullRsr9MCRCOk++;
-
-		pr_debug(" 9M: ALL[%d], OK[%d]\n",
-			 (int)pStatistic->CustomStat.ullRsr9M,
-			 (int)pStatistic->CustomStat.ullRsr9MCRCOk);
-	} else if (byRxRate == 24) {
-		pStatistic->CustomStat.ullRsr12M++;
-		if (byRSR & RSR_CRCOK)
-			pStatistic->CustomStat.ullRsr12MCRCOk++;
-
-		pr_debug("12M: ALL[%d], OK[%d]\n",
-			 (int)pStatistic->CustomStat.ullRsr12M,
-			 (int)pStatistic->CustomStat.ullRsr12MCRCOk);
-	} else if (byRxRate == 36) {
-		pStatistic->CustomStat.ullRsr18M++;
-		if (byRSR & RSR_CRCOK)
-			pStatistic->CustomStat.ullRsr18MCRCOk++;
-
-		pr_debug("18M: ALL[%d], OK[%d]\n",
-			 (int)pStatistic->CustomStat.ullRsr18M,
-			 (int)pStatistic->CustomStat.ullRsr18MCRCOk);
-	} else if (byRxRate == 48) {
-		pStatistic->CustomStat.ullRsr24M++;
-		if (byRSR & RSR_CRCOK)
-			pStatistic->CustomStat.ullRsr24MCRCOk++;
-
-		pr_debug("24M: ALL[%d], OK[%d]\n",
-			 (int)pStatistic->CustomStat.ullRsr24M,
-			 (int)pStatistic->CustomStat.ullRsr24MCRCOk);
-	} else if (byRxRate == 72) {
-		pStatistic->CustomStat.ullRsr36M++;
-		if (byRSR & RSR_CRCOK)
-			pStatistic->CustomStat.ullRsr36MCRCOk++;
-
-		pr_debug("36M: ALL[%d], OK[%d]\n",
-			 (int)pStatistic->CustomStat.ullRsr36M,
-			 (int)pStatistic->CustomStat.ullRsr36MCRCOk);
-	} else if (byRxRate == 96) {
-		pStatistic->CustomStat.ullRsr48M++;
-		if (byRSR & RSR_CRCOK)
-			pStatistic->CustomStat.ullRsr48MCRCOk++;
-
-		pr_debug("48M: ALL[%d], OK[%d]\n",
-			 (int)pStatistic->CustomStat.ullRsr48M,
-			 (int)pStatistic->CustomStat.ullRsr48MCRCOk);
-	} else if (byRxRate == 108) {
-		pStatistic->CustomStat.ullRsr54M++;
-		if (byRSR & RSR_CRCOK)
-			pStatistic->CustomStat.ullRsr54MCRCOk++;
-
-		pr_debug("54M: ALL[%d], OK[%d]\n",
-			 (int)pStatistic->CustomStat.ullRsr54M,
-			 (int)pStatistic->CustomStat.ullRsr54MCRCOk);
-	} else {
-		pr_debug("Unknown: Total[%d], CRCOK[%d]\n",
-			 (int)pStatistic->dwRsrRxPacket+1,
-			 (int)pStatistic->dwRsrCRCOk);
-	}
-
-	if (byRSR & RSR_BSSIDOK)
-		pStatistic->dwRsrBSSIDOk++;
-
-	if (byRSR & RSR_BCNSSIDOK)
-		pStatistic->dwRsrBCNSSIDOk++;
-	if (byRSR & RSR_IVLDLEN)  //invalid len (> 2312 byte)
-		pStatistic->dwRsrLENErr++;
-	if (byRSR & RSR_IVLDTYP)  //invalid packet type
-		pStatistic->dwRsrTYPErr++;
-	if (byRSR & (RSR_IVLDTYP | RSR_IVLDLEN))
-		pStatistic->dwRsrErr++;
-
-	if (byNewRSR & NEWRSR_DECRYPTOK)
-		pStatistic->dwNewRsrDECRYPTOK++;
-	if (byNewRSR & NEWRSR_CFPIND)
-		pStatistic->dwNewRsrCFP++;
-	if (byNewRSR & NEWRSR_HWUTSF)
-		pStatistic->dwNewRsrUTSF++;
-	if (byNewRSR & NEWRSR_BCNHITAID)
-		pStatistic->dwNewRsrHITAID++;
-	if (byNewRSR & NEWRSR_BCNHITAID0)
-		pStatistic->dwNewRsrHITAID0++;
-
-	// increase rx packet count
-	pStatistic->dwRsrRxPacket++;
-	pStatistic->dwRsrRxOctet += cbFrameLength;
-
-	if (IS_TYPE_DATA(pbyBuffer))
-		pStatistic->dwRsrRxData++;
-	else if (IS_TYPE_MGMT(pbyBuffer))
-		pStatistic->dwRsrRxManage++;
-	else if (IS_TYPE_CONTROL(pbyBuffer))
-		pStatistic->dwRsrRxControl++;
-
-	if (byRSR & RSR_ADDRBROAD)
-		pStatistic->dwRsrBroadcast++;
-	else if (byRSR & RSR_ADDRMULTI)
-		pStatistic->dwRsrMulticast++;
-	else
-		pStatistic->dwRsrDirected++;
-
-	if (WLAN_GET_FC_MOREFRAG(pHeader->wFrameCtl))
-		pStatistic->dwRsrRxFragment++;
-
-	if (cbFrameLength < ETH_ZLEN + 4)
-		pStatistic->dwRsrRunt++;
-	else if (cbFrameLength == ETH_ZLEN + 4)
-		pStatistic->dwRsrRxFrmLen64++;
-	else if ((65 <= cbFrameLength) && (cbFrameLength <= 127))
-		pStatistic->dwRsrRxFrmLen65_127++;
-	else if ((128 <= cbFrameLength) && (cbFrameLength <= 255))
-		pStatistic->dwRsrRxFrmLen128_255++;
-	else if ((256 <= cbFrameLength) && (cbFrameLength <= 511))
-		pStatistic->dwRsrRxFrmLen256_511++;
-	else if ((512 <= cbFrameLength) && (cbFrameLength <= 1023))
-		pStatistic->dwRsrRxFrmLen512_1023++;
-	else if ((1024 <= cbFrameLength) && (cbFrameLength <= ETH_FRAME_LEN + 4))
-		pStatistic->dwRsrRxFrmLen1024_1518++;
-	else if (cbFrameLength > ETH_FRAME_LEN + 4)
-		pStatistic->dwRsrLong++;
-}
-
-/*
- * Description: Update Rx Statistic Counter and copy Rx buffer
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
-
-void
-STAvUpdateRDStatCounterEx(
-	PSStatCounter   pStatistic,
-	unsigned char byRSR,
-	unsigned char byNewRSR,
-	unsigned char byRxRate,
-	unsigned char *pbyBuffer,
-	unsigned int cbFrameLength
-)
-{
-	STAvUpdateRDStatCounter(
-		pStatistic,
-		byRSR,
-		byNewRSR,
-		byRxRate,
-		pbyBuffer,
-		cbFrameLength
-);
-
-	// rx length
-	pStatistic->dwCntRxFrmLength = cbFrameLength;
-	// rx pattern, we just see 10 bytes for sample
-	memcpy(pStatistic->abyCntRxPattern, (unsigned char *)pbyBuffer, 10);
-}
-
-/*
- * Description: Update Tx Statistic Counter
- *
- * Parameters:
- *  In:
- *      pStatistic      - Pointer to Statistic Counter Data Structure
- *      byTSR0          - Tx Status
- *      byTSR1          - Tx Status
- *      pbyBuffer       - Tx Buffer
- *      cbFrameLength   - Tx Length
- *      uIdx            - Index of Tx DMA
- *  Out:
- *      none
- *
- * Return Value: none
- *
- */
-void
-STAvUpdateTDStatCounter(
-	PSStatCounter   pStatistic,
-	unsigned char byTSR0,
-	unsigned char byTSR1,
-	unsigned char *pbyBuffer,
-	unsigned int cbFrameLength,
-	unsigned int uIdx
-)
-{
-	PWLAN_80211HDR_A4   pHeader;
-	unsigned char *pbyDestAddr;
-	unsigned char byTSR0_NCR = byTSR0 & TSR0_NCR;
-
-	pHeader = (PWLAN_80211HDR_A4) pbyBuffer;
-	if (WLAN_GET_FC_TODS(pHeader->wFrameCtl) == 0)
-		pbyDestAddr = &(pHeader->abyAddr1[0]);
-	else
-		pbyDestAddr = &(pHeader->abyAddr3[0]);
-
-	// increase tx packet count
-	pStatistic->dwTsrTxPacket[uIdx]++;
-	pStatistic->dwTsrTxOctet[uIdx] += cbFrameLength;
-
-	if (byTSR0_NCR != 0) {
-		pStatistic->dwTsrRetry[uIdx]++;
-		pStatistic->dwTsrTotalRetry[uIdx] += byTSR0_NCR;
-
-		if (byTSR0_NCR == 1)
-			pStatistic->dwTsrOnceRetry[uIdx]++;
-		else
-			pStatistic->dwTsrMoreThanOnceRetry[uIdx]++;
-	}
-
-	if ((byTSR1&(TSR1_TERR|TSR1_RETRYTMO|TSR1_TMO|ACK_DATA)) == 0) {
-		pStatistic->ullTsrOK[uIdx]++;
-		pStatistic->CustomStat.ullTsrAllOK =
-			(pStatistic->ullTsrOK[TYPE_AC0DMA] + pStatistic->ullTsrOK[TYPE_TXDMA0]);
-		// update counters in case that successful transmit
-		if (is_broadcast_ether_addr(pbyDestAddr)) {
-			pStatistic->ullTxBroadcastFrames[uIdx]++;
-			pStatistic->ullTxBroadcastBytes[uIdx] += (unsigned long long) cbFrameLength;
-		} else if (is_multicast_ether_addr(pbyDestAddr)) {
-			pStatistic->ullTxMulticastFrames[uIdx]++;
-			pStatistic->ullTxMulticastBytes[uIdx] += (unsigned long long) cbFrameLength;
-		} else {
-			pStatistic->ullTxDirectedFrames[uIdx]++;
-			pStatistic->ullTxDirectedBytes[uIdx] += (unsigned long long) cbFrameLength;
-		}
-	} else {
-		if (byTSR1 & TSR1_TERR)
-			pStatistic->dwTsrErr[uIdx]++;
-		if (byTSR1 & TSR1_RETRYTMO)
-			pStatistic->dwTsrRetryTimeout[uIdx]++;
-		if (byTSR1 & TSR1_TMO)
-			pStatistic->dwTsrTransmitTimeout[uIdx]++;
-		if (byTSR1 & ACK_DATA)
-			pStatistic->dwTsrACKData[uIdx]++;
-	}
-
-	if (is_broadcast_ether_addr(pbyDestAddr))
-		pStatistic->dwTsrBroadcast[uIdx]++;
-	else if (is_multicast_ether_addr(pbyDestAddr))
-		pStatistic->dwTsrMulticast[uIdx]++;
-	else
-		pStatistic->dwTsrDirected[uIdx]++;
-}
-
-/*
- * Description: Update Tx Statistic Counter and copy Tx buffer
- *
- * Parameters:
- *  In:
- *      pStatistic      - Pointer to Statistic Counter Data Structure
- *      pbyBuffer       - Tx Buffer
- *      cbFrameLength   - Tx Length
- *  Out:
- *      none
- *
- * Return Value: none
- *
- */
-void
-STAvUpdateTDStatCounterEx(
-	PSStatCounter   pStatistic,
-	unsigned char *pbyBuffer,
-	unsigned long cbFrameLength
-)
-{
-	unsigned int uPktLength;
-
-	uPktLength = (unsigned int)cbFrameLength;
-
-	// tx length
-	pStatistic->dwCntTxBufLength = uPktLength;
-	// tx pattern, we just see 16 bytes for sample
-	memcpy(pStatistic->abyCntTxPattern, pbyBuffer, 16);
-}
-
-/*
  * Description: Update 802.11 mib counter
  *
  * Parameters:
@@ -526,37 +132,8 @@ STAvUpdate802_11Counter(
 	unsigned long dwCounter
 )
 {
-	p802_11Counter->MulticastTransmittedFrameCount = (unsigned long long) (pStatistic->dwTsrBroadcast[TYPE_AC0DMA] +
-									       pStatistic->dwTsrBroadcast[TYPE_TXDMA0] +
-									       pStatistic->dwTsrMulticast[TYPE_AC0DMA] +
-									       pStatistic->dwTsrMulticast[TYPE_TXDMA0]);
-	p802_11Counter->FailedCount = (unsigned long long) (pStatistic->dwTsrErr[TYPE_AC0DMA] + pStatistic->dwTsrErr[TYPE_TXDMA0]);
-	p802_11Counter->RetryCount = (unsigned long long) (pStatistic->dwTsrRetry[TYPE_AC0DMA] + pStatistic->dwTsrRetry[TYPE_TXDMA0]);
-	p802_11Counter->MultipleRetryCount = (unsigned long long) (pStatistic->dwTsrMoreThanOnceRetry[TYPE_AC0DMA] +
-								   pStatistic->dwTsrMoreThanOnceRetry[TYPE_TXDMA0]);
 	p802_11Counter->RTSSuccessCount += (unsigned long long)  (dwCounter & 0x000000ff);
 	p802_11Counter->RTSFailureCount += (unsigned long long) ((dwCounter & 0x0000ff00) >> 8);
 	p802_11Counter->ACKFailureCount += (unsigned long long) ((dwCounter & 0x00ff0000) >> 16);
 	p802_11Counter->FCSErrorCount +=   (unsigned long long) ((dwCounter & 0xff000000) >> 24);
-	p802_11Counter->MulticastReceivedFrameCount = (unsigned long long) (pStatistic->dwRsrBroadcast +
-									    pStatistic->dwRsrMulticast);
-}
-
-/*
- * Description: Clear 802.11 mib counter
- *
- * Parameters:
- *  In:
- *      p802_11Counter  - Pointer to 802.11 mib counter
- *  Out:
- *      none
- *
- * Return Value: none
- *
- */
-void
-STAvClear802_11Counter(PSDot11Counters p802_11Counter)
-{
-	// set memory to zero
-	memset(p802_11Counter, 0, sizeof(SDot11Counters));
 }
diff --git a/drivers/staging/vt6655/mib.h b/drivers/staging/vt6655/mib.h
index 732bdda..fdb40f2 100644
--- a/drivers/staging/vt6655/mib.h
+++ b/drivers/staging/vt6655/mib.h
@@ -38,136 +38,16 @@
 //
 
 typedef struct tagSDot11Counters {
-	unsigned long Length;
-	unsigned long long   TransmittedFragmentCount;
-	unsigned long long   MulticastTransmittedFrameCount;
-	unsigned long long   FailedCount;
-	unsigned long long   RetryCount;
-	unsigned long long   MultipleRetryCount;
 	unsigned long long   RTSSuccessCount;
 	unsigned long long   RTSFailureCount;
 	unsigned long long   ACKFailureCount;
-	unsigned long long   FrameDuplicateCount;
-	unsigned long long   ReceivedFragmentCount;
-	unsigned long long   MulticastReceivedFrameCount;
 	unsigned long long   FCSErrorCount;
-	unsigned long long   TKIPLocalMICFailures;
-	unsigned long long   TKIPRemoteMICFailures;
-	unsigned long long   TKIPICVErrors;
-	unsigned long long   TKIPCounterMeasuresInvoked;
-	unsigned long long   TKIPReplays;
-	unsigned long long   CCMPFormatErrors;
-	unsigned long long   CCMPReplays;
-	unsigned long long   CCMPDecryptErrors;
-	unsigned long long   FourWayHandshakeFailures;
 } SDot11Counters, *PSDot11Counters;
 
 //
-// MIB2 counter
-//
-typedef struct tagSMib2Counter {
-	long    ifIndex;
-	char    ifDescr[256];
-	long    ifType;
-	long    ifMtu;
-	unsigned long ifSpeed;
-	unsigned char ifPhysAddress[ETH_ALEN];
-	long    ifAdminStatus;
-	long    ifOperStatus;
-	unsigned long ifLastChange;
-	unsigned long ifInOctets;
-	unsigned long ifInUcastPkts;
-	unsigned long ifInNUcastPkts;
-	unsigned long ifInDiscards;
-	unsigned long ifInErrors;
-	unsigned long ifInUnknownProtos;
-	unsigned long ifOutOctets;
-	unsigned long ifOutUcastPkts;
-	unsigned long ifOutNUcastPkts;
-	unsigned long ifOutDiscards;
-	unsigned long ifOutErrors;
-	unsigned long ifOutQLen;
-	unsigned long ifSpecific;
-} SMib2Counter, *PSMib2Counter;
-
-// Value in the ifType entry
-#define WIRELESSLANIEEE80211b      6
-
-// Value in the ifAdminStatus/ifOperStatus entry
-#define UP                  1
-#define DOWN                2
-#define TESTING             3
-
-//
-// RMON counter
-//
-typedef struct tagSRmonCounter {
-	long    etherStatsIndex;
-	unsigned long etherStatsDataSource;
-	unsigned long etherStatsDropEvents;
-	unsigned long etherStatsOctets;
-	unsigned long etherStatsPkts;
-	unsigned long etherStatsBroadcastPkts;
-	unsigned long etherStatsMulticastPkts;
-	unsigned long etherStatsCRCAlignErrors;
-	unsigned long etherStatsUndersizePkts;
-	unsigned long etherStatsOversizePkts;
-	unsigned long etherStatsFragments;
-	unsigned long etherStatsJabbers;
-	unsigned long etherStatsCollisions;
-	unsigned long etherStatsPkt64Octets;
-	unsigned long etherStatsPkt65to127Octets;
-	unsigned long etherStatsPkt128to255Octets;
-	unsigned long etherStatsPkt256to511Octets;
-	unsigned long etherStatsPkt512to1023Octets;
-	unsigned long etherStatsPkt1024to1518Octets;
-	unsigned long etherStatsOwners;
-	unsigned long etherStatsStatus;
-} SRmonCounter, *PSRmonCounter;
-
-//
-// Custom counter
-//
-typedef struct tagSCustomCounters {
-	unsigned long Length;
-
-	unsigned long long   ullTsrAllOK;
-
-	unsigned long long   ullRsr11M;
-	unsigned long long   ullRsr5M;
-	unsigned long long   ullRsr2M;
-	unsigned long long   ullRsr1M;
-
-	unsigned long long   ullRsr11MCRCOk;
-	unsigned long long   ullRsr5MCRCOk;
-	unsigned long long   ullRsr2MCRCOk;
-	unsigned long long   ullRsr1MCRCOk;
-
-	unsigned long long   ullRsr54M;
-	unsigned long long   ullRsr48M;
-	unsigned long long   ullRsr36M;
-	unsigned long long   ullRsr24M;
-	unsigned long long   ullRsr18M;
-	unsigned long long   ullRsr12M;
-	unsigned long long   ullRsr9M;
-	unsigned long long   ullRsr6M;
-
-	unsigned long long   ullRsr54MCRCOk;
-	unsigned long long   ullRsr48MCRCOk;
-	unsigned long long   ullRsr36MCRCOk;
-	unsigned long long   ullRsr24MCRCOk;
-	unsigned long long   ullRsr18MCRCOk;
-	unsigned long long   ullRsr12MCRCOk;
-	unsigned long long   ullRsr9MCRCOk;
-	unsigned long long   ullRsr6MCRCOk;
-} SCustomCounters, *PSCustomCounters;
-
-//
 // Custom counter
 //
 typedef struct tagSISRCounters {
-	unsigned long Length;
-
 	unsigned long dwIsrTx0OK;
 	unsigned long dwIsrAC0TxOK;
 	unsigned long dwIsrBeaconTxOK;
@@ -183,161 +63,22 @@ typedef struct tagSISRCounters {
 	unsigned long dwIsrUnknown;
 
 	unsigned long dwIsrRx1OK;
-	unsigned long dwIsrATIMTxOK;
-	unsigned long dwIsrSYNCTxOK;
-	unsigned long dwIsrCFPEnd;
-	unsigned long dwIsrATIMEnd;
-	unsigned long dwIsrSYNCFlushOK;
 	unsigned long dwIsrSTIMER1Int;
 } SISRCounters, *PSISRCounters;
 
-// Value in the etherStatsStatus entry
-#define VALID               1
-#define CREATE_REQUEST      2
-#define UNDER_CREATION      3
-#define INVALID             4
-
 //
 // statistic counter
 //
 typedef struct tagSStatCounter {
-	// RSR status count
-	//
-	unsigned long dwRsrFrmAlgnErr;
-	unsigned long dwRsrErr;
-	unsigned long dwRsrCRCErr;
-	unsigned long dwRsrCRCOk;
-	unsigned long dwRsrBSSIDOk;
-	unsigned long dwRsrADDROk;
-	unsigned long dwRsrBCNSSIDOk;
-	unsigned long dwRsrLENErr;
-	unsigned long dwRsrTYPErr;
-
-	unsigned long dwNewRsrDECRYPTOK;
-	unsigned long dwNewRsrCFP;
-	unsigned long dwNewRsrUTSF;
-	unsigned long dwNewRsrHITAID;
-	unsigned long dwNewRsrHITAID0;
-
-	unsigned long dwRsrLong;
-	unsigned long dwRsrRunt;
-
-	unsigned long dwRsrRxControl;
-	unsigned long dwRsrRxData;
-	unsigned long dwRsrRxManage;
-
-	unsigned long dwRsrRxPacket;
-	unsigned long dwRsrRxOctet;
-	unsigned long dwRsrBroadcast;
-	unsigned long dwRsrMulticast;
-	unsigned long dwRsrDirected;
-	// 64-bit OID
-	unsigned long long   ullRsrOK;
-
-	// for some optional OIDs (64 bits) and DMI support
-	unsigned long long   ullRxBroadcastBytes;
-	unsigned long long   ullRxMulticastBytes;
-	unsigned long long   ullRxDirectedBytes;
-	unsigned long long   ullRxBroadcastFrames;
-	unsigned long long   ullRxMulticastFrames;
-	unsigned long long   ullRxDirectedFrames;
-
-	unsigned long dwRsrRxFragment;
-	unsigned long dwRsrRxFrmLen64;
-	unsigned long dwRsrRxFrmLen65_127;
-	unsigned long dwRsrRxFrmLen128_255;
-	unsigned long dwRsrRxFrmLen256_511;
-	unsigned long dwRsrRxFrmLen512_1023;
-	unsigned long dwRsrRxFrmLen1024_1518;
-
-	// TSR status count
-	//
-	unsigned long dwTsrTotalRetry[TYPE_MAXTD];        // total collision retry count
-	unsigned long dwTsrOnceRetry[TYPE_MAXTD];         // this packet only occur one collision
-	unsigned long dwTsrMoreThanOnceRetry[TYPE_MAXTD]; // this packet occur more than one collision
-	unsigned long dwTsrRetry[TYPE_MAXTD];             // this packet has ever occur collision,
-	// that is (dwTsrOnceCollision0 + dwTsrMoreThanOnceCollision0)
-	unsigned long dwTsrACKData[TYPE_MAXTD];
-	unsigned long dwTsrErr[TYPE_MAXTD];
-	unsigned long dwAllTsrOK[TYPE_MAXTD];
-	unsigned long dwTsrRetryTimeout[TYPE_MAXTD];
-	unsigned long dwTsrTransmitTimeout[TYPE_MAXTD];
-
-	unsigned long dwTsrTxPacket[TYPE_MAXTD];
-	unsigned long dwTsrTxOctet[TYPE_MAXTD];
-	unsigned long dwTsrBroadcast[TYPE_MAXTD];
-	unsigned long dwTsrMulticast[TYPE_MAXTD];
-	unsigned long dwTsrDirected[TYPE_MAXTD];
-
-	// RD/TD count
-	unsigned long dwCntRxFrmLength;
-	unsigned long dwCntTxBufLength;
-
-	unsigned char abyCntRxPattern[16];
-	unsigned char abyCntTxPattern[16];
-
-	// Software check....
-	unsigned long dwCntRxDataErr;             // rx buffer data software compare CRC err count
-	unsigned long dwCntDecryptErr;            // rx buffer data software compare CRC err count
-	unsigned long dwCntRxICVErr;              // rx buffer data software compare CRC err count
-	unsigned int idxRxErrorDesc[TYPE_MAXRD]; // index for rx data error RD
-
-	// 64-bit OID
-	unsigned long long   ullTsrOK[TYPE_MAXTD];
-
-	// for some optional OIDs (64 bits) and DMI support
-	unsigned long long   ullTxBroadcastFrames[TYPE_MAXTD];
-	unsigned long long   ullTxMulticastFrames[TYPE_MAXTD];
-	unsigned long long   ullTxDirectedFrames[TYPE_MAXTD];
-	unsigned long long   ullTxBroadcastBytes[TYPE_MAXTD];
-	unsigned long long   ullTxMulticastBytes[TYPE_MAXTD];
-	unsigned long long   ullTxDirectedBytes[TYPE_MAXTD];
-
 	SISRCounters ISRStat;
-
-	SCustomCounters CustomStat;
-
-#ifdef Calcu_LinkQual
-	//Tx count:
-	unsigned long TxNoRetryOkCount;
-	unsigned long TxRetryOkCount;
-	unsigned long TxFailCount;
-	//Rx count:
-	unsigned long RxOkCnt;
-	unsigned long RxFcsErrCnt;
-	//statistic
-	unsigned long SignalStren;
-	unsigned long LinkQuality;
-#endif
 } SStatCounter, *PSStatCounter;
 
-void STAvClearAllCounter(PSStatCounter pStatistic);
-
 void STAvUpdateIsrStatCounter(PSStatCounter pStatistic, unsigned long dwIsr);
 
-void STAvUpdateRDStatCounter(PSStatCounter pStatistic,
-			     unsigned char byRSR, unsigned char byNewRSR, unsigned char byRxRate,
-			     unsigned char *pbyBuffer, unsigned int cbFrameLength);
-
-void STAvUpdateRDStatCounterEx(PSStatCounter pStatistic,
-			       unsigned char byRSR, unsigned char byNewRsr, unsigned char byRxRate,
-			       unsigned char *pbyBuffer, unsigned int cbFrameLength);
-
-void STAvUpdateTDStatCounter(PSStatCounter pStatistic, unsigned char byTSR0, unsigned char byTSR1,
-			     unsigned char *pbyBuffer, unsigned int cbFrameLength, unsigned int uIdx);
-
-void STAvUpdateTDStatCounterEx(
-	PSStatCounter   pStatistic,
-	unsigned char *pbyBuffer,
-	unsigned long cbFrameLength
-);
-
 void STAvUpdate802_11Counter(
 	PSDot11Counters p802_11Counter,
 	PSStatCounter   pStatistic,
 	unsigned long dwCounter
 );
 
-void STAvClear802_11Counter(PSDot11Counters p802_11Counter);
-
 #endif // __MIB_H__
-- 
2.1.0

