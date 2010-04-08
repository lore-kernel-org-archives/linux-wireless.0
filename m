Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46722 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933197Ab0DHT1k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Apr 2010 15:27:40 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH 014/102] ath9k_hw: Add AR9003 PHY support
Date: Thu,  8 Apr 2010 15:26:10 -0400
Message-Id: <1270754858-26266-15-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
References: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This add stubs for PHY support for the AR9003 hardware family.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/Makefile     |    1 +
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |  146 +++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/hw.c         |   20 +++-
 drivers/net/wireless/ath/ath9k/hw.h         |    3 +-
 4 files changed, 166 insertions(+), 4 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9003_phy.c

diff --git a/drivers/net/wireless/ath/ath9k/Makefile b/drivers/net/wireless/ath/ath9k/Makefile
index db63ba2..ecf3f8c 100644
--- a/drivers/net/wireless/ath/ath9k/Makefile
+++ b/drivers/net/wireless/ath/ath9k/Makefile
@@ -14,6 +14,7 @@ ath9k-$(CONFIG_ATH9K_DEBUGFS) += debug.o
 obj-$(CONFIG_ATH9K) += ath9k.o
 
 ath9k_hw-y:=	hw.o \
+		ar9003_phy.o \
 		ar9002_phy.o \
 		ar5008_phy.o \
 		eeprom.o \
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
new file mode 100644
index 0000000..e3c97da
--- /dev/null
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -0,0 +1,146 @@
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
+#include "hw.h"
+
+/**
+ * ar9003_hw_set_channel - set channel on single-chip device
+ * @ah: atheros hardware structure
+ * @chan:
+ *
+ * This is the function to change channel on single-chip devices, that is
+ * all devices after ar9280.
+ *
+ * This function takes the channel value in MHz and sets
+ * hardware channel value. Assumes writes have been enabled to analog bus.
+ *
+ * Actual Expression,
+ *
+ * For 2GHz channel,
+ * Channel Frequency = (3/4) * freq_ref * (chansel[8:0] + chanfrac[16:0]/2^17)
+ * (freq_ref = 40MHz)
+ *
+ * For 5GHz channel,
+ * Channel Frequency = (3/2) * freq_ref * (chansel[8:0] + chanfrac[16:0]/2^10)
+ * (freq_ref = 40MHz/(24>>amodeRefSel))
+ *
+ * For 5GHz channels which are 5MHz spaced,
+ * Channel Frequency = (3/2) * freq_ref * (chansel[8:0] + chanfrac[16:0]/2^17)
+ * (freq_ref = 40MHz)
+ */
+static int ar9003_hw_set_channel(struct ath_hw *ah, struct ath9k_channel *chan)
+{
+	/* TODO */
+	return 0;
+}
+
+/**
+ * ar9003_hw_spur_mitigate - convert baseband spur frequency
+ * @ah: atheros hardware structure
+ * @chan:
+ *
+ * For single-chip solutions. Converts to baseband spur frequency given the
+ * input channel frequency and compute register settings below.
+ *
+ * Spur mitigation for MRC CCK
+ */
+static void ar9003_hw_spur_mitigate(struct ath_hw *ah, struct ath9k_channel *chan)
+{
+	/* TODO */
+}
+
+static u32 ar9003_hw_compute_pll_control(struct ath_hw *ah,
+					 struct ath9k_channel *chan)
+{
+	/* TODO */
+	return 0;
+}
+
+static void ar9003_hw_set_channel_regs(struct ath_hw *ah,
+				       struct ath9k_channel *chan)
+{
+	/* TODO */
+}
+
+static void ar9003_hw_init_bb(struct ath_hw *ah,
+			      struct ath9k_channel *chan)
+{
+	/* TODO */
+}
+
+static int ar9003_hw_process_ini(struct ath_hw *ah,
+				 struct ath9k_channel *chan)
+{
+	/* TODO */
+	return -1;
+}
+
+static void ar9003_hw_set_rfmode(struct ath_hw *ah,
+				 struct ath9k_channel *chan)
+{
+	/* TODO */
+}
+
+static void ar9003_hw_mark_phy_inactive(struct ath_hw *ah)
+{
+	/* TODO */
+}
+
+static void ar9003_hw_set_delta_slope(struct ath_hw *ah,
+				      struct ath9k_channel *chan)
+{
+	/* TODO */
+}
+
+static bool ar9003_hw_rfbus_req(struct ath_hw *ah)
+{
+	/* TODO */
+	return false;
+}
+
+static void ar9003_hw_rfbus_done(struct ath_hw *ah)
+{
+	/* TODO */
+}
+
+static void ar9003_hw_enable_rfkill(struct ath_hw *ah)
+{
+	/* TODO */
+}
+
+static void ar9003_hw_set_diversity(struct ath_hw *ah, bool value)
+{
+	/* TODO */
+}
+
+void ar9003_hw_attach_phy_ops(struct ath_hw *ah)
+{
+	struct ath_hw_private_ops *priv_ops = ath9k_hw_private_ops(ah);
+
+	priv_ops->rf_set_freq = ar9003_hw_set_channel;
+	priv_ops->spur_mitigate_freq = ar9003_hw_spur_mitigate;
+	priv_ops->compute_pll_control = ar9003_hw_compute_pll_control;
+	priv_ops->set_channel_regs = ar9003_hw_set_channel_regs;
+	priv_ops->init_bb = ar9003_hw_init_bb;
+	priv_ops->process_ini = ar9003_hw_process_ini;
+	priv_ops->set_rfmode = ar9003_hw_set_rfmode;
+	priv_ops->mark_phy_inactive = ar9003_hw_mark_phy_inactive;
+	priv_ops->set_delta_slope = ar9003_hw_set_delta_slope;
+	priv_ops->rfbus_req = ar9003_hw_rfbus_req;
+	priv_ops->rfbus_done = ar9003_hw_rfbus_done;
+	priv_ops->enable_rfkill = ar9003_hw_enable_rfkill;
+	priv_ops->set_diversity = ar9003_hw_set_diversity;
+}
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 6d4c6e6..655da06 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -27,6 +27,7 @@
 #define ATH9K_CLOCK_RATE_2GHZ_OFDM	44
 
 static void ar9002_hw_attach_ops(struct ath_hw *ah);
+static void ar9003_hw_attach_ops(struct ath_hw *ah);
 
 static bool ath9k_hw_set_reset_reg(struct ath_hw *ah, u32 type);
 static u32 ath9k_hw_ini_fixup(struct ath_hw *ah,
@@ -866,6 +867,14 @@ static void ath9k_hw_init_eeprom_fix(struct ath_hw *ah)
 	}
 }
 
+static void ath9k_hw_attach_ops(struct ath_hw *ah)
+{
+	if (AR_SREV_9300_20_OR_LATER(ah))
+		ar9003_hw_attach_ops(ah);
+	else
+		ar9002_hw_attach_ops(ah);
+}
+
 /* Called for all hardware families */
 static int __ath9k_hw_init(struct ath_hw *ah)
 {
@@ -881,7 +890,7 @@ static int __ath9k_hw_init(struct ath_hw *ah)
 		return -EIO;
 	}
 
-	ar9002_hw_attach_ops(ah);
+	ath9k_hw_attach_ops(ah);
 
 	if (!ath9k_hw_setpower(ah, ATH9K_PM_AWAKE)) {
 		ath_print(common, ATH_DBG_FATAL, "Couldn't wakeup chip\n");
@@ -3574,8 +3583,13 @@ static void ar9002_hw_attach_ops(struct ath_hw *ah)
 
 	ops->config_pci_powersave = ar9002_hw_configpcipowersave;
 
+	ar5008_hw_attach_phy_ops(ah);
 	if (AR_SREV_9280_10_OR_LATER(ah))
 		ar9002_hw_attach_phy_ops(ah);
-	else
-		ar5008_hw_attach_phy_ops(ah);
+}
+
+/* Sets up the AR9003 hardware familiy callbacks */
+static void ar9003_hw_attach_ops(struct ath_hw *ah)
+{
+	ar9003_hw_attach_phy_ops(ah);
 }
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 705dcad..f04d64b 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -782,8 +782,9 @@ void ath9k_hw_htc_resetinit(struct ath_hw *ah);
 void ath9k_hw_get_delta_slope_vals(struct ath_hw *ah, u32 coef_scaled,
 				   u32 *coef_mantissa, u32 *coef_exponent);
 
-void ar9002_hw_attach_phy_ops(struct ath_hw *ah);
 void ar5008_hw_attach_phy_ops(struct ath_hw *ah);
+void ar9002_hw_attach_phy_ops(struct ath_hw *ah);
+void ar9003_hw_attach_phy_ops(struct ath_hw *ah);
 
 #define ATH_PCIE_CAP_LINK_CTRL	0x70
 #define ATH_PCIE_CAP_LINK_L0S	1
-- 
1.6.3.3

