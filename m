Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:64199 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbaH3V0Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Aug 2014 17:26:25 -0400
Received: by mail-we0-f182.google.com with SMTP id w62so3677532wes.41
        for <linux-wireless@vger.kernel.org>; Sat, 30 Aug 2014 14:26:23 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 01/23] staging: vt6655: rxtx replace typedef struct tagSRrvTime_gRTS with struct vnt_rrv_time_rts
Date: Sat, 30 Aug 2014 22:25:27 +0100
Message-Id: <1409433949-5468-1-git-send-email-tvboxspy@gmail.com> (sfid-20140830_232629_599489_C123A272)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replacing members
wRTSTxRrvTime_ba, wRTSTxRrvTime_aa,  wRTSTxRrvTime_bb, wReserved, wTxRrvTime_b and wTxRrvTime_a
with
rts_rrv_time_ba, rts_rrv_time_aa, rts_rrv_time_bb, reserved, rrv_time_b and rrv_time_a

Creating the new structure in rxtx.h and Using __le16 where necessary

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/desc.h | 11 -----------
 drivers/staging/vt6655/rxtx.c | 32 ++++++++++++++++----------------
 drivers/staging/vt6655/rxtx.h | 10 ++++++++++
 3 files changed, 26 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/vt6655/desc.h b/drivers/staging/vt6655/desc.h
index b5730df..49a2e04 100644
--- a/drivers/staging/vt6655/desc.h
+++ b/drivers/staging/vt6655/desc.h
@@ -331,17 +331,6 @@ typedef const STxSyncDesc *PCSTxSyncDesc;
 //
 // RsvTime buffer header
 //
-typedef struct tagSRrvTime_gRTS {
-	unsigned short wRTSTxRrvTime_ba;
-	unsigned short wRTSTxRrvTime_aa;
-	unsigned short wRTSTxRrvTime_bb;
-	unsigned short wReserved;
-	unsigned short wTxRrvTime_b;
-	unsigned short wTxRrvTime_a;
-} __attribute__ ((__packed__))
-SRrvTime_gRTS, *PSRrvTime_gRTS;
-typedef const SRrvTime_gRTS *PCSRrvTime_gRTS;
-
 typedef struct tagSRrvTime_gCTS {
 	unsigned short wCTSTxRrvTime_ba;
 	unsigned short wReserved;
diff --git a/drivers/staging/vt6655/rxtx.c b/drivers/staging/vt6655/rxtx.c
index 7493db1..609aec8 100644
--- a/drivers/staging/vt6655/rxtx.c
+++ b/drivers/staging/vt6655/rxtx.c
@@ -1081,13 +1081,13 @@ s_vGenerateTxParameter(
 		if (pvRTS != NULL) { //RTS_need
 			//Fill RsvTime
 			if (pvRrvTime) {
-				PSRrvTime_gRTS pBuf = (PSRrvTime_gRTS)pvRrvTime;
+				struct vnt_rrv_time_rts *buf = pvRrvTime;
 
-				pBuf->wRTSTxRrvTime_aa = cpu_to_le16((unsigned short)s_uGetRTSCTSRsvTime(pDevice, 2, byPktType, cbFrameSize, wCurrentRate));//2:RTSTxRrvTime_aa, 1:2.4GHz
-				pBuf->wRTSTxRrvTime_ba = cpu_to_le16((unsigned short)s_uGetRTSCTSRsvTime(pDevice, 1, byPktType, cbFrameSize, wCurrentRate));//1:RTSTxRrvTime_ba, 1:2.4GHz
-				pBuf->wRTSTxRrvTime_bb = cpu_to_le16((unsigned short)s_uGetRTSCTSRsvTime(pDevice, 0, byPktType, cbFrameSize, wCurrentRate));//0:RTSTxRrvTime_bb, 1:2.4GHz
-				pBuf->wTxRrvTime_a = cpu_to_le16((unsigned short) s_uGetTxRsvTime(pDevice, byPktType, cbFrameSize, wCurrentRate, bNeedACK));//2.4G OFDM
-				pBuf->wTxRrvTime_b = cpu_to_le16((unsigned short) s_uGetTxRsvTime(pDevice, PK_TYPE_11B, cbFrameSize, pDevice->byTopCCKBasicRate, bNeedACK));//1:CCK
+				buf->rts_rrv_time_aa = cpu_to_le16((u16)s_uGetRTSCTSRsvTime(pDevice, 2, byPktType, cbFrameSize, wCurrentRate));
+				buf->rts_rrv_time_ba = cpu_to_le16((u16)s_uGetRTSCTSRsvTime(pDevice, 1, byPktType, cbFrameSize, wCurrentRate));
+				buf->rts_rrv_time_bb = cpu_to_le16((u16)s_uGetRTSCTSRsvTime(pDevice, 0, byPktType, cbFrameSize, wCurrentRate));
+				buf->rrv_time_a = cpu_to_le16((u16)s_uGetTxRsvTime(pDevice, byPktType, cbFrameSize, wCurrentRate, bNeedACK));
+				buf->rrv_time_b = cpu_to_le16((u16)s_uGetTxRsvTime(pDevice, PK_TYPE_11B, cbFrameSize, pDevice->byTopCCKBasicRate, bNeedACK));
 			}
 			//Fill RTS
 			s_vFillRTSHead(pDevice, byPktType, pvRTS, cbFrameSize, bNeedACK, bDisCRC, psEthHeader, wCurrentRate, byFBOption);
@@ -1312,12 +1312,12 @@ s_cbFillTxBufHead(struct vnt_private *pDevice, unsigned char byPktType,
 
 		if (byFBOption == AUTO_FB_NONE) {
 			if (bRTS == true) {//RTS_need
-				pvRrvTime = (PSRrvTime_gRTS) (pbyTxBufferAddr + wTxBufSize);
-				pMICHDR = (struct vnt_mic_hdr *) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_gRTS));
-				pvRTS = (PSRTS_g) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_gRTS) + cbMICHDR);
+				pvRrvTime = (void *)(pbyTxBufferAddr + wTxBufSize);
+				pMICHDR = (struct vnt_mic_hdr *)(pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_rts));
+				pvRTS = (PSRTS_g)(pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_rts) + cbMICHDR);
 				pvCTS = NULL;
-				pvTxDataHd = (PSTxDataHead_g) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_gRTS) + cbMICHDR + sizeof(SRTS_g));
-				cbHeaderLength = wTxBufSize + sizeof(SRrvTime_gRTS) + cbMICHDR + sizeof(SRTS_g) + sizeof(STxDataHead_g);
+				pvTxDataHd = (PSTxDataHead_g)(pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_rts) + cbMICHDR + sizeof(SRTS_g));
+				cbHeaderLength = wTxBufSize + sizeof(struct vnt_rrv_time_rts) + cbMICHDR + sizeof(SRTS_g) + sizeof(STxDataHead_g);
 			} else { //RTS_needless
 				pvRrvTime = (PSRrvTime_gCTS) (pbyTxBufferAddr + wTxBufSize);
 				pMICHDR = (struct vnt_mic_hdr *) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_gCTS));
@@ -1329,12 +1329,12 @@ s_cbFillTxBufHead(struct vnt_private *pDevice, unsigned char byPktType,
 		} else {
 			// Auto Fall Back
 			if (bRTS == true) {//RTS_need
-				pvRrvTime = (PSRrvTime_gRTS) (pbyTxBufferAddr + wTxBufSize);
-				pMICHDR = (struct vnt_mic_hdr *) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_gRTS));
-				pvRTS = (PSRTS_g_FB) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_gRTS) + cbMICHDR);
+				pvRrvTime = (void *)(pbyTxBufferAddr + wTxBufSize);
+				pMICHDR = (struct vnt_mic_hdr *) (pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_rts));
+				pvRTS = (PSRTS_g_FB) (pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_rts) + cbMICHDR);
 				pvCTS = NULL;
-				pvTxDataHd = (PSTxDataHead_g_FB) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_gRTS) + cbMICHDR + sizeof(SRTS_g_FB));
-				cbHeaderLength = wTxBufSize + sizeof(SRrvTime_gRTS) + cbMICHDR + sizeof(SRTS_g_FB) + sizeof(STxDataHead_g_FB);
+				pvTxDataHd = (PSTxDataHead_g_FB) (pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_rts) + cbMICHDR + sizeof(SRTS_g_FB));
+				cbHeaderLength = wTxBufSize + sizeof(struct vnt_rrv_time_rts) + cbMICHDR + sizeof(SRTS_g_FB) + sizeof(STxDataHead_g_FB);
 			} else { //RTS_needless
 				pvRrvTime = (PSRrvTime_gCTS) (pbyTxBufferAddr + wTxBufSize);
 				pMICHDR = (struct vnt_mic_hdr *) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_gCTS));
diff --git a/drivers/staging/vt6655/rxtx.h b/drivers/staging/vt6655/rxtx.h
index 789fae7..f5f6478 100644
--- a/drivers/staging/vt6655/rxtx.h
+++ b/drivers/staging/vt6655/rxtx.h
@@ -56,6 +56,16 @@ struct vnt_mic_hdr {
 	u16 packing; /* packing to 48 bytes */
 } __packed;
 
+/* RsvTime buffer header */
+struct vnt_rrv_time_rts {
+	__le16 rts_rrv_time_ba;
+	__le16 rts_rrv_time_aa;
+	__le16 rts_rrv_time_bb;
+	u16 reserved;
+	__le16 rrv_time_b;
+	__le16 rrv_time_a;
+} __packed;
+
 struct vnt_tx_short_buf_head {
 	__le16 fifo_ctl;
 	u16 time_stamp;
-- 
1.9.1

