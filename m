Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:37856 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbaAHUNi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jan 2014 15:13:38 -0500
Received: by mail-we0-f176.google.com with SMTP id p61so1893127wes.21
        for <linux-wireless@vger.kernel.org>; Wed, 08 Jan 2014 12:13:37 -0800 (PST)
Message-ID: <1389212009.6175.7.camel@canaries32-MCP7A> (sfid-20140108_211342_198600_5201ABA8)
Subject: [PATCH 2/2] staging: vt6656: rxtx.c Camel case and clean up
 s_uGetRTSCTSRsvTime
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Wed, 08 Jan 2014 20:13:29 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

White space clean

Remove unneeded comments.

Camel case changes

pDevice,
byRTSRsvType
byPktType
cbFrameLength
wCurrentRate

uRrvTime
uRTSTime
uCTSTime
uAckTime
uDataTime

} -> {

priv,
rsv_type
pkt_type
frame_lenght
current_rate

rrv_time
rts_time
cts_time
ack_time
data_time

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 68 +++++++++++++++++++++++++------------------
 1 file changed, 39 insertions(+), 29 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 6102822..51fff89 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -118,8 +118,8 @@ static void s_vSWencryption(struct vnt_private *pDevice,
 static unsigned int s_uGetTxRsvTime(struct vnt_private *pDevice, u8 byPktType,
 	u32 cbFrameLength, u16 wRate, int bNeedAck);
 
-static u16 s_uGetRTSCTSRsvTime(struct vnt_private *pDevice, u8 byRTSRsvType,
-	u8 byPktType, u32 cbFrameLength, u16 wCurrentRate);
+static u16 s_uGetRTSCTSRsvTime(struct vnt_private *priv,
+	u8 rsv_type, u8 pkt_type, u32 frame_lenght, u16 current_rate);
 
 static u16 s_vFillCTSHead(struct vnt_private *pDevice, u32 uDMAIdx,
 	u8 byPktType, union vnt_tx_data_head *head, u32 cbFrameLength,
@@ -367,37 +367,47 @@ static u16 vnt_rxtx_rsvtime_le16(struct vnt_private *priv, u8 pkt_type,
 }
 
 //byFreqType: 0=>5GHZ 1=>2.4GHZ
-static u16 s_uGetRTSCTSRsvTime(struct vnt_private *pDevice,
-	u8 byRTSRsvType, u8 byPktType, u32 cbFrameLength, u16 wCurrentRate)
+static u16 s_uGetRTSCTSRsvTime(struct vnt_private *priv,
+	u8 rsv_type, u8 pkt_type, u32 frame_lenght, u16 current_rate)
 {
-	u32 uRrvTime, uRTSTime, uCTSTime, uAckTime, uDataTime;
+	u32 rrv_time, rts_time, cts_time, ack_time, data_time;
 
-    uRrvTime = uRTSTime = uCTSTime = uAckTime = uDataTime = 0;
+	rrv_time = rts_time = cts_time = ack_time = data_time = 0;
 
-    uDataTime = BBuGetFrameTime(pDevice->byPreambleType, byPktType, cbFrameLength, wCurrentRate);
-    if (byRTSRsvType == 0) { //RTSTxRrvTime_bb
-        uRTSTime = BBuGetFrameTime(pDevice->byPreambleType, byPktType, 20, pDevice->byTopCCKBasicRate);
-        uCTSTime = uAckTime = BBuGetFrameTime(pDevice->byPreambleType, byPktType, 14, pDevice->byTopCCKBasicRate);
-    }
-    else if (byRTSRsvType == 1){ //RTSTxRrvTime_ba, only in 2.4GHZ
-        uRTSTime = BBuGetFrameTime(pDevice->byPreambleType, byPktType, 20, pDevice->byTopCCKBasicRate);
-        uCTSTime = BBuGetFrameTime(pDevice->byPreambleType, byPktType, 14, pDevice->byTopCCKBasicRate);
-        uAckTime = BBuGetFrameTime(pDevice->byPreambleType, byPktType, 14, pDevice->byTopOFDMBasicRate);
-    }
-    else if (byRTSRsvType == 2) { //RTSTxRrvTime_aa
-        uRTSTime = BBuGetFrameTime(pDevice->byPreambleType, byPktType, 20, pDevice->byTopOFDMBasicRate);
-        uCTSTime = uAckTime = BBuGetFrameTime(pDevice->byPreambleType, byPktType, 14, pDevice->byTopOFDMBasicRate);
-    }
-    else if (byRTSRsvType == 3) { //CTSTxRrvTime_ba, only in 2.4GHZ
-        uCTSTime = BBuGetFrameTime(pDevice->byPreambleType, byPktType, 14, pDevice->byTopCCKBasicRate);
-        uAckTime = BBuGetFrameTime(pDevice->byPreambleType, byPktType, 14, pDevice->byTopOFDMBasicRate);
-        uRrvTime = uCTSTime + uAckTime + uDataTime + 2*pDevice->uSIFS;
-        return uRrvTime;
-    }
+	data_time = BBuGetFrameTime(priv->byPreambleType, pkt_type,
+						frame_lenght, current_rate);
+
+	if (rsv_type == 0) {
+		rts_time = BBuGetFrameTime(priv->byPreambleType,
+			pkt_type, 20, priv->byTopCCKBasicRate);
+		cts_time = ack_time = BBuGetFrameTime(priv->byPreambleType,
+			pkt_type, 14, priv->byTopCCKBasicRate);
+	} else if (rsv_type == 1) {
+		rts_time = BBuGetFrameTime(priv->byPreambleType,
+			pkt_type, 20, priv->byTopCCKBasicRate);
+		cts_time = BBuGetFrameTime(priv->byPreambleType, pkt_type,
+			14, priv->byTopCCKBasicRate);
+		ack_time = BBuGetFrameTime(priv->byPreambleType, pkt_type,
+			14, priv->byTopOFDMBasicRate);
+	} else if (rsv_type == 2) {
+		rts_time = BBuGetFrameTime(priv->byPreambleType, pkt_type,
+			20, priv->byTopOFDMBasicRate);
+		cts_time = ack_time = BBuGetFrameTime(priv->byPreambleType,
+			pkt_type, 14, priv->byTopOFDMBasicRate);
+	} else if (rsv_type == 3) {
+		cts_time = BBuGetFrameTime(priv->byPreambleType, pkt_type,
+			14, priv->byTopCCKBasicRate);
+		ack_time = BBuGetFrameTime(priv->byPreambleType, pkt_type,
+			14, priv->byTopOFDMBasicRate);
+
+		rrv_time = cts_time + ack_time + data_time + 2 * priv->uSIFS;
+
+		return rrv_time;
+	}
+
+	rrv_time = rts_time + cts_time + ack_time + data_time + 3 * priv->uSIFS;
 
-    //RTSRrvTime
-    uRrvTime = uRTSTime + uCTSTime + uAckTime + uDataTime + 3*pDevice->uSIFS;
-	return cpu_to_le16((u16)uRrvTime);
+	return cpu_to_le16((u16)rrv_time);
 }
 
 //byFreqType 0: 5GHz, 1:2.4Ghz
-- 
1.8.5.2

