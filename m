Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:60952 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757272Ab0DOVjn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Apr 2010 17:39:43 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH v3 15/97] ath9k_hw: move init config and default after chip is up
Date: Thu, 15 Apr 2010 17:38:20 -0400
Message-Id: <1271367582-992-16-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1271367582-992-1-git-send-email-lrodriguez@atheros.com>
References: <1271367582-992-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows us to add SREV checks on these helpers.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 5dc7041..7127166 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -410,8 +410,6 @@ static void ath9k_hw_init_defaults(struct ath_hw *ah)
 	ah->hw_version.subvendorid = 0;
 
 	ah->ah_flags = 0;
-	if (ah->hw_version.devid == AR5416_AR9100_DEVID)
-		ah->hw_version.macVersion = AR_SREV_VERSION_9100;
 	if (!AR_SREV_9100(ah))
 		ah->ah_flags = AH_USE_EEPROM;
 
@@ -874,8 +872,8 @@ static int __ath9k_hw_init(struct ath_hw *ah)
 	struct ath_common *common = ath9k_hw_common(ah);
 	int r = 0;
 
-	ath9k_hw_init_defaults(ah);
-	ath9k_hw_init_config(ah);
+	if (ah->hw_version.devid == AR5416_AR9100_DEVID)
+		ah->hw_version.macVersion = AR_SREV_VERSION_9100;
 
 	if (!ath9k_hw_set_reset_reg(ah, ATH9K_RESET_POWER_ON)) {
 		ath_print(common, ATH_DBG_FATAL,
@@ -883,6 +881,9 @@ static int __ath9k_hw_init(struct ath_hw *ah)
 		return -EIO;
 	}
 
+	ath9k_hw_init_defaults(ah);
+	ath9k_hw_init_config(ah);
+
 	ath9k_hw_attach_ops(ah);
 
 	if (!ath9k_hw_setpower(ah, ATH9K_PM_AWAKE)) {
-- 
1.6.3.3

