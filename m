Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:65035 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885AbaBSV4p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Feb 2014 16:56:45 -0500
Received: by mail-wi0-f181.google.com with SMTP id hi5so1143041wib.14
        for <linux-wireless@vger.kernel.org>; Wed, 19 Feb 2014 13:56:44 -0800 (PST)
Message-ID: <1392846993.20211.15.camel@canaries64-MCP7A> (sfid-20140219_225648_127142_BB92E23C)
Subject: [PATCH 4/4] staging: vt6656: Remove typedef enum _CONTEXT_TYPE
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Wed, 19 Feb 2014 21:56:33 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace with enum

assign as u8 type.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h  | 10 +++++-----
 drivers/staging/vt6656/rxtx.c    | 10 +++++-----
 drivers/staging/vt6656/usbpipe.c |  2 +-
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 33e5e34..8d8f31a 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -158,10 +158,10 @@ typedef enum __device_msg_level {
 /*
  * Enum of context types for SendPacket
  */
-typedef enum _CONTEXT_TYPE {
-    CONTEXT_DATA_PACKET = 1,
-    CONTEXT_MGMT_PACKET
-} CONTEXT_TYPE;
+enum {
+	CONTEXT_DATA_PACKET = 1,
+	CONTEXT_MGMT_PACKET
+};
 
 /* RCB (Receive Control Block) */
 struct vnt_rcb {
@@ -180,7 +180,7 @@ struct vnt_usb_send_context {
 	struct sk_buff *pPacket;
 	struct urb *pUrb;
 	unsigned int uBufLen;
-	CONTEXT_TYPE Type;
+	u8 type;
 	struct ethhdr sEthHeader;
 	void *Next;
 	bool bBoolInUse;
diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 92146e5..ba0184a 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -1610,7 +1610,7 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice,
     pTX_Buffer->byType = 0x00;
 
     pContext->pPacket = NULL;
-    pContext->Type = CONTEXT_MGMT_PACKET;
+    pContext->type = CONTEXT_MGMT_PACKET;
     pContext->uBufLen = (u16)cbReqCount + 4;  //USB header
 
     if (WLAN_GET_FC_TODS(pMACHeader->frame_control) == 0) {
@@ -1702,7 +1702,7 @@ CMD_STATUS csBeacon_xmit(struct vnt_private *pDevice,
     pTX_Buffer->byType = 0x01;
 
     pContext->pPacket = NULL;
-    pContext->Type = CONTEXT_MGMT_PACKET;
+    pContext->type = CONTEXT_MGMT_PACKET;
     pContext->uBufLen = (u16)cbReqCount + 4;  //USB header
 
     PIPEnsSendBulkOut(pDevice,pContext);
@@ -2050,7 +2050,7 @@ void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb)
     pTX_Buffer->byType = 0x00;
 
     pContext->pPacket = skb;
-    pContext->Type = CONTEXT_MGMT_PACKET;
+    pContext->type = CONTEXT_MGMT_PACKET;
     pContext->uBufLen = (u16)cbReqCount + 4;  //USB header
 
     if (WLAN_GET_FC_TODS(pMACHeader->frame_control) == 0) {
@@ -2440,7 +2440,7 @@ int nsDMA_tx_packet(struct vnt_private *pDevice,
     pTX_Buffer->wTxByteCount = (u16)BytesToWrite;
 
     pContext->pPacket = skb;
-    pContext->Type = CONTEXT_DATA_PACKET;
+    pContext->type = CONTEXT_DATA_PACKET;
     pContext->uBufLen = (u16)BytesToWrite + 4 ; //USB header
 
     s_vSaveTxPktInfo(pDevice, (u8)(pTX_Buffer->byPKTNO & 0x0F),
@@ -2594,7 +2594,7 @@ int bRelayPacketSend(struct vnt_private *pDevice, u8 *pbySkbData, u32 uDataLen,
     pTX_Buffer->wTxByteCount = (u16)BytesToWrite;
 
     pContext->pPacket = NULL;
-    pContext->Type = CONTEXT_DATA_PACKET;
+    pContext->type = CONTEXT_DATA_PACKET;
     pContext->uBufLen = (u16)BytesToWrite + 4 ; //USB header
 
     s_vSaveTxPktInfo(pDevice, (u8)(pTX_Buffer->byPKTNO & 0x0F),
diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index 0ae5d20..1fc382d 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -610,7 +610,7 @@ static void s_nsBulkOutIoCompleteWrite(struct urb *urb)
 	struct vnt_usb_send_context *context =
 			(struct vnt_usb_send_context *)urb->context;
 	struct vnt_private *priv = context->pDevice;
-	CONTEXT_TYPE context_type = context->Type;
+	u8 context_type = context->type;
 	unsigned long buf_len = context->uBufLen;
 	int status;
 
-- 
1.9.rc1


