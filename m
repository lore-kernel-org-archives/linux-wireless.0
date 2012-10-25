Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:3642 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803Ab2JYLx0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2012 07:53:26 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 3/4] ath9k_hw: validate MCI stuck after RTC wakeup
Date: Thu, 25 Oct 2012 17:16:53 +0530
Message-ID: <1351165614-12691-3-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20121025_135328_917316_2B2F0079)
In-Reply-To: <1351165614-12691-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1351165614-12691-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 8e1559a..71cd9f0 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2153,9 +2153,6 @@ static bool ath9k_hw_set_power_awake(struct ath_hw *ah)
 		    AR_RTC_FORCE_WAKE_EN);
 	udelay(50);
 
-	if (ath9k_hw_mci_is_enabled(ah))
-		ar9003_mci_set_power_awake(ah);
-
 	for (i = POWER_UP_TIME / 50; i > 0; i--) {
 		val = REG_READ(ah, AR_RTC_STATUS) & AR_RTC_STATUS_M;
 		if (val == AR_RTC_STATUS_ON)
@@ -2171,6 +2168,9 @@ static bool ath9k_hw_set_power_awake(struct ath_hw *ah)
 		return false;
 	}
 
+	if (ath9k_hw_mci_is_enabled(ah))
+		ar9003_mci_set_power_awake(ah);
+
 	REG_CLR_BIT(ah, AR_STA_ID1, AR_STA_ID1_PWR_SAV);
 
 	return true;
-- 
1.8.0

