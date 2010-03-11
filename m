Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46891 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960Ab0CKB2c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Mar 2010 20:28:32 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 01/14] ath9k: start building an abstraction layer for hardware routines
Date: Wed, 10 Mar 2010 20:28:18 -0500
Message-Id: <1268270911-24568-2-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1268270911-24568-1-git-send-email-lrodriguez@atheros.com>
References: <1268270911-24568-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath9k supports the AR5008, AR9001 and AR9002 family of Atheros
chipsets, all 802.11n. The new breed of 802.11n chips, the
AR9003 family will be supported as well but each register read
and write uses a different register definition and and such
to support it we need to build a hardware family abstraction
layer.

This patch starts the abstraction layer through a set of callbacks.
Our approach is to avoid as much duplicate code as is possible so
where we can we will be re-using the same routines and only add
callbacks for specific hardware functions which do direct hardware
reads or writes. This starts off addressing hardware routines used
during hardware initialization.

The benefit with this approach is the core of the driver won't
need to be changed at all, except for areas where the hardware
does require some changes like DMA, which is the case for AR9003.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/common.h |    1 +
 drivers/net/wireless/ath/ath9k/hw-ops.h |   36 ++++++++
 drivers/net/wireless/ath/ath9k/hw.c     |  144 ++++++++++++++++++++++---------
 drivers/net/wireless/ath/ath9k/hw.h     |   57 +++++++++++-
 drivers/net/wireless/ath/ath9k/init.c   |    7 +-
 5 files changed, 194 insertions(+), 51 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/hw-ops.h

diff --git a/drivers/net/wireless/ath/ath9k/common.h b/drivers/net/wireless/ath/ath9k/common.h
index bbcc57f..17ad34a 100644
--- a/drivers/net/wireless/ath/ath9k/common.h
+++ b/drivers/net/wireless/ath/ath9k/common.h
@@ -20,6 +20,7 @@
 #include "../debug.h"
 
 #include "hw.h"
+#include "hw-ops.h"
 
 /* Common header for Atheros 802.11n base driver cores */
 
diff --git a/drivers/net/wireless/ath/ath9k/hw-ops.h b/drivers/net/wireless/ath/ath9k/hw-ops.h
new file mode 100644
index 0000000..0f9c29d
--- /dev/null
+++ b/drivers/net/wireless/ath/ath9k/hw-ops.h
@@ -0,0 +1,36 @@
+/*
+ * Copyright (c) 2010 Atheros Communications Inc.
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
+#ifndef ATH9K_HW_OPS_H
+#define ATH9K_HW_OPS_H
+
+#include "hw.h"
+
+/* Hardware core and driver accessible callbacks */
+
+static inline bool ath9k_hw_setpower(struct ath_hw *ah, enum ath9k_power_mode mode)
+{
+	return ath9k_hw_ops(ah)->set_power(ah, mode);
+}
+
+static inline void ath9k_hw_configpcipowersave(struct ath_hw *ah,
+					       int restore,
+					       int power_off)
+{
+	ath9k_hw_ops(ah)->config_pci_powersave(ah, restore, power_off);
+}
+
+#endif /* ATH9K_HW_OPS_H */
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 9699007..c6801c9 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -18,6 +18,7 @@
 #include <asm/unaligned.h>
 
 #include "hw.h"
+#include "hw-ops.h"
 #include "rc.h"
 #include "initvals.h"
 
@@ -25,7 +26,6 @@
 #define ATH9K_CLOCK_RATE_5GHZ_OFDM	40
 #define ATH9K_CLOCK_RATE_2GHZ_OFDM	44
 
-static bool ath9k_hw_set_reset_reg(struct ath_hw *ah, u32 type);
 static void ath9k_hw_set_regs(struct ath_hw *ah, struct ath9k_channel *chan);
 static u32 ath9k_hw_ini_fixup(struct ath_hw *ah,
 			      struct ar5416_eeprom_def *pEepData,
@@ -48,6 +48,33 @@ static void __exit ath9k_exit(void)
 }
 module_exit(ath9k_exit);
 
+/* Private hardware callbacks */
+
+static void ath9k_hw_init_cal_settings(struct ath_hw *ah)
+{
+	ath9k_hw_private_ops(ah)->init_cal_settings(ah);
+}
+
+static void ath9k_hw_init_mode_regs(struct ath_hw *ah)
+{
+	ath9k_hw_private_ops(ah)->init_mode_regs(ah);
+}
+
+static bool ath9k_hw_macversion_supported(struct ath_hw *ah)
+{
+	return ath9k_hw_private_ops(ah)->macversion_supported(ah->hw_version.macVersion);
+}
+
+static bool ath9k_hw_set_reset_reg(struct ath_hw *ah, u32 type)
+{
+	return ath9k_hw_private_ops(ah)->set_reset_reg(ah, type);
+}
+
+static void ath9k_hw_disablepcie(struct ath_hw *ah)
+{
+	ath9k_hw_private_ops(ah)->disable_pcie(ah);
+}
+
 /********************/
 /* Helper Functions */
 /********************/
@@ -254,7 +281,7 @@ static int ath9k_hw_get_radiorev(struct ath_hw *ah)
 /* HW Attach, Detach, Init Routines */
 /************************************/
 
-static void ath9k_hw_disablepcie(struct ath_hw *ah)
+static void ar9002_hw_disablepcie(struct ath_hw *ah)
 {
 	if (AR_SREV_9100(ah))
 		return;
@@ -371,7 +398,6 @@ static void ath9k_hw_init_config(struct ath_hw *ah)
 	if (num_possible_cpus() > 1)
 		ah->config.serialize_regmode = SER_REG_MODE_AUTO;
 }
-EXPORT_SYMBOL(ath9k_hw_init);
 
 static void ath9k_hw_init_defaults(struct ath_hw *ah)
 {
@@ -535,28 +561,7 @@ static int ath9k_hw_post_init(struct ath_hw *ah)
 	return 0;
 }
 
-static bool ath9k_hw_devid_supported(u16 devid)
-{
-	switch (devid) {
-	case AR5416_DEVID_PCI:
-	case AR5416_DEVID_PCIE:
-	case AR5416_AR9100_DEVID:
-	case AR9160_DEVID_PCI:
-	case AR9280_DEVID_PCI:
-	case AR9280_DEVID_PCIE:
-	case AR9285_DEVID_PCIE:
-	case AR5416_DEVID_AR9287_PCI:
-	case AR5416_DEVID_AR9287_PCIE:
-	case AR9271_USB:
-	case AR2427_DEVID_PCIE:
-		return true;
-	default:
-		break;
-	}
-	return false;
-}
-
-static bool ath9k_hw_macversion_supported(u32 macversion)
+static bool ar9002_hw_macversion_supported(u32 macversion)
 {
 	switch (macversion) {
 	case AR_SREV_VERSION_5416_PCI:
@@ -574,7 +579,7 @@ static bool ath9k_hw_macversion_supported(u32 macversion)
 	return false;
 }
 
-static void ath9k_hw_init_cal_settings(struct ath_hw *ah)
+static void ar9002_hw_init_cal_settings(struct ath_hw *ah)
 {
 	if (AR_SREV_9160_10_OR_LATER(ah)) {
 		if (AR_SREV_9280_10_OR_LATER(ah)) {
@@ -598,7 +603,7 @@ static void ath9k_hw_init_cal_settings(struct ath_hw *ah)
 	}
 }
 
-static void ath9k_hw_init_mode_regs(struct ath_hw *ah)
+static void ar9002_hw_init_mode_regs(struct ath_hw *ah)
 {
 	if (AR_SREV_9271(ah)) {
 		INIT_INI_ARRAY(&ah->iniModes, ar9271Modes_9271,
@@ -850,18 +855,12 @@ static void ath9k_hw_init_eeprom_fix(struct ath_hw *ah)
 	}
 }
 
-int ath9k_hw_init(struct ath_hw *ah)
+/* Called for all hardware families */
+int __ath9k_hw_init(struct ath_hw *ah)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
 	int r = 0;
 
-	if (!ath9k_hw_devid_supported(ah->hw_version.devid)) {
-		ath_print(common, ATH_DBG_FATAL,
-			  "Unsupported device ID: 0x%0x\n",
-			  ah->hw_version.devid);
-		return -EOPNOTSUPP;
-	}
-
 	ath9k_hw_init_defaults(ah);
 	ath9k_hw_init_config(ah);
 
@@ -895,7 +894,7 @@ int ath9k_hw_init(struct ath_hw *ah)
 	else
 		ah->config.max_txtrig_level = MAX_TX_FIFO_THRESHOLD;
 
-	if (!ath9k_hw_macversion_supported(ah->hw_version.macVersion)) {
+	if (!ath9k_hw_macversion_supported(ah)) {
 		ath_print(common, ATH_DBG_FATAL,
 			  "Mac Chip Rev 0x%02x.%x is not supported by "
 			  "this driver\n", ah->hw_version.macVersion,
@@ -912,6 +911,7 @@ int ath9k_hw_init(struct ath_hw *ah)
 	if (AR_SREV_9271(ah))
 		ah->is_pciexpress = false;
 
+	/* XXX: move this to its own hw op */
 	ah->hw_version.phyRev = REG_READ(ah, AR_PHY_CHIP_ID);
 
 	ath9k_hw_init_cal_settings(ah);
@@ -973,6 +973,49 @@ int ath9k_hw_init(struct ath_hw *ah)
 	return 0;
 }
 
+int ath9k_hw_init(struct ath_hw *ah)
+{
+	int ret;
+	struct ath_common *common = ath9k_hw_common(ah);
+
+	/* These are all the AR5008/AR9001/AR9002 hardware family of chipsets */
+	switch (ah->hw_version.devid) {
+	case AR5416_DEVID_PCI:
+	case AR5416_DEVID_PCIE:
+	case AR5416_AR9100_DEVID:
+	case AR9160_DEVID_PCI:
+	case AR9280_DEVID_PCI:
+	case AR9280_DEVID_PCIE:
+	case AR9285_DEVID_PCIE:
+	case AR5416_DEVID_AR9287_PCI:
+	case AR5416_DEVID_AR9287_PCIE:
+	case AR9271_USB:
+	case AR2427_DEVID_PCIE:
+		ar9002_hw_attach_ops(ah);
+		break;
+	default:
+		/*
+		 * For the AR9003 hardware family we'll eventually add a
+		 * respective ar9003_hw_attach_ops() call here.
+		 */
+		ath_print(common, ATH_DBG_FATAL,
+			  "Hardware device ID 0x%04x not supported\n",
+			  ah->hw_version.devid);
+		return -EOPNOTSUPP;
+	}
+
+	ret = __ath9k_hw_init(ah);
+	if (ret) {
+		ath_print(common, ATH_DBG_FATAL,
+			  "Unable to initialize hardware; "
+			  "initialization status: %d\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(ath9k_hw_init);
+
 static void ath9k_hw_init_bb(struct ath_hw *ah,
 			     struct ath9k_channel *chan)
 {
@@ -1761,7 +1804,7 @@ static bool ath9k_hw_set_reset_power_on(struct ath_hw *ah)
 	return ath9k_hw_set_reset(ah, ATH9K_RESET_WARM);
 }
 
-static bool ath9k_hw_set_reset_reg(struct ath_hw *ah, u32 type)
+static bool ar9002_hw_set_reset_reg(struct ath_hw *ah, u32 type)
 {
 	REG_WRITE(ah, AR_RTC_FORCE_WAKE,
 		  AR_RTC_FORCE_WAKE_EN | AR_RTC_FORCE_WAKE_ON_INT);
@@ -2489,7 +2532,7 @@ static bool ath9k_hw_set_power_awake(struct ath_hw *ah, int setChip)
 	return true;
 }
 
-bool ath9k_hw_setpower(struct ath_hw *ah, enum ath9k_power_mode mode)
+static bool ar9002_hw_setpower(struct ath_hw *ah, enum ath9k_power_mode mode)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
 	int status = true, setChip = true;
@@ -2526,7 +2569,6 @@ bool ath9k_hw_setpower(struct ath_hw *ah, enum ath9k_power_mode mode)
 
 	return status;
 }
-EXPORT_SYMBOL(ath9k_hw_setpower);
 
 /*
  * Helper for ASPM support.
@@ -2537,7 +2579,9 @@ EXPORT_SYMBOL(ath9k_hw_setpower);
  * Programming the SerDes must go through the same 288 bit serial shift
  * register as the other analog registers.  Hence the 9 writes.
  */
-void ath9k_hw_configpcipowersave(struct ath_hw *ah, int restore, int power_off)
+static void ar9002_hw_configpcipowersave(struct ath_hw *ah,
+					 int restore,
+					 int power_off)
 {
 	u8 i;
 	u32 val;
@@ -2555,7 +2599,7 @@ void ath9k_hw_configpcipowersave(struct ath_hw *ah, int restore, int power_off)
 			/*
 			 * AR9280 2.0 or later chips use SerDes values from the
 			 * initvals.h initialized depending on chipset during
-			 * ath9k_hw_init()
+			 * __ath9k_hw_init()
 			 */
 			for (i = 0; i < ah->iniPcieSerdes.ia_rows; i++) {
 				REG_WRITE(ah, INI_RA(&ah->iniPcieSerdes, i, 0),
@@ -2659,7 +2703,6 @@ void ath9k_hw_configpcipowersave(struct ath_hw *ah, int restore, int power_off)
 		}
 	}
 }
-EXPORT_SYMBOL(ath9k_hw_configpcipowersave);
 
 /**********************/
 /* Interrupt Handling */
@@ -3953,3 +3996,20 @@ void ath9k_hw_name(struct ath_hw *ah, char *hw_name, size_t len)
 	hw_name[used] = '\0';
 }
 EXPORT_SYMBOL(ath9k_hw_name);
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
+
+	ops->set_power = &ar9002_hw_setpower;
+	ops->config_pci_powersave = &ar9002_hw_configpcipowersave;
+}
+EXPORT_SYMBOL(ar9002_hw_attach_ops);
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 6b03e16..5a73d51 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -442,6 +442,42 @@ struct ath_gen_timer_table {
 	} timer_mask;
 };
 
+/**
+ * struct ath_hw_private_ops - callbacks used internally by hardware code
+ *
+ * This structure contains private callbacks designed to only be used internally
+ * by the hardware core.
+ *
+ * @init_cal_settings: Initializes calibration settings
+ * @init_mode_regs: Initializes mode registers
+ * @macversion_supported: If this specific mac revision is supported
+ * @set_reset_reg:
+ * @disable_pcie:
+ */
+struct ath_hw_private_ops {
+	void (*init_cal_settings)(struct ath_hw *ah);
+	void (*init_mode_regs)(struct ath_hw *ah);
+	bool (*macversion_supported)(u32 macversion);
+	bool (*set_reset_reg)(struct ath_hw *ah, u32 type);
+	void (*disable_pcie)(struct ath_hw *ah);
+};
+
+/**
+ * struct ath_hw_ops - callbacks used by hardware code and driver code
+ *
+ * This structure contains callbacks designed to to be used internally by
+ * hardware code and also by the lower level driver.
+ *
+ * @set_power:
+ * @config_pci_powersave:
+ */
+struct ath_hw_ops {
+	bool (*set_power)(struct ath_hw *ah, enum ath9k_power_mode mode);
+	void (*config_pci_powersave)(struct ath_hw *ah,
+				    int restore,
+				    int power_off);
+};
+
 struct ath_hw {
 	struct ieee80211_hw *hw;
 	struct ath_common common;
@@ -541,6 +577,11 @@ struct ath_hw {
 	void (*ath9k_hw_spur_mitigate_freq)(struct ath_hw *ah,
 					    struct ath9k_channel *chan);
 
+	/* Private to hardware code */
+	struct ath_hw_private_ops private_ops;
+	/* Accessed by the lower level driver */
+	struct ath_hw_ops ops;
+
 	/* Used to program the radio on non single-chip devices */
 	u32 *analogBank0Data;
 	u32 *analogBank1Data;
@@ -620,6 +661,16 @@ static inline struct ath_regulatory *ath9k_hw_regulatory(struct ath_hw *ah)
 	return &(ath9k_hw_common(ah)->regulatory);
 }
 
+static inline struct ath_hw_private_ops *ath9k_hw_private_ops(struct ath_hw *ah)
+{
+	return &ah->private_ops;
+}
+
+static inline struct ath_hw_ops *ath9k_hw_ops(struct ath_hw *ah)
+{
+	return &ah->ops;
+}
+
 /* Initialization, Detach, Reset */
 const char *ath9k_hw_probe(u16 vendorid, u16 devid);
 void ath9k_hw_deinit(struct ath_hw *ah);
@@ -680,10 +731,6 @@ void ath9k_hw_beaconinit(struct ath_hw *ah, u32 next_beacon, u32 beacon_period);
 void ath9k_hw_set_sta_beacon_timers(struct ath_hw *ah,
 				    const struct ath9k_beacon_state *bs);
 
-bool ath9k_hw_setpower(struct ath_hw *ah, enum ath9k_power_mode mode);
-
-void ath9k_hw_configpcipowersave(struct ath_hw *ah, int restore, int power_off);
-
 /* Interrupt Handling */
 bool ath9k_hw_intrpend(struct ath_hw *ah);
 bool ath9k_hw_getisr(struct ath_hw *ah, enum ath9k_int *masked);
@@ -707,6 +754,8 @@ u32 ath9k_hw_gettsf32(struct ath_hw *ah);
 
 void ath9k_hw_name(struct ath_hw *ah, char *hw_name, size_t len);
 
+void ar9002_hw_attach_ops(struct ath_hw *ah);
+
 /* HTC */
 void ath9k_hw_htc_resetinit(struct ath_hw *ah);
 
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 6063f54..62682cc 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -566,13 +566,10 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid,
 	ath_read_cachesize(common, &csz);
 	common->cachelsz = csz << 2; /* convert to bytes */
 
+	/* Initializes the hardware for all supported chipsets */
 	ret = ath9k_hw_init(ah);
-	if (ret) {
-		ath_print(common, ATH_DBG_FATAL,
-			  "Unable to initialize hardware; "
-			  "initialization status: %d\n", ret);
+	if (ret)
 		goto err_hw;
-	}
 
 	ret = ath9k_init_debug(ah);
 	if (ret) {
-- 
1.6.3.3

