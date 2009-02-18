Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:55332 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028AbZBRXZr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Feb 2009 18:25:47 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: johannes@sipsolutions.net
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH v4 07/15] cfg80211: add assert_cfg80211_lock() to ensure proper protection
Date: Wed, 18 Feb 2009 18:25:37 -0500
Message-Id: <1234999545-14357-8-git-send-email-lrodriguez@atheros.com> (sfid-20090219_002601_036661_5F084023)
In-Reply-To: <1234999545-14357-1-git-send-email-lrodriguez@atheros.com>
References: <1234999545-14357-1-git-send-email-lrodriguez@atheros.com>
To: johannes@sipsolutions.net, linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/core.c    |    5 ++++-
 net/wireless/core.h    |    6 ++++++
 net/wireless/nl80211.c |    3 ++-
 net/wireless/reg.c     |   15 +++++++++++++++
 4 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 39d40d1..e347093 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -7,7 +7,6 @@
 #include <linux/if.h>
 #include <linux/module.h>
 #include <linux/err.h>
-#include <linux/mutex.h>
 #include <linux/list.h>
 #include <linux/nl80211.h>
 #include <linux/debugfs.h>
@@ -50,6 +49,8 @@ cfg80211_drv_by_wiphy_idx(int wiphy_idx)
 	if (!wiphy_idx_valid(wiphy_idx))
 		return NULL;
 
+	assert_cfg80211_lock();
+
 	list_for_each_entry(drv, &cfg80211_drv_list, list) {
 		if (drv->wiphy_idx == wiphy_idx) {
 			result = drv;
@@ -69,6 +70,8 @@ __cfg80211_drv_from_info(struct genl_info *info)
 	struct net_device *dev;
 	int err = -EINVAL;
 
+	assert_cfg80211_lock();
+
 	if (info->attrs[NL80211_ATTR_WIPHY]) {
 		bywiphyidx = cfg80211_drv_by_wiphy_idx(
 				nla_get_u32(info->attrs[NL80211_ATTR_WIPHY]));
diff --git a/net/wireless/core.h b/net/wireless/core.h
index f3ab00c..982cc6b 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -10,6 +10,7 @@
 #include <linux/netdevice.h>
 #include <linux/kref.h>
 #include <linux/rbtree.h>
+#include <linux/mutex.h>
 #include <net/genetlink.h>
 #include <net/wireless.h>
 #include <net/cfg80211.h>
@@ -73,6 +74,11 @@ bool wiphy_idx_valid(int wiphy_idx)
 extern struct mutex cfg80211_mutex;
 extern struct list_head cfg80211_drv_list;
 
+static inline void assert_cfg80211_lock(void)
+{
+	BUG_ON(!mutex_is_locked(&cfg80211_mutex));
+}
+
 struct cfg80211_internal_bss {
 	struct list_head list;
 	struct rb_node rbn;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 5d3e968..768a65c 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -7,7 +7,6 @@
 #include <linux/if.h>
 #include <linux/module.h>
 #include <linux/err.h>
-#include <linux/mutex.h>
 #include <linux/list.h>
 #include <linux/if_ether.h>
 #include <linux/ieee80211.h>
@@ -159,6 +158,8 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 	int i;
 	u16 ifmodes = dev->wiphy.interface_modes;
 
+	assert_cfg80211_lock();
+
 	hdr = nl80211hdr_put(msg, pid, seq, flags, NL80211_CMD_NEW_WIPHY);
 	if (!hdr)
 		return -1;
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 47d5056..e49ac9b 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -276,6 +276,8 @@ static bool alpha2_equal(const char *alpha2_x, const char *alpha2_y)
 
 static bool regdom_changed(const char *alpha2)
 {
+	assert_cfg80211_lock();
+
 	if (!cfg80211_regdomain)
 		return true;
 	if (alpha2_equal(cfg80211_regdomain->alpha2, alpha2))
@@ -830,6 +832,8 @@ static void handle_channel(struct wiphy *wiphy, enum ieee80211_band band,
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_channel *chan;
 
+	assert_cfg80211_lock();
+
 	sband = wiphy->bands[band];
 	BUG_ON(chan_idx >= sband->n_channels);
 	chan = &sband->channels[chan_idx];
@@ -1042,6 +1046,9 @@ static int reg_copy_regd(const struct ieee80211_regdomain **dst_regd,
 static int ignore_request(struct wiphy *wiphy, enum reg_set_by set_by,
 			  const char *alpha2)
 {
+
+	assert_cfg80211_lock();
+
 	/* All initial requests are respected */
 	if (!last_request)
 		return 0;
@@ -1122,6 +1129,8 @@ int __regulatory_hint(struct wiphy *wiphy, enum reg_set_by set_by,
 	bool intersect = false;
 	int r = 0;
 
+	assert_cfg80211_lock();
+
 	r = ignore_request(wiphy, set_by, alpha2);
 
 	if (r == REG_INTERSECT) {
@@ -1217,6 +1226,8 @@ EXPORT_SYMBOL(regulatory_hint);
 static bool reg_same_country_ie_hint(struct wiphy *wiphy,
 			u32 country_ie_checksum)
 {
+	assert_cfg80211_lock();
+
 	if (!last_request->wiphy)
 		return false;
 	if (likely(last_request->wiphy != wiphy))
@@ -1583,6 +1594,8 @@ int set_regdom(const struct ieee80211_regdomain *rd)
 {
 	int r;
 
+	assert_cfg80211_lock();
+
 	/* Note that this doesn't update the wiphys, this is done below */
 	r = __set_regdom(rd);
 	if (r) {
@@ -1605,6 +1618,8 @@ int set_regdom(const struct ieee80211_regdomain *rd)
 /* Caller must hold cfg80211_mutex */
 void reg_device_remove(struct wiphy *wiphy)
 {
+	assert_cfg80211_lock();
+
 	kfree(wiphy->regd);
 	if (!last_request || !last_request->wiphy)
 		return;
-- 
1.6.0.3

