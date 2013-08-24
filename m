Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:63175 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754479Ab3HXLu6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Aug 2013 07:50:58 -0400
Received: by mail-wg0-f44.google.com with SMTP id x12so1159676wgg.35
        for <linux-wireless@vger.kernel.org>; Sat, 24 Aug 2013 04:50:57 -0700 (PDT)
Message-ID: <1377345050.23229.9.camel@canaries32-MCP7A> (sfid-20130824_135101_890295_5C2D9120)
Subject: [PATCH 2/5] staging: vt6656: rxtx.c s_vFillRTSHead remove dead
 bDiscCRC
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Sat, 24 Aug 2013 12:50:50 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As result of patch
vt6656: device.h Remove dead code bSoftwareGenCrcErr.

dDiscCRC is unused.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 80741c0..1b2effc 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -129,7 +129,7 @@ static void s_vFillCTSHead(struct vnt_private *pDevice, u32 uDMAIdx,
 	int bDisCRC, u16 wCurrentRate, u8 byFBOption);
 
 static void s_vFillRTSHead(struct vnt_private *pDevice, u8 byPktType,
-	void *pvRTS, u32 cbFrameLength, int bNeedAck, int bDisCRC,
+	void *pvRTS, u32 cbFrameLength, int bNeedAck,
 	struct ethhdr *psEthHeader, u16 wCurrentRate, u8 byFBOption);
 
 static u16 s_uGetDataDuration(struct vnt_private *pDevice,
@@ -596,7 +596,7 @@ static u32 s_uFillDataHead(struct vnt_private *pDevice,
 }
 
 static void s_vFillRTSHead(struct vnt_private *pDevice, u8 byPktType,
-	void *pvRTS, u32 cbFrameLength, int bNeedAck, int bDisCRC,
+	void *pvRTS, u32 cbFrameLength, int bNeedAck,
 	struct ethhdr *psEthHeader, u16 wCurrentRate, u8 byFBOption)
 {
 	u32 uRTSFrameLen = 20;
@@ -604,12 +604,6 @@ static void s_vFillRTSHead(struct vnt_private *pDevice, u8 byPktType,
     if (pvRTS == NULL)
     	return;
 
-    if (bDisCRC) {
-        // When CRCDIS bit is on, H/W forgot to generate FCS for RTS frame,
-        // in this case we need to decrease its length by 4.
-        uRTSFrameLen -= 4;
-    }
-
     // Note: So far RTSHead doesn't appear in ATIM & Beacom DMA, so we don't need to take them into account.
     //       Otherwise, we need to modified codes for them.
     if (byPktType == PK_TYPE_11GB || byPktType == PK_TYPE_11GA) {
@@ -900,7 +894,8 @@ static void s_vGenerateTxParameter(struct vnt_private *pDevice,
 				bNeedACK);
             }
             //Fill RTS
-            s_vFillRTSHead(pDevice, byPktType, pvRTS, cbFrameSize, bNeedACK, bDisCRC, psEthHeader, wCurrentRate, byFBOption);
+	    s_vFillRTSHead(pDevice, byPktType, pvRTS, cbFrameSize, bNeedACK,
+				psEthHeader, wCurrentRate, byFBOption);
         }
         else {//RTS_needless, PCF mode
 
@@ -933,7 +928,8 @@ static void s_vGenerateTxParameter(struct vnt_private *pDevice,
 				cbFrameSize, wCurrentRate, bNeedACK);
             }
             //Fill RTS
-            s_vFillRTSHead(pDevice, byPktType, pvRTS, cbFrameSize, bNeedACK, bDisCRC, psEthHeader, wCurrentRate, byFBOption);
+	    s_vFillRTSHead(pDevice, byPktType, pvRTS, cbFrameSize, bNeedACK,
+			psEthHeader, wCurrentRate, byFBOption);
         }
         else if (pvRTS == NULL) {//RTS_needless, non PCF mode
             //Fill RsvTime
@@ -958,7 +954,8 @@ static void s_vGenerateTxParameter(struct vnt_private *pDevice,
 				cbFrameSize, wCurrentRate, bNeedACK);
             }
             //Fill RTS
-            s_vFillRTSHead(pDevice, byPktType, pvRTS, cbFrameSize, bNeedACK, bDisCRC, psEthHeader, wCurrentRate, byFBOption);
+	    s_vFillRTSHead(pDevice, byPktType, pvRTS, cbFrameSize, bNeedACK,
+			psEthHeader, wCurrentRate, byFBOption);
         }
         else { //RTS_needless, non PCF mode
             //Fill RsvTime
-- 
1.8.1.2

