Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:60401 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771Ab3JAO7A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Oct 2013 10:59:00 -0400
Received: by mail-we0-f179.google.com with SMTP id x55so7257198wes.24
        for <linux-wireless@vger.kernel.org>; Tue, 01 Oct 2013 07:58:59 -0700 (PDT)
Message-ID: <1380639534.2087.5.camel@canaries64-MCP7A> (sfid-20131001_165905_563854_2394656A)
Subject: [PATCH 5/8] staging: vt6656: rxtx.c add no rts  struct
 vnt_tx_datahead_a_fb
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Tue, 01 Oct 2013 15:58:54 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add no rts/cts vnt_tx_datahead_a_fb to union vnt_tx_data_head.

The need_mic now applies to all modes of packet type PK_TYPE_11A.

and return vnt_rxtx_datahead_a_fb in s_vGenerateTxParameter

This removes pvTxDataHd pointer assignment.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 30 ++++++++++--------------------
 drivers/staging/vt6656/rxtx.h |  2 ++
 2 files changed, 12 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index b2c4786..1d02724 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -579,13 +579,6 @@ static u32 s_uFillDataHead(struct vnt_private *pDevice,
     }
 
     if (byPktType == PK_TYPE_11A) {
-	if (byFBOption != AUTO_FB_NONE) {
-		struct vnt_tx_datahead_a_fb *pBuf =
-			(struct vnt_tx_datahead_a_fb *)pTxDataHead;
-
-		return vnt_rxtx_datahead_a_fb(pDevice, byPktType, wCurrentRate,
-					pBuf, cbFrameLength, bNeedAck);
-        } else {
 		struct vnt_tx_datahead_ab *pBuf =
 			(struct vnt_tx_datahead_ab *)pTxDataHead;
             //Get SignalField,ServiceField,Length
@@ -597,7 +590,6 @@ static u32 s_uFillDataHead(struct vnt_private *pDevice,
 		pBuf->wTimeStampOff = vnt_time_stamp_off(pDevice,
 								wCurrentRate);
             return (pBuf->wDuration);
-        }
     }
     else if (byPktType == PK_TYPE_11B) {
 		struct vnt_tx_datahead_ab *pBuf =
@@ -938,6 +930,13 @@ static u16 s_vGenerateTxParameter(struct vnt_private *pDevice,
         }
     }
     else if (byPktType == PK_TYPE_11A) {
+	if (need_mic) {
+		*mic_hdr = &tx_buffer->tx_head.tx_ab.tx.mic.hdr;
+		head = &tx_buffer->tx_head.tx_ab.tx.mic.head;
+	} else {
+		head = &tx_buffer->tx_head.tx_ab.tx.head;
+	}
+
 	if (need_rts) {
             //Fill RsvTime
 		struct vnt_rrv_time_ab *pBuf = &tx_buffer->tx_head.tx_ab.ab;
@@ -947,13 +946,6 @@ static u16 s_vGenerateTxParameter(struct vnt_private *pDevice,
 		pBuf->wTxRrvTime = vnt_rxtx_rsvtime_le16(pDevice, byPktType,
 				cbFrameSize, wCurrentRate, bNeedACK);
 
-		if (need_mic) {
-			*mic_hdr = &tx_buffer->tx_head.tx_ab.tx.mic.hdr;
-			head = &tx_buffer->tx_head.tx_ab.tx.mic.head;
-		} else {
-			head = &tx_buffer->tx_head.tx_ab.tx.head;
-		}
-
 		/* Fill RTS */
 		s_vFillRTSHead(pDevice, byPktType, head, cbFrameSize,
 			bNeedACK, psEthHeader, wCurrentRate, byFBOption);
@@ -961,11 +953,11 @@ static u16 s_vGenerateTxParameter(struct vnt_private *pDevice,
             //Fill RsvTime
 		struct vnt_rrv_time_ab *pBuf = &tx_buffer->tx_head.tx_ab.ab;
 
-		if (need_mic)
-			*mic_hdr = &tx_buffer->tx_head.tx_ab.tx.mic.hdr;
-
 		pBuf->wTxRrvTime = vnt_rxtx_rsvtime_le16(pDevice, PK_TYPE_11A,
 			cbFrameSize, wCurrentRate, bNeedACK);
+
+		return vnt_rxtx_datahead_a_fb(pDevice, byPktType, wCurrentRate,
+			&head->data_head_a_fb, cbFrameSize, bNeedACK);
         }
     }
     else if (byPktType == PK_TYPE_11B) {
@@ -1207,8 +1199,6 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
 			cbMICHDR + sizeof(struct vnt_rts_a_fb);
             }
             else if (bRTS == false) { //RTS_needless
-		pvTxDataHd = (struct vnt_tx_datahead_a_fb *)(pbyTxBufferAddr +
-			wTxBufSize + sizeof(struct vnt_rrv_time_ab) + cbMICHDR);
 		cbHeaderLength = wTxBufSize + sizeof(struct vnt_rrv_time_ab) +
 			cbMICHDR + sizeof(struct vnt_tx_datahead_a_fb);
             }
diff --git a/drivers/staging/vt6656/rxtx.h b/drivers/staging/vt6656/rxtx.h
index 3fd8507..d8f25d1 100644
--- a/drivers/staging/vt6656/rxtx.h
+++ b/drivers/staging/vt6656/rxtx.h
@@ -183,6 +183,8 @@ union vnt_tx_data_head {
 	/* cts g */
 	struct vnt_cts cts_g;
 	struct vnt_cts_fb cts_g_fb;
+	/* no rts/cts */
+	struct vnt_tx_datahead_a_fb data_head_a_fb;
 };
 
 struct vnt_tx_mic_hdr {
-- 
1.8.3.2

