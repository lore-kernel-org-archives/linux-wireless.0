Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:32882 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757340Ab0DOVjp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Apr 2010 17:39:45 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v3 59/97] ath9k_hw: move the cck channel 14 INI to the AR9002 hw code
Date: Thu, 15 Apr 2010 17:39:04 -0400
Message-Id: <1271367582-992-60-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1271367582-992-1-git-send-email-lrodriguez@atheros.com>
References: <1271367582-992-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is specific to the AR9002 family only.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9002_hw.c |   15 +++++++++++++++
 drivers/net/wireless/ath/ath9k/hw.c        |   11 ++---------
 drivers/net/wireless/ath/ath9k/hw.h        |    2 ++
 3 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_hw.c b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
index aa52fd7..ff81efa 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
@@ -229,6 +229,21 @@ static void ar9002_hw_init_mode_regs(struct ath_hw *ah)
 	}
 }
 
+/* Support for Japan ch.14 (2484) spread */
+void ar9002_hw_cck_chan14_spread(struct ath_hw *ah)
+{
+	if (AR_SREV_9287_11_OR_LATER(ah)) {
+		INIT_INI_ARRAY(&ah->iniCckfirNormal,
+		       ar9287Common_normal_cck_fir_coeff_92871_1,
+		       ARRAY_SIZE(ar9287Common_normal_cck_fir_coeff_92871_1),
+		       2);
+		INIT_INI_ARRAY(&ah->iniCckfirJapan2484,
+		       ar9287Common_japan_2484_cck_fir_coeff_92871_1,
+		       ARRAY_SIZE(ar9287Common_japan_2484_cck_fir_coeff_92871_1),
+		       2);
+	}
+}
+
 /*
  * Helper for ASPM support.
  *
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 672c5ad..a43e587 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -713,15 +713,8 @@ static int __ath9k_hw_init(struct ath_hw *ah)
 	else
 		ath9k_hw_disablepcie(ah);
 
-	/* Support for Japan ch.14 (2484) spread */
-	if (AR_SREV_9287_11_OR_LATER(ah)) {
-		INIT_INI_ARRAY(&ah->iniCckfirNormal,
-		       ar9287Common_normal_cck_fir_coeff_92871_1,
-		       ARRAY_SIZE(ar9287Common_normal_cck_fir_coeff_92871_1), 2);
-		INIT_INI_ARRAY(&ah->iniCckfirJapan2484,
-		       ar9287Common_japan_2484_cck_fir_coeff_92871_1,
-		       ARRAY_SIZE(ar9287Common_japan_2484_cck_fir_coeff_92871_1), 2);
-	}
+	if (!AR_SREV_9300_20_OR_LATER(ah))
+		ar9002_hw_cck_chan14_spread(ah);
 
 	r = ath9k_hw_post_init(ah);
 	if (r)
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 9325095..56c5735 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -838,6 +838,8 @@ void ath9k_hw_htc_resetinit(struct ath_hw *ah);
 void ath9k_hw_get_delta_slope_vals(struct ath_hw *ah, u32 coef_scaled,
 				   u32 *coef_mantissa, u32 *coef_exponent);
 
+void ar9002_hw_cck_chan14_spread(struct ath_hw *ah);
+
 /*
  * Code specifric to AR9003, we stuff these here to avoid callbacks
  * for older families
-- 
1.6.3.3

