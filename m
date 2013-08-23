Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:54607 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754768Ab3HWKce (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Aug 2013 06:32:34 -0400
Received: by mail-ee0-f44.google.com with SMTP id b47so209071eek.17
        for <linux-wireless@vger.kernel.org>; Fri, 23 Aug 2013 03:32:33 -0700 (PDT)
Message-ID: <1377253946.8002.12.camel@canaries32-MCP7A> (sfid-20130823_123253_889050_E5A2A85D)
Subject: [PATCH] staging: vt6656: rxtx.c s_create new function to endian
 correct uGetTxRsvTime.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Fri, 23 Aug 2013 11:32:26 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We can't endian correct uGetTxRsvTime because it is called by other functions.

Create new function to vnt_rxtx_rsvtime_le16 to return little endian u16
value.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 33 +++++++++++++++++++++++++--------
 1 file changed, 25 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 4f36ec8..f1eec60 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -348,6 +348,13 @@ static u32 s_uGetTxRsvTime(struct vnt_private *pDevice, u8 byPktType,
     }
 }
 
+static u16 vnt_rxtx_rsvtime_le16(struct vnt_private *priv, u8 pkt_type,
+	u32 frame_length, u16 rate, int need_ack)
+{
+	return cpu_to_le16((u16)s_uGetTxRsvTime(priv, pkt_type,
+		frame_length, rate, need_ack));
+}
+
 //byFreqType: 0=>5GHZ 1=>2.4GHZ
 static u16 s_uGetRTSCTSRsvTime(struct vnt_private *pDevice,
 	u8 byRTSRsvType, u8 byPktType, u32 cbFrameLength, u16 wCurrentRate)
@@ -882,8 +889,11 @@ static void s_vGenerateTxParameter(struct vnt_private *pDevice,
 				byPktType, cbFrameSize, wCurrentRate);
 		pBuf->wRTSTxRrvTime_bb = s_uGetRTSCTSRsvTime(pDevice, 0,
 				byPktType, cbFrameSize, wCurrentRate);
-                pBuf->wTxRrvTime_a = cpu_to_le16((u16) s_uGetTxRsvTime(pDevice, byPktType, cbFrameSize, wCurrentRate, bNeedACK));//2.4G OFDM
-                pBuf->wTxRrvTime_b = cpu_to_le16((u16) s_uGetTxRsvTime(pDevice, PK_TYPE_11B, cbFrameSize, pDevice->byTopCCKBasicRate, bNeedACK));//1:CCK
+		pBuf->wTxRrvTime_a = vnt_rxtx_rsvtime_le16(pDevice,
+			byPktType, cbFrameSize, wCurrentRate, bNeedACK);
+		pBuf->wTxRrvTime_b = vnt_rxtx_rsvtime_le16(pDevice,
+			PK_TYPE_11B, cbFrameSize, pDevice->byTopCCKBasicRate,
+				bNeedACK);
             }
             //Fill RTS
             s_vFillRTSHead(pDevice, byPktType, pvRTS, cbFrameSize, bNeedACK, bDisCRC, psEthHeader, wCurrentRate, byFBOption);
@@ -894,8 +904,11 @@ static void s_vGenerateTxParameter(struct vnt_private *pDevice,
             if (pvRrvTime) {
 		struct vnt_rrv_time_cts *pBuf =
 				(struct vnt_rrv_time_cts *)pvRrvTime;
-                pBuf->wTxRrvTime_a = cpu_to_le16((u16)s_uGetTxRsvTime(pDevice, byPktType, cbFrameSize, wCurrentRate, bNeedACK));//2.4G OFDM
-                pBuf->wTxRrvTime_b = cpu_to_le16((u16)s_uGetTxRsvTime(pDevice, PK_TYPE_11B, cbFrameSize, pDevice->byTopCCKBasicRate, bNeedACK));//1:CCK
+		pBuf->wTxRrvTime_a = vnt_rxtx_rsvtime_le16(pDevice, byPktType,
+			cbFrameSize, wCurrentRate, bNeedACK);
+		pBuf->wTxRrvTime_b = vnt_rxtx_rsvtime_le16(pDevice,
+			PK_TYPE_11B, cbFrameSize,
+			pDevice->byTopCCKBasicRate, bNeedACK);
 		pBuf->wCTSTxRrvTime_ba = s_uGetRTSCTSRsvTime(pDevice, 3,
 				byPktType, cbFrameSize, wCurrentRate);
             }
@@ -912,7 +925,8 @@ static void s_vGenerateTxParameter(struct vnt_private *pDevice,
 				(struct vnt_rrv_time_ab *)pvRrvTime;
 		pBuf->wRTSTxRrvTime = s_uGetRTSCTSRsvTime(pDevice, 2,
 				byPktType, cbFrameSize, wCurrentRate);
-                pBuf->wTxRrvTime = cpu_to_le16((u16)s_uGetTxRsvTime(pDevice, byPktType, cbFrameSize, wCurrentRate, bNeedACK));//0:OFDM
+		pBuf->wTxRrvTime = vnt_rxtx_rsvtime_le16(pDevice, byPktType,
+				cbFrameSize, wCurrentRate, bNeedACK);
             }
             //Fill RTS
             s_vFillRTSHead(pDevice, byPktType, pvRTS, cbFrameSize, bNeedACK, bDisCRC, psEthHeader, wCurrentRate, byFBOption);
@@ -922,7 +936,8 @@ static void s_vGenerateTxParameter(struct vnt_private *pDevice,
             if (pvRrvTime) {
 		struct vnt_rrv_time_ab *pBuf =
 				(struct vnt_rrv_time_ab *)pvRrvTime;
-                pBuf->wTxRrvTime = cpu_to_le16((u16)s_uGetTxRsvTime(pDevice, PK_TYPE_11A, cbFrameSize, wCurrentRate, bNeedACK)); //0:OFDM
+		pBuf->wTxRrvTime = vnt_rxtx_rsvtime_le16(pDevice, PK_TYPE_11A,
+			cbFrameSize, wCurrentRate, bNeedACK);
             }
         }
     }
@@ -935,7 +950,8 @@ static void s_vGenerateTxParameter(struct vnt_private *pDevice,
 				(struct vnt_rrv_time_ab *)pvRrvTime;
 		pBuf->wRTSTxRrvTime = s_uGetRTSCTSRsvTime(pDevice, 0,
 				byPktType, cbFrameSize, wCurrentRate);
-                pBuf->wTxRrvTime = cpu_to_le16((u16)s_uGetTxRsvTime(pDevice, PK_TYPE_11B, cbFrameSize, wCurrentRate, bNeedACK));//1:CCK
+		pBuf->wTxRrvTime = vnt_rxtx_rsvtime_le16(pDevice, PK_TYPE_11B,
+				cbFrameSize, wCurrentRate, bNeedACK);
             }
             //Fill RTS
             s_vFillRTSHead(pDevice, byPktType, pvRTS, cbFrameSize, bNeedACK, bDisCRC, psEthHeader, wCurrentRate, byFBOption);
@@ -945,7 +961,8 @@ static void s_vGenerateTxParameter(struct vnt_private *pDevice,
             if (pvRrvTime) {
 		struct vnt_rrv_time_ab *pBuf =
 				(struct vnt_rrv_time_ab *)pvRrvTime;
-                pBuf->wTxRrvTime = cpu_to_le16((u16)s_uGetTxRsvTime(pDevice, PK_TYPE_11B, cbFrameSize, wCurrentRate, bNeedACK)); //1:CCK
+		pBuf->wTxRrvTime = vnt_rxtx_rsvtime_le16(pDevice, PK_TYPE_11B,
+			cbFrameSize, wCurrentRate, bNeedACK);
             }
         }
     }
-- 
1.8.1.2

