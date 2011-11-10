Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:32739 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935472Ab1KJPtk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Nov 2011 10:49:40 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH RESEND 14/27] iwlwifi: move more mac80211 callback function
Date: Thu, 10 Nov 2011 06:55:14 -0800
Message-Id: <1320936927-9078-15-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111110_165044_591652_569EA93D)
In-Reply-To: <1320936927-9078-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1320936927-9078-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move more mac80211 related functions to _mac80211 file

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c     |  304 --------------------------
 drivers/net/wireless/iwlwifi/iwl-core.h     |   11 -
 drivers/net/wireless/iwlwifi/iwl-mac80211.c |  308 +++++++++++++++++++++++++++
 3 files changed, 308 insertions(+), 315 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 989f9f3..f7b0048 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1120,227 +1120,8 @@ int iwl_send_statistics_request(struct iwl_priv *priv, u8 flags, bool clear)
 					&statistics_cmd);
 }
 
-int iwlagn_mac_conf_tx(struct ieee80211_hw *hw,
-		    struct ieee80211_vif *vif, u16 queue,
-		    const struct ieee80211_tx_queue_params *params)
-{
-	struct iwl_priv *priv = hw->priv;
-	struct iwl_vif_priv *vif_priv = (void *)vif->drv_priv;
-	struct iwl_rxon_context *ctx = vif_priv->ctx;
-	unsigned long flags;
-	int q;
-
-	if (WARN_ON(!ctx))
-		return -EINVAL;
-
-	IWL_DEBUG_MAC80211(priv, "enter\n");
-
-	if (!iwl_is_ready_rf(priv->shrd)) {
-		IWL_DEBUG_MAC80211(priv, "leave - RF not ready\n");
-		return -EIO;
-	}
-
-	if (queue >= AC_NUM) {
-		IWL_DEBUG_MAC80211(priv, "leave - queue >= AC_NUM %d\n", queue);
-		return 0;
-	}
-
-	q = AC_NUM - 1 - queue;
-
-	spin_lock_irqsave(&priv->shrd->lock, flags);
-
-	ctx->qos_data.def_qos_parm.ac[q].cw_min =
-		cpu_to_le16(params->cw_min);
-	ctx->qos_data.def_qos_parm.ac[q].cw_max =
-		cpu_to_le16(params->cw_max);
-	ctx->qos_data.def_qos_parm.ac[q].aifsn = params->aifs;
-	ctx->qos_data.def_qos_parm.ac[q].edca_txop =
-			cpu_to_le16((params->txop * 32));
-
-	ctx->qos_data.def_qos_parm.ac[q].reserved1 = 0;
-
-	spin_unlock_irqrestore(&priv->shrd->lock, flags);
-
-	IWL_DEBUG_MAC80211(priv, "leave\n");
-	return 0;
-}
-
-int iwlagn_mac_tx_last_beacon(struct ieee80211_hw *hw)
-{
-	struct iwl_priv *priv = hw->priv;
-
-	return priv->ibss_manager == IWL_IBSS_MANAGER;
-}
-
-static int iwl_set_mode(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
-{
-	iwl_connection_init_rx_config(priv, ctx);
-
-	iwlagn_set_rxon_chain(priv, ctx);
-
-	return iwlagn_commit_rxon(priv, ctx);
-}
-
-static int iwl_setup_interface(struct iwl_priv *priv,
-			       struct iwl_rxon_context *ctx)
-{
-	struct ieee80211_vif *vif = ctx->vif;
-	int err;
 
-	lockdep_assert_held(&priv->shrd->mutex);
-
-	/*
-	 * This variable will be correct only when there's just
-	 * a single context, but all code using it is for hardware
-	 * that supports only one context.
-	 */
-	priv->iw_mode = vif->type;
-
-	ctx->is_active = true;
-
-	err = iwl_set_mode(priv, ctx);
-	if (err) {
-		if (!ctx->always_active)
-			ctx->is_active = false;
-		return err;
-	}
-
-	if (priv->cfg->bt_params && priv->cfg->bt_params->advanced_bt_coexist &&
-	    vif->type == NL80211_IFTYPE_ADHOC) {
-		/*
-		 * pretend to have high BT traffic as long as we
-		 * are operating in IBSS mode, as this will cause
-		 * the rate scaling etc. to behave as intended.
-		 */
-		priv->bt_traffic_load = IWL_BT_COEX_TRAFFIC_LOAD_HIGH;
-	}
-
-	return 0;
-}
-
-int iwlagn_mac_add_interface(struct ieee80211_hw *hw,
-			     struct ieee80211_vif *vif)
-{
-	struct iwl_priv *priv = hw->priv;
-	struct iwl_vif_priv *vif_priv = (void *)vif->drv_priv;
-	struct iwl_rxon_context *tmp, *ctx = NULL;
-	int err;
-	enum nl80211_iftype viftype = ieee80211_vif_type_p2p(vif);
 
-	IWL_DEBUG_MAC80211(priv, "enter: type %d, addr %pM\n",
-			   viftype, vif->addr);
-
-	cancel_delayed_work_sync(&priv->hw_roc_disable_work);
-
-	mutex_lock(&priv->shrd->mutex);
-
-	iwlagn_disable_roc(priv);
-
-	if (!iwl_is_ready_rf(priv->shrd)) {
-		IWL_WARN(priv, "Try to add interface when device not ready\n");
-		err = -EINVAL;
-		goto out;
-	}
-
-	for_each_context(priv, tmp) {
-		u32 possible_modes =
-			tmp->interface_modes | tmp->exclusive_interface_modes;
-
-		if (tmp->vif) {
-			/* check if this busy context is exclusive */
-			if (tmp->exclusive_interface_modes &
-						BIT(tmp->vif->type)) {
-				err = -EINVAL;
-				goto out;
-			}
-			continue;
-		}
-
-		if (!(possible_modes & BIT(viftype)))
-			continue;
-
-		/* have maybe usable context w/o interface */
-		ctx = tmp;
-		break;
-	}
-
-	if (!ctx) {
-		err = -EOPNOTSUPP;
-		goto out;
-	}
-
-	vif_priv->ctx = ctx;
-	ctx->vif = vif;
-
-	err = iwl_setup_interface(priv, ctx);
-	if (!err)
-		goto out;
-
-	ctx->vif = NULL;
-	priv->iw_mode = NL80211_IFTYPE_STATION;
- out:
-	mutex_unlock(&priv->shrd->mutex);
-
-	IWL_DEBUG_MAC80211(priv, "leave\n");
-	return err;
-}
-
-static void iwl_teardown_interface(struct iwl_priv *priv,
-				   struct ieee80211_vif *vif,
-				   bool mode_change)
-{
-	struct iwl_rxon_context *ctx = iwl_rxon_ctx_from_vif(vif);
-
-	lockdep_assert_held(&priv->shrd->mutex);
-
-	if (priv->scan_vif == vif) {
-		iwl_scan_cancel_timeout(priv, 200);
-		iwl_force_scan_end(priv);
-	}
-
-	if (!mode_change) {
-		iwl_set_mode(priv, ctx);
-		if (!ctx->always_active)
-			ctx->is_active = false;
-	}
-
-	/*
-	 * When removing the IBSS interface, overwrite the
-	 * BT traffic load with the stored one from the last
-	 * notification, if any. If this is a device that
-	 * doesn't implement this, this has no effect since
-	 * both values are the same and zero.
-	 */
-	if (vif->type == NL80211_IFTYPE_ADHOC)
-		priv->bt_traffic_load = priv->last_bt_traffic_load;
-}
-
-void iwlagn_mac_remove_interface(struct ieee80211_hw *hw,
-			      struct ieee80211_vif *vif)
-{
-	struct iwl_priv *priv = hw->priv;
-	struct iwl_rxon_context *ctx = iwl_rxon_ctx_from_vif(vif);
-
-	IWL_DEBUG_MAC80211(priv, "enter\n");
-
-	mutex_lock(&priv->shrd->mutex);
-
-	if (WARN_ON(ctx->vif != vif)) {
-		struct iwl_rxon_context *tmp;
-		IWL_ERR(priv, "ctx->vif = %p, vif = %p\n", ctx->vif, vif);
-		for_each_context(priv, tmp)
-			IWL_ERR(priv, "\tID = %d:\tctx = %p\tctx->vif = %p\n",
-				tmp->ctxid, tmp, tmp->vif);
-	}
-	ctx->vif = NULL;
-
-	iwl_teardown_interface(priv, vif, false);
-
-	mutex_unlock(&priv->shrd->mutex);
-
-	IWL_DEBUG_MAC80211(priv, "leave\n");
-
-}
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 
@@ -1647,91 +1428,6 @@ int iwl_force_reset(struct iwl_priv *priv, int mode, bool external)
 	return 0;
 }
 
-int iwlagn_mac_change_interface(struct ieee80211_hw *hw,
-				struct ieee80211_vif *vif,
-				enum nl80211_iftype newtype, bool newp2p)
-{
-	struct iwl_priv *priv = hw->priv;
-	struct iwl_rxon_context *ctx = iwl_rxon_ctx_from_vif(vif);
-	struct iwl_rxon_context *bss_ctx = &priv->contexts[IWL_RXON_CTX_BSS];
-	struct iwl_rxon_context *tmp;
-	enum nl80211_iftype newviftype = newtype;
-	u32 interface_modes;
-	int err;
-
-	IWL_DEBUG_MAC80211(priv, "enter\n");
-
-	newtype = ieee80211_iftype_p2p(newtype, newp2p);
-
-	mutex_lock(&priv->shrd->mutex);
-
-	if (!ctx->vif || !iwl_is_ready_rf(priv->shrd)) {
-		/*
-		 * Huh? But wait ... this can maybe happen when
-		 * we're in the middle of a firmware restart!
-		 */
-		err = -EBUSY;
-		goto out;
-	}
-
-	interface_modes = ctx->interface_modes | ctx->exclusive_interface_modes;
-
-	if (!(interface_modes & BIT(newtype))) {
-		err = -EBUSY;
-		goto out;
-	}
-
-	/*
-	 * Refuse a change that should be done by moving from the PAN
-	 * context to the BSS context instead, if the BSS context is
-	 * available and can support the new interface type.
-	 */
-	if (ctx->ctxid == IWL_RXON_CTX_PAN && !bss_ctx->vif &&
-	    (bss_ctx->interface_modes & BIT(newtype) ||
-	     bss_ctx->exclusive_interface_modes & BIT(newtype))) {
-		BUILD_BUG_ON(NUM_IWL_RXON_CTX != 2);
-		err = -EBUSY;
-		goto out;
-	}
-
-	if (ctx->exclusive_interface_modes & BIT(newtype)) {
-		for_each_context(priv, tmp) {
-			if (ctx == tmp)
-				continue;
-
-			if (!tmp->vif)
-				continue;
-
-			/*
-			 * The current mode switch would be exclusive, but
-			 * another context is active ... refuse the switch.
-			 */
-			err = -EBUSY;
-			goto out;
-		}
-	}
-
-	/* success */
-	iwl_teardown_interface(priv, vif, true);
-	vif->type = newviftype;
-	vif->p2p = newp2p;
-	err = iwl_setup_interface(priv, ctx);
-	WARN_ON(err);
-	/*
-	 * We've switched internally, but submitting to the
-	 * device may have failed for some reason. Mask this
-	 * error, because otherwise mac80211 will not switch
-	 * (and set the interface type back) and we'll be
-	 * out of sync with it.
-	 */
-	err = 0;
-
- out:
-	mutex_unlock(&priv->shrd->mutex);
-	IWL_DEBUG_MAC80211(priv, "leave\n");
-
-	return err;
-}
 
 int iwl_cmd_echo_test(struct iwl_priv *priv)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 137da33..ee3692a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -237,10 +237,6 @@ struct iwl_cfg {
  *   L i b                 *
  ***************************/
 
-int iwlagn_mac_conf_tx(struct ieee80211_hw *hw,
-		    struct ieee80211_vif *vif, u16 queue,
-		    const struct ieee80211_tx_queue_params *params);
-int iwlagn_mac_tx_last_beacon(struct ieee80211_hw *hw);
 void iwl_set_rxon_hwcrypto(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 			   int hw_decrypt);
 int iwl_check_rxon_cmd(struct iwl_priv *priv, struct iwl_rxon_context *ctx);
@@ -260,13 +256,6 @@ bool iwl_is_ht40_tx_allowed(struct iwl_priv *priv,
 void iwl_connection_init_rx_config(struct iwl_priv *priv,
 				   struct iwl_rxon_context *ctx);
 void iwl_set_rate(struct iwl_priv *priv);
-int iwlagn_mac_add_interface(struct ieee80211_hw *hw,
-			  struct ieee80211_vif *vif);
-void iwlagn_mac_remove_interface(struct ieee80211_hw *hw,
-			      struct ieee80211_vif *vif);
-int iwlagn_mac_change_interface(struct ieee80211_hw *hw,
-			     struct ieee80211_vif *vif,
-			     enum nl80211_iftype newtype, bool newp2p);
 int iwl_cmd_echo_test(struct iwl_priv *priv);
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 int iwl_alloc_traffic_mem(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
index c06bfe4..1b2dbb0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -1493,6 +1493,314 @@ static int iwlagn_mac_set_tim(struct ieee80211_hw *hw,
 	return 0;
 }
 
+static int iwlagn_mac_conf_tx(struct ieee80211_hw *hw,
+		    struct ieee80211_vif *vif, u16 queue,
+		    const struct ieee80211_tx_queue_params *params)
+{
+	struct iwl_priv *priv = hw->priv;
+	struct iwl_vif_priv *vif_priv = (void *)vif->drv_priv;
+	struct iwl_rxon_context *ctx = vif_priv->ctx;
+	unsigned long flags;
+	int q;
+
+	if (WARN_ON(!ctx))
+		return -EINVAL;
+
+	IWL_DEBUG_MAC80211(priv, "enter\n");
+
+	if (!iwl_is_ready_rf(priv->shrd)) {
+		IWL_DEBUG_MAC80211(priv, "leave - RF not ready\n");
+		return -EIO;
+	}
+
+	if (queue >= AC_NUM) {
+		IWL_DEBUG_MAC80211(priv, "leave - queue >= AC_NUM %d\n", queue);
+		return 0;
+	}
+
+	q = AC_NUM - 1 - queue;
+
+	spin_lock_irqsave(&priv->shrd->lock, flags);
+
+	ctx->qos_data.def_qos_parm.ac[q].cw_min =
+		cpu_to_le16(params->cw_min);
+	ctx->qos_data.def_qos_parm.ac[q].cw_max =
+		cpu_to_le16(params->cw_max);
+	ctx->qos_data.def_qos_parm.ac[q].aifsn = params->aifs;
+	ctx->qos_data.def_qos_parm.ac[q].edca_txop =
+			cpu_to_le16((params->txop * 32));
+
+	ctx->qos_data.def_qos_parm.ac[q].reserved1 = 0;
+
+	spin_unlock_irqrestore(&priv->shrd->lock, flags);
+
+	IWL_DEBUG_MAC80211(priv, "leave\n");
+	return 0;
+}
+
+static int iwlagn_mac_tx_last_beacon(struct ieee80211_hw *hw)
+{
+	struct iwl_priv *priv = hw->priv;
+
+	return priv->ibss_manager == IWL_IBSS_MANAGER;
+}
+
+static int iwl_set_mode(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
+{
+	iwl_connection_init_rx_config(priv, ctx);
+
+	iwlagn_set_rxon_chain(priv, ctx);
+
+	return iwlagn_commit_rxon(priv, ctx);
+}
+
+static int iwl_setup_interface(struct iwl_priv *priv,
+			       struct iwl_rxon_context *ctx)
+{
+	struct ieee80211_vif *vif = ctx->vif;
+	int err;
+
+	lockdep_assert_held(&priv->shrd->mutex);
+
+	/*
+	 * This variable will be correct only when there's just
+	 * a single context, but all code using it is for hardware
+	 * that supports only one context.
+	 */
+	priv->iw_mode = vif->type;
+
+	ctx->is_active = true;
+
+	err = iwl_set_mode(priv, ctx);
+	if (err) {
+		if (!ctx->always_active)
+			ctx->is_active = false;
+		return err;
+	}
+
+	if (priv->cfg->bt_params && priv->cfg->bt_params->advanced_bt_coexist &&
+	    vif->type == NL80211_IFTYPE_ADHOC) {
+		/*
+		 * pretend to have high BT traffic as long as we
+		 * are operating in IBSS mode, as this will cause
+		 * the rate scaling etc. to behave as intended.
+		 */
+		priv->bt_traffic_load = IWL_BT_COEX_TRAFFIC_LOAD_HIGH;
+	}
+
+	return 0;
+}
+
+static int iwlagn_mac_add_interface(struct ieee80211_hw *hw,
+			     struct ieee80211_vif *vif)
+{
+	struct iwl_priv *priv = hw->priv;
+	struct iwl_vif_priv *vif_priv = (void *)vif->drv_priv;
+	struct iwl_rxon_context *tmp, *ctx = NULL;
+	int err;
+	enum nl80211_iftype viftype = ieee80211_vif_type_p2p(vif);
+
+	IWL_DEBUG_MAC80211(priv, "enter: type %d, addr %pM\n",
+			   viftype, vif->addr);
+
+	cancel_delayed_work_sync(&priv->hw_roc_disable_work);
+
+	mutex_lock(&priv->shrd->mutex);
+
+	iwlagn_disable_roc(priv);
+
+	if (!iwl_is_ready_rf(priv->shrd)) {
+		IWL_WARN(priv, "Try to add interface when device not ready\n");
+		err = -EINVAL;
+		goto out;
+	}
+
+	for_each_context(priv, tmp) {
+		u32 possible_modes =
+			tmp->interface_modes | tmp->exclusive_interface_modes;
+
+		if (tmp->vif) {
+			/* check if this busy context is exclusive */
+			if (tmp->exclusive_interface_modes &
+						BIT(tmp->vif->type)) {
+				err = -EINVAL;
+				goto out;
+			}
+			continue;
+		}
+
+		if (!(possible_modes & BIT(viftype)))
+			continue;
+
+		/* have maybe usable context w/o interface */
+		ctx = tmp;
+		break;
+	}
+
+	if (!ctx) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	vif_priv->ctx = ctx;
+	ctx->vif = vif;
+
+	err = iwl_setup_interface(priv, ctx);
+	if (!err)
+		goto out;
+
+	ctx->vif = NULL;
+	priv->iw_mode = NL80211_IFTYPE_STATION;
+ out:
+	mutex_unlock(&priv->shrd->mutex);
+
+	IWL_DEBUG_MAC80211(priv, "leave\n");
+	return err;
+}
+
+static void iwl_teardown_interface(struct iwl_priv *priv,
+				   struct ieee80211_vif *vif,
+				   bool mode_change)
+{
+	struct iwl_rxon_context *ctx = iwl_rxon_ctx_from_vif(vif);
+
+	lockdep_assert_held(&priv->shrd->mutex);
+
+	if (priv->scan_vif == vif) {
+		iwl_scan_cancel_timeout(priv, 200);
+		iwl_force_scan_end(priv);
+	}
+
+	if (!mode_change) {
+		iwl_set_mode(priv, ctx);
+		if (!ctx->always_active)
+			ctx->is_active = false;
+	}
+
+	/*
+	 * When removing the IBSS interface, overwrite the
+	 * BT traffic load with the stored one from the last
+	 * notification, if any. If this is a device that
+	 * doesn't implement this, this has no effect since
+	 * both values are the same and zero.
+	 */
+	if (vif->type == NL80211_IFTYPE_ADHOC)
+		priv->bt_traffic_load = priv->last_bt_traffic_load;
+}
+
+static void iwlagn_mac_remove_interface(struct ieee80211_hw *hw,
+			      struct ieee80211_vif *vif)
+{
+	struct iwl_priv *priv = hw->priv;
+	struct iwl_rxon_context *ctx = iwl_rxon_ctx_from_vif(vif);
+
+	IWL_DEBUG_MAC80211(priv, "enter\n");
+
+	mutex_lock(&priv->shrd->mutex);
+
+	if (WARN_ON(ctx->vif != vif)) {
+		struct iwl_rxon_context *tmp;
+		IWL_ERR(priv, "ctx->vif = %p, vif = %p\n", ctx->vif, vif);
+		for_each_context(priv, tmp)
+			IWL_ERR(priv, "\tID = %d:\tctx = %p\tctx->vif = %p\n",
+				tmp->ctxid, tmp, tmp->vif);
+	}
+	ctx->vif = NULL;
+
+	iwl_teardown_interface(priv, vif, false);
+
+	mutex_unlock(&priv->shrd->mutex);
+
+	IWL_DEBUG_MAC80211(priv, "leave\n");
+
+}
+
+static int iwlagn_mac_change_interface(struct ieee80211_hw *hw,
+				struct ieee80211_vif *vif,
+				enum nl80211_iftype newtype, bool newp2p)
+{
+	struct iwl_priv *priv = hw->priv;
+	struct iwl_rxon_context *ctx = iwl_rxon_ctx_from_vif(vif);
+	struct iwl_rxon_context *bss_ctx = &priv->contexts[IWL_RXON_CTX_BSS];
+	struct iwl_rxon_context *tmp;
+	enum nl80211_iftype newviftype = newtype;
+	u32 interface_modes;
+	int err;
+
+	IWL_DEBUG_MAC80211(priv, "enter\n");
+
+	newtype = ieee80211_iftype_p2p(newtype, newp2p);
+
+	mutex_lock(&priv->shrd->mutex);
+
+	if (!ctx->vif || !iwl_is_ready_rf(priv->shrd)) {
+		/*
+		 * Huh? But wait ... this can maybe happen when
+		 * we're in the middle of a firmware restart!
+		 */
+		err = -EBUSY;
+		goto out;
+	}
+
+	interface_modes = ctx->interface_modes | ctx->exclusive_interface_modes;
+
+	if (!(interface_modes & BIT(newtype))) {
+		err = -EBUSY;
+		goto out;
+	}
+
+	/*
+	 * Refuse a change that should be done by moving from the PAN
+	 * context to the BSS context instead, if the BSS context is
+	 * available and can support the new interface type.
+	 */
+	if (ctx->ctxid == IWL_RXON_CTX_PAN && !bss_ctx->vif &&
+	    (bss_ctx->interface_modes & BIT(newtype) ||
+	     bss_ctx->exclusive_interface_modes & BIT(newtype))) {
+		BUILD_BUG_ON(NUM_IWL_RXON_CTX != 2);
+		err = -EBUSY;
+		goto out;
+	}
+
+	if (ctx->exclusive_interface_modes & BIT(newtype)) {
+		for_each_context(priv, tmp) {
+			if (ctx == tmp)
+				continue;
+
+			if (!tmp->vif)
+				continue;
+
+			/*
+			 * The current mode switch would be exclusive, but
+			 * another context is active ... refuse the switch.
+			 */
+			err = -EBUSY;
+			goto out;
+		}
+	}
+
+	/* success */
+	iwl_teardown_interface(priv, vif, true);
+	vif->type = newviftype;
+	vif->p2p = newp2p;
+	err = iwl_setup_interface(priv, ctx);
+	WARN_ON(err);
+	/*
+	 * We've switched internally, but submitting to the
+	 * device may have failed for some reason. Mask this
+	 * error, because otherwise mac80211 will not switch
+	 * (and set the interface type back) and we'll be
+	 * out of sync with it.
+	 */
+	err = 0;
+
+ out:
+	mutex_unlock(&priv->shrd->mutex);
+	IWL_DEBUG_MAC80211(priv, "leave\n");
+
+	return err;
+}
+
 struct ieee80211_ops iwlagn_hw_ops = {
 	.tx = iwlagn_mac_tx,
 	.start = iwlagn_mac_start,
-- 
1.7.0.4

