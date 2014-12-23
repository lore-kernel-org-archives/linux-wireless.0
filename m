Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39452 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932302AbaLWQSi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2014 11:18:38 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] nl80211: define multicast group names in header
Date: Tue, 23 Dec 2014 17:18:31 +0100
Message-Id: <1419351511-985-1-git-send-email-johannes@sipsolutions.net> (sfid-20141223_171841_458491_32F75C2B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Put the group names into the userspace API header file so that
userspace clients can use symbolic names from there instead of
hardcoding the actual names. This doesn't really change much,
but seems somewhat cleaner.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/uapi/linux/nl80211.h |  7 +++++++
 net/wireless/nl80211.c       | 12 ++++++------
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 6cd33c02113a..f8970beafbce 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -29,6 +29,13 @@
 
 #define NL80211_GENL_NAME "nl80211"
 
+#define NL80211_MULTICAST_GROUP_CONFIG		"config"
+#define NL80211_MULTICAST_GROUP_SCAN		"scan"
+#define NL80211_MULTICAST_GROUP_REG		"regulatory"
+#define NL80211_MULTICAST_GROUP_MLME		"mlme"
+#define NL80211_MULTICAST_GROUP_VENDOR		"vendor"
+#define NL80211_MULTICAST_GROUP_TESTMODE	"testmode"
+
 /**
  * DOC: Station handling
  *
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index f565d8073758..18bccd16486c 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -59,13 +59,13 @@ enum nl80211_multicast_groups {
 };
 
 static const struct genl_multicast_group nl80211_mcgrps[] = {
-	[NL80211_MCGRP_CONFIG] = { .name = "config", },
-	[NL80211_MCGRP_SCAN] = { .name = "scan", },
-	[NL80211_MCGRP_REGULATORY] = { .name = "regulatory", },
-	[NL80211_MCGRP_MLME] = { .name = "mlme", },
-	[NL80211_MCGRP_VENDOR] = { .name = "vendor", },
+	[NL80211_MCGRP_CONFIG] = { .name = NL80211_MULTICAST_GROUP_CONFIG },
+	[NL80211_MCGRP_SCAN] = { .name = NL80211_MULTICAST_GROUP_SCAN },
+	[NL80211_MCGRP_REGULATORY] = { .name = NL80211_MULTICAST_GROUP_REG },
+	[NL80211_MCGRP_MLME] = { .name = NL80211_MULTICAST_GROUP_MLME },
+	[NL80211_MCGRP_VENDOR] = { .name = NL80211_MULTICAST_GROUP_VENDOR },
 #ifdef CONFIG_NL80211_TESTMODE
-	[NL80211_MCGRP_TESTMODE] = { .name = "testmode", }
+	[NL80211_MCGRP_TESTMODE] = { .name = NL80211_MULTICAST_GROUP_TESTMODE }
 #endif
 };
 
-- 
2.1.1

