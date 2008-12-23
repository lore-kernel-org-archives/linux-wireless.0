Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:51877 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751277AbYLWCyj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Dec 2008 21:54:39 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH] Revert "iwl3945: remove iwl-3945-led.[ch]"
Date: Tue, 23 Dec 2008 10:47:21 +0800
Message-Id: <1230000441-15977-1-git-send-email-yi.zhu@intel.com> (sfid-20081223_035454_957872_33011BC8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This reverts commit b3489137ec7dabe4531c4344347270857301e209. This
fixes the iwl3945 scan regression reported by Kalle Valo.

Conflicts:

	drivers/net/wireless/iwlwifi/iwl3945-base.c
---
 drivers/net/wireless/iwlwifi/Kconfig        |    1 -
 drivers/net/wireless/iwlwifi/Makefile       |    3 +
 drivers/net/wireless/iwlwifi/iwl-3945-led.c |  409 +++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-3945-led.h |   60 ++++
 drivers/net/wireless/iwlwifi/iwl-3945.c     |   10 +-
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    1 +
 drivers/net/wireless/iwlwifi/iwl-dev.h      |   11 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    7 +-
 8 files changed, 497 insertions(+), 5 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-3945-led.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-3945-led.h

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index 5ed2030..47bee0e 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -146,7 +146,6 @@ config IWL3945_SPECTRUM_MEASUREMENT
 config IWL3945_LEDS
 	bool "Enable LEDS features in iwl3945 driver"
 	depends on IWL3945
-	select IWLWIFI_LEDS
 	---help---
 	  This option enables LEDS for the iwl3945 driver.
 
diff --git a/drivers/net/wireless/iwlwifi/Makefile b/drivers/net/wireless/iwlwifi/Makefile
index 9808992..0be9e6b 100644
--- a/drivers/net/wireless/iwlwifi/Makefile
+++ b/drivers/net/wireless/iwlwifi/Makefile
@@ -15,3 +15,6 @@ iwlagn-$(CONFIG_IWL5000) += iwl-5000.o
 
 obj-$(CONFIG_IWL3945)	+= iwl3945.o
 iwl3945-objs		:= iwl3945-base.o iwl-3945.o iwl-3945-rs.o
+iwl3945-$(CONFIG_IWL3945_LEDS) += iwl-3945-led.o
+
+
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-led.c b/drivers/net/wireless/iwlwifi/iwl-3945-led.c
new file mode 100644
index 0000000..10e68d6
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-led.c
@@ -0,0 +1,409 @@
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
+ *  Intel Linux Wireless <ilw@linux.intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *
+ *****************************************************************************/
+
+
+#include <linux/kernel.h>
+#include <linux/module.h>
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
+#include "iwl-commands.h"
+#include "iwl-3945.h"
+
+
+static const struct {
+	u16 brightness;
+	u8 on_time;
+	u8 off_time;
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
+	{0, 167, 167},
+	/*SOLID_ON*/
+	{-1, IWL_LED_SOLID, 0}
+};
+
+#define IWL_1MB_RATE (128 * 1024)
+#define IWL_LED_THRESHOLD (16)
+#define IWL_MAX_BLINK_TBL (ARRAY_SIZE(blink_tbl) - 1) /*Exclude Solid on*/
+#define IWL_SOLID_BLINK_IDX (ARRAY_SIZE(blink_tbl) - 1)
+
+static int iwl3945_led_cmd_callback(struct iwl_priv *priv,
+				    struct iwl_cmd *cmd,
+				    struct sk_buff *skb)
+{
+	return 1;
+}
+
+static inline int iwl3945_brightness_to_idx(enum led_brightness brightness)
+{
+	return fls(0x000000FF & (u32)brightness);
+}
+
+/* Send led command */
+static int iwl_send_led_cmd(struct iwl_priv *priv,
+			    struct iwl_led_cmd *led_cmd)
+{
+	struct iwl_host_cmd cmd = {
+		.id = REPLY_LEDS_CMD,
+		.len = sizeof(struct iwl_led_cmd),
+		.data = led_cmd,
+		.meta.flags = CMD_ASYNC,
+		.meta.u.callback = iwl3945_led_cmd_callback,
+	};
+
+	return iwl3945_send_cmd(priv, &cmd);
+}
+
+
+
+/* Set led on command */
+static int iwl3945_led_pattern(struct iwl_priv *priv, int led_id,
+			       unsigned int idx)
+{
+	struct iwl_led_cmd led_cmd = {
+		.id = led_id,
+		.interval = IWL_DEF_LED_INTRVL
+	};
+
+	BUG_ON(idx > IWL_MAX_BLINK_TBL);
+
+	led_cmd.on = blink_tbl[idx].on_time;
+	led_cmd.off = blink_tbl[idx].off_time;
+
+	return iwl_send_led_cmd(priv, &led_cmd);
+}
+
+
+/* Set led on command */
+static int iwl3945_led_on(struct iwl_priv *priv, int led_id)
+{
+	struct iwl_led_cmd led_cmd = {
+		.id = led_id,
+		.on = IWL_LED_SOLID,
+		.off = 0,
+		.interval = IWL_DEF_LED_INTRVL
+	};
+	return iwl_send_led_cmd(priv, &led_cmd);
+}
+
+/* Set led off command */
+static int iwl3945_led_off(struct iwl_priv *priv, int led_id)
+{
+	struct iwl_led_cmd led_cmd = {
+		.id = led_id,
+		.on = 0,
+		.off = 0,
+		.interval = IWL_DEF_LED_INTRVL
+	};
+	IWL_DEBUG_LED("led off %d\n", led_id);
+	return iwl_send_led_cmd(priv, &led_cmd);
+}
+
+/*
+ * brightness call back function for Tx/Rx LED
+ */
+static int iwl3945_led_associated(struct iwl_priv *priv, int led_id)
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
+	struct iwl_priv *priv = led->priv;
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
+		if (led->led_pattern) {
+			int idx = iwl3945_brightness_to_idx(brightness);
+			led->led_pattern(priv, IWL_LED_LINK, idx);
+		}
+		break;
+	}
+}
+
+
+
+/*
+ * Register led class with the system
+ */
+static int iwl3945_led_register_led(struct iwl_priv *priv,
+				   struct iwl3945_led *led,
+				   enum led_type type, u8 set_led,
+				   char *trigger)
+{
+	struct device *device = wiphy_dev(priv->hw->wiphy);
+	int ret;
+
+	led->led_dev.name = led->name;
+	led->led_dev.brightness_set = iwl3945_led_brightness_set;
+	led->led_dev.default_trigger = trigger;
+
+	led->priv = priv;
+	led->type = type;
+
+	ret = led_classdev_register(device, &led->led_dev);
+	if (ret) {
+		IWL_ERR(priv, "Error: failed to register led handler.\n");
+		return ret;
+	}
+
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
+static inline u8 get_blink_rate(struct iwl_priv *priv)
+{
+	int index;
+	u64 current_tpt = priv->rxtxpackets;
+	s64 tpt = current_tpt - priv->led_tpt;
+
+	if (tpt < 0)
+		tpt = -tpt;
+	priv->led_tpt = current_tpt;
+
+	if (!priv->allow_blinking)
+		index = IWL_MAX_BLINK_TBL;
+	else
+		for (index = 0; index < IWL_MAX_BLINK_TBL; index++)
+			if (tpt > (blink_tbl[index].brightness * IWL_1MB_RATE))
+				break;
+	return index;
+}
+
+static inline int is_rf_kill(struct iwl_priv *priv)
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
+void iwl3945_led_background(struct iwl_priv *priv)
+{
+	u8 blink_idx;
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
+		if (priv->last_blink_rate != IWL_SOLID_BLINK_IDX) {
+			priv->last_blink_rate = IWL_SOLID_BLINK_IDX;
+			iwl3945_led_pattern(priv, IWL_LED_LINK,
+					    IWL_SOLID_BLINK_IDX);
+		}
+		return;
+	}
+	if (!priv->last_blink_time ||
+	    !time_after(jiffies, priv->last_blink_time +
+			msecs_to_jiffies(1000)))
+		return;
+
+	blink_idx = get_blink_rate(priv);
+
+	/* call only if blink rate change */
+	if (blink_idx != priv->last_blink_rate)
+		iwl3945_led_pattern(priv, IWL_LED_LINK, blink_idx);
+
+	priv->last_blink_time = jiffies;
+	priv->last_blink_rate = blink_idx;
+	priv->rxtxpackets = 0;
+}
+
+
+/* Register all led handler */
+int iwl3945_led_register(struct iwl_priv *priv)
+{
+	char *trigger;
+	int ret;
+
+	priv->last_blink_rate = 0;
+	priv->rxtxpackets = 0;
+	priv->led_tpt = 0;
+	priv->last_blink_time = 0;
+	priv->allow_blinking = 0;
+
+	trigger = ieee80211_get_radio_led_name(priv->hw);
+	snprintf(priv->led39[IWL_LED_TRG_RADIO].name,
+		 sizeof(priv->led39[IWL_LED_TRG_RADIO].name), "iwl-%s:radio",
+		 wiphy_name(priv->hw->wiphy));
+
+	priv->led39[IWL_LED_TRG_RADIO].led_on = iwl3945_led_on;
+	priv->led39[IWL_LED_TRG_RADIO].led_off = iwl3945_led_off;
+	priv->led39[IWL_LED_TRG_RADIO].led_pattern = NULL;
+
+	ret = iwl3945_led_register_led(priv,
+				   &priv->led39[IWL_LED_TRG_RADIO],
+				   IWL_LED_TRG_RADIO, 1, trigger);
+
+	if (ret)
+		goto exit_fail;
+
+	trigger = ieee80211_get_assoc_led_name(priv->hw);
+	snprintf(priv->led39[IWL_LED_TRG_ASSOC].name,
+		 sizeof(priv->led39[IWL_LED_TRG_ASSOC].name), "iwl-%s:assoc",
+		 wiphy_name(priv->hw->wiphy));
+
+	ret = iwl3945_led_register_led(priv,
+				   &priv->led39[IWL_LED_TRG_ASSOC],
+				   IWL_LED_TRG_ASSOC, 0, trigger);
+
+	/* for assoc always turn led on */
+	priv->led39[IWL_LED_TRG_ASSOC].led_on = iwl3945_led_on;
+	priv->led39[IWL_LED_TRG_ASSOC].led_off = iwl3945_led_on;
+	priv->led39[IWL_LED_TRG_ASSOC].led_pattern = NULL;
+
+	if (ret)
+		goto exit_fail;
+
+	trigger = ieee80211_get_rx_led_name(priv->hw);
+	snprintf(priv->led39[IWL_LED_TRG_RX].name,
+		 sizeof(priv->led39[IWL_LED_TRG_RX].name), "iwl-%s:RX",
+		 wiphy_name(priv->hw->wiphy));
+
+	ret = iwl3945_led_register_led(priv,
+				   &priv->led39[IWL_LED_TRG_RX],
+				   IWL_LED_TRG_RX, 0, trigger);
+
+	priv->led39[IWL_LED_TRG_RX].led_on = iwl3945_led_associated;
+	priv->led39[IWL_LED_TRG_RX].led_off = iwl3945_led_associated;
+	priv->led39[IWL_LED_TRG_RX].led_pattern = iwl3945_led_pattern;
+
+	if (ret)
+		goto exit_fail;
+
+	trigger = ieee80211_get_tx_led_name(priv->hw);
+	snprintf(priv->led39[IWL_LED_TRG_TX].name,
+		 sizeof(priv->led39[IWL_LED_TRG_TX].name), "iwl-%s:TX",
+		 wiphy_name(priv->hw->wiphy));
+
+	ret = iwl3945_led_register_led(priv,
+				   &priv->led39[IWL_LED_TRG_TX],
+				   IWL_LED_TRG_TX, 0, trigger);
+
+	priv->led39[IWL_LED_TRG_TX].led_on = iwl3945_led_associated;
+	priv->led39[IWL_LED_TRG_TX].led_off = iwl3945_led_associated;
+	priv->led39[IWL_LED_TRG_TX].led_pattern = iwl3945_led_pattern;
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
+void iwl3945_led_unregister(struct iwl_priv *priv)
+{
+	iwl3945_led_unregister_led(&priv->led39[IWL_LED_TRG_ASSOC], 0);
+	iwl3945_led_unregister_led(&priv->led39[IWL_LED_TRG_RX], 0);
+	iwl3945_led_unregister_led(&priv->led39[IWL_LED_TRG_TX], 0);
+	iwl3945_led_unregister_led(&priv->led39[IWL_LED_TRG_RADIO], 1);
+}
+
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-led.h b/drivers/net/wireless/iwlwifi/iwl-3945-led.h
new file mode 100644
index 0000000..859bb9b
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-led.h
@@ -0,0 +1,60 @@
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
+ *  Intel Linux Wireless <ilw@linux.intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *
+ *****************************************************************************/
+
+#ifndef IWL3945_LEDS_H
+#define IWL3945_LEDS_H
+
+struct iwl_priv;
+
+#ifdef CONFIG_IWL3945_LEDS
+
+#include "iwl-led.h"
+
+struct iwl3945_led {
+	struct iwl_priv *priv;
+	struct led_classdev led_dev;
+	char name[32];
+
+	int (*led_on) (struct iwl_priv *priv, int led_id);
+	int (*led_off) (struct iwl_priv *priv, int led_id);
+	int (*led_pattern) (struct iwl_priv *priv, int led_id,
+			    unsigned int idx);
+
+	enum led_type type;
+	unsigned int registered;
+};
+
+extern int iwl3945_led_register(struct iwl_priv *priv);
+extern void iwl3945_led_unregister(struct iwl_priv *priv);
+extern void iwl3945_led_background(struct iwl_priv *priv);
+
+#else
+static inline int iwl3945_led_register(struct iwl_priv *priv) { return 0; }
+static inline void iwl3945_led_unregister(struct iwl_priv *priv) {}
+static inline void iwl3945_led_background(struct iwl_priv *priv) {}
+#endif /* CONFIG_IWL3945_LEDS */
+
+#endif /* IWL3945_LEDS_H */
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 77c55a6..85a8790 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -399,7 +399,7 @@ void iwl3945_hw_rx_statistics(struct iwl_priv *priv, struct iwl_rx_mem_buffer *r
 
 	memcpy(&priv->statistics_39, pkt->u.raw, sizeof(priv->statistics_39));
 
-	iwl_leds_background(priv);
+	iwl3945_led_background(priv);
 
 	priv->last_statistics_time = jiffies;
 }
@@ -576,6 +576,9 @@ static void iwl3945_pass_packet_to_mac80211(struct iwl_priv *priv,
 				   struct ieee80211_rx_status *stats)
 {
 	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
+#ifdef CONFIG_IWL3945_LEDS
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)IWL_RX_DATA(pkt);
+#endif
 	struct iwl3945_rx_frame_hdr *rx_hdr = IWL_RX_HDR(pkt);
 	struct iwl3945_rx_frame_end *rx_end = IWL_RX_END(pkt);
 	short len = le16_to_cpu(rx_hdr->len);
@@ -600,6 +603,11 @@ static void iwl3945_pass_packet_to_mac80211(struct iwl_priv *priv,
 	if (iwl3945_mod_params.sw_crypto)
 		iwl3945_set_decrypted_flag(priv, rxb->skb,
 				       le32_to_cpu(rx_end->status), stats);
+
+#ifdef CONFIG_IWL3945_LEDS
+	if (ieee80211_is_data(hdr->frame_control))
+		priv->rxtxpackets += len;
+#endif
 	ieee80211_rx_irqsafe(priv->hw, rxb->skb, stats);
 	rxb->skb = NULL;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index bd41643..c5f5481 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -50,6 +50,7 @@ extern struct pci_device_id iwl3945_hw_card_ids[];
 #include "iwl-debug.h"
 #include "iwl-power.h"
 #include "iwl-dev.h"
+#include "iwl-3945-led.h"
 
 /* Highest firmware API version supported */
 #define IWL3945_UCODE_API_MAX 2
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index ef1099c..9b9d743 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -44,6 +44,7 @@
 #include "iwl-rfkill.h"
 #include "iwl-4965-hw.h"
 #include "iwl-3945-hw.h"
+#include "iwl-3945-led.h"
 #include "iwl-led.h"
 #include "iwl-power.h"
 #include "iwl-agn-rs.h"
@@ -903,13 +904,21 @@ struct iwl_priv {
 	struct rfkill *rfkill;
 #endif
 
-#ifdef	CONFIG_IWLWIFI_LEDS
+#if defined(CONFIG_IWLWIFI_LEDS) || defined(CONFIG_IWL3945_LEDS)
 	unsigned long last_blink_time;
 	u8 last_blink_rate;
 	u8 allow_blinking;
 	u64 led_tpt;
+#endif
+
+#ifdef CONFIG_IWLWIFI_LEDS
 	struct iwl_led led[IWL_LED_TRG_MAX];
 #endif
+
+#ifdef CONFIG_IWL3945_LEDS
+	struct iwl3945_led led39[IWL_LED_TRG_MAX];
+	unsigned int rxtxpackets;
+#endif
 	u16 active_rate;
 	u16 active_rate_basic;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index c098cac..b5f0b31 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2146,6 +2146,9 @@ static void iwl3945_build_tx_cmd_basic(struct iwl_priv *priv,
 			tx->timeout.pm_frame_timeout = cpu_to_le16(2);
 	} else {
 		tx->timeout.pm_frame_timeout = 0;
+#ifdef CONFIG_IWL3945_LEDS
+		priv->rxtxpackets += le16_to_cpu(cmd->cmd.tx.len);
+#endif
 	}
 
 	tx->driver_txop = 0;
@@ -5274,7 +5277,7 @@ static void iwl3945_alive_start(struct iwl_priv *priv)
 
 	iwl3945_reg_txpower_periodic(priv);
 
-	iwl_leds_register(priv);
+	iwl3945_led_register(priv);
 
 	IWL_DEBUG_INFO("ALIVE processing complete.\n");
 	set_bit(STATUS_READY, &priv->status);
@@ -5312,7 +5315,7 @@ static void __iwl3945_down(struct iwl_priv *priv)
 	if (!exit_pending)
 		set_bit(STATUS_EXIT_PENDING, &priv->status);
 
-	iwl_leds_unregister(priv);
+	iwl3945_led_unregister(priv);
 	iwl3945_clear_stations_table(priv);
 
 	/* Unblock any waiting calls */
-- 
1.5.3.6

