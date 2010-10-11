Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:50174 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769Ab0JKSmV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Oct 2010 14:42:21 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH 1/2] wireless:  Support wiphy_renamed hook for drivers.
Date: Mon, 11 Oct 2010 11:42:16 -0700
Message-Id: <1286822537-28756-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Some drivers may want to know when their wiphy is updated
so that they can reuname debugfs links, etc.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 bb5e0d7... 74dc014... M	include/net/cfg80211.h
:100644 100644 33aa2e3... 89e0671... M	include/net/mac80211.h
:100644 100644 512f8d3... bc722d5... M	net/mac80211/cfg.c
:100644 100644 1684ad9... b48c778... M	net/wireless/core.c
 include/net/cfg80211.h |    2 ++
 include/net/mac80211.h |    1 +
 net/mac80211/cfg.c     |   12 ++++++++++++
 net/wireless/core.c    |    4 ++++
 4 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index bb5e0d7..74dc014 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1285,6 +1285,8 @@ struct cfg80211_ops {
 	int	(*set_cqm_rssi_config)(struct wiphy *wiphy,
 				       struct net_device *dev,
 				       s32 rssi_thold, u32 rssi_hyst);
+	int	(*wiphy_renamed)(struct wiphy *wiphy,
+				 const char *newname);
 };
 
 /*
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 33aa2e3..89e0671 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1790,6 +1790,7 @@ struct ieee80211_ops {
 	void (*channel_switch)(struct ieee80211_hw *hw,
 			       struct ieee80211_channel_switch *ch_switch);
 	int (*napi_poll)(struct ieee80211_hw *hw, int budget);
+	int (*wiphy_renamed)(struct ieee80211_hw *hw, const char* newname);
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 512f8d3..bc722d5 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1477,6 +1477,17 @@ static int ieee80211_set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
 	return 0;
 }
 
+static int ieee80211_wiphy_renamed(struct wiphy *wiphy,
+				   const char *newname)
+{
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+
+	if (!local->ops->wiphy_renamed)
+		return -EOPNOTSUPP;
+
+	return local->ops->wiphy_renamed(&local->hw, newname);
+}
+
 static int ieee80211_set_cqm_rssi_config(struct wiphy *wiphy,
 					 struct net_device *dev,
 					 s32 rssi_thold, u32 rssi_hyst)
@@ -1663,4 +1674,5 @@ struct cfg80211_ops mac80211_config_ops = {
 	.cancel_remain_on_channel = ieee80211_cancel_remain_on_channel,
 	.mgmt_tx = ieee80211_mgmt_tx,
 	.set_cqm_rssi_config = ieee80211_set_cqm_rssi_config,
+	.wiphy_renamed = ieee80211_wiphy_renamed,
 };
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 1684ad9..b48c778 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -203,6 +203,10 @@ int cfg80211_dev_rename(struct cfg80211_registered_device *rdev,
 		printk(KERN_ERR "cfg80211: failed to rename debugfs dir to %s!\n",
 		       newname);
 
+	/* Let drivers know to rename their debugfs names as well. */
+	if (rdev->ops->wiphy_renamed)
+		rdev->ops->wiphy_renamed(&rdev->wiphy, newname);
+
 	nl80211_notify_dev_rename(rdev);
 
 	return 0;
-- 
1.7.2.2

