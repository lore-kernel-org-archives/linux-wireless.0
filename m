Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:12657 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758200AbZJBUtw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Oct 2009 16:49:52 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes@sipsolutions.net>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 09/13] iwlwifi: LED cleanup
Date: Fri,  2 Oct 2009 13:44:03 -0700
Message-Id: <1254516247-4085-10-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1254516247-4085-1-git-send-email-reinette.chatre@intel.com>
References: <1254516247-4085-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>

The iwlwifi drivers have LED blinking requirements that
mac80211 cannot fulfill due to the use of just a single
LED instead of different ones for TX, RX, radio etc.
Instead, the single LED blinks according to transfers
and is solid on the rest of the time. As such, having
LED class devices registered that mac80211 triggers are
connected to is pointless as we don't use the triggers
anyway.

Remove all the useless code and add hooks into the
driver itself. At the same time, make the LED code
abstracted so the core code that determines blink rate
etc. can be shared between 3945 and agn in iwlcore.

At the same time, the fact that we removed the use of
the mac80211 LED triggers means we can also remove the
IWLWIFI_LEDS Kconfig symbol since the LED support is
now self-contained.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/Kconfig        |    9 -
 drivers/net/wireless/iwlwifi/Makefile       |    5 +-
 drivers/net/wireless/iwlwifi/iwl-1000.c     |    2 +
 drivers/net/wireless/iwlwifi/iwl-3945-led.c |  371 ++-------------------------
 drivers/net/wireless/iwlwifi/iwl-3945-led.h |   22 +--
 drivers/net/wireless/iwlwifi/iwl-3945.c     |   10 +-
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    2 +
 drivers/net/wireless/iwlwifi/iwl-5000.c     |    5 +-
 drivers/net/wireless/iwlwifi/iwl-6000.c     |    2 +
 drivers/net/wireless/iwlwifi/iwl-agn-led.c  |   85 ++++++
 drivers/net/wireless/iwlwifi/iwl-agn-led.h  |   32 +++
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    6 +-
 drivers/net/wireless/iwlwifi/iwl-core.c     |    7 +-
 drivers/net/wireless/iwlwifi/iwl-core.h     |    7 +
 drivers/net/wireless/iwlwifi/iwl-debug.h    |    2 -
 drivers/net/wireless/iwlwifi/iwl-debugfs.c  |    8 -
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    7 +-
 drivers/net/wireless/iwlwifi/iwl-led.c      |  285 ++-------------------
 drivers/net/wireless/iwlwifi/iwl-led.h      |   38 +---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    8 +-
 21 files changed, 194 insertions(+), 721 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-agn-led.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-agn-led.h

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index 48d8f2c..c82c97b 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -2,15 +2,6 @@ config IWLWIFI
 	tristate "Intel Wireless Wifi"
 	depends on PCI && MAC80211 && WLAN_80211 && EXPERIMENTAL
 	select FW_LOADER
-	select MAC80211_LEDS if IWLWIFI_LEDS
-	select LEDS_CLASS if IWLWIFI_LEDS
-
-config IWLWIFI_LEDS
-	bool "Enable LED support in iwlagn and iwl3945 drivers"
-	depends on IWLWIFI
-	default y
-	---help---
-	  Select this if you want LED support.
 
 config IWLWIFI_SPECTRUM_MEASUREMENT
 	bool "Enable Spectrum Measurement in iwlagn driver"
diff --git a/drivers/net/wireless/iwlwifi/Makefile b/drivers/net/wireless/iwlwifi/Makefile
index 3f31d86..7f82044 100644
--- a/drivers/net/wireless/iwlwifi/Makefile
+++ b/drivers/net/wireless/iwlwifi/Makefile
@@ -1,9 +1,8 @@
 obj-$(CONFIG_IWLWIFI)	+= iwlcore.o
 iwlcore-objs 		:= iwl-core.o iwl-eeprom.o iwl-hcmd.o iwl-power.o
 iwlcore-objs 		+= iwl-rx.o iwl-tx.o iwl-sta.o iwl-calib.o
-iwlcore-objs 		+= iwl-scan.o
+iwlcore-objs 		+= iwl-scan.o iwl-led.o
 iwlcore-$(CONFIG_IWLWIFI_DEBUGFS) += iwl-debugfs.o
-iwlcore-$(CONFIG_IWLWIFI_LEDS) += iwl-led.o
 iwlcore-$(CONFIG_IWLWIFI_SPECTRUM_MEASUREMENT) += iwl-spectrum.o
 iwlcore-$(CONFIG_IWLWIFI_DEVICE_TRACING) += iwl-devtrace.o
 
@@ -11,7 +10,7 @@ CFLAGS_iwl-devtrace.o := -I$(src)
 
 # AGN
 obj-$(CONFIG_IWLAGN)	+= iwlagn.o
-iwlagn-objs		:= iwl-agn.o iwl-agn-rs.o
+iwlagn-objs		:= iwl-agn.o iwl-agn-rs.o iwl-agn-led.o
 
 iwlagn-$(CONFIG_IWL4965) += iwl-4965.o
 iwlagn-$(CONFIG_IWL5000) += iwl-5000.o
diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index af91dba..86d93b5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -44,6 +44,7 @@
 #include "iwl-sta.h"
 #include "iwl-helpers.h"
 #include "iwl-5000-hw.h"
+#include "iwl-agn-led.h"
 
 /* Highest firmware API version supported */
 #define IWL1000_UCODE_API_MAX 3
@@ -145,6 +146,7 @@ static struct iwl_ops iwl1000_ops = {
 	.lib = &iwl1000_lib,
 	.hcmd = &iwl5000_hcmd,
 	.utils = &iwl5000_hcmd_utils,
+	.led = &iwlagn_led_ops,
 };
 
 struct iwl_cfg iwl1000_bgn_cfg = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-led.c b/drivers/net/wireless/iwlwifi/iwl-3945-led.c
index 8c29ded..a871d09 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-led.c
@@ -24,8 +24,6 @@
  *
  *****************************************************************************/
 
-#ifdef CONFIG_IWLWIFI_LEDS
-
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
@@ -43,388 +41,51 @@
 #include "iwl-3945.h"
 #include "iwl-core.h"
 #include "iwl-dev.h"
+#include "iwl-3945-led.h"
 
-#ifdef CONFIG_IWLWIFI_DEBUG
-static const char *led_type_str[] = {
-	__stringify(IWL_LED_TRG_TX),
-	__stringify(IWL_LED_TRG_RX),
-	__stringify(IWL_LED_TRG_ASSOC),
-	__stringify(IWL_LED_TRG_RADIO),
-	NULL
-};
-#endif /* CONFIG_IWLWIFI_DEBUG */
-
-static const struct {
-	u16 brightness;
-	u8 on_time;
-	u8 off_time;
-} blink_tbl[] =
-{
-	{300, 25, 25},
-	{200, 40, 40},
-	{100, 55, 55},
-	{70, 65, 65},
-	{50, 75, 75},
-	{20, 85, 85},
-	{15, 95, 95 },
-	{10, 110, 110},
-	{5, 130, 130},
-	{0, 167, 167},
-	/* SOLID_ON */
-	{-1, IWL_LED_SOLID, 0}
-};
-
-#define IWL_1MB_RATE (128 * 1024)
-#define IWL_LED_THRESHOLD (16)
-#define IWL_MAX_BLINK_TBL (ARRAY_SIZE(blink_tbl) - 1) /*Exclude Solid on*/
-#define IWL_SOLID_BLINK_IDX (ARRAY_SIZE(blink_tbl) - 1)
-
-static void iwl3945_led_cmd_callback(struct iwl_priv *priv,
-				     struct iwl_device_cmd *cmd,
-				     struct sk_buff *skb)
-{
-}
-
-static inline int iwl3945_brightness_to_idx(enum led_brightness brightness)
-{
-	return fls(0x000000FF & (u32)brightness);
-}
 
 /* Send led command */
-static int iwl_send_led_cmd(struct iwl_priv *priv,
-			    struct iwl_led_cmd *led_cmd)
+static int iwl3945_send_led_cmd(struct iwl_priv *priv,
+				struct iwl_led_cmd *led_cmd)
 {
 	struct iwl_host_cmd cmd = {
 		.id = REPLY_LEDS_CMD,
 		.len = sizeof(struct iwl_led_cmd),
 		.data = led_cmd,
 		.flags = CMD_ASYNC,
-		.callback = iwl3945_led_cmd_callback,
+		.callback = NULL,
 	};
 
 	return iwl_send_cmd(priv, &cmd);
 }
 
-
-
-/* Set led on command */
-static int iwl3945_led_pattern(struct iwl_priv *priv, int led_id,
-			       unsigned int idx)
-{
-	struct iwl_led_cmd led_cmd = {
-		.id = led_id,
-		.interval = IWL_DEF_LED_INTRVL
-	};
-
-	BUG_ON(idx > IWL_MAX_BLINK_TBL);
-
-	led_cmd.on = blink_tbl[idx].on_time;
-	led_cmd.off = blink_tbl[idx].off_time;
-
-	return iwl_send_led_cmd(priv, &led_cmd);
-}
-
-
 /* Set led on command */
-static int iwl3945_led_on(struct iwl_priv *priv, int led_id)
+static int iwl3945_led_on(struct iwl_priv *priv)
 {
 	struct iwl_led_cmd led_cmd = {
-		.id = led_id,
+		.id = IWL_LED_LINK,
 		.on = IWL_LED_SOLID,
 		.off = 0,
 		.interval = IWL_DEF_LED_INTRVL
 	};
-	return iwl_send_led_cmd(priv, &led_cmd);
+	return iwl3945_send_led_cmd(priv, &led_cmd);
 }
 
 /* Set led off command */
-static int iwl3945_led_off(struct iwl_priv *priv, int led_id)
+static int iwl3945_led_off(struct iwl_priv *priv)
 {
 	struct iwl_led_cmd led_cmd = {
-		.id = led_id,
+		.id = IWL_LED_LINK,
 		.on = 0,
 		.off = 0,
 		.interval = IWL_DEF_LED_INTRVL
 	};
-	IWL_DEBUG_LED(priv, "led off %d\n", led_id);
-	return iwl_send_led_cmd(priv, &led_cmd);
+	IWL_DEBUG_LED(priv, "led off\n");
+	return iwl3945_send_led_cmd(priv, &led_cmd);
 }
 
-/*
- *  Set led on in case of association
- *  */
-static int iwl3945_led_associate(struct iwl_priv *priv, int led_id)
-{
-	IWL_DEBUG_LED(priv, "Associated\n");
-
-	priv->allow_blinking = 1;
-	return iwl3945_led_on(priv, led_id);
-}
-/* Set Led off in case of disassociation */
-static int iwl3945_led_disassociate(struct iwl_priv *priv, int led_id)
-{
-	IWL_DEBUG_LED(priv, "Disassociated\n");
-
-	priv->allow_blinking = 0;
-
-	return 0;
-}
-
-/*
- * brightness call back function for Tx/Rx LED
- */
-static int iwl3945_led_associated(struct iwl_priv *priv, int led_id)
-{
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status) ||
-	    !test_bit(STATUS_READY, &priv->status))
-		return 0;
-
-
-	/* start counting Tx/Rx bytes */
-	if (!priv->last_blink_time && priv->allow_blinking)
-		priv->last_blink_time = jiffies;
-	return 0;
-}
-
-/*
- * brightness call back for association and radio
- */
-static void iwl3945_led_brightness_set(struct led_classdev *led_cdev,
-				enum led_brightness brightness)
-{
-	struct iwl_led *led = container_of(led_cdev,
-					   struct iwl_led, led_dev);
-	struct iwl_priv *priv = led->priv;
-
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
-		return;
-
-	IWL_DEBUG_LED(priv, "Led type = %s brightness = %d\n",
-			led_type_str[led->type], brightness);
-
-	switch (brightness) {
-	case LED_FULL:
-		if (led->led_on)
-			led->led_on(priv, IWL_LED_LINK);
-		break;
-	case LED_OFF:
-		if (led->led_off)
-			led->led_off(priv, IWL_LED_LINK);
-		break;
-	default:
-		if (led->led_pattern) {
-			int idx = iwl3945_brightness_to_idx(brightness);
-			led->led_pattern(priv, IWL_LED_LINK, idx);
-		}
-		break;
-	}
-}
-
-/*
- * Register led class with the system
- */
-static int iwl3945_led_register_led(struct iwl_priv *priv,
-				   struct iwl_led *led,
-				   enum led_type type, u8 set_led,
-				   char *trigger)
-{
-	struct device *device = wiphy_dev(priv->hw->wiphy);
-	int ret;
-
-	led->led_dev.name = led->name;
-	led->led_dev.brightness_set = iwl3945_led_brightness_set;
-	led->led_dev.default_trigger = trigger;
-
-	led->priv = priv;
-	led->type = type;
-
-	ret = led_classdev_register(device, &led->led_dev);
-	if (ret) {
-		IWL_ERR(priv, "Error: failed to register led handler.\n");
-		return ret;
-	}
-
-	led->registered = 1;
-
-	if (set_led && led->led_on)
-		led->led_on(priv, IWL_LED_LINK);
-	return 0;
-}
-
-
-/*
- * calculate blink rate according to last 2 sec Tx/Rx activities
- */
-static inline u8 get_blink_rate(struct iwl_priv *priv)
-{
-	int index;
-	s64 tpt = priv->rxtxpackets;
-
-	if (tpt < 0)
-		tpt = -tpt;
-
-	IWL_DEBUG_LED(priv, "tpt %lld \n", (long long)tpt);
-
-	if (!priv->allow_blinking)
-		index = IWL_MAX_BLINK_TBL;
-	else
-		for (index = 0; index < IWL_MAX_BLINK_TBL; index++)
-			if (tpt > (blink_tbl[index].brightness * IWL_1MB_RATE))
-				break;
-
-	IWL_DEBUG_LED(priv, "LED BLINK IDX=%d\n", index);
-	return index;
-}
-
-/*
- * this function called from handler. Since setting Led command can
- * happen very frequent we postpone led command to be called from
- * REPLY handler so we know ucode is up
- */
-void iwl3945_led_background(struct iwl_priv *priv)
-{
-	u8 blink_idx;
-
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status)) {
-		priv->last_blink_time = 0;
-		return;
-	}
-	if (iwl_is_rfkill(priv)) {
-		priv->last_blink_time = 0;
-		return;
-	}
-
-	if (!priv->allow_blinking) {
-		priv->last_blink_time = 0;
-		if (priv->last_blink_rate != IWL_SOLID_BLINK_IDX) {
-			priv->last_blink_rate = IWL_SOLID_BLINK_IDX;
-			iwl3945_led_pattern(priv, IWL_LED_LINK,
-					    IWL_SOLID_BLINK_IDX);
-		}
-		return;
-	}
-	if (!priv->last_blink_time ||
-	    !time_after(jiffies, priv->last_blink_time +
-			msecs_to_jiffies(1000)))
-		return;
-
-	blink_idx = get_blink_rate(priv);
-
-	/* call only if blink rate change */
-	if (blink_idx != priv->last_blink_rate)
-		iwl3945_led_pattern(priv, IWL_LED_LINK, blink_idx);
-
-	priv->last_blink_time = jiffies;
-	priv->last_blink_rate = blink_idx;
-	priv->rxtxpackets = 0;
-}
-
-
-/* Register all led handler */
-int iwl3945_led_register(struct iwl_priv *priv)
-{
-	char *trigger;
-	int ret;
-
-	priv->last_blink_rate = 0;
-	priv->rxtxpackets = 0;
-	priv->led_tpt = 0;
-	priv->last_blink_time = 0;
-	priv->allow_blinking = 0;
-
-	trigger = ieee80211_get_radio_led_name(priv->hw);
-	snprintf(priv->led[IWL_LED_TRG_RADIO].name,
-		 sizeof(priv->led[IWL_LED_TRG_RADIO].name), "iwl-%s::radio",
-		 wiphy_name(priv->hw->wiphy));
-
-	priv->led[IWL_LED_TRG_RADIO].led_on = iwl3945_led_on;
-	priv->led[IWL_LED_TRG_RADIO].led_off = iwl3945_led_off;
-	priv->led[IWL_LED_TRG_RADIO].led_pattern = NULL;
-
-	ret = iwl3945_led_register_led(priv,
-				   &priv->led[IWL_LED_TRG_RADIO],
-				   IWL_LED_TRG_RADIO, 1, trigger);
-
-	if (ret)
-		goto exit_fail;
-
-	trigger = ieee80211_get_assoc_led_name(priv->hw);
-	snprintf(priv->led[IWL_LED_TRG_ASSOC].name,
-		 sizeof(priv->led[IWL_LED_TRG_ASSOC].name), "iwl-%s::assoc",
-		 wiphy_name(priv->hw->wiphy));
-
-	ret = iwl3945_led_register_led(priv,
-				   &priv->led[IWL_LED_TRG_ASSOC],
-				   IWL_LED_TRG_ASSOC, 0, trigger);
-
-	/* for assoc always turn led on */
-	priv->led[IWL_LED_TRG_ASSOC].led_on = iwl3945_led_associate;
-	priv->led[IWL_LED_TRG_ASSOC].led_off = iwl3945_led_disassociate;
-	priv->led[IWL_LED_TRG_ASSOC].led_pattern = NULL;
-
-	if (ret)
-		goto exit_fail;
-
-	trigger = ieee80211_get_rx_led_name(priv->hw);
-	snprintf(priv->led[IWL_LED_TRG_RX].name,
-		 sizeof(priv->led[IWL_LED_TRG_RX].name), "iwl-%s::RX",
-		 wiphy_name(priv->hw->wiphy));
-
-	ret = iwl3945_led_register_led(priv,
-				   &priv->led[IWL_LED_TRG_RX],
-				   IWL_LED_TRG_RX, 0, trigger);
-
-	priv->led[IWL_LED_TRG_RX].led_on = iwl3945_led_associated;
-	priv->led[IWL_LED_TRG_RX].led_off = iwl3945_led_associated;
-	priv->led[IWL_LED_TRG_RX].led_pattern = iwl3945_led_pattern;
-
-	if (ret)
-		goto exit_fail;
-
-	trigger = ieee80211_get_tx_led_name(priv->hw);
-	snprintf(priv->led[IWL_LED_TRG_TX].name,
-		 sizeof(priv->led[IWL_LED_TRG_TX].name), "iwl-%s::TX",
-		 wiphy_name(priv->hw->wiphy));
-
-	ret = iwl3945_led_register_led(priv,
-				   &priv->led[IWL_LED_TRG_TX],
-				   IWL_LED_TRG_TX, 0, trigger);
-
-	priv->led[IWL_LED_TRG_TX].led_on = iwl3945_led_associated;
-	priv->led[IWL_LED_TRG_TX].led_off = iwl3945_led_associated;
-	priv->led[IWL_LED_TRG_TX].led_pattern = iwl3945_led_pattern;
-
-	if (ret)
-		goto exit_fail;
-
-	return 0;
-
-exit_fail:
-	iwl3945_led_unregister(priv);
-	return ret;
-}
-
-
-/* unregister led class */
-static void iwl3945_led_unregister_led(struct iwl_led *led, u8 set_led)
-{
-	if (!led->registered)
-		return;
-
-	led_classdev_unregister(&led->led_dev);
-
-	if (set_led)
-		led->led_dev.brightness_set(&led->led_dev, LED_OFF);
-	led->registered = 0;
-}
-
-/* Unregister all led handlers */
-void iwl3945_led_unregister(struct iwl_priv *priv)
-{
-	iwl3945_led_unregister_led(&priv->led[IWL_LED_TRG_ASSOC], 0);
-	iwl3945_led_unregister_led(&priv->led[IWL_LED_TRG_RX], 0);
-	iwl3945_led_unregister_led(&priv->led[IWL_LED_TRG_TX], 0);
-	iwl3945_led_unregister_led(&priv->led[IWL_LED_TRG_RADIO], 1);
-}
-
-#endif
+const struct iwl_led_ops iwl3945_led_ops = {
+	.cmd = iwl3945_send_led_cmd,
+	.on = iwl3945_led_on,
+	.off = iwl3945_led_off,
+};
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-led.h b/drivers/net/wireless/iwlwifi/iwl-3945-led.h
index 3b65642..5a1033c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-led.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-led.h
@@ -24,23 +24,9 @@
  *
  *****************************************************************************/
 
-#ifndef IWL3945_LEDS_H
-#define IWL3945_LEDS_H
+#ifndef __iwl_3945_led_h__
+#define __iwl_3945_led_h__
 
-struct iwl_priv;
+extern const struct iwl_led_ops iwl3945_led_ops;
 
-#ifdef CONFIG_IWLWIFI_LEDS
-
-#include "iwl-led.h"
-
-extern int iwl3945_led_register(struct iwl_priv *priv);
-extern void iwl3945_led_unregister(struct iwl_priv *priv);
-extern void iwl3945_led_background(struct iwl_priv *priv);
-
-#else
-static inline int iwl3945_led_register(struct iwl_priv *priv) { return 0; }
-static inline void iwl3945_led_unregister(struct iwl_priv *priv) {}
-static inline void iwl3945_led_background(struct iwl_priv *priv) {}
-
-#endif /* IWLWIFI_LEDS*/
-#endif /* IWL3945_LEDS_H */
+#endif /* __iwl_3945_led_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 7bf447e..8cc0dfc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -46,7 +46,8 @@
 #include "iwl-eeprom.h"
 #include "iwl-helpers.h"
 #include "iwl-core.h"
-#include "iwl-agn-rs.h"
+#include "iwl-led.h"
+#include "iwl-3945-led.h"
 
 #define IWL_DECLARE_RATE_INFO(r, ip, in, rp, rn, pp, np)    \
 	[IWL_RATE_##r##M_INDEX] = { IWL_RATE_##r##M_PLCP,   \
@@ -359,7 +360,7 @@ void iwl3945_hw_rx_statistics(struct iwl_priv *priv,
 
 	memcpy(&priv->statistics_39, pkt->u.raw, sizeof(priv->statistics_39));
 
-	iwl3945_led_background(priv);
+	iwl_leds_background(priv);
 
 	priv->last_statistics_time = jiffies;
 }
@@ -572,10 +573,6 @@ static void iwl3945_pass_packet_to_mac80211(struct iwl_priv *priv,
 				       (struct ieee80211_hdr *)rxb->skb->data,
 				       le32_to_cpu(rx_end->status), stats);
 
-#ifdef CONFIG_IWLWIFI_LEDS
-	if (ieee80211_is_data(hdr->frame_control))
-		priv->rxtxpackets += len;
-#endif
 	iwl_update_stats(priv, false, hdr->frame_control, len);
 
 	memcpy(IEEE80211_SKB_RXCB(rxb->skb), stats, sizeof(*stats));
@@ -2880,6 +2877,7 @@ static struct iwl_ops iwl3945_ops = {
 	.lib = &iwl3945_lib,
 	.hcmd = &iwl3945_hcmd,
 	.utils = &iwl3945_hcmd_utils,
+	.led = &iwl3945_led_ops,
 };
 
 static struct iwl_cfg iwl3945_bg_cfg = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index 21679bf..f3907c1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -46,7 +46,7 @@ extern struct pci_device_id iwl3945_hw_card_ids[];
 #include "iwl-debug.h"
 #include "iwl-power.h"
 #include "iwl-dev.h"
-#include "iwl-3945-led.h"
+#include "iwl-led.h"
 
 /* Highest firmware API version supported */
 #define IWL3945_UCODE_API_MAX 2
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 0921e45..8717946 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -44,6 +44,7 @@
 #include "iwl-helpers.h"
 #include "iwl-calib.h"
 #include "iwl-sta.h"
+#include "iwl-agn-led.h"
 
 static int iwl4965_send_tx_power(struct iwl_priv *priv);
 static int iwl4965_hw_get_temperature(struct iwl_priv *priv);
@@ -2341,6 +2342,7 @@ static struct iwl_ops iwl4965_ops = {
 	.lib = &iwl4965_lib,
 	.hcmd = &iwl4965_hcmd,
 	.utils = &iwl4965_hcmd_utils,
+	.led = &iwlagn_led_ops,
 };
 
 struct iwl_cfg iwl4965_agn_cfg = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 01d53eb..6248535 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -42,6 +42,7 @@
 #include "iwl-io.h"
 #include "iwl-sta.h"
 #include "iwl-helpers.h"
+#include "iwl-agn-led.h"
 #include "iwl-5000-hw.h"
 #include "iwl-6000-hw.h"
 
@@ -1641,11 +1642,12 @@ static struct iwl_lib_ops iwl5150_lib = {
 	 },
 };
 
-struct iwl_ops iwl5000_ops = {
+static struct iwl_ops iwl5000_ops = {
 	.ucode = &iwl5000_ucode,
 	.lib = &iwl5000_lib,
 	.hcmd = &iwl5000_hcmd,
 	.utils = &iwl5000_hcmd_utils,
+	.led = &iwlagn_led_ops,
 };
 
 static struct iwl_ops iwl5150_ops = {
@@ -1653,6 +1655,7 @@ static struct iwl_ops iwl5150_ops = {
 	.lib = &iwl5150_lib,
 	.hcmd = &iwl5000_hcmd,
 	.utils = &iwl5000_hcmd_utils,
+	.led = &iwlagn_led_ops,
 };
 
 struct iwl_mod_params iwl50_mod_params = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 6f4ee27..a002214 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -45,6 +45,7 @@
 #include "iwl-helpers.h"
 #include "iwl-5000-hw.h"
 #include "iwl-6000-hw.h"
+#include "iwl-agn-led.h"
 
 /* Highest firmware API version supported */
 #define IWL6000_UCODE_API_MAX 4
@@ -227,6 +228,7 @@ static struct iwl_ops iwl6000_ops = {
 	.lib = &iwl6000_lib,
 	.hcmd = &iwl5000_hcmd,
 	.utils = &iwl5000_hcmd_utils,
+	.led = &iwlagn_led_ops,
 };
 
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-led.c b/drivers/net/wireless/iwlwifi/iwl-agn-led.c
new file mode 100644
index 0000000..3bccba2
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-led.c
@@ -0,0 +1,85 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2003 - 2009 Intel Corporation. All rights reserved.
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
+#include "iwl-dev.h"
+#include "iwl-core.h"
+#include "iwl-io.h"
+#include "iwl-agn-led.h"
+
+/* Send led command */
+static int iwl_send_led_cmd(struct iwl_priv *priv, struct iwl_led_cmd *led_cmd)
+{
+	struct iwl_host_cmd cmd = {
+		.id = REPLY_LEDS_CMD,
+		.len = sizeof(struct iwl_led_cmd),
+		.data = led_cmd,
+		.flags = CMD_ASYNC,
+		.callback = NULL,
+	};
+	u32 reg;
+
+	reg = iwl_read32(priv, CSR_LED_REG);
+	if (reg != (reg & CSR_LED_BSM_CTRL_MSK))
+		iwl_write32(priv, CSR_LED_REG, reg & CSR_LED_BSM_CTRL_MSK);
+
+	return iwl_send_cmd(priv, &cmd);
+}
+
+/* Set led register off */
+static int iwl_led_on_reg(struct iwl_priv *priv)
+{
+	IWL_DEBUG_LED(priv, "led on\n");
+	iwl_write32(priv, CSR_LED_REG, CSR_LED_REG_TRUN_ON);
+	return 0;
+}
+
+/* Set led register off */
+static int iwl_led_off_reg(struct iwl_priv *priv)
+{
+	IWL_DEBUG_LED(priv, "LED Reg off\n");
+	iwl_write32(priv, CSR_LED_REG, CSR_LED_REG_TRUN_OFF);
+	return 0;
+}
+
+const struct iwl_led_ops iwlagn_led_ops = {
+	.cmd = iwl_send_led_cmd,
+	.on = iwl_led_on_reg,
+	.off = iwl_led_off_reg,
+};
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-led.h b/drivers/net/wireless/iwlwifi/iwl-agn-led.h
new file mode 100644
index 0000000..ab55f92
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-led.h
@@ -0,0 +1,32 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2003 - 2009 Intel Corporation. All rights reserved.
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
+#ifndef __iwl_agn_led_h__
+#define __iwl_agn_led_h__
+
+extern const struct iwl_led_ops iwlagn_led_ops;
+
+#endif /* __iwl_agn_led_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 4fb50d0..046b571 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1801,7 +1801,7 @@ static void iwl_alive_start(struct iwl_priv *priv)
 	/* At this point, the NIC is initialized and operational */
 	iwl_rf_kill_ct_config(priv);
 
-	iwl_leds_register(priv);
+	iwl_leds_init(priv);
 
 	IWL_DEBUG_INFO(priv, "ALIVE processing complete.\n");
 	set_bit(STATUS_READY, &priv->status);
@@ -1839,8 +1839,6 @@ static void __iwl_down(struct iwl_priv *priv)
 	if (!exit_pending)
 		set_bit(STATUS_EXIT_PENDING, &priv->status);
 
-	iwl_leds_unregister(priv);
-
 	iwl_clear_stations_table(priv);
 
 	/* Unblock any waiting calls */
@@ -2339,6 +2337,8 @@ static int iwl_mac_start(struct ieee80211_hw *hw)
 		}
 	}
 
+	iwl_led_start(priv);
+
 out:
 	priv->is_open = 1;
 	IWL_DEBUG_MAC80211(priv, "leave\n");
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 1cf2e04..34547cf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2384,6 +2384,8 @@ void iwl_bss_info_changed(struct ieee80211_hw *hw,
 			priv->timestamp = bss_conf->timestamp;
 			priv->assoc_capability = bss_conf->assoc_capability;
 
+			iwl_led_associate(priv);
+
 			/*
 			 * We have just associated, don't start scan too early
 			 * leave time for EAPOL exchange to complete.
@@ -2394,9 +2396,10 @@ void iwl_bss_info_changed(struct ieee80211_hw *hw,
 					IWL_DELAY_NEXT_SCAN_AFTER_ASSOC;
 			if (!iwl_is_rfkill(priv))
 				priv->cfg->ops->lib->post_associate(priv);
-		} else
+		} else {
 			priv->assoc_id = 0;
-
+			iwl_led_disassociate(priv);
+		}
 	}
 
 	if (changes && iwl_is_associated(priv) && priv->assoc_id) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 3bd0e59..eb586a5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -187,11 +187,18 @@ struct iwl_lib_ops {
 	struct iwl_temp_ops temp_ops;
 };
 
+struct iwl_led_ops {
+	int (*cmd)(struct iwl_priv *priv, struct iwl_led_cmd *led_cmd);
+	int (*on)(struct iwl_priv *priv);
+	int (*off)(struct iwl_priv *priv);
+};
+
 struct iwl_ops {
 	const struct iwl_ucode_ops *ucode;
 	const struct iwl_lib_ops *lib;
 	const struct iwl_hcmd_ops *hcmd;
 	const struct iwl_hcmd_utils_ops *utils;
+	const struct iwl_led_ops *led;
 };
 
 struct iwl_mod_params {
diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index cbc6290..b9ca475 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -84,9 +84,7 @@ struct iwl_debugfs {
 		struct dentry *file_interrupt;
 		struct dentry *file_qos;
 		struct dentry *file_thermal_throttling;
-#ifdef CONFIG_IWLWIFI_LEDS
 		struct dentry *file_led;
-#endif
 		struct dentry *file_disable_ht40;
 		struct dentry *file_sleep_level_override;
 		struct dentry *file_current_sleep_command;
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index fa6371d..1794b9c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -677,7 +677,6 @@ static ssize_t iwl_dbgfs_qos_read(struct file *file, char __user *user_buf,
 	return ret;
 }
 
-#ifdef CONFIG_IWLWIFI_LEDS
 static ssize_t iwl_dbgfs_led_read(struct file *file, char __user *user_buf,
 				  size_t count, loff_t *ppos)
 {
@@ -702,7 +701,6 @@ static ssize_t iwl_dbgfs_led_read(struct file *file, char __user *user_buf,
 	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 	return ret;
 }
-#endif
 
 static ssize_t iwl_dbgfs_thermal_throttling_read(struct file *file,
 				char __user *user_buf,
@@ -866,9 +864,7 @@ DEBUGFS_READ_FILE_OPS(channels);
 DEBUGFS_READ_FILE_OPS(status);
 DEBUGFS_READ_WRITE_FILE_OPS(interrupt);
 DEBUGFS_READ_FILE_OPS(qos);
-#ifdef CONFIG_IWLWIFI_LEDS
 DEBUGFS_READ_FILE_OPS(led);
-#endif
 DEBUGFS_READ_FILE_OPS(thermal_throttling);
 DEBUGFS_READ_WRITE_FILE_OPS(disable_ht40);
 DEBUGFS_READ_WRITE_FILE_OPS(sleep_level_override);
@@ -1666,9 +1662,7 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 	DEBUGFS_ADD_FILE(status, data);
 	DEBUGFS_ADD_FILE(interrupt, data);
 	DEBUGFS_ADD_FILE(qos, data);
-#ifdef CONFIG_IWLWIFI_LEDS
 	DEBUGFS_ADD_FILE(led, data);
-#endif
 	DEBUGFS_ADD_FILE(sleep_level_override, data);
 	DEBUGFS_ADD_FILE(current_sleep_command, data);
 	DEBUGFS_ADD_FILE(thermal_throttling, data);
@@ -1721,9 +1715,7 @@ void iwl_dbgfs_unregister(struct iwl_priv *priv)
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_status);
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_interrupt);
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_qos);
-#ifdef CONFIG_IWLWIFI_LEDS
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_led);
-#endif
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_thermal_throttling);
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_disable_ht40);
 	DEBUGFS_REMOVE(priv->dbgfs->dir_data);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index ad99ce7..eabc556 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -43,7 +43,6 @@
 #include "iwl-debug.h"
 #include "iwl-4965-hw.h"
 #include "iwl-3945-hw.h"
-#include "iwl-3945-led.h"
 #include "iwl-led.h"
 #include "iwl-power.h"
 #include "iwl-agn-rs.h"
@@ -73,7 +72,6 @@ struct iwl_tx_queue;
 
 /* shared structures from iwl-5000.c */
 extern struct iwl_mod_params iwl50_mod_params;
-extern struct iwl_ops iwl5000_ops;
 extern struct iwl_ucode_ops iwl5000_ucode;
 extern struct iwl_lib_ops iwl5000_lib;
 extern struct iwl_hcmd_ops iwl5000_hcmd;
@@ -1066,14 +1064,11 @@ struct iwl_priv {
 	struct iwl_init_alive_resp card_alive_init;
 	struct iwl_alive_resp card_alive;
 
-#ifdef CONFIG_IWLWIFI_LEDS
 	unsigned long last_blink_time;
 	u8 last_blink_rate;
 	u8 allow_blinking;
 	u64 led_tpt;
-	struct iwl_led led[IWL_LED_TRG_MAX];
-	unsigned int rxtxpackets;
-#endif
+
 	u16 active_rate;
 	u16 active_rate_basic;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-led.c b/drivers/net/wireless/iwlwifi/iwl-led.c
index 685ba9d..478c905 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-led.c
@@ -48,16 +48,6 @@ module_param(led_mode, int, S_IRUGO);
 MODULE_PARM_DESC(led_mode, "led mode: 0=blinking, 1=On(RF On)/Off(RF Off), "
 			   "(default 0)\n");
 
-#ifdef CONFIG_IWLWIFI_DEBUG
-static const char *led_type_str[] = {
-	__stringify(IWL_LED_TRG_TX),
-	__stringify(IWL_LED_TRG_RX),
-	__stringify(IWL_LED_TRG_ASSOC),
-	__stringify(IWL_LED_TRG_RADIO),
-	NULL
-};
-#endif /* CONFIG_IWLWIFI_DEBUG */
-
 
 static const struct {
 	u16 tpt;	/* Mb/s */
@@ -75,7 +65,7 @@ static const struct {
 	{5, 110, 110},
 	{1, 130, 130},
 	{0, 167, 167},
-/* SOLID_ON */
+	/* SOLID_ON */
 	{-1, IWL_LED_SOLID, 0}
 };
 
@@ -107,37 +97,11 @@ static inline u8 iwl_blink_compensation(struct iwl_priv *priv,
 	return (u8)((time * compensation) >> 6);
 }
 
-/*  [0-256] -> [0..8] FIXME: we need [0..10] */
-static inline int iwl_brightness_to_idx(enum led_brightness brightness)
-{
-	return fls(0x000000FF & (u32)brightness);
-}
-
-/* Send led command */
-static int iwl_send_led_cmd(struct iwl_priv *priv, struct iwl_led_cmd *led_cmd)
-{
-	struct iwl_host_cmd cmd = {
-		.id = REPLY_LEDS_CMD,
-		.len = sizeof(struct iwl_led_cmd),
-		.data = led_cmd,
-		.flags = CMD_ASYNC,
-		.callback = NULL,
-	};
-	u32 reg;
-
-	reg = iwl_read32(priv, CSR_LED_REG);
-	if (reg != (reg & CSR_LED_BSM_CTRL_MSK))
-		iwl_write32(priv, CSR_LED_REG, reg & CSR_LED_BSM_CTRL_MSK);
-
-	return iwl_send_cmd(priv, &cmd);
-}
-
 /* Set led pattern command */
-static int iwl_led_pattern(struct iwl_priv *priv, int led_id,
-			       unsigned int idx)
+static int iwl_led_pattern(struct iwl_priv *priv, unsigned int idx)
 {
 	struct iwl_led_cmd led_cmd = {
-		.id = led_id,
+		.id = IWL_LED_LINK,
 		.interval = IWL_DEF_LED_INTRVL
 	};
 
@@ -152,153 +116,32 @@ static int iwl_led_pattern(struct iwl_priv *priv, int led_id,
 		iwl_blink_compensation(priv, blink_tbl[idx].off_time,
 					priv->cfg->led_compensation);
 
-	return iwl_send_led_cmd(priv, &led_cmd);
-}
-
-/* Set led register off */
-static int iwl_led_on_reg(struct iwl_priv *priv, int led_id)
-{
-	IWL_DEBUG_LED(priv, "led on %d\n", led_id);
-	iwl_write32(priv, CSR_LED_REG, CSR_LED_REG_TRUN_ON);
-	return 0;
-}
-
-#if 0
-/* Set led on command */
-static int iwl_led_on(struct iwl_priv *priv, int led_id)
-{
-	struct iwl_led_cmd led_cmd = {
-		.id = led_id,
-		.on = IWL_LED_SOLID,
-		.off = 0,
-		.interval = IWL_DEF_LED_INTRVL
-	};
-	return iwl_send_led_cmd(priv, &led_cmd);
-}
-
-/* Set led off command */
-int iwl_led_off(struct iwl_priv *priv, int led_id)
-{
-	struct iwl_led_cmd led_cmd = {
-		.id = led_id,
-		.on = 0,
-		.off = 0,
-		.interval = IWL_DEF_LED_INTRVL
-	};
-	IWL_DEBUG_LED(priv, "led off %d\n", led_id);
-	return iwl_send_led_cmd(priv, &led_cmd);
+	return priv->cfg->ops->led->cmd(priv, &led_cmd);
 }
-#endif
 
-
-/* Set led register off */
-static int iwl_led_off_reg(struct iwl_priv *priv, int led_id)
+int iwl_led_start(struct iwl_priv *priv)
 {
-	IWL_DEBUG_LED(priv, "LED Reg off\n");
-	iwl_write32(priv, CSR_LED_REG, CSR_LED_REG_TRUN_OFF);
-	return 0;
+	return priv->cfg->ops->led->on(priv);
 }
+EXPORT_SYMBOL(iwl_led_start);
 
-/*
- * Set led register in case of disassociation according to rfkill state
- */
-static int iwl_led_associate(struct iwl_priv *priv, int led_id)
+int iwl_led_associate(struct iwl_priv *priv)
 {
 	IWL_DEBUG_LED(priv, "Associated\n");
 	if (led_mode == IWL_LED_BLINK)
 		priv->allow_blinking = 1;
-	return iwl_led_on_reg(priv, led_id);
-}
-static int iwl_led_disassociate(struct iwl_priv *priv, int led_id)
-{
-	priv->allow_blinking = 0;
-
-	return 0;
-}
-
-/*
- * brightness call back function for Tx/Rx LED
- */
-static int iwl_led_associated(struct iwl_priv *priv, int led_id)
-{
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status) ||
-	    !test_bit(STATUS_READY, &priv->status))
-		return 0;
-
+	priv->last_blink_time = jiffies;
 
-	/* start counting Tx/Rx bytes */
-	if (!priv->last_blink_time && priv->allow_blinking)
-		priv->last_blink_time = jiffies;
 	return 0;
 }
 
-/*
- * brightness call back for association and radio
- */
-static void iwl_led_brightness_set(struct led_classdev *led_cdev,
-				       enum led_brightness brightness)
+int iwl_led_disassociate(struct iwl_priv *priv)
 {
-	struct iwl_led *led = container_of(led_cdev, struct iwl_led, led_dev);
-	struct iwl_priv *priv = led->priv;
-
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
-		return;
-
-
-	IWL_DEBUG_LED(priv, "Led type = %s brightness = %d\n",
-			led_type_str[led->type], brightness);
-	switch (brightness) {
-	case LED_FULL:
-		if (led->led_on)
-			led->led_on(priv, IWL_LED_LINK);
-		break;
-	case LED_OFF:
-		if (led->led_off)
-			led->led_off(priv, IWL_LED_LINK);
-		break;
-	default:
-		if (led->led_pattern) {
-			int idx = iwl_brightness_to_idx(brightness);
-			led->led_pattern(priv, IWL_LED_LINK, idx);
-		}
-		break;
-	}
-}
-
-
-
-/*
- * Register led class with the system
- */
-static int iwl_leds_register_led(struct iwl_priv *priv, struct iwl_led *led,
-				   enum led_type type, u8 set_led,
-				   char *trigger)
-{
-	struct device *device = wiphy_dev(priv->hw->wiphy);
-	int ret;
-
-	led->led_dev.name = led->name;
-	led->led_dev.brightness_set = iwl_led_brightness_set;
-	led->led_dev.default_trigger = trigger;
-
-	led->priv = priv;
-	led->type = type;
-
-	ret = led_classdev_register(device, &led->led_dev);
-	if (ret) {
-		IWL_ERR(priv, "Error: failed to register led handler.\n");
-		return ret;
-	}
-
-	led->registered = 1;
-
-	if (set_led && led->led_on)
-		led->led_on(priv, IWL_LED_LINK);
+	priv->allow_blinking = 0;
 
 	return 0;
 }
 
-
 /*
  * calculate blink rate according to last second Tx/Rx activities
  */
@@ -324,7 +167,7 @@ static int iwl_get_blink_rate(struct iwl_priv *priv)
 		i = IWL_MAX_BLINK_TBL;
 	else
 		for (i = 0; i < IWL_MAX_BLINK_TBL; i++)
-			if (tpt  > (blink_tbl[i].tpt * IWL_1MB_RATE))
+			if (tpt > (blink_tbl[i].tpt * IWL_1MB_RATE))
 				break;
 
 	IWL_DEBUG_LED(priv, "LED BLINK IDX=%d\n", i);
@@ -353,8 +196,7 @@ void iwl_leds_background(struct iwl_priv *priv)
 		priv->last_blink_time = 0;
 		if (priv->last_blink_rate != IWL_SOLID_BLINK_IDX) {
 			priv->last_blink_rate = IWL_SOLID_BLINK_IDX;
-			iwl_led_pattern(priv, IWL_LED_LINK,
-					    IWL_SOLID_BLINK_IDX);
+			iwl_led_pattern(priv, IWL_SOLID_BLINK_IDX);
 		}
 		return;
 	}
@@ -367,111 +209,18 @@ void iwl_leds_background(struct iwl_priv *priv)
 
 	/* call only if blink rate change */
 	if (blink_idx != priv->last_blink_rate)
-		iwl_led_pattern(priv, IWL_LED_LINK, blink_idx);
+		iwl_led_pattern(priv, blink_idx);
 
 	priv->last_blink_time = jiffies;
 	priv->last_blink_rate = blink_idx;
 }
+EXPORT_SYMBOL(iwl_leds_background);
 
-/* Register all led handler */
-int iwl_leds_register(struct iwl_priv *priv)
+void iwl_leds_init(struct iwl_priv *priv)
 {
-	char *trigger;
-	int ret;
-
 	priv->last_blink_rate = 0;
 	priv->led_tpt = 0;
 	priv->last_blink_time = 0;
 	priv->allow_blinking = 0;
-
-	trigger = ieee80211_get_radio_led_name(priv->hw);
-	snprintf(priv->led[IWL_LED_TRG_RADIO].name,
-		 sizeof(priv->led[IWL_LED_TRG_RADIO].name), "iwl-%s::radio",
-		 wiphy_name(priv->hw->wiphy));
-
-	priv->led[IWL_LED_TRG_RADIO].led_on = iwl_led_on_reg;
-	priv->led[IWL_LED_TRG_RADIO].led_off = iwl_led_off_reg;
-	priv->led[IWL_LED_TRG_RADIO].led_pattern = NULL;
-
-	ret = iwl_leds_register_led(priv, &priv->led[IWL_LED_TRG_RADIO],
-				   IWL_LED_TRG_RADIO, 1, trigger);
-	if (ret)
-		goto exit_fail;
-
-	trigger = ieee80211_get_assoc_led_name(priv->hw);
-	snprintf(priv->led[IWL_LED_TRG_ASSOC].name,
-		 sizeof(priv->led[IWL_LED_TRG_ASSOC].name), "iwl-%s::assoc",
-		 wiphy_name(priv->hw->wiphy));
-
-	ret = iwl_leds_register_led(priv, &priv->led[IWL_LED_TRG_ASSOC],
-				   IWL_LED_TRG_ASSOC, 0, trigger);
-
-	/* for assoc always turn led on */
-	priv->led[IWL_LED_TRG_ASSOC].led_on = iwl_led_associate;
-	priv->led[IWL_LED_TRG_ASSOC].led_off = iwl_led_disassociate;
-	priv->led[IWL_LED_TRG_ASSOC].led_pattern = NULL;
-
-	if (ret)
-		goto exit_fail;
-
-	trigger = ieee80211_get_rx_led_name(priv->hw);
-	snprintf(priv->led[IWL_LED_TRG_RX].name,
-		 sizeof(priv->led[IWL_LED_TRG_RX].name), "iwl-%s::RX",
-		 wiphy_name(priv->hw->wiphy));
-
-	ret = iwl_leds_register_led(priv, &priv->led[IWL_LED_TRG_RX],
-				   IWL_LED_TRG_RX, 0, trigger);
-
-	priv->led[IWL_LED_TRG_RX].led_on = iwl_led_associated;
-	priv->led[IWL_LED_TRG_RX].led_off = iwl_led_associated;
-	priv->led[IWL_LED_TRG_RX].led_pattern = iwl_led_pattern;
-
-	if (ret)
-		goto exit_fail;
-
-	trigger = ieee80211_get_tx_led_name(priv->hw);
-	snprintf(priv->led[IWL_LED_TRG_TX].name,
-		 sizeof(priv->led[IWL_LED_TRG_TX].name), "iwl-%s::TX",
-		 wiphy_name(priv->hw->wiphy));
-
-	ret = iwl_leds_register_led(priv, &priv->led[IWL_LED_TRG_TX],
-				   IWL_LED_TRG_TX, 0, trigger);
-
-	priv->led[IWL_LED_TRG_TX].led_on = iwl_led_associated;
-	priv->led[IWL_LED_TRG_TX].led_off = iwl_led_associated;
-	priv->led[IWL_LED_TRG_TX].led_pattern = iwl_led_pattern;
-
-	if (ret)
-		goto exit_fail;
-
-	return 0;
-
-exit_fail:
-	iwl_leds_unregister(priv);
-	return ret;
 }
-EXPORT_SYMBOL(iwl_leds_register);
-
-/* unregister led class */
-static void iwl_leds_unregister_led(struct iwl_led *led, u8 set_led)
-{
-	if (!led->registered)
-		return;
-
-	led_classdev_unregister(&led->led_dev);
-
-	if (set_led)
-		led->led_dev.brightness_set(&led->led_dev, LED_OFF);
-	led->registered = 0;
-}
-
-/* Unregister all led handlers */
-void iwl_leds_unregister(struct iwl_priv *priv)
-{
-	iwl_leds_unregister_led(&priv->led[IWL_LED_TRG_ASSOC], 0);
-	iwl_leds_unregister_led(&priv->led[IWL_LED_TRG_RX], 0);
-	iwl_leds_unregister_led(&priv->led[IWL_LED_TRG_TX], 0);
-	iwl_leds_unregister_led(&priv->led[IWL_LED_TRG_RADIO], 1);
-}
-EXPORT_SYMBOL(iwl_leds_unregister);
-
+EXPORT_SYMBOL(iwl_leds_init);
diff --git a/drivers/net/wireless/iwlwifi/iwl-led.h b/drivers/net/wireless/iwlwifi/iwl-led.h
index dd76b26..f47f053 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.h
+++ b/drivers/net/wireless/iwlwifi/iwl-led.h
@@ -30,9 +30,6 @@
 
 struct iwl_priv;
 
-#ifdef CONFIG_IWLWIFI_LEDS
-#include <linux/leds.h>
-
 #define IWL_LED_SOLID 11
 #define IWL_LED_NAME_LEN 31
 #define IWL_DEF_LED_INTRVL cpu_to_le32(1000)
@@ -59,38 +56,11 @@ enum iwl_led_mode {
 	IWL_LED_BLINK,
 	IWL_LED_RF_STATE,
 };
-#endif
-
-#ifdef CONFIG_IWLWIFI_LEDS
-
-struct iwl_led {
-	struct iwl_priv *priv;
-	struct led_classdev led_dev;
-	char name[32];
-
-	int (*led_on) (struct iwl_priv *priv, int led_id);
-	int (*led_off) (struct iwl_priv *priv, int led_id);
-	int (*led_pattern) (struct iwl_priv *priv, int led_id, unsigned int idx);
 
-	enum led_type type;
-	unsigned int registered;
-};
-
-int iwl_leds_register(struct iwl_priv *priv);
-void iwl_leds_unregister(struct iwl_priv *priv);
+void iwl_leds_init(struct iwl_priv *priv);
 void iwl_leds_background(struct iwl_priv *priv);
+int iwl_led_start(struct iwl_priv *priv);
+int iwl_led_associate(struct iwl_priv *priv);
+int iwl_led_disassociate(struct iwl_priv *priv);
 
-#else
-static inline int iwl_leds_register(struct iwl_priv *priv)
-{
-	return 0;
-}
-static inline void iwl_leds_unregister(struct iwl_priv *priv)
-{
-}
-static inline void iwl_leds_background(struct iwl_priv *priv)
-{
-}
-
-#endif /* CONFIG_IWLWIFI_LEDS */
 #endif /* __iwl_leds_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index d0d1b7f..ecbe036 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -455,9 +455,6 @@ static void iwl3945_build_tx_cmd_basic(struct iwl_priv *priv,
 			tx->timeout.pm_frame_timeout = cpu_to_le16(2);
 	} else {
 		tx->timeout.pm_frame_timeout = 0;
-#ifdef CONFIG_IWLWIFI_LEDS
-		priv->rxtxpackets += le16_to_cpu(cmd->cmd.tx.len);
-#endif
 	}
 
 	tx->driver_txop = 0;
@@ -2483,7 +2480,7 @@ static void iwl3945_alive_start(struct iwl_priv *priv)
 
 	iwl3945_reg_txpower_periodic(priv);
 
-	iwl3945_led_register(priv);
+	iwl_leds_init(priv);
 
 	IWL_DEBUG_INFO(priv, "ALIVE processing complete.\n");
 	set_bit(STATUS_READY, &priv->status);
@@ -2521,7 +2518,6 @@ static void __iwl3945_down(struct iwl_priv *priv)
 	if (!exit_pending)
 		set_bit(STATUS_EXIT_PENDING, &priv->status);
 
-	iwl3945_led_unregister(priv);
 	iwl_clear_stations_table(priv);
 
 	/* Unblock any waiting calls */
@@ -3156,6 +3152,8 @@ static int iwl3945_mac_start(struct ieee80211_hw *hw)
 	 * no need to poll the killswitch state anymore */
 	cancel_delayed_work(&priv->rfkill_poll);
 
+	iwl_led_start(priv);
+
 	priv->is_open = 1;
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 	return 0;
-- 
1.5.6.3

