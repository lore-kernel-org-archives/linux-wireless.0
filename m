Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:52559 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175Ab3HXMPm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Aug 2013 08:15:42 -0400
Received: by mail-we0-f178.google.com with SMTP id u54so1369767wes.23
        for <linux-wireless@vger.kernel.org>; Sat, 24 Aug 2013 05:15:41 -0700 (PDT)
Message-ID: <1377346532.23229.21.camel@canaries32-MCP7A> (sfid-20130824_141552_115975_F27DA6E3)
Subject: [PATCH 5/5] staging: vt6656: s_vGenerateTxParameter pvRrvTime
 should never be NULL
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Sat, 24 Aug 2013 13:15:32 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If pvRrvTime is NULL the whole structure is NULL, so
remove if statements and consolidate to single return.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 64ce7f0..dd2bfc9 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -860,6 +860,9 @@ static void s_vGenerateTxParameter(struct vnt_private *pDevice,
         byFBOption = AUTO_FB_1;
     }
 
+	if (!pvRrvTime)
+		return;
+
     if (pDevice->bLongHeader)
         cbMACHdLen = WLAN_HDR_ADDR3_LEN + 6;
 
@@ -867,7 +870,6 @@ static void s_vGenerateTxParameter(struct vnt_private *pDevice,
 
         if (pvRTS != NULL) { //RTS_need
             //Fill RsvTime
-            if (pvRrvTime) {
 		struct vnt_rrv_time_rts *pBuf =
 			(struct vnt_rrv_time_rts *)pvRrvTime;
 		pBuf->wRTSTxRrvTime_aa = s_uGetRTSCTSRsvTime(pDevice, 2,
@@ -881,15 +883,12 @@ static void s_vGenerateTxParameter(struct vnt_private *pDevice,
 		pBuf->wTxRrvTime_b = vnt_rxtx_rsvtime_le16(pDevice,
 			PK_TYPE_11B, cbFrameSize, pDevice->byTopCCKBasicRate,
 				bNeedACK);
-            }
             //Fill RTS
 	    s_vFillRTSHead(pDevice, byPktType, pvRTS, cbFrameSize, bNeedACK,
 				psEthHeader, wCurrentRate, byFBOption);
         }
         else {//RTS_needless, PCF mode
-
             //Fill RsvTime
-            if (pvRrvTime) {
 		struct vnt_rrv_time_cts *pBuf =
 				(struct vnt_rrv_time_cts *)pvRrvTime;
 		pBuf->wTxRrvTime_a = vnt_rxtx_rsvtime_le16(pDevice, byPktType,
@@ -899,7 +898,6 @@ static void s_vGenerateTxParameter(struct vnt_private *pDevice,
 			pDevice->byTopCCKBasicRate, bNeedACK);
 		pBuf->wCTSTxRrvTime_ba = s_uGetRTSCTSRsvTime(pDevice, 3,
 				byPktType, cbFrameSize, wCurrentRate);
-            }
             //Fill CTS
 	    s_vFillCTSHead(pDevice, uDMAIdx, byPktType, pvCTS, cbFrameSize,
 			bNeedACK, wCurrentRate, byFBOption);
@@ -909,52 +907,44 @@ static void s_vGenerateTxParameter(struct vnt_private *pDevice,
 
         if (pvRTS != NULL) {//RTS_need, non PCF mode
             //Fill RsvTime
-            if (pvRrvTime) {
 		struct vnt_rrv_time_ab *pBuf =
 				(struct vnt_rrv_time_ab *)pvRrvTime;
 		pBuf->wRTSTxRrvTime = s_uGetRTSCTSRsvTime(pDevice, 2,
 				byPktType, cbFrameSize, wCurrentRate);
 		pBuf->wTxRrvTime = vnt_rxtx_rsvtime_le16(pDevice, byPktType,
 				cbFrameSize, wCurrentRate, bNeedACK);
-            }
             //Fill RTS
 	    s_vFillRTSHead(pDevice, byPktType, pvRTS, cbFrameSize, bNeedACK,
 			psEthHeader, wCurrentRate, byFBOption);
         }
         else if (pvRTS == NULL) {//RTS_needless, non PCF mode
             //Fill RsvTime
-            if (pvRrvTime) {
 		struct vnt_rrv_time_ab *pBuf =
 				(struct vnt_rrv_time_ab *)pvRrvTime;
 		pBuf->wTxRrvTime = vnt_rxtx_rsvtime_le16(pDevice, PK_TYPE_11A,
 			cbFrameSize, wCurrentRate, bNeedACK);
-            }
         }
     }
     else if (byPktType == PK_TYPE_11B) {
 
         if ((pvRTS != NULL)) {//RTS_need, non PCF mode
             //Fill RsvTime
-            if (pvRrvTime) {
 		struct vnt_rrv_time_ab *pBuf =
 				(struct vnt_rrv_time_ab *)pvRrvTime;
 		pBuf->wRTSTxRrvTime = s_uGetRTSCTSRsvTime(pDevice, 0,
 				byPktType, cbFrameSize, wCurrentRate);
 		pBuf->wTxRrvTime = vnt_rxtx_rsvtime_le16(pDevice, PK_TYPE_11B,
 				cbFrameSize, wCurrentRate, bNeedACK);
-            }
             //Fill RTS
 	    s_vFillRTSHead(pDevice, byPktType, pvRTS, cbFrameSize, bNeedACK,
 			psEthHeader, wCurrentRate, byFBOption);
         }
         else { //RTS_needless, non PCF mode
             //Fill RsvTime
-            if (pvRrvTime) {
 		struct vnt_rrv_time_ab *pBuf =
 				(struct vnt_rrv_time_ab *)pvRrvTime;
 		pBuf->wTxRrvTime = vnt_rxtx_rsvtime_le16(pDevice, PK_TYPE_11B,
 			cbFrameSize, wCurrentRate, bNeedACK);
-            }
         }
     }
     //DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"s_vGenerateTxParameter END.\n");
-- 
1.8.1.2

