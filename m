Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:38224 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922AbaGJS5M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2014 14:57:12 -0400
Received: by mail-wg0-f46.google.com with SMTP id m15so2284wgh.17
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jul 2014 11:57:11 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 16/16] staging: vt6656: rename s_vFillCTSHead to vnt_fill_cts_head
Date: Thu, 10 Jul 2014 19:56:17 +0100
Message-Id: <1405018577-6832-16-git-send-email-tvboxspy@gmail.com> (sfid-20140710_205727_585194_EFAFC84F)
In-Reply-To: <1405018577-6832-1-git-send-email-tvboxspy@gmail.com>
References: <1405018577-6832-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removing static declaration.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index dce6cb5..f8c2323 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -33,7 +33,7 @@
  *      s_uGetRTSCTSDuration- get rtx/cts required duration
  *      s_uGetRTSCTSRsvTime- get rts/cts reserved time
  *      s_uGetTxRsvTime- get frame reserved time
- *      s_vFillCTSHead- fulfill CTS ctl header
+ *      vnt_fill_cts_head- fulfill CTS ctl header
  *      s_vFillFragParameter- Set fragment ctl parameter.
  *      s_vFillRTSHead- fulfill RTS ctl header
  *      vDMA0_tx_80211- tx 802.11 frame via dma0
@@ -89,10 +89,6 @@ static unsigned int s_uGetTxRsvTime(struct vnt_private *pDevice, u8 byPktType,
 static __le16 s_uGetRTSCTSRsvTime(struct vnt_private *priv,
 	u8 rsv_type, u8 pkt_type, u32 frame_length, u16 current_rate);
 
-static u16 s_vFillCTSHead(struct vnt_usb_send_context *tx_context,
-	u8 byPktType, union vnt_tx_data_head *head, u32 cbFrameLength,
-	int bNeedAck, u16 wCurrentRate);
-
 static __le16 s_uGetDataDuration(struct vnt_private *pDevice,
 	u8 byPktType, int bNeedAck);
 
@@ -519,7 +515,7 @@ static u16 vnt_rxtx_rts_a_fb_head(struct vnt_usb_send_context *tx_context,
 			&buf->data_head, frame_len, need_ack);
 }
 
-static u16 s_vFillCTSHead(struct vnt_usb_send_context *tx_context,
+static u16 vnt_fill_cts_head(struct vnt_usb_send_context *tx_context,
 	u8 pkt_type, union vnt_tx_data_head *head, u32 frame_len,
 	int need_ack, u16 current_rate)
 {
@@ -631,7 +627,7 @@ static u16 vnt_rxtx_cts(struct vnt_usb_send_context *tx_context,
 		head = &tx_head->tx_cts.tx.mic.head;
 
 	/* Fill CTS */
-	return s_vFillCTSHead(tx_context, pkt_type, head, frame_size,
+	return vnt_fill_cts_head(tx_context, pkt_type, head, frame_size,
 							need_ack, current_rate);
 }
 
-- 
1.9.1

