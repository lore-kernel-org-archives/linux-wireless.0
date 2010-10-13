Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:38212 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708Ab0JMWsx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Oct 2010 18:48:53 -0400
Received: from wpaz37.hot.corp.google.com (wpaz37.hot.corp.google.com [172.24.198.101])
	by smtp-out.google.com with ESMTP id o9DMmrM4011878
	for <linux-wireless@vger.kernel.org>; Wed, 13 Oct 2010 15:48:53 -0700
Received: from glenhelen.mtv.corp.google.com (glenhelen.mtv.corp.google.com [172.22.72.223])
	by wpaz37.hot.corp.google.com with ESMTP id o9DMmppu019038
	for <linux-wireless@vger.kernel.org>; Wed, 13 Oct 2010 15:48:52 -0700
From: Paul Stewart <pstew@google.com>
Date: Wed, 13 Oct 2010 15:06:47 -0700
Subject: [PATCH 1/6] Add nl80211 calls for bitrate threshold
To: linux-wireless@vger.kernel.org
Message-Id: <20101013224851.658E120478@glenhelen.mtv.corp.google.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add calls for accepting nl80211 bitrate thresholds from user space,
and add a function call for sending out threshold notifications.

Signed-off-by: Paul Stewart <pstew@google.com>

---
 include/linux/nl80211.h |    4 ++
 net/wireless/nl80211.c  |  102 ++++++++++++++++++++++++++++++++++++++++++++++-
 net/wireless/nl80211.h  |    6 +++
 3 files changed, 110 insertions(+), 2 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 0edb256..7944f64 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1786,6 +1786,8 @@ enum nl80211_ps_state {
  *	the minimum amount the RSSI level must change after an event before a
  *	new event may be issued (to reduce effects of RSSI oscillation).
  * @NL80211_ATTR_CQM_RSSI_THRESHOLD_EVENT: RSSI threshold event
+ * @NL80211_ATTR_CQM_BITRATE_THOLD: Bitrate threshold event
+ * @NL80211_ATTR_CQM_BITRATE_THRESHOLD_EVENT: New transmit bitrate
  * @__NL80211_ATTR_CQM_AFTER_LAST: internal
  * @NL80211_ATTR_CQM_MAX: highest key attribute
  */
@@ -1794,6 +1796,8 @@ enum nl80211_attr_cqm {
 	NL80211_ATTR_CQM_RSSI_THOLD,
 	NL80211_ATTR_CQM_RSSI_HYST,
 	NL80211_ATTR_CQM_RSSI_THRESHOLD_EVENT,
+	NL80211_ATTR_CQM_BITRATE_THOLD,
+	NL80211_ATTR_CQM_BITRATE_THRESHOLD_EVENT,
 
 	/* keep last */
 	__NL80211_ATTR_CQM_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index c506241..d9533a1 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4325,6 +4325,8 @@ nl80211_attr_cqm_policy[NL80211_ATTR_CQM_MAX + 1] __read_mostly = {
 	[NL80211_ATTR_CQM_RSSI_THOLD] = { .type = NLA_U32 },
 	[NL80211_ATTR_CQM_RSSI_HYST] = { .type = NLA_U32 },
 	[NL80211_ATTR_CQM_RSSI_THRESHOLD_EVENT] = { .type = NLA_U32 },
+	[NL80211_ATTR_CQM_BITRATE_THOLD] = { .type = NLA_U32 },
+	[NL80211_ATTR_CQM_BITRATE_THRESHOLD_EVENT] = { .type = NLA_U32 },
 };
 
 static int nl80211_set_cqm_rssi(struct genl_info *info,
@@ -4350,6 +4352,42 @@ static int nl80211_set_cqm_rssi(struct genl_info *info,
 					      threshold, hysteresis);
 }
 
+static int nl80211_set_cqm_bitrate(struct genl_info *info,
+					   u32 trigger_rate)
+{
+	struct cfg80211_registered_device *rdev;
+	struct wireless_dev *wdev;
+	struct net_device *dev;
+	int err;
+
+	rtnl_lock();
+
+	err = get_rdev_dev_by_info_ifindex(info, &rdev, &dev);
+	if (err)
+		goto unlock_rdev;
+
+	wdev = dev->ieee80211_ptr;
+
+	if (!rdev->ops->set_cqm_bitrate_config) {
+		err = -EOPNOTSUPP;
+		goto unlock_rdev;
+	}
+
+	if (wdev->iftype != NL80211_IFTYPE_STATION) {
+		err = -EOPNOTSUPP;
+		goto unlock_rdev;
+	}
+
+	err = rdev->ops->set_cqm_bitrate_config(wdev->wiphy, dev, trigger_rate);
+
+unlock_rdev:
+	cfg80211_unlock_rdev(rdev);
+	dev_put(dev);
+	rtnl_unlock();
+
+	return err;
+}
+
 static int nl80211_set_cqm(struct sk_buff *skb, struct genl_info *info)
 {
 	struct nlattr *attrs[NL80211_ATTR_CQM_MAX + 1];
@@ -4367,6 +4405,8 @@ static int nl80211_set_cqm(struct sk_buff *skb, struct genl_info *info)
 	if (err)
 		goto out;
 
+	err = -EINVAL;
+
 	if (attrs[NL80211_ATTR_CQM_RSSI_THOLD] &&
 	    attrs[NL80211_ATTR_CQM_RSSI_HYST]) {
 		s32 threshold;
@@ -4374,8 +4414,16 @@ static int nl80211_set_cqm(struct sk_buff *skb, struct genl_info *info)
 		threshold = nla_get_u32(attrs[NL80211_ATTR_CQM_RSSI_THOLD]);
 		hysteresis = nla_get_u32(attrs[NL80211_ATTR_CQM_RSSI_HYST]);
 		err = nl80211_set_cqm_rssi(info, threshold, hysteresis);
-	} else
-		err = -EINVAL;
+		if (err)
+			goto out;
+	}
+
+	if (attrs[NL80211_ATTR_CQM_BITRATE_THOLD]) {
+		u32 thold = nla_get_u32(attrs[NL80211_ATTR_CQM_BITRATE_THOLD]);
+		err = nl80211_set_cqm_bitrate(info, thold);
+		if (err)
+			goto out;
+	}
 
 out:
 	return err;
@@ -5651,6 +5699,56 @@ nl80211_send_cqm_rssi_notify(struct cfg80211_registered_device *rdev,
 	nlmsg_free(msg);
 }
 
+void
+nl80211_send_cqm_bitrate_notify(struct cfg80211_registered_device *rdev,
+				struct net_device *netdev,
+				u32 bitrate,
+				gfp_t gfp)
+{
+	struct sk_buff *msg;
+	struct nlattr *pinfoattr;
+	void *hdr;
+
+	if (bitrate == 0)
+		return;
+
+
+	msg = nlmsg_new(NLMSG_GOODSIZE, gfp);
+	if (!msg)
+		return;
+
+	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_NOTIFY_CQM);
+	if (!hdr) {
+		nlmsg_free(msg);
+		return;
+	}
+
+
+	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx);
+	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, netdev->ifindex);
+
+	pinfoattr = nla_nest_start(msg, NL80211_ATTR_CQM);
+	if (!pinfoattr)
+		goto nla_put_failure;
+
+	NLA_PUT_U32(msg, NL80211_ATTR_CQM_BITRATE_THRESHOLD_EVENT, bitrate);
+
+	nla_nest_end(msg, pinfoattr);
+
+	if (genlmsg_end(msg, hdr) < 0) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	genlmsg_multicast_netns(wiphy_net(&rdev->wiphy), msg, 0,
+				nl80211_mlme_mcgrp.id, gfp);
+	return;
+
+ nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+	nlmsg_free(msg);
+}
+
 static int nl80211_netlink_notify(struct notifier_block * nb,
 				  unsigned long state,
 				  void *_notify)
diff --git a/net/wireless/nl80211.h b/net/wireless/nl80211.h
index 30d2f93..769fa90 100644
--- a/net/wireless/nl80211.h
+++ b/net/wireless/nl80211.h
@@ -88,4 +88,10 @@ nl80211_send_cqm_rssi_notify(struct cfg80211_registered_device *rdev,
 			     enum nl80211_cqm_rssi_threshold_event rssi_event,
 			     gfp_t gfp);
 
+void
+nl80211_send_cqm_bitrate_notify(struct cfg80211_registered_device *rdev,
+				struct net_device *netdev,
+				u32 bitrate,
+				gfp_t gfp);
+
 #endif /* __NET_WIRELESS_NL80211_H */
-- 
1.7.1

