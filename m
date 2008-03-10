Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:38737 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751354AbYCJSlZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Mar 2008 14:41:25 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Mohamed Abbas <mohamed.abbas@intel.com>,
	Ian Schram <ischram@gmane.org>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 1/7] iwlwifi: Add led support
Date: Mon, 10 Mar 2008 11:35:06 -0700
Message-Id: <1205174112-18962-2-git-send-email-reinette.chatre@intel.com> (sfid-20080310_184153_096126_2E17BF8A)
In-Reply-To: <1205174112-18962-1-git-send-email-reinette.chatre@intel.com>
References: <1205174112-18962-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohamed Abbas <mohamed.abbas@intel.com>

This patch add LEDS support to 3965 and 4965 drivers. It is based on led
trigger and class. For our drivers we needed to avoid two things.
1- We receive led trigger on/off on each Rx\Tx frame. In our driver
   we can not call led command like that. In this driver once driver
   receive a start of traffic it call the led command to start blinking then
   we count all bytes of Tx and Rx frame, after two second we count the blink
   rate of last two second then id blink rate changed we call the led commands
2- Since we can call led command very often, we make sure we call the
   led command after we receive the statistics notification so
   we dont need to wakeup the ucode id it is in sleep state.
This patch was tested with 4965 and 3945.

This patch fixes compile and sparse warnings from earlier version.
Patch also includes fixes for endianity.

Signed-off-by: Mohamed abbas<mohamed.abbas@intel.com>
Signed-off-by: Ian Schram<ischram@gmane.org>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/Kconfig        |   20 ++-
 drivers/net/wireless/iwlwifi/Makefile       |    8 +
 drivers/net/wireless/iwlwifi/iwl-3945-led.c |  433 ++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-3945-led.h |   73 +++++
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    6 +
 drivers/net/wireless/iwlwifi/iwl-3945.h     |   13 +-
 drivers/net/wireless/iwlwifi/iwl-4965-led.c |  440 +++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-4965-led.h |   73 +++++
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    8 +-
 drivers/net/wireless/iwlwifi/iwl-4965.h     |   12 +-
 drivers/net/wireless/iwlwifi/iwl-csr.h      |    6 +
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    9 +-
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   10 +-
 13 files changed, 1095 insertions(+), 16 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-3945-led.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-3945-led.h
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-4965-led.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-4965-led.h

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index 5b7c016..496dd3d 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -37,6 +37,15 @@ config IWL4965_HT
 	  This option enables IEEE 802.11n High Throughput features
 	  for the iwl4965 driver.
 
+config IWL4965_LEDS
+	bool "Enable LEDS features in iwl4965 driver"
+	depends on IWL4965
+	select LEDS_CLASS
+	select LEDS_TRIGGERS
+	select MAC80211_LEDS
+	---help---
+	  This option enables LEDS for the iwl4965 driver.
+
 config IWL4965_SPECTRUM_MEASUREMENT
 	bool "Enable Spectrum Measurement in iwl4965 driver"
 	depends on IWL4965
@@ -46,7 +55,7 @@ config IWL4965_SPECTRUM_MEASUREMENT
 config IWL4965_SENSITIVITY
 	bool "Enable Sensitivity Calibration in iwl4965 driver"
 	depends on IWL4965
-	---help---
+---help---
 	  This option will enable sensitivity calibration for the iwl4965
 	  driver.
 
@@ -108,6 +117,15 @@ config IWL3945_SPECTRUM_MEASUREMENT
 	---help---
 	  This option will enable spectrum measurement for the iwl3945 driver.
 
+config IWL3945_LEDS
+	bool "Enable LEDS features in iwl3945 driver"
+	depends on IWL3945
+	select LEDS_CLASS
+	select LEDS_TRIGGERS
+	select MAC80211_LEDS
+	---help---
+	  This option enables LEDS for the iwl3945 driver.
+
 config IWL3945_DEBUG
 	bool "Enable full debugging output in iwl3945 driver"
 	depends on IWL3945
diff --git a/drivers/net/wireless/iwlwifi/Makefile b/drivers/net/wireless/iwlwifi/Makefile
index 6b85cca..abcfdbf 100644
--- a/drivers/net/wireless/iwlwifi/Makefile
+++ b/drivers/net/wireless/iwlwifi/Makefile
@@ -3,6 +3,14 @@ iwlcore-objs 		= iwl-core.o
 
 obj-$(CONFIG_IWL3945)	+= iwl3945.o
 iwl3945-objs		= iwl3945-base.o iwl-3945.o iwl-3945-rs.o
+ifeq ($(CONFIG_IWL3945_LEDS),y)
+	iwl3945-objs += iwl-3945-led.o
+endif
+
 
 obj-$(CONFIG_IWL4965)	+= iwl4965.o
 iwl4965-objs		= iwl4965-base.o iwl-4965.o iwl-4965-rs.o
+ifeq ($(CONFIG_IWL4965_LEDS),y)
+	iwl4965-objs += iwl-4965-led.o
+endif
+
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-led.c b/drivers/net/wireless/iwlwifi/iwl-3945-led.c
new file mode 100644
index 0000000..d200d08
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-led.c
@@ -0,0 +1,433 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2003 - 2008 Intel Corporation. All rights reserved.
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
+ *
+ *****************************************************************************/
+
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/version.h>
+#include <linux/init.h>
+#include <linux/pci.h>
+#include <linux/dma-mapping.h>
+#include <linux/delay.h>
+#include <linux/skbuff.h>
+#include <linux/netdevice.h>
+#include <linux/wireless.h>
+#include <net/mac80211.h>
+#include <linux/etherdevice.h>
+#include <asm/unaligned.h>
+
+#include "iwl-3945.h"
+#include "iwl-helpers.h"
+
+#define IWL_1MB_RATE (128 * 1024)
+#define IWL_LED_THRESHOLD (16)
+#define IWL_MAX_BLINK_TBL (10)
+
+static const struct {
+	u16 brightness;
+	u8 on_time;
+	u8 of_time;
+} blink_tbl[] =
+{
+	{300, 25, 25},
+	{200, 40, 40},
+	{100, 55, 55},
+	{70, 65, 65},
+	{50, 75, 75},
+	{20, 85, 85},
+	{15, 95, 95 },
+	{10, 110, 110},
+	{5, 130, 130},
+	{0, 167, 167}
+};
+
+static int iwl3945_led_cmd_callback(struct iwl3945_priv *priv,
+				    struct iwl3945_cmd *cmd,
+				    struct sk_buff *skb)
+{
+	return 1;
+}
+
+
+/* Send led command */
+static int iwl_send_led_cmd(struct iwl3945_priv *priv,
+			    struct iwl3945_led_cmd *led_cmd)
+{
+	struct iwl3945_host_cmd cmd = {
+		.id = REPLY_LEDS_CMD,
+		.len = sizeof(struct iwl3945_led_cmd),
+		.data = led_cmd,
+		.meta.flags = CMD_ASYNC,
+		.meta.u.callback = iwl3945_led_cmd_callback
+	};
+
+	return iwl3945_send_cmd(priv, &cmd);
+}
+
+
+/* Set led on command */
+static int iwl3945_led_on(struct iwl3945_priv *priv, int led_id)
+{
+	struct iwl3945_led_cmd led_cmd = {
+		.id = led_id,
+		.on = IWL_LED_SOLID,
+		.off = 0,
+		.interval = IWL_DEF_LED_INTRVL
+	};
+	return iwl_send_led_cmd(priv, &led_cmd);
+}
+
+/* Set led on command */
+static int iwl3945_led_pattern(struct iwl3945_priv *priv, int led_id,
+			       enum led_brightness brightness)
+{
+	struct iwl3945_led_cmd led_cmd = {
+		.id = led_id,
+		.on = brightness,
+		.off = brightness,
+		.interval = IWL_DEF_LED_INTRVL
+	};
+	if (brightness == LED_FULL) {
+		led_cmd.on = IWL_LED_SOLID;
+		led_cmd.off = 0;
+	}
+	return iwl_send_led_cmd(priv, &led_cmd);
+}
+
+/* Set led register off */
+static int iwl3945_led_on_reg(struct iwl3945_priv *priv, int led_id)
+{
+	IWL_DEBUG_LED("led on %d\n", led_id);
+	return iwl3945_led_on(priv, led_id);
+}
+
+/* Set led off command */
+static int iwl3945_led_off(struct iwl3945_priv *priv, int led_id)
+{
+	struct iwl3945_led_cmd led_cmd = {
+		.id = led_id,
+		.on = 0,
+		.off = 0,
+		.interval = IWL_DEF_LED_INTRVL
+	};
+	IWL_DEBUG_LED("led off %d\n", led_id);
+	return iwl_send_led_cmd(priv, &led_cmd);
+}
+
+/* Set led register off */
+static int iwl3945_led_off_reg(struct iwl3945_priv *priv, int led_id)
+{
+	iwl3945_led_off(priv, led_id);
+	return 0;
+}
+
+/* Set led blink command */
+static int iwl3945_led_not_solid(struct iwl3945_priv *priv, int led_id,
+			       u8 brightness)
+{
+	struct iwl3945_led_cmd led_cmd = {
+		.id = led_id,
+		.on = brightness,
+		.off = brightness,
+		.interval = IWL_DEF_LED_INTRVL
+	};
+
+	return iwl_send_led_cmd(priv, &led_cmd);
+}
+
+
+/*
+ * brightness call back function for Tx/Rx LED
+ */
+static int iwl3945_led_associated(struct iwl3945_priv *priv, int led_id)
+{
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status) ||
+	    !test_bit(STATUS_READY, &priv->status))
+		return 0;
+
+
+	/* start counting Tx/Rx bytes */
+	if (!priv->last_blink_time && priv->allow_blinking)
+		priv->last_blink_time = jiffies;
+	return 0;
+}
+
+/*
+ * brightness call back for association and radio
+ */
+static void iwl3945_led_brightness_set(struct led_classdev *led_cdev,
+				enum led_brightness brightness)
+{
+	struct iwl3945_led *led = container_of(led_cdev,
+					       struct iwl3945_led, led_dev);
+	struct iwl3945_priv *priv = led->priv;
+
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+		return;
+
+	switch (brightness) {
+	case LED_FULL:
+		if (led->type == IWL_LED_TRG_ASSOC) {
+			priv->allow_blinking = 1;
+			IWL_DEBUG_LED("MAC is  associated\n");
+		}
+		if (led->led_on)
+			led->led_on(priv, IWL_LED_LINK);
+		break;
+	case LED_OFF:
+		if (led->type == IWL_LED_TRG_ASSOC) {
+			priv->allow_blinking = 0;
+			IWL_DEBUG_LED("MAC is disassociated\n");
+		}
+		if (led->led_off)
+			led->led_off(priv, IWL_LED_LINK);
+		break;
+	default:
+		if (led->led_pattern)
+			led->led_pattern(priv, IWL_LED_LINK, brightness);
+		break;
+	}
+}
+
+
+
+/*
+ * Register led class with the system
+ */
+static int iwl3945_led_register_led(struct iwl3945_priv *priv,
+				   struct iwl3945_led *led,
+				   enum led_type type, u8 set_led,
+				   const char *name, char *trigger)
+{
+	struct device *device = wiphy_dev(priv->hw->wiphy);
+	int ret;
+
+	led->led_dev.name = name;
+	led->led_dev.brightness_set = iwl3945_led_brightness_set;
+	led->led_dev.default_trigger = trigger;
+
+	ret = led_classdev_register(device, &led->led_dev);
+	if (ret) {
+		IWL_ERROR("Error: failed to register led handler.\n");
+		return ret;
+	}
+
+	led->priv = priv;
+	led->type = type;
+	led->registered = 1;
+
+	if (set_led && led->led_on)
+		led->led_on(priv, IWL_LED_LINK);
+	return 0;
+}
+
+
+/*
+ * calculate blink rate according to last 2 sec Tx/Rx activities
+ */
+static inline u8 get_blink_rate(struct iwl3945_priv *priv)
+{
+	int index;
+	u8 blink_rate;
+
+	if (priv->rxtxpackets < IWL_LED_THRESHOLD)
+		index = 10;
+	else {
+		for (index = 0; index < IWL_MAX_BLINK_TBL; index++) {
+			if (priv->rxtxpackets > (blink_tbl[index].brightness *
+						 IWL_1MB_RATE))
+				break;
+		}
+	}
+	/* if 0 frame is transfered */
+	if ((index == IWL_MAX_BLINK_TBL) || !priv->allow_blinking)
+		blink_rate = IWL_LED_SOLID;
+	else
+		blink_rate = blink_tbl[index].on_time;
+
+	return blink_rate;
+}
+
+static inline int is_rf_kill(struct iwl3945_priv *priv)
+{
+	return test_bit(STATUS_RF_KILL_HW, &priv->status) ||
+		test_bit(STATUS_RF_KILL_SW, &priv->status);
+}
+
+/*
+ * this function called from handler. Since setting Led command can
+ * happen very frequent we postpone led command to be called from
+ * REPLY handler so we know ucode is up
+ */
+void iwl3945_led_background(struct iwl3945_priv *priv)
+{
+	u8 blink_rate;
+
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status)) {
+		priv->last_blink_time = 0;
+		return;
+	}
+	if (is_rf_kill(priv)) {
+		priv->last_blink_time = 0;
+		return;
+	}
+
+	if (!priv->allow_blinking) {
+		priv->last_blink_time = 0;
+		if (priv->last_blink_rate != IWL_LED_SOLID) {
+			priv->last_blink_rate = IWL_LED_SOLID;
+			iwl3945_led_on(priv, IWL_LED_LINK);
+		}
+		return;
+	}
+	if (!priv->last_blink_time ||
+	    !time_after(jiffies, priv->last_blink_time +
+			msecs_to_jiffies(1000)))
+		return;
+
+	blink_rate = get_blink_rate(priv);
+
+	/* call only if blink rate change */
+	if (blink_rate != priv->last_blink_rate) {
+		if (blink_rate != IWL_LED_SOLID) {
+			priv->last_blink_time = jiffies +
+						msecs_to_jiffies(1000);
+			iwl3945_led_not_solid(priv, IWL_LED_LINK, blink_rate);
+		} else {
+			priv->last_blink_time = 0;
+			iwl3945_led_on(priv, IWL_LED_LINK);
+		}
+	}
+
+	priv->last_blink_rate = blink_rate;
+	priv->rxtxpackets = 0;
+}
+
+
+/* Register all led handler */
+int iwl3945_led_register(struct iwl3945_priv *priv)
+{
+	char *trigger;
+	char name[32];
+	int ret;
+
+	priv->last_blink_rate = 0;
+	priv->rxtxpackets = 0;
+	priv->last_blink_time = 0;
+	priv->allow_blinking = 0;
+
+	trigger = ieee80211_get_radio_led_name(priv->hw);
+	snprintf(name, sizeof(name), "iwl-%s:radio",
+		 wiphy_name(priv->hw->wiphy));
+
+	priv->led[IWL_LED_TRG_RADIO].led_on = iwl3945_led_on_reg;
+	priv->led[IWL_LED_TRG_RADIO].led_off = iwl3945_led_off_reg;
+	priv->led[IWL_LED_TRG_RADIO].led_pattern = NULL;
+
+	ret = iwl3945_led_register_led(priv,
+				   &priv->led[IWL_LED_TRG_RADIO],
+				   IWL_LED_TRG_RADIO, 1,
+				   name, trigger);
+	if (ret)
+		goto exit_fail;
+
+	trigger = ieee80211_get_assoc_led_name(priv->hw);
+	snprintf(name, sizeof(name), "iwl-%s:assoc",
+		 wiphy_name(priv->hw->wiphy));
+
+	ret = iwl3945_led_register_led(priv,
+				   &priv->led[IWL_LED_TRG_ASSOC],
+				   IWL_LED_TRG_ASSOC, 0,
+				   name, trigger);
+	/* for assoc always turn led on */
+	priv->led[IWL_LED_TRG_ASSOC].led_on = iwl3945_led_on_reg;
+	priv->led[IWL_LED_TRG_ASSOC].led_off = iwl3945_led_on_reg;
+	priv->led[IWL_LED_TRG_ASSOC].led_pattern = NULL;
+
+	if (ret)
+		goto exit_fail;
+
+	trigger = ieee80211_get_rx_led_name(priv->hw);
+	snprintf(name, sizeof(name), "iwl-%s:RX",
+		 wiphy_name(priv->hw->wiphy));
+
+
+	ret = iwl3945_led_register_led(priv,
+				   &priv->led[IWL_LED_TRG_RX],
+				   IWL_LED_TRG_RX, 0,
+				   name, trigger);
+
+	priv->led[IWL_LED_TRG_RX].led_on = iwl3945_led_associated;
+	priv->led[IWL_LED_TRG_RX].led_off = iwl3945_led_associated;
+	priv->led[IWL_LED_TRG_RX].led_pattern = iwl3945_led_pattern;
+
+	if (ret)
+		goto exit_fail;
+
+	trigger = ieee80211_get_tx_led_name(priv->hw);
+	snprintf(name, sizeof(name), "iwl-%s:TX",
+		 wiphy_name(priv->hw->wiphy));
+	ret = iwl3945_led_register_led(priv,
+				   &priv->led[IWL_LED_TRG_TX],
+				   IWL_LED_TRG_TX, 0,
+				   name, trigger);
+	priv->led[IWL_LED_TRG_TX].led_on = iwl3945_led_associated;
+	priv->led[IWL_LED_TRG_TX].led_off = iwl3945_led_associated;
+	priv->led[IWL_LED_TRG_TX].led_pattern = iwl3945_led_pattern;
+
+	if (ret)
+		goto exit_fail;
+
+	return 0;
+
+exit_fail:
+	iwl3945_led_unregister(priv);
+	return ret;
+}
+
+
+/* unregister led class */
+static void iwl3945_led_unregister_led(struct iwl3945_led *led, u8 set_led)
+{
+	if (!led->registered)
+		return;
+
+	led_classdev_unregister(&led->led_dev);
+
+	if (set_led)
+		led->led_dev.brightness_set(&led->led_dev, LED_OFF);
+	led->registered = 0;
+}
+
+/* Unregister all led handlers */
+void iwl3945_led_unregister(struct iwl3945_priv *priv)
+{
+	iwl3945_led_unregister_led(&priv->led[IWL_LED_TRG_ASSOC], 0);
+	iwl3945_led_unregister_led(&priv->led[IWL_LED_TRG_RX], 0);
+	iwl3945_led_unregister_led(&priv->led[IWL_LED_TRG_TX], 0);
+	iwl3945_led_unregister_led(&priv->led[IWL_LED_TRG_RADIO], 1);
+}
+
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-led.h b/drivers/net/wireless/iwlwifi/iwl-3945-led.h
new file mode 100644
index 0000000..b1d2f6b
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-led.h
@@ -0,0 +1,73 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2003 - 2008 Intel Corporation. All rights reserved.
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
+ *
+ *****************************************************************************/
+
+#ifndef IWL3945_LEDS_H
+#define IWL3945_LEDS_H
+
+struct iwl3945_priv;
+
+#ifdef CONFIG_IWL3945_LEDS
+#define IWL_LED_SOLID 11
+#define IWL_LED_NAME_LEN 31
+#define IWL_DEF_LED_INTRVL __constant_cpu_to_le32(1000)
+
+#define IWL_LED_ACTIVITY       (0<<1)
+#define IWL_LED_LINK           (1<<1)
+
+enum led_type {
+	IWL_LED_TRG_TX,
+	IWL_LED_TRG_RX,
+	IWL_LED_TRG_ASSOC,
+	IWL_LED_TRG_RADIO,
+	IWL_LED_TRG_MAX,
+};
+
+#include <linux/leds.h>
+
+struct iwl3945_led {
+	struct iwl3945_priv *priv;
+	struct led_classdev led_dev;
+
+	int (*led_on) (struct iwl3945_priv *priv, int led_id);
+	int (*led_off) (struct iwl3945_priv *priv, int led_id);
+	int (*led_pattern) (struct iwl3945_priv *priv, int led_id,
+			    enum led_brightness brightness);
+
+	enum led_type type;
+	unsigned int registered;
+};
+
+extern int iwl3945_led_register(struct iwl3945_priv *priv);
+extern void iwl3945_led_unregister(struct iwl3945_priv *priv);
+extern void iwl3945_led_background(struct iwl3945_priv *priv);
+
+#else
+static inline int iwl3945_led_register(struct iwl3945_priv *priv) { return 0; }
+static inline void iwl3945_led_unregister(struct iwl3945_priv *priv) {}
+static inline void iwl3945_led_background(struct iwl3945_priv *priv) {}
+#endif /* CONFIG_IWL3945_LEDS */
+
+#endif /* IWL3945_LEDS_H */
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 50a641c..bcfa299 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -358,6 +358,8 @@ void iwl3945_hw_rx_statistics(struct iwl3945_priv *priv, struct iwl3945_rx_mem_b
 
 	memcpy(&priv->statistics, pkt->u.raw, sizeof(priv->statistics));
 
+	iwl3945_led_background(priv);
+
 	priv->last_statistics_time = jiffies;
 }
 
@@ -640,6 +642,10 @@ static void iwl3945_handle_data_packet(struct iwl3945_priv *priv, int is_data,
 	if (priv->add_radiotap)
 		iwl3945_add_radiotap(priv, rxb->skb, rx_hdr, stats);
 
+#ifdef CONFIG_IWL3945_LEDS
+	if (is_data)
+		priv->rxtxpackets += len;
+#endif
 	ieee80211_rx_irqsafe(priv->hw, rxb->skb, stats);
 	rxb->skb = NULL;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index 0ab22d3..076e2d7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -44,6 +44,7 @@ extern struct pci_device_id iwl3945_hw_card_ids[];
 #include "iwl-prph.h"
 #include "iwl-3945-hw.h"
 #include "iwl-3945-debug.h"
+#include "iwl-3945-led.h"
 
 /* Change firmware file name, using "-" and incrementing number,
  *   *only* when uCode interface or architecture changes so that it
@@ -777,13 +778,15 @@ struct iwl3945_priv {
 	struct iwl3945_init_alive_resp card_alive_init;
 	struct iwl3945_alive_resp card_alive;
 
-#ifdef LED
-	/* LED related variables */
-	struct iwl3945_activity_blink activity;
-	unsigned long led_packets;
-	int led_state;
+#ifdef CONFIG_IWL4965_LEDS
+	struct iwl3945_led led[IWL_LED_TRG_MAX];
+	unsigned long last_blink_time;
+	u8 last_blink_rate;
+	u8 allow_blinking;
+	unsigned int rxtxpackets;
 #endif
 
+
 	u16 active_rate;
 	u16 active_rate_basic;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-led.c b/drivers/net/wireless/iwlwifi/iwl-4965-led.c
new file mode 100644
index 0000000..c7246bd
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-led.c
@@ -0,0 +1,440 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2003 - 2008 Intel Corporation. All rights reserved.
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
+ *
+ *****************************************************************************/
+
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/version.h>
+#include <linux/init.h>
+#include <linux/pci.h>
+#include <linux/dma-mapping.h>
+#include <linux/delay.h>
+#include <linux/skbuff.h>
+#include <linux/netdevice.h>
+#include <linux/wireless.h>
+#include <net/mac80211.h>
+#include <linux/etherdevice.h>
+#include <asm/unaligned.h>
+
+#include "iwl-4965.h"
+#include "iwl-helpers.h"
+
+#define IWL_1MB_RATE (128 * 1024)
+#define IWL_LED_THRESHOLD (16)
+#define IWL_MAX_BLINK_TBL (10)
+
+static const struct {
+	u16 brightness;
+	u8 on_time;
+	u8 of_time;
+} blink_tbl[] =
+{
+	{300, 25, 25},
+	{200, 40, 40},
+	{100, 55, 55},
+	{70, 65, 65},
+	{50, 75, 75},
+	{20, 85, 85},
+	{15, 95, 95 },
+	{10, 110, 110},
+	{5, 130, 130},
+	{0, 167, 167}
+};
+
+static int iwl4965_led_cmd_callback(struct iwl4965_priv *priv,
+				struct iwl4965_cmd *cmd, struct sk_buff *skb)
+{
+	return 1;
+}
+
+
+/* Send led command */
+static int iwl_send_led_cmd(struct iwl4965_priv *priv,
+			    struct iwl4965_led_cmd *led_cmd)
+{
+	struct iwl4965_host_cmd cmd = {
+		.id = REPLY_LEDS_CMD,
+		.len = sizeof(struct iwl4965_led_cmd),
+		.data = led_cmd,
+		.meta.flags = CMD_ASYNC,
+		.meta.u.callback = iwl4965_led_cmd_callback
+	};
+	u32 reg;
+
+	reg = iwl4965_read32(priv, CSR_LED_REG);
+	if (reg != (reg & CSR_LED_BSM_CTRL_MSK))
+		iwl4965_write32(priv, CSR_LED_REG, reg & CSR_LED_BSM_CTRL_MSK);
+
+	return iwl4965_send_cmd(priv, &cmd);
+}
+
+
+/* Set led on command */
+static int iwl4965_led_on(struct iwl4965_priv *priv, int led_id)
+{
+	struct iwl4965_led_cmd led_cmd = {
+		.id = led_id,
+		.on = IWL_LED_SOLID,
+		.off = 0,
+		.interval = IWL_DEF_LED_INTRVL
+	};
+	return iwl_send_led_cmd(priv, &led_cmd);
+}
+
+/* Set led on command */
+static int iwl4965_led_pattern(struct iwl4965_priv *priv, int led_id,
+			       enum led_brightness brightness)
+{
+	struct iwl4965_led_cmd led_cmd = {
+		.id = led_id,
+		.on = brightness,
+		.off = brightness,
+		.interval = IWL_DEF_LED_INTRVL
+	};
+	if (brightness == LED_FULL) {
+		led_cmd.on = IWL_LED_SOLID;
+		led_cmd.off = 0;
+	}
+	return iwl_send_led_cmd(priv, &led_cmd);
+}
+
+/* Set led register off */
+static int iwl4965_led_on_reg(struct iwl4965_priv *priv, int led_id)
+{
+	IWL_DEBUG_LED("led on %d\n", led_id);
+	iwl4965_write32(priv, CSR_LED_REG, CSR_LED_REG_TRUN_ON);
+	return 0;
+}
+
+#if 0
+/* Set led off command */
+int iwl4965_led_off(struct iwl4965_priv *priv, int led_id)
+{
+	struct iwl4965_led_cmd led_cmd = {
+		.id = led_id,
+		.on = 0,
+		.off = 0,
+		.interval = IWL_DEF_LED_INTRVL
+	};
+	IWL_DEBUG_LED("led off %d\n", led_id);
+	return iwl_send_led_cmd(priv, &led_cmd);
+}
+#endif
+
+
+/* Set led register off */
+static int iwl4965_led_off_reg(struct iwl4965_priv *priv, int led_id)
+{
+	IWL_DEBUG_LED("radio off\n");
+	iwl4965_write32(priv, CSR_LED_REG, CSR_LED_REG_TRUN_OFF);
+	return 0;
+}
+
+/* Set led blink command */
+static int iwl4965_led_not_solid(struct iwl4965_priv *priv, int led_id,
+			       u8 brightness)
+{
+	struct iwl4965_led_cmd led_cmd = {
+		.id = led_id,
+		.on = brightness,
+		.off = brightness,
+		.interval = IWL_DEF_LED_INTRVL
+	};
+
+	return iwl_send_led_cmd(priv, &led_cmd);
+}
+
+
+/*
+ * brightness call back function for Tx/Rx LED
+ */
+static int iwl4965_led_associated(struct iwl4965_priv *priv, int led_id)
+{
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status) ||
+	    !test_bit(STATUS_READY, &priv->status))
+		return 0;
+
+
+	/* start counting Tx/Rx bytes */
+	if (!priv->last_blink_time && priv->allow_blinking)
+		priv->last_blink_time = jiffies;
+	return 0;
+}
+
+/*
+ * brightness call back for association and radio
+ */
+static void iwl4965_led_brightness_set(struct led_classdev *led_cdev,
+				       enum led_brightness brightness)
+{
+	struct iwl4965_led *led = container_of(led_cdev,
+					       struct iwl4965_led, led_dev);
+	struct iwl4965_priv *priv = led->priv;
+
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+		return;
+
+	switch (brightness) {
+	case LED_FULL:
+		if (led->type == IWL_LED_TRG_ASSOC)
+			priv->allow_blinking = 1;
+
+		if (led->led_on)
+			led->led_on(priv, IWL_LED_LINK);
+		break;
+	case LED_OFF:
+		if (led->type == IWL_LED_TRG_ASSOC)
+			priv->allow_blinking = 0;
+
+		if (led->led_off)
+			led->led_off(priv, IWL_LED_LINK);
+		break;
+	default:
+		if (led->led_pattern)
+			led->led_pattern(priv, IWL_LED_LINK, brightness);
+		break;
+	}
+}
+
+
+
+/*
+ * Register led class with the system
+ */
+static int iwl4965_led_register_led(struct iwl4965_priv *priv,
+				   struct iwl4965_led *led,
+				   enum led_type type, u8 set_led,
+				   const char *name, char *trigger)
+{
+	struct device *device = wiphy_dev(priv->hw->wiphy);
+	int ret;
+
+	led->led_dev.name = name;
+	led->led_dev.brightness_set = iwl4965_led_brightness_set;
+	led->led_dev.default_trigger = trigger;
+
+	ret = led_classdev_register(device, &led->led_dev);
+	if (ret) {
+		IWL_ERROR("Error: failed to register led handler.\n");
+		return ret;
+	}
+
+	led->priv = priv;
+	led->type = type;
+	led->registered = 1;
+
+	if (set_led && led->led_on)
+		led->led_on(priv, IWL_LED_LINK);
+	return 0;
+}
+
+
+/*
+ * calculate blink rate according to last 2 sec Tx/Rx activities
+ */
+static inline u8 get_blink_rate(struct iwl4965_priv *priv)
+{
+	int index;
+	u8 blink_rate;
+
+	if (priv->rxtxpackets < IWL_LED_THRESHOLD)
+		index = 10;
+	else {
+		for (index = 0; index < IWL_MAX_BLINK_TBL; index++) {
+			if (priv->rxtxpackets > (blink_tbl[index].brightness *
+						 IWL_1MB_RATE))
+				break;
+		}
+	}
+	/* if 0 frame is transfered */
+	if ((index == IWL_MAX_BLINK_TBL) || !priv->allow_blinking)
+		blink_rate = IWL_LED_SOLID;
+	else
+		blink_rate = blink_tbl[index].on_time;
+
+	return blink_rate;
+}
+
+static inline int is_rf_kill(struct iwl4965_priv *priv)
+{
+	return test_bit(STATUS_RF_KILL_HW, &priv->status) ||
+		test_bit(STATUS_RF_KILL_SW, &priv->status);
+}
+
+/*
+ * this function called from handler. Since setting Led command can
+ * happen very frequent we postpone led command to be called from
+ * REPLY handler so we know ucode is up
+ */
+void iwl4965_led_background(struct iwl4965_priv *priv)
+{
+	u8 blink_rate;
+
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status)) {
+		priv->last_blink_time = 0;
+		return;
+	}
+	if (is_rf_kill(priv)) {
+		priv->last_blink_time = 0;
+		return;
+	}
+
+	if (!priv->allow_blinking) {
+		priv->last_blink_time = 0;
+		if (priv->last_blink_rate != IWL_LED_SOLID) {
+			priv->last_blink_rate = IWL_LED_SOLID;
+			iwl4965_led_on(priv, IWL_LED_LINK);
+		}
+		return;
+	}
+	if (!priv->last_blink_time ||
+	    !time_after(jiffies, priv->last_blink_time +
+			msecs_to_jiffies(1000)))
+		return;
+
+	blink_rate = get_blink_rate(priv);
+
+	/* call only if blink rate change */
+	if (blink_rate != priv->last_blink_rate) {
+		if (blink_rate != IWL_LED_SOLID) {
+			priv->last_blink_time = jiffies +
+						msecs_to_jiffies(1000);
+			iwl4965_led_not_solid(priv, IWL_LED_LINK, blink_rate);
+		} else {
+			priv->last_blink_time = 0;
+			iwl4965_led_on(priv, IWL_LED_LINK);
+		}
+	}
+
+	priv->last_blink_rate = blink_rate;
+	priv->rxtxpackets = 0;
+}
+
+
+/* Register all led handler */
+int iwl4965_led_register(struct iwl4965_priv *priv)
+{
+	char *trigger;
+	char name[32];
+	int ret;
+
+	priv->last_blink_rate = 0;
+	priv->rxtxpackets = 0;
+	priv->last_blink_time = 0;
+	priv->allow_blinking = 0;
+
+	trigger = ieee80211_get_radio_led_name(priv->hw);
+	snprintf(name, sizeof(name), "iwl-%s:radio",
+		 wiphy_name(priv->hw->wiphy));
+
+	priv->led[IWL_LED_TRG_RADIO].led_on = iwl4965_led_on_reg;
+	priv->led[IWL_LED_TRG_RADIO].led_off = iwl4965_led_off_reg;
+	priv->led[IWL_LED_TRG_RADIO].led_pattern = NULL;
+
+	ret = iwl4965_led_register_led(priv,
+				   &priv->led[IWL_LED_TRG_RADIO],
+				   IWL_LED_TRG_RADIO, 1,
+				   name, trigger);
+	if (ret)
+		goto exit_fail;
+
+	trigger = ieee80211_get_assoc_led_name(priv->hw);
+	snprintf(name, sizeof(name), "iwl-%s:assoc",
+		 wiphy_name(priv->hw->wiphy));
+
+	ret = iwl4965_led_register_led(priv,
+				   &priv->led[IWL_LED_TRG_ASSOC],
+				   IWL_LED_TRG_ASSOC, 0,
+				   name, trigger);
+	/* for assoc always turn led on */
+	priv->led[IWL_LED_TRG_ASSOC].led_on = iwl4965_led_on_reg;
+	priv->led[IWL_LED_TRG_ASSOC].led_off = iwl4965_led_on_reg;
+	priv->led[IWL_LED_TRG_ASSOC].led_pattern = NULL;
+
+	if (ret)
+		goto exit_fail;
+
+	trigger = ieee80211_get_rx_led_name(priv->hw);
+	snprintf(name, sizeof(name), "iwl-%s:RX",
+		 wiphy_name(priv->hw->wiphy));
+
+
+	ret = iwl4965_led_register_led(priv,
+				   &priv->led[IWL_LED_TRG_RX],
+				   IWL_LED_TRG_RX, 0,
+				   name, trigger);
+
+	priv->led[IWL_LED_TRG_RX].led_on = iwl4965_led_associated;
+	priv->led[IWL_LED_TRG_RX].led_off = iwl4965_led_associated;
+	priv->led[IWL_LED_TRG_RX].led_pattern = iwl4965_led_pattern;
+
+	if (ret)
+		goto exit_fail;
+
+	trigger = ieee80211_get_tx_led_name(priv->hw);
+	snprintf(name, sizeof(name), "iwl-%s:TX",
+		 wiphy_name(priv->hw->wiphy));
+	ret = iwl4965_led_register_led(priv,
+				   &priv->led[IWL_LED_TRG_TX],
+				   IWL_LED_TRG_TX, 0,
+				   name, trigger);
+	priv->led[IWL_LED_TRG_TX].led_on = iwl4965_led_associated;
+	priv->led[IWL_LED_TRG_TX].led_off = iwl4965_led_associated;
+	priv->led[IWL_LED_TRG_TX].led_pattern = iwl4965_led_pattern;
+
+	if (ret)
+		goto exit_fail;
+
+	return 0;
+
+exit_fail:
+	iwl4965_led_unregister(priv);
+	return ret;
+}
+
+
+/* unregister led class */
+static void iwl4965_led_unregister_led(struct iwl4965_led *led, u8 set_led)
+{
+	if (!led->registered)
+		return;
+
+	led_classdev_unregister(&led->led_dev);
+
+	if (set_led)
+		led->led_dev.brightness_set(&led->led_dev, LED_OFF);
+	led->registered = 0;
+}
+
+/* Unregister all led handlers */
+void iwl4965_led_unregister(struct iwl4965_priv *priv)
+{
+	iwl4965_led_unregister_led(&priv->led[IWL_LED_TRG_ASSOC], 0);
+	iwl4965_led_unregister_led(&priv->led[IWL_LED_TRG_RX], 0);
+	iwl4965_led_unregister_led(&priv->led[IWL_LED_TRG_TX], 0);
+	iwl4965_led_unregister_led(&priv->led[IWL_LED_TRG_RADIO], 1);
+}
+
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-led.h b/drivers/net/wireless/iwlwifi/iwl-4965-led.h
new file mode 100644
index 0000000..17bbbe0
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-led.h
@@ -0,0 +1,73 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2003 - 2008 Intel Corporation. All rights reserved.
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
+ *
+ *****************************************************************************/
+
+#ifndef IWL4965_LEDS_H
+#define IWL4965_LEDS_H
+
+struct iwl4965_priv;
+
+#ifdef CONFIG_IWL4965_LEDS
+#define IWL_LED_SOLID 11
+#define IWL_LED_NAME_LEN 31
+#define IWL_DEF_LED_INTRVL __constant_cpu_to_le32(1000)
+
+#define IWL_LED_ACTIVITY       (0<<1)
+#define IWL_LED_LINK           (1<<1)
+
+enum led_type {
+	IWL_LED_TRG_TX,
+	IWL_LED_TRG_RX,
+	IWL_LED_TRG_ASSOC,
+	IWL_LED_TRG_RADIO,
+	IWL_LED_TRG_MAX,
+};
+
+#include <linux/leds.h>
+
+struct iwl4965_led {
+	struct iwl4965_priv *priv;
+	struct led_classdev led_dev;
+
+	int (*led_on) (struct iwl4965_priv *priv, int led_id);
+	int (*led_off) (struct iwl4965_priv *priv, int led_id);
+	int (*led_pattern) (struct iwl4965_priv *priv, int led_id,
+			    enum led_brightness brightness);
+
+	enum led_type type;
+	unsigned int registered;
+};
+
+extern int iwl4965_led_register(struct iwl4965_priv *priv);
+extern void iwl4965_led_unregister(struct iwl4965_priv *priv);
+extern void iwl4965_led_background(struct iwl4965_priv *priv);
+
+#else
+static inline int iwl4965_led_register(struct iwl4965_priv *priv) { return 0; }
+static inline void iwl4965_led_unregister(struct iwl4965_priv *priv) {}
+static inline void iwl4965_led_background(struct iwl4965_priv *priv) {}
+#endif /* CONFIG_IWL4965_LEDS */
+
+#endif /* IWL4965_LEDS_H */
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 2f01a49..6468504 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -3202,6 +3202,8 @@ void iwl4965_hw_rx_statistics(struct iwl4965_priv *priv, struct iwl4965_rx_mem_b
 #endif
 	}
 
+	iwl4965_led_background(priv);
+
 	/* If the hardware hasn't reported a change in
 	 * temperature then don't bother computing a
 	 * calibrated temperature value */
@@ -3408,9 +3410,9 @@ static void iwl4965_handle_data_packet(struct iwl4965_priv *priv, int is_data,
 	ieee80211_rx_irqsafe(priv->hw, rxb->skb, stats);
 	priv->alloc_rxb_skb--;
 	rxb->skb = NULL;
-#ifdef LED
-	priv->led_packets += len;
-	iwl4965_setup_activity_timer(priv);
+#ifdef CONFIG_IWL4965_LEDS
+	if (is_data)
+		priv->rxtxpackets += len;
 #endif
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wireless/iwlwifi/iwl-4965.h
index 057fa15..d54068b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -44,6 +44,7 @@ extern struct pci_device_id iwl4965_hw_card_ids[];
 #include "iwl-csr.h"
 #include "iwl-prph.h"
 #include "iwl-4965-debug.h"
+#include "iwl-4965-led.h"
 
 /* Change firmware file name, using "-" and incrementing number,
  *   *only* when uCode interface or architecture changes so that it
@@ -1060,11 +1061,12 @@ struct iwl4965_priv {
 	struct iwl4965_init_alive_resp card_alive_init;
 	struct iwl4965_alive_resp card_alive;
 
-#ifdef LED
-	/* LED related variables */
-	struct iwl4965_activity_blink activity;
-	unsigned long led_packets;
-	int led_state;
+#ifdef CONFIG_IWL4965_LEDS
+	struct iwl4965_led led[IWL_LED_TRG_MAX];
+	unsigned long last_blink_time;
+	u8 last_blink_rate;
+	u8 allow_blinking;
+	unsigned int rxtxpackets;
 #endif
 
 	u16 active_rate;
diff --git a/drivers/net/wireless/iwlwifi/iwl-csr.h b/drivers/net/wireless/iwlwifi/iwl-csr.h
index 7016e5b..758e940 100644
--- a/drivers/net/wireless/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/iwlwifi/iwl-csr.h
@@ -93,6 +93,7 @@
 #define CSR_UCODE_DRV_GP1_CLR   (CSR_BASE+0x05c)
 #define CSR_UCODE_DRV_GP2       (CSR_BASE+0x060)
 #define CSR_GIO_CHICKEN_BITS    (CSR_BASE+0x100)
+#define CSR_LED_REG             (CSR_BASE+0x094)
 
 /* Analog phase-lock-loop configuration (3945 only)
  * Set bit 24. */
@@ -214,6 +215,11 @@
 #define CSR_GIO_CHICKEN_BITS_REG_BIT_L1A_NO_L0S_RX  (0x00800000)
 #define CSR_GIO_CHICKEN_BITS_REG_BIT_DIS_L0S_EXIT_TIMER  (0x20000000)
 
+/* LED */
+#define CSR_LED_BSM_CTRL_MSK (0xFFFFFFDF)
+#define CSR_LED_REG_TRUN_ON (0x78)
+#define CSR_LED_REG_TRUN_OFF (0x38)
+
 /*=== HBUS (Host-side Bus) ===*/
 #define HBUS_BASE	(0x400)
 /*
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index ecf749c..c3c21ab 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2481,8 +2481,12 @@ static void iwl3945_build_tx_cmd_basic(struct iwl3945_priv *priv,
 			cmd->cmd.tx.timeout.pm_frame_timeout = cpu_to_le16(3);
 		else
 			cmd->cmd.tx.timeout.pm_frame_timeout = cpu_to_le16(2);
-	} else
+	} else {
 		cmd->cmd.tx.timeout.pm_frame_timeout = 0;
+#ifdef CONFIG_IWL3945_LEDS
+		priv->rxtxpackets += le16_to_cpu(cmd->cmd.tx.len);
+#endif
+	}
 
 	cmd->cmd.tx.driver_txop = 0;
 	cmd->cmd.tx.tx_flags = tx_flags;
@@ -5851,6 +5855,8 @@ static void iwl3945_alive_start(struct iwl3945_priv *priv)
 	IWL_DEBUG_INFO("ALIVE processing complete.\n");
 	wake_up_interruptible(&priv->wait_command_queue);
 
+	iwl3945_led_register(priv);
+
 	if (priv->error_recovering)
 		iwl3945_error_recovery(priv);
 
@@ -5875,6 +5881,7 @@ static void __iwl3945_down(struct iwl3945_priv *priv)
 	if (!exit_pending)
 		set_bit(STATUS_EXIT_PENDING, &priv->status);
 
+	iwl3945_led_unregister(priv);
 	iwl3945_clear_stations_table(priv);
 
 	/* Unblock any waiting calls */
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 28c64c3..029556e 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -2598,8 +2598,12 @@ static void iwl4965_build_tx_cmd_basic(struct iwl4965_priv *priv,
 			cmd->cmd.tx.timeout.pm_frame_timeout = cpu_to_le16(3);
 		else
 			cmd->cmd.tx.timeout.pm_frame_timeout = cpu_to_le16(2);
-	} else
+	} else {
 		cmd->cmd.tx.timeout.pm_frame_timeout = 0;
+#ifdef CONFIG_IWL4965_LEDS
+	priv->rxtxpackets += le16_to_cpu(cmd->cmd.tx.len);
+#endif
+	}
 
 	cmd->cmd.tx.driver_txop = 0;
 	cmd->cmd.tx.tx_flags = tx_flags;
@@ -6355,6 +6359,8 @@ static void iwl4965_alive_start(struct iwl4965_priv *priv)
 	IWL_DEBUG_INFO("ALIVE processing complete.\n");
 	wake_up_interruptible(&priv->wait_command_queue);
 
+	iwl4965_led_register(priv);
+
 	if (priv->error_recovering)
 		iwl4965_error_recovery(priv);
 
@@ -6379,6 +6385,8 @@ static void __iwl4965_down(struct iwl4965_priv *priv)
 	if (!exit_pending)
 		set_bit(STATUS_EXIT_PENDING, &priv->status);
 
+	iwl4965_led_unregister(priv);
+
 	iwl4965_clear_stations_table(priv);
 
 	/* Unblock any waiting calls */
-- 
1.5.3.4

