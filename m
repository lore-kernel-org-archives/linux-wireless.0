Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:27446 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727AbZBNFec (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Feb 2009 00:34:32 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 13 Feb 2009 21:34:32 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 01/10] cfg80211: rename cfg80211_registered_device's idx to wiphy_idx
Date: Fri, 13 Feb 2009 21:33:38 -0800
Message-ID: <1234589627-16977-2-git-send-email-lrodriguez@atheros.com> (sfid-20090214_063439_261477_30BDDF5B)
In-Reply-To: <1234589627-16977-1-git-send-email-lrodriguez@atheros.com>
References: <1234589627-16977-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Makes it clearer to read when comparing to ifidx

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/core.c    |   35 ++++++++++++++++++-----------------
 net/wireless/core.h    |    2 +-
 net/wireless/nl80211.c |    4 ++--
 net/wireless/sysfs.c   |    2 +-
 4 files changed, 22 insertions(+), 21 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 0668b2b..2b3e786 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -37,12 +37,13 @@ DEFINE_MUTEX(cfg80211_drv_mutex);
 static struct dentry *ieee80211_debugfs_dir;
 
 /* requires cfg80211_drv_mutex to be held! */
-static struct cfg80211_registered_device *cfg80211_drv_by_wiphy(int wiphy)
+static struct cfg80211_registered_device *
+cfg80211_drv_by_wiphy_idx(int wiphy_idx)
 {
 	struct cfg80211_registered_device *result = NULL, *drv;
 
 	list_for_each_entry(drv, &cfg80211_drv_list, list) {
-		if (drv->idx == wiphy) {
+		if (drv->wiphy_idx == wiphy_idx) {
 			result = drv;
 			break;
 		}
@@ -56,12 +57,12 @@ static struct cfg80211_registered_device *
 __cfg80211_drv_from_info(struct genl_info *info)
 {
 	int ifindex;
-	struct cfg80211_registered_device *bywiphy = NULL, *byifidx = NULL;
+	struct cfg80211_registered_device *bywiphyidx = NULL, *byifidx = NULL;
 	struct net_device *dev;
 	int err = -EINVAL;
 
 	if (info->attrs[NL80211_ATTR_WIPHY]) {
-		bywiphy = cfg80211_drv_by_wiphy(
+		bywiphyidx = cfg80211_drv_by_wiphy_idx(
 				nla_get_u32(info->attrs[NL80211_ATTR_WIPHY]));
 		err = -ENODEV;
 	}
@@ -78,14 +79,14 @@ __cfg80211_drv_from_info(struct genl_info *info)
 		err = -ENODEV;
 	}
 
-	if (bywiphy && byifidx) {
-		if (bywiphy != byifidx)
+	if (bywiphyidx && byifidx) {
+		if (bywiphyidx != byifidx)
 			return ERR_PTR(-EINVAL);
 		else
-			return bywiphy; /* == byifidx */
+			return bywiphyidx; /* == byifidx */
 	}
-	if (bywiphy)
-		return bywiphy;
+	if (bywiphyidx)
+		return bywiphyidx;
 
 	if (byifidx)
 		return byifidx;
@@ -143,16 +144,16 @@ int cfg80211_dev_rename(struct cfg80211_registered_device *rdev,
 			char *newname)
 {
 	struct cfg80211_registered_device *drv;
-	int idx, taken = -1, result, digits;
+	int wiphy_idx, taken = -1, result, digits;
 
 	mutex_lock(&cfg80211_drv_mutex);
 
 	/* prohibit calling the thing phy%d when %d is not its number */
-	sscanf(newname, PHY_NAME "%d%n", &idx, &taken);
-	if (taken == strlen(newname) && idx != rdev->idx) {
-		/* count number of places needed to print idx */
+	sscanf(newname, PHY_NAME "%d%n", &wiphy_idx, &taken);
+	if (taken == strlen(newname) && wiphy_idx != rdev->wiphy_idx) {
+		/* count number of places needed to print wiphy_idx */
 		digits = 1;
-		while (idx /= 10)
+		while (wiphy_idx /= 10)
 			digits++;
 		/*
 		 * deny the name if it is phy<idx> where <idx> is printed
@@ -222,9 +223,9 @@ struct wiphy *wiphy_new(struct cfg80211_ops *ops, int sizeof_priv)
 
 	mutex_lock(&cfg80211_drv_mutex);
 
-	drv->idx = wiphy_counter++;
+	drv->wiphy_idx = wiphy_counter++;
 
-	if (unlikely(drv->idx < 0)) {
+	if (unlikely(drv->wiphy_idx < 0)) {
 		wiphy_counter--;
 		mutex_unlock(&cfg80211_drv_mutex);
 		/* ugh, wrapped! */
@@ -235,7 +236,7 @@ struct wiphy *wiphy_new(struct cfg80211_ops *ops, int sizeof_priv)
 	mutex_unlock(&cfg80211_drv_mutex);
 
 	/* give it a proper name */
-	dev_set_name(&drv->wiphy.dev, PHY_NAME "%d", drv->idx);
+	dev_set_name(&drv->wiphy.dev, PHY_NAME "%d", drv->wiphy_idx);
 
 	mutex_init(&drv->mtx);
 	mutex_init(&drv->devlist_mtx);
diff --git a/net/wireless/core.h b/net/wireless/core.h
index e29ad4c..36e2397 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -37,7 +37,7 @@ struct cfg80211_registered_device {
 	enum environment_cap env;
 
 	/* wiphy index, internal only */
-	int idx;
+	int wiphy_idx;
 
 	/* associate netdev list */
 	struct mutex devlist_mtx;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index fd46b18..80741c4 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -163,7 +163,7 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 	if (!hdr)
 		return -1;
 
-	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY, dev->idx);
+	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY, dev->wiphy_idx);
 	NLA_PUT_STRING(msg, NL80211_ATTR_WIPHY_NAME, wiphy_name(&dev->wiphy));
 	NLA_PUT_U8(msg, NL80211_ATTR_MAX_NUM_SCAN_SSIDS,
 		   dev->wiphy.max_scan_ssids);
@@ -2705,7 +2705,7 @@ static int nl80211_send_scan_donemsg(struct sk_buff *msg,
 	if (!hdr)
 		return -1;
 
-	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY, rdev->idx);
+	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx);
 	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, netdev->ifindex);
 
 	/* XXX: we should probably bounce back the request? */
diff --git a/net/wireless/sysfs.c b/net/wireless/sysfs.c
index 26a72b0..2e3fd91 100644
--- a/net/wireless/sysfs.c
+++ b/net/wireless/sysfs.c
@@ -31,7 +31,7 @@ static ssize_t name ## _show(struct device *dev,			\
 	return sprintf(buf, fmt "\n", dev_to_rdev(dev)->member);	\
 }
 
-SHOW_FMT(index, "%d", idx);
+SHOW_FMT(index, "%d", wiphy_idx);
 SHOW_FMT(macaddress, "%pM", wiphy.perm_addr);
 
 static struct device_attribute ieee80211_dev_attrs[] = {
-- 
1.6.1.2.253.ga34a

