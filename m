Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:36706 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193AbaECOTx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 May 2014 10:19:53 -0400
Received: by mail-we0-f171.google.com with SMTP id w62so4895186wes.30
        for <linux-wireless@vger.kernel.org>; Sat, 03 May 2014 07:19:52 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 04/13] staging: vt6656: lock changes: csMgmt_xmit.
Date: Sat,  3 May 2014 15:17:25 +0100
Message-Id: <1399126654-2663-4-git-send-email-tvboxspy@gmail.com> (sfid-20140503_161957_358858_BC56DBB7)
In-Reply-To: <1399126654-2663-1-git-send-email-tvboxspy@gmail.com>
References: <1399126654-2663-1-git-send-email-tvboxspy@gmail.com>
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
index 0280ed2..185b1ea 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -1386,13 +1386,32 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice,
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
@@ -1400,24 +1419,6 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice,
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
@@ -1628,6 +1629,9 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice,
     }
 
     PIPEnsSendBulkOut(pDevice,pContext);
+
+	spin_unlock_irqrestore(&pDevice->lock, flags);
+
     return CMD_STATUS_PENDING;
 }
 
-- 
1.9.1

