Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:47549 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040AbaBYNgC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Feb 2014 08:36:02 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH] cfg80211: send stop AP event only due to internal reason
Date: Tue, 25 Feb 2014 15:33:38 +0200
Message-Id: <1393335218-2449-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140225_143609_288645_CF59D380)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Peer <ilan.peer@intel.com>

Commit "nl80211: send event when AP operation is stopped" added an
event to notify user space that an AP interface has been stopped, to
handle cases such as suspend etc. The event is sent regardless
if the stop AP flow was triggered by user space or due to internal state
change.

This might cause issues with wpa_supplicant/hostapd flows that consider
stop AP flow as a synchronous one, e.g., AP/GO channel change in the
absence of CSA support. In such cases, the flow will restart the AP
immediately after the stop AP flow is done, and only handle the stop
AP event after the current flow is done, and as a result stop the AP
again.

Change the current implementation to only send the event in case the
stop AP was triggered due to an internal reason.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
---
 net/wireless/ap.c      | 9 +++++----
 net/wireless/core.c    | 2 +-
 net/wireless/core.h    | 2 +-
 net/wireless/nl80211.c | 2 +-
 net/wireless/util.c    | 2 +-
 5 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/net/wireless/ap.c b/net/wireless/ap.c
index 68602be..3e02ade 100644
--- a/net/wireless/ap.c
+++ b/net/wireless/ap.c
@@ -7,7 +7,7 @@
 
 
 static int __cfg80211_stop_ap(struct cfg80211_registered_device *rdev,
-			      struct net_device *dev)
+			      struct net_device *dev, bool notify)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	int err;
@@ -30,20 +30,21 @@ static int __cfg80211_stop_ap(struct cfg80211_registered_device *rdev,
 		memset(&wdev->chandef, 0, sizeof(wdev->chandef));
 		wdev->ssid_len = 0;
 		rdev_set_qos_map(rdev, dev, NULL);
-		nl80211_send_ap_stopped(wdev);
+		if (notify)
+			nl80211_send_ap_stopped(wdev);
 	}
 
 	return err;
 }
 
 int cfg80211_stop_ap(struct cfg80211_registered_device *rdev,
-		     struct net_device *dev)
+		     struct net_device *dev, bool notify)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	int err;
 
 	wdev_lock(wdev);
-	err = __cfg80211_stop_ap(rdev, dev);
+	err = __cfg80211_stop_ap(rdev, dev, notify);
 	wdev_unlock(wdev);
 
 	return err;
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 1b44821..0c12fcf 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -809,7 +809,7 @@ void cfg80211_leave(struct cfg80211_registered_device *rdev,
 		break;
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_P2P_GO:
-		cfg80211_stop_ap(rdev, dev);
+		cfg80211_stop_ap(rdev, dev, true);
 		break;
 	default:
 		break;
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 3b2cf57..e80b6a9 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -283,7 +283,7 @@ int cfg80211_set_mesh_channel(struct cfg80211_registered_device *rdev,
 
 /* AP */
 int cfg80211_stop_ap(struct cfg80211_registered_device *rdev,
-		     struct net_device *dev);
+		     struct net_device *dev, bool notify);
 
 /* MLME */
 int cfg80211_mlme_auth(struct cfg80211_registered_device *rdev,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 31b96a7..e8a4783 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3356,7 +3356,7 @@ static int nl80211_stop_ap(struct sk_buff *skb, struct genl_info *info)
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
 	struct net_device *dev = info->user_ptr[1];
 
-	return cfg80211_stop_ap(rdev, dev);
+	return cfg80211_stop_ap(rdev, dev, false);
 }
 
 static const struct nla_policy sta_flags_policy[NL80211_STA_FLAG_MAX + 1] = {
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 02fd291..f69a2cb 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -886,7 +886,7 @@ int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
 
 		switch (otype) {
 		case NL80211_IFTYPE_AP:
-			cfg80211_stop_ap(rdev, dev);
+			cfg80211_stop_ap(rdev, dev, true);
 			break;
 		case NL80211_IFTYPE_ADHOC:
 			cfg80211_leave_ibss(rdev, dev, false);
-- 
1.8.3.2

