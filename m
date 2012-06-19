Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52384 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753494Ab2FSOv1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jun 2012 10:51:27 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 12/17] nl80211: send interface after creation
Date: Tue, 19 Jun 2012 16:50:51 +0200
Message-Id: <1340117456-10154-13-git-send-email-johannes@sipsolutions.net> (sfid-20120619_165142_779412_7697001B)
In-Reply-To: <1340117456-10154-1-git-send-email-johannes@sipsolutions.net>
References: <1340117456-10154-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

After a new virtual interface is created, reply
to userspace with a message detailing it so it
knows the new wdev identifier.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 9f5e796..861611b 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1962,6 +1962,7 @@ static int nl80211_new_interface(struct sk_buff *skb, struct genl_info *info)
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
 	struct vif_params params;
 	struct wireless_dev *wdev;
+	struct sk_buff *msg;
 	int err;
 	enum nl80211_iftype type = NL80211_IFTYPE_UNSPECIFIED;
 	u32 flags;
@@ -1988,14 +1989,20 @@ static int nl80211_new_interface(struct sk_buff *skb, struct genl_info *info)
 			return err;
 	}
 
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+
 	err = parse_monitor_flags(type == NL80211_IFTYPE_MONITOR ?
 				  info->attrs[NL80211_ATTR_MNTR_FLAGS] : NULL,
 				  &flags);
 	wdev = rdev->ops->add_virtual_intf(&rdev->wiphy,
 		nla_data(info->attrs[NL80211_ATTR_IFNAME]),
 		type, err ? NULL : &flags, &params);
-	if (IS_ERR(wdev))
+	if (IS_ERR(wdev)) {
+		nlmsg_free(msg);
 		return PTR_ERR(wdev);
+	}
 
 	if (type == NL80211_IFTYPE_MESH_POINT &&
 	    info->attrs[NL80211_ATTR_MESH_ID]) {
@@ -2009,7 +2016,13 @@ static int nl80211_new_interface(struct sk_buff *skb, struct genl_info *info)
 		wdev_unlock(wdev);
 	}
 
-	return 0;
+	if (nl80211_send_iface(msg, info->snd_pid, info->snd_seq, 0,
+			       rdev, wdev) < 0) {
+		nlmsg_free(msg);
+		return -ENOBUFS;
+	}
+
+	return genlmsg_reply(msg, info);
 }
 
 static int nl80211_del_interface(struct sk_buff *skb, struct genl_info *info)
-- 
1.7.10

