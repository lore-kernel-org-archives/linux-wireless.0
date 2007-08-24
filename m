Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:45022 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758392AbXHXMcE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Aug 2007 08:32:04 -0400
Message-Id: <20070824122908.327134000@sipsolutions.net>
References: <20070824122705.549190000@sipsolutions.net>
Date: Fri, 24 Aug 2007 14:27:14 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 09/15] mac80211: rename ieee80211_cfg.c to cfg.c
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's just painful to have the extra ieee80211_ prefix.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/mac80211/Makefile        |    2 -
 net/mac80211/cfg.c           |   72 +++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/ieee80211_cfg.c |   72 -------------------------------------------
 3 files changed, 73 insertions(+), 73 deletions(-)

--- wireless-dev.orig/net/mac80211/Makefile	2007-08-24 14:11:44.529417211 +0200
+++ wireless-dev/net/mac80211/Makefile	2007-08-24 14:16:15.649417211 +0200
@@ -17,7 +17,7 @@ mac80211-objs := \
 	regdomain.o \
 	tkip.o \
 	aes_ccm.o \
-	ieee80211_cfg.o \
+	cfg.o \
 	rx.o \
 	tx.o \
 	key.o \
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ wireless-dev/net/mac80211/cfg.c	2007-08-24 14:16:15.669417211 +0200
@@ -0,0 +1,72 @@
+/*
+ * mac80211 configuration hooks for cfg80211
+ *
+ * Copyright 2006	Johannes Berg <johannes@sipsolutions.net>
+ *
+ * This file is GPLv2 as found in COPYING.
+ */
+
+#include <linux/nl80211.h>
+#include <linux/rtnetlink.h>
+#include <net/cfg80211.h>
+#include "ieee80211_i.h"
+#include "ieee80211_cfg.h"
+
+static int ieee80211_add_iface(struct wiphy *wiphy, char *name,
+			       enum nl80211_iftype type)
+{
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+	int itype;
+
+	if (unlikely(local->reg_state != IEEE80211_DEV_REGISTERED))
+		return -ENODEV;
+
+	switch (type) {
+	case NL80211_IFTYPE_UNSPECIFIED:
+		itype = IEEE80211_IF_TYPE_STA;
+		break;
+	case NL80211_IFTYPE_ADHOC:
+		itype = IEEE80211_IF_TYPE_IBSS;
+		break;
+	case NL80211_IFTYPE_STATION:
+		itype = IEEE80211_IF_TYPE_STA;
+		break;
+	case NL80211_IFTYPE_AP:
+		itype = IEEE80211_IF_TYPE_AP;
+		break;
+	case NL80211_IFTYPE_WDS:
+		itype = IEEE80211_IF_TYPE_WDS;
+		break;
+	case NL80211_IFTYPE_MONITOR:
+		itype = IEEE80211_IF_TYPE_MNTR;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return ieee80211_if_add(local->mdev, name, NULL, itype);
+}
+
+static int ieee80211_del_iface(struct wiphy *wiphy, int ifindex)
+{
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+	struct net_device *dev;
+	char *name;
+
+	if (unlikely(local->reg_state != IEEE80211_DEV_REGISTERED))
+		return -ENODEV;
+
+	dev = dev_get_by_index(ifindex);
+	if (!dev)
+		return 0;
+
+	name = dev->name;
+	dev_put(dev);
+
+	return ieee80211_if_remove(local->mdev, name, -1);
+}
+
+struct cfg80211_ops mac80211_config_ops = {
+	.add_virtual_intf = ieee80211_add_iface,
+	.del_virtual_intf = ieee80211_del_iface,
+};
--- wireless-dev.orig/net/mac80211/ieee80211_cfg.c	2007-08-24 14:11:48.499417211 +0200
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,72 +0,0 @@
-/*
- * mac80211 configuration hooks for cfg80211
- *
- * Copyright 2006	Johannes Berg <johannes@sipsolutions.net>
- *
- * This file is GPLv2 as found in COPYING.
- */
-
-#include <linux/nl80211.h>
-#include <linux/rtnetlink.h>
-#include <net/cfg80211.h>
-#include "ieee80211_i.h"
-#include "ieee80211_cfg.h"
-
-static int ieee80211_add_iface(struct wiphy *wiphy, char *name,
-			       enum nl80211_iftype type)
-{
-	struct ieee80211_local *local = wiphy_priv(wiphy);
-	int itype;
-
-	if (unlikely(local->reg_state != IEEE80211_DEV_REGISTERED))
-		return -ENODEV;
-
-	switch (type) {
-	case NL80211_IFTYPE_UNSPECIFIED:
-		itype = IEEE80211_IF_TYPE_STA;
-		break;
-	case NL80211_IFTYPE_ADHOC:
-		itype = IEEE80211_IF_TYPE_IBSS;
-		break;
-	case NL80211_IFTYPE_STATION:
-		itype = IEEE80211_IF_TYPE_STA;
-		break;
-	case NL80211_IFTYPE_AP:
-		itype = IEEE80211_IF_TYPE_AP;
-		break;
-	case NL80211_IFTYPE_WDS:
-		itype = IEEE80211_IF_TYPE_WDS;
-		break;
-	case NL80211_IFTYPE_MONITOR:
-		itype = IEEE80211_IF_TYPE_MNTR;
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	return ieee80211_if_add(local->mdev, name, NULL, itype);
-}
-
-static int ieee80211_del_iface(struct wiphy *wiphy, int ifindex)
-{
-	struct ieee80211_local *local = wiphy_priv(wiphy);
-	struct net_device *dev;
-	char *name;
-
-	if (unlikely(local->reg_state != IEEE80211_DEV_REGISTERED))
-		return -ENODEV;
-
-	dev = dev_get_by_index(ifindex);
-	if (!dev)
-		return 0;
-
-	name = dev->name;
-	dev_put(dev);
-
-	return ieee80211_if_remove(local->mdev, name, -1);
-}
-
-struct cfg80211_ops mac80211_config_ops = {
-	.add_virtual_intf = ieee80211_add_iface,
-	.del_virtual_intf = ieee80211_del_iface,
-};

-- 

