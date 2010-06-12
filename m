Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:41843 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751416Ab0FLPWk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jun 2010 11:22:40 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: lrodriguez@atheros.com, linville@tuxdriver.com
Subject: [PATCH 7/7] ath9k_hw: remove ATH9K_CAP_DS
Date: Sat, 12 Jun 2010 17:22:34 +0200
Message-Id: <1276356154-66545-7-git-send-email-nbd@openwrt.org>
In-Reply-To: <1276356154-66545-6-git-send-email-nbd@openwrt.org>
References: <1276356154-66545-1-git-send-email-nbd@openwrt.org>
 <1276356154-66545-2-git-send-email-nbd@openwrt.org>
 <1276356154-66545-3-git-send-email-nbd@openwrt.org>
 <1276356154-66545-4-git-send-email-nbd@openwrt.org>
 <1276356154-66545-5-git-send-email-nbd@openwrt.org>
 <1276356154-66545-6-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This capability check is no longer used, so it can be removed along with
the now-obsolete ath9k_hw_getcapability function.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c |   15 ---------------
 drivers/net/wireless/ath/ath9k/hw.h |    6 ------
 2 files changed, 0 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 9321931..62597f4 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2257,21 +2257,6 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 	return 0;
 }
 
-bool ath9k_hw_getcapability(struct ath_hw *ah, enum ath9k_capability_type type,
-			    u32 capability, u32 *result)
-{
-	switch (type) {
-	case ATH9K_CAP_DS:
-		return (AR_SREV_9280_20_OR_LATER(ah) &&
-			(ah->eep_ops->get_eeprom(ah, EEP_RC_CHAIN_MASK) == 1))
-			? false : true;
-	default:
-		return false;
-	}
-}
-EXPORT_SYMBOL(ath9k_hw_getcapability);
-
-
 /****************************/
 /* GPIO / RFKILL / Antennae */
 /****************************/
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 16b35cd..5ecbfcf 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -206,10 +206,6 @@ enum ath9k_hw_caps {
 	ATH9K_HW_CAP_PAPRD			= BIT(22),
 };
 
-enum ath9k_capability_type {
-	ATH9K_CAP_DS
-};
-
 struct ath9k_hw_capabilities {
 	u32 hw_caps; /* ATH9K_HW_CAP_* from ath9k_hw_caps */
 	DECLARE_BITMAP(wireless_modes, ATH9K_MODE_MAX); /* ATH9K_MODE_* */
@@ -852,8 +848,6 @@ int ath9k_hw_init(struct ath_hw *ah);
 int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 		   bool bChannelChange);
 int ath9k_hw_fill_cap_info(struct ath_hw *ah);
-bool ath9k_hw_getcapability(struct ath_hw *ah, enum ath9k_capability_type type,
-			    u32 capability, u32 *result);
 u32 ath9k_regd_get_ctl(struct ath_regulatory *reg, struct ath9k_channel *chan);
 
 /* Key Cache Management */
-- 
1.6.4.2

