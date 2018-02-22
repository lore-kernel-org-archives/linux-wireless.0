Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2nam03on0089.outbound.protection.outlook.com ([104.47.42.89]:20992
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752786AbeBVJPd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Feb 2018 04:15:33 -0500
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Dmitry Lebed <dlebed@quantenna.com>,
        Dmitry Lebed <lebed.dmitry@gmail.com>
Subject: [PATCH v2] cfg80211/nl80211: add DFS offload flag
Date: Thu, 22 Feb 2018 12:15:13 +0300
Message-Id: <20180222091513.25456-1-sergey.matyukevich.os@quantenna.com> (sfid-20180222_101537_862358_0A00DA84)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dmitry Lebed <dlebed@quantenna.com>

Add wiphy EXT_FEATURE flag to indicate that HW or driver does
all DFS actions by itself.
User-space functionality already implemented in hostapd using
vendor-specific (QCA) OUI to advertise DFS offload support.
Need to introduce generic flag to inform about DFS offload support.
For deivces with DFS_OFFLOAD flag set user-space will no longer
need to issue CAC or do any actions in response to
"radar detected" events. HW will do everything by itself and send
events to user-space to indicate that CAC was started/finished, etc.

Signed-off-by: Dmitrii Lebed <dlebed@quantenna.com>
---
V1->V2 changes:
- moved from wiphy_flags to ext_features flags usage

include/uapi/linux/nl80211.h |  7 +++++++
 net/wireless/nl80211.c       | 12 ++++++++----
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 22cca373161d..811928ce4e1c 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -4948,6 +4948,12 @@ enum nl80211_feature_flags {
  *	probe request tx deferral and suppression
  * @NL80211_EXT_FEATURE_MFP_OPTIONAL: Driver supports the %NL80211_MFP_OPTIONAL
  *	value in %NL80211_ATTR_USE_MFP.
+ * @NL80211_EXT_FEATURE_DFS_OFFLOAD: HW/driver will offload DFS actions.
+ *	Device or driver will do all DFS-related actions by itself,
+ *	informing user-space about CAC progress, radar detection event,
+ *	channel change triggered by radar detection event.
+ *	No need to start CAC from user-space, no need to react to
+ *	"radar detected" event.
  *
  * @NUM_NL80211_EXT_FEATURES: number of extended features.
  * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
@@ -4975,6 +4981,7 @@ enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_OCE_PROBE_REQ_HIGH_TX_RATE,
 	NL80211_EXT_FEATURE_OCE_PROBE_REQ_DEFERRAL_SUPPRESSION,
 	NL80211_EXT_FEATURE_MFP_OPTIONAL,
+	NL80211_EXT_FEATURE_DFS_OFFLOAD,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index b5e613d14d6a..d57aba58a418 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -7786,12 +7786,13 @@ static int nl80211_start_radar_detection(struct sk_buff *skb,
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
 	struct net_device *dev = info->user_ptr[1];
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct wiphy *wiphy = wdev->wiphy;
 	struct cfg80211_chan_def chandef;
 	enum nl80211_dfs_regions dfs_region;
 	unsigned int cac_time_ms;
 	int err;
 
-	dfs_region = reg_get_dfs_region(wdev->wiphy);
+	dfs_region = reg_get_dfs_region(wiphy);
 	if (dfs_region == NL80211_DFS_UNSET)
 		return -EINVAL;
 
@@ -7805,17 +7806,20 @@ static int nl80211_start_radar_detection(struct sk_buff *skb,
 	if (wdev->cac_started)
 		return -EBUSY;
 
-	err = cfg80211_chandef_dfs_required(wdev->wiphy, &chandef,
-					    wdev->iftype);
+	err = cfg80211_chandef_dfs_required(wiphy, &chandef, wdev->iftype);
 	if (err < 0)
 		return err;
 
 	if (err == 0)
 		return -EINVAL;
 
-	if (!cfg80211_chandef_dfs_usable(wdev->wiphy, &chandef))
+	if (!cfg80211_chandef_dfs_usable(wiphy, &chandef))
 		return -EINVAL;
 
+	/* CAC start is offloaded to HW and can't be started manually */
+	if (wiphy_ext_feature_isset(wiphy, NL80211_EXT_FEATURE_DFS_OFFLOAD))
+		return -EOPNOTSUPP;
+
 	if (!rdev->ops->start_radar_detection)
 		return -EOPNOTSUPP;
 
-- 
2.16.1
