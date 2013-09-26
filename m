Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:53504 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059Ab3IZSAt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Sep 2013 14:00:49 -0400
Received: by mail-ee0-f41.google.com with SMTP id d17so731795eek.0
        for <linux-wireless@vger.kernel.org>; Thu, 26 Sep 2013 11:00:48 -0700 (PDT)
Message-ID: <1380218441.2059.16.camel@canaries64-MCP7A> (sfid-20130926_200053_059887_173C77D2)
Subject: [PATCH 5/5] staging: vt6656: rxtx.c remove dead code rts_cts void
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Thu, 26 Sep 2013 19:00:41 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 468a78b..791144a 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -100,9 +100,8 @@ static void *s_vGetFreeContext(struct vnt_private *pDevice);
 
 static void s_vGenerateTxParameter(struct vnt_private *pDevice,
 	u8 byPktType, u16 wCurrentRate,	struct vnt_tx_buffer *tx_buffer,
-	struct vnt_mic_hdr **mic_hdr, u32 need_mic,
-	void *rts_cts, u32 cbFrameSize, int bNeedACK, u32 uDMAIdx,
-	struct ethhdr *psEthHeader, bool need_rts);
+	struct vnt_mic_hdr **mic_hdr, u32 need_mic, u32 cbFrameSize,
+	int bNeedACK, u32 uDMAIdx, struct ethhdr *psEthHeader, bool need_rts);
 
 static u32 s_uFillDataHead(struct vnt_private *pDevice,
 	u8 byPktType, u16 wCurrentRate, void *pTxDataHead, u32 cbFrameLength,
@@ -842,9 +841,8 @@ static void s_vFillCTSHead(struct vnt_private *pDevice, u32 uDMAIdx,
 
 static void s_vGenerateTxParameter(struct vnt_private *pDevice,
 	u8 byPktType, u16 wCurrentRate,	struct vnt_tx_buffer *tx_buffer,
-	struct vnt_mic_hdr **mic_hdr, u32 need_mic,
-	void *rts_cts, u32 cbFrameSize, int bNeedACK, u32 uDMAIdx,
-	struct ethhdr *psEthHeader, bool need_rts)
+	struct vnt_mic_hdr **mic_hdr, u32 need_mic, u32 cbFrameSize,
+	int bNeedACK, u32 uDMAIdx, struct ethhdr *psEthHeader, bool need_rts)
 {
 	struct vnt_tx_fifo_head *pFifoHead = &tx_buffer->fifo_head;
 	union vnt_tx_data_head *head = NULL;
@@ -1013,7 +1011,6 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
 	u32 uDuration;
 	u32 cbHeaderLength = 0, uPadding = 0;
 	struct vnt_mic_hdr *pMICHDR;
-	void *rts_cts = NULL;
 	void *pvTxDataHd;
 	u8 byFBOption = AUTO_FB_NONE, byFragType;
 	u16 wTxBufSize;
@@ -1232,7 +1229,7 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
 
     //Fill FIFO,RrvTime,RTS,and CTS
     s_vGenerateTxParameter(pDevice, byPktType, wCurrentRate,
-		tx_buffer, &pMICHDR, cbMICHDR, rts_cts,
+		tx_buffer, &pMICHDR, cbMICHDR,
 		cbFrameSize, bNeedACK, uDMAIdx, psEthHeader, bRTS);
     //Fill DataHead
     uDuration = s_uFillDataHead(pDevice, byPktType, wCurrentRate, pvTxDataHd, cbFrameSize, uDMAIdx, bNeedACK,
@@ -1469,7 +1466,6 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice,
 	struct ieee80211_hdr *pMACHeader;
 	struct ethhdr sEthHeader;
 	u8 byPktType, *pbyTxBufferAddr;
-	void *rts_cts = NULL;
 	void *pvTxDataHd;
 	struct vnt_mic_hdr *pMICHDR = NULL;
 	u32 uDuration, cbReqCount, cbHeaderSize, cbFrameBodySize, cbFrameSize;
@@ -1628,7 +1624,7 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice,
 
 	/* Fill FIFO,RrvTime,RTS,and CTS */
 	s_vGenerateTxParameter(pDevice, byPktType, wCurrentRate,
-		pTX_Buffer, &pMICHDR, 0, rts_cts,
+		pTX_Buffer, &pMICHDR, 0,
 		cbFrameSize, bNeedACK, TYPE_TXDMA0, &sEthHeader, false);
 
     //Fill DataHead
@@ -1821,7 +1817,6 @@ void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb)
 	struct vnt_tx_fifo_head *pTxBufHead;
 	u8 byPktType;
 	u8 *pbyTxBufferAddr;
-	void *rts_cts = NULL;
 	void *pvTxDataHd;
 	u32 uDuration, cbReqCount;
 	struct ieee80211_hdr *pMACHeader;
@@ -2033,7 +2028,7 @@ void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb)
 
 	/* Fill FIFO,RrvTime,RTS,and CTS */
 	s_vGenerateTxParameter(pDevice, byPktType, wCurrentRate,
-		pTX_Buffer, &pMICHDR, cbMICHDR, rts_cts,
+		pTX_Buffer, &pMICHDR, cbMICHDR,
 		cbFrameSize, bNeedACK, TYPE_TXDMA0, &sEthHeader, false);
 
     //Fill DataHead
-- 
1.8.3.2

