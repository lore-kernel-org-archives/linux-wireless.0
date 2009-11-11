Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:41243 "EHLO ds10.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752260AbZKKQX3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Nov 2009 11:23:29 -0500
Message-ID: <4AFAE503.3030602@openwrt.org>
Date: Wed, 11 Nov 2009 17:23:31 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] nl80211: only allow adding stations to running vlan interfaces
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---

--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1813,7 +1813,7 @@ static int nl80211_get_station(struct sk
 }
 
 /*
- * Get vlan interface making sure it is on the right wiphy.
+ * Get vlan interface making sure it is running and on the right wiphy.
  */
 static int get_vlan(struct genl_info *info,
 		    struct cfg80211_registered_device *rdev,
@@ -1831,6 +1831,8 @@ static int get_vlan(struct genl_info *in
 			return -EINVAL;
 		if ((*vlan)->ieee80211_ptr->wiphy != &rdev->wiphy)
 			return -EINVAL;
+		if (!netif_running(*vlan))
+			return -ENETDOWN;
 	}
 	return 0;
 }
