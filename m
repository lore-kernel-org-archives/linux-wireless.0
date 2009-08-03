Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:34803 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754534AbZHCTZN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2009 15:25:13 -0400
Received: from mail.atheros.com ([10.10.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 03 Aug 2009 12:25:15 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 13/24] ath9k: break up hw initialization into a few more helpers
Date: Mon, 3 Aug 2009 12:24:45 -0700
Message-ID: <1249327496-24629-14-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1249327496-24629-1-git-send-email-lrodriguez@atheros.com>
References: <1249327496-24629-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes reading the hardware initialization process
easier to understand. The new helpers added are:

ath9k_hw_init_cal_settings()
ath9k_hw_init_mode_regs()
ath9k_hw_init_mode_gain_regs()
ath9k_hw_init_11a_eeprom_fix()

This patch has no functional changes.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |  154 ++++++++++++++++++++---------------
 1 files changed, 87 insertions(+), 67 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 31ec83d..f280eef 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -644,61 +644,8 @@ static bool ath9k_hw_macversion_supported(u32 macversion)
 	return false;
 }
 
-int ath9k_hw_attach(struct ath_hw *ah)
+static void ath9k_hw_init_cal_settings(struct ath_hw *ah)
 {
-	int r;
-	u32 i, j;
-
-	if (!ath9k_hw_devid_supported(ah->hw_version.devid)) {
-		r = -EOPNOTSUPP;
-		goto bad;
-	}
-
-	ath9k_hw_init_defaults(ah);
-	ath9k_hw_init_config(ah);
-
-	if (!ath9k_hw_set_reset_reg(ah, ATH9K_RESET_POWER_ON)) {
-		DPRINTF(ah->ah_sc, ATH_DBG_FATAL, "Couldn't reset chip\n");
-		r = -EIO;
-		goto bad;
-	}
-
-	if (!ath9k_hw_setpower(ah, ATH9K_PM_AWAKE)) {
-		DPRINTF(ah->ah_sc, ATH_DBG_FATAL, "Couldn't wakeup chip\n");
-		r = -EIO;
-		goto bad;
-	}
-
-	if (ah->config.serialize_regmode == SER_REG_MODE_AUTO) {
-		if (ah->hw_version.macVersion == AR_SREV_VERSION_5416_PCI ||
-		    (AR_SREV_9280(ah) && !ah->is_pciexpress)) {
-			ah->config.serialize_regmode =
-				SER_REG_MODE_ON;
-		} else {
-			ah->config.serialize_regmode =
-				SER_REG_MODE_OFF;
-		}
-	}
-
-	DPRINTF(ah->ah_sc, ATH_DBG_RESET, "serialize_regmode is %d\n",
-		ah->config.serialize_regmode);
-
-	if (!ath9k_hw_macversion_supported(ah->hw_version.macVersion)) {
-		DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
-			"Mac Chip Rev 0x%02x.%x is not supported by "
-			"this driver\n", ah->hw_version.macVersion,
-			ah->hw_version.macRev);
-		r = -EOPNOTSUPP;
-		goto bad;
-	}
-
-	if (AR_SREV_9100(ah)) {
-		ah->iq_caldata.calData = &iq_cal_multi_sample;
-		ah->supp_cals = IQ_MISMATCH_CAL;
-		ah->is_pciexpress = false;
-	}
-	ah->hw_version.phyRev = REG_READ(ah, AR_PHY_CHIP_ID);
-
 	if (AR_SREV_9160_10_OR_LATER(ah)) {
 		if (AR_SREV_9280_10_OR_LATER(ah)) {
 			ah->iq_caldata.calData = &iq_cal_single_sample;
@@ -719,10 +666,10 @@ int ath9k_hw_attach(struct ath_hw *ah)
 		}
 		ah->supp_cals = ADC_GAIN_CAL | ADC_DC_CAL | IQ_MISMATCH_CAL;
 	}
+}
 
-	ah->ani_function = ATH9K_ANI_ALL;
-	if (AR_SREV_9280_10_OR_LATER(ah))
-		ah->ani_function &= ~ATH9K_ANI_NOISE_IMMUNITY_LEVEL;
+static void ath9k_hw_init_mode_regs(struct ath_hw *ah)
+{
 	if (AR_SREV_9287_11_OR_LATER(ah)) {
 		INIT_INI_ARRAY(&ah->iniModes, ar9287Modes_9287_1_1,
 				ARRAY_SIZE(ar9287Modes_9287_1_1), 6);
@@ -884,16 +831,10 @@ int ath9k_hw_attach(struct ath_hw *ah)
 		INIT_INI_ARRAY(&ah->iniAddac, ar5416Addac,
 			       ARRAY_SIZE(ar5416Addac), 2);
 	}
+}
 
-	if (ah->is_pciexpress)
-		ath9k_hw_configpcipowersave(ah, 0);
-	else
-		ath9k_hw_disablepcie(ah);
-
-	r = ath9k_hw_post_attach(ah);
-	if (r)
-		goto bad;
-
+static void ath9k_hw_init_mode_gain_regs(struct ath_hw *ah)
+{
 	if (AR_SREV_9287_11(ah))
 		INIT_INI_ARRAY(&ah->iniModesRxGain,
 		ar9287Modes_rx_gain_9287_1_1,
@@ -930,8 +871,11 @@ int ath9k_hw_attach(struct ath_hw *ah)
 		}
 
 	}
+}
 
-	ath9k_hw_fill_cap_info(ah);
+static void ath9k_hw_init_11a_eeprom_fix(struct ath_hw *ah)
+{
+	u32 i, j;
 
 	if ((ah->hw_version.devid == AR9280_DEVID_PCI) &&
 	    test_bit(ATH9K_MODE_11A, ah->caps.wireless_modes)) {
@@ -950,6 +894,82 @@ int ath9k_hw_attach(struct ath_hw *ah)
 			}
 		}
 	}
+}
+
+int ath9k_hw_attach(struct ath_hw *ah)
+{
+	int r;
+
+	if (!ath9k_hw_devid_supported(ah->hw_version.devid)) {
+		r = -EOPNOTSUPP;
+		goto bad;
+	}
+
+	ath9k_hw_init_defaults(ah);
+	ath9k_hw_init_config(ah);
+
+	if (!ath9k_hw_set_reset_reg(ah, ATH9K_RESET_POWER_ON)) {
+		DPRINTF(ah->ah_sc, ATH_DBG_FATAL, "Couldn't reset chip\n");
+		r = -EIO;
+		goto bad;
+	}
+
+	if (!ath9k_hw_setpower(ah, ATH9K_PM_AWAKE)) {
+		DPRINTF(ah->ah_sc, ATH_DBG_FATAL, "Couldn't wakeup chip\n");
+		r = -EIO;
+		goto bad;
+	}
+
+	if (ah->config.serialize_regmode == SER_REG_MODE_AUTO) {
+		if (ah->hw_version.macVersion == AR_SREV_VERSION_5416_PCI ||
+		    (AR_SREV_9280(ah) && !ah->is_pciexpress)) {
+			ah->config.serialize_regmode =
+				SER_REG_MODE_ON;
+		} else {
+			ah->config.serialize_regmode =
+				SER_REG_MODE_OFF;
+		}
+	}
+
+	DPRINTF(ah->ah_sc, ATH_DBG_RESET, "serialize_regmode is %d\n",
+		ah->config.serialize_regmode);
+
+	if (!ath9k_hw_macversion_supported(ah->hw_version.macVersion)) {
+		DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
+			"Mac Chip Rev 0x%02x.%x is not supported by "
+			"this driver\n", ah->hw_version.macVersion,
+			ah->hw_version.macRev);
+		r = -EOPNOTSUPP;
+		goto bad;
+	}
+
+	if (AR_SREV_9100(ah)) {
+		ah->iq_caldata.calData = &iq_cal_multi_sample;
+		ah->supp_cals = IQ_MISMATCH_CAL;
+		ah->is_pciexpress = false;
+	}
+	ah->hw_version.phyRev = REG_READ(ah, AR_PHY_CHIP_ID);
+
+	ath9k_hw_init_cal_settings(ah);
+
+	ah->ani_function = ATH9K_ANI_ALL;
+	if (AR_SREV_9280_10_OR_LATER(ah))
+		ah->ani_function &= ~ATH9K_ANI_NOISE_IMMUNITY_LEVEL;
+
+	ath9k_hw_init_mode_regs(ah);
+
+	if (ah->is_pciexpress)
+		ath9k_hw_configpcipowersave(ah, 0);
+	else
+		ath9k_hw_disablepcie(ah);
+
+	r = ath9k_hw_post_attach(ah);
+	if (r)
+		goto bad;
+
+	ath9k_hw_init_mode_gain_regs(ah);
+	ath9k_hw_fill_cap_info(ah);
+	ath9k_hw_init_11a_eeprom_fix(ah);
 
 	r = ath9k_hw_init_macaddr(ah);
 	if (r) {
-- 
1.6.3.3

