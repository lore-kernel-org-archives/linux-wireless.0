Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:50642 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752359Ab1IEMDB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Sep 2011 08:03:01 -0400
Received: by mail-yw0-f42.google.com with SMTP id 3so3080544ywb.15
        for <linux-wireless@vger.kernel.org>; Mon, 05 Sep 2011 05:02:59 -0700 (PDT)
From: Victor Goldenshtein <victorg@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: <johannes@sipsolutions.net>
Subject: [RFC v2 1/5] nl80211/cfg80211: adding 'scan_cancel' command.
Date: Mon,  5 Sep 2011 15:02:27 +0300
Message-Id: <1315224151-16552-2-git-send-email-VictorG@ti.com> (sfid-20110905_140304_035208_85511FF0)
In-Reply-To: <1315224151-16552-1-git-send-email-VictorG@ti.com>
References: <1315224151-16552-1-git-send-email-VictorG@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mostly from an energy consumption and cpu load perspective,
it can be useful to stop a triggered scan earlier, when one
finds the desired scan results.
Adding the ability to stop a scan from user space by exposing
new NL80211_CMD_SCAN_CANCEL API.

Signed-off-by: Victor Goldenshtein <victorg@ti.com>
---
 include/linux/nl80211.h |    7 +++++++
 include/net/cfg80211.h  |    2 ++
 net/wireless/core.h     |    1 +
 net/wireless/nl80211.c  |   13 +++++++++++++
 net/wireless/scan.c     |   16 ++++++++++++++++
 5 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 89dec16..2fee93a 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -499,6 +499,11 @@
  *	this command may also be sent by the driver as an MLME event to
  *	inform userspace of the new replay counter.
  *
+ * @NL80211_CMD_SCAN_CANCEL: Stop currently running scan (both sw and hw).
+ *	This operation will eventually invoke %NL80211_CMD_SCAN_ABORTED
+ *	event, partial scan results will be available. Returns -ENOENT
+ *	if scan is not running.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -623,6 +628,8 @@ enum nl80211_commands {
 
 	NL80211_CMD_SET_REKEY_OFFLOAD,
 
+	NL80211_CMD_SCAN_CANCEL,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index d86a15d..7b0c31e 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1298,6 +1298,7 @@ struct cfg80211_gtk_rekey_data {
  *	the driver, and will be valid until passed to cfg80211_scan_done().
  *	For scan results, call cfg80211_inform_bss(); you can call this outside
  *	the scan/scan_done bracket too.
+ * @scan_cancel: Stop currently running scan (both sw and hw).
  *
  * @auth: Request to authenticate with the specified peer
  * @assoc: Request to (re)associate with the specified peer
@@ -1465,6 +1466,7 @@ struct cfg80211_ops {
 
 	int	(*scan)(struct wiphy *wiphy, struct net_device *dev,
 			struct cfg80211_scan_request *request);
+	void    (*scan_cancel)(struct wiphy *wiphy, struct net_device *dev);
 
 	int	(*auth)(struct wiphy *wiphy, struct net_device *dev,
 			struct cfg80211_auth_request *req);
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 8672e02..af22fe3 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -421,6 +421,7 @@ void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev, bool leak);
 void __cfg80211_sched_scan_results(struct work_struct *wk);
 int __cfg80211_stop_sched_scan(struct cfg80211_registered_device *rdev,
 			       bool driver_initiated);
+int cfg80211_scan_cancel(struct cfg80211_registered_device *rdev);
 void cfg80211_upload_connect_keys(struct wireless_dev *wdev);
 int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
 			  struct net_device *dev, enum nl80211_iftype ntype,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 2aa6a21..f9f239f 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3766,6 +3766,11 @@ static int nl80211_stop_sched_scan(struct sk_buff *skb,
 	return err;
 }
 
+static int nl80211_scan_cancel(struct sk_buff *skb, struct genl_info *info)
+{
+	return cfg80211_scan_cancel(info->user_ptr[0]);
+}
+
 static int nl80211_send_bss(struct sk_buff *msg, struct netlink_callback *cb,
 			    u32 seq, int flags,
 			    struct cfg80211_registered_device *rdev,
@@ -5906,6 +5911,14 @@ static struct genl_ops nl80211_ops[] = {
 				  NL80211_FLAG_NEED_RTNL,
 	},
 	{
+		.cmd = NL80211_CMD_SCAN_CANCEL,
+		.doit = nl80211_scan_cancel,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
+				  NL80211_FLAG_NEED_RTNL,
+	},
+	{
 		.cmd = NL80211_CMD_GET_SCAN,
 		.policy = nl80211_policy,
 		.dumpit = nl80211_dump_scan,
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index b0f0039..bb4a991 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -156,6 +156,22 @@ int __cfg80211_stop_sched_scan(struct cfg80211_registered_device *rdev,
 	return 0;
 }
 
+int cfg80211_scan_cancel(struct cfg80211_registered_device *rdev)
+{
+	struct net_device *dev;
+
+	ASSERT_RDEV_LOCK(rdev);
+
+	if (!rdev->ops->scan_cancel)
+		return -EOPNOTSUPP;
+	if (!rdev->scan_req)
+		return -ENOENT;
+
+	dev = rdev->scan_req->dev;
+	rdev->ops->scan_cancel(&rdev->wiphy, dev);
+	return 0;
+}
+
 static void bss_release(struct kref *ref)
 {
 	struct cfg80211_internal_bss *bss;
-- 
1.7.0.4

