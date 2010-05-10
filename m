Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:65350 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756903Ab0EJW2c (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 May 2010 18:28:32 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 33/47] iwlwifi: fix iwl_sta_init_lq station ID
Date: Mon, 10 May 2010 15:28:04 -0700
Message-Id: <1273530498-11876-34-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
References: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The "is_ap" argument to iwl_sta_init_lq is never true,
so it and the corresponding code can be removed. However,
it needs to have the station ID because it is also used
for the IBSS BSSID station, and that doesn't have the
broadcast ID.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-sta.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 0db742c..dd1c639 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -408,7 +408,7 @@ int iwl_add_station_common(struct iwl_priv *priv, const u8 *addr,
 EXPORT_SYMBOL(iwl_add_station_common);
 
 static struct iwl_link_quality_cmd *iwl_sta_init_lq(struct iwl_priv *priv,
-						    const u8 *addr, bool is_ap)
+						    u8 sta_id)
 {
 	int i, r;
 	struct iwl_link_quality_cmd *link_cmd;
@@ -422,9 +422,7 @@ static struct iwl_link_quality_cmd *iwl_sta_init_lq(struct iwl_priv *priv,
 	}
 	/* Set up the rate scaling to start at selected rate, fall back
 	 * all the way down to 1M in IEEE order, and then spin on 1M */
-	if (is_ap)
-		r = IWL_RATE_54M_INDEX;
-	else if (priv->band == IEEE80211_BAND_5GHZ)
+	if (priv->band == IEEE80211_BAND_5GHZ)
 		r = IWL_RATE_6M_INDEX;
 	else
 		r = IWL_RATE_1M_INDEX;
@@ -459,8 +457,7 @@ static struct iwl_link_quality_cmd *iwl_sta_init_lq(struct iwl_priv *priv,
 	link_cmd->agg_params.agg_time_limit =
 		cpu_to_le16(LINK_QUAL_AGG_TIME_LIMIT_DEF);
 
-	/* Update the rate scaling for control frame Tx to AP */
-	link_cmd->sta_id = is_ap ? IWL_AP_ID : priv->hw_params.bcast_sta_id;
+	link_cmd->sta_id = sta_id;
 
 	ret = iwl_send_lq_cmd(priv, link_cmd, CMD_SYNC, true);
 	if (ret)
@@ -496,7 +493,7 @@ int iwl_add_local_station(struct iwl_priv *priv, const u8 *addr, bool init_rs)
 
 	if (init_rs) {
 		/* Set up default rate scaling table in device's station table */
-		link_cmd = iwl_sta_init_lq(priv, addr, false);
+		link_cmd = iwl_sta_init_lq(priv, sta_id);
 		if (!link_cmd) {
 			IWL_ERR(priv, "Unable to initialize rate scaling for station %pM.\n",
 				addr);
-- 
1.6.3.3

