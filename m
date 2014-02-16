Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:47408 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987AbaBPTJu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Feb 2014 14:09:50 -0500
Received: by mail-wi0-f170.google.com with SMTP id hi5so1766897wib.1
        for <linux-wireless@vger.kernel.org>; Sun, 16 Feb 2014 11:09:49 -0800 (PST)
Message-ID: <1392577760.3430.9.camel@canaries64-MCP7A> (sfid-20140216_200953_690866_C7700C4A)
Subject: [PATCH 2/3] staging: vt6656: int : Replace typedef struct
 tagSINTData.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Sun, 16 Feb 2014 19:09:20 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

New struct vnt_interrupt_data removing the camel case from members.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/int.c | 48 +++++++++++++++++++++-----------------------
 drivers/staging/vt6656/int.h | 43 +++++++++++++++++++--------------------
 2 files changed, 44 insertions(+), 47 deletions(-)

diff --git a/drivers/staging/vt6656/int.c b/drivers/staging/vt6656/int.c
index 22d1ef5..0094887 100644
--- a/drivers/staging/vt6656/int.c
+++ b/drivers/staging/vt6656/int.c
@@ -77,60 +77,58 @@ void INTvWorkItem(struct vnt_private *pDevice)
 
 void INTnsProcessData(struct vnt_private *pDevice)
 {
-	PSINTData pINTData;
+	struct vnt_interrupt_data *pINTData;
 	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
 	struct net_device_stats *pStats = &pDevice->stats;
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"---->s_nsInterruptProcessData\n");
 
-	pINTData = (PSINTData) pDevice->intBuf.pDataBuf;
-	if (pINTData->byTSR0 & TSR_VALID) {
-		if (pINTData->byTSR0 & (TSR_TMO | TSR_RETRYTMO))
+	pINTData = (struct vnt_interrupt_data *)pDevice->intBuf.pDataBuf;
+	if (pINTData->tsr0 & TSR_VALID) {
+		if (pINTData->tsr0 & (TSR_TMO | TSR_RETRYTMO))
 			pDevice->wstats.discard.retries++;
 		else
 			pStats->tx_packets++;
 
 		BSSvUpdateNodeTxCounter(pDevice,
-					pINTData->byTSR0,
-					pINTData->byPkt0);
-		/*DBG_PRN_GRP01(("TSR0 %02x\n", pINTData->byTSR0));*/
+					pINTData->tsr0,
+					pINTData->pkt0);
 	}
-	if (pINTData->byTSR1 & TSR_VALID) {
-		if (pINTData->byTSR1 & (TSR_TMO | TSR_RETRYTMO))
+	if (pINTData->tsr1 & TSR_VALID) {
+		if (pINTData->tsr1 & (TSR_TMO | TSR_RETRYTMO))
 			pDevice->wstats.discard.retries++;
 		else
 			pStats->tx_packets++;
 
 
 		BSSvUpdateNodeTxCounter(pDevice,
-					pINTData->byTSR1,
-					pINTData->byPkt1);
-		/*DBG_PRN_GRP01(("TSR1 %02x\n", pINTData->byTSR1));*/
+					pINTData->tsr1,
+					pINTData->pkt1);
 	}
-	if (pINTData->byTSR2 & TSR_VALID) {
-		if (pINTData->byTSR2 & (TSR_TMO | TSR_RETRYTMO))
+	if (pINTData->tsr2 & TSR_VALID) {
+		if (pINTData->tsr2 & (TSR_TMO | TSR_RETRYTMO))
 			pDevice->wstats.discard.retries++;
 		else
 			pStats->tx_packets++;
 
 		BSSvUpdateNodeTxCounter(pDevice,
-					pINTData->byTSR2,
-					pINTData->byPkt2);
+					pINTData->tsr2,
+					pINTData->pkt2);
 		/*DBG_PRN_GRP01(("TSR2 %02x\n", pINTData->byTSR2));*/
 	}
-	if (pINTData->byTSR3 & TSR_VALID) {
-		if (pINTData->byTSR3 & (TSR_TMO | TSR_RETRYTMO))
+	if (pINTData->tsr3 & TSR_VALID) {
+		if (pINTData->tsr3 & (TSR_TMO | TSR_RETRYTMO))
 			pDevice->wstats.discard.retries++;
 		else
 			pStats->tx_packets++;
 
 		BSSvUpdateNodeTxCounter(pDevice,
-					pINTData->byTSR3,
-					pINTData->byPkt3);
+					pINTData->tsr3,
+					pINTData->pkt3);
 		/*DBG_PRN_GRP01(("TSR3 %02x\n", pINTData->byTSR3));*/
 	}
-	if (pINTData->byISR0 != 0) {
-		if (pINTData->byISR0 & ISR_BNTX) {
+	if (pINTData->isr0 != 0) {
+		if (pINTData->isr0 & ISR_BNTX) {
 			if (pDevice->op_mode == NL80211_IFTYPE_AP) {
 				if (pMgmt->byDTIMCount > 0) {
 					pMgmt->byDTIMCount--;
@@ -154,7 +152,7 @@ void INTnsProcessData(struct vnt_private *pDevice)
 		} else {
 			pDevice->bBeaconSent = false;
 		}
-		if (pINTData->byISR0 & ISR_TBTT) {
+		if (pINTData->isr0 & ISR_TBTT) {
 			if (pDevice->bEnablePSMode)
 				bScheduleCommand((void *) pDevice,
 						WLAN_CMD_TBTT_WAKEUP,
@@ -175,8 +173,8 @@ void INTnsProcessData(struct vnt_private *pDevice)
 		  pINTData->dwLoTSF,
 		  pINTData->dwHiTSF)); */
 	}
-	if (pINTData->byISR1 != 0)
-		if (pINTData->byISR1 & ISR_GPIO3)
+	if (pINTData->isr1 != 0)
+		if (pINTData->isr1 & ISR_GPIO3)
 			bScheduleCommand((void *) pDevice,
 					WLAN_CMD_RADIO,
 					NULL);
diff --git a/drivers/staging/vt6656/int.h b/drivers/staging/vt6656/int.h
index 7ce6efc..08db868 100644
--- a/drivers/staging/vt6656/int.h
+++ b/drivers/staging/vt6656/int.h
@@ -32,29 +32,28 @@
 
 #include "device.h"
 
-typedef struct tagSINTData {
-	u8 byTSR0;
-	u8 byPkt0;
-	u16 wTime0;
-	u8 byTSR1;
-	u8 byPkt1;
-	u16 wTime1;
-	u8 byTSR2;
-	u8 byPkt2;
-	u16 wTime2;
-	u8 byTSR3;
-	u8 byPkt3;
-	u16 wTime3;
+struct vnt_interrupt_data {
+	u8 tsr0;
+	u8 pkt0;
+	u16 time0;
+	u8 tsr1;
+	u8 pkt1;
+	u16 time1;
+	u8 tsr2;
+	u8 pkt2;
+	u16 time2;
+	u8 tsr3;
+	u8 pkt3;
+	u16 time3;
 	__le64 tsf;
-	u8 byISR0;
-	u8 byISR1;
-	u8 byRTSSuccess;
-	u8 byRTSFail;
-	u8 byACKFail;
-	u8 byFCSErr;
-	u8 abySW[2];
-} __attribute__ ((__packed__))
-SINTData, *PSINTData;
+	u8 isr0;
+	u8 isr1;
+	u8 rts_success;
+	u8 rts_fail;
+	u8 ack_fail;
+	u8 fcs_err;
+	u8 sw[2];
+} __packed;
 
 void INTvWorkItem(struct vnt_private *);
 void INTnsProcessData(struct vnt_private *);
-- 
1.9.rc1

