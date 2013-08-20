Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:46784 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab3HTVwh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Aug 2013 17:52:37 -0400
Received: by mail-we0-f171.google.com with SMTP id q55so927064wes.30
        for <linux-wireless@vger.kernel.org>; Tue, 20 Aug 2013 14:52:36 -0700 (PDT)
Message-ID: <1377035550.8885.46.camel@canaries32-MCP7A> (sfid-20130820_235241_900082_D85C6C27)
Subject: [PATCH 2/2] staging: vt6656: baseband.c BBvCalculateParameter
 create structure for pwPhyLen, pbyPhySrv and pbyPhySgn
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Tue, 20 Aug 2013 22:52:30 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Create single packed structure vnt_phy_field for rxtx.h structures.

In card.c CARDvSetRSPINF a vnt_phy_field replaces abyServ,
abySignal, awLen variables.

In rxtx.c point BBvCalculateParameter to relevant field.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/baseband.c | 70 ++++++++++++++--------------
 drivers/staging/vt6656/baseband.h | 10 +++-
 drivers/staging/vt6656/card.c     | 68 +++++++++------------------
 drivers/staging/vt6656/rxtx.c     | 97 +++++++++++++++------------------------
 drivers/staging/vt6656/rxtx.h     | 57 ++++++-----------------
 5 files changed, 117 insertions(+), 185 deletions(-)

diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index 7d34403..1e8b841 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -723,16 +723,16 @@ BBuGetFrameTime(
  *      cbFrameLength   - Tx Frame Length
  *      wRate           - Tx Rate
  *  Out:
- *      pwPhyLen        - pointer to Phy Length field
- *      pbyPhySrv       - pointer to Phy Service field
- *      pbyPhySgn       - pointer to Phy Signal field
+ *	struct vnt_phy_field *phy
+ * 			- pointer to Phy Length field
+ *			- pointer to Phy Service field
+ * 			- pointer to Phy Signal field
  *
  * Return Value: none
  *
  */
 void BBvCalculateParameter(struct vnt_private *pDevice, u32 cbFrameLength,
-	u16 wRate, u8 byPacketType, u16 *pwPhyLen, u8 *pbyPhySrv,
-		u8 *pbyPhySgn)
+	u16 wRate, u8 byPacketType, struct vnt_phy_field *phy)
 {
 	u32 cbBitCount;
 	u32 cbUsCount = 0;
@@ -747,15 +747,15 @@ void BBvCalculateParameter(struct vnt_private *pDevice, u32 cbFrameLength,
     switch (wRate) {
     case RATE_1M :
         cbUsCount = cbBitCount;
-        *pbyPhySgn = 0x00;
+	phy->signal = 0x00;
         break;
 
     case RATE_2M :
         cbUsCount = cbBitCount / 2;
         if (byPreambleType == 1)
-            *pbyPhySgn = 0x09;
+		phy->signal = 0x09;
         else // long preamble
-            *pbyPhySgn = 0x01;
+		phy->signal = 0x01;
         break;
 
     case RATE_5M :
@@ -766,9 +766,9 @@ void BBvCalculateParameter(struct vnt_private *pDevice, u32 cbFrameLength,
         if (cbTmp != cbBitCount)
             cbUsCount ++;
         if (byPreambleType == 1)
-            *pbyPhySgn = 0x0a;
+		phy->signal = 0x0a;
         else // long preamble
-            *pbyPhySgn = 0x02;
+		phy->signal = 0x02;
         break;
 
     case RATE_11M :
@@ -783,101 +783,101 @@ void BBvCalculateParameter(struct vnt_private *pDevice, u32 cbFrameLength,
                 bExtBit = true;
         }
         if (byPreambleType == 1)
-            *pbyPhySgn = 0x0b;
+		phy->signal = 0x0b;
         else // long preamble
-            *pbyPhySgn = 0x03;
+		phy->signal = 0x03;
         break;
 
     case RATE_6M :
         if(byPacketType == PK_TYPE_11A) {//11a, 5GHZ
-            *pbyPhySgn = 0x9B; //1001 1011
+		phy->signal = 0x9b;
         }
         else {//11g, 2.4GHZ
-            *pbyPhySgn = 0x8B; //1000 1011
+		phy->signal = 0x8b;
         }
         break;
 
     case RATE_9M :
         if(byPacketType == PK_TYPE_11A) {//11a, 5GHZ
-            *pbyPhySgn = 0x9F; //1001 1111
+		phy->signal = 0x9f;
         }
         else {//11g, 2.4GHZ
-            *pbyPhySgn = 0x8F; //1000 1111
+		phy->signal = 0x8f;
         }
         break;
 
     case RATE_12M :
         if(byPacketType == PK_TYPE_11A) {//11a, 5GHZ
-            *pbyPhySgn = 0x9A; //1001 1010
+		phy->signal = 0x9a;
         }
         else {//11g, 2.4GHZ
-            *pbyPhySgn = 0x8A; //1000 1010
+		phy->signal = 0x8a;
         }
         break;
 
     case RATE_18M :
         if(byPacketType == PK_TYPE_11A) {//11a, 5GHZ
-            *pbyPhySgn = 0x9E; //1001 1110
+		phy->signal = 0x9e;
         }
         else {//11g, 2.4GHZ
-            *pbyPhySgn = 0x8E; //1000 1110
+		phy->signal = 0x8e;
         }
         break;
 
     case RATE_24M :
         if(byPacketType == PK_TYPE_11A) {//11a, 5GHZ
-            *pbyPhySgn = 0x99; //1001 1001
+		phy->signal = 0x99;
         }
         else {//11g, 2.4GHZ
-            *pbyPhySgn = 0x89; //1000 1001
+		phy->signal = 0x89;
         }
         break;
 
     case RATE_36M :
         if(byPacketType == PK_TYPE_11A) {//11a, 5GHZ
-            *pbyPhySgn = 0x9D; //1001 1101
+		phy->signal = 0x9d;
         }
         else {//11g, 2.4GHZ
-            *pbyPhySgn = 0x8D; //1000 1101
+		phy->signal = 0x8d;
         }
         break;
 
     case RATE_48M :
         if(byPacketType == PK_TYPE_11A) {//11a, 5GHZ
-            *pbyPhySgn = 0x98; //1001 1000
+		phy->signal = 0x98;
         }
         else {//11g, 2.4GHZ
-            *pbyPhySgn = 0x88; //1000 1000
+		phy->signal = 0x88;
         }
         break;
 
     case RATE_54M :
         if (byPacketType == PK_TYPE_11A) {//11a, 5GHZ
-            *pbyPhySgn = 0x9C; //1001 1100
+		phy->signal = 0x9c;
         }
         else {//11g, 2.4GHZ
-            *pbyPhySgn = 0x8C; //1000 1100
+		phy->signal = 0x8c;
         }
         break;
 
     default :
         if (byPacketType == PK_TYPE_11A) {//11a, 5GHZ
-            *pbyPhySgn = 0x9C; //1001 1100
+		phy->signal = 0x9c;
         }
         else {//11g, 2.4GHZ
-            *pbyPhySgn = 0x8C; //1000 1100
+		phy->signal = 0x8c;
         }
         break;
     }
 
 	if (byPacketType == PK_TYPE_11B) {
-		*pbyPhySrv = 0x00;
+		phy->service = 0x00;
 		if (bExtBit)
-			*pbyPhySrv = *pbyPhySrv | 0x80;
-		*pwPhyLen = cpu_to_le16((u16)cbUsCount);
+			phy->service |= 0x80;
+		phy->len = cpu_to_le16((u16)cbUsCount);
 	} else {
-		*pbyPhySrv = 0x00;
-		*pwPhyLen = cpu_to_le16((u16)cbFrameLength);
+		phy->service = 0x00;
+		phy->len = cpu_to_le16((u16)cbFrameLength);
 	}
 }
 
diff --git a/drivers/staging/vt6656/baseband.h b/drivers/staging/vt6656/baseband.h
index 0a634ad..a8db17d 100644
--- a/drivers/staging/vt6656/baseband.h
+++ b/drivers/staging/vt6656/baseband.h
@@ -81,6 +81,13 @@
 #define TOP_RATE_2M         0x00200000
 #define TOP_RATE_1M         0x00100000
 
+/* Length, Service, and Signal fields of Phy for Tx */
+struct vnt_phy_field {
+	u8 signal;
+	u8 service;
+	u16 len;
+} __packed;
+
 unsigned int
 BBuGetFrameTime(
      u8 byPreambleType,
@@ -90,8 +97,7 @@ BBuGetFrameTime(
     );
 
 void BBvCalculateParameter(struct vnt_private *, u32 cbFrameLength,
-	u16 wRate, u8 byPacketType, u16 *pwPhyLen, u8 *pbyPhySrv,
-	u8 *pbyPhySgn);
+	u16 wRate, u8 byPacketType, struct vnt_phy_field *);
 
 /* timer for antenna diversity */
 
diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index c0815d8..dbf11ec 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -319,53 +319,27 @@ CARDvCalculateOFDMRParameter (
  */
 void CARDvSetRSPINF(struct vnt_private *pDevice, u8 byBBType)
 {
-	u8 abyServ[4] = {0, 0, 0, 0}; /* For CCK */
-	u8 abySignal[4] = {0, 0, 0, 0};
-	u16 awLen[4] = {0, 0, 0, 0};
+	struct vnt_phy_field phy[4];
 	u8 abyTxRate[9] = {0, 0, 0, 0, 0, 0, 0, 0, 0}; /* For OFDM */
 	u8 abyRsvTime[9] = {0, 0, 0, 0, 0, 0, 0, 0, 0};
 	u8 abyData[34];
 	int i;
 
     //RSPINF_b_1
-    BBvCalculateParameter(pDevice,
-                         14,
-                         swGetCCKControlRate(pDevice, RATE_1M),
-                         PK_TYPE_11B,
-                         &awLen[0],
-                         &abyServ[0],
-                         &abySignal[0]
-    );
+	BBvCalculateParameter(pDevice, 14,
+		swGetCCKControlRate(pDevice, RATE_1M), PK_TYPE_11B, &phy[0]);
 
     ///RSPINF_b_2
-    BBvCalculateParameter(pDevice,
-                         14,
-                         swGetCCKControlRate(pDevice, RATE_2M),
-                         PK_TYPE_11B,
-                         &awLen[1],
-                         &abyServ[1],
-                         &abySignal[1]
-    );
+	BBvCalculateParameter(pDevice, 14,
+		swGetCCKControlRate(pDevice, RATE_2M), PK_TYPE_11B, &phy[1]);
 
     //RSPINF_b_5
-    BBvCalculateParameter(pDevice,
-                         14,
-                         swGetCCKControlRate(pDevice, RATE_5M),
-                         PK_TYPE_11B,
-                         &awLen[2],
-                         &abyServ[2],
-                         &abySignal[2]
-    );
+	BBvCalculateParameter(pDevice, 14,
+		swGetCCKControlRate(pDevice, RATE_5M), PK_TYPE_11B, &phy[2]);
 
     //RSPINF_b_11
-    BBvCalculateParameter(pDevice,
-                         14,
-                         swGetCCKControlRate(pDevice, RATE_11M),
-                         PK_TYPE_11B,
-                         &awLen[3],
-                         &abyServ[3],
-                         &abySignal[3]
-    );
+	BBvCalculateParameter(pDevice, 14,
+		swGetCCKControlRate(pDevice, RATE_11M), PK_TYPE_11B, &phy[3]);
 
     //RSPINF_a_6
     CARDvCalculateOFDMRParameter (RATE_6M,
@@ -421,21 +395,21 @@ void CARDvSetRSPINF(struct vnt_private *pDevice, u8 byBBType)
                                  &abyTxRate[8],
                                  &abyRsvTime[8]);
 
-	put_unaligned(awLen[0], (u16 *)&abyData[0]);
-    abyData[2] = abySignal[0];
-    abyData[3] = abyServ[0];
+	put_unaligned(phy[0].len, (u16 *)&abyData[0]);
+	abyData[2] = phy[0].signal;
+	abyData[3] = phy[0].service;
 
-	put_unaligned(awLen[1], (u16 *)&abyData[4]);
-    abyData[6] = abySignal[1];
-    abyData[7] = abyServ[1];
+	put_unaligned(phy[1].len, (u16 *)&abyData[4]);
+	abyData[6] = phy[1].signal;
+	abyData[7] = phy[1].service;
 
-	put_unaligned(awLen[2], (u16 *)&abyData[8]);
-    abyData[10] = abySignal[2];
-    abyData[11] = abyServ[2];
+	put_unaligned(phy[2].len, (u16 *)&abyData[8]);
+	abyData[10] = phy[2].signal;
+	abyData[11] = phy[2].service;
 
-	put_unaligned(awLen[3], (u16 *)&abyData[12]);
-    abyData[14] = abySignal[3];
-    abyData[15] = abyServ[3];
+	put_unaligned(phy[3].len, (u16 *)&abyData[12]);
+	abyData[14] = phy[3].signal;
+	abyData[15] = phy[3].service;
 
     for (i = 0; i < 9; i++) {
 	abyData[16+i*2] = abyTxRate[i];
diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 8c42781..05e82ec 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -52,7 +52,6 @@
 #include "card.h"
 #include "bssdb.h"
 #include "mac.h"
-#include "baseband.h"
 #include "michael.h"
 #include "tkip.h"
 #include "tcrc.h"
@@ -503,12 +502,10 @@ static u32 s_uFillDataHead(struct vnt_private *pDevice,
 		struct vnt_tx_datahead_g *pBuf =
 				(struct vnt_tx_datahead_g *)pTxDataHead;
                 //Get SignalField,ServiceField,Length
-                BBvCalculateParameter(pDevice, cbFrameLength, wCurrentRate, byPktType,
-                    (u16 *)&(pBuf->wTransmitLength_a), (u8 *)&(pBuf->byServiceField_a), (u8 *)&(pBuf->bySignalField_a)
-                );
-                BBvCalculateParameter(pDevice, cbFrameLength, pDevice->byTopCCKBasicRate, PK_TYPE_11B,
-                    (u16 *)&(pBuf->wTransmitLength_b), (u8 *)&(pBuf->byServiceField_b), (u8 *)&(pBuf->bySignalField_b)
-                );
+		BBvCalculateParameter(pDevice, cbFrameLength, wCurrentRate,
+			byPktType, &pBuf->a);
+		BBvCalculateParameter(pDevice, cbFrameLength,
+			pDevice->byTopCCKBasicRate, PK_TYPE_11B, &pBuf->b);
                 //Get Duration and TimeStamp
 		pBuf->wDuration_a = (u16)s_uGetDataDuration(pDevice, DATADUR_A,
 							byPktType, bNeedAck);
@@ -523,12 +520,10 @@ static u32 s_uFillDataHead(struct vnt_private *pDevice,
 		struct vnt_tx_datahead_g_fb *pBuf =
 			(struct vnt_tx_datahead_g_fb *)pTxDataHead;
                 //Get SignalField,ServiceField,Length
-                BBvCalculateParameter(pDevice, cbFrameLength, wCurrentRate, byPktType,
-                    (u16 *)&(pBuf->wTransmitLength_a), (u8 *)&(pBuf->byServiceField_a), (u8 *)&(pBuf->bySignalField_a)
-                );
-                BBvCalculateParameter(pDevice, cbFrameLength, pDevice->byTopCCKBasicRate, PK_TYPE_11B,
-                    (u16 *)&(pBuf->wTransmitLength_b), (u8 *)&(pBuf->byServiceField_b), (u8 *)&(pBuf->bySignalField_b)
-                );
+		BBvCalculateParameter(pDevice, cbFrameLength, wCurrentRate,
+			byPktType, &pBuf->a);
+		BBvCalculateParameter(pDevice, cbFrameLength,
+			pDevice->byTopCCKBasicRate, PK_TYPE_11B, &pBuf->b);
                 //Get Duration and TimeStamp
 		pBuf->wDuration_a = (u16)s_uGetDataDuration(pDevice, DATADUR_A,
 							byPktType, bNeedAck);
@@ -548,9 +543,8 @@ static u32 s_uFillDataHead(struct vnt_private *pDevice,
 		struct vnt_tx_datahead_a_fb *pBuf =
 			(struct vnt_tx_datahead_a_fb *)pTxDataHead;
             //Get SignalField,ServiceField,Length
-            BBvCalculateParameter(pDevice, cbFrameLength, wCurrentRate, byPktType,
-                (u16 *)&(pBuf->wTransmitLength), (u8 *)&(pBuf->byServiceField), (u8 *)&(pBuf->bySignalField)
-            );
+		BBvCalculateParameter(pDevice, cbFrameLength, wCurrentRate,
+			byPktType, &pBuf->a);
             //Get Duration and TimeStampOff
 		pBuf->wDuration = (u16)s_uGetDataDuration(pDevice, DATADUR_A,
 					byPktType, bNeedAck);
@@ -564,9 +558,8 @@ static u32 s_uFillDataHead(struct vnt_private *pDevice,
 		struct vnt_tx_datahead_ab *pBuf =
 			(struct vnt_tx_datahead_ab *)pTxDataHead;
             //Get SignalField,ServiceField,Length
-            BBvCalculateParameter(pDevice, cbFrameLength, wCurrentRate, byPktType,
-                (u16 *)&(pBuf->wTransmitLength), (u8 *)&(pBuf->byServiceField), (u8 *)&(pBuf->bySignalField)
-            );
+		BBvCalculateParameter(pDevice, cbFrameLength, wCurrentRate,
+			byPktType, &pBuf->ab);
             //Get Duration and TimeStampOff
 		pBuf->wDuration = (u16)s_uGetDataDuration(pDevice, DATADUR_A,
 				byPktType, bNeedAck);
@@ -579,9 +572,8 @@ static u32 s_uFillDataHead(struct vnt_private *pDevice,
 		struct vnt_tx_datahead_ab *pBuf =
 			(struct vnt_tx_datahead_ab *)pTxDataHead;
             //Get SignalField,ServiceField,Length
-            BBvCalculateParameter(pDevice, cbFrameLength, wCurrentRate, byPktType,
-                (u16 *)&(pBuf->wTransmitLength), (u8 *)&(pBuf->byServiceField), (u8 *)&(pBuf->bySignalField)
-            );
+		BBvCalculateParameter(pDevice, cbFrameLength, wCurrentRate,
+			byPktType, &pBuf->ab);
             //Get Duration and TimeStampOff
 		pBuf->wDuration = (u16)s_uGetDataDuration(pDevice, DATADUR_B,
 				byPktType, bNeedAck);
@@ -597,7 +589,6 @@ static void s_vFillRTSHead(struct vnt_private *pDevice, u8 byPktType,
 	struct ethhdr *psEthHeader, u16 wCurrentRate, u8 byFBOption)
 {
 	u32 uRTSFrameLen = 20;
-	u16 wLen = 0;
 
     if (pvRTS == NULL)
     	return;
@@ -614,12 +605,10 @@ static void s_vFillRTSHead(struct vnt_private *pDevice, u8 byPktType,
         if (byFBOption == AUTO_FB_NONE) {
 		struct vnt_rts_g *pBuf = (struct vnt_rts_g *)pvRTS;
             //Get SignalField,ServiceField,Length
-            BBvCalculateParameter(pDevice, uRTSFrameLen, pDevice->byTopCCKBasicRate, PK_TYPE_11B,
-                (u16 *)&(wLen), (u8 *)&(pBuf->byServiceField_b), (u8 *)&(pBuf->bySignalField_b)
-            );
-            BBvCalculateParameter(pDevice, uRTSFrameLen, pDevice->byTopOFDMBasicRate, byPktType,
-                (u16 *)&(wLen), (u8 *)&(pBuf->byServiceField_a), (u8 *)&(pBuf->bySignalField_a)
-            );
+		BBvCalculateParameter(pDevice, uRTSFrameLen,
+			pDevice->byTopCCKBasicRate, PK_TYPE_11B, &pBuf->b);
+		BBvCalculateParameter(pDevice, uRTSFrameLen,
+			pDevice->byTopOFDMBasicRate, byPktType, &pBuf->a);
             //Get Duration
 		pBuf->wDuration_bb = s_uGetRTSCTSDuration(pDevice, RTSDUR_BB,
 			cbFrameLength, PK_TYPE_11B,
@@ -648,12 +637,10 @@ static void s_vFillRTSHead(struct vnt_private *pDevice, u8 byPktType,
         else {
 		struct vnt_rts_g_fb *pBuf = (struct vnt_rts_g_fb *)pvRTS;
             //Get SignalField,ServiceField,Length
-            BBvCalculateParameter(pDevice, uRTSFrameLen, pDevice->byTopCCKBasicRate, PK_TYPE_11B,
-                (u16 *)&(wLen), (u8 *)&(pBuf->byServiceField_b), (u8 *)&(pBuf->bySignalField_b)
-            );
-            BBvCalculateParameter(pDevice, uRTSFrameLen, pDevice->byTopOFDMBasicRate, byPktType,
-                (u16 *)&(wLen), (u8 *)&(pBuf->byServiceField_a), (u8 *)&(pBuf->bySignalField_a)
-            );
+		BBvCalculateParameter(pDevice, uRTSFrameLen,
+			pDevice->byTopCCKBasicRate, PK_TYPE_11B, &pBuf->b);
+		BBvCalculateParameter(pDevice, uRTSFrameLen,
+			pDevice->byTopOFDMBasicRate, byPktType, &pBuf->a);
             //Get Duration
 		pBuf->wDuration_bb = s_uGetRTSCTSDuration(pDevice, RTSDUR_BB,
 			cbFrameLength, PK_TYPE_11B,
@@ -696,9 +683,8 @@ static void s_vFillRTSHead(struct vnt_private *pDevice, u8 byPktType,
         if (byFBOption == AUTO_FB_NONE) {
 		struct vnt_rts_ab *pBuf = (struct vnt_rts_ab *)pvRTS;
             //Get SignalField,ServiceField,Length
-            BBvCalculateParameter(pDevice, uRTSFrameLen, pDevice->byTopOFDMBasicRate, byPktType,
-                (u16 *)&(wLen), (u8 *)&(pBuf->byServiceField), (u8 *)&(pBuf->bySignalField)
-            );
+		BBvCalculateParameter(pDevice, uRTSFrameLen,
+			pDevice->byTopOFDMBasicRate, byPktType, &pBuf->ab);
             //Get Duration
 		pBuf->wDuration = s_uGetRTSCTSDuration(pDevice, RTSDUR_AA,
 			cbFrameLength, byPktType, wCurrentRate,
@@ -721,9 +707,8 @@ static void s_vFillRTSHead(struct vnt_private *pDevice, u8 byPktType,
         else {
 		struct vnt_rts_a_fb *pBuf = (struct vnt_rts_a_fb *)pvRTS;
             //Get SignalField,ServiceField,Length
-            BBvCalculateParameter(pDevice, uRTSFrameLen, pDevice->byTopOFDMBasicRate, byPktType,
-                (u16 *)&(wLen), (u8 *)&(pBuf->byServiceField), (u8 *)&(pBuf->bySignalField)
-            );
+		BBvCalculateParameter(pDevice, uRTSFrameLen,
+			pDevice->byTopOFDMBasicRate, byPktType, &pBuf->a);
             //Get Duration
 		pBuf->wDuration = s_uGetRTSCTSDuration(pDevice, RTSDUR_AA,
 			cbFrameLength, byPktType, wCurrentRate,
@@ -753,9 +738,8 @@ static void s_vFillRTSHead(struct vnt_private *pDevice, u8 byPktType,
     else if (byPktType == PK_TYPE_11B) {
 	struct vnt_rts_ab *pBuf = (struct vnt_rts_ab *)pvRTS;
         //Get SignalField,ServiceField,Length
-        BBvCalculateParameter(pDevice, uRTSFrameLen, pDevice->byTopCCKBasicRate, PK_TYPE_11B,
-            (u16 *)&(wLen), (u8 *)&(pBuf->byServiceField), (u8 *)&(pBuf->bySignalField)
-        );
+	BBvCalculateParameter(pDevice, uRTSFrameLen, pDevice->byTopCCKBasicRate,
+		PK_TYPE_11B, &pBuf->ab);
         //Get Duration
 	pBuf->wDuration = s_uGetRTSCTSDuration(pDevice, RTSDUR_BB,
 		cbFrameLength, byPktType, wCurrentRate,
@@ -783,7 +767,6 @@ static void s_vFillCTSHead(struct vnt_private *pDevice, u32 uDMAIdx,
 	int bDisCRC, u16 wCurrentRate, u8 byFBOption)
 {
 	u32 uCTSFrameLen = 14;
-	u16 wLen = 0;
 
     if (pvCTS == NULL) {
         return;
@@ -799,10 +782,9 @@ static void s_vFillCTSHead(struct vnt_private *pDevice, u32 uDMAIdx,
 	if (byFBOption != AUTO_FB_NONE) {
 		/* Auto Fall back */
 		struct vnt_cts_fb *pBuf = (struct vnt_cts_fb *)pvCTS;
-            //Get SignalField,ServiceField,Length
-            BBvCalculateParameter(pDevice, uCTSFrameLen, pDevice->byTopCCKBasicRate, PK_TYPE_11B,
-                (u16 *)&(wLen), (u8 *)&(pBuf->byServiceField_b), (u8 *)&(pBuf->bySignalField_b)
-            );
+		/* Get SignalField,ServiceField,Length */
+		BBvCalculateParameter(pDevice, uCTSFrameLen,
+			pDevice->byTopCCKBasicRate, PK_TYPE_11B, &pBuf->b);
 		pBuf->wDuration_ba = s_uGetRTSCTSDuration(pDevice, CTSDUR_BA,
 			cbFrameLength, byPktType,
 			wCurrentRate, bNeedAck, byFBOption);
@@ -820,10 +802,9 @@ static void s_vFillCTSHead(struct vnt_private *pDevice, u32 uDMAIdx,
 		memcpy(pBuf->data.ra, pDevice->abyCurrentNetAddr, ETH_ALEN);
 	} else {
 		struct vnt_cts *pBuf = (struct vnt_cts *)pvCTS;
-            //Get SignalField,ServiceField,Length
-            BBvCalculateParameter(pDevice, uCTSFrameLen, pDevice->byTopCCKBasicRate, PK_TYPE_11B,
-                (u16 *)&(wLen), (u8 *)&(pBuf->byServiceField_b), (u8 *)&(pBuf->bySignalField_b)
-            );
+		/* Get SignalField,ServiceField,Length */
+		BBvCalculateParameter(pDevice, uCTSFrameLen,
+			pDevice->byTopCCKBasicRate, PK_TYPE_11B, &pBuf->b);
 		/* Get CTSDuration_ba */
 		pBuf->wDuration_ba = s_uGetRTSCTSDuration(pDevice,
 			CTSDUR_BA, cbFrameLength, byPktType,
@@ -1821,9 +1802,8 @@ CMD_STATUS csBeacon_xmit(struct vnt_private *pDevice,
 	pTxDataHead = (struct vnt_tx_datahead_ab *)
 			(pbyTxBufferAddr + wTxBufSize);
         //Get SignalField,ServiceField,Length
-        BBvCalculateParameter(pDevice, cbFrameSize, wCurrentRate, PK_TYPE_11A,
-            (u16 *)&(pTxDataHead->wTransmitLength), (u8 *)&(pTxDataHead->byServiceField), (u8 *)&(pTxDataHead->bySignalField)
-        );
+	BBvCalculateParameter(pDevice, cbFrameSize, wCurrentRate, PK_TYPE_11A,
+							&pTxDataHead->ab);
         //Get Duration and TimeStampOff
 	pTxDataHead->wDuration = cpu_to_le16((u16)s_uGetDataDuration(pDevice,
 				DATADUR_A, PK_TYPE_11A, false));
@@ -1835,9 +1815,8 @@ CMD_STATUS csBeacon_xmit(struct vnt_private *pDevice,
 	pTxDataHead = (struct vnt_tx_datahead_ab *)
 				(pbyTxBufferAddr + wTxBufSize);
         //Get SignalField,ServiceField,Length
-        BBvCalculateParameter(pDevice, cbFrameSize, wCurrentRate, PK_TYPE_11B,
-            (u16 *)&(pTxDataHead->wTransmitLength), (u8 *)&(pTxDataHead->byServiceField), (u8 *)&(pTxDataHead->bySignalField)
-        );
+	BBvCalculateParameter(pDevice, cbFrameSize, wCurrentRate, PK_TYPE_11B,
+							&pTxDataHead->ab);
         //Get Duration and TimeStampOff
 	pTxDataHead->wDuration = cpu_to_le16((u16)s_uGetDataDuration(pDevice,
 				DATADUR_B, PK_TYPE_11B, false));
diff --git a/drivers/staging/vt6656/rxtx.h b/drivers/staging/vt6656/rxtx.h
index b1ef90e..3484f2b 100644
--- a/drivers/staging/vt6656/rxtx.h
+++ b/drivers/staging/vt6656/rxtx.h
@@ -31,6 +31,7 @@
 
 #include "device.h"
 #include "wcmd.h"
+#include "baseband.h"
 
 /* RsvTime buffer header */
 struct vnt_rrv_time_rts {
@@ -56,12 +57,8 @@ struct vnt_rrv_time_ab {
 
 /* TX data header */
 struct vnt_tx_datahead_g {
-	u8 bySignalField_b;
-	u8 byServiceField_b;
-	u16 wTransmitLength_b;
-	u8 bySignalField_a;
-	u8 byServiceField_a;
-	u16 wTransmitLength_a;
+	struct vnt_phy_field b;
+	struct vnt_phy_field a;
 	u16 wDuration_b;
 	u16 wDuration_a;
 	u16 wTimeStampOff_b;
@@ -69,12 +66,8 @@ struct vnt_tx_datahead_g {
 } __packed;
 
 struct vnt_tx_datahead_g_fb {
-	u8 bySignalField_b;
-	u8 byServiceField_b;
-	u16 wTransmitLength_b;
-	u8 bySignalField_a;
-	u8 byServiceField_a;
-	u16 wTransmitLength_a;
+	struct vnt_phy_field b;
+	struct vnt_phy_field a;
 	u16 wDuration_b;
 	u16 wDuration_a;
 	u16 wDuration_a_f0;
@@ -84,17 +77,13 @@ struct vnt_tx_datahead_g_fb {
 } __packed;
 
 struct vnt_tx_datahead_ab {
-	u8 bySignalField;
-	u8 byServiceField;
-	u16 wTransmitLength;
+	struct vnt_phy_field ab;
 	u16 wDuration;
 	u16 wTimeStampOff;
 } __packed;
 
 struct vnt_tx_datahead_a_fb {
-	u8 bySignalField;
-	u8 byServiceField;
-	u16 wTransmitLength;
+	struct vnt_phy_field a;
 	u16 wDuration;
 	u16 wTimeStampOff;
 	u16 wDuration_f0;
@@ -103,12 +92,8 @@ struct vnt_tx_datahead_a_fb {
 
 /* RTS buffer header */
 struct vnt_rts_g {
-	u8 bySignalField_b;
-	u8 byServiceField_b;
-	u16 wTransmitLength_b;
-	u8 bySignalField_a;
-	u8 byServiceField_a;
-	u16 wTransmitLength_a;
+	struct vnt_phy_field b;
+	struct vnt_phy_field a;
 	u16 wDuration_ba;
 	u16 wDuration_aa;
 	u16 wDuration_bb;
@@ -117,12 +102,8 @@ struct vnt_rts_g {
 } __packed;
 
 struct vnt_rts_g_fb {
-	u8 bySignalField_b;
-	u8 byServiceField_b;
-	u16 wTransmitLength_b;
-	u8 bySignalField_a;
-	u8 byServiceField_a;
-	u16 wTransmitLength_a;
+	struct vnt_phy_field b;
+	struct vnt_phy_field a;
 	u16 wDuration_ba;
 	u16 wDuration_aa;
 	u16 wDuration_bb;
@@ -135,18 +116,14 @@ struct vnt_rts_g_fb {
 } __packed;
 
 struct vnt_rts_ab {
-	u8 bySignalField;
-	u8 byServiceField;
-	u16 wTransmitLength;
+	struct vnt_phy_field ab;
 	u16 wDuration;
 	u16 wReserved;
 	struct ieee80211_rts data;
 } __packed;
 
 struct vnt_rts_a_fb {
-	u8 bySignalField;
-	u8 byServiceField;
-	u16 wTransmitLength;
+	struct vnt_phy_field a;
 	u16 wDuration;
 	u16 wReserved;
 	u16 wRTSDuration_f0;
@@ -156,9 +133,7 @@ struct vnt_rts_a_fb {
 
 /* CTS buffer header */
 struct vnt_cts {
-	u8 bySignalField_b;
-	u8 byServiceField_b;
-	u16 wTransmitLength_b;
+	struct vnt_phy_field b;
 	u16 wDuration_ba;
 	u16 wReserved;
 	struct ieee80211_cts data;
@@ -166,9 +141,7 @@ struct vnt_cts {
 } __packed;
 
 struct vnt_cts_fb {
-	u8 bySignalField_b;
-	u8 byServiceField_b;
-	u16 wTransmitLength_b;
+	struct vnt_phy_field b;
 	u16 wDuration_ba;
 	u16 wReserved;
 	u16 wCTSDuration_ba_f0;
-- 
1.8.1.2



