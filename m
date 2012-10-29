Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from contumacia.investici.org ([178.255.144.35]:40433 "EHLO
	contumacia.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756279Ab2J2Jun (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Oct 2012 05:50:43 -0400
From: Antonio Quartulli <ordex@autistici.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Antonio Quartulli <ordex@autistici.org>
Subject: [PATCHv4 1/2] nl/cfg80211: add the NL80211_CMD_SET_MCAST_RATE command
Date: Mon, 29 Oct 2012 10:50:02 +0100
Message-Id: <1351504203-15369-1-git-send-email-ordex@autistici.org> (sfid-20121029_105049_122808_3A46C145)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This command triggers a new callback: set_mcast_rate(). It enables
the user to change the rate used to send multicast frames for vif
configured as IBSS or MESH_POINT

Signed-off-by: Antonio Quartulli <ordex@autistici.org>
---

v2:
 - added check for !set_mcast_rate in nl80211_set_mcast_rate()
 - moved all the changes for cfg80211 in 1/2. 2/2 now contains mac80211
   changes only

v3:
 - rebased on last mac80211-next
 - fixed destination param in memcpy in ieee80211_mcast_rate()

v4:
 - check for iftype moved in nl80211.c
 - advertise command in nl80211_send_wiphy()
 - removed ieee80211_mcast_rate() (content has been moved into
   ieee80211_set_mcast_rate())



 include/net/cfg80211.h       |  6 ++++++
 include/uapi/linux/nl80211.h |  5 +++++
 net/wireless/nl80211.c       | 42 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 53 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index aa0e4a1..63c9ba2 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1544,6 +1544,9 @@ struct cfg80211_gtk_rekey_data {
  *	to a merge.
  * @leave_ibss: Leave the IBSS.
  *
+ * @set_mcast_rate: Set the specified multicast rate (only if vif is in ADHOC or
+ *	MESH mode)
+ *
  * @set_wiphy_params: Notify that wiphy parameters have changed;
  *	@changed bitfield (see &enum wiphy_params_flags) describes which values
  *	have changed. The actual parameter values are available in
@@ -1745,6 +1748,9 @@ struct cfg80211_ops {
 			     struct cfg80211_ibss_params *params);
 	int	(*leave_ibss)(struct wiphy *wiphy, struct net_device *dev);
 
+	int	(*set_mcast_rate)(struct wiphy *wiphy, struct net_device *dev,
+				  int rate[IEEE80211_NUM_BANDS]);
+
 	int	(*set_wiphy_params)(struct wiphy *wiphy, u32 changed);
 
 	int	(*set_tx_power)(struct wiphy *wiphy,
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 617d0fb..654ff1e 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -578,6 +578,9 @@
  *	station, due to particular reason. %NL80211_ATTR_CONN_FAILED_REASON
  *	is used for this.
  *
+ * @NL80211_CMD_SET_MCAST_RATE: Change the rate used to send multicast frames
+ *	for IBSS or MESH vif.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -726,6 +729,8 @@ enum nl80211_commands {
 
 	NL80211_CMD_CONN_FAILED,
 
+	NL80211_CMD_SET_MCAST_RATE,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 8c08578..38522c4 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5444,6 +5444,40 @@ static int nl80211_leave_ibss(struct sk_buff *skb, struct genl_info *info)
 	return cfg80211_leave_ibss(rdev, dev, false);
 }
 
+static int nl80211_set_mcast_rate(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	int mcast_rate[IEEE80211_NUM_BANDS];
+	u32 nla_rate;
+	int err;
+
+	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_ADHOC &&
+	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_MESH_POINT)
+		return -EOPNOTSUPP;
+
+	if (!rdev->ops->set_mcast_rate)
+		return -EOPNOTSUPP;
+
+	memset(mcast_rate, 0, sizeof(mcast_rate));
+
+	if (!info->attrs[NL80211_ATTR_MCAST_RATE])
+		return -EINVAL;
+
+	nla_rate = nla_get_u32(info->attrs[NL80211_ATTR_MCAST_RATE]);
+	if (!nl80211_parse_mcast_rate(rdev, mcast_rate, nla_rate))
+		return -EINVAL;
+
+	wdev_lock(dev->ieee80211_ptr);
+
+	err = rdev->ops->set_mcast_rate(&rdev->wiphy, dev, mcast_rate);
+
+	wdev_unlock(dev->ieee80211_ptr);
+
+	return err;
+}
+
+
 #ifdef CONFIG_NL80211_TESTMODE
 static struct genl_multicast_group nl80211_testmode_mcgrp = {
 	.name = "testmode",
@@ -7625,6 +7659,14 @@ static struct genl_ops nl80211_ops[] = {
 		.internal_flags = NL80211_FLAG_NEED_WDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
+	{
+		.cmd = NL80211_CMD_SET_MCAST_RATE,
+		.doit = nl80211_set_mcast_rate,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_NETDEV |
+				  NL80211_FLAG_NEED_RTNL,
+	},
 };
 
 static struct genl_multicast_group nl80211_mlme_mcgrp = {
-- 
1.7.12.4

