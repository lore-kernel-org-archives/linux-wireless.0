Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:33717 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbaFDR0t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2014 13:26:49 -0400
Received: by mail-we0-f169.google.com with SMTP id u56so9040948wes.0
        for <linux-wireless@vger.kernel.org>; Wed, 04 Jun 2014 10:26:47 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 15/15] staging: vt6656: rename BBuGetFrameTime to vnt_get_frame_time
Date: Wed,  4 Jun 2014 18:25:35 +0100
Message-Id: <1401902735-3882-15-git-send-email-tvboxspy@gmail.com> (sfid-20140604_194613_804479_B7D29525)
In-Reply-To: <1401902735-3882-1-git-send-email-tvboxspy@gmail.com>
References: <1401902735-3882-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/baseband.c |  4 ++--
 drivers/staging/vt6656/baseband.h |  2 +-
 drivers/staging/vt6656/rxtx.c     | 42 +++++++++++++++++++--------------------
 3 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index b74c412..d99aae5 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -26,7 +26,7 @@
  * Date: Jun. 5, 2002
  *
  * Functions:
- *      BBuGetFrameTime        - Calculate data frame transmitting time
+ *      vnt_get_frame_time        - Calculate data frame transmitting time
  *      vnt_get_phy_field   - Calculate PhyLength, PhyService and Phy Signal parameter for baseband Tx
  *      BBbVT3184Init          - VIA VT3184 baseband chip init code
  *
@@ -646,7 +646,7 @@ static const u16 awcFrameTime[MAX_RATE] =
  * Return Value: FrameTime
  *
  */
-unsigned int BBuGetFrameTime(u8 preamble_type, u8 pkt_type,
+unsigned int vnt_get_frame_time(u8 preamble_type, u8 pkt_type,
 	unsigned int frame_length, u16 tx_rate)
 {
 	unsigned int frame_time;
diff --git a/drivers/staging/vt6656/baseband.h b/drivers/staging/vt6656/baseband.h
index 002e58e..4160695 100644
--- a/drivers/staging/vt6656/baseband.h
+++ b/drivers/staging/vt6656/baseband.h
@@ -88,7 +88,7 @@ struct vnt_phy_field {
 	__le16 len;
 } __packed;
 
-unsigned int BBuGetFrameTime(u8 preamble_type, u8 pkt_type,
+unsigned int vnt_get_frame_time(u8 preamble_type, u8 pkt_type,
 	unsigned int frame_length, u16 tx_rate);
 
 void vnt_get_phy_field(struct vnt_private *, u32 frame_length,
diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 9604b8e..3c19288 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -344,15 +344,15 @@ static u32 s_uGetTxRsvTime(struct vnt_private *priv, u8 pkt_type,
 {
 	u32 data_time, ack_time;
 
-	data_time = BBuGetFrameTime(priv->byPreambleType, pkt_type,
+	data_time = vnt_get_frame_time(priv->byPreambleType, pkt_type,
 							frame_length, rate);
 
 	if (pkt_type == PK_TYPE_11B)
-		ack_time = BBuGetFrameTime(priv->byPreambleType, pkt_type, 14,
-						(u16)priv->byTopCCKBasicRate);
+		ack_time = vnt_get_frame_time(priv->byPreambleType, pkt_type,
+					14, (u16)priv->byTopCCKBasicRate);
 	else
-		ack_time = BBuGetFrameTime(priv->byPreambleType, pkt_type, 14,
-						(u16)priv->byTopOFDMBasicRate);
+		ack_time = vnt_get_frame_time(priv->byPreambleType, pkt_type,
+					14, (u16)priv->byTopOFDMBasicRate);
 
 	if (need_ack)
 		return data_time + priv->uSIFS + ack_time;
@@ -375,30 +375,30 @@ static __le16 s_uGetRTSCTSRsvTime(struct vnt_private *priv,
 
 	rrv_time = rts_time = cts_time = ack_time = data_time = 0;
 
-	data_time = BBuGetFrameTime(priv->byPreambleType, pkt_type,
+	data_time = vnt_get_frame_time(priv->byPreambleType, pkt_type,
 						frame_length, current_rate);
 
 	if (rsv_type == 0) {
-		rts_time = BBuGetFrameTime(priv->byPreambleType,
+		rts_time = vnt_get_frame_time(priv->byPreambleType,
 			pkt_type, 20, priv->byTopCCKBasicRate);
-		cts_time = ack_time = BBuGetFrameTime(priv->byPreambleType,
+		cts_time = ack_time = vnt_get_frame_time(priv->byPreambleType,
 			pkt_type, 14, priv->byTopCCKBasicRate);
 	} else if (rsv_type == 1) {
-		rts_time = BBuGetFrameTime(priv->byPreambleType,
+		rts_time = vnt_get_frame_time(priv->byPreambleType,
 			pkt_type, 20, priv->byTopCCKBasicRate);
-		cts_time = BBuGetFrameTime(priv->byPreambleType, pkt_type,
+		cts_time = vnt_get_frame_time(priv->byPreambleType, pkt_type,
 			14, priv->byTopCCKBasicRate);
-		ack_time = BBuGetFrameTime(priv->byPreambleType, pkt_type,
+		ack_time = vnt_get_frame_time(priv->byPreambleType, pkt_type,
 			14, priv->byTopOFDMBasicRate);
 	} else if (rsv_type == 2) {
-		rts_time = BBuGetFrameTime(priv->byPreambleType, pkt_type,
+		rts_time = vnt_get_frame_time(priv->byPreambleType, pkt_type,
 			20, priv->byTopOFDMBasicRate);
-		cts_time = ack_time = BBuGetFrameTime(priv->byPreambleType,
+		cts_time = ack_time = vnt_get_frame_time(priv->byPreambleType,
 			pkt_type, 14, priv->byTopOFDMBasicRate);
 	} else if (rsv_type == 3) {
-		cts_time = BBuGetFrameTime(priv->byPreambleType, pkt_type,
+		cts_time = vnt_get_frame_time(priv->byPreambleType, pkt_type,
 			14, priv->byTopCCKBasicRate);
-		ack_time = BBuGetFrameTime(priv->byPreambleType, pkt_type,
+		ack_time = vnt_get_frame_time(priv->byPreambleType, pkt_type,
 			14, priv->byTopOFDMBasicRate);
 
 		rrv_time = cts_time + ack_time + data_time + 2 * priv->uSIFS;
@@ -419,10 +419,10 @@ static __le16 s_uGetDataDuration(struct vnt_private *pDevice,
 
 	if (bNeedAck) {
 		if (byPktType == PK_TYPE_11B)
-			uAckTime = BBuGetFrameTime(pDevice->byPreambleType,
+			uAckTime = vnt_get_frame_time(pDevice->byPreambleType,
 				byPktType, 14, pDevice->byTopCCKBasicRate);
 		else
-			uAckTime = BBuGetFrameTime(pDevice->byPreambleType,
+			uAckTime = vnt_get_frame_time(pDevice->byPreambleType,
 				byPktType, 14, pDevice->byTopOFDMBasicRate);
 		return cpu_to_le16((u16)(pDevice->uSIFS + uAckTime));
 	}
@@ -442,8 +442,8 @@ static __le16 s_uGetRTSCTSDuration(struct vnt_private *pDevice, u8 byDurType,
 	case RTSDUR_BA:
 	case RTSDUR_BA_F0:
 	case RTSDUR_BA_F1:
-		uCTSTime = BBuGetFrameTime(pDevice->byPreambleType, byPktType,
-			14, pDevice->byTopCCKBasicRate);
+		uCTSTime = vnt_get_frame_time(pDevice->byPreambleType,
+				byPktType, 14, pDevice->byTopCCKBasicRate);
 		uDurTime = uCTSTime + 2 * pDevice->uSIFS +
 			s_uGetTxRsvTime(pDevice, byPktType,
 						cbFrameLength, wRate, bNeedAck);
@@ -452,8 +452,8 @@ static __le16 s_uGetRTSCTSDuration(struct vnt_private *pDevice, u8 byDurType,
 	case RTSDUR_AA:
 	case RTSDUR_AA_F0:
 	case RTSDUR_AA_F1:
-		uCTSTime = BBuGetFrameTime(pDevice->byPreambleType, byPktType,
-			14, pDevice->byTopOFDMBasicRate);
+		uCTSTime = vnt_get_frame_time(pDevice->byPreambleType,
+				byPktType, 14, pDevice->byTopOFDMBasicRate);
 		uDurTime = uCTSTime + 2 * pDevice->uSIFS +
 			s_uGetTxRsvTime(pDevice, byPktType,
 						cbFrameLength, wRate, bNeedAck);
-- 
1.9.1

