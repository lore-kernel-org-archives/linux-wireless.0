Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:42861 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978AbaAATVH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jan 2014 14:21:07 -0500
Received: by mail-wg0-f52.google.com with SMTP id x13so11968851wgg.7
        for <linux-wireless@vger.kernel.org>; Wed, 01 Jan 2014 11:21:05 -0800 (PST)
Message-ID: <1388604040.29916.6.camel@canaries32-MCP7A> (sfid-20140101_202110_398524_46661057)
Subject: [PATCH 2/2] staging: vt6656: CARDqGetNextTBTT replace code using
 do_div.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Wed, 01 Jan 2014 19:20:40 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

uBeaconInterval becomes u32

get next TBTT value using vendor's equation as shown.

This patch was checked against the original code
and yields exactly the same value.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/card.c | 30 +++++++++++-------------------
 1 file changed, 11 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index ce7ee45..0d87728 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -720,28 +720,20 @@ bool CARDbClearCurrentTSF(struct vnt_private *pDevice)
  */
 u64 CARDqGetNextTBTT(u64 qwTSF, u16 wBeaconInterval)
 {
+	u32 uBeaconInterval;
 
-    unsigned int    uLowNextTBTT;
-    unsigned int    uHighRemain, uLowRemain;
-    unsigned int    uBeaconInterval;
+	uBeaconInterval = wBeaconInterval * 1024;
 
-    uBeaconInterval = wBeaconInterval * 1024;
-    // Next TBTT = ((local_current_TSF / beacon_interval) + 1 ) * beacon_interval
-	uLowNextTBTT = ((qwTSF & 0xffffffffULL) >> 10) << 10;
-	uLowRemain = (uLowNextTBTT) % uBeaconInterval;
-	uHighRemain = ((0x80000000 % uBeaconInterval) * 2 * (u32)(qwTSF >> 32))
-		% uBeaconInterval;
-	uLowRemain = (uHighRemain + uLowRemain) % uBeaconInterval;
-	uLowRemain = uBeaconInterval - uLowRemain;
-
-    // check if carry when add one beacon interval
-	if ((~uLowNextTBTT) < uLowRemain)
-		qwTSF = ((qwTSF >> 32) + 1) << 32;
-
-	qwTSF = (qwTSF & 0xffffffff00000000ULL) |
-		(u64)(uLowNextTBTT + uLowRemain);
+	/* Next TBTT =
+	*	((local_current_TSF / beacon_interval) + 1) * beacon_interval
+	*/
+	if (uBeaconInterval) {
+		do_div(qwTSF, uBeaconInterval);
+		qwTSF += 1;
+		qwTSF *= uBeaconInterval;
+	}
 
-    return (qwTSF);
+	return qwTSF;
 }
 
 /*
-- 
1.8.5.2



