Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:35426
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751816AbaJYTeW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Oct 2014 15:34:22 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, sujith@msujith.org
Subject: [PATCH v2 07/10] ath9k_hw: start initial NF calibration after PA calibration on <AR9003
Date: Sat, 25 Oct 2014 17:19:32 +0200
Message-Id: <1414250375-74121-7-git-send-email-nbd@openwrt.org> (sfid-20141025_213426_017110_A3FE08E1)
In-Reply-To: <1414250375-74121-1-git-send-email-nbd@openwrt.org>
References: <1414250375-74121-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes the initial NF calibration less likely to fail.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9002_calib.c | 2 ++
 drivers/net/wireless/ath/ath9k/hw.c           | 6 ++++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_calib.c b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
index 07994e3..42190b6 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
@@ -856,6 +856,8 @@ static bool ar9002_hw_init_cal(struct ath_hw *ah, struct ath9k_channel *chan)
 
 	/* Do PA Calibration */
 	ar9002_hw_pa_cal(ah, true);
+	ath9k_hw_loadnf(ah, chan);
+	ath9k_hw_start_nfcal(ah, true);
 
 	if (ah->caldata)
 		set_bit(NFCAL_PENDING, &ah->caldata->cal_flags);
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 8be4b14..85a7817 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1953,8 +1953,10 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	if (ath9k_hw_mci_is_enabled(ah))
 		ar9003_mci_check_bt(ah);
 
-	ath9k_hw_loadnf(ah, chan);
-	ath9k_hw_start_nfcal(ah, true);
+	if (AR_SREV_9300_20_OR_LATER(ah)) {
+		ath9k_hw_loadnf(ah, chan);
+		ath9k_hw_start_nfcal(ah, true);
+	}
 
 	if (AR_SREV_9300_20_OR_LATER(ah))
 		ar9003_hw_bb_watchdog_config(ah);
-- 
2.1.2

