Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49750 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964792AbXCZKrW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Mar 2007 06:47:22 -0400
Subject: [PATCH] allow wiphy renaming
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: "John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1172748592.11911.32.camel@johannes.berg>
References: <1172672119.5015.11.camel@johannes.berg>
	 <1172748592.11911.32.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 26 Mar 2007 12:47:13 +0200
Message-Id: <1174906033.1536.10.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch enables userspace to rename 802.11 PHYs via nl80211. It adds
the first multicast group and notifies it of these renames as well.

Also, it changes the default wiphy name to just "phy%d in anticipation
of Greg KH's sysfs change that will add the class name in front of the
directory name.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
This patch is actually required for my cfg80211/nl80211 rework patch and
I fixed the corner-case I talked about earlier now.

Apparently the sysfs change that would call the directory ieee80211:phy0
isn't in there yet though, but since we're not in mainline either we can
apply this patch safely for now. Also debugfs_rename is still missing,
I'll need to address that before we go to mainline.

Please apply this patch though, it adds useful functionality and doesn't
break anything even if debugfs_rename is missing (because it's not
permitted to rename the phy to phy%d where %d is something other than
its own index.

 include/linux/nl80211.h |   16 +++++++++++++++
 net/wireless/core.c     |   38 +++++++++++++++++++++++++++++++++++-
 net/wireless/core.h     |    3 ++
 net/wireless/nl80211.c  |   50 ++++++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.h  |    7 ++++++
 5 files changed, 113 insertions(+), 1 deletion(-)

--- wireless-dev.orig/include/linux/nl80211.h	2007-03-23 11:18:21.763431747 +0100
+++ wireless-dev/include/linux/nl80211.h	2007-03-26 12:43:38.954744301 +0200
@@ -118,6 +118,12 @@ enum {
 	 * ATTR_DEAUTHENTICATED */
 	NL80211_CMD_AUTHENTICATION_CHANGED,
 
+	/* rename a wiphy, takes a wiphy index and name */
+	NL80211_CMD_RENAME_WIPHY,
+
+	/* notification about rename */
+	NL80211_CMD_WIPHY_NEWNAME,
+
 	/* add commands here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -197,6 +203,8 @@ enum {
 
 	NL80211_ATTR_SCAN_TYPE,
 
+	NL80211_ATTR_WIPHY_NAME,
+
 	/* add attributes here */
 
 	/* used to define NL80211_ATTR_MAX below */
@@ -204,6 +212,14 @@ enum {
 };
 #define NL80211_ATTR_MAX (__NL80211_ATTR_AFTER_LAST - 1)
 
+/* multicast groups */
+enum {
+	/* be notified of configuration changes like wiphy renames */
+	NL80211_GROUP_CONFIG,
+
+	/* add groups here */
+};
+
 /**
  * NL80211_FLAG_TXSTATUS - send transmit status indication
  */
--- wireless-dev.orig/net/wireless/nl80211.c	2007-03-23 11:18:21.803431747 +0100
+++ wireless-dev/net/wireless/nl80211.c	2007-03-26 12:43:39.324744301 +0200
@@ -85,6 +85,8 @@ static struct nla_policy nl80211_policy[
 					       .len = NL80211_MAX_IE_LEN },
 	[NL80211_ATTR_ROAMING_CONTROL] = { .type = NLA_U32 },
 	[NL80211_ATTR_SCAN_TYPE] = { .type = NLA_U32 },
+	[NL80211_ATTR_WIPHY_NAME] = { .type = NLA_NUL_STRING,
+				      .len = BUS_ID_SIZE-1 },
 };
 
 /* netlink command implementations */
@@ -123,6 +125,7 @@ static int nl80211_get_cmdlist(struct sk
 	NLA_PUT_FLAG(msg, NL80211_CMD_GET_CMDLIST);
 	NLA_PUT_FLAG(msg, NL80211_CMD_GET_WIPHYS);
 	NLA_PUT_FLAG(msg, NL80211_CMD_GET_INTERFACES);
+	NLA_PUT_FLAG(msg, NL80211_CMD_RENAME_WIPHY);
 
 	CHECK_CMD(inject_packet, INJECT);
 	CHECK_CMD(add_virtual_intf, ADD_VIRTUAL_INTERFACE);
@@ -879,6 +882,24 @@ static int nl80211_initiate_scan(struct 
 	return err;
 }
 
+static int nl80211_rename_wiphy(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev;
+	int result;
+
+	if (!info->attrs[NL80211_ATTR_WIPHY_NAME])
+		return -EINVAL;
+
+	rdev = cfg80211_get_dev_from_info(info);
+	if (IS_ERR(rdev))
+		return PTR_ERR(rdev);
+
+	result = cfg80211_dev_rename(rdev, nla_data(info->attrs[NL80211_ATTR_WIPHY_NAME]));
+
+	cfg80211_put_dev(rdev);
+	return result;
+}
+
 static struct genl_ops nl80211_ops[] = {
 	{
 		.cmd = NL80211_CMD_GET_CMDLIST,
@@ -994,6 +1015,12 @@ static struct genl_ops nl80211_ops[] = {
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
 	},
+	{
+		.cmd = NL80211_CMD_RENAME_WIPHY,
+		.doit = nl80211_rename_wiphy,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+	},
 };
 
 
@@ -1024,6 +1051,29 @@ void *nl80211msg_new(struct sk_buff **sk
 }
 EXPORT_SYMBOL_GPL(nl80211msg_new);
 
+/* notification functions */
+
+void nl80211_notify_dev_rename(struct cfg80211_registered_device *rdev)
+{
+	struct sk_buff *msg;
+	void *hdr;
+
+	hdr = nl80211msg_new(&msg, 0, 0, 0, NL80211_CMD_WIPHY_NEWNAME);
+	if (IS_ERR(hdr))
+		return;
+
+	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY, rdev->idx);
+	NLA_PUT_STRING(msg, NL80211_ATTR_WIPHY_NAME, wiphy_name(&rdev->wiphy));
+
+	genlmsg_end(msg, hdr);
+	genlmsg_multicast(msg, 0, NL80211_GROUP_CONFIG, GFP_KERNEL);
+
+	return;
+
+ nla_put_failure:
+	nlmsg_free(msg);
+}
+
 /* initialisation/exit functions */
 
 int nl80211_init(void)
--- wireless-dev.orig/net/wireless/core.c	2007-03-23 11:18:21.873431747 +0100
+++ wireless-dev/net/wireless/core.c	2007-03-26 12:41:28.444744301 +0200
@@ -12,6 +12,7 @@
 #include <linux/nl80211.h>
 #include <linux/debugfs.h>
 #include <linux/notifier.h>
+#include <linux/device.h>
 #include <net/genetlink.h>
 #include <net/cfg80211.h>
 #include <net/wireless.h>
@@ -20,6 +21,9 @@
 #include "wext.h"
 #include "sysfs.h"
 
+/* name for sysfs, %d is appended */
+#define PHY_NAME "phy"
+
 MODULE_AUTHOR("Johannes Berg");
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("wireless configuration support");
@@ -137,6 +141,38 @@ void cfg80211_put_dev(struct cfg80211_re
 	mutex_unlock(&drv->mtx);
 }
 
+int cfg80211_dev_rename(struct cfg80211_registered_device *rdev,
+			char *newname)
+{
+	int idx, taken = -1, result, digits;
+
+	/* prohibit calling the thing phy%d when %d is not its number */
+	sscanf(newname, PHY_NAME "%d%n", &idx, &taken);
+	if (taken == strlen(newname) && idx != rdev->idx) {
+		/* count number of places needed to print idx */
+		digits = 1;
+		while (idx /= 10)
+			digits++;
+		/*
+		 * deny the name if it is phy<idx> where <idx> is printed
+		 * without leading zeroes. taken == strlen(newname) here
+		 */
+		if (taken == strlen(PHY_NAME) + digits)
+			return -EINVAL;
+	}
+
+	/* this will check for collisions */
+	result = device_rename(&rdev->wiphy.dev, newname);
+	if (!result)
+		return result;
+
+	/* TODO: do debugfs rename! */
+
+	nl80211_notify_dev_rename(rdev);
+
+	return 0;
+}
+
 /* exported functions */
 
 struct wiphy *wiphy_new(struct cfg80211_ops *ops, int sizeof_priv)
@@ -163,7 +199,7 @@ struct wiphy *wiphy_new(struct cfg80211_
 
 	/* give it a proper name */
 	snprintf(drv->wiphy.dev.bus_id, BUS_ID_SIZE,
-		 "wiphy%d", drv->idx);
+		 PHY_NAME "%d", drv->idx);
 
 	/* now increase counter for the next time */
 	wiphy_counter++;
--- wireless-dev.orig/net/wireless/core.h	2007-03-23 11:18:21.893431747 +0100
+++ wireless-dev/net/wireless/core.h	2007-03-23 11:19:34.043431747 +0100
@@ -74,4 +74,7 @@ extern void cfg80211_put_dev(struct cfg8
 /* free object */
 extern void cfg80211_dev_free(struct cfg80211_registered_device *drv);
 
+extern int cfg80211_dev_rename(struct cfg80211_registered_device *drv,
+			       char *newname);
+
 #endif /* __NET_WIRELESS_CORE_H */
--- wireless-dev.orig/net/wireless/nl80211.h	2007-03-23 11:18:21.973431747 +0100
+++ wireless-dev/net/wireless/nl80211.h	2007-03-23 11:19:34.053431747 +0100
@@ -1,9 +1,12 @@
 #ifndef __NET_WIRELESS_NL80211_H
 #define __NET_WIRELESS_NL80211_H
 
+#include "core.h"
+
 #ifdef CONFIG_NL80211
 extern int nl80211_init(void);
 extern void nl80211_exit(void);
+extern void nl80211_notify_dev_rename(struct cfg80211_registered_device *rdev);
 #else
 static inline int nl80211_init(void)
 {
@@ -12,6 +15,10 @@ static inline int nl80211_init(void)
 static inline void nl80211_exit(void)
 {
 }
+static inline void nl80211_notify_dev_rename(
+	struct cfg80211_registered_device *rdev)
+{
+}
 #endif /* CONFIG_NL80211 */
 
 #endif /* __NET_WIRELESS_NL80211_H */


