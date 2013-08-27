Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f52.google.com ([209.85.214.52]:57898 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752907Ab3H0LDF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Aug 2013 07:03:05 -0400
Received: by mail-bk0-f52.google.com with SMTP id e11so1586037bkh.11
        for <linux-wireless@vger.kernel.org>; Tue, 27 Aug 2013 04:03:03 -0700 (PDT)
Message-ID: <1377601374.3320.68.camel@canaries32-MCP7A> (sfid-20130827_130313_063601_3EFA3EB8)
Subject: [PATCH 4/5] staging: vt6656: rxtx.c merge pvRTS and pvCTS/pCTS void
 pointers
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Tue, 27 Aug 2013 12:02:54 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As result of patch
rxtx.c s_vGenerateTxParameter create argument bool need rts

RTS and CTS void pointers can be merged.

Create new pointer rts_cts so that unions in s_vFillCTSHead/s_vFillRTSHead
can be joined.

If rts_cts is NULL neither exist.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 86 ++++++++++++++++++-------------------------
 1 file changed, 36 insertions(+), 50 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 2fd71c3..c9f6ffc 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -100,7 +100,7 @@ static void *s_vGetFreeContext(struct vnt_private *pDevice);
 
 static void s_vGenerateTxParameter(struct vnt_private *pDevice,
 	u8 byPktType, u16 wCurrentRate,	void *pTxBufHead, void *pvRrvTime,
-	void *pvRTS, void *pvCTS, u32 cbFrameSize, int bNeedACK, u32 uDMAIdx,
+	void *rts_cts, u32 cbFrameSize, int bNeedACK, u32 uDMAIdx,
 	struct ethhdr *psEthHeader, bool need_rts);
 
 static u32 s_uFillDataHead(struct vnt_private *pDevice,
@@ -828,7 +828,7 @@ static void s_vFillCTSHead(struct vnt_private *pDevice, u32 uDMAIdx,
 
 static void s_vGenerateTxParameter(struct vnt_private *pDevice,
 	u8 byPktType, u16 wCurrentRate,	void *pTxBufHead, void *pvRrvTime,
-	void *pvRTS, void *pvCTS, u32 cbFrameSize, int bNeedACK, u32 uDMAIdx,
+	void *rts_cts, u32 cbFrameSize, int bNeedACK, u32 uDMAIdx,
 	struct ethhdr *psEthHeader, bool need_rts)
 {
 	u32 cbMACHdLen = WLAN_HDR_ADDR3_LEN; /* 24 */
@@ -869,9 +869,9 @@ static void s_vGenerateTxParameter(struct vnt_private *pDevice,
 		pBuf->wTxRrvTime_b = vnt_rxtx_rsvtime_le16(pDevice,
 			PK_TYPE_11B, cbFrameSize, pDevice->byTopCCKBasicRate,
 				bNeedACK);
-            //Fill RTS
-	    s_vFillRTSHead(pDevice, byPktType, pvRTS, cbFrameSize, bNeedACK,
-				psEthHeader, wCurrentRate, byFBOption);
+		/* Fill RTS */
+		s_vFillRTSHead(pDevice, byPktType, rts_cts, cbFrameSize,
+			bNeedACK, psEthHeader, wCurrentRate, byFBOption);
         }
         else {//RTS_needless, PCF mode
             //Fill RsvTime
@@ -884,9 +884,9 @@ static void s_vGenerateTxParameter(struct vnt_private *pDevice,
 			pDevice->byTopCCKBasicRate, bNeedACK);
 		pBuf->wCTSTxRrvTime_ba = s_uGetRTSCTSRsvTime(pDevice, 3,
 				byPktType, cbFrameSize, wCurrentRate);
-            //Fill CTS
-	    s_vFillCTSHead(pDevice, uDMAIdx, byPktType, pvCTS, cbFrameSize,
-			bNeedACK, wCurrentRate, byFBOption);
+		/* Fill CTS */
+		s_vFillCTSHead(pDevice, uDMAIdx, byPktType, rts_cts,
+			cbFrameSize, bNeedACK, wCurrentRate, byFBOption);
         }
     }
     else if (byPktType == PK_TYPE_11A) {
@@ -898,9 +898,9 @@ static void s_vGenerateTxParameter(struct vnt_private *pDevice,
 				byPktType, cbFrameSize, wCurrentRate);
 		pBuf->wTxRrvTime = vnt_rxtx_rsvtime_le16(pDevice, byPktType,
 				cbFrameSize, wCurrentRate, bNeedACK);
-            //Fill RTS
-	    s_vFillRTSHead(pDevice, byPktType, pvRTS, cbFrameSize, bNeedACK,
-			psEthHeader, wCurrentRate, byFBOption);
+		/* Fill RTS */
+		s_vFillRTSHead(pDevice, byPktType, rts_cts, cbFrameSize,
+			bNeedACK, psEthHeader, wCurrentRate, byFBOption);
 	} else {
             //Fill RsvTime
 		struct vnt_rrv_time_ab *pBuf =
@@ -918,9 +918,9 @@ static void s_vGenerateTxParameter(struct vnt_private *pDevice,
 				byPktType, cbFrameSize, wCurrentRate);
 		pBuf->wTxRrvTime = vnt_rxtx_rsvtime_le16(pDevice, PK_TYPE_11B,
 				cbFrameSize, wCurrentRate, bNeedACK);
-            //Fill RTS
-	    s_vFillRTSHead(pDevice, byPktType, pvRTS, cbFrameSize, bNeedACK,
-			psEthHeader, wCurrentRate, byFBOption);
+		/* Fill RTS */
+		s_vFillRTSHead(pDevice, byPktType, rts_cts, cbFrameSize,
+			bNeedACK, psEthHeader, wCurrentRate, byFBOption);
         }
         else { //RTS_needless, non PCF mode
             //Fill RsvTime
@@ -959,8 +959,7 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
 	u32 cbHeaderLength = 0, uPadding = 0;
 	void *pvRrvTime;
 	struct vnt_mic_hdr *pMICHDR;
-	void *pvRTS;
-	void *pvCTS;
+	void *rts_cts = NULL;
 	void *pvTxDataHd;
 	u8 byFBOption = AUTO_FB_NONE, byFragType;
 	u16 wTxBufSize;
@@ -968,7 +967,7 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
 	u32 *pdwMIC_L, *pdwMIC_R;
 	int bSoftWEP = false;
 
-	pvRrvTime = pMICHDR = pvRTS = pvCTS = pvTxDataHd = NULL;
+	pvRrvTime = pMICHDR = pvTxDataHd = NULL;
 
 	if (bNeedEncryption && pTransmitKey->pvKeyTable) {
 		if (((PSKeyTable)pTransmitKey->pvKeyTable)->bSoftWEP == true)
@@ -1098,9 +1097,8 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
 					(pbyTxBufferAddr + wTxBufSize);
 		pMICHDR = (struct vnt_mic_hdr *)(pbyTxBufferAddr + wTxBufSize +
 					sizeof(struct vnt_rrv_time_rts));
-		pvRTS = (struct vnt_rts_g *) (pbyTxBufferAddr + wTxBufSize +
+		rts_cts = (struct vnt_rts_g *) (pbyTxBufferAddr + wTxBufSize +
 				sizeof(struct vnt_rrv_time_rts) + cbMICHDR);
-                pvCTS = NULL;
 		pvTxDataHd = (struct vnt_tx_datahead_g *) (pbyTxBufferAddr +
 			wTxBufSize + sizeof(struct vnt_rrv_time_rts) +
 				cbMICHDR + sizeof(struct vnt_rts_g));
@@ -1113,8 +1111,7 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
 				(pbyTxBufferAddr + wTxBufSize);
 		pMICHDR = (struct vnt_mic_hdr *) (pbyTxBufferAddr + wTxBufSize +
 			sizeof(struct vnt_rrv_time_cts));
-                pvRTS = NULL;
-		pvCTS = (struct vnt_cts *) (pbyTxBufferAddr + wTxBufSize +
+		rts_cts = (struct vnt_cts *) (pbyTxBufferAddr + wTxBufSize +
 				sizeof(struct vnt_rrv_time_cts) + cbMICHDR);
 		pvTxDataHd = (struct vnt_tx_datahead_g *)(pbyTxBufferAddr +
 			wTxBufSize + sizeof(struct vnt_rrv_time_cts) +
@@ -1130,9 +1127,8 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
 								wTxBufSize);
 		pMICHDR = (struct vnt_mic_hdr *) (pbyTxBufferAddr + wTxBufSize +
 					sizeof(struct vnt_rrv_time_rts));
-		pvRTS = (struct vnt_rts_g_fb *) (pbyTxBufferAddr + wTxBufSize +
+		rts_cts = (struct vnt_rts_g_fb *)(pbyTxBufferAddr + wTxBufSize +
 				sizeof(struct vnt_rrv_time_rts) + cbMICHDR);
-                pvCTS = NULL;
 		pvTxDataHd = (struct vnt_tx_datahead_g_fb *) (pbyTxBufferAddr +
 			wTxBufSize + sizeof(struct vnt_rrv_time_rts) +
 				cbMICHDR + sizeof(struct vnt_rts_g_fb));
@@ -1145,8 +1141,7 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
 				(pbyTxBufferAddr + wTxBufSize);
 		pMICHDR = (struct vnt_mic_hdr *) (pbyTxBufferAddr + wTxBufSize +
 				sizeof(struct vnt_rrv_time_cts));
-                pvRTS = NULL;
-		pvCTS = (struct vnt_cts_fb *) (pbyTxBufferAddr + wTxBufSize +
+		rts_cts = (struct vnt_cts_fb *) (pbyTxBufferAddr + wTxBufSize +
 			sizeof(struct vnt_rrv_time_cts) + cbMICHDR);
 		pvTxDataHd = (struct vnt_tx_datahead_g_fb *) (pbyTxBufferAddr +
 			wTxBufSize + sizeof(struct vnt_rrv_time_cts) +
@@ -1164,9 +1159,8 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
 								wTxBufSize);
 		pMICHDR = (struct vnt_mic_hdr *)(pbyTxBufferAddr + wTxBufSize +
 						sizeof(struct vnt_rrv_time_ab));
-		pvRTS = (struct vnt_rts_ab *) (pbyTxBufferAddr + wTxBufSize +
+		rts_cts = (struct vnt_rts_ab *) (pbyTxBufferAddr + wTxBufSize +
 				sizeof(struct vnt_rrv_time_ab) + cbMICHDR);
-                pvCTS = NULL;
 		pvTxDataHd = (struct vnt_tx_datahead_ab *)(pbyTxBufferAddr +
 			wTxBufSize + sizeof(struct vnt_rrv_time_ab) + cbMICHDR +
 						sizeof(struct vnt_rts_ab));
@@ -1179,8 +1173,6 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
 								wTxBufSize);
 		pMICHDR = (struct vnt_mic_hdr *) (pbyTxBufferAddr + wTxBufSize +
 						sizeof(struct vnt_rrv_time_ab));
-                pvRTS = NULL;
-                pvCTS = NULL;
 		pvTxDataHd = (struct vnt_tx_datahead_ab *)(pbyTxBufferAddr +
 			wTxBufSize + sizeof(struct vnt_rrv_time_ab) + cbMICHDR);
 		cbHeaderLength = wTxBufSize + sizeof(struct vnt_rrv_time_ab) +
@@ -1193,9 +1185,8 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
 						wTxBufSize);
 		pMICHDR = (struct vnt_mic_hdr *) (pbyTxBufferAddr + wTxBufSize +
 			sizeof(struct vnt_rrv_time_ab));
-		pvRTS = (struct vnt_rts_a_fb *) (pbyTxBufferAddr + wTxBufSize +
+		rts_cts = (struct vnt_rts_a_fb *)(pbyTxBufferAddr + wTxBufSize +
 				sizeof(struct vnt_rrv_time_ab) + cbMICHDR);
-                pvCTS = NULL;
 		pvTxDataHd = (struct vnt_tx_datahead_a_fb *)(pbyTxBufferAddr +
 			wTxBufSize + sizeof(struct vnt_rrv_time_ab) + cbMICHDR +
 					sizeof(struct vnt_rts_a_fb));
@@ -1208,8 +1199,6 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
 								wTxBufSize);
 		pMICHDR = (struct vnt_mic_hdr *)(pbyTxBufferAddr + wTxBufSize +
 						sizeof(struct vnt_rrv_time_ab));
-                pvRTS = NULL;
-                pvCTS = NULL;
 		pvTxDataHd = (struct vnt_tx_datahead_a_fb *)(pbyTxBufferAddr +
 			wTxBufSize + sizeof(struct vnt_rrv_time_ab) + cbMICHDR);
 		cbHeaderLength = wTxBufSize + sizeof(struct vnt_rrv_time_ab) +
@@ -1232,7 +1221,7 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
 
     //Fill FIFO,RrvTime,RTS,and CTS
     s_vGenerateTxParameter(pDevice, byPktType, wCurrentRate,
-			   (void *)pbyTxBufferAddr, pvRrvTime, pvRTS, pvCTS,
+		(void *)pbyTxBufferAddr, pvRrvTime, rts_cts,
 		cbFrameSize, bNeedACK, uDMAIdx, psEthHeader, bRTS);
     //Fill DataHead
     uDuration = s_uFillDataHead(pDevice, byPktType, wCurrentRate, pvTxDataHd, cbFrameSize, uDMAIdx, bNeedACK,
@@ -1467,10 +1456,10 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice,
 	PSTxBufHead pTxBufHead;
 	PUSB_SEND_CONTEXT pContext;
 	struct ieee80211_hdr *pMACHeader;
-	struct vnt_cts *pCTS;
 	struct ethhdr sEthHeader;
 	u8 byPktType, *pbyTxBufferAddr;
-	void *pvRTS, *pvTxDataHd, *pvRrvTime, *pMICHDR;
+	void *rts_cts = NULL;
+	void *pvTxDataHd, *pvRrvTime, *pMICHDR;
 	u32 uDuration, cbReqCount, cbHeaderSize, cbFrameBodySize, cbFrameSize;
 	int bNeedACK, bIsPSPOLL = false;
 	u32 cbIVlen = 0, cbICVlen = 0, cbMIClen = 0, cbFCSlen = 4;
@@ -1605,8 +1594,7 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice,
 
 	pvRrvTime = (struct vnt_rrv_time_cts *) (pbyTxBufferAddr + wTxBufSize);
         pMICHDR = NULL;
-        pvRTS = NULL;
-	pCTS = (struct vnt_cts *) (pbyTxBufferAddr + wTxBufSize +
+	rts_cts = (struct vnt_cts *) (pbyTxBufferAddr + wTxBufSize +
 					sizeof(struct vnt_rrv_time_cts));
 	pvTxDataHd = (struct vnt_tx_datahead_g *)(pbyTxBufferAddr + wTxBufSize +
 		sizeof(struct vnt_rrv_time_cts) + sizeof(struct vnt_cts));
@@ -1616,8 +1604,6 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice,
     else { // 802.11a/b packet
 	pvRrvTime = (struct vnt_rrv_time_ab *) (pbyTxBufferAddr + wTxBufSize);
         pMICHDR = NULL;
-        pvRTS = NULL;
-        pCTS = NULL;
 	pvTxDataHd = (struct vnt_tx_datahead_ab *) (pbyTxBufferAddr +
 		wTxBufSize + sizeof(struct vnt_rrv_time_ab));
 	cbHeaderSize = wTxBufSize + sizeof(struct vnt_rrv_time_ab) +
@@ -1635,8 +1621,9 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice,
     //=========================
     pTxBufHead->wFragCtl |= (u16)FRAGCTL_NONFRAG;
 
-    //Fill FIFO,RrvTime,RTS,and CTS
-    s_vGenerateTxParameter(pDevice, byPktType, wCurrentRate,  pbyTxBufferAddr, pvRrvTime, pvRTS, pCTS,
+	/* Fill FIFO,RrvTime,RTS,and CTS */
+	s_vGenerateTxParameter(pDevice, byPktType, wCurrentRate,
+		pbyTxBufferAddr, pvRrvTime, rts_cts,
 		cbFrameSize, bNeedACK, TYPE_TXDMA0, &sEthHeader, false);
 
     //Fill DataHead
@@ -1824,7 +1811,8 @@ void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb)
 	struct vnt_tx_buffer *pTX_Buffer;
 	u8 byPktType;
 	u8 *pbyTxBufferAddr;
-	void *pvRTS, *pvCTS, *pvTxDataHd;
+	void *rts_cts = NULL;
+	void *pvTxDataHd;
 	u32 uDuration, cbReqCount;
 	struct ieee80211_hdr *pMACHeader;
 	u32 cbHeaderSize, cbFrameBodySize;
@@ -1851,7 +1839,7 @@ void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb)
 	u32 cbExtSuppRate = 0;
 	PUSB_SEND_CONTEXT pContext;
 
-    pvRrvTime = pMICHDR = pvRTS = pvCTS = pvTxDataHd = NULL;
+	pvRrvTime = pMICHDR = pvTxDataHd = NULL;
 
     if(skb->len <= WLAN_HDR_ADDR3_LEN) {
        cbFrameBodySize = 0;
@@ -2013,8 +2001,7 @@ void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb)
 	pvRrvTime = (struct vnt_rrv_time_cts *) (pbyTxBufferAddr + wTxBufSize);
 	pMICHDR = (struct vnt_mic_hdr *) (pbyTxBufferAddr + wTxBufSize +
 					sizeof(struct vnt_rrv_time_cts));
-        pvRTS = NULL;
-	pvCTS = (struct vnt_cts *) (pbyTxBufferAddr + wTxBufSize +
+	rts_cts = (struct vnt_cts *) (pbyTxBufferAddr + wTxBufSize +
 			sizeof(struct vnt_rrv_time_cts) + cbMICHDR);
 	pvTxDataHd = (struct vnt_tx_datahead_g *) (pbyTxBufferAddr +
 		wTxBufSize + sizeof(struct vnt_rrv_time_cts) + cbMICHDR +
@@ -2028,8 +2015,6 @@ void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb)
 	pvRrvTime = (struct vnt_rrv_time_ab *) (pbyTxBufferAddr + wTxBufSize);
 	pMICHDR = (struct vnt_mic_hdr *) (pbyTxBufferAddr + wTxBufSize +
 		sizeof(struct vnt_rrv_time_ab));
-        pvRTS = NULL;
-        pvCTS = NULL;
 	pvTxDataHd = (struct vnt_tx_datahead_ab *)(pbyTxBufferAddr +
 		wTxBufSize + sizeof(struct vnt_rrv_time_ab) + cbMICHDR);
 	cbHeaderSize = wTxBufSize + sizeof(struct vnt_rrv_time_ab) + cbMICHDR +
@@ -2046,8 +2031,9 @@ void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb)
     //=========================
     pTxBufHead->wFragCtl |= (u16)FRAGCTL_NONFRAG;
 
-    //Fill FIFO,RrvTime,RTS,and CTS
-    s_vGenerateTxParameter(pDevice, byPktType, wCurrentRate, pbyTxBufferAddr, pvRrvTime, pvRTS, pvCTS,
+	/* Fill FIFO,RrvTime,RTS,and CTS */
+	s_vGenerateTxParameter(pDevice, byPktType, wCurrentRate,
+		pbyTxBufferAddr, pvRrvTime, rts_cts,
 		cbFrameSize, bNeedACK, TYPE_TXDMA0, &sEthHeader, false);
 
     //Fill DataHead
-- 
1.8.1.2

