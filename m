Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:54685 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933014Ab3HGU2v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Aug 2013 16:28:51 -0400
Received: by mail-ee0-f41.google.com with SMTP id d17so1124163eek.28
        for <linux-wireless@vger.kernel.org>; Wed, 07 Aug 2013 13:28:50 -0700 (PDT)
Message-ID: <1375907325.5626.38.camel@canaries64> (sfid-20130807_222855_637072_DB4A46A8)
Subject: [PATCH 2/4] staging: vt6656: rxtx.c: s_uGetDataDuration remove dead
 variables.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Wed, 07 Aug 2013 21:28:45 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As result of patch
staging: vt6656: rxtx.c s_uGetDataDuration remove First Frag or Mid Frag dead code.

cbFrameLength, wRate, uFragIdx, cbLastFragmentSize, uMACfragNum, byFBOption are
dead variables.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 74 ++++++++++++++++++-------------------------
 1 file changed, 30 insertions(+), 44 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index d3b9a6b..2751531 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -135,9 +135,7 @@ static void s_vFillRTSHead(struct vnt_private *pDevice, u8 byPktType,
 	struct ethhdr *psEthHeader, u16 wCurrentRate, u8 byFBOption);
 
 static u32 s_uGetDataDuration(struct vnt_private *pDevice, u8 byDurType,
-	u32 cbFrameLength, u8 byPktType, u16 wRate, int bNeedAck,
-	u32 uFragIdx, u32 cbLastFragmentSize, u32 uMACfragNum,
-	u8 byFBOption);
+	u8 byPktType, int bNeedAck);
 
 static unsigned int s_uGetRTSCTSDuration(struct vnt_private *pDevice,
 	u8 byDurType, u32 cbFrameLength, u8 byPktType, u16 wRate,
@@ -388,9 +386,7 @@ static u32 s_uGetRTSCTSRsvTime(struct vnt_private *pDevice,
 
 //byFreqType 0: 5GHz, 1:2.4Ghz
 static u32 s_uGetDataDuration(struct vnt_private *pDevice, u8 byDurType,
-	u32 cbFrameLength, u8 byPktType, u16 wRate, int bNeedAck,
-	u32 uFragIdx, u32 cbLastFragmentSize, u32 uMACfragNum,
-	u8 byFBOption)
+	u8 byPktType, int bNeedAck)
 {
 	u32 uAckTime = 0;
 
@@ -545,10 +541,8 @@ static u32 s_uFillDataHead(struct vnt_private *pDevice,
                 (u16 *)&(pBuf->wTransmitLength), (u8 *)&(pBuf->byServiceField), (u8 *)&(pBuf->bySignalField)
             );
             //Get Duration and TimeStampOff
-            pBuf->wDuration = (u16)s_uGetDataDuration(pDevice, DATADUR_A, cbFrameLength, byPktType,
-                                                       wCurrentRate, bNeedAck, uFragIdx,
-                                                       cbLastFragmentSize, uMACfragNum,
-                                                       byFBOption); //1: 2.4GHz
+		pBuf->wDuration = (u16)s_uGetDataDuration(pDevice, DATADUR_A,
+					byPktType, bNeedAck);
             if(uDMAIdx!=TYPE_ATIMDMA) {
                 pBuf->wTimeStampOff = wTimeStampOff[pDevice->byPreambleType%2][wCurrentRate%MAX_RATE];
             }
@@ -565,14 +559,10 @@ static u32 s_uFillDataHead(struct vnt_private *pDevice,
                     (u16 *)&(pBuf->wTransmitLength_b), (u8 *)&(pBuf->byServiceField_b), (u8 *)&(pBuf->bySignalField_b)
                 );
                 //Get Duration and TimeStamp
-                pBuf->wDuration_a = (u16)s_uGetDataDuration(pDevice, DATADUR_A, cbFrameLength,
-                                                             byPktType, wCurrentRate, bNeedAck, uFragIdx,
-                                                             cbLastFragmentSize, uMACfragNum,
-                                                             byFBOption); //1: 2.4GHz
-                pBuf->wDuration_b = (u16)s_uGetDataDuration(pDevice, DATADUR_B, cbFrameLength,
-                                                             PK_TYPE_11B, pDevice->byTopCCKBasicRate,
-                                                             bNeedAck, uFragIdx, cbLastFragmentSize,
-                                                             uMACfragNum, byFBOption); //1: 2.4GHz
+		pBuf->wDuration_a = (u16)s_uGetDataDuration(pDevice, DATADUR_A,
+							byPktType, bNeedAck);
+		pBuf->wDuration_b = (u16)s_uGetDataDuration(pDevice, DATADUR_B,
+							PK_TYPE_11B, bNeedAck);
 
                 pBuf->wTimeStampOff_a = wTimeStampOff[pDevice->byPreambleType%2][wCurrentRate%MAX_RATE];
                 pBuf->wTimeStampOff_b = wTimeStampOff[pDevice->byPreambleType%2][pDevice->byTopCCKBasicRate%MAX_RATE];
@@ -588,14 +578,14 @@ static u32 s_uFillDataHead(struct vnt_private *pDevice,
                     (u16 *)&(pBuf->wTransmitLength_b), (u8 *)&(pBuf->byServiceField_b), (u8 *)&(pBuf->bySignalField_b)
                 );
                 //Get Duration and TimeStamp
-                pBuf->wDuration_a = (u16)s_uGetDataDuration(pDevice, DATADUR_A, cbFrameLength, byPktType,
-                                             wCurrentRate, bNeedAck, uFragIdx, cbLastFragmentSize, uMACfragNum, byFBOption); //1: 2.4GHz
-                pBuf->wDuration_b = (u16)s_uGetDataDuration(pDevice, DATADUR_B, cbFrameLength, PK_TYPE_11B,
-                                             pDevice->byTopCCKBasicRate, bNeedAck, uFragIdx, cbLastFragmentSize, uMACfragNum, byFBOption); //1: 2.4GHz
-                pBuf->wDuration_a_f0 = (u16)s_uGetDataDuration(pDevice, DATADUR_A_F0, cbFrameLength, byPktType,
-                                             wCurrentRate, bNeedAck, uFragIdx, cbLastFragmentSize, uMACfragNum, byFBOption); //1: 2.4GHz
-                pBuf->wDuration_a_f1 = (u16)s_uGetDataDuration(pDevice, DATADUR_A_F1, cbFrameLength, byPktType,
-                                             wCurrentRate, bNeedAck, uFragIdx, cbLastFragmentSize, uMACfragNum, byFBOption); //1: 2.4GHz
+		pBuf->wDuration_a = (u16)s_uGetDataDuration(pDevice, DATADUR_A,
+							byPktType, bNeedAck);
+		pBuf->wDuration_b = (u16)s_uGetDataDuration(pDevice, DATADUR_B,
+							PK_TYPE_11B, bNeedAck);
+		pBuf->wDuration_a_f0 = (u16)s_uGetDataDuration(pDevice,
+					DATADUR_A_F0, byPktType, bNeedAck);
+		pBuf->wDuration_a_f1 = (u16)s_uGetDataDuration(pDevice,
+					DATADUR_A_F1, byPktType, bNeedAck);
                 pBuf->wTimeStampOff_a = wTimeStampOff[pDevice->byPreambleType%2][wCurrentRate%MAX_RATE];
                 pBuf->wTimeStampOff_b = wTimeStampOff[pDevice->byPreambleType%2][pDevice->byTopCCKBasicRate%MAX_RATE];
                 return (pBuf->wDuration_a);
@@ -611,12 +601,12 @@ static u32 s_uFillDataHead(struct vnt_private *pDevice,
                 (u16 *)&(pBuf->wTransmitLength), (u8 *)&(pBuf->byServiceField), (u8 *)&(pBuf->bySignalField)
             );
             //Get Duration and TimeStampOff
-            pBuf->wDuration = (u16)s_uGetDataDuration(pDevice, DATADUR_A, cbFrameLength, byPktType,
-                                        wCurrentRate, bNeedAck, uFragIdx, cbLastFragmentSize, uMACfragNum, byFBOption); //0: 5GHz
-            pBuf->wDuration_f0 = (u16)s_uGetDataDuration(pDevice, DATADUR_A_F0, cbFrameLength, byPktType,
-                                        wCurrentRate, bNeedAck, uFragIdx, cbLastFragmentSize, uMACfragNum, byFBOption); //0: 5GHz
-            pBuf->wDuration_f1 = (u16)s_uGetDataDuration(pDevice, DATADUR_A_F1, cbFrameLength, byPktType,
-                                        wCurrentRate, bNeedAck, uFragIdx, cbLastFragmentSize, uMACfragNum, byFBOption); //0: 5GHz
+		pBuf->wDuration = (u16)s_uGetDataDuration(pDevice, DATADUR_A,
+					byPktType, bNeedAck);
+		pBuf->wDuration_f0 = (u16)s_uGetDataDuration(pDevice,
+				DATADUR_A_F0, byPktType, bNeedAck);
+		pBuf->wDuration_f1 = (u16)s_uGetDataDuration(pDevice,
+				DATADUR_A_F1, byPktType, bNeedAck);
             if(uDMAIdx!=TYPE_ATIMDMA) {
                 pBuf->wTimeStampOff = wTimeStampOff[pDevice->byPreambleType%2][wCurrentRate%MAX_RATE];
             }
@@ -628,10 +618,8 @@ static u32 s_uFillDataHead(struct vnt_private *pDevice,
                 (u16 *)&(pBuf->wTransmitLength), (u8 *)&(pBuf->byServiceField), (u8 *)&(pBuf->bySignalField)
             );
             //Get Duration and TimeStampOff
-            pBuf->wDuration = (u16)s_uGetDataDuration(pDevice, DATADUR_A, cbFrameLength, byPktType,
-                                                       wCurrentRate, bNeedAck, uFragIdx,
-                                                       cbLastFragmentSize, uMACfragNum,
-                                                       byFBOption);
+		pBuf->wDuration = (u16)s_uGetDataDuration(pDevice, DATADUR_A,
+				byPktType, bNeedAck);
 
             if(uDMAIdx!=TYPE_ATIMDMA) {
                 pBuf->wTimeStampOff = wTimeStampOff[pDevice->byPreambleType%2][wCurrentRate%MAX_RATE];
@@ -646,10 +634,8 @@ static u32 s_uFillDataHead(struct vnt_private *pDevice,
                 (u16 *)&(pBuf->wTransmitLength), (u8 *)&(pBuf->byServiceField), (u8 *)&(pBuf->bySignalField)
             );
             //Get Duration and TimeStampOff
-            pBuf->wDuration = (u16)s_uGetDataDuration(pDevice, DATADUR_B, cbFrameLength, byPktType,
-                                                       wCurrentRate, bNeedAck, uFragIdx,
-                                                       cbLastFragmentSize, uMACfragNum,
-                                                       byFBOption);
+		pBuf->wDuration = (u16)s_uGetDataDuration(pDevice, DATADUR_B,
+				byPktType, bNeedAck);
             if (uDMAIdx != TYPE_ATIMDMA) {
                 pBuf->wTimeStampOff = wTimeStampOff[pDevice->byPreambleType%2][wCurrentRate%MAX_RATE];
             }
@@ -1834,8 +1820,8 @@ CMD_STATUS csBeacon_xmit(struct vnt_private *pDevice,
             (u16 *)&(pTxDataHead->wTransmitLength), (u8 *)&(pTxDataHead->byServiceField), (u8 *)&(pTxDataHead->bySignalField)
         );
         //Get Duration and TimeStampOff
-        pTxDataHead->wDuration = cpu_to_le16((u16)s_uGetDataDuration(pDevice, DATADUR_A, cbFrameSize, PK_TYPE_11A,
-                                                          wCurrentRate, false, 0, 0, 1, AUTO_FB_NONE));
+	pTxDataHead->wDuration = cpu_to_le16((u16)s_uGetDataDuration(pDevice,
+				DATADUR_A, PK_TYPE_11A, false));
         pTxDataHead->wTimeStampOff = wTimeStampOff[pDevice->byPreambleType%2][wCurrentRate%MAX_RATE];
         cbHeaderSize = wTxBufSize + sizeof(STxDataHead_ab);
     } else {
@@ -1847,8 +1833,8 @@ CMD_STATUS csBeacon_xmit(struct vnt_private *pDevice,
             (u16 *)&(pTxDataHead->wTransmitLength), (u8 *)&(pTxDataHead->byServiceField), (u8 *)&(pTxDataHead->bySignalField)
         );
         //Get Duration and TimeStampOff
-        pTxDataHead->wDuration = cpu_to_le16((u16)s_uGetDataDuration(pDevice, DATADUR_B, cbFrameSize, PK_TYPE_11B,
-                                                          wCurrentRate, false, 0, 0, 1, AUTO_FB_NONE));
+	pTxDataHead->wDuration = cpu_to_le16((u16)s_uGetDataDuration(pDevice,
+				DATADUR_B, PK_TYPE_11B, false));
         pTxDataHead->wTimeStampOff = wTimeStampOff[pDevice->byPreambleType%2][wCurrentRate%MAX_RATE];
         cbHeaderSize = wTxBufSize + sizeof(STxDataHead_ab);
     }
-- 
1.8.1.2

