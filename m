Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:47316 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760069AbZKFWxC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2009 17:53:02 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 11/20] iwlwifi: fix for channel switch
Date: Fri,  6 Nov 2009 14:52:54 -0800
Message-Id: <1257547983-12590-12-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1257547983-12590-1-git-send-email-reinette.chatre@intel.com>
References: <1257547983-12590-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Different channel has different configuration, need to pass correct
configuration to uCode when send "channel switch" command to uCode.
Invalid configuration will cause sysassert in uCode and produce
un-expected result.

Even it is a very small windows, but we also need to consider and handle
the case if commit_rxon occurred before the "channel switch
announcement" notification received from uCode.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c |   12 +++++---
 drivers/net/wireless/iwlwifi/iwl-5000.c |    6 +++-
 drivers/net/wireless/iwlwifi/iwl-6000.c |    6 +++-
 drivers/net/wireless/iwlwifi/iwl-agn.c  |   11 +++++++
 drivers/net/wireless/iwlwifi/iwl-core.c |   45 ++++++++++++++++++++-----------
 drivers/net/wireless/iwlwifi/iwl-dev.h  |   13 +++++++++
 6 files changed, 68 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 607c312..cc39424 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -1450,14 +1450,14 @@ static int iwl4965_hw_channel_switch(struct iwl_priv *priv, u16 channel)
 	is_ht40 = is_ht40_channel(priv->staging_rxon.flags);
 
 	if (is_ht40 &&
-	    (priv->active_rxon.flags & RXON_FLG_CTRL_CHANNEL_LOC_HI_MSK))
+	    (priv->staging_rxon.flags & RXON_FLG_CTRL_CHANNEL_LOC_HI_MSK))
 		ctrl_chan_high = 1;
 
 	cmd.band = band;
 	cmd.expect_beacon = 0;
 	cmd.channel = cpu_to_le16(channel);
-	cmd.rxon_flags = priv->active_rxon.flags;
-	cmd.rxon_filter_flags = priv->active_rxon.filter_flags;
+	cmd.rxon_flags = priv->staging_rxon.flags;
+	cmd.rxon_filter_flags = priv->staging_rxon.filter_flags;
 	cmd.switch_time = cpu_to_le32(priv->ucode_beacon_time);
 	if (ch_info)
 		cmd.expect_beacon = is_channel_radar(ch_info);
@@ -1474,8 +1474,10 @@ static int iwl4965_hw_channel_switch(struct iwl_priv *priv, u16 channel)
 		return rc;
 	}
 
-	rc = iwl_send_cmd_pdu(priv, REPLY_CHANNEL_SWITCH, sizeof(cmd), &cmd);
-	return rc;
+	priv->switch_rxon.channel = cpu_to_le16(channel);
+	priv->switch_rxon.switch_in_progress = true;
+
+	return iwl_send_cmd_pdu(priv, REPLY_CHANNEL_SWITCH, sizeof(cmd), &cmd);
 }
 
 /**
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index f6cbbfa..e23d301 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -1392,8 +1392,8 @@ static int iwl5000_hw_channel_switch(struct iwl_priv *priv, u16 channel)
 		priv->active_rxon.channel, channel);
 	cmd.band = priv->band == IEEE80211_BAND_2GHZ;
 	cmd.channel = cpu_to_le16(channel);
-	cmd.rxon_flags = priv->active_rxon.flags;
-	cmd.rxon_filter_flags = priv->active_rxon.filter_flags;
+	cmd.rxon_flags = priv->staging_rxon.flags;
+	cmd.rxon_filter_flags = priv->staging_rxon.filter_flags;
 	cmd.switch_time = cpu_to_le32(priv->ucode_beacon_time);
 	ch_info = iwl_get_channel_info(priv, priv->band, channel);
 	if (ch_info)
@@ -1403,6 +1403,8 @@ static int iwl5000_hw_channel_switch(struct iwl_priv *priv, u16 channel)
 			priv->active_rxon.channel, channel);
 		return -EFAULT;
 	}
+	priv->switch_rxon.channel = cpu_to_le16(channel);
+	priv->switch_rxon.switch_in_progress = true;
 
 	return iwl_send_cmd_sync(priv, &hcmd);
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 9ab7954..1f769ea 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -186,8 +186,8 @@ static int iwl6000_hw_channel_switch(struct iwl_priv *priv, u16 channel)
 
 	cmd.band = priv->band == IEEE80211_BAND_2GHZ;
 	cmd.channel = cpu_to_le16(channel);
-	cmd.rxon_flags = priv->active_rxon.flags;
-	cmd.rxon_filter_flags = priv->active_rxon.filter_flags;
+	cmd.rxon_flags = priv->staging_rxon.flags;
+	cmd.rxon_filter_flags = priv->staging_rxon.filter_flags;
 	cmd.switch_time = cpu_to_le32(priv->ucode_beacon_time);
 	ch_info = iwl_get_channel_info(priv, priv->band, channel);
 	if (ch_info)
@@ -197,6 +197,8 @@ static int iwl6000_hw_channel_switch(struct iwl_priv *priv, u16 channel)
 			priv->active_rxon.channel, channel);
 		return -EFAULT;
 	}
+	priv->switch_rxon.channel = cpu_to_le16(channel);
+	priv->switch_rxon.switch_in_progress = true;
 
 	return iwl_send_cmd_sync(priv, &hcmd);
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 46503a6..fd7ba51 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -123,6 +123,17 @@ int iwl_commit_rxon(struct iwl_priv *priv)
 		return -EINVAL;
 	}
 
+	/*
+	 * receive commit_rxon request
+	 * abort any previous channel switch if still in process
+	 */
+	if (priv->switch_rxon.switch_in_progress &&
+	    (priv->switch_rxon.channel != priv->staging_rxon.channel)) {
+		IWL_DEBUG_11H(priv, "abort channel switch on %d\n",
+		      le16_to_cpu(priv->switch_rxon.channel));
+		priv->switch_rxon.switch_in_progress = false;
+	}
+
 	/* If we don't need to send a full RXON, we can use
 	 * iwl_rxon_assoc_cmd which is used to reconfigure filter
 	 * and other flags for the current radio configuration. */
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 34ffcdd..e5854a9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1317,14 +1317,19 @@ void iwl_rx_csa(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 	struct iwl_rxon_cmd *rxon = (void *)&priv->active_rxon;
 	struct iwl_csa_notification *csa = &(pkt->u.csa_notif);
 
-	if (!le32_to_cpu(csa->status)) {
-		rxon->channel = csa->channel;
-		priv->staging_rxon.channel = csa->channel;
-		IWL_DEBUG_11H(priv, "CSA notif: channel %d\n",
-		      le16_to_cpu(csa->channel));
-	} else
-		IWL_ERR(priv, "CSA notif (fail) : channel %d\n",
-		      le16_to_cpu(csa->channel));
+	if (priv->switch_rxon.switch_in_progress) {
+		if (!le32_to_cpu(csa->status) &&
+		    (csa->channel == priv->switch_rxon.channel)) {
+			rxon->channel = csa->channel;
+			priv->staging_rxon.channel = csa->channel;
+			IWL_DEBUG_11H(priv, "CSA notif: channel %d\n",
+			      le16_to_cpu(csa->channel));
+		} else
+			IWL_ERR(priv, "CSA notif (fail) : channel %d\n",
+			      le16_to_cpu(csa->channel));
+
+		priv->switch_rxon.switch_in_progress = false;
+	}
 }
 EXPORT_SYMBOL(iwl_rx_csa);
 
@@ -2691,14 +2696,6 @@ int iwl_mac_config(struct ieee80211_hw *hw, u32 changed)
 			goto set_ch_out;
 		}
 
-		if (iwl_is_associated(priv) &&
-		    (le16_to_cpu(priv->active_rxon.channel) != ch) &&
-		    priv->cfg->ops->lib->set_channel_switch) {
-			ret = priv->cfg->ops->lib->set_channel_switch(priv,
-				ch);
-			goto out;
-		}
-
 		spin_lock_irqsave(&priv->lock, flags);
 
 		/* Configure HT40 channels */
@@ -2733,6 +2730,22 @@ int iwl_mac_config(struct ieee80211_hw *hw, u32 changed)
 
 		iwl_set_flags_for_band(priv, conf->channel->band);
 		spin_unlock_irqrestore(&priv->lock, flags);
+		if (iwl_is_associated(priv) &&
+		    (le16_to_cpu(priv->active_rxon.channel) != ch) &&
+		    priv->cfg->ops->lib->set_channel_switch) {
+			iwl_set_rate(priv);
+			/*
+			 * at this point, staging_rxon has the
+			 * configuration for channel switch
+			 */
+			ret = priv->cfg->ops->lib->set_channel_switch(priv,
+				ch);
+			if (!ret) {
+				iwl_print_rx_config_cmd(priv);
+				goto out;
+			}
+			priv->switch_rxon.switch_in_progress = false;
+		}
  set_ch_out:
 		/* The list of supported rates and rate mask can be different
 		 * for each band; since the band may have changed, reset
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 9975645..9a19a3d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -994,6 +994,17 @@ struct traffic_stats {
 };
 #endif
 
+/*
+ * iwl_switch_rxon: "channel switch" structure
+ *
+ * @ switch_in_progress: channel switch in progress
+ * @ channel: new channel
+ */
+struct iwl_switch_rxon {
+	bool switch_in_progress;
+	__le16 channel;
+};
+
 struct iwl_priv {
 
 	/* ieee device used by generic ieee processing code */
@@ -1087,6 +1098,8 @@ struct iwl_priv {
 	const struct iwl_rxon_cmd active_rxon;
 	struct iwl_rxon_cmd staging_rxon;
 
+	struct iwl_switch_rxon switch_rxon;
+
 	/* 1st responses from initialize and runtime uCode images.
 	 * 4965's initialize alive response contains some calibration data. */
 	struct iwl_init_alive_resp card_alive_init;
-- 
1.5.6.3

