Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:48932 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757949Ab3HMS7j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Aug 2013 14:59:39 -0400
Received: by mail-wg0-f52.google.com with SMTP id b13so6866841wgh.31
        for <linux-wireless@vger.kernel.org>; Tue, 13 Aug 2013 11:59:38 -0700 (PDT)
Message-ID: <1376420371.6292.10.camel@canaries32-MCP7A> (sfid-20130813_205943_387504_0DA43038)
Subject: [PATCH v2 rebased] staging: vt6656: rxtx.c s:_uGetDataDuration
 simplify structure.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Tue, 13 Aug 2013 19:59:31 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A value is only returned when bNeedAck is true.

Only when byDurType == DATADUR_B is different.

Remove switch statement and simplify with if structure.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 50 ++++++++-----------------------------------
 1 file changed, 9 insertions(+), 41 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index c8e3e7e8..a701120 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -389,47 +389,15 @@ static u32 s_uGetDataDuration(struct vnt_private *pDevice, u8 byDurType,
 {
 	u32 uAckTime = 0;
 
-    switch (byDurType) {
-
-    case DATADUR_B:    //DATADUR_B
-            if (bNeedAck) {
-            	uAckTime = BBuGetFrameTime(pDevice->byPreambleType, byPktType, 14, pDevice->byTopCCKBasicRate);
-                return (pDevice->uSIFS + uAckTime);
-            } else {
-                return 0;
-            }
-        break;
-
-    case DATADUR_A:    //DATADUR_A
-            if(bNeedAck){
-            	uAckTime = BBuGetFrameTime(pDevice->byPreambleType, byPktType, 14, pDevice->byTopOFDMBasicRate);
-                return (pDevice->uSIFS + uAckTime);
-            } else {
-                return 0;
-            }
-        break;
-
-    case DATADUR_A_F0:    //DATADUR_A_F0
-            if(bNeedAck){
-            	uAckTime = BBuGetFrameTime(pDevice->byPreambleType, byPktType, 14, pDevice->byTopOFDMBasicRate);
-                return (pDevice->uSIFS + uAckTime);
-            } else {
-                return 0;
-            }
-        break;
-
-    case DATADUR_A_F1:    //DATADUR_A_F1
-            if(bNeedAck){
-            	uAckTime = BBuGetFrameTime(pDevice->byPreambleType, byPktType, 14, pDevice->byTopOFDMBasicRate);
-                return (pDevice->uSIFS + uAckTime);
-            } else {
-                return 0;
-            }
-        break;
-
-    default:
-        break;
-    }
+	if (bNeedAck) {
+		if (byDurType == DATADUR_B)
+			uAckTime = BBuGetFrameTime(pDevice->byPreambleType,
+				byPktType, 14, pDevice->byTopCCKBasicRate);
+		else
+			uAckTime = BBuGetFrameTime(pDevice->byPreambleType,
+				byPktType, 14, pDevice->byTopOFDMBasicRate);
+		return pDevice->uSIFS + uAckTime;
+	}
 
 	return 0;
 }
-- 
1.8.1.2


