Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:53706 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388030AbeGWRFN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Jul 2018 13:05:13 -0400
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH 1/9] ath9k_hw: set spectral scan enable bit on trigger for AR9003+
Date: Mon, 23 Jul 2018 18:02:52 +0200
Message-Id: <20180723160300.58024-1-nbd@nbd.name> (sfid-20180723_180334_848350_38479F26)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

AR9002 code and the QCA AR9003+ reference code do the same.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index fe5102ca5010..98c5f524a360 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -1800,6 +1800,8 @@ static void ar9003_hw_spectral_scan_config(struct ath_hw *ah,
 
 static void ar9003_hw_spectral_scan_trigger(struct ath_hw *ah)
 {
+	REG_SET_BIT(ah, AR_PHY_SPECTRAL_SCAN,
+		    AR_PHY_SPECTRAL_SCAN_ENABLE);
 	/* Activate spectral scan */
 	REG_SET_BIT(ah, AR_PHY_SPECTRAL_SCAN,
 		    AR_PHY_SPECTRAL_SCAN_ACTIVE);
-- 
2.17.0
