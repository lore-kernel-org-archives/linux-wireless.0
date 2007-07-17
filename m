Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:53963 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbXGQNTN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jul 2007 09:19:13 -0400
Subject: [PATCH] nl80211: use the generic netlink multicast framework
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 17 Jul 2007 15:18:05 +0200
Message-Id: <1184678285.3773.92.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Generic netlink just got a framework to register multicast
groups. Use it.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
I totally misunderstood how it should be with multicast groups
in generic netlink, but it wasn't really done well in any case.

Please apply this patch as soon as you get the generic netlink multicast
I just sent to davem. If you want I can also ping you once they make it
in.

 include/linux/nl80211.h |   16 ----------------
 net/wireless/nl80211.c  |   12 +++++++++++-
 2 files changed, 11 insertions(+), 17 deletions(-)

--- wireless-dev.orig/include/linux/nl80211.h	2007-07-17 14:05:13.520964463 +0200
+++ wireless-dev/include/linux/nl80211.h	2007-07-17 14:05:32.350964463 +0200
@@ -189,22 +189,6 @@ enum nl80211_attrs {
 };
 #define NL80211_ATTR_MAX (__NL80211_ATTR_AFTER_LAST - 1)
 
-/**
- * enum nl80211_multicast_groups - multicast groups for nl80211
- * @NL80211_GROUP_CONFIG: members of this group are notified of
- *	configuration changes
- */
-enum nl80211_multicast_groups {
-	/* be notified of configuration changes like wiphy renames */
-	NL80211_GROUP_CONFIG,
-
-	/* add groups here */
-
-	/* keep last */
-	__NL80211_GROUP_AFTER_LAST
-};
-#define NL80211_GROUP_MAX (__NL80211_GROUP_AFTER_LAST - 1)
-
 /*
  * maximum length of IE(s) passed in an NL80211_ATTR_IE.
  * this is an arbitrary limit, 774 means three full-length
--- wireless-dev.orig/net/wireless/nl80211.c	2007-07-17 14:05:13.550964463 +0200
+++ wireless-dev/net/wireless/nl80211.c	2007-07-17 14:05:32.350964463 +0200
@@ -944,6 +944,11 @@ void *nl80211msg_new(struct sk_buff **sk
 }
 EXPORT_SYMBOL_GPL(nl80211msg_new);
 
+/* multicast groups */
+static struct genl_multicast_group nl80211_config_mcgrp = {
+	.name = "config",
+};
+
 /* notification functions */
 
 void nl80211_notify_dev_rename(struct cfg80211_registered_device *rdev)
@@ -959,7 +964,7 @@ void nl80211_notify_dev_rename(struct cf
 	NLA_PUT_STRING(msg, NL80211_ATTR_WIPHY_NAME, wiphy_name(&rdev->wiphy));
 
 	genlmsg_end(msg, hdr);
-	genlmsg_multicast(msg, 0, NL80211_GROUP_CONFIG, GFP_KERNEL);
+	genlmsg_multicast(msg, 0, nl80211_config_mcgrp.id, GFP_KERNEL);
 
 	return;
 
@@ -982,6 +987,11 @@ int nl80211_init(void)
 		if (err)
 			goto err_out;
 	}
+
+	err = genl_register_mc_group(&nl80211_fam, &nl80211_config_mcgrp);
+	if (err)
+		goto err_out;
+
 	return 0;
  err_out:
 	genl_unregister_family(&nl80211_fam);


