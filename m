Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:51267 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754209AbaEOVvM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2014 17:51:12 -0400
Received: by mail-wi0-f169.google.com with SMTP id hi2so1276833wib.4
        for <linux-wireless@vger.kernel.org>; Thu, 15 May 2014 14:51:11 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH rebased 02/15] staging: vt6656: struct vnt_usb_send_context remove camel case.
Date: Thu, 15 May 2014 22:49:11 +0100
Message-Id: <1400190564-5135-2-git-send-email-tvboxspy@gmail.com> (sfid-20140515_235116_748960_829EEC88)
In-Reply-To: <1400190564-5135-1-git-send-email-tvboxspy@gmail.com>
References: <1400190564-5135-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Camel case changes
pDevice -> priv
pPacket -> skb
pUrb -> urb
uBufLen -> buf_len;
bBoolInUse -> in_use
Data -> data

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h   | 12 +++----
 drivers/staging/vt6656/main_usb.c | 14 ++++----
 drivers/staging/vt6656/rxtx.c     | 74 +++++++++++++++++++--------------------
 drivers/staging/vt6656/usbpipe.c  | 26 +++++++-------
 4 files changed, 63 insertions(+), 63 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index e2abe3d..f36a2eb 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -176,13 +176,13 @@ struct vnt_rcb {
 
 /* used to track bulk out irps */
 struct vnt_usb_send_context {
-	void *pDevice;
-	struct sk_buff *pPacket;
-	struct urb *pUrb;
-	unsigned int uBufLen;
+	void *priv;
+	struct sk_buff *skb;
+	struct urb *urb;
+	unsigned int buf_len;
 	u8 type;
-	bool bBoolInUse;
-	unsigned char Data[MAX_TOTAL_SIZE_WITH_ALL_HEADERS];
+	bool in_use;
+	unsigned char data[MAX_TOTAL_SIZE_WITH_ALL_HEADERS];
 };
 
 /* tx packet info for rxtx */
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 208640b..ea0d6b3 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -760,9 +760,9 @@ static void device_free_tx_bufs(struct vnt_private *priv)
 	for (ii = 0; ii < priv->cbTD; ii++) {
 		tx_context = priv->apTD[ii];
 		/* deallocate URBs */
-		if (tx_context->pUrb) {
-			usb_kill_urb(tx_context->pUrb);
-			usb_free_urb(tx_context->pUrb);
+		if (tx_context->urb) {
+			usb_kill_urb(tx_context->urb);
+			usb_free_urb(tx_context->urb);
 		}
 
 		kfree(tx_context);
@@ -828,17 +828,17 @@ static bool device_alloc_bufs(struct vnt_private *priv)
 		}
 
 		priv->apTD[ii] = tx_context;
-		tx_context->pDevice = priv;
+		tx_context->priv = priv;
 
 		/* allocate URBs */
-		tx_context->pUrb = usb_alloc_urb(0, GFP_ATOMIC);
-		if (tx_context->pUrb == NULL) {
+		tx_context->urb = usb_alloc_urb(0, GFP_ATOMIC);
+		if (!tx_context->urb) {
 			DBG_PRT(MSG_LEVEL_ERR,
 				KERN_ERR "alloc tx urb failed\n");
 			goto free_tx;
 		}
 
-		tx_context->bBoolInUse = false;
+		tx_context->in_use = false;
 	}
 
 	/* allocate RCB mem */
diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 57eb502..52be7b0 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -149,9 +149,9 @@ static struct vnt_usb_send_context
 			return NULL;
 
 		context = priv->apTD[ii];
-		if (context->bBoolInUse == false) {
-			context->bBoolInUse = true;
-			memset(context->Data, 0,
+		if (context->in_use == false) {
+			context->in_use = true;
+			memset(context->data, 0,
 					MAX_TOTAL_SIZE_WITH_ALL_HEADERS);
 			return context;
 		}
@@ -1391,7 +1391,7 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice,
         return CMD_STATUS_RESOURCES;
     }
 
-	pTX_Buffer = (struct vnt_tx_buffer *)&pContext->Data[0];
+	pTX_Buffer = (struct vnt_tx_buffer *)&pContext->data[0];
     cbFrameBodySize = pPacket->cbPayloadLen;
 	pTxBufHead = &pTX_Buffer->fifo_head;
 	pbyTxBufferAddr = (u8 *)&pTxBufHead->adwTxKey[0];
@@ -1609,9 +1609,9 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice,
     pTX_Buffer->byPKTNO = (u8) (((wCurrentRate<<4) &0x00F0) | ((pDevice->wSeqCounter - 1) & 0x000F));
     pTX_Buffer->byType = 0x00;
 
-    pContext->pPacket = NULL;
-    pContext->type = CONTEXT_MGMT_PACKET;
-    pContext->uBufLen = (u16)cbReqCount + 4;  //USB header
+	pContext->skb = NULL;
+	pContext->type = CONTEXT_MGMT_PACKET;
+	pContext->buf_len = (u16)cbReqCount + 4; /* USB header */
 
     if (WLAN_GET_FC_TODS(pMACHeader->frame_control) == 0) {
 	s_vSaveTxPktInfo(pDevice, (u8)(pTX_Buffer->byPKTNO & 0x0F),
@@ -1649,7 +1649,7 @@ CMD_STATUS csBeacon_xmit(struct vnt_private *pDevice,
         return status ;
     }
 
-	pTX_Buffer = (struct vnt_beacon_buffer *)&pContext->Data[0];
+	pTX_Buffer = (struct vnt_beacon_buffer *)&pContext->data[0];
 	short_head = &pTX_Buffer->short_head;
 
     cbFrameBodySize = pPacket->cbPayloadLen;
@@ -1701,9 +1701,9 @@ CMD_STATUS csBeacon_xmit(struct vnt_private *pDevice,
     pTX_Buffer->byPKTNO = (u8) (((wCurrentRate<<4) &0x00F0) | ((pDevice->wSeqCounter - 1) & 0x000F));
     pTX_Buffer->byType = 0x01;
 
-    pContext->pPacket = NULL;
-    pContext->type = CONTEXT_MGMT_PACKET;
-    pContext->uBufLen = (u16)cbReqCount + 4;  //USB header
+	pContext->skb = NULL;
+	pContext->type = CONTEXT_MGMT_PACKET;
+	pContext->buf_len = (u16)cbReqCount + 4; /* USB header */
 
     PIPEnsSendBulkOut(pDevice,pContext);
     return CMD_STATUS_PENDING;
@@ -1760,7 +1760,7 @@ void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb)
         return ;
     }
 
-	pTX_Buffer = (struct vnt_tx_buffer *)&pContext->Data[0];
+	pTX_Buffer = (struct vnt_tx_buffer *)&pContext->data[0];
 	pTxBufHead = &pTX_Buffer->fifo_head;
 	pbyTxBufferAddr = (u8 *)&pTxBufHead->adwTxKey[0];
 	wTxBufSize = sizeof(struct vnt_tx_fifo_head);
@@ -2049,9 +2049,9 @@ void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb)
     pTX_Buffer->byPKTNO = (u8) (((wCurrentRate<<4) &0x00F0) | ((pDevice->wSeqCounter - 1) & 0x000F));
     pTX_Buffer->byType = 0x00;
 
-    pContext->pPacket = skb;
-    pContext->type = CONTEXT_MGMT_PACKET;
-    pContext->uBufLen = (u16)cbReqCount + 4;  //USB header
+	pContext->skb = skb;
+	pContext->type = CONTEXT_MGMT_PACKET;
+	pContext->buf_len = (u16)cbReqCount + 4;  /* USB header */
 
     if (WLAN_GET_FC_TODS(pMACHeader->frame_control) == 0) {
 	s_vSaveTxPktInfo(pDevice, (u8)(pTX_Buffer->byPKTNO & 0x0F),
@@ -2408,7 +2408,7 @@ int nsDMA_tx_packet(struct vnt_private *pDevice, struct sk_buff *skb)
 		return STATUS_RESOURCES;
 	}
 
-	pTX_Buffer = (struct vnt_tx_buffer *)&pContext->Data[0];
+	pTX_Buffer = (struct vnt_tx_buffer *)&pContext->data[0];
 
     fConvertedPacket = s_bPacketToWirelessUsb(pDevice, byPktType,
 			pTX_Buffer, bNeedEncryption,
@@ -2418,11 +2418,11 @@ int nsDMA_tx_packet(struct vnt_private *pDevice, struct sk_buff *skb)
                         &uHeaderLen, &BytesToWrite
                        );
 
-    if (fConvertedPacket == false) {
-        pContext->bBoolInUse = false;
-        dev_kfree_skb_irq(skb);
-        return STATUS_FAILURE;
-    }
+	if (fConvertedPacket == false) {
+		pContext->in_use = false;
+		dev_kfree_skb_irq(skb);
+		return STATUS_FAILURE;
+	}
 
     if ( pDevice->bEnablePSMode == true ) {
         if ( !pDevice->bPSModeTxBurst ) {
@@ -2436,9 +2436,9 @@ int nsDMA_tx_packet(struct vnt_private *pDevice, struct sk_buff *skb)
     pTX_Buffer->byPKTNO = (u8) (((pDevice->wCurrentRate<<4) &0x00F0) | ((pDevice->wSeqCounter - 1) & 0x000F));
     pTX_Buffer->tx_byte_count = cpu_to_le16((u16)BytesToWrite);
 
-    pContext->pPacket = skb;
-    pContext->type = CONTEXT_DATA_PACKET;
-    pContext->uBufLen = (u16)BytesToWrite + 4 ; //USB header
+	pContext->skb = skb;
+	pContext->type = CONTEXT_DATA_PACKET;
+	pContext->buf_len = (u16)BytesToWrite + 4 ; /* USB header */
 
     s_vSaveTxPktInfo(pDevice, (u8)(pTX_Buffer->byPKTNO & 0x0F),
 			&pDevice->sTxEthHeader.h_dest[0],
@@ -2453,14 +2453,14 @@ int nsDMA_tx_packet(struct vnt_private *pDevice, struct sk_buff *skb)
 	bScheduleCommand((void *) pDevice, WLAN_CMD_DEAUTH, (u8 *) &wReason);
     }
 
-  if(status!=STATUS_PENDING) {
-     pContext->bBoolInUse = false;
-    dev_kfree_skb_irq(skb);
-    return STATUS_FAILURE;
-  }
-  else
-    return 0;
+	if (status != STATUS_PENDING) {
+		pContext->in_use = false;
+		dev_kfree_skb_irq(skb);
+		return STATUS_FAILURE;
+	}
 
+
+	return 0;
 }
 
 /*
@@ -2531,7 +2531,7 @@ int bRelayPacketSend(struct vnt_private *pDevice, u8 *pbySkbData, u32 uDataLen,
     }
 
     if ( bNeedEncryption && (pTransmitKey == NULL) ) {
-        pContext->bBoolInUse = false;
+	pContext->in_use = false;
         return false;
     }
 
@@ -2572,7 +2572,7 @@ int bRelayPacketSend(struct vnt_private *pDevice, u8 *pbySkbData, u32 uDataLen,
     // Convert the packet to an usb frame and copy into our buffer
     // and send the irp.
 
-	pTX_Buffer = (struct vnt_tx_buffer *)&pContext->Data[0];
+	pTX_Buffer = (struct vnt_tx_buffer *)&pContext->data[0];
 
     fConvertedPacket = s_bPacketToWirelessUsb(pDevice, byPktType,
 			pTX_Buffer, bNeedEncryption,
@@ -2583,16 +2583,16 @@ int bRelayPacketSend(struct vnt_private *pDevice, u8 *pbySkbData, u32 uDataLen,
                         );
 
     if (fConvertedPacket == false) {
-        pContext->bBoolInUse = false;
+	pContext->in_use = false;
         return false;
     }
 
     pTX_Buffer->byPKTNO = (u8) (((pDevice->wCurrentRate<<4) &0x00F0) | ((pDevice->wSeqCounter - 1) & 0x000F));
     pTX_Buffer->tx_byte_count = cpu_to_le16((u16)BytesToWrite);
 
-    pContext->pPacket = NULL;
-    pContext->type = CONTEXT_DATA_PACKET;
-    pContext->uBufLen = (u16)BytesToWrite + 4 ; //USB header
+	pContext->skb = NULL;
+	pContext->type = CONTEXT_DATA_PACKET;
+	pContext->buf_len = (u16)BytesToWrite + 4; /* USB header */
 
     s_vSaveTxPktInfo(pDevice, (u8)(pTX_Buffer->byPKTNO & 0x0F),
 		&pDevice->sTxEthHeader.h_dest[0],
diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index c5838d9..1a6f911 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -530,17 +530,17 @@ int PIPEnsSendBulkOut(struct vnt_private *priv,
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"s_nsSendBulkOut\n");
 
 	if (!(MP_IS_READY(priv) && priv->Flags & fMP_POST_WRITES)) {
-		context->bBoolInUse = false;
+		context->in_use = false;
 		return STATUS_RESOURCES;
 	}
 
-	urb = context->pUrb;
+	urb = context->urb;
 
 	usb_fill_bulk_urb(urb,
 			priv->usb,
 			usb_sndbulkpipe(priv->usb, 3),
-			context->Data,
-			context->uBufLen,
+			context->data,
+			context->buf_len,
 			s_nsBulkOutIoCompleteWrite,
 			context);
 
@@ -548,7 +548,7 @@ int PIPEnsSendBulkOut(struct vnt_private *priv,
 	if (status != 0) {
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
 				"Submit Tx URB failed %d\n", status);
-		context->bBoolInUse = false;
+		context->in_use = false;
 		return STATUS_FAILURE;
 	}
 
@@ -586,7 +586,7 @@ int PIPEnsSendBulkOut(struct vnt_private *priv,
 static void s_nsBulkOutIoCompleteWrite(struct urb *urb)
 {
 	struct vnt_usb_send_context *context = urb->context;
-	struct vnt_private *priv = context->pDevice;
+	struct vnt_private *priv = context->priv;
 	u8 context_type = context->type;
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"---->s_nsBulkOutIoCompleteWrite\n");
@@ -594,12 +594,12 @@ static void s_nsBulkOutIoCompleteWrite(struct urb *urb)
 	switch (urb->status) {
 	case 0:
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
-			"Write %d bytes\n", context->uBufLen);
+			"Write %d bytes\n", context->buf_len);
 		break;
 	case -ECONNRESET:
 	case -ENOENT:
 	case -ESHUTDOWN:
-		context->bBoolInUse = false;
+		context->in_use = false;
 		return;
 	case -ETIMEDOUT:
 	default:
@@ -612,11 +612,11 @@ static void s_nsBulkOutIoCompleteWrite(struct urb *urb)
 		return;
 
 	if (CONTEXT_DATA_PACKET == context_type) {
-		if (context->pPacket != NULL) {
-			dev_kfree_skb_irq(context->pPacket);
-			context->pPacket = NULL;
+		if (context->skb != NULL) {
+			dev_kfree_skb_irq(context->skb);
+			context->skb = NULL;
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
-				"tx  %d bytes\n", context->uBufLen);
+				"tx  %d bytes\n", context->buf_len);
 		}
 
 		priv->dev->trans_start = jiffies;
@@ -627,7 +627,7 @@ static void s_nsBulkOutIoCompleteWrite(struct urb *urb)
 			netif_wake_queue(priv->dev);
 	}
 
-	context->bBoolInUse = false;
+	context->in_use = false;
 
 	return;
 }
-- 
1.9.1

