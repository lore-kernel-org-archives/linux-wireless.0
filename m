Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:55075 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406AbaGJS5E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2014 14:57:04 -0400
Received: by mail-wi0-f173.google.com with SMTP id cc10so5112325wib.12
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jul 2014 11:57:00 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 10/16] staging: vt6656: move s_vFillCTSHead to vnt_rxtx_cts
Date: Thu, 10 Jul 2014 19:56:11 +0100
Message-Id: <1405018577-6832-10-git-send-email-tvboxspy@gmail.com> (sfid-20140710_205741_807760_25976D8F)
In-Reply-To: <1405018577-6832-1-git-send-email-tvboxspy@gmail.com>
References: <1405018577-6832-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

add need_mic and union vnt_tx_data_head head positions from s_vGenerateTxParameter.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 0ff8b50..c8a38c5 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -651,10 +651,12 @@ static u16 vnt_rxtx_rts(struct vnt_usb_send_context *tx_context,
 
 static u16 vnt_rxtx_cts(struct vnt_usb_send_context *tx_context,
 	union vnt_tx_head *tx_head, u8 pkt_type, u32 frame_size,
-	int need_ack, u16 current_rate)
+	int need_ack, u16 current_rate, bool need_mic)
 {
 	struct vnt_private *priv = tx_context->priv;
 	struct vnt_rrv_time_cts *buf = &tx_head->tx_cts.cts;
+	union vnt_tx_data_head *head = &tx_head->tx_cts.tx.head;
+
 
 	buf->rrv_time_a = vnt_rxtx_rsvtime_le16(priv, pkt_type,
 					frame_size, current_rate, need_ack);
@@ -664,7 +666,12 @@ static u16 vnt_rxtx_cts(struct vnt_usb_send_context *tx_context,
 	buf->cts_rrv_time_ba = s_uGetRTSCTSRsvTime(priv, 3,
 			pkt_type, frame_size, current_rate);
 
-	return 0;
+	if (need_mic)
+		head = &tx_head->tx_cts.tx.mic.head;
+
+	/* Fill CTS */
+	return s_vFillCTSHead(tx_context, pkt_type, head, frame_size,
+							need_ack, current_rate);
 }
 
 static u16 vnt_rxtx_ab(struct vnt_usb_send_context *tx_context,
@@ -728,20 +735,13 @@ static u16 s_vGenerateTxParameter(struct vnt_usb_send_context *tx_context,
 					byPktType, cbFrameSize, bNeedACK,
 						wCurrentRate, need_mic);
 		} else {
-			vnt_rxtx_cts(tx_context, &tx_buffer->tx_head,
-				byPktType, cbFrameSize, bNeedACK, wCurrentRate);
-
-			if (need_mic) {
+			if (need_mic)
 				*mic_hdr = &tx_buffer->
 						tx_head.tx_cts.tx.mic.hdr;
-				head = &tx_buffer->tx_head.tx_cts.tx.mic.head;
-			} else {
-				head = &tx_buffer->tx_head.tx_cts.tx.head;
-			}
-
-			/* Fill CTS */
-			return s_vFillCTSHead(tx_context, byPktType,
-				head, cbFrameSize, bNeedACK, wCurrentRate);
+
+			return vnt_rxtx_cts(tx_context, &tx_buffer->tx_head,
+					byPktType, cbFrameSize, bNeedACK,
+						wCurrentRate, need_mic);
 		}
 	} else if (byPktType == PK_TYPE_11A) {
 		if (need_mic) {
-- 
1.9.1

