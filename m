Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:37303 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbaEXNiQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 May 2014 09:38:16 -0400
Received: by mail-we0-f175.google.com with SMTP id t61so6075688wes.34
        for <linux-wireless@vger.kernel.org>; Sat, 24 May 2014 06:38:14 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 09/14] staging: vt6656: camel case and clean up CARDvSetFirstNextTBTT
Date: Sat, 24 May 2014 14:37:05 +0100
Message-Id: <1400938630-2850-9-git-send-email-tvboxspy@gmail.com> (sfid-20140524_153838_667007_E79C37B8)
In-Reply-To: <1400938630-2850-1-git-send-email-tvboxspy@gmail.com>
References: <1400938630-2850-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

camel case changes
pDevice -> priv
wBeaconInterval -> beacon_interval
qwNextTBTT -> next_tbtt
pbyData -> data

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/card.c | 42 ++++++++++++++++++------------------------
 1 file changed, 18 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index 3ed218a..b73b1b8 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -690,41 +690,35 @@ u64 CARDqGetNextTBTT(u64 tsf, u16 beacon_interval)
  * Parameters:
  *  In:
  *      dwIoBase        - IO Base
- *      wBeaconInterval - Beacon Interval
+ *	beacon_interval - Beacon Interval
  *  Out:
  *      none
  *
  * Return Value: none
  *
  */
-void CARDvSetFirstNextTBTT(struct vnt_private *pDevice, u16 wBeaconInterval)
+void CARDvSetFirstNextTBTT(struct vnt_private *priv, u16 beacon_interval)
 {
-	u64 qwNextTBTT = 0;
-	u8 pbyData[8];
+	u64 next_tbtt = 0;
+	u8 data[8];
 
-	CARDbClearCurrentTSF(pDevice);
-    //CARDbGetCurrentTSF(pDevice, &qwNextTBTT); //Get Local TSF counter
-	qwNextTBTT = CARDqGetNextTBTT(qwNextTBTT, wBeaconInterval);
-    // Set NextTBTT
+	CARDbClearCurrentTSF(priv);
 
-	pbyData[0] = (u8)qwNextTBTT;
-	pbyData[1] = (u8)(qwNextTBTT >> 8);
-	pbyData[2] = (u8)(qwNextTBTT >> 16);
-	pbyData[3] = (u8)(qwNextTBTT >> 24);
-	pbyData[4] = (u8)(qwNextTBTT >> 32);
-	pbyData[5] = (u8)(qwNextTBTT >> 40);
-	pbyData[6] = (u8)(qwNextTBTT >> 48);
-	pbyData[7] = (u8)(qwNextTBTT >> 56);
+	next_tbtt = CARDqGetNextTBTT(next_tbtt, beacon_interval);
 
-    CONTROLnsRequestOut(pDevice,
-                        MESSAGE_TYPE_SET_TSFTBTT,
-                        MESSAGE_REQUEST_TBTT,
-                        0,
-                        8,
-                        pbyData
-                        );
+	data[0] = (u8)next_tbtt;
+	data[1] = (u8)(next_tbtt >> 8);
+	data[2] = (u8)(next_tbtt >> 16);
+	data[3] = (u8)(next_tbtt >> 24);
+	data[4] = (u8)(next_tbtt >> 32);
+	data[5] = (u8)(next_tbtt >> 40);
+	data[6] = (u8)(next_tbtt >> 48);
+	data[7] = (u8)(next_tbtt >> 56);
 
-    return;
+	CONTROLnsRequestOut(priv, MESSAGE_TYPE_SET_TSFTBTT,
+		MESSAGE_REQUEST_TBTT, 0, 8, data);
+
+	return;
 }
 
 /*
-- 
1.9.1

