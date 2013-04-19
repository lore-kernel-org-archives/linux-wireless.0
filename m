Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35024 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756896Ab3DSK0Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Apr 2013 06:26:16 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/2] cfg80211: invert P2P-Device vs. netdev check ordering
Date: Fri, 19 Apr 2013 12:26:07 +0200
Message-Id: <1366367167-17619-2-git-send-email-johannes@sipsolutions.net> (sfid-20130419_122619_008594_461E94CA)
In-Reply-To: <1366367167-17619-1-git-send-email-johannes@sipsolutions.net>
References: <1366367167-17619-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In cfg80211_can_use_iftype_chan(), check for P2P Device
first, and then for netdevs. This doesn't really change
anything but makes the code a bit easier to read since
it may not be obvious for everyone at first that a P2P
device has no netdev.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/util.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index 3d8a133..a7046a4 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1278,12 +1278,12 @@ int cfg80211_can_use_iftype_chan(struct cfg80211_registered_device *rdev,
 	list_for_each_entry(wdev_iter, &rdev->wdev_list, list) {
 		if (wdev_iter == wdev)
 			continue;
-		if (wdev_iter->netdev) {
-			if (!netif_running(wdev_iter->netdev))
-				continue;
-		} else if (wdev_iter->iftype == NL80211_IFTYPE_P2P_DEVICE) {
+		if (wdev_iter->iftype == NL80211_IFTYPE_P2P_DEVICE) {
 			if (!wdev_iter->p2p_started)
 				continue;
+		} else if (wdev_iter->netdev) {
+			if (!netif_running(wdev_iter->netdev))
+				continue;
 		} else {
 			WARN_ON(1);
 		}
-- 
1.8.0

