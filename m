Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:33444 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964AbZBMFgy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Feb 2009 00:36:54 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 12 Feb 2009 21:36:54 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 4/6] cfg80211: add assert_cfg80211_lock() to ensure proper protection
Date: Thu, 12 Feb 2009 21:36:01 -0800
Message-ID: <1234503363-11014-5-git-send-email-lrodriguez@atheros.com> (sfid-20090213_063659_127324_E9340557)
In-Reply-To: <1234503363-11014-4-git-send-email-lrodriguez@atheros.com>
References: <1234503363-11014-1-git-send-email-lrodriguez@atheros.com>
 <1234503363-11014-2-git-send-email-lrodriguez@atheros.com>
 <1234503363-11014-3-git-send-email-lrodriguez@atheros.com>
 <1234503363-11014-4-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
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
index f55040a..6807538 100644
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
@@ -47,6 +46,8 @@ cfg80211_drv_by_wiphy_idx(int wiphy_idx)
 {
 	struct cfg80211_registered_device *result = NULL, *drv;
 
+	assert_cfg80211_lock();
+
 	list_for_each_entry(drv, &cfg80211_drv_list, list) {
 		if (drv->wiphy_idx == wiphy_idx) {
 			result = drv;
@@ -66,6 +67,8 @@ __cfg80211_drv_from_info(struct genl_info *info)
 	struct net_device *dev;
 	int err = -EINVAL;
 
+	assert_cfg80211_lock();
+
 	if (info->attrs[NL80211_ATTR_WIPHY]) {
 		bywiphyidx = cfg80211_drv_by_wiphy_idx(
 				nla_get_u32(info->attrs[NL80211_ATTR_WIPHY]));
diff --git a/net/wireless/core.h b/net/wireless/core.h
index ba0531e..2500dbc 100644
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
@@ -72,6 +73,11 @@ bool wiphy_idx_valid(int wiphy_idx)
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
index f5c2c05..843d26d 100644
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
@@ -138,6 +137,8 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 	int i;
 	u16 ifmodes = dev->wiphy.interface_modes;
 
+	assert_cfg80211_lock();
+
 	hdr = nl80211hdr_put(msg, pid, seq, flags, NL80211_CMD_NEW_WIPHY);
 	if (!hdr)
 		return -1;
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index ba82312..aab1c69 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -830,6 +830,8 @@ static void handle_channel(struct wiphy *wiphy, enum ieee80211_band band,
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_channel *chan;
 
+	assert_cfg80211_lock();
+
 	sband = wiphy->bands[band];
 	BUG_ON(chan_idx >= sband->n_channels);
 	chan = &sband->channels[chan_idx];
@@ -1042,6 +1044,10 @@ static int reg_copy_regd(const struct ieee80211_regdomain **dst_regd,
 static int ignore_request(struct wiphy *wiphy, enum reg_set_by set_by,
 			  const char *alpha2)
 {
+
+	if (set_by != REGDOM_SET_BY_CORE)
+		assert_cfg80211_lock();
+
 	/* All initial requests are respected */
 	if (!last_request)
 		return 0;
@@ -1126,6 +1132,9 @@ int __regulatory_hint(struct wiphy *wiphy, enum reg_set_by set_by,
 	bool intersect = false;
 	int r = 0;
 
+	if (set_by != REGDOM_SET_BY_CORE)
+		assert_cfg80211_lock();
+
 	r = ignore_request(wiphy, set_by, alpha2);
 
 	if (r == REG_INTERSECT) {
@@ -1201,6 +1210,8 @@ EXPORT_SYMBOL(regulatory_hint);
 static bool reg_same_country_ie_hint(struct wiphy *wiphy,
 			u32 country_ie_checksum)
 {
+	assert_cfg80211_lock();
+
 	if (!last_request->wiphy)
 		return false;
 	if (likely(last_request->wiphy != wiphy))
@@ -1567,6 +1578,8 @@ int set_regdom(const struct ieee80211_regdomain *rd)
 {
 	int r;
 
+	assert_cfg80211_lock();
+
 	/* Note that this doesn't update the wiphys, this is done below */
 	r = __set_regdom(rd);
 	if (r) {
@@ -1589,6 +1602,8 @@ int set_regdom(const struct ieee80211_regdomain *rd)
 /* Caller must hold cfg80211_mutex */
 void reg_device_remove(struct wiphy *wiphy)
 {
+	assert_cfg80211_lock();
+
 	kfree(wiphy->regd);
 	if (!last_request || !last_request->wiphy)
 		return;
-- 
1.6.1.2.253.ga34a

