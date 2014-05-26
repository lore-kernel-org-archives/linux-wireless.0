Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58720 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751998AbaEZLz0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2014 07:55:26 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: send events when devices are added/removed
Date: Mon, 26 May 2014 13:55:16 +0200
Message-Id: <1401105316-11200-1-git-send-email-johannes@sipsolutions.net> (sfid-20140526_135529_561920_C7B3BB90)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

We're currently sending NEW_WIPHY events for renames (which
is a bit odd, but now can't be changed), but also send them
for really new devices that register.

Also send DEL_WIPHY events when a device is removed, the
event ID for this was already reserved.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/core.c    |  5 ++++-
 net/wireless/nl80211.c | 21 ++++++++++++++++-----
 net/wireless/nl80211.h |  3 ++-
 3 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index d03d8bdb29ca..a1c40654dd9b 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -130,7 +130,7 @@ int cfg80211_dev_rename(struct cfg80211_registered_device *rdev,
 			    newname))
 		pr_err("failed to rename debugfs dir to %s!\n", newname);
 
-	nl80211_notify_dev_rename(rdev);
+	nl80211_notify_wiphy(rdev, NL80211_CMD_NEW_WIPHY);
 
 	return 0;
 }
@@ -660,6 +660,8 @@ int wiphy_register(struct wiphy *wiphy)
 		return res;
 	}
 
+	nl80211_notify_wiphy(rdev, NL80211_CMD_NEW_WIPHY);
+
 	return 0;
 }
 EXPORT_SYMBOL(wiphy_register);
@@ -698,6 +700,7 @@ void wiphy_unregister(struct wiphy *wiphy)
 		rfkill_unregister(rdev->rfkill);
 
 	rtnl_lock();
+	nl80211_notify_wiphy(rdev, NL80211_CMD_DEL_WIPHY);
 	rdev->wiphy.registered = false;
 
 	WARN_ON(!list_empty(&rdev->wdev_list));
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 62bdb1adaa4d..ba4f1723c83a 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1226,6 +1226,7 @@ struct nl80211_dump_wiphy_state {
 };
 
 static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
+			      enum nl80211_commands cmd,
 			      struct sk_buff *msg, u32 portid, u32 seq,
 			      int flags, struct nl80211_dump_wiphy_state *state)
 {
@@ -1240,7 +1241,7 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 				rdev->wiphy.mgmt_stypes;
 	u32 features;
 
-	hdr = nl80211hdr_put(msg, portid, seq, flags, NL80211_CMD_NEW_WIPHY);
+	hdr = nl80211hdr_put(msg, portid, seq, flags, cmd);
 	if (!hdr)
 		return -ENOBUFS;
 
@@ -1254,6 +1255,9 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 			cfg80211_rdev_list_generation))
 		goto nla_put_failure;
 
+	if (cmd != NL80211_CMD_NEW_WIPHY)
+		goto finish;
+
 	switch (state->split_start) {
 	case 0:
 		if (nla_put_u8(msg, NL80211_ATTR_WIPHY_RETRY_SHORT,
@@ -1682,6 +1686,7 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 		state->split_start = 0;
 		break;
 	}
+ finish:
 	return genlmsg_end(msg, hdr);
 
  nla_put_failure:
@@ -1756,7 +1761,8 @@ static int nl80211_dump_wiphy(struct sk_buff *skb, struct netlink_callback *cb)
 			continue;
 		/* attempt to fit multiple wiphy data chunks into the skb */
 		do {
-			ret = nl80211_send_wiphy(rdev, skb,
+			ret = nl80211_send_wiphy(rdev, NL80211_CMD_NEW_WIPHY,
+						 skb,
 						 NETLINK_CB(cb->skb).portid,
 						 cb->nlh->nlmsg_seq,
 						 NLM_F_MULTI, state);
@@ -1811,7 +1817,8 @@ static int nl80211_get_wiphy(struct sk_buff *skb, struct genl_info *info)
 	if (!msg)
 		return -ENOMEM;
 
-	if (nl80211_send_wiphy(rdev, msg, info->snd_portid, info->snd_seq, 0,
+	if (nl80211_send_wiphy(rdev, NL80211_CMD_NEW_WIPHY, msg,
+			       info->snd_portid, info->snd_seq, 0,
 			       &state) < 0) {
 		nlmsg_free(msg);
 		return -ENOBUFS;
@@ -10101,16 +10108,20 @@ static const struct genl_ops nl80211_ops[] = {
 
 /* notification functions */
 
-void nl80211_notify_dev_rename(struct cfg80211_registered_device *rdev)
+void nl80211_notify_wiphy(struct cfg80211_registered_device *rdev,
+			  enum nl80211_commands cmd)
 {
 	struct sk_buff *msg;
 	struct nl80211_dump_wiphy_state state = {};
 
+	WARN_ON(cmd != NL80211_CMD_NEW_WIPHY &&
+		cmd != NL80211_CMD_DEL_WIPHY);
+
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
 	if (!msg)
 		return;
 
-	if (nl80211_send_wiphy(rdev, msg, 0, 0, 0, &state) < 0) {
+	if (nl80211_send_wiphy(rdev, cmd, msg, 0, 0, 0, &state) < 0) {
 		nlmsg_free(msg);
 		return;
 	}
diff --git a/net/wireless/nl80211.h b/net/wireless/nl80211.h
index 1e6df9630f42..49c9a482dd12 100644
--- a/net/wireless/nl80211.h
+++ b/net/wireless/nl80211.h
@@ -5,7 +5,8 @@
 
 int nl80211_init(void);
 void nl80211_exit(void);
-void nl80211_notify_dev_rename(struct cfg80211_registered_device *rdev);
+void nl80211_notify_wiphy(struct cfg80211_registered_device *rdev,
+			  enum nl80211_commands cmd);
 void nl80211_send_scan_start(struct cfg80211_registered_device *rdev,
 			     struct wireless_dev *wdev);
 struct sk_buff *nl80211_build_scan_msg(struct cfg80211_registered_device *rdev,
-- 
2.0.0.rc0

