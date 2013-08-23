Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f177.google.com ([209.85.215.177]:55473 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754164Ab3HWKtG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Aug 2013 06:49:06 -0400
Received: by mail-ea0-f177.google.com with SMTP id f15so218173eak.36
        for <linux-wireless@vger.kernel.org>; Fri, 23 Aug 2013 03:49:03 -0700 (PDT)
Message-ID: <1377254926.8002.20.camel@canaries32-MCP7A> (sfid-20130823_124914_825557_E54C7EC6)
Subject: [PATCH] staging: vt6656: rxtx.c endian correct wTimeStampOff
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Fri, 23 Aug 2013 11:48:46 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wTimeStampOff needs to be endian corrected

Create new function vnt_time_stamp_off to return little endian u16 value.

Private variable byPreambleType is common to all calling functions is included.

variable rate to set the desired rate.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 33 ++++++++++++++++++++++-----------
 1 file changed, 22 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index f1eec60..ed3fdf4 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -323,6 +323,12 @@ static void s_vSWencryption(struct vnt_private *pDevice,
     }
 }
 
+static u16 vnt_time_stamp_off(struct vnt_private *priv, u16 rate)
+{
+	return cpu_to_le16(wTimeStampOff[priv->byPreambleType % 2]
+							[rate % MAX_RATE]);
+}
+
 /*byPktType : PK_TYPE_11A     0
              PK_TYPE_11B     1
              PK_TYPE_11GB    2
@@ -519,8 +525,10 @@ static u32 s_uFillDataHead(struct vnt_private *pDevice,
 		pBuf->wDuration_b = s_uGetDataDuration(pDevice,
 							PK_TYPE_11B, bNeedAck);
 
-                pBuf->wTimeStampOff_a = wTimeStampOff[pDevice->byPreambleType%2][wCurrentRate%MAX_RATE];
-                pBuf->wTimeStampOff_b = wTimeStampOff[pDevice->byPreambleType%2][pDevice->byTopCCKBasicRate%MAX_RATE];
+		pBuf->wTimeStampOff_a =	vnt_time_stamp_off(pDevice,
+								wCurrentRate);
+		pBuf->wTimeStampOff_b = vnt_time_stamp_off(pDevice,
+						pDevice->byTopCCKBasicRate);
                 return (pBuf->wDuration_a);
              } else {
                 // Auto Fallback
@@ -540,8 +548,10 @@ static u32 s_uFillDataHead(struct vnt_private *pDevice,
 							byPktType, bNeedAck);
 		pBuf->wDuration_a_f1 = s_uGetDataDuration(pDevice,
 							byPktType, bNeedAck);
-                pBuf->wTimeStampOff_a = wTimeStampOff[pDevice->byPreambleType%2][wCurrentRate%MAX_RATE];
-                pBuf->wTimeStampOff_b = wTimeStampOff[pDevice->byPreambleType%2][pDevice->byTopCCKBasicRate%MAX_RATE];
+		pBuf->wTimeStampOff_a = vnt_time_stamp_off(pDevice,
+								wCurrentRate);
+		pBuf->wTimeStampOff_b = vnt_time_stamp_off(pDevice,
+						pDevice->byTopCCKBasicRate);
                 return (pBuf->wDuration_a);
             } //if (byFBOption == AUTO_FB_NONE)
     }
@@ -559,7 +569,8 @@ static u32 s_uFillDataHead(struct vnt_private *pDevice,
 					byPktType, bNeedAck);
 		pBuf->wDuration_f1 = s_uGetDataDuration(pDevice,
 							byPktType, bNeedAck);
-                pBuf->wTimeStampOff = wTimeStampOff[pDevice->byPreambleType%2][wCurrentRate%MAX_RATE];
+		pBuf->wTimeStampOff = vnt_time_stamp_off(pDevice,
+								wCurrentRate);
             return (pBuf->wDuration);
         } else {
 		struct vnt_tx_datahead_ab *pBuf =
@@ -570,8 +581,8 @@ static u32 s_uFillDataHead(struct vnt_private *pDevice,
             //Get Duration and TimeStampOff
 		pBuf->wDuration = s_uGetDataDuration(pDevice,
 				byPktType, bNeedAck);
-                pBuf->wTimeStampOff = wTimeStampOff[pDevice->byPreambleType%2][wCurrentRate%MAX_RATE];
-
+		pBuf->wTimeStampOff = vnt_time_stamp_off(pDevice,
+								wCurrentRate);
             return (pBuf->wDuration);
         }
     }
@@ -584,8 +595,8 @@ static u32 s_uFillDataHead(struct vnt_private *pDevice,
             //Get Duration and TimeStampOff
 		pBuf->wDuration = s_uGetDataDuration(pDevice,
 				byPktType, bNeedAck);
-                pBuf->wTimeStampOff = wTimeStampOff[pDevice->byPreambleType%2][wCurrentRate%MAX_RATE];
-
+		pBuf->wTimeStampOff = vnt_time_stamp_off(pDevice,
+								wCurrentRate);
             return (pBuf->wDuration);
     }
     return 0;
@@ -1830,7 +1841,7 @@ CMD_STATUS csBeacon_xmit(struct vnt_private *pDevice,
         //Get Duration and TimeStampOff
 	pTxDataHead->wDuration = s_uGetDataDuration(pDevice,
 						PK_TYPE_11A, false);
-        pTxDataHead->wTimeStampOff = wTimeStampOff[pDevice->byPreambleType%2][wCurrentRate%MAX_RATE];
+	pTxDataHead->wTimeStampOff = vnt_time_stamp_off(pDevice, wCurrentRate);
 	cbHeaderSize = wTxBufSize + sizeof(struct vnt_tx_datahead_ab);
     } else {
         wCurrentRate = RATE_1M;
@@ -1843,7 +1854,7 @@ CMD_STATUS csBeacon_xmit(struct vnt_private *pDevice,
         //Get Duration and TimeStampOff
 	pTxDataHead->wDuration = s_uGetDataDuration(pDevice,
 						PK_TYPE_11B, false);
-        pTxDataHead->wTimeStampOff = wTimeStampOff[pDevice->byPreambleType%2][wCurrentRate%MAX_RATE];
+	pTxDataHead->wTimeStampOff = vnt_time_stamp_off(pDevice, wCurrentRate);
 	cbHeaderSize = wTxBufSize + sizeof(struct vnt_tx_datahead_ab);
     }
 
-- 
1.8.1.2

