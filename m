Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33671 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754562Ab2FFNWW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 09:22:22 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 07/29] iwlwifi: use mac80211 channel for radar check
Date: Wed,  6 Jun 2012 15:21:48 +0200
Message-Id: <1338988930-11561-7-git-send-email-johannes@sipsolutions.net> (sfid-20120606_152238_105575_C25297AE)
In-Reply-To: <1338988930-11561-1-git-send-email-johannes@sipsolutions.net>
References: <1338988930-11561-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In channel switch, instead of relying on our internal
channel database, just use the mac80211 channel that
we filled with that information on startup.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-devices.c |   20 ++------------------
 1 file changed, 2 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-devices.c b/drivers/net/wireless/iwlwifi/iwl-agn-devices.c
index 48533b3..529cdac 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-devices.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-devices.c
@@ -455,7 +455,6 @@ static int iwl5000_hw_channel_switch(struct iwl_priv *priv,
 	 */
 	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
 	struct iwl5000_channel_switch_cmd cmd;
-	const struct iwl_channel_info *ch_info;
 	u32 switch_time_in_usec, ucode_switch_time;
 	u16 ch;
 	u32 tsf_low;
@@ -505,14 +504,7 @@ static int iwl5000_hw_channel_switch(struct iwl_priv *priv,
 	}
 	IWL_DEBUG_11H(priv, "uCode time for the switch is 0x%x\n",
 		      cmd.switch_time);
-	ch_info = iwl_get_channel_info(priv, priv->band, ch);
-	if (ch_info)
-		cmd.expect_beacon = is_channel_radar(ch_info);
-	else {
-		IWL_ERR(priv, "invalid channel switch from %u to %u\n",
-			ctx->active.channel, ch);
-		return -EFAULT;
-	}
+	cmd.expect_beacon = ch_switch->channel->flags & IEEE80211_CHAN_RADAR;
 
 	return iwl_dvm_send_cmd(priv, &hcmd);
 }
@@ -654,7 +646,6 @@ static int iwl6000_hw_channel_switch(struct iwl_priv *priv,
 	 */
 	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
 	struct iwl6000_channel_switch_cmd cmd;
-	const struct iwl_channel_info *ch_info;
 	u32 switch_time_in_usec, ucode_switch_time;
 	u16 ch;
 	u32 tsf_low;
@@ -704,14 +695,7 @@ static int iwl6000_hw_channel_switch(struct iwl_priv *priv,
 	}
 	IWL_DEBUG_11H(priv, "uCode time for the switch is 0x%x\n",
 		      cmd.switch_time);
-	ch_info = iwl_get_channel_info(priv, priv->band, ch);
-	if (ch_info)
-		cmd.expect_beacon = is_channel_radar(ch_info);
-	else {
-		IWL_ERR(priv, "invalid channel switch from %u to %u\n",
-			ctx->active.channel, ch);
-		return -EFAULT;
-	}
+	cmd.expect_beacon = ch_switch->channel->flags & IEEE80211_CHAN_RADAR;
 
 	return iwl_dvm_send_cmd(priv, &hcmd);
 }
-- 
1.7.10

