Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:27647 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758726AbYEWCLO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2008 22:11:14 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH] iwlwifi: move iwl_bcast_addr to iwlcore
Date: Fri, 23 May 2008 10:08:49 +0800
Message-Id: <1211508569-3163-12-git-send-email-yi.zhu@intel.com> (sfid-20080523_041125_531263_FE4FE02D)
In-Reply-To: <1211508569-3163-11-git-send-email-yi.zhu@intel.com>
References: <1211508569-3163-1-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-2-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-3-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-4-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-5-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-6-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-7-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-8-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-9-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-10-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-11-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch renames iwl4965_broadcast_addr to iwl_bcast_addr
and moves it to iwlcore.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-core.c     |    5 +++++
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    2 +-
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   11 +++++------
 4 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 1ec53a3..44215a7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2029,7 +2029,7 @@ unsigned int iwl4965_hw_get_beacon_cmd(struct iwl_priv *priv,
 
 	frame_size = iwl4965_fill_beacon_frame(priv,
 				tx_beacon_cmd->frame,
-				iwl4965_broadcast_addr,
+				iwl_bcast_addr,
 				sizeof(frame->u) - sizeof(*tx_beacon_cmd));
 
 	BUG_ON(frame_size > MAX_MPDU_SIZE);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 8e411de..79e46c5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -85,6 +85,11 @@ const struct iwl_rate_info iwl_rates[IWL_RATE_COUNT] = {
 };
 EXPORT_SYMBOL(iwl_rates);
 
+
+const u8 iwl_bcast_addr[ETH_ALEN] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
+EXPORT_SYMBOL(iwl_bcast_addr);
+
+
 /* This function both allocates and initializes hw and priv. */
 struct ieee80211_hw *iwl_alloc_all(struct iwl_cfg *cfg,
 		struct ieee80211_ops *hw_ops)
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 60a8f06..8809fe3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -659,7 +659,7 @@ int iwl4965_set_pwr_src(struct iwl_priv *priv, enum iwl_pwr_src src);
 int iwl4965_init_geos(struct iwl_priv *priv);
 void iwl4965_free_geos(struct iwl_priv *priv);
 
-extern const u8 iwl4965_broadcast_addr[ETH_ALEN];
+extern const u8 iwl_bcast_addr[ETH_ALEN];
 int iwl4965_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd);
 
 /*
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index edde814..bb820f3 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -207,7 +207,6 @@ static inline u8 get_cmd_index(struct iwl_queue *q, u32 index, int is_huge)
 	return index & (q->n_window - 1);
 }
 
-const u8 iwl4965_broadcast_addr[ETH_ALEN] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
 
 /*************** STATION TABLE MANAGEMENT ****
  * mac80211 should be examined to determine if sta_info is duplicating
@@ -692,7 +691,7 @@ static int iwl4965_commit_rxon(struct iwl_priv *priv)
 	}
 
 	/* Add the broadcast address so we can send broadcast frames */
-	if (iwl4965_rxon_add_station(priv, iwl4965_broadcast_addr, 0) ==
+	if (iwl4965_rxon_add_station(priv, iwl_bcast_addr, 0) ==
 	    IWL_INVALID_STATION) {
 		IWL_ERROR("Error adding BROADCAST address for transmit.\n");
 		return -EIO;
@@ -1059,9 +1058,9 @@ static u16 iwl4965_fill_probe_req(struct iwl_priv *priv,
 	len += 24;
 
 	frame->frame_control = cpu_to_le16(IEEE80211_STYPE_PROBE_REQ);
-	memcpy(frame->da, iwl4965_broadcast_addr, ETH_ALEN);
+	memcpy(frame->da, iwl_bcast_addr, ETH_ALEN);
 	memcpy(frame->sa, priv->mac_addr, ETH_ALEN);
-	memcpy(frame->bssid, iwl4965_broadcast_addr, ETH_ALEN);
+	memcpy(frame->bssid, iwl_bcast_addr, ETH_ALEN);
 	frame->seq_ctrl = 0;
 
 	/* fill in our indirect SSID IE */
@@ -4912,7 +4911,7 @@ static void iwl4965_post_associate(struct iwl_priv *priv)
 		/* clear out the station table */
 		iwlcore_clear_stations_table(priv);
 
-		iwl4965_rxon_add_station(priv, iwl4965_broadcast_addr, 0);
+		iwl4965_rxon_add_station(priv, iwl_bcast_addr, 0);
 		iwl4965_rxon_add_station(priv, priv->bssid, 0);
 		iwl4965_rate_scale_init(priv->hw, IWL_STA_ID);
 		iwl4965_send_beacon_cmd(priv);
@@ -5324,7 +5323,7 @@ static void iwl4965_config_ap(struct iwl_priv *priv)
 		priv->staging_rxon.filter_flags |= RXON_FILTER_ASSOC_MSK;
 		iwl4965_commit_rxon(priv);
 		iwl4965_activate_qos(priv, 1);
-		iwl4965_rxon_add_station(priv, iwl4965_broadcast_addr, 0);
+		iwl4965_rxon_add_station(priv, iwl_bcast_addr, 0);
 	}
 	iwl4965_send_beacon_cmd(priv);
 
-- 
1.5.3.6

