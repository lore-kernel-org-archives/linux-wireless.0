Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:59682 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbaH3V0a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Aug 2014 17:26:30 -0400
Received: by mail-wi0-f180.google.com with SMTP id ex7so4192280wid.13
        for <linux-wireless@vger.kernel.org>; Sat, 30 Aug 2014 14:26:28 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 04/23] staging: vt6655: create vnt_rxtx_rsvtime_le16 to return s_uGetTxRsvTime endian corrected.
Date: Sat, 30 Aug 2014 22:25:30 +0100
Message-Id: <1409433949-5468-4-git-send-email-tvboxspy@gmail.com> (sfid-20140830_232634_757236_8E1AC7DB)
In-Reply-To: <1409433949-5468-1-git-send-email-tvboxspy@gmail.com>
References: <1409433949-5468-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace s_uGetTxRsvTime where endian correction is needed.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/rxtx.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/vt6655/rxtx.c b/drivers/staging/vt6655/rxtx.c
index a0b8384..627bfbd 100644
--- a/drivers/staging/vt6655/rxtx.c
+++ b/drivers/staging/vt6655/rxtx.c
@@ -366,6 +366,13 @@ s_uGetTxRsvTime(
 		return uDataTime;
 }
 
+static __le16 vnt_rxtx_rsvtime_le16(struct vnt_private *priv, u8 pkt_type,
+				    u32 frame_length, u16 rate, bool need_ack)
+{
+	return cpu_to_le16((u16)s_uGetTxRsvTime(priv, pkt_type,
+						frame_length, rate, need_ack));
+}
+
 //byFreqType: 0=>5GHZ 1=>2.4GHZ
 static
 unsigned int
@@ -1086,8 +1093,8 @@ s_vGenerateTxParameter(
 				buf->rts_rrv_time_aa = cpu_to_le16((u16)s_uGetRTSCTSRsvTime(pDevice, 2, byPktType, cbFrameSize, wCurrentRate));
 				buf->rts_rrv_time_ba = cpu_to_le16((u16)s_uGetRTSCTSRsvTime(pDevice, 1, byPktType, cbFrameSize, wCurrentRate));
 				buf->rts_rrv_time_bb = cpu_to_le16((u16)s_uGetRTSCTSRsvTime(pDevice, 0, byPktType, cbFrameSize, wCurrentRate));
-				buf->rrv_time_a = cpu_to_le16((u16)s_uGetTxRsvTime(pDevice, byPktType, cbFrameSize, wCurrentRate, bNeedACK));
-				buf->rrv_time_b = cpu_to_le16((u16)s_uGetTxRsvTime(pDevice, PK_TYPE_11B, cbFrameSize, pDevice->byTopCCKBasicRate, bNeedACK));
+				buf->rrv_time_a = vnt_rxtx_rsvtime_le16(pDevice, byPktType, cbFrameSize, wCurrentRate, bNeedACK);
+				buf->rrv_time_b = vnt_rxtx_rsvtime_le16(pDevice, PK_TYPE_11B, cbFrameSize, pDevice->byTopCCKBasicRate, bNeedACK);
 			}
 			//Fill RTS
 			s_vFillRTSHead(pDevice, byPktType, pvRTS, cbFrameSize, bNeedACK, bDisCRC, psEthHeader, wCurrentRate, byFBOption);
@@ -1097,8 +1104,8 @@ s_vGenerateTxParameter(
 			if (pvRrvTime) {
 				struct vnt_rrv_time_cts *buf = pvRrvTime;
 
-				buf->rrv_time_a = cpu_to_le16((u16)s_uGetTxRsvTime(pDevice, byPktType, cbFrameSize, wCurrentRate, bNeedACK));
-				buf->rrv_time_b = cpu_to_le16((u16)s_uGetTxRsvTime(pDevice, PK_TYPE_11B, cbFrameSize, pDevice->byTopCCKBasicRate, bNeedACK));
+				buf->rrv_time_a = vnt_rxtx_rsvtime_le16(pDevice, byPktType, cbFrameSize, wCurrentRate, bNeedACK);
+				buf->rrv_time_b = vnt_rxtx_rsvtime_le16(pDevice, PK_TYPE_11B, cbFrameSize, pDevice->byTopCCKBasicRate, bNeedACK);
 				buf->cts_rrv_time_ba = cpu_to_le16((u16)s_uGetRTSCTSRsvTime(pDevice, 3, byPktType, cbFrameSize, wCurrentRate));
 			}
 
@@ -1112,7 +1119,7 @@ s_vGenerateTxParameter(
 				struct vnt_rrv_time_ab *buf = pvRrvTime;
 
 				buf->rts_rrv_time = cpu_to_le16((u16)s_uGetRTSCTSRsvTime(pDevice, 2, byPktType, cbFrameSize, wCurrentRate));
-				buf->rrv_time = cpu_to_le16((u16)s_uGetTxRsvTime(pDevice, byPktType, cbFrameSize, wCurrentRate, bNeedACK));
+				buf->rrv_time = vnt_rxtx_rsvtime_le16(pDevice, byPktType, cbFrameSize, wCurrentRate, bNeedACK);
 			}
 			//Fill RTS
 			s_vFillRTSHead(pDevice, byPktType, pvRTS, cbFrameSize, bNeedACK, bDisCRC, psEthHeader, wCurrentRate, byFBOption);
@@ -1121,7 +1128,7 @@ s_vGenerateTxParameter(
 			if (pvRrvTime) {
 				struct vnt_rrv_time_ab *buf = pvRrvTime;
 
-				buf->rrv_time = cpu_to_le16((u16)s_uGetTxRsvTime(pDevice, PK_TYPE_11A, cbFrameSize, wCurrentRate, bNeedACK));
+				buf->rrv_time = vnt_rxtx_rsvtime_le16(pDevice, PK_TYPE_11A, cbFrameSize, wCurrentRate, bNeedACK);
 			}
 		}
 	} else if (byPktType == PK_TYPE_11B) {
@@ -1131,7 +1138,7 @@ s_vGenerateTxParameter(
 				struct vnt_rrv_time_ab *buf = pvRrvTime;
 
 				buf->rts_rrv_time = cpu_to_le16((u16)s_uGetRTSCTSRsvTime(pDevice, 0, byPktType, cbFrameSize, wCurrentRate));
-				buf->rrv_time = cpu_to_le16((u16)s_uGetTxRsvTime(pDevice, PK_TYPE_11B, cbFrameSize, wCurrentRate, bNeedACK));
+				buf->rrv_time = vnt_rxtx_rsvtime_le16(pDevice, PK_TYPE_11B, cbFrameSize, wCurrentRate, bNeedACK);
 			}
 			//Fill RTS
 			s_vFillRTSHead(pDevice, byPktType, pvRTS, cbFrameSize, bNeedACK, bDisCRC, psEthHeader, wCurrentRate, byFBOption);
@@ -1140,7 +1147,7 @@ s_vGenerateTxParameter(
 			if (pvRrvTime) {
 				struct vnt_rrv_time_ab *buf = pvRrvTime;
 
-				buf->rrv_time = cpu_to_le16((u16)s_uGetTxRsvTime(pDevice, PK_TYPE_11B, cbFrameSize, wCurrentRate, bNeedACK));
+				buf->rrv_time = vnt_rxtx_rsvtime_le16(pDevice, PK_TYPE_11B, cbFrameSize, wCurrentRate, bNeedACK);
 			}
 		}
 	}
-- 
1.9.1

