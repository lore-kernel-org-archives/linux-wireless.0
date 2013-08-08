Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from diserzione.investici.org ([82.221.99.153]:29268 "EHLO
	diserzione.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758112Ab3HHXYo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Aug 2013 19:24:44 -0400
From: Antonio Quartulli <ordex@autistici.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Antonio Quartulli <antonio@open-mesh.com>
Subject: [PATCHv2] cfg/nl80211: send CMD_INTERFACE event on NETDEV_UNREGISTER
Date: Fri,  9 Aug 2013 01:24:35 +0200
Message-Id: <1376004275-606-1-git-send-email-ordex@autistici.org> (sfid-20130809_012446_788246_E0D30B94)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Antonio Quartulli <antonio@open-mesh.com>

Userspace applications may be listening for events (e.g.
matching mgmt frame) on a given interface. If such interface
is deleted they would keep hanging because no event will be
delivered anymore.

Send a CMD_INTERFACE event on NETDEV_UNREGISTER to notify
userspace that the interface does not exist anymore.

Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>
---
 net/wireless/core.c    |  2 ++
 net/wireless/nl80211.c | 31 +++++++++++++++++++++++++++++++
 net/wireless/nl80211.h |  3 +++
 3 files changed, 36 insertions(+)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 389a3f2..ae4c148 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -913,6 +913,8 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 			}
 		break;
 	case NETDEV_UNREGISTER:
+		nl80211_send_del_iface(rdev, dev, GFP_KERNEL);
+
 		/*
 		 * It is possible to get NETDEV_UNREGISTER
 		 * multiple times. To detect that, check
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index f7cb121..61be4ea 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -10022,6 +10022,37 @@ void nl80211_send_disconnected(struct cfg80211_registered_device *rdev,
 
 }
 
+void nl80211_send_del_iface(struct cfg80211_registered_device *rdev,
+			    struct net_device *netdev, gfp_t gfp)
+{
+	struct sk_buff *msg;
+	void *hdr;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, gfp);
+	if (!msg)
+		return;
+
+	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_DEL_INTERFACE);
+	if (!hdr) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	if (nla_put_u32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx) ||
+	    nla_put_u32(msg, NL80211_ATTR_IFINDEX, netdev->ifindex))
+		goto nla_put_failure;
+
+	genlmsg_end(msg, hdr);
+
+	genlmsg_multicast_netns(wiphy_net(&rdev->wiphy), msg, 0,
+				nl80211_mlme_mcgrp.id, gfp);
+	return;
+
+ nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+	nlmsg_free(msg);
+}
+
 void nl80211_send_ibss_bssid(struct cfg80211_registered_device *rdev,
 			     struct net_device *netdev, const u8 *bssid,
 			     gfp_t gfp)
diff --git a/net/wireless/nl80211.h b/net/wireless/nl80211.h
index 44341bf..6071557 100644
--- a/net/wireless/nl80211.h
+++ b/net/wireless/nl80211.h
@@ -59,6 +59,9 @@ nl80211_send_beacon_hint_event(struct wiphy *wiphy,
 			       struct ieee80211_channel *channel_before,
 			       struct ieee80211_channel *channel_after);
 
+void nl80211_send_del_iface(struct cfg80211_registered_device *rdev,
+			    struct net_device *netdev, gfp_t gfp);
+
 void nl80211_send_ibss_bssid(struct cfg80211_registered_device *rdev,
 			     struct net_device *netdev, const u8 *bssid,
 			     gfp_t gfp);
-- 
1.8.1.5

