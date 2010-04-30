Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:64061 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757386Ab0D3XAf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Apr 2010 19:00:35 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 1/8] iwlwifi: remove get_stats callback function
Date: Fri, 30 Apr 2010 16:00:18 -0700
Message-Id: <1272668425-3753-2-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1272668425-3753-1-git-send-email-reinette.chatre@intel.com>
References: <1272668425-3753-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

The low level transmission function is performed at uCode layer
for all the "agn" NICs, there is no statistics information available
for mac80211 get_stats() call. Remove the callback function to
avoid misleading information that returned success when indeed it is not
supported. Now return "not supported".

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |   13 -------------
 1 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index c22d3d8..04d84a6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3001,18 +3001,6 @@ static int iwl_mac_ampdu_action(struct ieee80211_hw *hw,
 	return 0;
 }
 
-static int iwl_mac_get_stats(struct ieee80211_hw *hw,
-			     struct ieee80211_low_level_stats *stats)
-{
-	struct iwl_priv *priv = hw->priv;
-
-	priv = hw->priv;
-	IWL_DEBUG_MAC80211(priv, "enter\n");
-	IWL_DEBUG_MAC80211(priv, "leave\n");
-
-	return 0;
-}
-
 static void iwl_mac_sta_notify(struct ieee80211_hw *hw,
 			       struct ieee80211_vif *vif,
 			       enum sta_notify_cmd cmd,
@@ -3390,7 +3378,6 @@ static struct ieee80211_ops iwl_hw_ops = {
 	.configure_filter = iwl_configure_filter,
 	.set_key = iwl_mac_set_key,
 	.update_tkip_key = iwl_mac_update_tkip_key,
-	.get_stats = iwl_mac_get_stats,
 	.conf_tx = iwl_mac_conf_tx,
 	.reset_tsf = iwl_mac_reset_tsf,
 	.bss_info_changed = iwl_bss_info_changed,
-- 
1.6.3.3

