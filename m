Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:15300 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753224Ab1A0NK3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jan 2011 08:10:29 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 27 Jan 2011 05:10:09 -0800
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>,
	<stable@kernel.org>, Jack Lee <jlee@atheros.com>
Subject: [PATCH v2 1/2] ath9k_hw: Fix system hang when resuming from S3/S4
Date: Thu, 27 Jan 2011 18:39:37 +0530
Message-ID: <1296133778-3150-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The bit 6 & 7 of AR_WA (0x4004) should be enabled only
for the chips that are supporting L0s functionality
while resuming back from S3/S4.

Enabling these bits for AR9280 is causing system hang
within a few S3/S4-resume cycles.

Cc: stable@kernel.org
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

