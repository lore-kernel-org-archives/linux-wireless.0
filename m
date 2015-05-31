Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:38457 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754435AbbEaJf5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 May 2015 05:35:57 -0400
Received: by wizo1 with SMTP id o1so70810010wiz.1
        for <linux-wireless@vger.kernel.org>; Sun, 31 May 2015 02:35:56 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 2/9] staging: vt6655: dead code remove STAvUpdate802_11Counter
Date: Sun, 31 May 2015 10:35:21 +0100
Message-Id: <1433064928-2139-2-git-send-email-tvboxspy@gmail.com> (sfid-20150531_113607_677370_F64237A9)
In-Reply-To: <1433064928-2139-1-git-send-email-tvboxspy@gmail.com>
References: <1433064928-2139-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This function is nolonger of any future use.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/mib.c | 27 ---------------------------
 drivers/staging/vt6655/mib.h |  6 ------
 2 files changed, 33 deletions(-)

diff --git a/drivers/staging/vt6655/mib.c b/drivers/staging/vt6655/mib.c
index d55c762..e9d23a7 100644
--- a/drivers/staging/vt6655/mib.c
+++ b/drivers/staging/vt6655/mib.c
@@ -110,30 +110,3 @@ void STAvUpdateIsrStatCounter(PSStatCounter pStatistic, unsigned long dwIsr)
 	if (dwIsr & ISR_SOFTTIMER1)           /* ISR, bit21 */
 		pStatistic->ISRStat.dwIsrSTIMER1Int++;
 }
-
-/*
- * Description: Update 802.11 mib counter
- *
- * Parameters:
- *  In:
- *      p802_11Counter  - Pointer to 802.11 mib counter
- *      pStatistic      - Pointer to Statistic Counter Data Structure
- *      dwCounter       - hardware counter for 802.11 mib
- *  Out:
- *      none
- *
- * Return Value: none
- *
- */
-void
-STAvUpdate802_11Counter(
-	PSDot11Counters         p802_11Counter,
-	PSStatCounter           pStatistic,
-	unsigned long dwCounter
-)
-{
-	p802_11Counter->RTSSuccessCount += (unsigned long long)  (dwCounter & 0x000000ff);
-	p802_11Counter->RTSFailureCount += (unsigned long long) ((dwCounter & 0x0000ff00) >> 8);
-	p802_11Counter->ACKFailureCount += (unsigned long long) ((dwCounter & 0x00ff0000) >> 16);
-	p802_11Counter->FCSErrorCount +=   (unsigned long long) ((dwCounter & 0xff000000) >> 24);
-}
diff --git a/drivers/staging/vt6655/mib.h b/drivers/staging/vt6655/mib.h
index 5cb59b8..64ca360 100644
--- a/drivers/staging/vt6655/mib.h
+++ b/drivers/staging/vt6655/mib.h
@@ -73,10 +73,4 @@ typedef struct tagSStatCounter {
 
 void STAvUpdateIsrStatCounter(PSStatCounter pStatistic, unsigned long dwIsr);
 
-void STAvUpdate802_11Counter(
-	PSDot11Counters p802_11Counter,
-	PSStatCounter   pStatistic,
-	unsigned long dwCounter
-);
-
 #endif // __MIB_H__
-- 
2.1.4

