Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:64658 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031475Ab2CFWnc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Mar 2012 17:43:32 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH RESEND 07/33] iwlwifi: move mutex out of shared
Date: Tue,  6 Mar 2012 13:30:42 -0800
Message-Id: <1331069468-11074-8-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120306_234437_522560_FA93ADAC)
In-Reply-To: <1331069468-11074-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1331069468-11074-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Now the mutex no longer needs to be
shared, so move it into iwl_priv.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |   20 +++---
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |   20 +++---
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c  |   18 +++---
 drivers/net/wireless/iwlwifi/iwl-agn-tt.c   |    8 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   32 +++++-----
 drivers/net/wireless/iwlwifi/iwl-core.c     |    4 +-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c  |   12 ++--
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    2 +
 drivers/net/wireless/iwlwifi/iwl-mac80211.c |   82 +++++++++++++-------------
 drivers/net/wireless/iwlwifi/iwl-power.c    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c     |   32 +++++-----
 drivers/net/wireless/iwlwifi/iwl-shared.h   |    4 -
 drivers/net/wireless/iwlwifi/iwl-testmode.c |    8 +-
 drivers/net/wireless/iwlwifi/iwl-ucode.c    |    2 +-
 14 files changed, 122 insertions(+), 124 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 238f824..90f1f8a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -246,7 +246,7 @@ int iwlagn_txfifo_flush(struct iwl_priv *priv, u16 flush_control)
 
 void iwlagn_dev_txfifo_flush(struct iwl_priv *priv, u16 flush_control)
 {
-	mutex_lock(&priv->shrd->mutex);
+	mutex_lock(&priv->mutex);
 	ieee80211_stop_queues(priv->hw);
 	if (iwlagn_txfifo_flush(priv, IWL_DROP_ALL)) {
 		IWL_ERR(priv, "flush request fail\n");
@@ -256,7 +256,7 @@ void iwlagn_dev_txfifo_flush(struct iwl_priv *priv, u16 flush_control)
 	iwl_trans_wait_tx_queue_empty(trans(priv));
 done:
 	ieee80211_wake_queues(priv->hw);
-	mutex_unlock(&priv->shrd->mutex);
+	mutex_unlock(&priv->mutex);
 }
 
 /*
@@ -453,7 +453,7 @@ void iwlagn_bt_adjust_rssi_monitor(struct iwl_priv *priv, bool rssi_ena)
 	struct iwl_rxon_context *ctx, *found_ctx = NULL;
 	bool found_ap = false;
 
-	lockdep_assert_held(&priv->shrd->mutex);
+	lockdep_assert_held(&priv->mutex);
 
 	/* Check whether AP or GO mode is active. */
 	if (rssi_ena) {
@@ -566,7 +566,7 @@ static void iwlagn_bt_traffic_change_work(struct work_struct *work)
 		break;
 	}
 
-	mutex_lock(&priv->shrd->mutex);
+	mutex_lock(&priv->mutex);
 
 	/*
 	 * We can not send command to firmware while scanning. When the scan
@@ -594,7 +594,7 @@ static void iwlagn_bt_traffic_change_work(struct work_struct *work)
 	 */
 	iwlagn_bt_coex_rssi_monitor(priv);
 out:
-	mutex_unlock(&priv->shrd->mutex);
+	mutex_unlock(&priv->mutex);
 }
 
 /*
@@ -969,7 +969,7 @@ static void iwlagn_wowlan_program_keys(struct ieee80211_hw *hw,
 	u16 p1k[IWLAGN_P1K_SIZE];
 	int ret, i;
 
-	mutex_lock(&priv->shrd->mutex);
+	mutex_lock(&priv->mutex);
 
 	if ((key->cipher == WLAN_CIPHER_SUITE_WEP40 ||
 	     key->cipher == WLAN_CIPHER_SUITE_WEP104) &&
@@ -1075,7 +1075,7 @@ static void iwlagn_wowlan_program_keys(struct ieee80211_hw *hw,
 		break;
 	}
 
-	mutex_unlock(&priv->shrd->mutex);
+	mutex_unlock(&priv->mutex);
 }
 
 int iwlagn_send_patterns(struct iwl_priv *priv,
@@ -1222,11 +1222,11 @@ int iwlagn_suspend(struct iwl_priv *priv,
 		 * constraints. Since we're in the suspend path
 		 * that isn't really a problem though.
 		 */
-		mutex_unlock(&priv->shrd->mutex);
+		mutex_unlock(&priv->mutex);
 		ieee80211_iter_keys(priv->hw, ctx->vif,
 				    iwlagn_wowlan_program_keys,
 				    &key_data);
-		mutex_lock(&priv->shrd->mutex);
+		mutex_lock(&priv->mutex);
 		if (key_data.error) {
 			ret = -EIO;
 			goto out;
@@ -1304,7 +1304,7 @@ int iwl_dvm_send_cmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	 * (or more) synchronous commands at a time.
 	 */
 	if (cmd->flags & CMD_SYNC)
-		lockdep_assert_held(&priv->shrd->mutex);
+		lockdep_assert_held(&priv->mutex);
 
 	return iwl_trans_send_cmd(trans(priv), cmd);
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index 53114db..2c5e7ec 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -131,7 +131,7 @@ static void iwlagn_update_qos(struct iwl_priv *priv,
 static int iwlagn_update_beacon(struct iwl_priv *priv,
 				struct ieee80211_vif *vif)
 {
-	lockdep_assert_held(&priv->shrd->mutex);
+	lockdep_assert_held(&priv->mutex);
 
 	dev_kfree_skb(priv->beacon_skb);
 	priv->beacon_skb = ieee80211_beacon_get(priv->hw, vif);
@@ -313,7 +313,7 @@ int iwlagn_set_pan_params(struct iwl_priv *priv)
 
 	BUILD_BUG_ON(NUM_IWL_RXON_CTX != 2);
 
-	lockdep_assert_held(&priv->shrd->mutex);
+	lockdep_assert_held(&priv->mutex);
 
 	ctx_bss = &priv->contexts[IWL_RXON_CTX_BSS];
 	ctx_pan = &priv->contexts[IWL_RXON_CTX_PAN];
@@ -418,7 +418,7 @@ int iwlagn_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 	bool new_assoc = !!(ctx->staging.filter_flags & RXON_FILTER_ASSOC_MSK);
 	int ret;
 
-	lockdep_assert_held(&priv->shrd->mutex);
+	lockdep_assert_held(&priv->mutex);
 
 	if (!iwl_is_alive(priv->shrd))
 		return -EBUSY;
@@ -549,7 +549,7 @@ int iwlagn_mac_config(struct ieee80211_hw *hw, u32 changed)
 
 	IWL_DEBUG_MAC80211(priv, "enter: changed %#x", changed);
 
-	mutex_lock(&priv->shrd->mutex);
+	mutex_lock(&priv->mutex);
 
 	if (unlikely(test_bit(STATUS_SCANNING, &priv->shrd->status))) {
 		IWL_DEBUG_MAC80211(priv, "leave - scanning\n");
@@ -650,7 +650,7 @@ int iwlagn_mac_config(struct ieee80211_hw *hw, u32 changed)
 		iwlagn_commit_rxon(priv, ctx);
 	}
  out:
-	mutex_unlock(&priv->shrd->mutex);
+	mutex_unlock(&priv->mutex);
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 
 	return ret;
@@ -667,7 +667,7 @@ static void iwlagn_check_needed_chains(struct iwl_priv *priv,
 	struct ieee80211_sta_ht_cap *ht_cap;
 	bool need_multiple;
 
-	lockdep_assert_held(&priv->shrd->mutex);
+	lockdep_assert_held(&priv->mutex);
 
 	switch (vif->type) {
 	case NL80211_IFTYPE_STATION:
@@ -792,17 +792,17 @@ void iwlagn_bss_info_changed(struct ieee80211_hw *hw,
 	int ret;
 	bool force = false;
 
-	mutex_lock(&priv->shrd->mutex);
+	mutex_lock(&priv->mutex);
 
 	if (unlikely(!iwl_is_ready(priv->shrd))) {
 		IWL_DEBUG_MAC80211(priv, "leave - not ready\n");
-		mutex_unlock(&priv->shrd->mutex);
+		mutex_unlock(&priv->mutex);
 		return;
         }
 
 	if (unlikely(!ctx->vif)) {
 		IWL_DEBUG_MAC80211(priv, "leave - vif is NULL\n");
-		mutex_unlock(&priv->shrd->mutex);
+		mutex_unlock(&priv->mutex);
 		return;
 	}
 
@@ -931,7 +931,7 @@ void iwlagn_bss_info_changed(struct ieee80211_hw *hw,
 			IWL_ERR(priv, "Error sending IBSS beacon\n");
 	}
 
-	mutex_unlock(&priv->shrd->mutex);
+	mutex_unlock(&priv->mutex);
 }
 
 void iwlagn_post_scan(struct iwl_priv *priv)
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
index 73a25f4..14fbdec 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
@@ -811,7 +811,7 @@ void iwl_sta_fill_lq(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 	u32 rate_flags = 0;
 	__le32 rate_n_flags;
 
-	lockdep_assert_held(&priv->shrd->mutex);
+	lockdep_assert_held(&priv->mutex);
 
 	memset(link_cmd, 0, sizeof(*link_cmd));
 
@@ -978,7 +978,7 @@ static int iwl_send_static_wepkey_cmd(struct iwl_priv *priv,
 int iwl_restore_default_wep_keys(struct iwl_priv *priv,
 				 struct iwl_rxon_context *ctx)
 {
-	lockdep_assert_held(&priv->shrd->mutex);
+	lockdep_assert_held(&priv->mutex);
 
 	return iwl_send_static_wepkey_cmd(priv, ctx, false);
 }
@@ -989,7 +989,7 @@ int iwl_remove_default_wep_key(struct iwl_priv *priv,
 {
 	int ret;
 
-	lockdep_assert_held(&priv->shrd->mutex);
+	lockdep_assert_held(&priv->mutex);
 
 	IWL_DEBUG_WEP(priv, "Removing default WEP key: idx=%d\n",
 		      keyconf->keyidx);
@@ -1014,7 +1014,7 @@ int iwl_set_default_wep_key(struct iwl_priv *priv,
 {
 	int ret;
 
-	lockdep_assert_held(&priv->shrd->mutex);
+	lockdep_assert_held(&priv->mutex);
 
 	if (keyconf->keylen != WEP_KEY_LEN_128 &&
 	    keyconf->keylen != WEP_KEY_LEN_64) {
@@ -1166,7 +1166,7 @@ int iwl_remove_dynamic_key(struct iwl_priv *priv,
 	if (sta_id == IWL_INVALID_STATION)
 		return 0;
 
-	lockdep_assert_held(&priv->shrd->mutex);
+	lockdep_assert_held(&priv->mutex);
 
 	ctx->key_mapping_keys--;
 
@@ -1206,7 +1206,7 @@ int iwl_set_dynamic_key(struct iwl_priv *priv,
 	if (sta_id == IWL_INVALID_STATION)
 		return -EINVAL;
 
-	lockdep_assert_held(&priv->shrd->mutex);
+	lockdep_assert_held(&priv->mutex);
 
 	keyconf->hw_key_idx = iwl_get_free_ucode_key_offset(priv);
 	if (keyconf->hw_key_idx == WEP_INVALID_OFFSET)
@@ -1340,7 +1340,7 @@ int iwl_sta_tx_modify_enable_tid(struct iwl_priv *priv, int sta_id, int tid)
 {
 	struct iwl_addsta_cmd sta_cmd;
 
-	lockdep_assert_held(&priv->shrd->mutex);
+	lockdep_assert_held(&priv->mutex);
 
 	/* Remove "disable" flag, to enable Tx for this TID */
 	spin_lock_bh(&priv->sta_lock);
@@ -1359,7 +1359,7 @@ int iwl_sta_rx_agg_start(struct iwl_priv *priv, struct ieee80211_sta *sta,
 	int sta_id;
 	struct iwl_addsta_cmd sta_cmd;
 
-	lockdep_assert_held(&priv->shrd->mutex);
+	lockdep_assert_held(&priv->mutex);
 
 	sta_id = iwl_sta_id(sta);
 	if (sta_id == IWL_INVALID_STATION)
@@ -1383,7 +1383,7 @@ int iwl_sta_rx_agg_stop(struct iwl_priv *priv, struct ieee80211_sta *sta,
 	int sta_id;
 	struct iwl_addsta_cmd sta_cmd;
 
-	lockdep_assert_held(&priv->shrd->mutex);
+	lockdep_assert_held(&priv->mutex);
 
 	sta_id = iwl_sta_id(sta);
 	if (sta_id == IWL_INVALID_STATION) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tt.c b/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
index 56d7c0e..85fe590 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
@@ -310,7 +310,7 @@ static void iwl_legacy_tt_handler(struct iwl_priv *priv, s32 temp, bool force)
 			tt->tt_power_mode = IWL_POWER_INDEX_5;
 			break;
 		}
-		mutex_lock(&priv->shrd->mutex);
+		mutex_lock(&priv->mutex);
 		if (old_state == IWL_TI_CT_KILL)
 			clear_bit(STATUS_CT_KILL, &priv->shrd->status);
 		if (tt->state != IWL_TI_CT_KILL &&
@@ -341,7 +341,7 @@ static void iwl_legacy_tt_handler(struct iwl_priv *priv, s32 temp, bool force)
 			IWL_DEBUG_TEMP(priv, "Power Index change to %u\n",
 					tt->tt_power_mode);
 		}
-		mutex_unlock(&priv->shrd->mutex);
+		mutex_unlock(&priv->mutex);
 	}
 }
 
@@ -451,7 +451,7 @@ static void iwl_advance_tt_handler(struct iwl_priv *priv, s32 temp, bool force)
 			 * in case get disabled before */
 			iwl_set_rxon_ht(priv, &priv->current_ht_config);
 		}
-		mutex_lock(&priv->shrd->mutex);
+		mutex_lock(&priv->mutex);
 		if (old_state == IWL_TI_CT_KILL)
 			clear_bit(STATUS_CT_KILL, &priv->shrd->status);
 		if (tt->state != IWL_TI_CT_KILL &&
@@ -486,7 +486,7 @@ static void iwl_advance_tt_handler(struct iwl_priv *priv, s32 temp, bool force)
 				iwl_perform_ct_kill_task(priv, false);
 			}
 		}
-		mutex_unlock(&priv->shrd->mutex);
+		mutex_unlock(&priv->mutex);
 	}
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 3f59a77..863c27e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -132,7 +132,7 @@ int iwlagn_send_beacon_cmd(struct iwl_priv *priv)
 	 * beacon contents.
 	 */
 
-	lockdep_assert_held(&priv->shrd->mutex);
+	lockdep_assert_held(&priv->mutex);
 
 	if (!priv->beacon_ctx) {
 		IWL_ERR(priv, "trying to build beacon w/o beacon context!\n");
@@ -206,7 +206,7 @@ static void iwl_bg_beacon_update(struct work_struct *work)
 		container_of(work, struct iwl_priv, beacon_update);
 	struct sk_buff *beacon;
 
-	mutex_lock(&priv->shrd->mutex);
+	mutex_lock(&priv->mutex);
 	if (!priv->beacon_ctx) {
 		IWL_ERR(priv, "updating beacon w/o beacon context!\n");
 		goto out;
@@ -236,7 +236,7 @@ static void iwl_bg_beacon_update(struct work_struct *work)
 
 	iwlagn_send_beacon_cmd(priv);
  out:
-	mutex_unlock(&priv->shrd->mutex);
+	mutex_unlock(&priv->mutex);
 }
 
 static void iwl_bg_bt_runtime_config(struct work_struct *work)
@@ -259,7 +259,7 @@ static void iwl_bg_bt_full_concurrency(struct work_struct *work)
 		container_of(work, struct iwl_priv, bt_full_concurrency);
 	struct iwl_rxon_context *ctx;
 
-	mutex_lock(&priv->shrd->mutex);
+	mutex_lock(&priv->mutex);
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->shrd->status))
 		goto out;
@@ -283,7 +283,7 @@ static void iwl_bg_bt_full_concurrency(struct work_struct *work)
 
 	iwlagn_send_advance_bt_config(priv);
 out:
-	mutex_unlock(&priv->shrd->mutex);
+	mutex_unlock(&priv->mutex);
 }
 
 /**
@@ -774,7 +774,7 @@ void iwl_down(struct iwl_priv *priv)
 
 	IWL_DEBUG_INFO(priv, DRV_NAME " is going down\n");
 
-	lockdep_assert_held(&priv->shrd->mutex);
+	lockdep_assert_held(&priv->mutex);
 
 	iwl_scan_cancel_timeout(priv, 200);
 
@@ -844,11 +844,11 @@ static void iwl_bg_run_time_calib_work(struct work_struct *work)
 	struct iwl_priv *priv = container_of(work, struct iwl_priv,
 			run_time_calib_work);
 
-	mutex_lock(&priv->shrd->mutex);
+	mutex_lock(&priv->mutex);
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->shrd->status) ||
 	    test_bit(STATUS_SCANNING, &priv->shrd->status)) {
-		mutex_unlock(&priv->shrd->mutex);
+		mutex_unlock(&priv->mutex);
 		return;
 	}
 
@@ -857,7 +857,7 @@ static void iwl_bg_run_time_calib_work(struct work_struct *work)
 		iwl_sensitivity_calibration(priv);
 	}
 
-	mutex_unlock(&priv->shrd->mutex);
+	mutex_unlock(&priv->mutex);
 }
 
 void iwlagn_prepare_restart(struct iwl_priv *priv)
@@ -869,7 +869,7 @@ void iwlagn_prepare_restart(struct iwl_priv *priv)
 	u8 bt_status;
 	bool bt_is_sco;
 
-	lockdep_assert_held(&priv->shrd->mutex);
+	lockdep_assert_held(&priv->mutex);
 
 	for_each_context(priv, ctx)
 		ctx->vif = NULL;
@@ -907,9 +907,9 @@ static void iwl_bg_restart(struct work_struct *data)
 		return;
 
 	if (test_and_clear_bit(STATUS_FW_ERROR, &priv->shrd->status)) {
-		mutex_lock(&priv->shrd->mutex);
+		mutex_lock(&priv->mutex);
 		iwlagn_prepare_restart(priv);
-		mutex_unlock(&priv->shrd->mutex);
+		mutex_unlock(&priv->mutex);
 		iwl_cancel_deferred_work(priv);
 		ieee80211_restart_hw(priv->hw);
 	} else {
@@ -924,7 +924,7 @@ void iwlagn_disable_roc(struct iwl_priv *priv)
 {
 	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_PAN];
 
-	lockdep_assert_held(&priv->shrd->mutex);
+	lockdep_assert_held(&priv->mutex);
 
 	if (!priv->hw_roc_setup)
 		return;
@@ -947,9 +947,9 @@ static void iwlagn_disable_roc_work(struct work_struct *work)
 	struct iwl_priv *priv = container_of(work, struct iwl_priv,
 					     hw_roc_disable_work.work);
 
-	mutex_lock(&priv->shrd->mutex);
+	mutex_lock(&priv->mutex);
 	iwlagn_disable_roc(priv);
-	mutex_unlock(&priv->shrd->mutex);
+	mutex_unlock(&priv->mutex);
 }
 
 /*****************************************************************************
@@ -1036,7 +1036,7 @@ static int iwl_init_drv(struct iwl_priv *priv)
 
 	spin_lock_init(&priv->sta_lock);
 
-	mutex_init(&priv->shrd->mutex);
+	mutex_init(&priv->mutex);
 
 	INIT_LIST_HEAD(&priv->calib_results);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 26b7c68..88842de 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -316,7 +316,7 @@ int iwl_send_rxon_timing(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 
 	conf = &priv->hw->conf;
 
-	lockdep_assert_held(&priv->shrd->mutex);
+	lockdep_assert_held(&priv->mutex);
 
 	memset(&ctx->timing, 0, sizeof(struct iwl_rxon_time_cmd));
 
@@ -892,7 +892,7 @@ int iwl_set_tx_power(struct iwl_priv *priv, s8 tx_power, bool force)
 	bool defer;
 	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
 
-	lockdep_assert_held(&priv->shrd->mutex);
+	lockdep_assert_held(&priv->mutex);
 
 	if (priv->tx_power_user_lmt == tx_power && !force)
 		return 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index bc3e267..b9b6d62 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -761,9 +761,9 @@ static ssize_t iwl_dbgfs_sleep_level_override_write(struct file *file,
 
 	priv->power_data.debug_sleep_level_override = value;
 
-	mutex_lock(&priv->shrd->mutex);
+	mutex_lock(&priv->mutex);
 	iwl_power_update_mode(priv, true);
-	mutex_unlock(&priv->shrd->mutex);
+	mutex_unlock(&priv->mutex);
 
 	return count;
 }
@@ -1708,9 +1708,9 @@ static ssize_t iwl_dbgfs_ucode_bt_stats_read(struct file *file,
 		return -EINVAL;
 
 	/* make request to uCode to retrieve statistics information */
-	mutex_lock(&priv->shrd->mutex);
+	mutex_lock(&priv->mutex);
 	ret = iwl_send_statistics_request(priv, CMD_SYNC, false);
-	mutex_unlock(&priv->shrd->mutex);
+	mutex_unlock(&priv->mutex);
 
 	if (ret) {
 		IWL_ERR(priv,
@@ -2106,9 +2106,9 @@ static ssize_t iwl_dbgfs_clear_ucode_statistics_write(struct file *file,
 		return -EFAULT;
 
 	/* make request to uCode to retrieve statistics information */
-	mutex_lock(&priv->shrd->mutex);
+	mutex_lock(&priv->mutex);
 	iwl_send_statistics_request(priv, CMD_SYNC, true);
-	mutex_unlock(&priv->shrd->mutex);
+	mutex_unlock(&priv->mutex);
 
 	return count;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 4def9f9..73acbab 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -36,6 +36,7 @@
 #include <linux/wait.h>
 #include <linux/leds.h>
 #include <linux/slab.h>
+#include <linux/mutex.h>
 #include <net/ieee80211_radiotap.h>
 
 #include "iwl-eeprom.h"
@@ -718,6 +719,7 @@ struct iwl_priv {
 	const struct iwl_fw *fw;
 
 	spinlock_t sta_lock;
+	struct mutex mutex;
 
 	/* ieee device used by generic ieee processing code */
 	struct ieee80211_hw *hw;
diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
index 3c9a8fa..3086176 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -261,7 +261,7 @@ static int __iwl_up(struct iwl_priv *priv)
 	struct iwl_rxon_context *ctx;
 	int ret;
 
-	lockdep_assert_held(&priv->shrd->mutex);
+	lockdep_assert_held(&priv->mutex);
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->shrd->status)) {
 		IWL_WARN(priv, "Exit pending; will not bring the NIC up\n");
@@ -310,9 +310,9 @@ static int iwlagn_mac_start(struct ieee80211_hw *hw)
 	IWL_DEBUG_MAC80211(priv, "enter\n");
 
 	/* we should be verifying the device is ready to be opened */
-	mutex_lock(&priv->shrd->mutex);
+	mutex_lock(&priv->mutex);
 	ret = __iwl_up(priv);
-	mutex_unlock(&priv->shrd->mutex);
+	mutex_unlock(&priv->mutex);
 	if (ret)
 		return ret;
 
@@ -340,9 +340,9 @@ static void iwlagn_mac_stop(struct ieee80211_hw *hw)
 
 	priv->is_open = 0;
 
-	mutex_lock(&priv->shrd->mutex);
+	mutex_lock(&priv->mutex);
 	iwl_down(priv);
-	mutex_unlock(&priv->shrd->mutex);
+	mutex_unlock(&priv->mutex);
 
 	iwl_cancel_deferred_work(priv);
 
@@ -367,7 +367,7 @@ static void iwlagn_mac_set_rekey_data(struct ieee80211_hw *hw,
 		return;
 
 	IWL_DEBUG_MAC80211(priv, "enter\n");
-	mutex_lock(&priv->shrd->mutex);
+	mutex_lock(&priv->mutex);
 
 	if (priv->contexts[IWL_RXON_CTX_BSS].vif != vif)
 		goto out;
@@ -379,7 +379,7 @@ static void iwlagn_mac_set_rekey_data(struct ieee80211_hw *hw,
 	priv->have_rekey_data = true;
 
  out:
-	mutex_unlock(&priv->shrd->mutex);
+	mutex_unlock(&priv->mutex);
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 }
 
@@ -396,7 +396,7 @@ static int iwlagn_mac_suspend(struct ieee80211_hw *hw,
 		return -EINVAL;
 
 	IWL_DEBUG_MAC80211(priv, "enter\n");
-	mutex_lock(&priv->shrd->mutex);
+	mutex_lock(&priv->mutex);
 
 	/* Don't attempt WoWLAN when not associated, tear down instead. */
 	if (!ctx->vif || ctx->vif->type != NL80211_IFTYPE_STATION ||
@@ -420,7 +420,7 @@ static int iwlagn_mac_suspend(struct ieee80211_hw *hw,
 	iwlagn_prepare_restart(priv);
 	ieee80211_restart_hw(priv->hw);
  out:
-	mutex_unlock(&priv->shrd->mutex);
+	mutex_unlock(&priv->mutex);
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 
 	return ret;
@@ -436,7 +436,7 @@ static int iwlagn_mac_resume(struct ieee80211_hw *hw)
 	int ret = -EIO;
 
 	IWL_DEBUG_MAC80211(priv, "enter\n");
-	mutex_lock(&priv->shrd->mutex);
+	mutex_lock(&priv->mutex);
 
 	iwl_write32(trans(priv), CSR_UCODE_DRV_GP1_CLR,
 			  CSR_UCODE_DRV_GP1_BIT_D3_CFG_COMPLETE);
@@ -481,7 +481,7 @@ static int iwlagn_mac_resume(struct ieee80211_hw *hw)
 	iwl_connection_init_rx_config(priv, ctx);
 	iwlagn_set_rxon_chain(priv, ctx);
 
-	mutex_unlock(&priv->shrd->mutex);
+	mutex_unlock(&priv->mutex);
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 
 	ieee80211_resume_disconnect(vif);
@@ -559,7 +559,7 @@ static int iwlagn_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	if (cmd == DISABLE_KEY && key->hw_key_idx == WEP_INVALID_OFFSET)
 		return 0;
 
-	mutex_lock(&priv->shrd->mutex);
+	mutex_lock(&priv->mutex);
 	iwl_scan_cancel_timeout(priv, 100);
 
 	BUILD_BUG_ON(WEP_INVALID_OFFSET == IWLAGN_HW_KEY_DEFAULT);
@@ -610,7 +610,7 @@ static int iwlagn_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		ret = -EINVAL;
 	}
 
-	mutex_unlock(&priv->shrd->mutex);
+	mutex_unlock(&priv->mutex);
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 
 	return ret;
@@ -633,7 +633,7 @@ static int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
 		return -EACCES;
 
 	IWL_DEBUG_MAC80211(priv, "enter\n");
-	mutex_lock(&priv->shrd->mutex);
+	mutex_lock(&priv->mutex);
 
 	switch (action) {
 	case IEEE80211_AMPDU_RX_START:
@@ -675,7 +675,7 @@ static int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
 		ret = iwlagn_tx_agg_oper(priv, vif, sta, tid, buf_size);
 		break;
 	}
-	mutex_unlock(&priv->shrd->mutex);
+	mutex_unlock(&priv->mutex);
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 	return ret;
 }
@@ -746,7 +746,7 @@ static int iwlagn_mac_sta_state(struct ieee80211_hw *hw,
 	IWL_DEBUG_MAC80211(priv, "station %pM state change %d->%d\n",
 			   sta->addr, old_state, new_state);
 
-	mutex_lock(&priv->shrd->mutex);
+	mutex_lock(&priv->mutex);
 	if (vif->type == NL80211_IFTYPE_STATION) {
 		if (old_state == IEEE80211_STA_NOTEXIST &&
 		    new_state == IEEE80211_STA_NONE)
@@ -807,7 +807,7 @@ static int iwlagn_mac_sta_state(struct ieee80211_hw *hw,
 	if (iwl_is_rfkill(priv->shrd))
 		ret = 0;
 
-	mutex_unlock(&priv->shrd->mutex);
+	mutex_unlock(&priv->mutex);
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 
 	return ret;
@@ -834,7 +834,7 @@ static void iwlagn_mac_channel_switch(struct ieee80211_hw *hw,
 
 	IWL_DEBUG_MAC80211(priv, "enter\n");
 
-	mutex_lock(&priv->shrd->mutex);
+	mutex_lock(&priv->mutex);
 
 	if (iwl_is_rfkill(priv->shrd))
 		goto out;
@@ -890,7 +890,7 @@ static void iwlagn_mac_channel_switch(struct ieee80211_hw *hw,
 	}
 
 out:
-	mutex_unlock(&priv->shrd->mutex);
+	mutex_unlock(&priv->mutex);
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 }
 
@@ -920,7 +920,7 @@ static void iwlagn_configure_filter(struct ieee80211_hw *hw,
 
 #undef CHK
 
-	mutex_lock(&priv->shrd->mutex);
+	mutex_lock(&priv->mutex);
 
 	for_each_context(priv, ctx) {
 		ctx->staging.filter_flags &= ~filter_nand;
@@ -932,7 +932,7 @@ static void iwlagn_configure_filter(struct ieee80211_hw *hw,
 		 */
 	}
 
-	mutex_unlock(&priv->shrd->mutex);
+	mutex_unlock(&priv->mutex);
 
 	/*
 	 * Receiving all multicast frames is always enabled by the
@@ -948,7 +948,7 @@ static void iwlagn_mac_flush(struct ieee80211_hw *hw, bool drop)
 {
 	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 
-	mutex_lock(&priv->shrd->mutex);
+	mutex_lock(&priv->mutex);
 	IWL_DEBUG_MAC80211(priv, "enter\n");
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->shrd->status)) {
@@ -974,7 +974,7 @@ static void iwlagn_mac_flush(struct ieee80211_hw *hw, bool drop)
 	IWL_DEBUG_MAC80211(priv, "wait transmit/flush all frames\n");
 	iwl_trans_wait_tx_queue_empty(trans(priv));
 done:
-	mutex_unlock(&priv->shrd->mutex);
+	mutex_unlock(&priv->mutex);
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 }
 
@@ -994,7 +994,7 @@ static int iwlagn_mac_remain_on_channel(struct ieee80211_hw *hw,
 		return -EOPNOTSUPP;
 
 	IWL_DEBUG_MAC80211(priv, "enter\n");
-	mutex_lock(&priv->shrd->mutex);
+	mutex_lock(&priv->mutex);
 
 	if (test_bit(STATUS_SCAN_HW, &priv->shrd->status)) {
 		err = -EBUSY;
@@ -1065,7 +1065,7 @@ static int iwlagn_mac_remain_on_channel(struct ieee80211_hw *hw,
 		iwlagn_disable_roc(priv);
 
  out:
-	mutex_unlock(&priv->shrd->mutex);
+	mutex_unlock(&priv->mutex);
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 
 	return err;
@@ -1079,10 +1079,10 @@ static int iwlagn_mac_cancel_remain_on_channel(struct ieee80211_hw *hw)
 		return -EOPNOTSUPP;
 
 	IWL_DEBUG_MAC80211(priv, "enter\n");
-	mutex_lock(&priv->shrd->mutex);
+	mutex_lock(&priv->mutex);
 	iwl_scan_cancel_timeout(priv, priv->hw_roc_duration);
 	iwlagn_disable_roc(priv);
-	mutex_unlock(&priv->shrd->mutex);
+	mutex_unlock(&priv->mutex);
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 
 	return 0;
@@ -1094,7 +1094,7 @@ static void iwlagn_mac_rssi_callback(struct ieee80211_hw *hw,
 	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 
 	IWL_DEBUG_MAC80211(priv, "enter\n");
-	mutex_lock(&priv->shrd->mutex);
+	mutex_lock(&priv->mutex);
 
 	if (cfg(priv)->bt_params &&
 			cfg(priv)->bt_params->advanced_bt_coexist) {
@@ -1109,7 +1109,7 @@ static void iwlagn_mac_rssi_callback(struct ieee80211_hw *hw,
 				"ignoring RSSI callback\n");
 	}
 
-	mutex_unlock(&priv->shrd->mutex);
+	mutex_unlock(&priv->mutex);
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 }
 
@@ -1149,7 +1149,7 @@ static int iwlagn_mac_conf_tx(struct ieee80211_hw *hw,
 
 	q = AC_NUM - 1 - queue;
 
-	mutex_lock(&priv->shrd->mutex);
+	mutex_lock(&priv->mutex);
 
 	ctx->qos_data.def_qos_parm.ac[q].cw_min =
 		cpu_to_le16(params->cw_min);
@@ -1161,7 +1161,7 @@ static int iwlagn_mac_conf_tx(struct ieee80211_hw *hw,
 
 	ctx->qos_data.def_qos_parm.ac[q].reserved1 = 0;
 
-	mutex_unlock(&priv->shrd->mutex);
+	mutex_unlock(&priv->mutex);
 
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 	return 0;
@@ -1189,7 +1189,7 @@ static int iwl_setup_interface(struct iwl_priv *priv,
 	struct ieee80211_vif *vif = ctx->vif;
 	int err;
 
-	lockdep_assert_held(&priv->shrd->mutex);
+	lockdep_assert_held(&priv->mutex);
 
 	/*
 	 * This variable will be correct only when there's just
@@ -1234,7 +1234,7 @@ static int iwlagn_mac_add_interface(struct ieee80211_hw *hw,
 
 	cancel_delayed_work_sync(&priv->hw_roc_disable_work);
 
-	mutex_lock(&priv->shrd->mutex);
+	mutex_lock(&priv->mutex);
 
 	iwlagn_disable_roc(priv);
 
@@ -1281,7 +1281,7 @@ static int iwlagn_mac_add_interface(struct ieee80211_hw *hw,
 	ctx->vif = NULL;
 	priv->iw_mode = NL80211_IFTYPE_STATION;
  out:
-	mutex_unlock(&priv->shrd->mutex);
+	mutex_unlock(&priv->mutex);
 
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 	return err;
@@ -1293,7 +1293,7 @@ static void iwl_teardown_interface(struct iwl_priv *priv,
 {
 	struct iwl_rxon_context *ctx = iwl_rxon_ctx_from_vif(vif);
 
-	lockdep_assert_held(&priv->shrd->mutex);
+	lockdep_assert_held(&priv->mutex);
 
 	if (priv->scan_vif == vif) {
 		iwl_scan_cancel_timeout(priv, 200);
@@ -1325,7 +1325,7 @@ static void iwlagn_mac_remove_interface(struct ieee80211_hw *hw,
 
 	IWL_DEBUG_MAC80211(priv, "enter\n");
 
-	mutex_lock(&priv->shrd->mutex);
+	mutex_lock(&priv->mutex);
 
 	if (WARN_ON(ctx->vif != vif)) {
 		struct iwl_rxon_context *tmp;
@@ -1338,7 +1338,7 @@ static void iwlagn_mac_remove_interface(struct ieee80211_hw *hw,
 
 	iwl_teardown_interface(priv, vif, false);
 
-	mutex_unlock(&priv->shrd->mutex);
+	mutex_unlock(&priv->mutex);
 
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 
@@ -1360,7 +1360,7 @@ static int iwlagn_mac_change_interface(struct ieee80211_hw *hw,
 
 	newtype = ieee80211_iftype_p2p(newtype, newp2p);
 
-	mutex_lock(&priv->shrd->mutex);
+	mutex_lock(&priv->mutex);
 
 	if (!ctx->vif || !iwl_is_ready_rf(priv->shrd)) {
 		/*
@@ -1424,7 +1424,7 @@ static int iwlagn_mac_change_interface(struct ieee80211_hw *hw,
 	err = 0;
 
  out:
-	mutex_unlock(&priv->shrd->mutex);
+	mutex_unlock(&priv->mutex);
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 
 	return err;
@@ -1442,7 +1442,7 @@ static int iwlagn_mac_hw_scan(struct ieee80211_hw *hw,
 	if (req->n_channels == 0)
 		return -EINVAL;
 
-	mutex_lock(&priv->shrd->mutex);
+	mutex_lock(&priv->mutex);
 
 	/*
 	 * If an internal scan is in progress, just set
@@ -1471,7 +1471,7 @@ static int iwlagn_mac_hw_scan(struct ieee80211_hw *hw,
 
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 
-	mutex_unlock(&priv->shrd->mutex);
+	mutex_unlock(&priv->mutex);
 
 	return ret;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index 46ca820..d76ff23 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -383,7 +383,7 @@ int iwl_power_set_mode(struct iwl_priv *priv, struct iwl_powertable_cmd *cmd,
 	int ret;
 	bool update_chains;
 
-	lockdep_assert_held(&priv->shrd->mutex);
+	lockdep_assert_held(&priv->mutex);
 
 	/* Don't update the RX chain when chain noise calibration is running */
 	update_chains = priv->chain_noise_data.state == IWL_CHAIN_NOISE_DONE ||
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index dcba748..6cf2cb3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -115,7 +115,7 @@ static void iwl_process_scan_complete(struct iwl_priv *priv)
 {
 	bool aborted;
 
-	lockdep_assert_held(&priv->shrd->mutex);
+	lockdep_assert_held(&priv->mutex);
 
 	if (!test_and_clear_bit(STATUS_SCAN_COMPLETE, &priv->shrd->status))
 		return;
@@ -172,7 +172,7 @@ out_settings:
 
 void iwl_force_scan_end(struct iwl_priv *priv)
 {
-	lockdep_assert_held(&priv->shrd->mutex);
+	lockdep_assert_held(&priv->mutex);
 
 	if (!test_bit(STATUS_SCANNING, &priv->shrd->status)) {
 		IWL_DEBUG_SCAN(priv, "Forcing scan end while not scanning\n");
@@ -191,7 +191,7 @@ static void iwl_do_scan_abort(struct iwl_priv *priv)
 {
 	int ret;
 
-	lockdep_assert_held(&priv->shrd->mutex);
+	lockdep_assert_held(&priv->mutex);
 
 	if (!test_bit(STATUS_SCANNING, &priv->shrd->status)) {
 		IWL_DEBUG_SCAN(priv, "Not performing scan to abort\n");
@@ -230,7 +230,7 @@ void iwl_scan_cancel_timeout(struct iwl_priv *priv, unsigned long ms)
 {
 	unsigned long timeout = jiffies + msecs_to_jiffies(ms);
 
-	lockdep_assert_held(&priv->shrd->mutex);
+	lockdep_assert_held(&priv->mutex);
 
 	IWL_DEBUG_SCAN(priv, "Scan cancel timeout\n");
 
@@ -595,7 +595,7 @@ static int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	u8 scan_tx_antennas = hw_params(priv).valid_tx_ant;
 	int ret;
 
-	lockdep_assert_held(&priv->shrd->mutex);
+	lockdep_assert_held(&priv->mutex);
 
 	if (vif)
 		ctx = iwl_rxon_ctx_from_vif(vif);
@@ -912,7 +912,7 @@ int __must_check iwl_scan_initiate(struct iwl_priv *priv,
 {
 	int ret;
 
-	lockdep_assert_held(&priv->shrd->mutex);
+	lockdep_assert_held(&priv->mutex);
 
 	cancel_delayed_work(&priv->scan_check);
 
@@ -972,7 +972,7 @@ static void iwl_bg_start_internal_scan(struct work_struct *work)
 
 	IWL_DEBUG_SCAN(priv, "Start internal scan\n");
 
-	mutex_lock(&priv->shrd->mutex);
+	mutex_lock(&priv->mutex);
 
 	if (priv->scan_type == IWL_SCAN_RADIO_RESET) {
 		IWL_DEBUG_SCAN(priv, "Internal scan already in progress\n");
@@ -987,7 +987,7 @@ static void iwl_bg_start_internal_scan(struct work_struct *work)
 	if (iwl_scan_initiate(priv, NULL, IWL_SCAN_RADIO_RESET, priv->band))
 		IWL_DEBUG_SCAN(priv, "failed to start internal short scan\n");
  unlock:
-	mutex_unlock(&priv->shrd->mutex);
+	mutex_unlock(&priv->mutex);
 }
 
 static void iwl_bg_scan_check(struct work_struct *data)
@@ -1000,9 +1000,9 @@ static void iwl_bg_scan_check(struct work_struct *data)
 	/* Since we are here firmware does not finish scan and
 	 * most likely is in bad shape, so we don't bother to
 	 * send abort command, just force scan complete to mac80211 */
-	mutex_lock(&priv->shrd->mutex);
+	mutex_lock(&priv->mutex);
 	iwl_force_scan_end(priv);
-	mutex_unlock(&priv->shrd->mutex);
+	mutex_unlock(&priv->mutex);
 }
 
 /**
@@ -1060,9 +1060,9 @@ static void iwl_bg_abort_scan(struct work_struct *work)
 
 	/* We keep scan_check work queued in case when firmware will not
 	 * report back scan completed notification */
-	mutex_lock(&priv->shrd->mutex);
+	mutex_lock(&priv->mutex);
 	iwl_scan_cancel_timeout(priv, 200);
-	mutex_unlock(&priv->shrd->mutex);
+	mutex_unlock(&priv->mutex);
 }
 
 static void iwl_bg_scan_completed(struct work_struct *work)
@@ -1070,9 +1070,9 @@ static void iwl_bg_scan_completed(struct work_struct *work)
 	struct iwl_priv *priv =
 		container_of(work, struct iwl_priv, scan_completed);
 
-	mutex_lock(&priv->shrd->mutex);
+	mutex_lock(&priv->mutex);
 	iwl_process_scan_complete(priv);
-	mutex_unlock(&priv->shrd->mutex);
+	mutex_unlock(&priv->mutex);
 }
 
 void iwl_setup_scan_deferred_work(struct iwl_priv *priv)
@@ -1090,8 +1090,8 @@ void iwl_cancel_scan_deferred_work(struct iwl_priv *priv)
 	cancel_work_sync(&priv->scan_completed);
 
 	if (cancel_delayed_work_sync(&priv->scan_check)) {
-		mutex_lock(&priv->shrd->mutex);
+		mutex_lock(&priv->mutex);
 		iwl_force_scan_end(priv);
-		mutex_unlock(&priv->shrd->mutex);
+		mutex_unlock(&priv->mutex);
 	}
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index bb34766..30b942f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -65,7 +65,6 @@
 
 #include <linux/types.h>
 #include <linux/spinlock.h>
-#include <linux/mutex.h>
 #include <linux/gfp.h>
 #include <net/mac80211.h>
 
@@ -399,7 +398,6 @@ struct iwl_cfg {
  * @nic: pointer to the nic data
  * @hw_params: see struct iwl_hw_params
  * @lock: protect general shared data
- * @mutex:
  * @wait_command_queue: the wait_queue for SYNC host command nad uCode load
  * @eeprom: pointer to the eeprom/OTP image
  * @ucode_type: indicator of loaded ucode image
@@ -423,8 +421,6 @@ struct iwl_shared {
 	struct iwl_hw_params hw_params;
 	const struct iwl_fw *fw;
 
-	struct mutex mutex;
-
 	wait_queue_head_t wait_command_queue;
 
 	/* eeprom -- this is in the card's little endian byte order */
diff --git a/drivers/net/wireless/iwlwifi/iwl-testmode.c b/drivers/net/wireless/iwlwifi/iwl-testmode.c
index f26765b..095d71d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-testmode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-testmode.c
@@ -975,7 +975,7 @@ int iwlagn_mac_testmode_cmd(struct ieee80211_hw *hw, void *data, int len)
 		return -ENOMSG;
 	}
 	/* in case multiple accesses to the device happens */
-	mutex_lock(&priv->shrd->mutex);
+	mutex_lock(&priv->mutex);
 
 	switch (nla_get_u32(tb[IWL_TM_ATTR_COMMAND])) {
 	case IWL_TM_CMD_APP2DEV_UCODE:
@@ -1027,7 +1027,7 @@ int iwlagn_mac_testmode_cmd(struct ieee80211_hw *hw, void *data, int len)
 		break;
 	}
 
-	mutex_unlock(&priv->shrd->mutex);
+	mutex_unlock(&priv->mutex);
 	return result;
 }
 
@@ -1062,7 +1062,7 @@ int iwlagn_mac_testmode_dump(struct ieee80211_hw *hw, struct sk_buff *skb,
 	}
 
 	/* in case multiple accesses to the device happens */
-	mutex_lock(&priv->shrd->mutex);
+	mutex_lock(&priv->mutex);
 	switch (cmd) {
 	case IWL_TM_CMD_APP2DEV_READ_TRACE:
 		IWL_DEBUG_INFO(priv, "uCode trace cmd to driver\n");
@@ -1077,6 +1077,6 @@ int iwlagn_mac_testmode_dump(struct ieee80211_hw *hw, struct sk_buff *skb,
 		break;
 	}
 
-	mutex_unlock(&priv->shrd->mutex);
+	mutex_unlock(&priv->mutex);
 	return result;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-ucode.c b/drivers/net/wireless/iwlwifi/iwl-ucode.c
index 1cbe8e9..c1c5e1f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-ucode.c
@@ -599,7 +599,7 @@ int iwl_run_init_ucode(struct iwl_priv *priv)
 	struct iwl_notification_wait calib_wait;
 	int ret;
 
-	lockdep_assert_held(&priv->shrd->mutex);
+	lockdep_assert_held(&priv->mutex);
 
 	/* No init ucode required? Curious, but maybe ok */
 	if (!priv->fw->ucode_init.code.len)
-- 
1.7.0.4

