Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:59884 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932343Ab3HGU03 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Aug 2013 16:26:29 -0400
Received: by mail-wg0-f44.google.com with SMTP id l18so1888597wgh.11
        for <linux-wireless@vger.kernel.org>; Wed, 07 Aug 2013 13:26:28 -0700 (PDT)
Message-ID: <1375907172.5626.37.camel@canaries64> (sfid-20130807_222633_206613_DAD6D099)
Subject: [PATCH 1/4] staging: vt6656: rxtx.c: s_uGetDataDuration remove
 First Frag or Mid Frag dead code.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Wed, 07 Aug 2013 21:26:12 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver always calls s_uGetDataDuration with;
uFragIdx = 0, cbLastFragmentSize = 0 and uMACfragNum = 1

uFragIdx == (uMACfragNum-1) is always true and bLastFrag = 1.

Remove dead First Frag or Mid Frag if/else and variables.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 105 +-----------------------------------------
 1 file changed, 1 insertion(+), 104 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index b26fb2a..d3b9a6b 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -392,147 +392,44 @@ static u32 s_uGetDataDuration(struct vnt_private *pDevice, u8 byDurType,
 	u32 uFragIdx, u32 cbLastFragmentSize, u32 uMACfragNum,
 	u8 byFBOption)
 {
-	int bLastFrag = 0;
-	u32 uAckTime = 0, uNextPktTime = 0;
-
-    if (uFragIdx == (uMACfragNum-1)) {
-        bLastFrag = 1;
-    }
+	u32 uAckTime = 0;
 
     switch (byDurType) {
 
     case DATADUR_B:    //DATADUR_B
-        if (((uMACfragNum == 1)) || (bLastFrag == 1)) {//Non Frag or Last Frag
             if (bNeedAck) {
             	uAckTime = BBuGetFrameTime(pDevice->byPreambleType, byPktType, 14, pDevice->byTopCCKBasicRate);
                 return (pDevice->uSIFS + uAckTime);
             } else {
                 return 0;
             }
-        }
-        else {//First Frag or Mid Frag
-            if (uFragIdx == (uMACfragNum-2)) {
-            	uNextPktTime = s_uGetTxRsvTime(pDevice, byPktType, cbLastFragmentSize, wRate, bNeedAck);
-            } else {
-                uNextPktTime = s_uGetTxRsvTime(pDevice, byPktType, cbFrameLength, wRate, bNeedAck);
-            }
-            if (bNeedAck) {
-            	uAckTime = BBuGetFrameTime(pDevice->byPreambleType, byPktType, 14, pDevice->byTopCCKBasicRate);
-                return (pDevice->uSIFS + uAckTime + uNextPktTime);
-            } else {
-                return (pDevice->uSIFS + uNextPktTime);
-            }
-        }
         break;
 
     case DATADUR_A:    //DATADUR_A
-        if (((uMACfragNum==1)) || (bLastFrag==1)) {//Non Frag or Last Frag
             if(bNeedAck){
             	uAckTime = BBuGetFrameTime(pDevice->byPreambleType, byPktType, 14, pDevice->byTopOFDMBasicRate);
                 return (pDevice->uSIFS + uAckTime);
             } else {
                 return 0;
             }
-        }
-        else {//First Frag or Mid Frag
-            if(uFragIdx == (uMACfragNum-2)){
-            	uNextPktTime = s_uGetTxRsvTime(pDevice, byPktType, cbLastFragmentSize, wRate, bNeedAck);
-            } else {
-                uNextPktTime = s_uGetTxRsvTime(pDevice, byPktType, cbFrameLength, wRate, bNeedAck);
-            }
-            if(bNeedAck){
-            	uAckTime = BBuGetFrameTime(pDevice->byPreambleType, byPktType, 14, pDevice->byTopOFDMBasicRate);
-                return (pDevice->uSIFS + uAckTime + uNextPktTime);
-            } else {
-                return (pDevice->uSIFS + uNextPktTime);
-            }
-        }
         break;
 
     case DATADUR_A_F0:    //DATADUR_A_F0
-	    if (((uMACfragNum==1)) || (bLastFrag==1)) {//Non Frag or Last Frag
             if(bNeedAck){
             	uAckTime = BBuGetFrameTime(pDevice->byPreambleType, byPktType, 14, pDevice->byTopOFDMBasicRate);
                 return (pDevice->uSIFS + uAckTime);
             } else {
                 return 0;
             }
-        }
-	    else { //First Frag or Mid Frag
-	        if (byFBOption == AUTO_FB_0) {
-                if (wRate < RATE_18M)
-                    wRate = RATE_18M;
-                else if (wRate > RATE_54M)
-                    wRate = RATE_54M;
-
-	            if(uFragIdx == (uMACfragNum-2)){
-            	    uNextPktTime = s_uGetTxRsvTime(pDevice, byPktType, cbLastFragmentSize, wFB_Opt0[FB_RATE0][wRate-RATE_18M], bNeedAck);
-                } else {
-                    uNextPktTime = s_uGetTxRsvTime(pDevice, byPktType, cbFrameLength, wFB_Opt0[FB_RATE0][wRate-RATE_18M], bNeedAck);
-                }
-	        } else { // (byFBOption == AUTO_FB_1)
-                if (wRate < RATE_18M)
-                    wRate = RATE_18M;
-                else if (wRate > RATE_54M)
-                    wRate = RATE_54M;
-
-	            if(uFragIdx == (uMACfragNum-2)){
-            	    uNextPktTime = s_uGetTxRsvTime(pDevice, byPktType, cbLastFragmentSize, wFB_Opt1[FB_RATE0][wRate-RATE_18M], bNeedAck);
-                } else {
-                    uNextPktTime = s_uGetTxRsvTime(pDevice, byPktType, cbFrameLength, wFB_Opt1[FB_RATE0][wRate-RATE_18M], bNeedAck);
-                }
-	        }
-
-	        if(bNeedAck){
-            	uAckTime = BBuGetFrameTime(pDevice->byPreambleType, byPktType, 14, pDevice->byTopOFDMBasicRate);
-                return (pDevice->uSIFS + uAckTime + uNextPktTime);
-            } else {
-                return (pDevice->uSIFS + uNextPktTime);
-            }
-	    }
         break;
 
     case DATADUR_A_F1:    //DATADUR_A_F1
-        if (((uMACfragNum==1)) || (bLastFrag==1)) {//Non Frag or Last Frag
             if(bNeedAck){
             	uAckTime = BBuGetFrameTime(pDevice->byPreambleType, byPktType, 14, pDevice->byTopOFDMBasicRate);
                 return (pDevice->uSIFS + uAckTime);
             } else {
                 return 0;
             }
-        }
-	    else { //First Frag or Mid Frag
-	        if (byFBOption == AUTO_FB_0) {
-                if (wRate < RATE_18M)
-                    wRate = RATE_18M;
-                else if (wRate > RATE_54M)
-                    wRate = RATE_54M;
-
-	            if(uFragIdx == (uMACfragNum-2)){
-            	    uNextPktTime = s_uGetTxRsvTime(pDevice, byPktType, cbLastFragmentSize, wFB_Opt0[FB_RATE1][wRate-RATE_18M], bNeedAck);
-                } else {
-                    uNextPktTime = s_uGetTxRsvTime(pDevice, byPktType, cbFrameLength, wFB_Opt0[FB_RATE1][wRate-RATE_18M], bNeedAck);
-                }
-
-	        } else { // (byFBOption == AUTO_FB_1)
-                if (wRate < RATE_18M)
-                    wRate = RATE_18M;
-                else if (wRate > RATE_54M)
-                    wRate = RATE_54M;
-
-	            if(uFragIdx == (uMACfragNum-2)){
-            	    uNextPktTime = s_uGetTxRsvTime(pDevice, byPktType, cbLastFragmentSize, wFB_Opt1[FB_RATE1][wRate-RATE_18M], bNeedAck);
-                } else {
-                    uNextPktTime = s_uGetTxRsvTime(pDevice, byPktType, cbFrameLength, wFB_Opt1[FB_RATE1][wRate-RATE_18M], bNeedAck);
-                }
-	        }
-	        if(bNeedAck){
-            	uAckTime = BBuGetFrameTime(pDevice->byPreambleType, byPktType, 14, pDevice->byTopOFDMBasicRate);
-                return (pDevice->uSIFS + uAckTime + uNextPktTime);
-            } else {
-                return (pDevice->uSIFS + uNextPktTime);
-            }
-	    }
         break;
 
     default:
-- 
1.8.1.2


