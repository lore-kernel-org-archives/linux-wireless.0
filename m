Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:56126 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751698Ab1ASPsa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jan 2011 10:48:30 -0500
Received: from mail.atheros.com ([10.10.20.107])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 19 Jan 2011 07:48:12 -0800
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linux-wireless@vger.kernel.org>
CC: Rajkumar Manoharan <rmanoharan@atheros.com>,
	Jack Lee <jlee@atheros.com>
Subject: [PATCH 1/2] ath9k_hw: Fix system hang when resuming from S3/S4
Date: Wed, 19 Jan 2011 21:17:42 +0530
Message-ID: <1295452063-13828-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The bit 6 & 7 of AR_WA (0x4004) should be enabled only
for the chips that are supporting L0s functionality
while resuming back from S3/S4.

Enabling these bits for AR9280 is causing system hang
within a few S3/S4-resume cycles.

Cc: Jack Lee <jlee@atheros.com>
Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9002_hw.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_hw.c b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
index f8a7771..f44c84a 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
@@ -426,9 +426,8 @@ static void ar9002_hw_configpcipowersave(struct ath_hw *ah,
 		}
 
 		/* WAR for ASPM system hang */
-		if (AR_SREV_9280(ah) || AR_SREV_9285(ah) || AR_SREV_9287(ah)) {
+		if (AR_SREV_9285(ah) || AR_SREV_9287(ah))
 			val |= (AR_WA_BIT6 | AR_WA_BIT7);
-		}
 
 		if (AR_SREV_9285E_20(ah))
 			val |= AR_WA_BIT23;
-- 
1.7.3.5

