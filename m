Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:1107 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752664AbZIYVYe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Sep 2009 17:24:34 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes@sipsolutions.net>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 7/8] iwlwifi: support idle for 6000 series hw
Date: Fri, 25 Sep 2009 14:24:27 -0700
Message-Id: <1253913868-8400-8-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1253913868-8400-1-git-send-email-reinette.chatre@intel.com>
References: <1253913868-8400-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>

Using powersave while idle saves a lot of power, but
we've had problems with this on some cards (5150 has
been reported to be problematic). However, on the new
6000 series we're seeing no problems, so for now let
that hardware benefit from idle mode, we can look at
the problems with other hardware one by one and then
enable those once we figure out the problems.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-6000.c  |   10 ++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.c  |    3 ++-
 drivers/net/wireless/iwlwifi/iwl-core.h  |    1 +
 drivers/net/wireless/iwlwifi/iwl-power.c |    3 +++
 4 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index ad5d77c..6f4ee27 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -254,6 +254,7 @@ struct iwl_cfg iwl6000h_2agn_cfg = {
 	.led_compensation = 51,
 	.use_rts_for_ht = true, /* use rts/cts protection */
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
+	.supports_idle = true,
 };
 
 struct iwl_cfg iwl6000h_2abg_cfg = {
@@ -276,6 +277,7 @@ struct iwl_cfg iwl6000h_2abg_cfg = {
 	.ht_greenfield_support = true,
 	.led_compensation = 51,
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
+	.supports_idle = true,
 };
 
 struct iwl_cfg iwl6000h_2bg_cfg = {
@@ -298,6 +300,7 @@ struct iwl_cfg iwl6000h_2bg_cfg = {
 	.ht_greenfield_support = true,
 	.led_compensation = 51,
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
+	.supports_idle = true,
 };
 
 /*
@@ -324,6 +327,7 @@ struct iwl_cfg iwl6000i_2agn_cfg = {
 	.led_compensation = 51,
 	.use_rts_for_ht = true, /* use rts/cts protection */
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
+	.supports_idle = true,
 };
 
 struct iwl_cfg iwl6000i_2abg_cfg = {
@@ -346,6 +350,7 @@ struct iwl_cfg iwl6000i_2abg_cfg = {
 	.ht_greenfield_support = true,
 	.led_compensation = 51,
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
+	.supports_idle = true,
 };
 
 struct iwl_cfg iwl6000i_2bg_cfg = {
@@ -368,6 +373,7 @@ struct iwl_cfg iwl6000i_2bg_cfg = {
 	.ht_greenfield_support = true,
 	.led_compensation = 51,
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
+	.supports_idle = true,
 };
 
 struct iwl_cfg iwl6050_2agn_cfg = {
@@ -391,6 +397,7 @@ struct iwl_cfg iwl6050_2agn_cfg = {
 	.led_compensation = 51,
 	.use_rts_for_ht = true, /* use rts/cts protection */
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
+	.supports_idle = true,
 };
 
 struct iwl_cfg iwl6050_2abg_cfg = {
@@ -413,6 +420,7 @@ struct iwl_cfg iwl6050_2abg_cfg = {
 	.ht_greenfield_support = true,
 	.led_compensation = 51,
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
+	.supports_idle = true,
 };
 
 struct iwl_cfg iwl6000_3agn_cfg = {
@@ -436,6 +444,7 @@ struct iwl_cfg iwl6000_3agn_cfg = {
 	.led_compensation = 51,
 	.use_rts_for_ht = true, /* use rts/cts protection */
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
+	.supports_idle = true,
 };
 
 struct iwl_cfg iwl6050_3agn_cfg = {
@@ -459,6 +468,7 @@ struct iwl_cfg iwl6050_3agn_cfg = {
 	.led_compensation = 51,
 	.use_rts_for_ht = true, /* use rts/cts protection */
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
+	.supports_idle = true,
 };
 
 MODULE_FIRMWARE(IWL6000_MODULE_FIRMWARE(IWL6000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index e97b104..1cf2e04 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2650,7 +2650,8 @@ int iwl_mac_config(struct ieee80211_hw *hw, u32 changed)
 		iwl_set_rate(priv);
 	}
 
-	if (changed & IEEE80211_CONF_CHANGE_PS) {
+	if (changed & (IEEE80211_CONF_CHANGE_PS |
+			IEEE80211_CONF_CHANGE_IDLE)) {
 		ret = iwl_power_update_mode(priv, false);
 		if (ret)
 			IWL_DEBUG_MAC80211(priv, "Error setting sleep level\n");
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index b66bf7b..744f0ca 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -265,6 +265,7 @@ struct iwl_cfg {
 	const bool broken_powersave;
 	bool use_rts_for_ht;
 	int chain_noise_num_beacons;
+	const bool supports_idle;
 };
 
 /***************************
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index 60be976..e50d77b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -294,6 +294,9 @@ int iwl_power_update_mode(struct iwl_priv *priv, bool force)
 
 	if (priv->cfg->broken_powersave)
 		iwl_power_sleep_cam_cmd(priv, &cmd);
+	else if (priv->cfg->supports_idle &&
+		 priv->hw->conf.flags & IEEE80211_CONF_IDLE)
+		iwl_static_sleep_cmd(priv, &cmd, IWL_POWER_INDEX_5, 20);
 	else if (tt->state >= IWL_TI_1)
 		iwl_static_sleep_cmd(priv, &cmd, tt->tt_power_mode, dtimper);
 	else if (!enabled)
-- 
1.5.6.3

