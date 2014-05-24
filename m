Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:47786 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbaEXNiR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 May 2014 09:38:17 -0400
Received: by mail-wg0-f48.google.com with SMTP id k14so1729274wgh.31
        for <linux-wireless@vger.kernel.org>; Sat, 24 May 2014 06:38:16 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 10/14] staging: vt6656: camel case clean up CARDvUpdateNextTBTT
Date: Sat, 24 May 2014 14:37:06 +0100
Message-Id: <1400938630-2850-10-git-send-email-tvboxspy@gmail.com> (sfid-20140524_153829_015486_347D8BE9)
In-Reply-To: <1400938630-2850-1-git-send-email-tvboxspy@gmail.com>
References: <1400938630-2850-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

camel case changes
pDevice -> priv
qwTSF -> tsf
wBeaconInterval -> beacon_interval
pbyData -> data

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/card.c | 45 ++++++++++++++++++-------------------------
 1 file changed, 19 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index b73b1b8..09b6de5 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -727,45 +727,38 @@ void CARDvSetFirstNextTBTT(struct vnt_private *priv, u16 beacon_interval)
  *
  * Parameters:
  *  In:
- *      pDevice         - The adapter to be set
- *      qwTSF           - Current TSF counter
- *      wBeaconInterval - Beacon Interval
+ *	priv		- The adapter to be set
+ *      tsf		- Current TSF counter
+ *      beacon_interval - Beacon Interval
  *  Out:
  *      none
  *
  * Return Value: none
  *
  */
-void CARDvUpdateNextTBTT(struct vnt_private *pDevice, u64 qwTSF,
-			u16 wBeaconInterval)
+void CARDvUpdateNextTBTT(struct vnt_private *priv, u64 tsf,
+			u16 beacon_interval)
 {
-	u8 pbyData[8];
-
-    qwTSF = CARDqGetNextTBTT(qwTSF, wBeaconInterval);
+	u8 data[8];
 
-    // Set NextTBTT
+	tsf = CARDqGetNextTBTT(tsf, beacon_interval);
 
-	pbyData[0] = (u8)qwTSF;
-	pbyData[1] = (u8)(qwTSF >> 8);
-	pbyData[2] = (u8)(qwTSF >> 16);
-	pbyData[3] = (u8)(qwTSF >> 24);
-	pbyData[4] = (u8)(qwTSF >> 32);
-	pbyData[5] = (u8)(qwTSF >> 40);
-	pbyData[6] = (u8)(qwTSF >> 48);
-	pbyData[7] = (u8)(qwTSF >> 56);
+	data[0] = (u8)tsf;
+	data[1] = (u8)(tsf >> 8);
+	data[2] = (u8)(tsf >> 16);
+	data[3] = (u8)(tsf >> 24);
+	data[4] = (u8)(tsf >> 32);
+	data[5] = (u8)(tsf >> 40);
+	data[6] = (u8)(tsf >> 48);
+	data[7] = (u8)(tsf >> 56);
 
-    CONTROLnsRequestOut(pDevice,
-                        MESSAGE_TYPE_SET_TSFTBTT,
-                        MESSAGE_REQUEST_TBTT,
-                        0,
-                        8,
-                        pbyData
-                        );
+	CONTROLnsRequestOut(priv, MESSAGE_TYPE_SET_TSFTBTT,
+		MESSAGE_REQUEST_TBTT, 0, 8, data);
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
-		"Card:Update Next TBTT[%8lx]\n", (unsigned long)qwTSF);
+		"Card:Update Next TBTT[%8lx]\n", (unsigned long)tsf);
 
-    return;
+	return;
 }
 
 /*
-- 
1.9.1

