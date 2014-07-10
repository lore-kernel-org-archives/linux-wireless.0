Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:37568 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874AbaGJS5E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2014 14:57:04 -0400
Received: by mail-wg0-f42.google.com with SMTP id l18so6165wgh.13
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jul 2014 11:57:02 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 11/16] staging: vt6656: merge data positions for packet types a and b into vnt_rxtx_ab
Date: Thu, 10 Jul 2014 19:56:12 +0100
Message-Id: <1405018577-6832-11-git-send-email-tvboxspy@gmail.com> (sfid-20140710_205712_446194_FAAA20B7)
In-Reply-To: <1405018577-6832-1-git-send-email-tvboxspy@gmail.com>
References: <1405018577-6832-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

add rts positions from s_vFillRTSHead

add need_mic and remaining union vnt_tx_data_head head positions from
s_vGenerateTxParameter for packet type PK_TYPE_11A and PK_TYPE_11B..

As there are no other possibilities for packet types in  s_vGenerateTxParameter
the if becomes else.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 109 ++++++++++--------------------------------
 1 file changed, 25 insertions(+), 84 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index c8a38c5..6113807 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -98,10 +98,6 @@ static u16 s_vFillCTSHead(struct vnt_usb_send_context *tx_context,
 	u8 byPktType, union vnt_tx_data_head *head, u32 cbFrameLength,
 	int bNeedAck, u16 wCurrentRate);
 
-static u16 s_vFillRTSHead(struct vnt_usb_send_context *tx_context, u8 byPktType,
-	union vnt_tx_data_head *head, u32 cbFrameLength, int bNeedAck,
-	u16 wCurrentRate);
-
 static __le16 s_uGetDataDuration(struct vnt_private *pDevice,
 	u8 byPktType, int bNeedAck);
 
@@ -528,36 +524,6 @@ static u16 vnt_rxtx_rts_a_fb_head(struct vnt_usb_send_context *tx_context,
 			&buf->data_head, frame_len, need_ack);
 }
 
-static u16 s_vFillRTSHead(struct vnt_usb_send_context *tx_context, u8 byPktType,
-	union vnt_tx_data_head *head, u32 cbFrameLength, int bNeedAck,
-	u16 wCurrentRate)
-{
-
-	if (!head)
-		return 0;
-
-	/* Note: So far RTSHead doesn't appear in ATIM
-	*	& Beacom DMA, so we don't need to take them
-	*	into account.
-	*	Otherwise, we need to modified codes for them.
-	*/
-	switch (byPktType) {
-	case PK_TYPE_11A:
-		if (tx_context->fb_option) {
-			return vnt_rxtx_rts_a_fb_head(tx_context,
-				&head->rts_a_fb, byPktType,
-				cbFrameLength, bNeedAck, wCurrentRate);
-			break;
-		}
-	case PK_TYPE_11B:
-		return vnt_rxtx_rts_ab_head(tx_context, &head->rts_ab,
-				byPktType, cbFrameLength, bNeedAck,
-						wCurrentRate);
-	}
-
-	return 0;
-}
-
 static u16 s_vFillCTSHead(struct vnt_usb_send_context *tx_context,
 	u8 byPktType, union vnt_tx_data_head *head, u32 cbFrameLength,
 	int bNeedAck, u16 wCurrentRate)
@@ -676,14 +642,18 @@ static u16 vnt_rxtx_cts(struct vnt_usb_send_context *tx_context,
 
 static u16 vnt_rxtx_ab(struct vnt_usb_send_context *tx_context,
 	union vnt_tx_head *tx_head, u8 pkt_type, u32 frame_size,
-	int need_ack, u16 current_rate, bool need_rts)
+	int need_ack, u16 current_rate, bool need_rts, bool need_mic)
 {
 	struct vnt_private *priv = tx_context->priv;
 	struct vnt_rrv_time_ab *buf = &tx_head->tx_ab.ab;
+	union vnt_tx_data_head *head = &tx_head->tx_ab.tx.head;
 
 	buf->rrv_time = vnt_rxtx_rsvtime_le16(priv, pkt_type,
 			frame_size, current_rate, need_ack);
 
+	if (need_mic)
+		head = &tx_head->tx_ab.tx.mic.head;
+
 	if (need_rts) {
 		if (pkt_type == PK_TYPE_11B)
 			buf->rts_rrv_time = s_uGetRTSCTSRsvTime(priv, 0,
@@ -691,9 +661,23 @@ static u16 vnt_rxtx_ab(struct vnt_usb_send_context *tx_context,
 		else /* PK_TYPE_11A */
 			buf->rts_rrv_time = s_uGetRTSCTSRsvTime(priv, 2,
 				pkt_type, frame_size, current_rate);
+
+		if (tx_context->fb_option && pkt_type == PK_TYPE_11A)
+			return vnt_rxtx_rts_a_fb_head(tx_context,
+					&head->rts_a_fb, pkt_type, frame_size,
+					need_ack, current_rate);
+
+		return vnt_rxtx_rts_ab_head(tx_context, &head->rts_ab,
+				pkt_type, frame_size, need_ack, current_rate);
 	}
 
-	return 0;
+	if (pkt_type == PK_TYPE_11A)
+		return vnt_rxtx_datahead_a_fb(tx_context, pkt_type,
+			current_rate, &head->data_head_a_fb,
+				frame_size, need_ack);
+
+	return vnt_rxtx_datahead_ab(tx_context, pkt_type, current_rate,
+				&head->data_head_ab, frame_size, need_ack);
 }
 
 /*+
@@ -723,7 +707,6 @@ static u16 s_vGenerateTxParameter(struct vnt_usb_send_context *tx_context,
 	struct vnt_mic_hdr **mic_hdr, u32 need_mic, u32 cbFrameSize,
 	int bNeedACK, bool need_rts)
 {
-	union vnt_tx_data_head *head = NULL;
 
 	if (byPktType == PK_TYPE_11GB || byPktType == PK_TYPE_11GA) {
 		if (need_rts) {
@@ -743,55 +726,13 @@ static u16 s_vGenerateTxParameter(struct vnt_usb_send_context *tx_context,
 					byPktType, cbFrameSize, bNeedACK,
 						wCurrentRate, need_mic);
 		}
-	} else if (byPktType == PK_TYPE_11A) {
-		if (need_mic) {
-			*mic_hdr = &tx_buffer->tx_head.tx_ab.tx.mic.hdr;
-			head = &tx_buffer->tx_head.tx_ab.tx.mic.head;
-		} else {
-			head = &tx_buffer->tx_head.tx_ab.tx.head;
-		}
-
-		if (need_rts) {
-			vnt_rxtx_ab(tx_context, &tx_buffer->tx_head, byPktType,
-				cbFrameSize, bNeedACK, wCurrentRate, need_rts);
-
-
-			/* Fill RTS */
-			return s_vFillRTSHead(tx_context, byPktType, head,
-						cbFrameSize, bNeedACK,
-						wCurrentRate);
-		} else {
-			vnt_rxtx_ab(tx_context, &tx_buffer->tx_head, byPktType,
-				cbFrameSize, bNeedACK, wCurrentRate, need_rts);
-
-			return vnt_rxtx_datahead_a_fb(tx_context, byPktType,
-				wCurrentRate, &head->data_head_a_fb,
-						cbFrameSize, bNeedACK);
-		}
-	} else if (byPktType == PK_TYPE_11B) {
-		if (need_mic) {
+	} else {
+		if (need_mic)
 			*mic_hdr = &tx_buffer->tx_head.tx_ab.tx.mic.hdr;
-			head = &tx_buffer->tx_head.tx_ab.tx.mic.head;
-		} else {
-			head = &tx_buffer->tx_head.tx_ab.tx.head;
-		}
 
-		if (need_rts) {
-			vnt_rxtx_ab(tx_context, &tx_buffer->tx_head, byPktType,
-				cbFrameSize, bNeedACK, wCurrentRate, need_rts);
-
-			/* Fill RTS */
-			return s_vFillRTSHead(tx_context, byPktType, head,
-						cbFrameSize, bNeedACK,
-						wCurrentRate);
-		} else {
-			vnt_rxtx_ab(tx_context, &tx_buffer->tx_head, byPktType,
-				cbFrameSize, bNeedACK, wCurrentRate, need_rts);
-
-			return vnt_rxtx_datahead_ab(tx_context, byPktType,
-				wCurrentRate, &head->data_head_ab,
-					cbFrameSize, bNeedACK);
-		}
+		return vnt_rxtx_ab(tx_context, &tx_buffer->tx_head,
+					byPktType, cbFrameSize, bNeedACK,
+					wCurrentRate, need_rts, need_mic);
 	}
 
 	return 0;
-- 
1.9.1

