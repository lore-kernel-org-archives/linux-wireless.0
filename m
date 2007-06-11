Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 91-65-240-14-dynip.superkabel.de ([91.65.240.14]:49704 "EHLO
	charon.n2.diac24.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753075AbXFKWNA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2007 18:13:00 -0400
Date: Tue, 12 Jun 2007 00:12:26 +0200
From: David Lamparter <lists@diac24.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH] cfg80211: use nl80211_* enums
Message-ID: <20070611221224.GA10598@charon.n2.diac24.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use enum nl80211_phymode and nl80211_iftype where appropriate. Update
mac80211 and nl80211 to match.

Signed-off-by: David Lamparter <equinox@diac24.net>

---
 include/net/cfg80211.h       |    9 +++++----
 net/mac80211/ieee80211_cfg.c |    2 +-
 net/wireless/nl80211.c       |    4 ++--
 3 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 813706a..1398c21 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3,6 +3,7 @@
 
 #include <linux/netlink.h>
 #include <linux/skbuff.h>
+#include <linux/nl80211.h>
 #include <net/genetlink.h>
 
 /*
@@ -18,7 +19,7 @@
  * @active: scan actively or passively on this channel
  */
 struct scan_channel {
-	int phymode;
+	enum nl80211_phymode phymode;
 	u32 channel;
 	int active;
 };
@@ -36,7 +37,7 @@ struct scan_channel {
 struct scan_params {
 	int n_channels;
 	int active;
-	int phymode;
+	enum nl80211_phymode phymode;
 	struct scan_channel *channels;
 };
 
@@ -116,10 +117,10 @@ struct wiphy;
  */
 struct cfg80211_ops {
 	int	(*add_virtual_intf)(struct wiphy *wiphy, char *name,
-				    unsigned int type);
+				    enum nl80211_iftype type);
 	int	(*del_virtual_intf)(struct wiphy *wiphy, int ifindex);
 	int	(*change_virtual_intf)(struct wiphy *wiphy, int ifindex,
-				       unsigned int type);
+				       enum nl80211_iftype type);
 
 	int	(*associate)(struct wiphy *wiphy, struct net_device *dev,
 			     struct association_params *params);
diff --git a/net/mac80211/ieee80211_cfg.c b/net/mac80211/ieee80211_cfg.c
index 0069826..8f85bc2 100644
--- a/net/mac80211/ieee80211_cfg.c
+++ b/net/mac80211/ieee80211_cfg.c
@@ -13,7 +13,7 @@
 #include "ieee80211_cfg.h"
 
 static int ieee80211_add_iface(struct wiphy *wiphy, char *name,
-			       unsigned int type)
+			       enum nl80211_iftype type)
 {
 	struct ieee80211_local *local = wiphy_priv(wiphy);
 	int itype;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d6a44a3..ffbe628 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -293,7 +293,7 @@ static int nl80211_add_virt_intf(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *drv;
 	int err;
-	unsigned int type = NL80211_IFTYPE_UNSPECIFIED;
+	enum nl80211_iftype type = NL80211_IFTYPE_UNSPECIFIED;
 
 	if (!info->attrs[NL80211_ATTR_IFNAME])
 		return -EINVAL;
@@ -353,7 +353,7 @@ static int nl80211_change_virt_intf(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *drv;
 	int err, ifindex;
-	unsigned int type;
+	enum nl80211_iftype type;
 	struct net_device *dev;
 
 	if (info->attrs[NL80211_ATTR_IFTYPE]) {
-- 
1.5.2.1

