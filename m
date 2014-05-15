Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:63122 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129AbaEOVvn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2014 17:51:43 -0400
Received: by mail-wg0-f52.google.com with SMTP id l18so4120435wgh.35
        for <linux-wireless@vger.kernel.org>; Thu, 15 May 2014 14:51:42 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH rebased 06/15] staging: vt6656: lock changes: csMgmt_xmit.
Date: Thu, 15 May 2014 22:49:15 +0100
Message-Id: <1400190564-5135-6-git-send-email-tvboxspy@gmail.com> (sfid-20140515_235147_450074_10FC7B07)
In-Reply-To: <1400190564-5135-1-git-send-email-tvboxspy@gmail.com>
References: <1400190564-5135-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

csMgmt_xmit is nolonger atomically called but part of must be.

Reorder the function so that RFbSetPower is called first.

Add new lock spinlock for the remainder of the function.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 50 +++++++++++++++++++++++--------------------
 1 file changed, 27 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 52be7b0..c6ac263 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -1383,13 +1383,32 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice,
 	u16 wTxBufSize;
 	u32 cbMacHdLen;
 	u16 wCurrentRate = RATE_1M;
+	unsigned long flags;
 
-	pContext = s_vGetFreeContext(pDevice);
+	if (pDevice->byBBType == BB_TYPE_11A) {
+		wCurrentRate = RATE_6M;
+		byPktType = PK_TYPE_11A;
+	} else {
+		wCurrentRate = RATE_1M;
+		byPktType = PK_TYPE_11B;
+	}
 
-    if (NULL == pContext) {
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"ManagementSend TX...NO CONTEXT!\n");
-        return CMD_STATUS_RESOURCES;
-    }
+	if (pMgmt->eScanState != WMAC_NO_SCANNING)
+		RFbSetPower(pDevice, wCurrentRate, pDevice->byCurrentCh);
+	else
+		RFbSetPower(pDevice, wCurrentRate, pMgmt->uCurrChannel);
+
+	pDevice->wCurrentRate = wCurrentRate;
+
+	spin_lock_irqsave(&pDevice->lock, flags);
+
+	pContext = s_vGetFreeContext(pDevice);
+	if (!pContext) {
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+			"ManagementSend TX...NO CONTEXT!\n");
+		spin_unlock_irqrestore(&pDevice->lock, flags);
+		return CMD_STATUS_RESOURCES;
+	}
 
 	pTX_Buffer = (struct vnt_tx_buffer *)&pContext->data[0];
     cbFrameBodySize = pPacket->cbPayloadLen;
@@ -1397,24 +1416,6 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice,
 	pbyTxBufferAddr = (u8 *)&pTxBufHead->adwTxKey[0];
 	wTxBufSize = sizeof(struct vnt_tx_fifo_head);
 
-    if (pDevice->byBBType == BB_TYPE_11A) {
-        wCurrentRate = RATE_6M;
-        byPktType = PK_TYPE_11A;
-    } else {
-        wCurrentRate = RATE_1M;
-        byPktType = PK_TYPE_11B;
-    }
-
-    // SetPower will cause error power TX state for OFDM Date packet in TX buffer.
-    // 2004.11.11 Kyle -- Using OFDM power to tx MngPkt will decrease the connection capability.
-    //                    And cmd timer will wait data pkt TX finish before scanning so it's OK
-    //                    to set power here.
-    if (pMgmt->eScanState != WMAC_NO_SCANNING) {
-        RFbSetPower(pDevice, wCurrentRate, pDevice->byCurrentCh);
-    } else {
-        RFbSetPower(pDevice, wCurrentRate, pMgmt->uCurrChannel);
-    }
-    pDevice->wCurrentRate = wCurrentRate;
 
     //Set packet type
     if (byPktType == PK_TYPE_11A) {//0000 0000 0000 0000
@@ -1625,6 +1626,9 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice,
     }
 
     PIPEnsSendBulkOut(pDevice,pContext);
+
+	spin_unlock_irqrestore(&pDevice->lock, flags);
+
     return CMD_STATUS_PENDING;
 }
 
-- 
1.9.1

