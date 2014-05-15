Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:49029 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751249AbaEOKF5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2014 06:05:57 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, eliad@wizery.com,
	janusz.dziedzic@tieto.com
Date: Thu, 15 May 2014 13:05:39 +0300
Message-Id: <1400148339-10006-1-git-send-email-luca@coelho.fi> (sfid-20140515_120600_357416_A70F7B3D)
Subject: [PATCH] cfg80211: pass the actual iftype when calling cfg80211_chandef_dfs_required()
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

There is no need to pass NL80211_IFTYPE_UNSPECIFIED when calling
cfg80211_chandef_dfs_required() since we always already have the
interface type.  So, pass the actual interface type instead.

Additionally, have cfg80211_chandef_dfs_required() WARN if the passed
interface type is NL80211_IFTYPE_UNSPECIFIED, so we can detect
problems more easily.

Cc: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Reported-by: Eliad Peller <eliad@wizery.com>
Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 net/wireless/chan.c    | 5 ++---
 net/wireless/nl80211.c | 2 +-
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 7a679a6..992b340 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -340,7 +340,6 @@ int cfg80211_chandef_dfs_required(struct wiphy *wiphy,
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_P2P_GO:
 	case NL80211_IFTYPE_MESH_POINT:
-	case NL80211_IFTYPE_UNSPECIFIED:
 		width = cfg80211_chandef_get_width(chandef);
 		if (width < 0)
 			return -EINVAL;
@@ -372,6 +371,7 @@ int cfg80211_chandef_dfs_required(struct wiphy *wiphy,
 	case NL80211_IFTYPE_WDS:
 	case NL80211_IFTYPE_P2P_DEVICE:
 		break;
+	case NL80211_IFTYPE_UNSPECIFIED:
 	case NUM_NL80211_IFTYPES:
 		WARN_ON(1);
 	}
@@ -796,8 +796,7 @@ bool cfg80211_reg_can_beacon(struct wiphy *wiphy,
 	    !cfg80211_go_permissive_chan(rdev, chandef->chan))
 		prohibited_flags |= IEEE80211_CHAN_NO_IR;
 
-	if (cfg80211_chandef_dfs_required(wiphy, chandef,
-					  NL80211_IFTYPE_UNSPECIFIED) > 0 &&
+	if (cfg80211_chandef_dfs_required(wiphy, chandef, iftype) > 0 &&
 	    cfg80211_chandef_dfs_available(wiphy, chandef)) {
 		/* We can skip IEEE80211_CHAN_NO_IR if chandef dfs available */
 		prohibited_flags = IEEE80211_CHAN_DISABLED;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index c083383..74e7299 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5822,7 +5822,7 @@ static int nl80211_start_radar_detection(struct sk_buff *skb,
 		return -EBUSY;
 
 	err = cfg80211_chandef_dfs_required(wdev->wiphy, &chandef,
-					    NL80211_IFTYPE_UNSPECIFIED);
+					    wdev->iftype);
 	if (err < 0)
 		return err;
 
-- 
2.0.0.rc0

