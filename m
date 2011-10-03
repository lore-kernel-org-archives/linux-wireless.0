Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45524 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757231Ab1JCUYh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Oct 2011 16:24:37 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Gilboa Davara <gilboad@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] cfg80211: allow channel change on monitor i/f if no active i/f present
Date: Mon,  3 Oct 2011 16:23:33 -0400
Message-Id: <1317673413-1467-1-git-send-email-linville@tuxdriver.com> (sfid-20111003_222441_975121_9869D8F1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is the latest attempt to address the long-standing complaint from
the aircrack-ng folks about being unable to change the channel on
monitor interfaces.  This version checks for the existance of other
"active" interfaces and refuses the channel change if they are present.

	https://bugzilla.redhat.com/show_bug.cgi?id=654344

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/wireless/chan.c |   29 +++++++++++++++++++++++++++--
 1 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 17cd0c0..d4add34 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -81,10 +81,32 @@ int cfg80211_set_freq(struct cfg80211_registered_device *rdev,
 		      enum nl80211_channel_type channel_type)
 {
 	struct ieee80211_channel *chan;
-	int result;
+	int result, active_intf_present = 0;
+	struct wireless_dev *mon_wdev = NULL;
+
+	if (wdev && wdev->iftype == NL80211_IFTYPE_MONITOR) {
+		mon_wdev = wdev;
+
+		ASSERT_RDEV_LOCK(rdev);
+
+		/* rdev->devlist_mtx locked by callers */
+		list_for_each_entry(wdev, &rdev->netdev_list, list) {
+			if (wdev && wdev != mon_wdev &&
+			    (wdev->iftype == NL80211_IFTYPE_ADHOC ||
+			     wdev->iftype == NL80211_IFTYPE_AP ||
+			     wdev->iftype == NL80211_IFTYPE_AP_VLAN ||
+			     wdev->iftype == NL80211_IFTYPE_MESH_POINT ||
+			     wdev->iftype == NL80211_IFTYPE_P2P_GO)) {
+				active_intf_present = 1;
+				break;
+			}
+		}
+
+		if (active_intf_present)
+			return -EINVAL;
 
-	if (wdev && wdev->iftype == NL80211_IFTYPE_MONITOR)
 		wdev = NULL;
+	}
 
 	if (wdev) {
 		ASSERT_WDEV_LOCK(wdev);
@@ -131,5 +153,8 @@ int cfg80211_set_freq(struct cfg80211_registered_device *rdev,
 	if (wdev)
 		wdev->channel = chan;
 
+	if (mon_wdev)
+		mon_wdev->channel = chan;
+
 	return 0;
 }
-- 
1.7.4.4

