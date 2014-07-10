Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:37792 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874AbaGJS5I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2014 14:57:08 -0400
Received: by mail-wg0-f50.google.com with SMTP id n12so1385wgh.21
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jul 2014 11:57:05 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 13/16] staging: vt6656: s_vGenerateTxParameter remove camel case
Date: Thu, 10 Jul 2014 19:56:14 +0100
Message-Id: <1405018577-6832-13-git-send-email-tvboxspy@gmail.com> (sfid-20140710_205736_516621_91AAA8F5)
In-Reply-To: <1405018577-6832-1-git-send-email-tvboxspy@gmail.com>
References: <1405018577-6832-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Camel case changes
byPktType -> pkt_type
wCurrentRate -> current_rate
cbFrameSize -> frame_size
bNeedACK -> need_ack

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 0d0a956..1ff16e2 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -703,34 +703,34 @@ static u16 vnt_rxtx_ab(struct vnt_usb_send_context *tx_context,
 -*/
 
 static u16 s_vGenerateTxParameter(struct vnt_usb_send_context *tx_context,
-	u8 byPktType, u16 wCurrentRate,	struct vnt_tx_buffer *tx_buffer,
-	struct vnt_mic_hdr **mic_hdr, u32 need_mic, u32 cbFrameSize,
-	int bNeedACK, bool need_rts)
+	u8 pkt_type, u16 current_rate, struct vnt_tx_buffer *tx_buffer,
+	struct vnt_mic_hdr **mic_hdr, u32 need_mic, u32 frame_size,
+	int need_ack, bool need_rts)
 {
 
-	if (byPktType == PK_TYPE_11GB || byPktType == PK_TYPE_11GA) {
+	if (pkt_type == PK_TYPE_11GB || pkt_type == PK_TYPE_11GA) {
 		if (need_rts) {
 			if (need_mic)
 				*mic_hdr = &tx_buffer->
 						tx_head.tx_rts.tx.mic.hdr;
 
 			return vnt_rxtx_rts(tx_context, &tx_buffer->tx_head,
-					byPktType, cbFrameSize, bNeedACK,
-						wCurrentRate, need_mic);
+					pkt_type, frame_size, need_ack,
+						current_rate, need_mic);
 		}
 
 		if (need_mic)
 			*mic_hdr = &tx_buffer->tx_head.tx_cts.tx.mic.hdr;
 
-		return vnt_rxtx_cts(tx_context, &tx_buffer->tx_head, byPktType,
-				cbFrameSize, bNeedACK, wCurrentRate, need_mic);
+		return vnt_rxtx_cts(tx_context, &tx_buffer->tx_head, pkt_type,
+				frame_size, need_ack, current_rate, need_mic);
 	}
 
 	if (need_mic)
 		*mic_hdr = &tx_buffer->tx_head.tx_ab.tx.mic.hdr;
 
-	return vnt_rxtx_ab(tx_context, &tx_buffer->tx_head, byPktType,
-		cbFrameSize, bNeedACK, wCurrentRate, need_rts, need_mic);
+	return vnt_rxtx_ab(tx_context, &tx_buffer->tx_head, pkt_type,
+		frame_size, need_ack, current_rate, need_rts, need_mic);
 }
 
 static void vnt_fill_txkey(struct vnt_usb_send_context *tx_context,
-- 
1.9.1

