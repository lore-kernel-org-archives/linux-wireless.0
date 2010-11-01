Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mgw-da01.ext.nokia.com ([147.243.128.24]:31630 "EHLO
	mgw-da01.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755898Ab0KAM3I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Nov 2010 08:29:08 -0400
Received: from localhost.localdomain (chilepepper.research.nokia.com [172.21.50.167])
	by mgw-da01.nokia.com (Switch-3.4.3/Switch-3.4.3) with ESMTP id oA1BqGcD020116
	for <linux-wireless@vger.kernel.org>; Mon, 1 Nov 2010 13:52:17 +0200
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linux-wireless@vger.kernel.org
Subject: [RFC 01/15] nl80211: add periodic scan commands
Date: Mon,  1 Nov 2010 13:52:02 +0200
Message-Id: <1288612336-2830-2-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1288612336-2830-1-git-send-email-luciano.coelho@nokia.com>
References: <1288612336-2830-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add NL80211_CMD_START_PERIODIC_SCAN and NL80211_CMD_STOP_PERIDIODIC_SCAN
commands to the nl80211 interface.  This is just a skeleton and no actual
functionality is implemented.

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 include/linux/nl80211.h |    6 ++
 net/wireless/nl80211.c  |  126 +++++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.h  |    2 +
 3 files changed, 134 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 0edb256..b3d1306 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -199,6 +199,9 @@
  * @NL80211_CMD_SCAN_ABORTED: scan was aborted, for unspecified reasons,
  *	partial scan results may be available
  *
+ * @NL80211_CMD_START_PERIODIC_SCAN: start a periodic scan
+ * @NL80211_CMD_STOP_PERIODIC_SCAN: stop a periodic scan
+ *
  * @NL80211_CMD_GET_SURVEY: get survey resuls, e.g. channel occupation
  *      or noise level
  * @NL80211_CMD_NEW_SURVEY_RESULTS: survey data notification (as a reply to
@@ -443,6 +446,9 @@ enum nl80211_commands {
 	NL80211_CMD_NEW_SCAN_RESULTS,
 	NL80211_CMD_SCAN_ABORTED,
 
+	NL80211_CMD_START_PERIODIC_SCAN,
+	NL80211_CMD_STOP_PERIODIC_SCAN,
+
 	NL80211_CMD_REG_CHANGE,
 
 	NL80211_CMD_AUTHENTICATE,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index c506241..a2293ea 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2998,6 +2998,80 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 	return err;
 }
 
+static int nl80211_start_periodic(struct sk_buff *skb,
+				  struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev;
+	struct net_device *dev;
+	int err;
+
+	printk("nl80211_start_periodic\n");
+
+	rtnl_lock();
+
+	err = get_rdev_dev_by_info_ifindex(info, &rdev, &dev);
+	if (err)
+		goto out_rtnl;
+
+	if (!netif_running(dev)) {
+		err = -ENETDOWN;
+		goto out;
+	}
+
+	/* add actual calls here */
+
+	if (!err) {
+		nl80211_send_periodic(rdev, dev,
+				      NL80211_CMD_START_PERIODIC_SCAN);
+		dev_hold(dev);
+	}
+
+out:
+	cfg80211_unlock_rdev(rdev);
+	dev_put(dev);
+out_rtnl:
+	rtnl_unlock();
+
+	return err;
+}
+
+static int nl80211_stop_periodic(struct sk_buff *skb,
+				 struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev;
+	struct net_device *dev;
+	int err;
+
+	printk("nl80211_stop_periodic\n");
+
+	rtnl_lock();
+
+	err = get_rdev_dev_by_info_ifindex(info, &rdev, &dev);
+	if (err)
+		goto out_rtnl;
+
+	if (!netif_running(dev)) {
+		err = -ENETDOWN;
+		goto out;
+	}
+
+	/* add actual calls here */
+
+	if (!err) {
+		nl80211_send_periodic(rdev, dev,
+				      NL80211_CMD_STOP_PERIODIC_SCAN);
+		dev_hold(dev);
+	}
+
+out:
+	cfg80211_unlock_rdev(rdev);
+	dev_put(dev);
+out_rtnl:
+	rtnl_unlock();
+
+	return err;
+}
+
 static int nl80211_send_bss(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 			    struct cfg80211_registered_device *rdev,
 			    struct wireless_dev *wdev,
@@ -4665,6 +4739,18 @@ static struct genl_ops nl80211_ops[] = {
 		.dumpit = nl80211_dump_scan,
 	},
 	{
+		.cmd = NL80211_CMD_START_PERIODIC_SCAN,
+		.doit = nl80211_start_periodic,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+	},
+	{
+		.cmd = NL80211_CMD_STOP_PERIODIC_SCAN,
+		.doit = nl80211_stop_periodic,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+	},
+	{
 		.cmd = NL80211_CMD_AUTHENTICATE,
 		.doit = nl80211_authenticate,
 		.policy = nl80211_policy,
@@ -4950,6 +5036,28 @@ static int nl80211_send_scan_msg(struct sk_buff *msg,
 	return -EMSGSIZE;
 }
 
+static int nl80211_send_periodic_msg(struct sk_buff *msg,
+				     struct cfg80211_registered_device *rdev,
+				     struct net_device *netdev,
+				     u32 pid, u32 seq, int flags,
+				     u32 cmd)
+{
+	void *hdr;
+
+	hdr = nl80211hdr_put(msg, pid, seq, flags, cmd);
+	if (!hdr)
+		return -1;
+
+	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx);
+	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, netdev->ifindex);
+
+	return genlmsg_end(msg, hdr);
+
+ nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+	return -EMSGSIZE;
+}
+
 void nl80211_send_scan_start(struct cfg80211_registered_device *rdev,
 			     struct net_device *netdev)
 {
@@ -5007,6 +5115,24 @@ void nl80211_send_scan_aborted(struct cfg80211_registered_device *rdev,
 				nl80211_scan_mcgrp.id, GFP_KERNEL);
 }
 
+void nl80211_send_periodic(struct cfg80211_registered_device *rdev,
+			   struct net_device *netdev, u32 cmd)
+{
+	struct sk_buff *msg;
+
+	msg = nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
+	if (!msg)
+		return;
+
+	if (nl80211_send_periodic_msg(msg, rdev, netdev, 0, 0, 0, cmd) < 0) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	genlmsg_multicast_netns(wiphy_net(&rdev->wiphy), msg, 0,
+				nl80211_scan_mcgrp.id, GFP_KERNEL);
+}
+
 /*
  * This can happen on global regulatory changes or device specific settings
  * based on custom world regulatory domains.
diff --git a/net/wireless/nl80211.h b/net/wireless/nl80211.h
index 30d2f93..435d452 100644
--- a/net/wireless/nl80211.h
+++ b/net/wireless/nl80211.h
@@ -12,6 +12,8 @@ void nl80211_send_scan_done(struct cfg80211_registered_device *rdev,
 			    struct net_device *netdev);
 void nl80211_send_scan_aborted(struct cfg80211_registered_device *rdev,
 			       struct net_device *netdev);
+void nl80211_send_periodic(struct cfg80211_registered_device *rdev,
+			   struct net_device *netdev, u32 cmd);
 void nl80211_send_reg_change_event(struct regulatory_request *request);
 void nl80211_send_rx_auth(struct cfg80211_registered_device *rdev,
 			  struct net_device *netdev,
-- 
1.7.0.4

