Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:60399 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765Ab0FOJRq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jun 2010 05:17:46 -0400
Received: from vaebh105.NOE.Nokia.com (vaebh105.europe.nokia.com [10.160.244.31])
	by mgw-mx06.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o5F9Han4026403
	for <linux-wireless@vger.kernel.org>; Tue, 15 Jun 2010 12:17:43 +0300
Received: from localhost.localdomain (wimaxnb.nmp.nokia.com [172.22.211.32])
	by mgw-da02.ext.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o5F9HXvW019350
	for <linux-wireless@vger.kernel.org>; Tue, 15 Jun 2010 12:17:34 +0300
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linux-wireless@vger.kernel.org
Subject: [RFC PATCH] nl80211/cfg80211/mac80211: Add support for setting transmit power
Date: Tue, 15 Jun 2010 12:17:33 +0300
Message-Id: <1276593453-27818-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds an interface to adjust the transmit power level. Using this
interface the transmit power mode (automatic, limited or fixed) can be set
along with the power level to be enforced.

The power level is specified with a signed mBm unit value, which allows for
greater accuracy and smaller power levels.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 include/linux/nl80211.h    |   24 ++++++++++++++++
 include/net/cfg80211.h     |   15 +---------
 net/mac80211/cfg.c         |    8 ++--
 net/wireless/nl80211.c     |   66 ++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/wext-compat.c |    8 ++--
 5 files changed, 99 insertions(+), 22 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 64fb32b..047d28c 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -340,6 +340,8 @@
  *	no other interfaces are operating to avoid disturbing the operation
  *	of any other interfaces, and other interfaces will again take
  *	precedence when they are used.
+ * @NL80211_CMD_SET_TX_POWER: Set the used transmit power level (using
+ *	%NL80211_ATTR_TX_POWER_SETTING and %NL80211_ATTR_TX_POWER_LEVEL).
  *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
@@ -441,6 +443,8 @@ enum nl80211_commands {
 
 	NL80211_CMD_SET_CHANNEL,
 
+	NL80211_CMD_SET_TX_POWER,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -725,6 +729,11 @@ enum nl80211_commands {
  * @NL80211_ATTR_AP_ISOLATE: (AP mode) Do not forward traffic between stations
  *	connected to this BSS.
  *
+ * @NL80211_ATTR_TX_POWER_SETTING: Setting of the transmit power, see
+ *	&enum nl80211_tx_power_setting for the possible values. This is
+ *	currently used with @NL80211_CMD_SET_TX_POWER.
+ * @NL80211_ATTR_TX_POWER_LEVEL: Trasnmit power level in signed mBm format. This
+ *	is currently used with @NL80211_CMD_SET_TX_POWER.
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -882,6 +891,9 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_AP_ISOLATE,
 
+	NL80211_ATTR_TX_POWER_SETTING,
+	NL80211_ATTR_TX_POWER_LEVEL,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -1624,6 +1636,18 @@ enum nl80211_ps_state {
 };
 
 /**
+ * enum nl80211_tx_power_setting - TX power adjustment
+ * @TX_POWER_AUTOMATIC: automatic TX power handling
+ * @TX_POWER_LIMITED: limit TX power to the specified level
+ * @TX_POWER_FIXED: fix TX power to the specified level
+ */
+enum nl80211_tx_power_setting {
+	NL80211_TX_POWER_AUTOMATIC,
+	NL80211_TX_POWER_LIMITED,
+	NL80211_TX_POWER_FIXED,
+};
+
+/**
  * enum nl80211_attr_cqm - connection quality monitor attributes
  * @__NL80211_ATTR_CQM_INVALID: invalid
  * @NL80211_ATTR_CQM_RSSI_THOLD: RSSI threshold in dBm. This value specifies
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 22ab9d8..4db30f8 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -873,19 +873,6 @@ enum wiphy_params_flags {
 	WIPHY_PARAM_COVERAGE_CLASS	= 1 << 4,
 };
 
-/**
- * enum tx_power_setting - TX power adjustment
- *
- * @TX_POWER_AUTOMATIC: the dbm parameter is ignored
- * @TX_POWER_LIMITED: limit TX power by the dbm parameter
- * @TX_POWER_FIXED: fix TX power to the dbm parameter
- */
-enum tx_power_setting {
-	TX_POWER_AUTOMATIC,
-	TX_POWER_LIMITED,
-	TX_POWER_FIXED,
-};
-
 /*
  * cfg80211_bitrate_mask - masks for bitrate control
  */
@@ -1147,7 +1134,7 @@ struct cfg80211_ops {
 	int	(*set_wiphy_params)(struct wiphy *wiphy, u32 changed);
 
 	int	(*set_tx_power)(struct wiphy *wiphy,
-				enum tx_power_setting type, int dbm);
+				enum nl80211_tx_power_setting type, int dbm);
 	int	(*get_tx_power)(struct wiphy *wiphy, int *dbm);
 
 	int	(*set_wds_peer)(struct wiphy *wiphy, struct net_device *dev,
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 952845e..c1c149e 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1329,22 +1329,22 @@ static int ieee80211_set_wiphy_params(struct wiphy *wiphy, u32 changed)
 }
 
 static int ieee80211_set_tx_power(struct wiphy *wiphy,
-				  enum tx_power_setting type, int dbm)
+				  enum nl80211_tx_power_setting type, int dbm)
 {
 	struct ieee80211_local *local = wiphy_priv(wiphy);
 	struct ieee80211_channel *chan = local->hw.conf.channel;
 	u32 changes = 0;
 
 	switch (type) {
-	case TX_POWER_AUTOMATIC:
+	case NL80211_TX_POWER_AUTOMATIC:
 		local->user_power_level = -1;
 		break;
-	case TX_POWER_LIMITED:
+	case NL80211_TX_POWER_LIMITED:
 		if (dbm < 0)
 			return -EINVAL;
 		local->user_power_level = dbm;
 		break;
-	case TX_POWER_FIXED:
+	case NL80211_TX_POWER_FIXED:
 		if (dbm < 0)
 			return -EINVAL;
 		/* TODO: move to cfg80211 when it knows the channel */
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 90ab3c8..32b3352 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -153,6 +153,8 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_CQM] = { .type = NLA_NESTED, },
 	[NL80211_ATTR_LOCAL_STATE_CHANGE] = { .type = NLA_FLAG },
 	[NL80211_ATTR_AP_ISOLATE] = { .type = NLA_U8 },
+	[NL80211_ATTR_TX_POWER_SETTING] = { .type = NLA_U32 },
+	[NL80211_ATTR_TX_POWER_LEVEL] = { .type = NLA_U32 },
 };
 
 /* policy for the attributes */
@@ -4968,6 +4970,64 @@ out:
 	return err;
 }
 
+static int nl80211_set_tx_power(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev;
+	struct wireless_dev *wdev;
+	struct net_device *dev;
+	enum nl80211_tx_power_setting type;
+	int mbm = 0;
+	int err;
+
+	if (!info->attrs[NL80211_ATTR_TX_POWER_SETTING]) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	type = nla_get_u32(info->attrs[NL80211_ATTR_TX_POWER_SETTING]);
+
+	if (!info->attrs[NL80211_ATTR_TX_POWER_LEVEL] &&
+	    (type != NL80211_TX_POWER_AUTOMATIC)) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	if (type != NL80211_TX_POWER_AUTOMATIC)
+		mbm = nla_get_u32(info->attrs[NL80211_ATTR_TX_POWER_LEVEL]);
+
+	/*
+	 * Though the nl80211 supports negative mBm values, the interface
+	 * below it does not, for now.
+	 */
+	if (mbm < 0) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	rtnl_lock();
+
+	err = get_rdev_dev_by_info_ifindex(info, &rdev, &dev);
+	if (err)
+		goto unlock_rdev;
+
+	wdev = dev->ieee80211_ptr;
+
+	if (!rdev->ops->set_tx_power) {
+		return -EOPNOTSUPP;
+		goto unlock_rdev;
+	}
+
+	err = rdev->ops->set_tx_power(wdev->wiphy, type, MBM_TO_DBM(mbm));
+
+unlock_rdev:
+	cfg80211_unlock_rdev(rdev);
+	dev_put(dev);
+	rtnl_unlock();
+
+out:
+	return err;
+}
+
 static struct genl_ops nl80211_ops[] = {
 	{
 		.cmd = NL80211_CMD_GET_WIPHY,
@@ -5284,6 +5344,12 @@ static struct genl_ops nl80211_ops[] = {
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
 	},
+	{
+		.cmd = NL80211_CMD_SET_TX_POWER,
+		.doit = nl80211_set_tx_power,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+	},
 };
 
 static struct genl_multicast_group nl80211_mlme_mcgrp = {
diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index 9634299..3dfe8ed 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -829,7 +829,7 @@ int cfg80211_wext_siwtxpower(struct net_device *dev,
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
-	enum tx_power_setting type;
+	enum nl80211_tx_power_setting type;
 	int dbm = 0;
 
 	if ((data->txpower.flags & IW_TXPOW_TYPE) != IW_TXPOW_DBM)
@@ -852,7 +852,7 @@ int cfg80211_wext_siwtxpower(struct net_device *dev,
 			if (data->txpower.value < 0)
 				return -EINVAL;
 			dbm = data->txpower.value;
-			type = TX_POWER_FIXED;
+			type = NL80211_TX_POWER_FIXED;
 			/* TODO: do regulatory check! */
 		} else {
 			/*
@@ -860,10 +860,10 @@ int cfg80211_wext_siwtxpower(struct net_device *dev,
 			 * passed in from userland.
 			 */
 			if (data->txpower.value < 0) {
-				type = TX_POWER_AUTOMATIC;
+				type = NL80211_TX_POWER_AUTOMATIC;
 			} else {
 				dbm = data->txpower.value;
-				type = TX_POWER_LIMITED;
+				type = NL80211_TX_POWER_LIMITED;
 			}
 		}
 	} else {
-- 
1.6.3.3

