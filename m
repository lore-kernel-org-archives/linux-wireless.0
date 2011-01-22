Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:47749 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754963Ab1AVASY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Jan 2011 19:18:24 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 12/14] iwlwifi: implement remain-on-channel
Date: Fri, 21 Jan 2011 16:06:47 -0800
Message-Id: <1295654809-5790-13-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1295654809-5790-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1295654809-5790-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

For device supporting PAN/P2P, use the PAN
context to implement the remain-on-channel
operation using device offloads so that the
filters in the device will be programmed
correctly -- otherwise we cannot receive
any probe request frames during off-channel
periods.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c |    6 ++-
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |   17 +++++
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c   |    9 ++-
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   94 +++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    6 ++
 5 files changed, 130 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
index 366340f..fa6cf2a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
@@ -305,7 +305,11 @@ static int iwlagn_set_pan_params(struct iwl_priv *priv)
 	cmd.slots[0].type = 0; /* BSS */
 	cmd.slots[1].type = 1; /* PAN */
 
-	if (ctx_bss->vif && ctx_pan->vif) {
+	if (priv->_agn.hw_roc_channel) {
+		/* both contexts must be used for this to happen */
+		slot1 = priv->_agn.hw_roc_duration;
+		slot0 = 20;
+	} else if (ctx_bss->vif && ctx_pan->vif) {
 		int bcnint = ctx_pan->vif->bss_conf.beacon_int;
 		int dtim = ctx_pan->vif->bss_conf.dtim_period ?: 1;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index f693293..2a4ff83 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -156,6 +156,23 @@ int iwlagn_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 	/* always get timestamp with Rx frame */
 	ctx->staging.flags |= RXON_FLG_TSF2HOST_MSK;
 
+	if (ctx->ctxid == IWL_RXON_CTX_PAN && priv->_agn.hw_roc_channel) {
+		struct ieee80211_channel *chan = priv->_agn.hw_roc_channel;
+
+		iwl_set_rxon_channel(priv, chan, ctx);
+		iwl_set_flags_for_band(priv, ctx, chan->band, NULL);
+		ctx->staging.filter_flags |=
+			RXON_FILTER_ASSOC_MSK |
+			RXON_FILTER_PROMISC_MSK |
+			RXON_FILTER_CTL2HOST_MSK;
+		ctx->staging.dev_type = RXON_DEV_TYPE_P2P;
+		new_assoc = true;
+
+		if (memcmp(&ctx->staging, &ctx->active,
+			   sizeof(ctx->staging)) == 0)
+			return 0;
+	}
+
 	if ((ctx->vif && ctx->vif->bss_conf.use_short_slot) ||
 	    !(ctx->staging.flags & RXON_FLG_BAND_24G_MSK))
 		ctx->staging.flags |= RXON_FLG_SHORT_SLOT_MSK;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 24a11b8..266490d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -539,7 +539,14 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	unsigned long flags;
 	bool is_agg = false;
 
-	if (info->control.vif)
+	/*
+	 * If the frame needs to go out off-channel, then
+	 * we'll have put the PAN context to that channel,
+	 * so make the frame go out there.
+	 */
+	if (info->flags & IEEE80211_TX_CTL_TX_OFFCHAN)
+		ctx = &priv->contexts[IWL_RXON_CTX_PAN];
+	else if (info->control.vif)
 		ctx = iwl_rxon_ctx_from_vif(info->control.vif);
 
 	spin_lock_irqsave(&priv->lock, flags);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index dad9a63..51e5ea4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3208,6 +3208,8 @@ static int iwl_mac_setup_register(struct iwl_priv *priv,
 		hw->wiphy->interface_modes |= ctx->exclusive_interface_modes;
 	}
 
+	hw->wiphy->max_remain_on_channel_duration = 1000;
+
 	hw->wiphy->flags |= WIPHY_FLAG_CUSTOM_REGULATORY |
 			    WIPHY_FLAG_DISABLE_BEACON_HINTS;
 
@@ -3726,6 +3728,95 @@ done:
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 }
 
+static void iwlagn_disable_roc(struct iwl_priv *priv)
+{
+	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_PAN];
+	struct ieee80211_channel *chan = ACCESS_ONCE(priv->hw->conf.channel);
+
+	lockdep_assert_held(&priv->mutex);
+
+	if (!ctx->is_active)
+		return;
+
+	ctx->staging.dev_type = RXON_DEV_TYPE_2STA;
+	ctx->staging.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
+	iwl_set_rxon_channel(priv, chan, ctx);
+	iwl_set_flags_for_band(priv, ctx, chan->band, NULL);
+
+	priv->_agn.hw_roc_channel = NULL;
+
+	iwlagn_commit_rxon(priv, ctx);
+
+	ctx->is_active = false;
+}
+
+static void iwlagn_bg_roc_done(struct work_struct *work)
+{
+	struct iwl_priv *priv = container_of(work, struct iwl_priv,
+					     _agn.hw_roc_work.work);
+
+	mutex_lock(&priv->mutex);
+	ieee80211_remain_on_channel_expired(priv->hw);
+	iwlagn_disable_roc(priv);
+	mutex_unlock(&priv->mutex);
+}
+
+static int iwl_mac_remain_on_channel(struct ieee80211_hw *hw,
+				     struct ieee80211_channel *channel,
+				     enum nl80211_channel_type channel_type,
+				     int duration)
+{
+	struct iwl_priv *priv = hw->priv;
+	int err = 0;
+
+	if (!(priv->valid_contexts & BIT(IWL_RXON_CTX_PAN)))
+		return -EOPNOTSUPP;
+
+	if (!(priv->contexts[IWL_RXON_CTX_PAN].interface_modes &
+					BIT(NL80211_IFTYPE_P2P_CLIENT)))
+		return -EOPNOTSUPP;
+
+	mutex_lock(&priv->mutex);
+
+	if (priv->contexts[IWL_RXON_CTX_PAN].is_active ||
+	    test_bit(STATUS_SCAN_HW, &priv->status)) {
+		err = -EBUSY;
+		goto out;
+	}
+
+	priv->contexts[IWL_RXON_CTX_PAN].is_active = true;
+	priv->_agn.hw_roc_channel = channel;
+	priv->_agn.hw_roc_chantype = channel_type;
+	priv->_agn.hw_roc_duration = DIV_ROUND_UP(duration * 1000, 1024);
+	iwlagn_commit_rxon(priv, &priv->contexts[IWL_RXON_CTX_PAN]);
+	queue_delayed_work(priv->workqueue, &priv->_agn.hw_roc_work,
+			   msecs_to_jiffies(duration + 20));
+
+	msleep(20);
+	ieee80211_ready_on_channel(priv->hw);
+
+ out:
+	mutex_unlock(&priv->mutex);
+
+	return err;
+}
+
+static int iwl_mac_cancel_remain_on_channel(struct ieee80211_hw *hw)
+{
+	struct iwl_priv *priv = hw->priv;
+
+	if (!(priv->valid_contexts & BIT(IWL_RXON_CTX_PAN)))
+		return -EOPNOTSUPP;
+
+	cancel_delayed_work_sync(&priv->_agn.hw_roc_work);
+
+	mutex_lock(&priv->mutex);
+	iwlagn_disable_roc(priv);
+	mutex_unlock(&priv->mutex);
+
+	return 0;
+}
+
 /*****************************************************************************
  *
  * driver setup and teardown
@@ -3747,6 +3838,7 @@ static void iwl_setup_deferred_work(struct iwl_priv *priv)
 	INIT_WORK(&priv->bt_runtime_config, iwl_bg_bt_runtime_config);
 	INIT_DELAYED_WORK(&priv->init_alive_start, iwl_bg_init_alive_start);
 	INIT_DELAYED_WORK(&priv->alive_start, iwl_bg_alive_start);
+	INIT_DELAYED_WORK(&priv->_agn.hw_roc_work, iwlagn_bg_roc_done);
 
 	iwl_setup_scan_deferred_work(priv);
 
@@ -3915,6 +4007,8 @@ struct ieee80211_ops iwlagn_hw_ops = {
 	.channel_switch = iwlagn_mac_channel_switch,
 	.flush = iwlagn_mac_flush,
 	.tx_last_beacon = iwl_mac_tx_last_beacon,
+	.remain_on_channel = iwl_mac_remain_on_channel,
+	.cancel_remain_on_channel = iwl_mac_cancel_remain_on_channel,
 };
 #endif
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 6dd6508..6fa1383 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1488,6 +1488,12 @@ struct iwl_priv {
 			struct list_head notif_waits;
 			spinlock_t notif_wait_lock;
 			wait_queue_head_t notif_waitq;
+
+			/* remain-on-channel offload support */
+			struct ieee80211_channel *hw_roc_channel;
+			struct delayed_work hw_roc_work;
+			enum nl80211_channel_type hw_roc_chantype;
+			int hw_roc_duration;
 		} _agn;
 #endif
 	};
-- 
1.7.0.4

