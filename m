Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:23144 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762134AbYCETbD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2008 14:31:03 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH] iwlwifi: fix locking unbalance in 4965 rate scale
Date: Wed,  5 Mar 2008 11:31:00 -0800
Message-Id: <1204745460-9893-1-git-send-email-reinette.chatre@intel.com> (sfid-20080305_193137_156437_ABA8F993)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch fixes locking unbalance after adding rcu locking
for sta

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-rs.c |   25 ++++++++++++-------------
 1 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
index 306fbdc..25e7386 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
@@ -852,19 +852,18 @@ static void rs_tx_status(void *priv_rate, struct net_device *dev,
 
 	sta = sta_info_get(local, hdr->addr1);
 
-	if (!sta || !sta->rate_ctrl_priv) {
-		rcu_read_unlock();
-		return;
-	}
+	if (!sta || !sta->rate_ctrl_priv)
+		goto out;
+
 
 	lq_sta = (struct iwl4965_lq_sta *)sta->rate_ctrl_priv;
 
 	if (!priv->lq_mngr.lq_ready)
-		return;
+		goto out;
 
 	if ((priv->iw_mode == IEEE80211_IF_TYPE_IBSS) &&
 	    !lq_sta->ibss_sta_added)
-		return;
+		goto out;
 
 	table = &lq_sta->lq;
 	active_index = lq_sta->active_tbl;
@@ -915,8 +914,7 @@ static void rs_tx_status(void *priv_rate, struct net_device *dev,
 		tx_resp->control.tx_rate->bitrate)) {
 		IWL_DEBUG_RATE("initial rate does not match 0x%x\n",
 				tx_mcs.rate_n_flags);
-		rcu_read_unlock();
-		return;
+		goto out;
 	}
 
 	/* Update frame history window with "failure" for each Tx retry. */
@@ -1025,6 +1023,7 @@ static void rs_tx_status(void *priv_rate, struct net_device *dev,
 
 	/* See if there's a better rate or modulation mode to try. */
 	rs_rate_scale_perform(priv, dev, hdr, sta);
+out:
 	rcu_read_unlock();
 	return;
 }
@@ -2229,8 +2228,7 @@ static void rs_get_rate(void *priv_rate, struct net_device *dev,
 	if (!ieee80211_is_data(fc) || is_multicast_ether_addr(hdr->addr1) ||
 	    !sta || !sta->rate_ctrl_priv) {
 		sel->rate = rate_lowest(local, sband, sta);
-		rcu_read_unlock();
-		return;
+		goto out;
 	}
 
 	lq_sta = (struct iwl4965_lq_sta *)sta->rate_ctrl_priv;
@@ -2257,14 +2255,15 @@ static void rs_get_rate(void *priv_rate, struct net_device *dev,
 			goto done;
 	}
 
- done:
+done:
 	if ((i < 0) || (i > IWL_RATE_COUNT)) {
 		sel->rate = rate_lowest(local, sband, sta);
-		return;
+		goto out;
 	}
-	rcu_read_unlock();
 
 	sel->rate = &priv->ieee_rates[i];
+out:
+	rcu_read_unlock();
 }
 
 static void *rs_alloc_sta(void *priv, gfp_t gfp)
-- 
1.5.3.4

