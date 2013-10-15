Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:64482 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759597Ab3JOUFI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Oct 2013 16:05:08 -0400
Received: by mail-we0-f169.google.com with SMTP id q58so9221721wes.0
        for <linux-wireless@vger.kernel.org>; Tue, 15 Oct 2013 13:05:06 -0700 (PDT)
Message-ID: <1381867502.5100.21.camel@canaries32-MCP7A> (sfid-20131015_220512_806300_D3846500)
Subject: [PATCH 3/3] staging: vt6656: rxtx.c clean up s_uGetRTSCTSDuration
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Tue, 15 Oct 2013 21:05:02 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

White space clean up.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 53 +++++++++++++++++++++++--------------------
 1 file changed, 28 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 9cf5b08..0c1c46f 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -427,35 +427,38 @@ static u16 s_uGetRTSCTSDuration(struct vnt_private *pDevice, u8 byDurType,
 {
 	u32 uCTSTime = 0, uDurTime = 0;
 
-    switch (byDurType) {
+	switch (byDurType) {
+	case RTSDUR_BB:
+	case RTSDUR_BA:
+	case RTSDUR_BA_F0:
+	case RTSDUR_BA_F1:
+		uCTSTime = BBuGetFrameTime(pDevice->byPreambleType, byPktType,
+			14, pDevice->byTopCCKBasicRate);
+		uDurTime = uCTSTime + 2 * pDevice->uSIFS +
+			s_uGetTxRsvTime(pDevice, byPktType,
+						cbFrameLength, wRate, bNeedAck);
+		break;
 
-    case RTSDUR_BB:    //RTSDuration_bb
-    case RTSDUR_BA:    //RTSDuration_ba
-    case RTSDUR_BA_F0: //RTSDuration_ba_f0
-    case RTSDUR_BA_F1: //RTSDuration_ba_f1
-        uCTSTime = BBuGetFrameTime(pDevice->byPreambleType, byPktType, 14, pDevice->byTopCCKBasicRate);
-	uDurTime = uCTSTime + 2 * pDevice->uSIFS + s_uGetTxRsvTime(pDevice,
-		byPktType, cbFrameLength, wRate, bNeedAck);
-        break;
-
-    case RTSDUR_AA:
-    case RTSDUR_AA_F0:
-    case RTSDUR_AA_F1: //RTSDuration_aa_f1
-        uCTSTime = BBuGetFrameTime(pDevice->byPreambleType, byPktType, 14, pDevice->byTopOFDMBasicRate);
-	uDurTime = uCTSTime + 2 * pDevice->uSIFS + s_uGetTxRsvTime(pDevice,
-				byPktType, cbFrameLength, wRate, bNeedAck);
-	break;
+	case RTSDUR_AA:
+	case RTSDUR_AA_F0:
+	case RTSDUR_AA_F1:
+		uCTSTime = BBuGetFrameTime(pDevice->byPreambleType, byPktType,
+			14, pDevice->byTopOFDMBasicRate);
+		uDurTime = uCTSTime + 2 * pDevice->uSIFS +
+			s_uGetTxRsvTime(pDevice, byPktType,
+						cbFrameLength, wRate, bNeedAck);
+		break;
 
-    case CTSDUR_BA:
-    case CTSDUR_BA_F0: //CTSDuration_ba_f0
-    case CTSDUR_BA_F1: //CTSDuration_ba_f1
-	uDurTime = pDevice->uSIFS + s_uGetTxRsvTime(pDevice,
+	case CTSDUR_BA:
+	case CTSDUR_BA_F0:
+	case CTSDUR_BA_F1:
+		uDurTime = pDevice->uSIFS + s_uGetTxRsvTime(pDevice,
 				byPktType, cbFrameLength, wRate, bNeedAck);
-	break;
+		break;
 
-    default:
-        break;
-    }
+	default:
+		break;
+	}
 
 	return cpu_to_le16((u16)uDurTime);
 }
-- 
1.8.3.2


