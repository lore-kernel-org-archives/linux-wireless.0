Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52637 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036Ab2LTRZj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Dec 2012 12:25:39 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: move some AP code to right file
Date: Thu, 20 Dec 2012 18:25:59 +0100
Message-Id: <1356024359-13039-1-git-send-email-johannes@sipsolutions.net> (sfid-20121220_182542_779409_876F1AAD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Some AP code ended up in mlme.c as ap.c didn't
exist when it was written, move it now.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/ap.c   | 62 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/mlme.c | 62 -----------------------------------------------------
 2 files changed, 62 insertions(+), 62 deletions(-)

diff --git a/net/wireless/ap.c b/net/wireless/ap.c
index 324e8d8..a4a14e8 100644
--- a/net/wireless/ap.c
+++ b/net/wireless/ap.c
@@ -46,3 +46,65 @@ int cfg80211_stop_ap(struct cfg80211_registered_device *rdev,
 
 	return err;
 }
+
+void cfg80211_ch_switch_notify(struct net_device *dev,
+			       struct cfg80211_chan_def *chandef)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct wiphy *wiphy = wdev->wiphy;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+
+	trace_cfg80211_ch_switch_notify(dev, chandef);
+
+	wdev_lock(wdev);
+
+	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_AP &&
+		    wdev->iftype != NL80211_IFTYPE_P2P_GO))
+		goto out;
+
+	wdev->channel = chandef->chan;
+	nl80211_ch_switch_notify(rdev, dev, chandef, GFP_KERNEL);
+out:
+	wdev_unlock(wdev);
+	return;
+}
+EXPORT_SYMBOL(cfg80211_ch_switch_notify);
+
+bool cfg80211_rx_spurious_frame(struct net_device *dev,
+				const u8 *addr, gfp_t gfp)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	bool ret;
+
+	trace_cfg80211_rx_spurious_frame(dev, addr);
+
+	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_AP &&
+		    wdev->iftype != NL80211_IFTYPE_P2P_GO)) {
+		trace_cfg80211_return_bool(false);
+		return false;
+	}
+	ret = nl80211_unexpected_frame(dev, addr, gfp);
+	trace_cfg80211_return_bool(ret);
+	return ret;
+}
+EXPORT_SYMBOL(cfg80211_rx_spurious_frame);
+
+bool cfg80211_rx_unexpected_4addr_frame(struct net_device *dev,
+					const u8 *addr, gfp_t gfp)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	bool ret;
+
+	trace_cfg80211_rx_unexpected_4addr_frame(dev, addr);
+
+	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_AP &&
+		    wdev->iftype != NL80211_IFTYPE_P2P_GO &&
+		    wdev->iftype != NL80211_IFTYPE_AP_VLAN)) {
+		trace_cfg80211_return_bool(false);
+		return false;
+	}
+	ret = nl80211_unexpected_4addr_frame(dev, addr, gfp);
+	trace_cfg80211_return_bool(ret);
+	return ret;
+}
+EXPORT_SYMBOL(cfg80211_rx_unexpected_4addr_frame);
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 5e8123e..461e692 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -987,65 +987,3 @@ void cfg80211_pmksa_candidate_notify(struct net_device *dev, int index,
 	nl80211_pmksa_candidate_notify(rdev, dev, index, bssid, preauth, gfp);
 }
 EXPORT_SYMBOL(cfg80211_pmksa_candidate_notify);
-
-void cfg80211_ch_switch_notify(struct net_device *dev,
-			       struct cfg80211_chan_def *chandef)
-{
-	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	struct wiphy *wiphy = wdev->wiphy;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
-
-	trace_cfg80211_ch_switch_notify(dev, chandef);
-
-	wdev_lock(wdev);
-
-	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_AP &&
-		    wdev->iftype != NL80211_IFTYPE_P2P_GO))
-		goto out;
-
-	wdev->channel = chandef->chan;
-	nl80211_ch_switch_notify(rdev, dev, chandef, GFP_KERNEL);
-out:
-	wdev_unlock(wdev);
-	return;
-}
-EXPORT_SYMBOL(cfg80211_ch_switch_notify);
-
-bool cfg80211_rx_spurious_frame(struct net_device *dev,
-				const u8 *addr, gfp_t gfp)
-{
-	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	bool ret;
-
-	trace_cfg80211_rx_spurious_frame(dev, addr);
-
-	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_AP &&
-		    wdev->iftype != NL80211_IFTYPE_P2P_GO)) {
-		trace_cfg80211_return_bool(false);
-		return false;
-	}
-	ret = nl80211_unexpected_frame(dev, addr, gfp);
-	trace_cfg80211_return_bool(ret);
-	return ret;
-}
-EXPORT_SYMBOL(cfg80211_rx_spurious_frame);
-
-bool cfg80211_rx_unexpected_4addr_frame(struct net_device *dev,
-					const u8 *addr, gfp_t gfp)
-{
-	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	bool ret;
-
-	trace_cfg80211_rx_unexpected_4addr_frame(dev, addr);
-
-	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_AP &&
-		    wdev->iftype != NL80211_IFTYPE_P2P_GO &&
-		    wdev->iftype != NL80211_IFTYPE_AP_VLAN)) {
-		trace_cfg80211_return_bool(false);
-		return false;
-	}
-	ret = nl80211_unexpected_4addr_frame(dev, addr, gfp);
-	trace_cfg80211_return_bool(ret);
-	return ret;
-}
-EXPORT_SYMBOL(cfg80211_rx_unexpected_4addr_frame);
-- 
1.8.0

