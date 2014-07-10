Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:34690 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354AbaGJS45 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2014 14:56:57 -0400
Received: by mail-we0-f175.google.com with SMTP id k48so6248wev.6
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jul 2014 11:56:56 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 08/16] staging: vt6656: s_vGenerateTxParameter parse out vnt_rrv_time_ab
Date: Thu, 10 Jul 2014 19:56:09 +0100
Message-Id: <1405018577-6832-8-git-send-email-tvboxspy@gmail.com> (sfid-20140710_205703_231487_09BA1557)
In-Reply-To: <1405018577-6832-1-git-send-email-tvboxspy@gmail.com>
References: <1405018577-6832-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

create new function vnt_rxtx_ab which will eventually carry onward
functions

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 59 ++++++++++++++++++++++---------------------
 1 file changed, 30 insertions(+), 29 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index bad2fe4..758f69e 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -669,6 +669,28 @@ static u16 vnt_rxtx_cts(struct vnt_usb_send_context *tx_context,
 	return 0;
 }
 
+static u16 vnt_rxtx_ab(struct vnt_usb_send_context *tx_context,
+	union vnt_tx_head *tx_head, u8 pkt_type, u32 frame_size,
+	int need_ack, u16 current_rate, bool need_rts)
+{
+	struct vnt_private *priv = tx_context->priv;
+	struct vnt_rrv_time_ab *buf = &tx_head->tx_ab.ab;
+
+	buf->rrv_time = vnt_rxtx_rsvtime_le16(priv, pkt_type,
+			frame_size, current_rate, need_ack);
+
+	if (need_rts) {
+		if (pkt_type == PK_TYPE_11B)
+			buf->rts_rrv_time = s_uGetRTSCTSRsvTime(priv, 0,
+				pkt_type, frame_size, current_rate);
+		else /* PK_TYPE_11A */
+			buf->rts_rrv_time = s_uGetRTSCTSRsvTime(priv, 2,
+				pkt_type, frame_size, current_rate);
+	}
+
+	return 0;
+}
+
 /*+
  *
  * Description:
@@ -696,7 +718,6 @@ static u16 s_vGenerateTxParameter(struct vnt_usb_send_context *tx_context,
 	struct vnt_mic_hdr **mic_hdr, u32 need_mic, u32 cbFrameSize,
 	int bNeedACK, bool need_rts)
 {
-	struct vnt_private *pDevice = tx_context->priv;
 	union vnt_tx_data_head *head = NULL;
 
 	if (byPktType == PK_TYPE_11GB || byPktType == PK_TYPE_11GA) {
@@ -742,26 +763,17 @@ static u16 s_vGenerateTxParameter(struct vnt_usb_send_context *tx_context,
 		}
 
 		if (need_rts) {
-			struct vnt_rrv_time_ab *pBuf = &tx_buffer->
-							tx_head.tx_ab.ab;
-
-			pBuf->rts_rrv_time = s_uGetRTSCTSRsvTime(pDevice, 2,
-				byPktType, cbFrameSize, wCurrentRate);
+			vnt_rxtx_ab(tx_context, &tx_buffer->tx_head, byPktType,
+				cbFrameSize, bNeedACK, wCurrentRate, need_rts);
 
-			pBuf->rrv_time = vnt_rxtx_rsvtime_le16(pDevice,
-				byPktType, cbFrameSize, wCurrentRate, bNeedACK);
 
 			/* Fill RTS */
 			return s_vFillRTSHead(tx_context, byPktType, head,
 						cbFrameSize, bNeedACK,
 						wCurrentRate);
 		} else {
-			struct vnt_rrv_time_ab *pBuf = &tx_buffer->
-							tx_head.tx_ab.ab;
-
-			pBuf->rrv_time = vnt_rxtx_rsvtime_le16(pDevice,
-				byPktType, cbFrameSize,
-					wCurrentRate, bNeedACK);
+			vnt_rxtx_ab(tx_context, &tx_buffer->tx_head, byPktType,
+				cbFrameSize, bNeedACK, wCurrentRate, need_rts);
 
 			return vnt_rxtx_datahead_a_fb(tx_context, byPktType,
 				wCurrentRate, &head->data_head_a_fb,
@@ -776,27 +788,16 @@ static u16 s_vGenerateTxParameter(struct vnt_usb_send_context *tx_context,
 		}
 
 		if (need_rts) {
-			struct vnt_rrv_time_ab *pBuf = &tx_buffer->
-							tx_head.tx_ab.ab;
-
-			pBuf->rts_rrv_time = s_uGetRTSCTSRsvTime(pDevice, 0,
-				byPktType, cbFrameSize, wCurrentRate);
-
-			pBuf->rrv_time = vnt_rxtx_rsvtime_le16(pDevice,
-				byPktType, cbFrameSize, wCurrentRate,
-								bNeedACK);
+			vnt_rxtx_ab(tx_context, &tx_buffer->tx_head, byPktType,
+				cbFrameSize, bNeedACK, wCurrentRate, need_rts);
 
 			/* Fill RTS */
 			return s_vFillRTSHead(tx_context, byPktType, head,
 						cbFrameSize, bNeedACK,
 						wCurrentRate);
 		} else {
-			struct vnt_rrv_time_ab *pBuf = &tx_buffer->
-							tx_head.tx_ab.ab;
-
-			pBuf->rrv_time = vnt_rxtx_rsvtime_le16(pDevice,
-				byPktType, cbFrameSize,
-					wCurrentRate, bNeedACK);
+			vnt_rxtx_ab(tx_context, &tx_buffer->tx_head, byPktType,
+				cbFrameSize, bNeedACK, wCurrentRate, need_rts);
 
 			return vnt_rxtx_datahead_ab(tx_context, byPktType,
 				wCurrentRate, &head->data_head_ab,
-- 
1.9.1

