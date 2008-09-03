Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:21506 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755202AbYICDbj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2008 23:31:39 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 33/39] iwlwifi: use the results from disconnected antenna algorithm
Date: Wed,  3 Sep 2008 11:26:53 +0800
Message-Id: <1220412419-15404-34-git-send-email-yi.zhu@intel.com> (sfid-20080903_055043_181952_7C843064)
In-Reply-To: <1220412419-15404-33-git-send-email-yi.zhu@intel.com>
References: <1220412419-15404-1-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-2-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-3-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-4-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-5-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-6-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-7-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-8-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-9-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-10-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-11-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-12-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-13-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-14-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-15-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-16-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-17-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-18-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-19-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-20-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-21-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-22-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-23-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-24-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-25-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-26-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-27-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-28-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-29-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-30-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-31-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-32-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-33-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Grumbach, Emmanuel <emmanuel.grumbach@intel.com>

This patch makes usage of the results from disconnected antenna alg to
know how many antennas are connected.

It also synchronizes between the chain noise alg and the W/A that
disables power management during association. All the antennas must be
enables during the chain noise algorithm. Hence, power management is
restored only after the completion of the algorithm.

In the future, we will need to update the AP that we don't support MIMO
if there is only one antenna connected. We also need to update the rate
scaling algorithm.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c   |    6 ++++-
 drivers/net/wireless/iwlwifi/iwl-calib.c |   15 +++++++++---
 drivers/net/wireless/iwlwifi/iwl-core.c  |   35 ++++++++++++++++++++++++------
 drivers/net/wireless/iwlwifi/iwl-dev.h   |   10 +++++---
 drivers/net/wireless/iwlwifi/iwl-power.c |   26 +++++++++++-----------
 drivers/net/wireless/iwlwifi/iwl-power.h |    2 +-
 6 files changed, 64 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 42cb3dd..45cdf31 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2558,7 +2558,11 @@ static void iwl4965_post_associate(struct iwl_priv *priv)
 	iwl_activate_qos(priv, 0);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	iwl_power_enable_management(priv);
+	/* the chain noise calibration will enabled PM upon completion
+	 * If chain noise has already been run, then we need to enable
+	 * power management here */
+	if (priv->chain_noise_data.state == IWL_CHAIN_NOISE_DONE)
+		iwl_power_enable_management(priv);
 
 	/* Enable Rx differential gain and sensitivity calibrations */
 	iwl_chain_noise_reset(priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-calib.c b/drivers/net/wireless/iwlwifi/iwl-calib.c
index 35fb4a4..72fbf47 100644
--- a/drivers/net/wireless/iwlwifi/iwl-calib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-calib.c
@@ -808,13 +808,11 @@ void iwl_chain_noise_calibration(struct iwl_priv *priv,
 		}
 	}
 
+	/* Save for use within RXON, TX, SCAN commands, etc. */
+	priv->chain_noise_data.active_chains = active_chains;
 	IWL_DEBUG_CALIB("active_chains (bitwise) = 0x%x\n",
 			active_chains);
 
-	/* Save for use within RXON, TX, SCAN commands, etc. */
-	/*priv->valid_antenna = active_chains;*/
-	/*FIXME: should be reflected in RX chains in RXON */
-
 	/* Analyze noise for rx balance */
 	average_noise[0] = ((data->chain_noise_a)/CAL_NUM_OF_BEACONS);
 	average_noise[1] = ((data->chain_noise_b)/CAL_NUM_OF_BEACONS);
@@ -839,6 +837,15 @@ void iwl_chain_noise_calibration(struct iwl_priv *priv,
 
 	priv->cfg->ops->utils->gain_computation(priv, average_noise,
 		min_average_noise_antenna_i, min_average_noise);
+
+	/* Some power changes may have been made during the calibration.
+	 * Update and commit the RXON
+	 */
+	if (priv->cfg->ops->lib->update_chain_flags)
+		priv->cfg->ops->lib->update_chain_flags(priv);
+
+	data->state = IWL_CHAIN_NOISE_DONE;
+	iwl_power_enable_management(priv);
 }
 EXPORT_SYMBOL(iwl_chain_noise_calibration);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index b29c84a..134f4ee 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -740,6 +740,17 @@ static int iwl_get_idle_rx_chain_count(struct iwl_priv *priv, int active_cnt)
 	return idle_cnt;
 }
 
+/* up to 4 chains */
+static u8 iwl_count_chain_bitmap(u32 chain_bitmap)
+{
+	u8 res;
+	res = (chain_bitmap & BIT(0)) >> 0;
+	res += (chain_bitmap & BIT(1)) >> 1;
+	res += (chain_bitmap & BIT(2)) >> 2;
+	res += (chain_bitmap & BIT(4)) >> 4;
+	return res;
+}
+
 /**
  * iwl_set_rxon_chain - Set up Rx chain usage in "staging" RXON image
  *
@@ -750,25 +761,35 @@ void iwl_set_rxon_chain(struct iwl_priv *priv)
 {
 	bool is_single = is_single_rx_stream(priv);
 	bool is_cam = !test_bit(STATUS_POWER_PMI, &priv->status);
-	u8 idle_rx_cnt, active_rx_cnt;
+	u8 idle_rx_cnt, active_rx_cnt, valid_rx_cnt;
+	u32 active_chains;
 	u16 rx_chain;
 
 	/* Tell uCode which antennas are actually connected.
 	 * Before first association, we assume all antennas are connected.
 	 * Just after first association, iwl_chain_noise_calibration()
 	 *    checks which antennas actually *are* connected. */
-	rx_chain = priv->hw_params.valid_rx_ant << RXON_RX_CHAIN_VALID_POS;
+	 if (priv->chain_noise_data.active_chains)
+		active_chains = priv->chain_noise_data.active_chains;
+	else
+		active_chains = priv->hw_params.valid_rx_ant;
+
+	rx_chain = active_chains << RXON_RX_CHAIN_VALID_POS;
 
 	/* How many receivers should we use? */
 	active_rx_cnt = iwl_get_active_rx_chain_count(priv);
 	idle_rx_cnt = iwl_get_idle_rx_chain_count(priv, active_rx_cnt);
 
-	/* correct rx chain count accoridng hw settings */
-	if (priv->hw_params.rx_chains_num < active_rx_cnt)
-		active_rx_cnt = priv->hw_params.rx_chains_num;
 
-	if (priv->hw_params.rx_chains_num < idle_rx_cnt)
-		idle_rx_cnt = priv->hw_params.rx_chains_num;
+	/* correct rx chain count according hw settings
+	 * and chain noise calibration
+	 */
+	valid_rx_cnt = iwl_count_chain_bitmap(active_chains);
+	if (valid_rx_cnt < active_rx_cnt)
+		active_rx_cnt = valid_rx_cnt;
+
+	if (valid_rx_cnt < idle_rx_cnt)
+		idle_rx_cnt = valid_rx_cnt;
 
 	rx_chain |= active_rx_cnt << RXON_RX_CHAIN_MIMO_CNT_POS;
 	rx_chain |= idle_rx_cnt  << RXON_RX_CHAIN_CNT_POS;
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 7934f56..6e150f6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -699,8 +699,9 @@ enum iwl4965_false_alarm_state {
 
 enum iwl4965_chain_noise_state {
 	IWL_CHAIN_NOISE_ALIVE = 0,  /* must be 0 */
-	IWL_CHAIN_NOISE_ACCUMULATE = 1,
-	IWL_CHAIN_NOISE_CALIBRATED = 2,
+	IWL_CHAIN_NOISE_ACCUMULATE,
+	IWL_CHAIN_NOISE_CALIBRATED,
+	IWL_CHAIN_NOISE_DONE,
 };
 
 enum iwl4965_calib_enabled_state {
@@ -758,17 +759,18 @@ struct iwl_sensitivity_data {
 
 /* Chain noise (differential Rx gain) calib data */
 struct iwl_chain_noise_data {
-	u8 state;
-	u16 beacon_count;
+	u32 active_chains;
 	u32 chain_noise_a;
 	u32 chain_noise_b;
 	u32 chain_noise_c;
 	u32 chain_signal_a;
 	u32 chain_signal_b;
 	u32 chain_signal_c;
+	u16 beacon_count;
 	u8 disconn_array[NUM_RX_CHAINS];
 	u8 delta_gain_code[NUM_RX_CHAINS];
 	u8 radio_write;
+	u8 state;
 };
 
 #define	EEPROM_SEM_TIMEOUT 10		/* milliseconds */
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index 16f834d..bd6f600 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -252,12 +252,21 @@ static int iwl_update_power_command(struct iwl_priv *priv,
 /*
  * calucaute the final power mode index
  */
-int iwl_power_update_mode(struct iwl_priv *priv, u8 refresh)
+int iwl_power_update_mode(struct iwl_priv *priv, bool force)
 {
 	struct iwl_power_mgr *setting = &(priv->power_data);
 	int ret = 0;
 	u16 uninitialized_var(final_mode);
 
+	/* Don't update the RX chain when chain noise calibration is running */
+	if (priv->chain_noise_data.state != IWL_CHAIN_NOISE_DONE &&
+	    priv->chain_noise_data.state != IWL_CHAIN_NOISE_ALIVE) {
+		IWL_DEBUG_POWER("Cannot update the power, chain noise "
+			"calibration running: %d\n",
+			priv->chain_noise_data.state);
+		return -EAGAIN;
+	}
+
        /* If on battery, set to 3,
 	* if plugged into AC power, set to CAM ("continuously aware mode"),
 	* else user level */
@@ -285,7 +294,7 @@ int iwl_power_update_mode(struct iwl_priv *priv, u8 refresh)
 		final_mode = IWL_POWER_MODE_CAM;
 
 	if (!iwl_is_rfkill(priv) && !setting->power_disabled &&
-	    ((setting->power_mode != final_mode) || refresh)) {
+	    ((setting->power_mode != final_mode) || force)) {
 		struct iwl_powertable_cmd cmd;
 
 		if (final_mode != IWL_POWER_MODE_CAM)
@@ -359,35 +368,26 @@ EXPORT_SYMBOL(iwl_power_enable_management);
 /* set user_power_setting */
 int iwl_power_set_user_mode(struct iwl_priv *priv, u16 mode)
 {
-	int ret = 0;
-
 	if (mode > IWL_POWER_LIMIT)
 		return -EINVAL;
 
 	priv->power_data.user_power_setting = mode;
 
-	ret = iwl_power_update_mode(priv, 0);
-
-	return ret;
+	return iwl_power_update_mode(priv, 0);
 }
 EXPORT_SYMBOL(iwl_power_set_user_mode);
 
-
 /* set system_power_setting. This should be set by over all
  * PM application.
  */
 int iwl_power_set_system_mode(struct iwl_priv *priv, u16 mode)
 {
-	int ret = 0;
-
 	if (mode > IWL_POWER_LIMIT)
 		return -EINVAL;
 
 	priv->power_data.system_power_setting = mode;
 
-	ret = iwl_power_update_mode(priv, 0);
-
-	return ret;
+	return iwl_power_update_mode(priv, 0);
 }
 EXPORT_SYMBOL(iwl_power_set_system_mode);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.h b/drivers/net/wireless/iwlwifi/iwl-power.h
index aa99f36..a5c334f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.h
+++ b/drivers/net/wireless/iwlwifi/iwl-power.h
@@ -80,7 +80,7 @@ struct iwl_power_mgr {
 
 void iwl_setup_power_deferred_work(struct iwl_priv *priv);
 void iwl_power_cancel_timeout(struct iwl_priv *priv);
-int iwl_power_update_mode(struct iwl_priv *priv, u8 refresh);
+int iwl_power_update_mode(struct iwl_priv *priv, bool force);
 int iwl_power_disable_management(struct iwl_priv *priv, u32 ms);
 int iwl_power_enable_management(struct iwl_priv *priv);
 int iwl_power_set_user_mode(struct iwl_priv *priv, u16 mode);
-- 
1.5.3.6

