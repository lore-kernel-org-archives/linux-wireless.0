Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:58343 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932569AbaESTeU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2014 15:34:20 -0400
Received: by mail-wi0-f176.google.com with SMTP id n15so4733476wiw.9
        for <linux-wireless@vger.kernel.org>; Mon, 19 May 2014 12:34:19 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 06/20] staging: vt6656: checkpatch cleanup BBuGetFrameTime.
Date: Mon, 19 May 2014 20:32:58 +0100
Message-Id: <1400527992-3061-6-git-send-email-tvboxspy@gmail.com> (sfid-20140519_213437_183015_0398E942)
In-Reply-To: <1400527992-3061-1-git-send-email-tvboxspy@gmail.com>
References: <1400527992-3061-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

clean up white space.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/baseband.c | 78 ++++++++++++++++++---------------------
 1 file changed, 36 insertions(+), 42 deletions(-)

diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index a70b278..dbe06f9 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -663,53 +663,47 @@ s_vClearSQ3Value(PSDevice pDevice);
  * Return Value: FrameTime
  *
  */
-unsigned int
-BBuGetFrameTime(
-     u8 byPreambleType,
-     u8 byPktType,
-     unsigned int cbFrameLength,
-     u16 wRate
-    )
+unsigned int BBuGetFrameTime(u8 byPreambleType,  u8 byPktType,
+	unsigned int cbFrameLength, u16 wRate)
 {
-    unsigned int uFrameTime;
-    unsigned int uPreamble;
-    unsigned int uTmp;
-    unsigned int uRateIdx = (unsigned int)wRate;
-    unsigned int uRate = 0;
-
-    if (uRateIdx > RATE_54M) {
-        return 0;
-    }
+	unsigned int uFrameTime;
+	unsigned int uPreamble;
+	unsigned int uTmp;
+	unsigned int uRateIdx = (unsigned int)wRate;
+	unsigned int uRate = 0;
 
-    uRate = (unsigned int)awcFrameTime[uRateIdx];
+	if (uRateIdx > RATE_54M)
+		return 0;
 
-    if (uRateIdx <= 3) {          //CCK mode
+	uRate = (unsigned int)awcFrameTime[uRateIdx];
 
-        if (byPreambleType == 1) {//Short
-            uPreamble = 96;
-        } else {
-            uPreamble = 192;
-        }
-        uFrameTime = (cbFrameLength * 80) / uRate;  //?????
-        uTmp = (uFrameTime * uRate) / 80;
-        if (cbFrameLength != uTmp) {
-            uFrameTime ++;
-        }
+	if (uRateIdx <= 3) {
+		if (byPreambleType == 1)
+			uPreamble = 96;
+		else
+			uPreamble = 192;
 
-        return (uPreamble + uFrameTime);
-    }
-    else {
-        uFrameTime = (cbFrameLength * 8 + 22) / uRate;   //????????
-        uTmp = ((uFrameTime * uRate) - 22) / 8;
-        if(cbFrameLength != uTmp) {
-            uFrameTime ++;
-        }
-        uFrameTime = uFrameTime * 4;    //???????
-        if(byPktType != PK_TYPE_11A) {
-            uFrameTime += 6;
-        }
-        return (20 + uFrameTime); //??????
-    }
+		uFrameTime = (cbFrameLength * 80) / uRate;
+		uTmp = (uFrameTime * uRate) / 80;
+
+		if (cbFrameLength != uTmp)
+			uFrameTime++;
+
+		return uPreamble + uFrameTime;
+	} else {
+		uFrameTime = (cbFrameLength * 8 + 22) / uRate;
+		uTmp = ((uFrameTime * uRate) - 22) / 8;
+
+		if (cbFrameLength != uTmp)
+			uFrameTime++;
+
+		uFrameTime = uFrameTime * 4;
+
+		if (byPktType != PK_TYPE_11A)
+			uFrameTime += 6;
+
+		return 20 + uFrameTime;
+	}
 }
 
 /*
-- 
1.9.1

