Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:38748 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751544AbYCJSl1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Mar 2008 14:41:27 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 3/7] iwlwifi: Use sta_bcast_id variable instead of BROADCAST_ID constant
Date: Mon, 10 Mar 2008 11:35:08 -0700
Message-Id: <1205174112-18962-4-git-send-email-reinette.chatre@intel.com> (sfid-20080310_184137_125934_B83DFA69)
In-Reply-To: <1205174112-18962-3-git-send-email-reinette.chatre@intel.com>
References: <1205174112-18962-1-git-send-email-reinette.chatre@intel.com>
 <1205174112-18962-2-git-send-email-reinette.chatre@intel.com>
 <1205174112-18962-3-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch removes iwlYYY_BROADCAST_ID from run time usage.
hw_setting.sta_bcast_id is used instead.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-4965.c |    6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index bcfa299..4e6c529 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -986,7 +986,7 @@ void iwl3945_hw_build_tx_cmd_rate(struct iwl3945_priv *priv,
 	priv->stations[sta_id].current_rate.rate_n_flags = rate;
 
 	if ((priv->iw_mode == IEEE80211_IF_TYPE_IBSS) &&
-	    (sta_id != IWL3945_BROADCAST_ID) &&
+	    (sta_id != priv->hw_setting.bcast_sta_id) &&
 		(sta_id != IWL_MULTICAST_ID))
 		priv->stations[IWL_STA_ID].current_rate.rate_n_flags = rate;
 
@@ -2601,7 +2601,7 @@ unsigned int iwl3945_hw_get_beacon_cmd(struct iwl3945_priv *priv,
 	tx_beacon_cmd = (struct iwl3945_tx_beacon_cmd *)&frame->u;
 	memset(tx_beacon_cmd, 0, sizeof(*tx_beacon_cmd));
 
-	tx_beacon_cmd->tx.sta_id = IWL3945_BROADCAST_ID;
+	tx_beacon_cmd->tx.sta_id = priv->hw_setting.bcast_sta_id;
 	tx_beacon_cmd->tx.stop_time.life_time = TX_CMD_LIFE_TIME_INFINITE;
 
 	frame_size = iwl3945_fill_beacon_frame(priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 6468504..90462a0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -254,7 +254,7 @@ u8 iwl4965_hw_find_station(struct iwl4965_priv *priv, const u8 *addr)
 		start = IWL_STA_ID;
 
 	if (is_broadcast_ether_addr(addr))
-		return IWL4965_BROADCAST_ID;
+		return priv->hw_setting.bcast_sta_id;
 
 	spin_lock_irqsave(&priv->sta_lock, flags);
 	for (i = start; i < priv->hw_setting.max_stations; i++)
@@ -2836,7 +2836,7 @@ unsigned int iwl4965_hw_get_beacon_cmd(struct iwl4965_priv *priv,
 	tx_beacon_cmd = &frame->u.beacon;
 	memset(tx_beacon_cmd, 0, sizeof(*tx_beacon_cmd));
 
-	tx_beacon_cmd->tx.sta_id = IWL4965_BROADCAST_ID;
+	tx_beacon_cmd->tx.sta_id = priv->hw_setting.bcast_sta_id;
 	tx_beacon_cmd->tx.stop_time.life_time = TX_CMD_LIFE_TIME_INFINITE;
 
 	frame_size = iwl4965_fill_beacon_frame(priv,
@@ -4438,7 +4438,7 @@ void iwl4965_add_station(struct iwl4965_priv *priv, const u8 *addr, int is_ap)
 	link_cmd.agg_params.agg_time_limit = cpu_to_le16(4000);
 
 	/* Update the rate scaling for control frame Tx to AP */
-	link_cmd.sta_id = is_ap ? IWL_AP_ID : IWL4965_BROADCAST_ID;
+	link_cmd.sta_id = is_ap ? IWL_AP_ID : priv->hw_setting.bcast_sta_id;
 
 	iwl4965_send_cmd_pdu(priv, REPLY_TX_LINK_QUALITY_CMD, sizeof(link_cmd),
 			 &link_cmd);
-- 
1.5.3.4

