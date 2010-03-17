Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:41090 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756125Ab0CQW2P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Mar 2010 18:28:15 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v2 02/20] ath9k: initial move of ar9002 specific code to its own file
Date: Wed, 17 Mar 2010 18:27:55 -0400
Message-Id: <1268864893-11428-3-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1268864893-11428-1-git-send-email-lrodriguez@atheros.com>
References: <1268864893-11428-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move wardware code specific to ar9002 to its own file to make
things easier to read and manage. This just shuffles code and
adds three private hardware callbacks to allow us to move the
rest: init_pll, init_mode_gains and init_14_spread.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/Makefile    |    1 +
 drivers/net/wireless/ath/ath9k/ar9002_hw.c |  839 ++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/hw-ops.h    |   31 +-
 drivers/net/wireless/ath/ath9k/hw.c        |  821 +---------------------------
 drivers/net/wireless/ath/ath9k/hw.h        |    6 +
 5 files changed, 878 insertions(+), 820 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9002_hw.c

diff --git a/drivers/net/wireless/ath/ath9k/Makefile b/drivers/net/wireless/ath/ath9k/Makefile
index 97133be..fe53595 100644
--- a/drivers/net/wireless/ath/ath9k/Makefile
+++ b/drivers/net/wireless/ath/ath9k/Makefile
@@ -14,6 +14,7 @@ ath9k-$(CONFIG_ATH9K_DEBUGFS) += debug.o
 obj-$(CONFIG_ATH9K) += ath9k.o
 
 ath9k_hw-y:=	hw.o \
+		ar9002_hw.o \
 		eeprom.o \
 		eeprom_def.o \
 		eeprom_4k.o \
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_hw.c b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
new file mode 100644
index 0000000..76e49b4
--- /dev/null
+++ b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
@@ -0,0 +1,839 @@
+/*
+ * Copyright (c) 2008-2010 Atheros Communications Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include "hw.h"
+#include "hw-ops.h"
+#include "rc.h"
+#include "initvals.h"
+
+static void ar9002_hw_disablepcie(struct ath_hw *ah)
+{
+	if (AR_SREV_9100(ah))
+		return;
+
+	REG_WRITE(ah, AR_PCIE_SERDES, 0x9248fc00);
+	REG_WRITE(ah, AR_PCIE_SERDES, 0x24924924);
+	REG_WRITE(ah, AR_PCIE_SERDES, 0x28000029);
+	REG_WRITE(ah, AR_PCIE_SERDES, 0x57160824);
+	REG_WRITE(ah, AR_PCIE_SERDES, 0x25980579);
+	REG_WRITE(ah, AR_PCIE_SERDES, 0x00000000);
+	REG_WRITE(ah, AR_PCIE_SERDES, 0x1aaabe40);
+	REG_WRITE(ah, AR_PCIE_SERDES, 0xbe105554);
+	REG_WRITE(ah, AR_PCIE_SERDES, 0x000e1007);
+
+	REG_WRITE(ah, AR_PCIE_SERDES2, 0x00000000);
+}
+
+static bool ar9002_hw_macversion_supported(u32 macversion)
+{
+	switch (macversion) {
+	case AR_SREV_VERSION_5416_PCI:
+	case AR_SREV_VERSION_5416_PCIE:
+	case AR_SREV_VERSION_9160:
+	case AR_SREV_VERSION_9100:
+	case AR_SREV_VERSION_9280:
+	case AR_SREV_VERSION_9285:
+	case AR_SREV_VERSION_9287:
+	case AR_SREV_VERSION_9271:
+		return true;
+	default:
+		break;
+	}
+	return false;
+}
+
+static void ar9002_hw_init_cal_settings(struct ath_hw *ah)
+{
+	if (AR_SREV_9160_10_OR_LATER(ah)) {
+		if (AR_SREV_9280_10_OR_LATER(ah)) {
+			ah->iq_caldata.calData = &iq_cal_single_sample;
+			ah->adcgain_caldata.calData =
+				&adc_gain_cal_single_sample;
+			ah->adcdc_caldata.calData =
+				&adc_dc_cal_single_sample;
+			ah->adcdc_calinitdata.calData =
+				&adc_init_dc_cal;
+		} else {
+			ah->iq_caldata.calData = &iq_cal_multi_sample;
+			ah->adcgain_caldata.calData =
+				&adc_gain_cal_multi_sample;
+			ah->adcdc_caldata.calData =
+				&adc_dc_cal_multi_sample;
+			ah->adcdc_calinitdata.calData =
+				&adc_init_dc_cal;
+		}
+		ah->supp_cals = ADC_GAIN_CAL | ADC_DC_CAL | IQ_MISMATCH_CAL;
+	}
+}
+
+static void ar9002_hw_init_mode_regs(struct ath_hw *ah)
+{
+	if (AR_SREV_9271(ah)) {
+		INIT_INI_ARRAY(&ah->iniModes, ar9271Modes_9271,
+			       ARRAY_SIZE(ar9271Modes_9271), 6);
+		INIT_INI_ARRAY(&ah->iniCommon, ar9271Common_9271,
+			       ARRAY_SIZE(ar9271Common_9271), 2);
+		INIT_INI_ARRAY(&ah->iniCommon_normal_cck_fir_coeff_9271,
+			       ar9271Common_normal_cck_fir_coeff_9271,
+			       ARRAY_SIZE(ar9271Common_normal_cck_fir_coeff_9271), 2);
+		INIT_INI_ARRAY(&ah->iniCommon_japan_2484_cck_fir_coeff_9271,
+			       ar9271Common_japan_2484_cck_fir_coeff_9271,
+			       ARRAY_SIZE(ar9271Common_japan_2484_cck_fir_coeff_9271), 2);
+		INIT_INI_ARRAY(&ah->iniModes_9271_1_0_only,
+			       ar9271Modes_9271_1_0_only,
+			       ARRAY_SIZE(ar9271Modes_9271_1_0_only), 6);
+		INIT_INI_ARRAY(&ah->iniModes_9271_ANI_reg, ar9271Modes_9271_ANI_reg,
+			       ARRAY_SIZE(ar9271Modes_9271_ANI_reg), 6);
+		INIT_INI_ARRAY(&ah->iniModes_high_power_tx_gain_9271,
+			       ar9271Modes_high_power_tx_gain_9271,
+			       ARRAY_SIZE(ar9271Modes_high_power_tx_gain_9271), 6);
+		INIT_INI_ARRAY(&ah->iniModes_normal_power_tx_gain_9271,
+			       ar9271Modes_normal_power_tx_gain_9271,
+			       ARRAY_SIZE(ar9271Modes_normal_power_tx_gain_9271), 6);
+		return;
+	}
+
+	if (AR_SREV_9287_11_OR_LATER(ah)) {
+		INIT_INI_ARRAY(&ah->iniModes, ar9287Modes_9287_1_1,
+				ARRAY_SIZE(ar9287Modes_9287_1_1), 6);
+		INIT_INI_ARRAY(&ah->iniCommon, ar9287Common_9287_1_1,
+				ARRAY_SIZE(ar9287Common_9287_1_1), 2);
+		if (ah->config.pcie_clock_req)
+			INIT_INI_ARRAY(&ah->iniPcieSerdes,
+			ar9287PciePhy_clkreq_off_L1_9287_1_1,
+			ARRAY_SIZE(ar9287PciePhy_clkreq_off_L1_9287_1_1), 2);
+		else
+			INIT_INI_ARRAY(&ah->iniPcieSerdes,
+			ar9287PciePhy_clkreq_always_on_L1_9287_1_1,
+			ARRAY_SIZE(ar9287PciePhy_clkreq_always_on_L1_9287_1_1),
+					2);
+	} else if (AR_SREV_9287_10_OR_LATER(ah)) {
+		INIT_INI_ARRAY(&ah->iniModes, ar9287Modes_9287_1_0,
+				ARRAY_SIZE(ar9287Modes_9287_1_0), 6);
+		INIT_INI_ARRAY(&ah->iniCommon, ar9287Common_9287_1_0,
+				ARRAY_SIZE(ar9287Common_9287_1_0), 2);
+
+		if (ah->config.pcie_clock_req)
+			INIT_INI_ARRAY(&ah->iniPcieSerdes,
+			ar9287PciePhy_clkreq_off_L1_9287_1_0,
+			ARRAY_SIZE(ar9287PciePhy_clkreq_off_L1_9287_1_0), 2);
+		else
+			INIT_INI_ARRAY(&ah->iniPcieSerdes,
+			ar9287PciePhy_clkreq_always_on_L1_9287_1_0,
+			ARRAY_SIZE(ar9287PciePhy_clkreq_always_on_L1_9287_1_0),
+				  2);
+	} else if (AR_SREV_9285_12_OR_LATER(ah)) {
+
+
+		INIT_INI_ARRAY(&ah->iniModes, ar9285Modes_9285_1_2,
+			       ARRAY_SIZE(ar9285Modes_9285_1_2), 6);
+		INIT_INI_ARRAY(&ah->iniCommon, ar9285Common_9285_1_2,
+			       ARRAY_SIZE(ar9285Common_9285_1_2), 2);
+
+		if (ah->config.pcie_clock_req) {
+			INIT_INI_ARRAY(&ah->iniPcieSerdes,
+			ar9285PciePhy_clkreq_off_L1_9285_1_2,
+			ARRAY_SIZE(ar9285PciePhy_clkreq_off_L1_9285_1_2), 2);
+		} else {
+			INIT_INI_ARRAY(&ah->iniPcieSerdes,
+			ar9285PciePhy_clkreq_always_on_L1_9285_1_2,
+			ARRAY_SIZE(ar9285PciePhy_clkreq_always_on_L1_9285_1_2),
+				  2);
+		}
+	} else if (AR_SREV_9285_10_OR_LATER(ah)) {
+		INIT_INI_ARRAY(&ah->iniModes, ar9285Modes_9285,
+			       ARRAY_SIZE(ar9285Modes_9285), 6);
+		INIT_INI_ARRAY(&ah->iniCommon, ar9285Common_9285,
+			       ARRAY_SIZE(ar9285Common_9285), 2);
+
+		if (ah->config.pcie_clock_req) {
+			INIT_INI_ARRAY(&ah->iniPcieSerdes,
+			ar9285PciePhy_clkreq_off_L1_9285,
+			ARRAY_SIZE(ar9285PciePhy_clkreq_off_L1_9285), 2);
+		} else {
+			INIT_INI_ARRAY(&ah->iniPcieSerdes,
+			ar9285PciePhy_clkreq_always_on_L1_9285,
+			ARRAY_SIZE(ar9285PciePhy_clkreq_always_on_L1_9285), 2);
+		}
+	} else if (AR_SREV_9280_20_OR_LATER(ah)) {
+		INIT_INI_ARRAY(&ah->iniModes, ar9280Modes_9280_2,
+			       ARRAY_SIZE(ar9280Modes_9280_2), 6);
+		INIT_INI_ARRAY(&ah->iniCommon, ar9280Common_9280_2,
+			       ARRAY_SIZE(ar9280Common_9280_2), 2);
+
+		if (ah->config.pcie_clock_req) {
+			INIT_INI_ARRAY(&ah->iniPcieSerdes,
+			       ar9280PciePhy_clkreq_off_L1_9280,
+			       ARRAY_SIZE(ar9280PciePhy_clkreq_off_L1_9280),2);
+		} else {
+			INIT_INI_ARRAY(&ah->iniPcieSerdes,
+			       ar9280PciePhy_clkreq_always_on_L1_9280,
+			       ARRAY_SIZE(ar9280PciePhy_clkreq_always_on_L1_9280), 2);
+		}
+		INIT_INI_ARRAY(&ah->iniModesAdditional,
+			       ar9280Modes_fast_clock_9280_2,
+			       ARRAY_SIZE(ar9280Modes_fast_clock_9280_2), 3);
+	} else if (AR_SREV_9280_10_OR_LATER(ah)) {
+		INIT_INI_ARRAY(&ah->iniModes, ar9280Modes_9280,
+			       ARRAY_SIZE(ar9280Modes_9280), 6);
+		INIT_INI_ARRAY(&ah->iniCommon, ar9280Common_9280,
+			       ARRAY_SIZE(ar9280Common_9280), 2);
+	} else if (AR_SREV_9160_10_OR_LATER(ah)) {
+		INIT_INI_ARRAY(&ah->iniModes, ar5416Modes_9160,
+			       ARRAY_SIZE(ar5416Modes_9160), 6);
+		INIT_INI_ARRAY(&ah->iniCommon, ar5416Common_9160,
+			       ARRAY_SIZE(ar5416Common_9160), 2);
+		INIT_INI_ARRAY(&ah->iniBank0, ar5416Bank0_9160,
+			       ARRAY_SIZE(ar5416Bank0_9160), 2);
+		INIT_INI_ARRAY(&ah->iniBB_RfGain, ar5416BB_RfGain_9160,
+			       ARRAY_SIZE(ar5416BB_RfGain_9160), 3);
+		INIT_INI_ARRAY(&ah->iniBank1, ar5416Bank1_9160,
+			       ARRAY_SIZE(ar5416Bank1_9160), 2);
+		INIT_INI_ARRAY(&ah->iniBank2, ar5416Bank2_9160,
+			       ARRAY_SIZE(ar5416Bank2_9160), 2);
+		INIT_INI_ARRAY(&ah->iniBank3, ar5416Bank3_9160,
+			       ARRAY_SIZE(ar5416Bank3_9160), 3);
+		INIT_INI_ARRAY(&ah->iniBank6, ar5416Bank6_9160,
+			       ARRAY_SIZE(ar5416Bank6_9160), 3);
+		INIT_INI_ARRAY(&ah->iniBank6TPC, ar5416Bank6TPC_9160,
+			       ARRAY_SIZE(ar5416Bank6TPC_9160), 3);
+		INIT_INI_ARRAY(&ah->iniBank7, ar5416Bank7_9160,
+			       ARRAY_SIZE(ar5416Bank7_9160), 2);
+		if (AR_SREV_9160_11(ah)) {
+			INIT_INI_ARRAY(&ah->iniAddac,
+				       ar5416Addac_91601_1,
+				       ARRAY_SIZE(ar5416Addac_91601_1), 2);
+		} else {
+			INIT_INI_ARRAY(&ah->iniAddac, ar5416Addac_9160,
+				       ARRAY_SIZE(ar5416Addac_9160), 2);
+		}
+	} else if (AR_SREV_9100_OR_LATER(ah)) {
+		INIT_INI_ARRAY(&ah->iniModes, ar5416Modes_9100,
+			       ARRAY_SIZE(ar5416Modes_9100), 6);
+		INIT_INI_ARRAY(&ah->iniCommon, ar5416Common_9100,
+			       ARRAY_SIZE(ar5416Common_9100), 2);
+		INIT_INI_ARRAY(&ah->iniBank0, ar5416Bank0_9100,
+			       ARRAY_SIZE(ar5416Bank0_9100), 2);
+		INIT_INI_ARRAY(&ah->iniBB_RfGain, ar5416BB_RfGain_9100,
+			       ARRAY_SIZE(ar5416BB_RfGain_9100), 3);
+		INIT_INI_ARRAY(&ah->iniBank1, ar5416Bank1_9100,
+			       ARRAY_SIZE(ar5416Bank1_9100), 2);
+		INIT_INI_ARRAY(&ah->iniBank2, ar5416Bank2_9100,
+			       ARRAY_SIZE(ar5416Bank2_9100), 2);
+		INIT_INI_ARRAY(&ah->iniBank3, ar5416Bank3_9100,
+			       ARRAY_SIZE(ar5416Bank3_9100), 3);
+		INIT_INI_ARRAY(&ah->iniBank6, ar5416Bank6_9100,
+			       ARRAY_SIZE(ar5416Bank6_9100), 3);
+		INIT_INI_ARRAY(&ah->iniBank6TPC, ar5416Bank6TPC_9100,
+			       ARRAY_SIZE(ar5416Bank6TPC_9100), 3);
+		INIT_INI_ARRAY(&ah->iniBank7, ar5416Bank7_9100,
+			       ARRAY_SIZE(ar5416Bank7_9100), 2);
+		INIT_INI_ARRAY(&ah->iniAddac, ar5416Addac_9100,
+			       ARRAY_SIZE(ar5416Addac_9100), 2);
+	} else {
+		INIT_INI_ARRAY(&ah->iniModes, ar5416Modes,
+			       ARRAY_SIZE(ar5416Modes), 6);
+		INIT_INI_ARRAY(&ah->iniCommon, ar5416Common,
+			       ARRAY_SIZE(ar5416Common), 2);
+		INIT_INI_ARRAY(&ah->iniBank0, ar5416Bank0,
+			       ARRAY_SIZE(ar5416Bank0), 2);
+		INIT_INI_ARRAY(&ah->iniBB_RfGain, ar5416BB_RfGain,
+			       ARRAY_SIZE(ar5416BB_RfGain), 3);
+		INIT_INI_ARRAY(&ah->iniBank1, ar5416Bank1,
+			       ARRAY_SIZE(ar5416Bank1), 2);
+		INIT_INI_ARRAY(&ah->iniBank2, ar5416Bank2,
+			       ARRAY_SIZE(ar5416Bank2), 2);
+		INIT_INI_ARRAY(&ah->iniBank3, ar5416Bank3,
+			       ARRAY_SIZE(ar5416Bank3), 3);
+		INIT_INI_ARRAY(&ah->iniBank6, ar5416Bank6,
+			       ARRAY_SIZE(ar5416Bank6), 3);
+		INIT_INI_ARRAY(&ah->iniBank6TPC, ar5416Bank6TPC,
+			       ARRAY_SIZE(ar5416Bank6TPC), 3);
+		INIT_INI_ARRAY(&ah->iniBank7, ar5416Bank7,
+			       ARRAY_SIZE(ar5416Bank7), 2);
+		INIT_INI_ARRAY(&ah->iniAddac, ar5416Addac,
+			       ARRAY_SIZE(ar5416Addac), 2);
+	}
+}
+
+static void ar9002_hw_read_revisions(struct ath_hw *ah)
+{
+	u32 val;
+
+	val = REG_READ(ah, AR_SREV) & AR_SREV_ID;
+
+	if (val == 0xFF) {
+		val = REG_READ(ah, AR_SREV);
+		ah->hw_version.macVersion =
+			(val & AR_SREV_VERSION2) >> AR_SREV_TYPE2_S;
+		ah->hw_version.macRev = MS(val, AR_SREV_REVISION2);
+		ah->is_pciexpress = (val & AR_SREV_TYPE2_HOST_MODE) ? 0 : 1;
+	} else {
+		if (!AR_SREV_9100(ah))
+			ah->hw_version.macVersion = MS(val, AR_SREV_VERSION);
+
+		ah->hw_version.macRev = val & AR_SREV_REVISION;
+
+		if (ah->hw_version.macVersion == AR_SREV_VERSION_5416_PCIE)
+			ah->is_pciexpress = true;
+	}
+}
+
+static bool ar9002_hw_set_reset(struct ath_hw *ah, int type)
+{
+	u32 rst_flags;
+	u32 tmpReg;
+
+	if (AR_SREV_9100(ah)) {
+		u32 val = REG_READ(ah, AR_RTC_DERIVED_CLK);
+		val &= ~AR_RTC_DERIVED_CLK_PERIOD;
+		val |= SM(1, AR_RTC_DERIVED_CLK_PERIOD);
+		REG_WRITE(ah, AR_RTC_DERIVED_CLK, val);
+		(void)REG_READ(ah, AR_RTC_DERIVED_CLK);
+	}
+
+	REG_WRITE(ah, AR_RTC_FORCE_WAKE, AR_RTC_FORCE_WAKE_EN |
+		  AR_RTC_FORCE_WAKE_ON_INT);
+
+	if (AR_SREV_9100(ah)) {
+		rst_flags = AR_RTC_RC_MAC_WARM | AR_RTC_RC_MAC_COLD |
+			AR_RTC_RC_COLD_RESET | AR_RTC_RC_WARM_RESET;
+	} else {
+		tmpReg = REG_READ(ah, AR_INTR_SYNC_CAUSE);
+		if (tmpReg &
+		    (AR_INTR_SYNC_LOCAL_TIMEOUT |
+		     AR_INTR_SYNC_RADM_CPL_TIMEOUT)) {
+			REG_WRITE(ah, AR_INTR_SYNC_ENABLE, 0);
+			REG_WRITE(ah, AR_RC, AR_RC_AHB | AR_RC_HOSTIF);
+		} else {
+			REG_WRITE(ah, AR_RC, AR_RC_AHB);
+		}
+
+		rst_flags = AR_RTC_RC_MAC_WARM;
+		if (type == ATH9K_RESET_COLD)
+			rst_flags |= AR_RTC_RC_MAC_COLD;
+	}
+
+	REG_WRITE(ah, AR_RTC_RC, rst_flags);
+	udelay(50);
+
+	REG_WRITE(ah, AR_RTC_RC, 0);
+	if (!ath9k_hw_wait(ah, AR_RTC_RC, AR_RTC_RC_M, 0, AH_WAIT_TIMEOUT)) {
+		ath_print(ath9k_hw_common(ah), ATH_DBG_RESET,
+			  "RTC stuck in MAC reset\n");
+		return false;
+	}
+
+	if (!AR_SREV_9100(ah))
+		REG_WRITE(ah, AR_RC, 0);
+
+	if (AR_SREV_9100(ah))
+		udelay(50);
+
+	return true;
+}
+
+static bool ar9002_hw_set_reset_power_on(struct ath_hw *ah)
+{
+	REG_WRITE(ah, AR_RTC_FORCE_WAKE, AR_RTC_FORCE_WAKE_EN |
+		  AR_RTC_FORCE_WAKE_ON_INT);
+
+	if (!AR_SREV_9100(ah))
+		REG_WRITE(ah, AR_RC, AR_RC_AHB);
+
+	REG_WRITE(ah, AR_RTC_RESET, 0);
+	udelay(2);
+
+	if (!AR_SREV_9100(ah))
+		REG_WRITE(ah, AR_RC, 0);
+
+	REG_WRITE(ah, AR_RTC_RESET, 1);
+
+	if (!ath9k_hw_wait(ah,
+			   AR_RTC_STATUS,
+			   AR_RTC_STATUS_M,
+			   AR_RTC_STATUS_ON,
+			   AH_WAIT_TIMEOUT)) {
+		ath_print(ath9k_hw_common(ah), ATH_DBG_RESET,
+			  "RTC not waking up\n");
+		return false;
+	}
+
+	ar9002_hw_read_revisions(ah);
+
+	return ar9002_hw_set_reset(ah, ATH9K_RESET_WARM);
+}
+
+static bool ar9002_hw_set_reset_reg(struct ath_hw *ah, u32 type)
+{
+	REG_WRITE(ah, AR_RTC_FORCE_WAKE,
+		  AR_RTC_FORCE_WAKE_EN | AR_RTC_FORCE_WAKE_ON_INT);
+
+	switch (type) {
+	case ATH9K_RESET_POWER_ON:
+		return ar9002_hw_set_reset_power_on(ah);
+	case ATH9K_RESET_WARM:
+	case ATH9K_RESET_COLD:
+		return ar9002_hw_set_reset(ah, type);
+	default:
+		return false;
+	}
+}
+
+static void ar9002_hw_init_pll(struct ath_hw *ah,
+			      struct ath9k_channel *chan)
+{
+	u32 pll;
+
+	if (AR_SREV_9100(ah)) {
+		if (chan && IS_CHAN_5GHZ(chan))
+			pll = 0x1450;
+		else
+			pll = 0x1458;
+	} else {
+		if (AR_SREV_9280_10_OR_LATER(ah)) {
+			pll = SM(0x5, AR_RTC_9160_PLL_REFDIV);
+
+			if (chan && IS_CHAN_HALF_RATE(chan))
+				pll |= SM(0x1, AR_RTC_9160_PLL_CLKSEL);
+			else if (chan && IS_CHAN_QUARTER_RATE(chan))
+				pll |= SM(0x2, AR_RTC_9160_PLL_CLKSEL);
+
+			if (chan && IS_CHAN_5GHZ(chan)) {
+				pll |= SM(0x28, AR_RTC_9160_PLL_DIV);
+
+
+				if (AR_SREV_9280_20(ah)) {
+					if (((chan->channel % 20) == 0)
+					    || ((chan->channel % 10) == 0))
+						pll = 0x2850;
+					else
+						pll = 0x142c;
+				}
+			} else {
+				pll |= SM(0x2c, AR_RTC_9160_PLL_DIV);
+			}
+
+		} else if (AR_SREV_9160_10_OR_LATER(ah)) {
+
+			pll = SM(0x5, AR_RTC_9160_PLL_REFDIV);
+
+			if (chan && IS_CHAN_HALF_RATE(chan))
+				pll |= SM(0x1, AR_RTC_9160_PLL_CLKSEL);
+			else if (chan && IS_CHAN_QUARTER_RATE(chan))
+				pll |= SM(0x2, AR_RTC_9160_PLL_CLKSEL);
+
+			if (chan && IS_CHAN_5GHZ(chan))
+				pll |= SM(0x50, AR_RTC_9160_PLL_DIV);
+			else
+				pll |= SM(0x58, AR_RTC_9160_PLL_DIV);
+		} else {
+			pll = AR_RTC_PLL_REFDIV_5 | AR_RTC_PLL_DIV2;
+
+			if (chan && IS_CHAN_HALF_RATE(chan))
+				pll |= SM(0x1, AR_RTC_PLL_CLKSEL);
+			else if (chan && IS_CHAN_QUARTER_RATE(chan))
+				pll |= SM(0x2, AR_RTC_PLL_CLKSEL);
+
+			if (chan && IS_CHAN_5GHZ(chan))
+				pll |= SM(0xa, AR_RTC_PLL_DIV);
+			else
+				pll |= SM(0xb, AR_RTC_PLL_DIV);
+		}
+	}
+	REG_WRITE(ah, AR_RTC_PLL_CONTROL, pll);
+
+	/* Switch the core clock for ar9271 to 117Mhz */
+	if (AR_SREV_9271(ah)) {
+		udelay(500);
+		REG_WRITE(ah, 0x50040, 0x304);
+	}
+
+	udelay(RTC_PLL_SETTLE_DELAY);
+
+	REG_WRITE(ah, AR_RTC_SLEEP_CLK, AR_RTC_FORCE_DERIVED_CLK);
+}
+
+static bool ar9002_hw_set_power_awake(struct ath_hw *ah, int setChip)
+{
+	u32 val;
+	int i;
+
+	if (setChip) {
+		if ((REG_READ(ah, AR_RTC_STATUS) &
+		     AR_RTC_STATUS_M) == AR_RTC_STATUS_SHUTDOWN) {
+			if (ath9k_hw_set_reset_reg(ah,
+					   ATH9K_RESET_POWER_ON) != true) {
+				return false;
+			}
+			ath9k_hw_init_pll(ah, NULL);
+		}
+		if (AR_SREV_9100(ah))
+			REG_SET_BIT(ah, AR_RTC_RESET,
+				    AR_RTC_RESET_EN);
+
+		REG_SET_BIT(ah, AR_RTC_FORCE_WAKE,
+			    AR_RTC_FORCE_WAKE_EN);
+		udelay(50);
+
+		for (i = POWER_UP_TIME / 50; i > 0; i--) {
+			val = REG_READ(ah, AR_RTC_STATUS) & AR_RTC_STATUS_M;
+			if (val == AR_RTC_STATUS_ON)
+				break;
+			udelay(50);
+			REG_SET_BIT(ah, AR_RTC_FORCE_WAKE,
+				    AR_RTC_FORCE_WAKE_EN);
+		}
+		if (i == 0) {
+			ath_print(ath9k_hw_common(ah), ATH_DBG_FATAL,
+				  "Failed to wakeup in %uus\n",
+				  POWER_UP_TIME / 20);
+			return false;
+		}
+	}
+
+	REG_CLR_BIT(ah, AR_STA_ID1, AR_STA_ID1_PWR_SAV);
+
+	return true;
+}
+
+/******************************/
+/* Power Management (Chipset) */
+/******************************/
+
+static void ath9k_set_power_sleep(struct ath_hw *ah, int setChip)
+{
+	REG_SET_BIT(ah, AR_STA_ID1, AR_STA_ID1_PWR_SAV);
+	if (setChip) {
+		REG_CLR_BIT(ah, AR_RTC_FORCE_WAKE,
+			    AR_RTC_FORCE_WAKE_EN);
+		if (!AR_SREV_9100(ah))
+			REG_WRITE(ah, AR_RC, AR_RC_AHB | AR_RC_HOSTIF);
+
+		if (!AR_SREV_5416(ah) && !AR_SREV_9271(ah))
+			REG_CLR_BIT(ah, (AR_RTC_RESET),
+				    AR_RTC_RESET_EN);
+	}
+}
+
+static void ath9k_set_power_network_sleep(struct ath_hw *ah, int setChip)
+{
+	REG_SET_BIT(ah, AR_STA_ID1, AR_STA_ID1_PWR_SAV);
+	if (setChip) {
+		struct ath9k_hw_capabilities *pCap = &ah->caps;
+
+		if (!(pCap->hw_caps & ATH9K_HW_CAP_AUTOSLEEP)) {
+			REG_WRITE(ah, AR_RTC_FORCE_WAKE,
+				  AR_RTC_FORCE_WAKE_ON_INT);
+		} else {
+			REG_CLR_BIT(ah, AR_RTC_FORCE_WAKE,
+				    AR_RTC_FORCE_WAKE_EN);
+		}
+	}
+}
+
+static bool ar9002_hw_setpower(struct ath_hw *ah, enum ath9k_power_mode mode)
+{
+	struct ath_common *common = ath9k_hw_common(ah);
+	int status = true, setChip = true;
+	static const char *modes[] = {
+		"AWAKE",
+		"FULL-SLEEP",
+		"NETWORK SLEEP",
+		"UNDEFINED"
+	};
+
+	if (ah->power_mode == mode)
+		return status;
+
+	ath_print(common, ATH_DBG_RESET, "%s -> %s\n",
+		  modes[ah->power_mode], modes[mode]);
+
+	switch (mode) {
+	case ATH9K_PM_AWAKE:
+		status = ar9002_hw_set_power_awake(ah, setChip);
+		break;
+	case ATH9K_PM_FULL_SLEEP:
+		ath9k_set_power_sleep(ah, setChip);
+		ah->chip_fullsleep = true;
+		break;
+	case ATH9K_PM_NETWORK_SLEEP:
+		ath9k_set_power_network_sleep(ah, setChip);
+		break;
+	default:
+		ath_print(common, ATH_DBG_FATAL,
+			  "Unknown power mode %u\n", mode);
+		return false;
+	}
+	ah->power_mode = mode;
+
+	return status;
+}
+
+/*
+ * Helper for ASPM support.
+ *
+ * Disable PLL when in L0s as well as receiver clock when in L1.
+ * This power saving option must be enabled through the SerDes.
+ *
+ * Programming the SerDes must go through the same 288 bit serial shift
+ * register as the other analog registers.  Hence the 9 writes.
+ */
+static void ar9002_hw_configpcipowersave(struct ath_hw *ah,
+					 int restore,
+					 int power_off)
+{
+	u8 i;
+	u32 val;
+
+	if (ah->is_pciexpress != true)
+		return;
+
+	/* Do not touch SerDes registers */
+	if (ah->config.pcie_powersave_enable == 2)
+		return;
+
+	/* Nothing to do on restore for 11N */
+	if (!restore) {
+		if (AR_SREV_9280_20_OR_LATER(ah)) {
+			/*
+			 * AR9280 2.0 or later chips use SerDes values from the
+			 * initvals.h initialized depending on chipset during
+			 * __ath9k_hw_init()
+			 */
+			for (i = 0; i < ah->iniPcieSerdes.ia_rows; i++) {
+				REG_WRITE(ah, INI_RA(&ah->iniPcieSerdes, i, 0),
+					  INI_RA(&ah->iniPcieSerdes, i, 1));
+			}
+		} else if (AR_SREV_9280(ah) &&
+			   (ah->hw_version.macRev == AR_SREV_REVISION_9280_10)) {
+			REG_WRITE(ah, AR_PCIE_SERDES, 0x9248fd00);
+			REG_WRITE(ah, AR_PCIE_SERDES, 0x24924924);
+
+			/* RX shut off when elecidle is asserted */
+			REG_WRITE(ah, AR_PCIE_SERDES, 0xa8000019);
+			REG_WRITE(ah, AR_PCIE_SERDES, 0x13160820);
+			REG_WRITE(ah, AR_PCIE_SERDES, 0xe5980560);
+
+			/* Shut off CLKREQ active in L1 */
+			if (ah->config.pcie_clock_req)
+				REG_WRITE(ah, AR_PCIE_SERDES, 0x401deffc);
+			else
+				REG_WRITE(ah, AR_PCIE_SERDES, 0x401deffd);
+
+			REG_WRITE(ah, AR_PCIE_SERDES, 0x1aaabe40);
+			REG_WRITE(ah, AR_PCIE_SERDES, 0xbe105554);
+			REG_WRITE(ah, AR_PCIE_SERDES, 0x00043007);
+
+			/* Load the new settings */
+			REG_WRITE(ah, AR_PCIE_SERDES2, 0x00000000);
+
+		} else {
+			REG_WRITE(ah, AR_PCIE_SERDES, 0x9248fc00);
+			REG_WRITE(ah, AR_PCIE_SERDES, 0x24924924);
+
+			/* RX shut off when elecidle is asserted */
+			REG_WRITE(ah, AR_PCIE_SERDES, 0x28000039);
+			REG_WRITE(ah, AR_PCIE_SERDES, 0x53160824);
+			REG_WRITE(ah, AR_PCIE_SERDES, 0xe5980579);
+
+			/*
+			 * Ignore ah->ah_config.pcie_clock_req setting for
+			 * pre-AR9280 11n
+			 */
+			REG_WRITE(ah, AR_PCIE_SERDES, 0x001defff);
+
+			REG_WRITE(ah, AR_PCIE_SERDES, 0x1aaabe40);
+			REG_WRITE(ah, AR_PCIE_SERDES, 0xbe105554);
+			REG_WRITE(ah, AR_PCIE_SERDES, 0x000e3007);
+
+			/* Load the new settings */
+			REG_WRITE(ah, AR_PCIE_SERDES2, 0x00000000);
+		}
+
+		udelay(1000);
+
+		/* set bit 19 to allow forcing of pcie core into L1 state */
+		REG_SET_BIT(ah, AR_PCIE_PM_CTRL, AR_PCIE_PM_CTRL_ENA);
+
+		/* Several PCIe massages to ensure proper behaviour */
+		if (ah->config.pcie_waen) {
+			val = ah->config.pcie_waen;
+			if (!power_off)
+				val &= (~AR_WA_D3_L1_DISABLE);
+		} else {
+			if (AR_SREV_9285(ah) || AR_SREV_9271(ah) ||
+			    AR_SREV_9287(ah)) {
+				val = AR9285_WA_DEFAULT;
+				if (!power_off)
+					val &= (~AR_WA_D3_L1_DISABLE);
+			} else if (AR_SREV_9280(ah)) {
+				/*
+				 * On AR9280 chips bit 22 of 0x4004 needs to be
+				 * set otherwise card may disappear.
+				 */
+				val = AR9280_WA_DEFAULT;
+				if (!power_off)
+					val &= (~AR_WA_D3_L1_DISABLE);
+			} else
+				val = AR_WA_DEFAULT;
+		}
+
+		REG_WRITE(ah, AR_WA, val);
+	}
+
+	if (power_off) {
+		/*
+		 * Set PCIe workaround bits
+		 * bit 14 in WA register (disable L1) should only
+		 * be set when device enters D3 and be cleared
+		 * when device comes back to D0.
+		 */
+		if (ah->config.pcie_waen) {
+			if (ah->config.pcie_waen & AR_WA_D3_L1_DISABLE)
+				REG_SET_BIT(ah, AR_WA, AR_WA_D3_L1_DISABLE);
+		} else {
+			if (((AR_SREV_9285(ah) || AR_SREV_9271(ah) ||
+			      AR_SREV_9287(ah)) &&
+			     (AR9285_WA_DEFAULT & AR_WA_D3_L1_DISABLE)) ||
+			    (AR_SREV_9280(ah) &&
+			     (AR9280_WA_DEFAULT & AR_WA_D3_L1_DISABLE))) {
+				REG_SET_BIT(ah, AR_WA, AR_WA_D3_L1_DISABLE);
+			}
+		}
+	}
+}
+
+static void ar9002_hw_init_rxgain_ini(struct ath_hw *ah)
+{
+	u32 rxgain_type;
+
+	if (ah->eep_ops->get_eeprom(ah, EEP_MINOR_REV) >= AR5416_EEP_MINOR_VER_17) {
+		rxgain_type = ah->eep_ops->get_eeprom(ah, EEP_RXGAIN_TYPE);
+
+		if (rxgain_type == AR5416_EEP_RXGAIN_13DB_BACKOFF)
+			INIT_INI_ARRAY(&ah->iniModesRxGain,
+			ar9280Modes_backoff_13db_rxgain_9280_2,
+			ARRAY_SIZE(ar9280Modes_backoff_13db_rxgain_9280_2), 6);
+		else if (rxgain_type == AR5416_EEP_RXGAIN_23DB_BACKOFF)
+			INIT_INI_ARRAY(&ah->iniModesRxGain,
+			ar9280Modes_backoff_23db_rxgain_9280_2,
+			ARRAY_SIZE(ar9280Modes_backoff_23db_rxgain_9280_2), 6);
+		else
+			INIT_INI_ARRAY(&ah->iniModesRxGain,
+			ar9280Modes_original_rxgain_9280_2,
+			ARRAY_SIZE(ar9280Modes_original_rxgain_9280_2), 6);
+	} else {
+		INIT_INI_ARRAY(&ah->iniModesRxGain,
+			ar9280Modes_original_rxgain_9280_2,
+			ARRAY_SIZE(ar9280Modes_original_rxgain_9280_2), 6);
+	}
+}
+
+static void ar9002_hw_init_txgain_ini(struct ath_hw *ah)
+{
+	u32 txgain_type;
+
+	if (ah->eep_ops->get_eeprom(ah, EEP_MINOR_REV) >= AR5416_EEP_MINOR_VER_19) {
+		txgain_type = ah->eep_ops->get_eeprom(ah, EEP_TXGAIN_TYPE);
+
+		if (txgain_type == AR5416_EEP_TXGAIN_HIGH_POWER)
+			INIT_INI_ARRAY(&ah->iniModesTxGain,
+			ar9280Modes_high_power_tx_gain_9280_2,
+			ARRAY_SIZE(ar9280Modes_high_power_tx_gain_9280_2), 6);
+		else
+			INIT_INI_ARRAY(&ah->iniModesTxGain,
+			ar9280Modes_original_tx_gain_9280_2,
+			ARRAY_SIZE(ar9280Modes_original_tx_gain_9280_2), 6);
+	} else {
+		INIT_INI_ARRAY(&ah->iniModesTxGain,
+		ar9280Modes_original_tx_gain_9280_2,
+		ARRAY_SIZE(ar9280Modes_original_tx_gain_9280_2), 6);
+	}
+}
+
+static void ar9002_hw_init_mode_gains(struct ath_hw *ah)
+{
+	if (AR_SREV_9287_11_OR_LATER(ah))
+		INIT_INI_ARRAY(&ah->iniModesRxGain,
+		ar9287Modes_rx_gain_9287_1_1,
+		ARRAY_SIZE(ar9287Modes_rx_gain_9287_1_1), 6);
+	else if (AR_SREV_9287_10(ah))
+		INIT_INI_ARRAY(&ah->iniModesRxGain,
+		ar9287Modes_rx_gain_9287_1_0,
+		ARRAY_SIZE(ar9287Modes_rx_gain_9287_1_0), 6);
+	else if (AR_SREV_9280_20(ah))
+		ar9002_hw_init_rxgain_ini(ah);
+
+	if (AR_SREV_9287_11_OR_LATER(ah)) {
+		INIT_INI_ARRAY(&ah->iniModesTxGain,
+		ar9287Modes_tx_gain_9287_1_1,
+		ARRAY_SIZE(ar9287Modes_tx_gain_9287_1_1), 6);
+	} else if (AR_SREV_9287_10(ah)) {
+		INIT_INI_ARRAY(&ah->iniModesTxGain,
+		ar9287Modes_tx_gain_9287_1_0,
+		ARRAY_SIZE(ar9287Modes_tx_gain_9287_1_0), 6);
+	} else if (AR_SREV_9280_20(ah)) {
+		ar9002_hw_init_txgain_ini(ah);
+	} else if (AR_SREV_9285_12_OR_LATER(ah)) {
+		u32 txgain_type = ah->eep_ops->get_eeprom(ah, EEP_TXGAIN_TYPE);
+
+		/* txgain table */
+		if (txgain_type == AR5416_EEP_TXGAIN_HIGH_POWER) {
+			INIT_INI_ARRAY(&ah->iniModesTxGain,
+			ar9285Modes_high_power_tx_gain_9285_1_2,
+			ARRAY_SIZE(ar9285Modes_high_power_tx_gain_9285_1_2), 6);
+		} else {
+			INIT_INI_ARRAY(&ah->iniModesTxGain,
+			ar9285Modes_original_tx_gain_9285_1_2,
+			ARRAY_SIZE(ar9285Modes_original_tx_gain_9285_1_2), 6);
+		}
+
+	}
+}
+
+/* Support for Japan ch.14 (2484) spread */
+static void ar9002_hw_init_14_spread(struct ath_hw *ah)
+{
+	if (AR_SREV_9287_11_OR_LATER(ah)) {
+		INIT_INI_ARRAY(&ah->iniCckfirNormal,
+		       ar9287Common_normal_cck_fir_coeff_92871_1,
+		       ARRAY_SIZE(ar9287Common_normal_cck_fir_coeff_92871_1), 2);
+		INIT_INI_ARRAY(&ah->iniCckfirJapan2484,
+		       ar9287Common_japan_2484_cck_fir_coeff_92871_1,
+		       ARRAY_SIZE(ar9287Common_japan_2484_cck_fir_coeff_92871_1), 2);
+	}
+}
+
+/* Sets up the AR5008/AR9001/AR9002 hardware familiy callbacks */
+void ar9002_hw_attach_ops(struct ath_hw *ah)
+{
+	struct ath_hw_private_ops *priv_ops = ath9k_hw_private_ops(ah);
+	struct ath_hw_ops *ops = ath9k_hw_ops(ah);
+
+	priv_ops->init_cal_settings = &ar9002_hw_init_cal_settings;
+	priv_ops->init_mode_regs = &ar9002_hw_init_mode_regs;
+	priv_ops->macversion_supported = &ar9002_hw_macversion_supported;
+	priv_ops->set_reset_reg = &ar9002_hw_set_reset_reg;
+	priv_ops->disable_pcie = &ar9002_hw_disablepcie;
+	priv_ops->init_pll = &ar9002_hw_init_pll;
+	priv_ops->init_mode_gains = &ar9002_hw_init_mode_gains;
+	priv_ops->init_14_spread = &ar9002_hw_init_14_spread;
+
+	ops->set_power = &ar9002_hw_setpower;
+	ops->config_pci_powersave = &ar9002_hw_configpcipowersave;
+}
+EXPORT_SYMBOL(ar9002_hw_attach_ops);
diff --git a/drivers/net/wireless/ath/ath9k/hw-ops.h b/drivers/net/wireless/ath/ath9k/hw-ops.h
index 0f9c29d..54bb57f 100644
--- a/drivers/net/wireless/ath/ath9k/hw-ops.h
+++ b/drivers/net/wireless/ath/ath9k/hw-ops.h
@@ -19,7 +19,10 @@
 
 #include "hw.h"
 
-/* Hardware core and driver accessible callbacks */
+/*
+ * Hardware core and driver accessible callbacks. Both hardware code
+ * and the driver core is expected to make use of these calls.
+ */
 
 static inline bool ath9k_hw_setpower(struct ath_hw *ah, enum ath9k_power_mode mode)
 {
@@ -33,4 +36,30 @@ static inline void ath9k_hw_configpcipowersave(struct ath_hw *ah,
 	ath9k_hw_ops(ah)->config_pci_powersave(ah, restore, power_off);
 }
 
+/*
+ * Private common hardware helpers. It is not expected that the core
+ * driver will use any of these calls
+ */
+
+static inline bool ath9k_hw_set_reset_reg(struct ath_hw *ah, u32 type)
+{
+	return ath9k_hw_private_ops(ah)->set_reset_reg(ah, type);
+}
+
+static inline void ath9k_hw_init_pll(struct ath_hw *ah,
+				     struct ath9k_channel *chan)
+{
+	ath9k_hw_private_ops(ah)->init_pll(ah, chan);
+}
+
+static inline void ath9k_hw_init_mode_gains(struct ath_hw *ah)
+{
+	ath9k_hw_private_ops(ah)->init_mode_gains(ah);
+}
+
+static inline void ath9k_hw_init_14_spread(struct ath_hw *ah)
+{
+	ath9k_hw_private_ops(ah)->init_14_spread(ah);
+}
+
 #endif /* ATH9K_HW_OPS_H */
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 7b389a5..2a63b42 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -20,7 +20,6 @@
 #include "hw.h"
 #include "hw-ops.h"
 #include "rc.h"
-#include "initvals.h"
 
 #define ATH9K_CLOCK_RATE_CCK		22
 #define ATH9K_CLOCK_RATE_5GHZ_OFDM	40
@@ -65,11 +64,6 @@ static bool ath9k_hw_macversion_supported(struct ath_hw *ah)
 	return ath9k_hw_private_ops(ah)->macversion_supported(ah->hw_version.macVersion);
 }
 
-static bool ath9k_hw_set_reset_reg(struct ath_hw *ah, u32 type)
-{
-	return ath9k_hw_private_ops(ah)->set_reset_reg(ah, type);
-}
-
 static void ath9k_hw_disablepcie(struct ath_hw *ah)
 {
 	ath9k_hw_private_ops(ah)->disable_pcie(ah);
@@ -239,29 +233,6 @@ void ath9k_hw_get_channel_centers(struct ath_hw *ah,
 /* Chip Revisions */
 /******************/
 
-static void ath9k_hw_read_revisions(struct ath_hw *ah)
-{
-	u32 val;
-
-	val = REG_READ(ah, AR_SREV) & AR_SREV_ID;
-
-	if (val == 0xFF) {
-		val = REG_READ(ah, AR_SREV);
-		ah->hw_version.macVersion =
-			(val & AR_SREV_VERSION2) >> AR_SREV_TYPE2_S;
-		ah->hw_version.macRev = MS(val, AR_SREV_REVISION2);
-		ah->is_pciexpress = (val & AR_SREV_TYPE2_HOST_MODE) ? 0 : 1;
-	} else {
-		if (!AR_SREV_9100(ah))
-			ah->hw_version.macVersion = MS(val, AR_SREV_VERSION);
-
-		ah->hw_version.macRev = val & AR_SREV_REVISION;
-
-		if (ah->hw_version.macVersion == AR_SREV_VERSION_5416_PCIE)
-			ah->is_pciexpress = true;
-	}
-}
-
 static int ath9k_hw_get_radiorev(struct ath_hw *ah)
 {
 	u32 val;
@@ -281,24 +252,6 @@ static int ath9k_hw_get_radiorev(struct ath_hw *ah)
 /* HW Attach, Detach, Init Routines */
 /************************************/
 
-static void ar9002_hw_disablepcie(struct ath_hw *ah)
-{
-	if (AR_SREV_9100(ah))
-		return;
-
-	REG_WRITE(ah, AR_PCIE_SERDES, 0x9248fc00);
-	REG_WRITE(ah, AR_PCIE_SERDES, 0x24924924);
-	REG_WRITE(ah, AR_PCIE_SERDES, 0x28000029);
-	REG_WRITE(ah, AR_PCIE_SERDES, 0x57160824);
-	REG_WRITE(ah, AR_PCIE_SERDES, 0x25980579);
-	REG_WRITE(ah, AR_PCIE_SERDES, 0x00000000);
-	REG_WRITE(ah, AR_PCIE_SERDES, 0x1aaabe40);
-	REG_WRITE(ah, AR_PCIE_SERDES, 0xbe105554);
-	REG_WRITE(ah, AR_PCIE_SERDES, 0x000e1007);
-
-	REG_WRITE(ah, AR_PCIE_SERDES2, 0x00000000);
-}
-
 static bool ath9k_hw_chip_test(struct ath_hw *ah)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
@@ -473,54 +426,6 @@ static int ath9k_hw_init_macaddr(struct ath_hw *ah)
 	return 0;
 }
 
-static void ath9k_hw_init_rxgain_ini(struct ath_hw *ah)
-{
-	u32 rxgain_type;
-
-	if (ah->eep_ops->get_eeprom(ah, EEP_MINOR_REV) >= AR5416_EEP_MINOR_VER_17) {
-		rxgain_type = ah->eep_ops->get_eeprom(ah, EEP_RXGAIN_TYPE);
-
-		if (rxgain_type == AR5416_EEP_RXGAIN_13DB_BACKOFF)
-			INIT_INI_ARRAY(&ah->iniModesRxGain,
-			ar9280Modes_backoff_13db_rxgain_9280_2,
-			ARRAY_SIZE(ar9280Modes_backoff_13db_rxgain_9280_2), 6);
-		else if (rxgain_type == AR5416_EEP_RXGAIN_23DB_BACKOFF)
-			INIT_INI_ARRAY(&ah->iniModesRxGain,
-			ar9280Modes_backoff_23db_rxgain_9280_2,
-			ARRAY_SIZE(ar9280Modes_backoff_23db_rxgain_9280_2), 6);
-		else
-			INIT_INI_ARRAY(&ah->iniModesRxGain,
-			ar9280Modes_original_rxgain_9280_2,
-			ARRAY_SIZE(ar9280Modes_original_rxgain_9280_2), 6);
-	} else {
-		INIT_INI_ARRAY(&ah->iniModesRxGain,
-			ar9280Modes_original_rxgain_9280_2,
-			ARRAY_SIZE(ar9280Modes_original_rxgain_9280_2), 6);
-	}
-}
-
-static void ath9k_hw_init_txgain_ini(struct ath_hw *ah)
-{
-	u32 txgain_type;
-
-	if (ah->eep_ops->get_eeprom(ah, EEP_MINOR_REV) >= AR5416_EEP_MINOR_VER_19) {
-		txgain_type = ah->eep_ops->get_eeprom(ah, EEP_TXGAIN_TYPE);
-
-		if (txgain_type == AR5416_EEP_TXGAIN_HIGH_POWER)
-			INIT_INI_ARRAY(&ah->iniModesTxGain,
-			ar9280Modes_high_power_tx_gain_9280_2,
-			ARRAY_SIZE(ar9280Modes_high_power_tx_gain_9280_2), 6);
-		else
-			INIT_INI_ARRAY(&ah->iniModesTxGain,
-			ar9280Modes_original_tx_gain_9280_2,
-			ARRAY_SIZE(ar9280Modes_original_tx_gain_9280_2), 6);
-	} else {
-		INIT_INI_ARRAY(&ah->iniModesTxGain,
-		ar9280Modes_original_tx_gain_9280_2,
-		ARRAY_SIZE(ar9280Modes_original_tx_gain_9280_2), 6);
-	}
-}
-
 static int ath9k_hw_post_init(struct ath_hw *ah)
 {
 	int ecode;
@@ -561,278 +466,6 @@ static int ath9k_hw_post_init(struct ath_hw *ah)
 	return 0;
 }
 
-static bool ar9002_hw_macversion_supported(u32 macversion)
-{
-	switch (macversion) {
-	case AR_SREV_VERSION_5416_PCI:
-	case AR_SREV_VERSION_5416_PCIE:
-	case AR_SREV_VERSION_9160:
-	case AR_SREV_VERSION_9100:
-	case AR_SREV_VERSION_9280:
-	case AR_SREV_VERSION_9285:
-	case AR_SREV_VERSION_9287:
-	case AR_SREV_VERSION_9271:
-		return true;
-	default:
-		break;
-	}
-	return false;
-}
-
-static void ar9002_hw_init_cal_settings(struct ath_hw *ah)
-{
-	if (AR_SREV_9160_10_OR_LATER(ah)) {
-		if (AR_SREV_9280_10_OR_LATER(ah)) {
-			ah->iq_caldata.calData = &iq_cal_single_sample;
-			ah->adcgain_caldata.calData =
-				&adc_gain_cal_single_sample;
-			ah->adcdc_caldata.calData =
-				&adc_dc_cal_single_sample;
-			ah->adcdc_calinitdata.calData =
-				&adc_init_dc_cal;
-		} else {
-			ah->iq_caldata.calData = &iq_cal_multi_sample;
-			ah->adcgain_caldata.calData =
-				&adc_gain_cal_multi_sample;
-			ah->adcdc_caldata.calData =
-				&adc_dc_cal_multi_sample;
-			ah->adcdc_calinitdata.calData =
-				&adc_init_dc_cal;
-		}
-		ah->supp_cals = ADC_GAIN_CAL | ADC_DC_CAL | IQ_MISMATCH_CAL;
-	}
-}
-
-static void ar9002_hw_init_mode_regs(struct ath_hw *ah)
-{
-	if (AR_SREV_9271(ah)) {
-		INIT_INI_ARRAY(&ah->iniModes, ar9271Modes_9271,
-			       ARRAY_SIZE(ar9271Modes_9271), 6);
-		INIT_INI_ARRAY(&ah->iniCommon, ar9271Common_9271,
-			       ARRAY_SIZE(ar9271Common_9271), 2);
-		INIT_INI_ARRAY(&ah->iniCommon_normal_cck_fir_coeff_9271,
-			       ar9271Common_normal_cck_fir_coeff_9271,
-			       ARRAY_SIZE(ar9271Common_normal_cck_fir_coeff_9271), 2);
-		INIT_INI_ARRAY(&ah->iniCommon_japan_2484_cck_fir_coeff_9271,
-			       ar9271Common_japan_2484_cck_fir_coeff_9271,
-			       ARRAY_SIZE(ar9271Common_japan_2484_cck_fir_coeff_9271), 2);
-		INIT_INI_ARRAY(&ah->iniModes_9271_1_0_only,
-			       ar9271Modes_9271_1_0_only,
-			       ARRAY_SIZE(ar9271Modes_9271_1_0_only), 6);
-		INIT_INI_ARRAY(&ah->iniModes_9271_ANI_reg, ar9271Modes_9271_ANI_reg,
-			       ARRAY_SIZE(ar9271Modes_9271_ANI_reg), 6);
-		INIT_INI_ARRAY(&ah->iniModes_high_power_tx_gain_9271,
-			       ar9271Modes_high_power_tx_gain_9271,
-			       ARRAY_SIZE(ar9271Modes_high_power_tx_gain_9271), 6);
-		INIT_INI_ARRAY(&ah->iniModes_normal_power_tx_gain_9271,
-			       ar9271Modes_normal_power_tx_gain_9271,
-			       ARRAY_SIZE(ar9271Modes_normal_power_tx_gain_9271), 6);
-		return;
-	}
-
-	if (AR_SREV_9287_11_OR_LATER(ah)) {
-		INIT_INI_ARRAY(&ah->iniModes, ar9287Modes_9287_1_1,
-				ARRAY_SIZE(ar9287Modes_9287_1_1), 6);
-		INIT_INI_ARRAY(&ah->iniCommon, ar9287Common_9287_1_1,
-				ARRAY_SIZE(ar9287Common_9287_1_1), 2);
-		if (ah->config.pcie_clock_req)
-			INIT_INI_ARRAY(&ah->iniPcieSerdes,
-			ar9287PciePhy_clkreq_off_L1_9287_1_1,
-			ARRAY_SIZE(ar9287PciePhy_clkreq_off_L1_9287_1_1), 2);
-		else
-			INIT_INI_ARRAY(&ah->iniPcieSerdes,
-			ar9287PciePhy_clkreq_always_on_L1_9287_1_1,
-			ARRAY_SIZE(ar9287PciePhy_clkreq_always_on_L1_9287_1_1),
-					2);
-	} else if (AR_SREV_9287_10_OR_LATER(ah)) {
-		INIT_INI_ARRAY(&ah->iniModes, ar9287Modes_9287_1_0,
-				ARRAY_SIZE(ar9287Modes_9287_1_0), 6);
-		INIT_INI_ARRAY(&ah->iniCommon, ar9287Common_9287_1_0,
-				ARRAY_SIZE(ar9287Common_9287_1_0), 2);
-
-		if (ah->config.pcie_clock_req)
-			INIT_INI_ARRAY(&ah->iniPcieSerdes,
-			ar9287PciePhy_clkreq_off_L1_9287_1_0,
-			ARRAY_SIZE(ar9287PciePhy_clkreq_off_L1_9287_1_0), 2);
-		else
-			INIT_INI_ARRAY(&ah->iniPcieSerdes,
-			ar9287PciePhy_clkreq_always_on_L1_9287_1_0,
-			ARRAY_SIZE(ar9287PciePhy_clkreq_always_on_L1_9287_1_0),
-				  2);
-	} else if (AR_SREV_9285_12_OR_LATER(ah)) {
-
-
-		INIT_INI_ARRAY(&ah->iniModes, ar9285Modes_9285_1_2,
-			       ARRAY_SIZE(ar9285Modes_9285_1_2), 6);
-		INIT_INI_ARRAY(&ah->iniCommon, ar9285Common_9285_1_2,
-			       ARRAY_SIZE(ar9285Common_9285_1_2), 2);
-
-		if (ah->config.pcie_clock_req) {
-			INIT_INI_ARRAY(&ah->iniPcieSerdes,
-			ar9285PciePhy_clkreq_off_L1_9285_1_2,
-			ARRAY_SIZE(ar9285PciePhy_clkreq_off_L1_9285_1_2), 2);
-		} else {
-			INIT_INI_ARRAY(&ah->iniPcieSerdes,
-			ar9285PciePhy_clkreq_always_on_L1_9285_1_2,
-			ARRAY_SIZE(ar9285PciePhy_clkreq_always_on_L1_9285_1_2),
-				  2);
-		}
-	} else if (AR_SREV_9285_10_OR_LATER(ah)) {
-		INIT_INI_ARRAY(&ah->iniModes, ar9285Modes_9285,
-			       ARRAY_SIZE(ar9285Modes_9285), 6);
-		INIT_INI_ARRAY(&ah->iniCommon, ar9285Common_9285,
-			       ARRAY_SIZE(ar9285Common_9285), 2);
-
-		if (ah->config.pcie_clock_req) {
-			INIT_INI_ARRAY(&ah->iniPcieSerdes,
-			ar9285PciePhy_clkreq_off_L1_9285,
-			ARRAY_SIZE(ar9285PciePhy_clkreq_off_L1_9285), 2);
-		} else {
-			INIT_INI_ARRAY(&ah->iniPcieSerdes,
-			ar9285PciePhy_clkreq_always_on_L1_9285,
-			ARRAY_SIZE(ar9285PciePhy_clkreq_always_on_L1_9285), 2);
-		}
-	} else if (AR_SREV_9280_20_OR_LATER(ah)) {
-		INIT_INI_ARRAY(&ah->iniModes, ar9280Modes_9280_2,
-			       ARRAY_SIZE(ar9280Modes_9280_2), 6);
-		INIT_INI_ARRAY(&ah->iniCommon, ar9280Common_9280_2,
-			       ARRAY_SIZE(ar9280Common_9280_2), 2);
-
-		if (ah->config.pcie_clock_req) {
-			INIT_INI_ARRAY(&ah->iniPcieSerdes,
-			       ar9280PciePhy_clkreq_off_L1_9280,
-			       ARRAY_SIZE(ar9280PciePhy_clkreq_off_L1_9280),2);
-		} else {
-			INIT_INI_ARRAY(&ah->iniPcieSerdes,
-			       ar9280PciePhy_clkreq_always_on_L1_9280,
-			       ARRAY_SIZE(ar9280PciePhy_clkreq_always_on_L1_9280), 2);
-		}
-		INIT_INI_ARRAY(&ah->iniModesAdditional,
-			       ar9280Modes_fast_clock_9280_2,
-			       ARRAY_SIZE(ar9280Modes_fast_clock_9280_2), 3);
-	} else if (AR_SREV_9280_10_OR_LATER(ah)) {
-		INIT_INI_ARRAY(&ah->iniModes, ar9280Modes_9280,
-			       ARRAY_SIZE(ar9280Modes_9280), 6);
-		INIT_INI_ARRAY(&ah->iniCommon, ar9280Common_9280,
-			       ARRAY_SIZE(ar9280Common_9280), 2);
-	} else if (AR_SREV_9160_10_OR_LATER(ah)) {
-		INIT_INI_ARRAY(&ah->iniModes, ar5416Modes_9160,
-			       ARRAY_SIZE(ar5416Modes_9160), 6);
-		INIT_INI_ARRAY(&ah->iniCommon, ar5416Common_9160,
-			       ARRAY_SIZE(ar5416Common_9160), 2);
-		INIT_INI_ARRAY(&ah->iniBank0, ar5416Bank0_9160,
-			       ARRAY_SIZE(ar5416Bank0_9160), 2);
-		INIT_INI_ARRAY(&ah->iniBB_RfGain, ar5416BB_RfGain_9160,
-			       ARRAY_SIZE(ar5416BB_RfGain_9160), 3);
-		INIT_INI_ARRAY(&ah->iniBank1, ar5416Bank1_9160,
-			       ARRAY_SIZE(ar5416Bank1_9160), 2);
-		INIT_INI_ARRAY(&ah->iniBank2, ar5416Bank2_9160,
-			       ARRAY_SIZE(ar5416Bank2_9160), 2);
-		INIT_INI_ARRAY(&ah->iniBank3, ar5416Bank3_9160,
-			       ARRAY_SIZE(ar5416Bank3_9160), 3);
-		INIT_INI_ARRAY(&ah->iniBank6, ar5416Bank6_9160,
-			       ARRAY_SIZE(ar5416Bank6_9160), 3);
-		INIT_INI_ARRAY(&ah->iniBank6TPC, ar5416Bank6TPC_9160,
-			       ARRAY_SIZE(ar5416Bank6TPC_9160), 3);
-		INIT_INI_ARRAY(&ah->iniBank7, ar5416Bank7_9160,
-			       ARRAY_SIZE(ar5416Bank7_9160), 2);
-		if (AR_SREV_9160_11(ah)) {
-			INIT_INI_ARRAY(&ah->iniAddac,
-				       ar5416Addac_91601_1,
-				       ARRAY_SIZE(ar5416Addac_91601_1), 2);
-		} else {
-			INIT_INI_ARRAY(&ah->iniAddac, ar5416Addac_9160,
-				       ARRAY_SIZE(ar5416Addac_9160), 2);
-		}
-	} else if (AR_SREV_9100_OR_LATER(ah)) {
-		INIT_INI_ARRAY(&ah->iniModes, ar5416Modes_9100,
-			       ARRAY_SIZE(ar5416Modes_9100), 6);
-		INIT_INI_ARRAY(&ah->iniCommon, ar5416Common_9100,
-			       ARRAY_SIZE(ar5416Common_9100), 2);
-		INIT_INI_ARRAY(&ah->iniBank0, ar5416Bank0_9100,
-			       ARRAY_SIZE(ar5416Bank0_9100), 2);
-		INIT_INI_ARRAY(&ah->iniBB_RfGain, ar5416BB_RfGain_9100,
-			       ARRAY_SIZE(ar5416BB_RfGain_9100), 3);
-		INIT_INI_ARRAY(&ah->iniBank1, ar5416Bank1_9100,
-			       ARRAY_SIZE(ar5416Bank1_9100), 2);
-		INIT_INI_ARRAY(&ah->iniBank2, ar5416Bank2_9100,
-			       ARRAY_SIZE(ar5416Bank2_9100), 2);
-		INIT_INI_ARRAY(&ah->iniBank3, ar5416Bank3_9100,
-			       ARRAY_SIZE(ar5416Bank3_9100), 3);
-		INIT_INI_ARRAY(&ah->iniBank6, ar5416Bank6_9100,
-			       ARRAY_SIZE(ar5416Bank6_9100), 3);
-		INIT_INI_ARRAY(&ah->iniBank6TPC, ar5416Bank6TPC_9100,
-			       ARRAY_SIZE(ar5416Bank6TPC_9100), 3);
-		INIT_INI_ARRAY(&ah->iniBank7, ar5416Bank7_9100,
-			       ARRAY_SIZE(ar5416Bank7_9100), 2);
-		INIT_INI_ARRAY(&ah->iniAddac, ar5416Addac_9100,
-			       ARRAY_SIZE(ar5416Addac_9100), 2);
-	} else {
-		INIT_INI_ARRAY(&ah->iniModes, ar5416Modes,
-			       ARRAY_SIZE(ar5416Modes), 6);
-		INIT_INI_ARRAY(&ah->iniCommon, ar5416Common,
-			       ARRAY_SIZE(ar5416Common), 2);
-		INIT_INI_ARRAY(&ah->iniBank0, ar5416Bank0,
-			       ARRAY_SIZE(ar5416Bank0), 2);
-		INIT_INI_ARRAY(&ah->iniBB_RfGain, ar5416BB_RfGain,
-			       ARRAY_SIZE(ar5416BB_RfGain), 3);
-		INIT_INI_ARRAY(&ah->iniBank1, ar5416Bank1,
-			       ARRAY_SIZE(ar5416Bank1), 2);
-		INIT_INI_ARRAY(&ah->iniBank2, ar5416Bank2,
-			       ARRAY_SIZE(ar5416Bank2), 2);
-		INIT_INI_ARRAY(&ah->iniBank3, ar5416Bank3,
-			       ARRAY_SIZE(ar5416Bank3), 3);
-		INIT_INI_ARRAY(&ah->iniBank6, ar5416Bank6,
-			       ARRAY_SIZE(ar5416Bank6), 3);
-		INIT_INI_ARRAY(&ah->iniBank6TPC, ar5416Bank6TPC,
-			       ARRAY_SIZE(ar5416Bank6TPC), 3);
-		INIT_INI_ARRAY(&ah->iniBank7, ar5416Bank7,
-			       ARRAY_SIZE(ar5416Bank7), 2);
-		INIT_INI_ARRAY(&ah->iniAddac, ar5416Addac,
-			       ARRAY_SIZE(ar5416Addac), 2);
-	}
-}
-
-static void ath9k_hw_init_mode_gain_regs(struct ath_hw *ah)
-{
-	if (AR_SREV_9287_11_OR_LATER(ah))
-		INIT_INI_ARRAY(&ah->iniModesRxGain,
-		ar9287Modes_rx_gain_9287_1_1,
-		ARRAY_SIZE(ar9287Modes_rx_gain_9287_1_1), 6);
-	else if (AR_SREV_9287_10(ah))
-		INIT_INI_ARRAY(&ah->iniModesRxGain,
-		ar9287Modes_rx_gain_9287_1_0,
-		ARRAY_SIZE(ar9287Modes_rx_gain_9287_1_0), 6);
-	else if (AR_SREV_9280_20(ah))
-		ath9k_hw_init_rxgain_ini(ah);
-
-	if (AR_SREV_9287_11_OR_LATER(ah)) {
-		INIT_INI_ARRAY(&ah->iniModesTxGain,
-		ar9287Modes_tx_gain_9287_1_1,
-		ARRAY_SIZE(ar9287Modes_tx_gain_9287_1_1), 6);
-	} else if (AR_SREV_9287_10(ah)) {
-		INIT_INI_ARRAY(&ah->iniModesTxGain,
-		ar9287Modes_tx_gain_9287_1_0,
-		ARRAY_SIZE(ar9287Modes_tx_gain_9287_1_0), 6);
-	} else if (AR_SREV_9280_20(ah)) {
-		ath9k_hw_init_txgain_ini(ah);
-	} else if (AR_SREV_9285_12_OR_LATER(ah)) {
-		u32 txgain_type = ah->eep_ops->get_eeprom(ah, EEP_TXGAIN_TYPE);
-
-		/* txgain table */
-		if (txgain_type == AR5416_EEP_TXGAIN_HIGH_POWER) {
-			INIT_INI_ARRAY(&ah->iniModesTxGain,
-			ar9285Modes_high_power_tx_gain_9285_1_2,
-			ARRAY_SIZE(ar9285Modes_high_power_tx_gain_9285_1_2), 6);
-		} else {
-			INIT_INI_ARRAY(&ah->iniModesTxGain,
-			ar9285Modes_original_tx_gain_9285_1_2,
-			ARRAY_SIZE(ar9285Modes_original_tx_gain_9285_1_2), 6);
-		}
-
-	}
-}
-
 static void ath9k_hw_init_eeprom_fix(struct ath_hw *ah)
 {
 	u32 i, j;
@@ -933,21 +566,13 @@ int __ath9k_hw_init(struct ath_hw *ah)
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
+	ath9k_hw_init_14_spread(ah);
 
 	r = ath9k_hw_post_init(ah);
 	if (r)
 		return r;
 
-	ath9k_hw_init_mode_gain_regs(ah);
+	ath9k_hw_init_mode_gains(ah);
 	r = ath9k_hw_fill_cap_info(ah);
 	if (r)
 		return r;
@@ -1049,80 +674,6 @@ static void ath9k_hw_init_qos(struct ath_hw *ah)
 	REG_WRITE(ah, AR_TXOP_12_15, 0xFFFFFFFF);
 }
 
-static void ath9k_hw_init_pll(struct ath_hw *ah,
-			      struct ath9k_channel *chan)
-{
-	u32 pll;
-
-	if (AR_SREV_9100(ah)) {
-		if (chan && IS_CHAN_5GHZ(chan))
-			pll = 0x1450;
-		else
-			pll = 0x1458;
-	} else {
-		if (AR_SREV_9280_10_OR_LATER(ah)) {
-			pll = SM(0x5, AR_RTC_9160_PLL_REFDIV);
-
-			if (chan && IS_CHAN_HALF_RATE(chan))
-				pll |= SM(0x1, AR_RTC_9160_PLL_CLKSEL);
-			else if (chan && IS_CHAN_QUARTER_RATE(chan))
-				pll |= SM(0x2, AR_RTC_9160_PLL_CLKSEL);
-
-			if (chan && IS_CHAN_5GHZ(chan)) {
-				pll |= SM(0x28, AR_RTC_9160_PLL_DIV);
-
-
-				if (AR_SREV_9280_20(ah)) {
-					if (((chan->channel % 20) == 0)
-					    || ((chan->channel % 10) == 0))
-						pll = 0x2850;
-					else
-						pll = 0x142c;
-				}
-			} else {
-				pll |= SM(0x2c, AR_RTC_9160_PLL_DIV);
-			}
-
-		} else if (AR_SREV_9160_10_OR_LATER(ah)) {
-
-			pll = SM(0x5, AR_RTC_9160_PLL_REFDIV);
-
-			if (chan && IS_CHAN_HALF_RATE(chan))
-				pll |= SM(0x1, AR_RTC_9160_PLL_CLKSEL);
-			else if (chan && IS_CHAN_QUARTER_RATE(chan))
-				pll |= SM(0x2, AR_RTC_9160_PLL_CLKSEL);
-
-			if (chan && IS_CHAN_5GHZ(chan))
-				pll |= SM(0x50, AR_RTC_9160_PLL_DIV);
-			else
-				pll |= SM(0x58, AR_RTC_9160_PLL_DIV);
-		} else {
-			pll = AR_RTC_PLL_REFDIV_5 | AR_RTC_PLL_DIV2;
-
-			if (chan && IS_CHAN_HALF_RATE(chan))
-				pll |= SM(0x1, AR_RTC_PLL_CLKSEL);
-			else if (chan && IS_CHAN_QUARTER_RATE(chan))
-				pll |= SM(0x2, AR_RTC_PLL_CLKSEL);
-
-			if (chan && IS_CHAN_5GHZ(chan))
-				pll |= SM(0xa, AR_RTC_PLL_DIV);
-			else
-				pll |= SM(0xb, AR_RTC_PLL_DIV);
-		}
-	}
-	REG_WRITE(ah, AR_RTC_PLL_CONTROL, pll);
-
-	/* Switch the core clock for ar9271 to 117Mhz */
-	if (AR_SREV_9271(ah)) {
-		udelay(500);
-		REG_WRITE(ah, 0x50040, 0x304);
-	}
-
-	udelay(RTC_PLL_SETTLE_DELAY);
-
-	REG_WRITE(ah, AR_RTC_SLEEP_CLK, AR_RTC_FORCE_DERIVED_CLK);
-}
-
 static void ath9k_hw_init_chain_masks(struct ath_hw *ah)
 {
 	int rx_chainmask, tx_chainmask;
@@ -1717,107 +1268,6 @@ static void ath9k_hw_set_delta_slope(struct ath_hw *ah,
 		      AR_PHY_HALFGI_DSC_EXP, ds_coef_exp);
 }
 
-static bool ath9k_hw_set_reset(struct ath_hw *ah, int type)
-{
-	u32 rst_flags;
-	u32 tmpReg;
-
-	if (AR_SREV_9100(ah)) {
-		u32 val = REG_READ(ah, AR_RTC_DERIVED_CLK);
-		val &= ~AR_RTC_DERIVED_CLK_PERIOD;
-		val |= SM(1, AR_RTC_DERIVED_CLK_PERIOD);
-		REG_WRITE(ah, AR_RTC_DERIVED_CLK, val);
-		(void)REG_READ(ah, AR_RTC_DERIVED_CLK);
-	}
-
-	REG_WRITE(ah, AR_RTC_FORCE_WAKE, AR_RTC_FORCE_WAKE_EN |
-		  AR_RTC_FORCE_WAKE_ON_INT);
-
-	if (AR_SREV_9100(ah)) {
-		rst_flags = AR_RTC_RC_MAC_WARM | AR_RTC_RC_MAC_COLD |
-			AR_RTC_RC_COLD_RESET | AR_RTC_RC_WARM_RESET;
-	} else {
-		tmpReg = REG_READ(ah, AR_INTR_SYNC_CAUSE);
-		if (tmpReg &
-		    (AR_INTR_SYNC_LOCAL_TIMEOUT |
-		     AR_INTR_SYNC_RADM_CPL_TIMEOUT)) {
-			REG_WRITE(ah, AR_INTR_SYNC_ENABLE, 0);
-			REG_WRITE(ah, AR_RC, AR_RC_AHB | AR_RC_HOSTIF);
-		} else {
-			REG_WRITE(ah, AR_RC, AR_RC_AHB);
-		}
-
-		rst_flags = AR_RTC_RC_MAC_WARM;
-		if (type == ATH9K_RESET_COLD)
-			rst_flags |= AR_RTC_RC_MAC_COLD;
-	}
-
-	REG_WRITE(ah, AR_RTC_RC, rst_flags);
-	udelay(50);
-
-	REG_WRITE(ah, AR_RTC_RC, 0);
-	if (!ath9k_hw_wait(ah, AR_RTC_RC, AR_RTC_RC_M, 0, AH_WAIT_TIMEOUT)) {
-		ath_print(ath9k_hw_common(ah), ATH_DBG_RESET,
-			  "RTC stuck in MAC reset\n");
-		return false;
-	}
-
-	if (!AR_SREV_9100(ah))
-		REG_WRITE(ah, AR_RC, 0);
-
-	if (AR_SREV_9100(ah))
-		udelay(50);
-
-	return true;
-}
-
-static bool ath9k_hw_set_reset_power_on(struct ath_hw *ah)
-{
-	REG_WRITE(ah, AR_RTC_FORCE_WAKE, AR_RTC_FORCE_WAKE_EN |
-		  AR_RTC_FORCE_WAKE_ON_INT);
-
-	if (!AR_SREV_9100(ah))
-		REG_WRITE(ah, AR_RC, AR_RC_AHB);
-
-	REG_WRITE(ah, AR_RTC_RESET, 0);
-	udelay(2);
-
-	if (!AR_SREV_9100(ah))
-		REG_WRITE(ah, AR_RC, 0);
-
-	REG_WRITE(ah, AR_RTC_RESET, 1);
-
-	if (!ath9k_hw_wait(ah,
-			   AR_RTC_STATUS,
-			   AR_RTC_STATUS_M,
-			   AR_RTC_STATUS_ON,
-			   AH_WAIT_TIMEOUT)) {
-		ath_print(ath9k_hw_common(ah), ATH_DBG_RESET,
-			  "RTC not waking up\n");
-		return false;
-	}
-
-	ath9k_hw_read_revisions(ah);
-
-	return ath9k_hw_set_reset(ah, ATH9K_RESET_WARM);
-}
-
-static bool ar9002_hw_set_reset_reg(struct ath_hw *ah, u32 type)
-{
-	REG_WRITE(ah, AR_RTC_FORCE_WAKE,
-		  AR_RTC_FORCE_WAKE_EN | AR_RTC_FORCE_WAKE_ON_INT);
-
-	switch (type) {
-	case ATH9K_RESET_POWER_ON:
-		return ath9k_hw_set_reset_power_on(ah);
-	case ATH9K_RESET_WARM:
-	case ATH9K_RESET_COLD:
-		return ath9k_hw_set_reset(ah, type);
-	default:
-		return false;
-	}
-}
-
 static void ath9k_hw_set_regs(struct ath_hw *ah, struct ath9k_channel *chan)
 {
 	u32 phymode;
@@ -2453,256 +1903,6 @@ bool ath9k_hw_keyisvalid(struct ath_hw *ah, u16 entry)
 }
 EXPORT_SYMBOL(ath9k_hw_keyisvalid);
 
-/******************************/
-/* Power Management (Chipset) */
-/******************************/
-
-static void ath9k_set_power_sleep(struct ath_hw *ah, int setChip)
-{
-	REG_SET_BIT(ah, AR_STA_ID1, AR_STA_ID1_PWR_SAV);
-	if (setChip) {
-		REG_CLR_BIT(ah, AR_RTC_FORCE_WAKE,
-			    AR_RTC_FORCE_WAKE_EN);
-		if (!AR_SREV_9100(ah))
-			REG_WRITE(ah, AR_RC, AR_RC_AHB | AR_RC_HOSTIF);
-
-		if (!AR_SREV_5416(ah) && !AR_SREV_9271(ah))
-			REG_CLR_BIT(ah, (AR_RTC_RESET),
-				    AR_RTC_RESET_EN);
-	}
-}
-
-static void ath9k_set_power_network_sleep(struct ath_hw *ah, int setChip)
-{
-	REG_SET_BIT(ah, AR_STA_ID1, AR_STA_ID1_PWR_SAV);
-	if (setChip) {
-		struct ath9k_hw_capabilities *pCap = &ah->caps;
-
-		if (!(pCap->hw_caps & ATH9K_HW_CAP_AUTOSLEEP)) {
-			REG_WRITE(ah, AR_RTC_FORCE_WAKE,
-				  AR_RTC_FORCE_WAKE_ON_INT);
-		} else {
-			REG_CLR_BIT(ah, AR_RTC_FORCE_WAKE,
-				    AR_RTC_FORCE_WAKE_EN);
-		}
-	}
-}
-
-static bool ath9k_hw_set_power_awake(struct ath_hw *ah, int setChip)
-{
-	u32 val;
-	int i;
-
-	if (setChip) {
-		if ((REG_READ(ah, AR_RTC_STATUS) &
-		     AR_RTC_STATUS_M) == AR_RTC_STATUS_SHUTDOWN) {
-			if (ath9k_hw_set_reset_reg(ah,
-					   ATH9K_RESET_POWER_ON) != true) {
-				return false;
-			}
-			ath9k_hw_init_pll(ah, NULL);
-		}
-		if (AR_SREV_9100(ah))
-			REG_SET_BIT(ah, AR_RTC_RESET,
-				    AR_RTC_RESET_EN);
-
-		REG_SET_BIT(ah, AR_RTC_FORCE_WAKE,
-			    AR_RTC_FORCE_WAKE_EN);
-		udelay(50);
-
-		for (i = POWER_UP_TIME / 50; i > 0; i--) {
-			val = REG_READ(ah, AR_RTC_STATUS) & AR_RTC_STATUS_M;
-			if (val == AR_RTC_STATUS_ON)
-				break;
-			udelay(50);
-			REG_SET_BIT(ah, AR_RTC_FORCE_WAKE,
-				    AR_RTC_FORCE_WAKE_EN);
-		}
-		if (i == 0) {
-			ath_print(ath9k_hw_common(ah), ATH_DBG_FATAL,
-				  "Failed to wakeup in %uus\n",
-				  POWER_UP_TIME / 20);
-			return false;
-		}
-	}
-
-	REG_CLR_BIT(ah, AR_STA_ID1, AR_STA_ID1_PWR_SAV);
-
-	return true;
-}
-
-static bool ar9002_hw_setpower(struct ath_hw *ah, enum ath9k_power_mode mode)
-{
-	struct ath_common *common = ath9k_hw_common(ah);
-	int status = true, setChip = true;
-	static const char *modes[] = {
-		"AWAKE",
-		"FULL-SLEEP",
-		"NETWORK SLEEP",
-		"UNDEFINED"
-	};
-
-	if (ah->power_mode == mode)
-		return status;
-
-	ath_print(common, ATH_DBG_RESET, "%s -> %s\n",
-		  modes[ah->power_mode], modes[mode]);
-
-	switch (mode) {
-	case ATH9K_PM_AWAKE:
-		status = ath9k_hw_set_power_awake(ah, setChip);
-		break;
-	case ATH9K_PM_FULL_SLEEP:
-		ath9k_set_power_sleep(ah, setChip);
-		ah->chip_fullsleep = true;
-		break;
-	case ATH9K_PM_NETWORK_SLEEP:
-		ath9k_set_power_network_sleep(ah, setChip);
-		break;
-	default:
-		ath_print(common, ATH_DBG_FATAL,
-			  "Unknown power mode %u\n", mode);
-		return false;
-	}
-	ah->power_mode = mode;
-
-	return status;
-}
-
-/*
- * Helper for ASPM support.
- *
- * Disable PLL when in L0s as well as receiver clock when in L1.
- * This power saving option must be enabled through the SerDes.
- *
- * Programming the SerDes must go through the same 288 bit serial shift
- * register as the other analog registers.  Hence the 9 writes.
- */
-static void ar9002_hw_configpcipowersave(struct ath_hw *ah,
-					 int restore,
-					 int power_off)
-{
-	u8 i;
-	u32 val;
-
-	if (ah->is_pciexpress != true)
-		return;
-
-	/* Do not touch SerDes registers */
-	if (ah->config.pcie_powersave_enable == 2)
-		return;
-
-	/* Nothing to do on restore for 11N */
-	if (!restore) {
-		if (AR_SREV_9280_20_OR_LATER(ah)) {
-			/*
-			 * AR9280 2.0 or later chips use SerDes values from the
-			 * initvals.h initialized depending on chipset during
-			 * __ath9k_hw_init()
-			 */
-			for (i = 0; i < ah->iniPcieSerdes.ia_rows; i++) {
-				REG_WRITE(ah, INI_RA(&ah->iniPcieSerdes, i, 0),
-					  INI_RA(&ah->iniPcieSerdes, i, 1));
-			}
-		} else if (AR_SREV_9280(ah) &&
-			   (ah->hw_version.macRev == AR_SREV_REVISION_9280_10)) {
-			REG_WRITE(ah, AR_PCIE_SERDES, 0x9248fd00);
-			REG_WRITE(ah, AR_PCIE_SERDES, 0x24924924);
-
-			/* RX shut off when elecidle is asserted */
-			REG_WRITE(ah, AR_PCIE_SERDES, 0xa8000019);
-			REG_WRITE(ah, AR_PCIE_SERDES, 0x13160820);
-			REG_WRITE(ah, AR_PCIE_SERDES, 0xe5980560);
-
-			/* Shut off CLKREQ active in L1 */
-			if (ah->config.pcie_clock_req)
-				REG_WRITE(ah, AR_PCIE_SERDES, 0x401deffc);
-			else
-				REG_WRITE(ah, AR_PCIE_SERDES, 0x401deffd);
-
-			REG_WRITE(ah, AR_PCIE_SERDES, 0x1aaabe40);
-			REG_WRITE(ah, AR_PCIE_SERDES, 0xbe105554);
-			REG_WRITE(ah, AR_PCIE_SERDES, 0x00043007);
-
-			/* Load the new settings */
-			REG_WRITE(ah, AR_PCIE_SERDES2, 0x00000000);
-
-		} else {
-			REG_WRITE(ah, AR_PCIE_SERDES, 0x9248fc00);
-			REG_WRITE(ah, AR_PCIE_SERDES, 0x24924924);
-
-			/* RX shut off when elecidle is asserted */
-			REG_WRITE(ah, AR_PCIE_SERDES, 0x28000039);
-			REG_WRITE(ah, AR_PCIE_SERDES, 0x53160824);
-			REG_WRITE(ah, AR_PCIE_SERDES, 0xe5980579);
-
-			/*
-			 * Ignore ah->ah_config.pcie_clock_req setting for
-			 * pre-AR9280 11n
-			 */
-			REG_WRITE(ah, AR_PCIE_SERDES, 0x001defff);
-
-			REG_WRITE(ah, AR_PCIE_SERDES, 0x1aaabe40);
-			REG_WRITE(ah, AR_PCIE_SERDES, 0xbe105554);
-			REG_WRITE(ah, AR_PCIE_SERDES, 0x000e3007);
-
-			/* Load the new settings */
-			REG_WRITE(ah, AR_PCIE_SERDES2, 0x00000000);
-		}
-
-		udelay(1000);
-
-		/* set bit 19 to allow forcing of pcie core into L1 state */
-		REG_SET_BIT(ah, AR_PCIE_PM_CTRL, AR_PCIE_PM_CTRL_ENA);
-
-		/* Several PCIe massages to ensure proper behaviour */
-		if (ah->config.pcie_waen) {
-			val = ah->config.pcie_waen;
-			if (!power_off)
-				val &= (~AR_WA_D3_L1_DISABLE);
-		} else {
-			if (AR_SREV_9285(ah) || AR_SREV_9271(ah) ||
-			    AR_SREV_9287(ah)) {
-				val = AR9285_WA_DEFAULT;
-				if (!power_off)
-					val &= (~AR_WA_D3_L1_DISABLE);
-			} else if (AR_SREV_9280(ah)) {
-				/*
-				 * On AR9280 chips bit 22 of 0x4004 needs to be
-				 * set otherwise card may disappear.
-				 */
-				val = AR9280_WA_DEFAULT;
-				if (!power_off)
-					val &= (~AR_WA_D3_L1_DISABLE);
-			} else
-				val = AR_WA_DEFAULT;
-		}
-
-		REG_WRITE(ah, AR_WA, val);
-	}
-
-	if (power_off) {
-		/*
-		 * Set PCIe workaround bits
-		 * bit 14 in WA register (disable L1) should only
-		 * be set when device enters D3 and be cleared
-		 * when device comes back to D0.
-		 */
-		if (ah->config.pcie_waen) {
-			if (ah->config.pcie_waen & AR_WA_D3_L1_DISABLE)
-				REG_SET_BIT(ah, AR_WA, AR_WA_D3_L1_DISABLE);
-		} else {
-			if (((AR_SREV_9285(ah) || AR_SREV_9271(ah) ||
-			      AR_SREV_9287(ah)) &&
-			     (AR9285_WA_DEFAULT & AR_WA_D3_L1_DISABLE)) ||
-			    (AR_SREV_9280(ah) &&
-			     (AR9280_WA_DEFAULT & AR_WA_D3_L1_DISABLE))) {
-				REG_SET_BIT(ah, AR_WA, AR_WA_D3_L1_DISABLE);
-			}
-		}
-	}
-}
-
 /**********************/
 /* Interrupt Handling */
 /**********************/
@@ -3995,20 +3195,3 @@ void ath9k_hw_name(struct ath_hw *ah, char *hw_name, size_t len)
 	hw_name[used] = '\0';
 }
 EXPORT_SYMBOL(ath9k_hw_name);
-
-/* Sets up the AR5008/AR9001/AR9002 hardware familiy callbacks */
-void ar9002_hw_attach_ops(struct ath_hw *ah)
-{
-	struct ath_hw_private_ops *priv_ops = ath9k_hw_private_ops(ah);
-	struct ath_hw_ops *ops = ath9k_hw_ops(ah);
-
-	priv_ops->init_cal_settings = &ar9002_hw_init_cal_settings;
-	priv_ops->init_mode_regs = &ar9002_hw_init_mode_regs;
-	priv_ops->macversion_supported = &ar9002_hw_macversion_supported;
-	priv_ops->set_reset_reg = &ar9002_hw_set_reset_reg;
-	priv_ops->disable_pcie = &ar9002_hw_disablepcie;
-
-	ops->set_power = &ar9002_hw_setpower;
-	ops->config_pci_powersave = &ar9002_hw_configpcipowersave;
-}
-EXPORT_SYMBOL(ar9002_hw_attach_ops);
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 5a73d51..1b1b18d 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -453,6 +453,9 @@ struct ath_gen_timer_table {
  * @macversion_supported: If this specific mac revision is supported
  * @set_reset_reg:
  * @disable_pcie:
+ * @init_pll:
+ * @init_mode_gains:
+ * @init_14_spread:
  */
 struct ath_hw_private_ops {
 	void (*init_cal_settings)(struct ath_hw *ah);
@@ -460,6 +463,9 @@ struct ath_hw_private_ops {
 	bool (*macversion_supported)(u32 macversion);
 	bool (*set_reset_reg)(struct ath_hw *ah, u32 type);
 	void (*disable_pcie)(struct ath_hw *ah);
+	void (*init_pll)(struct ath_hw *ah, struct ath9k_channel *chan);
+	void (*init_mode_gains)(struct ath_hw *ah);
+	void (*init_14_spread)(struct ath_hw *ah);
 };
 
 /**
-- 
1.6.3.3

