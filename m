Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:59648 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427AbaH3V1C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Aug 2014 17:27:02 -0400
Received: by mail-we0-f172.google.com with SMTP id q59so3734641wes.3
        for <linux-wireless@vger.kernel.org>; Sat, 30 Aug 2014 14:27:00 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 22/23] staging: vt6655: s_uGetRTSCTSDuration always return __le16
Date: Sat, 30 Aug 2014 22:25:48 +0100
Message-Id: <1409433949-5468-22-git-send-email-tvboxspy@gmail.com> (sfid-20140830_234533_685427_0F384F3A)
In-Reply-To: <1409433949-5468-1-git-send-email-tvboxspy@gmail.com>
References: <1409433949-5468-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This function should always return __le16, move all endian
correction to here.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/rxtx.c | 149 ++++++++++++++++++++++++------------------
 1 file changed, 84 insertions(+), 65 deletions(-)

diff --git a/drivers/staging/vt6655/rxtx.c b/drivers/staging/vt6655/rxtx.c
index 3c8c499..0c69193 100644
--- a/drivers/staging/vt6655/rxtx.c
+++ b/drivers/staging/vt6655/rxtx.c
@@ -578,7 +578,7 @@ s_uGetDataDuration(
 
 //byFreqType: 0=>5GHZ 1=>2.4GHZ
 static
-unsigned int
+__le16
 s_uGetRTSCTSDuration(
 	struct vnt_private *pDevice,
 	unsigned char byDurType,
@@ -667,7 +667,7 @@ s_uGetRTSCTSDuration(
 		break;
 	}
 
-	return uDurTime;
+	return cpu_to_le16((u16)uDurTime);
 }
 
 static
@@ -829,17 +829,20 @@ s_vFillRTSHead(
 					  byPktType, &buf->a);
 			/* Get Duration */
 			buf->duration_bb =
-				cpu_to_le16((u16)s_uGetRTSCTSDuration(pDevice, RTSDUR_BB, cbFrameLength,
-								      PK_TYPE_11B, pDevice->byTopCCKBasicRate,
-								      bNeedAck, byFBOption));
+				s_uGetRTSCTSDuration(pDevice, RTSDUR_BB,
+						     cbFrameLength, PK_TYPE_11B,
+						     pDevice->byTopCCKBasicRate,
+						     bNeedAck, byFBOption);
 			buf->duration_aa =
-				cpu_to_le16((u16)s_uGetRTSCTSDuration(pDevice, RTSDUR_AA, cbFrameLength,
-								      byPktType, wCurrentRate, bNeedAck,
-								      byFBOption));
+				s_uGetRTSCTSDuration(pDevice, RTSDUR_AA,
+						     cbFrameLength, byPktType,
+						     wCurrentRate, bNeedAck,
+						     byFBOption);
 			buf->duration_ba =
-				cpu_to_le16((u16)s_uGetRTSCTSDuration(pDevice, RTSDUR_BA, cbFrameLength,
-								      byPktType, wCurrentRate, bNeedAck,
-								      byFBOption));
+				s_uGetRTSCTSDuration(pDevice, RTSDUR_BA,
+						     cbFrameLength, byPktType,
+						     wCurrentRate, bNeedAck,
+						     byFBOption);
 
 			buf->data.duration = buf->duration_aa;
 			/* Get RTS Frame body */
@@ -871,33 +874,40 @@ s_vFillRTSHead(
 					  byPktType, &buf->a);
 			/* Get Duration */
 			buf->duration_bb =
-				cpu_to_le16((u16)s_uGetRTSCTSDuration(pDevice, RTSDUR_BB, cbFrameLength,
-								      PK_TYPE_11B, pDevice->byTopCCKBasicRate,
-								      bNeedAck, byFBOption));
+				s_uGetRTSCTSDuration(pDevice, RTSDUR_BB,
+						     cbFrameLength, PK_TYPE_11B,
+						     pDevice->byTopCCKBasicRate,
+						     bNeedAck, byFBOption);
 			buf->duration_aa =
-				cpu_to_le16((u16)s_uGetRTSCTSDuration(pDevice, RTSDUR_AA, cbFrameLength,
-								      byPktType, wCurrentRate, bNeedAck,
-								      byFBOption));
+				s_uGetRTSCTSDuration(pDevice, RTSDUR_AA,
+						     cbFrameLength, byPktType,
+						     wCurrentRate, bNeedAck,
+						     byFBOption);
 			buf->duration_ba =
-				cpu_to_le16((u16)s_uGetRTSCTSDuration(pDevice, RTSDUR_BA, cbFrameLength,
-								      byPktType, wCurrentRate, bNeedAck,
-								      byFBOption));
+				s_uGetRTSCTSDuration(pDevice, RTSDUR_BA,
+						     cbFrameLength, byPktType,
+						     wCurrentRate, bNeedAck,
+						     byFBOption);
 			buf->rts_duration_ba_f0 =
-				cpu_to_le16((u16)s_uGetRTSCTSDuration(pDevice, RTSDUR_BA_F0, cbFrameLength,
-								      byPktType, wCurrentRate, bNeedAck,
-								      byFBOption));
+				s_uGetRTSCTSDuration(pDevice, RTSDUR_BA_F0,
+						     cbFrameLength, byPktType,
+						     wCurrentRate, bNeedAck,
+						     byFBOption);
 			buf->rts_duration_aa_f0 =
-				cpu_to_le16((u16)s_uGetRTSCTSDuration(pDevice, RTSDUR_AA_F0, cbFrameLength,
-								      byPktType, wCurrentRate, bNeedAck,
-								      byFBOption));
+				s_uGetRTSCTSDuration(pDevice, RTSDUR_AA_F0,
+						     cbFrameLength, byPktType,
+						     wCurrentRate, bNeedAck,
+						     byFBOption);
 			buf->rts_duration_ba_f1 =
-				cpu_to_le16((u16)s_uGetRTSCTSDuration(pDevice, RTSDUR_BA_F1, cbFrameLength,
-								      byPktType, wCurrentRate, bNeedAck,
-								      byFBOption));
+				s_uGetRTSCTSDuration(pDevice, RTSDUR_BA_F1,
+						     cbFrameLength, byPktType,
+						     wCurrentRate, bNeedAck,
+						     byFBOption);
 			buf->rts_duration_aa_f1 =
-				cpu_to_le16((u16)s_uGetRTSCTSDuration(pDevice, RTSDUR_AA_F1, cbFrameLength,
-								      byPktType, wCurrentRate, bNeedAck,
-								      byFBOption));
+				s_uGetRTSCTSDuration(pDevice, RTSDUR_AA_F1,
+						     cbFrameLength, byPktType,
+						     wCurrentRate, bNeedAck,
+						     byFBOption);
 			buf->data.duration = buf->duration_aa;
 			/* Get RTS Frame body */
 			buf->data.frame_control =
@@ -927,9 +937,10 @@ s_vFillRTSHead(
 					  byPktType, &buf->ab);
 			/* Get Duration */
 			buf->duration =
-				cpu_to_le16((u16)s_uGetRTSCTSDuration(pDevice, RTSDUR_AA, cbFrameLength,
-								      byPktType, wCurrentRate, bNeedAck,
-								      byFBOption));
+				s_uGetRTSCTSDuration(pDevice, RTSDUR_AA,
+						     cbFrameLength, byPktType,
+						     wCurrentRate, bNeedAck,
+						     byFBOption);
 			buf->data.duration = buf->duration;
 			/* Get RTS Frame body */
 			buf->data.frame_control =
@@ -957,17 +968,20 @@ s_vFillRTSHead(
 					  byPktType, &buf->a);
 			/* Get Duration */
 			buf->duration =
-				cpu_to_le16((u16)s_uGetRTSCTSDuration(pDevice, RTSDUR_AA, cbFrameLength,
-								      byPktType, wCurrentRate,
-								      bNeedAck, byFBOption));
+				s_uGetRTSCTSDuration(pDevice, RTSDUR_AA,
+						     cbFrameLength, byPktType,
+						     wCurrentRate, bNeedAck,
+						     byFBOption);
 			buf->rts_duration_f0 =
-				cpu_to_le16((u16)s_uGetRTSCTSDuration(pDevice, RTSDUR_AA_F0, cbFrameLength,
-								      byPktType, wCurrentRate,
-								      bNeedAck, byFBOption));
+				s_uGetRTSCTSDuration(pDevice, RTSDUR_AA_F0,
+						     cbFrameLength, byPktType,
+						     wCurrentRate, bNeedAck,
+						     byFBOption);
 			buf->rts_duration_f1 =
-				cpu_to_le16((u16)s_uGetRTSCTSDuration(pDevice, RTSDUR_AA_F1, cbFrameLength,
-								      byPktType, wCurrentRate,
-								      bNeedAck, byFBOption));
+				s_uGetRTSCTSDuration(pDevice, RTSDUR_AA_F1,
+						     cbFrameLength, byPktType,
+						     wCurrentRate, bNeedAck,
+						     byFBOption);
 			buf->data.duration = buf->duration;
 			/* Get RTS Frame body */
 			buf->data.frame_control =
@@ -993,9 +1007,10 @@ s_vFillRTSHead(
 				  PK_TYPE_11B, &buf->ab);
 		/* Get Duration */
 		buf->duration =
-			cpu_to_le16((u16)s_uGetRTSCTSDuration(pDevice, RTSDUR_BB, cbFrameLength,
-							      byPktType, wCurrentRate, bNeedAck,
-							      byFBOption));
+			s_uGetRTSCTSDuration(pDevice, RTSDUR_BB, cbFrameLength,
+					     byPktType, wCurrentRate, bNeedAck,
+					     byFBOption);
+
 		buf->data.duration = buf->duration;
 		/* Get RTS Frame body */
 		buf->data.frame_control =
@@ -1049,21 +1064,26 @@ s_vFillCTSHead(
 					  pDevice->byTopCCKBasicRate,
 					  PK_TYPE_11B, &buf->b);
 
-			buf->duration_ba = (u16)s_uGetRTSCTSDuration(pDevice, CTSDUR_BA, cbFrameLength,
-								     byPktType, wCurrentRate, bNeedAck, byFBOption);
-			buf->duration_ba = cpu_to_le16(buf->duration_ba);
-			/* Get CTSDuration_ba_f0 */
-			buf->cts_duration_ba_f0 = (u16)s_uGetRTSCTSDuration(pDevice, CTSDUR_BA_F0, cbFrameLength,
-									    byPktType, wCurrentRate,
-									    bNeedAck, byFBOption);
+			buf->duration_ba =
+				s_uGetRTSCTSDuration(pDevice, CTSDUR_BA,
+						     cbFrameLength, byPktType,
+						     wCurrentRate, bNeedAck,
+						     byFBOption);
 
-			buf->cts_duration_ba_f0 = cpu_to_le16(buf->cts_duration_ba_f0);
-			//Get CTSDuration_ba_f1
-			buf->cts_duration_ba_f1 = (u16)s_uGetRTSCTSDuration(pDevice, CTSDUR_BA_F1, cbFrameLength,
-									    byPktType, wCurrentRate,
-									    bNeedAck, byFBOption);
+			/* Get CTSDuration_ba_f0 */
+			buf->cts_duration_ba_f0 =
+				s_uGetRTSCTSDuration(pDevice, CTSDUR_BA_F0,
+						     cbFrameLength, byPktType,
+						     wCurrentRate, bNeedAck,
+						     byFBOption);
+
+			/* Get CTSDuration_ba_f1 */
+			buf->cts_duration_ba_f1 =
+				s_uGetRTSCTSDuration(pDevice, CTSDUR_BA_F1,
+						     cbFrameLength, byPktType,
+						     wCurrentRate, bNeedAck,
+						     byFBOption);
 
-			buf->cts_duration_ba_f1 = cpu_to_le16(buf->cts_duration_ba_f1);
 			/* Get CTS Frame body */
 			buf->data.duration = buf->duration_ba;
 
@@ -1083,11 +1103,10 @@ s_vFillCTSHead(
 
 			/* Get CTSDuration_ba */
 			buf->duration_ba =
-				cpu_to_le16((u16)s_uGetRTSCTSDuration(pDevice, CTSDUR_BA, cbFrameLength,
-								      byPktType, wCurrentRate, bNeedAck,
-								      byFBOption));
-
-			buf->duration_ba = cpu_to_le16(buf->duration_ba);
+				s_uGetRTSCTSDuration(pDevice, CTSDUR_BA,
+						     cbFrameLength, byPktType,
+						     wCurrentRate, bNeedAck,
+						     byFBOption);
 
 			/* Get CTS Frame body */
 			buf->data.duration = buf->duration_ba;
-- 
1.9.1

