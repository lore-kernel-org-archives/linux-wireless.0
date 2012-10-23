Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42885 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754626Ab2JWNRM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Oct 2012 09:17:12 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: add tracing for P2P Device start/stop
Date: Tue, 23 Oct 2012 15:17:44 +0200
Message-Id: <1350998264-18318-1-git-send-email-johannes@sipsolutions.net> (sfid-20121023_151716_769653_3C524697)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

These were missed due to the tracing work having
started on a kernel that didn't have P2P Device
yet, implement them now.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/core.c     |    4 ++--
 net/wireless/nl80211.c  |    4 ++--
 net/wireless/rdev-ops.h |   18 ++++++++++++++++++
 net/wireless/trace.h    |   10 ++++++++++
 4 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index f280f48..ce1ad77 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -241,7 +241,7 @@ static int cfg80211_rfkill_set_block(void *data, bool blocked)
 		case NL80211_IFTYPE_P2P_DEVICE:
 			if (!wdev->p2p_started)
 				break;
-			rdev->ops->stop_p2p_device(&rdev->wiphy, wdev);
+			rdev_stop_p2p_device(rdev, wdev);
 			wdev->p2p_started = false;
 			rdev->opencount--;
 			break;
@@ -774,7 +774,7 @@ void cfg80211_unregister_wdev(struct wireless_dev *wdev)
 	case NL80211_IFTYPE_P2P_DEVICE:
 		if (!wdev->p2p_started)
 			break;
-		rdev->ops->stop_p2p_device(&rdev->wiphy, wdev);
+		rdev_stop_p2p_device(rdev, wdev);
 		wdev->p2p_started = false;
 		rdev->opencount--;
 		break;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 5d3167d..8c08578 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -6932,7 +6932,7 @@ static int nl80211_start_p2p_device(struct sk_buff *skb, struct genl_info *info)
 	if (err)
 		return err;
 
-	err = rdev->ops->start_p2p_device(&rdev->wiphy, wdev);
+	err = rdev_start_p2p_device(rdev, wdev);
 	if (err)
 		return err;
 
@@ -6958,7 +6958,7 @@ static int nl80211_stop_p2p_device(struct sk_buff *skb, struct genl_info *info)
 	if (!wdev->p2p_started)
 		return 0;
 
-	rdev->ops->stop_p2p_device(&rdev->wiphy, wdev);
+	rdev_stop_p2p_device(rdev, wdev);
 	wdev->p2p_started = false;
 
 	mutex_lock(&rdev->devlist_mtx);
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 4a88a39..eb5f897 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -858,4 +858,22 @@ static inline struct ieee80211_channel
 	return ret;
 }
 
+static inline int rdev_start_p2p_device(struct cfg80211_registered_device *rdev,
+					struct wireless_dev *wdev)
+{
+	int ret;
+
+	trace_rdev_start_p2p_device(&rdev->wiphy, wdev);
+	ret = rdev->ops->start_p2p_device(&rdev->wiphy, wdev);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
+}
+
+static inline void rdev_stop_p2p_device(struct cfg80211_registered_device *rdev,
+					struct wireless_dev *wdev)
+{
+	trace_rdev_stop_p2p_device(&rdev->wiphy, wdev);
+	rdev->ops->stop_p2p_device(&rdev->wiphy, wdev);
+	trace_rdev_return_void(&rdev->wiphy);
+}					
 #endif /* __CFG80211_RDEV_OPS */
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 857734c..0ca71ca 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -1741,6 +1741,16 @@ TRACE_EVENT(rdev_return_channel,
 		  WIPHY_PR_ARG, CHAN_PR_ARG, __entry->type)
 );
 
+DEFINE_EVENT(wiphy_wdev_evt, rdev_start_p2p_device,
+	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev),
+	TP_ARGS(wiphy, wdev)
+);
+
+DEFINE_EVENT(wiphy_wdev_evt, rdev_stop_p2p_device,
+	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev),
+	TP_ARGS(wiphy, wdev)
+);
+
 /*************************************************************
  *	     cfg80211 exported functions traces		     *
  *************************************************************/
-- 
1.7.10.4

