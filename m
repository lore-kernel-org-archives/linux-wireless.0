Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from contumacia.investici.org ([178.255.144.35]:25662 "EHLO
	contumacia.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435Ab2GHXvk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jul 2012 19:51:40 -0400
From: Antonio Quartulli <ordex@autistici.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Antonio Quartulli <ordex@autistici.org>
Subject: [PATCHv2] nl/cfg/mac80211: add set_mcast_rate API
Date: Mon,  9 Jul 2012 01:51:43 +0200
Message-Id: <1341791503-12542-1-git-send-email-ordex@autistici.org> (sfid-20120709_015220_629141_E7063F47)
In-Reply-To: <1341739885-15385-1-git-send-email-ordex@autistici.org>
References: <1341739885-15385-1-git-send-email-ordex@autistici.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

with the current API the multicast rate parameter is specifiable at ibss and
mesh join only. With this new API multicast rate can instead be modified
whenever needed by the user (only if the VIF type is ADHOC or MESH_POINT).

This API is particularly useful in case of use of wpa_supplicant with IBSS/RSN
since it does not support mcast_rate as ibss join parameter (this lead to the
impossibility of changing the mcast_rate while using IBSS/RSN).

Signed-off-by: Antonio Quartulli <ordex@autistici.org>
---
v2: removed useless locking, use BIT() instead of 1<<

 include/linux/nl80211.h |    2 +
 include/net/cfg80211.h  |    3 ++
 net/mac80211/cfg.c      |   27 ++++++++++++++
 net/wireless/nl80211.c  |   95 +++++++++++++++++++++++++++++++++--------------
 4 files changed, 99 insertions(+), 28 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index db961a5..f8c51af 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -708,6 +708,8 @@ enum nl80211_commands {
 
 	NL80211_CMD_CH_SWITCH_NOTIFY,
 
+	NL80211_CMD_SET_MCAST_RATE,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 51f67a9..e55448d 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1722,6 +1722,9 @@ struct cfg80211_ops {
 
 	int	(*set_wiphy_params)(struct wiphy *wiphy, u32 changed);
 
+	int	(*set_mcast_rate)(struct wiphy *wiphy, struct net_device *dev,
+				  int mcast_rate[IEEE80211_NUM_BANDS]);
+
 	int	(*set_tx_power)(struct wiphy *wiphy,
 				enum nl80211_tx_power_setting type, int mbm);
 	int	(*get_tx_power)(struct wiphy *wiphy, int *dbm);
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index ccbe241..b8f907d 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1919,6 +1919,32 @@ static int ieee80211_set_wiphy_params(struct wiphy *wiphy, u32 changed)
 	return 0;
 }
 
+static int ieee80211_set_mcast_rate(struct wiphy *wiphy, struct net_device *dev,
+				    int mcast_rate[IEEE80211_NUM_BANDS])
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	u32 basic_rates = sdata->vif.bss_conf.basic_rates;
+	int i;
+
+	/* check if the mcast_rates are also in basic_rates */
+	for (i = 0; i < IEEE80211_NUM_BANDS; i++)
+		if (!(basic_rates & BIT(mcast_rate[i] - 1)))
+			return -EINVAL;
+
+	switch (sdata->vif.type) {
+	case NL80211_IFTYPE_ADHOC:
+	case NL80211_IFTYPE_MESH_POINT:
+		memcpy(sdata->vif.bss_conf.mcast_rate, mcast_rate,
+		       sizeof(mcast_rate));
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+
+}
+
 static int ieee80211_set_tx_power(struct wiphy *wiphy,
 				  enum nl80211_tx_power_setting type, int mbm)
 {
@@ -3041,6 +3067,7 @@ struct cfg80211_ops mac80211_config_ops = {
 	.join_ibss = ieee80211_join_ibss,
 	.leave_ibss = ieee80211_leave_ibss,
 	.set_wiphy_params = ieee80211_set_wiphy_params,
+	.set_mcast_rate = ieee80211_set_mcast_rate,
 	.set_tx_power = ieee80211_set_tx_power,
 	.get_tx_power = ieee80211_get_tx_power,
 	.set_wds_peer = ieee80211_set_wds_peer,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 2a5cdb6..b0630b2 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1039,6 +1039,7 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 		if (nla_put_u32(msg, i, NL80211_CMD_REGISTER_BEACONS))
 			goto nla_put_failure;
 	}
+	CMD(set_mcast_rate, SET_MCAST_RATE);
 
 #ifdef CONFIG_NL80211_TESTMODE
 	CMD(testmode_cmd, TESTMODE);
@@ -1668,6 +1669,64 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 	return result;
 }
 
+static bool
+nl80211_parse_mcast_rate(struct cfg80211_registered_device *rdev,
+			 int mcast_rate[IEEE80211_NUM_BANDS],
+			 int rateval)
+{
+	struct wiphy *wiphy = &rdev->wiphy;
+	bool found = false;
+	int band, i;
+
+	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
+		struct ieee80211_supported_band *sband;
+
+		sband = wiphy->bands[band];
+		if (!sband)
+			continue;
+
+		for (i = 0; i < sband->n_bitrates; i++) {
+			if (sband->bitrates[i].bitrate == rateval) {
+				mcast_rate[band] = i + 1;
+				found = true;
+				break;
+			}
+		}
+	}
+
+	return found;
+}
+
+static int nl80211_set_mcast_rate(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	u32 mcast_attr;
+	int mcast_rate[IEEE80211_NUM_BANDS];
+	int err;
+
+	if (!info->attrs[NL80211_ATTR_MCAST_RATE])
+		return -EINVAL;
+
+	mcast_attr = nla_get_u32(info->attrs[NL80211_ATTR_MCAST_RATE]);
+	if (!nl80211_parse_mcast_rate(rdev, mcast_rate, mcast_attr))
+		return -EINVAL;
+
+	if (wdev->iftype != NL80211_IFTYPE_ADHOC &&
+	    wdev->iftype != NL80211_IFTYPE_MESH_POINT)
+		return -EOPNOTSUPP;
+
+	if (!rdev->ops->set_mcast_rate)
+		return -EOPNOTSUPP;
+
+	if (!wdev->current_bss)
+		return -EINVAL;
+
+	err = rdev->ops->set_mcast_rate(&rdev->wiphy, dev, mcast_rate);
+
+	return err;
+}
 
 static int nl80211_send_iface(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 			      struct cfg80211_registered_device *rdev,
@@ -5066,34 +5125,6 @@ static int nl80211_disassociate(struct sk_buff *skb, struct genl_info *info)
 				      local_state_change);
 }
 
-static bool
-nl80211_parse_mcast_rate(struct cfg80211_registered_device *rdev,
-			 int mcast_rate[IEEE80211_NUM_BANDS],
-			 int rateval)
-{
-	struct wiphy *wiphy = &rdev->wiphy;
-	bool found = false;
-	int band, i;
-
-	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
-		struct ieee80211_supported_band *sband;
-
-		sband = wiphy->bands[band];
-		if (!sband)
-			continue;
-
-		for (i = 0; i < sband->n_bitrates; i++) {
-			if (sband->bitrates[i].bitrate == rateval) {
-				mcast_rate[band] = i + 1;
-				found = true;
-				break;
-			}
-		}
-	}
-
-	return found;
-}
-
 static int nl80211_join_ibss(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
@@ -6726,6 +6757,14 @@ static struct genl_ops nl80211_ops[] = {
 		.internal_flags = NL80211_FLAG_NEED_RTNL,
 	},
 	{
+		.cmd = NL80211_CMD_SET_MCAST_RATE,
+		.doit = nl80211_set_mcast_rate,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
+				  NL80211_FLAG_NEED_RTNL,
+	},
+	{
 		.cmd = NL80211_CMD_GET_INTERFACE,
 		.doit = nl80211_get_interface,
 		.dumpit = nl80211_dump_interface,
-- 
1.7.9.4

