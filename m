Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:41310 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681Ab3LIWah (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Dec 2013 17:30:37 -0500
Received: by mail-we0-f173.google.com with SMTP id u57so4158341wes.4
        for <linux-wireless@vger.kernel.org>; Mon, 09 Dec 2013 14:30:36 -0800 (PST)
Message-ID: <1386628214.14057.7.camel@canaries64-MCP7A> (sfid-20131209_233041_406607_E19FBBD4)
Subject: [PATCH 4/4] staging: vt6656: Replace pStatistic->abyTxPktInfo with
 struct vnt_tx_pkt_info
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Mon, 09 Dec 2013 22:30:14 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Change s_vSaveTxPktInfo and BSSvUpdateNodeTxCounter to use vnt_tx_pkt_info
relayed to BSSvUpdateNodeTxCounter via INTnsProcessData.

pStatistic->abyTxPktInfo[byPktNum].byBroadMultiUni is unused and discarded.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/bssdb.c  |  8 ++++----
 drivers/staging/vt6656/bssdb.h  |  3 +--
 drivers/staging/vt6656/device.h |  7 +++++++
 drivers/staging/vt6656/int.c    |  4 ----
 drivers/staging/vt6656/rxtx.c   | 18 ++++--------------
 5 files changed, 16 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/vt6656/bssdb.c b/drivers/staging/vt6656/bssdb.c
index a0655a9..c3fab7b 100644
--- a/drivers/staging/vt6656/bssdb.c
+++ b/drivers/staging/vt6656/bssdb.c
@@ -1160,10 +1160,10 @@ else {
  *
 -*/
 
-void BSSvUpdateNodeTxCounter(struct vnt_private *pDevice,
-	PSStatCounter pStatistic, u8 byTSR, u8 byPktNO)
+void BSSvUpdateNodeTxCounter(struct vnt_private *pDevice, u8 byTSR, u8 byPktNO)
 {
 	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
+	struct vnt_tx_pkt_info *pkt_info = pDevice->pkt_info;
 	u32 uNodeIndex = 0;
 	u8 byTxRetry;
 	u16 wRate;
@@ -1177,8 +1177,8 @@ void BSSvUpdateNodeTxCounter(struct vnt_private *pDevice,
     byPktNum = (byPktNO & 0x0F) >> 4;
     byTxRetry = (byTSR & 0xF0) >> 4;
     wRate = (u16) (byPktNO & 0xF0) >> 4;
-    wFIFOCtl = pStatistic->abyTxPktInfo[byPktNum].wFIFOCtl;
-    pbyDestAddr = (u8 *) &( pStatistic->abyTxPktInfo[byPktNum].abyDestAddr[0]);
+    wFIFOCtl = pkt_info[byPktNum].fifo_ctl;
+    pbyDestAddr = pkt_info[byPktNum].dest_addr;
 
     if (wFIFOCtl & FIFOCTL_AUTO_FB_0) {
         byFallBack = AUTO_FB_0;
diff --git a/drivers/staging/vt6656/bssdb.h b/drivers/staging/vt6656/bssdb.h
index fc41855..8b28ef6 100644
--- a/drivers/staging/vt6656/bssdb.h
+++ b/drivers/staging/vt6656/bssdb.h
@@ -264,8 +264,7 @@ void BSSvUpdateAPNode(struct vnt_private *, u16 *pwCapInfo,
 
 void BSSvSecondCallBack(struct work_struct *work);
 
-void BSSvUpdateNodeTxCounter(struct vnt_private *, PSStatCounter pStatistic,
-	u8 byTSR, u8 byPktNO);
+void BSSvUpdateNodeTxCounter(struct vnt_private *, u8 byTSR, u8 byPktNO);
 
 void BSSvRemoveOneNode(struct vnt_private *, u32 uNodeIndex);
 
diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 82e1e6d..c58c69a 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -189,6 +189,12 @@ struct vnt_usb_send_context {
 	unsigned char Data[MAX_TOTAL_SIZE_WITH_ALL_HEADERS];
 };
 
+/* tx packet info for rxtx */
+struct vnt_tx_pkt_info {
+	u16 fifo_ctl;
+	u8 dest_addr[ETH_ALEN];
+};
+
 /* structure got from configuration file as user-desired default settings */
 typedef struct _DEFAULT_CONFIG {
 	signed int    ZoneType;
@@ -430,6 +436,7 @@ struct vnt_private {
 	/* Variables to track resources for the BULK Out Pipe */
 	struct vnt_usb_send_context *apTD[CB_MAX_TX_DESC];
 	u32 cbTD;
+	struct vnt_tx_pkt_info pkt_info[16];
 
 	/* Variables to track resources for the Interrupt In Pipe */
 	INT_BUFFER intBuf;
diff --git a/drivers/staging/vt6656/int.c b/drivers/staging/vt6656/int.c
index abbffa1..512bb5d 100644
--- a/drivers/staging/vt6656/int.c
+++ b/drivers/staging/vt6656/int.c
@@ -92,7 +92,6 @@ void INTnsProcessData(struct vnt_private *pDevice)
 			pStats->tx_packets++;
 
 		BSSvUpdateNodeTxCounter(pDevice,
-					&(pDevice->scStatistic),
 					pINTData->byTSR0,
 					pINTData->byPkt0);
 		/*DBG_PRN_GRP01(("TSR0 %02x\n", pINTData->byTSR0));*/
@@ -105,7 +104,6 @@ void INTnsProcessData(struct vnt_private *pDevice)
 

 		BSSvUpdateNodeTxCounter(pDevice,
-					&(pDevice->scStatistic),
 					pINTData->byTSR1,
 					pINTData->byPkt1);
 		/*DBG_PRN_GRP01(("TSR1 %02x\n", pINTData->byTSR1));*/
@@ -117,7 +115,6 @@ void INTnsProcessData(struct vnt_private *pDevice)
 			pStats->tx_packets++;
 
 		BSSvUpdateNodeTxCounter(pDevice,
-					&(pDevice->scStatistic),
 					pINTData->byTSR2,
 					pINTData->byPkt2);
 		/*DBG_PRN_GRP01(("TSR2 %02x\n", pINTData->byTSR2));*/
@@ -129,7 +126,6 @@ void INTnsProcessData(struct vnt_private *pDevice)
 			pStats->tx_packets++;
 
 		BSSvUpdateNodeTxCounter(pDevice,
-					&(pDevice->scStatistic),
 					pINTData->byTSR3,
 					pINTData->byPkt3);
 		/*DBG_PRN_GRP01(("TSR3 %02x\n", pINTData->byTSR3));*/
diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 06290be..3186971 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -167,20 +167,10 @@ static void s_vSaveTxPktInfo(struct vnt_private *pDevice, u8 byPktNum,
 	u8 *pbyDestAddr, u16 wPktLength, u16 wFIFOCtl)
 {
 	struct net_device_stats *stats = &pDevice->stats;
-	PSStatCounter pStatistic = &pDevice->scStatistic;
-
-    if (is_broadcast_ether_addr(pbyDestAddr))
-        pStatistic->abyTxPktInfo[byPktNum].byBroadMultiUni = TX_PKT_BROAD;
-    else if (is_multicast_ether_addr(pbyDestAddr))
-        pStatistic->abyTxPktInfo[byPktNum].byBroadMultiUni = TX_PKT_MULTI;
-    else
-        pStatistic->abyTxPktInfo[byPktNum].byBroadMultiUni = TX_PKT_UNI;
-
-    pStatistic->abyTxPktInfo[byPktNum].wLength = wPktLength;
-    pStatistic->abyTxPktInfo[byPktNum].wFIFOCtl = wFIFOCtl;
-    memcpy(pStatistic->abyTxPktInfo[byPktNum].abyDestAddr,
-	   pbyDestAddr,
-	   ETH_ALEN);
+	struct vnt_tx_pkt_info *pkt_info = pDevice->pkt_info;
+
+	pkt_info[byPktNum].fifo_ctl = wFIFOCtl;
+	memcpy(pkt_info[byPktNum].dest_addr, pbyDestAddr, ETH_ALEN);
 
 	stats->tx_bytes += wPktLength;
 }
-- 
1.8.3.2


