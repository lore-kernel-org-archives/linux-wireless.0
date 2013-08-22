Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:55799 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753262Ab3HVUDp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Aug 2013 16:03:45 -0400
Received: by mail-wg0-f54.google.com with SMTP id e12so2095883wgh.9
        for <linux-wireless@vger.kernel.org>; Thu, 22 Aug 2013 13:03:44 -0700 (PDT)
Message-ID: <1377201820.7702.4.camel@canaries32-MCP7A> (sfid-20130822_220348_894397_CE1711C5)
Subject: [PATCH] staging: vt6656: s_uGetRTSCTSRsvTime return u16 endian
 corrected value.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Thu, 22 Aug 2013 21:03:40 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

s_uGetRTSCTSRsvTime always needs to be corrected to u16 endian value.

Change function to return u16 endian corrected value.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index d4b9b60..4f36ec8 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -121,7 +121,7 @@ static void s_vSWencryption(struct vnt_private *pDevice,
 static unsigned int s_uGetTxRsvTime(struct vnt_private *pDevice, u8 byPktType,
 	u32 cbFrameLength, u16 wRate, int bNeedAck);
 
-static u32 s_uGetRTSCTSRsvTime(struct vnt_private *pDevice, u8 byRTSRsvType,
+static u16 s_uGetRTSCTSRsvTime(struct vnt_private *pDevice, u8 byRTSRsvType,
 	u8 byPktType, u32 cbFrameLength, u16 wCurrentRate);
 
 static void s_vFillCTSHead(struct vnt_private *pDevice, u32 uDMAIdx,
@@ -349,7 +349,7 @@ static u32 s_uGetTxRsvTime(struct vnt_private *pDevice, u8 byPktType,
 }
 
 //byFreqType: 0=>5GHZ 1=>2.4GHZ
-static u32 s_uGetRTSCTSRsvTime(struct vnt_private *pDevice,
+static u16 s_uGetRTSCTSRsvTime(struct vnt_private *pDevice,
 	u8 byRTSRsvType, u8 byPktType, u32 cbFrameLength, u16 wCurrentRate)
 {
 	u32 uRrvTime, uRTSTime, uCTSTime, uAckTime, uDataTime;
@@ -379,7 +379,7 @@ static u32 s_uGetRTSCTSRsvTime(struct vnt_private *pDevice,
 
     //RTSRrvTime
     uRrvTime = uRTSTime + uCTSTime + uAckTime + uDataTime + 3*pDevice->uSIFS;
-    return uRrvTime;
+	return cpu_to_le16((u16)uRrvTime);
 }
 
 //byFreqType 0: 5GHz, 1:2.4Ghz
@@ -876,9 +876,12 @@ static void s_vGenerateTxParameter(struct vnt_private *pDevice,
             if (pvRrvTime) {
 		struct vnt_rrv_time_rts *pBuf =
 			(struct vnt_rrv_time_rts *)pvRrvTime;
-                pBuf->wRTSTxRrvTime_aa = cpu_to_le16((u16)s_uGetRTSCTSRsvTime(pDevice, 2, byPktType, cbFrameSize, wCurrentRate));//2:RTSTxRrvTime_aa, 1:2.4GHz
-                pBuf->wRTSTxRrvTime_ba = cpu_to_le16((u16)s_uGetRTSCTSRsvTime(pDevice, 1, byPktType, cbFrameSize, wCurrentRate));//1:RTSTxRrvTime_ba, 1:2.4GHz
-                pBuf->wRTSTxRrvTime_bb = cpu_to_le16((u16)s_uGetRTSCTSRsvTime(pDevice, 0, byPktType, cbFrameSize, wCurrentRate));//0:RTSTxRrvTime_bb, 1:2.4GHz
+		pBuf->wRTSTxRrvTime_aa = s_uGetRTSCTSRsvTime(pDevice, 2,
+				byPktType, cbFrameSize, wCurrentRate);
+		pBuf->wRTSTxRrvTime_ba = s_uGetRTSCTSRsvTime(pDevice, 1,
+				byPktType, cbFrameSize, wCurrentRate);
+		pBuf->wRTSTxRrvTime_bb = s_uGetRTSCTSRsvTime(pDevice, 0,
+				byPktType, cbFrameSize, wCurrentRate);
                 pBuf->wTxRrvTime_a = cpu_to_le16((u16) s_uGetTxRsvTime(pDevice, byPktType, cbFrameSize, wCurrentRate, bNeedACK));//2.4G OFDM
                 pBuf->wTxRrvTime_b = cpu_to_le16((u16) s_uGetTxRsvTime(pDevice, PK_TYPE_11B, cbFrameSize, pDevice->byTopCCKBasicRate, bNeedACK));//1:CCK
             }
@@ -893,7 +896,8 @@ static void s_vGenerateTxParameter(struct vnt_private *pDevice,
 				(struct vnt_rrv_time_cts *)pvRrvTime;
                 pBuf->wTxRrvTime_a = cpu_to_le16((u16)s_uGetTxRsvTime(pDevice, byPktType, cbFrameSize, wCurrentRate, bNeedACK));//2.4G OFDM
                 pBuf->wTxRrvTime_b = cpu_to_le16((u16)s_uGetTxRsvTime(pDevice, PK_TYPE_11B, cbFrameSize, pDevice->byTopCCKBasicRate, bNeedACK));//1:CCK
-                pBuf->wCTSTxRrvTime_ba = cpu_to_le16((u16)s_uGetRTSCTSRsvTime(pDevice, 3, byPktType, cbFrameSize, wCurrentRate));//3:CTSTxRrvTime_Ba, 1:2.4GHz
+		pBuf->wCTSTxRrvTime_ba = s_uGetRTSCTSRsvTime(pDevice, 3,
+				byPktType, cbFrameSize, wCurrentRate);
             }
             //Fill CTS
             s_vFillCTSHead(pDevice, uDMAIdx, byPktType, pvCTS, cbFrameSize, bNeedACK, bDisCRC, wCurrentRate, byFBOption);
@@ -906,7 +910,8 @@ static void s_vGenerateTxParameter(struct vnt_private *pDevice,
             if (pvRrvTime) {
 		struct vnt_rrv_time_ab *pBuf =
 				(struct vnt_rrv_time_ab *)pvRrvTime;
-                pBuf->wRTSTxRrvTime = cpu_to_le16((u16)s_uGetRTSCTSRsvTime(pDevice, 2, byPktType, cbFrameSize, wCurrentRate));//2:RTSTxRrvTime_aa, 0:5GHz
+		pBuf->wRTSTxRrvTime = s_uGetRTSCTSRsvTime(pDevice, 2,
+				byPktType, cbFrameSize, wCurrentRate);
                 pBuf->wTxRrvTime = cpu_to_le16((u16)s_uGetTxRsvTime(pDevice, byPktType, cbFrameSize, wCurrentRate, bNeedACK));//0:OFDM
             }
             //Fill RTS
@@ -928,7 +933,8 @@ static void s_vGenerateTxParameter(struct vnt_private *pDevice,
             if (pvRrvTime) {
 		struct vnt_rrv_time_ab *pBuf =
 				(struct vnt_rrv_time_ab *)pvRrvTime;
-                pBuf->wRTSTxRrvTime = cpu_to_le16((u16)s_uGetRTSCTSRsvTime(pDevice, 0, byPktType, cbFrameSize, wCurrentRate));//0:RTSTxRrvTime_bb, 1:2.4GHz
+		pBuf->wRTSTxRrvTime = s_uGetRTSCTSRsvTime(pDevice, 0,
+				byPktType, cbFrameSize, wCurrentRate);
                 pBuf->wTxRrvTime = cpu_to_le16((u16)s_uGetTxRsvTime(pDevice, PK_TYPE_11B, cbFrameSize, wCurrentRate, bNeedACK));//1:CCK
             }
             //Fill RTS
-- 
1.8.1.2


