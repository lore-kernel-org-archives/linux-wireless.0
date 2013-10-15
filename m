Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:36181 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759732Ab3JOUq5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Oct 2013 16:46:57 -0400
Received: by mail-we0-f177.google.com with SMTP id x55so9020311wes.36
        for <linux-wireless@vger.kernel.org>; Tue, 15 Oct 2013 13:46:56 -0700 (PDT)
Message-ID: <1381870009.5100.45.camel@canaries32-MCP7A> (sfid-20131015_224704_176236_285092A1)
Subject: [PATCH 2/2] staging: vt6656: rxtx change u32 [4] aWTxKey to u8[16]
 tx_key
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Tue, 15 Oct 2013 21:46:49 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace 4 x u32 aWTxKey with u8 array of 16 bytes tx_key.

Replaces pbyBuf in s_vFillTxKey and connects pbyTxBufferAddr
directly to tx_key without a cast elsewhere in structure.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 23 ++++++++++++-----------
 drivers/staging/vt6656/rxtx.h |  2 +-
 2 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 35a3ddb..7ca1c26 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -185,7 +185,6 @@ static void s_vFillTxKey(struct vnt_private *pDevice,
 	PSKeyItem pTransmitKey, u8 *pbyHdrBuf, u16 wPayloadLen,
 	struct vnt_mic_hdr *mic_hdr)
 {
-	u8 *pbyBuf = (u8 *)&fifo_head->adwTxKey[0];
 	u32 *pdwIV = (u32 *)pbyIVHead;
 	u32 *pdwExtIV = (u32 *)((u8 *)pbyIVHead + 4);
 	struct ieee80211_hdr *pMACHeader = (struct ieee80211_hdr *)pbyHdrBuf;
@@ -206,16 +205,18 @@ static void s_vFillTxKey(struct vnt_private *pDevice,
 			memcpy(pDevice->abyPRNG + 3, pTransmitKey->abyKey,
 						pTransmitKey->uKeyLength);
 		} else {
-			memcpy(pbyBuf, (u8 *)&dwRevIVCounter, 3);
-			memcpy(pbyBuf + 3, pTransmitKey->abyKey,
+			memcpy(fifo_head->tx_key, (u8 *)&dwRevIVCounter, 3);
+			memcpy(&fifo_head->tx_key[3], pTransmitKey->abyKey,
 						pTransmitKey->uKeyLength);
 			if (pTransmitKey->uKeyLength == WLAN_WEP40_KEYLEN) {
-				memcpy(pbyBuf+8, (u8 *)&dwRevIVCounter, 3);
-			memcpy(pbyBuf+11, pTransmitKey->abyKey,
+				memcpy(&fifo_head->tx_key[8],
+						(u8 *)&dwRevIVCounter, 3);
+				memcpy(&fifo_head->tx_key[11],
+					pTransmitKey->abyKey,
 						pTransmitKey->uKeyLength);
 			}
 
-			memcpy(pDevice->abyPRNG, pbyBuf, 16);
+			memcpy(pDevice->abyPRNG, fifo_head->tx_key, 16);
 		}
 		/* Append IV after Mac Header */
 		*pdwIV &= WEP_IV_MASK;
@@ -235,7 +236,7 @@ static void s_vFillTxKey(struct vnt_private *pDevice,
 		TKIPvMixKey(pTransmitKey->abyKey, pDevice->abyCurrentNetAddr,
 			pTransmitKey->wTSC15_0, pTransmitKey->dwTSC47_16,
 							pDevice->abyPRNG);
-		memcpy(pbyBuf, pDevice->abyPRNG, 16);
+		memcpy(fifo_head->tx_key, pDevice->abyPRNG, 16);
 
 		/* Make IV */
 		memcpy(pdwIV, pDevice->abyPRNG, 3);
@@ -254,7 +255,7 @@ static void s_vFillTxKey(struct vnt_private *pDevice,
 		if (pTransmitKey->wTSC15_0 == 0)
 			pTransmitKey->dwTSC47_16++;
 
-		memcpy(pbyBuf, pTransmitKey->abyKey, 16);
+		memcpy(fifo_head->tx_key, pTransmitKey->abyKey, 16);
 
 		/* Make IV */
 		*pdwIV = 0;
@@ -1103,7 +1104,7 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
         pTxBufHead->wFIFOCtl |= (FIFOCTL_RTS | FIFOCTL_LRETRY);
     }
 
-    pbyTxBufferAddr = (u8 *) &(pTxBufHead->adwTxKey[0]);
+	pbyTxBufferAddr = pTxBufHead->tx_key;
 	wTxBufSize = sizeof(struct vnt_tx_fifo_head);
 
     if (byPktType == PK_TYPE_11GB || byPktType == PK_TYPE_11GA) {//802.11g packet
@@ -1419,7 +1420,7 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice,
 	pTX_Buffer = (struct vnt_tx_buffer *)&pContext->Data[0];
     cbFrameBodySize = pPacket->cbPayloadLen;
 	pTxBufHead = &pTX_Buffer->fifo_head;
-	pbyTxBufferAddr = (u8 *)&pTxBufHead->adwTxKey[0];
+	pbyTxBufferAddr = pTxBufHead->tx_key;
 	wTxBufSize = sizeof(struct vnt_tx_fifo_head);
 
     if (pDevice->byBBType == BB_TYPE_11A) {
@@ -1791,7 +1792,7 @@ void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb)
 
 	pTX_Buffer = (struct vnt_tx_buffer *)&pContext->Data[0];
 	pTxBufHead = &pTX_Buffer->fifo_head;
-	pbyTxBufferAddr = (u8 *)&pTxBufHead->adwTxKey[0];
+	pbyTxBufferAddr = pTxBufHead->tx_key;
 	wTxBufSize = sizeof(struct vnt_tx_fifo_head);
 
     if (pDevice->byBBType == BB_TYPE_11A) {
diff --git a/drivers/staging/vt6656/rxtx.h b/drivers/staging/vt6656/rxtx.h
index eecbe89..b2dbc09 100644
--- a/drivers/staging/vt6656/rxtx.h
+++ b/drivers/staging/vt6656/rxtx.h
@@ -215,7 +215,7 @@ union vnt_tx_head {
 };
 
 struct vnt_tx_fifo_head {
-	u32 adwTxKey[4];
+	u8 tx_key[16];
 	u16 wFIFOCtl;
 	u16 wTimeStamp;
 	u16 wFragCtl;
-- 
1.8.3.2

