Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45710 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755459AbaELVAQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 May 2014 17:00:16 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Kalle Valo <kvalo@qca.qualcomm.com>,
	Bing Zhao <bzhao@marvell.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [RFC] wireless: add cfg80211 ethtool infrastructure for firmware dumps
Date: Mon, 12 May 2014 16:59:27 -0400
Message-Id: <1399928367-306-1-git-send-email-linville@tuxdriver.com> (sfid-20140512_230022_577558_3D9056B9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is all boilerplate based upon the existing ethtool support in cfg80211.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
Compile-tested only!

This basically just passes the ethtool call down to the hardware
driver.  What else would/should it do?

I think that I did the bare minimum on the tracing part.  What else
does it need?

 include/net/cfg80211.h  | 10 ++++++++++
 net/wireless/ethtool.c  | 33 +++++++++++++++++++++++++++++++++
 net/wireless/rdev-ops.h | 40 ++++++++++++++++++++++++++++++++++++++++
 net/wireless/trace.h    | 15 +++++++++++++++
 4 files changed, 98 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 7eae46ccec01..89381650a45e 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2506,6 +2506,16 @@ struct cfg80211_ops {
 				struct ethtool_stats *stats, u64 *data);
 	void	(*get_et_strings)(struct wiphy *wiphy, struct net_device *dev,
 				  u32 sset, u8 *data);
+	int	(*set_et_dump)(struct wiphy *wiphy,
+			       struct net_device *dev,
+			       struct ethtool_dump *dump);
+	int	(*get_et_dump_flag)(struct wiphy *wiphy,
+				    struct net_device *dev,
+				    struct ethtool_dump *dump);
+	int	(*get_et_dump_data)(struct wiphy *wiphy,
+				    struct net_device *dev,
+				    struct ethtool_dump *dump,
+				    void *buffer);
 
 	int	(*get_channel)(struct wiphy *wiphy,
 			       struct wireless_dev *wdev,
diff --git a/net/wireless/ethtool.c b/net/wireless/ethtool.c
index d4860bfc020e..5bc9221b2c2a 100644
--- a/net/wireless/ethtool.c
+++ b/net/wireless/ethtool.c
@@ -93,6 +93,36 @@ static void cfg80211_get_strings(struct net_device *dev, u32 sset, u8 *data)
 		rdev_get_et_strings(rdev, dev, sset, data);
 }
 
+static int cfg80211_set_dump(struct net_device *dev, struct ethtool_dump *dump)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
+	if (rdev->ops->set_et_dump)
+		return rdev_set_et_dump(rdev, dev, dump);
+	return -EOPNOTSUPP;
+}
+
+static int cfg80211_get_dump_flag(struct net_device *dev,
+				  struct ethtool_dump *dump)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
+	if (rdev->ops->get_et_dump_flag)
+		return rdev_get_et_dump_flag(rdev, dev, dump);
+	return -EOPNOTSUPP;
+}
+
+static int cfg80211_get_dump_data(struct net_device *dev,
+				  struct ethtool_dump *dump,
+				  void *buffer)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
+	if (rdev->ops->get_et_dump_data)
+		return rdev_get_et_dump_data(rdev, dev, dump, buffer);
+	return -EOPNOTSUPP;
+}
+
 const struct ethtool_ops cfg80211_ethtool_ops = {
 	.get_drvinfo = cfg80211_get_drvinfo,
 	.get_regs_len = cfg80211_get_regs_len,
@@ -103,4 +133,7 @@ const struct ethtool_ops cfg80211_ethtool_ops = {
 	.get_strings = cfg80211_get_strings,
 	.get_ethtool_stats = cfg80211_get_stats,
 	.get_sset_count = cfg80211_get_sset_count,
+	.set_dump = cfg80211_set_dump,
+	.get_dump_flag = cfg80211_get_dump_flag,
+	.get_dump_data = cfg80211_get_dump_data,
 };
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 00cdf73ba6c4..32ffa8af361c 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -963,4 +963,44 @@ rdev_set_ap_chanwidth(struct cfg80211_registered_device *rdev,
 	return ret;
 }
 
+static inline int
+rdev_set_et_dump(struct cfg80211_registered_device *rdev,
+		 struct net_device *dev, struct ethtool_dump *dump)
+{
+	int ret;
+
+	trace_rdev_set_et_dump(&rdev->wiphy, dev);
+	ret = rdev->ops->set_et_dump(&rdev->wiphy, dev, dump);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+
+	return ret;
+}
+
+static inline int
+rdev_get_et_dump_flag(struct cfg80211_registered_device *rdev,
+		      struct net_device *dev, struct ethtool_dump *dump)
+{
+	int ret;
+
+	trace_rdev_get_et_dump_flag(&rdev->wiphy, dev);
+	ret = rdev->ops->get_et_dump_flag(&rdev->wiphy, dev, dump);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+
+	return ret;
+}
+
+static inline int
+rdev_get_et_dump_data(struct cfg80211_registered_device *rdev,
+		      struct net_device *dev, struct ethtool_dump *dump,
+		      void *buffer)
+{
+	int ret;
+
+	trace_rdev_get_et_dump_data(&rdev->wiphy, dev);
+	ret = rdev->ops->get_et_dump_data(&rdev->wiphy, dev, dump, buffer);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+
+	return ret;
+}
+
 #endif /* __CFG80211_RDEV_OPS */
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index f3c13ff4d04c..e933f2fcabdb 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -585,6 +585,21 @@ DEFINE_EVENT(wiphy_netdev_evt, rdev_get_et_stats,
 	TP_ARGS(wiphy, netdev)
 );
 
+DEFINE_EVENT(wiphy_netdev_evt, rdev_set_et_dump,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev),
+	TP_ARGS(wiphy, netdev)
+);
+
+DEFINE_EVENT(wiphy_netdev_evt, rdev_get_et_dump_flag,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev),
+	TP_ARGS(wiphy, netdev)
+);
+
+DEFINE_EVENT(wiphy_netdev_evt, rdev_get_et_dump_data,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev),
+	TP_ARGS(wiphy, netdev)
+);
+
 DEFINE_EVENT(wiphy_netdev_evt, rdev_sched_scan_stop,
 	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev),
 	TP_ARGS(wiphy, netdev)
-- 
1.9.0

