Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:65155 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297AbaH3V0m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Aug 2014 17:26:42 -0400
Received: by mail-wg0-f42.google.com with SMTP id b13so3605591wgh.1
        for <linux-wireless@vger.kernel.org>; Sat, 30 Aug 2014 14:26:40 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 11/23] staging: vt6655: replace -typedef struct tagSTxDataHead_a_FB with struct vnt_tx_datahead_a_fb
Date: Sat, 30 Aug 2014 22:25:37 +0100
Message-Id: <1409433949-5468-11-git-send-email-tvboxspy@gmail.com> (sfid-20140830_234534_524718_2466A76E)
In-Reply-To: <1409433949-5468-1-git-send-email-tvboxspy@gmail.com>
References: <1409433949-5468-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace members
a, wDuration, wTimeStampOff, wDuration_f0, and wDuration_f1;
with
a, duration, time_stamp_off, duration_f0, duration_f1

All unsigned short members should be  __le16

Creating the new structure in rxtx.h.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/desc.h | 13 -------------
 drivers/staging/vt6655/rxtx.c | 35 ++++++++++++++++++-----------------
 drivers/staging/vt6655/rxtx.h |  8 ++++++++
 3 files changed, 26 insertions(+), 30 deletions(-)

diff --git a/drivers/staging/vt6655/desc.h b/drivers/staging/vt6655/desc.h
index ed5052a..0da860e 100644
--- a/drivers/staging/vt6655/desc.h
+++ b/drivers/staging/vt6655/desc.h
@@ -456,19 +456,6 @@ typedef struct tagSTxBufHead {
 STxBufHead, *PSTxBufHead;
 typedef const STxBufHead *PCSTxBufHead;
 
-//
-// Tx data header
-//
-typedef struct tagSTxDataHead_a_FB {
-	struct vnt_phy_field a;
-	unsigned short wDuration;
-	unsigned short wTimeStampOff;
-	unsigned short wDuration_f0;
-	unsigned short wDuration_f1;
-} __attribute__ ((__packed__))
-STxDataHead_a_FB, *PSTxDataHead_a_FB;
-typedef const STxDataHead_a_FB *PCSTxDataHead_a_FB;
-
 typedef struct tagSBEACONCtl {
 	u32 BufReady:1;
 	u32 TSF:15;
diff --git a/drivers/staging/vt6655/rxtx.c b/drivers/staging/vt6655/rxtx.c
index 627cacb..bd0e339 100644
--- a/drivers/staging/vt6655/rxtx.c
+++ b/drivers/staging/vt6655/rxtx.c
@@ -743,22 +743,21 @@ s_uFillDataHead(
 		} //if (byFBOption == AUTO_FB_NONE)
 	} else if (byPktType == PK_TYPE_11A) {
 		if ((byFBOption != AUTO_FB_NONE)) {
-			// Auto Fallback
-			PSTxDataHead_a_FB pBuf = (PSTxDataHead_a_FB)pTxDataHead;
+			/* Auto Fallback */
+			struct vnt_tx_datahead_a_fb *buf = pTxDataHead;
 			/* Get SignalField, ServiceField & Length */
 			vnt_get_phy_field(pDevice, cbFrameLength, wCurrentRate,
-					  byPktType, &pBuf->a);
-
-			//Get Duration and TimeStampOff
+					  byPktType, &buf->a);
 
-			pBuf->wDuration = cpu_to_le16((unsigned short)s_uGetDataDuration(pDevice, DATADUR_A, cbFrameLength, byPktType,
-											 wCurrentRate, bNeedAck, uFragIdx, cbLastFragmentSize, uMACfragNum, byFBOption)); //0: 5GHz
-			pBuf->wDuration_f0 = cpu_to_le16((unsigned short)s_uGetDataDuration(pDevice, DATADUR_A_F0, cbFrameLength, byPktType,
-											    wCurrentRate, bNeedAck, uFragIdx, cbLastFragmentSize, uMACfragNum, byFBOption)); //0: 5GHz
-			pBuf->wDuration_f1 = cpu_to_le16((unsigned short)s_uGetDataDuration(pDevice, DATADUR_A_F1, cbFrameLength, byPktType,
-											    wCurrentRate, bNeedAck, uFragIdx, cbLastFragmentSize, uMACfragNum, byFBOption)); //0: 5GHz
-			pBuf->wTimeStampOff = vnt_time_stamp_off(pDevice, wCurrentRate);
-			return pBuf->wDuration;
+			/* Get Duration and TimeStampOff */
+			buf->duration = cpu_to_le16((u16)s_uGetDataDuration(pDevice, DATADUR_A, cbFrameLength, byPktType,
+									    wCurrentRate, bNeedAck, uFragIdx, cbLastFragmentSize, uMACfragNum, byFBOption));
+			buf->duration_f0 = cpu_to_le16((u16)s_uGetDataDuration(pDevice, DATADUR_A_F0, cbFrameLength, byPktType,
+									       wCurrentRate, bNeedAck, uFragIdx, cbLastFragmentSize, uMACfragNum, byFBOption));
+			buf->duration_f1 = cpu_to_le16((u16)s_uGetDataDuration(pDevice, DATADUR_A_F1, cbFrameLength, byPktType,
+										wCurrentRate, bNeedAck, uFragIdx, cbLastFragmentSize, uMACfragNum, byFBOption));
+			buf->time_stamp_off = vnt_time_stamp_off(pDevice, wCurrentRate);
+			return buf->duration;
 		} else {
 			struct vnt_tx_datahead_ab *buf = pTxDataHead;
 			/* Get SignalField, ServiceField & Length */
@@ -1376,15 +1375,17 @@ s_cbFillTxBufHead(struct vnt_private *pDevice, unsigned char byPktType,
 				pMICHDR = (struct vnt_mic_hdr *) (pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_ab));
 				pvRTS = (PSRTS_a_FB) (pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_ab) + cbMICHDR);
 				pvCTS = NULL;
-				pvTxDataHd = (PSTxDataHead_a_FB) (pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_ab) + cbMICHDR + sizeof(SRTS_a_FB));
-				cbHeaderLength = wTxBufSize + sizeof(struct vnt_rrv_time_ab) + cbMICHDR + sizeof(SRTS_a_FB) + sizeof(STxDataHead_a_FB);
+				pvTxDataHd = (void *)(pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_ab) + cbMICHDR + sizeof(SRTS_a_FB));
+				cbHeaderLength = wTxBufSize + sizeof(struct vnt_rrv_time_ab) +
+					cbMICHDR + sizeof(SRTS_a_FB) + sizeof(struct vnt_tx_datahead_a_fb);
 			} else { //RTS_needless
 				pvRrvTime = (void *)(pbyTxBufferAddr + wTxBufSize);
 				pMICHDR = (struct vnt_mic_hdr *)(pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_ab));
 				pvRTS = NULL;
 				pvCTS = NULL;
-				pvTxDataHd = (PSTxDataHead_a_FB) (pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_ab) + cbMICHDR);
-				cbHeaderLength = wTxBufSize + sizeof(struct vnt_rrv_time_ab) + cbMICHDR + sizeof(STxDataHead_a_FB);
+				pvTxDataHd = (void *)(pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_ab) + cbMICHDR);
+				cbHeaderLength = wTxBufSize + sizeof(struct vnt_rrv_time_ab) +
+					cbMICHDR + sizeof(struct vnt_tx_datahead_a_fb);
 			}
 		} // Auto Fall Back
 	}
diff --git a/drivers/staging/vt6655/rxtx.h b/drivers/staging/vt6655/rxtx.h
index 4899f6e..21bbc7e 100644
--- a/drivers/staging/vt6655/rxtx.h
+++ b/drivers/staging/vt6655/rxtx.h
@@ -105,6 +105,14 @@ struct vnt_tx_datahead_ab {
 	__le16 time_stamp_off;
 } __packed;
 
+struct vnt_tx_datahead_a_fb {
+	struct vnt_phy_field a;
+	__le16 duration;
+	__le16 time_stamp_off;
+	__le16 duration_f0;
+	__le16 duration_f1;
+} __packed;
+
 struct vnt_tx_short_buf_head {
 	__le16 fifo_ctl;
 	u16 time_stamp;
-- 
1.9.1

