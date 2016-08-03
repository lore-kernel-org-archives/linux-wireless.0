Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:33462 "EHLO
	mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754375AbcHCOKv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Aug 2016 10:10:51 -0400
Received: by mail-oi0-f68.google.com with SMTP id l9so19966407oih.0
        for <linux-wireless@vger.kernel.org>; Wed, 03 Aug 2016 07:10:51 -0700 (PDT)
From: Denis Kenzior <denkenz@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Denis Kenzior <denkenz@gmail.com>
Subject: [PATCH v3 2/3] core: Always notify of new wireless netdevs
Date: Wed,  3 Aug 2016 16:58:34 -0500
Message-Id: <1470261515-2830-3-git-send-email-denkenz@gmail.com> (sfid-20160803_161055_142906_A373A4A6)
In-Reply-To: <1470261515-2830-1-git-send-email-denkenz@gmail.com>
References: <1470261515-2830-1-git-send-email-denkenz@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This change alters the semantics of NL80211_CMD_NEW_INTERFACE events
by always sending this event whenever a new net_device object
associated with a wdev is registered.  Prior to this change, this event
was only sent as a result of NL80211_CMD_NEW_INTERFACE command sent
from userspace.  This allows userspace to reliably detect new wireless
interfaces (e.g. due to hardware hot-plug events, etc).

For wdevs created without an associated net_device object (e.g.
NL80211_IFTYPE_P2P_DEVICE), the NL80211_CMD_NEW_INTERFACE event is
still generated inside the relevant nl80211 command handler.

Signed-off-by: Denis Kenzior <denkenz@gmail.com>
---
 net/wireless/core.c    |  2 ++
 net/wireless/nl80211.c | 23 +++++++++--------------
 2 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 7645e97..7758c0f 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1079,6 +1079,8 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 		     wdev->iftype == NL80211_IFTYPE_P2P_CLIENT ||
 		     wdev->iftype == NL80211_IFTYPE_ADHOC) && !wdev->use_4addr)
 			dev->priv_flags |= IFF_DONT_BRIDGE;
+
+		nl80211_notify_iface(rdev, wdev, NL80211_CMD_NEW_INTERFACE);
 		break;
 	case NETDEV_GOING_DOWN:
 		cfg80211_leave(rdev, wdev);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index c174770..591c3ab 100644
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

