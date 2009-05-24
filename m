Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59072 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754770AbZEXRZL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 May 2009 13:25:11 -0400
Subject: [PATCH] nl80211: bounce scan request back to userspace
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 24 May 2009 16:43:15 +0200
Message-Id: <1243176195.29222.2.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When a scan finishes only the program that asked for it
knows what kind of scan it was; let's tell everybody else
about the scan parameters as well so they can evaluate
the result of the scan better. Also helps with debugging.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/nl80211.c |   43 ++++++++++++++++++++++++++++++++++++++-----
 net/wireless/scan.c    |    3 ++-
 2 files changed, 40 insertions(+), 6 deletions(-)

--- wireless-testing.orig/net/wireless/nl80211.c	2009-05-24 16:40:42.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.c	2009-05-24 16:40:45.000000000 +0200
@@ -3563,11 +3563,43 @@ void nl80211_notify_dev_rename(struct cf
 	genlmsg_multicast(msg, 0, nl80211_config_mcgrp.id, GFP_KERNEL);
 }
 
+static int nl80211_add_scan_req(struct sk_buff *msg,
+				struct cfg80211_registered_device *rdev)
+{
+	struct cfg80211_scan_request *req = rdev->scan_req;
+	struct nlattr *nest;
+	int i;
+
+	if (WARN_ON(!req))
+		return 0;
+
+	nest = nla_nest_start(msg, NL80211_ATTR_SCAN_SSIDS);
+	if (!nest)
+		goto nla_put_failure;
+	for (i = 0; i < req->n_ssids; i++)
+		NLA_PUT(msg, i, req->ssids[i].ssid_len, req->ssids[i].ssid);
+	nla_nest_end(msg, nest);
+
+	nest = nla_nest_start(msg, NL80211_ATTR_SCAN_FREQUENCIES);
+	if (!nest)
+		goto nla_put_failure;
+	for (i = 0; i < req->n_channels; i++)
+		NLA_PUT_U32(msg, i, req->channels[i]->center_freq);
+	nla_nest_end(msg, nest);
+
+	if (req->ie)
+		NLA_PUT(msg, NL80211_ATTR_IE, req->ie_len, req->ie);
+
+	return 0;
+ nla_put_failure:
+	return -ENOBUFS;
+}
+
 static int nl80211_send_scan_donemsg(struct sk_buff *msg,
-				    struct cfg80211_registered_device *rdev,
-				    struct net_device *netdev,
-				    u32 pid, u32 seq, int flags,
-				    u32 cmd)
+				     struct cfg80211_registered_device *rdev,
+				     struct net_device *netdev,
+				     u32 pid, u32 seq, int flags,
+				     u32 cmd)
 {
 	void *hdr;
 
@@ -3578,7 +3610,8 @@ static int nl80211_send_scan_donemsg(str
 	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx);
 	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, netdev->ifindex);
 
-	/* XXX: we should probably bounce back the request? */
+	/* ignore errors and send incomplete event anyway */
+	nl80211_add_scan_req(msg, rdev);
 
 	return genlmsg_end(msg, hdr);
 
--- wireless-testing.orig/net/wireless/scan.c	2009-05-24 16:40:28.000000000 +0200
+++ wireless-testing/net/wireless/scan.c	2009-05-24 16:40:45.000000000 +0200
@@ -29,13 +29,14 @@ void cfg80211_scan_done(struct cfg80211_
 		goto out;
 
 	WARN_ON(request != wiphy_to_dev(request->wiphy)->scan_req);
-	wiphy_to_dev(request->wiphy)->scan_req = NULL;
 
 	if (aborted)
 		nl80211_send_scan_aborted(wiphy_to_dev(request->wiphy), dev);
 	else
 		nl80211_send_scan_done(wiphy_to_dev(request->wiphy), dev);
 
+	wiphy_to_dev(request->wiphy)->scan_req = NULL;
+
 #ifdef CONFIG_WIRELESS_EXT
 	if (!aborted) {
 		memset(&wrqu, 0, sizeof(wrqu));


