Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:42416 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154AbaEXNiO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 May 2014 09:38:14 -0400
Received: by mail-wi0-f178.google.com with SMTP id cc10so2170206wib.5
        for <linux-wireless@vger.kernel.org>; Sat, 24 May 2014 06:38:13 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 08/14] staging: vt6656: CARDqGetNextTBTT remove camel case
Date: Sat, 24 May 2014 14:37:04 +0100
Message-Id: <1400938630-2850-8-git-send-email-tvboxspy@gmail.com> (sfid-20140524_153821_442453_DA9179DE)
In-Reply-To: <1400938630-2850-1-git-send-email-tvboxspy@gmail.com>
References: <1400938630-2850-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

qwTSF -> tsf
wBeaconInterval -> beacon_interval
uBeaconInterval -> beacon_int

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/card.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index bb06f59..3ed218a 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -657,30 +657,30 @@ bool CARDbClearCurrentTSF(struct vnt_private *priv)
  *
  * Parameters:
  *  In:
- *      qwTSF           - Current TSF counter
- *      wbeaconInterval - Beacon Interval
+ *      tsf		- Current TSF counter
+ *      beacon_interval - Beacon Interval
  *  Out:
- *      qwCurrTSF       - Current TSF counter
+ *      tsf		- Current TSF counter
  *
  * Return Value: TSF value of next Beacon
  *
  */
-u64 CARDqGetNextTBTT(u64 qwTSF, u16 wBeaconInterval)
+u64 CARDqGetNextTBTT(u64 tsf, u16 beacon_interval)
 {
-	u32 uBeaconInterval;
+	u32 beacon_int;
 
-	uBeaconInterval = wBeaconInterval * 1024;
+	beacon_int = beacon_interval * 1024;
 
 	/* Next TBTT =
 	*	((local_current_TSF / beacon_interval) + 1) * beacon_interval
 	*/
-	if (uBeaconInterval) {
-		do_div(qwTSF, uBeaconInterval);
-		qwTSF += 1;
-		qwTSF *= uBeaconInterval;
+	if (beacon_int) {
+		do_div(tsf, beacon_int);
+		tsf += 1;
+		tsf *= beacon_int;
 	}
 
-	return qwTSF;
+	return tsf;
 }
 
 /*
-- 
1.9.1

