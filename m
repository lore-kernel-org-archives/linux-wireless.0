Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:51827 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756519Ab3D1XWM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Apr 2013 19:22:12 -0400
Received: from aeonflux.amr.corp.intel.com (S010620c9d099deff.vc.shawcable.net [24.84.124.211])
	by mail.holtmann.org (Postfix) with ESMTPSA id BA4828B33C
	for <linux-wireless@vger.kernel.org>; Mon, 29 Apr 2013 01:22:09 +0200 (CEST)
From: Marcel Holtmann <marcel@holtmann.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] nl80211: Add generic netlink module alias for cfg80211/nl80211
Date: Sun, 28 Apr 2013 16:22:06 -0700
Message-Id: <1367191326-30078-1-git-send-email-marcel@holtmann.org> (sfid-20130429_012225_262878_EE362FD8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To support auto-loading of wireless modules from netlink users, add module
alias for nl80211 family.

This also adds NL80211_GENL_NAME constant to define the "nl80211" netlink
family name as part of uapi.

Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
---
 include/uapi/linux/nl80211.h | 2 ++
 net/wireless/core.c          | 1 +
 net/wireless/nl80211.c       | 8 ++++----
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index d1e48b5..b573a55 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -27,6 +27,8 @@
 
 #include <linux/types.h>
 
+#define NL80211_GENL_NAME "nl80211"
+
 /**
  * DOC: Station handling
  *
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 84c9ad7..68f0c96 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -34,6 +34,7 @@
 MODULE_AUTHOR("Johannes Berg");
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("wireless configuration support");
+MODULE_ALIAS_GENL_FAMILY(NL80211_GENL_NAME);
 
 /* RCU-protected (and cfg80211_mutex for writers) */
 LIST_HEAD(cfg80211_rdev_list);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index afa2838..3c2da0a 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -37,10 +37,10 @@ static void nl80211_post_doit(struct genl_ops *ops, struct sk_buff *skb,
 
 /* the netlink family */
 static struct genl_family nl80211_fam = {
-	.id = GENL_ID_GENERATE,	/* don't bother with a hardcoded ID */
-	.name = "nl80211",	/* have users key off the name instead */
-	.hdrsize = 0,		/* no private header */
-	.version = 1,		/* no particular meaning now */
+	.id = GENL_ID_GENERATE,		/* don't bother with a hardcoded ID */
+	.name = NL80211_GENL_NAME,	/* have users key off the name instead */
+	.hdrsize = 0,			/* no private header */
+	.version = 1,			/* no particular meaning now */
 	.maxattr = NL80211_ATTR_MAX,
 	.netnsok = true,
 	.pre_doit = nl80211_pre_doit,
-- 
1.8.1.4

