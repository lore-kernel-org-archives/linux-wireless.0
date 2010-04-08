Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46975 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933292Ab0DHT1s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Apr 2010 15:27:48 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 081/102] ath9k_hw: skip asynch fifo enablement to AR9003
Date: Thu,  8 Apr 2010 15:27:17 -0400
Message-Id: <1270754858-26266-82-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
References: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The asynch fifo code is specific to >= AR9287 so stuff it
into the AR9002 hardware family code and skip it for AR9003
cards.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9002_hw.c |   29 ++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/hw.c        |   19 ++---------------
 drivers/net/wireless/ath/ath9k/hw.h        |    1 +
 3 files changed, 33 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_hw.c b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
index 9f713ce..16af1fb 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
@@ -578,6 +578,35 @@ int ar9002_hw_rf_claim(struct ath_hw *ah)
 	return 0;
 }
 
+/*
+ * Enable ASYNC FIFO
+ *
+ * If Async FIFO is enabled, the following counters change as MAC now runs
+ * at 117 Mhz instead of 88/44MHz when async FIFO is disabled.
+ *
+ * The values below tested for ht40 2 chain.
+ * Overwrite the delay/timeouts initialized in process ini.
+ */
+void ar9002_hw_enable_async_fifo(struct ath_hw *ah)
+{
+	if (AR_SREV_9287_12_OR_LATER(ah)) {
+		REG_WRITE(ah, AR_D_GBL_IFS_SIFS,
+			  AR_D_GBL_IFS_SIFS_ASYNC_FIFO_DUR);
+		REG_WRITE(ah, AR_D_GBL_IFS_SLOT,
+			  AR_D_GBL_IFS_SLOT_ASYNC_FIFO_DUR);
+		REG_WRITE(ah, AR_D_GBL_IFS_EIFS,
+			  AR_D_GBL_IFS_EIFS_ASYNC_FIFO_DUR);
+
+		REG_WRITE(ah, AR_TIME_OUT, AR_TIME_OUT_ACK_CTS_ASYNC_FIFO_DUR);
+		REG_WRITE(ah, AR_USEC, AR_USEC_ASYNC_FIFO_DUR);
+
+		REG_SET_BIT(ah, AR_MAC_PCU_LOGIC_ANALYZER,
+			    AR_MAC_PCU_LOGIC_ANALYZER_DISBUG20768);
+		REG_RMW_FIELD(ah, AR_AHB_MODE, AR_AHB_CUSTOM_BURST_EN,
+			      AR_AHB_CUSTOM_BURST_ASYNC_FIFO_VAL);
+	}
+}
+
 /* Sets up the AR5008/AR9001/AR9002 hardware familiy callbacks */
 void ar9002_hw_attach_ops(struct ath_hw *ah)
 {
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 1c625c0..ceab040 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1267,22 +1267,9 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 
 	ath9k_hw_init_global_settings(ah);
 
-	if (AR_SREV_9287_12_OR_LATER(ah)) {
-		REG_WRITE(ah, AR_D_GBL_IFS_SIFS,
-			  AR_D_GBL_IFS_SIFS_ASYNC_FIFO_DUR);
-		REG_WRITE(ah, AR_D_GBL_IFS_SLOT,
-			  AR_D_GBL_IFS_SLOT_ASYNC_FIFO_DUR);
-		REG_WRITE(ah, AR_D_GBL_IFS_EIFS,
-			  AR_D_GBL_IFS_EIFS_ASYNC_FIFO_DUR);
-
-		REG_WRITE(ah, AR_TIME_OUT, AR_TIME_OUT_ACK_CTS_ASYNC_FIFO_DUR);
-		REG_WRITE(ah, AR_USEC, AR_USEC_ASYNC_FIFO_DUR);
+	if (!AR_SREV_9300_20_OR_LATER(ah))
+		ar9002_hw_enable_async_fifo(ah);
 
-		REG_SET_BIT(ah, AR_MAC_PCU_LOGIC_ANALYZER,
-			    AR_MAC_PCU_LOGIC_ANALYZER_DISBUG20768);
-		REG_RMW_FIELD(ah, AR_AHB_MODE, AR_AHB_CUSTOM_BURST_EN,
-			      AR_AHB_CUSTOM_BURST_ASYNC_FIFO_VAL);
-	}
 	if (AR_SREV_9287_12_OR_LATER(ah)) {
 		REG_SET_BIT(ah, AR_PCU_MISC_MODE2,
 				AR_PCU_MISC_MODE2_ENABLE_AGGWEP);
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 4f401fd..9201707 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -845,6 +845,7 @@ void ath9k_hw_get_delta_slope_vals(struct ath_hw *ah, u32 coef_scaled,
 void ar9002_hw_cck_chan14_spread(struct ath_hw *ah);
 int ar9002_hw_rf_claim(struct ath_hw *ah);
 void ar9280_pci_hw_init_eeprom_fix(struct ath_hw *ah);
+void ar9002_hw_enable_async_fifo(struct ath_hw *ah);
 
 /*
  * Code specifric to AR9003, we stuff these here to avoid callbacks
-- 
1.6.3.3

