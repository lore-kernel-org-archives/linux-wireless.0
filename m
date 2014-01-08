Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:58257 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756635AbaAHQTl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jan 2014 11:19:41 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] ath9k: Disable cross-band FCC
Date: Wed,  8 Jan 2014 21:44:27 +0530
Message-Id: <1389197667-13105-1-git-send-email-sujith@msujith.org> (sfid-20140108_171944_149314_574C0408)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Fast Channel Change across bands was enabled for
AR9462 recently, but this is causing baseband issues.
Disable it until this feature is tested well. Also,
remove the feature bit for AR9565 since it is
a single-band card and doesn't support this feature.

Cc: stable@vger.kernel.org
Reported-by: Oleksij Rempel <linux@rempel-privat.de>
Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 47c6285..ce41658 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2476,13 +2476,6 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 	    ah->eep_ops->get_eeprom(ah, EEP_PAPRD))
 			pCap->hw_caps |= ATH9K_HW_CAP_PAPRD;
 
-	/*
-	 * Fast channel change across bands is available
-	 * only for AR9462 and AR9565.
-	 */
-	if (AR_SREV_9462(ah) || AR_SREV_9565(ah))
-		pCap->hw_caps |= ATH9K_HW_CAP_FCC_BAND_SWITCH;
-
 	return 0;
 }
 
-- 
1.8.5.2

