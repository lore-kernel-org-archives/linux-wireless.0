Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:57669 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757291Ab3JOUED (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Oct 2013 16:04:03 -0400
Received: by mail-wg0-f43.google.com with SMTP id b13so5042484wgh.34
        for <linux-wireless@vger.kernel.org>; Tue, 15 Oct 2013 13:04:02 -0700 (PDT)
Message-ID: <1381867433.5100.20.camel@canaries32-MCP7A> (sfid-20131015_220417_303690_F489A81C)
Subject: [PATCH 2/3] staging: vt6656: rxtx.c s_uGetRTSCTSDuration allow
 fall-through duplicates
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Tue, 15 Oct 2013 21:03:53 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow switch fall-through of duplicate case.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 35 +++--------------------------------
 1 file changed, 3 insertions(+), 32 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 3404730..9cf5b08 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -430,53 +430,24 @@ static u16 s_uGetRTSCTSDuration(struct vnt_private *pDevice, u8 byDurType,
     switch (byDurType) {
 
     case RTSDUR_BB:    //RTSDuration_bb
-        uCTSTime = BBuGetFrameTime(pDevice->byPreambleType, byPktType, 14, pDevice->byTopCCKBasicRate);
-        uDurTime = uCTSTime + 2*pDevice->uSIFS + s_uGetTxRsvTime(pDevice, byPktType, cbFrameLength, wRate, bNeedAck);
-        break;
-
     case RTSDUR_BA:    //RTSDuration_ba
-        uCTSTime = BBuGetFrameTime(pDevice->byPreambleType, byPktType, 14, pDevice->byTopCCKBasicRate);
-        uDurTime = uCTSTime + 2*pDevice->uSIFS + s_uGetTxRsvTime(pDevice, byPktType, cbFrameLength, wRate, bNeedAck);
-        break;
-
-    case RTSDUR_AA:    //RTSDuration_aa
-        uCTSTime = BBuGetFrameTime(pDevice->byPreambleType, byPktType, 14, pDevice->byTopOFDMBasicRate);
-        uDurTime = uCTSTime + 2*pDevice->uSIFS + s_uGetTxRsvTime(pDevice, byPktType, cbFrameLength, wRate, bNeedAck);
-        break;
-
-    case CTSDUR_BA:    //CTSDuration_ba
-        uDurTime = pDevice->uSIFS + s_uGetTxRsvTime(pDevice, byPktType, cbFrameLength, wRate, bNeedAck);
-        break;
-
     case RTSDUR_BA_F0: //RTSDuration_ba_f0
-        uCTSTime = BBuGetFrameTime(pDevice->byPreambleType, byPktType, 14, pDevice->byTopCCKBasicRate);
-	uDurTime = uCTSTime + 2 * pDevice->uSIFS + s_uGetTxRsvTime(pDevice,
-			byPktType, cbFrameLength, wRate, bNeedAck);
-        break;
-
-    case RTSDUR_AA_F0: //RTSDuration_aa_f0
-        uCTSTime = BBuGetFrameTime(pDevice->byPreambleType, byPktType, 14, pDevice->byTopOFDMBasicRate);
-	uDurTime = uCTSTime + 2 * pDevice->uSIFS + s_uGetTxRsvTime(pDevice,
-			byPktType, cbFrameLength, wRate, bNeedAck);
-        break;
-
     case RTSDUR_BA_F1: //RTSDuration_ba_f1
         uCTSTime = BBuGetFrameTime(pDevice->byPreambleType, byPktType, 14, pDevice->byTopCCKBasicRate);
 	uDurTime = uCTSTime + 2 * pDevice->uSIFS + s_uGetTxRsvTime(pDevice,
 		byPktType, cbFrameLength, wRate, bNeedAck);
         break;
 
+    case RTSDUR_AA:
+    case RTSDUR_AA_F0:
     case RTSDUR_AA_F1: //RTSDuration_aa_f1
         uCTSTime = BBuGetFrameTime(pDevice->byPreambleType, byPktType, 14, pDevice->byTopOFDMBasicRate);
 	uDurTime = uCTSTime + 2 * pDevice->uSIFS + s_uGetTxRsvTime(pDevice,
 				byPktType, cbFrameLength, wRate, bNeedAck);
 	break;
 
+    case CTSDUR_BA:
     case CTSDUR_BA_F0: //CTSDuration_ba_f0
-	uDurTime = pDevice->uSIFS + s_uGetTxRsvTime(pDevice,
-				byPktType, cbFrameLength, wRate, bNeedAck);
-	break;
-
     case CTSDUR_BA_F1: //CTSDuration_ba_f1
 	uDurTime = pDevice->uSIFS + s_uGetTxRsvTime(pDevice,
 				byPktType, cbFrameLength, wRate, bNeedAck);
-- 
1.8.3.2


