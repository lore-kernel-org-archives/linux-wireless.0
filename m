Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:46848 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142Ab3IZRrk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Sep 2013 13:47:40 -0400
Received: by mail-wg0-f42.google.com with SMTP id m15so6557438wgh.1
        for <linux-wireless@vger.kernel.org>; Thu, 26 Sep 2013 10:47:39 -0700 (PDT)
Message-ID: <1380217645.2059.10.camel@canaries64-MCP7A> (sfid-20130926_194746_196270_DA98A3E6)
Subject: [PATCH 1/5] staging: vt6656: rxtx.c Create union of struct
 vnt_rrv_time* stuctures
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Thu, 26 Sep 2013 18:47:25 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Attach union vnt_tx_head to structure vnt_tx_buffer replacing pointer
pvRrvTime.

In s_vGenerateTxParameter the relevant struct vnt_rrv_time_*
structure is attached to the vnt_tx_head.

The NULL check is now pFifoHead.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 72 +++++++++++++++----------------------------
 drivers/staging/vt6656/rxtx.h |  7 +++++
 2 files changed, 32 insertions(+), 47 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 2a9deb6..7b05ee8 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -100,8 +100,8 @@ static void *s_vGetFreeContext(struct vnt_private *pDevice);
 
 static void s_vGenerateTxParameter(struct vnt_private *pDevice,
 	u8 byPktType, u16 wCurrentRate,	struct vnt_tx_buffer *tx_buffer,
-	void *pvRrvTime, void *rts_cts, u32 cbFrameSize, int bNeedACK,
-	u32 uDMAIdx, struct ethhdr *psEthHeader, bool need_rts);
+	void *rts_cts, u32 cbFrameSize, int bNeedACK, u32 uDMAIdx,
+	struct ethhdr *psEthHeader, bool need_rts);
 
 static u32 s_uFillDataHead(struct vnt_private *pDevice,
 	u8 byPktType, u16 wCurrentRate, void *pTxDataHead, u32 cbFrameLength,
@@ -841,8 +841,8 @@ static void s_vFillCTSHead(struct vnt_private *pDevice, u32 uDMAIdx,
 
 static void s_vGenerateTxParameter(struct vnt_private *pDevice,
 	u8 byPktType, u16 wCurrentRate,	struct vnt_tx_buffer *tx_buffer,
-	void *pvRrvTime, void *rts_cts, u32 cbFrameSize, int bNeedACK,
-	u32 uDMAIdx, struct ethhdr *psEthHeader, bool need_rts)
+	void *rts_cts, u32 cbFrameSize, int bNeedACK, u32 uDMAIdx,
+	struct ethhdr *psEthHeader, bool need_rts)
 {
 	struct vnt_tx_fifo_head *pFifoHead = &tx_buffer->fifo_head;
 	union vnt_tx_data_head *head = rts_cts;
@@ -861,7 +861,7 @@ static void s_vGenerateTxParameter(struct vnt_private *pDevice,
         byFBOption = AUTO_FB_1;
     }
 
-	if (!pvRrvTime)
+	if (!pFifoHead)
 		return;
 
     if (pDevice->bLongHeader)
@@ -870,8 +870,8 @@ static void s_vGenerateTxParameter(struct vnt_private *pDevice,
     if (byPktType == PK_TYPE_11GB || byPktType == PK_TYPE_11GA) {
 	if (need_rts) {
             //Fill RsvTime
-		struct vnt_rrv_time_rts *pBuf =
-			(struct vnt_rrv_time_rts *)pvRrvTime;
+		struct vnt_rrv_time_rts *pBuf = &tx_buffer->tx_head.rts;
+
 		pBuf->wRTSTxRrvTime_aa = s_uGetRTSCTSRsvTime(pDevice, 2,
 				byPktType, cbFrameSize, wCurrentRate);
 		pBuf->wRTSTxRrvTime_ba = s_uGetRTSCTSRsvTime(pDevice, 1,
@@ -889,8 +889,8 @@ static void s_vGenerateTxParameter(struct vnt_private *pDevice,
         }
         else {//RTS_needless, PCF mode
             //Fill RsvTime
-		struct vnt_rrv_time_cts *pBuf =
-				(struct vnt_rrv_time_cts *)pvRrvTime;
+		struct vnt_rrv_time_cts *pBuf = &tx_buffer->tx_head.cts;
+
 		pBuf->wTxRrvTime_a = vnt_rxtx_rsvtime_le16(pDevice, byPktType,
 			cbFrameSize, wCurrentRate, bNeedACK);
 		pBuf->wTxRrvTime_b = vnt_rxtx_rsvtime_le16(pDevice,
@@ -906,8 +906,8 @@ static void s_vGenerateTxParameter(struct vnt_private *pDevice,
     else if (byPktType == PK_TYPE_11A) {
 	if (need_rts) {
             //Fill RsvTime
-		struct vnt_rrv_time_ab *pBuf =
-				(struct vnt_rrv_time_ab *)pvRrvTime;
+		struct vnt_rrv_time_ab *pBuf = &tx_buffer->tx_head.ab;
+
 		pBuf->wRTSTxRrvTime = s_uGetRTSCTSRsvTime(pDevice, 2,
 				byPktType, cbFrameSize, wCurrentRate);
 		pBuf->wTxRrvTime = vnt_rxtx_rsvtime_le16(pDevice, byPktType,
@@ -917,8 +917,8 @@ static void s_vGenerateTxParameter(struct vnt_private *pDevice,
 			bNeedACK, psEthHeader, wCurrentRate, byFBOption);
 	} else {
             //Fill RsvTime
-		struct vnt_rrv_time_ab *pBuf =
-				(struct vnt_rrv_time_ab *)pvRrvTime;
+		struct vnt_rrv_time_ab *pBuf = &tx_buffer->tx_head.ab;
+
 		pBuf->wTxRrvTime = vnt_rxtx_rsvtime_le16(pDevice, PK_TYPE_11A,
 			cbFrameSize, wCurrentRate, bNeedACK);
         }
@@ -926,8 +926,8 @@ static void s_vGenerateTxParameter(struct vnt_private *pDevice,
     else if (byPktType == PK_TYPE_11B) {
 	if (need_rts) {
             //Fill RsvTime
-		struct vnt_rrv_time_ab *pBuf =
-				(struct vnt_rrv_time_ab *)pvRrvTime;
+		struct vnt_rrv_time_ab *pBuf = &tx_buffer->tx_head.ab;
+
 		pBuf->wRTSTxRrvTime = s_uGetRTSCTSRsvTime(pDevice, 0,
 				byPktType, cbFrameSize, wCurrentRate);
 		pBuf->wTxRrvTime = vnt_rxtx_rsvtime_le16(pDevice, PK_TYPE_11B,
@@ -938,8 +938,8 @@ static void s_vGenerateTxParameter(struct vnt_private *pDevice,
         }
         else { //RTS_needless, non PCF mode
             //Fill RsvTime
-		struct vnt_rrv_time_ab *pBuf =
-				(struct vnt_rrv_time_ab *)pvRrvTime;
+		struct vnt_rrv_time_ab *pBuf = &tx_buffer->tx_head.ab;
+
 		pBuf->wTxRrvTime = vnt_rxtx_rsvtime_le16(pDevice, PK_TYPE_11B,
 			cbFrameSize, wCurrentRate, bNeedACK);
         }
@@ -972,7 +972,6 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
 		= {0xAA, 0xAA, 0x03, 0x00, 0x00, 0xF8};
 	u32 uDuration;
 	u32 cbHeaderLength = 0, uPadding = 0;
-	void *pvRrvTime;
 	struct vnt_mic_hdr *pMICHDR;
 	void *rts_cts = NULL;
 	void *pvTxDataHd;
@@ -981,7 +980,8 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
 	u32 dwMICKey0, dwMICKey1, dwMIC_Priority;
 	u32 *pdwMIC_L, *pdwMIC_R;
 	int bSoftWEP = false;
-	pvRrvTime = pMICHDR = pvTxDataHd = NULL;
+
+	pMICHDR = pvTxDataHd = NULL;
 
 	if (bNeedEncryption && pTransmitKey->pvKeyTable) {
 		if (((PSKeyTable)pTransmitKey->pvKeyTable)->bSoftWEP == true)
@@ -1108,8 +1108,6 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
     if (byPktType == PK_TYPE_11GB || byPktType == PK_TYPE_11GA) {//802.11g packet
         if (byFBOption == AUTO_FB_NONE) {
             if (bRTS == true) {//RTS_need
-		pvRrvTime = (struct vnt_rrv_time_rts *)
-					(pbyTxBufferAddr + wTxBufSize);
 		pMICHDR = (struct vnt_mic_hdr *)(pbyTxBufferAddr + wTxBufSize +
 					sizeof(struct vnt_rrv_time_rts));
 		rts_cts = (struct vnt_rts_g *) (pbyTxBufferAddr + wTxBufSize +
@@ -1122,8 +1120,6 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
 				sizeof(struct vnt_tx_datahead_g);
             }
             else { //RTS_needless
-		pvRrvTime = (struct vnt_rrv_time_cts *)
-				(pbyTxBufferAddr + wTxBufSize);
 		pMICHDR = (struct vnt_mic_hdr *) (pbyTxBufferAddr + wTxBufSize +
 			sizeof(struct vnt_rrv_time_cts));
 		rts_cts = (struct vnt_cts *) (pbyTxBufferAddr + wTxBufSize +
@@ -1138,8 +1134,6 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
         } else {
             // Auto Fall Back
             if (bRTS == true) {//RTS_need
-		pvRrvTime = (struct vnt_rrv_time_rts *)(pbyTxBufferAddr +
-								wTxBufSize);
 		pMICHDR = (struct vnt_mic_hdr *) (pbyTxBufferAddr + wTxBufSize +
 					sizeof(struct vnt_rrv_time_rts));
 		rts_cts = (struct vnt_rts_g_fb *)(pbyTxBufferAddr + wTxBufSize +
@@ -1152,8 +1146,6 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
 				sizeof(struct vnt_tx_datahead_g_fb);
             }
             else if (bRTS == false) { //RTS_needless
-		pvRrvTime = (struct vnt_rrv_time_cts *)
-				(pbyTxBufferAddr + wTxBufSize);
 		pMICHDR = (struct vnt_mic_hdr *) (pbyTxBufferAddr + wTxBufSize +
 				sizeof(struct vnt_rrv_time_cts));
 		rts_cts = (struct vnt_cts_fb *) (pbyTxBufferAddr + wTxBufSize +
@@ -1170,8 +1162,6 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
     else {//802.11a/b packet
         if (byFBOption == AUTO_FB_NONE) {
             if (bRTS == true) {//RTS_need
-		pvRrvTime = (struct vnt_rrv_time_ab *) (pbyTxBufferAddr +
-								wTxBufSize);
 		pMICHDR = (struct vnt_mic_hdr *)(pbyTxBufferAddr + wTxBufSize +
 						sizeof(struct vnt_rrv_time_ab));
 		rts_cts = (struct vnt_rts_ab *) (pbyTxBufferAddr + wTxBufSize +
@@ -1184,8 +1174,6 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
 				sizeof(struct vnt_tx_datahead_ab);
             }
             else if (bRTS == false) { //RTS_needless, no MICHDR
-		pvRrvTime = (struct vnt_rrv_time_ab *)(pbyTxBufferAddr +
-								wTxBufSize);
 		pMICHDR = (struct vnt_mic_hdr *) (pbyTxBufferAddr + wTxBufSize +
 						sizeof(struct vnt_rrv_time_ab));
 		pvTxDataHd = (struct vnt_tx_datahead_ab *)(pbyTxBufferAddr +
@@ -1196,8 +1184,6 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
         } else {
             // Auto Fall Back
             if (bRTS == true) {//RTS_need
-		pvRrvTime = (struct vnt_rrv_time_ab *)(pbyTxBufferAddr +
-						wTxBufSize);
 		pMICHDR = (struct vnt_mic_hdr *) (pbyTxBufferAddr + wTxBufSize +
 			sizeof(struct vnt_rrv_time_ab));
 		rts_cts = (struct vnt_rts_a_fb *)(pbyTxBufferAddr + wTxBufSize +
@@ -1210,8 +1196,6 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
 					sizeof(struct vnt_tx_datahead_a_fb);
             }
             else if (bRTS == false) { //RTS_needless
-		pvRrvTime = (struct vnt_rrv_time_ab *)(pbyTxBufferAddr +
-								wTxBufSize);
 		pMICHDR = (struct vnt_mic_hdr *)(pbyTxBufferAddr + wTxBufSize +
 						sizeof(struct vnt_rrv_time_ab));
 		pvTxDataHd = (struct vnt_tx_datahead_a_fb *)(pbyTxBufferAddr +
@@ -1236,7 +1220,7 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
 
     //Fill FIFO,RrvTime,RTS,and CTS
     s_vGenerateTxParameter(pDevice, byPktType, wCurrentRate,
-		tx_buffer, pvRrvTime, rts_cts,
+		tx_buffer, rts_cts,
 		cbFrameSize, bNeedACK, uDMAIdx, psEthHeader, bRTS);
     //Fill DataHead
     uDuration = s_uFillDataHead(pDevice, byPktType, wCurrentRate, pvTxDataHd, cbFrameSize, uDMAIdx, bNeedACK,
@@ -1474,7 +1458,7 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice,
 	struct ethhdr sEthHeader;
 	u8 byPktType, *pbyTxBufferAddr;
 	void *rts_cts = NULL;
-	void *pvTxDataHd, *pvRrvTime, *pMICHDR;
+	void *pvTxDataHd, *pMICHDR;
 	u32 uDuration, cbReqCount, cbHeaderSize, cbFrameBodySize, cbFrameSize;
 	int bNeedACK, bIsPSPOLL = false;
 	u32 cbIVlen = 0, cbICVlen = 0, cbMIClen = 0, cbFCSlen = 4;
@@ -1606,8 +1590,6 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice,
 
     //Set RrvTime/RTS/CTS Buffer
     if (byPktType == PK_TYPE_11GB || byPktType == PK_TYPE_11GA) {//802.11g packet
-
-	pvRrvTime = (struct vnt_rrv_time_cts *) (pbyTxBufferAddr + wTxBufSize);
         pMICHDR = NULL;
 	rts_cts = (struct vnt_cts *) (pbyTxBufferAddr + wTxBufSize +
 					sizeof(struct vnt_rrv_time_cts));
@@ -1617,7 +1599,6 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice,
 		sizeof(struct vnt_cts) + sizeof(struct vnt_tx_datahead_g);
     }
     else { // 802.11a/b packet
-	pvRrvTime = (struct vnt_rrv_time_ab *) (pbyTxBufferAddr + wTxBufSize);
         pMICHDR = NULL;
 	pvTxDataHd = (struct vnt_tx_datahead_ab *) (pbyTxBufferAddr +
 		wTxBufSize + sizeof(struct vnt_rrv_time_ab));
@@ -1638,7 +1619,7 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice,
 
 	/* Fill FIFO,RrvTime,RTS,and CTS */
 	s_vGenerateTxParameter(pDevice, byPktType, wCurrentRate,
-		pTX_Buffer, pvRrvTime, rts_cts,
+		pTX_Buffer, rts_cts,
 		cbFrameSize, bNeedACK, TYPE_TXDMA0, &sEthHeader, false);
 
     //Fill DataHead
@@ -1847,7 +1828,7 @@ void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb)
 	u16 wTxBufSize;
 	u32 cbMacHdLen;
 	struct ethhdr sEthHeader;
-	void *pvRrvTime, *pMICHDR;
+	void *pMICHDR;
 	u32 wCurrentRate = RATE_1M;
 	PUWLAN_80211HDR  p80211Header;
 	u32 uNodeIndex = 0;
@@ -1858,7 +1839,7 @@ void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb)
 	u32 cbExtSuppRate = 0;
 	struct vnt_usb_send_context *pContext;
 
-	pvRrvTime = pMICHDR = pvTxDataHd = NULL;
+	pMICHDR = pvTxDataHd = NULL;
 
     if(skb->len <= WLAN_HDR_ADDR3_LEN) {
        cbFrameBodySize = 0;
@@ -2017,7 +1998,6 @@ void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb)
     //the rest of pTxBufHead->wFragCtl:FragTyp will be set later in s_vFillFragParameter()
 
     if (byPktType == PK_TYPE_11GB || byPktType == PK_TYPE_11GA) {//802.11g packet
-	pvRrvTime = (struct vnt_rrv_time_cts *) (pbyTxBufferAddr + wTxBufSize);
 	pMICHDR = (struct vnt_mic_hdr *) (pbyTxBufferAddr + wTxBufSize +
 					sizeof(struct vnt_rrv_time_cts));
 	rts_cts = (struct vnt_cts *) (pbyTxBufferAddr + wTxBufSize +
@@ -2030,8 +2010,6 @@ void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb)
 
     }
     else {//802.11a/b packet
-
-	pvRrvTime = (struct vnt_rrv_time_ab *) (pbyTxBufferAddr + wTxBufSize);
 	pMICHDR = (struct vnt_mic_hdr *) (pbyTxBufferAddr + wTxBufSize +
 		sizeof(struct vnt_rrv_time_ab));
 	pvTxDataHd = (struct vnt_tx_datahead_ab *)(pbyTxBufferAddr +
@@ -2052,7 +2030,7 @@ void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb)
 
 	/* Fill FIFO,RrvTime,RTS,and CTS */
 	s_vGenerateTxParameter(pDevice, byPktType, wCurrentRate,
-		pTX_Buffer, pvRrvTime, rts_cts,
+		pTX_Buffer, rts_cts,
 		cbFrameSize, bNeedACK, TYPE_TXDMA0, &sEthHeader, false);
 
     //Fill DataHead
diff --git a/drivers/staging/vt6656/rxtx.h b/drivers/staging/vt6656/rxtx.h
index 137e62d..78b7b74 100644
--- a/drivers/staging/vt6656/rxtx.h
+++ b/drivers/staging/vt6656/rxtx.h
@@ -180,6 +180,12 @@ union vnt_tx_data_head {
 	struct vnt_cts_fb cts_g_fb;
 };
 
+union vnt_tx_head {
+	struct vnt_rrv_time_rts rts;
+	struct vnt_rrv_time_cts cts;
+	struct vnt_rrv_time_ab ab;
+};
+
 struct vnt_tx_fifo_head {
 	u32 adwTxKey[4];
 	u16 wFIFOCtl;
@@ -193,6 +199,7 @@ struct vnt_tx_buffer {
 	u8 byPKTNO;
 	u16 wTxByteCount;
 	struct vnt_tx_fifo_head fifo_head;
+	union vnt_tx_head tx_head;
 } __packed;
 
 struct vnt_beacon_buffer {
-- 
1.8.3.2

