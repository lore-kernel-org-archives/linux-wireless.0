Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:45411 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754383Ab2F2KrX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jun 2012 06:47:23 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 01/13] cfg80211: introduce cfg80211_stop_ap
Date: Fri, 29 Jun 2012 12:46:56 +0200
Message-ID: <1340966828-22874-2-git-send-email-michal.kazior@tieto.com> (sfid-20120629_124749_287936_04A0B835)
In-Reply-To: <1340966828-22874-1-git-send-email-michal.kazior@tieto.com>
References: <1340966828-22874-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This functionality will be reused when interface
is going down. Avoids code duplication. Also adds
missing wdev locking.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/wireless/Makefile  |    2 +-
 net/wireless/ap.c      |   44 ++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/core.h    |    4 ++++
 net/wireless/nl80211.c |   17 +----------------
 4 files changed, 50 insertions(+), 17 deletions(-)
 create mode 100644 net/wireless/ap.c

diff --git a/net/wireless/Makefile b/net/wireless/Makefile
index 55a28ab..0f7e0d6 100644
--- a/net/wireless/Makefile
+++ b/net/wireless/Makefile
@@ -10,7 +10,7 @@ obj-$(CONFIG_WEXT_SPY) += wext-spy.o
 obj-$(CONFIG_WEXT_PRIV) += wext-priv.o
 
 cfg80211-y += core.o sysfs.o radiotap.o util.o reg.o scan.o nl80211.o
-cfg80211-y += mlme.o ibss.o sme.o chan.o ethtool.o mesh.o
+cfg80211-y += mlme.o ibss.o sme.o chan.o ethtool.o mesh.o ap.o
 cfg80211-$(CONFIG_CFG80211_DEBUGFS) += debugfs.o
 cfg80211-$(CONFIG_CFG80211_WEXT) += wext-compat.o wext-sme.o
 cfg80211-$(CONFIG_CFG80211_INTERNAL_REGDB) += regdb.o
diff --git a/net/wireless/ap.c b/net/wireless/ap.c
new file mode 100644
index 0000000..45199cc
--- /dev/null
+++ b/net/wireless/ap.c
@@ -0,0 +1,44 @@
+#include <linux/ieee80211.h>
+#include <linux/export.h>
+#include <net/cfg80211.h>
+#include "nl80211.h"
+#include "core.h"
+
+
+static int __cfg80211_stop_ap(struct cfg80211_registered_device *rdev,
+			      struct net_device *dev)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	int err;
+
+	ASSERT_WDEV_LOCK(wdev);
+
+	if (!rdev->ops->stop_ap)
+		return -EOPNOTSUPP;
+
+	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
+	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO)
+		return -EOPNOTSUPP;
+
+	if (!wdev->beacon_interval)
+		return -ENOENT;
+
+	err = rdev->ops->stop_ap(&rdev->wiphy, dev);
+	if (!err)
+		wdev->beacon_interval = 0;
+
+	return err;
+}
+
+int cfg80211_stop_ap(struct cfg80211_registered_device *rdev,
+		     struct net_device *dev)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	int err;
+
+	wdev_lock(wdev);
+	err = __cfg80211_stop_ap(rdev, dev);
+	wdev_unlock(wdev);
+
+	return err;
+}
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 609a579..fef476d 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -289,6 +289,10 @@ int cfg80211_set_mesh_freq(struct cfg80211_registered_device *rdev,
 			   struct wireless_dev *wdev, int freq,
 			   enum nl80211_channel_type channel_type);
 
+/* AP */
+int cfg80211_stop_ap(struct cfg80211_registered_device *rdev,
+		     struct net_device *dev);
+
 /* MLME */
 int __cfg80211_mlme_auth(struct cfg80211_registered_device *rdev,
 			 struct net_device *dev,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 5c4a720..20d0fd6 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2521,23 +2521,8 @@ static int nl80211_stop_ap(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
 	struct net_device *dev = info->user_ptr[1];
-	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	int err;
-
-	if (!rdev->ops->stop_ap)
-		return -EOPNOTSUPP;
 
-	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
-	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO)
-		return -EOPNOTSUPP;
-
-	if (!wdev->beacon_interval)
-		return -ENOENT;
-
-	err = rdev->ops->stop_ap(&rdev->wiphy, dev);
-	if (!err)
-		wdev->beacon_interval = 0;
-	return err;
+	return cfg80211_stop_ap(rdev, dev);
 }
 
 static const struct nla_policy sta_flags_policy[NL80211_STA_FLAG_MAX + 1] = {
-- 
1.7.0.4

