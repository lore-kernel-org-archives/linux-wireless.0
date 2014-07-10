Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:44896 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922AbaGJS5K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2014 14:57:10 -0400
Received: by mail-wg0-f51.google.com with SMTP id y10so4637479wgg.34
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jul 2014 11:57:08 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 14/16] staging: vt6656: rename s_vGenerateTxParameter to vnt_generate_tx_parameter
Date: Thu, 10 Jul 2014 19:56:15 +0100
Message-Id: <1405018577-6832-14-git-send-email-tvboxspy@gmail.com> (sfid-20140710_205726_990898_A3FAA84C)
In-Reply-To: <1405018577-6832-1-git-send-email-tvboxspy@gmail.com>
References: <1405018577-6832-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removing static declaration

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 1ff16e2..ad1a1b6 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -25,7 +25,7 @@
  * Date: May 20, 2003
  *
  * Functions:
- *      s_vGenerateTxParameter - Generate tx dma required parameter.
+ *      vnt_generate_tx_parameter - Generate tx dma required parameter.
  *      csBeacon_xmit - beacon tx function
  *      csMgmt_xmit - management tx function
  *      s_uGetDataDuration - get tx data required duration
@@ -83,11 +83,6 @@ static const u16 wFB_Opt1[2][5] = {
 
 static struct vnt_usb_send_context *s_vGetFreeContext(struct vnt_private *);
 
-static u16 s_vGenerateTxParameter(struct vnt_usb_send_context *tx_context,
-	u8 byPktType, u16 wCurrentRate,	struct vnt_tx_buffer *tx_buffer,
-	struct vnt_mic_hdr **mic_hdr, u32 need_mic, u32 cbFrameSize,
-	int bNeedACK, bool need_rts);
-
 static unsigned int s_uGetTxRsvTime(struct vnt_private *pDevice, u8 byPktType,
 	u32 cbFrameLength, u16 wRate, int bNeedAck);
 
@@ -702,7 +697,7 @@ static u16 vnt_rxtx_ab(struct vnt_usb_send_context *tx_context,
  *
 -*/
 
-static u16 s_vGenerateTxParameter(struct vnt_usb_send_context *tx_context,
+static u16 vnt_generate_tx_parameter(struct vnt_usb_send_context *tx_context,
 	u8 pkt_type, u16 current_rate, struct vnt_tx_buffer *tx_buffer,
 	struct vnt_mic_hdr **mic_hdr, u32 need_mic, u32 frame_size,
 	int need_ack, bool need_rts)
@@ -950,8 +945,8 @@ int vnt_tx_packet(struct vnt_private *priv, struct sk_buff *skb)
 
 	tx_context->fb_option = fb_option;
 
-	duration_id = s_vGenerateTxParameter(tx_context, pkt_type, current_rate,
-				tx_buffer, &mic_hdr, need_mic, frame_size,
+	duration_id = vnt_generate_tx_parameter(tx_context, pkt_type,
+			current_rate, tx_buffer, &mic_hdr, need_mic, frame_size,
 						need_ack, need_rts);
 
 	tx_header_size = tx_context->tx_hdr_size;
-- 
1.9.1

