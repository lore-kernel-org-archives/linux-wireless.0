Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:52263 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730Ab2ENByK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 May 2012 21:54:10 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20400.26004.289549.13390@gargle.gargle.HOWL> (sfid-20120514_035413_605002_6E98E3AC)
Date: Mon, 14 May 2012 07:23:24 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 4/7] ath9k_hw: Fix AR_RTC_KEEP_AWAKE usage
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The default value that is being programmed to AR_RTC_KEEP_AWAKE
is 0x2, there is no need to program it manually in various
functions.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_mci.c |    1 -
 drivers/net/wireless/ath/ath9k/hw.c         |   11 -----------
 2 files changed, 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.c b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
index ffbb180..9331d73 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
@@ -330,7 +330,6 @@ void ar9003_mci_set_full_sleep(struct ath_hw *ah)
 	}
 
 	mci->ready = false;
-	REG_WRITE(ah, AR_RTC_KEEP_AWAKE, 0x2);
 }
 
 static void ar9003_mci_disable_interrupt(struct ath_hw *ah)
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 02ce524..8698589 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1432,9 +1432,6 @@ static bool ath9k_hw_set_reset_reg(struct ath_hw *ah, u32 type)
 		break;
 	}
 
-	if (ah->caps.hw_caps & ATH9K_HW_CAP_MCI)
-		REG_WRITE(ah, AR_RTC_KEEP_AWAKE, 0x2);
-
 	return ret;
 }
 
@@ -2164,10 +2161,6 @@ bool ath9k_hw_setpower(struct ath_hw *ah, enum ath9k_power_mode mode)
 	switch (mode) {
 	case ATH9K_PM_AWAKE:
 		status = ath9k_hw_set_power_awake(ah, setChip);
-
-		if (ah->caps.hw_caps & ATH9K_HW_CAP_MCI)
-			REG_WRITE(ah, AR_RTC_KEEP_AWAKE, 0x2);
-
 		break;
 	case ATH9K_PM_FULL_SLEEP:
 		if (ah->caps.hw_caps & ATH9K_HW_CAP_MCI)
@@ -2177,10 +2170,6 @@ bool ath9k_hw_setpower(struct ath_hw *ah, enum ath9k_power_mode mode)
 		ah->chip_fullsleep = true;
 		break;
 	case ATH9K_PM_NETWORK_SLEEP:
-
-		if (ah->caps.hw_caps & ATH9K_HW_CAP_MCI)
-			REG_WRITE(ah, AR_RTC_KEEP_AWAKE, 0x2);
-
 		ath9k_set_power_network_sleep(ah, setChip);
 		break;
 	default:
-- 
1.7.10.2

