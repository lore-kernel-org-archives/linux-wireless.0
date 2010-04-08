Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46962 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933286Ab0DHT1s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Apr 2010 15:27:48 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 075/102] ath9k_hw: move the RF claim stuff to AR9002 hardware family
Date: Thu,  8 Apr 2010 15:27:11 -0400
Message-Id: <1270754858-26266-76-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
References: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9002_hw.c |   43 +++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/hw.c        |   51 +++-------------------------
 drivers/net/wireless/ath/ath9k/hw.h        |    5 +++
 3 files changed, 53 insertions(+), 46 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_hw.c b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
index 8441807..9f713ce 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
@@ -535,6 +535,49 @@ void ar9280_pci_hw_init_eeprom_fix(struct ath_hw *ah)
 		ar9280_pci_hw_mode_eeprom_fix(ah, row);
 }
 
+static int ar9002_hw_get_radiorev(struct ath_hw *ah)
+{
+	u32 val;
+	int i;
+
+	REG_WRITE(ah, AR_PHY(0x36), 0x00007058);
+
+	for (i = 0; i < 8; i++)
+		REG_WRITE(ah, AR_PHY(0x20), 0x00010000);
+	val = (REG_READ(ah, AR_PHY(256)) >> 24) & 0xff;
+	val = ((val & 0xf0) >> 4) | ((val & 0x0f) << 4);
+
+	return ath9k_hw_reverse_bits(val, 8);
+}
+
+int ar9002_hw_rf_claim(struct ath_hw *ah)
+{
+	u32 val;
+
+	REG_WRITE(ah, AR_PHY(0), 0x00000007);
+
+	val = ar9002_hw_get_radiorev(ah);
+	switch (val & AR_RADIO_SREV_MAJOR) {
+	case 0:
+		val = AR_RAD5133_SREV_MAJOR;
+		break;
+	case AR_RAD5133_SREV_MAJOR:
+	case AR_RAD5122_SREV_MAJOR:
+	case AR_RAD2133_SREV_MAJOR:
+	case AR_RAD2122_SREV_MAJOR:
+		break;
+	default:
+		ath_print(ath9k_hw_common(ah), ATH_DBG_FATAL,
+			  "Radio Chip Rev 0x%02X not supported\n",
+			  val & AR_RADIO_SREV_MAJOR);
+		return -EOPNOTSUPP;
+	}
+
+	ah->hw_version.analog5GhzRev = val;
+
+	return 0;
+}
+
 /* Sets up the AR5008/AR9001/AR9002 hardware familiy callbacks */
 void ar9002_hw_attach_ops(struct ath_hw *ah)
 {
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index fcb6b6d..98c7e6a 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -261,21 +261,6 @@ static void ath9k_hw_read_revisions(struct ath_hw *ah)
 	}
 }
 
-static int ath9k_hw_get_radiorev(struct ath_hw *ah)
-{
-	u32 val;
-	int i;
-
-	REG_WRITE(ah, AR_PHY(0x36), 0x00007058);
-
-	for (i = 0; i < 8; i++)
-		REG_WRITE(ah, AR_PHY(0x20), 0x00010000);
-	val = (REG_READ(ah, AR_PHY(256)) >> 24) & 0xff;
-	val = ((val & 0xf0) >> 4) | ((val & 0x0f) << 4);
-
-	return ath9k_hw_reverse_bits(val, 8);
-}
-
 /************************************/
 /* HW Attach, Detach, Init Routines */
 /************************************/
@@ -434,34 +419,6 @@ static void ath9k_hw_init_defaults(struct ath_hw *ah)
 	ah->power_mode = ATH9K_PM_UNDEFINED;
 }
 
-static int ath9k_hw_rf_claim(struct ath_hw *ah)
-{
-	u32 val;
-
-	REG_WRITE(ah, AR_PHY(0), 0x00000007);
-
-	val = ath9k_hw_get_radiorev(ah);
-	switch (val & AR_RADIO_SREV_MAJOR) {
-	case 0:
-		val = AR_RAD5133_SREV_MAJOR;
-		break;
-	case AR_RAD5133_SREV_MAJOR:
-	case AR_RAD5122_SREV_MAJOR:
-	case AR_RAD2133_SREV_MAJOR:
-	case AR_RAD2122_SREV_MAJOR:
-		break;
-	default:
-		ath_print(ath9k_hw_common(ah), ATH_DBG_FATAL,
-			  "Radio Chip Rev 0x%02X not supported\n",
-			  val & AR_RADIO_SREV_MAJOR);
-		return -EOPNOTSUPP;
-	}
-
-	ah->hw_version.analog5GhzRev = val;
-
-	return 0;
-}
-
 static int ath9k_hw_init_macaddr(struct ath_hw *ah)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
@@ -492,9 +449,11 @@ static int ath9k_hw_post_init(struct ath_hw *ah)
 			return -ENODEV;
 	}
 
-	ecode = ath9k_hw_rf_claim(ah);
-	if (ecode != 0)
-		return ecode;
+	if (!AR_SREV_9300_20_OR_LATER(ah)) {
+		ecode = ar9002_hw_rf_claim(ah);
+		if (ecode != 0)
+			return ecode;
+	}
 
 	ecode = ath9k_hw_eeprom_init(ah);
 	if (ecode != 0)
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index e7c8005..4f401fd 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -838,7 +838,12 @@ void ath9k_hw_htc_resetinit(struct ath_hw *ah);
 void ath9k_hw_get_delta_slope_vals(struct ath_hw *ah, u32 coef_scaled,
 				   u32 *coef_mantissa, u32 *coef_exponent);
 
+/*
+ * Code Specific to AR5008, AR9001 or AR9002,
+ * we stuff these here to avoid callbacks for AR9003.
+ */
 void ar9002_hw_cck_chan14_spread(struct ath_hw *ah);
+int ar9002_hw_rf_claim(struct ath_hw *ah);
 void ar9280_pci_hw_init_eeprom_fix(struct ath_hw *ah);
 
 /*
-- 
1.6.3.3

