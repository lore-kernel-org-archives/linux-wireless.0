Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:41103 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756138Ab0CQW2P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Mar 2010 18:28:15 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v2 08/20] ath9k_hw: move ar9002 bluetooth coexistence code to its own file
Date: Wed, 17 Mar 2010 18:28:01 -0400
Message-Id: <1268864893-11428-9-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1268864893-11428-1-git-send-email-lrodriguez@atheros.com>
References: <1268864893-11428-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It turns out all these routines do their own read/writes so just move the
entire file. If btcoex is supported by the chipset the calls will be enabled
and the driver core and hardware call will issue calls for btcoex.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/Makefile        |    2 +-
 drivers/net/wireless/ath/ath9k/ar9002_btcoex.c |  239 ++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/ar9002_hw.c     |    3 +
 drivers/net/wireless/ath/ath9k/btcoex.c        |  227 ----------------------
 drivers/net/wireless/ath/ath9k/btcoex.h        |   10 -
 drivers/net/wireless/ath/ath9k/hw-ops.h        |   51 +++++
 drivers/net/wireless/ath/ath9k/hw.h            |   26 +++
 drivers/net/wireless/ath/ath9k/init.c          |    2 +-
 8 files changed, 321 insertions(+), 239 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9002_btcoex.c
 delete mode 100644 drivers/net/wireless/ath/ath9k/btcoex.c

diff --git a/drivers/net/wireless/ath/ath9k/Makefile b/drivers/net/wireless/ath/ath9k/Makefile
index 6c1594b..affbf84 100644
--- a/drivers/net/wireless/ath/ath9k/Makefile
+++ b/drivers/net/wireless/ath/ath9k/Makefile
@@ -17,6 +17,7 @@ ath9k_hw-y:=	hw.o \
 		ar9002_hw.o \
 		ar9002_calib.o \
 		ar9002_calib_settings.o \
+		ar9002_btcoex.o \
 		eeprom.o \
 		eeprom_def.o \
 		eeprom_4k.o \
@@ -24,7 +25,6 @@ ath9k_hw-y:=	hw.o \
 		calib.o \
 		ani.o \
 		phy.o \
-		btcoex.o \
 		mac.o \
 
 obj-$(CONFIG_ATH9K_HW) += ath9k_hw.o
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_btcoex.c b/drivers/net/wireless/ath/ath9k/ar9002_btcoex.c
new file mode 100644
index 0000000..3db3edb
--- /dev/null
+++ b/drivers/net/wireless/ath/ath9k/ar9002_btcoex.c
@@ -0,0 +1,239 @@
+/*
+ * Copyright (c) 2009 Atheros Communications Inc.
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
+
+enum ath_bt_mode {
+	ATH_BT_COEX_MODE_LEGACY,        /* legacy rx_clear mode */
+	ATH_BT_COEX_MODE_UNSLOTTED,     /* untimed/unslotted mode */
+	ATH_BT_COEX_MODE_SLOTTED,       /* slotted mode */
+	ATH_BT_COEX_MODE_DISALBED,      /* coexistence disabled */
+};
+
+struct ath_btcoex_config {
+	u8 bt_time_extend;
+	bool bt_txstate_extend;
+	bool bt_txframe_extend;
+	enum ath_bt_mode bt_mode; /* coexistence mode */
+	bool bt_quiet_collision;
+	bool bt_rxclear_polarity; /* invert rx_clear as WLAN_ACTIVE*/
+	u8 bt_priority_time;
+	u8 bt_first_slot_time;
+	bool bt_hold_rx_clear;
+};
+
+static const u16 ath_subsysid_tbl[] = {
+	AR9280_COEX2WIRE_SUBSYSID,
+	AT9285_COEX3WIRE_SA_SUBSYSID,
+	AT9285_COEX3WIRE_DA_SUBSYSID
+};
+
+/*
+ * Checks the subsystem id of the device to see if it
+ * supports btcoex
+ */
+static bool ar9002_hw_btcoex_supported(struct ath_hw *ah)
+{
+	int i;
+
+	if (!ah->hw_version.subsysid)
+		return false;
+
+	for (i = 0; i < ARRAY_SIZE(ath_subsysid_tbl); i++)
+		if (ah->hw_version.subsysid == ath_subsysid_tbl[i])
+			return true;
+
+	return false;
+}
+
+static void ar9002_hw_btcoex_init(struct ath_hw *ah, int qnum)
+{
+	struct ath_btcoex_hw *btcoex_hw = &ah->btcoex_hw;
+	const struct ath_btcoex_config ath_bt_config = {
+		.bt_time_extend = 0,
+		.bt_txstate_extend = true,
+		.bt_txframe_extend = true,
+		.bt_mode = ATH_BT_COEX_MODE_SLOTTED,
+		.bt_quiet_collision = true,
+		.bt_rxclear_polarity = true,
+		.bt_priority_time = 2,
+		.bt_first_slot_time = 5,
+		.bt_hold_rx_clear = true,
+	};
+	u32 i;
+
+	btcoex_hw->bt_coex_mode =
+		(btcoex_hw->bt_coex_mode & AR_BT_QCU_THRESH) |
+		SM(ath_bt_config.bt_time_extend, AR_BT_TIME_EXTEND) |
+		SM(ath_bt_config.bt_txstate_extend, AR_BT_TXSTATE_EXTEND) |
+		SM(ath_bt_config.bt_txframe_extend, AR_BT_TX_FRAME_EXTEND) |
+		SM(ath_bt_config.bt_mode, AR_BT_MODE) |
+		SM(ath_bt_config.bt_quiet_collision, AR_BT_QUIET) |
+		SM(ath_bt_config.bt_rxclear_polarity, AR_BT_RX_CLEAR_POLARITY) |
+		SM(ath_bt_config.bt_priority_time, AR_BT_PRIORITY_TIME) |
+		SM(ath_bt_config.bt_first_slot_time, AR_BT_FIRST_SLOT_TIME) |
+		SM(qnum, AR_BT_QCU_THRESH);
+
+	btcoex_hw->bt_coex_mode2 =
+		SM(ath_bt_config.bt_hold_rx_clear, AR_BT_HOLD_RX_CLEAR) |
+		SM(ATH_BTCOEX_BMISS_THRESH, AR_BT_BCN_MISS_THRESH) |
+		AR_BT_DISABLE_BT_ANT;
+
+	for (i = 0; i < 32; i++)
+		ah->hw_gen_timers.gen_timer_index[(debruijn32 << i) >> 27] = i;
+}
+
+static void ar9002_hw_btcoex_init_2wire(struct ath_hw *ah)
+{
+	struct ath_btcoex_hw *btcoex_hw = &ah->btcoex_hw;
+
+	/* connect bt_active to baseband */
+	REG_CLR_BIT(ah, AR_GPIO_INPUT_EN_VAL,
+		    (AR_GPIO_INPUT_EN_VAL_BT_PRIORITY_DEF |
+		     AR_GPIO_INPUT_EN_VAL_BT_FREQUENCY_DEF));
+
+	REG_SET_BIT(ah, AR_GPIO_INPUT_EN_VAL,
+		    AR_GPIO_INPUT_EN_VAL_BT_ACTIVE_BB);
+
+	/* Set input mux for bt_active to gpio pin */
+	REG_RMW_FIELD(ah, AR_GPIO_INPUT_MUX1,
+		      AR_GPIO_INPUT_MUX1_BT_ACTIVE,
+		      btcoex_hw->btactive_gpio);
+
+	/* Configure the desired gpio port for input */
+	ath9k_hw_cfg_gpio_input(ah, btcoex_hw->btactive_gpio);
+}
+
+static void ar9002_hw_btcoex_init_3wire(struct ath_hw *ah)
+{
+	struct ath_btcoex_hw *btcoex_hw = &ah->btcoex_hw;
+
+	/* btcoex 3-wire */
+	REG_SET_BIT(ah, AR_GPIO_INPUT_EN_VAL,
+			(AR_GPIO_INPUT_EN_VAL_BT_PRIORITY_BB |
+			 AR_GPIO_INPUT_EN_VAL_BT_ACTIVE_BB));
+
+	/* Set input mux for bt_prority_async and
+	 *                  bt_active_async to GPIO pins */
+	REG_RMW_FIELD(ah, AR_GPIO_INPUT_MUX1,
+			AR_GPIO_INPUT_MUX1_BT_ACTIVE,
+			btcoex_hw->btactive_gpio);
+
+	REG_RMW_FIELD(ah, AR_GPIO_INPUT_MUX1,
+			AR_GPIO_INPUT_MUX1_BT_PRIORITY,
+			btcoex_hw->btpriority_gpio);
+
+	/* Configure the desired GPIO ports for input */
+
+	ath9k_hw_cfg_gpio_input(ah, btcoex_hw->btactive_gpio);
+	ath9k_hw_cfg_gpio_input(ah, btcoex_hw->btpriority_gpio);
+}
+
+static void ar9002_hw_btcoex_enable_2wire(struct ath_hw *ah)
+{
+	struct ath_btcoex_hw *btcoex_hw = &ah->btcoex_hw;
+
+	/* Configure the desired GPIO port for TX_FRAME output */
+	ath9k_hw_cfg_output(ah, btcoex_hw->wlanactive_gpio,
+			    AR_GPIO_OUTPUT_MUX_AS_TX_FRAME);
+}
+
+static void ar9002_hw_btcoex_set_weight(struct ath_hw *ah,
+					u32 bt_weight,
+					u32 wlan_weight)
+{
+	struct ath_btcoex_hw *btcoex_hw = &ah->btcoex_hw;
+
+	btcoex_hw->bt_coex_weights = SM(bt_weight, AR_BTCOEX_BT_WGHT) |
+				     SM(wlan_weight, AR_BTCOEX_WL_WGHT);
+}
+
+static void ar9002_hw_btcoex_enable_3wire(struct ath_hw *ah)
+{
+	struct ath_btcoex_hw *btcoex_hw = &ah->btcoex_hw;
+
+	/*
+	 * Program coex mode and weight registers to
+	 * enable coex 3-wire
+	 */
+	REG_WRITE(ah, AR_BT_COEX_MODE, btcoex_hw->bt_coex_mode);
+	REG_WRITE(ah, AR_BT_COEX_WEIGHT, btcoex_hw->bt_coex_weights);
+	REG_WRITE(ah, AR_BT_COEX_MODE2, btcoex_hw->bt_coex_mode2);
+
+	REG_RMW_FIELD(ah, AR_QUIET1, AR_QUIET1_QUIET_ACK_CTS_ENABLE, 1);
+	REG_RMW_FIELD(ah, AR_PCU_MISC, AR_PCU_BT_ANT_PREVENT_RX, 0);
+
+	ath9k_hw_cfg_output(ah, btcoex_hw->wlanactive_gpio,
+			    AR_GPIO_OUTPUT_MUX_AS_RX_CLEAR_EXTERNAL);
+}
+
+static void ar9002_hw_btcoex_enable(struct ath_hw *ah)
+{
+	struct ath_btcoex_hw *btcoex_hw = &ah->btcoex_hw;
+
+	switch (btcoex_hw->scheme) {
+	case ATH_BTCOEX_CFG_NONE:
+		break;
+	case ATH_BTCOEX_CFG_2WIRE:
+		ath9k_hw_btcoex_enable_2wire(ah);
+		break;
+	case ATH_BTCOEX_CFG_3WIRE:
+		ath9k_hw_btcoex_enable_3wire(ah);
+		break;
+	}
+
+	REG_RMW(ah, AR_GPIO_PDPU,
+		(0x2 << (btcoex_hw->btactive_gpio * 2)),
+		(0x3 << (btcoex_hw->btactive_gpio * 2)));
+
+	ah->btcoex_hw.enabled = true;
+}
+
+static void ar9002_hw_btcoex_disable(struct ath_hw *ah)
+{
+	struct ath_btcoex_hw *btcoex_hw = &ah->btcoex_hw;
+
+	ath9k_hw_set_gpio(ah, btcoex_hw->wlanactive_gpio, 0);
+
+	ath9k_hw_cfg_output(ah, btcoex_hw->wlanactive_gpio,
+			AR_GPIO_OUTPUT_MUX_AS_OUTPUT);
+
+	if (btcoex_hw->scheme == ATH_BTCOEX_CFG_3WIRE) {
+		REG_WRITE(ah, AR_BT_COEX_MODE, AR_BT_QUIET | AR_BT_MODE);
+		REG_WRITE(ah, AR_BT_COEX_WEIGHT, 0);
+		REG_WRITE(ah, AR_BT_COEX_MODE2, 0);
+	}
+
+	ah->btcoex_hw.enabled = false;
+}
+
+void ar9002_hw_attach_btcoex_ops(struct ath_hw *ah)
+{
+	struct ath_hw_private_ops *priv_ops = ath9k_hw_private_ops(ah);
+	struct ath_hw_ops *ops = ath9k_hw_ops(ah);
+
+	priv_ops->btcoex_supported = &ar9002_hw_btcoex_supported;
+	priv_ops->btcoex_enable_2wire = &ar9002_hw_btcoex_enable_2wire;
+	priv_ops->btcoex_enable_3wire = &ar9002_hw_btcoex_enable_3wire;
+
+	ops->btcoex_init = &ar9002_hw_btcoex_init;
+	ops->btcoex_init_2wire = &ar9002_hw_btcoex_init_2wire;
+	ops->btcoex_init_3wire = &ar9002_hw_btcoex_init_3wire;
+	ops->btcoex_set_weight = &ar9002_hw_btcoex_set_weight;
+	ops->btcoex_enable = &ar9002_hw_btcoex_enable;
+	ops->btcoex_disable = &ar9002_hw_btcoex_disable;
+}
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_hw.c b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
index 7c46c1e..8e5a07d 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
@@ -19,6 +19,8 @@
 #include "rc.h"
 #include "ar9002_initvals.h"
 
+extern void ar9002_hw_attach_btcoex_ops(struct ath_hw *ah);
+
 static void ar9002_hw_disablepcie(struct ath_hw *ah)
 {
 	if (AR_SREV_9100(ah))
@@ -812,5 +814,6 @@ void ar9002_hw_attach_ops(struct ath_hw *ah)
 	ops->config_pci_powersave = &ar9002_hw_configpcipowersave;
 
 	ar9002_hw_attach_calib_ops(ah);
+	ar9002_hw_attach_btcoex_ops(ah);
 }
 EXPORT_SYMBOL(ar9002_hw_attach_ops);
diff --git a/drivers/net/wireless/ath/ath9k/btcoex.c b/drivers/net/wireless/ath/ath9k/btcoex.c
deleted file mode 100644
index fb4ac15..0000000
--- a/drivers/net/wireless/ath/ath9k/btcoex.c
+++ /dev/null
@@ -1,227 +0,0 @@
-/*
- * Copyright (c) 2009 Atheros Communications Inc.
- *
- * Permission to use, copy, modify, and/or distribute this software for any
- * purpose with or without fee is hereby granted, provided that the above
- * copyright notice and this permission notice appear in all copies.
- *
- * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
- * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
- * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
- * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
- * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
- * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
- * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
- */
-
-#include "hw.h"
-
-enum ath_bt_mode {
-	ATH_BT_COEX_MODE_LEGACY,        /* legacy rx_clear mode */
-	ATH_BT_COEX_MODE_UNSLOTTED,     /* untimed/unslotted mode */
-	ATH_BT_COEX_MODE_SLOTTED,       /* slotted mode */
-	ATH_BT_COEX_MODE_DISALBED,      /* coexistence disabled */
-};
-
-struct ath_btcoex_config {
-	u8 bt_time_extend;
-	bool bt_txstate_extend;
-	bool bt_txframe_extend;
-	enum ath_bt_mode bt_mode; /* coexistence mode */
-	bool bt_quiet_collision;
-	bool bt_rxclear_polarity; /* invert rx_clear as WLAN_ACTIVE*/
-	u8 bt_priority_time;
-	u8 bt_first_slot_time;
-	bool bt_hold_rx_clear;
-};
-
-static const u16 ath_subsysid_tbl[] = {
-	AR9280_COEX2WIRE_SUBSYSID,
-	AT9285_COEX3WIRE_SA_SUBSYSID,
-	AT9285_COEX3WIRE_DA_SUBSYSID
-};
-
-/*
- * Checks the subsystem id of the device to see if it
- * supports btcoex
- */
-bool ath9k_hw_btcoex_supported(struct ath_hw *ah)
-{
-	int i;
-
-	if (!ah->hw_version.subsysid)
-		return false;
-
-	for (i = 0; i < ARRAY_SIZE(ath_subsysid_tbl); i++)
-		if (ah->hw_version.subsysid == ath_subsysid_tbl[i])
-			return true;
-
-	return false;
-}
-
-void ath9k_hw_init_btcoex_hw(struct ath_hw *ah, int qnum)
-{
-	struct ath_btcoex_hw *btcoex_hw = &ah->btcoex_hw;
-	const struct ath_btcoex_config ath_bt_config = {
-		.bt_time_extend = 0,
-		.bt_txstate_extend = true,
-		.bt_txframe_extend = true,
-		.bt_mode = ATH_BT_COEX_MODE_SLOTTED,
-		.bt_quiet_collision = true,
-		.bt_rxclear_polarity = true,
-		.bt_priority_time = 2,
-		.bt_first_slot_time = 5,
-		.bt_hold_rx_clear = true,
-	};
-	u32 i;
-
-	btcoex_hw->bt_coex_mode =
-		(btcoex_hw->bt_coex_mode & AR_BT_QCU_THRESH) |
-		SM(ath_bt_config.bt_time_extend, AR_BT_TIME_EXTEND) |
-		SM(ath_bt_config.bt_txstate_extend, AR_BT_TXSTATE_EXTEND) |
-		SM(ath_bt_config.bt_txframe_extend, AR_BT_TX_FRAME_EXTEND) |
-		SM(ath_bt_config.bt_mode, AR_BT_MODE) |
-		SM(ath_bt_config.bt_quiet_collision, AR_BT_QUIET) |
-		SM(ath_bt_config.bt_rxclear_polarity, AR_BT_RX_CLEAR_POLARITY) |
-		SM(ath_bt_config.bt_priority_time, AR_BT_PRIORITY_TIME) |
-		SM(ath_bt_config.bt_first_slot_time, AR_BT_FIRST_SLOT_TIME) |
-		SM(qnum, AR_BT_QCU_THRESH);
-
-	btcoex_hw->bt_coex_mode2 =
-		SM(ath_bt_config.bt_hold_rx_clear, AR_BT_HOLD_RX_CLEAR) |
-		SM(ATH_BTCOEX_BMISS_THRESH, AR_BT_BCN_MISS_THRESH) |
-		AR_BT_DISABLE_BT_ANT;
-
-	for (i = 0; i < 32; i++)
-		ah->hw_gen_timers.gen_timer_index[(debruijn32 << i) >> 27] = i;
-}
-EXPORT_SYMBOL(ath9k_hw_init_btcoex_hw);
-
-void ath9k_hw_btcoex_init_2wire(struct ath_hw *ah)
-{
-	struct ath_btcoex_hw *btcoex_hw = &ah->btcoex_hw;
-
-	/* connect bt_active to baseband */
-	REG_CLR_BIT(ah, AR_GPIO_INPUT_EN_VAL,
-		    (AR_GPIO_INPUT_EN_VAL_BT_PRIORITY_DEF |
-		     AR_GPIO_INPUT_EN_VAL_BT_FREQUENCY_DEF));
-
-	REG_SET_BIT(ah, AR_GPIO_INPUT_EN_VAL,
-		    AR_GPIO_INPUT_EN_VAL_BT_ACTIVE_BB);
-
-	/* Set input mux for bt_active to gpio pin */
-	REG_RMW_FIELD(ah, AR_GPIO_INPUT_MUX1,
-		      AR_GPIO_INPUT_MUX1_BT_ACTIVE,
-		      btcoex_hw->btactive_gpio);
-
-	/* Configure the desired gpio port for input */
-	ath9k_hw_cfg_gpio_input(ah, btcoex_hw->btactive_gpio);
-}
-EXPORT_SYMBOL(ath9k_hw_btcoex_init_2wire);
-
-void ath9k_hw_btcoex_init_3wire(struct ath_hw *ah)
-{
-	struct ath_btcoex_hw *btcoex_hw = &ah->btcoex_hw;
-
-	/* btcoex 3-wire */
-	REG_SET_BIT(ah, AR_GPIO_INPUT_EN_VAL,
-			(AR_GPIO_INPUT_EN_VAL_BT_PRIORITY_BB |
-			 AR_GPIO_INPUT_EN_VAL_BT_ACTIVE_BB));
-
-	/* Set input mux for bt_prority_async and
-	 *                  bt_active_async to GPIO pins */
-	REG_RMW_FIELD(ah, AR_GPIO_INPUT_MUX1,
-			AR_GPIO_INPUT_MUX1_BT_ACTIVE,
-			btcoex_hw->btactive_gpio);
-
-	REG_RMW_FIELD(ah, AR_GPIO_INPUT_MUX1,
-			AR_GPIO_INPUT_MUX1_BT_PRIORITY,
-			btcoex_hw->btpriority_gpio);
-
-	/* Configure the desired GPIO ports for input */
-
-	ath9k_hw_cfg_gpio_input(ah, btcoex_hw->btactive_gpio);
-	ath9k_hw_cfg_gpio_input(ah, btcoex_hw->btpriority_gpio);
-}
-EXPORT_SYMBOL(ath9k_hw_btcoex_init_3wire);
-
-static void ath9k_hw_btcoex_enable_2wire(struct ath_hw *ah)
-{
-	struct ath_btcoex_hw *btcoex_hw = &ah->btcoex_hw;
-
-	/* Configure the desired GPIO port for TX_FRAME output */
-	ath9k_hw_cfg_output(ah, btcoex_hw->wlanactive_gpio,
-			    AR_GPIO_OUTPUT_MUX_AS_TX_FRAME);
-}
-
-void ath9k_hw_btcoex_set_weight(struct ath_hw *ah,
-				u32 bt_weight,
-				u32 wlan_weight)
-{
-	struct ath_btcoex_hw *btcoex_hw = &ah->btcoex_hw;
-
-	btcoex_hw->bt_coex_weights = SM(bt_weight, AR_BTCOEX_BT_WGHT) |
-				     SM(wlan_weight, AR_BTCOEX_WL_WGHT);
-}
-EXPORT_SYMBOL(ath9k_hw_btcoex_set_weight);
-
-static void ath9k_hw_btcoex_enable_3wire(struct ath_hw *ah)
-{
-	struct ath_btcoex_hw *btcoex_hw = &ah->btcoex_hw;
-
-	/*
-	 * Program coex mode and weight registers to
-	 * enable coex 3-wire
-	 */
-	REG_WRITE(ah, AR_BT_COEX_MODE, btcoex_hw->bt_coex_mode);
-	REG_WRITE(ah, AR_BT_COEX_WEIGHT, btcoex_hw->bt_coex_weights);
-	REG_WRITE(ah, AR_BT_COEX_MODE2, btcoex_hw->bt_coex_mode2);
-
-	REG_RMW_FIELD(ah, AR_QUIET1, AR_QUIET1_QUIET_ACK_CTS_ENABLE, 1);
-	REG_RMW_FIELD(ah, AR_PCU_MISC, AR_PCU_BT_ANT_PREVENT_RX, 0);
-
-	ath9k_hw_cfg_output(ah, btcoex_hw->wlanactive_gpio,
-			    AR_GPIO_OUTPUT_MUX_AS_RX_CLEAR_EXTERNAL);
-}
-
-void ath9k_hw_btcoex_enable(struct ath_hw *ah)
-{
-	struct ath_btcoex_hw *btcoex_hw = &ah->btcoex_hw;
-
-	switch (btcoex_hw->scheme) {
-	case ATH_BTCOEX_CFG_NONE:
-		break;
-	case ATH_BTCOEX_CFG_2WIRE:
-		ath9k_hw_btcoex_enable_2wire(ah);
-		break;
-	case ATH_BTCOEX_CFG_3WIRE:
-		ath9k_hw_btcoex_enable_3wire(ah);
-		break;
-	}
-
-	REG_RMW(ah, AR_GPIO_PDPU,
-		(0x2 << (btcoex_hw->btactive_gpio * 2)),
-		(0x3 << (btcoex_hw->btactive_gpio * 2)));
-
-	ah->btcoex_hw.enabled = true;
-}
-EXPORT_SYMBOL(ath9k_hw_btcoex_enable);
-
-void ath9k_hw_btcoex_disable(struct ath_hw *ah)
-{
-	struct ath_btcoex_hw *btcoex_hw = &ah->btcoex_hw;
-
-	ath9k_hw_set_gpio(ah, btcoex_hw->wlanactive_gpio, 0);
-
-	ath9k_hw_cfg_output(ah, btcoex_hw->wlanactive_gpio,
-			AR_GPIO_OUTPUT_MUX_AS_OUTPUT);
-
-	if (btcoex_hw->scheme == ATH_BTCOEX_CFG_3WIRE) {
-		REG_WRITE(ah, AR_BT_COEX_MODE, AR_BT_QUIET | AR_BT_MODE);
-		REG_WRITE(ah, AR_BT_COEX_WEIGHT, 0);
-		REG_WRITE(ah, AR_BT_COEX_MODE2, 0);
-	}
-
-	ah->btcoex_hw.enabled = false;
-}
-EXPORT_SYMBOL(ath9k_hw_btcoex_disable);
diff --git a/drivers/net/wireless/ath/ath9k/btcoex.h b/drivers/net/wireless/ath/ath9k/btcoex.h
index 1ee5a15..0217df0 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.h
+++ b/drivers/net/wireless/ath/ath9k/btcoex.h
@@ -49,14 +49,4 @@ struct ath_btcoex_hw {
 	u32 bt_coex_mode2; 	/* Register setting for AR_BT_COEX_MODE2 */
 };
 
-bool ath9k_hw_btcoex_supported(struct ath_hw *ah);
-void ath9k_hw_btcoex_init_2wire(struct ath_hw *ah);
-void ath9k_hw_btcoex_init_3wire(struct ath_hw *ah);
-void ath9k_hw_init_btcoex_hw(struct ath_hw *ah, int qnum);
-void ath9k_hw_btcoex_set_weight(struct ath_hw *ah,
-				u32 bt_weight,
-				u32 wlan_weight);
-void ath9k_hw_btcoex_enable(struct ath_hw *ah);
-void ath9k_hw_btcoex_disable(struct ath_hw *ah);
-
 #endif
diff --git a/drivers/net/wireless/ath/ath9k/hw-ops.h b/drivers/net/wireless/ath/ath9k/hw-ops.h
index 6d20bb7..3e4f49f 100644
--- a/drivers/net/wireless/ath/ath9k/hw-ops.h
+++ b/drivers/net/wireless/ath/ath9k/hw-ops.h
@@ -112,4 +112,55 @@ static inline void ath9k_hw_pa_cal(struct ath_hw *ah)
 	ath9k_hw_private_ops(ah)->pa_cal(ah);
 }
 
+/* Bluetooth coexistence ops */
+
+static inline bool ath9k_hw_btcoex_supported(struct ath_hw *ah)
+{
+	if (!ath9k_hw_private_ops(ah)->btcoex_supported)
+		return false;
+	return ath9k_hw_private_ops(ah)->btcoex_supported(ah);
+}
+
+static inline void ath9k_hw_btcoex_enable_2wire(struct ath_hw *ah)
+{
+	ath9k_hw_private_ops(ah)->btcoex_enable_2wire(ah);
+}
+
+static inline void ath9k_hw_btcoex_enable_3wire(struct ath_hw *ah)
+{
+	ath9k_hw_private_ops(ah)->btcoex_enable_3wire(ah);
+}
+
+static inline void ath9k_hw_btcoex_init(struct ath_hw *ah, int qnum)
+{
+	ath9k_hw_ops(ah)->btcoex_init(ah, qnum);
+}
+
+static inline void ath9k_hw_btcoex_init_2wire(struct ath_hw *ah)
+{
+	ath9k_hw_ops(ah)->btcoex_init_2wire(ah);
+}
+
+static inline void ath9k_hw_btcoex_init_3wire(struct ath_hw *ah)
+{
+	ath9k_hw_ops(ah)->btcoex_init_3wire(ah);
+}
+
+static inline void ath9k_hw_btcoex_set_weight(struct ath_hw *ah,
+					      u32 bt_weight,
+					      u32 wlan_weight)
+{
+	ath9k_hw_ops(ah)->btcoex_set_weight(ah, bt_weight, wlan_weight);
+}
+
+static inline void ath9k_hw_btcoex_enable(struct ath_hw *ah)
+{
+	ath9k_hw_ops(ah)->btcoex_enable(ah);
+}
+
+static inline void ath9k_hw_btcoex_disable(struct ath_hw *ah)
+{
+	ath9k_hw_ops(ah)->btcoex_disable(ah);
+}
+
 #endif /* ATH9K_HW_OPS_H */
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 06d5c2a..ed137a8 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -465,6 +465,10 @@ struct ath_gen_timer_table {
  * @loadnf:
  * @start_nfcal: start noise floor calibration
  * @pa_cal: Power amplifier calibration
+ *
+ * @btcoex_supported: whether or not bluetooth coexistence is supported
+ * @btcoex_enable_2wire:
+ * @btcoex_enable_3wire:
  */
 struct ath_hw_private_ops {
 	/* General hardware ops */
@@ -490,6 +494,11 @@ struct ath_hw_private_ops {
 	void (*loadnf)(struct ath_hw *ah, struct ath9k_channel *chan);
 	void (*start_nfcal)(struct ath_hw *ah);
 	void (*pa_cal)(struct ath_hw *ah);
+
+	/* Bluetooth coexistence ops */
+	bool (*btcoex_supported)(struct ath_hw *ah);
+	void (*btcoex_enable_2wire)(struct ath_hw *ah);
+	void (*btcoex_enable_3wire)(struct ath_hw *ah);
 };
 
 /**
@@ -500,12 +509,29 @@ struct ath_hw_private_ops {
  *
  * @set_power:
  * @config_pci_powersave:
+ *
+ * @btcoex_init:
+ * @btcoex_init_2wire:
+ * @btcoex_init_3wire:
+ * @btcoex_set_weight:
+ * @btcoex_enable:
+ * @btcoex_disable:
  */
 struct ath_hw_ops {
 	bool (*set_power)(struct ath_hw *ah, enum ath9k_power_mode mode);
 	void (*config_pci_powersave)(struct ath_hw *ah,
 				    int restore,
 				    int power_off);
+
+	/* Bluetooth coexistence ops */
+	void (*btcoex_init)(struct ath_hw *ah, int qnum);
+	void (*btcoex_init_2wire)(struct ath_hw *ah);
+	void (*btcoex_init_3wire)(struct ath_hw *ah);
+	void (*btcoex_set_weight)(struct ath_hw *ah,
+				  u32 bt_weight,
+				  u32 wlan_weight);
+	void (*btcoex_enable)(struct ath_hw *ah);
+	void (*btcoex_disable)(struct ath_hw *ah);
 };
 
 struct ath_hw {
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 62682cc..b7fd491 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -402,7 +402,7 @@ static int ath9k_init_btcoex(struct ath_softc *sc)
 		if (r)
 			return -1;
 		qnum = ath_tx_get_qnum(sc, ATH9K_TX_QUEUE_DATA, ATH9K_WME_AC_BE);
-		ath9k_hw_init_btcoex_hw(sc->sc_ah, qnum);
+		ath9k_hw_btcoex_init(sc->sc_ah, qnum);
 		sc->btcoex.bt_stomp_type = ATH_BTCOEX_STOMP_LOW;
 		break;
 	default:
-- 
1.6.3.3

