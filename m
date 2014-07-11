Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:62956 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734AbaGKAJZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2014 20:09:25 -0400
Received: by mail-wi0-f169.google.com with SMTP id hi2so5255046wib.4
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jul 2014 17:09:23 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 06/13] staging: vt6656: rename s_uGetTxRsvTime to vnt_get_rsvtime
Date: Fri, 11 Jul 2014 01:08:24 +0100
Message-Id: <1405037311-3666-6-git-send-email-tvboxspy@gmail.com> (sfid-20140711_020930_846337_97C0B6A5)
In-Reply-To: <1405037311-3666-1-git-send-email-tvboxspy@gmail.com>
References: <1405037311-3666-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Drop tx from name

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index ceaaca0..5084434 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -32,7 +32,7 @@
  *      s_uFillDataHead- fulfill tx data duration header
  *      vnt_get_rtscts_duration_le- get rtx/cts required duration
  *      vnt_get_rtscts_rsvtime_le- get rts/cts reserved time
- *      s_uGetTxRsvTime- get frame reserved time
+ *      vnt_get_rsvtime- get frame reserved time
  *      vnt_fill_cts_head- fulfill CTS ctl header
  *      s_vFillFragParameter- Set fragment ctl parameter.
  *      s_vFillRTSHead- fulfill RTS ctl header
@@ -83,7 +83,7 @@ static const u16 wFB_Opt1[2][5] = {
 
 static struct vnt_usb_send_context *s_vGetFreeContext(struct vnt_private *);
 
-static unsigned int s_uGetTxRsvTime(struct vnt_private *pDevice, u8 byPktType,
+static unsigned int vnt_get_rsvtime(struct vnt_private *pDevice, u8 byPktType,
 	u32 cbFrameLength, u16 wRate, int bNeedAck);
 
 static __le16 vnt_get_rtscts_rsvtime_le(struct vnt_private *priv,
@@ -137,7 +137,7 @@ static __le16 vnt_time_stamp_off(struct vnt_private *priv, u16 rate)
              PK_TYPE_11GB    2
              PK_TYPE_11GA    3
 */
-static u32 s_uGetTxRsvTime(struct vnt_private *priv, u8 pkt_type,
+static u32 vnt_get_rsvtime(struct vnt_private *priv, u8 pkt_type,
 	u32 frame_length, u16 rate, int need_ack)
 {
 	u32 data_time, ack_time;
@@ -161,7 +161,7 @@ static u32 s_uGetTxRsvTime(struct vnt_private *priv, u8 pkt_type,
 static __le16 vnt_rxtx_rsvtime_le16(struct vnt_private *priv, u8 pkt_type,
 	u32 frame_length, u16 rate, int need_ack)
 {
-	return cpu_to_le16((u16)s_uGetTxRsvTime(priv, pkt_type,
+	return cpu_to_le16((u16)vnt_get_rsvtime(priv, pkt_type,
 		frame_length, rate, need_ack));
 }
 
@@ -243,7 +243,7 @@ static __le16 vnt_get_rtscts_duration_le(struct vnt_private *priv, u8 dur_type,
 		cts_time = vnt_get_frame_time(priv->byPreambleType,
 				pkt_type, 14, priv->byTopCCKBasicRate);
 		dur_time = cts_time + 2 * priv->uSIFS +
-			s_uGetTxRsvTime(priv, pkt_type,
+			vnt_get_rsvtime(priv, pkt_type,
 						frame_length, rate, need_ack);
 		break;
 
@@ -253,14 +253,14 @@ static __le16 vnt_get_rtscts_duration_le(struct vnt_private *priv, u8 dur_type,
 		cts_time = vnt_get_frame_time(priv->byPreambleType,
 				pkt_type, 14, priv->byTopOFDMBasicRate);
 		dur_time = cts_time + 2 * priv->uSIFS +
-			s_uGetTxRsvTime(priv, pkt_type,
+			vnt_get_rsvtime(priv, pkt_type,
 						frame_length, rate, need_ack);
 		break;
 
 	case CTSDUR_BA:
 	case CTSDUR_BA_F0:
 	case CTSDUR_BA_F1:
-		dur_time = priv->uSIFS + s_uGetTxRsvTime(priv,
+		dur_time = priv->uSIFS + vnt_get_rsvtime(priv,
 				pkt_type, frame_length, rate, need_ack);
 		break;
 
-- 
1.9.1

