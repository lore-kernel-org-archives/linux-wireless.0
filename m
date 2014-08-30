Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:50023 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272AbaH3V0i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Aug 2014 17:26:38 -0400
Received: by mail-we0-f177.google.com with SMTP id u56so3654781wes.8
        for <linux-wireless@vger.kernel.org>; Sat, 30 Aug 2014 14:26:37 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 09/23] staging: vt6655: replace typedef struct tagSTxDataHead_g_FB with struct vnt_tx_datahead_g_fb
Date: Sat, 30 Aug 2014 22:25:35 +0100
Message-Id: <1409433949-5468-9-git-send-email-tvboxspy@gmail.com> (sfid-20140830_232647_018316_94E3CAF0)
In-Reply-To: <1409433949-5468-1-git-send-email-tvboxspy@gmail.com>
References: <1409433949-5468-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replacing members
b, a, wDuration_b, wDuration_a, wDuration_a_f0, wDuration_a_f1, wTimeStampOff_b and wTimeStampOff_a
with
b, a, duration_b, duration_a, duration_a_f0, duration_a_f1, time_stamp_off_b and time_stamp_off_a

All unsigned short need to be __le16 type.

Creating the new structure in rxtx.h

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/desc.h | 13 ------------
 drivers/staging/vt6655/rxtx.c | 46 ++++++++++++++++++++++---------------------
 drivers/staging/vt6655/rxtx.h | 11 +++++++++++
 3 files changed, 35 insertions(+), 35 deletions(-)

diff --git a/drivers/staging/vt6655/desc.h b/drivers/staging/vt6655/desc.h
index 27b6fd7..0945c07 100644
--- a/drivers/staging/vt6655/desc.h
+++ b/drivers/staging/vt6655/desc.h
@@ -459,19 +459,6 @@ typedef const STxBufHead *PCSTxBufHead;
 //
 // Tx data header
 //
-typedef struct tagSTxDataHead_g_FB {
-	struct vnt_phy_field b;
-	struct vnt_phy_field a;
-	unsigned short wDuration_b;
-	unsigned short wDuration_a;
-	unsigned short wDuration_a_f0;
-	unsigned short wDuration_a_f1;
-	unsigned short wTimeStampOff_b;
-	unsigned short wTimeStampOff_a;
-} __attribute__ ((__packed__))
-STxDataHead_g_FB, *PSTxDataHead_g_FB;
-typedef const STxDataHead_g_FB *PCSTxDataHead_g_FB;
-
 typedef struct tagSTxDataHead_ab {
 	struct vnt_phy_field ab;
 	unsigned short wDuration;
diff --git a/drivers/staging/vt6655/rxtx.c b/drivers/staging/vt6655/rxtx.c
index 97b84df..d8e3347 100644
--- a/drivers/staging/vt6655/rxtx.c
+++ b/drivers/staging/vt6655/rxtx.c
@@ -717,29 +717,29 @@ s_uFillDataHead(
 
 			return buf->duration_a;
 		} else {
-			// Auto Fallback
-			PSTxDataHead_g_FB pBuf = (PSTxDataHead_g_FB)pTxDataHead;
+			/* Auto Fallback */
+			struct vnt_tx_datahead_g_fb *buf = pTxDataHead;
 			/* Get SignalField, ServiceField & Length */
 			vnt_get_phy_field(pDevice, cbFrameLength, wCurrentRate,
-					  byPktType, &pBuf->a);
+					  byPktType, &buf->a);
 
 			vnt_get_phy_field(pDevice, cbFrameLength,
 					  pDevice->byTopCCKBasicRate,
-					  PK_TYPE_11B, &pBuf->b);
-			//Get Duration and TimeStamp
-			pBuf->wDuration_a = cpu_to_le16((unsigned short)s_uGetDataDuration(pDevice, DATADUR_A, cbFrameLength, byPktType,
-											   wCurrentRate, bNeedAck, uFragIdx, cbLastFragmentSize, uMACfragNum, byFBOption)); //1: 2.4GHz
-			pBuf->wDuration_b = cpu_to_le16((unsigned short)s_uGetDataDuration(pDevice, DATADUR_B, cbFrameLength, PK_TYPE_11B,
-											   pDevice->byTopCCKBasicRate, bNeedAck, uFragIdx, cbLastFragmentSize, uMACfragNum, byFBOption)); //1: 2.4GHz
-			pBuf->wDuration_a_f0 = cpu_to_le16((unsigned short)s_uGetDataDuration(pDevice, DATADUR_A_F0, cbFrameLength, byPktType,
-											      wCurrentRate, bNeedAck, uFragIdx, cbLastFragmentSize, uMACfragNum, byFBOption)); //1: 2.4GHz
-			pBuf->wDuration_a_f1 = cpu_to_le16((unsigned short)s_uGetDataDuration(pDevice, DATADUR_A_F1, cbFrameLength, byPktType,
-											      wCurrentRate, bNeedAck, uFragIdx, cbLastFragmentSize, uMACfragNum, byFBOption)); //1: 2.4GHz
-
-			pBuf->wTimeStampOff_a = vnt_time_stamp_off(pDevice, wCurrentRate);
-			pBuf->wTimeStampOff_b = vnt_time_stamp_off(pDevice, pDevice->byTopCCKBasicRate);
-
-			return pBuf->wDuration_a;
+					  PK_TYPE_11B, &buf->b);
+			/* Get Duration and TimeStamp */
+			buf->duration_a = cpu_to_le16((u16)s_uGetDataDuration(pDevice, DATADUR_A, cbFrameLength, byPktType,
+									      wCurrentRate, bNeedAck, uFragIdx, cbLastFragmentSize, uMACfragNum, byFBOption));
+			buf->duration_b = cpu_to_le16((u16)s_uGetDataDuration(pDevice, DATADUR_B, cbFrameLength, PK_TYPE_11B,
+									       pDevice->byTopCCKBasicRate, bNeedAck, uFragIdx, cbLastFragmentSize, uMACfragNum, byFBOption));
+			buf->duration_a_f0 = cpu_to_le16((u16)s_uGetDataDuration(pDevice, DATADUR_A_F0, cbFrameLength, byPktType,
+										  wCurrentRate, bNeedAck, uFragIdx, cbLastFragmentSize, uMACfragNum, byFBOption));
+			buf->duration_a_f1 = cpu_to_le16((u16)s_uGetDataDuration(pDevice, DATADUR_A_F1, cbFrameLength, byPktType,
+										 wCurrentRate, bNeedAck, uFragIdx, cbLastFragmentSize, uMACfragNum, byFBOption));
+
+			buf->time_stamp_off_a = vnt_time_stamp_off(pDevice, wCurrentRate);
+			buf->time_stamp_off_b = vnt_time_stamp_off(pDevice, pDevice->byTopCCKBasicRate);
+
+			return buf->duration_a;
 		} //if (byFBOption == AUTO_FB_NONE)
 	} else if (byPktType == PK_TYPE_11A) {
 		if ((byFBOption != AUTO_FB_NONE)) {
@@ -1335,15 +1335,17 @@ s_cbFillTxBufHead(struct vnt_private *pDevice, unsigned char byPktType,
 				pMICHDR = (struct vnt_mic_hdr *) (pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_rts));
 				pvRTS = (PSRTS_g_FB) (pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_rts) + cbMICHDR);
 				pvCTS = NULL;
-				pvTxDataHd = (PSTxDataHead_g_FB) (pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_rts) + cbMICHDR + sizeof(SRTS_g_FB));
-				cbHeaderLength = wTxBufSize + sizeof(struct vnt_rrv_time_rts) + cbMICHDR + sizeof(SRTS_g_FB) + sizeof(STxDataHead_g_FB);
+				pvTxDataHd = (void *)(pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_rts) + cbMICHDR + sizeof(SRTS_g_FB));
+				cbHeaderLength = wTxBufSize + sizeof(struct vnt_rrv_time_rts) +
+					cbMICHDR + sizeof(SRTS_g_FB) + sizeof(struct vnt_tx_datahead_g_fb);
 			} else { //RTS_needless
 				pvRrvTime = (void *)(pbyTxBufferAddr + wTxBufSize);
 				pMICHDR = (struct vnt_mic_hdr *) (pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_cts));
 				pvRTS = NULL;
 				pvCTS = (PSCTS_FB) (pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_cts) + cbMICHDR);
-				pvTxDataHd = (PSTxDataHead_g_FB) (pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_cts) + cbMICHDR + sizeof(SCTS_FB));
-				cbHeaderLength = wTxBufSize + sizeof(struct vnt_rrv_time_cts) + cbMICHDR + sizeof(SCTS_FB) + sizeof(STxDataHead_g_FB);
+				pvTxDataHd = (void  *)(pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_cts) + cbMICHDR + sizeof(SCTS_FB));
+				cbHeaderLength = wTxBufSize + sizeof(struct vnt_rrv_time_cts) +
+					cbMICHDR + sizeof(SCTS_FB) + sizeof(struct vnt_tx_datahead_g_fb);
 			}
 		} // Auto Fall Back
 	} else {//802.11a/b packet
diff --git a/drivers/staging/vt6655/rxtx.h b/drivers/staging/vt6655/rxtx.h
index 0fe9998..212c2ef 100644
--- a/drivers/staging/vt6655/rxtx.h
+++ b/drivers/staging/vt6655/rxtx.h
@@ -88,6 +88,17 @@ struct vnt_tx_datahead_g {
 	__le16 time_stamp_off_a;
 } __packed;
 
+struct vnt_tx_datahead_g_fb {
+	struct vnt_phy_field b;
+	struct vnt_phy_field a;
+	__le16 duration_b;
+	__le16 duration_a;
+	__le16 duration_a_f0;
+	__le16 duration_a_f1;
+	__le16 time_stamp_off_b;
+	__le16 time_stamp_off_a;
+} __packed;
+
 struct vnt_tx_short_buf_head {
 	__le16 fifo_ctl;
 	u16 time_stamp;
-- 
1.9.1

