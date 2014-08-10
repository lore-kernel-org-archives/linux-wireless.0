Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:48720 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbaHJLWv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Aug 2014 07:22:51 -0400
Received: by mail-wi0-f174.google.com with SMTP id d1so2969229wiv.7
        for <linux-wireless@vger.kernel.org>; Sun, 10 Aug 2014 04:22:48 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 4/7] staging: vt6655: CARDqGetNextTBTT calculate qwTSF using do_div
Date: Sun, 10 Aug 2014 12:21:59 +0100
Message-Id: <1407669722-2682-4-git-send-email-tvboxspy@gmail.com> (sfid-20140810_132256_761280_0E56F93D)
In-Reply-To: <1407669722-2682-1-git-send-email-tvboxspy@gmail.com>
References: <1407669722-2682-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use do_div to compute equation as shown replacing existing code.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/card.c | 29 ++++++++++-------------------
 1 file changed, 10 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/vt6655/card.c b/drivers/staging/vt6655/card.c
index 5295463..a5da3d2 100644
--- a/drivers/staging/vt6655/card.c
+++ b/drivers/staging/vt6655/card.c
@@ -1995,27 +1995,18 @@ bool CARDbGetCurrentTSF(void __iomem *dwIoBase, u64 *pqwCurrTSF)
  */
 u64 CARDqGetNextTBTT(u64 qwTSF, unsigned short wBeaconInterval)
 {
-	unsigned int uLowNextTBTT;
-	unsigned int uHighRemain, uLowRemain;
-	unsigned int uBeaconInterval;
+	u32 beacon_int;
 
-	uBeaconInterval = wBeaconInterval * 1024;
-	// Next TBTT = ((local_current_TSF / beacon_interval) + 1) * beacon_interval
-	uLowNextTBTT = ((qwTSF & 0xffffffffULL) >> 10) << 10;
-	// low dword (mod) bcn
-	uLowRemain = (uLowNextTBTT) % uBeaconInterval;
-	// high dword (mod) bcn
-	uHighRemain = (((0xffffffff % uBeaconInterval) + 1) * (u32)(qwTSF >> 32))
-		% uBeaconInterval;
-	uLowRemain = (uHighRemain + uLowRemain) % uBeaconInterval;
-	uLowRemain = uBeaconInterval - uLowRemain;
+	beacon_int = wBeaconInterval * 1024;
 
-	// check if carry when add one beacon interval
-	if ((~uLowNextTBTT) < uLowRemain)
-		qwTSF = ((qwTSF >> 32) + 1) << 32;
-
-	qwTSF = (qwTSF & 0xffffffff00000000ULL) |
-		(u64)(uLowNextTBTT + uLowRemain);
+	/* Next TBTT =
+	*	((local_current_TSF / beacon_interval) + 1) * beacon_interval
+	*/
+	if (beacon_int) {
+		do_div(qwTSF, beacon_int);
+		qwTSF += 1;
+		qwTSF *= beacon_int;
+	}
 
 	return qwTSF;
 }
-- 
1.9.1

