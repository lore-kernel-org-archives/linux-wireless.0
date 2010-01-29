Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:35013 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754534Ab0A2TyK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jan 2010 14:54:10 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 07/12] iwlwifi: no need to test iw_mode in power saving
Date: Fri, 29 Jan 2010 11:53:57 -0800
Message-Id: <1264794842-8046-8-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1264794842-8046-1-git-send-email-reinette.chatre@intel.com>
References: <1264794842-8046-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

mac80211 will only enable powersaving for station mode.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-power.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index 9e3ca06..232dd18 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -308,8 +308,7 @@ int iwl_power_update_mode(struct iwl_priv *priv, bool force)
 {
 	int ret = 0;
 	struct iwl_tt_mgmt *tt = &priv->thermal_throttle;
-	bool enabled = (priv->iw_mode == NL80211_IFTYPE_STATION) &&
-			(priv->hw->conf.flags & IEEE80211_CONF_PS);
+	bool enabled = priv->hw->conf.flags & IEEE80211_CONF_PS;
 	bool update_chains;
 	struct iwl_powertable_cmd cmd;
 	int dtimper;
-- 
1.6.3.3

