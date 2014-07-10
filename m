Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:54287 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844AbaGJS4w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2014 14:56:52 -0400
Received: by mail-we0-f170.google.com with SMTP id w61so4301wes.15
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jul 2014 11:56:51 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 05/16] staging: vt6656: s_vGenerateTxParameter Parse out struct vnt_rrv_time_rts
Date: Thu, 10 Jul 2014 19:56:06 +0100
Message-Id: <1405018577-6832-5-git-send-email-tvboxspy@gmail.com> (sfid-20140710_205657_038778_7F790242)
In-Reply-To: <1405018577-6832-1-git-send-email-tvboxspy@gmail.com>
References: <1405018577-6832-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Creat new function vnt_rxtx_rts that will eventually carry onward
functions.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 39 ++++++++++++++++++++++++---------------
 1 file changed, 24 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 2ed045d..7d0b74c 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -629,6 +629,28 @@ static u16 s_vFillCTSHead(struct vnt_usb_send_context *tx_context,
 	return 0;
 }
 
+static u16 vnt_rxtx_rts(struct vnt_usb_send_context *tx_context,
+	union vnt_tx_head *tx_head, u8 pkt_type, u32 frame_size,
+	int need_ack, u16 current_rate)
+{
+	struct vnt_private *priv = tx_context->priv;
+	struct vnt_rrv_time_rts *buf = &tx_head->tx_rts.rts;
+
+	buf->rts_rrv_time_aa = s_uGetRTSCTSRsvTime(priv, 2,
+				pkt_type, frame_size, current_rate);
+	buf->rts_rrv_time_ba = s_uGetRTSCTSRsvTime(priv, 1,
+				pkt_type, frame_size, current_rate);
+	buf->rts_rrv_time_bb = s_uGetRTSCTSRsvTime(priv, 0,
+				pkt_type, frame_size, current_rate);
+
+	buf->rrv_time_a = vnt_rxtx_rsvtime_le16(priv, pkt_type, frame_size,
+							current_rate, need_ack);
+	buf->rrv_time_b = vnt_rxtx_rsvtime_le16(priv, PK_TYPE_11B, frame_size,
+					priv->byTopCCKBasicRate, need_ack);
+
+	return 0;
+}
+
 /*+
  *
  * Description:
@@ -661,21 +683,8 @@ static u16 s_vGenerateTxParameter(struct vnt_usb_send_context *tx_context,
 
 	if (byPktType == PK_TYPE_11GB || byPktType == PK_TYPE_11GA) {
 		if (need_rts) {
-			struct vnt_rrv_time_rts *pBuf =
-					&tx_buffer->tx_head.tx_rts.rts;
-
-			pBuf->rts_rrv_time_aa = s_uGetRTSCTSRsvTime(pDevice, 2,
-					byPktType, cbFrameSize, wCurrentRate);
-			pBuf->rts_rrv_time_ba = s_uGetRTSCTSRsvTime(pDevice, 1,
-					byPktType, cbFrameSize, wCurrentRate);
-			pBuf->rts_rrv_time_bb = s_uGetRTSCTSRsvTime(pDevice, 0,
-				byPktType, cbFrameSize, wCurrentRate);
-
-			pBuf->rrv_time_a = vnt_rxtx_rsvtime_le16(pDevice,
-				byPktType, cbFrameSize, wCurrentRate, bNeedACK);
-			pBuf->rrv_time_b = vnt_rxtx_rsvtime_le16(pDevice,
-					PK_TYPE_11B, cbFrameSize,
-					pDevice->byTopCCKBasicRate, bNeedACK);
+			vnt_rxtx_rts(tx_context, &tx_buffer->tx_head,
+				byPktType, cbFrameSize, bNeedACK, wCurrentRate);
 
 			if (need_mic) {
 				*mic_hdr = &tx_buffer->
-- 
1.9.1

