Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59829 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756285Ab0HINwJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Aug 2010 09:52:09 -0400
Subject: [PATCH] cfg80211: fix locking in action frame TX
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 Aug 2010 15:52:03 +0200
Message-ID: <1281361923.3845.66.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Accesses to "wdev->current_bss" must be
locked with the wdev lock, which action
frame transmission is missing.

Cc: stable@kernel.org [2.6.33+]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/mlme.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- wireless-testing.orig/net/wireless/mlme.c	2010-08-09 15:23:36.000000000 +0200
+++ wireless-testing/net/wireless/mlme.c	2010-08-09 15:25:30.000000000 +0200
@@ -844,13 +844,19 @@ int cfg80211_mlme_action(struct cfg80211
 		return -EINVAL;
 	if (mgmt->u.action.category != WLAN_CATEGORY_PUBLIC) {
 		/* Verify that we are associated with the destination AP */
+		wdev_lock(wdev);
+
 		if (!wdev->current_bss ||
 		    memcmp(wdev->current_bss->pub.bssid, mgmt->bssid,
 			   ETH_ALEN) != 0 ||
 		    (wdev->iftype == NL80211_IFTYPE_STATION &&
 		     memcmp(wdev->current_bss->pub.bssid, mgmt->da,
-			    ETH_ALEN) != 0))
+			    ETH_ALEN) != 0)) {
+			wdev_unlock(wdev);
 			return -ENOTCONN;
+		}
+
+		wdev_unlock(wdev);
 	}
 
 	if (memcmp(mgmt->sa, dev->dev_addr, ETH_ALEN) != 0)


