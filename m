Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:57656 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752501Ab0CJFWE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Mar 2010 00:22:04 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 06/24] iwlwifi: remove dead code from iwl_mac_reset_tsf
Date: Tue,  9 Mar 2010 21:21:34 -0800
Message-Id: <1268198512-6572-7-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1268198512-6572-1-git-send-email-reinette.chatre@intel.com>
References: <1268198512-6572-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

iwl_mac_reset_tsf will only ever be called in
IBSS mode, so checking for other modes is not
useful and the code that depends on that will
not be executed.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |   16 +++-------------
 1 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 166087d..1cfcc9f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2597,8 +2597,6 @@ void iwl_mac_reset_tsf(struct ieee80211_hw *hw)
 
 	priv->beacon_int = priv->vif->bss_conf.beacon_int;
 	priv->timestamp = 0;
-	if ((priv->iw_mode == NL80211_IFTYPE_STATION))
-		priv->beacon_int = 0;
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
@@ -2611,17 +2609,9 @@ void iwl_mac_reset_tsf(struct ieee80211_hw *hw)
 	/* we are restarting association process
 	 * clear RXON_FILTER_ASSOC_MSK bit
 	 */
-	if (priv->iw_mode != NL80211_IFTYPE_AP) {
-		iwl_scan_cancel_timeout(priv, 100);
-		priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
-		iwlcore_commit_rxon(priv);
-	}
-
-	if (priv->iw_mode != NL80211_IFTYPE_ADHOC) {
-		IWL_DEBUG_MAC80211(priv, "leave - not in IBSS\n");
-		mutex_unlock(&priv->mutex);
-		return;
-	}
+	iwl_scan_cancel_timeout(priv, 100);
+	priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
+	iwlcore_commit_rxon(priv);
 
 	iwl_set_rate(priv);
 
-- 
1.6.3.3

