Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:55896 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbaH3V0h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Aug 2014 17:26:37 -0400
Received: by mail-wi0-f169.google.com with SMTP id n3so830188wiv.2
        for <linux-wireless@vger.kernel.org>; Sat, 30 Aug 2014 14:26:35 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 08/23] staging: vt6655: replace typedef struct tagSTxDataHead_g with struct vnt_tx_datahead_g
Date: Sat, 30 Aug 2014 22:25:34 +0100
Message-Id: <1409433949-5468-8-git-send-email-tvboxspy@gmail.com> (sfid-20140830_232644_460439_66EE63AC)
In-Reply-To: <1409433949-5468-1-git-send-email-tvboxspy@gmail.com>
References: <1409433949-5468-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace members
b, a, wDuration_b, wDuration_a, wTimeStampOff_b and wTimeStampOff_a
with
b, a, duration_b, duration_a, time_stamp_off_b and time_stamp_off_a

Using __le16 endian type for unsigned short.

Creating the new structure in rxtx.h

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/desc.h | 11 --------
 drivers/staging/vt6655/rxtx.c | 62 ++++++++++++++++++++++---------------------
 drivers/staging/vt6655/rxtx.h | 10 +++++++
 3 files changed, 42 insertions(+), 41 deletions(-)

diff --git a/drivers/staging/vt6655/desc.h b/drivers/staging/vt6655/desc.h
index 84de4ef..27b6fd7 100644
--- a/drivers/staging/vt6655/desc.h
+++ b/drivers/staging/vt6655/desc.h
@@ -459,17 +459,6 @@ typedef const STxBufHead *PCSTxBufHead;
 //
 // Tx data header
 //
-typedef struct tagSTxDataHead_g {
-	struct vnt_phy_field b;
-	struct vnt_phy_field a;
-	unsigned short wDuration_b;
-	unsigned short wDuration_a;
-	unsigned short wTimeStampOff_b;
-	unsigned short wTimeStampOff_a;
-} __attribute__ ((__packed__))
-STxDataHead_g, *PSTxDataHead_g;
-typedef const STxDataHead_g *PCSTxDataHead_g;
-
 typedef struct tagSTxDataHead_g_FB {
 	struct vnt_phy_field b;
 	struct vnt_phy_field a;
diff --git a/drivers/staging/vt6655/rxtx.c b/drivers/staging/vt6655/rxtx.c
index 9617701..97b84df 100644
--- a/drivers/staging/vt6655/rxtx.c
+++ b/drivers/staging/vt6655/rxtx.c
@@ -693,29 +693,29 @@ s_uFillDataHead(
 
 	if (byPktType == PK_TYPE_11GB || byPktType == PK_TYPE_11GA) {
 		if (byFBOption == AUTO_FB_NONE) {
-			PSTxDataHead_g pBuf = (PSTxDataHead_g)pTxDataHead;
+			struct vnt_tx_datahead_g *buf = pTxDataHead;
 			/* Get SignalField, ServiceField & Length */
 			vnt_get_phy_field(pDevice, cbFrameLength, wCurrentRate,
-					  byPktType, &pBuf->a);
+					  byPktType, &buf->a);
 
 			vnt_get_phy_field(pDevice, cbFrameLength,
 					  pDevice->byTopCCKBasicRate,
-					  PK_TYPE_11B, &pBuf->b);
-
-			//Get Duration and TimeStamp
-			pBuf->wDuration_a = cpu_to_le16((unsigned short)s_uGetDataDuration(pDevice, DATADUR_A, cbFrameLength,
-											   byPktType, wCurrentRate, bNeedAck, uFragIdx,
-											   cbLastFragmentSize, uMACfragNum,
-											   byFBOption)); //1: 2.4GHz
-			pBuf->wDuration_b = cpu_to_le16((unsigned short)s_uGetDataDuration(pDevice, DATADUR_B, cbFrameLength,
-											   PK_TYPE_11B, pDevice->byTopCCKBasicRate,
-											   bNeedAck, uFragIdx, cbLastFragmentSize,
-											   uMACfragNum, byFBOption)); //1: 2.4
-
-			pBuf->wTimeStampOff_a = vnt_time_stamp_off(pDevice, wCurrentRate);
-			pBuf->wTimeStampOff_b = vnt_time_stamp_off(pDevice, pDevice->byTopCCKBasicRate);
-
-			return pBuf->wDuration_a;
+					  PK_TYPE_11B, &buf->b);
+
+			/* Get Duration and TimeStamp */
+			buf->duration_a = cpu_to_le16((u16)s_uGetDataDuration(pDevice, DATADUR_A, cbFrameLength,
+									      byPktType, wCurrentRate, bNeedAck, uFragIdx,
+									      cbLastFragmentSize, uMACfragNum,
+									      byFBOption));
+			buf->duration_b = cpu_to_le16((u16)s_uGetDataDuration(pDevice, DATADUR_B, cbFrameLength,
+									      PK_TYPE_11B, pDevice->byTopCCKBasicRate,
+									      bNeedAck, uFragIdx, cbLastFragmentSize,
+									      uMACfragNum, byFBOption));
+
+			buf->time_stamp_off_a = vnt_time_stamp_off(pDevice, wCurrentRate);
+			buf->time_stamp_off_b = vnt_time_stamp_off(pDevice, pDevice->byTopCCKBasicRate);
+
+			return buf->duration_a;
 		} else {
 			// Auto Fallback
 			PSTxDataHead_g_FB pBuf = (PSTxDataHead_g_FB)pTxDataHead;
@@ -1316,15 +1316,17 @@ s_cbFillTxBufHead(struct vnt_private *pDevice, unsigned char byPktType,
 				pMICHDR = (struct vnt_mic_hdr *)(pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_rts));
 				pvRTS = (PSRTS_g)(pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_rts) + cbMICHDR);
 				pvCTS = NULL;
-				pvTxDataHd = (PSTxDataHead_g)(pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_rts) + cbMICHDR + sizeof(SRTS_g));
-				cbHeaderLength = wTxBufSize + sizeof(struct vnt_rrv_time_rts) + cbMICHDR + sizeof(SRTS_g) + sizeof(STxDataHead_g);
+				pvTxDataHd = (void *)(pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_rts) + cbMICHDR + sizeof(SRTS_g));
+				cbHeaderLength = wTxBufSize + sizeof(struct vnt_rrv_time_rts) +
+							cbMICHDR + sizeof(SRTS_g) + sizeof(struct vnt_tx_datahead_g);
 			} else { //RTS_needless
 				pvRrvTime = (void *)(pbyTxBufferAddr + wTxBufSize);
 				pMICHDR = (struct vnt_mic_hdr *) (pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_cts));
 				pvRTS = NULL;
 				pvCTS = (PSCTS) (pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_cts) + cbMICHDR);
-				pvTxDataHd = (PSTxDataHead_g) (pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_cts) + cbMICHDR + sizeof(SCTS));
-				cbHeaderLength = wTxBufSize + sizeof(struct vnt_rrv_time_cts) + cbMICHDR + sizeof(SCTS) + sizeof(STxDataHead_g);
+				pvTxDataHd = (void *)(pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_cts) + cbMICHDR + sizeof(SCTS));
+				cbHeaderLength = wTxBufSize + sizeof(struct vnt_rrv_time_cts) +
+							cbMICHDR + sizeof(SCTS) + sizeof(struct vnt_tx_datahead_g);
 			}
 		} else {
 			// Auto Fall Back
@@ -2188,10 +2190,10 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice, PSTxMgmtPacket pPacket)
 		pvRTS = NULL;
 		pCTS = (PSCTS) (pbyTxBufferAddr + wTxBufSize +
 					sizeof(struct vnt_rrv_time_cts));
-		pvTxDataHd = (PSTxDataHead_g) (pbyTxBufferAddr + wTxBufSize +
+		pvTxDataHd = (void *)(pbyTxBufferAddr + wTxBufSize +
 				sizeof(struct vnt_rrv_time_cts) + sizeof(SCTS));
 		cbHeaderSize = wTxBufSize + sizeof(struct vnt_rrv_time_cts) +
-					sizeof(SCTS) + sizeof(STxDataHead_g);
+					sizeof(SCTS) + sizeof(struct vnt_tx_datahead_g);
 	} else { // 802.11a/b packet
 		pvRrvTime = (void *)(pbyTxBufferAddr + wTxBufSize);
 		pMICHDR = NULL;
@@ -2290,8 +2292,8 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice, PSTxMgmtPacket pPacket)
 		// in the same place of other packet's Duration-field).
 		// And it will cause Cisco-AP to issue Disassociation-packet
 		if (byPktType == PK_TYPE_11GB || byPktType == PK_TYPE_11GA) {
-			((PSTxDataHead_g)pvTxDataHd)->wDuration_a = cpu_to_le16(pPacket->p80211Header->sA2.wDurationID);
-			((PSTxDataHead_g)pvTxDataHd)->wDuration_b = cpu_to_le16(pPacket->p80211Header->sA2.wDurationID);
+			((struct vnt_tx_datahead_g *)pvTxDataHd)->duration_a = cpu_to_le16(pPacket->p80211Header->sA2.wDurationID);
+			((struct vnt_tx_datahead_g *)pvTxDataHd)->duration_b = cpu_to_le16(pPacket->p80211Header->sA2.wDurationID);
 		} else {
 			((PSTxDataHead_ab)pvTxDataHd)->wDuration = cpu_to_le16(pPacket->p80211Header->sA2.wDurationID);
 		}
@@ -2676,10 +2678,10 @@ void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb,
 		pvRTS = NULL;
 		pvCTS = (PSCTS) (pbyTxBufferAddr + wTxBufSize +
 				sizeof(struct vnt_rrv_time_cts) + cbMICHDR);
-		pvTxDataHd = (PSTxDataHead_g) (pbyTxBufferAddr + wTxBufSize +
+		pvTxDataHd = (void *)(pbyTxBufferAddr + wTxBufSize +
 			sizeof(struct vnt_rrv_time_cts) + cbMICHDR + sizeof(SCTS));
 		cbHeaderSize = wTxBufSize + sizeof(struct vnt_rrv_time_cts) +
-				cbMICHDR + sizeof(SCTS) + sizeof(STxDataHead_g);
+				cbMICHDR + sizeof(SCTS) + sizeof(struct vnt_tx_datahead_g);
 
 	} else {//802.11a/b packet
 
@@ -2816,8 +2818,8 @@ void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb,
 		// in the same place of other packet's Duration-field).
 		// And it will cause Cisco-AP to issue Disassociation-packet
 		if (byPktType == PK_TYPE_11GB || byPktType == PK_TYPE_11GA) {
-			((PSTxDataHead_g)pvTxDataHd)->wDuration_a = cpu_to_le16(p80211Header->sA2.wDurationID);
-			((PSTxDataHead_g)pvTxDataHd)->wDuration_b = cpu_to_le16(p80211Header->sA2.wDurationID);
+			((struct vnt_tx_datahead_g *)pvTxDataHd)->duration_a = cpu_to_le16(p80211Header->sA2.wDurationID);
+			((struct vnt_tx_datahead_g *)pvTxDataHd)->duration_b = cpu_to_le16(p80211Header->sA2.wDurationID);
 		} else {
 			((PSTxDataHead_ab)pvTxDataHd)->wDuration = cpu_to_le16(p80211Header->sA2.wDurationID);
 		}
diff --git a/drivers/staging/vt6655/rxtx.h b/drivers/staging/vt6655/rxtx.h
index a14b5f1..0fe9998 100644
--- a/drivers/staging/vt6655/rxtx.h
+++ b/drivers/staging/vt6655/rxtx.h
@@ -78,6 +78,16 @@ struct vnt_rrv_time_ab {
 	__le16 rrv_time;
 } __packed;
 
+/* TX data header */
+struct vnt_tx_datahead_g {
+	struct vnt_phy_field b;
+	struct vnt_phy_field a;
+	__le16 duration_b;
+	__le16 duration_a;
+	__le16 time_stamp_off_b;
+	__le16 time_stamp_off_a;
+} __packed;
+
 struct vnt_tx_short_buf_head {
 	__le16 fifo_ctl;
 	u16 time_stamp;
-- 
1.9.1

