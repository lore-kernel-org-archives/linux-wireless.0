Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:43140 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755238AbYC1XZc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2008 19:25:32 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Mohamed Abbas <mabbas@linux.intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 2/8] iwlwifi: hook iwlwifi with Linux rfkill
Date: Fri, 28 Mar 2008 16:21:06 -0700
Message-Id: <1206746472-10443-3-git-send-email-reinette.chatre@intel.com> (sfid-20080328_232535_678419_F214775B)
In-Reply-To: <1206746472-10443-2-git-send-email-reinette.chatre@intel.com>
References: <1206746472-10443-1-git-send-email-reinette.chatre@intel.com>
 <1206746472-10443-2-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohamed Abbas <mabbas@linux.intel.com>

This patch hook IWL with Linux rfkill.

Signed-off-by: Mohamed Abbas <mabbas@linux.intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/Kconfig        |    6 +
 drivers/net/wireless/iwlwifi/Makefile       |    4 +
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    1 +
 drivers/net/wireless/iwlwifi/iwl-4965.h     |    5 +
 drivers/net/wireless/iwlwifi/iwl-core.c     |    4 +
 drivers/net/wireless/iwlwifi/iwl-core.h     |    1 +
 drivers/net/wireless/iwlwifi/iwl-rfkill.c   |  174 +++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-rfkill.h   |   56 +++++++++
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   54 +++-----
 9 files changed, 271 insertions(+), 34 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-rfkill.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-rfkill.h

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index c26ca74..4a5c8c0 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -9,6 +9,12 @@ config IWLWIFI_LEDS
 	  This option enables LEDS for the iwlwifi drivers
 
 
+config IWLCORE_RFKILL
+	boolean "IWLWIFI RF kill support"
+	depends on IWLCORE
+	select RFKILL
+	select RFKILL_INPUT
+
 config IWL4965
 	tristate "Intel Wireless WiFi 4965AGN"
 	depends on PCI && MAC80211 && WLAN_80211 && EXPERIMENTAL
diff --git a/drivers/net/wireless/iwlwifi/Makefile b/drivers/net/wireless/iwlwifi/Makefile
index 64fca4d..2751e8a 100644
--- a/drivers/net/wireless/iwlwifi/Makefile
+++ b/drivers/net/wireless/iwlwifi/Makefile
@@ -9,6 +9,10 @@ ifeq ($(CONFIG_IWLWIFI_LEDS),y)
 	iwlcore-objs += iwl-led.o
 endif
 
+ifeq ($(CONFIG_IWLCORE_RFKILL),y)
+	iwlcore-objs += iwl-rfkill.o
+endif
+
 obj-$(CONFIG_IWL3945)	+= iwl3945.o
 iwl3945-objs		= iwl3945-base.o iwl-3945.o iwl-3945-rs.o
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index e5f64d7..3ab5d82 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -4961,6 +4961,7 @@ static struct iwl_lib_ops iwl4965_lib = {
 		.acquire_semaphore = iwlcore_eeprom_acquire_semaphore,
 		.release_semaphore = iwlcore_eeprom_release_semaphore,
 	},
+	.radio_kill_sw = iwl4965_radio_kill_sw,
 };
 
 static struct iwl_ops iwl4965_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wireless/iwlwifi/iwl-4965.h
index 069e591..ca864fa 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -40,6 +40,7 @@
 extern struct pci_device_id iwl4965_hw_card_ids[];
 
 #define DRV_NAME        "iwl4965"
+#include "iwl-rfkill.h"
 #include "iwl-eeprom.h"
 #include "iwl-4965-hw.h"
 #include "iwl-csr.h"
@@ -739,6 +740,7 @@ extern int iwl4965_tx_queue_reclaim(struct iwl_priv *priv, int txq_id, int index
 extern int iwl4965_queue_space(const struct iwl4965_queue *q);
 struct iwl_priv;
 
+extern void iwl4965_radio_kill_sw(struct iwl_priv *priv, int disable_radio);
 /*
  * Forward declare iwl-4965.c functions for iwl-base.c
  */
@@ -1050,6 +1052,9 @@ struct iwl_priv {
 	 * 4965's initialize alive response contains some calibration data. */
 	struct iwl4965_init_alive_resp card_alive_init;
 	struct iwl4965_alive_resp card_alive;
+#ifdef CONFIG_IWLCORE_RFKILL
+	struct iwl_rfkill_mngr rfkill_mngr;
+#endif
 
 #ifdef CONFIG_IWL4965_LEDS
 	struct iwl4965_led led[IWL_LED_TRG_MAX];
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 342a269..49fb52f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -35,6 +35,7 @@ struct iwl_priv; /* FIXME: remove */
 #include "iwl-debug.h"
 #include "iwl-eeprom.h"
 #include "iwl-core.h"
+#include "iwl-rfkill.h"
 
 #include "iwl-4965.h" /* FIXME: remove */
 
@@ -257,12 +258,15 @@ int iwlcore_low_level_notify(struct iwl_priv *priv,
 {
 	switch (notify) {
 	case IWLCORE_INIT_EVT:
+		iwl_rfkill_init(priv);
 		break;
 	case IWLCORE_START_EVT:
 		break;
 	case IWLCORE_STOP_EVT:
 		break;
 	case IWLCORE_REMOVE_EVT:
+		iwl_rfkill_unregister(priv);
+		iwl_rfkill_free(priv);
 		break;
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 4dfa059..5efafe1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -91,6 +91,7 @@ struct iwl_lib_ops {
 	int (*init_drv)(struct iwl_priv *priv);
 	/* eeprom operations (as defined in iwl-eeprom.h) */
 	struct iwl_eeprom_ops eeprom_ops;
+	void (*radio_kill_sw)(struct iwl_priv *priv, int disable_radio);
 };
 
 struct iwl_ops {
diff --git a/drivers/net/wireless/iwlwifi/iwl-rfkill.c b/drivers/net/wireless/iwlwifi/iwl-rfkill.c
new file mode 100644
index 0000000..66abf52
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-rfkill.c
@@ -0,0 +1,174 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2003 - 2008 Intel Corporation. All rights reserved.
+ *
+ * Portions of this file are derived from the ipw3945 project, as well
+ * as portions of the ieee80211 subsystem header files.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * The full GNU General Public License is included in this distribution in the
+ * file called LICENSE.
+ *
+ * Contact Information:
+ * James P. Ketrenos <ipw2100-admin@linux.intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *****************************************************************************/
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/version.h>
+#include <linux/init.h>
+
+#include <net/mac80211.h>
+
+#include "iwl-eeprom.h"
+#include "iwl-core.h"
+#include "iwl-4965.h"
+#include "iwl-helpers.h"
+
+
+static inline int iwl_is_rfkill(struct iwl_priv *priv)
+{
+	return test_bit(STATUS_RF_KILL_HW, &priv->status) ||
+		test_bit(STATUS_RF_KILL_SW, &priv->status);
+}
+
+
+/* software rf-kill from user */
+static int iwl_rfkill_soft_rf_kill(void *data, enum rfkill_state state)
+{
+	struct iwl_priv *priv = data;
+	int err = 0;
+
+	if (!priv->rfkill_mngr.rfkill)
+		return 0;
+
+	IWL_DEBUG_RF_KILL("we recieved soft RFKILL set to state %d\n", state);
+	mutex_lock(&priv->mutex);
+
+	switch (state) {
+	case RFKILL_STATE_ON:
+		priv->cfg->ops->lib->radio_kill_sw(priv, 0);
+		/* if HW rf-kill is set dont allow ON state */
+		if (iwl_is_rfkill(priv))
+			err = -EBUSY;
+		break;
+	case RFKILL_STATE_OFF:
+		priv->cfg->ops->lib->radio_kill_sw(priv, 1);
+		if (!iwl_is_rfkill(priv))
+			err = -EBUSY;
+		break;
+	}
+	mutex_unlock(&priv->mutex);
+
+	return err;
+}
+
+int iwl_rfkill_init(struct iwl_priv *priv)
+{
+	struct device *device = wiphy_dev(priv->hw->wiphy);
+	int ret = 0;
+
+	BUG_ON(device == NULL);
+
+	priv->rfkill_mngr.rfkill = rfkill_allocate(device, RFKILL_TYPE_WLAN);
+	if (!priv->rfkill_mngr.rfkill) {
+		ret = -ENOMEM;
+		goto error;
+	}
+
+	priv->rfkill_mngr.rfkill->name = priv->cfg->name;
+	priv->rfkill_mngr.rfkill->data = priv;
+	priv->rfkill_mngr.rfkill->state = RFKILL_STATE_ON;
+	priv->rfkill_mngr.rfkill->toggle_radio = iwl_rfkill_soft_rf_kill;
+	priv->rfkill_mngr.rfkill->user_claim_unsupported = 1;
+
+	priv->rfkill_mngr.rfkill->dev.class->suspend = NULL;
+	priv->rfkill_mngr.rfkill->dev.class->resume = NULL;
+
+	priv->rfkill_mngr.input_dev = input_allocate_device();
+	if (!priv->rfkill_mngr.input_dev) {
+		ret = -ENOMEM;
+		goto freed_rfkill;
+	}
+
+	priv->rfkill_mngr.input_dev->name = priv->cfg->name;
+	priv->rfkill_mngr.input_dev->phys = wiphy_name(priv->hw->wiphy);
+	priv->rfkill_mngr.input_dev->id.bustype = BUS_HOST;
+	priv->rfkill_mngr.input_dev->id.vendor = priv->pci_dev->vendor;
+	priv->rfkill_mngr.input_dev->dev.parent = device;
+	priv->rfkill_mngr.input_dev->evbit[0] = BIT(EV_KEY);
+	set_bit(KEY_WLAN, priv->rfkill_mngr.input_dev->keybit);
+
+	ret = rfkill_register(priv->rfkill_mngr.rfkill);
+	if (ret)
+		goto free_input_dev;
+
+	ret = input_register_device(priv->rfkill_mngr.input_dev);
+	if (ret)
+		goto unregister_rfkill;
+
+	return ret;
+
+unregister_rfkill:
+	rfkill_unregister(priv->rfkill_mngr.rfkill);
+
+free_input_dev:
+	input_free_device(priv->rfkill_mngr.input_dev);
+	priv->rfkill_mngr.input_dev = NULL;
+
+freed_rfkill:
+	rfkill_free(priv->rfkill_mngr.rfkill);
+	priv->rfkill_mngr.rfkill = NULL;
+
+error:
+	return ret;
+}
+EXPORT_SYMBOL(iwl_rfkill_init);
+
+void iwl_rfkill_unregister(struct iwl_priv *priv)
+{
+
+	if (priv->rfkill_mngr.input_dev)
+		input_unregister_device(priv->rfkill_mngr.input_dev);
+
+	if (priv->rfkill_mngr.rfkill)
+		rfkill_unregister(priv->rfkill_mngr.rfkill);
+}
+EXPORT_SYMBOL(iwl_rfkill_unregister);
+
+
+void iwl_rfkill_free(struct iwl_priv *priv)
+{
+	if (priv->rfkill_mngr.input_dev)
+		input_free_device(priv->rfkill_mngr.input_dev);
+
+	if (priv->rfkill_mngr.rfkill)
+		rfkill_free(priv->rfkill_mngr.rfkill);
+}
+EXPORT_SYMBOL(iwl_rfkill_free);
+
+/* set rf-kill to the right state. */
+void iwl_rfkill_set_hw_state(struct iwl_priv *priv)
+{
+
+	if (!priv->rfkill_mngr.rfkill)
+		return;
+
+	if (!iwl_is_rfkill(priv))
+		priv->rfkill_mngr.rfkill->state = RFKILL_STATE_ON;
+	else
+		priv->rfkill_mngr.rfkill->state = RFKILL_STATE_OFF;
+}
+EXPORT_SYMBOL(iwl_rfkill_set_hw_state);
diff --git a/drivers/net/wireless/iwlwifi/iwl-rfkill.h b/drivers/net/wireless/iwlwifi/iwl-rfkill.h
new file mode 100644
index 0000000..a5cbc5a
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-rfkill.h
@@ -0,0 +1,56 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2007 - 2008 Intel Corporation. All rights reserved.
+ *
+ * Portions of this file are derived from the ipw3945 project, as well
+ * as portions of the ieee80211 subsystem header files.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * The full GNU General Public License is included in this distribution in the
+ * file called LICENSE.
+ *
+ * Contact Information:
+ * James P. Ketrenos <ipw2100-admin@linux.intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *****************************************************************************/
+#ifndef __iwl_rf_kill_h__
+#define __iwl_rf_kill_h__
+
+struct iwl_priv;
+
+#include <linux/rfkill.h>
+#include <linux/input.h>
+
+
+#ifdef CONFIG_IWLCORE_RFKILL
+struct iwl_rfkill_mngr {
+	struct rfkill *rfkill;
+	struct input_dev *input_dev;
+};
+
+void iwl_rfkill_set_hw_state(struct iwl_priv *priv);
+void iwl_rfkill_free(struct iwl_priv *priv);
+void iwl_rfkill_unregister(struct iwl_priv *priv);
+int iwl_rfkill_init(struct iwl_priv *priv);
+#else
+static inline void iwl_rfkill_set_hw_state(struct iwl_priv *priv) {}
+static inline void iwl_rfkill_free(struct iwl_priv *priv) {}
+static inline void iwl_rfkill_unregister(struct iwl_priv *priv) {}
+static inline int iwl_rfkill_init(struct iwl_priv *priv) { return 0; }
+#endif
+
+
+
+#endif  /* __iwl_rf_kill_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 5261b61..7f56565 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -2607,7 +2607,7 @@ static void iwl4965_set_rate(struct iwl_priv *priv)
 		   (IWL_OFDM_BASIC_RATES_MASK >> IWL_FIRST_OFDM_RATE) & 0xFF;
 }
 
-static void iwl4965_radio_kill_sw(struct iwl_priv *priv, int disable_radio)
+void iwl4965_radio_kill_sw(struct iwl_priv *priv, int disable_radio)
 {
 	unsigned long flags;
 
@@ -2625,8 +2625,16 @@ static void iwl4965_radio_kill_sw(struct iwl_priv *priv, int disable_radio)
 			iwl_write32(priv, CSR_UCODE_DRV_GP1_SET,
 				    CSR_UCODE_SW_BIT_RFKILL);
 			spin_unlock_irqrestore(&priv->lock, flags);
-			iwl4965_send_card_state(priv, CARD_STATE_CMD_DISABLE, 0);
+			/* call the host command only if no hw rf-kill set */
+			if (!test_bit(STATUS_RF_KILL_HW, &priv->status))
+				iwl4965_send_card_state(priv,
+							CARD_STATE_CMD_DISABLE,
+							0);
 			set_bit(STATUS_RF_KILL_SW, &priv->status);
+
+			/* make sure mac80211 stop sending Tx frame */
+			if (priv->mac80211_registered)
+				ieee80211_stop_queues(priv->hw);
 		}
 		return;
 	}
@@ -5852,6 +5860,7 @@ static int __iwl4965_up(struct iwl_priv *priv)
 	if (test_bit(STATUS_RF_KILL_SW, &priv->status)) {
 		IWL_WARNING("Radio disabled by SW RF kill (module "
 			    "parameter)\n");
+		iwl_rfkill_set_hw_state(priv);
 		return -ENODEV;
 	}
 
@@ -5867,11 +5876,13 @@ static int __iwl4965_up(struct iwl_priv *priv)
 	else {
 		set_bit(STATUS_RF_KILL_HW, &priv->status);
 		if (!test_bit(STATUS_IN_SUSPEND, &priv->status)) {
+			iwl_rfkill_set_hw_state(priv);
 			IWL_WARNING("Radio disabled by HW RF Kill switch\n");
 			return -ENODEV;
 		}
 	}
 
+	iwl_rfkill_set_hw_state(priv);
 	iwl_write32(priv, CSR_INT, 0xFFFFFFFF);
 
 	rc = iwl4965_hw_nic_init(priv);
@@ -5985,6 +5996,9 @@ static void iwl4965_bg_rf_kill(struct work_struct *work)
 		if (!test_bit(STATUS_EXIT_PENDING, &priv->status))
 			queue_work(priv->workqueue, &priv->restart);
 	} else {
+		/* make sure mac80211 stop sending Tx frame */
+		if (priv->mac80211_registered)
+			ieee80211_stop_queues(priv->hw);
 
 		if (!test_bit(STATUS_RF_KILL_HW, &priv->status))
 			IWL_DEBUG_RF_KILL("Can not turn radio back on - "
@@ -5994,6 +6008,8 @@ static void iwl4965_bg_rf_kill(struct work_struct *work)
 				    "Kill switch must be turned off for "
 				    "wireless networking to work.\n");
 	}
+	iwl_rfkill_set_hw_state(priv);
+
 	mutex_unlock(&priv->mutex);
 }
 
@@ -6674,7 +6690,8 @@ static int iwl4965_mac_config(struct ieee80211_hw *hw, struct ieee80211_conf *co
 	}
 #endif
 
-	iwl4965_radio_kill_sw(priv, !conf->radio_enabled);
+	if (priv->cfg->ops->lib->radio_kill_sw)
+		priv->cfg->ops->lib->radio_kill_sw(priv, !conf->radio_enabled);
 
 	if (!conf->radio_enabled) {
 		IWL_DEBUG_MAC80211("leave - radio disabled\n");
@@ -7449,36 +7466,6 @@ static DRIVER_ATTR(debug_level, S_IWUSR | S_IRUGO,
 
 #endif /* CONFIG_IWLWIFI_DEBUG */
 
-static ssize_t show_rf_kill(struct device *d,
-			    struct device_attribute *attr, char *buf)
-{
-	/*
-	 * 0 - RF kill not enabled
-	 * 1 - SW based RF kill active (sysfs)
-	 * 2 - HW based RF kill active
-	 * 3 - Both HW and SW based RF kill active
-	 */
-	struct iwl_priv *priv = (struct iwl_priv *)d->driver_data;
-	int val = (test_bit(STATUS_RF_KILL_SW, &priv->status) ? 0x1 : 0x0) |
-		  (test_bit(STATUS_RF_KILL_HW, &priv->status) ? 0x2 : 0x0);
-
-	return sprintf(buf, "%i\n", val);
-}
-
-static ssize_t store_rf_kill(struct device *d,
-			     struct device_attribute *attr,
-			     const char *buf, size_t count)
-{
-	struct iwl_priv *priv = (struct iwl_priv *)d->driver_data;
-
-	mutex_lock(&priv->mutex);
-	iwl4965_radio_kill_sw(priv, buf[0] == '1');
-	mutex_unlock(&priv->mutex);
-
-	return count;
-}
-
-static DEVICE_ATTR(rf_kill, S_IWUSR | S_IRUGO, show_rf_kill, store_rf_kill);
 
 static ssize_t show_temperature(struct device *d,
 				struct device_attribute *attr, char *buf)
@@ -7964,7 +7951,6 @@ static struct attribute *iwl4965_sysfs_entries[] = {
 #endif
 	&dev_attr_power_level.attr,
 	&dev_attr_retry_rate.attr,
-	&dev_attr_rf_kill.attr,
 	&dev_attr_rs_window.attr,
 	&dev_attr_statistics.attr,
 	&dev_attr_status.attr,
-- 
1.5.3.4

