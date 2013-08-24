Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:61231 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754313Ab3HXL4T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Aug 2013 07:56:19 -0400
Received: by mail-wi0-f179.google.com with SMTP id hr7so1431260wib.6
        for <linux-wireless@vger.kernel.org>; Sat, 24 Aug 2013 04:56:18 -0700 (PDT)
Message-ID: <1377345371.23229.12.camel@canaries32-MCP7A> (sfid-20130824_135622_549145_CCEFFD74)
Subject: [PATCH 3/5] staging: vt6656: rxtx.c s_vFillCTSHead remove dead code
 bDisCRC
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Sat, 24 Aug 2013 12:56:11 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As result of patch
vt6656: device.h Remove dead code bSoftwareGenCrcErr.

dDiscCRC is unused.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 1b2effc..7b94a77 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -126,7 +126,7 @@ static u16 s_uGetRTSCTSRsvTime(struct vnt_private *pDevice, u8 byRTSRsvType,
 
 static void s_vFillCTSHead(struct vnt_private *pDevice, u32 uDMAIdx,
 	u8 byPktType, void *pvCTS, u32 cbFrameLength, int bNeedAck,
-	int bDisCRC, u16 wCurrentRate, u8 byFBOption);
+	u16 wCurrentRate, u8 byFBOption);
 
 static void s_vFillRTSHead(struct vnt_private *pDevice, u8 byPktType,
 	void *pvRTS, u32 cbFrameLength, int bNeedAck,
@@ -769,7 +769,7 @@ static void s_vFillRTSHead(struct vnt_private *pDevice, u8 byPktType,
 
 static void s_vFillCTSHead(struct vnt_private *pDevice, u32 uDMAIdx,
 	u8 byPktType, void *pvCTS, u32 cbFrameLength, int bNeedAck,
-	int bDisCRC, u16 wCurrentRate, u8 byFBOption)
+	u16 wCurrentRate, u8 byFBOption)
 {
 	u32 uCTSFrameLen = 14;
 
@@ -777,12 +777,6 @@ static void s_vFillCTSHead(struct vnt_private *pDevice, u32 uDMAIdx,
         return;
     }
 
-    if (bDisCRC) {
-        // When CRCDIS bit is on, H/W forgot to generate FCS for CTS frame,
-        // in this case we need to decrease its length by 4.
-        uCTSFrameLen -= 4;
-    }
-
     if (byPktType == PK_TYPE_11GB || byPktType == PK_TYPE_11GA) {
 	if (byFBOption != AUTO_FB_NONE) {
 		/* Auto Fall back */
@@ -912,7 +906,8 @@ static void s_vGenerateTxParameter(struct vnt_private *pDevice,
 				byPktType, cbFrameSize, wCurrentRate);
             }
             //Fill CTS
-            s_vFillCTSHead(pDevice, uDMAIdx, byPktType, pvCTS, cbFrameSize, bNeedACK, bDisCRC, wCurrentRate, byFBOption);
+	    s_vFillCTSHead(pDevice, uDMAIdx, byPktType, pvCTS, cbFrameSize,
+			bNeedACK, wCurrentRate, byFBOption);
         }
     }
     else if (byPktType == PK_TYPE_11A) {
-- 
1.8.1.2

