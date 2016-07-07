Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:36835 "EHLO
	mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932892AbcGFXIj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2016 19:08:39 -0400
Received: by mail-oi0-f65.google.com with SMTP id m11so175148oik.3
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jul 2016 16:08:38 -0700 (PDT)
From: Denis Kenzior <denkenz@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Denis Kenzior <denkenz@gmail.com>
Subject: [PATCH 3/5] nl80211: Emit NEW_INTERFACE only in special cases
Date: Thu,  7 Jul 2016 02:08:48 -0500
Message-Id: <1467875330-7835-4-git-send-email-denkenz@gmail.com> (sfid-20160707_010855_964627_CA5A76F0)
In-Reply-To: <1467875330-7835-1-git-send-email-denkenz@gmail.com>
References: <1467875330-7835-1-git-send-email-denkenz@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For wireless device objects with an associated netdev, the NEW_INTERFACE
event is generated inside the netdev notifier.  The event is generated
regardless of whether it was due to a NL80211_CMD_NEW_INTERFACE call
from userspace or if the netdev was created implicitly by the driver.

If NL80211_CMD_NEW_INTERFACE handler is called, then a duplicate
NEW_INTERFACE event will be multicast.  This change modifies the logic
inside nl80211_new_interface to avoid this.
---
 net/wireless/nl80211.c | 23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index da03e17..ec8eb88 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2787,7 +2787,7 @@ static int nl80211_new_interface(struct sk_buff *skb, struct genl_info *info)
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
 	struct vif_params params;
 	struct wireless_dev *wdev;
-	struct sk_buff *msg, *event;
+	struct sk_buff *msg;
 	int err;
 	enum nl80211_iftype type = NL80211_IFTYPE_UNSPECIFIED;
 	u32 flags;
@@ -2891,20 +2891,15 @@ static int nl80211_new_interface(struct sk_buff *skb, struct genl_info *info)
 		return -ENOBUFS;
 	}
 
-	event = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
-	if (event) {
-		if (nl80211_send_iface(event, 0, 0, 0,
-				       rdev, wdev, false) < 0) {
-			nlmsg_free(event);
-			goto out;
-		}
-
-		genlmsg_multicast_netns(&nl80211_fam, wiphy_net(&rdev->wiphy),
-					event, 0, NL80211_MCGRP_CONFIG,
-					GFP_KERNEL);
-	}
+	/*
+	 * For wdevs which have no associated netdev object (e.g. of type
+	 * NL80211_IFTYPE_P2P_DEVICE), emit the NEW_INTERFACE event here.
+	 * For all other types, the event will be generated from the
+	 * netdev notifier
+	 */
+	if (!wdev->netdev)
+		nl80211_notify_iface(rdev, wdev, NL80211_CMD_NEW_INTERFACE);
 
-out:
 	return genlmsg_reply(msg, info);
 }
 
-- 
2.7.3

