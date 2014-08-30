Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:41279 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393AbaH3V06 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Aug 2014 17:26:58 -0400
Received: by mail-we0-f170.google.com with SMTP id p10so3706026wes.29
        for <linux-wireless@vger.kernel.org>; Sat, 30 Aug 2014 14:26:57 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 20/23] staging: vt6655: replace typedef struct tagSCTS_FB with struct vnt_cts_fb
Date: Sat, 30 Aug 2014 22:25:46 +0100
Message-Id: <1409433949-5468-20-git-send-email-tvboxspy@gmail.com> (sfid-20140830_234534_217394_E0E27FC4)
In-Reply-To: <1409433949-5468-1-git-send-email-tvboxspy@gmail.com>
References: <1409433949-5468-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replacing members
b, wDuration_ba,  wReserved, wCTSDuration_ba_f0, wCTSDuration_ba_f1, data and
reserved2.

With
b, duration_ba, reserved, cts_duration_ba_f0, cts_duration_ba_f1, data and
reserved2

unsigned short is replaced with u16 or __le16 where necessary.

cast void pointer to pvCTS

Creating the new structure in rxtx.h

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/desc.h | 15 -------------
 drivers/staging/vt6655/rxtx.c | 50 ++++++++++++++++++++++++++-----------------
 drivers/staging/vt6655/rxtx.h | 10 +++++++++
 3 files changed, 40 insertions(+), 35 deletions(-)

diff --git a/drivers/staging/vt6655/desc.h b/drivers/staging/vt6655/desc.h
index 4d9027e..5a2bbd2 100644
--- a/drivers/staging/vt6655/desc.h
+++ b/drivers/staging/vt6655/desc.h
@@ -353,21 +353,6 @@ union vnt_phy_field_swap {
 };
 
 //
-// CTS buffer header
-//
-typedef struct tagSCTS_FB {
-	struct vnt_phy_field b;
-	unsigned short wDuration_ba;
-	unsigned short wReserved;
-	unsigned short wCTSDuration_ba_f0;
-	unsigned short wCTSDuration_ba_f1;
-	struct ieee80211_cts data;
-	u16 reserved2;
-} __attribute__ ((__packed__))
-SCTS_FB, *PSCTS_FB;
-typedef const SCTS_FB *PCSCTS_FB;
-
-//
 // Tx FIFO header
 //
 typedef struct tagSTxBufHead {
diff --git a/drivers/staging/vt6655/rxtx.c b/drivers/staging/vt6655/rxtx.c
index d3de73c..6b22f09 100644
--- a/drivers/staging/vt6655/rxtx.c
+++ b/drivers/staging/vt6655/rxtx.c
@@ -1043,33 +1043,42 @@ s_vFillCTSHead(
 	if (byPktType == PK_TYPE_11GB || byPktType == PK_TYPE_11GA) {
 		if (byFBOption != AUTO_FB_NONE && uDMAIdx != TYPE_ATIMDMA && uDMAIdx != TYPE_BEACONDMA) {
 			// Auto Fall back
-			PSCTS_FB pBuf = (PSCTS_FB)pvCTS;
+			struct vnt_cts_fb *buf = pvCTS;
 			/* Get SignalField, ServiceField & Length */
 			vnt_get_phy_field(pDevice, uCTSFrameLen,
 					  pDevice->byTopCCKBasicRate,
-					  PK_TYPE_11B, &pBuf->b);
-
-			pBuf->wDuration_ba = (unsigned short)s_uGetRTSCTSDuration(pDevice, CTSDUR_BA, cbFrameLength, byPktType, wCurrentRate, bNeedAck, byFBOption); //3:CTSDuration_ba, 1:2.4G, 2,3:2.4G OFDM Data
-			pBuf->wDuration_ba += pDevice->wCTSDuration;
-			pBuf->wDuration_ba = cpu_to_le16(pBuf->wDuration_ba);
-			//Get CTSDuration_ba_f0
-			pBuf->wCTSDuration_ba_f0 = (unsigned short)s_uGetRTSCTSDuration(pDevice, CTSDUR_BA_F0, cbFrameLength, byPktType, wCurrentRate, bNeedAck, byFBOption); //8:CTSDuration_ba_f0, 1:2.4G, 2,3:2.4G OFDM Data
-			pBuf->wCTSDuration_ba_f0 += pDevice->wCTSDuration;
-			pBuf->wCTSDuration_ba_f0 = cpu_to_le16(pBuf->wCTSDuration_ba_f0);
+					  PK_TYPE_11B, &buf->b);
+
+			buf->duration_ba = (u16)s_uGetRTSCTSDuration(pDevice, CTSDUR_BA, cbFrameLength,
+								     byPktType, wCurrentRate, bNeedAck, byFBOption);
+			buf->duration_ba += pDevice->wCTSDuration;
+
+			buf->duration_ba = cpu_to_le16(buf->duration_ba);
+			/* Get CTSDuration_ba_f0 */
+			buf->cts_duration_ba_f0 = (u16)s_uGetRTSCTSDuration(pDevice, CTSDUR_BA_F0, cbFrameLength,
+									    byPktType, wCurrentRate,
+									    bNeedAck, byFBOption);
+
+			buf->cts_duration_ba_f0 += pDevice->wCTSDuration;
+
+			buf->cts_duration_ba_f0 = cpu_to_le16(buf->cts_duration_ba_f0);
 			//Get CTSDuration_ba_f1
-			pBuf->wCTSDuration_ba_f1 = (unsigned short)s_uGetRTSCTSDuration(pDevice, CTSDUR_BA_F1, cbFrameLength, byPktType, wCurrentRate, bNeedAck, byFBOption); //9:CTSDuration_ba_f1, 1:2.4G, 2,3:2.4G OFDM Data
-			pBuf->wCTSDuration_ba_f1 += pDevice->wCTSDuration;
-			pBuf->wCTSDuration_ba_f1 = cpu_to_le16(pBuf->wCTSDuration_ba_f1);
+			buf->cts_duration_ba_f1 = (u16)s_uGetRTSCTSDuration(pDevice, CTSDUR_BA_F1, cbFrameLength,
+									    byPktType, wCurrentRate,
+									    bNeedAck, byFBOption);
+			buf->cts_duration_ba_f1 += pDevice->wCTSDuration;
+
+			buf->cts_duration_ba_f1 = cpu_to_le16(buf->cts_duration_ba_f1);
 			/* Get CTS Frame body */
-			pBuf->data.duration = pBuf->wDuration_ba;
+			buf->data.duration = buf->duration_ba;
 
-			pBuf->data.frame_control =
+			buf->data.frame_control =
 				cpu_to_le16(IEEE80211_FTYPE_CTL |
 					    IEEE80211_STYPE_CTS);
 
-			pBuf->reserved2 = 0x0;
-			memcpy(&pBuf->data.ra, pDevice->abyCurrentNetAddr, ETH_ALEN);
+			buf->reserved2 = 0x0;
 
+			memcpy(&buf->data.ra, pDevice->abyCurrentNetAddr, ETH_ALEN);
 		} else { //if (byFBOption != AUTO_FB_NONE && uDMAIdx != TYPE_ATIMDMA && uDMAIdx != TYPE_BEACONDMA)
 			struct vnt_cts *buf = pvCTS;
 			/* Get SignalField, ServiceField & Length */
@@ -1414,10 +1423,11 @@ s_cbFillTxBufHead(struct vnt_private *pDevice, unsigned char byPktType,
 				pvRrvTime = (void *)(pbyTxBufferAddr + wTxBufSize);
 				pMICHDR = (struct vnt_mic_hdr *) (pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_cts));
 				pvRTS = NULL;
-				pvCTS = (PSCTS_FB) (pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_cts) + cbMICHDR);
-				pvTxDataHd = (void  *)(pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_cts) + cbMICHDR + sizeof(SCTS_FB));
+				pvCTS = (void *)(pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_cts) + cbMICHDR);
+				pvTxDataHd = (void  *)(pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_cts) +
+					cbMICHDR + sizeof(struct vnt_cts_fb));
 				cbHeaderLength = wTxBufSize + sizeof(struct vnt_rrv_time_cts) +
-					cbMICHDR + sizeof(SCTS_FB) + sizeof(struct vnt_tx_datahead_g_fb);
+					cbMICHDR + sizeof(struct vnt_cts_fb) + sizeof(struct vnt_tx_datahead_g_fb);
 			}
 		} // Auto Fall Back
 	} else {//802.11a/b packet
diff --git a/drivers/staging/vt6655/rxtx.h b/drivers/staging/vt6655/rxtx.h
index 2c09c11..8ee6288 100644
--- a/drivers/staging/vt6655/rxtx.h
+++ b/drivers/staging/vt6655/rxtx.h
@@ -163,6 +163,16 @@ struct vnt_cts {
 	u16 reserved2;
 } __packed;
 
+struct vnt_cts_fb {
+	struct vnt_phy_field b;
+	__le16 duration_ba;
+	u16 reserved;
+	__le16 cts_duration_ba_f0;
+	__le16 cts_duration_ba_f1;
+	struct ieee80211_cts data;
+	u16 reserved2;
+} __packed;
+
 struct vnt_tx_short_buf_head {
 	__le16 fifo_ctl;
 	u16 time_stamp;
-- 
1.9.1

