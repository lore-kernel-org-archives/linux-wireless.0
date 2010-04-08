Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46978 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933293Ab0DHT1s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Apr 2010 15:27:48 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 082/102] ath9k_hw: skip WEP aggregation enable code for AR9003
Date: Thu,  8 Apr 2010 15:27:18 -0400
Message-Id: <1270754858-26266-83-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
References: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The AR9002 hardware code enables aggregation for WEP but
mac80211 doesn't enable aggregation with WEP, and the AR9003
code family does not need this so skip it for now for AR9003
but leave the code and annotate we should eventually consider
how to remove this in consideration for the HAL unification
goals.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9002_hw.c |   12 ++++++++++++
 drivers/net/wireless/ath/ath9k/hw.c        |    7 ++-----
 drivers/net/wireless/ath/ath9k/hw.h        |    1 +
 3 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_hw.c b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
index 16af1fb..7a2e943 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
@@ -607,6 +607,18 @@ void ar9002_hw_enable_async_fifo(struct ath_hw *ah)
 	}
 }
 
+/*
+ * We don't enable WEP aggregation on mac80211 but we keep this
+ * around for HAL unification purposes.
+ */
+void ar9002_hw_enable_wep_aggregation(struct ath_hw *ah)
+{
+	if (AR_SREV_9287_12_OR_LATER(ah)) {
+		REG_SET_BIT(ah, AR_PCU_MISC_MODE2,
+				AR_PCU_MISC_MODE2_ENABLE_AGGWEP);
+	}
+}
+
 /* Sets up the AR5008/AR9001/AR9002 hardware familiy callbacks */
 void ar9002_hw_attach_ops(struct ath_hw *ah)
 {
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index ceab040..156a416 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1267,12 +1267,9 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 
 	ath9k_hw_init_global_settings(ah);
 
-	if (!AR_SREV_9300_20_OR_LATER(ah))
+	if (!AR_SREV_9300_20_OR_LATER(ah)) {
 		ar9002_hw_enable_async_fifo(ah);
-
-	if (AR_SREV_9287_12_OR_LATER(ah)) {
-		REG_SET_BIT(ah, AR_PCU_MISC_MODE2,
-				AR_PCU_MISC_MODE2_ENABLE_AGGWEP);
+		ar9002_hw_enable_wep_aggregation(ah);
 	}
 
 	REG_WRITE(ah, AR_STA_ID1,
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 9201707..ade4a6c 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -846,6 +846,7 @@ void ar9002_hw_cck_chan14_spread(struct ath_hw *ah);
 int ar9002_hw_rf_claim(struct ath_hw *ah);
 void ar9280_pci_hw_init_eeprom_fix(struct ath_hw *ah);
 void ar9002_hw_enable_async_fifo(struct ath_hw *ah);
+void ar9002_hw_enable_wep_aggregation(struct ath_hw *ah);
 
 /*
  * Code specifric to AR9003, we stuff these here to avoid callbacks
-- 
1.6.3.3

