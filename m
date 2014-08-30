Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:56566 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361AbaH3V0x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Aug 2014 17:26:53 -0400
Received: by mail-wg0-f47.google.com with SMTP id z12so3590953wgg.6
        for <linux-wireless@vger.kernel.org>; Sat, 30 Aug 2014 14:26:52 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 17/23] staging: vt6655: replace typedef struct tagSRTS_ab with struct vnt_rts_ab
Date: Sat, 30 Aug 2014 22:25:43 +0100
Message-Id: <1409433949-5468-17-git-send-email-tvboxspy@gmail.com> (sfid-20140830_234534_719809_CADB36DE)
In-Reply-To: <1409433949-5468-1-git-send-email-tvboxspy@gmail.com>
References: <1409433949-5468-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replacing members
ab, wDuration, wReserved and data

with

ab, duration, reserved and data

replacing unsigned short with u16 and __le16 where necessary.

pvRTS is void pointer.

Creating the new structure in rxtx.h

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/desc.h |  9 --------
 drivers/staging/vt6655/rxtx.c | 52 ++++++++++++++++++++++++-------------------
 drivers/staging/vt6655/rxtx.h |  7 ++++++
 3 files changed, 36 insertions(+), 32 deletions(-)

diff --git a/drivers/staging/vt6655/desc.h b/drivers/staging/vt6655/desc.h
index e1c686e..de459d8 100644
--- a/drivers/staging/vt6655/desc.h
+++ b/drivers/staging/vt6655/desc.h
@@ -352,15 +352,6 @@ union vnt_phy_field_swap {
 	u32 field_write;
 };
 
-typedef struct tagSRTS_ab {
-	struct vnt_phy_field ab;
-	unsigned short wDuration;
-	unsigned short wReserved;
-	struct ieee80211_rts data;
-} __attribute__ ((__packed__))
-SRTS_ab, *PSRTS_ab;
-typedef const SRTS_ab *PCSRTS_ab;
-
 typedef struct tagSRTS_a_FB {
 	struct vnt_phy_field a;
 	unsigned short wDuration;
diff --git a/drivers/staging/vt6655/rxtx.c b/drivers/staging/vt6655/rxtx.c
index a0d379a..420fcf5 100644
--- a/drivers/staging/vt6655/rxtx.c
+++ b/drivers/staging/vt6655/rxtx.c
@@ -920,31 +920,34 @@ s_vFillRTSHead(
 		} // if (byFBOption == AUTO_FB_NONE)
 	} else if (byPktType == PK_TYPE_11A) {
 		if (byFBOption == AUTO_FB_NONE) {
-			PSRTS_ab pBuf = (PSRTS_ab)pvRTS;
+			struct vnt_rts_ab *buf = pvRTS;
 			/* Get SignalField, ServiceField & Length */
 			vnt_get_phy_field(pDevice, uRTSFrameLen,
 					  pDevice->byTopOFDMBasicRate,
-					  byPktType, &pBuf->ab);
-			//Get Duration
-			pBuf->wDuration = cpu_to_le16((unsigned short)s_uGetRTSCTSDuration(pDevice, RTSDUR_AA, cbFrameLength, byPktType, wCurrentRate, bNeedAck, byFBOption)); //0:RTSDuration_aa, 0:5G, 0: 5G OFDMData
-			pBuf->data.duration = pBuf->wDuration;
+					  byPktType, &buf->ab);
+			/* Get Duration */
+			buf->duration =
+				cpu_to_le16((u16)s_uGetRTSCTSDuration(pDevice, RTSDUR_AA, cbFrameLength,
+								      byPktType, wCurrentRate, bNeedAck,
+								      byFBOption));
+			buf->data.duration = buf->duration;
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
 			PSRTS_a_FB pBuf = (PSRTS_a_FB)pvRTS;
@@ -975,29 +978,32 @@ s_vFillRTSHead(
 				memcpy(&pBuf->data.ta, psEthHeader->abySrcAddr, ETH_ALEN);
 		}
 	} else if (byPktType == PK_TYPE_11B) {
-		PSRTS_ab pBuf = (PSRTS_ab)pvRTS;
+		struct vnt_rts_ab *buf = pvRTS;
 		/* Get SignalField, ServiceField & Length */
 		vnt_get_phy_field(pDevice, uRTSFrameLen,
 				  pDevice->byTopCCKBasicRate,
-				  PK_TYPE_11B, &pBuf->ab);
-		//Get Duration
-		pBuf->wDuration = cpu_to_le16((unsigned short)s_uGetRTSCTSDuration(pDevice, RTSDUR_BB, cbFrameLength, byPktType, wCurrentRate, bNeedAck, byFBOption)); //0:RTSDuration_bb, 1:2.4G, 1:CCKData
-		pBuf->data.duration = pBuf->wDuration;
+				  PK_TYPE_11B, &buf->ab);
+		/* Get Duration */
+		buf->duration =
+			cpu_to_le16((u16)s_uGetRTSCTSDuration(pDevice, RTSDUR_BB, cbFrameLength,
+							      byPktType, wCurrentRate, bNeedAck,
+							      byFBOption));
+		buf->data.duration = buf->duration;
 		/* Get RTS Frame body */
-		pBuf->data.frame_control =
+		buf->data.frame_control =
 			cpu_to_le16(IEEE80211_FTYPE_CTL | IEEE80211_STYPE_RTS);
 
 		if ((pDevice->eOPMode == OP_MODE_ADHOC) ||
 		    (pDevice->eOPMode == OP_MODE_AP)) {
-			memcpy(&pBuf->data.ra, psEthHeader->abyDstAddr, ETH_ALEN);
+			memcpy(&buf->data.ra, psEthHeader->abyDstAddr, ETH_ALEN);
 		} else {
-			memcpy(&pBuf->data.ra, pDevice->abyBSSID, ETH_ALEN);
+			memcpy(&buf->data.ra, pDevice->abyBSSID, ETH_ALEN);
 		}
 
 		if (pDevice->eOPMode == OP_MODE_AP)
-			memcpy(&pBuf->data.ta, pDevice->abyBSSID, ETH_ALEN);
+			memcpy(&buf->data.ta, pDevice->abyBSSID, ETH_ALEN);
 		else
-			memcpy(&pBuf->data.ta, psEthHeader->abySrcAddr, ETH_ALEN);
+			memcpy(&buf->data.ta, psEthHeader->abySrcAddr, ETH_ALEN);
 	}
 }
 
@@ -1408,12 +1414,12 @@ s_cbFillTxBufHead(struct vnt_private *pDevice, unsigned char byPktType,
 			if (bRTS == true) {
 				pvRrvTime = (void *)(pbyTxBufferAddr + wTxBufSize);
 				pMICHDR = (struct vnt_mic_hdr *) (pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_ab));
-				pvRTS = (PSRTS_ab) (pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_ab) + cbMICHDR);
+				pvRTS = (void *)(pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_ab) + cbMICHDR);
 				pvCTS = NULL;
 				pvTxDataHd = (void *)(pbyTxBufferAddr + wTxBufSize +
-					sizeof(struct vnt_rrv_time_ab) + cbMICHDR + sizeof(SRTS_ab));
+					sizeof(struct vnt_rrv_time_ab) + cbMICHDR + sizeof(struct vnt_rts_ab));
 				cbHeaderLength = wTxBufSize + sizeof(struct vnt_rrv_time_ab) +
-					cbMICHDR + sizeof(SRTS_ab) + sizeof(struct vnt_tx_datahead_ab);
+					cbMICHDR + sizeof(struct vnt_rts_ab) + sizeof(struct vnt_tx_datahead_ab);
 			} else { //RTS_needless, need MICHDR
 				pvRrvTime = (void *)(pbyTxBufferAddr + wTxBufSize);
 				pMICHDR = (struct vnt_mic_hdr *) (pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_ab));
diff --git a/drivers/staging/vt6655/rxtx.h b/drivers/staging/vt6655/rxtx.h
index b9153e0..807753c 100644
--- a/drivers/staging/vt6655/rxtx.h
+++ b/drivers/staging/vt6655/rxtx.h
@@ -138,6 +138,13 @@ struct vnt_rts_g_fb {
 	struct ieee80211_rts data;
 } __packed;
 
+struct vnt_rts_ab {
+	struct vnt_phy_field ab;
+	__le16 duration;
+	u16 reserved;
+	struct ieee80211_rts data;
+} __packed;
+
 struct vnt_tx_short_buf_head {
 	__le16 fifo_ctl;
 	u16 time_stamp;
-- 
1.9.1

