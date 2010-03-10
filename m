Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:1472 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753152Ab0CJFWG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Mar 2010 00:22:06 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 14/24] iwlwifi: remove alive start adhoc restart
Date: Tue,  9 Mar 2010 21:21:42 -0800
Message-Id: <1268198512-6572-15-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1268198512-6572-1-git-send-email-reinette.chatre@intel.com>
References: <1268198512-6572-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This code will never trigger, because when
we call this during interface start, neither
priv->vif nor priv->iw_mode conditions will
be true, and when it happens during reset
then priv->vif is also NULL. Also, in both
cases the same code will be executed as part
of iwl_bss_info_changed(), which contains a
copy of this code.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    9 ---------
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    8 --------
 2 files changed, 0 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index fbbe998..b07c013 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2144,15 +2144,6 @@ static void iwl_alive_start(struct iwl_priv *priv)
 
 	iwl_power_update_mode(priv, true);
 
-	/* reassociate for ADHOC mode */
-	if (priv->vif && (priv->iw_mode == NL80211_IFTYPE_ADHOC)) {
-		struct sk_buff *beacon = ieee80211_beacon_get(priv->hw,
-								priv->vif);
-		if (beacon)
-			iwl_mac_beacon_update(priv->hw, beacon);
-	}
-
-
 	if (test_and_clear_bit(STATUS_MODE_PENDING, &priv->status))
 		iwl_set_mode(priv, priv->iw_mode);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 9cc15f9..bdd5fc7 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2537,14 +2537,6 @@ static void iwl3945_alive_start(struct iwl_priv *priv)
 	set_bit(STATUS_READY, &priv->status);
 	wake_up_interruptible(&priv->wait_command_queue);
 
-	/* reassociate for ADHOC mode */
-	if (priv->vif && (priv->iw_mode == NL80211_IFTYPE_ADHOC)) {
-		struct sk_buff *beacon = ieee80211_beacon_get(priv->hw,
-								priv->vif);
-		if (beacon)
-			iwl_mac_beacon_update(priv->hw, beacon);
-	}
-
 	if (test_and_clear_bit(STATUS_MODE_PENDING, &priv->status))
 		iwl_set_mode(priv, priv->iw_mode);
 
-- 
1.6.3.3

