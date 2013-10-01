Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:57013 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561Ab3JAOwZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Oct 2013 10:52:25 -0400
Received: by mail-wi0-f180.google.com with SMTP id hj3so5708974wib.13
        for <linux-wireless@vger.kernel.org>; Tue, 01 Oct 2013 07:52:23 -0700 (PDT)
Message-ID: <1380639136.2087.2.camel@canaries64-MCP7A> (sfid-20131001_165228_724157_BFEE0C29)
Subject: [PATCH 2/8] staging: vt6656: rxtx.c Parse struct vnt_tx_datahead_g
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Tue, 01 Oct 2013 15:52:16 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Parse struct vnt_tx_datahead_g from s_uFillDataHead and
move to struct vnt_rts_g/struct vnt_cts structure.

This removes pvTxDataHd pointer assignment.

The duration_id(uDuration) field is now returned in s_vGenerateTxParameter.

The return of s_uFillDataHead temporary or'ed to retain functionality of
other functions and is removed at the end of this patch series.

Since pvTxDataHd is now null a small vendor hack to vDMA0_tx_80211/csMgmt_xmit
to do with Disassociation-packet is also changed correct head position.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 107 ++++++++++++++++++++----------------------
 drivers/staging/vt6656/rxtx.h |   2 +
 2 files changed, 54 insertions(+), 55 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index ff40255..58a9d8a 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -509,6 +509,25 @@ static u16 s_uGetRTSCTSDuration(struct vnt_private *pDevice, u8 byDurType,
 	return cpu_to_le16((u16)uDurTime);
 }
 
+static u16 vnt_rxtx_datahead_g(struct vnt_private *priv, u8 pkt_type, u16 rate,
+		struct vnt_tx_datahead_g *buf, u32 frame_len, int need_ack)
+{
+	/* Get SignalField,ServiceField,Length */
+	BBvCalculateParameter(priv, frame_len, rate, pkt_type, &buf->a);
+	BBvCalculateParameter(priv, frame_len, priv->byTopCCKBasicRate,
+							PK_TYPE_11B, &buf->b);
+
+	/* Get Duration and TimeStamp */
+	buf->wDuration_a = s_uGetDataDuration(priv, pkt_type, need_ack);
+	buf->wDuration_b = s_uGetDataDuration(priv, PK_TYPE_11B, need_ack);
+
+	buf->wTimeStampOff_a = vnt_time_stamp_off(priv, rate);
+	buf->wTimeStampOff_b = vnt_time_stamp_off(priv,
+					priv->byTopCCKBasicRate);
+
+	return buf->wDuration_a;
+}
+
 static u32 s_uFillDataHead(struct vnt_private *pDevice,
 	u8 byPktType, u16 wCurrentRate, void *pTxDataHead, u32 cbFrameLength,
 	u32 uDMAIdx, int bNeedAck, u8 byFBOption)
@@ -520,24 +539,7 @@ static u32 s_uFillDataHead(struct vnt_private *pDevice,
 
     if (byPktType == PK_TYPE_11GB || byPktType == PK_TYPE_11GA) {
             if (byFBOption == AUTO_FB_NONE) {
-		struct vnt_tx_datahead_g *pBuf =
-				(struct vnt_tx_datahead_g *)pTxDataHead;
-                //Get SignalField,ServiceField,Length
-		BBvCalculateParameter(pDevice, cbFrameLength, wCurrentRate,
-			byPktType, &pBuf->a);
-		BBvCalculateParameter(pDevice, cbFrameLength,
-			pDevice->byTopCCKBasicRate, PK_TYPE_11B, &pBuf->b);
-                //Get Duration and TimeStamp
-		pBuf->wDuration_a = s_uGetDataDuration(pDevice,
-							byPktType, bNeedAck);
-		pBuf->wDuration_b = s_uGetDataDuration(pDevice,
-							PK_TYPE_11B, bNeedAck);
-
-		pBuf->wTimeStampOff_a =	vnt_time_stamp_off(pDevice,
-								wCurrentRate);
-		pBuf->wTimeStampOff_b = vnt_time_stamp_off(pDevice,
-						pDevice->byTopCCKBasicRate);
-                return (pBuf->wDuration_a);
+		;
              } else {
                 // Auto Fallback
 		struct vnt_tx_datahead_g_fb *pBuf =
@@ -651,7 +653,8 @@ static u16 vnt_rxtx_rts_g_head(struct vnt_private *priv,
 
 	vnt_fill_ieee80211_rts(priv, &buf->data, eth_hdr, buf->wDuration_aa);
 
-	return 0;
+	return vnt_rxtx_datahead_g(priv, pkt_type, current_rate,
+			&buf->data_head, frame_len, need_ack);
 }
 
 static u16 vnt_rxtx_rts_g_fb_head(struct vnt_private *priv,
@@ -748,7 +751,7 @@ static u16 s_vFillRTSHead(struct vnt_private *pDevice, u8 byPktType,
 	case PK_TYPE_11GB:
 	case PK_TYPE_11GA:
 		if (byFBOption == AUTO_FB_NONE)
-			vnt_rxtx_rts_g_head(pDevice, &head->rts_g,
+			return vnt_rxtx_rts_g_head(pDevice, &head->rts_g,
 				psEthHeader, byPktType, cbFrameLength,
 				bNeedAck, wCurrentRate, byFBOption);
 		else
@@ -815,6 +818,9 @@ static u16 s_vFillCTSHead(struct vnt_private *pDevice, u32 uDMAIdx,
 		pBuf->data.duration = pBuf->wDuration_ba;
 		pBuf->data.frame_control = TYPE_CTL_CTS;
 		memcpy(pBuf->data.ra, pDevice->abyCurrentNetAddr, ETH_ALEN);
+
+		return vnt_rxtx_datahead_g(pDevice, byPktType, wCurrentRate,
+				&pBuf->data_head, cbFrameLength, bNeedAck);
         }
 
 	return 0;
@@ -896,7 +902,7 @@ static u16 s_vGenerateTxParameter(struct vnt_private *pDevice,
 		}
 
 		/* Fill RTS */
-		s_vFillRTSHead(pDevice, byPktType, head, cbFrameSize,
+		return s_vFillRTSHead(pDevice, byPktType, head, cbFrameSize,
 			bNeedACK, psEthHeader, wCurrentRate, byFBOption);
         }
         else {//RTS_needless, PCF mode
@@ -919,7 +925,7 @@ static u16 s_vGenerateTxParameter(struct vnt_private *pDevice,
 		}
 
 		/* Fill CTS */
-		s_vFillCTSHead(pDevice, uDMAIdx, byPktType, head,
+		return s_vFillCTSHead(pDevice, uDMAIdx, byPktType, head,
 			cbFrameSize, bNeedACK, wCurrentRate, byFBOption);
         }
     }
@@ -1151,20 +1157,12 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
     if (byPktType == PK_TYPE_11GB || byPktType == PK_TYPE_11GA) {//802.11g packet
         if (byFBOption == AUTO_FB_NONE) {
             if (bRTS == true) {//RTS_need
-		pvTxDataHd = (struct vnt_tx_datahead_g *) (pbyTxBufferAddr +
-			wTxBufSize + sizeof(struct vnt_rrv_time_rts) +
-				cbMICHDR + sizeof(struct vnt_rts_g));
 		cbHeaderLength = wTxBufSize + sizeof(struct vnt_rrv_time_rts) +
-			cbMICHDR + sizeof(struct vnt_rts_g) +
-				sizeof(struct vnt_tx_datahead_g);
+			cbMICHDR + sizeof(struct vnt_rts_g);
             }
             else { //RTS_needless
-		pvTxDataHd = (struct vnt_tx_datahead_g *)(pbyTxBufferAddr +
-			wTxBufSize + sizeof(struct vnt_rrv_time_cts) +
-				cbMICHDR + sizeof(struct vnt_cts));
 		cbHeaderLength = wTxBufSize + sizeof(struct vnt_rrv_time_cts) +
-			cbMICHDR + sizeof(struct vnt_cts) +
-				sizeof(struct vnt_tx_datahead_g);
+			cbMICHDR + sizeof(struct vnt_cts);
             }
         } else {
             // Auto Fall Back
@@ -1233,13 +1231,13 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
     //uDMAIdx = TYPE_AC0DMA;
     //pTxBufHead = (PSTxBufHead) &(pTxBufHead->adwTxKey[0]);
 
-    //Fill FIFO,RrvTime,RTS,and CTS
-    s_vGenerateTxParameter(pDevice, byPktType, wCurrentRate,
-		tx_buffer, &pMICHDR, cbMICHDR,
-		cbFrameSize, bNeedACK, uDMAIdx, psEthHeader, bRTS);
+	/* Fill FIFO, RrvTime, RTS and CTS */
+	uDuration = s_vGenerateTxParameter(pDevice, byPktType, wCurrentRate,
+			tx_buffer, &pMICHDR, cbMICHDR,
+			cbFrameSize, bNeedACK, uDMAIdx, psEthHeader, bRTS);
     //Fill DataHead
-    uDuration = s_uFillDataHead(pDevice, byPktType, wCurrentRate, pvTxDataHd, cbFrameSize, uDMAIdx, bNeedACK,
-				byFBOption);
+    uDuration |= s_uFillDataHead(pDevice, byPktType, wCurrentRate, pvTxDataHd,
+		cbFrameSize, uDMAIdx, bNeedACK,	byFBOption);
     // Generate TX MAC Header
     s_vGenerateMACHeader(pDevice, pbyMacHdr, (u16)uDuration, psEthHeader, bNeedEncryption,
                            byFragType, uDMAIdx, 0);
@@ -1605,10 +1603,8 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice,
 
     //Set RrvTime/RTS/CTS Buffer
     if (byPktType == PK_TYPE_11GB || byPktType == PK_TYPE_11GA) {//802.11g packet
-	pvTxDataHd = (struct vnt_tx_datahead_g *)(pbyTxBufferAddr + wTxBufSize +
-		sizeof(struct vnt_rrv_time_cts) + sizeof(struct vnt_cts));
 	cbHeaderSize = wTxBufSize + sizeof(struct vnt_rrv_time_cts) +
-		sizeof(struct vnt_cts) + sizeof(struct vnt_tx_datahead_g);
+		sizeof(struct vnt_cts);
     }
     else { // 802.11a/b packet
 	pvTxDataHd = (struct vnt_tx_datahead_ab *) (pbyTxBufferAddr +
@@ -1629,13 +1625,13 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice,
     pTxBufHead->wFragCtl |= (u16)FRAGCTL_NONFRAG;
 
 	/* Fill FIFO,RrvTime,RTS,and CTS */
-	s_vGenerateTxParameter(pDevice, byPktType, wCurrentRate,
+	uDuration = s_vGenerateTxParameter(pDevice, byPktType, wCurrentRate,
 		pTX_Buffer, &pMICHDR, 0,
 		cbFrameSize, bNeedACK, TYPE_TXDMA0, &sEthHeader, false);
 
     //Fill DataHead
-    uDuration = s_uFillDataHead(pDevice, byPktType, wCurrentRate, pvTxDataHd, cbFrameSize, TYPE_TXDMA0, bNeedACK,
-				AUTO_FB_NONE);
+    uDuration |= s_uFillDataHead(pDevice, byPktType, wCurrentRate, pvTxDataHd,
+		cbFrameSize, TYPE_TXDMA0, bNeedACK, AUTO_FB_NONE);
 
     pMACHeader = (struct ieee80211_hdr *) (pbyTxBufferAddr + cbHeaderSize);
 
@@ -1699,9 +1695,11 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice,
         // in the same place of other packet's Duration-field).
         // And it will cause Cisco-AP to issue Disassociation-packet
 	if (byPktType == PK_TYPE_11GB || byPktType == PK_TYPE_11GA) {
-		((struct vnt_tx_datahead_g *)pvTxDataHd)->wDuration_a =
+		struct vnt_tx_datahead_g *data_head = &pTX_Buffer->tx_head.
+						tx_cts.tx.head.cts_g.data_head;
+		data_head->wDuration_a =
 			cpu_to_le16(pPacket->p80211Header->sA2.wDurationID);
-		((struct vnt_tx_datahead_g *)pvTxDataHd)->wDuration_b =
+		data_head->wDuration_b =
 			cpu_to_le16(pPacket->p80211Header->sA2.wDurationID);
 	} else {
 		((struct vnt_tx_datahead_ab *)pvTxDataHd)->wDuration =
@@ -2008,11 +2006,8 @@ void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb)
     //the rest of pTxBufHead->wFragCtl:FragTyp will be set later in s_vFillFragParameter()
 
     if (byPktType == PK_TYPE_11GB || byPktType == PK_TYPE_11GA) {//802.11g packet
-	pvTxDataHd = (struct vnt_tx_datahead_g *) (pbyTxBufferAddr +
-		wTxBufSize + sizeof(struct vnt_rrv_time_cts) + cbMICHDR +
-					sizeof(struct vnt_cts));
 	cbHeaderSize = wTxBufSize + sizeof(struct vnt_rrv_time_cts) + cbMICHDR +
-		sizeof(struct vnt_cts) + sizeof(struct vnt_tx_datahead_g);
+		sizeof(struct vnt_cts);
 
     }
     else {//802.11a/b packet
@@ -2033,13 +2028,13 @@ void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb)
     pTxBufHead->wFragCtl |= (u16)FRAGCTL_NONFRAG;
 
 	/* Fill FIFO,RrvTime,RTS,and CTS */
-	s_vGenerateTxParameter(pDevice, byPktType, wCurrentRate,
+	uDuration = s_vGenerateTxParameter(pDevice, byPktType, wCurrentRate,
 		pTX_Buffer, &pMICHDR, cbMICHDR,
 		cbFrameSize, bNeedACK, TYPE_TXDMA0, &sEthHeader, false);
 
     //Fill DataHead
-    uDuration = s_uFillDataHead(pDevice, byPktType, wCurrentRate, pvTxDataHd, cbFrameSize, TYPE_TXDMA0, bNeedACK,
-				AUTO_FB_NONE);
+    uDuration |= s_uFillDataHead(pDevice, byPktType, wCurrentRate, pvTxDataHd,
+		cbFrameSize, TYPE_TXDMA0, bNeedACK, AUTO_FB_NONE);
 
     pMACHeader = (struct ieee80211_hdr *) (pbyTxBufferAddr + cbHeaderSize);
 
@@ -2149,9 +2144,11 @@ void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb)
         // in the same place of other packet's Duration-field).
         // And it will cause Cisco-AP to issue Disassociation-packet
 	if (byPktType == PK_TYPE_11GB || byPktType == PK_TYPE_11GA) {
-		((struct vnt_tx_datahead_g *)pvTxDataHd)->wDuration_a =
+		struct vnt_tx_datahead_g *data_head = &pTX_Buffer->tx_head.
+						tx_cts.tx.head.cts_g.data_head;
+		data_head->wDuration_a =
 			cpu_to_le16(p80211Header->sA2.wDurationID);
-		((struct vnt_tx_datahead_g *)pvTxDataHd)->wDuration_b =
+		data_head->wDuration_b =
 			cpu_to_le16(p80211Header->sA2.wDurationID);
 	} else {
 		((struct vnt_tx_datahead_ab *)pvTxDataHd)->wDuration =
diff --git a/drivers/staging/vt6656/rxtx.h b/drivers/staging/vt6656/rxtx.h
index bbda9a3..ea20e94 100644
--- a/drivers/staging/vt6656/rxtx.h
+++ b/drivers/staging/vt6656/rxtx.h
@@ -117,6 +117,7 @@ struct vnt_rts_g {
 	u16 wDuration_bb;
 	u16 wReserved;
 	struct ieee80211_rts data;
+	struct vnt_tx_datahead_g data_head;
 } __packed;
 
 struct vnt_rts_g_fb {
@@ -156,6 +157,7 @@ struct vnt_cts {
 	u16 wReserved;
 	struct ieee80211_cts data;
 	u16 reserved2;
+	struct vnt_tx_datahead_g data_head;
 } __packed;
 
 struct vnt_cts_fb {
-- 
1.8.3.2

