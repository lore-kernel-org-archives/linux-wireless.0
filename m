Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:42651 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254Ab3IZR5o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Sep 2013 13:57:44 -0400
Received: by mail-we0-f176.google.com with SMTP id u56so1522130wes.7
        for <linux-wireless@vger.kernel.org>; Thu, 26 Sep 2013 10:57:42 -0700 (PDT)
Message-ID: <1380218254.2059.14.camel@canaries64-MCP7A> (sfid-20130926_195748_500402_0F25774E)
Subject: [PATCH 4/5] staging: vt6656: rxtx.c Move rts_cts pointer assignment
  to s_vGenerateTxParameter
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Thu, 26 Sep 2013 18:57:34 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move rts/cts pointers to relevant vnt_tx_data_head position. 

Remove old rts_cts pointers in calling functions.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 44 ++++++++++++++++++++++---------------------
 1 file changed, 23 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 7002b5d..468a78b 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -847,7 +847,7 @@ static void s_vGenerateTxParameter(struct vnt_private *pDevice,
 	struct ethhdr *psEthHeader, bool need_rts)
 {
 	struct vnt_tx_fifo_head *pFifoHead = &tx_buffer->fifo_head;
-	union vnt_tx_data_head *head = rts_cts;
+	union vnt_tx_data_head *head = NULL;
 	u32 cbMACHdLen = WLAN_HDR_ADDR3_LEN; /* 24 */
 	u16 wFifoCtl;
 	u8 byFBOption = AUTO_FB_NONE;
@@ -885,8 +885,13 @@ static void s_vGenerateTxParameter(struct vnt_private *pDevice,
 		pBuf->wTxRrvTime_b = vnt_rxtx_rsvtime_le16(pDevice,
 			PK_TYPE_11B, cbFrameSize, pDevice->byTopCCKBasicRate,
 				bNeedACK);
-		if (need_mic)
+
+		if (need_mic) {
 			*mic_hdr = &tx_buffer->tx_head.tx_rts.tx.mic.hdr;
+			head = &tx_buffer->tx_head.tx_rts.tx.mic.head;
+		} else {
+			head = &tx_buffer->tx_head.tx_rts.tx.head;
+		}
 
 		/* Fill RTS */
 		s_vFillRTSHead(pDevice, byPktType, head, cbFrameSize,
@@ -904,8 +909,12 @@ static void s_vGenerateTxParameter(struct vnt_private *pDevice,
 		pBuf->wCTSTxRrvTime_ba = s_uGetRTSCTSRsvTime(pDevice, 3,
 				byPktType, cbFrameSize, wCurrentRate);
 
-		if (need_mic)
+		if (need_mic) {
 			*mic_hdr = &tx_buffer->tx_head.tx_cts.tx.mic.hdr;
+			head = &tx_buffer->tx_head.tx_cts.tx.mic.head;
+		} else {
+			head = &tx_buffer->tx_head.tx_cts.tx.head;
+		}
 
 		/* Fill CTS */
 		s_vFillCTSHead(pDevice, uDMAIdx, byPktType, head,
@@ -921,8 +930,13 @@ static void s_vGenerateTxParameter(struct vnt_private *pDevice,
 				byPktType, cbFrameSize, wCurrentRate);
 		pBuf->wTxRrvTime = vnt_rxtx_rsvtime_le16(pDevice, byPktType,
 				cbFrameSize, wCurrentRate, bNeedACK);
-		if (need_mic)
+
+		if (need_mic) {
 			*mic_hdr = &tx_buffer->tx_head.tx_ab.tx.mic.hdr;
+			head = &tx_buffer->tx_head.tx_ab.tx.mic.head;
+		} else {
+			head = &tx_buffer->tx_head.tx_ab.tx.head;
+		}
 
 		/* Fill RTS */
 		s_vFillRTSHead(pDevice, byPktType, head, cbFrameSize,
@@ -948,8 +962,12 @@ static void s_vGenerateTxParameter(struct vnt_private *pDevice,
 		pBuf->wTxRrvTime = vnt_rxtx_rsvtime_le16(pDevice, PK_TYPE_11B,
 				cbFrameSize, wCurrentRate, bNeedACK);
 
-		if (need_mic)
+		if (need_mic) {
 			*mic_hdr = &tx_buffer->tx_head.tx_ab.tx.mic.hdr;
+			head = &tx_buffer->tx_head.tx_ab.tx.mic.head;
+		} else {
+			head = &tx_buffer->tx_head.tx_ab.tx.head;
+		}
 
 		/* Fill RTS */
 		s_vFillRTSHead(pDevice, byPktType, head, cbFrameSize,
@@ -1130,8 +1148,6 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
     if (byPktType == PK_TYPE_11GB || byPktType == PK_TYPE_11GA) {//802.11g packet
         if (byFBOption == AUTO_FB_NONE) {
             if (bRTS == true) {//RTS_need
-		rts_cts = (struct vnt_rts_g *) (pbyTxBufferAddr + wTxBufSize +
-				sizeof(struct vnt_rrv_time_rts) + cbMICHDR);
 		pvTxDataHd = (struct vnt_tx_datahead_g *) (pbyTxBufferAddr +
 			wTxBufSize + sizeof(struct vnt_rrv_time_rts) +
 				cbMICHDR + sizeof(struct vnt_rts_g));
@@ -1140,8 +1156,6 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
 				sizeof(struct vnt_tx_datahead_g);
             }
             else { //RTS_needless
-		rts_cts = (struct vnt_cts *) (pbyTxBufferAddr + wTxBufSize +
-				sizeof(struct vnt_rrv_time_cts) + cbMICHDR);
 		pvTxDataHd = (struct vnt_tx_datahead_g *)(pbyTxBufferAddr +
 			wTxBufSize + sizeof(struct vnt_rrv_time_cts) +
 				cbMICHDR + sizeof(struct vnt_cts));
@@ -1152,8 +1166,6 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
         } else {
             // Auto Fall Back
             if (bRTS == true) {//RTS_need
-		rts_cts = (struct vnt_rts_g_fb *)(pbyTxBufferAddr + wTxBufSize +
-				sizeof(struct vnt_rrv_time_rts) + cbMICHDR);
 		pvTxDataHd = (struct vnt_tx_datahead_g_fb *) (pbyTxBufferAddr +
 			wTxBufSize + sizeof(struct vnt_rrv_time_rts) +
 				cbMICHDR + sizeof(struct vnt_rts_g_fb));
@@ -1162,8 +1174,6 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
 				sizeof(struct vnt_tx_datahead_g_fb);
             }
             else if (bRTS == false) { //RTS_needless
-		rts_cts = (struct vnt_cts_fb *) (pbyTxBufferAddr + wTxBufSize +
-			sizeof(struct vnt_rrv_time_cts) + cbMICHDR);
 		pvTxDataHd = (struct vnt_tx_datahead_g_fb *) (pbyTxBufferAddr +
 			wTxBufSize + sizeof(struct vnt_rrv_time_cts) +
 				cbMICHDR + sizeof(struct vnt_cts_fb));
@@ -1176,8 +1186,6 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
     else {//802.11a/b packet
         if (byFBOption == AUTO_FB_NONE) {
             if (bRTS == true) {//RTS_need
-		rts_cts = (struct vnt_rts_ab *) (pbyTxBufferAddr + wTxBufSize +
-				sizeof(struct vnt_rrv_time_ab) + cbMICHDR);
 		pvTxDataHd = (struct vnt_tx_datahead_ab *)(pbyTxBufferAddr +
 			wTxBufSize + sizeof(struct vnt_rrv_time_ab) + cbMICHDR +
 						sizeof(struct vnt_rts_ab));
@@ -1194,8 +1202,6 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
         } else {
             // Auto Fall Back
             if (bRTS == true) {//RTS_need
-		rts_cts = (struct vnt_rts_a_fb *)(pbyTxBufferAddr + wTxBufSize +
-				sizeof(struct vnt_rrv_time_ab) + cbMICHDR);
 		pvTxDataHd = (struct vnt_tx_datahead_a_fb *)(pbyTxBufferAddr +
 			wTxBufSize + sizeof(struct vnt_rrv_time_ab) + cbMICHDR +
 					sizeof(struct vnt_rts_a_fb));
@@ -1597,8 +1603,6 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice,
 
     //Set RrvTime/RTS/CTS Buffer
     if (byPktType == PK_TYPE_11GB || byPktType == PK_TYPE_11GA) {//802.11g packet
-	rts_cts = (struct vnt_cts *) (pbyTxBufferAddr + wTxBufSize +
-					sizeof(struct vnt_rrv_time_cts));
 	pvTxDataHd = (struct vnt_tx_datahead_g *)(pbyTxBufferAddr + wTxBufSize +
 		sizeof(struct vnt_rrv_time_cts) + sizeof(struct vnt_cts));
 	cbHeaderSize = wTxBufSize + sizeof(struct vnt_rrv_time_cts) +
@@ -2003,8 +2007,6 @@ void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb)
     //the rest of pTxBufHead->wFragCtl:FragTyp will be set later in s_vFillFragParameter()
 
     if (byPktType == PK_TYPE_11GB || byPktType == PK_TYPE_11GA) {//802.11g packet
-	rts_cts = (struct vnt_cts *) (pbyTxBufferAddr + wTxBufSize +
-			sizeof(struct vnt_rrv_time_cts) + cbMICHDR);
 	pvTxDataHd = (struct vnt_tx_datahead_g *) (pbyTxBufferAddr +
 		wTxBufSize + sizeof(struct vnt_rrv_time_cts) + cbMICHDR +
 					sizeof(struct vnt_cts));
-- 
1.8.3.2

