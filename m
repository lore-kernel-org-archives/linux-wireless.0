Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f177.google.com ([209.85.215.177]:59270 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754765Ab3HOSep (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Aug 2013 14:34:45 -0400
Received: by mail-ea0-f177.google.com with SMTP id f15so533207eak.22
        for <linux-wireless@vger.kernel.org>; Thu, 15 Aug 2013 11:34:44 -0700 (PDT)
Message-ID: <1376591677.5404.18.camel@canaries32-MCP7A> (sfid-20130815_203512_728273_B5FA325A)
Subject: [PATCH 1/3] staging: vt6656: rxtx.c remove typdef PTX_BUFFER
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Thu, 15 Aug 2013 19:34:37 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rename to vnt_tx_buffer.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>

---
 drivers/staging/vt6656/rxtx.c | 20 ++++++++++----------
 drivers/staging/vt6656/rxtx.h | 20 +++++++++-----------
 2 files changed, 19 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 9cd4158..083f58f 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -996,8 +996,8 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
 	u32 uNodeIndex, u16 wCurrentRate, u32 *pcbHeaderLen, u32 *pcbTotalLen)
 {
 	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
+	struct vnt_tx_buffer *pTxBufHead;
 	u32 cbFrameSize, cbFrameBodySize;
-	PTX_BUFFER pTxBufHead;
 	u32 cb802_1_H_len;
 	u32 cbIVlen = 0, cbICVlen = 0, cbMIClen = 0, cbMACHdLen = 0;
 	u32 cbFCSlen = 4, cbMICHDR = 0;
@@ -1026,7 +1026,7 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
 			bSoftWEP = true; /* WEP 256 */
 	}
 
-    pTxBufHead = (PTX_BUFFER) usbPacketBuf;
+	pTxBufHead = (struct vnt_tx_buffer *)usbPacketBuf;
 
     // Get pkt type
     if (ntohs(psEthHeader->h_proto) > ETH_DATA_LEN) {
@@ -1489,7 +1489,7 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice,
 	struct vnt_tx_mgmt *pPacket)
 {
 	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
-	PTX_BUFFER pTX_Buffer;
+	struct vnt_tx_buffer *pTX_Buffer;
 	PSTxBufHead pTxBufHead;
 	PUSB_SEND_CONTEXT pContext;
 	struct ieee80211_hdr *pMACHeader;
@@ -1512,7 +1512,7 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice,
         return CMD_STATUS_RESOURCES;
     }
 
-    pTX_Buffer = (PTX_BUFFER) (&pContext->Data[0]);
+	pTX_Buffer = (struct vnt_tx_buffer *)&pContext->Data[0];
     pbyTxBufferAddr = (u8 *)&(pTX_Buffer->adwTxKey[0]);
     cbFrameBodySize = pPacket->cbPayloadLen;
     pTxBufHead = (PSTxBufHead) pbyTxBufferAddr;
@@ -1838,6 +1838,7 @@ CMD_STATUS csBeacon_xmit(struct vnt_private *pDevice,
 void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb)
 {
 	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
+	struct vnt_tx_buffer *pTX_Buffer;
 	u8 byPktType;
 	u8 *pbyTxBufferAddr;
 	void *pvRTS, *pvCTS, *pvTxDataHd;
@@ -1865,7 +1866,6 @@ void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb)
 	PSKeyItem pTransmitKey = NULL;
 	u8 *pbyIVHead, *pbyPayloadHead, *pbyMacHdr;
 	u32 cbExtSuppRate = 0;
-	PTX_BUFFER pTX_Buffer;
 	PUSB_SEND_CONTEXT pContext;
 
     pvRrvTime = pMICHDR = pvRTS = pvCTS = pvTxDataHd = NULL;
@@ -1886,7 +1886,7 @@ void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb)
         return ;
     }
 
-    pTX_Buffer = (PTX_BUFFER)(&pContext->Data[0]);
+	pTX_Buffer = (struct vnt_tx_buffer *)&pContext->Data[0];
     pbyTxBufferAddr = (u8 *)(&pTX_Buffer->adwTxKey[0]);
     pTxBufHead = (PSTxBufHead) pbyTxBufferAddr;
     wTxBufSize = sizeof(STxBufHead);
@@ -2218,6 +2218,7 @@ int nsDMA_tx_packet(struct vnt_private *pDevice,
 {
 	struct net_device_stats *pStats = &pDevice->stats;
 	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
+	struct vnt_tx_buffer *pTX_Buffer;
 	u32 BytesToWrite = 0, uHeaderLen = 0;
 	u32 uNodeIndex = 0;
 	u8 byMask[8] = {1, 2, 4, 8, 0x10, 0x20, 0x40, 0x80};
@@ -2233,7 +2234,6 @@ int nsDMA_tx_packet(struct vnt_private *pDevice,
 	int bNodeExist = false;
 	PUSB_SEND_CONTEXT pContext;
 	bool fConvertedPacket;
-	PTX_BUFFER pTX_Buffer;
 	u32 status;
 	u16 wKeepRate = pDevice->wCurrentRate;
 	int bTxeapol_key = false;
@@ -2564,7 +2564,7 @@ int nsDMA_tx_packet(struct vnt_private *pDevice,
         }
     }
 
-    pTX_Buffer = (PTX_BUFFER)&(pContext->Data[0]);
+	pTX_Buffer = (struct vnt_tx_buffer *)&pContext->Data[0];
     pTX_Buffer->byPKTNO = (u8) (((pDevice->wCurrentRate<<4) &0x00F0) | ((pDevice->wSeqCounter - 1) & 0x000F));
     pTX_Buffer->wTxByteCount = (u16)BytesToWrite;
 
@@ -2611,6 +2611,7 @@ int bRelayPacketSend(struct vnt_private *pDevice, u8 *pbySkbData, u32 uDataLen,
 	u32 uNodeIndex)
 {
 	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
+	struct vnt_tx_buffer *pTX_Buffer;
 	u32 BytesToWrite = 0, uHeaderLen = 0;
 	u8 byPktType = PK_TYPE_11B;
 	int bNeedEncryption = false;
@@ -2620,7 +2621,6 @@ int bRelayPacketSend(struct vnt_private *pDevice, u8 *pbySkbData, u32 uDataLen,
 	PUSB_SEND_CONTEXT pContext;
 	u8 byPktTyp;
 	int fConvertedPacket;
-	PTX_BUFFER pTX_Buffer;
 	u32 status;
 	u16 wKeepRate = pDevice->wCurrentRate;
 
@@ -2714,7 +2714,7 @@ int bRelayPacketSend(struct vnt_private *pDevice, u8 *pbySkbData, u32 uDataLen,
         return false;
     }
 
-    pTX_Buffer = (PTX_BUFFER)&(pContext->Data[0]);
+	pTX_Buffer = (struct vnt_tx_buffer *)&pContext->Data[0];
     pTX_Buffer->byPKTNO = (u8) (((pDevice->wCurrentRate<<4) &0x00F0) | ((pDevice->wSeqCounter - 1) & 0x000F));
     pTX_Buffer->wTxByteCount = (u16)BytesToWrite;
 
diff --git a/drivers/staging/vt6656/rxtx.h b/drivers/staging/vt6656/rxtx.h
index 3e2a877..bd1f9e2 100644
--- a/drivers/staging/vt6656/rxtx.h
+++ b/drivers/staging/vt6656/rxtx.h
@@ -32,18 +32,16 @@
 #include "device.h"
 #include "wcmd.h"
 
-typedef struct tagSTX_BUFFER
-{
-    u8                            byType;
-    u8                            byPKTNO;
-    u16                            wTxByteCount;
-
+struct vnt_tx_buffer {
+	u8 byType;
+	u8 byPKTNO;
+	u16 wTxByteCount;
 	u32 adwTxKey[4];
-    u16                            wFIFOCtl;
-    u16                            wTimeStamp;
-    u16                            wFragCtl;
-    u16                            wReserved;
-} __packed TX_BUFFER, *PTX_BUFFER;
+	u16 wFIFOCtl;
+	u16 wTimeStamp;
+	u16 wFragCtl;
+	u16 wReserved;
+} __packed;
 
 typedef struct tagSBEACON_BUFFER
 {
-- 
1.8.1.2



