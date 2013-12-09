Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:58663 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753214Ab3LIWXZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Dec 2013 17:23:25 -0500
Received: by mail-we0-f171.google.com with SMTP id q58so4179669wes.30
        for <linux-wireless@vger.kernel.org>; Mon, 09 Dec 2013 14:23:24 -0800 (PST)
Message-ID: <1386627799.14057.1.camel@canaries64-MCP7A> (sfid-20131209_232329_111567_3D9CC9F4)
Subject: [PATCH 1/4] staging: vt6656: Remove STAvUpdateTDStatCounter and
 apply directly  to stats
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Mon, 09 Dec 2013 22:23:19 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Apply directly to net_device_stats and wireless stats.

tx_bytes are relayed from s_vSaveTxPktInfo via scStatistic,
so collect them there.

All other statistics in STAvUpdateTDStatCounter are dead code
and don't reach user.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/int.c   | 45 ++++++++++-----------
 drivers/staging/vt6656/iwctl.c |  1 -
 drivers/staging/vt6656/mib.c   | 89 ------------------------------------------
 drivers/staging/vt6656/mib.h   |  3 --
 drivers/staging/vt6656/rxtx.c  |  3 ++
 5 files changed, 26 insertions(+), 115 deletions(-)

diff --git a/drivers/staging/vt6656/int.c b/drivers/staging/vt6656/int.c
index a2b4ba6..abbffa1 100644
--- a/drivers/staging/vt6656/int.c
+++ b/drivers/staging/vt6656/int.c
@@ -86,10 +86,11 @@ void INTnsProcessData(struct vnt_private *pDevice)
 
 	pINTData = (PSINTData) pDevice->intBuf.pDataBuf;
 	if (pINTData->byTSR0 & TSR_VALID) {
-		STAvUpdateTDStatCounter(&(pDevice->scStatistic),
-					(u8)(pINTData->byPkt0 & 0x0F),
-					(u8)(pINTData->byPkt0>>4),
-					pINTData->byTSR0);
+		if (pINTData->byTSR0 & (TSR_TMO | TSR_RETRYTMO))
+			pDevice->wstats.discard.retries++;
+		else
+			pStats->tx_packets++;
+
 		BSSvUpdateNodeTxCounter(pDevice,
 					&(pDevice->scStatistic),
 					pINTData->byTSR0,
@@ -97,10 +98,12 @@ void INTnsProcessData(struct vnt_private *pDevice)
 		/*DBG_PRN_GRP01(("TSR0 %02x\n", pINTData->byTSR0));*/
 	}
 	if (pINTData->byTSR1 & TSR_VALID) {
-		STAvUpdateTDStatCounter(&(pDevice->scStatistic),
-					(u8)(pINTData->byPkt1 & 0x0F),
-					(u8)(pINTData->byPkt1>>4),
-					pINTData->byTSR1);
+		if (pINTData->byTSR1 & (TSR_TMO | TSR_RETRYTMO))
+			pDevice->wstats.discard.retries++;
+		else
+			pStats->tx_packets++;
+
+
 		BSSvUpdateNodeTxCounter(pDevice,
 					&(pDevice->scStatistic),
 					pINTData->byTSR1,
@@ -108,10 +111,11 @@ void INTnsProcessData(struct vnt_private *pDevice)
 		/*DBG_PRN_GRP01(("TSR1 %02x\n", pINTData->byTSR1));*/
 	}
 	if (pINTData->byTSR2 & TSR_VALID) {
-		STAvUpdateTDStatCounter(&(pDevice->scStatistic),
-					(u8)(pINTData->byPkt2 & 0x0F),
-					(u8)(pINTData->byPkt2>>4),
-					pINTData->byTSR2);
+		if (pINTData->byTSR2 & (TSR_TMO | TSR_RETRYTMO))
+			pDevice->wstats.discard.retries++;
+		else
+			pStats->tx_packets++;
+
 		BSSvUpdateNodeTxCounter(pDevice,
 					&(pDevice->scStatistic),
 					pINTData->byTSR2,
@@ -119,10 +123,11 @@ void INTnsProcessData(struct vnt_private *pDevice)
 		/*DBG_PRN_GRP01(("TSR2 %02x\n", pINTData->byTSR2));*/
 	}
 	if (pINTData->byTSR3 & TSR_VALID) {
-		STAvUpdateTDStatCounter(&(pDevice->scStatistic),
-					(u8)(pINTData->byPkt3 & 0x0F),
-					(u8)(pINTData->byPkt3>>4),
-					pINTData->byTSR3);
+		if (pINTData->byTSR3 & (TSR_TMO | TSR_RETRYTMO))
+			pDevice->wstats.discard.retries++;
+		else
+			pStats->tx_packets++;
+
 		BSSvUpdateNodeTxCounter(pDevice,
 					&(pDevice->scStatistic),
 					pINTData->byTSR3,
@@ -193,10 +198,6 @@ void INTnsProcessData(struct vnt_private *pDevice)
 	pDevice->intBuf.uDataLen = 0;
 	pDevice->intBuf.bInUse = false;
 
-	pStats->tx_packets = pDevice->scStatistic.ullTsrOK;
-	pStats->tx_bytes = pDevice->scStatistic.ullTxDirectedBytes +
-		pDevice->scStatistic.ullTxMulticastBytes +
-		pDevice->scStatistic.ullTxBroadcastBytes;
-	pStats->tx_errors = pDevice->scStatistic.dwTsrErr;
-	pStats->tx_dropped = pDevice->scStatistic.dwTsrErr;
+	pStats->tx_errors = pDevice->wstats.discard.retries;
+	pStats->tx_dropped = pDevice->wstats.discard.retries;
 }
diff --git a/drivers/staging/vt6656/iwctl.c b/drivers/staging/vt6656/iwctl.c
index 63917ab..183c5a2 100644
--- a/drivers/staging/vt6656/iwctl.c
+++ b/drivers/staging/vt6656/iwctl.c
@@ -68,7 +68,6 @@ struct iw_statistics *iwctl_get_wireless_stats(struct net_device *dev)
 	pDevice->wstats.discard.nwid = 0;
 	pDevice->wstats.discard.code = 0;
 	pDevice->wstats.discard.fragment = 0;
-	pDevice->wstats.discard.retries = pDevice->scStatistic.dwTsrErr;
 	pDevice->wstats.discard.misc = 0;
 	pDevice->wstats.miss.beacon = 0;
 	return &pDevice->wstats;
diff --git a/drivers/staging/vt6656/mib.c b/drivers/staging/vt6656/mib.c
index 12333cd..002f2b2 100644
--- a/drivers/staging/vt6656/mib.c
+++ b/drivers/staging/vt6656/mib.c
@@ -334,95 +334,6 @@ void STAvUpdateRDStatCounter(PSStatCounter pStatistic,
 }
 
 /*
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
-STAvUpdateTDStatCounter (
-    PSStatCounter   pStatistic,
-    u8            byPktNum,
-    u8            byRate,
-    u8            byTSR
-    )
-{
-    u8    byRetyCnt;
-    // increase tx packet count
-    pStatistic->dwTsrTxPacket++;
-
-    byRetyCnt = (byTSR & 0xF0) >> 4;
-    if (byRetyCnt != 0) {
-        pStatistic->dwTsrRetry++;
-        pStatistic->dwTsrTotalRetry += byRetyCnt;
-        pStatistic->dwTxFail[byRate]+= byRetyCnt;
-        pStatistic->dwTxFail[MAX_RATE] += byRetyCnt;
-
-        if ( byRetyCnt == 0x1)
-            pStatistic->dwTsrOnceRetry++;
-        else
-            pStatistic->dwTsrMoreThanOnceRetry++;
-
-        if (byRetyCnt <= 8)
-            pStatistic->dwTxRetryCount[byRetyCnt-1]++;
-
-    }
-    if ( !(byTSR & (TSR_TMO | TSR_RETRYTMO))) {
-
-   if (byRetyCnt < 2)
-        pStatistic->TxNoRetryOkCount ++;
-   else
-        pStatistic->TxRetryOkCount ++;
-
-        pStatistic->ullTsrOK++;
-        pStatistic->CustomStat.ullTsrAllOK++;
-        // update counters in case that successful transmit
-        pStatistic->dwTxOk[byRate]++;
-        pStatistic->dwTxOk[MAX_RATE]++;
-
-        if ( pStatistic->abyTxPktInfo[byPktNum].byBroadMultiUni == TX_PKT_BROAD )  {
-            pStatistic->ullTxBroadcastFrames++;
-            pStatistic->ullTxBroadcastBytes += pStatistic->abyTxPktInfo[byPktNum].wLength;
-        } else if ( pStatistic->abyTxPktInfo[byPktNum].byBroadMultiUni == TX_PKT_MULTI ) {
-            pStatistic->ullTxMulticastFrames++;
-            pStatistic->ullTxMulticastBytes += pStatistic->abyTxPktInfo[byPktNum].wLength;
-        } else if ( pStatistic->abyTxPktInfo[byPktNum].byBroadMultiUni == TX_PKT_UNI ) {
-            pStatistic->ullTxDirectedFrames++;
-            pStatistic->ullTxDirectedBytes += pStatistic->abyTxPktInfo[byPktNum].wLength;
-        }
-    }
-    else {
-
-        pStatistic->TxFailCount ++;
-
-        pStatistic->dwTsrErr++;
-        if (byTSR & TSR_RETRYTMO)
-            pStatistic->dwTsrRetryTimeout++;
-        if (byTSR & TSR_TMO)
-            pStatistic->dwTsrTransmitTimeout++;
-    }
-
-    if ( pStatistic->abyTxPktInfo[byPktNum].byBroadMultiUni == TX_PKT_BROAD )  {
-        pStatistic->dwTsrBroadcast++;
-    } else if ( pStatistic->abyTxPktInfo[byPktNum].byBroadMultiUni == TX_PKT_MULTI ) {
-        pStatistic->dwTsrMulticast++;
-    } else if ( pStatistic->abyTxPktInfo[byPktNum].byBroadMultiUni == TX_PKT_UNI ) {
-        pStatistic->dwTsrDirected++;
-    }
-}
-
-/*
  * Description: Update 802.11 mib counter
  *
  * Parameters:
diff --git a/drivers/staging/vt6656/mib.h b/drivers/staging/vt6656/mib.h
index 3537532..5616b9a 100644
--- a/drivers/staging/vt6656/mib.h
+++ b/drivers/staging/vt6656/mib.h
@@ -360,9 +360,6 @@ void STAvUpdateRDStatCounter(PSStatCounter pStatistic,
 			     u8 byRxRate, u8 * pbyBuffer,
 			     unsigned int cbFrameLength);
 
-void STAvUpdateTDStatCounter(PSStatCounter pStatistic, u8 byPktNum,
-			     u8 byRate, u8 byTSR);
-
 void
 STAvUpdate802_11Counter(
     PSDot11Counters         p802_11Counter,
diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 2db03d6..06290be 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -166,6 +166,7 @@ static struct vnt_usb_send_context
 static void s_vSaveTxPktInfo(struct vnt_private *pDevice, u8 byPktNum,
 	u8 *pbyDestAddr, u16 wPktLength, u16 wFIFOCtl)
 {
+	struct net_device_stats *stats = &pDevice->stats;
 	PSStatCounter pStatistic = &pDevice->scStatistic;
 
     if (is_broadcast_ether_addr(pbyDestAddr))
@@ -180,6 +181,8 @@ static void s_vSaveTxPktInfo(struct vnt_private *pDevice, u8 byPktNum,
     memcpy(pStatistic->abyTxPktInfo[byPktNum].abyDestAddr,
 	   pbyDestAddr,
 	   ETH_ALEN);
+
+	stats->tx_bytes += wPktLength;
 }
 
 static void s_vFillTxKey(struct vnt_private *pDevice,
-- 
1.8.3.2


