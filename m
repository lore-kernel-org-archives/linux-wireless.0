Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:64642 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab3HTVth (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Aug 2013 17:49:37 -0400
Received: by mail-wi0-f171.google.com with SMTP id hr7so2949wib.4
        for <linux-wireless@vger.kernel.org>; Tue, 20 Aug 2013 14:49:36 -0700 (PDT)
Message-ID: <1377035366.8885.44.camel@canaries32-MCP7A> (sfid-20130820_234947_401513_E3B88966)
Subject: [PATCH 1/2] staging: vt6656: baseband.c  BBvCalculateParameter
 pwPhyLen return endian corrected.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Tue, 20 Aug 2013 22:49:26 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In rxtx.c many calls to BBvCaculateParameter are not endian
corrected all calls here need to be endian corrected.

Correct the endian in BBvCaculateParameter.

In card.c: CARDvSetRSPINF pwPhyLen points to awLen and is
manually applied to abyData.  Because it is now endian
corrected put_unaligned is needed to correct it.

In rxtx.c remove were endian is corrected.

This allows to merge  BBvCalculateParameter *pwPhyLen,*pbyPhySrv
and *pbyPhySgn to singles structure for tx buffers.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/baseband.c | 19 +++++++++----------
 drivers/staging/vt6656/card.c     | 12 ++++--------
 drivers/staging/vt6656/rxtx.c     |  9 ---------
 3 files changed, 13 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index a14a6a0..7d34403 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -870,16 +870,15 @@ void BBvCalculateParameter(struct vnt_private *pDevice, u32 cbFrameLength,
         break;
     }
 
-    if (byPacketType == PK_TYPE_11B) {
-        *pbyPhySrv = 0x00;
-        if (bExtBit)
-            *pbyPhySrv = *pbyPhySrv | 0x80;
-        *pwPhyLen = (u16) cbUsCount;
-    }
-    else {
-        *pbyPhySrv = 0x00;
-        *pwPhyLen = (u16)cbFrameLength;
-    }
+	if (byPacketType == PK_TYPE_11B) {
+		*pbyPhySrv = 0x00;
+		if (bExtBit)
+			*pbyPhySrv = *pbyPhySrv | 0x80;
+		*pwPhyLen = cpu_to_le16((u16)cbUsCount);
+	} else {
+		*pbyPhySrv = 0x00;
+		*pwPhyLen = cpu_to_le16((u16)cbFrameLength);
+	}
 }
 
 /*
diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index 24291ae..c0815d8 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -421,23 +421,19 @@ void CARDvSetRSPINF(struct vnt_private *pDevice, u8 byBBType)
                                  &abyTxRate[8],
                                  &abyRsvTime[8]);
 
-    abyData[0] = (u8)(awLen[0]&0xFF);
-    abyData[1] = (u8)(awLen[0]>>8);
+	put_unaligned(awLen[0], (u16 *)&abyData[0]);
     abyData[2] = abySignal[0];
     abyData[3] = abyServ[0];
 
-    abyData[4] = (u8)(awLen[1]&0xFF);
-    abyData[5] = (u8)(awLen[1]>>8);
+	put_unaligned(awLen[1], (u16 *)&abyData[4]);
     abyData[6] = abySignal[1];
     abyData[7] = abyServ[1];
 
-    abyData[8] = (u8)(awLen[2]&0xFF);
-    abyData[9] = (u8)(awLen[2]>>8);
+	put_unaligned(awLen[2], (u16 *)&abyData[8]);
     abyData[10] = abySignal[2];
     abyData[11] = abyServ[2];
 
-    abyData[12] = (u8)(awLen[3]&0xFF);
-    abyData[13] = (u8)(awLen[3]>>8);
+	put_unaligned(awLen[3], (u16 *)&abyData[12]);
     abyData[14] = abySignal[3];
     abyData[15] = abyServ[3];
 
diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 06950c4..8c42781 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -617,11 +617,9 @@ static void s_vFillRTSHead(struct vnt_private *pDevice, u8 byPktType,
             BBvCalculateParameter(pDevice, uRTSFrameLen, pDevice->byTopCCKBasicRate, PK_TYPE_11B,
                 (u16 *)&(wLen), (u8 *)&(pBuf->byServiceField_b), (u8 *)&(pBuf->bySignalField_b)
             );
-            pBuf->wTransmitLength_b = cpu_to_le16(wLen);
             BBvCalculateParameter(pDevice, uRTSFrameLen, pDevice->byTopOFDMBasicRate, byPktType,
                 (u16 *)&(wLen), (u8 *)&(pBuf->byServiceField_a), (u8 *)&(pBuf->bySignalField_a)
             );
-            pBuf->wTransmitLength_a = cpu_to_le16(wLen);
             //Get Duration
 		pBuf->wDuration_bb = s_uGetRTSCTSDuration(pDevice, RTSDUR_BB,
 			cbFrameLength, PK_TYPE_11B,
@@ -653,11 +651,9 @@ static void s_vFillRTSHead(struct vnt_private *pDevice, u8 byPktType,
             BBvCalculateParameter(pDevice, uRTSFrameLen, pDevice->byTopCCKBasicRate, PK_TYPE_11B,
                 (u16 *)&(wLen), (u8 *)&(pBuf->byServiceField_b), (u8 *)&(pBuf->bySignalField_b)
             );
-            pBuf->wTransmitLength_b = cpu_to_le16(wLen);
             BBvCalculateParameter(pDevice, uRTSFrameLen, pDevice->byTopOFDMBasicRate, byPktType,
                 (u16 *)&(wLen), (u8 *)&(pBuf->byServiceField_a), (u8 *)&(pBuf->bySignalField_a)
             );
-            pBuf->wTransmitLength_a = cpu_to_le16(wLen);
             //Get Duration
 		pBuf->wDuration_bb = s_uGetRTSCTSDuration(pDevice, RTSDUR_BB,
 			cbFrameLength, PK_TYPE_11B,
@@ -703,7 +699,6 @@ static void s_vFillRTSHead(struct vnt_private *pDevice, u8 byPktType,
             BBvCalculateParameter(pDevice, uRTSFrameLen, pDevice->byTopOFDMBasicRate, byPktType,
                 (u16 *)&(wLen), (u8 *)&(pBuf->byServiceField), (u8 *)&(pBuf->bySignalField)
             );
-            pBuf->wTransmitLength = cpu_to_le16(wLen);
             //Get Duration
 		pBuf->wDuration = s_uGetRTSCTSDuration(pDevice, RTSDUR_AA,
 			cbFrameLength, byPktType, wCurrentRate,
@@ -729,7 +724,6 @@ static void s_vFillRTSHead(struct vnt_private *pDevice, u8 byPktType,
             BBvCalculateParameter(pDevice, uRTSFrameLen, pDevice->byTopOFDMBasicRate, byPktType,
                 (u16 *)&(wLen), (u8 *)&(pBuf->byServiceField), (u8 *)&(pBuf->bySignalField)
             );
-            pBuf->wTransmitLength = cpu_to_le16(wLen);
             //Get Duration
 		pBuf->wDuration = s_uGetRTSCTSDuration(pDevice, RTSDUR_AA,
 			cbFrameLength, byPktType, wCurrentRate,
@@ -762,7 +756,6 @@ static void s_vFillRTSHead(struct vnt_private *pDevice, u8 byPktType,
         BBvCalculateParameter(pDevice, uRTSFrameLen, pDevice->byTopCCKBasicRate, PK_TYPE_11B,
             (u16 *)&(wLen), (u8 *)&(pBuf->byServiceField), (u8 *)&(pBuf->bySignalField)
         );
-        pBuf->wTransmitLength = cpu_to_le16(wLen);
         //Get Duration
 	pBuf->wDuration = s_uGetRTSCTSDuration(pDevice, RTSDUR_BB,
 		cbFrameLength, byPktType, wCurrentRate,
@@ -810,7 +803,6 @@ static void s_vFillCTSHead(struct vnt_private *pDevice, u32 uDMAIdx,
             BBvCalculateParameter(pDevice, uCTSFrameLen, pDevice->byTopCCKBasicRate, PK_TYPE_11B,
                 (u16 *)&(wLen), (u8 *)&(pBuf->byServiceField_b), (u8 *)&(pBuf->bySignalField_b)
             );
-            pBuf->wTransmitLength_b = cpu_to_le16(wLen);
 		pBuf->wDuration_ba = s_uGetRTSCTSDuration(pDevice, CTSDUR_BA,
 			cbFrameLength, byPktType,
 			wCurrentRate, bNeedAck, byFBOption);
@@ -832,7 +824,6 @@ static void s_vFillCTSHead(struct vnt_private *pDevice, u32 uDMAIdx,
             BBvCalculateParameter(pDevice, uCTSFrameLen, pDevice->byTopCCKBasicRate, PK_TYPE_11B,
                 (u16 *)&(wLen), (u8 *)&(pBuf->byServiceField_b), (u8 *)&(pBuf->bySignalField_b)
             );
-            pBuf->wTransmitLength_b = cpu_to_le16(wLen);
 		/* Get CTSDuration_ba */
 		pBuf->wDuration_ba = s_uGetRTSCTSDuration(pDevice,
 			CTSDUR_BA, cbFrameLength, byPktType,
-- 
1.8.1.2




