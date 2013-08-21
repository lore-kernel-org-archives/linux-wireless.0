Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:33413 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159Ab3HUVQL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Aug 2013 17:16:11 -0400
Received: by mail-we0-f169.google.com with SMTP id t61so925561wes.28
        for <linux-wireless@vger.kernel.org>; Wed, 21 Aug 2013 14:16:10 -0700 (PDT)
Message-ID: <1377119764.7253.16.camel@canaries32-MCP7A> (sfid-20130821_231614_992175_AE058044)
Subject: [PATCH 2/2] staging: vt6656: rxtx.c: s_uGetDataDuration  Drop
 argument byDurType.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Wed, 21 Aug 2013 22:16:04 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When byDurType == DATADUR_B then byPktType == PK_TYPE_11B

Drop argument byDurType and filter on byPktType == PK_TYPE_11B.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 1d0611e..d4b9b60 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -132,7 +132,7 @@ static void s_vFillRTSHead(struct vnt_private *pDevice, u8 byPktType,
 	void *pvRTS, u32 cbFrameLength, int bNeedAck, int bDisCRC,
 	struct ethhdr *psEthHeader, u16 wCurrentRate, u8 byFBOption);
 
-static u16 s_uGetDataDuration(struct vnt_private *pDevice, u8 byDurType,
+static u16 s_uGetDataDuration(struct vnt_private *pDevice,
 	u8 byPktType, int bNeedAck);
 
 static u16 s_uGetRTSCTSDuration(struct vnt_private *pDevice,
@@ -383,13 +383,13 @@ static u32 s_uGetRTSCTSRsvTime(struct vnt_private *pDevice,
 }
 
 //byFreqType 0: 5GHz, 1:2.4Ghz
-static u16 s_uGetDataDuration(struct vnt_private *pDevice, u8 byDurType,
-	u8 byPktType, int bNeedAck)
+static u16 s_uGetDataDuration(struct vnt_private *pDevice,
+					u8 byPktType, int bNeedAck)
 {
 	u32 uAckTime = 0;
 
 	if (bNeedAck) {
-		if (byDurType == DATADUR_B)
+		if (byPktType == PK_TYPE_11B)
 			uAckTime = BBuGetFrameTime(pDevice->byPreambleType,
 				byPktType, 14, pDevice->byTopCCKBasicRate);
 		else
@@ -507,9 +507,9 @@ static u32 s_uFillDataHead(struct vnt_private *pDevice,
 		BBvCalculateParameter(pDevice, cbFrameLength,
 			pDevice->byTopCCKBasicRate, PK_TYPE_11B, &pBuf->b);
                 //Get Duration and TimeStamp
-		pBuf->wDuration_a = s_uGetDataDuration(pDevice, DATADUR_A,
+		pBuf->wDuration_a = s_uGetDataDuration(pDevice,
 							byPktType, bNeedAck);
-		pBuf->wDuration_b = s_uGetDataDuration(pDevice, DATADUR_B,
+		pBuf->wDuration_b = s_uGetDataDuration(pDevice,
 							PK_TYPE_11B, bNeedAck);
 
                 pBuf->wTimeStampOff_a = wTimeStampOff[pDevice->byPreambleType%2][wCurrentRate%MAX_RATE];
@@ -525,14 +525,14 @@ static u32 s_uFillDataHead(struct vnt_private *pDevice,
 		BBvCalculateParameter(pDevice, cbFrameLength,
 			pDevice->byTopCCKBasicRate, PK_TYPE_11B, &pBuf->b);
                 //Get Duration and TimeStamp
-		pBuf->wDuration_a = s_uGetDataDuration(pDevice, DATADUR_A,
+		pBuf->wDuration_a = s_uGetDataDuration(pDevice,
 							byPktType, bNeedAck);
-		pBuf->wDuration_b = s_uGetDataDuration(pDevice, DATADUR_B,
+		pBuf->wDuration_b = s_uGetDataDuration(pDevice,
 							PK_TYPE_11B, bNeedAck);
 		pBuf->wDuration_a_f0 = s_uGetDataDuration(pDevice,
-					DATADUR_A_F0, byPktType, bNeedAck);
+							byPktType, bNeedAck);
 		pBuf->wDuration_a_f1 = s_uGetDataDuration(pDevice,
-					DATADUR_A_F1, byPktType, bNeedAck);
+							byPktType, bNeedAck);
                 pBuf->wTimeStampOff_a = wTimeStampOff[pDevice->byPreambleType%2][wCurrentRate%MAX_RATE];
                 pBuf->wTimeStampOff_b = wTimeStampOff[pDevice->byPreambleType%2][pDevice->byTopCCKBasicRate%MAX_RATE];
                 return (pBuf->wDuration_a);
@@ -546,12 +546,12 @@ static u32 s_uFillDataHead(struct vnt_private *pDevice,
 		BBvCalculateParameter(pDevice, cbFrameLength, wCurrentRate,
 			byPktType, &pBuf->a);
             //Get Duration and TimeStampOff
-		pBuf->wDuration = s_uGetDataDuration(pDevice, DATADUR_A,
+		pBuf->wDuration = s_uGetDataDuration(pDevice,
 					byPktType, bNeedAck);
 		pBuf->wDuration_f0 = s_uGetDataDuration(pDevice,
-				DATADUR_A_F0, byPktType, bNeedAck);
+					byPktType, bNeedAck);
 		pBuf->wDuration_f1 = s_uGetDataDuration(pDevice,
-				DATADUR_A_F1, byPktType, bNeedAck);
+							byPktType, bNeedAck);
                 pBuf->wTimeStampOff = wTimeStampOff[pDevice->byPreambleType%2][wCurrentRate%MAX_RATE];
             return (pBuf->wDuration);
         } else {
@@ -561,7 +561,7 @@ static u32 s_uFillDataHead(struct vnt_private *pDevice,
 		BBvCalculateParameter(pDevice, cbFrameLength, wCurrentRate,
 			byPktType, &pBuf->ab);
             //Get Duration and TimeStampOff
-		pBuf->wDuration = s_uGetDataDuration(pDevice, DATADUR_A,
+		pBuf->wDuration = s_uGetDataDuration(pDevice,
 				byPktType, bNeedAck);
                 pBuf->wTimeStampOff = wTimeStampOff[pDevice->byPreambleType%2][wCurrentRate%MAX_RATE];
 
@@ -575,7 +575,7 @@ static u32 s_uFillDataHead(struct vnt_private *pDevice,
 		BBvCalculateParameter(pDevice, cbFrameLength, wCurrentRate,
 			byPktType, &pBuf->ab);
             //Get Duration and TimeStampOff
-		pBuf->wDuration = s_uGetDataDuration(pDevice, DATADUR_B,
+		pBuf->wDuration = s_uGetDataDuration(pDevice,
 				byPktType, bNeedAck);
                 pBuf->wTimeStampOff = wTimeStampOff[pDevice->byPreambleType%2][wCurrentRate%MAX_RATE];
 
@@ -1806,7 +1806,7 @@ CMD_STATUS csBeacon_xmit(struct vnt_private *pDevice,
 							&pTxDataHead->ab);
         //Get Duration and TimeStampOff
 	pTxDataHead->wDuration = s_uGetDataDuration(pDevice,
-					DATADUR_A, PK_TYPE_11A, false);
+						PK_TYPE_11A, false);
         pTxDataHead->wTimeStampOff = wTimeStampOff[pDevice->byPreambleType%2][wCurrentRate%MAX_RATE];
 	cbHeaderSize = wTxBufSize + sizeof(struct vnt_tx_datahead_ab);
     } else {
@@ -1819,7 +1819,7 @@ CMD_STATUS csBeacon_xmit(struct vnt_private *pDevice,
 							&pTxDataHead->ab);
         //Get Duration and TimeStampOff
 	pTxDataHead->wDuration = s_uGetDataDuration(pDevice,
-					DATADUR_B, PK_TYPE_11B, false);
+						PK_TYPE_11B, false);
         pTxDataHead->wTimeStampOff = wTimeStampOff[pDevice->byPreambleType%2][wCurrentRate%MAX_RATE];
 	cbHeaderSize = wTxBufSize + sizeof(struct vnt_tx_datahead_ab);
     }
-- 
1.8.1.2


