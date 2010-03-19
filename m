Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:41167 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752712Ab0CSVOO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Mar 2010 17:14:14 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 4/9] iwlwifi: sta_id cannot be invalid in rs_initialize_lq
Date: Fri, 19 Mar 2010 14:14:06 -0700
Message-Id: <1269033251-17545-5-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1269033251-17545-1-git-send-email-reinette.chatre@intel.com>
References: <1269033251-17545-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The only caller of this is iwl_rs_rate_init
which is only called with a valid sta_id.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 970eec8..5155b1a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -2377,10 +2377,6 @@ static void rs_initialize_lq(struct iwl_priv *priv,
 
 	i = lq_sta->last_txrate_idx;
 
-	if ((lq_sta->lq.sta_id == 0xff) &&
-	    (priv->iw_mode == NL80211_IFTYPE_ADHOC))
-		goto out;
-
 	valid_tx_ant = priv->hw_params.valid_tx_ant;
 
 	if (!lq_sta->search_better_tbl)
-- 
1.6.3.3

