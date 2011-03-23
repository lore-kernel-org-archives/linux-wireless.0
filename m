Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:44611 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932741Ab1CWT5k (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Mar 2011 15:57:40 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 09/10] ath9k_hw: remove ATH9K_HW_CAP_ENHANCEDPM
Date: Wed, 23 Mar 2011 20:57:32 +0100
Message-Id: <1300910253-28189-9-git-send-email-nbd@openwrt.org>
In-Reply-To: <1300910253-28189-8-git-send-email-nbd@openwrt.org>
References: <1300910253-28189-1-git-send-email-nbd@openwrt.org>
 <1300910253-28189-2-git-send-email-nbd@openwrt.org>
 <1300910253-28189-3-git-send-email-nbd@openwrt.org>
 <1300910253-28189-4-git-send-email-nbd@openwrt.org>
 <1300910253-28189-5-git-send-email-nbd@openwrt.org>
 <1300910253-28189-6-git-send-email-nbd@openwrt.org>
 <1300910253-28189-7-git-send-email-nbd@openwrt.org>
 <1300910253-28189-8-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is not used anywhere

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c |    2 --
 drivers/net/wireless/ath/ath9k/hw.h |    1 -
 2 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 5c676da..a2509dc 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1903,8 +1903,6 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 		pCap->rts_aggr_limit = (8 * 1024);
 	}
 
-	pCap->hw_caps |= ATH9K_HW_CAP_ENHANCEDPM;
-
 #if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
 	ah->rfsilent = ah->eep_ops->get_eeprom(ah, EEP_RF_SILENT);
 	if (ah->rfsilent & EEP_RFSILENT_ENABLED) {
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 296e51b..a0243b8 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -174,7 +174,6 @@ enum ath9k_hw_caps {
 	ATH9K_HW_CAP_HT                         = BIT(0),
 	ATH9K_HW_CAP_RFSILENT                   = BIT(1),
 	ATH9K_HW_CAP_CST                        = BIT(2),
-	ATH9K_HW_CAP_ENHANCEDPM                 = BIT(3),
 	ATH9K_HW_CAP_AUTOSLEEP                  = BIT(4),
 	ATH9K_HW_CAP_4KB_SPLITTRANS             = BIT(5),
 	ATH9K_HW_CAP_EDMA			= BIT(6),
-- 
1.7.3.2

