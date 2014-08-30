Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:50203 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288AbaH3V0k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Aug 2014 17:26:40 -0400
Received: by mail-wg0-f43.google.com with SMTP id a1so3615188wgh.26
        for <linux-wireless@vger.kernel.org>; Sat, 30 Aug 2014 14:26:39 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 10/23] staging: vt6655: replace typedef struct tagSTxDataHead_ab with struct vnt_tx_datahead_ab
Date: Sat, 30 Aug 2014 22:25:36 +0100
Message-Id: <1409433949-5468-10-git-send-email-tvboxspy@gmail.com> (sfid-20140830_232648_939457_C0DFF7D8)
In-Reply-To: <1409433949-5468-1-git-send-email-tvboxspy@gmail.com>
References: <1409433949-5468-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replacing members
ab, wDuration and wTimeStampOff

with
ab, duration and time_stamp_off

All unsigned short should be __le16

Structure is moved to rxtx.h

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/desc.h |  8 ------
 drivers/staging/vt6655/rxtx.c | 61 +++++++++++++++++++++++--------------------
 drivers/staging/vt6655/rxtx.h |  6 +++++
 3 files changed, 39 insertions(+), 36 deletions(-)

diff --git a/drivers/staging/vt6655/desc.h b/drivers/staging/vt6655/desc.h
index 0945c07..ed5052a 100644
--- a/drivers/staging/vt6655/desc.h
+++ b/drivers/staging/vt6655/desc.h
@@ -459,14 +459,6 @@ typedef const STxBufHead *PCSTxBufHead;
 //
 // Tx data header
 //
-typedef struct tagSTxDataHead_ab {
-	struct vnt_phy_field ab;
-	unsigned short wDuration;
-	unsigned short wTimeStampOff;
-} __attribute__ ((__packed__))
-STxDataHead_ab, *PSTxDataHead_ab;
-typedef const STxDataHead_ab *PCSTxDataHead_ab;
-
 typedef struct tagSTxDataHead_a_FB {
 	struct vnt_phy_field a;
 	unsigned short wDuration;
diff --git a/drivers/staging/vt6655/rxtx.c b/drivers/staging/vt6655/rxtx.c
index d8e3347..627cacb 100644
--- a/drivers/staging/vt6655/rxtx.c
+++ b/drivers/staging/vt6655/rxtx.c
@@ -760,32 +760,32 @@ s_uFillDataHead(
 			pBuf->wTimeStampOff = vnt_time_stamp_off(pDevice, wCurrentRate);
 			return pBuf->wDuration;
 		} else {
-			PSTxDataHead_ab pBuf = (PSTxDataHead_ab)pTxDataHead;
+			struct vnt_tx_datahead_ab *buf = pTxDataHead;
 			/* Get SignalField, ServiceField & Length */
 			vnt_get_phy_field(pDevice, cbFrameLength, wCurrentRate,
-					  byPktType, &pBuf->ab);
-			//Get Duration and TimeStampOff
+					  byPktType, &buf->ab);
 
-			pBuf->wDuration = cpu_to_le16((unsigned short)s_uGetDataDuration(pDevice, DATADUR_A, cbFrameLength, byPktType,
-											 wCurrentRate, bNeedAck, uFragIdx,
-											 cbLastFragmentSize, uMACfragNum,
-											 byFBOption));
+			/* Get Duration and TimeStampOff */
+			buf->duration = cpu_to_le16((u16)s_uGetDataDuration(pDevice, DATADUR_A, cbFrameLength, byPktType,
+									    wCurrentRate, bNeedAck, uFragIdx,
+									    cbLastFragmentSize, uMACfragNum,
+									    byFBOption));
 
-			pBuf->wTimeStampOff = vnt_time_stamp_off(pDevice, wCurrentRate);
-			return pBuf->wDuration;
+			buf->time_stamp_off = vnt_time_stamp_off(pDevice, wCurrentRate);
+			return buf->duration;
 		}
 	} else {
-		PSTxDataHead_ab pBuf = (PSTxDataHead_ab)pTxDataHead;
+		struct vnt_tx_datahead_ab *buf = pTxDataHead;
 		/* Get SignalField, ServiceField & Length */
 		vnt_get_phy_field(pDevice, cbFrameLength, wCurrentRate,
-				  byPktType, &pBuf->ab);
-		//Get Duration and TimeStampOff
-		pBuf->wDuration = cpu_to_le16((unsigned short)s_uGetDataDuration(pDevice, DATADUR_B, cbFrameLength, byPktType,
-										 wCurrentRate, bNeedAck, uFragIdx,
-										 cbLastFragmentSize, uMACfragNum,
-										 byFBOption));
-		pBuf->wTimeStampOff = vnt_time_stamp_off(pDevice, wCurrentRate);
-		return pBuf->wDuration;
+				  byPktType, &buf->ab);
+		/* Get Duration and TimeStampOff */
+		buf->duration = cpu_to_le16((u16)s_uGetDataDuration(pDevice, DATADUR_B, cbFrameLength, byPktType,
+								    wCurrentRate, bNeedAck, uFragIdx,
+								    cbLastFragmentSize, uMACfragNum,
+								    byFBOption));
+		buf->time_stamp_off = vnt_time_stamp_off(pDevice, wCurrentRate);
+		return buf->duration;
 	}
 	return 0;
 }
@@ -1356,15 +1356,18 @@ s_cbFillTxBufHead(struct vnt_private *pDevice, unsigned char byPktType,
 				pMICHDR = (struct vnt_mic_hdr *) (pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_ab));
 				pvRTS = (PSRTS_ab) (pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_ab) + cbMICHDR);
 				pvCTS = NULL;
-				pvTxDataHd = (PSTxDataHead_ab) (pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_ab) + cbMICHDR + sizeof(SRTS_ab));
-				cbHeaderLength = wTxBufSize + sizeof(struct vnt_rrv_time_ab) + cbMICHDR + sizeof(SRTS_ab) + sizeof(STxDataHead_ab);
+				pvTxDataHd = (void *)(pbyTxBufferAddr + wTxBufSize +
+					sizeof(struct vnt_rrv_time_ab) + cbMICHDR + sizeof(SRTS_ab));
+				cbHeaderLength = wTxBufSize + sizeof(struct vnt_rrv_time_ab) +
+					cbMICHDR + sizeof(SRTS_ab) + sizeof(struct vnt_tx_datahead_ab);
 			} else { //RTS_needless, need MICHDR
 				pvRrvTime = (void *)(pbyTxBufferAddr + wTxBufSize);
 				pMICHDR = (struct vnt_mic_hdr *) (pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_ab));
 				pvRTS = NULL;
 				pvCTS = NULL;
-				pvTxDataHd = (PSTxDataHead_ab) (pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_ab) + cbMICHDR);
-				cbHeaderLength = wTxBufSize + sizeof(struct vnt_rrv_time_ab) + cbMICHDR + sizeof(STxDataHead_ab);
+				pvTxDataHd = (void *)(pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_ab) + cbMICHDR);
+				cbHeaderLength = wTxBufSize + sizeof(struct vnt_rrv_time_ab) +
+					cbMICHDR + sizeof(struct vnt_tx_datahead_ab);
 			}
 		} else {
 			// Auto Fall Back
@@ -2201,8 +2204,10 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice, PSTxMgmtPacket pPacket)
 		pMICHDR = NULL;
 		pvRTS = NULL;
 		pCTS = NULL;
-		pvTxDataHd = (PSTxDataHead_ab) (pbyTxBufferAddr + wTxBufSize + sizeof(struct vnt_rrv_time_ab));
-		cbHeaderSize = wTxBufSize + sizeof(struct vnt_rrv_time_ab) + sizeof(STxDataHead_ab);
+		pvTxDataHd = (void *)(pbyTxBufferAddr + wTxBufSize +
+			sizeof(struct vnt_rrv_time_ab));
+		cbHeaderSize = wTxBufSize + sizeof(struct vnt_rrv_time_ab) +
+			sizeof(struct vnt_tx_datahead_ab);
 	}
 
 	memset((void *)(pbyTxBufferAddr + wTxBufSize), 0, (cbHeaderSize - wTxBufSize));
@@ -2297,7 +2302,7 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice, PSTxMgmtPacket pPacket)
 			((struct vnt_tx_datahead_g *)pvTxDataHd)->duration_a = cpu_to_le16(pPacket->p80211Header->sA2.wDurationID);
 			((struct vnt_tx_datahead_g *)pvTxDataHd)->duration_b = cpu_to_le16(pPacket->p80211Header->sA2.wDurationID);
 		} else {
-			((PSTxDataHead_ab)pvTxDataHd)->wDuration = cpu_to_le16(pPacket->p80211Header->sA2.wDurationID);
+			((struct vnt_tx_datahead_ab *)pvTxDataHd)->duration = cpu_to_le16(pPacket->p80211Header->sA2.wDurationID);
 		}
 	}
 
@@ -2692,10 +2697,10 @@ void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb,
 				wTxBufSize + sizeof(struct vnt_rrv_time_ab));
 		pvRTS = NULL;
 		pvCTS = NULL;
-		pvTxDataHd = (PSTxDataHead_ab) (pbyTxBufferAddr +
+		pvTxDataHd = (void *)(pbyTxBufferAddr +
 			wTxBufSize + sizeof(struct vnt_rrv_time_ab) + cbMICHDR);
 		cbHeaderSize = wTxBufSize + sizeof(struct vnt_rrv_time_ab) +
-					cbMICHDR + sizeof(STxDataHead_ab);
+				cbMICHDR + sizeof(struct vnt_tx_datahead_ab);
 
 	}
 
@@ -2823,7 +2828,7 @@ void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb,
 			((struct vnt_tx_datahead_g *)pvTxDataHd)->duration_a = cpu_to_le16(p80211Header->sA2.wDurationID);
 			((struct vnt_tx_datahead_g *)pvTxDataHd)->duration_b = cpu_to_le16(p80211Header->sA2.wDurationID);
 		} else {
-			((PSTxDataHead_ab)pvTxDataHd)->wDuration = cpu_to_le16(p80211Header->sA2.wDurationID);
+			((struct vnt_tx_datahead_ab *)pvTxDataHd)->duration = cpu_to_le16(p80211Header->sA2.wDurationID);
 		}
 	}
 
diff --git a/drivers/staging/vt6655/rxtx.h b/drivers/staging/vt6655/rxtx.h
index 212c2ef..4899f6e 100644
--- a/drivers/staging/vt6655/rxtx.h
+++ b/drivers/staging/vt6655/rxtx.h
@@ -99,6 +99,12 @@ struct vnt_tx_datahead_g_fb {
 	__le16 time_stamp_off_a;
 } __packed;
 
+struct vnt_tx_datahead_ab {
+	struct vnt_phy_field ab;
+	__le16 duration;
+	__le16 time_stamp_off;
+} __packed;
+
 struct vnt_tx_short_buf_head {
 	__le16 fifo_ctl;
 	u16 time_stamp;
-- 
1.9.1

