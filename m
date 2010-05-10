Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:39917 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756730Ab0EJW23 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 May 2010 18:28:29 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 34/47] iwlwifi: split allocation/sending local station LQ
Date: Mon, 10 May 2010 15:28:05 -0700
Message-Id: <1273530498-11876-35-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
References: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Rename iwl_sta_init_lq to iwl_sta_alloc_lq and
move sending it out into the caller.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-sta.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index dd1c639..5bf82b9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -407,13 +407,12 @@ int iwl_add_station_common(struct iwl_priv *priv, const u8 *addr,
 }
 EXPORT_SYMBOL(iwl_add_station_common);
 
-static struct iwl_link_quality_cmd *iwl_sta_init_lq(struct iwl_priv *priv,
-						    u8 sta_id)
+static struct iwl_link_quality_cmd *iwl_sta_alloc_lq(struct iwl_priv *priv,
+						     u8 sta_id)
 {
 	int i, r;
 	struct iwl_link_quality_cmd *link_cmd;
 	u32 rate_flags;
-	int ret = 0;
 
 	link_cmd = kzalloc(sizeof(struct iwl_link_quality_cmd), GFP_KERNEL);
 	if (!link_cmd) {
@@ -459,10 +458,6 @@ static struct iwl_link_quality_cmd *iwl_sta_init_lq(struct iwl_priv *priv,
 
 	link_cmd->sta_id = sta_id;
 
-	ret = iwl_send_lq_cmd(priv, link_cmd, CMD_SYNC, true);
-	if (ret)
-		IWL_ERR(priv, "Link quality command failed (%d)\n", ret);
-
 	return link_cmd;
 }
 
@@ -493,12 +488,17 @@ int iwl_add_local_station(struct iwl_priv *priv, const u8 *addr, bool init_rs)
 
 	if (init_rs) {
 		/* Set up default rate scaling table in device's station table */
-		link_cmd = iwl_sta_init_lq(priv, sta_id);
+		link_cmd = iwl_sta_alloc_lq(priv, sta_id);
 		if (!link_cmd) {
 			IWL_ERR(priv, "Unable to initialize rate scaling for station %pM.\n",
 				addr);
 			return -ENOMEM;
 		}
+
+		ret = iwl_send_lq_cmd(priv, link_cmd, CMD_SYNC, true);
+		if (ret)
+			IWL_ERR(priv, "Link quality command failed (%d)\n", ret);
+
 		spin_lock_irqsave(&priv->sta_lock, flags);
 		priv->stations[sta_id].lq = link_cmd;
 		spin_unlock_irqrestore(&priv->sta_lock, flags);
-- 
1.6.3.3

