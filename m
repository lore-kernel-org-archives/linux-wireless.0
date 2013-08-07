Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:44390 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932769Ab3HGUdN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Aug 2013 16:33:13 -0400
Received: by mail-wg0-f51.google.com with SMTP id a12so1946297wgh.30
        for <linux-wireless@vger.kernel.org>; Wed, 07 Aug 2013 13:33:12 -0700 (PDT)
Message-ID: <1375907588.5626.40.camel@canaries64> (sfid-20130807_223316_377187_5555AB52)
Subject: [PATCH 4/4] staging: vt6656: rxtx.c s:_uGetDataDuration simplify
 structure
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Wed, 07 Aug 2013 21:33:08 +0100
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
index 70a30d9..42f0823 100644
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
-                return (pDevice->uSIFS + uAckTime);switch
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






