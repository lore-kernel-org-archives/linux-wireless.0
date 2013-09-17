Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:47245 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753490Ab3IQS6T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Sep 2013 14:58:19 -0400
Received: by mail-wg0-f50.google.com with SMTP id f12so5483383wgh.17
        for <linux-wireless@vger.kernel.org>; Tue, 17 Sep 2013 11:58:18 -0700 (PDT)
Message-ID: <1379444291.5456.24.camel@canaries32-MCP7A> (sfid-20130917_205822_765169_163D56FA)
Subject: [PATCH 2/2] staging: vt6656: rxtx.c s_vGenerateTxParameter replace
 pTxBufHead void pointer.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Tue, 17 Sep 2013 19:58:11 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

with struct vnt_tx_buffer and attach vnt_tx_fifo_head to pTX_Buffer structure.

The the calling pbyTxBufferAddr points to the same address as
vnt_tx_buffer->fifo_head and is still in use.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index a733e3b..2a9deb6 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -99,9 +99,9 @@ static void s_vSaveTxPktInfo(struct vnt_private *pDevice, u8 byPktNum,
 static void *s_vGetFreeContext(struct vnt_private *pDevice);
 
 static void s_vGenerateTxParameter(struct vnt_private *pDevice,
-	u8 byPktType, u16 wCurrentRate,	void *pTxBufHead, void *pvRrvTime,
-	void *rts_cts, u32 cbFrameSize, int bNeedACK, u32 uDMAIdx,
-	struct ethhdr *psEthHeader, bool need_rts);
+	u8 byPktType, u16 wCurrentRate,	struct vnt_tx_buffer *tx_buffer,
+	void *pvRrvTime, void *rts_cts, u32 cbFrameSize, int bNeedACK,
+	u32 uDMAIdx, struct ethhdr *psEthHeader, bool need_rts);
 
 static u32 s_uFillDataHead(struct vnt_private *pDevice,
 	u8 byPktType, u16 wCurrentRate, void *pTxDataHead, u32 cbFrameLength,
@@ -840,12 +840,11 @@ static void s_vFillCTSHead(struct vnt_private *pDevice, u32 uDMAIdx,
 -*/
 
 static void s_vGenerateTxParameter(struct vnt_private *pDevice,
-	u8 byPktType, u16 wCurrentRate,	void *pTxBufHead, void *pvRrvTime,
-	void *rts_cts, u32 cbFrameSize, int bNeedACK, u32 uDMAIdx,
-	struct ethhdr *psEthHeader, bool need_rts)
+	u8 byPktType, u16 wCurrentRate,	struct vnt_tx_buffer *tx_buffer,
+	void *pvRrvTime, void *rts_cts, u32 cbFrameSize, int bNeedACK,
+	u32 uDMAIdx, struct ethhdr *psEthHeader, bool need_rts)
 {
-	struct vnt_tx_fifo_head *pFifoHead =
-				(struct vnt_tx_fifo_head *)pTxBufHead;
+	struct vnt_tx_fifo_head *pFifoHead = &tx_buffer->fifo_head;
 	union vnt_tx_data_head *head = rts_cts;
 	u32 cbMACHdLen = WLAN_HDR_ADDR3_LEN; /* 24 */
 	u16 wFifoCtl;
@@ -1237,7 +1236,7 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
 
     //Fill FIFO,RrvTime,RTS,and CTS
     s_vGenerateTxParameter(pDevice, byPktType, wCurrentRate,
-		(void *)pbyTxBufferAddr, pvRrvTime, rts_cts,
+		tx_buffer, pvRrvTime, rts_cts,
 		cbFrameSize, bNeedACK, uDMAIdx, psEthHeader, bRTS);
     //Fill DataHead
     uDuration = s_uFillDataHead(pDevice, byPktType, wCurrentRate, pvTxDataHd, cbFrameSize, uDMAIdx, bNeedACK,
@@ -1639,7 +1638,7 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice,
 
 	/* Fill FIFO,RrvTime,RTS,and CTS */
 	s_vGenerateTxParameter(pDevice, byPktType, wCurrentRate,
-		pbyTxBufferAddr, pvRrvTime, rts_cts,
+		pTX_Buffer, pvRrvTime, rts_cts,
 		cbFrameSize, bNeedACK, TYPE_TXDMA0, &sEthHeader, false);
 
     //Fill DataHead
@@ -2053,7 +2052,7 @@ void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb)
 
 	/* Fill FIFO,RrvTime,RTS,and CTS */
 	s_vGenerateTxParameter(pDevice, byPktType, wCurrentRate,
-		pbyTxBufferAddr, pvRrvTime, rts_cts,
+		pTX_Buffer, pvRrvTime, rts_cts,
 		cbFrameSize, bNeedACK, TYPE_TXDMA0, &sEthHeader, false);
 
     //Fill DataHead
-- 
1.8.1.2

