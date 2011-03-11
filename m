Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:45130 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751272Ab1CKE3i (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2011 23:29:38 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 1/2] iwlagn: support off-channel TX
Date: Thu, 10 Mar 2011 20:13:26 -0800
Message-Id: <1299816807-26813-2-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1299816807-26813-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1299816807-26813-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Add support to iwlagn for off-channel TX. The
microcode API for this is a bit strange in that
it uses a hacked-up scan command, so the scan
code needs to change quite a bit to accomodate
that and be able to send it out.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |  135 ++++++++++++++++++++-------
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   87 +++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-commands.h |    8 ++-
 drivers/net/wireless/iwlwifi/iwl-core.h     |    6 +
 drivers/net/wireless/iwlwifi/iwl-dev.h      |   12 ++-
 drivers/net/wireless/iwlwifi/iwl-scan.c     |   41 +++++----
 6 files changed, 238 insertions(+), 51 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 25fccf9..2003c1d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -1115,6 +1115,18 @@ static int iwl_get_channels_for_scan(struct iwl_priv *priv,
 	return added;
 }
 
+static int iwl_fill_offch_tx(struct iwl_priv *priv, void *data, size_t maxlen)
+{
+	struct sk_buff *skb = priv->_agn.offchan_tx_skb;
+
+	if (skb->len < maxlen)
+		maxlen = skb->len;
+
+	memcpy(data, skb->data, maxlen);
+
+	return maxlen;
+}
+
 int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 {
 	struct iwl_host_cmd cmd = {
@@ -1157,17 +1169,25 @@ int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	scan->quiet_plcp_th = IWL_PLCP_QUIET_THRESH;
 	scan->quiet_time = IWL_ACTIVE_QUIET_TIME;
 
-	if (iwl_is_any_associated(priv)) {
+	if (priv->scan_type != IWL_SCAN_OFFCH_TX &&
+	    iwl_is_any_associated(priv)) {
 		u16 interval = 0;
 		u32 extra;
 		u32 suspend_time = 100;
 		u32 scan_suspend_time = 100;
 
 		IWL_DEBUG_INFO(priv, "Scanning while associated...\n");
-		if (priv->is_internal_short_scan)
+		switch (priv->scan_type) {
+		case IWL_SCAN_OFFCH_TX:
+			WARN_ON(1);
+			break;
+		case IWL_SCAN_RADIO_RESET:
 			interval = 0;
-		else
+			break;
+		case IWL_SCAN_NORMAL:
 			interval = vif->bss_conf.beacon_int;
+			break;
+		}
 
 		scan->suspend_time = 0;
 		scan->max_out_time = cpu_to_le32(200 * 1024);
@@ -1180,29 +1200,41 @@ int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 		scan->suspend_time = cpu_to_le32(scan_suspend_time);
 		IWL_DEBUG_SCAN(priv, "suspend_time 0x%X beacon interval %d\n",
 			       scan_suspend_time, interval);
+	} else if (priv->scan_type == IWL_SCAN_OFFCH_TX) {
+		scan->suspend_time = 0;
+		scan->max_out_time =
+			cpu_to_le32(1024 * priv->_agn.offchan_tx_timeout);
 	}
 
-	if (priv->is_internal_short_scan) {
+	switch (priv->scan_type) {
+	case IWL_SCAN_RADIO_RESET:
 		IWL_DEBUG_SCAN(priv, "Start internal passive scan.\n");
-	} else if (priv->scan_request->n_ssids) {
-		int i, p = 0;
-		IWL_DEBUG_SCAN(priv, "Kicking off active scan\n");
-		for (i = 0; i < priv->scan_request->n_ssids; i++) {
-			/* always does wildcard anyway */
-			if (!priv->scan_request->ssids[i].ssid_len)
-				continue;
-			scan->direct_scan[p].id = WLAN_EID_SSID;
-			scan->direct_scan[p].len =
-				priv->scan_request->ssids[i].ssid_len;
-			memcpy(scan->direct_scan[p].ssid,
-			       priv->scan_request->ssids[i].ssid,
-			       priv->scan_request->ssids[i].ssid_len);
-			n_probes++;
-			p++;
-		}
-		is_active = true;
-	} else
-		IWL_DEBUG_SCAN(priv, "Start passive scan.\n");
+		break;
+	case IWL_SCAN_NORMAL:
+		if (priv->scan_request->n_ssids) {
+			int i, p = 0;
+			IWL_DEBUG_SCAN(priv, "Kicking off active scan\n");
+			for (i = 0; i < priv->scan_request->n_ssids; i++) {
+				/* always does wildcard anyway */
+				if (!priv->scan_request->ssids[i].ssid_len)
+					continue;
+				scan->direct_scan[p].id = WLAN_EID_SSID;
+				scan->direct_scan[p].len =
+					priv->scan_request->ssids[i].ssid_len;
+				memcpy(scan->direct_scan[p].ssid,
+				       priv->scan_request->ssids[i].ssid,
+				       priv->scan_request->ssids[i].ssid_len);
+				n_probes++;
+				p++;
+			}
+			is_active = true;
+		} else
+			IWL_DEBUG_SCAN(priv, "Start passive scan.\n");
+		break;
+	case IWL_SCAN_OFFCH_TX:
+		IWL_DEBUG_SCAN(priv, "Start offchannel TX scan.\n");
+		break;
+	}
 
 	scan->tx_cmd.tx_flags = TX_CMD_FLG_SEQ_CTL_MSK;
 	scan->tx_cmd.sta_id = ctx->bcast_sta_id;
@@ -1300,38 +1332,77 @@ int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	rx_chain |= rx_ant << RXON_RX_CHAIN_FORCE_SEL_POS;
 	rx_chain |= 0x1 << RXON_RX_CHAIN_DRIVER_FORCE_POS;
 	scan->rx_chain = cpu_to_le16(rx_chain);
-	if (!priv->is_internal_short_scan) {
+	switch (priv->scan_type) {
+	case IWL_SCAN_NORMAL:
 		cmd_len = iwl_fill_probe_req(priv,
 					(struct ieee80211_mgmt *)scan->data,
 					vif->addr,
 					priv->scan_request->ie,
 					priv->scan_request->ie_len,
 					IWL_MAX_SCAN_SIZE - sizeof(*scan));
-	} else {
+		break;
+	case IWL_SCAN_RADIO_RESET:
 		/* use bcast addr, will not be transmitted but must be valid */
 		cmd_len = iwl_fill_probe_req(priv,
 					(struct ieee80211_mgmt *)scan->data,
 					iwl_bcast_addr, NULL, 0,
 					IWL_MAX_SCAN_SIZE - sizeof(*scan));
-
+		break;
+	case IWL_SCAN_OFFCH_TX:
+		cmd_len = iwl_fill_offch_tx(priv, scan->data,
+					    IWL_MAX_SCAN_SIZE
+					     - sizeof(*scan)
+					     - sizeof(struct iwl_scan_channel));
+		scan->scan_flags |= IWL_SCAN_FLAGS_ACTION_FRAME_TX;
+		break;
+	default:
+		BUG();
 	}
 	scan->tx_cmd.len = cpu_to_le16(cmd_len);
 
 	scan->filter_flags |= (RXON_FILTER_ACCEPT_GRP_MSK |
 			       RXON_FILTER_BCON_AWARE_MSK);
 
-	if (priv->is_internal_short_scan) {
+	switch (priv->scan_type) {
+	case IWL_SCAN_RADIO_RESET:
 		scan->channel_count =
 			iwl_get_single_channel_for_scan(priv, vif, band,
-				(void *)&scan->data[le16_to_cpu(
-				scan->tx_cmd.len)]);
-	} else {
+				(void *)&scan->data[cmd_len]);
+		break;
+	case IWL_SCAN_NORMAL:
 		scan->channel_count =
 			iwl_get_channels_for_scan(priv, vif, band,
 				is_active, n_probes,
-				(void *)&scan->data[le16_to_cpu(
-				scan->tx_cmd.len)]);
+				(void *)&scan->data[cmd_len]);
+		break;
+	case IWL_SCAN_OFFCH_TX: {
+		struct iwl_scan_channel *scan_ch;
+
+		scan->channel_count = 1;
+
+		scan_ch = (void *)&scan->data[cmd_len];
+		scan_ch->type = SCAN_CHANNEL_TYPE_ACTIVE;
+		scan_ch->channel =
+			cpu_to_le16(priv->_agn.offchan_tx_chan->hw_value);
+		scan_ch->active_dwell =
+			cpu_to_le16(priv->_agn.offchan_tx_timeout);
+		scan_ch->passive_dwell = 0;
+
+		/* Set txpower levels to defaults */
+		scan_ch->dsp_atten = 110;
+
+		/* NOTE: if we were doing 6Mb OFDM for scans we'd use
+		 * power level:
+		 * scan_ch->tx_gain = ((1 << 5) | (2 << 3)) | 3;
+		 */
+		if (priv->_agn.offchan_tx_chan->band == IEEE80211_BAND_5GHZ)
+			scan_ch->tx_gain = ((1 << 5) | (3 << 3)) | 3;
+		else
+			scan_ch->tx_gain = ((1 << 5) | (5 << 3));
+		}
+		break;
 	}
+
 	if (scan->channel_count == 0) {
 		IWL_DEBUG_SCAN(priv, "channel count %d\n", scan->channel_count);
 		return -EIO;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 19bb567..5f4e481 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2937,6 +2937,91 @@ static void iwl_bg_rx_replenish(struct work_struct *data)
 	mutex_unlock(&priv->mutex);
 }
 
+static int iwl_mac_offchannel_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
+				 struct ieee80211_channel *chan,
+				 enum nl80211_channel_type channel_type,
+				 unsigned int wait)
+{
+	struct iwl_priv *priv = hw->priv;
+	int ret;
+
+	/* Not supported if we don't have PAN */
+	if (!(priv->valid_contexts & BIT(IWL_RXON_CTX_PAN))) {
+		ret = -EOPNOTSUPP;
+		goto free;
+	}
+
+	/* Not supported on pre-P2P firmware */
+	if (!(priv->contexts[IWL_RXON_CTX_PAN].interface_modes &
+					BIT(NL80211_IFTYPE_P2P_CLIENT))) {
+		ret = -EOPNOTSUPP;
+		goto free;
+	}
+
+	mutex_lock(&priv->mutex);
+
+	if (!priv->contexts[IWL_RXON_CTX_PAN].is_active) {
+		/*
+		 * If the PAN context is free, use the normal
+		 * way of doing remain-on-channel offload + TX.
+		 */
+		ret = 1;
+		goto out;
+	}
+
+	/* TODO: queue up if scanning? */
+	if (test_bit(STATUS_SCANNING, &priv->status) ||
+	    priv->_agn.offchan_tx_skb) {
+		ret = -EBUSY;
+		goto out;
+	}
+
+	/*
+	 * max_scan_ie_len doesn't include the blank SSID or the header,
+	 * so need to add that again here.
+	 */
+	if (skb->len > hw->wiphy->max_scan_ie_len + 24 + 2) {
+		ret = -ENOBUFS;
+		goto out;
+	}
+
+	priv->_agn.offchan_tx_skb = skb;
+	priv->_agn.offchan_tx_timeout = wait;
+	priv->_agn.offchan_tx_chan = chan;
+
+	ret = iwl_scan_initiate(priv, priv->contexts[IWL_RXON_CTX_PAN].vif,
+				IWL_SCAN_OFFCH_TX, chan->band);
+	if (ret)
+		priv->_agn.offchan_tx_skb = NULL;
+ out:
+	mutex_unlock(&priv->mutex);
+ free:
+	if (ret)
+		kfree_skb(skb);
+
+	return ret;
+}
+
+static int iwl_mac_offchannel_tx_cancel_wait(struct ieee80211_hw *hw)
+{
+	struct iwl_priv *priv = hw->priv;
+	int ret;
+
+	mutex_lock(&priv->mutex);
+
+	if (!priv->_agn.offchan_tx_skb)
+		return -EINVAL;
+
+	priv->_agn.offchan_tx_skb = NULL;
+
+	ret = iwl_scan_cancel_timeout(priv, 200);
+	if (ret)
+		ret = -EIO;
+	mutex_unlock(&priv->mutex);
+
+	return ret;
+}
+
 /*****************************************************************************
  *
  * mac80211 entry point functions
@@ -3815,6 +3900,8 @@ struct ieee80211_ops iwlagn_hw_ops = {
 	.tx_last_beacon = iwl_mac_tx_last_beacon,
 	.remain_on_channel = iwl_mac_remain_on_channel,
 	.cancel_remain_on_channel = iwl_mac_cancel_remain_on_channel,
+	.offchannel_tx = iwl_mac_offchannel_tx,
+	.offchannel_tx_cancel_wait = iwl_mac_offchannel_tx_cancel_wait,
 };
 
 static void iwl_hw_detect(struct iwl_priv *priv)
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 03cfb74..ca42ffa 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -2964,9 +2964,15 @@ struct iwl3945_scan_cmd {
 	u8 data[0];
 } __packed;
 
+enum iwl_scan_flags {
+	/* BIT(0) currently unused */
+	IWL_SCAN_FLAGS_ACTION_FRAME_TX	= BIT(1),
+	/* bits 2-7 reserved */
+};
+
 struct iwl_scan_cmd {
 	__le16 len;
-	u8 reserved0;
+	u8 scan_flags;		/* scan flags: see enum iwl_scan_flags */
 	u8 channel_count;	/* # channels in channel list */
 	__le16 quiet_time;	/* dwell only this # millisecs on quiet channel
 				 * (only for active scan) */
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index af47750..b316d83 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -63,6 +63,8 @@
 #ifndef __iwl_core_h__
 #define __iwl_core_h__
 
+#include "iwl-dev.h"
+
 /************************
  * forward declarations *
  ************************/
@@ -551,6 +553,10 @@ u16 iwl_get_passive_dwell_time(struct iwl_priv *priv,
 			       struct ieee80211_vif *vif);
 void iwl_setup_scan_deferred_work(struct iwl_priv *priv);
 void iwl_cancel_scan_deferred_work(struct iwl_priv *priv);
+int __must_check iwl_scan_initiate(struct iwl_priv *priv,
+				   struct ieee80211_vif *vif,
+				   enum iwl_scan_type scan_type,
+				   enum ieee80211_band band);
 
 /* For faster active scanning, scan will move to the next channel if fewer than
  * PLCP_QUIET_THRESH packets are heard on this channel within
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 6a41deb..68b953f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1230,6 +1230,12 @@ struct iwl_rxon_context {
 	} ht;
 };
 
+enum iwl_scan_type {
+	IWL_SCAN_NORMAL,
+	IWL_SCAN_RADIO_RESET,
+	IWL_SCAN_OFFCH_TX,
+};
+
 struct iwl_priv {
 
 	/* ieee device used by generic ieee processing code */
@@ -1290,7 +1296,7 @@ struct iwl_priv {
 	enum ieee80211_band scan_band;
 	struct cfg80211_scan_request *scan_request;
 	struct ieee80211_vif *scan_vif;
-	bool is_internal_short_scan;
+	enum iwl_scan_type scan_type;
 	u8 scan_tx_ant[IEEE80211_NUM_BANDS];
 	u8 mgmt_tx_ant;
 
@@ -1504,6 +1510,10 @@ struct iwl_priv {
 			struct delayed_work hw_roc_work;
 			enum nl80211_channel_type hw_roc_chantype;
 			int hw_roc_duration;
+
+			struct sk_buff *offchan_tx_skb;
+			int offchan_tx_timeout;
+			struct ieee80211_channel *offchan_tx_chan;
 		} _agn;
 #endif
 	};
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index faa6d34..3a4d9e6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -101,7 +101,7 @@ static void iwl_complete_scan(struct iwl_priv *priv, bool aborted)
 		ieee80211_scan_completed(priv->hw, aborted);
 	}
 
-	priv->is_internal_short_scan = false;
+	priv->scan_type = IWL_SCAN_NORMAL;
 	priv->scan_vif = NULL;
 	priv->scan_request = NULL;
 }
@@ -339,10 +339,10 @@ void iwl_init_scan_params(struct iwl_priv *priv)
 		priv->scan_tx_ant[IEEE80211_BAND_2GHZ] = ant_idx;
 }
 
-static int __must_check iwl_scan_initiate(struct iwl_priv *priv,
-					  struct ieee80211_vif *vif,
-					  bool internal,
-					  enum ieee80211_band band)
+int __must_check iwl_scan_initiate(struct iwl_priv *priv,
+				   struct ieee80211_vif *vif,
+				   enum iwl_scan_type scan_type,
+				   enum ieee80211_band band)
 {
 	int ret;
 
@@ -370,17 +370,19 @@ static int __must_check iwl_scan_initiate(struct iwl_priv *priv,
 	}
 
 	IWL_DEBUG_SCAN(priv, "Starting %sscan...\n",
-			internal ? "internal short " : "");
+			scan_type == IWL_SCAN_NORMAL ? "" :
+			scan_type == IWL_SCAN_OFFCH_TX ? "offchan TX " :
+			"internal short ");
 
 	set_bit(STATUS_SCANNING, &priv->status);
-	priv->is_internal_short_scan = internal;
+	priv->scan_type = scan_type;
 	priv->scan_start = jiffies;
 	priv->scan_band = band;
 
 	ret = priv->cfg->ops->utils->request_scan(priv, vif);
 	if (ret) {
 		clear_bit(STATUS_SCANNING, &priv->status);
-		priv->is_internal_short_scan = false;
+		priv->scan_type = IWL_SCAN_NORMAL;
 		return ret;
 	}
 
@@ -405,7 +407,7 @@ int iwl_mac_hw_scan(struct ieee80211_hw *hw,
 	mutex_lock(&priv->mutex);
 
 	if (test_bit(STATUS_SCANNING, &priv->status) &&
-	    !priv->is_internal_short_scan) {
+	    priv->scan_type != IWL_SCAN_NORMAL) {
 		IWL_DEBUG_SCAN(priv, "Scan already in progress.\n");
 		ret = -EAGAIN;
 		goto out_unlock;
@@ -419,11 +421,11 @@ int iwl_mac_hw_scan(struct ieee80211_hw *hw,
 	 * If an internal scan is in progress, just set
 	 * up the scan_request as per above.
 	 */
-	if (priv->is_internal_short_scan) {
+	if (priv->scan_type != IWL_SCAN_NORMAL) {
 		IWL_DEBUG_SCAN(priv, "SCAN request during internal scan\n");
 		ret = 0;
 	} else
-		ret = iwl_scan_initiate(priv, vif, false,
+		ret = iwl_scan_initiate(priv, vif, IWL_SCAN_NORMAL,
 					req->channels[0]->band);
 
 	IWL_DEBUG_MAC80211(priv, "leave\n");
@@ -452,7 +454,7 @@ static void iwl_bg_start_internal_scan(struct work_struct *work)
 
 	mutex_lock(&priv->mutex);
 
-	if (priv->is_internal_short_scan == true) {
+	if (priv->scan_type == IWL_SCAN_RADIO_RESET) {
 		IWL_DEBUG_SCAN(priv, "Internal scan already in progress\n");
 		goto unlock;
 	}
@@ -462,7 +464,7 @@ static void iwl_bg_start_internal_scan(struct work_struct *work)
 		goto unlock;
 	}
 
-	if (iwl_scan_initiate(priv, NULL, true, priv->band))
+	if (iwl_scan_initiate(priv, NULL, IWL_SCAN_RADIO_RESET, priv->band))
 		IWL_DEBUG_SCAN(priv, "failed to start internal short scan\n");
  unlock:
 	mutex_unlock(&priv->mutex);
@@ -549,8 +551,7 @@ static void iwl_bg_scan_completed(struct work_struct *work)
 	    container_of(work, struct iwl_priv, scan_completed);
 	bool aborted;
 
-	IWL_DEBUG_SCAN(priv, "Completed %sscan.\n",
-		       priv->is_internal_short_scan ? "internal short " : "");
+	IWL_DEBUG_SCAN(priv, "Completed scan.\n");
 
 	cancel_delayed_work(&priv->scan_check);
 
@@ -565,7 +566,13 @@ static void iwl_bg_scan_completed(struct work_struct *work)
 		goto out_settings;
 	}
 
-	if (priv->is_internal_short_scan && !aborted) {
+	if (priv->scan_type == IWL_SCAN_OFFCH_TX && priv->_agn.offchan_tx_skb) {
+		ieee80211_tx_status_irqsafe(priv->hw,
+					    priv->_agn.offchan_tx_skb);
+		priv->_agn.offchan_tx_skb = NULL;
+	}
+
+	if (priv->scan_type != IWL_SCAN_NORMAL && !aborted) {
 		int err;
 
 		/* Check if mac80211 requested scan during our internal scan */
@@ -573,7 +580,7 @@ static void iwl_bg_scan_completed(struct work_struct *work)
 			goto out_complete;
 
 		/* If so request a new scan */
-		err = iwl_scan_initiate(priv, priv->scan_vif, false,
+		err = iwl_scan_initiate(priv, priv->scan_vif, IWL_SCAN_NORMAL,
 					priv->scan_request->channels[0]->band);
 		if (err) {
 			IWL_DEBUG_SCAN(priv,
-- 
1.7.0.4

