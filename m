Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:36903 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbaGKAJX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2014 20:09:23 -0400
Received: by mail-we0-f170.google.com with SMTP id w62so10135wes.29
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jul 2014 17:09:21 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 05/13] staging: vt6656: rename s_uGetRTSCTSRsvTime to vnt_get_rtscts_rsvtime_le
Date: Fri, 11 Jul 2014 01:08:23 +0100
Message-Id: <1405037311-3666-5-git-send-email-tvboxspy@gmail.com> (sfid-20140711_020929_820646_4BE7AB60)
In-Reply-To: <1405037311-3666-1-git-send-email-tvboxspy@gmail.com>
References: <1405037311-3666-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Function always returns little endian.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 3c92360..ceaaca0 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -31,7 +31,7 @@
  *      vnt_get_duration_le - get tx data required duration
  *      s_uFillDataHead- fulfill tx data duration header
  *      vnt_get_rtscts_duration_le- get rtx/cts required duration
- *      s_uGetRTSCTSRsvTime- get rts/cts reserved time
+ *      vnt_get_rtscts_rsvtime_le- get rts/cts reserved time
  *      s_uGetTxRsvTime- get frame reserved time
  *      vnt_fill_cts_head- fulfill CTS ctl header
  *      s_vFillFragParameter- Set fragment ctl parameter.
@@ -86,7 +86,7 @@ static struct vnt_usb_send_context *s_vGetFreeContext(struct vnt_private *);
 static unsigned int s_uGetTxRsvTime(struct vnt_private *pDevice, u8 byPktType,
 	u32 cbFrameLength, u16 wRate, int bNeedAck);
 
-static __le16 s_uGetRTSCTSRsvTime(struct vnt_private *priv,
+static __le16 vnt_get_rtscts_rsvtime_le(struct vnt_private *priv,
 	u8 rsv_type, u8 pkt_type, u32 frame_length, u16 current_rate);
 
 static __le16 vnt_get_duration_le(struct vnt_private *pDevice,
@@ -166,7 +166,7 @@ static __le16 vnt_rxtx_rsvtime_le16(struct vnt_private *priv, u8 pkt_type,
 }
 
 //byFreqType: 0=>5GHZ 1=>2.4GHZ
-static __le16 s_uGetRTSCTSRsvTime(struct vnt_private *priv,
+static __le16 vnt_get_rtscts_rsvtime_le(struct vnt_private *priv,
 	u8 rsv_type, u8 pkt_type, u32 frame_length, u16 current_rate)
 {
 	u32 rrv_time, rts_time, cts_time, ack_time, data_time;
@@ -584,11 +584,11 @@ static u16 vnt_rxtx_rts(struct vnt_usb_send_context *tx_context,
 	struct vnt_rrv_time_rts *buf = &tx_head->tx_rts.rts;
 	union vnt_tx_data_head *head = &tx_head->tx_rts.tx.head;
 
-	buf->rts_rrv_time_aa = s_uGetRTSCTSRsvTime(priv, 2,
+	buf->rts_rrv_time_aa = vnt_get_rtscts_rsvtime_le(priv, 2,
 				pkt_type, frame_size, current_rate);
-	buf->rts_rrv_time_ba = s_uGetRTSCTSRsvTime(priv, 1,
+	buf->rts_rrv_time_ba = vnt_get_rtscts_rsvtime_le(priv, 1,
 				pkt_type, frame_size, current_rate);
-	buf->rts_rrv_time_bb = s_uGetRTSCTSRsvTime(priv, 0,
+	buf->rts_rrv_time_bb = vnt_get_rtscts_rsvtime_le(priv, 0,
 				pkt_type, frame_size, current_rate);
 
 	buf->rrv_time_a = vnt_rxtx_rsvtime_le16(priv, pkt_type, frame_size,
@@ -621,7 +621,7 @@ static u16 vnt_rxtx_cts(struct vnt_usb_send_context *tx_context,
 	buf->rrv_time_b = vnt_rxtx_rsvtime_le16(priv, PK_TYPE_11B,
 				frame_size, priv->byTopCCKBasicRate, need_ack);
 
-	buf->cts_rrv_time_ba = s_uGetRTSCTSRsvTime(priv, 3,
+	buf->cts_rrv_time_ba = vnt_get_rtscts_rsvtime_le(priv, 3,
 			pkt_type, frame_size, current_rate);
 
 	if (need_mic)
@@ -648,10 +648,10 @@ static u16 vnt_rxtx_ab(struct vnt_usb_send_context *tx_context,
 
 	if (need_rts) {
 		if (pkt_type == PK_TYPE_11B)
-			buf->rts_rrv_time = s_uGetRTSCTSRsvTime(priv, 0,
+			buf->rts_rrv_time = vnt_get_rtscts_rsvtime_le(priv, 0,
 				pkt_type, frame_size, current_rate);
 		else /* PK_TYPE_11A */
-			buf->rts_rrv_time = s_uGetRTSCTSRsvTime(priv, 2,
+			buf->rts_rrv_time = vnt_get_rtscts_rsvtime_le(priv, 2,
 				pkt_type, frame_size, current_rate);
 
 		if (tx_context->fb_option && pkt_type == PK_TYPE_11A)
-- 
1.9.1

