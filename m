Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:41791 "EHLO mail.neratec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753392Ab1BIMCD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 07:02:03 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.neratec.ch (Postfix) with ESMTP id 3F139664001
	for <linux-wireless@vger.kernel.org>; Wed,  9 Feb 2011 13:02:01 +0100 (CET)
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
To: linux-wireless@vger.kernel.org
Cc: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Subject: [PATCH 1/2] nl80211: interface update
Date: Wed,  9 Feb 2011 13:01:41 +0100
Message-Id: <1297252905-29739-2-git-send-email-zefir.kurtisi@neratec.com>
In-Reply-To: <1297252905-29739-1-git-send-email-zefir.kurtisi@neratec.com>
References: <1297252905-29739-1-git-send-email-zefir.kurtisi@neratec.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Interface implementation to pass DFS pulse events via nl80211.

Includes
 * new command NL80211_CMD_SET_DFS_EVENT
 * new attributes NL80211_DFSEVENT_ATTR_{FREQ,TS,WIDTH}
 * functions to pass DFS pulse events through netlink interface
---
 include/linux/nl80211.h |    6 +++++
 include/net/cfg80211.h  |    6 +++++
 net/wireless/core.c     |   11 ++++++++++
 net/wireless/nl80211.c  |   48 ++++++++++++++++++++++++++++++++++++++++++++++-
 net/wireless/nl80211.h  |    3 ++
 5 files changed, 73 insertions(+), 1 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 821ffb9..ae3f6ae 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -524,6 +524,8 @@ enum nl80211_commands {
 
 	/* add new commands above here */
 
+	NL80211_CMD_SET_DFS_EVENT,
+
 	/* used to define NL80211_CMD_MAX below */
 	__NL80211_CMD_AFTER_LAST,
 	NL80211_CMD_MAX = __NL80211_CMD_AFTER_LAST - 1
@@ -1076,6 +1078,10 @@ enum nl80211_attrs {
 
 	/* add attributes here, update the policy in nl80211.c */
 
+	NL80211_DFSEVENT_ATTR_FREQ,
+	NL80211_DFSEVENT_ATTR_TS,
+	NL80211_DFSEVENT_ATTR_WIDTH,
+
 	__NL80211_ATTR_AFTER_LAST,
 	NL80211_ATTR_MAX = __NL80211_ATTR_AFTER_LAST - 1
 };
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 679a049..59ced7a 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2715,6 +2715,12 @@ void cfg80211_cqm_rssi_notify(struct net_device *dev,
 void cfg80211_cqm_pktloss_notify(struct net_device *dev,
 				 const u8 *peer, u32 num_packets, gfp_t gfp);
 
+
+/**
+ * DFS radar pulse reporting
+ */
+void ieee80211_add_radar_pulse(struct wiphy *wiphy, u16 freq, u64 ts, u8 width);
+
 /* Logging, debugging and troubleshooting/diagnostic helpers. */
 
 /* wiphy_printk helpers, similar to dev_printk */
diff --git a/net/wireless/core.c b/net/wireless/core.c
index fe01de2..4e62d37 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -944,3 +944,14 @@ static void __exit cfg80211_exit(void)
 	destroy_workqueue(cfg80211_wq);
 }
 module_exit(cfg80211_exit);
+
+
+/**
+ * DFS
+ */
+
+void ieee80211_add_radar_pulse(struct wiphy *wiphy, u16 freq, u64 ts, u8 width)
+{
+	return nl80211_send_dfs_event(wiphy, freq, ts, width);
+}
+EXPORT_SYMBOL(ieee80211_add_radar_pulse);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 864ddfb..8e75f40 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4015,7 +4015,6 @@ __cfg80211_testmode_alloc_skb(struct cfg80211_registered_device *rdev,
 	skb = nlmsg_new(approxlen + 100, gfp);
 	if (!skb)
 		return NULL;
-
 	hdr = nl80211hdr_put(skb, pid, seq, 0, NL80211_CMD_TESTMODE);
 	if (!hdr) {
 		kfree_skb(skb);
@@ -6191,3 +6190,50 @@ void nl80211_exit(void)
 	netlink_unregister_notifier(&nl80211_netlink_notifier);
 	genl_unregister_family(&nl80211_fam);
 }
+
+
+void nl80211_send_dfs_event(struct wiphy *wiphy, u16 freq, u64 ts, u8 width)
+{
+	struct sk_buff *msg;
+	void *hdr;
+	int wiphy_idx = 0;
+
+	if (wiphy == NULL) {
+		printk(KERN_WARNING "nl80211_send_dfs_event: wiphy=0\n");
+		return;
+	}
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_ATOMIC);
+	if (!msg)
+		return;
+
+	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_SET_DFS_EVENT);
+	if (!hdr) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	wiphy_idx = get_wiphy_idx(wiphy);
+
+	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY, wiphy_idx);
+	NLA_PUT_U16(msg, NL80211_DFSEVENT_ATTR_FREQ, freq);
+	NLA_PUT_U64(msg, NL80211_DFSEVENT_ATTR_TS, ts);
+	NLA_PUT_U8(msg, NL80211_DFSEVENT_ATTR_WIDTH, width);
+
+	if (genlmsg_end(msg, hdr) < 0) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	rcu_read_lock();
+	genlmsg_multicast_netns(wiphy_net(wiphy), msg, 0,
+			nl80211_regulatory_mcgrp.id, GFP_ATOMIC);
+	rcu_read_unlock();
+
+	return;
+
+nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+	nlmsg_free(msg);
+}
+
diff --git a/net/wireless/nl80211.h b/net/wireless/nl80211.h
index e3f7fa8..3d3bbc4 100644
--- a/net/wireless/nl80211.h
+++ b/net/wireless/nl80211.h
@@ -98,4 +98,7 @@ nl80211_send_cqm_pktloss_notify(struct cfg80211_registered_device *rdev,
 				struct net_device *netdev, const u8 *peer,
 				u32 num_packets, gfp_t gfp);
 
+void nl80211_send_dfs_event(struct wiphy *wiphy, u16 freq, u64 ts, u8 width);
+
+
 #endif /* __NET_WIRELESS_NL80211_H */
-- 
1.7.1

