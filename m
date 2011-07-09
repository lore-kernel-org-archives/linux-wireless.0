Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:35857 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750909Ab1GIENQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jul 2011 00:13:16 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 2/9] ath9k_hw: always enable 5 GHz fast clock for AR9280
Date: Sat,  9 Jul 2011 11:12:47 +0700
Message-Id: <1310184774-32913-2-git-send-email-nbd@openwrt.org> (sfid-20110709_061329_763850_84E2112B)
In-Reply-To: <1310184774-32913-1-git-send-email-nbd@openwrt.org>
References: <1310184774-32913-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All devices support this, but some disable it using an EEPROM flag
for some reason. Improves 5 GHz performance on those devices.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 07827b5..a6bb9c4 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2079,10 +2079,7 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 			pCap->hw_caps |= ATH9K_HW_CAP_PAPRD;
 	} else {
 		pCap->tx_desc_len = sizeof(struct ath_desc);
-		if (AR_SREV_9280_20(ah) &&
-		    ((ah->eep_ops->get_eeprom(ah, EEP_MINOR_REV) <=
-		      AR5416_EEP_MINOR_VER_16) ||
-		     ah->eep_ops->get_eeprom(ah, EEP_FSTCLK_5G)))
+		if (AR_SREV_9280_20(ah))
 			pCap->hw_caps |= ATH9K_HW_CAP_FASTCLOCK;
 	}
 
-- 
1.7.3.2

