Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:20496 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031493Ab2CFWnh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Mar 2012 17:43:37 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH RESEND 21/33] iwlwifi: constify remaining config data
Date: Tue,  6 Mar 2012 13:30:56 -0800
Message-Id: <1331069468-11074-22-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120306_234408_566706_E3936159)
In-Reply-To: <1331069468-11074-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1331069468-11074-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The HW configuration settings base_params, ht_params
and bt_params all should be const, make it so.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c   |    5 +++--
 drivers/net/wireless/iwlwifi/iwl-2000.c   |    8 ++++----
 drivers/net/wireless/iwlwifi/iwl-5000.c   |    5 +++--
 drivers/net/wireless/iwlwifi/iwl-6000.c   |   11 ++++++-----
 drivers/net/wireless/iwlwifi/iwl-shared.h |    6 +++---
 5 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index c3e30b0..900d430 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -155,7 +155,7 @@ static struct iwl_lib_ops iwl1000_lib = {
 	.temperature = iwlagn_temperature,
 };
 
-static struct iwl_base_params iwl1000_base_params = {
+static const struct iwl_base_params iwl1000_base_params = {
 	.num_of_queues = IWLAGN_NUM_QUEUES,
 	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
@@ -170,7 +170,8 @@ static struct iwl_base_params iwl1000_base_params = {
 	.max_event_log_size = 128,
 	.wd_disable = true,
 };
-static struct iwl_ht_params iwl1000_ht_params = {
+
+static const struct iwl_ht_params iwl1000_ht_params = {
 	.ht_greenfield_support = true,
 	.use_rts_for_aggregation = true, /* use rts/cts protection */
 	.smps_mode = IEEE80211_SMPS_DYNAMIC,
diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index 212f292..db6df69 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -173,7 +173,7 @@ static struct iwl_lib_ops iwl2030_lib = {
 	.temperature = iwlagn_temperature,
 };
 
-static struct iwl_base_params iwl2000_base_params = {
+static const struct iwl_base_params iwl2000_base_params = {
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
 	.num_of_queues = IWLAGN_NUM_QUEUES,
 	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
@@ -192,7 +192,7 @@ static struct iwl_base_params iwl2000_base_params = {
 };
 
 
-static struct iwl_base_params iwl2030_base_params = {
+static const struct iwl_base_params iwl2030_base_params = {
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
 	.num_of_queues = IWLAGN_NUM_QUEUES,
 	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
@@ -210,12 +210,12 @@ static struct iwl_base_params iwl2030_base_params = {
 	.hd_v2 = true,
 };
 
-static struct iwl_ht_params iwl2000_ht_params = {
+static const struct iwl_ht_params iwl2000_ht_params = {
 	.ht_greenfield_support = true,
 	.use_rts_for_aggregation = true, /* use rts/cts protection */
 };
 
-static struct iwl_bt_params iwl2030_bt_params = {
+static const struct iwl_bt_params iwl2030_bt_params = {
 	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
 	.advanced_bt_coexist = true,
 	.agg_time_limit = BT_AGG_THRESHOLD_DEF,
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index cbcec33..0b85ca0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -306,7 +306,7 @@ static struct iwl_lib_ops iwl5150_lib = {
 	.temperature = iwl5150_temperature,
 };
 
-static struct iwl_base_params iwl5000_base_params = {
+static const struct iwl_base_params iwl5000_base_params = {
 	.eeprom_size = IWLAGN_EEPROM_IMG_SIZE,
 	.num_of_queues = IWLAGN_NUM_QUEUES,
 	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
@@ -319,7 +319,8 @@ static struct iwl_base_params iwl5000_base_params = {
 	.no_idle_support = true,
 	.wd_disable = true,
 };
-static struct iwl_ht_params iwl5000_ht_params = {
+
+static const struct iwl_ht_params iwl5000_ht_params = {
 	.ht_greenfield_support = true,
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index b3ceaad..1e29a51 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -269,7 +269,7 @@ static struct iwl_lib_ops iwl6030_lib = {
 	.temperature = iwlagn_temperature,
 };
 
-static struct iwl_base_params iwl6000_base_params = {
+static const struct iwl_base_params iwl6000_base_params = {
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
 	.num_of_queues = IWLAGN_NUM_QUEUES,
 	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
@@ -286,7 +286,7 @@ static struct iwl_base_params iwl6000_base_params = {
 	.shadow_reg_enable = true,
 };
 
-static struct iwl_base_params iwl6050_base_params = {
+static const struct iwl_base_params iwl6050_base_params = {
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
 	.num_of_queues = IWLAGN_NUM_QUEUES,
 	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
@@ -302,7 +302,8 @@ static struct iwl_base_params iwl6050_base_params = {
 	.max_event_log_size = 1024,
 	.shadow_reg_enable = true,
 };
-static struct iwl_base_params iwl6000_g2_base_params = {
+
+static const struct iwl_base_params iwl6000_g2_base_params = {
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
 	.num_of_queues = IWLAGN_NUM_QUEUES,
 	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
@@ -319,12 +320,12 @@ static struct iwl_base_params iwl6000_g2_base_params = {
 	.shadow_reg_enable = true,
 };
 
-static struct iwl_ht_params iwl6000_ht_params = {
+static const struct iwl_ht_params iwl6000_ht_params = {
 	.ht_greenfield_support = true,
 	.use_rts_for_aggregation = true, /* use rts/cts protection */
 };
 
-static struct iwl_bt_params iwl6000_bt_params = {
+static const struct iwl_bt_params iwl6000_bt_params = {
 	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
 	.advanced_bt_coexist = true,
 	.agg_time_limit = BT_AGG_THRESHOLD_DEF,
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index ecb46dc..e2bcc99 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -364,10 +364,10 @@ struct iwl_cfg {
 	const struct iwl_lib_ops *lib;
 	void (*additional_nic_config)(struct iwl_priv *priv);
 	/* params not likely to change within a device family */
-	struct iwl_base_params *base_params;
+	const struct iwl_base_params *base_params;
 	/* params likely to change within a device family */
-	struct iwl_ht_params *ht_params;
-	struct iwl_bt_params *bt_params;
+	const struct iwl_ht_params *ht_params;
+	const struct iwl_bt_params *bt_params;
 	enum iwl_pa_type pa_type;	  /* if used set to IWL_PA_SYSTEM */
 	const bool need_temp_offset_calib; /* if used set to true */
 	const bool no_xtal_calib;
-- 
1.7.0.4

