Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42915 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635AbZFPR5M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2009 13:57:12 -0400
Subject: [PATCH] cfg80211: issue netlink notification when scan starts
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 16 Jun 2009 19:56:42 +0200
Message-Id: <1245175002.21287.3.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To ease multiple apps working together smoothly,
send a notification when a scan is started.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/nl80211.c |   39 ++++++++++++++++++++++++++++++---------
 net/wireless/nl80211.h |    2 ++
 net/wireless/scan.c    |    3 ++-
 3 files changed, 34 insertions(+), 10 deletions(-)

--- wireless-testing.orig/net/wireless/nl80211.c	2009-06-16 18:49:13.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.c	2009-06-16 18:51:27.000000000 +0200
@@ -2773,6 +2773,9 @@ static int nl80211_trigger_scan(struct s
 	drv->scan_req = request;
 	err = drv->ops->scan(&drv->wiphy, dev, request);
 
+	if (!err)
+		nl80211_send_scan_start(drv, dev);
+
  out_free:
 	if (err) {
 		drv->scan_req = NULL;
@@ -3599,11 +3602,11 @@ static int nl80211_add_scan_req(struct s
 	return -ENOBUFS;
 }
 
-static int nl80211_send_scan_donemsg(struct sk_buff *msg,
-				     struct cfg80211_registered_device *rdev,
-				     struct net_device *netdev,
-				     u32 pid, u32 seq, int flags,
-				     u32 cmd)
+static int nl80211_send_scan_msg(struct sk_buff *msg,
+				 struct cfg80211_registered_device *rdev,
+				 struct net_device *netdev,
+				 u32 pid, u32 seq, int flags,
+				 u32 cmd)
 {
 	void *hdr;
 
@@ -3624,6 +3627,24 @@ static int nl80211_send_scan_donemsg(str
 	return -EMSGSIZE;
 }
 
+void nl80211_send_scan_start(struct cfg80211_registered_device *rdev,
+			     struct net_device *netdev)
+{
+	struct sk_buff *msg;
+
+	msg = nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
+	if (!msg)
+		return;
+
+	if (nl80211_send_scan_msg(msg, rdev, netdev, 0, 0, 0,
+				  NL80211_CMD_TRIGGER_SCAN) < 0) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	genlmsg_multicast(msg, 0, nl80211_scan_mcgrp.id, GFP_KERNEL);
+}
+
 void nl80211_send_scan_done(struct cfg80211_registered_device *rdev,
 			    struct net_device *netdev)
 {
@@ -3633,8 +3654,8 @@ void nl80211_send_scan_done(struct cfg80
 	if (!msg)
 		return;
 
-	if (nl80211_send_scan_donemsg(msg, rdev, netdev, 0, 0, 0,
-				      NL80211_CMD_NEW_SCAN_RESULTS) < 0) {
+	if (nl80211_send_scan_msg(msg, rdev, netdev, 0, 0, 0,
+				  NL80211_CMD_NEW_SCAN_RESULTS) < 0) {
 		nlmsg_free(msg);
 		return;
 	}
@@ -3651,8 +3672,8 @@ void nl80211_send_scan_aborted(struct cf
 	if (!msg)
 		return;
 
-	if (nl80211_send_scan_donemsg(msg, rdev, netdev, 0, 0, 0,
-				      NL80211_CMD_SCAN_ABORTED) < 0) {
+	if (nl80211_send_scan_msg(msg, rdev, netdev, 0, 0, 0,
+				  NL80211_CMD_SCAN_ABORTED) < 0) {
 		nlmsg_free(msg);
 		return;
 	}
--- wireless-testing.orig/net/wireless/nl80211.h	2009-06-16 18:50:32.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.h	2009-06-16 18:50:53.000000000 +0200
@@ -6,6 +6,8 @@
 extern int nl80211_init(void);
 extern void nl80211_exit(void);
 extern void nl80211_notify_dev_rename(struct cfg80211_registered_device *rdev);
+extern void nl80211_send_scan_start(struct cfg80211_registered_device *rdev,
+				    struct net_device *netdev);
 extern void nl80211_send_scan_done(struct cfg80211_registered_device *rdev,
 				   struct net_device *netdev);
 extern void nl80211_send_scan_aborted(struct cfg80211_registered_device *rdev,
--- wireless-testing.orig/net/wireless/scan.c	2009-06-16 18:52:00.000000000 +0200
+++ wireless-testing/net/wireless/scan.c	2009-06-16 18:52:13.000000000 +0200
@@ -648,7 +648,8 @@ int cfg80211_wext_siwscan(struct net_dev
 	if (err) {
 		rdev->scan_req = NULL;
 		kfree(creq);
-	}
+	} else
+		nl80211_send_scan_start(rdev, dev);
  out:
 	cfg80211_put_dev(rdev);
 	return err;


