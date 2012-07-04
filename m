Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:63422 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995Ab2GDP67 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jul 2012 11:58:59 -0400
Received: by werb14 with SMTP id b14so4517616wer.19
        for <linux-wireless@vger.kernel.org>; Wed, 04 Jul 2012 08:58:57 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [RFC 1/4] nl80211: accept optional netdev in send_wiphy
Date: Wed,  4 Jul 2012 18:58:47 +0300
Message-Id: <1341417530-9062-2-git-send-email-arik@wizery.com> (sfid-20120704_175903_375037_FD3EE5A2)
In-Reply-To: <1341417530-9062-1-git-send-email-arik@wizery.com>
References: <1341417530-9062-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When a specific interface is requested in a GET_WIPHY command, propagate
the interface to the send_wiphy. This allows interface specific abilities
to be sent up.

This change requires us to implement a new internal flag for NL commands
for optionally getting the netdev. This flag is used for GET_WIPHY.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 net/wireless/nl80211.c |   38 +++++++++++++++++++++++++++++++++-----
 1 file changed, 33 insertions(+), 5 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 77102e6..010ff47 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -791,7 +791,8 @@ nla_put_failure:
 }
 
 static int nl80211_send_wiphy(struct sk_buff *msg, u32 pid, u32 seq, int flags,
-			      struct cfg80211_registered_device *dev)
+			      struct cfg80211_registered_device *dev,
+			      struct net_device *netdev)
 {
 	void *hdr;
 	struct nlattr *nl_bands, *nl_band;
@@ -1207,7 +1208,7 @@ static int nl80211_dump_wiphy(struct sk_buff *skb, struct netlink_callback *cb)
 			continue;
 		if (nl80211_send_wiphy(skb, NETLINK_CB(cb->skb).pid,
 				       cb->nlh->nlmsg_seq, NLM_F_MULTI,
-				       dev) < 0) {
+				       dev, NULL) < 0) {
 			idx--;
 			break;
 		}
@@ -1223,12 +1224,14 @@ static int nl80211_get_wiphy(struct sk_buff *skb, struct genl_info *info)
 {
 	struct sk_buff *msg;
 	struct cfg80211_registered_device *dev = info->user_ptr[0];
+	struct net_device *netdev = info->user_ptr[1];
 
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
 	if (!msg)
 		return -ENOMEM;
 
-	if (nl80211_send_wiphy(msg, info->snd_pid, info->snd_seq, 0, dev) < 0) {
+	if (nl80211_send_wiphy(msg, info->snd_pid, info->snd_seq, 0, dev,
+			       netdev) < 0) {
 		nlmsg_free(msg);
 		return -ENOBUFS;
 	}
@@ -6648,6 +6651,7 @@ static int nl80211_register_beacons(struct sk_buff *skb, struct genl_info *info)
 #define NL80211_FLAG_NEED_NETDEV	0x02
 #define NL80211_FLAG_NEED_RTNL		0x04
 #define NL80211_FLAG_CHECK_NETDEV_UP	0x08
+#define NL80211_FLAG_OPT_NETDEV_UP	0x10 /* get netdev if given and up */
 #define NL80211_FLAG_NEED_NETDEV_UP	(NL80211_FLAG_NEED_NETDEV |\
 					 NL80211_FLAG_CHECK_NETDEV_UP)
 
@@ -6688,6 +6692,30 @@ static int nl80211_pre_doit(struct genl_ops *ops, struct sk_buff *skb,
 		}
 		info->user_ptr[0] = rdev;
 		info->user_ptr[1] = dev;
+	} else if (ops->internal_flags & NL80211_FLAG_OPT_NETDEV_UP) {
+		if (info->attrs[NL80211_ATTR_IFINDEX]) {
+			err = get_rdev_dev_by_ifindex(genl_info_net(info),
+						      info->attrs, &rdev,
+						      &dev);
+			/* only get the netdev if up */
+			if (!err && !netif_running(dev)) {
+				dev_put(dev);
+				dev = NULL;
+			}
+		} else {
+			dev = NULL;
+			rdev = cfg80211_get_dev_from_info(genl_info_net(info),
+							  info);
+			err = IS_ERR(rdev) ? PTR_ERR(rdev) : 0;
+		}
+		if (err) {
+			if (rtnl)
+				rtnl_unlock();
+			return err;
+		}
+
+		info->user_ptr[0] = rdev;
+		info->user_ptr[1] = dev; /* might be null */
 	}
 
 	return 0;
@@ -6711,7 +6739,7 @@ static struct genl_ops nl80211_ops[] = {
 		.dumpit = nl80211_dump_wiphy,
 		.policy = nl80211_policy,
 		/* can be retrieved by unprivileged users */
-		.internal_flags = NL80211_FLAG_NEED_WIPHY,
+		.internal_flags = NL80211_FLAG_OPT_NETDEV_UP,
 	},
 	{
 		.cmd = NL80211_CMD_SET_WIPHY,
@@ -7262,7 +7290,7 @@ void nl80211_notify_dev_rename(struct cfg80211_registered_device *rdev)
 	if (!msg)
 		return;
 
-	if (nl80211_send_wiphy(msg, 0, 0, 0, rdev) < 0) {
+	if (nl80211_send_wiphy(msg, 0, 0, 0, rdev, NULL) < 0) {
 		nlmsg_free(msg);
 		return;
 	}
-- 
1.7.9.5

