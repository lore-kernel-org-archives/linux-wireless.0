Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:20116 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755030Ab2CDUnD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 15:43:03 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 031/101] iwlwifi: move iwl_base_params to shared header
Date: Sun,  4 Mar 2012 11:28:45 -0800
Message-Id: <1330889395-533-32-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120304_214626_469360_734334CA)
In-Reply-To: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This is used from there, so should be in it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.h   |   42 ----------------------------
 drivers/net/wireless/iwlwifi/iwl-shared.h |   43 +++++++++++++++++++++++++++++
 2 files changed, 43 insertions(+), 42 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index db44115..7259cbf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -96,48 +96,6 @@ struct iwl_lib_ops {
 };
 
 /*
- * @max_ll_items: max number of OTP blocks
- * @shadow_ram_support: shadow support for OTP memory
- * @led_compensation: compensate on the led on/off time per HW according
- *	to the deviation to achieve the desired led frequency.
- *	The detail algorithm is described in iwl-led.c
- * @chain_noise_num_beacons: number of beacons used to compute chain noise
- * @adv_thermal_throttle: support advance thermal throttle
- * @support_ct_kill_exit: support ct kill exit condition
- * @support_wimax_coexist: support wimax/wifi co-exist
- * @plcp_delta_threshold: plcp error rate threshold used to trigger
- *	radio tuning when there is a high receiving plcp error rate
- * @chain_noise_scale: default chain noise scale used for gain computation
- * @wd_timeout: TX queues watchdog timeout
- * @max_event_log_size: size of event log buffer size for ucode event logging
- * @shadow_reg_enable: HW shadhow register bit
- * @no_idle_support: do not support idle mode
- * @hd_v2: v2 of enhanced sensitivity value, used for 2000 series and up
- * wd_disable: disable watchdog timer
- */
-struct iwl_base_params {
-	int eeprom_size;
-	int num_of_queues;	/* def: HW dependent */
-	int num_of_ampdu_queues;/* def: HW dependent */
-	/* for iwl_apm_init() */
-	u32 pll_cfg_val;
-
-	const u16 max_ll_items;
-	const bool shadow_ram_support;
-	u16 led_compensation;
-	bool adv_thermal_throttle;
-	bool support_ct_kill_exit;
-	const bool support_wimax_coexist;
-	u8 plcp_delta_threshold;
-	s32 chain_noise_scale;
-	unsigned int wd_timeout;
-	u32 max_event_log_size;
-	const bool shadow_reg_enable;
-	const bool no_idle_support;
-	const bool hd_v2;
-	const bool wd_disable;
-};
-/*
  * @advanced_bt_coexist: support advanced bt coexist
  * @bt_init_traffic_load: specify initial bt traffic load
  * @bt_prio_boost: default bt priority boost value
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index b816e70..ef80e03 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -267,6 +267,49 @@ enum iwl_led_mode {
 	IWL_LED_DISABLE,
 };
 
+/*
+ * @max_ll_items: max number of OTP blocks
+ * @shadow_ram_support: shadow support for OTP memory
+ * @led_compensation: compensate on the led on/off time per HW according
+ *	to the deviation to achieve the desired led frequency.
+ *	The detail algorithm is described in iwl-led.c
+ * @chain_noise_num_beacons: number of beacons used to compute chain noise
+ * @adv_thermal_throttle: support advance thermal throttle
+ * @support_ct_kill_exit: support ct kill exit condition
+ * @support_wimax_coexist: support wimax/wifi co-exist
+ * @plcp_delta_threshold: plcp error rate threshold used to trigger
+ *	radio tuning when there is a high receiving plcp error rate
+ * @chain_noise_scale: default chain noise scale used for gain computation
+ * @wd_timeout: TX queues watchdog timeout
+ * @max_event_log_size: size of event log buffer size for ucode event logging
+ * @shadow_reg_enable: HW shadhow register bit
+ * @hd_v2: v2 of enhanced sensitivity value, used for 2000 series and up
+ * @no_idle_support: do not support idle mode
+ * wd_disable: disable watchdog timer
+ */
+struct iwl_base_params {
+	int eeprom_size;
+	int num_of_queues;	/* def: HW dependent */
+	int num_of_ampdu_queues;/* def: HW dependent */
+	/* for iwl_apm_init() */
+	u32 pll_cfg_val;
+
+	const u16 max_ll_items;
+	const bool shadow_ram_support;
+	u16 led_compensation;
+	bool adv_thermal_throttle;
+	bool support_ct_kill_exit;
+	const bool support_wimax_coexist;
+	u8 plcp_delta_threshold;
+	s32 chain_noise_scale;
+	unsigned int wd_timeout;
+	u32 max_event_log_size;
+	const bool shadow_reg_enable;
+	const bool hd_v2;
+	const bool no_idle_support;
+	const bool wd_disable;
+};
+
 /**
  * struct iwl_cfg
  * @name: Offical name of the device
-- 
1.7.0.4

