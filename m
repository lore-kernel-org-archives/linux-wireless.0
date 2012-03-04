Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:38078 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754944Ab2CDUm7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 15:42:59 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 010/101] iwlwifi: make EXIT_PENDING depend on mac80211
Date: Sun,  4 Mar 2012 11:28:24 -0800
Message-Id: <1330889395-533-11-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120304_214651_730821_45988CDA)
In-Reply-To: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no reason to set EXIT_PENDING when we
start removing the module, as mac80211 will
cleanly shut down the device in this case.
Additionally, there's no point in rejecting
commands to the device when we're cleaning up
as that only leads to unwanted errors from
mac80211 being printed, such as
  failed to remove key (...) from hardware (-16)

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c      |    6 ------
 drivers/net/wireless/iwlwifi/iwl-agn.c           |    6 ------
 drivers/net/wireless/iwlwifi/iwl-mac80211.c      |    4 ----
 drivers/net/wireless/iwlwifi/iwl-scan.c          |    3 +--
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c |    7 -------
 5 files changed, 1 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index a8c7900..7a86a35 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -422,9 +422,6 @@ int iwlagn_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 
 	lockdep_assert_held(&priv->shrd->mutex);
 
-	if (test_bit(STATUS_EXIT_PENDING, &priv->shrd->status))
-		return -EINVAL;
-
 	if (!iwl_is_alive(priv->shrd))
 		return -EBUSY;
 
@@ -560,9 +557,6 @@ int iwlagn_mac_config(struct ieee80211_hw *hw, u32 changed)
 
 	mutex_lock(&priv->shrd->mutex);
 
-	if (test_bit(STATUS_EXIT_PENDING, &priv->shrd->status))
-		goto out;
-
 	if (unlikely(test_bit(STATUS_SCANNING, &priv->shrd->status))) {
 		IWL_DEBUG_MAC80211(priv, "leave - scanning\n");
 		goto out;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index ada9d9e..c14eda0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1378,12 +1378,6 @@ static void iwl_op_mode_dvm_stop(struct iwl_op_mode *op_mode)
 
 	iwl_dbgfs_unregister(priv);
 
-	/* ieee80211_unregister_hw call wil cause iwlagn_mac_stop to
-	 * to be called and iwl_down since we are removing the device
-	 * we need to set STATUS_EXIT_PENDING bit.
-	 */
-	set_bit(STATUS_EXIT_PENDING, &priv->shrd->status);
-
 	iwl_testmode_cleanup(priv);
 	iwlagn_mac_unregister(priv);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
index dcee30f..7f63ba9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -649,8 +649,6 @@ static int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
 	case IEEE80211_AMPDU_RX_STOP:
 		IWL_DEBUG_HT(priv, "stop Rx\n");
 		ret = iwl_sta_rx_agg_stop(priv, sta, tid);
-		if (test_bit(STATUS_EXIT_PENDING, &priv->shrd->status))
-			ret = 0;
 		break;
 	case IEEE80211_AMPDU_TX_START:
 		if (iwlagn_mod_params.disable_11n & IWL_DISABLE_HT_TXAGG)
@@ -666,8 +664,6 @@ static int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
 			IWL_DEBUG_HT(priv, "priv->agg_tids_count = %u\n",
 				     priv->agg_tids_count);
 		}
-		if (test_bit(STATUS_EXIT_PENDING, &priv->shrd->status))
-			ret = 0;
 		if (!priv->agg_tids_count && cfg(priv)->ht_params &&
 		    cfg(priv)->ht_params->use_rts_for_aggregation) {
 			/*
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 42ee1c4..766572b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -69,8 +69,7 @@ static int iwl_send_scan_abort(struct iwl_priv *priv)
 	if (!test_bit(STATUS_READY, &priv->shrd->status) ||
 	    !test_bit(STATUS_GEO_CONFIGURED, &priv->shrd->status) ||
 	    !test_bit(STATUS_SCAN_HW, &priv->shrd->status) ||
-	    test_bit(STATUS_FW_ERROR, &priv->shrd->status) ||
-	    test_bit(STATUS_EXIT_PENDING, &priv->shrd->status))
+	    test_bit(STATUS_FW_ERROR, &priv->shrd->status))
 		return -EIO;
 
 	ret = iwl_trans_send_cmd(trans(priv), &cmd);
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
index 1cb1dd2..de2a0d9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
@@ -914,9 +914,6 @@ static int iwl_send_cmd_async(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 		return -EINVAL;
 
 
-	if (test_bit(STATUS_EXIT_PENDING, &trans->shrd->status))
-		return -EBUSY;
-
 	ret = iwl_enqueue_hcmd(trans, cmd);
 	if (ret < 0) {
 		IWL_DEBUG_QUIET_RFKILL(trans,
@@ -938,10 +935,6 @@ static int iwl_send_cmd_sync(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 	IWL_DEBUG_INFO(trans, "Attempting to send sync command %s\n",
 			get_cmd_string(cmd->id));
 
-	if (test_bit(STATUS_EXIT_PENDING, &trans->shrd->status))
-		return -EBUSY;
-
-
 	if (test_bit(STATUS_RF_KILL_HW, &trans->shrd->status)) {
 		IWL_ERR(trans, "Command %s aborted: RF KILL Switch\n",
 			       get_cmd_string(cmd->id));
-- 
1.7.0.4

