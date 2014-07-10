Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:46021 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354AbaGJS47 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2014 14:56:59 -0400
Received: by mail-wi0-f177.google.com with SMTP id ho1so188967wib.16
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jul 2014 11:56:58 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 09/16] staging: vt6656: merge PK_TYPE_11GB and PK_TYPE_11GA into vnt_rxtx_rts
Date: Thu, 10 Jul 2014 19:56:10 +0100
Message-Id: <1405018577-6832-9-git-send-email-tvboxspy@gmail.com> (sfid-20140710_205705_717381_5653D008)
In-Reply-To: <1405018577-6832-1-git-send-email-tvboxspy@gmail.com>
References: <1405018577-6832-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

add to vnt_rxtx_rts calls from s_vFillRTSHead.

add need_mic and union vnt_tx_data_head head positions from s_vGenerateTxParameter.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 41 +++++++++++++++--------------------------
 1 file changed, 15 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 758f69e..0ff8b50 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -542,17 +542,6 @@ static u16 s_vFillRTSHead(struct vnt_usb_send_context *tx_context, u8 byPktType,
 	*	Otherwise, we need to modified codes for them.
 	*/
 	switch (byPktType) {
-	case PK_TYPE_11GB:
-	case PK_TYPE_11GA:
-		if (!tx_context->fb_option)
-			return vnt_rxtx_rts_g_head(tx_context, &head->rts_g,
-				byPktType, cbFrameLength,
-				bNeedAck, wCurrentRate);
-		else
-			return vnt_rxtx_rts_g_fb_head(tx_context,
-				&head->rts_g_fb, byPktType,
-				cbFrameLength, bNeedAck, wCurrentRate);
-		break;
 	case PK_TYPE_11A:
 		if (tx_context->fb_option) {
 			return vnt_rxtx_rts_a_fb_head(tx_context,
@@ -631,10 +620,11 @@ static u16 s_vFillCTSHead(struct vnt_usb_send_context *tx_context,
 
 static u16 vnt_rxtx_rts(struct vnt_usb_send_context *tx_context,
 	union vnt_tx_head *tx_head, u8 pkt_type, u32 frame_size,
-	int need_ack, u16 current_rate)
+	int need_ack, u16 current_rate, bool need_mic)
 {
 	struct vnt_private *priv = tx_context->priv;
 	struct vnt_rrv_time_rts *buf = &tx_head->tx_rts.rts;
+	union vnt_tx_data_head *head = &tx_head->tx_rts.tx.head;
 
 	buf->rts_rrv_time_aa = s_uGetRTSCTSRsvTime(priv, 2,
 				pkt_type, frame_size, current_rate);
@@ -648,7 +638,15 @@ static u16 vnt_rxtx_rts(struct vnt_usb_send_context *tx_context,
 	buf->rrv_time_b = vnt_rxtx_rsvtime_le16(priv, PK_TYPE_11B, frame_size,
 					priv->byTopCCKBasicRate, need_ack);
 
-	return 0;
+	if (need_mic)
+		head = &tx_head->tx_rts.tx.mic.head;
+
+	if (tx_context->fb_option)
+		return vnt_rxtx_rts_g_fb_head(tx_context, &head->rts_g_fb,
+			pkt_type, frame_size, need_ack, current_rate);
+
+	return vnt_rxtx_rts_g_head(tx_context, &head->rts_g,
+				pkt_type, frame_size, need_ack, current_rate);
 }
 
 static u16 vnt_rxtx_cts(struct vnt_usb_send_context *tx_context,
@@ -722,22 +720,13 @@ static u16 s_vGenerateTxParameter(struct vnt_usb_send_context *tx_context,
 
 	if (byPktType == PK_TYPE_11GB || byPktType == PK_TYPE_11GA) {
 		if (need_rts) {
-			vnt_rxtx_rts(tx_context, &tx_buffer->tx_head,
-				byPktType, cbFrameSize, bNeedACK, wCurrentRate);
-
-			if (need_mic) {
+			if (need_mic)
 				*mic_hdr = &tx_buffer->
 						tx_head.tx_rts.tx.mic.hdr;
-				head = &tx_buffer->tx_head.tx_rts.tx.mic.head;
-			} else {
-				head = &tx_buffer->tx_head.tx_rts.tx.head;
-			}
-
-			/* Fill RTS */
-			return s_vFillRTSHead(tx_context, byPktType, head,
-						cbFrameSize, bNeedACK,
-						wCurrentRate);
 
+			return vnt_rxtx_rts(tx_context, &tx_buffer->tx_head,
+					byPktType, cbFrameSize, bNeedACK,
+						wCurrentRate, need_mic);
 		} else {
 			vnt_rxtx_cts(tx_context, &tx_buffer->tx_head,
 				byPktType, cbFrameSize, bNeedACK, wCurrentRate);
-- 
1.9.1

