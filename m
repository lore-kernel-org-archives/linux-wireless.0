Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:51042 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283AbaESTe0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2014 15:34:26 -0400
Received: by mail-we0-f179.google.com with SMTP id q59so5956592wes.38
        for <linux-wireless@vger.kernel.org>; Mon, 19 May 2014 12:34:24 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 09/20] staging: vt6656: checkpatch cleanup BBvCalculateParameter.
Date: Mon, 19 May 2014 20:33:01 +0100
Message-Id: <1400527992-3061-9-git-send-email-tvboxspy@gmail.com> (sfid-20140519_213431_175166_81B5DBCA)
In-Reply-To: <1400527992-3061-1-git-send-email-tvboxspy@gmail.com>
References: <1400527992-3061-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

White space clean up.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/baseband.c | 218 ++++++++++++++++++--------------------
 1 file changed, 103 insertions(+), 115 deletions(-)

diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index 36977f0..9f435c5 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -731,129 +731,117 @@ void BBvCalculateParameter(struct vnt_private *pDevice, u32 cbFrameLength,
 	int bExtBit;
 	u8 byPreambleType = pDevice->byPreambleType;
 
-    cbBitCount = cbFrameLength * 8;
-    bExtBit = false;
-
-    switch (wRate) {
-    case RATE_1M :
-        cbUsCount = cbBitCount;
-	phy->signal = 0x00;
-        break;
-
-    case RATE_2M :
-        cbUsCount = cbBitCount / 2;
-        if (byPreambleType == 1)
-		phy->signal = 0x09;
-        else // long preamble
-		phy->signal = 0x01;
-        break;
-
-    case RATE_5M :
-        cbUsCount = (cbBitCount * 10) / 55;
-        cbTmp = (cbUsCount * 55) / 10;
-        if (cbTmp != cbBitCount)
-            cbUsCount ++;
-        if (byPreambleType == 1)
-		phy->signal = 0x0a;
-        else // long preamble
-		phy->signal = 0x02;
-        break;
-
-    case RATE_11M :
-        cbUsCount = cbBitCount / 11;
-        cbTmp = cbUsCount * 11;
-        if (cbTmp != cbBitCount) {
-            cbUsCount ++;
-            if ((cbBitCount - cbTmp) <= 3)
-                bExtBit = true;
-        }
-        if (byPreambleType == 1)
-		phy->signal = 0x0b;
-        else // long preamble
-		phy->signal = 0x03;
-        break;
-
-    case RATE_6M :
-        if(byPacketType == PK_TYPE_11A) {//11a, 5GHZ
-		phy->signal = 0x9b;
-        }
-        else {//11g, 2.4GHZ
-		phy->signal = 0x8b;
-        }
-        break;
+	cbBitCount = cbFrameLength * 8;
+	bExtBit = false;
 
-    case RATE_9M :
-        if(byPacketType == PK_TYPE_11A) {//11a, 5GHZ
-		phy->signal = 0x9f;
-        }
-        else {//11g, 2.4GHZ
-		phy->signal = 0x8f;
-        }
-        break;
+	switch (wRate) {
+	case RATE_1M:
+		cbUsCount = cbBitCount;
 
-    case RATE_12M :
-        if(byPacketType == PK_TYPE_11A) {//11a, 5GHZ
-		phy->signal = 0x9a;
-        }
-        else {//11g, 2.4GHZ
-		phy->signal = 0x8a;
-        }
-        break;
+		phy->signal = 0x00;
 
-    case RATE_18M :
-        if(byPacketType == PK_TYPE_11A) {//11a, 5GHZ
-		phy->signal = 0x9e;
-        }
-        else {//11g, 2.4GHZ
-		phy->signal = 0x8e;
-        }
-        break;
+		break;
+	case RATE_2M:
+		cbUsCount = cbBitCount / 2;
 
-    case RATE_24M :
-        if(byPacketType == PK_TYPE_11A) {//11a, 5GHZ
-		phy->signal = 0x99;
-        }
-        else {//11g, 2.4GHZ
-		phy->signal = 0x89;
-        }
-        break;
+		if (byPreambleType == 1)
+			phy->signal = 0x09;
+		else
+			phy->signal = 0x01;
 
-    case RATE_36M :
-        if(byPacketType == PK_TYPE_11A) {//11a, 5GHZ
-		phy->signal = 0x9d;
-        }
-        else {//11g, 2.4GHZ
-		phy->signal = 0x8d;
-        }
-        break;
+		break;
+	case RATE_5M:
+		cbUsCount = (cbBitCount * 10) / 55;
+		cbTmp = (cbUsCount * 55) / 10;
 
-    case RATE_48M :
-        if(byPacketType == PK_TYPE_11A) {//11a, 5GHZ
-		phy->signal = 0x98;
-        }
-        else {//11g, 2.4GHZ
-		phy->signal = 0x88;
-        }
-        break;
+		if (cbTmp != cbBitCount)
+			cbUsCount++;
 
-    case RATE_54M :
-        if (byPacketType == PK_TYPE_11A) {//11a, 5GHZ
-		phy->signal = 0x9c;
-        }
-        else {//11g, 2.4GHZ
-		phy->signal = 0x8c;
-        }
-        break;
+		if (byPreambleType == 1)
+			phy->signal = 0x0a;
+		else
+			phy->signal = 0x02;
 
-    default :
-        if (byPacketType == PK_TYPE_11A) {//11a, 5GHZ
-		phy->signal = 0x9c;
-        }
-        else {//11g, 2.4GHZ
-		phy->signal = 0x8c;
-        }
-        break;
-    }
+		break;
+	case RATE_11M:
+		cbUsCount = cbBitCount / 11;
+		cbTmp = cbUsCount * 11;
+
+		if (cbTmp != cbBitCount) {
+			cbUsCount++;
+
+			if ((cbBitCount - cbTmp) <= 3)
+				bExtBit = true;
+		}
+
+		if (byPreambleType == 1)
+			phy->signal = 0x0b;
+		else
+			phy->signal = 0x03;
+
+		break;
+	case RATE_6M:
+		if (byPacketType == PK_TYPE_11A)
+			phy->signal = 0x9b;
+		else
+			phy->signal = 0x8b;
+
+		break;
+	case RATE_9M:
+		if (byPacketType == PK_TYPE_11A)
+			phy->signal = 0x9f;
+		else
+			phy->signal = 0x8f;
+
+		break;
+	case RATE_12M:
+		if (byPacketType == PK_TYPE_11A)
+			phy->signal = 0x9a;
+		else
+			phy->signal = 0x8a;
+
+		break;
+	case RATE_18M:
+		if (byPacketType == PK_TYPE_11A)
+			phy->signal = 0x9e;
+		else
+			phy->signal = 0x8e;
+
+		break;
+	case RATE_24M:
+		if (byPacketType == PK_TYPE_11A)
+			phy->signal = 0x99;
+		else
+			phy->signal = 0x89;
+
+		break;
+	case RATE_36M:
+		if (byPacketType == PK_TYPE_11A)
+			phy->signal = 0x9d;
+		else
+			phy->signal = 0x8d;
+
+		break;
+	case RATE_48M:
+		if (byPacketType == PK_TYPE_11A)
+			phy->signal = 0x98;
+		else
+			phy->signal = 0x88;
+
+		break;
+	case RATE_54M:
+		if (byPacketType == PK_TYPE_11A)
+			phy->signal = 0x9c;
+		else
+			phy->signal = 0x8c;
+		break;
+	default:
+		if (byPacketType == PK_TYPE_11A)
+			phy->signal = 0x9c;
+		else
+			phy->signal = 0x8c;
+		break;
+	}
 
 	if (byPacketType == PK_TYPE_11B) {
 		phy->service = 0x00;
-- 
1.9.1

