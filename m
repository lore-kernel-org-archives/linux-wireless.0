Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:16598 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753322Ab1AaNxL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 08:53:11 -0500
From: juuso.oikarinen@nokia.com
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] cfg80211: Fix power save state after interface type change
Date: Mon, 31 Jan 2011 15:52:58 +0200
Message-Id: <1296481978-1123-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Currently cfg80211 only configures the PSM state to the driver upon creation
of a new virtual interface, but not after interface type change. The mac80211
on the other hand reinitializes its sdata structure every time the interface
type is changed, losing the PSM configuration.

Hence, if the interface type is changed to, say, ad-hoc and then back to
managed, "iw wlan0 get power_save" will claim that PSM is enabled, when in
fact on mac80211 level it is not.

Fix this in cfg80211 by configuring the PSM state to the driver each time
the interface is brought up instead of just when the interface is created.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 net/wireless/core.c |   20 +++++++++++++-------
 1 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index e9a5f8c..fe01de2 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -718,13 +718,6 @@ static int cfg80211_netdev_notifier_call(struct notifier_block * nb,
 			wdev->ps = false;
 		/* allow mac80211 to determine the timeout */
 		wdev->ps_timeout = -1;
-		if (rdev->ops->set_power_mgmt)
-			if (rdev->ops->set_power_mgmt(wdev->wiphy, dev,
-						      wdev->ps,
-						      wdev->ps_timeout)) {
-				/* assume this means it's off */
-				wdev->ps = false;
-			}
 
 		if (!dev->ethtool_ops)
 			dev->ethtool_ops = &cfg80211_ethtool_ops;
@@ -813,6 +806,19 @@ static int cfg80211_netdev_notifier_call(struct notifier_block * nb,
 		rdev->opencount++;
 		mutex_unlock(&rdev->devlist_mtx);
 		cfg80211_unlock_rdev(rdev);
+
+		/*
+		 * Configure power management to the driver here so that its
+		 * correctly set also after interface type changes etc.
+		 */
+		if (wdev->iftype == NL80211_IFTYPE_STATION &&
+		    rdev->ops->set_power_mgmt)
+			if (rdev->ops->set_power_mgmt(wdev->wiphy, dev,
+						      wdev->ps,
+						      wdev->ps_timeout)) {
+				/* assume this means it's off */
+				wdev->ps = false;
+			}
 		break;
 	case NETDEV_UNREGISTER:
 		/*
-- 
1.7.1

