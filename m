Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:1940 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752388Ab1ITXX3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Sep 2011 19:23:29 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 3/8] iwlagn: split remain-on-channel
Date: Tue, 20 Sep 2011 15:37:22 -0700
Message-Id: <1316558247-10018-4-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110921_012343_530204_77FA00F3)
In-Reply-To: <1316558247-10018-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1316558247-10018-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If we're associated and want to do P2P at the same
time, the scan for remain-on-channel is currently
limited to 80ms because of the way the device will
behave in that case. Instead of doing that, split
up the dwell times into little pieces. It will not
actually be a single big dwell time then, but will
be close enough. This improves robustness of P2P
in such scenarios.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c  |   10 +---
 drivers/net/wireless/iwlwifi/iwl-dev.h  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c |   99 +++++++++++++++++++------------
 3 files changed, 62 insertions(+), 49 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index fcfb410..baaf486 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2770,15 +2770,6 @@ static int iwl_mac_remain_on_channel(struct ieee80211_hw *hw,
 
 	mutex_lock(&priv->shrd->mutex);
 
-	/*
-	 * TODO: Remove this hack! Firmware needs to be updated
-	 * to allow longer off-channel periods in scanning for
-	 * this use case, based on a flag (and we'll need an API
-	 * flag in the firmware when it has that).
-	 */
-	if (iwl_is_associated(priv, IWL_RXON_CTX_BSS) && duration > 80)
-		duration = 80;
-
 	if (test_bit(STATUS_SCAN_HW, &priv->shrd->status)) {
 		err = -EBUSY;
 		goto out;
@@ -2787,6 +2778,7 @@ static int iwl_mac_remain_on_channel(struct ieee80211_hw *hw,
 	priv->hw_roc_channel = channel;
 	priv->hw_roc_chantype = channel_type;
 	priv->hw_roc_duration = duration;
+	priv->hw_roc_start_notified = false;
 	cancel_delayed_work(&priv->hw_roc_disable_work);
 
 	if (!ctx->is_active) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index fabfc8b..7f534c4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1029,7 +1029,7 @@ struct iwl_priv {
 	struct delayed_work hw_roc_disable_work;
 	enum nl80211_channel_type hw_roc_chantype;
 	int hw_roc_duration;
-	bool hw_roc_setup;
+	bool hw_roc_setup, hw_roc_start_notified;
 
 	/* bt coex */
 	u8 bt_enable_flag;
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 8ac6b05..8386a86 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -218,8 +218,11 @@ static void iwl_rx_scan_start_notif(struct iwl_priv *priv,
 		       le32_to_cpu(notif->tsf_low),
 		       notif->status, notif->beacon_timer);
 
-	if (priv->scan_type == IWL_SCAN_ROC)
+	if (priv->scan_type == IWL_SCAN_ROC &&
+	    !priv->hw_roc_start_notified) {
 		ieee80211_ready_on_channel(priv->hw);
+		priv->hw_roc_start_notified = true;
+	}
 }
 
 /* Service SCAN_RESULTS_NOTIFICATION (0x83) */
@@ -310,34 +313,38 @@ static u16 iwl_get_active_dwell_time(struct iwl_priv *priv,
 			IWL_ACTIVE_DWELL_FACTOR_24GHZ * (n_probes + 1);
 }
 
+static u16 iwl_limit_dwell(struct iwl_priv *priv, u16 dwell_time)
+{
+	struct iwl_rxon_context *ctx;
+
+	/*
+	 * If we're associated, we clamp the dwell time 98%
+	 * of the smallest beacon interval (minus 2 * channel
+	 * tune time)
+	 */
+	for_each_context(priv, ctx) {
+		u16 value;
+
+		if (!iwl_is_associated_ctx(ctx))
+			continue;
+		value = ctx->beacon_int;
+		if (!value)
+			value = IWL_PASSIVE_DWELL_BASE;
+		value = (value * 98) / 100 - IWL_CHANNEL_TUNE_TIME * 2;
+		dwell_time = min(value, dwell_time);
+	}
+
+	return dwell_time;
+}
+
 static u16 iwl_get_passive_dwell_time(struct iwl_priv *priv,
 				      enum ieee80211_band band)
 {
-	struct iwl_rxon_context *ctx;
 	u16 passive = (band == IEEE80211_BAND_2GHZ) ?
 	    IWL_PASSIVE_DWELL_BASE + IWL_PASSIVE_DWELL_TIME_24 :
 	    IWL_PASSIVE_DWELL_BASE + IWL_PASSIVE_DWELL_TIME_52;
 
-	if (iwl_is_any_associated(priv)) {
-		/*
-		 * If we're associated, we clamp the maximum passive
-		 * dwell time to be 98% of the smallest beacon interval
-		 * (minus 2 * channel tune time)
-		 */
-		for_each_context(priv, ctx) {
-			u16 value;
-
-			if (!iwl_is_associated_ctx(ctx))
-				continue;
-			value = ctx->vif ? ctx->vif->bss_conf.beacon_int : 0;
-			if ((value > IWL_PASSIVE_DWELL_BASE) || !value)
-				value = IWL_PASSIVE_DWELL_BASE;
-			value = (value * 98) / 100 - IWL_CHANNEL_TUNE_TIME * 2;
-			passive = min(value, passive);
-		}
-	}
-
-	return passive;
+	return iwl_limit_dwell(priv, passive);
 }
 
 static int iwl_get_single_channel_for_scan(struct iwl_priv *priv,
@@ -716,29 +723,43 @@ static int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 		break;
 	case IWL_SCAN_ROC: {
 		struct iwl_scan_channel *scan_ch;
+		int n_chan, i;
+		u16 dwell;
+
+		dwell = iwl_limit_dwell(priv, priv->hw_roc_duration);
+		n_chan = DIV_ROUND_UP(priv->hw_roc_duration, dwell);
 
-		scan->channel_count = 1;
+		scan->channel_count = n_chan;
 
 		scan_ch = (void *)&scan->data[cmd_len];
-		scan_ch->type = SCAN_CHANNEL_TYPE_PASSIVE;
-		scan_ch->channel =
-			cpu_to_le16(priv->hw_roc_channel->hw_value);
-		scan_ch->active_dwell =
-		scan_ch->passive_dwell =
-			cpu_to_le16(priv->hw_roc_duration);
 
-		/* Set txpower levels to defaults */
-		scan_ch->dsp_atten = 110;
+		for (i = 0; i < n_chan; i++) {
+			scan_ch->type = SCAN_CHANNEL_TYPE_PASSIVE;
+			scan_ch->channel =
+				cpu_to_le16(priv->hw_roc_channel->hw_value);
 
-		/* NOTE: if we were doing 6Mb OFDM for scans we'd use
-		 * power level:
-		 * scan_ch->tx_gain = ((1 << 5) | (2 << 3)) | 3;
-		 */
-		if (priv->hw_roc_channel->band == IEEE80211_BAND_5GHZ)
-			scan_ch->tx_gain = ((1 << 5) | (3 << 3)) | 3;
-		else
-			scan_ch->tx_gain = ((1 << 5) | (5 << 3));
+			if (i == n_chan - 1)
+				dwell = priv->hw_roc_duration - i * dwell;
+
+			scan_ch->active_dwell =
+			scan_ch->passive_dwell = cpu_to_le16(dwell);
+
+			/* Set txpower levels to defaults */
+			scan_ch->dsp_atten = 110;
+
+			/* NOTE: if we were doing 6Mb OFDM for scans we'd use
+			 * power level:
+			 * scan_ch->tx_gain = ((1 << 5) | (2 << 3)) | 3;
+			 */
+			if (priv->hw_roc_channel->band == IEEE80211_BAND_5GHZ)
+				scan_ch->tx_gain = ((1 << 5) | (3 << 3)) | 3;
+			else
+				scan_ch->tx_gain = ((1 << 5) | (5 << 3));
+
+			scan_ch++;
 		}
+		}
+
 		break;
 	}
 
-- 
1.7.0.4

