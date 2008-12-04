Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:18556 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756529AbYLDWsM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Dec 2008 17:48:12 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: johannes@sipsolutions.net, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH] mac80211: remove WARN_ON() from ieee80211_hw_config
Date: Thu,  4 Dec 2008 14:49:08 -0800
Message-Id: <1228430948-25509-1-git-send-email-reinette.chatre@intel.com> (sfid-20081204_234815_917846_CE3F184C)
In-Reply-To: <>
References: <>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ieee80211_hw_config can return an error when the hardware
has rfkill enabled. A WARN_ON() is too harsh for this
failure as it is a valid scenario. Only comment this warning
as we would like to have it back when rfkill is integrated into
mac80211.

Also reintroduce propagation of error if ieee80211_hw_config fails
in ieee80211_config_beacon.

This patch partially reverts patch:
5f0387fc3337ca26f0745f945f550f0c3734960f
"mac80211: clean up ieee80211_hw_config errors"

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 net/mac80211/cfg.c  |    6 ++++--
 net/mac80211/main.c |   12 +++++++++++-
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 7a7a6c1..7912eb1 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -396,8 +396,10 @@ static int ieee80211_config_beacon(struct ieee80211_sub_if_data *sdata,
 	 */
 	if (params->interval) {
 		sdata->local->hw.conf.beacon_int = params->interval;
-		ieee80211_hw_config(sdata->local,
-				    IEEE80211_CONF_CHANGE_BEACON_INTERVAL);
+		err = ieee80211_hw_config(sdata->local,
+					IEEE80211_CONF_CHANGE_BEACON_INTERVAL);
+		if (err < 0)
+			return err;
 		/*
 		 * We updated some parameter so if below bails out
 		 * it's not an error.
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 29c3ecf..df7e9a8 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -243,10 +243,20 @@ int ieee80211_hw_config(struct ieee80211_local *local, u32 changed)
 	if (changed && local->open_count) {
 		ret = local->ops->config(local_to_hw(local), changed);
 		/*
+		 * Goal:
 		 * HW reconfiguration should never fail, the driver has told
 		 * us what it can support so it should live up to that promise.
+		 *
+		 * Current status:
+		 * rfkill is not integrated with mac80211 and a
+		 * configuration command can thus fail if hardware rfkill
+		 * is enabled
+		 *
+		 * FIXME: integrate rfkill with mac80211 and then add this
+		 * WARN_ON() back
+		 *
 		 */
-		WARN_ON(ret);
+		/* WARN_ON(ret); */
 	}
 
 	return ret;
-- 
1.5.4.3

