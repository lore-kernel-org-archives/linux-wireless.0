Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f180.google.com ([209.85.215.180]:38908 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757720Ab3HMTRR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Aug 2013 15:17:17 -0400
Received: by mail-ea0-f180.google.com with SMTP id h10so4340182eaj.39
        for <linux-wireless@vger.kernel.org>; Tue, 13 Aug 2013 12:17:15 -0700 (PDT)
Message-ID: <1376421431.6292.18.camel@canaries32-MCP7A> (sfid-20130813_211721_673606_910006F4)
Subject: [PATCH] staging: vt6656: rxtx.c s_uGetRTSCTSDuration return endian
 u16
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Tue, 13 Aug 2013 20:17:11 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The return value of uGetRTSCTSDuration always needs to be
corrected to a u16 little endian corrected value.

Some places the endian correction is done on the next line

Change uGetRTSCTSDuration return u16 little endian corrected value.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 93 +++++++++++++++++++++++++++++--------------
 1 file changed, 63 insertions(+), 30 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index a701120..9cd4158 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -136,7 +136,7 @@ static void s_vFillRTSHead(struct vnt_private *pDevice, u8 byPktType,
 static u32 s_uGetDataDuration(struct vnt_private *pDevice, u8 byDurType,
 	u8 byPktType, int bNeedAck);
 
-static unsigned int s_uGetRTSCTSDuration(struct vnt_private *pDevice,
+static u16 s_uGetRTSCTSDuration(struct vnt_private *pDevice,
 	u8 byDurType, u32 cbFrameLength, u8 byPktType, u16 wRate,
 	int bNeedAck, u8 byFBOption);
 
@@ -403,7 +403,7 @@ static u32 s_uGetDataDuration(struct vnt_private *pDevice, u8 byDurType,
 }
 
 //byFreqType: 0=>5GHZ 1=>2.4GHZ
-static u32 s_uGetRTSCTSDuration(struct vnt_private *pDevice, u8 byDurType,
+static u16 s_uGetRTSCTSDuration(struct vnt_private *pDevice, u8 byDurType,
 	u32 cbFrameLength, u8 byPktType, u16 wRate, int bNeedAck,
 	u8 byFBOption)
 {
@@ -486,8 +486,7 @@ static u32 s_uGetRTSCTSDuration(struct vnt_private *pDevice, u8 byDurType,
         break;
     }
 
-    return uDurTime;
-
+	return cpu_to_le16((u16)uDurTime);
 }
 
 static u32 s_uFillDataHead(struct vnt_private *pDevice,
@@ -641,9 +640,15 @@ static void s_vFillRTSHead(struct vnt_private *pDevice, u8 byPktType,
             );
             pBuf->wTransmitLength_a = cpu_to_le16(wLen);
             //Get Duration
-            pBuf->wDuration_bb = cpu_to_le16((u16)s_uGetRTSCTSDuration(pDevice, RTSDUR_BB, cbFrameLength, PK_TYPE_11B, pDevice->byTopCCKBasicRate, bNeedAck, byFBOption));    //0:RTSDuration_bb, 1:2.4G, 1:CCKData
-            pBuf->wDuration_aa = cpu_to_le16((u16)s_uGetRTSCTSDuration(pDevice, RTSDUR_AA, cbFrameLength, byPktType, wCurrentRate, bNeedAck, byFBOption)); //2:RTSDuration_aa, 1:2.4G, 2,3: 2.4G OFDMData
-            pBuf->wDuration_ba = cpu_to_le16((u16)s_uGetRTSCTSDuration(pDevice, RTSDUR_BA, cbFrameLength, byPktType, wCurrentRate, bNeedAck, byFBOption)); //1:RTSDuration_ba, 1:2.4G, 2,3:2.4G OFDM Data
+		pBuf->wDuration_bb = s_uGetRTSCTSDuration(pDevice, RTSDUR_BB,
+			cbFrameLength, PK_TYPE_11B,
+			pDevice->byTopCCKBasicRate, bNeedAck, byFBOption);
+		pBuf->wDuration_aa = s_uGetRTSCTSDuration(pDevice, RTSDUR_AA,
+			cbFrameLength, byPktType,
+			wCurrentRate, bNeedAck, byFBOption);
+		pBuf->wDuration_ba = s_uGetRTSCTSDuration(pDevice, RTSDUR_BA,
+			cbFrameLength, byPktType,
+			wCurrentRate, bNeedAck, byFBOption);
 		pBuf->data.duration = pBuf->wDuration_aa;
 		/*Get RTS Frame body */
 		pBuf->data.frame_control = TYPE_CTL_RTS;
@@ -671,13 +676,27 @@ static void s_vFillRTSHead(struct vnt_private *pDevice, u8 byPktType,
             );
             pBuf->wTransmitLength_a = cpu_to_le16(wLen);
             //Get Duration
-            pBuf->wDuration_bb = cpu_to_le16((u16)s_uGetRTSCTSDuration(pDevice, RTSDUR_BB, cbFrameLength, PK_TYPE_11B, pDevice->byTopCCKBasicRate, bNeedAck, byFBOption));    //0:RTSDuration_bb, 1:2.4G, 1:CCKData
-            pBuf->wDuration_aa = cpu_to_le16((u16)s_uGetRTSCTSDuration(pDevice, RTSDUR_AA, cbFrameLength, byPktType, wCurrentRate, bNeedAck, byFBOption)); //2:RTSDuration_aa, 1:2.4G, 2,3:2.4G OFDMData
-            pBuf->wDuration_ba = cpu_to_le16((u16)s_uGetRTSCTSDuration(pDevice, RTSDUR_BA, cbFrameLength, byPktType, wCurrentRate, bNeedAck, byFBOption)); //1:RTSDuration_ba, 1:2.4G, 2,3:2.4G OFDMData
-            pBuf->wRTSDuration_ba_f0 = cpu_to_le16((u16)s_uGetRTSCTSDuration(pDevice, RTSDUR_BA_F0, cbFrameLength, byPktType, wCurrentRate, bNeedAck, byFBOption));    //4:wRTSDuration_ba_f0, 1:2.4G, 1:CCKData
-            pBuf->wRTSDuration_aa_f0 = cpu_to_le16((u16)s_uGetRTSCTSDuration(pDevice, RTSDUR_AA_F0, cbFrameLength, byPktType, wCurrentRate, bNeedAck, byFBOption));    //5:wRTSDuration_aa_f0, 1:2.4G, 1:CCKData
-            pBuf->wRTSDuration_ba_f1 = cpu_to_le16((u16)s_uGetRTSCTSDuration(pDevice, RTSDUR_BA_F1, cbFrameLength, byPktType, wCurrentRate, bNeedAck, byFBOption));    //6:wRTSDuration_ba_f1, 1:2.4G, 1:CCKData
-            pBuf->wRTSDuration_aa_f1 = cpu_to_le16((u16)s_uGetRTSCTSDuration(pDevice, RTSDUR_AA_F1, cbFrameLength, byPktType, wCurrentRate, bNeedAck, byFBOption));    //7:wRTSDuration_aa_f1, 1:2.4G, 1:CCKData
+		pBuf->wDuration_bb = s_uGetRTSCTSDuration(pDevice, RTSDUR_BB,
+			cbFrameLength, PK_TYPE_11B,
+			pDevice->byTopCCKBasicRate, bNeedAck, byFBOption);
+		pBuf->wDuration_aa = s_uGetRTSCTSDuration(pDevice, RTSDUR_AA,
+			cbFrameLength, byPktType,
+			wCurrentRate, bNeedAck, byFBOption);
+		pBuf->wDuration_ba = s_uGetRTSCTSDuration(pDevice, RTSDUR_BA,
+			cbFrameLength, byPktType,
+			wCurrentRate, bNeedAck, byFBOption);
+		pBuf->wRTSDuration_ba_f0 = s_uGetRTSCTSDuration(pDevice,
+			RTSDUR_BA_F0, cbFrameLength, byPktType, wCurrentRate,
+			bNeedAck, byFBOption);
+		pBuf->wRTSDuration_aa_f0 = s_uGetRTSCTSDuration(pDevice,
+			RTSDUR_AA_F0, cbFrameLength, byPktType,
+			wCurrentRate, bNeedAck, byFBOption);
+		pBuf->wRTSDuration_ba_f1 = s_uGetRTSCTSDuration(pDevice,
+			RTSDUR_BA_F1, cbFrameLength, byPktType, wCurrentRate,
+			bNeedAck, byFBOption);
+		pBuf->wRTSDuration_aa_f1 = s_uGetRTSCTSDuration(pDevice,
+			RTSDUR_AA_F1, cbFrameLength, byPktType, wCurrentRate,
+			bNeedAck, byFBOption);
 		pBuf->data.duration = pBuf->wDuration_aa;
 		/*Get RTS Frame body*/
 		pBuf->data.frame_control = TYPE_CTL_RTS;
@@ -703,7 +722,9 @@ static void s_vFillRTSHead(struct vnt_private *pDevice, u8 byPktType,
             );
             pBuf->wTransmitLength = cpu_to_le16(wLen);
             //Get Duration
-            pBuf->wDuration = cpu_to_le16((u16)s_uGetRTSCTSDuration(pDevice, RTSDUR_AA, cbFrameLength, byPktType, wCurrentRate, bNeedAck, byFBOption)); //0:RTSDuration_aa, 0:5G, 0: 5G OFDMData
+		pBuf->wDuration = s_uGetRTSCTSDuration(pDevice, RTSDUR_AA,
+			cbFrameLength, byPktType, wCurrentRate,
+				bNeedAck, byFBOption);
 		pBuf->data.duration = pBuf->wDuration;
 		/* Get RTS Frame body */
 		pBuf->data.frame_control = TYPE_CTL_RTS;
@@ -727,9 +748,15 @@ static void s_vFillRTSHead(struct vnt_private *pDevice, u8 byPktType,
             );
             pBuf->wTransmitLength = cpu_to_le16(wLen);
             //Get Duration
-            pBuf->wDuration = cpu_to_le16((u16)s_uGetRTSCTSDuration(pDevice, RTSDUR_AA, cbFrameLength, byPktType, wCurrentRate, bNeedAck, byFBOption)); //0:RTSDuration_aa, 0:5G, 0: 5G OFDMData
-    	    pBuf->wRTSDuration_f0 = cpu_to_le16((u16)s_uGetRTSCTSDuration(pDevice, RTSDUR_AA_F0, cbFrameLength, byPktType, wCurrentRate, bNeedAck, byFBOption)); //5:RTSDuration_aa_f0, 0:5G, 0: 5G OFDMData
-    	    pBuf->wRTSDuration_f1 = cpu_to_le16((u16)s_uGetRTSCTSDuration(pDevice, RTSDUR_AA_F1, cbFrameLength, byPktType, wCurrentRate, bNeedAck, byFBOption)); //7:RTSDuration_aa_f1, 0:5G, 0:
+		pBuf->wDuration = s_uGetRTSCTSDuration(pDevice, RTSDUR_AA,
+			cbFrameLength, byPktType, wCurrentRate,
+			bNeedAck, byFBOption);
+		pBuf->wRTSDuration_f0 = s_uGetRTSCTSDuration(pDevice,
+			RTSDUR_AA_F0, cbFrameLength, byPktType,
+			wCurrentRate, bNeedAck, byFBOption);
+		pBuf->wRTSDuration_f1 = s_uGetRTSCTSDuration(pDevice,
+			RTSDUR_AA_F1, cbFrameLength, byPktType,
+			wCurrentRate, bNeedAck, byFBOption);
 		pBuf->data.duration = pBuf->wDuration;
 		/* Get RTS Frame body */
 		pBuf->data.frame_control = TYPE_CTL_RTS;
@@ -754,7 +781,9 @@ static void s_vFillRTSHead(struct vnt_private *pDevice, u8 byPktType,
         );
         pBuf->wTransmitLength = cpu_to_le16(wLen);
         //Get Duration
-        pBuf->wDuration = cpu_to_le16((u16)s_uGetRTSCTSDuration(pDevice, RTSDUR_BB, cbFrameLength, byPktType, wCurrentRate, bNeedAck, byFBOption)); //0:RTSDuration_bb, 1:2.4G, 1:CCKData
+	pBuf->wDuration = s_uGetRTSCTSDuration(pDevice, RTSDUR_BB,
+		cbFrameLength, byPktType, wCurrentRate,
+		bNeedAck, byFBOption);
 
 	pBuf->data.duration = pBuf->wDuration;
 	/* Get RTS Frame body */
@@ -799,14 +828,17 @@ static void s_vFillCTSHead(struct vnt_private *pDevice, u32 uDMAIdx,
                 (u16 *)&(wLen), (u8 *)&(pBuf->byServiceField_b), (u8 *)&(pBuf->bySignalField_b)
             );
             pBuf->wTransmitLength_b = cpu_to_le16(wLen);
-            pBuf->wDuration_ba = (u16)s_uGetRTSCTSDuration(pDevice, CTSDUR_BA, cbFrameLength, byPktType, wCurrentRate, bNeedAck, byFBOption); //3:CTSDuration_ba, 1:2.4G, 2,3:2.4G OFDM Data
-            pBuf->wDuration_ba = cpu_to_le16(pBuf->wDuration_ba);
-            //Get CTSDuration_ba_f0
-            pBuf->wCTSDuration_ba_f0 = (u16)s_uGetRTSCTSDuration(pDevice, CTSDUR_BA_F0, cbFrameLength, byPktType, wCurrentRate, bNeedAck, byFBOption); //8:CTSDuration_ba_f0, 1:2.4G, 2,3:2.4G OFDM Data
-            pBuf->wCTSDuration_ba_f0 = cpu_to_le16(pBuf->wCTSDuration_ba_f0);
-            //Get CTSDuration_ba_f1
-            pBuf->wCTSDuration_ba_f1 = (u16)s_uGetRTSCTSDuration(pDevice, CTSDUR_BA_F1, cbFrameLength, byPktType, wCurrentRate, bNeedAck, byFBOption); //9:CTSDuration_ba_f1, 1:2.4G, 2,3:2.4G OFDM Data
-            pBuf->wCTSDuration_ba_f1 = cpu_to_le16(pBuf->wCTSDuration_ba_f1);
+		pBuf->wDuration_ba = s_uGetRTSCTSDuration(pDevice, CTSDUR_BA,
+			cbFrameLength, byPktType,
+			wCurrentRate, bNeedAck, byFBOption);
+		/* Get CTSDuration_ba_f0 */
+		pBuf->wCTSDuration_ba_f0 = s_uGetRTSCTSDuration(pDevice,
+			CTSDUR_BA_F0, cbFrameLength, byPktType, wCurrentRate,
+			bNeedAck, byFBOption);
+		/* Get CTSDuration_ba_f1 */
+		pBuf->wCTSDuration_ba_f1 = s_uGetRTSCTSDuration(pDevice,
+			CTSDUR_BA_F1, cbFrameLength, byPktType, wCurrentRate,
+			bNeedAck, byFBOption);
 		/* Get CTS Frame body */
 		pBuf->data.duration = pBuf->wDuration_ba;
 		pBuf->data.frame_control = TYPE_CTL_CTS;
@@ -818,9 +850,10 @@ static void s_vFillCTSHead(struct vnt_private *pDevice, u32 uDMAIdx,
                 (u16 *)&(wLen), (u8 *)&(pBuf->byServiceField_b), (u8 *)&(pBuf->bySignalField_b)
             );
             pBuf->wTransmitLength_b = cpu_to_le16(wLen);
-            //Get CTSDuration_ba
-            pBuf->wDuration_ba = cpu_to_le16((u16)s_uGetRTSCTSDuration(pDevice, CTSDUR_BA, cbFrameLength, byPktType, wCurrentRate, bNeedAck, byFBOption)); //3:CTSDuration_ba, 1:2.4G, 2,3:2.4G OFDM Data
-            pBuf->wDuration_ba = cpu_to_le16(pBuf->wDuration_ba);
+		/* Get CTSDuration_ba */
+		pBuf->wDuration_ba = s_uGetRTSCTSDuration(pDevice,
+			CTSDUR_BA, cbFrameLength, byPktType,
+			wCurrentRate, bNeedAck, byFBOption);
 		/*Get CTS Frame body*/
 		pBuf->data.duration = pBuf->wDuration_ba;
 		pBuf->data.frame_control = TYPE_CTL_CTS;
-- 
1.8.1.2


