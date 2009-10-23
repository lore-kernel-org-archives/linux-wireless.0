Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:24341 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752184AbZJWUmh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2009 16:42:37 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 11/18] iwlwifi: add channel switch support to 5000 series and up
Date: Fri, 23 Oct 2009 13:42:29 -0700
Message-Id: <1256330556-20997-12-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1256330556-20997-1-git-send-email-reinette.chatre@intel.com>
References: <1256330556-20997-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Support "channel switch" request by issue "channel switch" host command
to uCode.

There is no separated "channel switch" indication from mac80211,
when detected "IEEE80211_CONF_CHANGE_CHANNEL" flag in iwl_mac_config(),
if the station is in "associated" state, then assume "channel switch
announcement" IE was received by mac80211.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c |    6 -----
 drivers/net/wireless/iwlwifi/iwl-3945.h |    2 -
 drivers/net/wireless/iwlwifi/iwl-4965.c |   12 ++++++----
 drivers/net/wireless/iwlwifi/iwl-5000.c |   32 +++++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-6000.c |   32 +++++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.c |   21 ++++++++++++++++---
 drivers/net/wireless/iwlwifi/iwl-core.h |    1 +
 7 files changed, 89 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index f5d7528..09a7bd2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -1982,12 +1982,6 @@ static int iwl3945_commit_rxon(struct iwl_priv *priv)
 	return 0;
 }
 
-/* will add 3945 channel switch cmd handling later */
-int iwl3945_hw_channel_switch(struct iwl_priv *priv, u16 channel)
-{
-	return 0;
-}
-
 /**
  * iwl3945_reg_txpower_periodic -  called when time to check our temperature.
  *
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index f3907c1..964c019 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -280,8 +280,6 @@ extern void iwl3945_config_ap(struct iwl_priv *priv);
  */
 extern u8 iwl3945_hw_find_station(struct iwl_priv *priv, const u8 *bssid);
 
-extern int iwl3945_hw_channel_switch(struct iwl_priv *priv, u16 channel);
-
 /*
  * Forward declare iwl-3945.c functions for iwl-base.c
  */
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index bd856df..1ff465a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -1433,14 +1433,13 @@ static int iwl4965_send_rxon_assoc(struct iwl_priv *priv)
 	return ret;
 }
 
-#ifdef IEEE80211_CONF_CHANNEL_SWITCH
 static int iwl4965_hw_channel_switch(struct iwl_priv *priv, u16 channel)
 {
 	int rc;
 	u8 band = 0;
 	bool is_ht40 = false;
 	u8 ctrl_chan_high = 0;
-	struct iwl4965_channel_switch_cmd cmd = { 0 };
+	struct iwl4965_channel_switch_cmd cmd;
 	const struct iwl_channel_info *ch_info;
 
 	band = priv->band == IEEE80211_BAND_2GHZ;
@@ -1461,8 +1460,11 @@ static int iwl4965_hw_channel_switch(struct iwl_priv *priv, u16 channel)
 	cmd.switch_time = cpu_to_le32(priv->ucode_beacon_time);
 	if (ch_info)
 		cmd.expect_beacon = is_channel_radar(ch_info);
-	else
-		cmd.expect_beacon = 1;
+	else {
+		IWL_ERR(priv, "invalid channel switch from %u to %u\n",
+			priv->active_rxon.channel, channel);
+		return -EFAULT;
+	}
 
 	rc = iwl4965_fill_txpower_tbl(priv, band, channel, is_ht40,
 				      ctrl_chan_high, &cmd.tx_power);
@@ -1474,7 +1476,6 @@ static int iwl4965_hw_channel_switch(struct iwl_priv *priv, u16 channel)
 	rc = iwl_send_cmd_pdu(priv, REPLY_CHANNEL_SWITCH, sizeof(cmd), &cmd);
 	return rc;
 }
-#endif
 
 /**
  * iwl4965_txq_update_byte_cnt_tbl - Set up entry in Tx byte-count array
@@ -2171,6 +2172,7 @@ static struct iwl_lib_ops iwl4965_lib = {
 	.load_ucode = iwl4965_load_bsm,
 	.dump_nic_event_log = iwl_dump_nic_event_log,
 	.dump_nic_error_log = iwl_dump_nic_error_log,
+	.set_channel_switch = iwl4965_hw_channel_switch,
 	.apm_ops = {
 		.init = iwl_apm_init,
 		.stop = iwl_apm_stop,
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index a6e347b..d256fec 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -1382,6 +1382,36 @@ IWL5000_UCODE_GET(init_size);
 IWL5000_UCODE_GET(init_data_size);
 IWL5000_UCODE_GET(boot_size);
 
+static int iwl5000_hw_channel_switch(struct iwl_priv *priv, u16 channel)
+{
+	struct iwl5000_channel_switch_cmd cmd;
+	const struct iwl_channel_info *ch_info;
+	struct iwl_host_cmd hcmd = {
+		.id = REPLY_CHANNEL_SWITCH,
+		.len = sizeof(cmd),
+		.flags = CMD_SIZE_HUGE,
+		.data = &cmd,
+	};
+
+	IWL_DEBUG_11H(priv, "channel switch from %d to %d\n",
+		priv->active_rxon.channel, channel);
+	cmd.band = priv->band == IEEE80211_BAND_2GHZ;
+	cmd.channel = cpu_to_le16(channel);
+	cmd.rxon_flags = priv->active_rxon.flags;
+	cmd.rxon_filter_flags = priv->active_rxon.filter_flags;
+	cmd.switch_time = cpu_to_le32(priv->ucode_beacon_time);
+	ch_info = iwl_get_channel_info(priv, priv->band, channel);
+	if (ch_info)
+		cmd.expect_beacon = is_channel_radar(ch_info);
+	else {
+		IWL_ERR(priv, "invalid channel switch from %u to %u\n",
+			priv->active_rxon.channel, channel);
+		return -EFAULT;
+	}
+
+	return iwl_send_cmd_sync(priv, &hcmd);
+}
+
 struct iwl_hcmd_ops iwl5000_hcmd = {
 	.rxon_assoc = iwl5000_send_rxon_assoc,
 	.commit_rxon = iwl_commit_rxon,
@@ -1429,6 +1459,7 @@ struct iwl_lib_ops iwl5000_lib = {
 	.alive_notify = iwl5000_alive_notify,
 	.send_tx_power = iwl5000_send_tx_power,
 	.update_chain_flags = iwl_update_chain_flags,
+	.set_channel_switch = iwl5000_hw_channel_switch,
 	.apm_ops = {
 		.init = iwl_apm_init,
 		.stop = iwl_apm_stop,
@@ -1480,6 +1511,7 @@ static struct iwl_lib_ops iwl5150_lib = {
 	.alive_notify = iwl5000_alive_notify,
 	.send_tx_power = iwl5000_send_tx_power,
 	.update_chain_flags = iwl_update_chain_flags,
+	.set_channel_switch = iwl5000_hw_channel_switch,
 	.apm_ops = {
 		.init = iwl_apm_init,
 		.stop = iwl_apm_stop,
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index f585529..f5639b4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -172,6 +172,37 @@ static int iwl6000_hw_set_hw_params(struct iwl_priv *priv)
 	return 0;
 }
 
+static int iwl6000_hw_channel_switch(struct iwl_priv *priv, u16 channel)
+{
+	struct iwl6000_channel_switch_cmd cmd;
+	const struct iwl_channel_info *ch_info;
+	struct iwl_host_cmd hcmd = {
+		.id = REPLY_CHANNEL_SWITCH,
+		.len = sizeof(cmd),
+		.flags = CMD_SIZE_HUGE,
+		.data = &cmd,
+	};
+
+	IWL_DEBUG_11H(priv, "channel switch from %d to %d\n",
+		priv->active_rxon.channel, channel);
+
+	cmd.band = priv->band == IEEE80211_BAND_2GHZ;
+	cmd.channel = cpu_to_le16(channel);
+	cmd.rxon_flags = priv->active_rxon.flags;
+	cmd.rxon_filter_flags = priv->active_rxon.filter_flags;
+	cmd.switch_time = cpu_to_le32(priv->ucode_beacon_time);
+	ch_info = iwl_get_channel_info(priv, priv->band, channel);
+	if (ch_info)
+		cmd.expect_beacon = is_channel_radar(ch_info);
+	else {
+		IWL_ERR(priv, "invalid channel switch from %u to %u\n",
+			priv->active_rxon.channel, channel);
+		return -EFAULT;
+	}
+
+	return iwl_send_cmd_sync(priv, &hcmd);
+}
+
 static struct iwl_lib_ops iwl6000_lib = {
 	.set_hw_params = iwl6000_hw_set_hw_params,
 	.txq_update_byte_cnt_tbl = iwl5000_txq_update_byte_cnt_tbl,
@@ -192,6 +223,7 @@ static struct iwl_lib_ops iwl6000_lib = {
 	.alive_notify = iwl5000_alive_notify,
 	.send_tx_power = iwl5000_send_tx_power,
 	.update_chain_flags = iwl_update_chain_flags,
+	.set_channel_switch = iwl6000_hw_channel_switch,
 	.apm_ops = {
 		.init = iwl_apm_init,
 		.stop = iwl_apm_stop,
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index e43469c..d2b56ba 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1284,10 +1284,15 @@ void iwl_rx_csa(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_rxon_cmd *rxon = (void *)&priv->active_rxon;
 	struct iwl_csa_notification *csa = &(pkt->u.csa_notif);
-	IWL_DEBUG_11H(priv, "CSA notif: channel %d, status %d\n",
-		      le16_to_cpu(csa->channel), le32_to_cpu(csa->status));
-	rxon->channel = csa->channel;
-	priv->staging_rxon.channel = csa->channel;
+
+	if (!le32_to_cpu(csa->status)) {
+		rxon->channel = csa->channel;
+		priv->staging_rxon.channel = csa->channel;
+		IWL_DEBUG_11H(priv, "CSA notif: channel %d\n",
+		      le16_to_cpu(csa->channel));
+	} else
+		IWL_ERR(priv, "CSA notif (fail) : channel %d\n",
+		      le16_to_cpu(csa->channel));
 }
 EXPORT_SYMBOL(iwl_rx_csa);
 
@@ -2714,6 +2719,14 @@ int iwl_mac_config(struct ieee80211_hw *hw, u32 changed)
 			goto set_ch_out;
 		}
 
+		if (iwl_is_associated(priv) &&
+		    (le16_to_cpu(priv->active_rxon.channel) != ch) &&
+		    priv->cfg->ops->lib->set_channel_switch) {
+			ret = priv->cfg->ops->lib->set_channel_switch(priv,
+				ch);
+			goto out;
+		}
+
 		spin_lock_irqsave(&priv->lock, flags);
 
 		/* Configure HT40 channels */
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 02bacc4..b875dcf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -169,6 +169,7 @@ struct iwl_lib_ops {
 	int (*load_ucode)(struct iwl_priv *priv);
 	void (*dump_nic_event_log)(struct iwl_priv *priv);
 	void (*dump_nic_error_log)(struct iwl_priv *priv);
+	int (*set_channel_switch)(struct iwl_priv *priv, u16 channel);
 	/* power management */
 	struct iwl_apm_ops apm_ops;
 
-- 
1.5.6.3

