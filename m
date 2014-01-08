Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:37765 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511AbaAHUIw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jan 2014 15:08:52 -0500
Received: by mail-wg0-f47.google.com with SMTP id n12so1943427wgh.14
        for <linux-wireless@vger.kernel.org>; Wed, 08 Jan 2014 12:08:51 -0800 (PST)
Message-ID: <1389211722.6175.4.camel@canaries32-MCP7A> (sfid-20140108_210856_335691_DFC67547)
Subject: [PATCH 1/2] staging: vt6656: rxtx.c Camel case and clean up
 s_uGetTxRsvTime
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Wed, 08 Jan 2014 20:08:42 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

White space clean.

Remove unneeded comments.

Camel case changes
pDevice
byPktType
cbFrameLength
wRate
bNeedAck

uDataTime
uAckTime

} -> {

priv
pkt_type
frame_length
rate
need_ack

data_time
ack_time

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 3186971..6102822 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -338,24 +338,25 @@ static u16 vnt_time_stamp_off(struct vnt_private *priv, u16 rate)
              PK_TYPE_11GB    2
              PK_TYPE_11GA    3
 */
-static u32 s_uGetTxRsvTime(struct vnt_private *pDevice, u8 byPktType,
-	u32 cbFrameLength, u16 wRate, int bNeedAck)
+static u32 s_uGetTxRsvTime(struct vnt_private *priv, u8 pkt_type,
+	u32 frame_length, u16 rate, int need_ack)
 {
-	u32 uDataTime, uAckTime;
+	u32 data_time, ack_time;
 
-    uDataTime = BBuGetFrameTime(pDevice->byPreambleType, byPktType, cbFrameLength, wRate);
-    if (byPktType == PK_TYPE_11B) {//llb,CCK mode
-        uAckTime = BBuGetFrameTime(pDevice->byPreambleType, byPktType, 14, (u16)pDevice->byTopCCKBasicRate);
-    } else {//11g 2.4G OFDM mode & 11a 5G OFDM mode
-        uAckTime = BBuGetFrameTime(pDevice->byPreambleType, byPktType, 14, (u16)pDevice->byTopOFDMBasicRate);
-    }
+	data_time = BBuGetFrameTime(priv->byPreambleType, pkt_type,
+							frame_length, rate);
 
-    if (bNeedAck) {
-        return (uDataTime + pDevice->uSIFS + uAckTime);
-    }
-    else {
-        return uDataTime;
-    }
+	if (pkt_type == PK_TYPE_11B)
+		ack_time = BBuGetFrameTime(priv->byPreambleType, pkt_type, 14,
+						(u16)priv->byTopCCKBasicRate);
+	else
+		ack_time = BBuGetFrameTime(priv->byPreambleType, pkt_type, 14,
+						(u16)priv->byTopOFDMBasicRate);
+
+	if (need_ack)
+		return data_time + priv->uSIFS + ack_time;
+
+	return data_time;
 }
 
 static u16 vnt_rxtx_rsvtime_le16(struct vnt_private *priv, u8 pkt_type,
-- 
1.8.5.2

