Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:50049 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbaHJLWo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Aug 2014 07:22:44 -0400
Received: by mail-wg0-f44.google.com with SMTP id m15so7354988wgh.15
        for <linux-wireless@vger.kernel.org>; Sun, 10 Aug 2014 04:22:43 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 1/7] staging: vt6655: Remove TxInSleep macro
Date: Sun, 10 Aug 2014 12:21:56 +0100
Message-Id: <1407669722-2682-1-git-send-email-tvboxspy@gmail.com> (sfid-20140810_132249_043809_DE6F8BDE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

TxInSleep is always enabled remove the macro and any
else code.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device.h      | 2 --
 drivers/staging/vt6655/device_main.c | 6 ++----
 drivers/staging/vt6655/power.c       | 6 +-----
 drivers/staging/vt6655/rxtx.c        | 2 --
 drivers/staging/vt6655/ttype.h       | 4 ----
 drivers/staging/vt6655/wcmd.c        | 5 +----
 drivers/staging/vt6655/wcmd.h        | 3 +--
 drivers/staging/vt6655/wmgr.c        | 2 --
 8 files changed, 5 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/vt6655/device.h b/drivers/staging/vt6655/device.h
index 9bf0ea9..b857881 100644
--- a/drivers/staging/vt6655/device.h
+++ b/drivers/staging/vt6655/device.h
@@ -643,12 +643,10 @@ typedef struct __device_info {
 
 	// command timer
 	struct timer_list       sTimerCommand;
-#ifdef TxInSleep
 	struct timer_list       sTimerTxData;
 	unsigned long nTxDataTimeCout;
 	bool fTxDataInSleep;
 	bool IsTxDataTrigger;
-#endif
 
 #ifdef WPA_SM_Transtatus
 	bool fWPA_Authened;           //is WPA/WPA-PSK or WPA2/WPA2-PSK authen??
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index c78d06e..8b98ce2 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -1736,9 +1736,8 @@ static int  device_close(struct net_device *dev)
 		bScheduleCommand((void *)pDevice, WLAN_CMD_DISASSOCIATE, NULL);
 		mdelay(30);
 	}
-#ifdef TxInSleep
+
 	del_timer(&pDevice->sTimerTxData);
-#endif
 	del_timer(&pDevice->sTimerCommand);
 	del_timer(&pMgmt->sTimerSecondCallback);
 	if (pDevice->bDiversityRegCtlON) {
@@ -2248,9 +2247,8 @@ static int  device_xmit(struct sk_buff *skb, struct net_device *dev)
 	pLastTD->pTDInfo->skb = skb;
 	pLastTD->pTDInfo->byFlags = 0;
 	pLastTD->pTDInfo->byFlags |= TD_FLAGS_NETIF_SKB;
-#ifdef TxInSleep
 	pDevice->nTxDataTimeCout = 0; //2008-8-21 chester <add> for send null packet
-#endif
+
 	if (AVAIL_TD(pDevice, TYPE_AC0DMA) <= 1)
 		netif_stop_queue(dev);
 
diff --git a/drivers/staging/vt6655/power.c b/drivers/staging/vt6655/power.c
index 2a21cbd..f08c26f 100644
--- a/drivers/staging/vt6655/power.c
+++ b/drivers/staging/vt6655/power.c
@@ -274,13 +274,9 @@ PSbSendNullPacket(
 	if (!pDevice->bLinkPass)
 		return false;
 
-#ifdef TxInSleep
 	if (!pDevice->bEnablePSMode && !pDevice->fTxDataInSleep)
 		return false;
-#else
-	if (!pDevice->bEnablePSMode)
-		return false;
-#endif
+
 	if (pDevice->bEnablePSMode) {
 		for (uIdx = 0; uIdx < TYPE_MAXTD; uIdx++) {
 			if (pDevice->iTDUsed[uIdx] != 0)
diff --git a/drivers/staging/vt6655/rxtx.c b/drivers/staging/vt6655/rxtx.c
index 0866d9f..2270e2a 100644
--- a/drivers/staging/vt6655/rxtx.c
+++ b/drivers/staging/vt6655/rxtx.c
@@ -2326,9 +2326,7 @@ CMD_STATUS csMgmt_xmit(PSDevice pDevice, PSTxMgmtPacket pPacket)
 
 	pDevice->apCurrTD[TYPE_TXDMA0] = pFrstTD->next;
 
-#ifdef TxInSleep
 	pDevice->nTxDataTimeCout = 0; //2008-8-21 chester <add> for send null packet
-#endif
 
 	// Poll Transmit the adapter
 	MACvTransmit0(pDevice->PortOffset);
diff --git a/drivers/staging/vt6655/ttype.h b/drivers/staging/vt6655/ttype.h
index b1d8ae7..3f3a768 100644
--- a/drivers/staging/vt6655/ttype.h
+++ b/drivers/staging/vt6655/ttype.h
@@ -31,10 +31,6 @@
 
 /******* Common definitions and typedefs ***********************************/
 
-#ifndef TxInSleep
-#define TxInSleep
-#endif
-
 #ifndef WPA_SM_Transtatus
 #define WPA_SM_Transtatus
 #endif
diff --git a/drivers/staging/vt6655/wcmd.c b/drivers/staging/vt6655/wcmd.c
index f12eef0..16ed097 100644
--- a/drivers/staging/vt6655/wcmd.c
+++ b/drivers/staging/vt6655/wcmd.c
@@ -647,7 +647,6 @@ vCommandTimer(
 			if (netif_queue_stopped(pDevice->dev))
 				netif_wake_queue(pDevice->dev);
 
-#ifdef TxInSleep
 			if (pDevice->IsTxDataTrigger) {    //TxDataTimer is not triggered at the first time
 				del_timer(&pDevice->sTimerTxData);
 				init_timer(&pDevice->sTimerTxData);
@@ -660,7 +659,7 @@ vCommandTimer(
 
 			pDevice->IsTxDataTrigger = true;
 			add_timer(&pDevice->sTimerTxData);
-#endif
+
 		} else if (pMgmt->eCurrState < WMAC_STATE_ASSOCPENDING) {
 			printk("WLAN_ASSOCIATE_WAIT:Association Fail???\n");
 		} else if (pDevice->byLinkWaitCount <= 4) {    //mike add:wait another 2 sec if associated_frame delay!
@@ -984,7 +983,6 @@ vResetCommandTimer(
 	pDevice->bCmdClear = false;
 }
 
-#ifdef TxInSleep
 void
 BSSvSecondTxData(
 	void *hDeviceContext
@@ -1019,4 +1017,3 @@ BSSvSecondTxData(
 		add_timer(&pDevice->sTimerTxData);
 		return;
 	}
-#endif
diff --git a/drivers/staging/vt6655/wcmd.h b/drivers/staging/vt6655/wcmd.h
index 126b61c..6ef04de 100644
--- a/drivers/staging/vt6655/wcmd.h
+++ b/drivers/staging/vt6655/wcmd.h
@@ -114,11 +114,10 @@ vCommandTimerWait(
 	void *hDeviceContext,
 	unsigned int MSecond
 );
-#ifdef TxInSleep
+
 void
 BSSvSecondTxData(
 	void *hDeviceContext
 );
-#endif
 
 #endif //__WCMD_H__
diff --git a/drivers/staging/vt6655/wmgr.c b/drivers/staging/vt6655/wmgr.c
index e88e116..3b9819e 100644
--- a/drivers/staging/vt6655/wmgr.c
+++ b/drivers/staging/vt6655/wmgr.c
@@ -388,7 +388,6 @@ vMgrTimerInit(
 	pDevice->sTimerCommand.function = (TimerFunction)vCommandTimer;
 	pDevice->sTimerCommand.expires = RUN_AT(HZ);
 
-#ifdef TxInSleep
 	init_timer(&pDevice->sTimerTxData);
 	pDevice->sTimerTxData.data = (unsigned long) pDevice;
 	pDevice->sTimerTxData.function = (TimerFunction)BSSvSecondTxData;
@@ -396,7 +395,6 @@ vMgrTimerInit(
 	pDevice->fTxDataInSleep = false;
 	pDevice->IsTxDataTrigger = false;
 	pDevice->nTxDataTimeCout = 0;
-#endif
 
 	pDevice->cbFreeCmdQueue = CMD_Q_SIZE;
 	pDevice->uCmdDequeueIdx = 0;
-- 
1.9.1

