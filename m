Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:55411 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbaGKAJW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2014 20:09:22 -0400
Received: by mail-wg0-f42.google.com with SMTP id l18so291457wgh.13
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jul 2014 17:09:20 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 04/13] staging: vt6656: rename s_uGetDataDuration to vnt_get_duration_le
Date: Fri, 11 Jul 2014 01:08:22 +0100
Message-Id: <1405037311-3666-4-git-send-email-tvboxspy@gmail.com> (sfid-20140711_020924_951855_32D81E00)
In-Reply-To: <1405037311-3666-1-git-send-email-tvboxspy@gmail.com>
References: <1405037311-3666-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Drop data and the function always returns little endian

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index a89f7fd..3c92360 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -28,7 +28,7 @@
  *      vnt_generate_tx_parameter - Generate tx dma required parameter.
  *      csBeacon_xmit - beacon tx function
  *      csMgmt_xmit - management tx function
- *      s_uGetDataDuration - get tx data required duration
+ *      vnt_get_duration_le - get tx data required duration
  *      s_uFillDataHead- fulfill tx data duration header
  *      vnt_get_rtscts_duration_le- get rtx/cts required duration
  *      s_uGetRTSCTSRsvTime- get rts/cts reserved time
@@ -89,7 +89,7 @@ static unsigned int s_uGetTxRsvTime(struct vnt_private *pDevice, u8 byPktType,
 static __le16 s_uGetRTSCTSRsvTime(struct vnt_private *priv,
 	u8 rsv_type, u8 pkt_type, u32 frame_length, u16 current_rate);
 
-static __le16 s_uGetDataDuration(struct vnt_private *pDevice,
+static __le16 vnt_get_duration_le(struct vnt_private *pDevice,
 	u8 byPktType, int bNeedAck);
 
 static __le16 vnt_get_rtscts_duration_le(struct vnt_private *priv,
@@ -210,7 +210,7 @@ static __le16 s_uGetRTSCTSRsvTime(struct vnt_private *priv,
 }
 
 //byFreqType 0: 5GHz, 1:2.4Ghz
-static __le16 s_uGetDataDuration(struct vnt_private *piv,
+static __le16 vnt_get_duration_le(struct vnt_private *piv,
 					u8 pkt_type, int need_ack)
 {
 	u32 ack_time = 0;
@@ -305,8 +305,8 @@ static u16 vnt_rxtx_datahead_g(struct vnt_usb_send_context *tx_context,
 		buf->duration_a = dur;
 		buf->duration_b = dur;
 	} else {
-		buf->duration_a = s_uGetDataDuration(priv, pkt_type, need_ack);
-		buf->duration_b = s_uGetDataDuration(priv,
+		buf->duration_a = vnt_get_duration_le(priv, pkt_type, need_ack);
+		buf->duration_b = vnt_get_duration_le(priv,
 							PK_TYPE_11B, need_ack);
 	}
 
@@ -332,11 +332,11 @@ static u16 vnt_rxtx_datahead_g_fb(struct vnt_usb_send_context *tx_context,
 						PK_TYPE_11B, &buf->b);
 
 	/* Get Duration and TimeStamp */
-	buf->duration_a = s_uGetDataDuration(priv, pkt_type, need_ack);
-	buf->duration_b = s_uGetDataDuration(priv, PK_TYPE_11B, need_ack);
+	buf->duration_a = vnt_get_duration_le(priv, pkt_type, need_ack);
+	buf->duration_b = vnt_get_duration_le(priv, PK_TYPE_11B, need_ack);
 
-	buf->duration_a_f0 = s_uGetDataDuration(priv, pkt_type, need_ack);
-	buf->duration_a_f1 = s_uGetDataDuration(priv, pkt_type, need_ack);
+	buf->duration_a_f0 = vnt_get_duration_le(priv, pkt_type, need_ack);
+	buf->duration_a_f1 = vnt_get_duration_le(priv, pkt_type, need_ack);
 
 	buf->time_stamp_off_a = vnt_time_stamp_off(priv, rate);
 	buf->time_stamp_off_b = vnt_time_stamp_off(priv,
@@ -356,10 +356,10 @@ static u16 vnt_rxtx_datahead_a_fb(struct vnt_usb_send_context *tx_context,
 	/* Get SignalField,ServiceField,Length */
 	vnt_get_phy_field(priv, frame_len, rate, pkt_type, &buf->a);
 	/* Get Duration and TimeStampOff */
-	buf->duration = s_uGetDataDuration(priv, pkt_type, need_ack);
+	buf->duration = vnt_get_duration_le(priv, pkt_type, need_ack);
 
-	buf->duration_f0 = s_uGetDataDuration(priv, pkt_type, need_ack);
-	buf->duration_f1 = s_uGetDataDuration(priv, pkt_type, need_ack);
+	buf->duration_f0 = vnt_get_duration_le(priv, pkt_type, need_ack);
+	buf->duration_f1 = vnt_get_duration_le(priv, pkt_type, need_ack);
 
 	buf->time_stamp_off = vnt_time_stamp_off(priv, rate);
 
@@ -385,7 +385,7 @@ static u16 vnt_rxtx_datahead_ab(struct vnt_usb_send_context *tx_context,
 
 		buf->duration = dur;
 	} else {
-		buf->duration = s_uGetDataDuration(priv, pkt_type, need_ack);
+		buf->duration = vnt_get_duration_le(priv, pkt_type, need_ack);
 	}
 
 	buf->time_stamp_off = vnt_time_stamp_off(priv, rate);
@@ -1027,7 +1027,7 @@ static int vnt_beacon_xmit(struct vnt_private *priv,
 			PK_TYPE_11A, &short_head->ab);
 
 		/* Get Duration and TimeStampOff */
-		short_head->duration = s_uGetDataDuration(priv,
+		short_head->duration = vnt_get_duration_le(priv,
 							PK_TYPE_11A, false);
 		short_head->time_stamp_off =
 				vnt_time_stamp_off(priv, current_rate);
@@ -1040,7 +1040,7 @@ static int vnt_beacon_xmit(struct vnt_private *priv,
 					PK_TYPE_11B, &short_head->ab);
 
 		/* Get Duration and TimeStampOff */
-		short_head->duration = s_uGetDataDuration(priv,
+		short_head->duration = vnt_get_duration_le(priv,
 						PK_TYPE_11B, false);
 		short_head->time_stamp_off =
 			vnt_time_stamp_off(priv, current_rate);
-- 
1.9.1

