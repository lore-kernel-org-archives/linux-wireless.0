Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from postel.suug.ch ([194.88.212.233]:53072 "EHLO postel.suug.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753697AbXGVLGf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Jul 2007 07:06:35 -0400
Date: Sun, 22 Jul 2007 12:43:32 +0200
From: Thomas Graf <tgraf@suug.ch>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [WIRELESS]: Use type safe netlink interface
Message-ID: <20070722104332.GL3651@postel.suug.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Makes use of the type safe netlink interface and adds a warning
if the message is too big for NLMSG_DEFAULT_SIZE to help debug.

Signed-off-by: Thomas Graf <tgraf@suug.ch>

Index: net-2.6/net/wireless/wext.c
===================================================================
--- net-2.6.orig/net/wireless/wext.c	2007-07-22 11:41:46.000000000 +0200
+++ net-2.6/net/wireless/wext.c	2007-07-22 12:00:17.000000000 +0200
@@ -1129,10 +1129,12 @@ static int rtnetlink_fill_iwinfo(struct 
 {
 	struct ifinfomsg *r;
 	struct nlmsghdr  *nlh;
-	unsigned char	 *b = skb_tail_pointer(skb);
 
-	nlh = NLMSG_PUT(skb, 0, 0, type, sizeof(*r));
-	r = NLMSG_DATA(nlh);
+	nlh = nlmsg_put(skb, 0, 0, type, sizeof(*r), 0);
+	if (nlh == NULL)
+		return -EMSGSIZE;
+
+	r = nlmsg_data(nlh);
 	r->ifi_family = AF_UNSPEC;
 	r->__ifi_pad = 0;
 	r->ifi_type = dev->type;
@@ -1141,15 +1143,13 @@ static int rtnetlink_fill_iwinfo(struct 
 	r->ifi_change = 0;	/* Wireless changes don't affect those flags */
 
 	/* Add the wireless events in the netlink packet */
-	RTA_PUT(skb, IFLA_WIRELESS, event_len, event);
+	NLA_PUT(skb, IFLA_WIRELESS, event_len, event);
 
-	nlh->nlmsg_len = skb_tail_pointer(skb) - b;
-	return skb->len;
+	return nlmsg_end(skb, nlh);
 
-nlmsg_failure:
-rtattr_failure:
-	nlmsg_trim(skb, b);
-	return -1;
+nla_put_failure:
+	nlmsg_cancel(skb, nlh);
+	return -EMSGSIZE;
 }
 
 /* ---------------------------------------------------------------- */
@@ -1162,17 +1162,19 @@ rtattr_failure:
 static void rtmsg_iwinfo(struct net_device *dev, char *event, int event_len)
 {
 	struct sk_buff *skb;
-	int size = NLMSG_GOODSIZE;
+	int err;
 
-	skb = alloc_skb(size, GFP_ATOMIC);
+	skb = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_ATOMIC);
 	if (!skb)
 		return;
 
-	if (rtnetlink_fill_iwinfo(skb, dev, RTM_NEWLINK,
-				  event, event_len) < 0) {
+	err = rtnetlink_fill_iwinfo(skb, dev, RTM_NEWLINK, event, event_len);
+	if (err < 0) {
+		WARN_ON(err == -EMSGSIZE);
 		kfree_skb(skb);
 		return;
 	}
+
 	NETLINK_CB(skb).dst_group = RTNLGRP_LINK;
 	skb_queue_tail(&wireless_nlevent_queue, skb);
 	tasklet_schedule(&wireless_nlevent_tasklet);
