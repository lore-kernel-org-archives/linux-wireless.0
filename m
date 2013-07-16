Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:59865 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563Ab3GPGgo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jul 2013 02:36:44 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/6] ath9k: Add a HW flag for FCC
Date: Tue, 16 Jul 2013 12:03:18 +0530
Message-Id: <1373956402-22169-2-git-send-email-sujith@msujith.org> (sfid-20130716_083648_714900_11D26458)
In-Reply-To: <1373956402-22169-1-git-send-email-sujith@msujith.org>
References: <1373956402-22169-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Fast Channel Change across 2G/5G bands is supported
only by AR9462 and AR9565. Add a HW capability field
to indicate this.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw.c | 7 +++++++
 drivers/net/wireless/ath/ath9k/hw.h | 1 +
 2 files changed, 8 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 4ca0cb0..2d385c2 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2610,6 +2610,13 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 	    ah->eep_ops->get_eeprom(ah, EEP_PAPRD))
 			pCap->hw_caps |= ATH9K_HW_CAP_PAPRD;
 
+	/*
+	 * Fast channel change across bands is available
+	 * only for AR9462 and AR9565.
+	 */
+	if (AR_SREV_9462(ah) || AR_SREV_9565(ah))
+		pCap->hw_caps |= ATH9K_HW_CAP_FCC_BAND_SWITCH;
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index cd74b3a..fd009e5 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -247,6 +247,7 @@ enum ath9k_hw_caps {
 	ATH9K_HW_CAP_DFS			= BIT(16),
 	ATH9K_HW_WOW_DEVICE_CAPABLE		= BIT(17),
 	ATH9K_HW_CAP_PAPRD			= BIT(18),
+	ATH9K_HW_CAP_FCC_BAND_SWITCH		= BIT(19),
 };
 
 /*
-- 
1.8.3.2

