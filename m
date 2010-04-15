Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54971 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756992Ab0DODa4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Apr 2010 23:30:56 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v2 78/97] ath9k_hw: skip asynch fifo enablement to AR9003
Date: Wed, 14 Apr 2010 23:30:32 -0400
Message-Id: <1271302251-9075-79-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1271302251-9075-1-git-send-email-lrodriguez@atheros.com>
References: <1271302251-9075-1-git-send-email-lrodriguez@atheros.com>
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
index 5b21e69..cf36f64 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
@@ -526,6 +526,35 @@ int ar9002_hw_rf_claim(struct ath_hw *ah)
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
index 953911d..ab223c6 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1266,22 +1266,9 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 
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
index 580de2f..81fb3a7 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -844,6 +844,7 @@ void ath9k_hw_get_delta_slope_vals(struct ath_hw *ah, u32 coef_scaled,
  */
 void ar9002_hw_cck_chan14_spread(struct ath_hw *ah);
 int ar9002_hw_rf_claim(struct ath_hw *ah);
+void ar9002_hw_enable_async_fifo(struct ath_hw *ah);
 
 /*
  * Code specifric to AR9003, we stuff these here to avoid callbacks
-- 
1.6.3.3

