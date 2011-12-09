Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:23204 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753971Ab1LIBZB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 20:25:01 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 06/15] iwlwifi: rename CONFIG_IWLWIFI_DEVICE_SVTOOL to CONFIG_IWLWIFI_DEVICE_TESTMODE
Date: Thu,  8 Dec 2011 16:26:13 -0800
Message-Id: <1323390382-1678-7-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111209_022529_980540_F355FDE5)
In-Reply-To: <1323390382-1678-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1323390382-1678-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Change the name to match the works

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/Kconfig      |   10 +++++-----
 drivers/net/wireless/iwlwifi/Makefile     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |    6 +++---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c    |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-agn.h    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h    |    4 ++--
 7 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index 855b135..82c8cca 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -102,12 +102,12 @@ config IWLWIFI_DEVICE_TRACING
 	  occur.
 endmenu
 
-config IWLWIFI_DEVICE_SVTOOL
+config IWLWIFI_DEVICE_TESTMODE
 	def_bool y
 	depends on IWLWIFI
 	depends on NL80211_TESTMODE
 	help
-	  This option enables the svtool support for iwlwifi device through
-	  NL80211_TESTMODE. svtool is a software validation tool that runs in
-	  the user space and interacts with the device in the kernel space
-	  through the generic netlink message via NL80211_TESTMODE channel.
+	  This option enables the testmode support for iwlwifi device through
+	  NL80211_TESTMODE. This provide the capabilities of enable user space
+	  validation applications to interacts with the device through the
+	  generic netlink message via NL80211_TESTMODE channel.
diff --git a/drivers/net/wireless/iwlwifi/Makefile b/drivers/net/wireless/iwlwifi/Makefile
index 86344ce..9dc84a7 100644
--- a/drivers/net/wireless/iwlwifi/Makefile
+++ b/drivers/net/wireless/iwlwifi/Makefile
@@ -18,7 +18,7 @@ iwlwifi-objs		+= iwl-trans-pcie.o iwl-trans-pcie-rx.o iwl-trans-pcie-tx.o
 
 iwlwifi-$(CONFIG_IWLWIFI_DEBUGFS) += iwl-debugfs.o
 iwlwifi-$(CONFIG_IWLWIFI_DEVICE_TRACING) += iwl-devtrace.o
-iwlwifi-$(CONFIG_IWLWIFI_DEVICE_SVTOOL) += iwl-testmode.o
+iwlwifi-$(CONFIG_IWLWIFI_DEVICE_TESTMODE) += iwl-testmode.o
 
 CFLAGS_iwl-devtrace.o := -I$(src)
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 359c47a..78efa2b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -352,7 +352,7 @@ static void rs_program_fix_rate(struct iwl_priv *priv,
 	lq_sta->active_mimo2_rate  = 0x1FD0;	/* 6 - 60 MBits, no 9, no CCK */
 	lq_sta->active_mimo3_rate  = 0x1FD0;	/* 6 - 60 MBits, no 9, no CCK */
 
-#ifdef CONFIG_IWLWIFI_DEVICE_SVTOOL
+#ifdef CONFIG_IWLWIFI_DEVICE_TESTMODE
 	/* testmode has higher priority to overwirte the fixed rate */
 	if (priv->tm_fixed_rate)
 		lq_sta->dbg_fixed_rate = priv->tm_fixed_rate;
@@ -1081,7 +1081,7 @@ done:
 	if (sta && sta->supp_rates[sband->band])
 		rs_rate_scale_perform(priv, skb, sta, lq_sta);
 
-#if defined(CONFIG_MAC80211_DEBUGFS) && defined(CONFIG_IWLWIFI_DEVICE_SVTOOL)
+#if defined(CONFIG_MAC80211_DEBUGFS) && defined(CONFIG_IWLWIFI_DEVICE_TESTMODE)
 	if ((priv->tm_fixed_rate) &&
 	    (priv->tm_fixed_rate != lq_sta->dbg_fixed_rate))
 		rs_program_fix_rate(priv, lq_sta);
@@ -2904,7 +2904,7 @@ void iwl_rs_rate_init(struct iwl_priv *priv, struct ieee80211_sta *sta, u8 sta_i
 	if (sband->band == IEEE80211_BAND_5GHZ)
 		lq_sta->last_txrate_idx += IWL_FIRST_OFDM_RATE;
 	lq_sta->is_agg = 0;
-#ifdef CONFIG_IWLWIFI_DEVICE_SVTOOL
+#ifdef CONFIG_IWLWIFI_DEVICE_TESTMODE
 	priv->tm_fixed_rate = 0;
 #endif
 #ifdef CONFIG_MAC80211_DEBUGFS
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index a1a95d5..cdf9efd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -148,7 +148,7 @@ static void iwlagn_tx_cmd_build_rate(struct iwl_priv *priv,
 	if (ieee80211_is_data(fc)) {
 		tx_cmd->initial_rate_index = 0;
 		tx_cmd->tx_flags |= TX_CMD_FLG_STA_RATE_MSK;
-#ifdef CONFIG_IWLWIFI_DEVICE_SVTOOL
+#ifdef CONFIG_IWLWIFI_DEVICE_TESTMODE
 		if (priv->tm_fixed_rate) {
 			/*
 			 * rate overwrite by testmode
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index daf010d..5021cc9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1703,8 +1703,8 @@ static void iwl_debug_config(struct iwl_priv *priv)
 		"disabled\n");
 #endif
 
-	dev_printk(KERN_INFO, bus(priv)->dev, "CONFIG_IWLWIFI_DEVICE_SVTOOL "
-#ifdef CONFIG_IWLWIFI_DEVICE_SVTOOL
+	dev_printk(KERN_INFO, bus(priv)->dev, "CONFIG_IWLWIFI_DEVICE_TESTMODE "
+#ifdef CONFIG_IWLWIFI_DEVICE_TESTMODE
 		"enabled\n");
 #else
 		"disabled\n");
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index f2f1070..b891bd9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -359,7 +359,7 @@ void iwl_eeprom_get_mac(const struct iwl_priv *priv, u8 *mac);
 extern int iwlagn_init_alive_start(struct iwl_priv *priv);
 extern int iwl_alive_start(struct iwl_priv *priv);
 /* svtool */
-#ifdef CONFIG_IWLWIFI_DEVICE_SVTOOL
+#ifdef CONFIG_IWLWIFI_DEVICE_TESTMODE
 extern int iwlagn_mac_testmode_cmd(struct ieee80211_hw *hw, void *data,
 				   int len);
 extern int iwlagn_mac_testmode_dump(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index be26145..d7b64af 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -750,7 +750,7 @@ enum iwl_scan_type {
 	IWL_SCAN_ROC,
 };
 
-#ifdef CONFIG_IWLWIFI_DEVICE_SVTOOL
+#ifdef CONFIG_IWLWIFI_DEVICE_TESTMODE
 struct iwl_testmode_trace {
 	u32 buff_size;
 	u32 total_size;
@@ -1039,7 +1039,7 @@ struct iwl_priv {
 	struct led_classdev led;
 	unsigned long blink_on, blink_off;
 	bool led_registered;
-#ifdef CONFIG_IWLWIFI_DEVICE_SVTOOL
+#ifdef CONFIG_IWLWIFI_DEVICE_TESTMODE
 	struct iwl_testmode_trace testmode_trace;
 	struct iwl_testmode_sram testmode_sram;
 	u32 tm_fixed_rate;
-- 
1.7.0.4

