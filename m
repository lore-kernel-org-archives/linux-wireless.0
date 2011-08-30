Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:9351 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738Ab1H3KZd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 06:25:33 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	<stable@kernel.org>, Adrian Chadd <adrian@freebsd.org>,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH] ath9k_hw: Fix fast clock support for AR9280 v2.0+
Date: Tue, 30 Aug 2011 15:55:58 +0530
Message-ID: <1314699958-4951-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110830_122537_169391_773D312D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To enable fast clock support on 5GHz for AR9280 v2.0+ chips,
mac version alone is not sufficient. It also depends on eeprom
values.

Cc: stable@kernel.org
Cc: Adrian Chadd <adrian@freebsd.org>
Cc: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 284d2a4..d8d776f9 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2184,7 +2184,10 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 			pCap->hw_caps |= ATH9K_HW_CAP_PAPRD;
 	} else {
 		pCap->tx_desc_len = sizeof(struct ath_desc);
-		if (AR_SREV_9280_20(ah))
+		if (AR_SREV_9280_20(ah) &&
+		    ((ah->eep_ops->get_eeprom(ah, EEP_MINOR_REV) <=
+					      AR5416_EEP_MINOR_VER_16) ||
+		     ah->eep_ops->get_eeprom(ah, EEP_FSTCLK_5G)))
 			pCap->hw_caps |= ATH9K_HW_CAP_FASTCLOCK;
 	}
 
-- 
1.7.6.1

