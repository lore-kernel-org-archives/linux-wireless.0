Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38361 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112Ab1EIQlR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2011 12:41:17 -0400
Subject: [PATCH] cfg80211: restrict AP beacon intervals
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 May 2011 18:41:15 +0200
Message-ID: <1304959275.12202.4.camel@jlt3.sipsolutions.net> (sfid-20110509_184119_374792_5F7A96D0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Multiple virtual AP interfaces can currently try
to use different beacon intervals, but that just
leads to problems since it won't actually be done
that way by drivers. Return an error in this case
to make sure it won't be done wrong.

Also, ignore attempts to change the DTIM period
or beacon interval during the lifetime of the BSS.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h |    4 ++++
 net/wireless/core.c    |    1 +
 net/wireless/core.h    |    3 +++
 net/wireless/nl80211.c |   40 +++++++++++++++++++++++-----------------
 net/wireless/util.c    |   25 +++++++++++++++++++++++++
 5 files changed, 56 insertions(+), 17 deletions(-)

--- a/include/net/cfg80211.h	2011-05-06 17:40:17.000000000 +0200
+++ b/include/net/cfg80211.h	2011-05-06 17:40:17.000000000 +0200
@@ -1836,6 +1836,8 @@ struct cfg80211_cached_keys;
  * @mgmt_registrations_lock: lock for the list
  * @mtx: mutex used to lock data in this struct
  * @cleanup_work: work struct used for cleanup that can't be done directly
+ * @beacon_interval: beacon interval used on this device for transmitting
+ *	beacons, 0 when not valid
  */
 struct wireless_dev {
 	struct wiphy *wiphy;
@@ -1876,6 +1878,8 @@ struct wireless_dev {
 	bool ps;
 	int ps_timeout;
 
+	int beacon_interval;
+
 #ifdef CONFIG_CFG80211_WEXT
 	/* wext data */
 	struct {
--- a/net/wireless/core.h	2011-05-06 17:40:17.000000000 +0200
+++ b/net/wireless/core.h	2011-05-06 17:40:17.000000000 +0200
@@ -426,6 +426,9 @@ int cfg80211_set_freq(struct cfg80211_re
 
 u16 cfg80211_calculate_bitrate(struct rate_info *rate);
 
+int cfg80211_validate_beacon_int(struct cfg80211_registered_device *rdev,
+				 u32 beacon_int);
+
 #ifdef CONFIG_CFG80211_DEVELOPER_WARNINGS
 #define CFG80211_DEV_WARN_ON(cond)	WARN_ON(cond)
 #else
--- a/net/wireless/util.c	2011-05-06 17:40:17.000000000 +0200
+++ b/net/wireless/util.c	2011-05-06 17:44:40.000000000 +0200
@@ -896,3 +896,28 @@ u16 cfg80211_calculate_bitrate(struct ra
 	/* do NOT round down here */
 	return (bitrate + 50000) / 100000;
 }
+
+int cfg80211_validate_beacon_int(struct cfg80211_registered_device *rdev,
+				 u32 beacon_int)
+{
+	struct wireless_dev *wdev;
+	int res = 0;
+
+	if (!beacon_int)
+		return -EINVAL;
+
+	mutex_lock(&rdev->devlist_mtx);
+
+	list_for_each_entry(wdev, &rdev->netdev_list, list) {
+		if (!wdev->beacon_interval)
+			continue;
+		if (wdev->beacon_interval != beacon_int) {
+			res = -EINVAL;
+			break;
+		}
+	}
+
+	mutex_unlock(&rdev->devlist_mtx);
+
+	return res;
+}
--- a/net/wireless/nl80211.c	2011-05-06 17:40:17.000000000 +0200
+++ b/net/wireless/nl80211.c	2011-05-06 17:40:17.000000000 +0200
@@ -1871,8 +1871,9 @@ static int nl80211_addset_beacon(struct
 		    struct beacon_parameters *info);
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
 	struct net_device *dev = info->user_ptr[1];
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct beacon_parameters params;
-	int haveinfo = 0;
+	int haveinfo = 0, err;
 
 	if (!is_valid_ie_attr(info->attrs[NL80211_ATTR_BEACON_TAIL]))
 		return -EINVAL;
@@ -1881,6 +1882,8 @@ static int nl80211_addset_beacon(struct
 	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO)
 		return -EOPNOTSUPP;
 
+	memset(&params, 0, sizeof(params));
+
 	switch (info->genlhdr->cmd) {
 	case NL80211_CMD_NEW_BEACON:
 		/* these are required for NEW_BEACON */
@@ -1889,6 +1892,15 @@ static int nl80211_addset_beacon(struct
 		    !info->attrs[NL80211_ATTR_BEACON_HEAD])
 			return -EINVAL;
 
+		params.interval =
+			nla_get_u32(info->attrs[NL80211_ATTR_BEACON_INTERVAL]);
+		params.dtim_period =
+			nla_get_u32(info->attrs[NL80211_ATTR_DTIM_PERIOD]);
+
+		err = cfg80211_validate_beacon_int(rdev, params.interval);
+		if (err)
+			return err;
+
 		call = rdev->ops->add_beacon;
 		break;
 	case NL80211_CMD_SET_BEACON:
@@ -1902,20 +1914,6 @@ static int nl80211_addset_beacon(struct
 	if (!call)
 		return -EOPNOTSUPP;
 
-	memset(&params, 0, sizeof(params));
-
-	if (info->attrs[NL80211_ATTR_BEACON_INTERVAL]) {
-		params.interval =
-		    nla_get_u32(info->attrs[NL80211_ATTR_BEACON_INTERVAL]);
-		haveinfo = 1;
-	}
-
-	if (info->attrs[NL80211_ATTR_DTIM_PERIOD]) {
-		params.dtim_period =
-		    nla_get_u32(info->attrs[NL80211_ATTR_DTIM_PERIOD]);
-		haveinfo = 1;
-	}
-
 	if (info->attrs[NL80211_ATTR_BEACON_HEAD]) {
 		params.head = nla_data(info->attrs[NL80211_ATTR_BEACON_HEAD]);
 		params.head_len =
@@ -1933,13 +1931,18 @@ static int nl80211_addset_beacon(struct
 	if (!haveinfo)
 		return -EINVAL;
 
-	return call(&rdev->wiphy, dev, &params);
+	err = call(&rdev->wiphy, dev, &params);
+	if (!err && params.interval)
+		wdev->beacon_interval = params.interval;
+	return err;
 }
 
 static int nl80211_del_beacon(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
 	struct net_device *dev = info->user_ptr[1];
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	int err;
 
 	if (!rdev->ops->del_beacon)
 		return -EOPNOTSUPP;
@@ -1948,7 +1951,10 @@ static int nl80211_del_beacon(struct sk_
 	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO)
 		return -EOPNOTSUPP;
 
-	return rdev->ops->del_beacon(&rdev->wiphy, dev);
+	err = rdev->ops->del_beacon(&rdev->wiphy, dev);
+	if (!err)
+		wdev->beacon_interval = 0;
+	return err;
 }
 
 static const struct nla_policy sta_flags_policy[NL80211_STA_FLAG_MAX + 1] = {
--- a/net/wireless/core.c	2011-05-06 17:41:05.000000000 +0200
+++ b/net/wireless/core.c	2011-05-06 17:41:25.000000000 +0200
@@ -777,6 +777,7 @@ static int cfg80211_netdev_notifier_call
 		default:
 			break;
 		}
+		wdev->beacon_interval = 0;
 		break;
 	case NETDEV_DOWN:
 		dev_hold(dev);


