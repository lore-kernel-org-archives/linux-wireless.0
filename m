Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:63346 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370AbaH3V0z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Aug 2014 17:26:55 -0400
Received: by mail-we0-f177.google.com with SMTP id u56so3693288wes.36
        for <linux-wireless@vger.kernel.org>; Sat, 30 Aug 2014 14:26:53 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 18/23] staging: vt6655: replace typedef struct tagSRTS_a_FB with struct vnt_rts_a_fb
Date: Sat, 30 Aug 2014 22:25:44 +0100
Message-Id: <1409433949-5468-18-git-send-email-tvboxspy@gmail.com> (sfid-20140830_234535_220042_A5A35E3D)
In-Reply-To: <1409433949-5468-1-git-send-email-tvboxspy@gmail.com>
References: <1409433949-5468-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replacing members
a, wDuration, wReserved, wRTSDuration_f0, wRTSDuration_f1 and data
with
a, duration, reserved, rts_duration_f0, rts_duration_f1 and data

unsigned short is replaced with u16 or __le16 where necessary.

cast void pointer to pvRTS

Creating the new structure in rxtx.h

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/desc.h | 11 -----------
 drivers/staging/vt6655/rxtx.c | 41 +++++++++++++++++++++++++----------------
 drivers/staging/vt6655/rxtx.h |  9 +++++++++
 3 files changed, 34 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/vt6655/desc.h b/drivers/staging/vt6655/desc.h
index de459d8..f0a31a8 100644
--- a/drivers/staging/vt6655/desc.h
+++ b/drivers/staging/vt6655/desc.h
@@ -352,17 +352,6 @@ union vnt_phy_field_swap {
 	u32 field_write;
 };
 
-typedef struct tagSRTS_a_FB {
-	struct vnt_phy_field a;
-	unsigned short wDuration;
-	unsigned short wReserved;
-	unsigned short wRTSDuration_f0;
-	unsigned short wRTSDuration_f1;
-	struct ieee80211_rts data;
-} __attribute__ ((__packed__))
-SRTS_a_FB, *PSRTS_a_FB;
-typedef const SRTS_a_FB *PCSRTS_a_FB;
-
 //
 // CTS buffer header
 //
diff --git a/drivers/staging/vt6655/rxtx.c b/drivers/staging/vt6655/rxtx.c
index 420fcf5..0721fbb 100644
--- a/drivers/staging/vt6655/rxtx.c
+++ b/drivers/staging/vt6655/rxtx.c
@@ -950,32 +950,40 @@ s_vFillRTSHead(
 				memcpy(&buf->data.ta, psEthHeader->abySrcAddr, ETH_ALEN);
 
 		} else {
-			PSRTS_a_FB pBuf = (PSRTS_a_FB)pvRTS;
+			struct vnt_rts_a_fb *buf = pvRTS;
 			/* Get SignalField, ServiceField & Length */
 			vnt_get_phy_field(pDevice, uRTSFrameLen,
 					  pDevice->byTopOFDMBasicRate,
-					  byPktType, &pBuf->a);
-			//Get Duration
-			pBuf->wDuration = cpu_to_le16((unsigned short)s_uGetRTSCTSDuration(pDevice, RTSDUR_AA, cbFrameLength, byPktType, wCurrentRate, bNeedAck, byFBOption)); //0:RTSDuration_aa, 0:5G, 0: 5G OFDMData
-			pBuf->wRTSDuration_f0 = cpu_to_le16((unsigned short)s_uGetRTSCTSDuration(pDevice, RTSDUR_AA_F0, cbFrameLength, byPktType, wCurrentRate, bNeedAck, byFBOption)); //5:RTSDuration_aa_f0, 0:5G, 0: 5G OFDMData
-			pBuf->wRTSDuration_f1 = cpu_to_le16((unsigned short)s_uGetRTSCTSDuration(pDevice, RTSDUR_AA_F1, cbFrameLength, byPktType, wCurrentRate, bNeedAck, byFBOption)); //7:RTSDuration_aa_f1, 0:5G, 0:
-			pBuf->data.duration = pBuf->wDuration;
+					  byPktType, &buf->a);
+			/* Get Duration */
+			buf->duration =
+				cpu_to_le16((u16)s_uGetRTSCTSDuration(pDevice, RTSDUR_AA, cbFrameLength,
+								      byPktType, wCurrentRate,
+								      bNeedAck, byFBOption));
+			buf->rts_duration_f0 =
+				cpu_to_le16((u16)s_uGetRTSCTSDuration(pDevice, RTSDUR_AA_F0, cbFrameLength,
+								      byPktType, wCurrentRate,
+								      bNeedAck, byFBOption));
+			buf->rts_duration_f1 =
+				cpu_to_le16((u16)s_uGetRTSCTSDuration(pDevice, RTSDUR_AA_F1, cbFrameLength,
+								      byPktType, wCurrentRate,
+								      bNeedAck, byFBOption));
+			buf->data.duration = buf->duration;
 			/* Get RTS Frame body */
-			pBuf->data.frame_control =
+			buf->data.frame_control =
 					cpu_to_le16(IEEE80211_FTYPE_CTL |
 						    IEEE80211_STYPE_RTS);
 
-
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
 		}
 	} else if (byPktType == PK_TYPE_11B) {
 		struct vnt_rts_ab *buf = pvRTS;
@@ -1434,11 +1442,12 @@ s_cbFillTxBufHead(struct vnt_private *pDevice, unsigned char byPktType,
 			if (bRTS == true) {//RTS_need
 				pvRrvTime = (void *)(pbyTxBufferAddr + wTxBufSize);
 				pMICHDR = (struct vnt_mic_hdr *) (pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_ab));
-				pvRTS = (PSRTS_a_FB) (pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_ab) + cbMICHDR);
+				pvRTS = (void *)(pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_ab) + cbMICHDR);
 				pvCTS = NULL;
-				pvTxDataHd = (void *)(pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_ab) + cbMICHDR + sizeof(SRTS_a_FB));
+				pvTxDataHd = (void *)(pbyTxBufferAddr + wTxBufSize +
+					sizeof(struct vnt_rrv_time_ab) + cbMICHDR + sizeof(struct vnt_rts_a_fb));
 				cbHeaderLength = wTxBufSize + sizeof(struct vnt_rrv_time_ab) +
-					cbMICHDR + sizeof(SRTS_a_FB) + sizeof(struct vnt_tx_datahead_a_fb);
+					cbMICHDR + sizeof(struct vnt_rts_a_fb) + sizeof(struct vnt_tx_datahead_a_fb);
 			} else { //RTS_needless
 				pvRrvTime = (void *)(pbyTxBufferAddr + wTxBufSize);
 				pMICHDR = (struct vnt_mic_hdr *)(pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_ab));
diff --git a/drivers/staging/vt6655/rxtx.h b/drivers/staging/vt6655/rxtx.h
index 807753c..bac2214 100644
--- a/drivers/staging/vt6655/rxtx.h
+++ b/drivers/staging/vt6655/rxtx.h
@@ -145,6 +145,15 @@ struct vnt_rts_ab {
 	struct ieee80211_rts data;
 } __packed;
 
+struct vnt_rts_a_fb {
+	struct vnt_phy_field a;
+	__le16 duration;
+	u16 reserved;
+	__le16 rts_duration_f0;
+	__le16 rts_duration_f1;
+	struct ieee80211_rts data;
+} __packed;
+
 struct vnt_tx_short_buf_head {
 	__le16 fifo_ctl;
 	u16 time_stamp;
-- 
1.9.1

