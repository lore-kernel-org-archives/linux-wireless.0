Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:39194 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604Ab3LLRKR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Dec 2013 12:10:17 -0500
Received: by mail-ee0-f48.google.com with SMTP id e49so378581eek.7
        for <linux-wireless@vger.kernel.org>; Thu, 12 Dec 2013 09:10:16 -0800 (PST)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, mcgrof@do-not-panic.com,
	Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	rmanohar@qti.qualcomm.com
Subject: [PATCH] ath9k: fix 5/10MHz channel width initialization on ar9003
Date: Thu, 12 Dec 2013 18:10:16 +0100
Message-Id: <1386868216-11963-1-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20131212_181038_774830_CB7760E3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move ath9k_hw_set_rfmode() after ath9k_hw_process_ini() in order to avoid
AR_PHY_MODE register is overwritten with default values by
ar9003_hw_process_ini()

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
 drivers/net/wireless/ath/ath9k/hw.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 4ee24b1..1de98b8 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1485,7 +1485,6 @@ static bool ath9k_hw_chip_reset(struct ath_hw *ah,
 	if (AR_SREV_9330(ah))
 		ar9003_hw_internal_regulator_apply(ah);
 	ath9k_hw_init_pll(ah, chan);
-	ath9k_hw_set_rfmode(ah, chan);
 
 	return true;
 }
@@ -1954,6 +1953,8 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	if (r)
 		return r;
 
+	ath9k_hw_set_rfmode(ah, chan);
+
 	if (ath9k_hw_mci_is_enabled(ah))
 		ar9003_mci_reset(ah, false, IS_CHAN_2GHZ(chan), save_fullsleep);
 
-- 
1.8.3.2

