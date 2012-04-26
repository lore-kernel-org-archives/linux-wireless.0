Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56139 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759413Ab2DZW2m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Apr 2012 18:28:42 -0400
Received: by pbbrr13 with SMTP id rr13so237581pbb.19
        for <linux-wireless@vger.kernel.org>; Thu, 26 Apr 2012 15:28:41 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: devel@lists.open80211s.org, Thomas Pedersen <thomas@cozybit.com>,
	johannes@sipsolutions.net, linville@tuxdriver.com
Subject: [RFC] nl80211: don't require netdev UP for wdev
Date: Thu, 26 Apr 2012 15:28:36 -0700
Message-Id: <1335479316-2933-1-git-send-email-thomas@cozybit.com> (sfid-20120427_002846_786030_B6244935)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It seems as long as we have a netdev, a wdev is available as well.
Remove the restriction that netdev must be up before a wdev can be
obtained in nl80211, or changing channels in cfg80211.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>

---
Hi list,

This was encountered while implementing an interface for setting
BSSBasicRateSet in mesh. The wdev->channel is needed in nl80211.c for
rate verification, but prior to this patch not available.  This doesn't
seem right since the following sequence of commands would fail:

iw wlan0 set type mp
iw wlan0 set channel n
ip link set wlan0 up
iw wlan0 mesh join meshid basic-rate 1,2

Also, 'iw set channel' is met with an -EBUSY if doing this after the
link is up for fixed channel modes (mesh) anyway.

Comments? Any idea why this was required initially?

Thanks,
Thomas

 net/wireless/chan.c    |    6 +-----
 net/wireless/nl80211.c |    3 +--
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 2fcfe09..2ae6019 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -88,13 +88,9 @@ int cfg80211_set_freq(struct cfg80211_registered_device *rdev,
 	if (wdev && wdev->iftype == NL80211_IFTYPE_MONITOR)
 		wdev = NULL;
 
-	if (wdev) {
+	if (wdev)
 		ASSERT_WDEV_LOCK(wdev);
 
-		if (!netif_running(wdev->netdev))
-			return -ENETDOWN;
-	}
-
 	if (!rdev->ops->set_channel)
 		return -EOPNOTSUPP;
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 140c1d2..29e5703 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1257,8 +1257,7 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 		result = 0;
 
 		mutex_lock(&rdev->mtx);
-	} else if (netif_running(netdev) &&
-		   nl80211_can_set_dev_channel(netdev->ieee80211_ptr))
+	} else if (nl80211_can_set_dev_channel(netdev->ieee80211_ptr))
 		wdev = netdev->ieee80211_ptr;
 	else
 		wdev = NULL;
-- 
1.7.5.4

