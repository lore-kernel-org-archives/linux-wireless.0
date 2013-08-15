Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f171.google.com ([209.85.215.171]:55649 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467Ab3HOShL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Aug 2013 14:37:11 -0400
Received: by mail-ea0-f171.google.com with SMTP id n15so541345ead.30
        for <linux-wireless@vger.kernel.org>; Thu, 15 Aug 2013 11:37:09 -0700 (PDT)
Message-ID: <1376591824.5404.20.camel@canaries32-MCP7A> (sfid-20130815_203715_183321_D3405A48)
Subject: [PATCH 2/3] staging: vt6656: rxtx.c : s_bPacketToWirelessUsb remove
 usbPacketBuf.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Thu, 15 Aug 2013 19:37:04 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move vnt_tx_buffer *pTxBufHead to argument u8 *usbPacketBuf position.

Fix the calling to s_bPacketToWirelessUsb so it attached to
the calling struct vnt_tx_buffer pTX_Buffer.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 083f58f..e37e82c 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -991,12 +991,12 @@ static void s_vGenerateTxParameter(struct vnt_private *pDevice,
 */
 
 static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
-	u8 *usbPacketBuf, int bNeedEncryption, u32 uSkbPacketLen, u32 uDMAIdx,
-	struct ethhdr *psEthHeader, u8 *pPacket, PSKeyItem pTransmitKey,
-	u32 uNodeIndex, u16 wCurrentRate, u32 *pcbHeaderLen, u32 *pcbTotalLen)
+	struct vnt_tx_buffer *pTxBufHead, int bNeedEncryption,
+	u32 uSkbPacketLen, u32 uDMAIdx,	struct ethhdr *psEthHeader,
+	u8 *pPacket, PSKeyItem pTransmitKey, u32 uNodeIndex, u16 wCurrentRate,
+	u32 *pcbHeaderLen, u32 *pcbTotalLen)
 {
 	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
-	struct vnt_tx_buffer *pTxBufHead;
 	u32 cbFrameSize, cbFrameBodySize;
 	u32 cb802_1_H_len;
 	u32 cbIVlen = 0, cbICVlen = 0, cbMIClen = 0, cbMACHdLen = 0;
@@ -1026,8 +1026,6 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
 			bSoftWEP = true; /* WEP 256 */
 	}
 
-	pTxBufHead = (struct vnt_tx_buffer *)usbPacketBuf;
-
     // Get pkt type
     if (ntohs(psEthHeader->h_proto) > ETH_DATA_LEN) {
         if (pDevice->dwDiagRefCount == 0) {
@@ -2541,8 +2539,10 @@ int nsDMA_tx_packet(struct vnt_private *pDevice,
         }
     }
 
+	pTX_Buffer = (struct vnt_tx_buffer *)&pContext->Data[0];
+
     fConvertedPacket = s_bPacketToWirelessUsb(pDevice, byPktType,
-                        (u8 *)(&pContext->Data[0]), bNeedEncryption,
+			pTX_Buffer, bNeedEncryption,
                         skb->len, uDMAIdx, &pDevice->sTxEthHeader,
                         (u8 *)skb->data, pTransmitKey, uNodeIndex,
                         pDevice->wCurrentRate,
@@ -2564,7 +2564,6 @@ int nsDMA_tx_packet(struct vnt_private *pDevice,
         }
     }
 
-	pTX_Buffer = (struct vnt_tx_buffer *)&pContext->Data[0];
     pTX_Buffer->byPKTNO = (u8) (((pDevice->wCurrentRate<<4) &0x00F0) | ((pDevice->wSeqCounter - 1) & 0x000F));
     pTX_Buffer->wTxByteCount = (u16)BytesToWrite;
 
@@ -2701,8 +2700,10 @@ int bRelayPacketSend(struct vnt_private *pDevice, u8 *pbySkbData, u32 uDataLen,
     // Convert the packet to an usb frame and copy into our buffer
     // and send the irp.
 
+	pTX_Buffer = (struct vnt_tx_buffer *)&pContext->Data[0];
+
     fConvertedPacket = s_bPacketToWirelessUsb(pDevice, byPktType,
-                         (u8 *)(&pContext->Data[0]), bNeedEncryption,
+			pTX_Buffer, bNeedEncryption,
                          uDataLen, TYPE_AC0DMA, &pDevice->sTxEthHeader,
                          pbySkbData, pTransmitKey, uNodeIndex,
                          pDevice->wCurrentRate,
@@ -2714,7 +2715,6 @@ int bRelayPacketSend(struct vnt_private *pDevice, u8 *pbySkbData, u32 uDataLen,
         return false;
     }
 
-	pTX_Buffer = (struct vnt_tx_buffer *)&pContext->Data[0];
     pTX_Buffer->byPKTNO = (u8) (((pDevice->wCurrentRate<<4) &0x00F0) | ((pDevice->wSeqCounter - 1) & 0x000F));
     pTX_Buffer->wTxByteCount = (u16)BytesToWrite;
 
-- 
1.8.1.2



