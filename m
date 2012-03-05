Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:7349 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965078Ab2CEUiE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Mar 2012 15:38:04 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH RESEND 09/33] iwlwifi: remove shared lock
Date: Mon,  5 Mar 2012 11:24:27 -0800
Message-Id: <1330975491-19680-10-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120305_213810_656012_9BD2A937)
In-Reply-To: <1330975491-19680-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330975491-19680-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Some data doesn't need protection, some of the
lock places are simply useless, and some data
can be protected with the mutex instead. Thus
the shared lock can be removed by making those
changes.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-5000.c     |    7 -------
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |    3 ---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c   |    3 ---
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |    6 ------
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c   |    9 ---------
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    5 +----
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    4 ----
 drivers/net/wireless/iwlwifi/iwl-mac80211.c |    9 ++-------
 drivers/net/wireless/iwlwifi/iwl-shared.h   |    1 -
 9 files changed, 3 insertions(+), 44 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 1527dec..ccaeead 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -63,12 +63,8 @@
 /* NIC configuration for 5000 series */
 static void iwl5000_nic_config(struct iwl_priv *priv)
 {
-	unsigned long flags;
-
 	iwl_rf_config(priv);
 
-	spin_lock_irqsave(&priv->shrd->lock, flags);
-
 	/* W/A : NIC is stuck in a reset state after Early PCIe power off
 	 * (PCIe power is lost before PERST# is asserted),
 	 * causing ME FW to lose ownership and not being able to obtain it back.
@@ -76,9 +72,6 @@ static void iwl5000_nic_config(struct iwl_priv *priv)
 	iwl_set_bits_mask_prph(trans(priv), APMG_PS_CTRL_REG,
 				APMG_PS_CTRL_EARLY_PWR_OFF_RESET_DIS,
 				~APMG_PS_CTRL_EARLY_PWR_OFF_RESET_DIS);
-
-
-	spin_unlock_irqrestore(&priv->shrd->lock, flags);
 }
 
 static struct iwl_sensitivity_ranges iwl5000_sensitivity = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 0f8dd0f..2470ca7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -710,7 +710,6 @@ int iwlagn_bt_coex_profile_notif(struct iwl_priv *priv,
 				  struct iwl_rx_mem_buffer *rxb,
 				  struct iwl_device_cmd *cmd)
 {
-	unsigned long flags;
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_bt_coex_profile_notif *coex = &pkt->u.bt_coex_profile_notif;
 	struct iwl_bt_uart_msg *uart_msg = &coex->last_bt_uart_msg;
@@ -756,9 +755,7 @@ int iwlagn_bt_coex_profile_notif(struct iwl_priv *priv,
 
 	/* FIXME: based on notification, adjust the prio_boost */
 
-	spin_lock_irqsave(&priv->shrd->lock, flags);
 	priv->bt_ci_compliance = coex->bt_ci_compliance;
-	spin_unlock_irqrestore(&priv->shrd->lock, flags);
 	return 0;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index a7d6713..9895b80 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -870,19 +870,16 @@ static void rs_bt_update_lq(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 {
 	struct iwl_scale_tbl_info *tbl;
 	bool full_concurrent = priv->bt_full_concurrent;
-	unsigned long flags;
 
 	if (priv->bt_ant_couple_ok) {
 		/*
 		 * Is there a need to switch between
 		 * full concurrency and 3-wire?
 		 */
-		spin_lock_irqsave(&priv->shrd->lock, flags);
 		if (priv->bt_ci_compliance && priv->bt_ant_couple_ok)
 			full_concurrent = true;
 		else
 			full_concurrent = false;
-		spin_unlock_irqrestore(&priv->shrd->lock, flags);
 	}
 	if ((priv->bt_traffic_load != priv->last_bt_traffic_load) ||
 	    (priv->bt_full_concurrent != full_concurrent)) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index 73653a6..a8c7900 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -590,8 +590,6 @@ int iwlagn_mac_config(struct ieee80211_hw *hw, u32 changed)
 	}
 
 	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
-		unsigned long flags;
-
 		ch_info = iwl_get_channel_info(priv, channel->band,
 					       channel->hw_value);
 		if (!is_channel_valid(ch_info)) {
@@ -600,8 +598,6 @@ int iwlagn_mac_config(struct ieee80211_hw *hw, u32 changed)
 			goto out;
 		}
 
-		spin_lock_irqsave(&priv->shrd->lock, flags);
-
 		for_each_context(priv, ctx) {
 			/* Configure HT40 channels */
 			if (ctx->ht.enabled != conf_is_ht(conf))
@@ -636,8 +632,6 @@ int iwlagn_mac_config(struct ieee80211_hw *hw, u32 changed)
 					       ctx->vif);
 		}
 
-		spin_unlock_irqrestore(&priv->shrd->lock, flags);
-
 		iwl_update_bcast_stations(priv);
 
 		/*
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 4e69189..2b722cc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -259,18 +259,15 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
 	struct iwl_device_cmd *dev_cmd = NULL;
 	struct iwl_tx_cmd *tx_cmd;
-
 	__le16 fc;
 	u8 hdr_len;
 	u16 len, seq_number = 0;
 	u8 sta_id, tid = IWL_MAX_TID_COUNT;
-	unsigned long flags;
 	bool is_agg = false;
 
 	if (info->control.vif)
 		ctx = iwl_rxon_ctx_from_vif(info->control.vif);
 
-	spin_lock_irqsave(&priv->shrd->lock, flags);
 	if (iwl_is_rfkill(priv->shrd)) {
 		IWL_DEBUG_DROP(priv, "Dropping - RF KILL\n");
 		goto drop_unlock_priv;
@@ -369,7 +366,6 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	info->driver_data[0] = ctx;
 	info->driver_data[1] = dev_cmd;
 
-	/* irqs already disabled/saved above when locking priv->shrd->lock */
 	spin_lock(&priv->sta_lock);
 
 	if (ieee80211_is_data_qos(fc) && !ieee80211_is_qos_nullfunc(fc)) {
@@ -418,7 +414,6 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 		priv->tid_data[sta_id][tid].seq_number = seq_number;
 
 	spin_unlock(&priv->sta_lock);
-	spin_unlock_irqrestore(&priv->shrd->lock, flags);
 
 	/*
 	 * Avoid atomic ops if it isn't an associated client.
@@ -437,7 +432,6 @@ drop_unlock_sta:
 		kmem_cache_free(priv->tx_cmd_pool, dev_cmd);
 	spin_unlock(&priv->sta_lock);
 drop_unlock_priv:
-	spin_unlock_irqrestore(&priv->shrd->lock, flags);
 	return -1;
 }
 
@@ -445,7 +439,6 @@ int iwlagn_tx_agg_stop(struct iwl_priv *priv, struct ieee80211_vif *vif,
 			struct ieee80211_sta *sta, u16 tid)
 {
 	struct iwl_tid_data *tid_data;
-	unsigned long flags;
 	int sta_id;
 
 	sta_id = iwl_sta_id(sta);
@@ -500,9 +493,7 @@ turn_off:
 
 	spin_unlock_bh(&priv->sta_lock);
 
-	spin_lock_irqsave(&priv->shrd->lock, flags);
 	iwl_trans_tx_agg_disable(trans(priv), sta_id, tid);
-	spin_unlock_irqrestore(&priv->shrd->lock, flags);
 
 	ieee80211_stop_tx_ba_cb_irqsafe(vif, sta->addr, tid);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 47c7886..ada9d9e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -552,13 +552,11 @@ static void iwl_rf_kill_ct_config(struct iwl_priv *priv)
 {
 	struct iwl_ct_kill_config cmd;
 	struct iwl_ct_kill_throttling_config adv_cmd;
-	unsigned long flags;
 	int ret = 0;
 
-	spin_lock_irqsave(&priv->shrd->lock, flags);
 	iwl_write32(trans(priv), CSR_UCODE_DRV_GP1_CLR,
 		    CSR_UCODE_DRV_GP1_REG_BIT_CT_KILL_EXIT);
-	spin_unlock_irqrestore(&priv->shrd->lock, flags);
+
 	priv->thermal_throttle.ct_kill_toggle = false;
 
 	if (cfg(priv)->base_params->support_ct_kill_exit) {
@@ -1232,7 +1230,6 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans)
 	 * we should init now
 	 */
 	spin_lock_init(&trans(priv)->reg_lock);
-	spin_lock_init(&priv->shrd->lock);
 	spin_lock_init(&priv->statistics.lock);
 
 	/***********************
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index daf2330..5b537db 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -719,10 +719,6 @@ struct iwl_priv {
 	/*data shared among all the driver's layers */
 	struct iwl_shared *shrd;
 
-	/*
-	 * protects the station table, if shrd->lock and sta_lock are
-	 * needed, shrd->lock must be acquired first
-	 */
 	spinlock_t sta_lock;
 
 	/* ieee device used by generic ieee processing code */
diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
index 9fba532..dcee30f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -779,8 +779,6 @@ static void iwlagn_mac_channel_switch(struct ieee80211_hw *hw,
 		goto out;
 	}
 
-	spin_lock_irq(&priv->shrd->lock);
-
 	priv->current_ht_config.smps = conf->smps_mode;
 
 	/* Configure HT40 channels */
@@ -797,8 +795,6 @@ static void iwlagn_mac_channel_switch(struct ieee80211_hw *hw,
 	iwl_set_rxon_ht(priv, ht_conf);
 	iwl_set_flags_for_band(priv, ctx, channel->band, ctx->vif);
 
-	spin_unlock_irq(&priv->shrd->lock);
-
 	iwl_set_rate(priv);
 	/*
 	 * at this point, staging_rxon has the
@@ -1133,7 +1129,6 @@ static int iwlagn_mac_conf_tx(struct ieee80211_hw *hw,
 	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 	struct iwl_vif_priv *vif_priv = (void *)vif->drv_priv;
 	struct iwl_rxon_context *ctx = vif_priv->ctx;
-	unsigned long flags;
 	int q;
 
 	if (WARN_ON(!ctx))
@@ -1153,7 +1148,7 @@ static int iwlagn_mac_conf_tx(struct ieee80211_hw *hw,
 
 	q = AC_NUM - 1 - queue;
 
-	spin_lock_irqsave(&priv->shrd->lock, flags);
+	mutex_lock(&priv->shrd->mutex);
 
 	ctx->qos_data.def_qos_parm.ac[q].cw_min =
 		cpu_to_le16(params->cw_min);
@@ -1165,7 +1160,7 @@ static int iwlagn_mac_conf_tx(struct ieee80211_hw *hw,
 
 	ctx->qos_data.def_qos_parm.ac[q].reserved1 = 0;
 
-	spin_unlock_irqrestore(&priv->shrd->lock, flags);
+	mutex_unlock(&priv->shrd->mutex);
 
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 	return 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 3a0f0a4..7720fc3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -388,7 +388,6 @@ struct iwl_shared {
 	struct iwl_nic *nic;
 	struct iwl_hw_params hw_params;
 
-	spinlock_t lock;
 	struct mutex mutex;
 
 	wait_queue_head_t wait_command_queue;
-- 
1.7.0.4

