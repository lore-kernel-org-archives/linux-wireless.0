Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:32389 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753186AbYLSCpi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 21:45:38 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 36/43] iwl3945: cleanup and remove duplicate code
Date: Fri, 19 Dec 2008 10:37:36 +0800
Message-Id: <1229654263-21454-37-git-send-email-yi.zhu@intel.com> (sfid-20081219_034626_575107_3D6CFD79)
In-Reply-To: <1229654263-21454-36-git-send-email-yi.zhu@intel.com>
References: <1229654263-21454-1-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-2-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-3-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-4-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-5-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-6-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-7-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-8-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-9-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-10-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-11-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-12-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-13-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-14-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-15-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-16-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-17-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-18-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-19-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-20-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-21-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-22-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-23-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-24-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-25-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-26-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-27-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-28-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-29-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-30-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-31-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-32-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-33-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-34-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-35-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-36-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kolekar, Abhijeet <abhijeet.kolekar@intel.com>

The patch removes the following duplicate structures:

	iwl3945_is_alive
	iwl3945_is_ready
	iwl3945_is_init
	iwl3945_is_rfkill_sw
	iwl3945_is_rfkill
	iwl3945_reset_qos

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |  204 +++++----------------------
 1 files changed, 34 insertions(+), 170 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index e8b2af8..a8e17c5 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -433,51 +433,6 @@ u8 iwl3945_add_station(struct iwl_priv *priv, const u8 *addr, int is_ap, u8 flag
 
 }
 
-/*************** DRIVER STATUS FUNCTIONS   *****/
-
-static inline int iwl3945_is_ready(struct iwl_priv *priv)
-{
-	/* The adapter is 'ready' if READY and GEO_CONFIGURED bits are
-	 * set but EXIT_PENDING is not */
-	return test_bit(STATUS_READY, &priv->status) &&
-	       test_bit(STATUS_GEO_CONFIGURED, &priv->status) &&
-	       !test_bit(STATUS_EXIT_PENDING, &priv->status);
-}
-
-static inline int iwl3945_is_alive(struct iwl_priv *priv)
-{
-	return test_bit(STATUS_ALIVE, &priv->status);
-}
-
-static inline int iwl3945_is_init(struct iwl_priv *priv)
-{
-	return test_bit(STATUS_INIT, &priv->status);
-}
-
-static inline int iwl3945_is_rfkill_sw(struct iwl_priv *priv)
-{
-	return test_bit(STATUS_RF_KILL_SW, &priv->status);
-}
-
-static inline int iwl3945_is_rfkill_hw(struct iwl_priv *priv)
-{
-	return test_bit(STATUS_RF_KILL_HW, &priv->status);
-}
-
-static inline int iwl3945_is_rfkill(struct iwl_priv *priv)
-{
-	return iwl3945_is_rfkill_hw(priv) ||
-		iwl3945_is_rfkill_sw(priv);
-}
-
-static inline int iwl3945_is_ready_rf(struct iwl_priv *priv)
-{
-
-	if (iwl3945_is_rfkill(priv))
-		return 0;
-
-	return iwl3945_is_ready(priv);
-}
 
 /*************** HOST COMMAND QUEUE FUNCTIONS   *****/
 
@@ -515,7 +470,7 @@ static int iwl3945_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	       !(cmd->meta.flags & CMD_SIZE_HUGE));
 
 
-	if (iwl3945_is_rfkill(priv)) {
+	if (iwl_is_rfkill(priv)) {
 		IWL_DEBUG_INFO("Not sending command - RF KILL");
 		return -EIO;
 	}
@@ -943,7 +898,7 @@ static int iwl3945_commit_rxon(struct iwl_priv *priv)
 	int rc = 0;
 	DECLARE_MAC_BUF(mac);
 
-	if (!iwl3945_is_alive(priv))
+	if (!iwl_is_alive(priv))
 		return -1;
 
 	/* always get timestamp with Rx frame */
@@ -1598,97 +1553,6 @@ static int iwl3945_send_qos_params_command(struct iwl_priv *priv,
 				sizeof(struct iwl_qosparam_cmd), qos);
 }
 
-static void iwl3945_reset_qos(struct iwl_priv *priv)
-{
-	u16 cw_min = 15;
-	u16 cw_max = 1023;
-	u8 aifs = 2;
-	u8 is_legacy = 0;
-	unsigned long flags;
-	int i;
-
-	spin_lock_irqsave(&priv->lock, flags);
-	priv->qos_data.qos_active = 0;
-
-	/* QoS always active in AP and ADHOC mode
-	 * In STA mode wait for association
-	 */
-	if (priv->iw_mode == NL80211_IFTYPE_ADHOC ||
-	    priv->iw_mode == NL80211_IFTYPE_AP)
-		priv->qos_data.qos_active = 1;
-	else
-		priv->qos_data.qos_active = 0;
-
-
-	/* check for legacy mode */
-	if ((priv->iw_mode == NL80211_IFTYPE_ADHOC &&
-	     (priv->active_rate & IWL_OFDM_RATES_MASK) == 0) ||
-	    (priv->iw_mode == NL80211_IFTYPE_STATION &&
-	     (priv->staging39_rxon.flags & RXON_FLG_SHORT_SLOT_MSK) == 0)) {
-		cw_min = 31;
-		is_legacy = 1;
-	}
-
-	if (priv->qos_data.qos_active)
-		aifs = 3;
-
-	priv->qos_data.def_qos_parm.ac[0].cw_min = cpu_to_le16(cw_min);
-	priv->qos_data.def_qos_parm.ac[0].cw_max = cpu_to_le16(cw_max);
-	priv->qos_data.def_qos_parm.ac[0].aifsn = aifs;
-	priv->qos_data.def_qos_parm.ac[0].edca_txop = 0;
-	priv->qos_data.def_qos_parm.ac[0].reserved1 = 0;
-
-	if (priv->qos_data.qos_active) {
-		i = 1;
-		priv->qos_data.def_qos_parm.ac[i].cw_min = cpu_to_le16(cw_min);
-		priv->qos_data.def_qos_parm.ac[i].cw_max = cpu_to_le16(cw_max);
-		priv->qos_data.def_qos_parm.ac[i].aifsn = 7;
-		priv->qos_data.def_qos_parm.ac[i].edca_txop = 0;
-		priv->qos_data.def_qos_parm.ac[i].reserved1 = 0;
-
-		i = 2;
-		priv->qos_data.def_qos_parm.ac[i].cw_min =
-			cpu_to_le16((cw_min + 1) / 2 - 1);
-		priv->qos_data.def_qos_parm.ac[i].cw_max =
-			cpu_to_le16(cw_max);
-		priv->qos_data.def_qos_parm.ac[i].aifsn = 2;
-		if (is_legacy)
-			priv->qos_data.def_qos_parm.ac[i].edca_txop =
-				cpu_to_le16(6016);
-		else
-			priv->qos_data.def_qos_parm.ac[i].edca_txop =
-				cpu_to_le16(3008);
-		priv->qos_data.def_qos_parm.ac[i].reserved1 = 0;
-
-		i = 3;
-		priv->qos_data.def_qos_parm.ac[i].cw_min =
-			cpu_to_le16((cw_min + 1) / 4 - 1);
-		priv->qos_data.def_qos_parm.ac[i].cw_max =
-			cpu_to_le16((cw_max + 1) / 2 - 1);
-		priv->qos_data.def_qos_parm.ac[i].aifsn = 2;
-		priv->qos_data.def_qos_parm.ac[i].reserved1 = 0;
-		if (is_legacy)
-			priv->qos_data.def_qos_parm.ac[i].edca_txop =
-				cpu_to_le16(3264);
-		else
-			priv->qos_data.def_qos_parm.ac[i].edca_txop =
-				cpu_to_le16(1504);
-	} else {
-		for (i = 1; i < 4; i++) {
-			priv->qos_data.def_qos_parm.ac[i].cw_min =
-				cpu_to_le16(cw_min);
-			priv->qos_data.def_qos_parm.ac[i].cw_max =
-				cpu_to_le16(cw_max);
-			priv->qos_data.def_qos_parm.ac[i].aifsn = aifs;
-			priv->qos_data.def_qos_parm.ac[i].edca_txop = 0;
-			priv->qos_data.def_qos_parm.ac[i].reserved1 = 0;
-		}
-	}
-	IWL_DEBUG_QOS("set QoS to default \n");
-
-	spin_unlock_irqrestore(&priv->lock, flags);
-}
-
 static void iwl3945_activate_qos(struct iwl_priv *priv, u8 force)
 {
 	unsigned long flags;
@@ -2020,7 +1884,7 @@ static void iwl3945_setup_rxon_timing(struct iwl_priv *priv)
 
 static int iwl3945_scan_initiate(struct iwl_priv *priv)
 {
-	if (!iwl3945_is_ready_rf(priv)) {
+	if (!iwl_is_ready_rf(priv)) {
 		IWL_DEBUG_SCAN("Aborting scan due to not ready.\n");
 		return -EIO;
 	}
@@ -2181,7 +2045,7 @@ static int iwl3945_set_mode(struct iwl_priv *priv, int mode)
 	iwl3945_clear_stations_table(priv);
 
 	/* don't commit rxon if rf-kill is on*/
-	if (!iwl3945_is_ready_rf(priv))
+	if (!iwl_is_ready_rf(priv))
 		return -EAGAIN;
 
 	cancel_delayed_work(&priv->scan_check);
@@ -2398,7 +2262,7 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	int rc;
 
 	spin_lock_irqsave(&priv->lock, flags);
-	if (iwl3945_is_rfkill(priv)) {
+	if (iwl_is_rfkill(priv)) {
 		IWL_DEBUG_DROP("Dropping - RF KILL\n");
 		goto drop_unlock;
 	}
@@ -5624,7 +5488,7 @@ static void iwl3945_alive_start(struct iwl_priv *priv)
 	/* Clear out the uCode error bit if it is set */
 	clear_bit(STATUS_FW_ERROR, &priv->status);
 
-	if (iwl3945_is_rfkill(priv))
+	if (iwl_is_rfkill(priv))
 		return;
 
 	ieee80211_wake_queues(priv->hw);
@@ -5718,7 +5582,7 @@ static void __iwl3945_down(struct iwl_priv *priv)
 
 	/* If we have not previously called iwl3945_init() then
 	 * clear all bits but the RF Kill and SUSPEND bits and return */
-	if (!iwl3945_is_init(priv)) {
+	if (!iwl_is_init(priv)) {
 		priv->status = test_bit(STATUS_RF_KILL_HW, &priv->status) <<
 					STATUS_RF_KILL_HW |
 			       test_bit(STATUS_RF_KILL_SW, &priv->status) <<
@@ -5930,7 +5794,7 @@ static void iwl3945_bg_rf_kill(struct work_struct *work)
 
 	mutex_lock(&priv->mutex);
 
-	if (!iwl3945_is_rfkill(priv)) {
+	if (!iwl_is_rfkill(priv)) {
 		IWL_DEBUG(IWL_DL_INFO | IWL_DL_RF_KILL,
 			  "HW and/or SW RF Kill no longer active, restarting "
 			  "device\n");
@@ -5994,7 +5858,7 @@ static void iwl3945_bg_request_scan(struct work_struct *data)
 
 	mutex_lock(&priv->mutex);
 
-	if (!iwl3945_is_ready(priv)) {
+	if (!iwl_is_ready(priv)) {
 		IWL_WARN(priv, "request scan called when driver not ready.\n");
 		goto done;
 	}
@@ -6023,7 +5887,7 @@ static void iwl3945_bg_request_scan(struct work_struct *data)
 		goto done;
 	}
 
-	if (iwl3945_is_rfkill(priv)) {
+	if (iwl_is_rfkill(priv)) {
 		IWL_DEBUG_HC("Aborting scan due to RF Kill activation\n");
 		goto done;
 	}
@@ -6305,7 +6169,7 @@ static void iwl3945_bg_abort_scan(struct work_struct *work)
 {
 	struct iwl_priv *priv = container_of(work, struct iwl_priv, abort_scan);
 
-	if (!iwl3945_is_ready(priv))
+	if (!iwl_is_ready(priv))
 		return;
 
 	mutex_lock(&priv->mutex);
@@ -6441,7 +6305,7 @@ static void iwl3945_mac_stop(struct ieee80211_hw *hw)
 
 	priv->is_open = 0;
 
-	if (iwl3945_is_ready_rf(priv)) {
+	if (iwl_is_ready_rf(priv)) {
 		/* stop mac, cancel any scan request and clear
 		 * RXON_FILTER_ASSOC_MSK BIT
 		 */
@@ -6504,7 +6368,7 @@ static int iwl3945_mac_add_interface(struct ieee80211_hw *hw,
 		memcpy(priv->mac_addr, conf->mac_addr, ETH_ALEN);
 	}
 
-	if (iwl3945_is_ready(priv))
+	if (iwl_is_ready(priv))
 		iwl3945_set_mode(priv, conf->type);
 
 	mutex_unlock(&priv->mutex);
@@ -6531,7 +6395,7 @@ static int iwl3945_mac_config(struct ieee80211_hw *hw, u32 changed)
 	mutex_lock(&priv->mutex);
 	IWL_DEBUG_MAC80211("enter to channel %d\n", conf->channel->hw_value);
 
-	if (!iwl3945_is_ready(priv)) {
+	if (!iwl_is_ready(priv)) {
 		IWL_DEBUG_MAC80211("leave - not ready\n");
 		ret = -EIO;
 		goto out;
@@ -6583,7 +6447,7 @@ static int iwl3945_mac_config(struct ieee80211_hw *hw, u32 changed)
 		goto out;
 	}
 
-	if (iwl3945_is_rfkill(priv)) {
+	if (iwl_is_rfkill(priv)) {
 		IWL_DEBUG_MAC80211("leave - RF kill\n");
 		ret = -EIO;
 		goto out;
@@ -6691,7 +6555,7 @@ static int iwl3945_mac_config_interface(struct ieee80211_hw *hw,
 			return rc;
 	}
 
-	if (!iwl3945_is_alive(priv))
+	if (!iwl_is_alive(priv))
 		return -EAGAIN;
 
 	mutex_lock(&priv->mutex);
@@ -6720,7 +6584,7 @@ static int iwl3945_mac_config_interface(struct ieee80211_hw *hw,
 		priv->ibss_beacon = ieee80211_beacon_get(hw, vif);
 	}
 
-	if (iwl3945_is_rfkill(priv))
+	if (iwl_is_rfkill(priv))
 		goto done;
 
 	if (conf->bssid && !is_zero_ether_addr(conf->bssid) &&
@@ -6819,7 +6683,7 @@ static void iwl3945_mac_remove_interface(struct ieee80211_hw *hw,
 
 	mutex_lock(&priv->mutex);
 
-	if (iwl3945_is_ready_rf(priv)) {
+	if (iwl_is_ready_rf(priv)) {
 		iwl3945_scan_cancel_timeout(priv, 100);
 		priv->staging39_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 		iwl3945_commit_rxon(priv);
@@ -6900,7 +6764,7 @@ static int iwl3945_mac_hw_scan(struct ieee80211_hw *hw, u8 *ssid, size_t len)
 	mutex_lock(&priv->mutex);
 	spin_lock_irqsave(&priv->lock, flags);
 
-	if (!iwl3945_is_ready_rf(priv)) {
+	if (!iwl_is_ready_rf(priv)) {
 		rc = -EIO;
 		IWL_DEBUG_MAC80211("leave - not ready or exit pending\n");
 		goto out_unlock;
@@ -7011,7 +6875,7 @@ static int iwl3945_mac_conf_tx(struct ieee80211_hw *hw, u16 queue,
 
 	IWL_DEBUG_MAC80211("enter\n");
 
-	if (!iwl3945_is_ready_rf(priv)) {
+	if (!iwl_is_ready_rf(priv)) {
 		IWL_DEBUG_MAC80211("leave - RF not ready\n");
 		return -EIO;
 	}
@@ -7059,7 +6923,7 @@ static int iwl3945_mac_get_tx_stats(struct ieee80211_hw *hw,
 
 	IWL_DEBUG_MAC80211("enter\n");
 
-	if (!iwl3945_is_ready_rf(priv)) {
+	if (!iwl_is_ready_rf(priv)) {
 		IWL_DEBUG_MAC80211("leave - RF not ready\n");
 		return -EIO;
 	}
@@ -7091,7 +6955,7 @@ static void iwl3945_mac_reset_tsf(struct ieee80211_hw *hw)
 	mutex_lock(&priv->mutex);
 	IWL_DEBUG_MAC80211("enter\n");
 
-	iwl3945_reset_qos(priv);
+	iwl_reset_qos(priv);
 
 	spin_lock_irqsave(&priv->lock, flags);
 	priv->assoc_id = 0;
@@ -7111,7 +6975,7 @@ static void iwl3945_mac_reset_tsf(struct ieee80211_hw *hw)
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	if (!iwl3945_is_ready_rf(priv)) {
+	if (!iwl_is_ready_rf(priv)) {
 		IWL_DEBUG_MAC80211("leave - not ready\n");
 		mutex_unlock(&priv->mutex);
 		return;
@@ -7149,7 +7013,7 @@ static int iwl3945_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *sk
 
 	IWL_DEBUG_MAC80211("enter\n");
 
-	if (!iwl3945_is_ready_rf(priv)) {
+	if (!iwl_is_ready_rf(priv)) {
 		IWL_DEBUG_MAC80211("leave - RF not ready\n");
 		return -EIO;
 	}
@@ -7171,7 +7035,7 @@ static int iwl3945_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *sk
 	IWL_DEBUG_MAC80211("leave\n");
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	iwl3945_reset_qos(priv);
+	iwl_reset_qos(priv);
 
 	iwl3945_post_associate(priv);
 
@@ -7228,7 +7092,7 @@ static ssize_t show_temperature(struct device *d,
 {
 	struct iwl_priv *priv = (struct iwl_priv *)d->driver_data;
 
-	if (!iwl3945_is_alive(priv))
+	if (!iwl_is_alive(priv))
 		return -EAGAIN;
 
 	return sprintf(buf, "%d\n", iwl3945_hw_get_temperature(priv));
@@ -7440,7 +7304,7 @@ static ssize_t store_power_level(struct device *d,
 	mode = simple_strtoul(buf, NULL, 0);
 	mutex_lock(&priv->mutex);
 
-	if (!iwl3945_is_ready(priv)) {
+	if (!iwl_is_ready(priv)) {
 		rc = -EAGAIN;
 		goto out;
 	}
@@ -7538,7 +7402,7 @@ static ssize_t show_statistics(struct device *d,
 	u8 *data = (u8 *)&priv->statistics_39;
 	int rc = 0;
 
-	if (!iwl3945_is_alive(priv))
+	if (!iwl_is_alive(priv))
 		return -EAGAIN;
 
 	mutex_lock(&priv->mutex);
@@ -7572,7 +7436,7 @@ static ssize_t show_antenna(struct device *d,
 {
 	struct iwl_priv *priv = dev_get_drvdata(d);
 
-	if (!iwl3945_is_alive(priv))
+	if (!iwl_is_alive(priv))
 		return -EAGAIN;
 
 	return sprintf(buf, "%d\n", priv->antenna);
@@ -7609,7 +7473,7 @@ static ssize_t show_status(struct device *d,
 			   struct device_attribute *attr, char *buf)
 {
 	struct iwl_priv *priv = (struct iwl_priv *)d->driver_data;
-	if (!iwl3945_is_alive(priv))
+	if (!iwl_is_alive(priv))
 		return -EAGAIN;
 	return sprintf(buf, "0x%08x\n", (int)priv->status);
 }
@@ -7896,7 +7760,7 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 
 	priv->iw_mode = NL80211_IFTYPE_STATION;
 
-	iwl3945_reset_qos(priv);
+	iwl_reset_qos(priv);
 
 	priv->qos_data.qos_active = 0;
 	priv->qos_data.qos_cap.val = 0;
@@ -8117,7 +7981,7 @@ static int iwl3945_rfkill_soft_rf_kill(void *data, enum rfkill_state state)
 
 	switch (state) {
 	case RFKILL_STATE_UNBLOCKED:
-		if (iwl3945_is_rfkill_hw(priv)) {
+		if (iwl_is_rfkill_hw(priv)) {
 			err = -EBUSY;
 			goto out_unlock;
 		}
@@ -8194,12 +8058,12 @@ void iwl3945_rfkill_set_hw_state(struct iwl_priv *priv)
 	if (!priv->rfkill)
 		return;
 
-	if (iwl3945_is_rfkill_hw(priv)) {
+	if (iwl_is_rfkill_hw(priv)) {
 		rfkill_force_state(priv->rfkill, RFKILL_STATE_HARD_BLOCKED);
 		return;
 	}
 
-	if (!iwl3945_is_rfkill_sw(priv))
+	if (!iwl_is_rfkill_sw(priv))
 		rfkill_force_state(priv->rfkill, RFKILL_STATE_UNBLOCKED);
 	else
 		rfkill_force_state(priv->rfkill, RFKILL_STATE_SOFT_BLOCKED);
-- 
1.5.3.6

