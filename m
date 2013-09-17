Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:64582 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753874Ab3IQSyo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Sep 2013 14:54:44 -0400
Received: by mail-wg0-f45.google.com with SMTP id y10so5546315wgg.12
        for <linux-wireless@vger.kernel.org>; Tue, 17 Sep 2013 11:54:43 -0700 (PDT)
Message-ID: <1379444075.5456.22.camel@canaries32-MCP7A> (sfid-20130917_205451_787271_0A91A895)
Subject: [PATCH 1/2] staging vt6656: desc.h remove typedef struct
 tagSTxBufHead to rxtx.h
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Tue, 17 Sep 2013 19:54:35 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In code it is referred to as fifo to renamed to
typedef struct tagSTxBufHead -> struct vnt_tx_fifo_head

This is only needed by rxtc.c so moved to rxtx.h

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/desc.h |  9 --------
 drivers/staging/vt6656/rxtx.c | 52 ++++++++++++++++++++++++++++---------------
 drivers/staging/vt6656/rxtx.h | 12 ++++++----
 3 files changed, 42 insertions(+), 31 deletions(-)

diff --git a/drivers/staging/vt6656/desc.h b/drivers/staging/vt6656/desc.h
index 4675135..afe7074 100644
--- a/drivers/staging/vt6656/desc.h
+++ b/drivers/staging/vt6656/desc.h
@@ -146,15 +146,6 @@
 /*
  * TX FIFO header
  */
-typedef struct tagSTxBufHead {
-	u32 adwTxKey[4];
-    u16    wFIFOCtl;
-    u16    wTimeStamp;
-    u16    wFragCtl;
-    u16    wReserved;
-} __attribute__ ((__packed__))
-STxBufHead, *PSTxBufHead;
-typedef const STxBufHead *PCSTxBufHead;
 
 typedef struct tagSTxShortBufHead {
     u16    wFIFOCtl;
diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index fb743a8..a733e3b 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -844,13 +844,14 @@ static void s_vGenerateTxParameter(struct vnt_private *pDevice,
 	void *rts_cts, u32 cbFrameSize, int bNeedACK, u32 uDMAIdx,
 	struct ethhdr *psEthHeader, bool need_rts)
 {
+	struct vnt_tx_fifo_head *pFifoHead =
+				(struct vnt_tx_fifo_head *)pTxBufHead;
 	union vnt_tx_data_head *head = rts_cts;
 	u32 cbMACHdLen = WLAN_HDR_ADDR3_LEN; /* 24 */
 	u16 wFifoCtl;
 	u8 byFBOption = AUTO_FB_NONE;
 
     //DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"s_vGenerateTxParameter...\n");
-    PSTxBufHead pFifoHead = (PSTxBufHead)pTxBufHead;
     pFifoHead->wReserved = wCurrentRate;
     wFifoCtl = pFifoHead->wFIFOCtl;
 
@@ -953,11 +954,12 @@ static void s_vGenerateTxParameter(struct vnt_private *pDevice,
 */
 
 static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
-	struct vnt_tx_buffer *pTxBufHead, int bNeedEncryption,
+	struct vnt_tx_buffer *tx_buffer, int bNeedEncryption,
 	u32 uSkbPacketLen, u32 uDMAIdx,	struct ethhdr *psEthHeader,
 	u8 *pPacket, PSKeyItem pTransmitKey, u32 uNodeIndex, u16 wCurrentRate,
 	u32 *pcbHeaderLen, u32 *pcbTotalLen)
 {
+	struct vnt_tx_fifo_head *pTxBufHead = &tx_buffer->fifo_head;
 	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
 	u32 cbFrameSize, cbFrameBodySize;
 	u32 cb802_1_H_len;
@@ -980,7 +982,6 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
 	u32 dwMICKey0, dwMICKey1, dwMIC_Priority;
 	u32 *pdwMIC_L, *pdwMIC_R;
 	int bSoftWEP = false;
-
 	pvRrvTime = pMICHDR = pvTxDataHd = NULL;
 
 	if (bNeedEncryption && pTransmitKey->pvKeyTable) {
@@ -1103,7 +1104,8 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
     }
 
     pbyTxBufferAddr = (u8 *) &(pTxBufHead->adwTxKey[0]);
-    wTxBufSize = sizeof(STxBufHead);
+	wTxBufSize = sizeof(struct vnt_tx_fifo_head);
+
     if (byPktType == PK_TYPE_11GB || byPktType == PK_TYPE_11GA) {//802.11g packet
         if (byFBOption == AUTO_FB_NONE) {
             if (bRTS == true) {//RTS_need
@@ -1467,8 +1469,8 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice,
 {
 	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
 	struct vnt_tx_buffer *pTX_Buffer;
-	PSTxBufHead pTxBufHead;
 	struct vnt_usb_send_context *pContext;
+	struct vnt_tx_fifo_head *pTxBufHead;
 	struct ieee80211_hdr *pMACHeader;
 	struct ethhdr sEthHeader;
 	u8 byPktType, *pbyTxBufferAddr;
@@ -1490,10 +1492,10 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice,
     }
 
 	pTX_Buffer = (struct vnt_tx_buffer *)&pContext->Data[0];
-    pbyTxBufferAddr = (u8 *)&(pTX_Buffer->adwTxKey[0]);
     cbFrameBodySize = pPacket->cbPayloadLen;
-    pTxBufHead = (PSTxBufHead) pbyTxBufferAddr;
-    wTxBufSize = sizeof(STxBufHead);
+	pTxBufHead = &pTX_Buffer->fifo_head;
+	pbyTxBufferAddr = (u8 *)&pTxBufHead->adwTxKey[0];
+	wTxBufSize = sizeof(struct vnt_tx_fifo_head);
 
     if (pDevice->byBBType == BB_TYPE_11A) {
         wCurrentRate = RATE_6M;
@@ -1725,10 +1727,14 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice,
     pContext->uBufLen = (u16)cbReqCount + 4;  //USB header
 
     if (WLAN_GET_FC_TODS(pMACHeader->frame_control) == 0) {
-        s_vSaveTxPktInfo(pDevice, (u8) (pTX_Buffer->byPKTNO & 0x0F), &(pMACHeader->addr1[0]), (u16)cbFrameSize, pTX_Buffer->wFIFOCtl);
+	s_vSaveTxPktInfo(pDevice, (u8)(pTX_Buffer->byPKTNO & 0x0F),
+			&pMACHeader->addr1[0], (u16)cbFrameSize,
+			pTxBufHead->wFIFOCtl);
     }
     else {
-        s_vSaveTxPktInfo(pDevice, (u8) (pTX_Buffer->byPKTNO & 0x0F), &(pMACHeader->addr3[0]), (u16)cbFrameSize, pTX_Buffer->wFIFOCtl);
+	s_vSaveTxPktInfo(pDevice, (u8)(pTX_Buffer->byPKTNO & 0x0F),
+			&pMACHeader->addr3[0], (u16)cbFrameSize,
+			pTxBufHead->wFIFOCtl);
     }
 
     PIPEnsSendBulkOut(pDevice,pContext);
@@ -1823,6 +1829,7 @@ void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb)
 {
 	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
 	struct vnt_tx_buffer *pTX_Buffer;
+	struct vnt_tx_fifo_head *pTxBufHead;
 	u8 byPktType;
 	u8 *pbyTxBufferAddr;
 	void *rts_cts = NULL;
@@ -1831,7 +1838,6 @@ void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb)
 	struct ieee80211_hdr *pMACHeader;
 	u32 cbHeaderSize, cbFrameBodySize;
 	int bNeedACK, bIsPSPOLL = false;
-	PSTxBufHead pTxBufHead;
 	u32 cbFrameSize;
 	u32 cbIVlen = 0, cbICVlen = 0, cbMIClen = 0, cbFCSlen = 4;
 	u32 uPadding = 0;
@@ -1872,9 +1878,9 @@ void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb)
     }
 
 	pTX_Buffer = (struct vnt_tx_buffer *)&pContext->Data[0];
-    pbyTxBufferAddr = (u8 *)(&pTX_Buffer->adwTxKey[0]);
-    pTxBufHead = (PSTxBufHead) pbyTxBufferAddr;
-    wTxBufSize = sizeof(STxBufHead);
+	pTxBufHead = &pTX_Buffer->fifo_head;
+	pbyTxBufferAddr = (u8 *)&pTxBufHead->adwTxKey[0];
+	wTxBufSize = sizeof(struct vnt_tx_fifo_head);
 
     if (pDevice->byBBType == BB_TYPE_11A) {
         wCurrentRate = RATE_6M;
@@ -2181,10 +2187,14 @@ void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb)
     pContext->uBufLen = (u16)cbReqCount + 4;  //USB header
 
     if (WLAN_GET_FC_TODS(pMACHeader->frame_control) == 0) {
-        s_vSaveTxPktInfo(pDevice, (u8) (pTX_Buffer->byPKTNO & 0x0F), &(pMACHeader->addr1[0]), (u16)cbFrameSize, pTX_Buffer->wFIFOCtl);
+	s_vSaveTxPktInfo(pDevice, (u8)(pTX_Buffer->byPKTNO & 0x0F),
+			&pMACHeader->addr1[0], (u16)cbFrameSize,
+			pTxBufHead->wFIFOCtl);
     }
     else {
-        s_vSaveTxPktInfo(pDevice, (u8) (pTX_Buffer->byPKTNO & 0x0F), &(pMACHeader->addr3[0]), (u16)cbFrameSize, pTX_Buffer->wFIFOCtl);
+	s_vSaveTxPktInfo(pDevice, (u8)(pTX_Buffer->byPKTNO & 0x0F),
+			&pMACHeader->addr3[0], (u16)cbFrameSize,
+			pTxBufHead->wFIFOCtl);
     }
     PIPEnsSendBulkOut(pDevice,pContext);
     return ;
@@ -2566,7 +2576,10 @@ int nsDMA_tx_packet(struct vnt_private *pDevice,
     pContext->Type = CONTEXT_DATA_PACKET;
     pContext->uBufLen = (u16)BytesToWrite + 4 ; //USB header
 
-    s_vSaveTxPktInfo(pDevice, (u8) (pTX_Buffer->byPKTNO & 0x0F), &(pContext->sEthHeader.h_dest[0]), (u16) (BytesToWrite-uHeaderLen), pTX_Buffer->wFIFOCtl);
+    s_vSaveTxPktInfo(pDevice, (u8)(pTX_Buffer->byPKTNO & 0x0F),
+			&pContext->sEthHeader.h_dest[0],
+			(u16)(BytesToWrite-uHeaderLen),
+			pTX_Buffer->fifo_head.wFIFOCtl);
 
     status = PIPEnsSendBulkOut(pDevice,pContext);
 
@@ -2717,7 +2730,10 @@ int bRelayPacketSend(struct vnt_private *pDevice, u8 *pbySkbData, u32 uDataLen,
     pContext->Type = CONTEXT_DATA_PACKET;
     pContext->uBufLen = (u16)BytesToWrite + 4 ; //USB header
 
-    s_vSaveTxPktInfo(pDevice, (u8) (pTX_Buffer->byPKTNO & 0x0F), &(pContext->sEthHeader.h_dest[0]), (u16) (BytesToWrite-uHeaderLen), pTX_Buffer->wFIFOCtl);
+    s_vSaveTxPktInfo(pDevice, (u8)(pTX_Buffer->byPKTNO & 0x0F),
+		&pContext->sEthHeader.h_dest[0],
+		(u16)(BytesToWrite - uHeaderLen),
+		pTX_Buffer->fifo_head.wFIFOCtl);
 
     status = PIPEnsSendBulkOut(pDevice,pContext);
 
diff --git a/drivers/staging/vt6656/rxtx.h b/drivers/staging/vt6656/rxtx.h
index 4bbee1c..137e62d 100644
--- a/drivers/staging/vt6656/rxtx.h
+++ b/drivers/staging/vt6656/rxtx.h
@@ -180,10 +180,7 @@ union vnt_tx_data_head {
 	struct vnt_cts_fb cts_g_fb;
 };
 
-struct vnt_tx_buffer {
-	u8 byType;
-	u8 byPKTNO;
-	u16 wTxByteCount;
+struct vnt_tx_fifo_head {
 	u32 adwTxKey[4];
 	u16 wFIFOCtl;
 	u16 wTimeStamp;
@@ -191,6 +188,13 @@ struct vnt_tx_buffer {
 	u16 wReserved;
 } __packed;
 
+struct vnt_tx_buffer {
+	u8 byType;
+	u8 byPKTNO;
+	u16 wTxByteCount;
+	struct vnt_tx_fifo_head fifo_head;
+} __packed;
+
 struct vnt_beacon_buffer {
 	u8 byType;
 	u8 byPKTNO;
-- 
1.8.1.2

