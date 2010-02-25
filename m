Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:63121 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754482Ab0BYGMR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Feb 2010 01:12:17 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 6/7] iwmc3200wifi: mark some pmksa functions static
Date: Thu, 25 Feb 2010 14:15:30 +0800
Message-Id: <1267078531-9817-7-git-send-email-yi.zhu@intel.com>
In-Reply-To: <1267078531-9817-6-git-send-email-yi.zhu@intel.com>
References: <1267078531-9817-1-git-send-email-yi.zhu@intel.com>
 <1267078531-9817-2-git-send-email-yi.zhu@intel.com>
 <1267078531-9817-3-git-send-email-yi.zhu@intel.com>
 <1267078531-9817-4-git-send-email-yi.zhu@intel.com>
 <1267078531-9817-5-git-send-email-yi.zhu@intel.com>
 <1267078531-9817-6-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes the sparse warnings.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwmc3200wifi/cfg80211.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/cfg80211.c b/drivers/net/wireless/iwmc3200wifi/cfg80211.c
index 6778e58..fc239a3 100644
--- a/drivers/net/wireless/iwmc3200wifi/cfg80211.c
+++ b/drivers/net/wireless/iwmc3200wifi/cfg80211.c
@@ -725,23 +725,26 @@ static int iwm_cfg80211_set_power_mgmt(struct wiphy *wiphy,
 				       CFG_POWER_INDEX, iwm->conf.power_index);
 }
 
-int iwm_cfg80211_set_pmksa(struct wiphy *wiphy, struct net_device *netdev,
-			   struct cfg80211_pmksa *pmksa)
+static int iwm_cfg80211_set_pmksa(struct wiphy *wiphy,
+				  struct net_device *netdev,
+				  struct cfg80211_pmksa *pmksa)
 {
 	struct iwm_priv *iwm = wiphy_to_iwm(wiphy);
 
 	return iwm_send_pmkid_update(iwm, pmksa, IWM_CMD_PMKID_ADD);
 }
 
-int iwm_cfg80211_del_pmksa(struct wiphy *wiphy, struct net_device *netdev,
-			   struct cfg80211_pmksa *pmksa)
+static int iwm_cfg80211_del_pmksa(struct wiphy *wiphy,
+				  struct net_device *netdev,
+				  struct cfg80211_pmksa *pmksa)
 {
 	struct iwm_priv *iwm = wiphy_to_iwm(wiphy);
 
 	return iwm_send_pmkid_update(iwm, pmksa, IWM_CMD_PMKID_DEL);
 }
 
-int iwm_cfg80211_flush_pmksa(struct wiphy *wiphy, struct net_device *netdev)
+static int iwm_cfg80211_flush_pmksa(struct wiphy *wiphy,
+				    struct net_device *netdev)
 {
 	struct iwm_priv *iwm = wiphy_to_iwm(wiphy);
 	struct cfg80211_pmksa pmksa;
-- 
1.6.0.4

