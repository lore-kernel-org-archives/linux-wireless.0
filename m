Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:41977 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbaBQJbw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Feb 2014 04:31:52 -0500
From: Luciano Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, sw@simonwunderlich.de
Subject: [PATCH v3] cfg80211: remove radar requirements check from cfg80211_can_use_iftype_chan()
Date: Mon, 17 Feb 2014 11:31:44 +0200
Message-Id: <1392629504-17758-1-git-send-email-luca@coelho.fi> (sfid-20140217_103201_431810_98D784C6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

We don't have to double check whether the parameters passed to
cfg80211_can_use_iftype_chan() are correct.  We should just make sure
they *are* when we call this function.

Remove the radar_detect argument check in
cfg80211_can_use_iftype_chan() to simplify the code.

Added comments in every place where this function is called (directly
or indirectly) explaining how we make sure that the radar_detect
argument is correct.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---

In v3: just for consistency, added a check to make sure the iftype is
valid (it used to be indirectly checked in the switch block).

In v2: removed silly unused variable warning that somehow creeped in
during my squashes.

This patch is small in actual content, but I added a lot of comments
explaining why I believe it's okay to remove the checks.  They were
mostly written for myself while I analysed the possibility of removing
the radar_detect check from the function.  But I think they are good,
at least during review, as an argumentation point in favor of removing
the check.  I can send a v4 without the comments if people think
they're just noise. ;)

This is done in order to simplify the combinations check and make it
easier to move the check out of cfg80211.

 net/wireless/core.h    |  6 ++++++
 net/wireless/ibss.c    | 15 +++++++++------
 net/wireless/mesh.c    |  8 ++++++++
 net/wireless/mlme.c    | 12 ++++++++++++
 net/wireless/nl80211.c |  9 +++++++++
 net/wireless/util.c    | 31 +------------------------------
 6 files changed, 45 insertions(+), 36 deletions(-)

diff --git a/net/wireless/core.h b/net/wireless/core.h
index 9895ab1..db35f7f 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -406,6 +406,7 @@ cfg80211_can_change_interface(struct cfg80211_registered_device *rdev,
 			      struct wireless_dev *wdev,
 			      enum nl80211_iftype iftype)
 {
+	/* Channel is NULL, no need for radar detection */
 	return cfg80211_can_use_iftype_chan(rdev, wdev, iftype, NULL,
 					    CHAN_MODE_UNDEFINED, 0);
 }
@@ -426,6 +427,11 @@ cfg80211_can_use_chan(struct cfg80211_registered_device *rdev,
 		      struct ieee80211_channel *chan,
 		      enum cfg80211_chan_mode chanmode)
 {
+	/*
+	 * The only place that could call us without checking whether
+	 * radar detection is needed is cfg80211_set_mesh_channel() --
+	 * and for libertas only -- but we added a WARN_ON there.
+	 */
 	return cfg80211_can_use_iftype_chan(rdev, wdev, wdev->iftype,
 					    chan, chanmode, 0);
 }
diff --git a/net/wireless/ibss.c b/net/wireless/ibss.c
index 1470b90..59f2c43 100644
--- a/net/wireless/ibss.c
+++ b/net/wireless/ibss.c
@@ -127,15 +127,18 @@ int __cfg80211_join_ibss(struct cfg80211_registered_device *rdev,
 	wdev->wext.ibss.chandef = params->chandef;
 #endif
 	check_chan = params->chandef.chan;
-	if (params->userspace_handles_dfs) {
-		/* use channel NULL to check for radar even if the current
-		 * channel is not a radar channel - it might decide to change
-		 * to DFS channel later.
+	if (params->userspace_handles_dfs)
+		/*
+		 * Check for radar even if the current channel is not
+		 * a radar channel - it might decide to change to DFS
+		 * channel later.
 		 */
 		radar_detect_width = BIT(params->chandef.width);
-		check_chan = NULL;
-	}
 
+	/*
+	 * We're guaranteeing with the code above that radar detection
+	 * will always be enabled if the userspace can handle DFS.
+	 */
 	err = cfg80211_can_use_iftype_chan(rdev, wdev, wdev->iftype,
 					   check_chan,
 					   (params->channel_fixed &&
diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
index d42a3fc..7a98440 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -184,6 +184,7 @@ int __cfg80211_join_mesh(struct cfg80211_registered_device *rdev,
 	if (err)
 		radar_detect_width = BIT(setup->chandef.width);
 
+	/* We're checking if radar detection is needed above */
 	err = cfg80211_can_use_iftype_chan(rdev, wdev, wdev->iftype,
 					   setup->chandef.chan,
 					   CHAN_MODE_SHARED,
@@ -236,6 +237,13 @@ int cfg80211_set_mesh_channel(struct cfg80211_registered_device *rdev,
 		if (!netif_running(wdev->netdev))
 			return -ENETDOWN;
 
+		/*
+		 * cfg80211_can_use_chan() calls
+		 * cfg80211_can_use_iftype_chan() with no radar
+		 * detection, so if we're trying to use a radar
+		 * channel here, something is wrong.
+		 */
+		WARN_ON_ONCE(chandef->chan->flags & IEEE80211_CHAN_RADAR);
 		err = cfg80211_can_use_chan(rdev, wdev, chandef->chan,
 					    CHAN_MODE_SHARED);
 		if (err)
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index d47c9d1..b09a12c 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -233,6 +233,12 @@ int cfg80211_mlme_auth(struct cfg80211_registered_device *rdev,
 	if (!req.bss)
 		return -ENOENT;
 
+	/*
+	 * For managed mode, we don't have to check for radar, so
+	 * there's no problem to call cfg80211+can_use_channel() which
+	 * calls cfg80211_can_use_iftype_chan() with no radar
+	 * detection.
+	 */
 	err = cfg80211_can_use_chan(rdev, wdev, req.bss->channel,
 				    CHAN_MODE_SHARED);
 	if (err)
@@ -306,6 +312,12 @@ int cfg80211_mlme_assoc(struct cfg80211_registered_device *rdev,
 	if (!req->bss)
 		return -ENOENT;
 
+	/*
+	 * For managed mode, we don't have to check for radar, so
+	 * there's no problem to call cfg80211+can_use_channel() which
+	 * calls cfg80211_can_use_iftype_chan() with no radar
+	 * detection.
+	 */
 	err = cfg80211_can_use_chan(rdev, wdev, chan, CHAN_MODE_SHARED);
 	if (err)
 		goto out;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index b78d734..2f46c2d 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3263,6 +3263,7 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 		params.radar_required = true;
 	}
 
+	/* We're checking if radar detection is needed above */
 	err = cfg80211_can_use_iftype_chan(rdev, wdev, wdev->iftype,
 					   params.chandef.chan,
 					   CHAN_MODE_SHARED,
@@ -5794,6 +5795,10 @@ static int nl80211_start_radar_detection(struct sk_buff *skb,
 	if (!rdev->ops->start_radar_detection)
 		return -EOPNOTSUPP;
 
+	/*
+	 * This is only called if radar detection is required and we
+	 * pass the radar_detect_width properly below.
+	 */
 	err = cfg80211_can_use_iftype_chan(rdev, wdev, wdev->iftype,
 					   chandef.chan, CHAN_MODE_SHARED,
 					   BIT(chandef.width));
@@ -5924,6 +5929,10 @@ skip_beacons:
 		}
 	}
 
+	/*
+	 * We guarantee with the code above that radar_detect_width is
+	 * correctly set for the interface types that need it.
+	 */
 	err = cfg80211_can_use_iftype_chan(rdev, wdev, wdev->iftype,
 					   params.chandef.chan,
 					   CHAN_MODE_SHARED,
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 780b454..57b3ce7 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1269,7 +1269,6 @@ int cfg80211_can_use_iftype_chan(struct cfg80211_registered_device *rdev,
 	enum cfg80211_chan_mode chmode;
 	int num_different_channels = 0;
 	int total = 1;
-	bool radar_required = false;
 	int i, j;
 
 	ASSERT_RTNL();
@@ -1277,35 +1276,7 @@ int cfg80211_can_use_iftype_chan(struct cfg80211_registered_device *rdev,
 	if (WARN_ON(hweight32(radar_detect) > 1))
 		return -EINVAL;
 
-	switch (iftype) {
-	case NL80211_IFTYPE_ADHOC:
-	case NL80211_IFTYPE_AP:
-	case NL80211_IFTYPE_AP_VLAN:
-	case NL80211_IFTYPE_MESH_POINT:
-	case NL80211_IFTYPE_P2P_GO:
-	case NL80211_IFTYPE_WDS:
-		/* if the interface could potentially choose a DFS channel,
-		 * then mark DFS as required.
-		 */
-		if (!chan) {
-			if (chanmode != CHAN_MODE_UNDEFINED && radar_detect)
-				radar_required = true;
-			break;
-		}
-		radar_required = !!(chan->flags & IEEE80211_CHAN_RADAR);
-		break;
-	case NL80211_IFTYPE_P2P_CLIENT:
-	case NL80211_IFTYPE_STATION:
-	case NL80211_IFTYPE_P2P_DEVICE:
-	case NL80211_IFTYPE_MONITOR:
-		break;
-	case NUM_NL80211_IFTYPES:
-	case NL80211_IFTYPE_UNSPECIFIED:
-	default:
-		return -EINVAL;
-	}
-
-	if (radar_required && !radar_detect)
+	if (WARN_ON(iftype >= NUM_NL80211_IFTYPES))
 		return -EINVAL;
 
 	/* Always allow software iftypes */
-- 
1.8.5.3

