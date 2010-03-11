Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46902 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317Ab0CKB2c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Mar 2010 20:28:32 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 08/14] ath9k_hw: move ar9002 bluetooth coexistence code to its own file
Date: Wed, 10 Mar 2010 20:28:25 -0500
Message-Id: <1268270911-24568-9-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1268270911-24568-1-git-send-email-lrodriguez@atheros.com>
References: <1268270911-24568-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It turns out all these routines do their own read/writes so just move the
entire file. If btcoex is supported by the chipset the calls will be enabled
and the driver core and hardware call will issue calls for btcoex.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/Makefile            |    2 +-
 .../ath/ath9k/{btcoex.c => ar9002_btcoex.c}        |   46 +++++++++++-------
 drivers/net/wireless/ath/ath9k/ar9002_hw.c         |    3 +
 drivers/net/wireless/ath/ath9k/btcoex.h            |   10 ----
 drivers/net/wireless/ath/ath9k/hw-ops.h            |   51 ++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/hw.h                |   26 ++++++++++
 drivers/net/wireless/ath/ath9k/init.c              |    2 +-
 7 files changed, 111 insertions(+), 29 deletions(-)
 rename drivers/net/wireless/ath/ath9k/{btcoex.c => ar9002_btcoex.c} (82%)

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
diff --git a/drivers/net/wireless/ath/ath9k/btcoex.c b/drivers/net/wireless/ath/ath9k/ar9002_btcoex.c
similarity index 82%
rename from drivers/net/wireless/ath/ath9k/btcoex.c
rename to drivers/net/wireless/ath/ath9k/ar9002_btcoex.c
index fb4ac15..3db3edb 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_btcoex.c
@@ -15,6 +15,7 @@
  */
 
 #include "hw.h"
+#include "hw-ops.h"
 
 enum ath_bt_mode {
 	ATH_BT_COEX_MODE_LEGACY,        /* legacy rx_clear mode */
@@ -45,7 +46,7 @@ static const u16 ath_subsysid_tbl[] = {
  * Checks the subsystem id of the device to see if it
  * supports btcoex
  */
-bool ath9k_hw_btcoex_supported(struct ath_hw *ah)
+static bool ar9002_hw_btcoex_supported(struct ath_hw *ah)
 {
 	int i;
 
@@ -59,7 +60,7 @@ bool ath9k_hw_btcoex_supported(struct ath_hw *ah)
 	return false;
 }
 
-void ath9k_hw_init_btcoex_hw(struct ath_hw *ah, int qnum)
+static void ar9002_hw_btcoex_init(struct ath_hw *ah, int qnum)
 {
 	struct ath_btcoex_hw *btcoex_hw = &ah->btcoex_hw;
 	const struct ath_btcoex_config ath_bt_config = {
@@ -95,9 +96,8 @@ void ath9k_hw_init_btcoex_hw(struct ath_hw *ah, int qnum)
 	for (i = 0; i < 32; i++)
 		ah->hw_gen_timers.gen_timer_index[(debruijn32 << i) >> 27] = i;
 }
-EXPORT_SYMBOL(ath9k_hw_init_btcoex_hw);
 
-void ath9k_hw_btcoex_init_2wire(struct ath_hw *ah)
+static void ar9002_hw_btcoex_init_2wire(struct ath_hw *ah)
 {
 	struct ath_btcoex_hw *btcoex_hw = &ah->btcoex_hw;
 
@@ -117,9 +117,8 @@ void ath9k_hw_btcoex_init_2wire(struct ath_hw *ah)
 	/* Configure the desired gpio port for input */
 	ath9k_hw_cfg_gpio_input(ah, btcoex_hw->btactive_gpio);
 }
-EXPORT_SYMBOL(ath9k_hw_btcoex_init_2wire);
 
-void ath9k_hw_btcoex_init_3wire(struct ath_hw *ah)
+static void ar9002_hw_btcoex_init_3wire(struct ath_hw *ah)
 {
 	struct ath_btcoex_hw *btcoex_hw = &ah->btcoex_hw;
 
@@ -143,9 +142,8 @@ void ath9k_hw_btcoex_init_3wire(struct ath_hw *ah)
 	ath9k_hw_cfg_gpio_input(ah, btcoex_hw->btactive_gpio);
 	ath9k_hw_cfg_gpio_input(ah, btcoex_hw->btpriority_gpio);
 }
-EXPORT_SYMBOL(ath9k_hw_btcoex_init_3wire);
 
-static void ath9k_hw_btcoex_enable_2wire(struct ath_hw *ah)
+static void ar9002_hw_btcoex_enable_2wire(struct ath_hw *ah)
 {
 	struct ath_btcoex_hw *btcoex_hw = &ah->btcoex_hw;
 
@@ -154,18 +152,17 @@ static void ath9k_hw_btcoex_enable_2wire(struct ath_hw *ah)
 			    AR_GPIO_OUTPUT_MUX_AS_TX_FRAME);
 }
 
-void ath9k_hw_btcoex_set_weight(struct ath_hw *ah,
-				u32 bt_weight,
-				u32 wlan_weight)
+static void ar9002_hw_btcoex_set_weight(struct ath_hw *ah,
+					u32 bt_weight,
+					u32 wlan_weight)
 {
 	struct ath_btcoex_hw *btcoex_hw = &ah->btcoex_hw;
 
 	btcoex_hw->bt_coex_weights = SM(bt_weight, AR_BTCOEX_BT_WGHT) |
 				     SM(wlan_weight, AR_BTCOEX_WL_WGHT);
 }
-EXPORT_SYMBOL(ath9k_hw_btcoex_set_weight);
 
-static void ath9k_hw_btcoex_enable_3wire(struct ath_hw *ah)
+static void ar9002_hw_btcoex_enable_3wire(struct ath_hw *ah)
 {
 	struct ath_btcoex_hw *btcoex_hw = &ah->btcoex_hw;
 
@@ -184,7 +181,7 @@ static void ath9k_hw_btcoex_enable_3wire(struct ath_hw *ah)
 			    AR_GPIO_OUTPUT_MUX_AS_RX_CLEAR_EXTERNAL);
 }
 
-void ath9k_hw_btcoex_enable(struct ath_hw *ah)
+static void ar9002_hw_btcoex_enable(struct ath_hw *ah)
 {
 	struct ath_btcoex_hw *btcoex_hw = &ah->btcoex_hw;
 
@@ -205,9 +202,8 @@ void ath9k_hw_btcoex_enable(struct ath_hw *ah)
 
 	ah->btcoex_hw.enabled = true;
 }
-EXPORT_SYMBOL(ath9k_hw_btcoex_enable);
 
-void ath9k_hw_btcoex_disable(struct ath_hw *ah)
+static void ar9002_hw_btcoex_disable(struct ath_hw *ah)
 {
 	struct ath_btcoex_hw *btcoex_hw = &ah->btcoex_hw;
 
@@ -224,4 +220,20 @@ void ath9k_hw_btcoex_disable(struct ath_hw *ah)
 
 	ah->btcoex_hw.enabled = false;
 }
-EXPORT_SYMBOL(ath9k_hw_btcoex_disable);
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
index d937b47..5363878 100644
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
@@ -811,5 +813,6 @@ void ar9002_hw_attach_ops(struct ath_hw *ah)
 	ops->config_pci_powersave = &ar9002_hw_configpcipowersave;
 
 	ar9002_hw_attach_calib_ops(ah);
+	ar9002_hw_attach_btcoex_ops(ah);
 }
 EXPORT_SYMBOL(ar9002_hw_attach_ops);
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

