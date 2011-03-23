Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:44606 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932749Ab1CWT5k (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Mar 2011 15:57:40 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 06/10] ath9k_hw: remove ah->config.ht_enable
Date: Wed, 23 Mar 2011 20:57:29 +0100
Message-Id: <1300910253-28189-6-git-send-email-nbd@openwrt.org>
In-Reply-To: <1300910253-28189-5-git-send-email-nbd@openwrt.org>
References: <1300910253-28189-1-git-send-email-nbd@openwrt.org>
 <1300910253-28189-2-git-send-email-nbd@openwrt.org>
 <1300910253-28189-3-git-send-email-nbd@openwrt.org>
 <1300910253-28189-4-git-send-email-nbd@openwrt.org>
 <1300910253-28189-5-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is only used in one place, and the device id check that it's based on
can be moved there as well.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c |    7 +------
 drivers/net/wireless/ath/ath9k/hw.h |    1 -
 2 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index de0d218..625ad0b 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -378,11 +378,6 @@ static void ath9k_hw_init_config(struct ath_hw *ah)
 		ah->config.spurchans[i][1] = AR_NO_SPUR;
 	}
 
-	if (ah->hw_version.devid != AR2427_DEVID_PCIE)
-		ah->config.ht_enable = 1;
-	else
-		ah->config.ht_enable = 0;
-
 	/* PAPRD needs some more work to be enabled */
 	ah->config.paprd_disable = 1;
 
@@ -1880,7 +1875,7 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 
 	common->crypt_caps |= ATH_CRYPT_CAP_CIPHER_AESCCM;
 
-	if (ah->config.ht_enable)
+	if (ah->hw_version.devid != AR2427_DEVID_PCIE)
 		pCap->hw_caps |= ATH9K_HW_CAP_HT;
 	else
 		pCap->hw_caps &= ~ATH9K_HW_CAP_HT;
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 4e62ad8..7bbf701 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -222,7 +222,6 @@ struct ath9k_ops_config {
 	u8 pcie_clock_req;
 	u32 pcie_waen;
 	u8 analog_shiftreg;
-	u8 ht_enable;
 	u8 paprd_disable;
 	u32 ofdm_trig_low;
 	u32 ofdm_trig_high;
-- 
1.7.3.2

