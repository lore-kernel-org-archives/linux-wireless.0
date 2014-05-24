Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:45973 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154AbaEXNiJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 May 2014 09:38:09 -0400
Received: by mail-wg0-f49.google.com with SMTP id m15so5901620wgh.8
        for <linux-wireless@vger.kernel.org>; Sat, 24 May 2014 06:38:07 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 05/14] staging: vt6656: camel case and clean up CARDvAdjustTSF
Date: Sat, 24 May 2014 14:37:01 +0100
Message-Id: <1400938630-2850-5-git-send-email-tvboxspy@gmail.com> (sfid-20140524_153816_237894_E74EC5F5)
In-Reply-To: <1400938630-2850-1-git-send-email-tvboxspy@gmail.com>
References: <1400938630-2850-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

camel case changes
pDevice -> priv
byRxRate -> rx_rate
qwBSSTimestamp -> time_stamp
qwLocalTSF -> local_tsf
qwTSFOffset -> tsf_offset
pbyData -> data

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/card.c | 44 ++++++++++++++++++-------------------------
 1 file changed, 18 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index 8d12ae9..4b0b3ef 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -580,42 +580,34 @@ u64 CARDqGetTSFOffset(u8 rx_rate, u64 tsf1, u64 tsf2)
  *
  * Parameters:
  *  In:
- *      pDevice         - The adapter to be sync.
- *      qwBSSTimestamp  - Rx BCN's TSF
- *      qwLocalTSF      - Local TSF
+ *      priv		- The adapter to be sync.
+ *      time_stamp	- Rx BCN's TSF
+ *      local_tsf	- Local TSF
  *  Out:
  *      none
  *
  * Return Value: none
  *
  */
-void CARDvAdjustTSF(struct vnt_private *pDevice, u8 byRxRate,
-		u64 qwBSSTimestamp, u64 qwLocalTSF)
+void CARDvAdjustTSF(struct vnt_private *priv, u8 rx_rate,
+		u64 time_stamp, u64 local_tsf)
 {
-	u64 qwTSFOffset = 0;
-	u8 pbyData[8];
-
-    qwTSFOffset = CARDqGetTSFOffset(byRxRate, qwBSSTimestamp, qwLocalTSF);
-    // adjust TSF
-    // HW's TSF add TSF Offset reg
+	u64 tsf_offset = 0;
+	u8 data[8];
 
-	pbyData[0] = (u8)qwTSFOffset;
-	pbyData[1] = (u8)(qwTSFOffset >> 8);
-	pbyData[2] = (u8)(qwTSFOffset >> 16);
-	pbyData[3] = (u8)(qwTSFOffset >> 24);
-	pbyData[4] = (u8)(qwTSFOffset >> 32);
-	pbyData[5] = (u8)(qwTSFOffset >> 40);
-	pbyData[6] = (u8)(qwTSFOffset >> 48);
-	pbyData[7] = (u8)(qwTSFOffset >> 56);
+	tsf_offset = CARDqGetTSFOffset(rx_rate, time_stamp, local_tsf);
 
-    CONTROLnsRequestOut(pDevice,
-                        MESSAGE_TYPE_SET_TSFTBTT,
-                        MESSAGE_REQUEST_TSF,
-                        0,
-                        8,
-                        pbyData
-                        );
+	data[0] = (u8)tsf_offset;
+	data[1] = (u8)(tsf_offset >> 8);
+	data[2] = (u8)(tsf_offset >> 16);
+	data[3] = (u8)(tsf_offset >> 24);
+	data[4] = (u8)(tsf_offset >> 32);
+	data[5] = (u8)(tsf_offset >> 40);
+	data[6] = (u8)(tsf_offset >> 48);
+	data[7] = (u8)(tsf_offset >> 56);
 
+	CONTROLnsRequestOut(priv, MESSAGE_TYPE_SET_TSFTBTT,
+		MESSAGE_REQUEST_TSF, 0, 8, data);
 }
 /*
  * Description: Read NIC TSF counter
-- 
1.9.1

