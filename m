Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46905 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933265Ab0DHT1q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Apr 2010 15:27:46 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 058/102] ath9k_hw: split the generic hardware code by hardware family
Date: Thu,  8 Apr 2010 15:26:54 -0400
Message-Id: <1270754858-26266-59-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
References: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move out the generic hardware family code out into their own
files, we have one for AR5008, AR9001, and AR9002 family (ar9002_hw.c)
and another file for the new AR9003 hardware family (ar9003_hw.c).

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/Makefile    |    5 +-
 drivers/net/wireless/ath/ath9k/ar9002_hw.c |  383 +++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/ar9003_hw.c |  149 +++++++++
 drivers/net/wireless/ath/ath9k/hw.c        |  499 +---------------------------
 drivers/net/wireless/ath/ath9k/hw.h        |    5 +-
 5 files changed, 541 insertions(+), 500 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9002_hw.c
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9003_hw.c

diff --git a/drivers/net/wireless/ath/ath9k/Makefile b/drivers/net/wireless/ath/ath9k/Makefile
index d2417ed..ee8f7e8 100644
--- a/drivers/net/wireless/ath/ath9k/Makefile
+++ b/drivers/net/wireless/ath/ath9k/Makefile
@@ -13,7 +13,10 @@ ath9k-$(CONFIG_ATH9K_DEBUGFS) += debug.o
 
 obj-$(CONFIG_ATH9K) += ath9k.o
 
-ath9k_hw-y:=	hw.o \
+ath9k_hw-y:=	\
+		ar9002_hw.o \
+		ar9003_hw.o \
+		hw.o \
 		ar9003_phy.o \
 		ar9002_phy.o \
 		ar5008_phy.o \
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_hw.c b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
new file mode 100644
index 0000000..bd634fe
--- /dev/null
+++ b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
@@ -0,0 +1,383 @@
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
+#include "ar5008_initvals.h"
+#include "ar9001_initvals.h"
+#include "ar9002_initvals.h"
+
+/* General hardware code for the A5008/AR9001/AR9002 hadware families */
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
+/* Sets up the AR5008/AR9001/AR9002 hardware familiy callbacks */
+void ar9002_hw_attach_ops(struct ath_hw *ah)
+{
+	struct ath_hw_private_ops *priv_ops = ath9k_hw_private_ops(ah);
+	struct ath_hw_ops *ops = ath9k_hw_ops(ah);
+
+	priv_ops->init_mode_regs = ar9002_hw_init_mode_regs;
+	priv_ops->macversion_supported = ar9002_hw_macversion_supported;
+
+	ops->config_pci_powersave = ar9002_hw_configpcipowersave;
+
+	ar5008_hw_attach_phy_ops(ah);
+	if (AR_SREV_9280_10_OR_LATER(ah))
+		ar9002_hw_attach_phy_ops(ah);
+
+	ar9002_hw_attach_calib_ops(ah);
+	ar9002_hw_attach_mac_ops(ah);
+}
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_hw.c b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
new file mode 100644
index 0000000..6111bdb
--- /dev/null
+++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
@@ -0,0 +1,149 @@
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
+#include "ar9003_initvals.h"
+
+/* General hardware code for the AR9003 hadware family */
+
+static bool ar9003_hw_macversion_supported(u32 macversion)
+{
+	switch (macversion) {
+	case AR_SREV_VERSION_9300:
+		return true;
+	default:
+		break;
+	}
+	return false;
+}
+
+/* AR9003 2.0 - new INI format (pre, core, post arrays per subsystem) */
+static void ar9003_hw_init_mode_regs(struct ath_hw *ah)
+{
+	/* mac */
+	INIT_INI_ARRAY(&ah->iniMac[ATH_INI_PRE], NULL, 0, 0);
+	INIT_INI_ARRAY(&ah->iniMac[ATH_INI_CORE],
+		       ar9300_2p0_mac_core,
+		       ARRAY_SIZE(ar9300_2p0_mac_core), 2);
+	INIT_INI_ARRAY(&ah->iniMac[ATH_INI_POST],
+		       ar9300_2p0_mac_postamble,
+		       ARRAY_SIZE(ar9300_2p0_mac_postamble), 5);
+
+	/* bb */
+	INIT_INI_ARRAY(&ah->iniBB[ATH_INI_PRE], NULL, 0, 0);
+	INIT_INI_ARRAY(&ah->iniBB[ATH_INI_CORE],
+		       ar9300_2p0_baseband_core,
+		       ARRAY_SIZE(ar9300_2p0_baseband_core), 2);
+	INIT_INI_ARRAY(&ah->iniBB[ATH_INI_POST],
+		       ar9300_2p0_baseband_postamble,
+		       ARRAY_SIZE(ar9300_2p0_baseband_postamble), 5);
+
+	/* radio */
+	INIT_INI_ARRAY(&ah->iniRadio[ATH_INI_PRE], NULL, 0, 0);
+	INIT_INI_ARRAY(&ah->iniRadio[ATH_INI_CORE],
+		       ar9300_2p0_radio_core,
+		       ARRAY_SIZE(ar9300_2p0_radio_core), 2);
+	INIT_INI_ARRAY(&ah->iniRadio[ATH_INI_POST],
+		       ar9300_2p0_radio_postamble,
+		       ARRAY_SIZE(ar9300_2p0_radio_postamble), 5);
+
+	/* soc */
+	INIT_INI_ARRAY(&ah->iniSOC[ATH_INI_PRE],
+		       ar9300_2p0_soc_preamble,
+		       ARRAY_SIZE(ar9300_2p0_soc_preamble), 2);
+	INIT_INI_ARRAY(&ah->iniSOC[ATH_INI_CORE], NULL, 0, 0);
+	INIT_INI_ARRAY(&ah->iniSOC[ATH_INI_POST],
+		       ar9300_2p0_soc_postamble,
+		       ARRAY_SIZE(ar9300_2p0_soc_postamble), 5);
+
+	/* rx/tx gain */
+	INIT_INI_ARRAY(&ah->iniModesRxGain,
+		       ar9300Common_rx_gain_table_2p0,
+		       ARRAY_SIZE(ar9300Common_rx_gain_table_2p0), 2);
+	INIT_INI_ARRAY(&ah->iniModesTxGain,
+		       ar9300Modes_lowest_ob_db_tx_gain_table_2p0,
+		       ARRAY_SIZE(ar9300Modes_lowest_ob_db_tx_gain_table_2p0),
+		       5);
+
+	/* Load PCIE SERDES settings from INI */
+
+	/* Awake Setting */
+
+	INIT_INI_ARRAY(&ah->iniPcieSerdes,
+		       ar9300PciePhy_pll_on_clkreq_disable_L1_2p0,
+		       ARRAY_SIZE(ar9300PciePhy_pll_on_clkreq_disable_L1_2p0),
+		       2);
+
+	/* Sleep Setting */
+
+	INIT_INI_ARRAY(&ah->iniPcieSerdesLowPower,
+		       ar9300PciePhy_clkreq_enable_L1_2p0,
+		       ARRAY_SIZE(ar9300PciePhy_clkreq_enable_L1_2p0),
+		       2);
+
+	/* Fast clock modal settings */
+	INIT_INI_ARRAY(&ah->iniModesAdditional,
+		       ar9300Modes_fast_clock_2p0,
+		       ARRAY_SIZE(ar9300Modes_fast_clock_2p0),
+		       3);
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
+static void ar9003_hw_configpcipowersave(struct ath_hw *ah,
+					 int restore,
+					 int power_off)
+{
+	if (ah->is_pciexpress != true)
+		return;
+
+	/* Do not touch SerDes registers */
+	if (ah->config.pcie_powersave_enable == 2)
+		return;
+
+	/* Nothing to do on restore for 11N */
+	if (!restore) {
+		/* set bit 19 to allow forcing of pcie core into L1 state */
+		REG_SET_BIT(ah, AR_PCIE_PM_CTRL, AR_PCIE_PM_CTRL_ENA);
+
+		/* Several PCIe massages to ensure proper behaviour */
+		if (ah->config.pcie_waen)
+			REG_WRITE(ah, AR_WA, ah->config.pcie_waen);
+	}
+}
+
+/* Sets up the AR9003 hardware familiy callbacks */
+void ar9003_hw_attach_ops(struct ath_hw *ah)
+{
+	struct ath_hw_private_ops *priv_ops = ath9k_hw_private_ops(ah);
+	struct ath_hw_ops *ops = ath9k_hw_ops(ah);
+
+	priv_ops->init_mode_regs = ar9003_hw_init_mode_regs;
+	priv_ops->macversion_supported = ar9003_hw_macversion_supported;
+
+	ops->config_pci_powersave = ar9003_hw_configpcipowersave;
+
+	ar9003_hw_attach_phy_ops(ah);
+	ar9003_hw_attach_calib_ops(ah);
+	ar9003_hw_attach_mac_ops(ah);
+}
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 8f47b7d..39ac6b5 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2008-2009 Atheros Communications Inc.
+ * Copyright (c) 2008-2010 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -14,24 +14,17 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#include <linux/io.h>
 #include <asm/unaligned.h>
 
 #include "hw.h"
 #include "hw-ops.h"
 #include "rc.h"
-#include "ar5008_initvals.h"
-#include "ar9001_initvals.h"
 #include "ar9002_initvals.h"
-#include "ar9003_initvals.h"
 
 #define ATH9K_CLOCK_RATE_CCK		22
 #define ATH9K_CLOCK_RATE_5GHZ_OFDM	40
 #define ATH9K_CLOCK_RATE_2GHZ_OFDM	44
 
-static void ar9002_hw_attach_ops(struct ath_hw *ah);
-static void ar9003_hw_attach_ops(struct ath_hw *ah);
-
 static bool ath9k_hw_set_reset_reg(struct ath_hw *ah, u32 type);
 
 MODULE_AUTHOR("Atheros Communications");
@@ -565,296 +558,6 @@ static int ath9k_hw_post_init(struct ath_hw *ah)
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
-static bool ar9003_hw_macversion_supported(u32 macversion)
-{
-	switch (macversion) {
-	case AR_SREV_VERSION_9300:
-		return true;
-	default:
-		break;
-	}
-	return false;
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
-/* AR9003 2.0 - new INI format (pre, core, post arrays per subsystem) */
-static void ar9003_hw_init_mode_regs(struct ath_hw *ah)
-{
-	/* mac */
-	INIT_INI_ARRAY(&ah->iniMac[ATH_INI_PRE], NULL, 0, 0);
-	INIT_INI_ARRAY(&ah->iniMac[ATH_INI_CORE],
-		       ar9300_2p0_mac_core,
-		       ARRAY_SIZE(ar9300_2p0_mac_core), 2);
-	INIT_INI_ARRAY(&ah->iniMac[ATH_INI_POST],
-		       ar9300_2p0_mac_postamble,
-		       ARRAY_SIZE(ar9300_2p0_mac_postamble), 5);
-
-	/* bb */
-	INIT_INI_ARRAY(&ah->iniBB[ATH_INI_PRE], NULL, 0, 0);
-	INIT_INI_ARRAY(&ah->iniBB[ATH_INI_CORE],
-		       ar9300_2p0_baseband_core,
-		       ARRAY_SIZE(ar9300_2p0_baseband_core), 2);
-	INIT_INI_ARRAY(&ah->iniBB[ATH_INI_POST],
-		       ar9300_2p0_baseband_postamble,
-		       ARRAY_SIZE(ar9300_2p0_baseband_postamble), 5);
-
-	/* radio */
-	INIT_INI_ARRAY(&ah->iniRadio[ATH_INI_PRE], NULL, 0, 0);
-	INIT_INI_ARRAY(&ah->iniRadio[ATH_INI_CORE],
-		       ar9300_2p0_radio_core,
-		       ARRAY_SIZE(ar9300_2p0_radio_core), 2);
-	INIT_INI_ARRAY(&ah->iniRadio[ATH_INI_POST],
-		       ar9300_2p0_radio_postamble,
-		       ARRAY_SIZE(ar9300_2p0_radio_postamble), 5);
-
-	/* soc */
-	INIT_INI_ARRAY(&ah->iniSOC[ATH_INI_PRE],
-		       ar9300_2p0_soc_preamble,
-		       ARRAY_SIZE(ar9300_2p0_soc_preamble), 2);
-	INIT_INI_ARRAY(&ah->iniSOC[ATH_INI_CORE], NULL, 0, 0);
-	INIT_INI_ARRAY(&ah->iniSOC[ATH_INI_POST],
-		       ar9300_2p0_soc_postamble,
-		       ARRAY_SIZE(ar9300_2p0_soc_postamble), 5);
-
-	/* rx/tx gain */
-	INIT_INI_ARRAY(&ah->iniModesRxGain,
-		       ar9300Common_rx_gain_table_2p0,
-		       ARRAY_SIZE(ar9300Common_rx_gain_table_2p0), 2);
-	INIT_INI_ARRAY(&ah->iniModesTxGain,
-		       ar9300Modes_lowest_ob_db_tx_gain_table_2p0,
-		       ARRAY_SIZE(ar9300Modes_lowest_ob_db_tx_gain_table_2p0),
-		       5);
-
-	/* Load PCIE SERDES settings from INI */
-
-	/* Awake Setting */
-
-	INIT_INI_ARRAY(&ah->iniPcieSerdes,
-		       ar9300PciePhy_pll_on_clkreq_disable_L1_2p0,
-		       ARRAY_SIZE(ar9300PciePhy_pll_on_clkreq_disable_L1_2p0),
-		       2);
-
-	/* Sleep Setting */
-
-	INIT_INI_ARRAY(&ah->iniPcieSerdesLowPower,
-		       ar9300PciePhy_clkreq_enable_L1_2p0,
-		       ARRAY_SIZE(ar9300PciePhy_clkreq_enable_L1_2p0),
-		       2);
-
-	/* Fast clock modal settings */
-	INIT_INI_ARRAY(&ah->iniModesAdditional,
-		       ar9300Modes_fast_clock_2p0,
-		       ARRAY_SIZE(ar9300Modes_fast_clock_2p0),
-		       3);
-}
-
 static void ath9k_hw_init_mode_gain_regs(struct ath_hw *ah)
 {
 	if (AR_SREV_9287_11_OR_LATER(ah))
@@ -2212,140 +1915,6 @@ bool ath9k_hw_setpower(struct ath_hw *ah, enum ath9k_power_mode mode)
 }
 EXPORT_SYMBOL(ath9k_hw_setpower);
 
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
@@ -2627,37 +2196,6 @@ enum ath9k_int ath9k_hw_set_interrupts(struct ath_hw *ah, enum ath9k_int ints)
 }
 EXPORT_SYMBOL(ath9k_hw_set_interrupts);
 
-/*
- * Helper for ASPM support.
- *
- * Disable PLL when in L0s as well as receiver clock when in L1.
- * This power saving option must be enabled through the SerDes.
- *
- * Programming the SerDes must go through the same 288 bit serial shift
- * register as the other analog registers.  Hence the 9 writes.
- */
-static void ar9003_hw_configpcipowersave(struct ath_hw *ah,
-					 int restore,
-					 int power_off)
-{
-	if (ah->is_pciexpress != true)
-		return;
-
-	/* Do not touch SerDes registers */
-	if (ah->config.pcie_powersave_enable == 2)
-		return;
-
-	/* Nothing to do on restore for 11N */
-	if (!restore) {
-		/* set bit 19 to allow forcing of pcie core into L1 state */
-		REG_SET_BIT(ah, AR_PCIE_PM_CTRL, AR_PCIE_PM_CTRL_ENA);
-
-		/* Several PCIe massages to ensure proper behaviour */
-		if (ah->config.pcie_waen)
-			REG_WRITE(ah, AR_WA, ah->config.pcie_waen);
-	}
-}
-
 /*******************/
 /* Beacon Handling */
 /*******************/
@@ -3672,38 +3210,3 @@ void ath9k_hw_name(struct ath_hw *ah, char *hw_name, size_t len)
 	hw_name[used] = '\0';
 }
 EXPORT_SYMBOL(ath9k_hw_name);
-
-/* Sets up the AR5008/AR9001/AR9002 hardware familiy callbacks */
-static void ar9002_hw_attach_ops(struct ath_hw *ah)
-{
-	struct ath_hw_private_ops *priv_ops = ath9k_hw_private_ops(ah);
-	struct ath_hw_ops *ops = ath9k_hw_ops(ah);
-
-	priv_ops->init_mode_regs = ar9002_hw_init_mode_regs;
-	priv_ops->macversion_supported = ar9002_hw_macversion_supported;
-
-	ops->config_pci_powersave = ar9002_hw_configpcipowersave;
-
-	ar5008_hw_attach_phy_ops(ah);
-	if (AR_SREV_9280_10_OR_LATER(ah))
-		ar9002_hw_attach_phy_ops(ah);
-
-	ar9002_hw_attach_calib_ops(ah);
-	ar9002_hw_attach_mac_ops(ah);
-}
-
-/* Sets up the AR9003 hardware familiy callbacks */
-static void ar9003_hw_attach_ops(struct ath_hw *ah)
-{
-	struct ath_hw_private_ops *priv_ops = ath9k_hw_private_ops(ah);
-	struct ath_hw_ops *ops = ath9k_hw_ops(ah);
-
-	priv_ops->init_mode_regs = ar9003_hw_init_mode_regs;
-	priv_ops->macversion_supported = ar9003_hw_macversion_supported;
-
-	ops->config_pci_powersave = ar9003_hw_configpcipowersave;
-
-	ar9003_hw_attach_phy_ops(ah);
-	ar9003_hw_attach_calib_ops(ah);
-	ar9003_hw_attach_mac_ops(ah);
-}
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 8101ca4..1c6b07b 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2008-2009 Atheros Communications Inc.
+ * Copyright (c) 2008-2010 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -846,6 +846,9 @@ void ar9003_hw_attach_phy_ops(struct ath_hw *ah);
 void ar9002_hw_attach_calib_ops(struct ath_hw *ah);
 void ar9003_hw_attach_calib_ops(struct ath_hw *ah);
 
+void ar9002_hw_attach_ops(struct ath_hw *ah);
+void ar9003_hw_attach_ops(struct ath_hw *ah);
+
 #define ATH_PCIE_CAP_LINK_CTRL	0x70
 #define ATH_PCIE_CAP_LINK_L0S	1
 #define ATH_PCIE_CAP_LINK_L1	2
-- 
1.6.3.3

