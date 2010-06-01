Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:41894 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755744Ab0FAJnA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jun 2010 05:43:00 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 01 Jun 2010 02:43:00 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19460.54890.225442.990101@gargle.gargle.HOWL>
Date: Tue, 1 Jun 2010 15:14:10 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 05/13] ath9k_hw: Fix async fifo for AR9287
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Async fifo is now enabled only for versions 1.3 and above.
Enable it in the appropriate place, in the reset routine,
instead of process_ini().

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar5008_phy.c |   11 -----
 drivers/net/wireless/ath/ath9k/ar9002_hw.c  |   24 ++++++++---
 drivers/net/wireless/ath/ath9k/hw.c         |    5 ++-
 drivers/net/wireless/ath/ath9k/hw.h         |    1 +
 drivers/net/wireless/ath/ath9k/reg.h        |   58 +++++++++++++++------------
 5 files changed, 55 insertions(+), 44 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar5008_phy.c b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
index c594814..cde411c 100644
--- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
@@ -744,17 +744,6 @@ static int ar5008_hw_process_ini(struct ath_hw *ah,
 		return -EINVAL;
 	}
 
-	if (AR_SREV_9287_12_OR_LATER(ah)) {
-		/* Enable ASYNC FIFO */
-		REG_SET_BIT(ah, AR_MAC_PCU_ASYNC_FIFO_REG3,
-				AR_MAC_PCU_ASYNC_FIFO_REG3_DATAPATH_SEL);
-		REG_SET_BIT(ah, AR_PHY_MODE, AR_PHY_MODE_ASYNCFIFO);
-		REG_CLR_BIT(ah, AR_MAC_PCU_ASYNC_FIFO_REG3,
-				AR_MAC_PCU_ASYNC_FIFO_REG3_SOFT_RESET);
-		REG_SET_BIT(ah, AR_MAC_PCU_ASYNC_FIFO_REG3,
-				AR_MAC_PCU_ASYNC_FIFO_REG3_SOFT_RESET);
-	}
-
 	/*
 	 * Set correct baseband to analog shift setting to
 	 * access analog chips.
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_hw.c b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
index 748449c..7ba9dd6 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
@@ -18,6 +18,7 @@
 #include "ar5008_initvals.h"
 #include "ar9001_initvals.h"
 #include "ar9002_initvals.h"
+#include "ar9002_phy.h"
 
 /* General hardware code for the A5008/AR9001/AR9002 hadware families */
 
@@ -565,18 +566,29 @@ int ar9002_hw_rf_claim(struct ath_hw *ah)
 	return 0;
 }
 
+void ar9002_hw_enable_async_fifo(struct ath_hw *ah)
+{
+	if (AR_SREV_9287_13_OR_LATER(ah)) {
+		REG_SET_BIT(ah, AR_MAC_PCU_ASYNC_FIFO_REG3,
+				AR_MAC_PCU_ASYNC_FIFO_REG3_DATAPATH_SEL);
+		REG_SET_BIT(ah, AR_PHY_MODE, AR_PHY_MODE_ASYNCFIFO);
+		REG_CLR_BIT(ah, AR_MAC_PCU_ASYNC_FIFO_REG3,
+				AR_MAC_PCU_ASYNC_FIFO_REG3_SOFT_RESET);
+		REG_SET_BIT(ah, AR_MAC_PCU_ASYNC_FIFO_REG3,
+				AR_MAC_PCU_ASYNC_FIFO_REG3_SOFT_RESET);
+	}
+}
+
 /*
- * Enable ASYNC FIFO
- *
  * If Async FIFO is enabled, the following counters change as MAC now runs
  * at 117 Mhz instead of 88/44MHz when async FIFO is disabled.
  *
  * The values below tested for ht40 2 chain.
  * Overwrite the delay/timeouts initialized in process ini.
  */
-void ar9002_hw_enable_async_fifo(struct ath_hw *ah)
+void ar9002_hw_update_async_fifo(struct ath_hw *ah)
 {
-	if (AR_SREV_9287_12_OR_LATER(ah)) {
+	if (AR_SREV_9287_13_OR_LATER(ah)) {
 		REG_WRITE(ah, AR_D_GBL_IFS_SIFS,
 			  AR_D_GBL_IFS_SIFS_ASYNC_FIFO_DUR);
 		REG_WRITE(ah, AR_D_GBL_IFS_SLOT,
@@ -600,9 +612,9 @@ void ar9002_hw_enable_async_fifo(struct ath_hw *ah)
  */
 void ar9002_hw_enable_wep_aggregation(struct ath_hw *ah)
 {
-	if (AR_SREV_9287_12_OR_LATER(ah)) {
+	if (AR_SREV_9287_13_OR_LATER(ah)) {
 		REG_SET_BIT(ah, AR_PCU_MISC_MODE2,
-				AR_PCU_MISC_MODE2_ENABLE_AGGWEP);
+			    AR_PCU_MISC_MODE2_ENABLE_AGGWEP);
 	}
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 45a9c84..1c541b4 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1303,6 +1303,9 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	if (AR_SREV_9280_10_OR_LATER(ah))
 		REG_SET_BIT(ah, AR_GPIO_INPUT_EN_VAL, AR_GPIO_JTAG_DISABLE);
 
+	if (!AR_SREV_9300_20_OR_LATER(ah))
+		ar9002_hw_enable_async_fifo(ah);
+
 	r = ath9k_hw_process_ini(ah, chan);
 	if (r)
 		return r;
@@ -1375,7 +1378,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	ath9k_hw_init_global_settings(ah);
 
 	if (!AR_SREV_9300_20_OR_LATER(ah)) {
-		ar9002_hw_enable_async_fifo(ah);
+		ar9002_hw_update_async_fifo(ah);
 		ar9002_hw_enable_wep_aggregation(ah);
 	}
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index a95e88d..f9cad8c 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -908,6 +908,7 @@ void ath9k_hw_get_delta_slope_vals(struct ath_hw *ah, u32 coef_scaled,
 void ar9002_hw_cck_chan14_spread(struct ath_hw *ah);
 int ar9002_hw_rf_claim(struct ath_hw *ah);
 void ar9002_hw_enable_async_fifo(struct ath_hw *ah);
+void ar9002_hw_update_async_fifo(struct ath_hw *ah);
 void ar9002_hw_enable_wep_aggregation(struct ath_hw *ah);
 
 /*
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index 854e681..216c71b 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -759,32 +759,33 @@
 #define AR_SREV_REVISION2        	      0x00000F00
 #define AR_SREV_REVISION2_S     	      8
 
-#define AR_SREV_VERSION_5416_PCI               0xD
-#define AR_SREV_VERSION_5416_PCIE              0xC
-#define AR_SREV_REVISION_5416_10               0
-#define AR_SREV_REVISION_5416_20               1
-#define AR_SREV_REVISION_5416_22               2
-#define AR_SREV_VERSION_9100                  0x14
-#define AR_SREV_VERSION_9160        	      0x40
-#define AR_SREV_REVISION_9160_10    	      0
-#define AR_SREV_REVISION_9160_11    	      1
-#define AR_SREV_VERSION_9280                0x80
-#define AR_SREV_REVISION_9280_10            0
-#define AR_SREV_REVISION_9280_20            1
-#define AR_SREV_REVISION_9280_21            2
-#define AR_SREV_VERSION_9285                  0xC0
-#define AR_SREV_REVISION_9285_10              0
-#define AR_SREV_REVISION_9285_11              1
-#define AR_SREV_REVISION_9285_12              2
-#define AR_SREV_VERSION_9287                  0x180
-#define AR_SREV_REVISION_9287_10              0
-#define AR_SREV_REVISION_9287_11              1
-#define AR_SREV_REVISION_9287_12              2
-#define AR_SREV_VERSION_9271			0x140
-#define AR_SREV_REVISION_9271_10		0
-#define AR_SREV_REVISION_9271_11		1
-#define AR_SREV_VERSION_9300                  0x1c0
-#define AR_SREV_REVISION_9300_20              2 /* 2.0 and 2.1 */
+#define AR_SREV_VERSION_5416_PCI	0xD
+#define AR_SREV_VERSION_5416_PCIE	0xC
+#define AR_SREV_REVISION_5416_10	0
+#define AR_SREV_REVISION_5416_20	1
+#define AR_SREV_REVISION_5416_22	2
+#define AR_SREV_VERSION_9100		0x14
+#define AR_SREV_VERSION_9160		0x40
+#define AR_SREV_REVISION_9160_10	0
+#define AR_SREV_REVISION_9160_11	1
+#define AR_SREV_VERSION_9280		0x80
+#define AR_SREV_REVISION_9280_10	0
+#define AR_SREV_REVISION_9280_20	1
+#define AR_SREV_REVISION_9280_21	2
+#define AR_SREV_VERSION_9285		0xC0
+#define AR_SREV_REVISION_9285_10	0
+#define AR_SREV_REVISION_9285_11	1
+#define AR_SREV_REVISION_9285_12	2
+#define AR_SREV_VERSION_9287		0x180
+#define AR_SREV_REVISION_9287_10	0
+#define AR_SREV_REVISION_9287_11	1
+#define AR_SREV_REVISION_9287_12	2
+#define AR_SREV_REVISION_9287_13	3
+#define AR_SREV_VERSION_9271		0x140
+#define AR_SREV_REVISION_9271_10	0
+#define AR_SREV_REVISION_9271_11	1
+#define AR_SREV_VERSION_9300		0x1c0
+#define AR_SREV_REVISION_9300_20	2 /* 2.0 and 2.1 */
 
 #define AR_SREV_5416(_ah) \
 	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_5416_PCI) || \
@@ -862,6 +863,11 @@
 	(((_ah)->hw_version.macVersion > AR_SREV_VERSION_9287) || \
 	 (((_ah)->hw_version.macVersion == AR_SREV_VERSION_9287) && \
 	  ((_ah)->hw_version.macRev >= AR_SREV_REVISION_9287_12)))
+#define AR_SREV_9287_13_OR_LATER(_ah) \
+	(((_ah)->hw_version.macVersion > AR_SREV_VERSION_9287) || \
+	 (((_ah)->hw_version.macVersion == AR_SREV_VERSION_9287) && \
+	  ((_ah)->hw_version.macRev >= AR_SREV_REVISION_9287_13)))
+
 #define AR_SREV_9271(_ah) \
     (((_ah))->hw_version.macVersion == AR_SREV_VERSION_9271)
 #define AR_SREV_9271_10(_ah) \
-- 
1.7.1

