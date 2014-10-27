Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:36889 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752459AbaJ0Mne (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Oct 2014 08:43:34 -0400
From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: linux-wireless@vger.kernel.org
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [PATCH] wireless: nl80211: Broadcast CMD_NEW_INTERFACE and CMD_DEL_INTERFACE
Date: Mon, 27 Oct 2014 14:43:27 +0200
Message-Id: <1414413807-7649-1-git-send-email-tomasz.bursztyka@linux.intel.com> (sfid-20141027_134340_833740_6984A324)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Let the other listeners being notified when a new or del interface
command has been issued, thus reducing later necessary request to be in
sync with current context.

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---

Hi, 

In order not to change current API behavior for the command issuer, I kept
the reply for NEW_INTERFACE unicasted, as well as the returned status for
DEL_INTERFACE. This patch only add the notification for all other listeners.

It bloats a bit nl80211_send_iface() function (I wanted to reuse its logic
for both commands). Tell me if you would prefer a better way to do this.

Tomasz

 net/wireless/nl80211.c | 82 +++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 67 insertions(+), 15 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index cb9f5a4..b555c26 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2336,12 +2336,18 @@ static int nl80211_send_chandef(struct sk_buff *msg,
 
 static int nl80211_send_iface(struct sk_buff *msg, u32 portid, u32 seq, int flags,
 			      struct cfg80211_registered_device *rdev,
-			      struct wireless_dev *wdev)
+			      struct wireless_dev *wdev,
+			      enum nl80211_iftype iftype, u64 wdev_id,
+			      u8 *wdev_address, struct net_device *dev,
+			      u8 ssid_len, u8 *ssid, bool new)
 {
-	struct net_device *dev = wdev->netdev;
+	u8 cmd = NL80211_CMD_NEW_INTERFACE;
 	void *hdr;
 
-	hdr = nl80211hdr_put(msg, portid, seq, flags, NL80211_CMD_NEW_INTERFACE);
+	if (!new)
+		cmd = NL80211_CMD_DEL_INTERFACE;
+
+	hdr = nl80211hdr_put(msg, portid, seq, flags, cmd);
 	if (!hdr)
 		return -1;
 
@@ -2351,15 +2357,15 @@ static int nl80211_send_iface(struct sk_buff *msg, u32 portid, u32 seq, int flag
 		goto nla_put_failure;
 
 	if (nla_put_u32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx) ||
-	    nla_put_u32(msg, NL80211_ATTR_IFTYPE, wdev->iftype) ||
-	    nla_put_u64(msg, NL80211_ATTR_WDEV, wdev_id(wdev)) ||
-	    nla_put(msg, NL80211_ATTR_MAC, ETH_ALEN, wdev_address(wdev)) ||
+	    nla_put_u32(msg, NL80211_ATTR_IFTYPE, iftype) ||
+	    nla_put_u64(msg, NL80211_ATTR_WDEV, wdev_id) ||
+	    nla_put(msg, NL80211_ATTR_MAC, ETH_ALEN, wdev_address) ||
 	    nla_put_u32(msg, NL80211_ATTR_GENERATION,
 			rdev->devlist_generation ^
 			(cfg80211_rdev_list_generation << 2)))
 		goto nla_put_failure;
 
-	if (rdev->ops->get_channel) {
+	if (wdev && rdev->ops->get_channel) {
 		int ret;
 		struct cfg80211_chan_def chandef;
 
@@ -2370,10 +2376,8 @@ static int nl80211_send_iface(struct sk_buff *msg, u32 portid, u32 seq, int flag
 		}
 	}
 
-	if (wdev->ssid_len) {
-		if (nla_put(msg, NL80211_ATTR_SSID, wdev->ssid_len, wdev->ssid))
+	if (ssid_len && nla_put(msg, NL80211_ATTR_SSID, ssid_len, ssid))
 			goto nla_put_failure;
-	}
 
 	return genlmsg_end(msg, hdr);
 
@@ -2382,6 +2386,28 @@ static int nl80211_send_iface(struct sk_buff *msg, u32 portid, u32 seq, int flag
 	return -EMSGSIZE;
 }
 
+static void nl80211_notify_iface(struct cfg80211_registered_device *rdev,
+				 struct wireless_dev *wdev,
+				 enum nl80211_iftype iftype, u64 wdev_id,
+				 u8 *wdev_address, struct net_device *dev,
+				 u8 ssid_len, u8 *ssid, bool new, u32 portid)
+{
+	struct sk_buff *msg;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return;
+
+	if (nl80211_send_iface(msg, 0, 0, 0, rdev, wdev, iftype, wdev_id,
+			       wdev_address, dev, ssid_len, ssid, new) < 0) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	genlmsg_multicast_netns(&nl80211_fam, wiphy_net(&rdev->wiphy),
+				msg, portid, NL80211_MCGRP_CONFIG, GFP_KERNEL);
+}
+
 static int nl80211_dump_interface(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	int wp_idx = 0;
@@ -2408,7 +2434,11 @@ static int nl80211_dump_interface(struct sk_buff *skb, struct netlink_callback *
 			}
 			if (nl80211_send_iface(skb, NETLINK_CB(cb->skb).portid,
 					       cb->nlh->nlmsg_seq, NLM_F_MULTI,
-					       rdev, wdev) < 0) {
+					       rdev, wdev, wdev->iftype,
+					       wdev_id(wdev),
+					       wdev_address(wdev),
+					       wdev->netdev, wdev->ssid_len,
+					       wdev->ssid, true) < 0) {
 				goto out;
 			}
 			if_idx++;
@@ -2436,7 +2466,9 @@ static int nl80211_get_interface(struct sk_buff *skb, struct genl_info *info)
 		return -ENOMEM;
 
 	if (nl80211_send_iface(msg, info->snd_portid, info->snd_seq, 0,
-			       rdev, wdev) < 0) {
+			       rdev, wdev, wdev->iftype, wdev_id(wdev),
+			       wdev_address(wdev), wdev->netdev,
+			       wdev->ssid_len, wdev->ssid, true) < 0) {
 		nlmsg_free(msg);
 		return -ENOBUFS;
 	}
@@ -2675,11 +2707,17 @@ static int nl80211_new_interface(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	if (nl80211_send_iface(msg, info->snd_portid, info->snd_seq, 0,
-			       rdev, wdev) < 0) {
+			       rdev, wdev, wdev->iftype, wdev_id(wdev),
+			       wdev_address(wdev), wdev->netdev,
+			       wdev->ssid_len, wdev->ssid, true) < 0) {
 		nlmsg_free(msg);
 		return -ENOBUFS;
 	}
 
+	nl80211_notify_iface(rdev, wdev, wdev->iftype, wdev_id(wdev),
+			     wdev_address(wdev), wdev->netdev, wdev->ssid_len,
+			     wdev->ssid, true, info->snd_portid);
+
 	return genlmsg_reply(msg, info);
 }
 
@@ -2687,10 +2725,17 @@ static int nl80211_del_interface(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
 	struct wireless_dev *wdev = info->user_ptr[1];
+	enum nl80211_iftype iftype = wdev->iftype;
+	struct net_device *dev = wdev->netdev;
+	u8 address[ETH_ALEN];
+	u64 id = wdev_id(wdev);
+	int status;
 
 	if (!rdev->ops->del_virtual_intf)
 		return -EOPNOTSUPP;
 
+	memcpy(address, wdev_address(wdev), ETH_ALEN);
+
 	/*
 	 * If we remove a wireless device without a netdev then clear
 	 * user_ptr[1] so that nl80211_post_doit won't dereference it
@@ -2698,10 +2743,17 @@ static int nl80211_del_interface(struct sk_buff *skb, struct genl_info *info)
 	 * since the wdev has been freed, unlike with a netdev where
 	 * we need the dev_put() for the netdev to really be freed.
 	 */
-	if (!wdev->netdev)
+	if (!dev)
 		info->user_ptr[1] = NULL;
 
-	return rdev_del_virtual_intf(rdev, wdev);
+	status = rdev_del_virtual_intf(rdev, wdev);
+	if (status < 0)
+		return status;
+
+	nl80211_notify_iface(rdev, NULL, iftype, id, address, dev,
+			     0, NULL, false, info->snd_portid);
+
+	return status;
 }
 
 static int nl80211_set_noack_map(struct sk_buff *skb, struct genl_info *info)
-- 
2.0.4

