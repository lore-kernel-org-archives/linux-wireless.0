Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:43075 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542Ab3HUU6m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Aug 2013 16:58:42 -0400
Received: by mail-wi0-f176.google.com with SMTP id l12so1255263wiv.3
        for <linux-wireless@vger.kernel.org>; Wed, 21 Aug 2013 13:58:41 -0700 (PDT)
Message-ID: <1377118717.7253.7.camel@canaries32-MCP7A> (sfid-20130821_225845_622743_BB14759B)
Subject: [PATCH 1/2] staging: vt6656: rxtx.c s_uGetDataDuration return
 endian corrected u16.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Wed, 21 Aug 2013 21:58:37 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The return always be u16 endian corrected. For the
large part this is missing.

Fix uGetDataDuration to return u16 endian corrected.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 05e82ec..1d0611e 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -132,7 +132,7 @@ static void s_vFillRTSHead(struct vnt_private *pDevice, u8 byPktType,
 	void *pvRTS, u32 cbFrameLength, int bNeedAck, int bDisCRC,
 	struct ethhdr *psEthHeader, u16 wCurrentRate, u8 byFBOption);
 
-static u32 s_uGetDataDuration(struct vnt_private *pDevice, u8 byDurType,
+static u16 s_uGetDataDuration(struct vnt_private *pDevice, u8 byDurType,
 	u8 byPktType, int bNeedAck);
 
 static u16 s_uGetRTSCTSDuration(struct vnt_private *pDevice,
@@ -383,7 +383,7 @@ static u32 s_uGetRTSCTSRsvTime(struct vnt_private *pDevice,
 }
 
 //byFreqType 0: 5GHz, 1:2.4Ghz
-static u32 s_uGetDataDuration(struct vnt_private *pDevice, u8 byDurType,
+static u16 s_uGetDataDuration(struct vnt_private *pDevice, u8 byDurType,
 	u8 byPktType, int bNeedAck)
 {
 	u32 uAckTime = 0;
@@ -395,7 +395,7 @@ static u32 s_uGetDataDuration(struct vnt_private *pDevice, u8 byDurType,
 		else
 			uAckTime = BBuGetFrameTime(pDevice->byPreambleType,
 				byPktType, 14, pDevice->byTopOFDMBasicRate);
-		return pDevice->uSIFS + uAckTime;
+		return cpu_to_le16((u16)(pDevice->uSIFS + uAckTime));
 	}
 
 	return 0;
@@ -507,9 +507,9 @@ static u32 s_uFillDataHead(struct vnt_private *pDevice,
 		BBvCalculateParameter(pDevice, cbFrameLength,
 			pDevice->byTopCCKBasicRate, PK_TYPE_11B, &pBuf->b);
                 //Get Duration and TimeStamp
-		pBuf->wDuration_a = (u16)s_uGetDataDuration(pDevice, DATADUR_A,
+		pBuf->wDuration_a = s_uGetDataDuration(pDevice, DATADUR_A,
 							byPktType, bNeedAck);
-		pBuf->wDuration_b = (u16)s_uGetDataDuration(pDevice, DATADUR_B,
+		pBuf->wDuration_b = s_uGetDataDuration(pDevice, DATADUR_B,
 							PK_TYPE_11B, bNeedAck);
 
                 pBuf->wTimeStampOff_a = wTimeStampOff[pDevice->byPreambleType%2][wCurrentRate%MAX_RATE];
@@ -525,13 +525,13 @@ static u32 s_uFillDataHead(struct vnt_private *pDevice,
 		BBvCalculateParameter(pDevice, cbFrameLength,
 			pDevice->byTopCCKBasicRate, PK_TYPE_11B, &pBuf->b);
                 //Get Duration and TimeStamp
-		pBuf->wDuration_a = (u16)s_uGetDataDuration(pDevice, DATADUR_A,
+		pBuf->wDuration_a = s_uGetDataDuration(pDevice, DATADUR_A,
 							byPktType, bNeedAck);
-		pBuf->wDuration_b = (u16)s_uGetDataDuration(pDevice, DATADUR_B,
+		pBuf->wDuration_b = s_uGetDataDuration(pDevice, DATADUR_B,
 							PK_TYPE_11B, bNeedAck);
-		pBuf->wDuration_a_f0 = (u16)s_uGetDataDuration(pDevice,
+		pBuf->wDuration_a_f0 = s_uGetDataDuration(pDevice,
 					DATADUR_A_F0, byPktType, bNeedAck);
-		pBuf->wDuration_a_f1 = (u16)s_uGetDataDuration(pDevice,
+		pBuf->wDuration_a_f1 = s_uGetDataDuration(pDevice,
 					DATADUR_A_F1, byPktType, bNeedAck);
                 pBuf->wTimeStampOff_a = wTimeStampOff[pDevice->byPreambleType%2][wCurrentRate%MAX_RATE];
                 pBuf->wTimeStampOff_b = wTimeStampOff[pDevice->byPreambleType%2][pDevice->byTopCCKBasicRate%MAX_RATE];
@@ -546,11 +546,11 @@ static u32 s_uFillDataHead(struct vnt_private *pDevice,
 		BBvCalculateParameter(pDevice, cbFrameLength, wCurrentRate,
 			byPktType, &pBuf->a);
             //Get Duration and TimeStampOff
-		pBuf->wDuration = (u16)s_uGetDataDuration(pDevice, DATADUR_A,
+		pBuf->wDuration = s_uGetDataDuration(pDevice, DATADUR_A,
 					byPktType, bNeedAck);
-		pBuf->wDuration_f0 = (u16)s_uGetDataDuration(pDevice,
+		pBuf->wDuration_f0 = s_uGetDataDuration(pDevice,
 				DATADUR_A_F0, byPktType, bNeedAck);
-		pBuf->wDuration_f1 = (u16)s_uGetDataDuration(pDevice,
+		pBuf->wDuration_f1 = s_uGetDataDuration(pDevice,
 				DATADUR_A_F1, byPktType, bNeedAck);
                 pBuf->wTimeStampOff = wTimeStampOff[pDevice->byPreambleType%2][wCurrentRate%MAX_RATE];
             return (pBuf->wDuration);
@@ -561,7 +561,7 @@ static u32 s_uFillDataHead(struct vnt_private *pDevice,
 		BBvCalculateParameter(pDevice, cbFrameLength, wCurrentRate,
 			byPktType, &pBuf->ab);
             //Get Duration and TimeStampOff
-		pBuf->wDuration = (u16)s_uGetDataDuration(pDevice, DATADUR_A,
+		pBuf->wDuration = s_uGetDataDuration(pDevice, DATADUR_A,
 				byPktType, bNeedAck);
                 pBuf->wTimeStampOff = wTimeStampOff[pDevice->byPreambleType%2][wCurrentRate%MAX_RATE];
 
@@ -575,7 +575,7 @@ static u32 s_uFillDataHead(struct vnt_private *pDevice,
 		BBvCalculateParameter(pDevice, cbFrameLength, wCurrentRate,
 			byPktType, &pBuf->ab);
             //Get Duration and TimeStampOff
-		pBuf->wDuration = (u16)s_uGetDataDuration(pDevice, DATADUR_B,
+		pBuf->wDuration = s_uGetDataDuration(pDevice, DATADUR_B,
 				byPktType, bNeedAck);
                 pBuf->wTimeStampOff = wTimeStampOff[pDevice->byPreambleType%2][wCurrentRate%MAX_RATE];
 
@@ -1805,8 +1805,8 @@ CMD_STATUS csBeacon_xmit(struct vnt_private *pDevice,
 	BBvCalculateParameter(pDevice, cbFrameSize, wCurrentRate, PK_TYPE_11A,
 							&pTxDataHead->ab);
         //Get Duration and TimeStampOff
-	pTxDataHead->wDuration = cpu_to_le16((u16)s_uGetDataDuration(pDevice,
-				DATADUR_A, PK_TYPE_11A, false));
+	pTxDataHead->wDuration = s_uGetDataDuration(pDevice,
+					DATADUR_A, PK_TYPE_11A, false);
         pTxDataHead->wTimeStampOff = wTimeStampOff[pDevice->byPreambleType%2][wCurrentRate%MAX_RATE];
 	cbHeaderSize = wTxBufSize + sizeof(struct vnt_tx_datahead_ab);
     } else {
@@ -1818,8 +1818,8 @@ CMD_STATUS csBeacon_xmit(struct vnt_private *pDevice,
 	BBvCalculateParameter(pDevice, cbFrameSize, wCurrentRate, PK_TYPE_11B,
 							&pTxDataHead->ab);
         //Get Duration and TimeStampOff
-	pTxDataHead->wDuration = cpu_to_le16((u16)s_uGetDataDuration(pDevice,
-				DATADUR_B, PK_TYPE_11B, false));
+	pTxDataHead->wDuration = s_uGetDataDuration(pDevice,
+					DATADUR_B, PK_TYPE_11B, false);
         pTxDataHead->wTimeStampOff = wTimeStampOff[pDevice->byPreambleType%2][wCurrentRate%MAX_RATE];
 	cbHeaderSize = wTxBufSize + sizeof(struct vnt_tx_datahead_ab);
     }
-- 
1.8.1.2


