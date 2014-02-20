Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:55920 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbaBTFKT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Feb 2014 00:10:19 -0500
From: Luciano Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, michal.kazior@tieto.com,
	sw@simonwunderlich.de, bzhao@marvell.com, arend@broadcom.com
Subject: [PATCH v2 2/7] cfg80211: remove radar requirements check from cfg80211_can_use_iftype_chan()
Date: Thu, 20 Feb 2014 07:10:08 +0200
Message-Id: <1392873013-21772-3-git-send-email-luca@coelho.fi> (sfid-20140220_061048_676035_54A8AEB8)
In-Reply-To: <1392873013-21772-1-git-send-email-luca@coelho.fi>
References: <1392873013-21772-1-git-send-email-luca@coelho.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

We don't have to double check whether the parameters passed to
cfg80211_can_use_iftype_chan() are correct.  We should just make sure
they *are* when we call this function.

Remove the radar_detect argument check in
cfg80211_can_use_iftype_chan() to simplify the code.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 net/wireless/ibss.c | 10 ++++------
 net/wireless/mesh.c |  6 ++++++
 net/wireless/util.c | 31 +------------------------------
 3 files changed, 11 insertions(+), 36 deletions(-)

diff --git a/net/wireless/ibss.c b/net/wireless/ibss.c
index 1470b90..c66c524 100644
--- a/net/wireless/ibss.c
+++ b/net/wireless/ibss.c
@@ -127,14 +127,12 @@ int __cfg80211_join_ibss(struct cfg80211_registered_device *rdev,
 	wdev->wext.ibss.chandef = params->chandef;
 #endif
 	check_chan = params->chandef.chan;
-	if (params->userspace_handles_dfs) {
-		/* use channel NULL to check for radar even if the current
-		 * channel is not a radar channel - it might decide to change
-		 * to DFS channel later.
+	if (params->userspace_handles_dfs)
+		/* Check for radar even if the current channel is not
+		 * a radar channel - it might decide to change to DFS
+		 * channel later.
 		 */
 		radar_detect_width = BIT(params->chandef.width);
-		check_chan = NULL;
-	}
 
 	err = cfg80211_can_use_iftype_chan(rdev, wdev, wdev->iftype,
 					   check_chan,
diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
index d42a3fc..5af5cc6 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -236,6 +236,12 @@ int cfg80211_set_mesh_channel(struct cfg80211_registered_device *rdev,
 		if (!netif_running(wdev->netdev))
 			return -ENETDOWN;
 
+		/* cfg80211_can_use_chan() calls
+		 * cfg80211_can_use_iftype_chan() with no radar
+		 * detection, so if we're trying to use a radar
+		 * channel here, something is wrong.
+		 */
+		WARN_ON_ONCE(chandef->chan->flags & IEEE80211_CHAN_RADAR);
 		err = cfg80211_can_use_chan(rdev, wdev, chandef->chan,
 					    CHAN_MODE_SHARED);
 		if (err)
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

