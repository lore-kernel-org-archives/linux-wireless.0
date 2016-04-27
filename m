Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49848 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752385AbcD0IRW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Apr 2016 04:17:22 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: fix statistics leak if dev_alloc_name() fails
Date: Wed, 27 Apr 2016 10:17:16 +0200
Message-Id: <1461745036-30993-1-git-send-email-johannes@sipsolutions.net> (sfid-20160427_101727_138712_E3E42B7B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In the case that dev_alloc_name() fails, e.g. because the name was
given by the user and already exists, we need to clean up properly
and free the per-CPU statistics. Fix that.

Cc: stable@vger.kernel.org
Fixes: 5a490510ba5f ("mac80211: use per-CPU TX/RX statistics")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/iface.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 453b4e741780..e1cb22c16530 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1761,7 +1761,7 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 
 		ret = dev_alloc_name(ndev, ndev->name);
 		if (ret < 0) {
-			free_netdev(ndev);
+			ieee80211_if_free(ndev);
 			return ret;
 		}
 
@@ -1847,7 +1847,7 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 
 		ret = register_netdevice(ndev);
 		if (ret) {
-			free_netdev(ndev);
+			ieee80211_if_free(ndev);
 			return ret;
 		}
 	}
-- 
2.8.0.rc3

