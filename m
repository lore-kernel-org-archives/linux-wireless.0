Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:52212 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156AbaH3V02 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Aug 2014 17:26:28 -0400
Received: by mail-we0-f177.google.com with SMTP id u56so3689035wes.22
        for <linux-wireless@vger.kernel.org>; Sat, 30 Aug 2014 14:26:27 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 03/23] staging: vt6655: rxtx replace typedef struct tagSRrvTime_ab with struct vnt_rrv_time_ab
Date: Sat, 30 Aug 2014 22:25:29 +0100
Message-Id: <1409433949-5468-3-git-send-email-tvboxspy@gmail.com> (sfid-20140830_232633_273464_3E8D7B44)
In-Reply-To: <1409433949-5468-1-git-send-email-tvboxspy@gmail.com>
References: <1409433949-5468-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replacing members
wRTSTxRrvTime and wTxRrvTime
with
rts_rrv_time and rrv_time

using __le16 type

Moving structure to rxtx.h

pvRrvTime is a void pointer

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/desc.h |  7 -----
 drivers/staging/vt6655/rxtx.c | 73 ++++++++++++++++++++++---------------------
 drivers/staging/vt6655/rxtx.h |  5 +++
 3 files changed, 43 insertions(+), 42 deletions(-)

diff --git a/drivers/staging/vt6655/desc.h b/drivers/staging/vt6655/desc.h
index 237a99c..84de4ef 100644
--- a/drivers/staging/vt6655/desc.h
+++ b/drivers/staging/vt6655/desc.h
@@ -331,13 +331,6 @@ typedef const STxSyncDesc *PCSTxSyncDesc;
 //
 // RsvTime buffer header
 //
-typedef struct tagSRrvTime_ab {
-	unsigned short wRTSTxRrvTime;
-	unsigned short wTxRrvTime;
-} __attribute__ ((__packed__))
-SRrvTime_ab, *PSRrvTime_ab;
-typedef const SRrvTime_ab *PCSRrvTime_ab;
-
 typedef struct tagSRrvTime_atim {
 	unsigned short wCTSTxRrvTime_ba;
 	unsigned short wTxRrvTime_a;
diff --git a/drivers/staging/vt6655/rxtx.c b/drivers/staging/vt6655/rxtx.c
index b2fd513..a0b8384 100644
--- a/drivers/staging/vt6655/rxtx.c
+++ b/drivers/staging/vt6655/rxtx.c
@@ -1109,38 +1109,38 @@ s_vGenerateTxParameter(
 		if (pvRTS != NULL) {//RTS_need, non PCF mode
 			//Fill RsvTime
 			if (pvRrvTime) {
-				PSRrvTime_ab pBuf = (PSRrvTime_ab)pvRrvTime;
+				struct vnt_rrv_time_ab *buf = pvRrvTime;
 
-				pBuf->wRTSTxRrvTime = cpu_to_le16((unsigned short)s_uGetRTSCTSRsvTime(pDevice, 2, byPktType, cbFrameSize, wCurrentRate));//2:RTSTxRrvTime_aa, 0:5GHz
-				pBuf->wTxRrvTime = cpu_to_le16((unsigned short)s_uGetTxRsvTime(pDevice, byPktType, cbFrameSize, wCurrentRate, bNeedACK));//0:OFDM
+				buf->rts_rrv_time = cpu_to_le16((u16)s_uGetRTSCTSRsvTime(pDevice, 2, byPktType, cbFrameSize, wCurrentRate));
+				buf->rrv_time = cpu_to_le16((u16)s_uGetTxRsvTime(pDevice, byPktType, cbFrameSize, wCurrentRate, bNeedACK));
 			}
 			//Fill RTS
 			s_vFillRTSHead(pDevice, byPktType, pvRTS, cbFrameSize, bNeedACK, bDisCRC, psEthHeader, wCurrentRate, byFBOption);
 		} else if (pvRTS == NULL) {//RTS_needless, non PCF mode
 			//Fill RsvTime
 			if (pvRrvTime) {
-				PSRrvTime_ab pBuf = (PSRrvTime_ab)pvRrvTime;
+				struct vnt_rrv_time_ab *buf = pvRrvTime;
 
-				pBuf->wTxRrvTime = cpu_to_le16((unsigned short)s_uGetTxRsvTime(pDevice, PK_TYPE_11A, cbFrameSize, wCurrentRate, bNeedACK)); //0:OFDM
+				buf->rrv_time = cpu_to_le16((u16)s_uGetTxRsvTime(pDevice, PK_TYPE_11A, cbFrameSize, wCurrentRate, bNeedACK));
 			}
 		}
 	} else if (byPktType == PK_TYPE_11B) {
 		if ((pvRTS != NULL)) {//RTS_need, non PCF mode
 			//Fill RsvTime
 			if (pvRrvTime) {
-				PSRrvTime_ab pBuf = (PSRrvTime_ab)pvRrvTime;
+				struct vnt_rrv_time_ab *buf = pvRrvTime;
 
-				pBuf->wRTSTxRrvTime = cpu_to_le16((unsigned short)s_uGetRTSCTSRsvTime(pDevice, 0, byPktType, cbFrameSize, wCurrentRate));//0:RTSTxRrvTime_bb, 1:2.4GHz
-				pBuf->wTxRrvTime = cpu_to_le16((unsigned short)s_uGetTxRsvTime(pDevice, PK_TYPE_11B, cbFrameSize, wCurrentRate, bNeedACK));//1:CCK
+				buf->rts_rrv_time = cpu_to_le16((u16)s_uGetRTSCTSRsvTime(pDevice, 0, byPktType, cbFrameSize, wCurrentRate));
+				buf->rrv_time = cpu_to_le16((u16)s_uGetTxRsvTime(pDevice, PK_TYPE_11B, cbFrameSize, wCurrentRate, bNeedACK));
 			}
 			//Fill RTS
 			s_vFillRTSHead(pDevice, byPktType, pvRTS, cbFrameSize, bNeedACK, bDisCRC, psEthHeader, wCurrentRate, byFBOption);
 		} else { //RTS_needless, non PCF mode
 			//Fill RsvTime
 			if (pvRrvTime) {
-				PSRrvTime_ab pBuf = (PSRrvTime_ab)pvRrvTime;
+				struct vnt_rrv_time_ab *buf = pvRrvTime;
 
-				pBuf->wTxRrvTime = cpu_to_le16((unsigned short)s_uGetTxRsvTime(pDevice, PK_TYPE_11B, cbFrameSize, wCurrentRate, bNeedACK)); //1:CCK
+				buf->rrv_time = cpu_to_le16((u16)s_uGetTxRsvTime(pDevice, PK_TYPE_11B, cbFrameSize, wCurrentRate, bNeedACK));
 			}
 		}
 	}
@@ -1348,36 +1348,36 @@ s_cbFillTxBufHead(struct vnt_private *pDevice, unsigned char byPktType,
 
 		if (byFBOption == AUTO_FB_NONE) {
 			if (bRTS == true) {
-				pvRrvTime = (PSRrvTime_ab) (pbyTxBufferAddr + wTxBufSize);
-				pMICHDR = (struct vnt_mic_hdr *) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_ab));
-				pvRTS = (PSRTS_ab) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_ab) + cbMICHDR);
+				pvRrvTime = (void *)(pbyTxBufferAddr + wTxBufSize);
+				pMICHDR = (struct vnt_mic_hdr *) (pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_ab));
+				pvRTS = (PSRTS_ab) (pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_ab) + cbMICHDR);
 				pvCTS = NULL;
-				pvTxDataHd = (PSTxDataHead_ab) (pbyTxBufferAddr + wTxBufSize + sizeof(PSRrvTime_ab) + cbMICHDR + sizeof(SRTS_ab));
-				cbHeaderLength = wTxBufSize + sizeof(PSRrvTime_ab) + cbMICHDR + sizeof(SRTS_ab) + sizeof(STxDataHead_ab);
+				pvTxDataHd = (PSTxDataHead_ab) (pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_ab) + cbMICHDR + sizeof(SRTS_ab));
+				cbHeaderLength = wTxBufSize + sizeof(struct vnt_rrv_time_ab) + cbMICHDR + sizeof(SRTS_ab) + sizeof(STxDataHead_ab);
 			} else { //RTS_needless, need MICHDR
-				pvRrvTime = (PSRrvTime_ab) (pbyTxBufferAddr + wTxBufSize);
-				pMICHDR = (struct vnt_mic_hdr *) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_ab));
+				pvRrvTime = (void *)(pbyTxBufferAddr + wTxBufSize);
+				pMICHDR = (struct vnt_mic_hdr *) (pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_ab));
 				pvRTS = NULL;
 				pvCTS = NULL;
-				pvTxDataHd = (PSTxDataHead_ab) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_ab) + cbMICHDR);
-				cbHeaderLength = wTxBufSize + sizeof(SRrvTime_ab) + cbMICHDR + sizeof(STxDataHead_ab);
+				pvTxDataHd = (PSTxDataHead_ab) (pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_ab) + cbMICHDR);
+				cbHeaderLength = wTxBufSize + sizeof(struct vnt_rrv_time_ab) + cbMICHDR + sizeof(STxDataHead_ab);
 			}
 		} else {
 			// Auto Fall Back
 			if (bRTS == true) {//RTS_need
-				pvRrvTime = (PSRrvTime_ab) (pbyTxBufferAddr + wTxBufSize);
-				pMICHDR = (struct vnt_mic_hdr *) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_ab));
-				pvRTS = (PSRTS_a_FB) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_ab) + cbMICHDR);
+				pvRrvTime = (void *)(pbyTxBufferAddr + wTxBufSize);
+				pMICHDR = (struct vnt_mic_hdr *) (pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_ab));
+				pvRTS = (PSRTS_a_FB) (pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_ab) + cbMICHDR);
 				pvCTS = NULL;
-				pvTxDataHd = (PSTxDataHead_a_FB) (pbyTxBufferAddr + wTxBufSize + sizeof(PSRrvTime_ab) + cbMICHDR + sizeof(SRTS_a_FB));
-				cbHeaderLength = wTxBufSize + sizeof(PSRrvTime_ab) + cbMICHDR + sizeof(SRTS_a_FB) + sizeof(STxDataHead_a_FB);
+				pvTxDataHd = (PSTxDataHead_a_FB) (pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_ab) + cbMICHDR + sizeof(SRTS_a_FB));
+				cbHeaderLength = wTxBufSize + sizeof(struct vnt_rrv_time_ab) + cbMICHDR + sizeof(SRTS_a_FB) + sizeof(STxDataHead_a_FB);
 			} else { //RTS_needless
-				pvRrvTime = (PSRrvTime_ab) (pbyTxBufferAddr + wTxBufSize);
-				pMICHDR = (struct vnt_mic_hdr *) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_ab));
+				pvRrvTime = (void *)(pbyTxBufferAddr + wTxBufSize);
+				pMICHDR = (struct vnt_mic_hdr *)(pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_ab));
 				pvRTS = NULL;
 				pvCTS = NULL;
-				pvTxDataHd = (PSTxDataHead_a_FB) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_ab) + cbMICHDR);
-				cbHeaderLength = wTxBufSize + sizeof(SRrvTime_ab) + cbMICHDR + sizeof(STxDataHead_a_FB);
+				pvTxDataHd = (PSTxDataHead_a_FB) (pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_ab) + cbMICHDR);
+				cbHeaderLength = wTxBufSize + sizeof(struct vnt_rrv_time_ab) + cbMICHDR + sizeof(STxDataHead_a_FB);
 			}
 		} // Auto Fall Back
 	}
@@ -2193,12 +2193,12 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice, PSTxMgmtPacket pPacket)
 		cbHeaderSize = wTxBufSize + sizeof(struct vnt_rrv_time_cts) +
 					sizeof(SCTS) + sizeof(STxDataHead_g);
 	} else { // 802.11a/b packet
-		pvRrvTime = (PSRrvTime_ab) (pbyTxBufferAddr + wTxBufSize);
+		pvRrvTime = (void *)(pbyTxBufferAddr + wTxBufSize);
 		pMICHDR = NULL;
 		pvRTS = NULL;
 		pCTS = NULL;
-		pvTxDataHd = (PSTxDataHead_ab) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_ab));
-		cbHeaderSize = wTxBufSize + sizeof(SRrvTime_ab) + sizeof(STxDataHead_ab);
+		pvTxDataHd = (PSTxDataHead_ab) (pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_ab));
+		cbHeaderSize = wTxBufSize + sizeof(struct vnt_rrv_time_ab) + sizeof(STxDataHead_ab);
 	}
 
 	memset((void *)(pbyTxBufferAddr + wTxBufSize), 0, (cbHeaderSize - wTxBufSize));
@@ -2683,12 +2683,15 @@ void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb,
 
 	} else {//802.11a/b packet
 
-		pvRrvTime = (PSRrvTime_ab) (pbyTxBufferAddr + wTxBufSize);
-		pMICHDR = (struct vnt_mic_hdr *) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_ab));
+		pvRrvTime = (void *)(pbyTxBufferAddr + wTxBufSize);
+		pMICHDR = (struct vnt_mic_hdr *) (pbyTxBufferAddr +
+				wTxBufSize + sizeof(struct vnt_rrv_time_ab));
 		pvRTS = NULL;
 		pvCTS = NULL;
-		pvTxDataHd = (PSTxDataHead_ab) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_ab) + cbMICHDR);
-		cbHeaderSize = wTxBufSize + sizeof(SRrvTime_ab) + cbMICHDR + sizeof(STxDataHead_ab);
+		pvTxDataHd = (PSTxDataHead_ab) (pbyTxBufferAddr +
+			wTxBufSize + sizeof(struct vnt_rrv_time_ab) + cbMICHDR);
+		cbHeaderSize = wTxBufSize + sizeof(struct vnt_rrv_time_ab) +
+					cbMICHDR + sizeof(STxDataHead_ab);
 
 	}
 
diff --git a/drivers/staging/vt6655/rxtx.h b/drivers/staging/vt6655/rxtx.h
index 4dca615..a14b5f1 100644
--- a/drivers/staging/vt6655/rxtx.h
+++ b/drivers/staging/vt6655/rxtx.h
@@ -73,6 +73,11 @@ struct vnt_rrv_time_cts {
 	__le16 rrv_time_a;
 } __packed;
 
+struct vnt_rrv_time_ab {
+	__le16 rts_rrv_time;
+	__le16 rrv_time;
+} __packed;
+
 struct vnt_tx_short_buf_head {
 	__le16 fifo_ctl;
 	u16 time_stamp;
-- 
1.9.1

