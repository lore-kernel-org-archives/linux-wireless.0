Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:57972 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030464Ab2CORje (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 13:39:34 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [RFC 1/2] cfg80211:  Add framework to support ethtool stats.
Date: Thu, 15 Mar 2012 10:39:18 -0700
Message-Id: <1331833159-12694-1-git-send-email-greearb@candelatech.com> (sfid-20120315_183939_019754_FB9DFB9F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 9ed8021... d97c9da... M	include/net/cfg80211.h
:100644 100644 bfed851... bc75a32... M	net/mac80211/sta_info.h
:100644 100644 9bde4d1... 7eecdf4... M	net/wireless/ethtool.c
 include/net/cfg80211.h  |    7 +++++++
 net/mac80211/sta_info.h |    2 ++
 net/wireless/ethtool.c  |   29 +++++++++++++++++++++++++++++
 3 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 9ed8021..d97c9da 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1689,6 +1689,13 @@ struct cfg80211_ops {
 				  u16 noack_map);
 
 	struct ieee80211_channel *(*get_channel)(struct wiphy *wiphy);
+
+	int	(*get_et_sset_count)(struct wiphy *wiphy,
+				     struct net_device* dev, int sset);
+	void	(*get_et_stats)(struct wiphy *wiphy, struct net_device* dev,
+				struct ethtool_stats *stats, u64 *data);
+	void	(*get_et_strings)(struct wiphy *wiphy, struct net_device* dev,
+				  u32 sset, u8 *data);
 };
 
 /*
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index bfed851..bc75a32 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -379,6 +379,8 @@ struct sta_info {
 	struct ieee80211_sta sta;
 };
 
+#define NUM_STA_INFO_STATS 12
+
 static inline enum nl80211_plink_state sta_plink_state(struct sta_info *sta)
 {
 #ifdef CONFIG_MAC80211_MESH
diff --git a/net/wireless/ethtool.c b/net/wireless/ethtool.c
index 9bde4d1..7eecdf4 100644
--- a/net/wireless/ethtool.c
+++ b/net/wireless/ethtool.c
@@ -68,6 +68,32 @@ static int cfg80211_set_ringparam(struct net_device *dev,
 	return -ENOTSUPP;
 }
 
+static int cfg80211_get_sset_count(struct net_device *dev, int sset)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	if (rdev->ops->get_et_sset_count)
+		return rdev->ops->get_et_sset_count(wdev->wiphy, dev, sset);
+	return -EOPNOTSUPP;
+}
+
+static void cfg80211_get_stats(struct net_device *dev,
+			       struct ethtool_stats *stats, u64 *data)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	if (rdev->ops->get_et_stats)
+		rdev->ops->get_et_stats(wdev->wiphy, dev, stats, data);
+}
+
+static void cfg80211_get_strings(struct net_device *dev, u32 sset, u8 *data)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	if (rdev->ops->get_et_strings)
+		rdev->ops->get_et_strings(wdev->wiphy, dev, sset, data);
+}
+
 const struct ethtool_ops cfg80211_ethtool_ops = {
 	.get_drvinfo = cfg80211_get_drvinfo,
 	.get_regs_len = cfg80211_get_regs_len,
@@ -75,4 +101,7 @@ const struct ethtool_ops cfg80211_ethtool_ops = {
 	.get_link = ethtool_op_get_link,
 	.get_ringparam = cfg80211_get_ringparam,
 	.set_ringparam = cfg80211_set_ringparam,
+	.get_strings = cfg80211_get_strings,
+	.get_ethtool_stats = cfg80211_get_stats,
+	.get_sset_count = cfg80211_get_sset_count,
 };
-- 
1.7.3.4

