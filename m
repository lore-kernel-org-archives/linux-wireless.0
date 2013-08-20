Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:64857 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750Ab3HTTr5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Aug 2013 15:47:57 -0400
Received: by mail-wi0-f172.google.com with SMTP id hj13so4781353wib.5
        for <linux-wireless@vger.kernel.org>; Tue, 20 Aug 2013 12:47:56 -0700 (PDT)
Message-ID: <1377028069.8082.5.camel@canaries32-MCP7A> (sfid-20130820_214801_144237_223D76DD)
Subject: [PATCH ] staging: vt6656: rxtx.c dead code
 TYPE_ATIMDMA/TYPE_BEACONDMA
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Tue, 20 Aug 2013 20:47:49 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Both TYPE_ATIMDMA/TYPE_BEACONDMA are not used in driver for the value of uDMAIdx.

Remove dead code.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 41 +++++++----------------------------------
 1 file changed, 7 insertions(+), 34 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index d7f920d..06950c4 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -499,22 +499,6 @@ static u32 s_uFillDataHead(struct vnt_private *pDevice,
     }
 
     if (byPktType == PK_TYPE_11GB || byPktType == PK_TYPE_11GA) {
-	if ((uDMAIdx == TYPE_ATIMDMA) || (uDMAIdx == TYPE_BEACONDMA)) {
-		struct vnt_tx_datahead_ab *pBuf =
-			(struct vnt_tx_datahead_ab *)pTxDataHead;
-            //Get SignalField,ServiceField,Length
-            BBvCalculateParameter(pDevice, cbFrameLength, wCurrentRate, byPktType,
-                (u16 *)&(pBuf->wTransmitLength), (u8 *)&(pBuf->byServiceField), (u8 *)&(pBuf->bySignalField)
-            );
-            //Get Duration and TimeStampOff
-		pBuf->wDuration = (u16)s_uGetDataDuration(pDevice, DATADUR_A,
-					byPktType, bNeedAck);
-            if(uDMAIdx!=TYPE_ATIMDMA) {
-                pBuf->wTimeStampOff = wTimeStampOff[pDevice->byPreambleType%2][wCurrentRate%MAX_RATE];
-            }
-            return (pBuf->wDuration);
-        }
-        else { // DATA & MANAGE Frame
             if (byFBOption == AUTO_FB_NONE) {
 		struct vnt_tx_datahead_g *pBuf =
 				(struct vnt_tx_datahead_g *)pTxDataHead;
@@ -558,11 +542,9 @@ static u32 s_uFillDataHead(struct vnt_private *pDevice,
                 pBuf->wTimeStampOff_b = wTimeStampOff[pDevice->byPreambleType%2][pDevice->byTopCCKBasicRate%MAX_RATE];
                 return (pBuf->wDuration_a);
             } //if (byFBOption == AUTO_FB_NONE)
-        }
     }
     else if (byPktType == PK_TYPE_11A) {
-        if ((byFBOption != AUTO_FB_NONE) && (uDMAIdx != TYPE_ATIMDMA) && (uDMAIdx != TYPE_BEACONDMA)) {
-            // Auto Fallback
+	if (byFBOption != AUTO_FB_NONE) {
 		struct vnt_tx_datahead_a_fb *pBuf =
 			(struct vnt_tx_datahead_a_fb *)pTxDataHead;
             //Get SignalField,ServiceField,Length
@@ -576,9 +558,7 @@ static u32 s_uFillDataHead(struct vnt_private *pDevice,
 				DATADUR_A_F0, byPktType, bNeedAck);
 		pBuf->wDuration_f1 = (u16)s_uGetDataDuration(pDevice,
 				DATADUR_A_F1, byPktType, bNeedAck);
-            if(uDMAIdx!=TYPE_ATIMDMA) {
                 pBuf->wTimeStampOff = wTimeStampOff[pDevice->byPreambleType%2][wCurrentRate%MAX_RATE];
-            }
             return (pBuf->wDuration);
         } else {
 		struct vnt_tx_datahead_ab *pBuf =
@@ -590,10 +570,8 @@ static u32 s_uFillDataHead(struct vnt_private *pDevice,
             //Get Duration and TimeStampOff
 		pBuf->wDuration = (u16)s_uGetDataDuration(pDevice, DATADUR_A,
 				byPktType, bNeedAck);
-
-            if(uDMAIdx!=TYPE_ATIMDMA) {
                 pBuf->wTimeStampOff = wTimeStampOff[pDevice->byPreambleType%2][wCurrentRate%MAX_RATE];
-            }
+
             return (pBuf->wDuration);
         }
     }
@@ -607,9 +585,8 @@ static u32 s_uFillDataHead(struct vnt_private *pDevice,
             //Get Duration and TimeStampOff
 		pBuf->wDuration = (u16)s_uGetDataDuration(pDevice, DATADUR_B,
 				byPktType, bNeedAck);
-            if (uDMAIdx != TYPE_ATIMDMA) {
                 pBuf->wTimeStampOff = wTimeStampOff[pDevice->byPreambleType%2][wCurrentRate%MAX_RATE];
-            }
+
             return (pBuf->wDuration);
     }
     return 0;
@@ -826,8 +803,8 @@ static void s_vFillCTSHead(struct vnt_private *pDevice, u32 uDMAIdx,
     }
 
     if (byPktType == PK_TYPE_11GB || byPktType == PK_TYPE_11GA) {
-        if (byFBOption != AUTO_FB_NONE && uDMAIdx != TYPE_ATIMDMA && uDMAIdx != TYPE_BEACONDMA) {
-            // Auto Fall back
+	if (byFBOption != AUTO_FB_NONE) {
+		/* Auto Fall back */
 		struct vnt_cts_fb *pBuf = (struct vnt_cts_fb *)pvCTS;
             //Get SignalField,ServiceField,Length
             BBvCalculateParameter(pDevice, uCTSFrameLen, pDevice->byTopCCKBasicRate, PK_TYPE_11B,
@@ -849,7 +826,7 @@ static void s_vFillCTSHead(struct vnt_private *pDevice, u32 uDMAIdx,
 		pBuf->data.duration = pBuf->wDuration_ba;
 		pBuf->data.frame_control = TYPE_CTL_CTS;
 		memcpy(pBuf->data.ra, pDevice->abyCurrentNetAddr, ETH_ALEN);
-        } else { //if (byFBOption != AUTO_FB_NONE && uDMAIdx != TYPE_ATIMDMA && uDMAIdx != TYPE_BEACONDMA)
+	} else {
 		struct vnt_cts *pBuf = (struct vnt_cts *)pvCTS;
             //Get SignalField,ServiceField,Length
             BBvCalculateParameter(pDevice, uCTSFrameLen, pDevice->byTopCCKBasicRate, PK_TYPE_11B,
@@ -1462,11 +1439,7 @@ static void s_vGenerateMACHeader(struct vnt_private *pDevice,
 {
 	struct ieee80211_hdr *pMACHeader = (struct ieee80211_hdr *)pbyBufferAddr;
 
-    if (uDMAIdx == TYPE_ATIMDMA) {
-    	pMACHeader->frame_control = TYPE_802_11_ATIM;
-    } else {
-        pMACHeader->frame_control = TYPE_802_11_DATA;
-    }
+	pMACHeader->frame_control = TYPE_802_11_DATA;
 
     if (pDevice->eOPMode == OP_MODE_AP) {
 	memcpy(&(pMACHeader->addr1[0]),
-- 
1.8.1.2

