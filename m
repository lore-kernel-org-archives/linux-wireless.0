Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46975 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757468AbZDSOXY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Apr 2009 10:23:24 -0400
Subject: [PATCH] nl80211: send wiphy along with netdev
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 19 Apr 2009 16:23:20 +0200
Message-Id: <1240151000.898.9.camel@johannes.local> (sfid-20090419_162327_266188_65E30287)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When listing all wireless netdevs in the system this
is useful to print which wiphy they belong to. Just
add the attribute, any program that doesn't care will
just ignore it.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/nl80211.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- wireless-testing.orig/net/wireless/nl80211.c	2009-04-19 16:18:50.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.c	2009-04-19 16:21:28.000000000 +0200
@@ -542,6 +542,7 @@ static int nl80211_set_wiphy(struct sk_b
 
 
 static int nl80211_send_iface(struct sk_buff *msg, u32 pid, u32 seq, int flags,
+			      struct cfg80211_registered_device *rdev,
 			      struct net_device *dev)
 {
 	void *hdr;
@@ -551,6 +552,7 @@ static int nl80211_send_iface(struct sk_
 		return -1;
 
 	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, dev->ifindex);
+	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx);
 	NLA_PUT_STRING(msg, NL80211_ATTR_IFNAME, dev->name);
 	NLA_PUT_U32(msg, NL80211_ATTR_IFTYPE, dev->ieee80211_ptr->iftype);
 	return genlmsg_end(msg, hdr);
@@ -585,7 +587,7 @@ static int nl80211_dump_interface(struct
 			}
 			if (nl80211_send_iface(skb, NETLINK_CB(cb->skb).pid,
 					       cb->nlh->nlmsg_seq, NLM_F_MULTI,
-					       wdev->netdev) < 0) {
+					       dev, wdev->netdev) < 0) {
 				mutex_unlock(&dev->devlist_mtx);
 				goto out;
 			}
@@ -619,7 +621,8 @@ static int nl80211_get_interface(struct 
 	if (!msg)
 		goto out_err;
 
-	if (nl80211_send_iface(msg, info->snd_pid, info->snd_seq, 0, netdev) < 0)
+	if (nl80211_send_iface(msg, info->snd_pid, info->snd_seq, 0,
+			       dev, netdev) < 0)
 		goto out_free;
 
 	dev_put(netdev);


