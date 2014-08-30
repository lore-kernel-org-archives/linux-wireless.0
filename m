Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:60850 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346AbaH3V0v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Aug 2014 17:26:51 -0400
Received: by mail-we0-f174.google.com with SMTP id u57so3689271wes.5
        for <linux-wireless@vger.kernel.org>; Sat, 30 Aug 2014 14:26:50 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 16/23] staging: vt6655: replace typedef struct tagSRTS_g_FB with struct vnt_rts_g_fb
Date: Sat, 30 Aug 2014 22:25:42 +0100
Message-Id: <1409433949-5468-16-git-send-email-tvboxspy@gmail.com> (sfid-20140830_234534_899981_BF223708)
In-Reply-To: <1409433949-5468-1-git-send-email-tvboxspy@gmail.com>
References: <1409433949-5468-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replacing members
b, a, wDuration_ba, wDuration_aa, wDuration_bb, wReserved, wRTSDuration_ba_f0,
wRTSDuration_aa_f0, wRTSDuration_ba_f1, wRTSDuration_aa_f1 and data

with

b, a, duration_ba, duration_aa, duration_bb, wReserved, rts_duration_ba_f0,
rts_duration_aa_f0, rts_duration_ba_f1, rts_duration_aa_f1 and data

replacing unsigned short with u16 or __le16 where endian correction is necessary.

Creating the new structure in rxtx.h

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/desc.h | 16 -----------
 drivers/staging/vt6655/rxtx.c | 62 +++++++++++++++++++++++++++++--------------
 drivers/staging/vt6655/rxtx.h | 14 ++++++++++
 3 files changed, 56 insertions(+), 36 deletions(-)

diff --git a/drivers/staging/vt6655/desc.h b/drivers/staging/vt6655/desc.h
index 5fbef74..e1c686e 100644
--- a/drivers/staging/vt6655/desc.h
+++ b/drivers/staging/vt6655/desc.h
@@ -352,22 +352,6 @@ union vnt_phy_field_swap {
 	u32 field_write;
 };
 
-typedef struct tagSRTS_g_FB {
-	struct vnt_phy_field b;
-	struct vnt_phy_field a;
-	unsigned short wDuration_ba;
-	unsigned short wDuration_aa;
-	unsigned short wDuration_bb;
-	unsigned short wReserved;
-	unsigned short wRTSDuration_ba_f0;
-	unsigned short wRTSDuration_aa_f0;
-	unsigned short wRTSDuration_ba_f1;
-	unsigned short wRTSDuration_aa_f1;
-	struct ieee80211_rts data;
-} __attribute__ ((__packed__))
-SRTS_g_FB, *PSRTS_g_FB;
-typedef const SRTS_g_FB *PCSRTS_g_FB;
-
 typedef struct tagSRTS_ab {
 	struct vnt_phy_field ab;
 	unsigned short wDuration;
diff --git a/drivers/staging/vt6655/rxtx.c b/drivers/staging/vt6655/rxtx.c
index 29a4ed0..a0d379a 100644
--- a/drivers/staging/vt6655/rxtx.c
+++ b/drivers/staging/vt6655/rxtx.c
@@ -860,41 +860,62 @@ s_vFillRTSHead(
 				memcpy(&buf->data.ta, psEthHeader->abySrcAddr, ETH_ALEN);
 
 		} else {
-			PSRTS_g_FB pBuf = (PSRTS_g_FB)pvRTS;
+			struct vnt_rts_g_fb *buf = pvRTS;
 			/* Get SignalField, ServiceField & Length */
 			vnt_get_phy_field(pDevice, uRTSFrameLen,
 					  pDevice->byTopCCKBasicRate,
-					  PK_TYPE_11B, &pBuf->b);
+					  PK_TYPE_11B, &buf->b);
 
 			vnt_get_phy_field(pDevice, uRTSFrameLen,
 					  pDevice->byTopOFDMBasicRate,
-					  byPktType, &pBuf->a);
-			//Get Duration
-			pBuf->wDuration_bb = cpu_to_le16((unsigned short)s_uGetRTSCTSDuration(pDevice, RTSDUR_BB, cbFrameLength, PK_TYPE_11B, pDevice->byTopCCKBasicRate, bNeedAck, byFBOption));    //0:RTSDuration_bb, 1:2.4G, 1:CCKData
-			pBuf->wDuration_aa = cpu_to_le16((unsigned short)s_uGetRTSCTSDuration(pDevice, RTSDUR_AA, cbFrameLength, byPktType, wCurrentRate, bNeedAck, byFBOption)); //2:RTSDuration_aa, 1:2.4G, 2,3:2.4G OFDMData
-			pBuf->wDuration_ba = cpu_to_le16((unsigned short)s_uGetRTSCTSDuration(pDevice, RTSDUR_BA, cbFrameLength, byPktType, wCurrentRate, bNeedAck, byFBOption)); //1:RTSDuration_ba, 1:2.4G, 2,3:2.4G OFDMData
-			pBuf->wRTSDuration_ba_f0 = cpu_to_le16((unsigned short)s_uGetRTSCTSDuration(pDevice, RTSDUR_BA_F0, cbFrameLength, byPktType, wCurrentRate, bNeedAck, byFBOption));    //4:wRTSDuration_ba_f0, 1:2.4G, 1:CCKData
-			pBuf->wRTSDuration_aa_f0 = cpu_to_le16((unsigned short)s_uGetRTSCTSDuration(pDevice, RTSDUR_AA_F0, cbFrameLength, byPktType, wCurrentRate, bNeedAck, byFBOption));    //5:wRTSDuration_aa_f0, 1:2.4G, 1:CCKData
-			pBuf->wRTSDuration_ba_f1 = cpu_to_le16((unsigned short)s_uGetRTSCTSDuration(pDevice, RTSDUR_BA_F1, cbFrameLength, byPktType, wCurrentRate, bNeedAck, byFBOption));    //6:wRTSDuration_ba_f1, 1:2.4G, 1:CCKData
-			pBuf->wRTSDuration_aa_f1 = cpu_to_le16((unsigned short)s_uGetRTSCTSDuration(pDevice, RTSDUR_AA_F1, cbFrameLength, byPktType, wCurrentRate, bNeedAck, byFBOption));    //7:wRTSDuration_aa_f1, 1:2.4G, 1:CCKData
-			pBuf->data.duration = pBuf->wDuration_aa;
+					  byPktType, &buf->a);
+			/* Get Duration */
+			buf->duration_bb =
+				cpu_to_le16((u16)s_uGetRTSCTSDuration(pDevice, RTSDUR_BB, cbFrameLength,
+								      PK_TYPE_11B, pDevice->byTopCCKBasicRate,
+								      bNeedAck, byFBOption));
+			buf->duration_aa =
+				cpu_to_le16((u16)s_uGetRTSCTSDuration(pDevice, RTSDUR_AA, cbFrameLength,
+								      byPktType, wCurrentRate, bNeedAck,
+								      byFBOption));
+			buf->duration_ba =
+				cpu_to_le16((u16)s_uGetRTSCTSDuration(pDevice, RTSDUR_BA, cbFrameLength,
+								      byPktType, wCurrentRate, bNeedAck,
+								      byFBOption));
+			buf->rts_duration_ba_f0 =
+				cpu_to_le16((u16)s_uGetRTSCTSDuration(pDevice, RTSDUR_BA_F0, cbFrameLength,
+								      byPktType, wCurrentRate, bNeedAck,
+								      byFBOption));
+			buf->rts_duration_aa_f0 =
+				cpu_to_le16((u16)s_uGetRTSCTSDuration(pDevice, RTSDUR_AA_F0, cbFrameLength,
+								      byPktType, wCurrentRate, bNeedAck,
+								      byFBOption));
+			buf->rts_duration_ba_f1 =
+				cpu_to_le16((u16)s_uGetRTSCTSDuration(pDevice, RTSDUR_BA_F1, cbFrameLength,
+								      byPktType, wCurrentRate, bNeedAck,
+								      byFBOption));
+			buf->rts_duration_aa_f1 =
+				cpu_to_le16((u16)s_uGetRTSCTSDuration(pDevice, RTSDUR_AA_F1, cbFrameLength,
+								      byPktType, wCurrentRate, bNeedAck,
+								      byFBOption));
+			buf->data.duration = buf->duration_aa;
 			/* Get RTS Frame body */
-			pBuf->data.frame_control =
+			buf->data.frame_control =
 					cpu_to_le16(IEEE80211_FTYPE_CTL |
 						    IEEE80211_STYPE_RTS);
 
 
 			if ((pDevice->eOPMode == OP_MODE_ADHOC) ||
 			    (pDevice->eOPMode == OP_MODE_AP)) {
-				memcpy(&pBuf->data.ra, psEthHeader->abyDstAddr, ETH_ALEN);
+				memcpy(&buf->data.ra, psEthHeader->abyDstAddr, ETH_ALEN);
 			} else {
-				memcpy(&pBuf->data.ra, pDevice->abyBSSID, ETH_ALEN);
+				memcpy(&buf->data.ra, pDevice->abyBSSID, ETH_ALEN);
 			}
 
 			if (pDevice->eOPMode == OP_MODE_AP)
-				memcpy(&pBuf->data.ta, pDevice->abyBSSID, ETH_ALEN);
+				memcpy(&buf->data.ta, pDevice->abyBSSID, ETH_ALEN);
 			else
-				memcpy(&pBuf->data.ta, psEthHeader->abySrcAddr, ETH_ALEN);
+				memcpy(&buf->data.ta, psEthHeader->abySrcAddr, ETH_ALEN);
 
 		} // if (byFBOption == AUTO_FB_NONE)
 	} else if (byPktType == PK_TYPE_11A) {
@@ -1365,11 +1386,12 @@ s_cbFillTxBufHead(struct vnt_private *pDevice, unsigned char byPktType,
 			if (bRTS == true) {//RTS_need
 				pvRrvTime = (void *)(pbyTxBufferAddr + wTxBufSize);
 				pMICHDR = (struct vnt_mic_hdr *) (pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_rts));
-				pvRTS = (PSRTS_g_FB) (pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_rts) + cbMICHDR);
+				pvRTS = (void *) (pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_rts) + cbMICHDR);
 				pvCTS = NULL;
-				pvTxDataHd = (void *)(pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_rts) + cbMICHDR + sizeof(SRTS_g_FB));
+				pvTxDataHd = (void *)(pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_rts) +
+					cbMICHDR + sizeof(struct vnt_rts_g_fb));
 				cbHeaderLength = wTxBufSize + sizeof(struct vnt_rrv_time_rts) +
-					cbMICHDR + sizeof(SRTS_g_FB) + sizeof(struct vnt_tx_datahead_g_fb);
+					cbMICHDR + sizeof(struct vnt_rts_g_fb) + sizeof(struct vnt_tx_datahead_g_fb);
 			} else { //RTS_needless
 				pvRrvTime = (void *)(pbyTxBufferAddr + wTxBufSize);
 				pMICHDR = (struct vnt_mic_hdr *) (pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_cts));
diff --git a/drivers/staging/vt6655/rxtx.h b/drivers/staging/vt6655/rxtx.h
index 377cd42..b9153e0 100644
--- a/drivers/staging/vt6655/rxtx.h
+++ b/drivers/staging/vt6655/rxtx.h
@@ -124,6 +124,20 @@ struct vnt_rts_g {
 	struct ieee80211_rts data;
 } __packed;
 
+struct vnt_rts_g_fb {
+	struct vnt_phy_field b;
+	struct vnt_phy_field a;
+	__le16 duration_ba;
+	__le16 duration_aa;
+	__le16 duration_bb;
+	u16 wReserved;
+	__le16 rts_duration_ba_f0;
+	__le16 rts_duration_aa_f0;
+	__le16 rts_duration_ba_f1;
+	__le16 rts_duration_aa_f1;
+	struct ieee80211_rts data;
+} __packed;
+
 struct vnt_tx_short_buf_head {
 	__le16 fifo_ctl;
 	u16 time_stamp;
-- 
1.9.1

