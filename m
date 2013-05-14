Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:50303 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177Ab3ENHgO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 May 2013 03:36:14 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: greearb@candelatech.com, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.10] cfg80211: fix interface down/disconnect state handling
Date: Tue, 14 May 2013 09:36:08 +0200
Message-Id: <1368516968-29292-1-git-send-email-johannes@sipsolutions.net> (sfid-20130514_093618_978752_EBA4A27F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When the interface goes down, there's no need to call
cfg80211_mlme_down() after __cfg80211_disconnect() as
the latter will call the former (if appropriate.)

Also, in __cfg80211_disconnect(), if the cfg80211 SME
isn't used, __cfg80211_disconnected() may still need
to be called (depending on the current state) so that
the SME state gets cleared.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/core.c | 1 -
 net/wireless/sme.c  | 3 ++-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 6c9f800..73405e0 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -870,7 +870,6 @@ void cfg80211_leave(struct cfg80211_registered_device *rdev,
 #endif
 		__cfg80211_disconnect(rdev, dev,
 				      WLAN_REASON_DEAUTH_LEAVING, true);
-		cfg80211_mlme_down(rdev, dev);
 		wdev_unlock(wdev);
 		break;
 	case NL80211_IFTYPE_MESH_POINT:
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index a9dc5c7..8b5eddf 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -961,7 +961,7 @@ int __cfg80211_disconnect(struct cfg80211_registered_device *rdev,
 		/* was it connected by userspace SME? */
 		if (!wdev->conn) {
 			cfg80211_mlme_down(rdev, dev);
-			return 0;
+			goto disconnect;
 		}
 
 		if (wdev->sme_state == CFG80211_SME_CONNECTING &&
@@ -987,6 +987,7 @@ int __cfg80211_disconnect(struct cfg80211_registered_device *rdev,
 			return err;
 	}
 
+ disconnect:
 	if (wdev->sme_state == CFG80211_SME_CONNECTED)
 		__cfg80211_disconnected(dev, NULL, 0, 0, false);
 	else if (wdev->sme_state == CFG80211_SME_CONNECTING)
-- 
1.8.0

