Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:54812 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822AbaBPTKt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Feb 2014 14:10:49 -0500
Received: by mail-we0-f181.google.com with SMTP id w61so10144399wes.12
        for <linux-wireless@vger.kernel.org>; Sun, 16 Feb 2014 11:10:48 -0800 (PST)
Message-ID: <1392577818.3430.10.camel@canaries64-MCP7A> (sfid-20140216_201053_056790_ED458582)
Subject: [PATCH  3/3] staging: vt6656: Clean up and remove camel case
 INTnsProcessData.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Sun, 16 Feb 2014 19:10:18 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Camel Case changes
pDevice -> priv
pINTData -> int_data
pStats -> stats

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/int.c | 141 +++++++++++++++++++++----------------------
 1 file changed, 70 insertions(+), 71 deletions(-)

diff --git a/drivers/staging/vt6656/int.c b/drivers/staging/vt6656/int.c
index 0094887..ec135b4 100644
--- a/drivers/staging/vt6656/int.c
+++ b/drivers/staging/vt6656/int.c
@@ -75,112 +75,111 @@ void INTvWorkItem(struct vnt_private *pDevice)
 	spin_unlock_irq(&pDevice->lock);
 }
 
-void INTnsProcessData(struct vnt_private *pDevice)
+void INTnsProcessData(struct vnt_private *priv)
 {
-	struct vnt_interrupt_data *pINTData;
-	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
-	struct net_device_stats *pStats = &pDevice->stats;
+	struct vnt_interrupt_data *int_data;
+	struct vnt_manager *mgmt = &priv->vnt_mgmt;
+	struct net_device_stats *stats = &priv->stats;
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"---->s_nsInterruptProcessData\n");
 
-	pINTData = (struct vnt_interrupt_data *)pDevice->intBuf.pDataBuf;
-	if (pINTData->tsr0 & TSR_VALID) {
-		if (pINTData->tsr0 & (TSR_TMO | TSR_RETRYTMO))
-			pDevice->wstats.discard.retries++;
+	int_data = (struct vnt_interrupt_data *)priv->intBuf.pDataBuf;
+
+	if (int_data->tsr0 & TSR_VALID) {
+		if (int_data->tsr0 & (TSR_TMO | TSR_RETRYTMO))
+			priv->wstats.discard.retries++;
 		else
-			pStats->tx_packets++;
+			stats->tx_packets++;
 
-		BSSvUpdateNodeTxCounter(pDevice,
-					pINTData->tsr0,
-					pINTData->pkt0);
+		BSSvUpdateNodeTxCounter(priv,
+					int_data->tsr0,
+					int_data->pkt0);
 	}
-	if (pINTData->tsr1 & TSR_VALID) {
-		if (pINTData->tsr1 & (TSR_TMO | TSR_RETRYTMO))
-			pDevice->wstats.discard.retries++;
+
+	if (int_data->tsr1 & TSR_VALID) {
+		if (int_data->tsr1 & (TSR_TMO | TSR_RETRYTMO))
+			priv->wstats.discard.retries++;
 		else
-			pStats->tx_packets++;
+			stats->tx_packets++;
 
 
-		BSSvUpdateNodeTxCounter(pDevice,
-					pINTData->tsr1,
-					pINTData->pkt1);
+		BSSvUpdateNodeTxCounter(priv,
+					int_data->tsr1,
+					int_data->pkt1);
 	}
-	if (pINTData->tsr2 & TSR_VALID) {
-		if (pINTData->tsr2 & (TSR_TMO | TSR_RETRYTMO))
-			pDevice->wstats.discard.retries++;
+
+	if (int_data->tsr2 & TSR_VALID) {
+		if (int_data->tsr2 & (TSR_TMO | TSR_RETRYTMO))
+			priv->wstats.discard.retries++;
 		else
-			pStats->tx_packets++;
+			stats->tx_packets++;
 
-		BSSvUpdateNodeTxCounter(pDevice,
-					pINTData->tsr2,
-					pINTData->pkt2);
-		/*DBG_PRN_GRP01(("TSR2 %02x\n", pINTData->byTSR2));*/
+		BSSvUpdateNodeTxCounter(priv,
+					int_data->tsr2,
+					int_data->pkt2);
 	}
-	if (pINTData->tsr3 & TSR_VALID) {
-		if (pINTData->tsr3 & (TSR_TMO | TSR_RETRYTMO))
-			pDevice->wstats.discard.retries++;
+
+	if (int_data->tsr3 & TSR_VALID) {
+		if (int_data->tsr3 & (TSR_TMO | TSR_RETRYTMO))
+			priv->wstats.discard.retries++;
 		else
-			pStats->tx_packets++;
+			stats->tx_packets++;
 
-		BSSvUpdateNodeTxCounter(pDevice,
-					pINTData->tsr3,
-					pINTData->pkt3);
-		/*DBG_PRN_GRP01(("TSR3 %02x\n", pINTData->byTSR3));*/
+		BSSvUpdateNodeTxCounter(priv,
+					int_data->tsr3,
+					int_data->pkt3);
 	}
-	if (pINTData->isr0 != 0) {
-		if (pINTData->isr0 & ISR_BNTX) {
-			if (pDevice->op_mode == NL80211_IFTYPE_AP) {
-				if (pMgmt->byDTIMCount > 0) {
-					pMgmt->byDTIMCount--;
-					pMgmt->sNodeDBTable[0].bRxPSPoll =
+
+	if (int_data->isr0 != 0) {
+		if (int_data->isr0 & ISR_BNTX) {
+			if (priv->op_mode == NL80211_IFTYPE_AP) {
+				if (mgmt->byDTIMCount > 0) {
+					mgmt->byDTIMCount--;
+					mgmt->sNodeDBTable[0].bRxPSPoll =
 						false;
-				} else if (pMgmt->byDTIMCount == 0) {
+				} else if (mgmt->byDTIMCount == 0) {
 					/* check if multicast tx buffering */
-					pMgmt->byDTIMCount =
-						pMgmt->byDTIMPeriod-1;
-					pMgmt->sNodeDBTable[0].bRxPSPoll = true;
-					if (pMgmt->sNodeDBTable[0].bPSEnable)
-						bScheduleCommand((void *) pDevice,
+					mgmt->byDTIMCount =
+						mgmt->byDTIMPeriod-1;
+					mgmt->sNodeDBTable[0].bRxPSPoll = true;
+					if (mgmt->sNodeDBTable[0].bPSEnable)
+						bScheduleCommand((void *) priv,
 								 WLAN_CMD_RX_PSPOLL,
 								 NULL);
 				}
-				bScheduleCommand((void *) pDevice,
+				bScheduleCommand((void *) priv,
 						WLAN_CMD_BECON_SEND,
 						NULL);
 			}
-		pDevice->bBeaconSent = true;
+			priv->bBeaconSent = true;
 		} else {
-			pDevice->bBeaconSent = false;
+			priv->bBeaconSent = false;
 		}
-		if (pINTData->isr0 & ISR_TBTT) {
-			if (pDevice->bEnablePSMode)
-				bScheduleCommand((void *) pDevice,
+
+		if (int_data->isr0 & ISR_TBTT) {
+			if (priv->bEnablePSMode)
+				bScheduleCommand((void *) priv,
 						WLAN_CMD_TBTT_WAKEUP,
 						NULL);
-			if (pDevice->bChannelSwitch) {
-				pDevice->byChannelSwitchCount--;
-				if (pDevice->byChannelSwitchCount == 0)
-					bScheduleCommand((void *) pDevice,
+			if (priv->bChannelSwitch) {
+				priv->byChannelSwitchCount--;
+				if (priv->byChannelSwitchCount == 0)
+					bScheduleCommand((void *) priv,
 							WLAN_CMD_11H_CHSW,
 							NULL);
 			}
 		}
-		pDevice->qwCurrTSF = le64_to_cpu(pINTData->tsf);
-		/*DBG_PRN_GRP01(("ISR0 = %02x ,
-		  LoTsf =  %08x,
-		  HiTsf =  %08x\n",
-		  pINTData->byISR0,
-		  pINTData->dwLoTSF,
-		  pINTData->dwHiTSF)); */
+		priv->qwCurrTSF = le64_to_cpu(int_data->tsf);
 	}
-	if (pINTData->isr1 != 0)
-		if (pINTData->isr1 & ISR_GPIO3)
-			bScheduleCommand((void *) pDevice,
+
+	if (int_data->isr1 != 0)
+		if (int_data->isr1 & ISR_GPIO3)
+			bScheduleCommand((void *) priv,
 					WLAN_CMD_RADIO,
 					NULL);
-	pDevice->intBuf.uDataLen = 0;
-	pDevice->intBuf.bInUse = false;
+	priv->intBuf.uDataLen = 0;
+	priv->intBuf.bInUse = false;
 
-	pStats->tx_errors = pDevice->wstats.discard.retries;
-	pStats->tx_dropped = pDevice->wstats.discard.retries;
+	stats->tx_errors = priv->wstats.discard.retries;
+	stats->tx_dropped = priv->wstats.discard.retries;
 }
-- 
1.9.rc1

