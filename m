Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:47006 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752694Ab1GXNKx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Jul 2011 09:10:53 -0400
Received: by mail-gw0-f51.google.com with SMTP id 17so2269216gwj.38
        for <linux-wireless@vger.kernel.org>; Sun, 24 Jul 2011 06:10:52 -0700 (PDT)
From: Victor Goldenshtein <victorg@ti.com>
To: <linux-wireless@vger.kernel.org>
Subject: [RFC 1/2] nl80211/cfg80211: adding 'scan_cancel' command.
Date: Sun, 24 Jul 2011 16:10:37 +0300
Message-Id: <1311513038-5669-1-git-send-email-VictorG@ti.com> (sfid-20110724_151057_640848_FA9FADC0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mostly from an energy consumption and cpu load perspective,
it can be useful to stop a triggered scan earlier, when one
finds the desired scan results.
Adding the ability to stop a scan from user space by exposing
new NL80211_CMD_SCAN_CANCEL API.

Signed-off-by: Victor Goldenshtein <victorg@ti.com>
---
 include/linux/nl80211.h |    6 ++++++
 include/net/cfg80211.h  |    2 ++
 net/wireless/core.h     |    1 +
 net/wireless/nl80211.c  |   13 +++++++++++++
 net/wireless/scan.c     |   15 +++++++++++++++
 5 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 3ec2f94..3468789 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -491,6 +491,11 @@
  *	this command may also be sent by the driver as an MLME event to
  *	inform userspace of the new replay counter.
  *
+ * @NL80211_CMD_SCAN_CANCEL: Stop currently running scan (both sw and hw).
+ *      This will eventually call ieee80211_scan_cancel() in mac80211 which
+ *      will clean up scan_req resources. If we try to stop a not running
+ *      scan it will return -ENOENT.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -615,6 +620,7 @@ enum nl80211_commands {
 
 	NL80211_CMD_SET_REKEY_OFFLOAD,
 
+	NL80211_CMD_SCAN_CANCEL,
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 4bf101b..0d619b9 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1334,6 +1334,7 @@ struct cfg80211_gtk_rekey_data {
  * @set_ringparam: Set tx and rx ring sizes.
  *
  * @get_ringparam: Get tx and rx ring current and maximum sizes.
+ * @scan_cancel: Stop triggered scan, return 0 if successful.
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -1516,6 +1517,7 @@ struct cfg80211_ops {
 
 	int	(*set_rekey_data)(struct wiphy *wiphy, struct net_device *dev,
 				  struct cfg80211_gtk_rekey_data *data);
+	void    (*scan_cancel)(struct wiphy *wiphy, struct net_device *dev);
 };
 
 /*
diff --git a/net/wireless/core.h b/net/wireless/core.h
index a570ff9..bd3a780 100644
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
index 6a82c89..023e749 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3641,6 +3641,11 @@ static int nl80211_stop_sched_scan(struct sk_buff *skb,
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
@@ -5759,6 +5764,14 @@ static struct genl_ops nl80211_ops[] = {
 				  NL80211_FLAG_NEED_RTNL,
 	},
 	{
+		.cmd = NL80211_CMD_SCAN_CANCEL,
+		.doit = nl80211_scan_cancel,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
+				NL80211_FLAG_NEED_RTNL,
+	},
+	{
 		.cmd = NL80211_CMD_GET_SCAN,
 		.policy = nl80211_policy,
 		.dumpit = nl80211_dump_scan,
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 2cc9d4a..69259b1 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -155,6 +155,21 @@ int __cfg80211_stop_sched_scan(struct cfg80211_registered_device *rdev,
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
 static void bss_release(struct kref *ref)
 {
 	struct cfg80211_internal_bss *bss;
-- 
1.7.0.4

