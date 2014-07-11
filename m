Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:34545 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbaGKAJS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2014 20:09:18 -0400
Received: by mail-wg0-f43.google.com with SMTP id b13so293421wgh.26
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jul 2014 17:09:15 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 01/13] staging: vt6656: s_uGetRTSCTSDuration remove camel case
Date: Fri, 11 Jul 2014 01:08:19 +0100
Message-Id: <1405037311-3666-1-git-send-email-tvboxspy@gmail.com> (sfid-20140711_020921_647914_B13AB71B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

camel case changes
pDevice -> priv
byDurType -> dur_type
cbFrameLength -> frame_length
byPktType -> pkt_type
wRate -> rate
bNeedAck -> need_ack
uCTSTime -> cts_time
uDurTime -> dur_time

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index f8c2323..0e853c1 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -92,9 +92,9 @@ static __le16 s_uGetRTSCTSRsvTime(struct vnt_private *priv,
 static __le16 s_uGetDataDuration(struct vnt_private *pDevice,
 	u8 byPktType, int bNeedAck);
 
-static __le16 s_uGetRTSCTSDuration(struct vnt_private *pDevice,
-	u8 byDurType, u32 cbFrameLength, u8 byPktType, u16 wRate,
-	int bNeedAck);
+static __le16 s_uGetRTSCTSDuration(struct vnt_private *priv,
+	u8 dur_type, u32 frame_length, u8 pkt_type, u16 rate,
+	int need_ack);
 
 static struct vnt_usb_send_context
 	*s_vGetFreeContext(struct vnt_private *priv)
@@ -229,45 +229,45 @@ static __le16 s_uGetDataDuration(struct vnt_private *pDevice,
 }
 
 //byFreqType: 0=>5GHZ 1=>2.4GHZ
-static __le16 s_uGetRTSCTSDuration(struct vnt_private *pDevice, u8 byDurType,
-	u32 cbFrameLength, u8 byPktType, u16 wRate, int bNeedAck)
+static __le16 s_uGetRTSCTSDuration(struct vnt_private *priv, u8 dur_type,
+	u32 frame_length, u8 pkt_type, u16 rate, int need_ack)
 {
-	u32 uCTSTime = 0, uDurTime = 0;
+	u32 cts_time = 0, dur_time = 0;
 
-	switch (byDurType) {
+	switch (dur_type) {
 	case RTSDUR_BB:
 	case RTSDUR_BA:
 	case RTSDUR_BA_F0:
 	case RTSDUR_BA_F1:
-		uCTSTime = vnt_get_frame_time(pDevice->byPreambleType,
-				byPktType, 14, pDevice->byTopCCKBasicRate);
-		uDurTime = uCTSTime + 2 * pDevice->uSIFS +
-			s_uGetTxRsvTime(pDevice, byPktType,
-						cbFrameLength, wRate, bNeedAck);
+		cts_time = vnt_get_frame_time(priv->byPreambleType,
+				pkt_type, 14, priv->byTopCCKBasicRate);
+		dur_time = cts_time + 2 * priv->uSIFS +
+			s_uGetTxRsvTime(priv, pkt_type,
+						frame_length, rate, need_ack);
 		break;
 
 	case RTSDUR_AA:
 	case RTSDUR_AA_F0:
 	case RTSDUR_AA_F1:
-		uCTSTime = vnt_get_frame_time(pDevice->byPreambleType,
-				byPktType, 14, pDevice->byTopOFDMBasicRate);
-		uDurTime = uCTSTime + 2 * pDevice->uSIFS +
-			s_uGetTxRsvTime(pDevice, byPktType,
-						cbFrameLength, wRate, bNeedAck);
+		cts_time = vnt_get_frame_time(priv->byPreambleType,
+				pkt_type, 14, priv->byTopOFDMBasicRate);
+		dur_time = cts_time + 2 * priv->uSIFS +
+			s_uGetTxRsvTime(priv, pkt_type,
+						frame_length, rate, need_ack);
 		break;
 
 	case CTSDUR_BA:
 	case CTSDUR_BA_F0:
 	case CTSDUR_BA_F1:
-		uDurTime = pDevice->uSIFS + s_uGetTxRsvTime(pDevice,
-				byPktType, cbFrameLength, wRate, bNeedAck);
+		dur_time = priv->uSIFS + s_uGetTxRsvTime(priv,
+				pkt_type, frame_length, rate, need_ack);
 		break;
 
 	default:
 		break;
 	}
 
-	return cpu_to_le16((u16)uDurTime);
+	return cpu_to_le16((u16)dur_time);
 }
 
 static u16 vnt_mac_hdr_pos(struct vnt_usb_send_context *tx_context,
-- 
1.9.1

