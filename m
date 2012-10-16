Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43742 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755193Ab2JPSQm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Oct 2012 14:16:42 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.7] iwlwifi: fix 6000 series channel switch command
Date: Tue, 16 Oct 2012 20:17:17 +0200
Message-Id: <1350411437-2534-1-git-send-email-johannes@sipsolutions.net> (sfid-20121016_201645_346186_A812A5A5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The channel switch command for 6000 series devices
is larger than the maximum inline command size of
320 bytes. The command is therefore refused with a
warning. Fix this by allocating the command and
using the NOCOPY mechanism.

Cc: stable@kernel.org
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/devices.c |   39 +++++++++++++++++-----------
 1 file changed, 24 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/devices.c b/drivers/net/wireless/iwlwifi/dvm/devices.c
index 349c205d5..da58620 100644
--- a/drivers/net/wireless/iwlwifi/dvm/devices.c
+++ b/drivers/net/wireless/iwlwifi/dvm/devices.c
@@ -518,7 +518,7 @@ static int iwl6000_hw_channel_switch(struct iwl_priv *priv,
 	 * See iwlagn_mac_channel_switch.
 	 */
 	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
-	struct iwl6000_channel_switch_cmd cmd;
+	struct iwl6000_channel_switch_cmd *cmd;
 	u32 switch_time_in_usec, ucode_switch_time;
 	u16 ch;
 	u32 tsf_low;
@@ -527,18 +527,25 @@ static int iwl6000_hw_channel_switch(struct iwl_priv *priv,
 	struct ieee80211_vif *vif = ctx->vif;
 	struct iwl_host_cmd hcmd = {
 		.id = REPLY_CHANNEL_SWITCH,
-		.len = { sizeof(cmd), },
+		.len = { sizeof(*cmd), },
 		.flags = CMD_SYNC,
-		.data = { &cmd, },
+		.dataflags[0] = IWL_HCMD_DFL_NOCOPY,
 	};
+	int err;
 
-	cmd.band = priv->band == IEEE80211_BAND_2GHZ;
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (!cmd)
+		return -ENOMEM;
+
+	hcmd.data[0] = cmd;
+
+	cmd->band = priv->band == IEEE80211_BAND_2GHZ;
 	ch = ch_switch->channel->hw_value;
 	IWL_DEBUG_11H(priv, "channel switch from %u to %u\n",
 		      ctx->active.channel, ch);
-	cmd.channel = cpu_to_le16(ch);
-	cmd.rxon_flags = ctx->staging.flags;
-	cmd.rxon_filter_flags = ctx->staging.filter_flags;
+	cmd->channel = cpu_to_le16(ch);
+	cmd->rxon_flags = ctx->staging.flags;
+	cmd->rxon_filter_flags = ctx->staging.filter_flags;
 	switch_count = ch_switch->count;
 	tsf_low = ch_switch->timestamp & 0x0ffffffff;
 	/*
@@ -554,23 +561,25 @@ static int iwl6000_hw_channel_switch(struct iwl_priv *priv,
 			switch_count = 0;
 	}
 	if (switch_count <= 1)
-		cmd.switch_time = cpu_to_le32(priv->ucode_beacon_time);
+		cmd->switch_time = cpu_to_le32(priv->ucode_beacon_time);
 	else {
 		switch_time_in_usec =
 			vif->bss_conf.beacon_int * switch_count * TIME_UNIT;
 		ucode_switch_time = iwl_usecs_to_beacons(priv,
 							 switch_time_in_usec,
 							 beacon_interval);
-		cmd.switch_time = iwl_add_beacon_time(priv,
-						      priv->ucode_beacon_time,
-						      ucode_switch_time,
-						      beacon_interval);
+		cmd->switch_time = iwl_add_beacon_time(priv,
+						       priv->ucode_beacon_time,
+						       ucode_switch_time,
+						       beacon_interval);
 	}
 	IWL_DEBUG_11H(priv, "uCode time for the switch is 0x%x\n",
-		      cmd.switch_time);
-	cmd.expect_beacon = ch_switch->channel->flags & IEEE80211_CHAN_RADAR;
+		      cmd->switch_time);
+	cmd->expect_beacon = ch_switch->channel->flags & IEEE80211_CHAN_RADAR;
 
-	return iwl_dvm_send_cmd(priv, &hcmd);
+	err = iwl_dvm_send_cmd(priv, &hcmd);
+	kfree(cmd);
+	return err;
 }
 
 struct iwl_lib_ops iwl6000_lib = {
-- 
1.7.10.4

