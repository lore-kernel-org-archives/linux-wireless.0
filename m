Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:36542 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406AbaGJS44 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2014 14:56:56 -0400
Received: by mail-wi0-f171.google.com with SMTP id f8so4617984wiw.16
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jul 2014 11:56:52 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 06/16] staging: vt6656: s_vGenerateTxParameter Parse out struct vnt_rrv_time_cts
Date: Thu, 10 Jul 2014 19:56:07 +0100
Message-Id: <1405018577-6832-6-git-send-email-tvboxspy@gmail.com> (sfid-20140710_205703_837532_9D15BEBA)
In-Reply-To: <1405018577-6832-1-git-send-email-tvboxspy@gmail.com>
References: <1405018577-6832-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Create new function vnt_rxtx_cts that will eventually carry onward
function.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 7d0b74c..49bda3c 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -651,6 +651,24 @@ static u16 vnt_rxtx_rts(struct vnt_usb_send_context *tx_context,
 	return 0;
 }
 
+static u16 vnt_rxtx_cts(struct vnt_usb_send_context *tx_context,
+	union vnt_tx_head *tx_head, u8 pkt_type, u32 frame_size,
+	int need_ack, u16 current_rate)
+{
+	struct vnt_private *priv = tx_context->priv;
+	struct vnt_rrv_time_cts *buf = &tx_head->tx_cts.cts;
+
+	buf->rrv_time_a = vnt_rxtx_rsvtime_le16(priv, pkt_type,
+					frame_size, current_rate, need_ack);
+	buf->rrv_time_b = vnt_rxtx_rsvtime_le16(priv, PK_TYPE_11B,
+				frame_size, priv->byTopCCKBasicRate, need_ack);
+
+	buf->cts_rrv_time_ba = s_uGetRTSCTSRsvTime(priv, 3,
+			pkt_type, frame_size, current_rate);
+
+	return 0;
+}
+
 /*+
  *
  * Description:
@@ -700,17 +718,8 @@ static u16 s_vGenerateTxParameter(struct vnt_usb_send_context *tx_context,
 						wCurrentRate);
 
 		} else {
-			struct vnt_rrv_time_cts *pBuf = &tx_buffer->
-							tx_head.tx_cts.cts;
-
-			pBuf->rrv_time_a = vnt_rxtx_rsvtime_le16(pDevice,
-				byPktType, cbFrameSize, wCurrentRate, bNeedACK);
-			pBuf->rrv_time_b = vnt_rxtx_rsvtime_le16(pDevice,
-				PK_TYPE_11B, cbFrameSize,
-					pDevice->byTopCCKBasicRate, bNeedACK);
-
-			pBuf->cts_rrv_time_ba = s_uGetRTSCTSRsvTime(pDevice, 3,
-					byPktType, cbFrameSize, wCurrentRate);
+			vnt_rxtx_cts(tx_context, &tx_buffer->tx_head,
+				byPktType, cbFrameSize, bNeedACK, wCurrentRate);
 
 			if (need_mic) {
 				*mic_hdr = &tx_buffer->
-- 
1.9.1

