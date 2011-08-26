Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:23946 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752238Ab1HZGx3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Aug 2011 02:53:29 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 12/60] iwlagn: priv->mutex moves to iwl_shared
Date: Thu, 25 Aug 2011 23:10:44 -0700
Message-Id: <1314339092-20797-13-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110826_085500_267082_CC76F903)
In-Reply-To: <1314339092-20797-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1314339092-20797-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Since it is used by all the layers, it needs to move to iwl_shared.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c       |   12 ++--
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c      |   20 ++--
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c       |   18 ++--
 drivers/net/wireless/iwlwifi/iwl-agn-tt.c        |    8 +-
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c           |   98 +++++++++++-----------
 drivers/net/wireless/iwlwifi/iwl-core.c          |   20 ++--
 drivers/net/wireless/iwlwifi/iwl-debugfs.c       |   12 ++--
 drivers/net/wireless/iwlwifi/iwl-dev.h           |    2 +-
 drivers/net/wireless/iwlwifi/iwl-power.c         |    2 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c          |   32 ++++----
 drivers/net/wireless/iwlwifi/iwl-shared.h        |    2 +
 drivers/net/wireless/iwlwifi/iwl-sta.c           |    4 +-
 drivers/net/wireless/iwlwifi/iwl-sv-open.c       |    8 +-
 drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c |    4 +-
 drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c |    2 +-
 16 files changed, 124 insertions(+), 122 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 7ace507..a604baa 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -778,7 +778,7 @@ int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	u8 scan_tx_antennas = hw_params(priv).valid_tx_ant;
 	int ret;
 
-	lockdep_assert_held(&priv->mutex);
+	lockdep_assert_held(&priv->shrd->mutex);
 
 	if (vif)
 		ctx = iwl_rxon_ctx_from_vif(vif);
@@ -1165,7 +1165,7 @@ int iwlagn_txfifo_flush(struct iwl_priv *priv, u16 flush_control)
 
 void iwlagn_dev_txfifo_flush(struct iwl_priv *priv, u16 flush_control)
 {
-	mutex_lock(&priv->mutex);
+	mutex_lock(&priv->shrd->mutex);
 	ieee80211_stop_queues(priv->hw);
 	if (iwlagn_txfifo_flush(priv, IWL_DROP_ALL)) {
 		IWL_ERR(priv, "flush request fail\n");
@@ -1175,7 +1175,7 @@ void iwlagn_dev_txfifo_flush(struct iwl_priv *priv, u16 flush_control)
 	iwlagn_wait_tx_queue_empty(priv);
 done:
 	ieee80211_wake_queues(priv->hw);
-	mutex_unlock(&priv->mutex);
+	mutex_unlock(&priv->shrd->mutex);
 }
 
 /*
@@ -1372,7 +1372,7 @@ void iwlagn_bt_adjust_rssi_monitor(struct iwl_priv *priv, bool rssi_ena)
 	struct iwl_rxon_context *ctx, *found_ctx = NULL;
 	bool found_ap = false;
 
-	lockdep_assert_held(&priv->mutex);
+	lockdep_assert_held(&priv->shrd->mutex);
 
 	/* Check whether AP or GO mode is active. */
 	if (rssi_ena) {
@@ -1485,7 +1485,7 @@ static void iwlagn_bt_traffic_change_work(struct work_struct *work)
 		break;
 	}
 
-	mutex_lock(&priv->mutex);
+	mutex_lock(&priv->shrd->mutex);
 
 	/*
 	 * We can not send command to firmware while scanning. When the scan
@@ -1513,7 +1513,7 @@ static void iwlagn_bt_traffic_change_work(struct work_struct *work)
 	 */
 	iwlagn_bt_coex_rssi_monitor(priv);
 out:
-	mutex_unlock(&priv->mutex);
+	mutex_unlock(&priv->shrd->mutex);
 }
 
 /*
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index fadfc38..f0292fe 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -132,7 +132,7 @@ static void iwlagn_update_qos(struct iwl_priv *priv,
 static int iwlagn_update_beacon(struct iwl_priv *priv,
 				struct ieee80211_vif *vif)
 {
-	lockdep_assert_held(&priv->mutex);
+	lockdep_assert_held(&priv->shrd->mutex);
 
 	dev_kfree_skb(priv->beacon_skb);
 	priv->beacon_skb = ieee80211_beacon_get(priv->hw, vif);
@@ -316,7 +316,7 @@ int iwlagn_set_pan_params(struct iwl_priv *priv)
 
 	BUILD_BUG_ON(NUM_IWL_RXON_CTX != 2);
 
-	lockdep_assert_held(&priv->mutex);
+	lockdep_assert_held(&priv->shrd->mutex);
 
 	ctx_bss = &priv->contexts[IWL_RXON_CTX_BSS];
 	ctx_pan = &priv->contexts[IWL_RXON_CTX_PAN];
@@ -421,7 +421,7 @@ int iwlagn_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 	bool new_assoc = !!(ctx->staging.filter_flags & RXON_FILTER_ASSOC_MSK);
 	int ret;
 
-	lockdep_assert_held(&priv->mutex);
+	lockdep_assert_held(&priv->shrd->mutex);
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->shrd->status))
 		return -EINVAL;
@@ -537,7 +537,7 @@ int iwlagn_mac_config(struct ieee80211_hw *hw, u32 changed)
 
 	IWL_DEBUG_MAC80211(priv, "changed %#x", changed);
 
-	mutex_lock(&priv->mutex);
+	mutex_lock(&priv->shrd->mutex);
 
 	if (unlikely(test_bit(STATUS_SCANNING, &priv->shrd->status))) {
 		IWL_DEBUG_MAC80211(priv, "leave - scanning\n");
@@ -652,7 +652,7 @@ int iwlagn_mac_config(struct ieee80211_hw *hw, u32 changed)
 		iwlagn_commit_rxon(priv, ctx);
 	}
  out:
-	mutex_unlock(&priv->mutex);
+	mutex_unlock(&priv->shrd->mutex);
 	return ret;
 }
 
@@ -667,7 +667,7 @@ static void iwlagn_check_needed_chains(struct iwl_priv *priv,
 	struct ieee80211_sta_ht_cap *ht_cap;
 	bool need_multiple;
 
-	lockdep_assert_held(&priv->mutex);
+	lockdep_assert_held(&priv->shrd->mutex);
 
 	switch (vif->type) {
 	case NL80211_IFTYPE_STATION:
@@ -792,17 +792,17 @@ void iwlagn_bss_info_changed(struct ieee80211_hw *hw,
 	int ret;
 	bool force = false;
 
-	mutex_lock(&priv->mutex);
+	mutex_lock(&priv->shrd->mutex);
 
 	if (unlikely(!iwl_is_ready(priv))) {
 		IWL_DEBUG_MAC80211(priv, "leave - not ready\n");
-		mutex_unlock(&priv->mutex);
+		mutex_unlock(&priv->shrd->mutex);
 		return;
         }
 
 	if (unlikely(!ctx->vif)) {
 		IWL_DEBUG_MAC80211(priv, "leave - vif is NULL\n");
-		mutex_unlock(&priv->mutex);
+		mutex_unlock(&priv->shrd->mutex);
 		return;
 	}
 
@@ -913,7 +913,7 @@ void iwlagn_bss_info_changed(struct ieee80211_hw *hw,
 			IWL_ERR(priv, "Error sending IBSS beacon\n");
 	}
 
-	mutex_unlock(&priv->mutex);
+	mutex_unlock(&priv->shrd->mutex);
 }
 
 void iwlagn_post_scan(struct iwl_priv *priv)
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
index f894bfb..c99e6cc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
@@ -49,7 +49,7 @@ iwl_sta_alloc_lq(struct iwl_priv *priv, struct iwl_rxon_context *ctx, u8 sta_id)
 		return NULL;
 	}
 
-	lockdep_assert_held(&priv->mutex);
+	lockdep_assert_held(&priv->shrd->mutex);
 
 	/* Set up the rate scaling to start at selected rate, fall back
 	 * all the way down to 1M in IEEE order, and then spin on 1M */
@@ -197,7 +197,7 @@ static int iwl_send_static_wepkey_cmd(struct iwl_priv *priv,
 int iwl_restore_default_wep_keys(struct iwl_priv *priv,
 				 struct iwl_rxon_context *ctx)
 {
-	lockdep_assert_held(&priv->mutex);
+	lockdep_assert_held(&priv->shrd->mutex);
 
 	return iwl_send_static_wepkey_cmd(priv, ctx, false);
 }
@@ -208,7 +208,7 @@ int iwl_remove_default_wep_key(struct iwl_priv *priv,
 {
 	int ret;
 
-	lockdep_assert_held(&priv->mutex);
+	lockdep_assert_held(&priv->shrd->mutex);
 
 	IWL_DEBUG_WEP(priv, "Removing default WEP key: idx=%d\n",
 		      keyconf->keyidx);
@@ -232,7 +232,7 @@ int iwl_set_default_wep_key(struct iwl_priv *priv,
 {
 	int ret;
 
-	lockdep_assert_held(&priv->mutex);
+	lockdep_assert_held(&priv->shrd->mutex);
 
 	if (keyconf->keylen != WEP_KEY_LEN_128 &&
 	    keyconf->keylen != WEP_KEY_LEN_64) {
@@ -397,7 +397,7 @@ int iwl_remove_dynamic_key(struct iwl_priv *priv,
 	if (sta_id == IWL_INVALID_STATION)
 		return 0;
 
-	lockdep_assert_held(&priv->mutex);
+	lockdep_assert_held(&priv->shrd->mutex);
 
 	ctx->key_mapping_keys--;
 
@@ -430,7 +430,7 @@ int iwl_set_dynamic_key(struct iwl_priv *priv,
 	if (sta_id == IWL_INVALID_STATION)
 		return -EINVAL;
 
-	lockdep_assert_held(&priv->mutex);
+	lockdep_assert_held(&priv->shrd->mutex);
 
 	keyconf->hw_key_idx = iwl_get_free_ucode_key_offset(priv);
 	if (keyconf->hw_key_idx == WEP_INVALID_OFFSET)
@@ -572,7 +572,7 @@ int iwl_sta_tx_modify_enable_tid(struct iwl_priv *priv, int sta_id, int tid)
 	unsigned long flags;
 	struct iwl_addsta_cmd sta_cmd;
 
-	lockdep_assert_held(&priv->mutex);
+	lockdep_assert_held(&priv->shrd->mutex);
 
 	/* Remove "disable" flag, to enable Tx for this TID */
 	spin_lock_irqsave(&priv->sta_lock, flags);
@@ -592,7 +592,7 @@ int iwl_sta_rx_agg_start(struct iwl_priv *priv, struct ieee80211_sta *sta,
 	int sta_id;
 	struct iwl_addsta_cmd sta_cmd;
 
-	lockdep_assert_held(&priv->mutex);
+	lockdep_assert_held(&priv->shrd->mutex);
 
 	sta_id = iwl_sta_id(sta);
 	if (sta_id == IWL_INVALID_STATION)
@@ -617,7 +617,7 @@ int iwl_sta_rx_agg_stop(struct iwl_priv *priv, struct ieee80211_sta *sta,
 	int sta_id;
 	struct iwl_addsta_cmd sta_cmd;
 
-	lockdep_assert_held(&priv->mutex);
+	lockdep_assert_held(&priv->shrd->mutex);
 
 	sta_id = iwl_sta_id(sta);
 	if (sta_id == IWL_INVALID_STATION) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tt.c b/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
index 44fff5b..03d8389 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
@@ -313,7 +313,7 @@ static void iwl_legacy_tt_handler(struct iwl_priv *priv, s32 temp, bool force)
 			tt->tt_power_mode = IWL_POWER_INDEX_5;
 			break;
 		}
-		mutex_lock(&priv->mutex);
+		mutex_lock(&priv->shrd->mutex);
 		if (old_state == IWL_TI_CT_KILL)
 			clear_bit(STATUS_CT_KILL, &priv->shrd->status);
 		if (tt->state != IWL_TI_CT_KILL &&
@@ -344,7 +344,7 @@ static void iwl_legacy_tt_handler(struct iwl_priv *priv, s32 temp, bool force)
 			IWL_DEBUG_TEMP(priv, "Power Index change to %u\n",
 					tt->tt_power_mode);
 		}
-		mutex_unlock(&priv->mutex);
+		mutex_unlock(&priv->shrd->mutex);
 	}
 }
 
@@ -454,7 +454,7 @@ static void iwl_advance_tt_handler(struct iwl_priv *priv, s32 temp, bool force)
 			 * in case get disabled before */
 			iwl_set_rxon_ht(priv, &priv->current_ht_config);
 		}
-		mutex_lock(&priv->mutex);
+		mutex_lock(&priv->shrd->mutex);
 		if (old_state == IWL_TI_CT_KILL)
 			clear_bit(STATUS_CT_KILL, &priv->shrd->status);
 		if (tt->state != IWL_TI_CT_KILL &&
@@ -489,7 +489,7 @@ static void iwl_advance_tt_handler(struct iwl_priv *priv, s32 temp, bool force)
 				iwl_perform_ct_kill_task(priv, false);
 			}
 		}
-		mutex_unlock(&priv->mutex);
+		mutex_unlock(&priv->shrd->mutex);
 	}
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
index 0fc1237..3717a88 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
@@ -545,7 +545,7 @@ int iwlagn_run_init_ucode(struct iwl_priv *priv)
 	struct iwl_notification_wait calib_wait;
 	int ret;
 
-	lockdep_assert_held(&priv->mutex);
+	lockdep_assert_held(&priv->shrd->mutex);
 
 	/* No init ucode required? Curious, but maybe ok */
 	if (!priv->ucode_init.code.len)
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 6d2c13e..ef60120 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -135,7 +135,7 @@ int iwlagn_send_beacon_cmd(struct iwl_priv *priv)
 	 * beacon contents.
 	 */
 
-	lockdep_assert_held(&priv->mutex);
+	lockdep_assert_held(&priv->shrd->mutex);
 
 	if (!priv->beacon_ctx) {
 		IWL_ERR(priv, "trying to build beacon w/o beacon context!\n");
@@ -209,7 +209,7 @@ static void iwl_bg_beacon_update(struct work_struct *work)
 		container_of(work, struct iwl_priv, beacon_update);
 	struct sk_buff *beacon;
 
-	mutex_lock(&priv->mutex);
+	mutex_lock(&priv->shrd->mutex);
 	if (!priv->beacon_ctx) {
 		IWL_ERR(priv, "updating beacon w/o beacon context!\n");
 		goto out;
@@ -239,7 +239,7 @@ static void iwl_bg_beacon_update(struct work_struct *work)
 
 	iwlagn_send_beacon_cmd(priv);
  out:
-	mutex_unlock(&priv->mutex);
+	mutex_unlock(&priv->shrd->mutex);
 }
 
 static void iwl_bg_bt_runtime_config(struct work_struct *work)
@@ -262,7 +262,7 @@ static void iwl_bg_bt_full_concurrency(struct work_struct *work)
 		container_of(work, struct iwl_priv, bt_full_concurrency);
 	struct iwl_rxon_context *ctx;
 
-	mutex_lock(&priv->mutex);
+	mutex_lock(&priv->shrd->mutex);
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->shrd->status))
 		goto out;
@@ -286,7 +286,7 @@ static void iwl_bg_bt_full_concurrency(struct work_struct *work)
 
 	iwlagn_send_advance_bt_config(priv);
 out:
-	mutex_unlock(&priv->mutex);
+	mutex_unlock(&priv->shrd->mutex);
 }
 
 /**
@@ -1920,9 +1920,9 @@ static void __iwl_down(struct iwl_priv *priv)
 
 static void iwl_down(struct iwl_priv *priv)
 {
-	mutex_lock(&priv->mutex);
+	mutex_lock(&priv->shrd->mutex);
 	__iwl_down(priv);
-	mutex_unlock(&priv->mutex);
+	mutex_unlock(&priv->shrd->mutex);
 
 	iwl_cancel_deferred_work(priv);
 }
@@ -1934,7 +1934,7 @@ static int __iwl_up(struct iwl_priv *priv)
 	struct iwl_rxon_context *ctx;
 	int ret;
 
-	lockdep_assert_held(&priv->mutex);
+	lockdep_assert_held(&priv->shrd->mutex);
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->shrd->status)) {
 		IWL_WARN(priv, "Exit pending; will not bring the NIC up\n");
@@ -1989,11 +1989,11 @@ static void iwl_bg_run_time_calib_work(struct work_struct *work)
 	struct iwl_priv *priv = container_of(work, struct iwl_priv,
 			run_time_calib_work);
 
-	mutex_lock(&priv->mutex);
+	mutex_lock(&priv->shrd->mutex);
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->shrd->status) ||
 	    test_bit(STATUS_SCANNING, &priv->shrd->status)) {
-		mutex_unlock(&priv->mutex);
+		mutex_unlock(&priv->shrd->mutex);
 		return;
 	}
 
@@ -2002,7 +2002,7 @@ static void iwl_bg_run_time_calib_work(struct work_struct *work)
 		iwl_sensitivity_calibration(priv);
 	}
 
-	mutex_unlock(&priv->mutex);
+	mutex_unlock(&priv->shrd->mutex);
 }
 
 static void iwlagn_prepare_restart(struct iwl_priv *priv)
@@ -2014,7 +2014,7 @@ static void iwlagn_prepare_restart(struct iwl_priv *priv)
 	u8 bt_status;
 	bool bt_is_sco;
 
-	lockdep_assert_held(&priv->mutex);
+	lockdep_assert_held(&priv->shrd->mutex);
 
 	for_each_context(priv, ctx)
 		ctx->vif = NULL;
@@ -2052,9 +2052,9 @@ static void iwl_bg_restart(struct work_struct *data)
 		return;
 
 	if (test_and_clear_bit(STATUS_FW_ERROR, &priv->shrd->status)) {
-		mutex_lock(&priv->mutex);
+		mutex_lock(&priv->shrd->mutex);
 		iwlagn_prepare_restart(priv);
-		mutex_unlock(&priv->mutex);
+		mutex_unlock(&priv->shrd->mutex);
 		iwl_cancel_deferred_work(priv);
 		ieee80211_restart_hw(priv->hw);
 	} else {
@@ -2256,9 +2256,9 @@ static int iwlagn_mac_start(struct ieee80211_hw *hw)
 	IWL_DEBUG_MAC80211(priv, "enter\n");
 
 	/* we should be verifying the device is ready to be opened */
-	mutex_lock(&priv->mutex);
+	mutex_lock(&priv->shrd->mutex);
 	ret = __iwl_up(priv);
-	mutex_unlock(&priv->mutex);
+	mutex_unlock(&priv->shrd->mutex);
 	if (ret)
 		return ret;
 
@@ -2351,7 +2351,7 @@ static void iwlagn_mac_set_rekey_data(struct ieee80211_hw *hw,
 	if (iwlagn_mod_params.sw_crypto)
 		return;
 
-	mutex_lock(&priv->mutex);
+	mutex_lock(&priv->shrd->mutex);
 
 	if (priv->contexts[IWL_RXON_CTX_BSS].vif != vif)
 		goto out;
@@ -2362,7 +2362,7 @@ static void iwlagn_mac_set_rekey_data(struct ieee80211_hw *hw,
 	priv->have_rekey_data = true;
 
  out:
-	mutex_unlock(&priv->mutex);
+	mutex_unlock(&priv->shrd->mutex);
 }
 
 struct wowlan_key_data {
@@ -2400,7 +2400,7 @@ static void iwlagn_wowlan_program_keys(struct ieee80211_hw *hw,
 	u16 p1k[IWLAGN_P1K_SIZE];
 	int ret, i;
 
-	mutex_lock(&priv->mutex);
+	mutex_lock(&priv->shrd->mutex);
 
 	if ((key->cipher == WLAN_CIPHER_SUITE_WEP40 ||
 	     key->cipher == WLAN_CIPHER_SUITE_WEP104) &&
@@ -2505,7 +2505,7 @@ static void iwlagn_wowlan_program_keys(struct ieee80211_hw *hw,
 		break;
 	}
 
-	mutex_unlock(&priv->mutex);
+	mutex_unlock(&priv->shrd->mutex);
 }
 
 static int iwlagn_mac_suspend(struct ieee80211_hw *hw,
@@ -2530,7 +2530,7 @@ static int iwlagn_mac_suspend(struct ieee80211_hw *hw,
 	if (WARN_ON(!wowlan))
 		return -EINVAL;
 
-	mutex_lock(&priv->mutex);
+	mutex_lock(&priv->shrd->mutex);
 
 	/* Don't attempt WoWLAN when not associated, tear down instead. */
 	if (!ctx->vif || ctx->vif->type != NL80211_IFTYPE_STATION ||
@@ -2624,11 +2624,11 @@ static int iwlagn_mac_suspend(struct ieee80211_hw *hw,
 		 * constraints. Since we're in the suspend path
 		 * that isn't really a problem though.
 		 */
-		mutex_unlock(&priv->mutex);
+		mutex_unlock(&priv->shrd->mutex);
 		ieee80211_iter_keys(priv->hw, ctx->vif,
 				    iwlagn_wowlan_program_keys,
 				    &key_data);
-		mutex_lock(&priv->mutex);
+		mutex_lock(&priv->shrd->mutex);
 		if (key_data.error) {
 			ret = -EIO;
 			goto error;
@@ -2697,7 +2697,7 @@ static int iwlagn_mac_suspend(struct ieee80211_hw *hw,
 	iwlagn_prepare_restart(priv);
 	ieee80211_restart_hw(priv->hw);
  out:
-	mutex_unlock(&priv->mutex);
+	mutex_unlock(&priv->shrd->mutex);
 	kfree(key_data.rsc_tsc);
 	return ret;
 }
@@ -2711,7 +2711,7 @@ static int iwlagn_mac_resume(struct ieee80211_hw *hw)
 	u32 base, status = 0xffffffff;
 	int ret = -EIO;
 
-	mutex_lock(&priv->mutex);
+	mutex_lock(&priv->shrd->mutex);
 
 	iwl_write32(priv, CSR_UCODE_DRV_GP1_CLR,
 			  CSR_UCODE_DRV_GP1_BIT_D3_CFG_COMPLETE);
@@ -2755,7 +2755,7 @@ static int iwlagn_mac_resume(struct ieee80211_hw *hw)
 	iwl_connection_init_rx_config(priv, ctx);
 	iwlagn_set_rxon_chain(priv, ctx);
 
-	mutex_unlock(&priv->mutex);
+	mutex_unlock(&priv->shrd->mutex);
 
 	ieee80211_resume_disconnect(vif);
 
@@ -2824,7 +2824,7 @@ static int iwlagn_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	if (cmd == DISABLE_KEY && key->hw_key_idx == WEP_INVALID_OFFSET)
 		return 0;
 
-	mutex_lock(&priv->mutex);
+	mutex_lock(&priv->shrd->mutex);
 	iwl_scan_cancel_timeout(priv, 100);
 
 	BUILD_BUG_ON(WEP_INVALID_OFFSET == IWLAGN_HW_KEY_DEFAULT);
@@ -2875,7 +2875,7 @@ static int iwlagn_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		ret = -EINVAL;
 	}
 
-	mutex_unlock(&priv->mutex);
+	mutex_unlock(&priv->shrd->mutex);
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 
 	return ret;
@@ -2897,7 +2897,7 @@ static int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
 	if (!(priv->cfg->sku & EEPROM_SKU_CAP_11N_ENABLE))
 		return -EACCES;
 
-	mutex_lock(&priv->mutex);
+	mutex_lock(&priv->shrd->mutex);
 
 	switch (action) {
 	case IEEE80211_AMPDU_RX_START:
@@ -2988,7 +2988,7 @@ static int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
 		ret = 0;
 		break;
 	}
-	mutex_unlock(&priv->mutex);
+	mutex_unlock(&priv->shrd->mutex);
 
 	return ret;
 }
@@ -3006,7 +3006,7 @@ static int iwlagn_mac_sta_add(struct ieee80211_hw *hw,
 
 	IWL_DEBUG_INFO(priv, "received request to add station %pM\n",
 			sta->addr);
-	mutex_lock(&priv->mutex);
+	mutex_lock(&priv->shrd->mutex);
 	IWL_DEBUG_INFO(priv, "proceeding to add station %pM\n",
 			sta->addr);
 	sta_priv->common.sta_id = IWL_INVALID_STATION;
@@ -3021,7 +3021,7 @@ static int iwlagn_mac_sta_add(struct ieee80211_hw *hw,
 		IWL_ERR(priv, "Unable to add station %pM (%d)\n",
 			sta->addr, ret);
 		/* Should we return success if return code is EEXIST ? */
-		mutex_unlock(&priv->mutex);
+		mutex_unlock(&priv->shrd->mutex);
 		return ret;
 	}
 
@@ -3031,7 +3031,7 @@ static int iwlagn_mac_sta_add(struct ieee80211_hw *hw,
 	IWL_DEBUG_INFO(priv, "Initializing rate scaling for station %pM\n",
 		       sta->addr);
 	iwl_rs_rate_init(priv, sta, sta_id);
-	mutex_unlock(&priv->mutex);
+	mutex_unlock(&priv->shrd->mutex);
 
 	return 0;
 }
@@ -3057,7 +3057,7 @@ static void iwlagn_mac_channel_switch(struct ieee80211_hw *hw,
 
 	IWL_DEBUG_MAC80211(priv, "enter\n");
 
-	mutex_lock(&priv->mutex);
+	mutex_lock(&priv->shrd->mutex);
 
 	if (iwl_is_rfkill(priv))
 		goto out;
@@ -3129,7 +3129,7 @@ static void iwlagn_mac_channel_switch(struct ieee80211_hw *hw,
 	}
 
 out:
-	mutex_unlock(&priv->mutex);
+	mutex_unlock(&priv->shrd->mutex);
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 }
 
@@ -3159,7 +3159,7 @@ static void iwlagn_configure_filter(struct ieee80211_hw *hw,
 
 #undef CHK
 
-	mutex_lock(&priv->mutex);
+	mutex_lock(&priv->shrd->mutex);
 
 	for_each_context(priv, ctx) {
 		ctx->staging.filter_flags &= ~filter_nand;
@@ -3171,7 +3171,7 @@ static void iwlagn_configure_filter(struct ieee80211_hw *hw,
 		 */
 	}
 
-	mutex_unlock(&priv->mutex);
+	mutex_unlock(&priv->shrd->mutex);
 
 	/*
 	 * Receiving all multicast frames is always enabled by the
@@ -3187,7 +3187,7 @@ static void iwlagn_mac_flush(struct ieee80211_hw *hw, bool drop)
 {
 	struct iwl_priv *priv = hw->priv;
 
-	mutex_lock(&priv->mutex);
+	mutex_lock(&priv->shrd->mutex);
 	IWL_DEBUG_MAC80211(priv, "enter\n");
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->shrd->status)) {
@@ -3213,7 +3213,7 @@ static void iwlagn_mac_flush(struct ieee80211_hw *hw, bool drop)
 	IWL_DEBUG_MAC80211(priv, "wait transmit/flush all frames\n");
 	iwlagn_wait_tx_queue_empty(priv);
 done:
-	mutex_unlock(&priv->mutex);
+	mutex_unlock(&priv->shrd->mutex);
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 }
 
@@ -3221,7 +3221,7 @@ void iwlagn_disable_roc(struct iwl_priv *priv)
 {
 	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_PAN];
 
-	lockdep_assert_held(&priv->mutex);
+	lockdep_assert_held(&priv->shrd->mutex);
 
 	if (!priv->hw_roc_setup)
 		return;
@@ -3244,9 +3244,9 @@ static void iwlagn_disable_roc_work(struct work_struct *work)
 	struct iwl_priv *priv = container_of(work, struct iwl_priv,
 					     hw_roc_disable_work.work);
 
-	mutex_lock(&priv->mutex);
+	mutex_lock(&priv->shrd->mutex);
 	iwlagn_disable_roc(priv);
-	mutex_unlock(&priv->mutex);
+	mutex_unlock(&priv->shrd->mutex);
 }
 
 static int iwl_mac_remain_on_channel(struct ieee80211_hw *hw,
@@ -3264,7 +3264,7 @@ static int iwl_mac_remain_on_channel(struct ieee80211_hw *hw,
 	if (!(ctx->interface_modes & BIT(NL80211_IFTYPE_P2P_CLIENT)))
 		return -EOPNOTSUPP;
 
-	mutex_lock(&priv->mutex);
+	mutex_lock(&priv->shrd->mutex);
 
 	/*
 	 * TODO: Remove this hack! Firmware needs to be updated
@@ -3314,7 +3314,7 @@ static int iwl_mac_remain_on_channel(struct ieee80211_hw *hw,
 		iwlagn_disable_roc(priv);
 
  out:
-	mutex_unlock(&priv->mutex);
+	mutex_unlock(&priv->shrd->mutex);
 
 	return err;
 }
@@ -3326,10 +3326,10 @@ static int iwl_mac_cancel_remain_on_channel(struct ieee80211_hw *hw)
 	if (!(priv->valid_contexts & BIT(IWL_RXON_CTX_PAN)))
 		return -EOPNOTSUPP;
 
-	mutex_lock(&priv->mutex);
+	mutex_lock(&priv->shrd->mutex);
 	iwl_scan_cancel_timeout(priv, priv->hw_roc_duration);
 	iwlagn_disable_roc(priv);
-	mutex_unlock(&priv->mutex);
+	mutex_unlock(&priv->shrd->mutex);
 
 	return 0;
 }
@@ -3419,7 +3419,7 @@ static int iwl_init_drv(struct iwl_priv *priv)
 	spin_lock_init(&priv->sta_lock);
 	spin_lock_init(&priv->hcmd_lock);
 
-	mutex_init(&priv->mutex);
+	mutex_init(&priv->shrd->mutex);
 
 	priv->ieee_channels = NULL;
 	priv->ieee_rates = NULL;
@@ -3492,7 +3492,7 @@ static void iwl_mac_rssi_callback(struct ieee80211_hw *hw,
 {
 	struct iwl_priv *priv = hw->priv;
 
-	mutex_lock(&priv->mutex);
+	mutex_lock(&priv->shrd->mutex);
 
 	if (priv->cfg->bt_params &&
 			priv->cfg->bt_params->advanced_bt_coexist) {
@@ -3507,7 +3507,7 @@ static void iwl_mac_rssi_callback(struct ieee80211_hw *hw,
 				"ignoring RSSI callback\n");
 	}
 
-	mutex_unlock(&priv->mutex);
+	mutex_unlock(&priv->shrd->mutex);
 }
 
 struct ieee80211_ops iwlagn_hw_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 40ad889..bf173b6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -325,7 +325,7 @@ int iwl_send_rxon_timing(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 
 	conf = ieee80211_get_hw_conf(priv->hw);
 
-	lockdep_assert_held(&priv->mutex);
+	lockdep_assert_held(&priv->shrd->mutex);
 
 	memset(&ctx->timing, 0, sizeof(struct iwl_rxon_time_cmd));
 
@@ -1069,7 +1069,7 @@ int iwl_set_tx_power(struct iwl_priv *priv, s8 tx_power, bool force)
 	bool defer;
 	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
 
-	lockdep_assert_held(&priv->mutex);
+	lockdep_assert_held(&priv->shrd->mutex);
 
 	if (priv->tx_power_user_lmt == tx_power && !force)
 		return 0;
@@ -1232,7 +1232,7 @@ static int iwl_setup_interface(struct iwl_priv *priv,
 	struct ieee80211_vif *vif = ctx->vif;
 	int err;
 
-	lockdep_assert_held(&priv->mutex);
+	lockdep_assert_held(&priv->shrd->mutex);
 
 	/*
 	 * This variable will be correct only when there's just
@@ -1276,7 +1276,7 @@ int iwl_mac_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 
 	cancel_delayed_work_sync(&priv->hw_roc_disable_work);
 
-	mutex_lock(&priv->mutex);
+	mutex_lock(&priv->shrd->mutex);
 
 	iwlagn_disable_roc(priv);
 
@@ -1323,7 +1323,7 @@ int iwl_mac_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	ctx->vif = NULL;
 	priv->iw_mode = NL80211_IFTYPE_STATION;
  out:
-	mutex_unlock(&priv->mutex);
+	mutex_unlock(&priv->shrd->mutex);
 
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 	return err;
@@ -1335,7 +1335,7 @@ static void iwl_teardown_interface(struct iwl_priv *priv,
 {
 	struct iwl_rxon_context *ctx = iwl_rxon_ctx_from_vif(vif);
 
-	lockdep_assert_held(&priv->mutex);
+	lockdep_assert_held(&priv->shrd->mutex);
 
 	if (priv->scan_vif == vif) {
 		iwl_scan_cancel_timeout(priv, 200);
@@ -1367,14 +1367,14 @@ void iwl_mac_remove_interface(struct ieee80211_hw *hw,
 
 	IWL_DEBUG_MAC80211(priv, "enter\n");
 
-	mutex_lock(&priv->mutex);
+	mutex_lock(&priv->shrd->mutex);
 
 	WARN_ON(ctx->vif != vif);
 	ctx->vif = NULL;
 
 	iwl_teardown_interface(priv, vif, false);
 
-	mutex_unlock(&priv->mutex);
+	mutex_unlock(&priv->shrd->mutex);
 
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 
@@ -1698,7 +1698,7 @@ int iwl_mac_change_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 
 	newtype = ieee80211_iftype_p2p(newtype, newp2p);
 
-	mutex_lock(&priv->mutex);
+	mutex_lock(&priv->shrd->mutex);
 
 	if (!ctx->vif || !iwl_is_ready_rf(priv)) {
 		/*
@@ -1762,7 +1762,7 @@ int iwl_mac_change_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	err = 0;
 
  out:
-	mutex_unlock(&priv->mutex);
+	mutex_unlock(&priv->shrd->mutex);
 	return err;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 8bd8177..0aa8456 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -819,9 +819,9 @@ static ssize_t iwl_dbgfs_sleep_level_override_write(struct file *file,
 
 	priv->power_data.debug_sleep_level_override = value;
 
-	mutex_lock(&priv->mutex);
+	mutex_lock(&priv->shrd->mutex);
 	iwl_power_update_mode(priv, true);
-	mutex_unlock(&priv->mutex);
+	mutex_unlock(&priv->shrd->mutex);
 
 	return count;
 }
@@ -1838,9 +1838,9 @@ static ssize_t iwl_dbgfs_ucode_bt_stats_read(struct file *file,
 		return -EINVAL;
 
 	/* make request to uCode to retrieve statistics information */
-	mutex_lock(&priv->mutex);
+	mutex_lock(&priv->shrd->mutex);
 	ret = iwl_send_statistics_request(priv, CMD_SYNC, false);
-	mutex_unlock(&priv->mutex);
+	mutex_unlock(&priv->shrd->mutex);
 
 	if (ret) {
 		IWL_ERR(priv,
@@ -2231,9 +2231,9 @@ static ssize_t iwl_dbgfs_clear_ucode_statistics_write(struct file *file,
 		return -EFAULT;
 
 	/* make request to uCode to retrieve statistics information */
-	mutex_lock(&priv->mutex);
+	mutex_lock(&priv->shrd->mutex);
 	iwl_send_statistics_request(priv, CMD_SYNC, true);
-	mutex_unlock(&priv->mutex);
+	mutex_unlock(&priv->shrd->mutex);
 
 	return count;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index c60a242..8ba2d94 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1228,8 +1228,8 @@ struct iwl_priv {
 	/* spinlock */
 	spinlock_t hcmd_lock;	/* protect hcmd */
 	spinlock_t reg_lock;	/* protect hw register access */
-	struct mutex mutex;
 
+	/*TODO: remove these pointers - use bus(priv) instead */
 	struct iwl_bus *bus;	/* bus specific data */
 	struct iwl_trans trans;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index 52a6f8a..343317f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -383,7 +383,7 @@ int iwl_power_set_mode(struct iwl_priv *priv, struct iwl_powertable_cmd *cmd,
 	int ret;
 	bool update_chains;
 
-	lockdep_assert_held(&priv->mutex);
+	lockdep_assert_held(&priv->shrd->mutex);
 
 	/* Don't update the RX chain when chain noise calibration is running */
 	update_chains = priv->chain_noise_data.state == IWL_CHAIN_NOISE_DONE ||
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index bc8cb1d..fa100c5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -116,7 +116,7 @@ static void iwl_complete_scan(struct iwl_priv *priv, bool aborted)
 
 void iwl_force_scan_end(struct iwl_priv *priv)
 {
-	lockdep_assert_held(&priv->mutex);
+	lockdep_assert_held(&priv->shrd->mutex);
 
 	if (!test_bit(STATUS_SCANNING, &priv->shrd->status)) {
 		IWL_DEBUG_SCAN(priv, "Forcing scan end while not scanning\n");
@@ -134,7 +134,7 @@ static void iwl_do_scan_abort(struct iwl_priv *priv)
 {
 	int ret;
 
-	lockdep_assert_held(&priv->mutex);
+	lockdep_assert_held(&priv->shrd->mutex);
 
 	if (!test_bit(STATUS_SCANNING, &priv->shrd->status)) {
 		IWL_DEBUG_SCAN(priv, "Not performing scan to abort\n");
@@ -173,7 +173,7 @@ int iwl_scan_cancel_timeout(struct iwl_priv *priv, unsigned long ms)
 {
 	unsigned long timeout = jiffies + msecs_to_jiffies(ms);
 
-	lockdep_assert_held(&priv->mutex);
+	lockdep_assert_held(&priv->shrd->mutex);
 
 	IWL_DEBUG_SCAN(priv, "Scan cancel timeout\n");
 
@@ -358,7 +358,7 @@ int __must_check iwl_scan_initiate(struct iwl_priv *priv,
 {
 	int ret;
 
-	lockdep_assert_held(&priv->mutex);
+	lockdep_assert_held(&priv->shrd->mutex);
 
 	cancel_delayed_work(&priv->scan_check);
 
@@ -413,7 +413,7 @@ int iwl_mac_hw_scan(struct ieee80211_hw *hw,
 	if (req->n_channels == 0)
 		return -EINVAL;
 
-	mutex_lock(&priv->mutex);
+	mutex_lock(&priv->shrd->mutex);
 
 	if (test_bit(STATUS_SCANNING, &priv->shrd->status) &&
 	    priv->scan_type != IWL_SCAN_NORMAL) {
@@ -440,7 +440,7 @@ int iwl_mac_hw_scan(struct ieee80211_hw *hw,
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 
 out_unlock:
-	mutex_unlock(&priv->mutex);
+	mutex_unlock(&priv->shrd->mutex);
 
 	return ret;
 }
@@ -461,7 +461,7 @@ static void iwl_bg_start_internal_scan(struct work_struct *work)
 
 	IWL_DEBUG_SCAN(priv, "Start internal scan\n");
 
-	mutex_lock(&priv->mutex);
+	mutex_lock(&priv->shrd->mutex);
 
 	if (priv->scan_type == IWL_SCAN_RADIO_RESET) {
 		IWL_DEBUG_SCAN(priv, "Internal scan already in progress\n");
@@ -476,7 +476,7 @@ static void iwl_bg_start_internal_scan(struct work_struct *work)
 	if (iwl_scan_initiate(priv, NULL, IWL_SCAN_RADIO_RESET, priv->band))
 		IWL_DEBUG_SCAN(priv, "failed to start internal short scan\n");
  unlock:
-	mutex_unlock(&priv->mutex);
+	mutex_unlock(&priv->shrd->mutex);
 }
 
 static void iwl_bg_scan_check(struct work_struct *data)
@@ -489,9 +489,9 @@ static void iwl_bg_scan_check(struct work_struct *data)
 	/* Since we are here firmware does not finish scan and
 	 * most likely is in bad shape, so we don't bother to
 	 * send abort command, just force scan complete to mac80211 */
-	mutex_lock(&priv->mutex);
+	mutex_lock(&priv->shrd->mutex);
 	iwl_force_scan_end(priv);
-	mutex_unlock(&priv->mutex);
+	mutex_unlock(&priv->shrd->mutex);
 }
 
 /**
@@ -549,9 +549,9 @@ static void iwl_bg_abort_scan(struct work_struct *work)
 
 	/* We keep scan_check work queued in case when firmware will not
 	 * report back scan completed notification */
-	mutex_lock(&priv->mutex);
+	mutex_lock(&priv->shrd->mutex);
 	iwl_scan_cancel_timeout(priv, 200);
-	mutex_unlock(&priv->mutex);
+	mutex_unlock(&priv->shrd->mutex);
 }
 
 static void iwl_bg_scan_completed(struct work_struct *work)
@@ -564,7 +564,7 @@ static void iwl_bg_scan_completed(struct work_struct *work)
 
 	cancel_delayed_work(&priv->scan_check);
 
-	mutex_lock(&priv->mutex);
+	mutex_lock(&priv->shrd->mutex);
 
 	aborted = test_and_clear_bit(STATUS_SCAN_ABORTING, &priv->shrd->status);
 	if (aborted)
@@ -612,7 +612,7 @@ out_settings:
 	iwlagn_post_scan(priv);
 
 out:
-	mutex_unlock(&priv->mutex);
+	mutex_unlock(&priv->shrd->mutex);
 }
 
 void iwl_setup_scan_deferred_work(struct iwl_priv *priv)
@@ -630,8 +630,8 @@ void iwl_cancel_scan_deferred_work(struct iwl_priv *priv)
 	cancel_work_sync(&priv->scan_completed);
 
 	if (cancel_delayed_work_sync(&priv->scan_check)) {
-		mutex_lock(&priv->mutex);
+		mutex_lock(&priv->shrd->mutex);
 		iwl_force_scan_end(priv);
-		mutex_unlock(&priv->mutex);
+		mutex_unlock(&priv->shrd->mutex);
 	}
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 1c2c31c..3395319 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -150,6 +150,7 @@ struct iwl_hw_params {
  * @hw_params: see struct iwl_hw_params
  * @workqueue: the workqueue used by all the layers of the driver
  * @lock: protect general shared data
+ * @mutex:
  */
 struct iwl_shared {
 #ifdef CONFIG_IWLWIFI_DEBUG
@@ -165,6 +166,7 @@ struct iwl_shared {
 
 	struct workqueue_struct *workqueue;
 	spinlock_t lock;
+	struct mutex mutex;
 };
 
 /*Whatever _m is (iwl_trans, iwl_priv, iwl_bus, these macros will work */
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index b5b0ff3..63b434b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -821,13 +821,13 @@ int iwl_mac_sta_remove(struct ieee80211_hw *hw,
 
 	IWL_DEBUG_INFO(priv, "received request to remove station %pM\n",
 			sta->addr);
-	mutex_lock(&priv->mutex);
+	mutex_lock(&priv->shrd->mutex);
 	IWL_DEBUG_INFO(priv, "proceeding to remove station %pM\n",
 			sta->addr);
 	ret = iwl_remove_station(priv, sta_common->sta_id, sta->addr);
 	if (ret)
 		IWL_ERR(priv, "Error removing station %pM\n",
 			sta->addr);
-	mutex_unlock(&priv->mutex);
+	mutex_unlock(&priv->shrd->mutex);
 	return ret;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-sv-open.c b/drivers/net/wireless/iwlwifi/iwl-sv-open.c
index b11f60d..ac751fa 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sv-open.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sv-open.c
@@ -661,7 +661,7 @@ int iwl_testmode_cmd(struct ieee80211_hw *hw, void *data, int len)
 		return -ENOMSG;
 	}
 	/* in case multiple accesses to the device happens */
-	mutex_lock(&priv->mutex);
+	mutex_lock(&priv->shrd->mutex);
 
 	switch (nla_get_u32(tb[IWL_TM_ATTR_COMMAND])) {
 	case IWL_TM_CMD_APP2DEV_UCODE:
@@ -702,7 +702,7 @@ int iwl_testmode_cmd(struct ieee80211_hw *hw, void *data, int len)
 		break;
 	}
 
-	mutex_unlock(&priv->mutex);
+	mutex_unlock(&priv->shrd->mutex);
 	return result;
 }
 
@@ -738,7 +738,7 @@ int iwl_testmode_dump(struct ieee80211_hw *hw, struct sk_buff *skb,
 	}
 
 	/* in case multiple accesses to the device happens */
-	mutex_lock(&priv->mutex);
+	mutex_lock(&priv->shrd->mutex);
 	switch (cmd) {
 	case IWL_TM_CMD_APP2DEV_READ_TRACE:
 		IWL_DEBUG_INFO(priv, "uCode trace cmd to driver\n");
@@ -749,6 +749,6 @@ int iwl_testmode_dump(struct ieee80211_hw *hw, struct sk_buff *skb,
 		break;
 	}
 
-	mutex_unlock(&priv->mutex);
+	mutex_unlock(&priv->shrd->mutex);
 	return result;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c
index 26497dd..9c4bf8c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c
@@ -349,9 +349,9 @@ void iwl_bg_rx_replenish(struct work_struct *data)
 	if (test_bit(STATUS_EXIT_PENDING, &priv->shrd->status))
 		return;
 
-	mutex_lock(&priv->mutex);
+	mutex_lock(&priv->shrd->mutex);
 	iwlagn_rx_replenish(priv);
-	mutex_unlock(&priv->mutex);
+	mutex_unlock(&priv->shrd->mutex);
 }
 
 /**
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
index 61e17dd..e1130a7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
@@ -934,7 +934,7 @@ static int iwl_send_cmd_sync(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	int cmd_idx;
 	int ret;
 
-	lockdep_assert_held(&priv->mutex);
+	lockdep_assert_held(&priv->shrd->mutex);
 
 	 /* A synchronous command can not have a callback set. */
 	if (WARN_ON(cmd->callback))
-- 
1.7.0.4

