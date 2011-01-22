Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:47747 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754789Ab1AVASV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Jan 2011 19:18:21 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 01/14] iwlwifi: use mac80211 throughput trigger
Date: Fri, 21 Jan 2011 16:06:36 -0800
Message-Id: <1295654809-5790-2-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1295654809-5790-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1295654809-5790-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of keeping track of LED blink speed
in the driver, use the new mac80211 trigger
and link it up with an LED classdev that we
now register. This also allows users more
flexibility in how they want to have the LED
blink or not.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/Kconfig        |    4 +
 drivers/net/wireless/iwlwifi/iwl-3945-led.c |   27 ----
 drivers/net/wireless/iwlwifi/iwl-agn-led.c  |   14 +--
 drivers/net/wireless/iwlwifi/iwl-agn-led.h  |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |    2 -
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   10 +-
 drivers/net/wireless/iwlwifi/iwl-core.c     |    2 -
 drivers/net/wireless/iwlwifi/iwl-core.h     |   14 --
 drivers/net/wireless/iwlwifi/iwl-debugfs.c  |   25 ----
 drivers/net/wireless/iwlwifi/iwl-dev.h      |   18 +--
 drivers/net/wireless/iwlwifi/iwl-led.c      |  201 +++++++++++----------------
 drivers/net/wireless/iwlwifi/iwl-led.h      |   16 +--
 drivers/net/wireless/iwlwifi/iwl-legacy.c   |    4 -
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    8 +-
 14 files changed, 106 insertions(+), 240 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index ed42457..8994d30 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -2,6 +2,10 @@ config IWLWIFI
 	tristate "Intel Wireless Wifi"
 	depends on PCI && MAC80211
 	select FW_LOADER
+	select NEW_LEDS
+	select LEDS_CLASS
+	select LEDS_TRIGGERS
+	select MAC80211_LEDS
 
 menu "Debugging Options"
 	depends on IWLWIFI
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-led.c b/drivers/net/wireless/iwlwifi/iwl-3945-led.c
index abe2b73..dc7c3a4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-led.c
@@ -59,33 +59,6 @@ static int iwl3945_send_led_cmd(struct iwl_priv *priv,
 	return iwl_send_cmd(priv, &cmd);
 }
 
-/* Set led on command */
-static int iwl3945_led_on(struct iwl_priv *priv)
-{
-	struct iwl_led_cmd led_cmd = {
-		.id = IWL_LED_LINK,
-		.on = IWL_LED_SOLID,
-		.off = 0,
-		.interval = IWL_DEF_LED_INTRVL
-	};
-	return iwl3945_send_led_cmd(priv, &led_cmd);
-}
-
-/* Set led off command */
-static int iwl3945_led_off(struct iwl_priv *priv)
-{
-	struct iwl_led_cmd led_cmd = {
-		.id = IWL_LED_LINK,
-		.on = 0,
-		.off = 0,
-		.interval = IWL_DEF_LED_INTRVL
-	};
-	IWL_DEBUG_LED(priv, "led off\n");
-	return iwl3945_send_led_cmd(priv, &led_cmd);
-}
-
 const struct iwl_led_ops iwl3945_led_ops = {
 	.cmd = iwl3945_send_led_cmd,
-	.on = iwl3945_led_on,
-	.off = iwl3945_led_off,
 };
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-led.c b/drivers/net/wireless/iwlwifi/iwl-agn-led.c
index 1a24946..c1190d9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-led.c
@@ -63,23 +63,11 @@ static int iwl_send_led_cmd(struct iwl_priv *priv, struct iwl_led_cmd *led_cmd)
 }
 
 /* Set led register off */
-static int iwl_led_on_reg(struct iwl_priv *priv)
+void iwlagn_led_enable(struct iwl_priv *priv)
 {
-	IWL_DEBUG_LED(priv, "led on\n");
 	iwl_write32(priv, CSR_LED_REG, CSR_LED_REG_TRUN_ON);
-	return 0;
-}
-
-/* Set led register off */
-static int iwl_led_off_reg(struct iwl_priv *priv)
-{
-	IWL_DEBUG_LED(priv, "LED Reg off\n");
-	iwl_write32(priv, CSR_LED_REG, CSR_LED_REG_TRUN_OFF);
-	return 0;
 }
 
 const struct iwl_led_ops iwlagn_led_ops = {
 	.cmd = iwl_send_led_cmd,
-	.on = iwl_led_on_reg,
-	.off = iwl_led_off_reg,
 };
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-led.h b/drivers/net/wireless/iwlwifi/iwl-agn-led.h
index a594e4f..96f323d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-led.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-led.h
@@ -28,5 +28,6 @@
 #define __iwl_agn_led_h__
 
 extern const struct iwl_led_ops iwlagn_led_ops;
+void iwlagn_led_enable(struct iwl_priv *priv);
 
 #endif /* __iwl_agn_led_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index 6e80f10..f693293 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -557,12 +557,10 @@ void iwlagn_bss_info_changed(struct ieee80211_hw *hw,
 
 	if (changes & BSS_CHANGED_ASSOC) {
 		if (bss_conf->assoc) {
-			iwl_led_associate(priv);
 			priv->timestamp = bss_conf->timestamp;
 			ctx->staging.filter_flags |= RXON_FILTER_ASSOC_MSK;
 		} else {
 			ctx->staging.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
-			iwl_led_disassociate(priv);
 		}
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 97657d0..9240abf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -59,6 +59,7 @@
 #include "iwl-sta.h"
 #include "iwl-agn-calib.h"
 #include "iwl-agn.h"
+#include "iwl-agn-led.h"
 
 
 /******************************************************************************
@@ -2741,8 +2742,6 @@ static void iwl_alive_start(struct iwl_priv *priv)
 	/* At this point, the NIC is initialized and operational */
 	iwl_rf_kill_ct_config(priv);
 
-	iwl_leds_init(priv);
-
 	IWL_DEBUG_INFO(priv, "ALIVE processing complete.\n");
 	wake_up_interruptible(&priv->wait_command_queue);
 
@@ -3234,6 +3233,8 @@ static int iwl_mac_setup_register(struct iwl_priv *priv,
 		priv->hw->wiphy->bands[IEEE80211_BAND_5GHZ] =
 			&priv->bands[IEEE80211_BAND_5GHZ];
 
+	iwl_leds_init(priv);
+
 	ret = ieee80211_register_hw(priv->hw);
 	if (ret) {
 		IWL_ERR(priv, "Failed to register hw (error %d)\n", ret);
@@ -3278,7 +3279,7 @@ int iwlagn_mac_start(struct ieee80211_hw *hw)
 		}
 	}
 
-	iwl_led_start(priv);
+	iwlagn_led_enable(priv);
 
 out:
 	priv->is_open = 1;
@@ -4288,6 +4289,9 @@ static void __devexit iwl_pci_remove(struct pci_dev *pdev)
 	 * we need to set STATUS_EXIT_PENDING bit.
 	 */
 	set_bit(STATUS_EXIT_PENDING, &priv->status);
+
+	iwl_leds_exit(priv);
+
 	if (priv->mac80211_registered) {
 		ieee80211_unregister_hw(priv->hw);
 		priv->mac80211_registered = 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index a8d4a93..8e1b801 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1676,7 +1676,6 @@ void iwl_clear_traffic_stats(struct iwl_priv *priv)
 {
 	memset(&priv->tx_stats, 0, sizeof(struct traffic_stats));
 	memset(&priv->rx_stats, 0, sizeof(struct traffic_stats));
-	priv->led_tpt = 0;
 }
 
 /*
@@ -1769,7 +1768,6 @@ void iwl_update_stats(struct iwl_priv *priv, bool is_tx, __le16 fc, u16 len)
 		stats->data_cnt++;
 		stats->data_bytes += len;
 	}
-	iwl_leds_background(priv);
 }
 EXPORT_SYMBOL(iwl_update_stats);
 #endif
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index a347437..bbc5aa7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -227,8 +227,6 @@ struct iwl_lib_ops {
 
 struct iwl_led_ops {
 	int (*cmd)(struct iwl_priv *priv, struct iwl_led_cmd *led_cmd);
-	int (*on)(struct iwl_priv *priv);
-	int (*off)(struct iwl_priv *priv);
 };
 
 /* NIC specific ops */
@@ -494,18 +492,6 @@ static inline void iwl_dbg_log_rx_data_frame(struct iwl_priv *priv,
 static inline void iwl_update_stats(struct iwl_priv *priv, bool is_tx,
 				    __le16 fc, u16 len)
 {
-	struct traffic_stats	*stats;
-
-	if (is_tx)
-		stats = &priv->tx_stats;
-	else
-		stats = &priv->rx_stats;
-
-	if (ieee80211_is_data(fc)) {
-		/* data */
-		stats->data_bytes += len;
-	}
-	iwl_leds_background(priv);
 }
 #endif
 /*****************************************************
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 6fe80b5..7f11a44 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -668,29 +668,6 @@ static ssize_t iwl_dbgfs_qos_read(struct file *file, char __user *user_buf,
 	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 }
 
-static ssize_t iwl_dbgfs_led_read(struct file *file, char __user *user_buf,
-				  size_t count, loff_t *ppos)
-{
-	struct iwl_priv *priv = file->private_data;
-	int pos = 0;
-	char buf[256];
-	const size_t bufsz = sizeof(buf);
-
-	pos += scnprintf(buf + pos, bufsz - pos,
-			 "allow blinking: %s\n",
-			 (priv->allow_blinking) ? "True" : "False");
-	if (priv->allow_blinking) {
-		pos += scnprintf(buf + pos, bufsz - pos,
-				 "Led blinking rate: %u\n",
-				 priv->last_blink_rate);
-		pos += scnprintf(buf + pos, bufsz - pos,
-				 "Last blink time: %lu\n",
-				 priv->last_blink_time);
-	}
-
-	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
-}
-
 static ssize_t iwl_dbgfs_thermal_throttling_read(struct file *file,
 				char __user *user_buf,
 				size_t count, loff_t *ppos)
@@ -856,7 +833,6 @@ DEBUGFS_READ_FILE_OPS(channels);
 DEBUGFS_READ_FILE_OPS(status);
 DEBUGFS_READ_WRITE_FILE_OPS(interrupt);
 DEBUGFS_READ_FILE_OPS(qos);
-DEBUGFS_READ_FILE_OPS(led);
 DEBUGFS_READ_FILE_OPS(thermal_throttling);
 DEBUGFS_READ_WRITE_FILE_OPS(disable_ht40);
 DEBUGFS_READ_WRITE_FILE_OPS(sleep_level_override);
@@ -1725,7 +1701,6 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 	DEBUGFS_ADD_FILE(status, dir_data, S_IRUSR);
 	DEBUGFS_ADD_FILE(interrupt, dir_data, S_IWUSR | S_IRUSR);
 	DEBUGFS_ADD_FILE(qos, dir_data, S_IRUSR);
-	DEBUGFS_ADD_FILE(led, dir_data, S_IRUSR);
 	if (!priv->cfg->base_params->broken_powersave) {
 		DEBUGFS_ADD_FILE(sleep_level_override, dir_data,
 				 S_IWUSR | S_IRUSR);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 2ec680b..6dd6508 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -35,6 +35,7 @@
 #include <linux/pci.h> /* for struct pci_device_id */
 #include <linux/kernel.h>
 #include <linux/wait.h>
+#include <linux/leds.h>
 #include <net/ieee80211_radiotap.h>
 
 #include "iwl-eeprom.h"
@@ -996,7 +997,6 @@ struct reply_agg_tx_error_statistics {
 	u32 unknown;
 };
 
-#ifdef CONFIG_IWLWIFI_DEBUGFS
 /* management statistics */
 enum iwl_mgmt_stats {
 	MANAGEMENT_ASSOC_REQ = 0,
@@ -1027,16 +1027,13 @@ enum iwl_ctrl_stats {
 };
 
 struct traffic_stats {
+#ifdef CONFIG_IWLWIFI_DEBUGFS
 	u32 mgmt[MANAGEMENT_MAX];
 	u32 ctrl[CONTROL_MAX];
 	u32 data_cnt;
 	u64 data_bytes;
-};
-#else
-struct traffic_stats {
-	u64 data_bytes;
-};
 #endif
+};
 
 /*
  * iwl_switch_rxon: "channel switch" structure
@@ -1338,11 +1335,6 @@ struct iwl_priv {
 	struct iwl_init_alive_resp card_alive_init;
 	struct iwl_alive_resp card_alive;
 
-	unsigned long last_blink_time;
-	u8 last_blink_rate;
-	u8 allow_blinking;
-	u64 led_tpt;
-
 	u16 active_rate;
 
 	u8 start_calib;
@@ -1580,6 +1572,10 @@ struct iwl_priv {
 	bool hw_ready;
 
 	struct iwl_event_log event_log;
+
+	struct led_classdev led;
+	unsigned long blink_on, blink_off;
+	bool led_registered;
 }; /*iwl_priv */
 
 static inline void iwl_txq_ctx_activate(struct iwl_priv *priv, int txq_id)
diff --git a/drivers/net/wireless/iwlwifi/iwl-led.c b/drivers/net/wireless/iwlwifi/iwl-led.c
index 46ccdf4..074ad22 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-led.c
@@ -48,31 +48,19 @@ module_param(led_mode, int, S_IRUGO);
 MODULE_PARM_DESC(led_mode, "0=system default, "
 		"1=On(RF On)/Off(RF Off), 2=blinking");
 
-static const struct {
-	u16 tpt;	/* Mb/s */
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
-	{10, 95, 95},
-	{5, 110, 110},
-	{1, 130, 130},
-	{0, 167, 167},
-	/* SOLID_ON */
-	{-1, IWL_LED_SOLID, 0}
+static const struct ieee80211_tpt_blink iwl_blink[] = {
+	{ .throughput = 0 * 1024 - 1, .blink_time = 334 },
+	{ .throughput = 1 * 1024 - 1, .blink_time = 260 },
+	{ .throughput = 5 * 1024 - 1, .blink_time = 220 },
+	{ .throughput = 10 * 1024 - 1, .blink_time = 190 },
+	{ .throughput = 20 * 1024 - 1, .blink_time = 170 },
+	{ .throughput = 50 * 1024 - 1, .blink_time = 150 },
+	{ .throughput = 70 * 1024 - 1, .blink_time = 130 },
+	{ .throughput = 100 * 1024 - 1, .blink_time = 110 },
+	{ .throughput = 200 * 1024 - 1, .blink_time = 80 },
+	{ .throughput = 300 * 1024 - 1, .blink_time = 50 },
 };
 
-#define IWL_1MB_RATE (128 * 1024)
-#define IWL_LED_THRESHOLD (16)
-#define IWL_MAX_BLINK_TBL (ARRAY_SIZE(blink_tbl) - 1) /* exclude SOLID_ON */
-#define IWL_SOLID_BLINK_IDX (ARRAY_SIZE(blink_tbl) - 1)
-
 /*
  * Adjust led blink rate to compensate on a MAC Clock difference on every HW
  * Led blink rate analysis showed an average deviation of 0% on 3945,
@@ -97,133 +85,104 @@ static inline u8 iwl_blink_compensation(struct iwl_priv *priv,
 }
 
 /* Set led pattern command */
-static int iwl_led_pattern(struct iwl_priv *priv, unsigned int idx)
+static int iwl_led_cmd(struct iwl_priv *priv,
+		       unsigned long on,
+		       unsigned long off)
 {
 	struct iwl_led_cmd led_cmd = {
 		.id = IWL_LED_LINK,
 		.interval = IWL_DEF_LED_INTRVL
 	};
+	int ret;
 
-	BUG_ON(idx > IWL_MAX_BLINK_TBL);
+	if (!test_bit(STATUS_READY, &priv->status))
+		return -EBUSY;
 
-	IWL_DEBUG_LED(priv, "Led blink time compensation= %u\n",
+	if (priv->blink_on == on && priv->blink_off == off)
+		return 0;
+
+	IWL_DEBUG_LED(priv, "Led blink time compensation=%u\n",
 			priv->cfg->base_params->led_compensation);
-	led_cmd.on =
-		iwl_blink_compensation(priv, blink_tbl[idx].on_time,
+	led_cmd.on = iwl_blink_compensation(priv, on,
 				priv->cfg->base_params->led_compensation);
-	led_cmd.off =
-		iwl_blink_compensation(priv, blink_tbl[idx].off_time,
+	led_cmd.off = iwl_blink_compensation(priv, off,
 				priv->cfg->base_params->led_compensation);
 
-	return priv->cfg->ops->led->cmd(priv, &led_cmd);
+	ret = priv->cfg->ops->led->cmd(priv, &led_cmd);
+	if (!ret) {
+		priv->blink_on = on;
+		priv->blink_off = off;
+	}
+	return ret;
 }
 
-int iwl_led_start(struct iwl_priv *priv)
+static void iwl_led_brightness_set(struct led_classdev *led_cdev,
+				   enum led_brightness brightness)
 {
-	return priv->cfg->ops->led->on(priv);
-}
-EXPORT_SYMBOL(iwl_led_start);
+	struct iwl_priv *priv = container_of(led_cdev, struct iwl_priv, led);
+	unsigned long on = 0;
 
-int iwl_led_associate(struct iwl_priv *priv)
-{
-	IWL_DEBUG_LED(priv, "Associated\n");
-	if (priv->cfg->led_mode == IWL_LED_BLINK)
-		priv->allow_blinking = 1;
-	priv->last_blink_time = jiffies;
+	if (brightness > 0)
+		on = IWL_LED_SOLID;
 
-	return 0;
+	iwl_led_cmd(priv, on, 0);
 }
-EXPORT_SYMBOL(iwl_led_associate);
 
-int iwl_led_disassociate(struct iwl_priv *priv)
+static int iwl_led_blink_set(struct led_classdev *led_cdev,
+			     unsigned long *delay_on,
+			     unsigned long *delay_off)
 {
-	priv->allow_blinking = 0;
+	struct iwl_priv *priv = container_of(led_cdev, struct iwl_priv, led);
 
-	return 0;
+	return iwl_led_cmd(priv, *delay_on, *delay_off);
 }
-EXPORT_SYMBOL(iwl_led_disassociate);
 
-/*
- * calculate blink rate according to last second Tx/Rx activities
- */
-static int iwl_get_blink_rate(struct iwl_priv *priv)
-{
-	int i;
-	/* count both tx and rx traffic to be able to
-	 * handle traffic in either direction
-	 */
-	u64 current_tpt = priv->tx_stats.data_bytes +
-			  priv->rx_stats.data_bytes;
-	s64 tpt = current_tpt - priv->led_tpt;
-
-	if (tpt < 0) /* wraparound */
-		tpt = -tpt;
-
-	IWL_DEBUG_LED(priv, "tpt %lld current_tpt %llu\n",
-		(long long)tpt,
-		(unsigned long long)current_tpt);
-	priv->led_tpt = current_tpt;
-
-	if (!priv->allow_blinking)
-		i = IWL_MAX_BLINK_TBL;
-	else
-		for (i = 0; i < IWL_MAX_BLINK_TBL; i++)
-			if (tpt > (blink_tbl[i].tpt * IWL_1MB_RATE))
-				break;
-
-	IWL_DEBUG_LED(priv, "LED BLINK IDX=%d\n", i);
-	return i;
-}
-
-/*
- * this function called from handler. Since setting Led command can
- * happen very frequent we postpone led command to be called from
- * REPLY handler so we know ucode is up
- */
-void iwl_leds_background(struct iwl_priv *priv)
+void iwl_leds_init(struct iwl_priv *priv)
 {
-	u8 blink_idx;
-
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status)) {
-		priv->last_blink_time = 0;
-		return;
-	}
-	if (iwl_is_rfkill(priv)) {
-		priv->last_blink_time = 0;
-		return;
+	int mode = led_mode;
+	int ret;
+
+	if (mode == IWL_LED_DEFAULT)
+		mode = priv->cfg->led_mode;
+
+	priv->led.name = kasprintf(GFP_KERNEL, "%s-led",
+				   wiphy_name(priv->hw->wiphy));
+	priv->led.brightness_set = iwl_led_brightness_set;
+	priv->led.blink_set = iwl_led_blink_set;
+	priv->led.max_brightness = 1;
+
+	switch (mode) {
+	case IWL_LED_DEFAULT:
+		WARN_ON(1);
+		break;
+	case IWL_LED_BLINK:
+		priv->led.default_trigger =
+			ieee80211_create_tpt_led_trigger(priv->hw,
+					IEEE80211_TPT_LEDTRIG_FL_CONNECTED,
+					iwl_blink, ARRAY_SIZE(iwl_blink));
+		break;
+	case IWL_LED_RF_STATE:
+		priv->led.default_trigger =
+			ieee80211_get_radio_led_name(priv->hw);
+		break;
 	}
 
-	if (!priv->allow_blinking) {
-		priv->last_blink_time = 0;
-		if (priv->last_blink_rate != IWL_SOLID_BLINK_IDX) {
-			priv->last_blink_rate = IWL_SOLID_BLINK_IDX;
-			iwl_led_pattern(priv, IWL_SOLID_BLINK_IDX);
-		}
+	ret = led_classdev_register(&priv->pci_dev->dev, &priv->led);
+	if (ret) {
+		kfree(priv->led.name);
 		return;
 	}
-	if (!priv->last_blink_time ||
-	    !time_after(jiffies, priv->last_blink_time +
-			msecs_to_jiffies(1000)))
-		return;
-
-	blink_idx = iwl_get_blink_rate(priv);
 
-	/* call only if blink rate change */
-	if (blink_idx != priv->last_blink_rate)
-		iwl_led_pattern(priv, blink_idx);
-
-	priv->last_blink_time = jiffies;
-	priv->last_blink_rate = blink_idx;
+	priv->led_registered = true;
 }
-EXPORT_SYMBOL(iwl_leds_background);
+EXPORT_SYMBOL(iwl_leds_init);
 
-void iwl_leds_init(struct iwl_priv *priv)
+void iwl_leds_exit(struct iwl_priv *priv)
 {
-	priv->last_blink_rate = 0;
-	priv->last_blink_time = 0;
-	priv->allow_blinking = 0;
-	if (led_mode != IWL_LED_DEFAULT &&
-	    led_mode != priv->cfg->led_mode)
-		priv->cfg->led_mode = led_mode;
+	if (!priv->led_registered)
+		return;
+
+	led_classdev_unregister(&priv->led);
+	kfree(priv->led.name);
 }
-EXPORT_SYMBOL(iwl_leds_init);
+EXPORT_SYMBOL(iwl_leds_exit);
diff --git a/drivers/net/wireless/iwlwifi/iwl-led.h b/drivers/net/wireless/iwlwifi/iwl-led.h
index 9079b33..101eef1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.h
+++ b/drivers/net/wireless/iwlwifi/iwl-led.h
@@ -31,23 +31,14 @@
 struct iwl_priv;
 
 #define IWL_LED_SOLID 11
-#define IWL_LED_NAME_LEN 31
 #define IWL_DEF_LED_INTRVL cpu_to_le32(1000)
 
 #define IWL_LED_ACTIVITY       (0<<1)
 #define IWL_LED_LINK           (1<<1)
 
-enum led_type {
-	IWL_LED_TRG_TX,
-	IWL_LED_TRG_RX,
-	IWL_LED_TRG_ASSOC,
-	IWL_LED_TRG_RADIO,
-	IWL_LED_TRG_MAX,
-};
-
 /*
  * LED mode
- *    IWL_LED_DEFAULT:  use system default
+ *    IWL_LED_DEFAULT:  use device default
  *    IWL_LED_RF_STATE: turn LED on/off based on RF state
  *			LED ON  = RF ON
  *			LED OFF = RF OFF
@@ -60,9 +51,6 @@ enum iwl_led_mode {
 };
 
 void iwl_leds_init(struct iwl_priv *priv);
-void iwl_leds_background(struct iwl_priv *priv);
-int iwl_led_start(struct iwl_priv *priv);
-int iwl_led_associate(struct iwl_priv *priv);
-int iwl_led_disassociate(struct iwl_priv *priv);
+void iwl_leds_exit(struct iwl_priv *priv);
 
 #endif /* __iwl_leds_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-legacy.c b/drivers/net/wireless/iwlwifi/iwl-legacy.c
index bb1a742..927fe37 100644
--- a/drivers/net/wireless/iwlwifi/iwl-legacy.c
+++ b/drivers/net/wireless/iwlwifi/iwl-legacy.c
@@ -332,7 +332,6 @@ static inline void iwl_set_no_assoc(struct iwl_priv *priv,
 {
 	struct iwl_rxon_context *ctx = iwl_rxon_ctx_from_vif(vif);
 
-	iwl_led_disassociate(priv);
 	/*
 	 * inform the ucode that there is no longer an
 	 * association and that no more packets should be
@@ -520,8 +519,6 @@ void iwl_legacy_mac_bss_info_changed(struct ieee80211_hw *hw,
 		if (bss_conf->assoc) {
 			priv->timestamp = bss_conf->timestamp;
 
-			iwl_led_associate(priv);
-
 			if (!iwl_is_rfkill(priv))
 				priv->cfg->ops->legacy->post_associate(priv);
 		} else
@@ -545,7 +542,6 @@ void iwl_legacy_mac_bss_info_changed(struct ieee80211_hw *hw,
 			memcpy(ctx->staging.bssid_addr,
 			       bss_conf->bssid, ETH_ALEN);
 			memcpy(priv->bssid, bss_conf->bssid, ETH_ALEN);
-			iwl_led_associate(priv);
 			priv->cfg->ops->legacy->config_ap(priv);
 		} else
 			iwl_set_no_assoc(priv, vif);
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 371abbf..9c986f2 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2540,8 +2540,6 @@ static void iwl3945_alive_start(struct iwl_priv *priv)
 
 	iwl3945_reg_txpower_periodic(priv);
 
-	iwl_leds_init(priv);
-
 	IWL_DEBUG_INFO(priv, "ALIVE processing complete.\n");
 	set_bit(STATUS_READY, &priv->status);
 	wake_up_interruptible(&priv->wait_command_queue);
@@ -3170,8 +3168,6 @@ static int iwl3945_mac_start(struct ieee80211_hw *hw)
 	 * no need to poll the killswitch state anymore */
 	cancel_delayed_work(&priv->_3945.rfkill_poll);
 
-	iwl_led_start(priv);
-
 	priv->is_open = 1;
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 	return 0;
@@ -3935,6 +3931,8 @@ static int iwl3945_setup_mac(struct iwl_priv *priv)
 		priv->hw->wiphy->bands[IEEE80211_BAND_5GHZ] =
 			&priv->bands[IEEE80211_BAND_5GHZ];
 
+	iwl_leds_init(priv);
+
 	ret = ieee80211_register_hw(priv->hw);
 	if (ret) {
 		IWL_ERR(priv, "Failed to register hw (error %d)\n", ret);
@@ -4194,6 +4192,8 @@ static void __devexit iwl3945_pci_remove(struct pci_dev *pdev)
 
 	set_bit(STATUS_EXIT_PENDING, &priv->status);
 
+	iwl_leds_exit(priv);
+
 	if (priv->mac80211_registered) {
 		ieee80211_unregister_hw(priv->hw);
 		priv->mac80211_registered = 0;
-- 
1.7.0.4

