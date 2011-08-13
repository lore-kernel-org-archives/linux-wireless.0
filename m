Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:37604 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751721Ab1HMQ57 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 12:57:59 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 08/13] iwlagn: support new P2P implementation
Date: Sat, 13 Aug 2011 09:18:02 -0700
Message-Id: <1313252287-22858-8-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110813_185811_783192_CBE294B8)
In-Reply-To: <1313252287-22858-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1313252287-22858-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The previous P2P implementation turned out to
not work well and new uCode capabilities were
added to support P2P. Modify the driver to
take advantage of those, and also discover P2P
support automatically based on a uCode flag
instead of having a Kconfig symbol for P2P.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/Kconfig        |   17 ---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |   47 ++-----
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |   23 +---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c   |   30 ++---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |  190 ++++++++++----------------
 drivers/net/wireless/iwlwifi/iwl-agn.h      |    1 +
 drivers/net/wireless/iwlwifi/iwl-core.c     |    5 +
 drivers/net/wireless/iwlwifi/iwl-dev.h      |   10 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c     |   19 ++-
 9 files changed, 127 insertions(+), 215 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index ad3bdba..1d7572f 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -111,20 +111,3 @@ config IWLWIFI_DEVICE_SVTOOL
 	  NL80211_TESTMODE. svtool is a software validation tool that runs in
 	  the user space and interacts with the device in the kernel space
 	  through the generic netlink message via NL80211_TESTMODE channel.
-
-config IWL_P2P
-	bool "iwlwifi experimental P2P support"
-	depends on IWLAGN
-	help
-	  This option enables experimental P2P support for some devices
-	  based on microcode support. Since P2P support is still under
-	  development, this option may even enable it for some devices
-	  now that turn out to not support it in the future due to
-	  microcode restrictions.
-
-	  To determine if your microcode supports the experimental P2P
-	  offered by this option, check if the driver advertises AP
-	  support when it is loaded.
-
-	  Say Y only if you want to experiment with P2P.
-
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 3bee0f1..4edb6cf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -753,18 +753,6 @@ static int iwl_get_channels_for_scan(struct iwl_priv *priv,
 	return added;
 }
 
-static int iwl_fill_offch_tx(struct iwl_priv *priv, void *data, size_t maxlen)
-{
-	struct sk_buff *skb = priv->offchan_tx_skb;
-
-	if (skb->len < maxlen)
-		maxlen = skb->len;
-
-	memcpy(data, skb->data, maxlen);
-
-	return maxlen;
-}
-
 int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 {
 	struct iwl_host_cmd cmd = {
@@ -807,7 +795,7 @@ int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	scan->quiet_plcp_th = IWL_PLCP_QUIET_THRESH;
 	scan->quiet_time = IWL_ACTIVE_QUIET_TIME;
 
-	if (priv->scan_type != IWL_SCAN_OFFCH_TX &&
+	if (priv->scan_type != IWL_SCAN_ROC &&
 	    iwl_is_any_associated(priv)) {
 		u16 interval = 0;
 		u32 extra;
@@ -816,7 +804,7 @@ int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 
 		IWL_DEBUG_INFO(priv, "Scanning while associated...\n");
 		switch (priv->scan_type) {
-		case IWL_SCAN_OFFCH_TX:
+		case IWL_SCAN_ROC:
 			WARN_ON(1);
 			break;
 		case IWL_SCAN_RADIO_RESET:
@@ -838,10 +826,11 @@ int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 		scan->suspend_time = cpu_to_le32(scan_suspend_time);
 		IWL_DEBUG_SCAN(priv, "suspend_time 0x%X beacon interval %d\n",
 			       scan_suspend_time, interval);
-	} else if (priv->scan_type == IWL_SCAN_OFFCH_TX) {
+	} else if (priv->scan_type == IWL_SCAN_ROC) {
 		scan->suspend_time = 0;
-		scan->max_out_time =
-			cpu_to_le32(1024 * priv->offchan_tx_timeout);
+		scan->max_out_time = 0;
+		scan->quiet_time = 0;
+		scan->quiet_plcp_th = 0;
 	}
 
 	switch (priv->scan_type) {
@@ -869,8 +858,8 @@ int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 		} else
 			IWL_DEBUG_SCAN(priv, "Start passive scan.\n");
 		break;
-	case IWL_SCAN_OFFCH_TX:
-		IWL_DEBUG_SCAN(priv, "Start offchannel TX scan.\n");
+	case IWL_SCAN_ROC:
+		IWL_DEBUG_SCAN(priv, "Start ROC scan.\n");
 		break;
 	}
 
@@ -988,19 +977,13 @@ int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 					IWL_MAX_SCAN_SIZE - sizeof(*scan));
 		break;
 	case IWL_SCAN_RADIO_RESET:
+	case IWL_SCAN_ROC:
 		/* use bcast addr, will not be transmitted but must be valid */
 		cmd_len = iwl_fill_probe_req(priv,
 					(struct ieee80211_mgmt *)scan->data,
 					iwl_bcast_addr, NULL, 0,
 					IWL_MAX_SCAN_SIZE - sizeof(*scan));
 		break;
-	case IWL_SCAN_OFFCH_TX:
-		cmd_len = iwl_fill_offch_tx(priv, scan->data,
-					    IWL_MAX_SCAN_SIZE
-					     - sizeof(*scan)
-					     - sizeof(struct iwl_scan_channel));
-		scan->scan_flags |= IWL_SCAN_FLAGS_ACTION_FRAME_TX;
-		break;
 	default:
 		BUG();
 	}
@@ -1021,18 +1004,18 @@ int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 				is_active, n_probes,
 				(void *)&scan->data[cmd_len]);
 		break;
-	case IWL_SCAN_OFFCH_TX: {
+	case IWL_SCAN_ROC: {
 		struct iwl_scan_channel *scan_ch;
 
 		scan->channel_count = 1;
 
 		scan_ch = (void *)&scan->data[cmd_len];
-		scan_ch->type = SCAN_CHANNEL_TYPE_ACTIVE;
+		scan_ch->type = SCAN_CHANNEL_TYPE_PASSIVE;
 		scan_ch->channel =
-			cpu_to_le16(priv->offchan_tx_chan->hw_value);
+			cpu_to_le16(priv->hw_roc_channel->hw_value);
 		scan_ch->active_dwell =
-			cpu_to_le16(priv->offchan_tx_timeout);
-		scan_ch->passive_dwell = 0;
+		scan_ch->passive_dwell =
+			cpu_to_le16(priv->hw_roc_duration);
 
 		/* Set txpower levels to defaults */
 		scan_ch->dsp_atten = 110;
@@ -1041,7 +1024,7 @@ int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 		 * power level:
 		 * scan_ch->tx_gain = ((1 << 5) | (2 << 3)) | 3;
 		 */
-		if (priv->offchan_tx_chan->band == IEEE80211_BAND_5GHZ)
+		if (priv->hw_roc_channel->band == IEEE80211_BAND_5GHZ)
 			scan_ch->tx_gain = ((1 << 5) | (3 << 3)) | 3;
 		else
 			scan_ch->tx_gain = ((1 << 5) | (5 << 3));
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index 1428bcf..903b2d9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -337,10 +337,10 @@ int iwlagn_set_pan_params(struct iwl_priv *priv)
 	cmd.slots[0].type = 0; /* BSS */
 	cmd.slots[1].type = 1; /* PAN */
 
-	if (priv->hw_roc_channel) {
+	if (priv->hw_roc_setup) {
 		/* both contexts must be used for this to happen */
-		slot1 = priv->hw_roc_duration;
-		slot0 = IWL_MIN_SLOT_TIME;
+		slot1 = IWL_MIN_SLOT_TIME;
+		slot0 = 3000;
 	} else if (ctx_bss->vif && ctx_pan->vif) {
 		int bcnint = ctx_pan->beacon_int;
 		int dtim = ctx_pan->vif->bss_conf.dtim_period ?: 1;
@@ -441,23 +441,6 @@ int iwlagn_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 	/* always get timestamp with Rx frame */
 	ctx->staging.flags |= RXON_FLG_TSF2HOST_MSK;
 
-	if (ctx->ctxid == IWL_RXON_CTX_PAN && priv->hw_roc_channel) {
-		struct ieee80211_channel *chan = priv->hw_roc_channel;
-
-		iwl_set_rxon_channel(priv, chan, ctx);
-		iwl_set_flags_for_band(priv, ctx, chan->band, NULL);
-		ctx->staging.filter_flags |=
-			RXON_FILTER_ASSOC_MSK |
-			RXON_FILTER_PROMISC_MSK |
-			RXON_FILTER_CTL2HOST_MSK;
-		ctx->staging.dev_type = RXON_DEV_TYPE_P2P;
-		new_assoc = true;
-
-		if (memcmp(&ctx->staging, &ctx->active,
-			   sizeof(ctx->staging)) == 0)
-			return 0;
-	}
-
 	/*
 	 * force CTS-to-self frames protection if RTS-CTS is not preferred
 	 * one aggregation protection method
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 53bb59e..9bc26da 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -128,11 +128,10 @@ static void iwlagn_tx_cmd_protection(struct iwl_priv *priv,
  * handle build REPLY_TX command notification.
  */
 static void iwlagn_tx_cmd_build_basic(struct iwl_priv *priv,
-					struct sk_buff *skb,
-					struct iwl_tx_cmd *tx_cmd,
-					struct ieee80211_tx_info *info,
-					struct ieee80211_hdr *hdr,
-					u8 std_id)
+				      struct sk_buff *skb,
+				      struct iwl_tx_cmd *tx_cmd,
+				      struct ieee80211_tx_info *info,
+				      struct ieee80211_hdr *hdr, u8 sta_id)
 {
 	__le16 fc = hdr->frame_control;
 	__le32 tx_flags = tx_cmd->tx_flags;
@@ -157,7 +156,7 @@ static void iwlagn_tx_cmd_build_basic(struct iwl_priv *priv,
 		tx_flags |= TX_CMD_FLG_IGNORE_BT;
 
 
-	tx_cmd->sta_id = std_id;
+	tx_cmd->sta_id = sta_id;
 	if (ieee80211_has_morefrags(fc))
 		tx_flags |= TX_CMD_FLG_MORE_FRAG_MSK;
 
@@ -189,9 +188,9 @@ static void iwlagn_tx_cmd_build_basic(struct iwl_priv *priv,
 #define RTS_DFAULT_RETRY_LIMIT		60
 
 static void iwlagn_tx_cmd_build_rate(struct iwl_priv *priv,
-			      struct iwl_tx_cmd *tx_cmd,
-			      struct ieee80211_tx_info *info,
-			      __le16 fc)
+				     struct iwl_tx_cmd *tx_cmd,
+				     struct ieee80211_tx_info *info,
+				     __le16 fc)
 {
 	u32 rate_flags;
 	int rate_idx;
@@ -334,14 +333,7 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	unsigned long flags;
 	bool is_agg = false;
 
-	/*
-	 * If the frame needs to go out off-channel, then
-	 * we'll have put the PAN context to that channel,
-	 * so make the frame go out there.
-	 */
-	if (info->flags & IEEE80211_TX_CTL_TX_OFFCHAN)
-		ctx = &priv->contexts[IWL_RXON_CTX_PAN];
-	else if (info->control.vif)
+	if (info->control.vif)
 		ctx = iwl_rxon_ctx_from_vif(info->control.vif);
 
 	spin_lock_irqsave(&priv->lock, flags);
@@ -407,7 +399,9 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 		 */
 		hdr->frame_control |=
 			cpu_to_le16(IEEE80211_FCTL_MOREDATA);
-	} else
+	} else if (info->flags & IEEE80211_TX_CTL_TX_OFFCHAN)
+		txq_id = IWL_AUX_QUEUE;
+	else
 		txq_id = ctx->ac_to_queue[skb_get_queue_mapping(skb)];
 
 	/* irqs already disabled/saved above when locking priv->lock */
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 8819fc9..c8ad0cb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -681,10 +681,12 @@ static void iwl_init_context(struct iwl_priv *priv, u32 ucode_flags)
 	priv->contexts[IWL_RXON_CTX_PAN].mcast_queue = IWL_IPAN_MCAST_QUEUE;
 	priv->contexts[IWL_RXON_CTX_PAN].interface_modes =
 		BIT(NL80211_IFTYPE_STATION) | BIT(NL80211_IFTYPE_AP);
-#ifdef CONFIG_IWL_P2P
-	priv->contexts[IWL_RXON_CTX_PAN].interface_modes |=
-		BIT(NL80211_IFTYPE_P2P_CLIENT) | BIT(NL80211_IFTYPE_P2P_GO);
-#endif
+
+	if (ucode_flags & IWL_UCODE_TLV_FLAGS_P2P)
+		priv->contexts[IWL_RXON_CTX_PAN].interface_modes |=
+			BIT(NL80211_IFTYPE_P2P_CLIENT) |
+			BIT(NL80211_IFTYPE_P2P_GO);
+
 	priv->contexts[IWL_RXON_CTX_PAN].ap_devtype = RXON_DEV_TYPE_CP;
 	priv->contexts[IWL_RXON_CTX_PAN].station_devtype = RXON_DEV_TYPE_2STA;
 	priv->contexts[IWL_RXON_CTX_PAN].unused_devtype = RXON_DEV_TYPE_P2P;
@@ -1235,6 +1237,13 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	if (!(priv->cfg->sku & EEPROM_SKU_CAP_IPAN_ENABLE))
 		ucode_capa.flags &= ~IWL_UCODE_TLV_FLAGS_PAN;
 
+	/*
+	 * if not PAN, then don't support P2P -- might be a uCode
+	 * packaging bug or due to the eeprom check above
+	 */
+	if (!(ucode_capa.flags & IWL_UCODE_TLV_FLAGS_PAN))
+		ucode_capa.flags &= ~IWL_UCODE_TLV_FLAGS_P2P;
+
 	if (ucode_capa.flags & IWL_UCODE_TLV_FLAGS_PAN) {
 		priv->sta_key_max_num = STA_KEY_MAX_NUM_PAN;
 		priv->cmd_queue = IWL_IPAN_CMD_QUEUE_NUM;
@@ -1856,6 +1865,13 @@ static void __iwl_down(struct iwl_priv *priv)
 
 	iwl_scan_cancel_timeout(priv, 200);
 
+	/*
+	 * If active, scanning won't cancel it, so say it expired.
+	 * No race since we hold the mutex here and a new one
+	 * can't come in at this time.
+	 */
+	ieee80211_remain_on_channel_expired(priv->hw);
+
 	exit_pending = test_and_set_bit(STATUS_EXIT_PENDING, &priv->status);
 
 	/* Stop TX queues watchdog. We need to have STATUS_EXIT_PENDING bit set
@@ -2046,94 +2062,6 @@ static void iwl_bg_restart(struct work_struct *data)
 	}
 }
 
-static int iwl_mac_offchannel_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
-				 struct ieee80211_channel *chan,
-				 enum nl80211_channel_type channel_type,
-				 unsigned int wait)
-{
-	struct iwl_priv *priv = hw->priv;
-	int ret;
-
-	/* Not supported if we don't have PAN */
-	if (!(priv->valid_contexts & BIT(IWL_RXON_CTX_PAN))) {
-		ret = -EOPNOTSUPP;
-		goto free;
-	}
-
-	/* Not supported on pre-P2P firmware */
-	if (!(priv->contexts[IWL_RXON_CTX_PAN].interface_modes &
-					BIT(NL80211_IFTYPE_P2P_CLIENT))) {
-		ret = -EOPNOTSUPP;
-		goto free;
-	}
-
-	mutex_lock(&priv->mutex);
-
-	if (!priv->contexts[IWL_RXON_CTX_PAN].is_active) {
-		/*
-		 * If the PAN context is free, use the normal
-		 * way of doing remain-on-channel offload + TX.
-		 */
-		ret = 1;
-		goto out;
-	}
-
-	/* TODO: queue up if scanning? */
-	if (test_bit(STATUS_SCANNING, &priv->status) ||
-	    priv->offchan_tx_skb) {
-		ret = -EBUSY;
-		goto out;
-	}
-
-	/*
-	 * max_scan_ie_len doesn't include the blank SSID or the header,
-	 * so need to add that again here.
-	 */
-	if (skb->len > hw->wiphy->max_scan_ie_len + 24 + 2) {
-		ret = -ENOBUFS;
-		goto out;
-	}
-
-	priv->offchan_tx_skb = skb;
-	priv->offchan_tx_timeout = wait;
-	priv->offchan_tx_chan = chan;
-
-	ret = iwl_scan_initiate(priv, priv->contexts[IWL_RXON_CTX_PAN].vif,
-				IWL_SCAN_OFFCH_TX, chan->band);
-	if (ret)
-		priv->offchan_tx_skb = NULL;
- out:
-	mutex_unlock(&priv->mutex);
- free:
-	if (ret < 0)
-		kfree_skb(skb);
-
-	return ret;
-}
-
-static int iwl_mac_offchannel_tx_cancel_wait(struct ieee80211_hw *hw)
-{
-	struct iwl_priv *priv = hw->priv;
-	int ret;
-
-	mutex_lock(&priv->mutex);
-
-	if (!priv->offchan_tx_skb) {
-		ret = -EINVAL;
-		goto unlock;
-	}
-
-	priv->offchan_tx_skb = NULL;
-
-	ret = iwl_scan_cancel_timeout(priv, 200);
-	if (ret)
-		ret = -EIO;
-unlock:
-	mutex_unlock(&priv->mutex);
-
-	return ret;
-}
-
 /*****************************************************************************
  *
  * mac80211 entry point functions
@@ -3285,35 +3213,34 @@ done:
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 }
 
-static void iwlagn_disable_roc(struct iwl_priv *priv)
+void iwlagn_disable_roc(struct iwl_priv *priv)
 {
 	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_PAN];
-	struct ieee80211_channel *chan = ACCESS_ONCE(priv->hw->conf.channel);
 
 	lockdep_assert_held(&priv->mutex);
 
-	if (!ctx->is_active)
+	if (!priv->hw_roc_setup)
 		return;
 
-	ctx->staging.dev_type = RXON_DEV_TYPE_2STA;
+	ctx->staging.dev_type = RXON_DEV_TYPE_P2P;
 	ctx->staging.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
-	iwl_set_rxon_channel(priv, chan, ctx);
-	iwl_set_flags_for_band(priv, ctx, chan->band, NULL);
 
 	priv->hw_roc_channel = NULL;
 
+	memset(ctx->staging.node_addr, 0, ETH_ALEN);
+
 	iwlagn_commit_rxon(priv, ctx);
 
 	ctx->is_active = false;
+	priv->hw_roc_setup = false;
 }
 
-static void iwlagn_bg_roc_done(struct work_struct *work)
+static void iwlagn_disable_roc_work(struct work_struct *work)
 {
 	struct iwl_priv *priv = container_of(work, struct iwl_priv,
-					     hw_roc_work.work);
+					     hw_roc_disable_work.work);
 
 	mutex_lock(&priv->mutex);
-	ieee80211_remain_on_channel_expired(priv->hw);
 	iwlagn_disable_roc(priv);
 	mutex_unlock(&priv->mutex);
 }
@@ -3324,33 +3251,63 @@ static int iwl_mac_remain_on_channel(struct ieee80211_hw *hw,
 				     int duration)
 {
 	struct iwl_priv *priv = hw->priv;
+	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_PAN];
 	int err = 0;
 
 	if (!(priv->valid_contexts & BIT(IWL_RXON_CTX_PAN)))
 		return -EOPNOTSUPP;
 
-	if (!(priv->contexts[IWL_RXON_CTX_PAN].interface_modes &
-					BIT(NL80211_IFTYPE_P2P_CLIENT)))
+	if (!(ctx->interface_modes & BIT(NL80211_IFTYPE_P2P_CLIENT)))
 		return -EOPNOTSUPP;
 
 	mutex_lock(&priv->mutex);
 
-	if (priv->contexts[IWL_RXON_CTX_PAN].is_active ||
-	    test_bit(STATUS_SCAN_HW, &priv->status)) {
+	/*
+	 * TODO: Remove this hack! Firmware needs to be updated
+	 * to allow longer off-channel periods in scanning for
+	 * this use case, based on a flag (and we'll need an API
+	 * flag in the firmware when it has that).
+	 */
+	if (iwl_is_associated(priv, IWL_RXON_CTX_BSS) && duration > 80)
+		duration = 80;
+
+	if (test_bit(STATUS_SCAN_HW, &priv->status)) {
 		err = -EBUSY;
 		goto out;
 	}
 
-	priv->contexts[IWL_RXON_CTX_PAN].is_active = true;
 	priv->hw_roc_channel = channel;
 	priv->hw_roc_chantype = channel_type;
-	priv->hw_roc_duration = DIV_ROUND_UP(duration * 1000, 1024);
-	iwlagn_commit_rxon(priv, &priv->contexts[IWL_RXON_CTX_PAN]);
-	queue_delayed_work(priv->workqueue, &priv->hw_roc_work,
-			   msecs_to_jiffies(duration + 20));
+	priv->hw_roc_duration = duration;
+	cancel_delayed_work(&priv->hw_roc_disable_work);
+
+	if (!ctx->is_active) {
+		ctx->is_active = true;
+		ctx->staging.dev_type = RXON_DEV_TYPE_P2P;
+		memcpy(ctx->staging.node_addr,
+		       priv->contexts[IWL_RXON_CTX_BSS].staging.node_addr,
+		       ETH_ALEN);
+		memcpy(ctx->staging.bssid_addr,
+		       priv->contexts[IWL_RXON_CTX_BSS].staging.node_addr,
+		       ETH_ALEN);
+		err = iwlagn_commit_rxon(priv, ctx);
+		if (err)
+			goto out;
+		ctx->staging.filter_flags |= RXON_FILTER_ASSOC_MSK |
+					     RXON_FILTER_PROMISC_MSK |
+					     RXON_FILTER_CTL2HOST_MSK;
+
+		err = iwlagn_commit_rxon(priv, ctx);
+		if (err) {
+			iwlagn_disable_roc(priv);
+			goto out;
+		}
+		priv->hw_roc_setup = true;
+	}
 
-	msleep(IWL_MIN_SLOT_TIME); /* TU is almost ms */
-	ieee80211_ready_on_channel(priv->hw);
+	err = iwl_scan_initiate(priv, ctx->vif, IWL_SCAN_ROC, channel->band);
+	if (err)
+		iwlagn_disable_roc(priv);
 
  out:
 	mutex_unlock(&priv->mutex);
@@ -3365,9 +3322,8 @@ static int iwl_mac_cancel_remain_on_channel(struct ieee80211_hw *hw)
 	if (!(priv->valid_contexts & BIT(IWL_RXON_CTX_PAN)))
 		return -EOPNOTSUPP;
 
-	cancel_delayed_work_sync(&priv->hw_roc_work);
-
 	mutex_lock(&priv->mutex);
+	iwl_scan_cancel_timeout(priv, priv->hw_roc_duration);
 	iwlagn_disable_roc(priv);
 	mutex_unlock(&priv->mutex);
 
@@ -3458,7 +3414,8 @@ static void iwl_setup_deferred_work(struct iwl_priv *priv)
 	INIT_WORK(&priv->tx_flush, iwl_bg_tx_flush);
 	INIT_WORK(&priv->bt_full_concurrency, iwl_bg_bt_full_concurrency);
 	INIT_WORK(&priv->bt_runtime_config, iwl_bg_bt_runtime_config);
-	INIT_DELAYED_WORK(&priv->hw_roc_work, iwlagn_bg_roc_done);
+	INIT_DELAYED_WORK(&priv->hw_roc_disable_work,
+			  iwlagn_disable_roc_work);
 
 	iwl_setup_scan_deferred_work(priv);
 
@@ -3490,6 +3447,7 @@ static void iwl_cancel_deferred_work(struct iwl_priv *priv)
 
 	cancel_work_sync(&priv->bt_full_concurrency);
 	cancel_work_sync(&priv->bt_runtime_config);
+	cancel_delayed_work_sync(&priv->hw_roc_disable_work);
 
 	del_timer_sync(&priv->statistics_periodic);
 	del_timer_sync(&priv->ucode_trace);
@@ -3640,8 +3598,6 @@ struct ieee80211_ops iwlagn_hw_ops = {
 	.tx_last_beacon = iwl_mac_tx_last_beacon,
 	.remain_on_channel = iwl_mac_remain_on_channel,
 	.cancel_remain_on_channel = iwl_mac_cancel_remain_on_channel,
-	.offchannel_tx = iwl_mac_offchannel_tx,
-	.offchannel_tx_cancel_wait = iwl_mac_offchannel_tx_cancel_wait,
 	.rssi_callback = iwl_mac_rssi_callback,
 	CFG80211_TESTMODE_CMD(iwl_testmode_cmd)
 	CFG80211_TESTMODE_DUMP(iwl_testmode_dump)
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index d941c4c..df2960a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -209,6 +209,7 @@ u8 iwl_toggle_tx_ant(struct iwl_priv *priv, u8 ant_idx, u8 valid);
 /* scan */
 int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif);
 void iwlagn_post_scan(struct iwl_priv *priv);
+void iwlagn_disable_roc(struct iwl_priv *priv);
 
 /* station mgmt */
 int iwlagn_manage_ibss_station(struct iwl_priv *priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index cf376f6..e269987 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -40,6 +40,7 @@
 #include "iwl-io.h"
 #include "iwl-power.h"
 #include "iwl-sta.h"
+#include "iwl-agn.h"
 #include "iwl-helpers.h"
 #include "iwl-agn.h"
 #include "iwl-trans.h"
@@ -1273,8 +1274,12 @@ int iwl_mac_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	IWL_DEBUG_MAC80211(priv, "enter: type %d, addr %pM\n",
 			   viftype, vif->addr);
 
+	cancel_delayed_work_sync(&priv->hw_roc_disable_work);
+
 	mutex_lock(&priv->mutex);
 
+	iwlagn_disable_roc(priv);
+
 	if (!iwl_is_ready_rf(priv)) {
 		IWL_WARN(priv, "Try to add interface when device not ready\n");
 		err = -EINVAL;
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 4349782..2698ec0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -574,11 +574,13 @@ enum iwl_ucode_tlv_type {
  * @IWL_UCODE_TLV_FLAGS_NEWSCAN: new uCode scan behaviour on hidden SSID,
  *	treats good CRC threshold as a boolean
  * @IWL_UCODE_TLV_FLAGS_MFP: This uCode image supports MFP (802.11w).
+ * @IWL_UCODE_TLV_FLAGS_P2P: This uCode image supports P2P.
  */
 enum iwl_ucode_tlv_flag {
 	IWL_UCODE_TLV_FLAGS_PAN		= BIT(0),
 	IWL_UCODE_TLV_FLAGS_NEWSCAN	= BIT(1),
 	IWL_UCODE_TLV_FLAGS_MFP		= BIT(2),
+	IWL_UCODE_TLV_FLAGS_P2P		= BIT(3),
 };
 
 struct iwl_ucode_tlv {
@@ -1181,7 +1183,7 @@ struct iwl_rxon_context {
 enum iwl_scan_type {
 	IWL_SCAN_NORMAL,
 	IWL_SCAN_RADIO_RESET,
-	IWL_SCAN_OFFCH_TX,
+	IWL_SCAN_ROC,
 };
 
 enum iwlagn_ucode_type {
@@ -1451,15 +1453,11 @@ struct iwl_priv {
 
 	/* remain-on-channel offload support */
 	struct ieee80211_channel *hw_roc_channel;
-	struct delayed_work hw_roc_work;
+	struct delayed_work hw_roc_disable_work;
 	enum nl80211_channel_type hw_roc_chantype;
 	int hw_roc_duration;
 	bool hw_roc_setup;
 
-	struct sk_buff *offchan_tx_skb;
-	int offchan_tx_timeout;
-	struct ieee80211_channel *offchan_tx_chan;
-
 	/* bt coex */
 	u8 bt_enable_flag;
 	u8 bt_status;
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index dd6937e..28e5931 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -103,6 +103,12 @@ static void iwl_complete_scan(struct iwl_priv *priv, bool aborted)
 		ieee80211_scan_completed(priv->hw, aborted);
 	}
 
+	if (priv->scan_type == IWL_SCAN_ROC) {
+		ieee80211_remain_on_channel_expired(priv->hw);
+		priv->hw_roc_channel = NULL;
+		schedule_delayed_work(&priv->hw_roc_disable_work, 10 * HZ);
+	}
+
 	priv->scan_type = IWL_SCAN_NORMAL;
 	priv->scan_vif = NULL;
 	priv->scan_request = NULL;
@@ -211,6 +217,9 @@ static void iwl_rx_scan_start_notif(struct iwl_priv *priv,
 		       le32_to_cpu(notif->tsf_high),
 		       le32_to_cpu(notif->tsf_low),
 		       notif->status, notif->beacon_timer);
+
+	if (priv->scan_type == IWL_SCAN_ROC)
+		ieee80211_ready_on_channel(priv->hw);
 }
 
 /* Service SCAN_RESULTS_NOTIFICATION (0x83) */
@@ -370,7 +379,7 @@ int __must_check iwl_scan_initiate(struct iwl_priv *priv,
 
 	IWL_DEBUG_SCAN(priv, "Starting %sscan...\n",
 			scan_type == IWL_SCAN_NORMAL ? "" :
-			scan_type == IWL_SCAN_OFFCH_TX ? "offchan TX " :
+			scan_type == IWL_SCAN_ROC ? "remain-on-channel " :
 			"internal short ");
 
 	set_bit(STATUS_SCANNING, &priv->status);
@@ -565,10 +574,10 @@ static void iwl_bg_scan_completed(struct work_struct *work)
 		goto out_settings;
 	}
 
-	if (priv->scan_type == IWL_SCAN_OFFCH_TX && priv->offchan_tx_skb) {
-		ieee80211_tx_status_irqsafe(priv->hw,
-					    priv->offchan_tx_skb);
-		priv->offchan_tx_skb = NULL;
+	if (priv->scan_type == IWL_SCAN_ROC) {
+		ieee80211_remain_on_channel_expired(priv->hw);
+		priv->hw_roc_channel = NULL;
+		schedule_delayed_work(&priv->hw_roc_disable_work, 10 * HZ);
 	}
 
 	if (priv->scan_type != IWL_SCAN_NORMAL && !aborted) {
-- 
1.7.0.4

