Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:35576 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266Ab3JGTOL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Oct 2013 15:14:11 -0400
Received: by mail-wg0-f48.google.com with SMTP id n12so7587552wgh.3
        for <linux-wireless@vger.kernel.org>; Mon, 07 Oct 2013 12:14:10 -0700 (PDT)
Message-ID: <1381173241.6262.2.camel@canaries64-MCP7A> (sfid-20131007_211415_762705_8B437B10)
Subject: [PATCH] staging: vt6656: rxtx.c cleanup s_vGenerateTxParameter
From: Malcolm Priestley <tvboxspy@gmail.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 07 Oct 2013 20:14:01 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove white space and commented out code.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 222 ++++++++++++++++++++++--------------------
 1 file changed, 115 insertions(+), 107 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 93eba18..821b2e1 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -835,139 +835,147 @@ static u16 s_vGenerateTxParameter(struct vnt_private *pDevice,
 	u16 wFifoCtl;
 	u8 byFBOption = AUTO_FB_NONE;
 
-    //DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"s_vGenerateTxParameter...\n");
-    pFifoHead->wReserved = wCurrentRate;
-    wFifoCtl = pFifoHead->wFIFOCtl;
+	pFifoHead->wReserved = wCurrentRate;
+	wFifoCtl = pFifoHead->wFIFOCtl;
 
-    if (wFifoCtl & FIFOCTL_AUTO_FB_0) {
-        byFBOption = AUTO_FB_0;
-    }
-    else if (wFifoCtl & FIFOCTL_AUTO_FB_1) {
-        byFBOption = AUTO_FB_1;
-    }
+	if (wFifoCtl & FIFOCTL_AUTO_FB_0)
+		byFBOption = AUTO_FB_0;
+	else if (wFifoCtl & FIFOCTL_AUTO_FB_1)
+		byFBOption = AUTO_FB_1;
 
 	if (!pFifoHead)
 		return 0;
 
-    if (pDevice->bLongHeader)
-        cbMACHdLen = WLAN_HDR_ADDR3_LEN + 6;
-
-    if (byPktType == PK_TYPE_11GB || byPktType == PK_TYPE_11GA) {
-	if (need_rts) {
-            //Fill RsvTime
-		struct vnt_rrv_time_rts *pBuf = &tx_buffer->tx_head.tx_rts.rts;
+	if (pDevice->bLongHeader)
+		cbMACHdLen = WLAN_HDR_ADDR3_LEN + 6;
 
-		pBuf->wRTSTxRrvTime_aa = s_uGetRTSCTSRsvTime(pDevice, 2,
-				byPktType, cbFrameSize, wCurrentRate);
-		pBuf->wRTSTxRrvTime_ba = s_uGetRTSCTSRsvTime(pDevice, 1,
-				byPktType, cbFrameSize, wCurrentRate);
-		pBuf->wRTSTxRrvTime_bb = s_uGetRTSCTSRsvTime(pDevice, 0,
+	if (byPktType == PK_TYPE_11GB || byPktType == PK_TYPE_11GA) {
+		if (need_rts) {
+			struct vnt_rrv_time_rts *pBuf =
+					&tx_buffer->tx_head.tx_rts.rts;
+
+			pBuf->wRTSTxRrvTime_aa = s_uGetRTSCTSRsvTime(pDevice, 2,
+					byPktType, cbFrameSize, wCurrentRate);
+			pBuf->wRTSTxRrvTime_ba = s_uGetRTSCTSRsvTime(pDevice, 1,
+					byPktType, cbFrameSize, wCurrentRate);
+			pBuf->wRTSTxRrvTime_bb = s_uGetRTSCTSRsvTime(pDevice, 0,
 				byPktType, cbFrameSize, wCurrentRate);
-		pBuf->wTxRrvTime_a = vnt_rxtx_rsvtime_le16(pDevice,
-			byPktType, cbFrameSize, wCurrentRate, bNeedACK);
-		pBuf->wTxRrvTime_b = vnt_rxtx_rsvtime_le16(pDevice,
-			PK_TYPE_11B, cbFrameSize, pDevice->byTopCCKBasicRate,
-				bNeedACK);
 
-		if (need_mic) {
-			*mic_hdr = &tx_buffer->tx_head.tx_rts.tx.mic.hdr;
-			head = &tx_buffer->tx_head.tx_rts.tx.mic.head;
-		} else {
-			head = &tx_buffer->tx_head.tx_rts.tx.head;
-		}
+			pBuf->wTxRrvTime_a = vnt_rxtx_rsvtime_le16(pDevice,
+				byPktType, cbFrameSize, wCurrentRate, bNeedACK);
+			pBuf->wTxRrvTime_b = vnt_rxtx_rsvtime_le16(pDevice,
+					PK_TYPE_11B, cbFrameSize,
+					pDevice->byTopCCKBasicRate, bNeedACK);
+
+			if (need_mic) {
+				*mic_hdr = &tx_buffer->
+						tx_head.tx_rts.tx.mic.hdr;
+				head = &tx_buffer->tx_head.tx_rts.tx.mic.head;
+			} else {
+				head = &tx_buffer->tx_head.tx_rts.tx.head;
+			}
 
-		/* Fill RTS */
-		return s_vFillRTSHead(pDevice, byPktType, head, cbFrameSize,
-			bNeedACK, psEthHeader, wCurrentRate, byFBOption);
-        }
-        else {//RTS_needless, PCF mode
-            //Fill RsvTime
-		struct vnt_rrv_time_cts *pBuf = &tx_buffer->tx_head.tx_cts.cts;
-
-		pBuf->wTxRrvTime_a = vnt_rxtx_rsvtime_le16(pDevice, byPktType,
-			cbFrameSize, wCurrentRate, bNeedACK);
-		pBuf->wTxRrvTime_b = vnt_rxtx_rsvtime_le16(pDevice,
-			PK_TYPE_11B, cbFrameSize,
-			pDevice->byTopCCKBasicRate, bNeedACK);
-		pBuf->wCTSTxRrvTime_ba = s_uGetRTSCTSRsvTime(pDevice, 3,
-				byPktType, cbFrameSize, wCurrentRate);
+			/* Fill RTS */
+			return s_vFillRTSHead(pDevice, byPktType, head,
+					cbFrameSize, bNeedACK, psEthHeader,
+						wCurrentRate, byFBOption);
 
+		} else {
+			struct vnt_rrv_time_cts *pBuf = &tx_buffer->
+							tx_head.tx_cts.cts;
+
+			pBuf->wTxRrvTime_a = vnt_rxtx_rsvtime_le16(pDevice,
+				byPktType, cbFrameSize, wCurrentRate, bNeedACK);
+			pBuf->wTxRrvTime_b = vnt_rxtx_rsvtime_le16(pDevice,
+				PK_TYPE_11B, cbFrameSize,
+					pDevice->byTopCCKBasicRate, bNeedACK);
+
+			pBuf->wCTSTxRrvTime_ba = s_uGetRTSCTSRsvTime(pDevice, 3,
+					byPktType, cbFrameSize, wCurrentRate);
+
+			if (need_mic) {
+				*mic_hdr = &tx_buffer->
+						tx_head.tx_cts.tx.mic.hdr;
+				head = &tx_buffer->tx_head.tx_cts.tx.mic.head;
+			} else {
+				head = &tx_buffer->tx_head.tx_cts.tx.head;
+			}
+
+			/* Fill CTS */
+			return s_vFillCTSHead(pDevice, uDMAIdx, byPktType,
+				head, cbFrameSize, bNeedACK, wCurrentRate,
+					byFBOption);
+		}
+	} else if (byPktType == PK_TYPE_11A) {
 		if (need_mic) {
-			*mic_hdr = &tx_buffer->tx_head.tx_cts.tx.mic.hdr;
-			head = &tx_buffer->tx_head.tx_cts.tx.mic.head;
+			*mic_hdr = &tx_buffer->tx_head.tx_ab.tx.mic.hdr;
+			head = &tx_buffer->tx_head.tx_ab.tx.mic.head;
 		} else {
-			head = &tx_buffer->tx_head.tx_cts.tx.head;
+			head = &tx_buffer->tx_head.tx_ab.tx.head;
 		}
 
-		/* Fill CTS */
-		return s_vFillCTSHead(pDevice, uDMAIdx, byPktType, head,
-			cbFrameSize, bNeedACK, wCurrentRate, byFBOption);
-        }
-    }
-    else if (byPktType == PK_TYPE_11A) {
-	if (need_mic) {
-		*mic_hdr = &tx_buffer->tx_head.tx_ab.tx.mic.hdr;
-		head = &tx_buffer->tx_head.tx_ab.tx.mic.head;
-	} else {
-		head = &tx_buffer->tx_head.tx_ab.tx.head;
-	}
-
-	if (need_rts) {
-            //Fill RsvTime
-		struct vnt_rrv_time_ab *pBuf = &tx_buffer->tx_head.tx_ab.ab;
+		if (need_rts) {
+			struct vnt_rrv_time_ab *pBuf = &tx_buffer->
+							tx_head.tx_ab.ab;
 
-		pBuf->wRTSTxRrvTime = s_uGetRTSCTSRsvTime(pDevice, 2,
+			pBuf->wRTSTxRrvTime = s_uGetRTSCTSRsvTime(pDevice, 2,
 				byPktType, cbFrameSize, wCurrentRate);
-		pBuf->wTxRrvTime = vnt_rxtx_rsvtime_le16(pDevice, byPktType,
-				cbFrameSize, wCurrentRate, bNeedACK);
 
-		/* Fill RTS */
-		return s_vFillRTSHead(pDevice, byPktType, head, cbFrameSize,
-			bNeedACK, psEthHeader, wCurrentRate, byFBOption);
-	} else {
-            //Fill RsvTime
-		struct vnt_rrv_time_ab *pBuf = &tx_buffer->tx_head.tx_ab.ab;
+			pBuf->wTxRrvTime = vnt_rxtx_rsvtime_le16(pDevice,
+				byPktType, cbFrameSize, wCurrentRate, bNeedACK);
 
-		pBuf->wTxRrvTime = vnt_rxtx_rsvtime_le16(pDevice, PK_TYPE_11A,
-			cbFrameSize, wCurrentRate, bNeedACK);
+			/* Fill RTS */
+			return s_vFillRTSHead(pDevice, byPktType, head,
+				cbFrameSize, bNeedACK, psEthHeader,
+					wCurrentRate, byFBOption);
+		} else {
+			struct vnt_rrv_time_ab *pBuf = &tx_buffer->
+							tx_head.tx_ab.ab;
 
-		return vnt_rxtx_datahead_a_fb(pDevice, byPktType, wCurrentRate,
-			&head->data_head_a_fb, cbFrameSize, bNeedACK);
-        }
-    }
-    else if (byPktType == PK_TYPE_11B) {
-	if (need_mic) {
-		*mic_hdr = &tx_buffer->tx_head.tx_ab.tx.mic.hdr;
-		head = &tx_buffer->tx_head.tx_ab.tx.mic.head;
-	} else {
-		head = &tx_buffer->tx_head.tx_ab.tx.head;
-	}
+			pBuf->wTxRrvTime = vnt_rxtx_rsvtime_le16(pDevice,
+				PK_TYPE_11A, cbFrameSize,
+					wCurrentRate, bNeedACK);
 
-	if (need_rts) {
-            //Fill RsvTime
-		struct vnt_rrv_time_ab *pBuf = &tx_buffer->tx_head.tx_ab.ab;
+			return vnt_rxtx_datahead_a_fb(pDevice, byPktType,
+				wCurrentRate, &head->data_head_a_fb,
+						cbFrameSize, bNeedACK);
+		}
+	} else if (byPktType == PK_TYPE_11B) {
+		if (need_mic) {
+			*mic_hdr = &tx_buffer->tx_head.tx_ab.tx.mic.hdr;
+			head = &tx_buffer->tx_head.tx_ab.tx.mic.head;
+		} else {
+			head = &tx_buffer->tx_head.tx_ab.tx.head;
+		}
+
+		if (need_rts) {
+			struct vnt_rrv_time_ab *pBuf = &tx_buffer->
+							tx_head.tx_ab.ab;
 
-		pBuf->wRTSTxRrvTime = s_uGetRTSCTSRsvTime(pDevice, 0,
+			pBuf->wRTSTxRrvTime = s_uGetRTSCTSRsvTime(pDevice, 0,
 				byPktType, cbFrameSize, wCurrentRate);
-		pBuf->wTxRrvTime = vnt_rxtx_rsvtime_le16(pDevice, PK_TYPE_11B,
-				cbFrameSize, wCurrentRate, bNeedACK);
 
-		/* Fill RTS */
-		return s_vFillRTSHead(pDevice, byPktType, head, cbFrameSize,
+			pBuf->wTxRrvTime = vnt_rxtx_rsvtime_le16(pDevice,
+				PK_TYPE_11B, cbFrameSize, wCurrentRate,
+								bNeedACK);
+
+			/* Fill RTS */
+			return s_vFillRTSHead(pDevice, byPktType, head,
+				cbFrameSize,
 			bNeedACK, psEthHeader, wCurrentRate, byFBOption);
-        }
-        else { //RTS_needless, non PCF mode
-            //Fill RsvTime
-		struct vnt_rrv_time_ab *pBuf = &tx_buffer->tx_head.tx_ab.ab;
+		} else {
+			struct vnt_rrv_time_ab *pBuf = &tx_buffer->
+							tx_head.tx_ab.ab;
 
-		pBuf->wTxRrvTime = vnt_rxtx_rsvtime_le16(pDevice, PK_TYPE_11B,
-			cbFrameSize, wCurrentRate, bNeedACK);
+			pBuf->wTxRrvTime = vnt_rxtx_rsvtime_le16(pDevice,
+				PK_TYPE_11B, cbFrameSize,
+					wCurrentRate, bNeedACK);
 
-		return vnt_rxtx_datahead_ab(pDevice, byPktType, wCurrentRate,
-			&head->data_head_ab, cbFrameSize, bNeedACK);
-        }
-    }
-    //DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"s_vGenerateTxParameter END.\n");
+			return vnt_rxtx_datahead_ab(pDevice, byPktType,
+				wCurrentRate, &head->data_head_ab,
+					cbFrameSize, bNeedACK);
+		}
+	}
 
 	return 0;
 }
-- 
1.8.3.2

