Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:44851 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755839AbZIRJeV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2009 05:34:21 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2009 02:34:25 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19123.21539.327196.550393@gargle.gargle.HOWL>
Date: Fri, 18 Sep 2009 15:04:27 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH/REVIEW 3/9] ath9k: Fix RTC reset for AR5416
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For AR5416 chipsets, clearing RTC_RESET_EN when setting
the chip to SLEEP mode results in high power consumption.
This patch fixes this issue by not clearing it for AR5416.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 6ed0289..96ea5cc 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2851,8 +2851,9 @@ static void ath9k_set_power_sleep(struct ath_hw *ah, int setChip)
 		if (!AR_SREV_9100(ah))
 			REG_WRITE(ah, AR_RC, AR_RC_AHB | AR_RC_HOSTIF);
 
-		REG_CLR_BIT(ah, (AR_RTC_RESET),
-			    AR_RTC_RESET_EN);
+		if(!AR_SREV_5416(ah))
+			REG_CLR_BIT(ah, (AR_RTC_RESET),
+				    AR_RTC_RESET_EN);
 	}
 }
 
-- 
1.6.4.4

