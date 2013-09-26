Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:58453 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857Ab3IZRwT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Sep 2013 13:52:19 -0400
Received: by mail-wi0-f175.google.com with SMTP id ez12so7467203wid.2
        for <linux-wireless@vger.kernel.org>; Thu, 26 Sep 2013 10:52:18 -0700 (PDT)
Message-ID: <1380217930.2059.12.camel@canaries64-MCP7A> (sfid-20130926_195223_000320_4823B756)
Subject: [PATCH 3/5] staging: vt6656: rxtx.c s_vGenerateTxParameter Create
 vnt_mic_hdr structure
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Thu, 26 Sep 2013 18:52:10 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Create double pointer to pass back vnt_mic_hdr address position
of relevant structure if need_mic is more than 0. Otherwise it
is NULL.

This replaces the pMICHDR void pointer with struct vnt_mic_hdr
and assignments in the calling functions.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 55 ++++++++++++++++++++++---------------------
 1 file changed, 28 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index c80a809..7002b5d 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -100,6 +100,7 @@ static void *s_vGetFreeContext(struct vnt_private *pDevice);
 
 static void s_vGenerateTxParameter(struct vnt_private *pDevice,
 	u8 byPktType, u16 wCurrentRate,	struct vnt_tx_buffer *tx_buffer,
+	struct vnt_mic_hdr **mic_hdr, u32 need_mic,
 	void *rts_cts, u32 cbFrameSize, int bNeedACK, u32 uDMAIdx,
 	struct ethhdr *psEthHeader, bool need_rts);
 
@@ -841,6 +842,7 @@ static void s_vFillCTSHead(struct vnt_private *pDevice, u32 uDMAIdx,
 
 static void s_vGenerateTxParameter(struct vnt_private *pDevice,
 	u8 byPktType, u16 wCurrentRate,	struct vnt_tx_buffer *tx_buffer,
+	struct vnt_mic_hdr **mic_hdr, u32 need_mic,
 	void *rts_cts, u32 cbFrameSize, int bNeedACK, u32 uDMAIdx,
 	struct ethhdr *psEthHeader, bool need_rts)
 {
@@ -883,6 +885,9 @@ static void s_vGenerateTxParameter(struct vnt_private *pDevice,
 		pBuf->wTxRrvTime_b = vnt_rxtx_rsvtime_le16(pDevice,
 			PK_TYPE_11B, cbFrameSize, pDevice->byTopCCKBasicRate,
 				bNeedACK);
+		if (need_mic)
+			*mic_hdr = &tx_buffer->tx_head.tx_rts.tx.mic.hdr;
+
 		/* Fill RTS */
 		s_vFillRTSHead(pDevice, byPktType, head, cbFrameSize,
 			bNeedACK, psEthHeader, wCurrentRate, byFBOption);
@@ -898,6 +903,10 @@ static void s_vGenerateTxParameter(struct vnt_private *pDevice,
 			pDevice->byTopCCKBasicRate, bNeedACK);
 		pBuf->wCTSTxRrvTime_ba = s_uGetRTSCTSRsvTime(pDevice, 3,
 				byPktType, cbFrameSize, wCurrentRate);
+
+		if (need_mic)
+			*mic_hdr = &tx_buffer->tx_head.tx_cts.tx.mic.hdr;
+
 		/* Fill CTS */
 		s_vFillCTSHead(pDevice, uDMAIdx, byPktType, head,
 			cbFrameSize, bNeedACK, wCurrentRate, byFBOption);
@@ -912,6 +921,9 @@ static void s_vGenerateTxParameter(struct vnt_private *pDevice,
 				byPktType, cbFrameSize, wCurrentRate);
 		pBuf->wTxRrvTime = vnt_rxtx_rsvtime_le16(pDevice, byPktType,
 				cbFrameSize, wCurrentRate, bNeedACK);
+		if (need_mic)
+			*mic_hdr = &tx_buffer->tx_head.tx_ab.tx.mic.hdr;
+
 		/* Fill RTS */
 		s_vFillRTSHead(pDevice, byPktType, head, cbFrameSize,
 			bNeedACK, psEthHeader, wCurrentRate, byFBOption);
@@ -919,6 +931,9 @@ static void s_vGenerateTxParameter(struct vnt_private *pDevice,
             //Fill RsvTime
 		struct vnt_rrv_time_ab *pBuf = &tx_buffer->tx_head.tx_ab.ab;
 
+		if (need_mic)
+			*mic_hdr = &tx_buffer->tx_head.tx_ab.tx.mic.hdr;
+
 		pBuf->wTxRrvTime = vnt_rxtx_rsvtime_le16(pDevice, PK_TYPE_11A,
 			cbFrameSize, wCurrentRate, bNeedACK);
         }
@@ -932,6 +947,10 @@ static void s_vGenerateTxParameter(struct vnt_private *pDevice,
 				byPktType, cbFrameSize, wCurrentRate);
 		pBuf->wTxRrvTime = vnt_rxtx_rsvtime_le16(pDevice, PK_TYPE_11B,
 				cbFrameSize, wCurrentRate, bNeedACK);
+
+		if (need_mic)
+			*mic_hdr = &tx_buffer->tx_head.tx_ab.tx.mic.hdr;
+
 		/* Fill RTS */
 		s_vFillRTSHead(pDevice, byPktType, head, cbFrameSize,
 			bNeedACK, psEthHeader, wCurrentRate, byFBOption);
@@ -940,6 +959,9 @@ static void s_vGenerateTxParameter(struct vnt_private *pDevice,
             //Fill RsvTime
 		struct vnt_rrv_time_ab *pBuf = &tx_buffer->tx_head.tx_ab.ab;
 
+		if (need_mic)
+			*mic_hdr = &tx_buffer->tx_head.tx_ab.tx.mic.hdr;
+
 		pBuf->wTxRrvTime = vnt_rxtx_rsvtime_le16(pDevice, PK_TYPE_11B,
 			cbFrameSize, wCurrentRate, bNeedACK);
         }
@@ -1108,8 +1130,6 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
     if (byPktType == PK_TYPE_11GB || byPktType == PK_TYPE_11GA) {//802.11g packet
         if (byFBOption == AUTO_FB_NONE) {
             if (bRTS == true) {//RTS_need
-		pMICHDR = (struct vnt_mic_hdr *)(pbyTxBufferAddr + wTxBufSize +
-					sizeof(struct vnt_rrv_time_rts));
 		rts_cts = (struct vnt_rts_g *) (pbyTxBufferAddr + wTxBufSize +
 				sizeof(struct vnt_rrv_time_rts) + cbMICHDR);
 		pvTxDataHd = (struct vnt_tx_datahead_g *) (pbyTxBufferAddr +
@@ -1120,8 +1140,6 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
 				sizeof(struct vnt_tx_datahead_g);
             }
             else { //RTS_needless
-		pMICHDR = (struct vnt_mic_hdr *) (pbyTxBufferAddr + wTxBufSize +
-			sizeof(struct vnt_rrv_time_cts));
 		rts_cts = (struct vnt_cts *) (pbyTxBufferAddr + wTxBufSize +
 				sizeof(struct vnt_rrv_time_cts) + cbMICHDR);
 		pvTxDataHd = (struct vnt_tx_datahead_g *)(pbyTxBufferAddr +
@@ -1134,8 +1152,6 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
         } else {
             // Auto Fall Back
             if (bRTS == true) {//RTS_need
-		pMICHDR = (struct vnt_mic_hdr *) (pbyTxBufferAddr + wTxBufSize +
-					sizeof(struct vnt_rrv_time_rts));
 		rts_cts = (struct vnt_rts_g_fb *)(pbyTxBufferAddr + wTxBufSize +
 				sizeof(struct vnt_rrv_time_rts) + cbMICHDR);
 		pvTxDataHd = (struct vnt_tx_datahead_g_fb *) (pbyTxBufferAddr +
@@ -1146,8 +1162,6 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
 				sizeof(struct vnt_tx_datahead_g_fb);
             }
             else if (bRTS == false) { //RTS_needless
-		pMICHDR = (struct vnt_mic_hdr *) (pbyTxBufferAddr + wTxBufSize +
-				sizeof(struct vnt_rrv_time_cts));
 		rts_cts = (struct vnt_cts_fb *) (pbyTxBufferAddr + wTxBufSize +
 			sizeof(struct vnt_rrv_time_cts) + cbMICHDR);
 		pvTxDataHd = (struct vnt_tx_datahead_g_fb *) (pbyTxBufferAddr +
@@ -1162,8 +1176,6 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
     else {//802.11a/b packet
         if (byFBOption == AUTO_FB_NONE) {
             if (bRTS == true) {//RTS_need
-		pMICHDR = (struct vnt_mic_hdr *)(pbyTxBufferAddr + wTxBufSize +
-						sizeof(struct vnt_rrv_time_ab));
 		rts_cts = (struct vnt_rts_ab *) (pbyTxBufferAddr + wTxBufSize +
 				sizeof(struct vnt_rrv_time_ab) + cbMICHDR);
 		pvTxDataHd = (struct vnt_tx_datahead_ab *)(pbyTxBufferAddr +
@@ -1174,8 +1186,6 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
 				sizeof(struct vnt_tx_datahead_ab);
             }
             else if (bRTS == false) { //RTS_needless, no MICHDR
-		pMICHDR = (struct vnt_mic_hdr *) (pbyTxBufferAddr + wTxBufSize +
-						sizeof(struct vnt_rrv_time_ab));
 		pvTxDataHd = (struct vnt_tx_datahead_ab *)(pbyTxBufferAddr +
 			wTxBufSize + sizeof(struct vnt_rrv_time_ab) + cbMICHDR);
 		cbHeaderLength = wTxBufSize + sizeof(struct vnt_rrv_time_ab) +
@@ -1184,8 +1194,6 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
         } else {
             // Auto Fall Back
             if (bRTS == true) {//RTS_need
-		pMICHDR = (struct vnt_mic_hdr *) (pbyTxBufferAddr + wTxBufSize +
-			sizeof(struct vnt_rrv_time_ab));
 		rts_cts = (struct vnt_rts_a_fb *)(pbyTxBufferAddr + wTxBufSize +
 				sizeof(struct vnt_rrv_time_ab) + cbMICHDR);
 		pvTxDataHd = (struct vnt_tx_datahead_a_fb *)(pbyTxBufferAddr +
@@ -1196,8 +1204,6 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
 					sizeof(struct vnt_tx_datahead_a_fb);
             }
             else if (bRTS == false) { //RTS_needless
-		pMICHDR = (struct vnt_mic_hdr *)(pbyTxBufferAddr + wTxBufSize +
-						sizeof(struct vnt_rrv_time_ab));
 		pvTxDataHd = (struct vnt_tx_datahead_a_fb *)(pbyTxBufferAddr +
 			wTxBufSize + sizeof(struct vnt_rrv_time_ab) + cbMICHDR);
 		cbHeaderLength = wTxBufSize + sizeof(struct vnt_rrv_time_ab) +
@@ -1220,7 +1226,7 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
 
     //Fill FIFO,RrvTime,RTS,and CTS
     s_vGenerateTxParameter(pDevice, byPktType, wCurrentRate,
-		tx_buffer, rts_cts,
+		tx_buffer, &pMICHDR, cbMICHDR, rts_cts,
 		cbFrameSize, bNeedACK, uDMAIdx, psEthHeader, bRTS);
     //Fill DataHead
     uDuration = s_uFillDataHead(pDevice, byPktType, wCurrentRate, pvTxDataHd, cbFrameSize, uDMAIdx, bNeedACK,
@@ -1458,7 +1464,8 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice,
 	struct ethhdr sEthHeader;
 	u8 byPktType, *pbyTxBufferAddr;
 	void *rts_cts = NULL;
-	void *pvTxDataHd, *pMICHDR;
+	void *pvTxDataHd;
+	struct vnt_mic_hdr *pMICHDR = NULL;
 	u32 uDuration, cbReqCount, cbHeaderSize, cbFrameBodySize, cbFrameSize;
 	int bNeedACK, bIsPSPOLL = false;
 	u32 cbIVlen = 0, cbICVlen = 0, cbMIClen = 0, cbFCSlen = 4;
@@ -1590,7 +1597,6 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice,
 
     //Set RrvTime/RTS/CTS Buffer
     if (byPktType == PK_TYPE_11GB || byPktType == PK_TYPE_11GA) {//802.11g packet
-        pMICHDR = NULL;
 	rts_cts = (struct vnt_cts *) (pbyTxBufferAddr + wTxBufSize +
 					sizeof(struct vnt_rrv_time_cts));
 	pvTxDataHd = (struct vnt_tx_datahead_g *)(pbyTxBufferAddr + wTxBufSize +
@@ -1599,7 +1605,6 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice,
 		sizeof(struct vnt_cts) + sizeof(struct vnt_tx_datahead_g);
     }
     else { // 802.11a/b packet
-        pMICHDR = NULL;
 	pvTxDataHd = (struct vnt_tx_datahead_ab *) (pbyTxBufferAddr +
 		wTxBufSize + sizeof(struct vnt_rrv_time_ab));
 	cbHeaderSize = wTxBufSize + sizeof(struct vnt_rrv_time_ab) +
@@ -1619,7 +1624,7 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice,
 
 	/* Fill FIFO,RrvTime,RTS,and CTS */
 	s_vGenerateTxParameter(pDevice, byPktType, wCurrentRate,
-		pTX_Buffer, rts_cts,
+		pTX_Buffer, &pMICHDR, 0, rts_cts,
 		cbFrameSize, bNeedACK, TYPE_TXDMA0, &sEthHeader, false);
 
     //Fill DataHead
@@ -1828,7 +1833,7 @@ void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb)
 	u16 wTxBufSize;
 	u32 cbMacHdLen;
 	struct ethhdr sEthHeader;
-	void *pMICHDR;
+	struct vnt_mic_hdr *pMICHDR;
 	u32 wCurrentRate = RATE_1M;
 	PUWLAN_80211HDR  p80211Header;
 	u32 uNodeIndex = 0;
@@ -1998,8 +2003,6 @@ void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb)
     //the rest of pTxBufHead->wFragCtl:FragTyp will be set later in s_vFillFragParameter()
 
     if (byPktType == PK_TYPE_11GB || byPktType == PK_TYPE_11GA) {//802.11g packet
-	pMICHDR = (struct vnt_mic_hdr *) (pbyTxBufferAddr + wTxBufSize +
-					sizeof(struct vnt_rrv_time_cts));
 	rts_cts = (struct vnt_cts *) (pbyTxBufferAddr + wTxBufSize +
 			sizeof(struct vnt_rrv_time_cts) + cbMICHDR);
 	pvTxDataHd = (struct vnt_tx_datahead_g *) (pbyTxBufferAddr +
@@ -2010,8 +2013,6 @@ void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb)
 
     }
     else {//802.11a/b packet
-	pMICHDR = (struct vnt_mic_hdr *) (pbyTxBufferAddr + wTxBufSize +
-		sizeof(struct vnt_rrv_time_ab));
 	pvTxDataHd = (struct vnt_tx_datahead_ab *)(pbyTxBufferAddr +
 		wTxBufSize + sizeof(struct vnt_rrv_time_ab) + cbMICHDR);
 	cbHeaderSize = wTxBufSize + sizeof(struct vnt_rrv_time_ab) + cbMICHDR +
@@ -2030,7 +2031,7 @@ void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb)
 
 	/* Fill FIFO,RrvTime,RTS,and CTS */
 	s_vGenerateTxParameter(pDevice, byPktType, wCurrentRate,
-		pTX_Buffer, rts_cts,
+		pTX_Buffer, &pMICHDR, cbMICHDR, rts_cts,
 		cbFrameSize, bNeedACK, TYPE_TXDMA0, &sEthHeader, false);
 
     //Fill DataHead
-- 
1.8.3.2

