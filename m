Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:55142 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341AbaH3V0u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Aug 2014 17:26:50 -0400
Received: by mail-we0-f180.google.com with SMTP id w61so3703057wes.39
        for <linux-wireless@vger.kernel.org>; Sat, 30 Aug 2014 14:26:48 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 15/23] staging: vt6655: replace typedef struct tagSRTS_g with struct vnt_rts_g
Date: Sat, 30 Aug 2014 22:25:41 +0100
Message-Id: <1409433949-5468-15-git-send-email-tvboxspy@gmail.com> (sfid-20140830_234533_480085_6F8B427B)
In-Reply-To: <1409433949-5468-1-git-send-email-tvboxspy@gmail.com>
References: <1409433949-5468-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replacing members
b, a, wDuration_ba, wDuration_aa, wDuration_bb, wReserved and data
with
b, a,duration_ba, duration_aa, duration_bb, reserved and  data

replacing unsigned short with u16 or __le16 where endian correction is necessary.

Creating the new structure in rxtx.h

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/desc.h | 12 ------------
 drivers/staging/vt6655/rxtx.c | 45 +++++++++++++++++++++++++++----------------
 drivers/staging/vt6655/rxtx.h | 11 +++++++++++
 3 files changed, 39 insertions(+), 29 deletions(-)

diff --git a/drivers/staging/vt6655/desc.h b/drivers/staging/vt6655/desc.h
index 00c3922..5fbef74 100644
--- a/drivers/staging/vt6655/desc.h
+++ b/drivers/staging/vt6655/desc.h
@@ -352,18 +352,6 @@ union vnt_phy_field_swap {
 	u32 field_write;
 };
 
-typedef struct tagSRTS_g {
-	struct vnt_phy_field b;
-	struct vnt_phy_field a;
-	unsigned short wDuration_ba;
-	unsigned short wDuration_aa;
-	unsigned short wDuration_bb;
-	unsigned short wReserved;
-	struct ieee80211_rts data;
-} __attribute__ ((__packed__))
-SRTS_g, *PSRTS_g;
-typedef const SRTS_g *PCSRTS_g;
-
 typedef struct tagSRTS_g_FB {
 	struct vnt_phy_field b;
 	struct vnt_phy_field a;
diff --git a/drivers/staging/vt6655/rxtx.c b/drivers/staging/vt6655/rxtx.c
index d94d496..29a4ed0 100644
--- a/drivers/staging/vt6655/rxtx.c
+++ b/drivers/staging/vt6655/rxtx.c
@@ -818,37 +818,46 @@ s_vFillRTSHead(
 	//       Otherwise, we need to modify codes for them.
 	if (byPktType == PK_TYPE_11GB || byPktType == PK_TYPE_11GA) {
 		if (byFBOption == AUTO_FB_NONE) {
-			PSRTS_g pBuf = (PSRTS_g)pvRTS;
+			struct vnt_rts_g *buf = pvRTS;
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
-			pBuf->wDuration_aa = cpu_to_le16((unsigned short)s_uGetRTSCTSDuration(pDevice, RTSDUR_AA, cbFrameLength, byPktType, wCurrentRate, bNeedAck, byFBOption)); //2:RTSDuration_aa, 1:2.4G, 2,3: 2.4G OFDMData
-			pBuf->wDuration_ba = cpu_to_le16((unsigned short)s_uGetRTSCTSDuration(pDevice, RTSDUR_BA, cbFrameLength, byPktType, wCurrentRate, bNeedAck, byFBOption)); //1:RTSDuration_ba, 1:2.4G, 2,3:2.4G OFDM Data
-
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
+
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
 
 		} else {
 			PSRTS_g_FB pBuf = (PSRTS_g_FB)pvRTS;
@@ -1335,11 +1344,13 @@ s_cbFillTxBufHead(struct vnt_private *pDevice, unsigned char byPktType,
 			if (bRTS == true) {//RTS_need
 				pvRrvTime = (void *)(pbyTxBufferAddr + wTxBufSize);
 				pMICHDR = (struct vnt_mic_hdr *)(pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_rts));
-				pvRTS = (PSRTS_g)(pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_rts) + cbMICHDR);
+				pvRTS = (void *)(pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_rts) + cbMICHDR);
 				pvCTS = NULL;
-				pvTxDataHd = (void *)(pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_rts) + cbMICHDR + sizeof(SRTS_g));
+				pvTxDataHd = (void *)(pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_rts) +
+							cbMICHDR + sizeof(struct vnt_rts_g));
 				cbHeaderLength = wTxBufSize + sizeof(struct vnt_rrv_time_rts) +
-							cbMICHDR + sizeof(SRTS_g) + sizeof(struct vnt_tx_datahead_g);
+							cbMICHDR + sizeof(struct vnt_rts_g) +
+							sizeof(struct vnt_tx_datahead_g);
 			} else { //RTS_needless
 				pvRrvTime = (void *)(pbyTxBufferAddr + wTxBufSize);
 				pMICHDR = (struct vnt_mic_hdr *) (pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_cts));
diff --git a/drivers/staging/vt6655/rxtx.h b/drivers/staging/vt6655/rxtx.h
index 21bbc7e..377cd42 100644
--- a/drivers/staging/vt6655/rxtx.h
+++ b/drivers/staging/vt6655/rxtx.h
@@ -113,6 +113,17 @@ struct vnt_tx_datahead_a_fb {
 	__le16 duration_f1;
 } __packed;
 
+/* RTS buffer header */
+struct vnt_rts_g {
+	struct vnt_phy_field b;
+	struct vnt_phy_field a;
+	__le16 duration_ba;
+	__le16 duration_aa;
+	__le16 duration_bb;
+	u16 reserved;
+	struct ieee80211_rts data;
+} __packed;
+
 struct vnt_tx_short_buf_head {
 	__le16 fifo_ctl;
 	u16 time_stamp;
-- 
1.9.1

