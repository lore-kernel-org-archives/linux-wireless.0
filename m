Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:10312 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752516AbaKLO1J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2014 09:27:09 -0500
From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: linux-wireless@vger.kernel.org
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [PATCH v3] nl80211: Broadcast CMD_NEW_INTERFACE and CMD_DEL_INTERFACE
Date: Wed, 12 Nov 2014 16:26:45 +0200
Message-Id: <1415802405-10002-1-git-send-email-tomasz.bursztyka@linux.intel.com> (sfid-20141112_152713_936239_CB135719)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Let the other listeners being notified when a new or del interface
command has been issued, thus reducing later necessary request to be in
sync with current context.

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 net/wireless/nl80211.c | 48 +++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 41 insertions(+), 7 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 1a31736..653c337 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2341,12 +2341,16 @@ static int nl80211_send_chandef(struct sk_buff *msg,
 
 static int nl80211_send_iface(struct sk_buff *msg, u32 portid, u32 seq, int flags,
 			      struct cfg80211_registered_device *rdev,
-			      struct wireless_dev *wdev)
+			      struct wireless_dev *wdev, bool removal)
 {
 	struct net_device *dev = wdev->netdev;
+	u8 cmd = NL80211_CMD_NEW_INTERFACE;
 	void *hdr;
 
-	hdr = nl80211hdr_put(msg, portid, seq, flags, NL80211_CMD_NEW_INTERFACE);
+	if (removal)
+		cmd = NL80211_CMD_DEL_INTERFACE;
+
+	hdr = nl80211hdr_put(msg, portid, seq, flags, cmd);
 	if (!hdr)
 		return -1;
 
@@ -2413,7 +2417,7 @@ static int nl80211_dump_interface(struct sk_buff *skb, struct netlink_callback *
 			}
 			if (nl80211_send_iface(skb, NETLINK_CB(cb->skb).portid,
 					       cb->nlh->nlmsg_seq, NLM_F_MULTI,
-					       rdev, wdev) < 0) {
+					       rdev, wdev, false) < 0) {
 				goto out;
 			}
 			if_idx++;
@@ -2441,7 +2445,7 @@ static int nl80211_get_interface(struct sk_buff *skb, struct genl_info *info)
 		return -ENOMEM;
 
 	if (nl80211_send_iface(msg, info->snd_portid, info->snd_seq, 0,
-			       rdev, wdev) < 0) {
+			       rdev, wdev, false) < 0) {
 		nlmsg_free(msg);
 		return -ENOBUFS;
 	}
@@ -2587,7 +2591,7 @@ static int nl80211_new_interface(struct sk_buff *skb, struct genl_info *info)
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
 	struct vif_params params;
 	struct wireless_dev *wdev;
-	struct sk_buff *msg;
+	struct sk_buff *msg, *event;
 	int err;
 	enum nl80211_iftype type = NL80211_IFTYPE_UNSPECIFIED;
 	u32 flags;
@@ -2682,11 +2686,25 @@ static int nl80211_new_interface(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	if (nl80211_send_iface(msg, info->snd_portid, info->snd_seq, 0,
-			       rdev, wdev) < 0) {
+			       rdev, wdev, false) < 0) {
 		nlmsg_free(msg);
 		return -ENOBUFS;
 	}
 
+	event = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (event) {
+		if (nl80211_send_iface(event, 0, 0, 0,
+				       rdev, wdev, false) < 0) {
+			nlmsg_free(event);
+			goto out;
+		}
+
+		genlmsg_multicast_netns(&nl80211_fam, wiphy_net(&rdev->wiphy),
+					event, 0, NL80211_MCGRP_CONFIG,
+					GFP_KERNEL);
+	}
+
+out:
 	return genlmsg_reply(msg, info);
 }
 
@@ -2694,10 +2712,18 @@ static int nl80211_del_interface(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
 	struct wireless_dev *wdev = info->user_ptr[1];
+	struct sk_buff *msg;
+	int status;
 
 	if (!rdev->ops->del_virtual_intf)
 		return -EOPNOTSUPP;
 
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (msg && nl80211_send_iface(msg, 0, 0, 0, rdev, wdev, true) < 0) {
+		nlmsg_free(msg);
+		msg = NULL;
+	}
+
 	/*
 	 * If we remove a wireless device without a netdev then clear
 	 * user_ptr[1] so that nl80211_post_doit won't dereference it
@@ -2708,7 +2734,15 @@ static int nl80211_del_interface(struct sk_buff *skb, struct genl_info *info)
 	if (!wdev->netdev)
 		info->user_ptr[1] = NULL;
 
-	return rdev_del_virtual_intf(rdev, wdev);
+	status = rdev_del_virtual_intf(rdev, wdev);
+	if (status >= 0 && msg)
+		genlmsg_multicast_netns(&nl80211_fam, wiphy_net(&rdev->wiphy),
+					msg, 0, NL80211_MCGRP_CONFIG,
+					GFP_KERNEL);
+	else
+		nlmsg_free(msg);
+
+	return status;
 }
 
 static int nl80211_set_noack_map(struct sk_buff *skb, struct genl_info *info)
-- 
2.0.4

