Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:57307 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204AbaH3V0b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Aug 2014 17:26:31 -0400
Received: by mail-wg0-f52.google.com with SMTP id m15so3645098wgh.35
        for <linux-wireless@vger.kernel.org>; Sat, 30 Aug 2014 14:26:30 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 05/23] staging: vt6655: rxtx change s_uGetRTSCTSRsvTime to always return __le16
Date: Sat, 30 Aug 2014 22:25:31 +0100
Message-Id: <1409433949-5468-5-git-send-email-tvboxspy@gmail.com> (sfid-20140830_232638_130292_0777D6FC)
In-Reply-To: <1409433949-5468-1-git-send-email-tvboxspy@gmail.com>
References: <1409433949-5468-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

s_uGetRTSCTSRsvTime always needs to return little endian __le16

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/rxtx.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/vt6655/rxtx.c b/drivers/staging/vt6655/rxtx.c
index 627bfbd..ee20ae2 100644
--- a/drivers/staging/vt6655/rxtx.c
+++ b/drivers/staging/vt6655/rxtx.c
@@ -375,7 +375,7 @@ static __le16 vnt_rxtx_rsvtime_le16(struct vnt_private *priv, u8 pkt_type,
 
 //byFreqType: 0=>5GHZ 1=>2.4GHZ
 static
-unsigned int
+__le16
 s_uGetRTSCTSRsvTime(
 	struct vnt_private *pDevice,
 	unsigned char byRTSRsvType,
@@ -403,12 +403,12 @@ s_uGetRTSCTSRsvTime(
 		uCTSTime = BBuGetFrameTime(pDevice->byPreambleType, byPktType, 14, pDevice->byTopCCKBasicRate);
 		uAckTime = BBuGetFrameTime(pDevice->byPreambleType, byPktType, 14, pDevice->byTopOFDMBasicRate);
 		uRrvTime = uCTSTime + uAckTime + uDataTime + 2*pDevice->uSIFS;
-		return uRrvTime;
+		return cpu_to_le16((u16)uRrvTime);
 	}
 
 	//RTSRrvTime
 	uRrvTime = uRTSTime + uCTSTime + uAckTime + uDataTime + 3*pDevice->uSIFS;
-	return uRrvTime;
+	return cpu_to_le16((u16)uRrvTime);
 }
 
 //byFreqType 0: 5GHz, 1:2.4Ghz
@@ -1090,9 +1090,9 @@ s_vGenerateTxParameter(
 			if (pvRrvTime) {
 				struct vnt_rrv_time_rts *buf = pvRrvTime;
 
-				buf->rts_rrv_time_aa = cpu_to_le16((u16)s_uGetRTSCTSRsvTime(pDevice, 2, byPktType, cbFrameSize, wCurrentRate));
-				buf->rts_rrv_time_ba = cpu_to_le16((u16)s_uGetRTSCTSRsvTime(pDevice, 1, byPktType, cbFrameSize, wCurrentRate));
-				buf->rts_rrv_time_bb = cpu_to_le16((u16)s_uGetRTSCTSRsvTime(pDevice, 0, byPktType, cbFrameSize, wCurrentRate));
+				buf->rts_rrv_time_aa = s_uGetRTSCTSRsvTime(pDevice, 2, byPktType, cbFrameSize, wCurrentRate);
+				buf->rts_rrv_time_ba = s_uGetRTSCTSRsvTime(pDevice, 1, byPktType, cbFrameSize, wCurrentRate);
+				buf->rts_rrv_time_bb = s_uGetRTSCTSRsvTime(pDevice, 0, byPktType, cbFrameSize, wCurrentRate);
 				buf->rrv_time_a = vnt_rxtx_rsvtime_le16(pDevice, byPktType, cbFrameSize, wCurrentRate, bNeedACK);
 				buf->rrv_time_b = vnt_rxtx_rsvtime_le16(pDevice, PK_TYPE_11B, cbFrameSize, pDevice->byTopCCKBasicRate, bNeedACK);
 			}
@@ -1106,7 +1106,7 @@ s_vGenerateTxParameter(
 
 				buf->rrv_time_a = vnt_rxtx_rsvtime_le16(pDevice, byPktType, cbFrameSize, wCurrentRate, bNeedACK);
 				buf->rrv_time_b = vnt_rxtx_rsvtime_le16(pDevice, PK_TYPE_11B, cbFrameSize, pDevice->byTopCCKBasicRate, bNeedACK);
-				buf->cts_rrv_time_ba = cpu_to_le16((u16)s_uGetRTSCTSRsvTime(pDevice, 3, byPktType, cbFrameSize, wCurrentRate));
+				buf->cts_rrv_time_ba = s_uGetRTSCTSRsvTime(pDevice, 3, byPktType, cbFrameSize, wCurrentRate);
 			}
 
 			//Fill CTS
@@ -1118,7 +1118,7 @@ s_vGenerateTxParameter(
 			if (pvRrvTime) {
 				struct vnt_rrv_time_ab *buf = pvRrvTime;
 
-				buf->rts_rrv_time = cpu_to_le16((u16)s_uGetRTSCTSRsvTime(pDevice, 2, byPktType, cbFrameSize, wCurrentRate));
+				buf->rts_rrv_time = s_uGetRTSCTSRsvTime(pDevice, 2, byPktType, cbFrameSize, wCurrentRate);
 				buf->rrv_time = vnt_rxtx_rsvtime_le16(pDevice, byPktType, cbFrameSize, wCurrentRate, bNeedACK);
 			}
 			//Fill RTS
@@ -1137,7 +1137,7 @@ s_vGenerateTxParameter(
 			if (pvRrvTime) {
 				struct vnt_rrv_time_ab *buf = pvRrvTime;
 
-				buf->rts_rrv_time = cpu_to_le16((u16)s_uGetRTSCTSRsvTime(pDevice, 0, byPktType, cbFrameSize, wCurrentRate));
+				buf->rts_rrv_time = s_uGetRTSCTSRsvTime(pDevice, 0, byPktType, cbFrameSize, wCurrentRate);
 				buf->rrv_time = vnt_rxtx_rsvtime_le16(pDevice, PK_TYPE_11B, cbFrameSize, wCurrentRate, bNeedACK);
 			}
 			//Fill RTS
-- 
1.9.1

